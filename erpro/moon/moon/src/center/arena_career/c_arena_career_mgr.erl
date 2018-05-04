%% --------------------------------------------------------------------
%% 跨服师门竞技管理器 
%% @author shawn 
%% --------------------------------------------------------------------
-module(c_arena_career_mgr).

-behaviour(gen_server).

%% 头文件
-include("common.hrl").
-include("arena_career.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("vip.hrl").
-include("mail.hrl").
-include("link.hrl").
-include("center.hrl").

%% api funs
-export([
        start_link/0 
    ]).

%% funs
-export([
        combat_start/1
        ,combat_over/1
        ,get_state/0
        ,commit_rank_data/3
        ,update/0
        ,notice/0
        ,clean/0
        ,init_join_data/2
    ]
).

%% gen_server callback
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% record
-record(state, {
        center_log = [] %% 战胜第一名公告, 只有1条
        ,cur_sn = 0
        ,collect_list = []
        ,award_time = 0
    }
).

-define(NOTICE_TIMEOUT, 10 * 1000). %% 广播超时后进行数据采集
-define(UPDATE_TIMEOUT, 30 * 1000). %% 广播超时后进行数据采集

-define(AWARD_TIME, 18 * 3600 + 2100). %% 6点半 + 5分钟缓冲 奖励时间

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

combat_start(Role) ->
    gen_server:cast(?MODULE, {combat_start, Role}).

combat_over(Result) ->
    gen_server:cast(?MODULE, {combat_over, Result}).

get_state() ->
    gen_server:call(?MODULE, get_state).

%% 远端服务器提交跨服数据
commit_rank_data(Sn, SrvId, Data) ->
    gen_server:cast(?MODULE, {commit_rank_data, Sn, SrvId, Data}).

%% 远端服务器请求跨服数据
init_join_data(SrvId, SrvIds) ->
    gen_server:cast(?MODULE, {init_join_data, SrvId, SrvIds}).

update() -> 
    c_arena_career_mgr ! update.

notice() -> 
    c_arena_career_mgr ! notice.

clean() -> 
    c_arena_career_mgr ! clean.

reload_state() ->
    case catch sys_env:get(c_arena_career_state) of
        State when is_record(State, state) ->
            {ok, State};
        undefined -> undefined;
        Reason -> {false, Reason}
    end.

%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    ets:new(c_arena_career_rank, [set, named_table, public, {keypos, #c_arena_career_role.id}]),
    dets:open_file(c_arena_career_rank, [{file, "../var/c_arena_career_rank.dets"}, {keypos, #c_arena_career_role.id}, {type, set}]),
    load_data(),
    NewState = case reload_state() of
        {ok, State} ->
            State#state{cur_sn = gen_collect_sn()};
        undefined ->
            ?INFO("初次师门竞技,进行初始化state"),
            #state{cur_sn = gen_collect_sn()};
        {false, Reason} ->
            ?ERR("加载跨服竞技数据异常:~w",[Reason]),
            #state{cur_sn = gen_collect_sn()}
    end,
    Now = util:unixtime(),
    NowDay = util:unixtime(today),
    case NewState#state.award_time of
        0 ->
            ?INFO("首次跨服,无奖励时间"),
            skip;
        AwardTime ->
            case util:unixtime({today, AwardTime}) + 86400 * 3 =:= NowDay of
                true ->
                    case Now > (NowDay + ?AWARD_TIME) of
                        true ->
                            ?INFO("跨服竞技统计奖励时间已过,10分钟后再统计"),
                            erlang:send_after(600 * 1000, self(), notice);
                        false ->
                            ?INFO("跨服竞技统计奖励时间未到,定点统计"),
                            ?INFO("[~w]秒后进行统计跨服竞技奖励",[(NowDay + ?AWARD_TIME - Now + 60)]),
                            erlang:send_after((NowDay + ?AWARD_TIME - Now + 60) * 1000, self(), notice)
                    end;
                false ->
                    ?INFO("跨服竞技非统计日,不予统计"),
                    skip
            end
    end,
    erlang:send_after((util:unixtime(today) + 86420 - util:unixtime()) * 1000, self(), day_check),
    erlang:send_after(30 * 60 * 1000, self(), save_state),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, NewState}.

%% 获取状态
handle_call(get_state, _From, State) ->
    ?DEBUG("State:~w",[State]),
    {reply, State, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%% 获取跨服数据
handle_cast({init_join_data, SrvId, SrvIds}, State = #state{center_log = CenterLog, award_time = AwardTime}) ->
    Reply = c_arena_career:query_join_data(SrvIds),
    c_arena_career:pack_msg(SrvId, {init_join_data, Reply, CenterLog, AwardTime}),
    {noreply, State};

handle_cast({commit_rank_data, Sn, SrvId, Data}, State = #state{cur_sn = CurSn, collect_list = CollList}) when Sn =:= CurSn ->
    ?DEBUG("收集到跨服竞技数据:Sn=~w, SrvId:~s", [Sn, SrvId]),
    %% to_show(Data),
    NewCollList = case lists:member(SrvId, CollList) of
        false ->
            ?INFO("收到未知服务器或者重复的SrvId:~s",[SrvId]),
            CollList;
        true ->
            merge_data(SrvId, Data),
            CollList -- [SrvId]
    end,
    {noreply, State#state{collect_list = NewCollList}};

handle_cast({commit_rank_data, Sn, _SrvId, _Data}, State = #state{cur_sn = CurSn}) when Sn =/= CurSn ->
    ?ERR("收到远端服务器提交的跨服数据[sn=~w]，但是已经超时了[当前sn=~w]", [Sn, CurSn]),
    ?DEBUG("收集到跨服竞技数据:Sn=~w, SrvId:~s", [Sn, _SrvId]),
    %% to_show(Data),
    {noreply, State};

handle_cast({combat_start, RoleInfo}, State) ->
    c_arena_career_dao:do_update_role(RoleInfo),
    {noreply, State};

handle_cast({combat_over, CombatResult = #arena_career_result{fight_rid = FromRid, fight_srv_id = FromSrvId, fight_career = FromCareer, to_fight_rid = ToRid, to_fight_srv_id = ToSrvId, to_fight_career = ToCareer, result = Result}}, State) ->
    case c_arena_career:get_role(FromRid, FromSrvId, FromCareer) of
        false -> 
            ?DEBUG("不存在该角色跨服数据,Rid:~w,SrvId:~s,Career:~s",[FromRid, FromSrvId, FromCareer]),
            {noreply, State};
        FromRole ->
            case c_arena_career:get_role(ToRid, ToSrvId, ToCareer) of
                false ->
                    ?DEBUG("不存在该角色跨服数据,Rid:~w,SrvId:~s,Career:~s",[ToRid, ToSrvId, ToCareer]),
                    {noreply, State};
                ToRole ->
                    {FromRank, ToRank} = case Result of
                        ?arena_career_win ->
                            {erlang:min(FromRole#c_arena_career_role.rank, ToRole#c_arena_career_role.rank),
                                erlang:max(FromRole#c_arena_career_role.rank, ToRole#c_arena_career_role.rank)};
                        ?arena_career_lose ->
                            {FromRole#c_arena_career_role.rank, ToRole#c_arena_career_role.rank}
                    end,
                    FromUporDown = if
                        FromRank > FromRole#c_arena_career_role.rank -> ?arena_career_rank_down;
                        FromRank < FromRole#c_arena_career_role.rank -> ?arena_career_rank_up;
                        true -> ?arena_career_rank_normal 
                    end,
                    ToUporDown = if
                        ToRank > ToRole#c_arena_career_role.rank -> ?arena_career_rank_down;
                        ToRank < ToRole#c_arena_career_role.rank -> ?arena_career_rank_up;
                        true -> ?arena_career_rank_normal 
                    end,
                    NewFromRole = FromRole#c_arena_career_role{rank = FromRank},
                    NewToRole = ToRole#c_arena_career_role{rank = ToRank},
                    save_result(NewFromRole, NewToRole),
                    c_arena_career:pack_msg(FromSrvId, {c_combat_over, 0, CombatResult, FromUporDown, FromRank}),
                    c_arena_career:pack_msg(ToSrvId, {c_combat_over, 1, CombatResult, ToUporDown, ToRank}),
                    case check_chief(FromRank, FromRole#c_arena_career_role.rank, FromRole, ToRole, State) of
                        {cast, NewState, Args} ->
                            Msg = {c_cast, Args},
                            c_mirror_group:cast(all, arena_career_mgr, async_apply, [Msg]),
                            {noreply, NewState};
                        {skip, NewState} ->
                            {noreply, NewState}
                    end
            end
    end;

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 每天检测
handle_info(day_check, State = #state{award_time = AwardTime}) ->
    Now = util:unixtime(today),
    case AwardTime =:= 0 of
        true -> skip;
        false ->
            case Now =:= (util:unixtime({today, AwardTime}) + 86400 * 3) of
                true ->
                    ?INFO("今日更新跨服竞技统计榜"),
                    ?INFO("[~w]毫秒后每天检测进行统计跨服竞技奖励",[(?AWARD_TIME) * 1000]),
                    erlang:send_after((?AWARD_TIME) * 1000, self(), notice);
                false ->
                    skip
            end
    end,
    erlang:send_after(86400 * 1000, self(), day_check),
    {noreply, State};

handle_info(notice, State) ->
    ?INFO("开始统计本次跨服竞技数据,并广播"),
    TableList = ets:tab2list(c_arena_career_rank) ,
    cast_notice(TableList),
    spawn(fun() ->
                do_notice(TableList)
        end),
    erlang:send_after(?NOTICE_TIMEOUT, self(), update), 
    {noreply, State};

handle_info(clean, State) ->
    ?INFO("清除旧版跨服竞技数据, 重新统计数据"),
    ets:delete_all_objects(c_arena_career_rank),
    dets:delete_all_objects(c_arena_career_rank),
    cast_notice([]),
    erlang:send_after(?NOTICE_TIMEOUT, self(), update), 
    {noreply, State};

handle_info(update, State = #state{cur_sn = Sn}) ->
    ?INFO("开始收集跨服师门竞技数据"),
    collect_rank_data(Sn),
    put(tmp_rank_data, []), 
    L = [SrvId || #mirror_data{srv_id = SrvId} <- c_mirror_group:get_all_mirror_data()],
    erlang:send_after(?UPDATE_TIMEOUT, self(), check_update_timeout_1), 
    {noreply, State#state{collect_list = L}};

handle_info(check_update_timeout_1, State = #state{cur_sn = Sn, collect_list = L}) ->
    ?INFO("采集重试时间到, 重试采集失败服务器列表:~w",[L]),
    retry_collect(Sn, L),
    erlang:send_after(?UPDATE_TIMEOUT, self(), check_update_timeout_2), 
    {noreply, State};

handle_info(check_update_timeout_2, State = #state{collect_list = L}) ->
    ?INFO("采集跨服师门竞技时间到, 采集失败服务器列表:~w",[L]),
    RankData = get(tmp_rank_data),
    TableList = ets:tab2list(c_arena_career_rank),
    put(tmp_rank_data, []), 
    ets:delete_all_objects(c_arena_career_rank),
    dets:delete_all_objects(c_arena_career_rank),
    AwardTime = util:unixtime(),
    split_rank_data(RankData, TableList, AwardTime),
    NextSn = gen_collect_sn(),
    NewState = State#state{cur_sn = NextSn, collect_list = [], award_time = AwardTime},
    save(NewState),
    ?INFO("跨服师门竞技统计完成，正式开始竞技"),
    {noreply, NewState};

%% 保存信息
handle_info(save_state, State) ->
    save(State),
    erlang:send_after(30 * 60 * 1000, self(), save_state),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

%% @spec: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
terminate(_Reason, State) ->
    save(State),
    ok.

%% @spec: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ------------------------------------------
%% 内部函数
%% -----------------------------------------
save(State) ->
    case sys_env:save(c_arena_career_state, State) of
        ok -> ?DEBUG("保存跨服竞技信息列表");
        _E -> ?ERR("保存跨服竞技信息列表失败:~w", [_E])
    end.


check_chief(1, OldRank, #c_arena_career_role{rid = Frid, srv_id = Fsrvid, name = Fname}, #c_arena_career_role{rid = Trid, srv_id = Tsrvid, name = Tname}, State) -> %% 攻击方最后排名为1
    case OldRank =:= 1 of
        false -> {cast, State#state{center_log = [{Frid, Fsrvid, Fname, Trid, Tsrvid, Tname}]}, {Frid, Fsrvid, Fname, Trid, Tsrvid, Tname}};
        true -> {skip, State}
    end;
check_chief(_, _, _, _, State) -> {skip, State}.

load_data() ->
    case dets:first(c_arena_career_rank) of
        '$end_of_table' -> ?INFO("没有跨服师门竞技数据");
        _ ->
            dets:traverse(c_arena_career_rank,
                fun(Crole) ->
                        NewCrole = c_arena_career:convert(Crole),
                        ets:insert(c_arena_career_rank, NewCrole),
                        continue
                end
            ),
            ?INFO("跨服师门竞技数据加载完毕")
    end.

save_result(#c_arena_career_role{rid = FromRid, srv_id = FromSrvId, career = FromCareer, rank = FromRank}, #c_arena_career_role{rid = ToRid, srv_id = ToSrvId, career = ToCareer, rank = ToRank}) ->
    c_arena_career_dao:save_combat_result(FromRid, FromSrvId, FromCareer, FromRank, ToRid, ToSrvId, ToCareer, ToRank).

%% 合并相同平台的数据,并且根据职业分组排序
split_rank_data(List, TableList, AwardTime) ->
    NewData = do_rank(List, TableList),
    case c_arena_career_dao:sign(NewData) of
        ok ->
            ?INFO("成功写入跨服角色数据,通知各服参赛名单"),
            spawn(fun() ->
                        c_arena_career:pack_join_rank_to_all(List, AwardTime)
                end);
        false ->
            ?ERR("写入跨服角色数据失败")
    end.

%% 分5个职业
%% -define(career_zhenwu, 1).      %% 真武
%% -define(career_cike, 2).     %% 刺客
%% -define(career_xianzhe, 3).     %% 贤者
%% -define(career_feiyu, 4).       %% 飞羽
%% -define(career_qishi, 5).     %% 骑士
do_rank(List, TableList) ->
    do_rank(List, TableList, []).

do_rank([], [], AllData) ->
    ?DEBUG("第一次排行,按照战斗力"),
    NewData = modify_rank(keys_sort(1, AllData)),
    NewData;
do_rank([], TableList, AllData) -> %% 旧数据, 和新数据合并
    ?DEBUG("已有旧数据,需要合并数据"),
    NewData = do_merge_rank(TableList, AllData),
    NewData;
do_rank([{_SrvId, Data} | T], TableList, AllData) ->
    do_rank(T, TableList, Data ++ AllData).

modify_rank(Data) ->
    modify_rank(Data, 1, []).
modify_rank([], _, Data) -> Data;
modify_rank([{Rid, SrvId, Name, Career, _Rank, Sex, Lev, Face, HpMax, MpMax, Attr, Looks, Eqm, PetBag, Skill, FightCapacity, Ascend} | T], NewRank, Data) ->
    modify_rank(T, NewRank + 1, [{Rid, SrvId, Name, Career, NewRank, Sex, Lev, Face, HpMax, MpMax, Attr, Looks, Eqm, PetBag, Skill, FightCapacity, Ascend} | Data]).

do_merge_rank(TableList, AllData) ->
    do_merge_rank(TableList, AllData, [], []).
do_merge_rank(_TableList, [], Old, New) ->
    Nold = lists:reverse(keys_sort(2, Old)),
    Nnew = keys_sort(1, New), 
    modify_rank(Nold ++ Nnew);
do_merge_rank(TableList, [R = {Rid, SrvId, _, Career, _, _, _, _, _, _, _, _, _, _, _, _, _} | T], Old, New) ->
    case lists:keyfind({Rid, SrvId, Career}, #c_arena_career_role.id, TableList) of
        false ->
            do_merge_rank(TableList, T, Old, [R | New]);
        #c_arena_career_role{rid = Rid, srv_id = SrvId, name = Name, career = Career, rank = Rank, sex = Sex, lev = Lev, face = Face, hp_max = HpMax, mp_max = MpMax, attr = Attr, looks = Looks, eqm = Eqm, pet_bag = PetBag, skill = Skill, fight_capacity = FightCapacity, ascend = Ascend} ->
            do_merge_rank(TableList, T, [{Rid, SrvId, Name, Career, Rank, Sex, Lev, Face, HpMax, MpMax, Attr, Looks, Eqm, PetBag, Skill, FightCapacity, Ascend} | Old], New)
    end.

%% 按多键排序 后面优先 即第二个键优先于第一个键
keys_sort(N, TupleList) ->
    do_keys_sort(get_sort_key(N), TupleList).
do_keys_sort([],TupleList) ->
    lists:reverse(TupleList);
do_keys_sort([H|T], TupleList) ->
    NewTupleList = lists:keysort(H, TupleList),
    do_keys_sort(T,NewTupleList).

%% 获取排行榜排序key
get_sort_key(1) -> [16];
get_sort_key(2) -> [5].

%% 合并缓存数据
merge_data(_SrvId, []) -> skip;
merge_data(SrvId, Data) ->
    TmpRankData = get(tmp_rank_data),
    NewTmpRankData = [{SrvId, Data} | TmpRankData],
    put(tmp_rank_data, NewTmpRankData).

%% 生成采集任务序列号
gen_collect_sn() ->
    util:unixtime().

%% 采集数据
collect_rank_data(Sn) ->
    Msg = {collect_rank_data, Sn},
    c_mirror_group:cast(all, arena_career_mgr, async_apply, [Msg]).

%% 重试采集数据
retry_collect(_Sn, []) -> skip;
retry_collect(Sn, [SrvId | T]) ->
    Msg = {collect_rank_data, Sn},
    c_mirror_group:cast(node, SrvId, arena_career_mgr, async_apply, [Msg]),
    retry_collect(Sn, T).

%% 开始广播统计
do_notice([]) -> skip;
do_notice(TableList) ->
    CastTable = [{Rid, SrvId, Rank, Lev} || #c_arena_career_role{rid = Rid, srv_id = SrvId, rank = Rank, lev = Lev} <- TableList, Rank =< 3000],
    LuckNum = util:rand(0, 9),
    Msg = {award, CastTable, LuckNum},
    c_mirror_group:cast(all, arena_career_mgr, async_apply, [Msg]). 

cast_notice(TableList) ->
    case [Crole || Crole <- TableList, Crole#c_arena_career_role.rank =:= 1] of
        [] ->
            Msg = {notice, null},
            c_mirror_group:cast(all, arena_career_mgr, async_apply, [Msg]);
        [#c_arena_career_role{rid = Rid, srv_id = SrvId, name = Name}] ->
            Msg = {notice, {Rid, SrvId, Name}},
            c_mirror_group:cast(all, arena_career_mgr, async_apply, [Msg])
    end.

%% 调试用接口
%% to_show([]) -> ok;
%% to_show([{_Rid, _SrvId, _Name, _, _Rank, _, _, _, _, _, _, _, _, _, _, _, _, _FightCapacity} | T]) ->
%%     ?DEBUG("Rid:~w, SrvId:~s, Name:~s, Rank:~w, FightCapacity:~w",[_Rid, _SrvId, _Name, _Rank, _FightCapacity]),
%%     to_show(T).
