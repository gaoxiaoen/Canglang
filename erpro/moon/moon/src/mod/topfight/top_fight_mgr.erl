%% -------------------------------------------------------------------
%% Description : 
%% Author  : abu
%% -------------------------------------------------------------------
-module(top_fight_mgr).

-behaviour(gen_server).

%% export functions
-export([start_link/0
        ,change_status/1
        ,update_status/2
        ,atime/1
        ,debug/0
        ,update_hero_rank/1
        ,update_top_hero/1
        ,get_hero_rank/1
        ,get_top_hero/0
        ,get_hero/0
        ,handle_top_hero/1
        ,handle_seq_winners/1
        ,adm_sync/0
    ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
        terminate/2, code_change/3]).

%% record
-record(state, {ts, status, rank, top_hero}).

%% include
-include("common.hrl").
-include("role.hrl").
-include("looks.hrl").
-include("vip.hrl").
-include("top_fight.hrl").
%%

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 获取活动时间
atime(Type) ->
    ?CALL(?MODULE, {atime, Type}).

%% @spec send_notice_msg() 
%% 发送预备消息
change_status(Type) ->
    case is_open() of
        true ->
            do_change_status(Type);
        _ ->
            ?INFO("开服前15天，不开启巅峰对决"),
            ok
    end.

do_change_status(notice) ->
    case ?CALL(?MODULE, {change_status, notice}) of
        {ok} ->
            notice:send(54, util:fbin(?L(<<"仙法竞技，决胜巅峰，谁是飞仙第一霸主，还看巅峰之决战，决战开启在即，请各飞仙高人做好准备！">>), [])),
            %%erlang:send_after(60 * 1000, self(), {send_msg_notic}),
            role_group:pack_cast(world, 17300, {1, round(?top_fight_timeout_notice / 1000)}),
            ok;
        _ ->
            ok
    end;
do_change_status(prepare) ->
    case ?CALL(?MODULE, {change_status, prepare}) of
        {ok} ->
            notice:send(54, util:fbin(?L(<<"巅峰对决正式开启报名，请符合条件的各界高手及时报名！">>), [])),
            %%erlang:send_after(60 * 1000, self(), {send_msg_prepare}),
            role_group:pack_cast(world, 17300, {2, round(?top_fight_timeout_prepare_cross / 1000)}),
            ok;
        _ ->
            ok
    end;
do_change_status(match_pre) ->
    case ?CALL(?MODULE, {change_status, match_pre}) of
        {ok} ->
            notice:send(54, util:fbin(?L(<<"巅峰对决比赛正式开始!">>), [])),
            role_group:pack_cast(world, 17300, {3, 0}),
            ok;
        _ ->
            ok
    end;

do_change_status(Type) when Type =:= matching orelse Type =:= expire orelse Type =:= idel ->
    case ?CALL(?MODULE, {change_status, Type}) of
        {ok} ->
            case Type =:= idel of
                true ->
                    role_group:pack_cast(world, 17300, {0, 0});
                _ ->
                    ok
            end;
        _ ->
            ok
    end;

do_change_status(_Type) ->
    ?ERR("错误的状态", [_Type]),
    ok.

%% 更新状态
update_status(Ts, Status) ->
    case is_open() of
        true ->
            ?MODULE ! {update_status, Ts, Status};
        _ ->
            ok
    end.

%% 更新排行榜
update_hero_rank(Rank) ->
    ?MODULE ! {update_hero_rank, Rank}.

%% 更新霸主
update_top_hero(TopHero) ->
    ?MODULE ! {update_top_hero, TopHero}.

%% 获取排行榜
get_hero_rank(ArenaSeq) ->
    case ?CALL(?MODULE, {get_hero_rank, ?top_fight_lev_low, ArenaSeq}) of
        {ok, Num, ArenaHeroZone} -> {ok, Num, ArenaHeroZone};
        _ -> 
            {false, ?L(<<"获取巅峰对决英雄榜信息有误">>)}
    end.

%%
get_top_hero() ->
    case ?CALL(?MODULE, {get_top_hero}) of
        {ok, Thero} ->
            {ok, Thero};
        _ ->
            {false, <<>>}
    end.

%% 获取霸主列表
get_hero() ->
    case ?CALL(?MODULE, {get_hero}) of
        {ok, HeroList} ->
            {ok, HeroList};
        _ ->
            {false, <<>>}
    end.

%% 更新霸主
handle_top_hero(#top_fight_hero{role_id = RoleId, srv_id = SrvId, group_id = GroupId, fight_capacity = Fc, pet_fight_capacity = PetFc}) ->
    case fetch_role({RoleId, SrvId}) of
        {ok, #role{name = Name, career = Career, lev = Lev, sex = Sex, looks = Looks, eqm = Eqms, vip = #vip{type = VipLev}}} ->
            TopHero = #top_fight_top_hero{role_id = RoleId, srv_id = SrvId, group_id = GroupId, fight_capacity = Fc, pet_fight_capacity = PetFc, name = Name, career = Career, lev = Lev, vip = VipLev, sex = Sex, looks = [{?LOOKS_TYPE_CAMP_DRESS, 19999, 0} | Looks], eqms = Eqms},
            center:cast(top_fight_center_mgr, update_top_hero_result, [TopHero]);
        _ ->
            ?ERR("没有找到角色: ~w", [{RoleId, SrvId}]),
            ok
    end.

%% 处理战区第一名
handle_seq_winners(Winners) ->
    ?DEBUG("巅峰对决：~w", [Winners]),
    lists:foreach(fun do_handle_lord_notice/1, Winners),
    case do_handle_seq_winners(Winners) of
        {ok, LordWinners, OtherWinners} ->
            do_handle_lord_winners(LordWinners),
            do_handle_other_winners(OtherWinners),
            lists:foreach(fun do_handle_other_winners_notice/1, OtherWinners),
            ok;
        _ ->
            ok
    end.

do_handle_seq_winners(Winners) ->
    do_handle_seq_winners(Winners, [], []).

do_handle_seq_winners([], Back1, Back2) ->
    {ok, Back1, Back2};
do_handle_seq_winners([H = #top_fight_hero{srv_id = SrvId, arena_seq = Seq} | T], Back1, Back2) ->
    case role_api:is_local_role(SrvId) of
        true ->
            case Seq of
                1 ->
                    do_handle_seq_winners(T, [H | Back1], Back2);
                _ ->
                    do_handle_seq_winners(T, Back1, [H | Back2])
            end;
        false ->
            do_handle_seq_winners(T, Back1, Back2)
    end.

do_handle_lord_winners(W) ->
    honor_mgr:replace_honor_gainer(top_fight_lord_winner, [{{RoleId, SrvId}, 60006} || #top_fight_hero{role_id = RoleId, srv_id = SrvId} <- W], 7 * 86400 + util:unixtime()).

do_handle_other_winners(W) ->
    honor_mgr:replace_honor_gainer(top_fight_other_winner, [{{RoleId, SrvId}, 60007} || #top_fight_hero{role_id = RoleId, srv_id = SrvId} <- W], 7 * 86400 + util:unixtime()).

do_handle_other_winners_notice(#top_fight_hero{role_id = RoleId, srv_id = SrvId, name = Name, arena_seq = ArenaSeq, kill = Kill, score = Score}) ->
    RoleName = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>, [RoleId, SrvId, Name]),
    notice:send(53, util:fbin(?L(<<"~s仙法超群，在巅峰对决中第~w战区中击败了~w个对手，获得了~w积分，真是神勇无敌，特此被授予了巅峰王者">>), [RoleName, ArenaSeq, Kill, Score])).

do_handle_lord_notice(#top_fight_hero{role_id = RoleId, srv_id = SrvId, name = Name, arena_seq = ArenaSeq, kill = Kill, score = Score}) when ArenaSeq =:= 1 ->
    RoleName = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>, [RoleId, SrvId, Name]),
    notice:send(53, util:fbin(?L(<<"传闻~s在巅峰对决中第~w战区中横扫对手，睥睨群仙，总共击败了~w个对手，获得了~w积分，简直是神一般的存在，特此被授予~s和巅峰霸主之称号！">>), [RoleName, ArenaSeq, Kill, Score, notice:item_to_msg({19999, 1, 1})]));
do_handle_lord_notice(_) ->
    ok.

%% 与中央服同步信息
adm_sync() ->
    ?MODULE ! {adm_sync}.

%% 打印调试信息
debug() ->
    ?MODULE ! {debug}.

%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------

%% @spec init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    ?INFO("[~w] 启动完成...", [?MODULE]),
    erlang:send_after(60 * 1000, self(), {sync_hero_rank}),
    erlang:send_after(60 * 1000, self(), {sync_top_hero}),
    {ok, #state{ts = util:unixtime(), status = idel}}.

%% @spec: handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages

handle_call({get_hero}, _From, State = #state{rank = Rank}) ->
    Reply = case do_get_hero(Rank) of
        {ok, HeroList} ->
            {ok, HeroList};
        {false, Reason} ->
            {false, Reason}
    end,
    {reply, Reply, State};

handle_call({get_hero_rank, ArenaLev, ArenaSeq}, _From, State = #state{rank = HeroRank}) ->
    Reply = case do_get_hero_rank(HeroRank, ArenaLev, ArenaSeq) of
        {ok, Num, ArenaHeroZone} -> {ok, Num, ArenaHeroZone};
        {false, Reason} -> {false, Reason}
    end,
    {reply, Reply, State};

handle_call({get_top_hero}, _From, State = #state{top_hero = Thero}) ->
    {reply, {ok, Thero}, State};

handle_call({change_status, Status}, _From, State) ->
    ?INFO("[巅峰对决]状态: ~w", [Status]),
    {reply, {ok}, State#state{ts = erlang:now(), status = Status}};

handle_call({atime, Type}, _From, State = #state{status = Status, ts = Ts}) ->
    Reply = handle_atime(Type, Status, Ts),
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.


%% @spec: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
handle_cast(_Msg, State) ->
    {noreply, State}.

%% @spec: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages

handle_info({update_hero_rank, Rank}, State) ->
    {noreply, State#state{rank = Rank}};

handle_info({update_top_hero, TopHero}, State) ->
    {noreply, State#state{top_hero = TopHero}};

handle_info({sync_hero_rank}, State) ->
    case top_fight_center_mgr:sync_hero_rank() of
        {ok, Rank} ->
            ?INFO("成功更新排行榜"),
            {noreply, State#state{rank = Rank}};
        _ ->
            {noreply, State}
    end;

handle_info({sync_top_hero}, State) ->
    case top_fight_center_mgr:sync_top_hero() of
        {ok, Thero} ->
            ?INFO("成功更新霸主"),
            {noreply, State#state{top_hero = Thero}};
        _ ->
            {noreply, State}
    end;

handle_info({sync_status}, State) ->
    case top_fight_center_mgr:sync_status() of
        {ok, Ts, Status} ->
            ?INFO("成功更新状态"),
            {noreply, State#state{ts = Ts, status = Status}};
        _ ->
            {noreply, State}
    end;

handle_info({update_status, Ts, Status}, State) ->
    {noreply, State#state{ts = Ts, status = Status}};

handle_info({adm_sync}, State) ->
    erlang:send_after(1 * 1000, self(), {sync_hero_rank}),
    erlang:send_after(1 * 1000, self(), {sync_top_hero}),
    erlang:send_after(1 * 1000, self(), {sync_status}),
    {noreply, State};

handle_info({debug}, State) ->
    ?DEBUG("state: ~w", [State]),
    {noreply, State};
handle_info(_Info, State) ->
    {noreply, State}.

%% @spec: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
terminate(_Reason, _State) ->
    ok.

%% @spec: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------


%% 获取竞技开始报名时间 notice状态
handle_atime(notice, notice, Ts) ->
    Reply = round(util:time_left(?top_fight_timeout_notice, Ts) / 1000),
    {ok, {1, Reply}};
%% 获取竞技开始报名时间 prepare状态
handle_atime(notice, prepare, Ts) ->
    Reply = round(util:time_left(?top_fight_timeout_prepare_cross, Ts) / 1000),
    {ok, {2, Reply}};
handle_atime(notice, match_pre, _Ts) ->
    {ok, {3, 0}};
handle_atime(notice, matching, _Ts) ->
    {ok, {3, 0}};
%% 获取竞技开始报名时间 其它状态
handle_atime(notice, _StateName, _Ts) ->
    {ok, {0, 0}};

%% 获取准备时间
handle_atime(prepare, prepare, Ts) ->
    Reply = round(util:time_left(?top_fight_timeout_prepare_cross, Ts) / 1000),
    {ok, Reply};
handle_atime(prepare, _StateName, _Ts) ->
    {ok, 0};

%% 获取竞技时间
handle_atime(match, match_pre, Ts) ->
    Reply = round((util:time_left(?top_fight_timeout_match_pre_cross, Ts) + ?top_fight_timeout_matching) / 1000),
    {ok, Reply};
handle_atime(match, matching, Ts) ->
    Reply = round(util:time_left(?top_fight_timeout_matching, Ts) / 1000),
    {ok, Reply};
handle_atime(match, _StateName, _Ts) ->
    {ok, 0}.

%% 获取排行榜
do_get_hero_rank(#top_fight_hero_rank{low = ZoneList}, ?top_fight_lev_low, ArenaSeq) ->
    keyfind_hero_rank(ArenaSeq, ZoneList);
do_get_hero_rank(#top_fight_hero_rank{middle = ZoneList}, ?top_fight_lev_middle, ArenaSeq) ->
    keyfind_hero_rank(ArenaSeq, ZoneList);
do_get_hero_rank(#top_fight_hero_rank{hight = ZoneList}, ?top_fight_lev_hight, ArenaSeq) ->
    keyfind_hero_rank(ArenaSeq, ZoneList);
do_get_hero_rank(#top_fight_hero_rank{super = ZoneList}, ?top_fight_lev_super, ArenaSeq) ->
    keyfind_hero_rank(ArenaSeq, ZoneList);
do_get_hero_rank(#top_fight_hero_rank{angle = ZoneList}, ?top_fight_lev_angle, ArenaSeq) ->
    keyfind_hero_rank(ArenaSeq, ZoneList);
do_get_hero_rank(_, _, _) ->
    {false, ?L(<<"没找到竞技场战区信息">>)}.

keyfind_hero_rank(ArenaSeq, ZoneList) ->
    case lists:keyfind(ArenaSeq, #top_fight_hero_zone.arena_seq, ZoneList) of
        false -> 
            ?DEBUG("没找到巅峰对决战区信息"),
            {false, ?L(<<"没找到竞技场战区信息">>)};
        HeroZone -> {ok, length(ZoneList), HeroZone}
    end.

%% 获取霸主列表
do_get_hero(#top_fight_hero_rank{low = ZoneList}) ->
    {ok, [Hr || Hr = #top_fight_hero{winner = 1} <- flat_role(ZoneList)]};
do_get_hero(_) ->
    {false, <<>>}.

flat_role(ZoneList) ->
    flat_role(ZoneList, []).
flat_role([], Back) ->
    Back;
flat_role([#top_fight_hero_zone{hero_list = HeroList} | T], Back) ->
    flat_role(T, Back ++ HeroList).


%%
fetch_role(Rid) ->
    case role_api:lookup(by_id, Rid) of
        {ok, _, Role} ->
            {ok, Role};
        _ ->
            case role_data:fetch_role(by_id, Rid) of
                {ok, Role} ->
                    {ok, setting:dress_login_init(Role)};
                _ ->
                    false
            end
    end.

%% 判断是否有足够资格开巅峰对决
is_open() ->
    OpenTime = sys_env:get(srv_open_time),
    case guild_war_util:day_diff(OpenTime, util:unixtime()) of
        Day when Day < 14 ->
            false;
        _ ->
            true
    end.

