%% --------------------------------------------------------------------
%% 中庭战神管理器 
%% @author shawn 
%% --------------------------------------------------------------------
-module(arena_career_mgr).

-behaviour(gen_server).

%% 头文件
-include("common.hrl").
-include("arena_career.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("vip.hrl").
-include("mail.hrl").
-include("link.hrl").
-include("notification.hrl").
-include("gain.hrl").

%% api funs
-export([
        start_link/0 
    ]).

%% funs
-export([
        query_data/2
        ,query_rank/1
        %,query_center/0
        ,combat_start/1
        %,check_center/3
        ,sign/1
        ,combat_over/1
        ,get_max_power/1
        %,award_info/2
        %,get_award/2
        ,get_hero/0
        ,get_wins_rank/0
        %,get_center_hero/0
        ,get_state/0
        ,gm_award/0
        ,async_apply/1
        %,get_center_award/0
        ,i/0
        ,remain_award_time/0
        ,get_award_timer/0
        ,max_rank/0
    ]
).

%% gen_server callback
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(secs_of_3_days, 3*24*3600).  %% 3天的秒数
-define(secs_of_1_day, 24*3600).  %% 1天的秒数


%% record
-record(state, {
        chief_log = [] %% 战胜首席公告, 只有5条
        ,next_rank_id = 1  %% 下一个排名ID
        ,award_list = [] %% 当前奖励列表
        ,join_data = [] %% 参与跨服列表
        ,center_log = [] %% 跨服霸主公告 只有1条
        ,init = false
        ,last_award_day   %% 最后上一次的发奖日期当天0时时间戳
        ,next_award_time  %% 下次发奖时间戳（包括了随机偏移时间）
    }
).

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

query_data(Rid, SrvId) ->
    get_log_list(Rid, SrvId).

query_rank(Career) ->
    gen_server:call(?MODULE, {query_rank, Career}). 

combat_start(Role) ->
    gen_server:cast(?MODULE, {combat_start, Role}).

% get_center_award() ->
%     gen_server:call(?MODULE, center_award).

get_hero() ->
    gen_server:call(?MODULE, get_hero).

get_wins_rank() ->
    gen_server:call(?MODULE, get_wins_rank).

% get_center_hero() ->
%     gen_server:call(?MODULE, {get_center_hero}).

sign(Role = #role{id = {Rid, SrvId}, lev = Lev}) when Lev >= ?arena_career_lev ->
    case arena_career_dao:get_role(Rid, SrvId) of
        undefined ->
            gen_server:cast(?MODULE, {sign, Role});
        _ ->
            ?DEBUG("已经报名,无需触发"),
            skip 
    end;
sign(_) -> skip.

get_max_power(Career) ->
    gen_server:call(?MODULE, {get_max_power, Career}). 

%award_info(Rid, SrvId) ->
%    gen_server:call(?MODULE, {award_info, Rid, SrvId}).
%
%get_award(Rid, SrvId) ->
%    gen_server:call(?MODULE, {get_award, Rid, SrvId}).

combat_over(Result) ->
    gen_server:cast(?MODULE, {combat_over, Result}).

% query_center() ->
%     gen_server:call(?MODULE, query_center).

% check_center(Rid, SrvId, Career) ->
%     gen_server:call(?MODULE, {check_center, Rid, SrvId, Career}).

get_state() ->
    gen_server:call(?MODULE, get_state).

async_apply(Msg) ->
    gen_server:cast(?MODULE, Msg).

reload() ->
    case catch sys_env:get(arena_career_state) of
        State when is_record(State, state) ->
            {ok, State};
        {state, ChiefLog, NextRankId, AwardList} ->
            {ok, #state{chief_log = ChiefLog, next_rank_id = NextRankId, award_list = AwardList}}; 
        undefined -> skip;
        Reason -> {false, Reason}
    end.

max_rank() ->
    case catch sys_env:get(arena_career_state) of
        State when is_record(State, state) ->
            {ok, State#state.next_rank_id - 1};
        {state, _ChiefLog, NextRankId, _AwardList} ->
            {ok, NextRankId - 1}; 
        undefined -> 0;
        _Reason -> 0
    end.    

gm_award() ->
    ?MODULE ! award.

i() ->
    gen_server:call(?MODULE, i).

remain_award_time() ->
    NextAwardTime = case catch gen_server:call(?MODULE, get_next_award_time) of
        {'EXIT', _Reason} ->
            ?ERR("timeout"),
            case catch sys_env:get(arena_career_state) of
                #state{next_award_time = Time} when is_integer(Time), Time > 0 ->
                    Time;
                _ -> %% 当作是新开服处理
                    util:unixtime(today) + ?secs_of_1_day
            end;
        Time ->
            Time
    end,
    NextAwardTime - util:unixtime().

%% 调试用，监控用
%% -> undefined | {Ref, RemainTime::{Days, {Hour, Min, Sec}}}
get_award_timer() ->
    gen_server:call(?MODULE, get_award_timer).

%% 锁住参赛者，不让其它人攻击
%lock({RoleId, SrvId}) ->
%    LockId = case catch ets:lookup_element(arena_career_lock, {RoleId, SrvId}, #arena_career_lock.id) of
%        {'EXIT', {badarg, _}} -> ets:insert(arena_career_lock, {{RoleId, SrvId}, 1}), 1;
%        Id -> Id
%    end,
%    NewLockId = ets:update_counter(arena_career_lock, {RoleId, SrvId}, {#arena_career_lock.id, 1, 1000, 1}),
%    case LockId + 1 =:= NewLockId of
%        true ->
%            ;
%        false -> 
%            ok;
%    end.


%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    ets:new(ets_arena_career_log, [named_table, public, set]),
    %ets:new(ets_c_arena_career_log, [named_table, public, set]),
    State = case reload() of
        skip ->
            #state{};
        {false, Reason} -> 
            ?ERR("获取中庭战神状态出错, 原因:~w",[Reason]),
            #state{};
        {ok, SavedState} -> 
            SavedState
    end,
    case arena_career_dao:max_rank() of
        {ok, MaxRank} when is_integer(MaxRank) -> 
            NextRank = MaxRank + 1,
            Now = util:unixtime(),
            Today = util:unixtime(today),
            RandTime = util:rand(1, 60),
            % TickTime = ?award_time + RandTime,
            % case Now > Today + TickTime of
            %     true ->
            %         put(arena_career_award_time, 0),
            %         skip;
            %     false ->
            %         put(arena_career_award_time, RandTime),
            %         erlang:send_after((Today + TickTime - Now) * 1000, self(), award)
            % end,
            ?INFO("[~w] 启动完成", [?MODULE]),
            put(arena_career_hero, []),
            put(arena_career_wins_rank, []),
            %put(arena_career_center_hero, []),
            erlang:send_after(20 * 1000, self(), update_rank),
            %erlang:send_after((Today + 86420 - util:unixtime()) * 1000, self(), day_check),
            erlang:send_after(30 * 60 * 1000, self(), save_state),
            %erlang:send_after(1 * 70 * 1000, self(), init_join_data),
            %%
            NewLastAwardDay = case State#state.last_award_day of
                undefined -> %% 开服第一天
                    timer(?secs_of_1_day - Now + Today + RandTime, cycle_1_day_0),  %% 3天后执行
                    Today;
                LastAwardDay -> 
                    case (Today - LastAwardDay) > ?secs_of_1_day of
                        true -> %% 当前时间离上次发奖时间大于3天, 马上发一次奖
                            Offset = (Now - LastAwardDay) rem ?secs_of_1_day,  %% 超过最近一次发奖时间的时间差
                            TimeAfter = ?secs_of_1_day - Offset + RandTime,  %% 下一次发奖时间
                            timer(TimeAfter, cycle_1_day_0),
                            do_active_award(),   %% 马上发奖
                            Now - Offset;  %% 上一个发奖时间 
                        false ->  %% 当前时间离上次发奖时间不足3天
                            timer(?secs_of_1_day - Now + LastAwardDay + RandTime, cycle_1_day_0),
                            LastAwardDay
                    end
            end,
            timer(?secs_of_1_day - Now + Today + util:rand(1, 30), cycle_1_day),  %% 1天后执行
            NewState = State#state{
                init = false, 
                next_rank_id = NextRank, 
                last_award_day = NewLastAwardDay,
                next_award_time = NewLastAwardDay + ?secs_of_1_day + RandTime
            },
            save(NewState),
            self() ! send_award_queue,
            {ok, NewState};
        DbErr ->
            {stop, DbErr}
    end.

%% 查询公告日志
handle_call({query_rank, Career}, _From, State = #state{chief_log = OwnerLog}) ->
    Reply = case lists:keyfind(Career, 1, OwnerLog) of
        false -> null;
        {_, Own} -> Own
    end,
    {reply, Reply, State};

%% 查询跨服日志
% handle_call(query_center, _From, State = #state{center_log = CenterLog}) ->
%     {reply, CenterLog, State}; 

%% 查询是否有跨服资格
% handle_call({check_center, Rid, SrvId, Career}, _From, State = #state{join_data = JoinData}) ->
%     Reply = do_check_center(Rid, SrvId, Career, JoinData), 
%     {reply, Reply, State};

%% 查询首席弟子
handle_call({get_max_power, Career}, _From, State) ->
    Reply = arena_career_dao:get_max(Career),
    {reply, Reply, State};

%% 获取状态
handle_call(get_state, _From, State) ->
    ?DEBUG("State:~w",[State]),
    {reply, State, State};

%% 查询是否有奖励 
% handle_call({award_info, Rid, SrvId}, _From, State = #state{award_list = AwardList}) ->
%     Label = case find_award(AwardList, Rid, SrvId) of
%         false -> ?false;
%         {true, _, _} -> ?true
%     end,
%     Now = util:unixtime(),
%     Today = util:unixtime(today),
%     RandTime = get(arena_career_award_time),
%     Time = case Now > Today + ?award_time + RandTime of
%         true -> Today + ?award_time + 86400 - Now;
%         false -> Today + ?award_time + RandTime - Now
%     end,
%     {reply, {Label, Time}, State};

%% 领取奖励
% handle_call({get_award, Rid, SrvId}, _From, State = #state{award_list = AwardList}) ->
%     ?DEBUG("AwardList:~w",[AwardList]),
%     case find_award(AwardList, Rid, SrvId) of
%         false ->
%             {reply, ?false, State};
%         {true, Rank, _} -> 
%             ?DEBUG("Rank:~w",[Rank]),
%             Attainment = erlang:round(3000/math:pow(Rank, 0.8)),
%             CareerDev = erlang:round(200 / math:pow(Rank, 0.5)),
%             NewAwardList = modify_award(AwardList, Rid, SrvId),
%             {reply, {?true, Rank, Attainment, CareerDev}, State#state{award_list = NewAwardList}}
%     end;

%% 跨服统计剩余天数
% handle_call(center_award, _From, State) ->
%     Now = util:unixtime(),
%     NowDay = util:unixtime(today),
%     Reply = case get(center_award_time) of
%         0 -> 3;
%         Time when is_integer(Time) ->
%             case NowDay =:= (util:unixtime({today, Time}) + 86400 * 3) of
%                 true ->
%                     case Now > (NowDay + (18 * 3600 + 2100)) of
%                         true -> 3;
%                         false -> 0
%                     end;
%                 false -> day_diff(Now, Time + 86400 * 3)
%             end
%     end,
%     {reply, Reply, State};

%% 获取英雄榜
handle_call(get_hero, _From, State) ->
    Reply = get(arena_career_hero),
    {reply, Reply, State};

%% 获取连胜榜
handle_call(get_wins_rank, _From, State) ->
    Reply = get(arena_career_wins_rank),
    {reply, Reply, State};

%% 获取跨服英雄榜
% handle_call({get_center_hero}, _From, State) ->
%     List = get(arena_career_center_hero),
%     {reply, List, State};

handle_call(get_next_award_time, _From, State) ->
    {reply, State#state.next_award_time, State};

handle_call(get_last_award_day, _From, State) ->
    {reply, State#state.last_award_day, State};

handle_call(i, _From, State) ->
    {reply, State, State};

%% 调试用，监控用
handle_call(get_award_timer, _From, State) ->
    Reply = case get({timer, cycle_1_day_0}) of
        undefined -> undefined;
        Ref ->
            case erlang:read_timer(Ref) of
                false -> undefined;
                Time -> {Ref, calendar:seconds_to_daystime(Time div 1000)}
            end
    end,
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

% handle_cast({collect_rank_data, Sn}, State = #state{award_list = AwardList}) ->
%     List = find_center_role(AwardList),
%     case sys_env:get(srv_id) of
%         undefined ->
%             ?ERR("收集跨服中庭战神时无法获取SrvId"),
%             skip;
%         SrvId -> 
%             center:cast(c_arena_career_mgr, commit_rank_data, [Sn, list_to_bitstring(SrvId), List])
%     end,
%     {noreply, State};

%% 统计更新, 收到跨服角色参加消息 (中央服广播)
% handle_cast({join_data, Data, AwardTime}, State = #state{}) ->
%     JoinList = pack_join_data(Data, []),
%     put(center_award_time, AwardTime),
%     {noreply, State#state{join_data = JoinList, center_log = []}};

%% 收到跨服角色列表信息 (主动请求)
% handle_cast({init_join_data, Data, CenterLog, AwardTime}, State) when is_list(Data) ->
%     put(center_award_time, AwardTime),
%     erlang:send_after(30 * 1000, self(), update_center_hero),
%     ?INFO("收到跨服中庭战神信息:Data长度:~w, CenterLog:~w,奖励统计时间:~w",[length(Data), length(CenterLog), AwardTime]),
%     {noreply, State#state{join_data = Data, center_log = CenterLog, init = true}};
% 
% %% 收到跨服角色列表信息
% handle_cast({init_join_data, Data, _CenterLog, _}, State) ->
%     ?ERR("收到错误的跨服中庭战神信息:Data:~w",[Data]),
%     {noreply, State#state{init = true}};

%% 收到奖励信息
%handle_cast({award, TableList, LuckNum}, State) ->
%    RoleList = get_local_role(TableList),
%    send_award_mail(RoleList),
%    Now = util:unixtime(),
%    BeginTime = util:datetime_to_seconds({{2012, 7, 4}, {0,0,1}}),
%    EndTime = util:datetime_to_seconds({{2012, 7, 9}, {23,59,59}}),
%    case Now >=  BeginTime andalso Now =< EndTime of
%        true -> 
%            send_luck_mail(RoleList, LuckNum),
%            send_camp_mail(RoleList);
%        false -> ok
%    end,
%    %add_center_honor(RoleList),
%    {noreply, State};

%% 排行第一
% handle_cast({notice, {Rid, SrvId, Name}}, State) ->
%     RoleMsg = notice:role_to_msg({Rid, SrvId, Name}),
%     notice:send(54, util:fbin(?L(<<"上一届跨服中庭战神已经结束, 恭喜~s获得跨服竞技第一名, 夺得【武圣】称号，下一届跨服中庭战神资格将马上产生，让我们拭目以待">>),[RoleMsg])),
%     put(center_award_time, 0),
%     {noreply, State#state{join_data = []}};

% handle_cast({notice, null}, State) ->
%     notice:send(54, ?L(<<"上一届跨服中庭战神已经结束, 下一届跨服中庭战神资格将马上产生，让我们拭目以待">>)),
%     put(center_award_time, 0),
%     {noreply, State#state{join_data = []}};

handle_cast({sign, Role = #role{id = {_Rid, _SrvId}}}, State = #state{next_rank_id = NextRank}) ->
    ?DEBUG("sign: ~p rank: ~p", [{_Rid, _SrvId}, NextRank]),
    case arena_career_dao:sign(NextRank, Role) of
        true -> 
            NewState = State#state{next_rank_id = NextRank + 1},
            save(NewState),
            {noreply, NewState};
        false ->
            {noreply, State}
    end;

handle_cast({combat_start, Role}, State) ->
    update(Role),
    {noreply, State};

% handle_cast({c_combat_over, Label, CombatResult = #arena_career_result{fight_rid = FromRid, fight_srv_id = FromSrvId}, UporDown, Rank}, State) ->
%     insert_center_log(Label, CombatResult, UporDown, Rank),
%     case Label =:= 0 of
%         true -> spawn(fun() -> c_pack_combat_over(FromRid, FromSrvId) end);
%         false -> skip
%     end,
%     {noreply, State};
% handle_cast({c_cast, {Frid, Fsrvid, Fname, Trid, Tsrvid, Tname}}, State) ->
%     From = notice:role_to_msg({Frid, Fsrvid, Fname}),
%     To = notice:role_to_msg({Trid, Tsrvid, Tname}),
%     Msg = util:fbin(?L(<<"战神降临！~s竟在超时空跨服竞技中击败了排行第一的~s，成为宇宙最强，有望成为新一届武圣！">>), [From, To]),
%     notice:send(53, Msg),
%     CenterLog = [{Frid, Fsrvid, Fname, Trid, Tsrvid, Tname}],
%     {noreply, State#state{center_log = CenterLog}};

handle_cast({combat_over, CombatResult = #arena_career_result{fight_rid = FromRid, fight_srv_id = FromSrvId, fight_career = _FromCareer, to_fight_rid = ToRid, to_fight_srv_id = ToSrvId, to_fight_career = _ToCareer, result = Result}}, State) ->
    arena_career_lock:unlock({FromRid, FromSrvId}, {ToRid, ToSrvId}),
    case arena_career:get_role(FromRid, FromSrvId) of
        false -> 
            ?ERR("无法获取中庭战神发起方数据库信息,Rid:~w,SrvId:~s",[FromRid, FromSrvId]),
            {noreply, State};
        FromRole ->
            case arena_career:get_role(ToRid, ToSrvId) of
                false ->
                    ?ERR("无法获取中庭战神防守方数据库信息,Rid:~w,SrvId:~s",[ToRid, ToSrvId]),
                    {noreply, State};
                ToRole ->
                    RolePid = 
                    case role_api:c_lookup(by_id, {FromRole#arena_career_role.rid, FromRole#arena_career_role.srv_id}, #role.pid) of %%检查是否在线,在线则发送消息通知
                        {ok, _, Pid} when is_pid(Pid)  ->
                            Pid;
                        _ -> undefined
                    end,

                    {FromRank, ToRank, FromWins, ToWins} = case Result of
                        ?arena_career_win ->
                            case is_pid(RolePid) andalso is_process_alive(RolePid) of 
                                true ->  
                                    role:apply(async, RolePid, {random_award, competitive_win, []});
                                _ -> ignore
                            end,

                            {erlang:min(FromRole#arena_career_role.rank, ToRole#arena_career_role.rank),
                                erlang:max(FromRole#arena_career_role.rank, ToRole#arena_career_role.rank),
                                FromRole#arena_career_role.con_wins + 1,
                                0};
                        ?arena_career_lose ->
                            case is_pid(RolePid) andalso is_process_alive(RolePid) of 
                                true ->  
                                    role:apply(async, RolePid, {random_award, competitive_loss, []});
                                _ -> ignore
                            end,

                            {FromRole#arena_career_role.rank, 
                                ToRole#arena_career_role.rank, 
                                0, 
                                ToRole#arena_career_role.con_wins + 1}
                    end,
                    FromUporDown = if
                        FromRank > FromRole#arena_career_role.rank -> ?arena_career_rank_down;
                        FromRank < FromRole#arena_career_role.rank -> ?arena_career_rank_up;
                        true -> ?arena_career_rank_normal 
                    end,
                    ToUporDown = if
                        ToRank > ToRole#arena_career_role.rank -> ?arena_career_rank_down;
                        ToRank < ToRole#arena_career_role.rank -> ?arena_career_rank_up;
                        true -> ?arena_career_rank_normal 
                    end,
                    NewFromRole = FromRole#arena_career_role{rank = FromRank, con_wins = FromWins},
                    NewToRole = ToRole#arena_career_role{rank = ToRank, con_wins = ToWins},
                    %tv(CombatResult),
                    insert_log(CombatResult, FromUporDown, FromRank, ToUporDown, ToRank),
                    save_result(NewFromRole, NewToRole),
                    %NewState = check_chief(FromRank, FromRole#arena_career_role.rank, FromRole, ToRole, State),
                    spawn(fun() ->
                                FromRoleNameFmt = notice:get_role_msg(FromRole#arena_career_role.name, {FromRid, FromSrvId}),
                                ToRoleNameFmt = notice:get_role_msg(ToRole#arena_career_role.name, {ToRid, ToSrvId}),
                                case Result =:= ?arena_career_win andalso FromUporDown =:= ?arena_career_rank_up andalso FromRank =< 10 of
                                    true ->
                                        Msg = util:fbin(?L(<<"~s在中庭战神中勇猛异常，打败了~s，夺得了第~s名">>), 
                                                [FromRoleNameFmt, ToRoleNameFmt, ?notify_color_num(FromRank)]),
                                        notice:rumor(Msg);
                                    _ ->
                                        ignore
                                end,
                                {NotifyMsg, NotifyType} = case Result =:= ?arena_career_win of
                                    true -> 
                                        case FromUporDown of
                                            ?arena_career_rank_normal ->
                                                {util:fbin(?L(<<"~s在中庭战神中战胜了您，排名不变">>), [FromRoleNameFmt]), 
                                                ?notify_type_arena_career_lose};
                                            _ ->
                                                {util:fbin(?L(<<"~s在中庭战神中战胜了您，你的排名下降到第~s名">>), [FromRoleNameFmt, ?notify_color_num(ToRank)]), 
                                                ?notify_type_arena_career_lose}
                                        end;
                                    _ -> {util:fbin(?L(<<"~s在中庭战神中挑战了您，您获得了胜利">>), [FromRoleNameFmt]), 
                                        ?notify_type_arena_career_win}
                                end,
                                notification:send(offline, {ToRid, ToSrvId}, NotifyType, NotifyMsg, []),
                                %% 连胜传闻
                                case Result =:= ?arena_career_win of
                                    true -> notice_con_wins(FromRole, FromRoleNameFmt, FromWins, ToRole, ToRoleNameFmt, ToWins);
                                    false -> notice_con_wins(ToRole, ToRoleNameFmt, ToWins, FromRole, FromRoleNameFmt, FromWins)
                                end,
                                pack_combat_over(FromRid, FromSrvId, FromRole#arena_career_role.career, Result, State)
                        end),
                    {noreply, State}
            end
    end;

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 更新英雄榜和连胜榜
handle_info(update_rank, State) ->
    Hero = arena_career:get_hero(),
    put(arena_career_hero, Hero),
    WinsRank = arena_career:get_wins_rank(),
    put(arena_career_wins_rank, WinsRank),
    erlang:send_after(5 * 60 * 1000, self(), update_rank),
    {noreply, State};

%% 更新跨服英雄榜
% handle_info(update_center_hero, State) ->
%     CenterHero = arena_career:get_cross_hero(),
%     put(arena_career_center_hero, CenterHero),
%     erlang:send_after(5 * 60 * 1000, self(), update_center_hero),
%     {noreply, State};

%% 每天检测
% handle_info(day_check, State) ->
%     RandTime = util:rand(1, 1800),
%     put(arena_career_award_time, RandTime),
%     erlang:send_after((?award_time + RandTime) * 1000, self(), award),
%     erlang:send_after(86400 * 1000, self(), day_check),
%     {noreply, State};

%% 统计奖励
% handle_info(award, State) ->
%     NewAwardList = arena_career_dao:get_award_list(),
%     % MaxPowers = [{Career, {Rid, SrvId}} || {Rid, SrvId, Rank, Career, _, _} <- NewAwardList, Rank =:= 1], 
%     % npc_mgr:update_honour_npc(MaxPowers),
%     add_honor(NewAwardList),
%     NewState = State#state{award_list = NewAwardList},
%     save(NewState),
%     spawn(fun() -> notice_promt(NewAwardList) end),
%     {noreply, NewState};

%% 请求跨服数据 
% handle_info(init_join_data, State = #state{init = false}) ->
%     SrvId = sys_env:get(srv_id),
%     SrvIds = sys_env:get(srv_ids),
%     QuerySrvIds = (SrvIds -- [SrvId]) ++ [SrvId],
%     ?DEBUG("请求跨服中庭战神列表:服务器数量~w",[length(QuerySrvIds)]),
%     center:cast(c_arena_career_mgr, init_join_data, [list_to_bitstring(SrvId), QuerySrvIds]),
%     erlang:send_after(3 * 60 * 1000, self(), init_join_data),
%     {noreply, State};
% handle_info(init_join_data, State) ->
%     {noreply, State};

%% 保存信息
handle_info(save_state, State) ->
    save(State),
    erlang:send_after(30 * 60 * 1000, self(), save_state),
    {noreply, State};

handle_info(cycle_1_day_0, State) ->
    ?INFO("cycle_1_day_0"),
    RandTime = util:rand(1, 60),
    Now = util:unixtime(),
    Today = util:unixtime(today),
    timer(?secs_of_1_day - Now + Today + RandTime, cycle_1_day_0),  %% 3天后执行
    do_active_award(),  %% 发奖
    self() ! send_award_queue,
    NewState = State#state{
        last_award_day = Today,
        next_award_time = Today + ?secs_of_1_day + RandTime
    },
    {noreply, NewState};

handle_info(cycle_1_day, State) ->
    ?INFO("cycle_1_day"),
    RandTime = util:rand(1, 30),
    Now = util:unixtime(),
    Today = util:unixtime(today),
    timer(?secs_of_1_day - Now + Today + RandTime, cycle_1_day),  %% 1天后执行
    %% TODO do_send_wins_award(),  %% 暂不发连胜榜奖
    do_update_wins_rank(),
    {noreply, State};

handle_info(send_award_queue, State) ->
    ?INFO("send_award_queue"),
    case do_send_award_queue() of
        next ->
            erlang:send_after(2000, self(), send_award_queue);
        _ ->
            ignore
    end,
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

%% ------------------------------------
%% 内部函数
%% ------------------------------------ 
% do_check_center(_Rid, _SrvId, _Career, []) -> false;
% do_check_center(Rid, SrvId, Career, [{Rid, SrvId, Career, _} | _T]) -> true;
% do_check_center(Rid, SrvId, Career, [_ | T]) -> 
%     do_check_center(Rid, SrvId, Career, T).

save(State) ->
    case sys_env:save(arena_career_state, State#state{join_data = [], center_log = []}) of
        ok -> ?DEBUG("保存中庭战神信息列表");
        _E -> ?ERR("保存中庭战神信息列表失败:~w", [_E])
    end.

% pack_join_data([], AllList) -> AllList;
% pack_join_data([{Career, List} | T], AllList) ->
%     case join_data_to_msg(Career, List, <<"">>) of
%         skip -> skip;
%         Msg -> notice:send(54, Msg)
%     end,
%     pack_join_data(T, List ++ AllList).

% join_data_to_msg(_Career, [], <<"">>) -> skip;
% join_data_to_msg(Career, [], RoleMsg) ->
%     util:fbin(?L(<<"恭喜本服选手~s获得参与【~s】跨服中庭战神资格，让我们祝福他们在竞赛中获得好成绩！">>),[RoleMsg, to_career_name(Career)]); 
% join_data_to_msg(Career, [{Rid, SrvId, _, Name} | T], RoleMsg) ->
%     case RoleMsg =:= <<"">> of
%         true -> join_data_to_msg(Career, T, util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>, [Rid, SrvId, Name]));
%         false -> join_data_to_msg(Career, T, util:fbin(<<"~s、{role, ~w, ~s, ~s, #3ad6f0}">>, [RoleMsg, Rid, SrvId, Name]))
%     end.
% 
% to_career_name(?career_zhenwu) -> ?L(<<"真武">>);
% to_career_name(?career_cike) -> ?L(<<"刺客">>);
% to_career_name(?career_feiyu) -> ?L(<<"飞羽">>);
% to_career_name(?career_xianzhe) -> ?L(<<"贤者">>);
% to_career_name(?career_qishi) -> ?L(<<"骑士">>).

% notice_promt([]) -> ok;
% notice_promt([{Rid, SrvId, _, _, _} | T]) ->
%     case role_api:lookup(by_id, {Rid, SrvId}, #role.link) of
%         {ok, _Node, #link{conn_pid = ConnPid}} ->
%             sys_conn:pack_send(ConnPid, 16117, {});
%         _ -> skip
%     end,
%     notice_promt(T).

% c_pack_combat_over(Rid, SrvId) ->
%     case role_api:lookup(by_id, {Rid, SrvId}, #role.pid) of
%         {ok, _Node, Pid} ->
%             role:apply(async, Pid, {fun c_async_combat_info/1, []});
%         _ ->
%             skip
%     end.

% c_async_combat_info(Role = #role{id = {Rid, SrvId}, career = Career, link = #link{conn_pid = ConnPid}, arena_career = #arena_career{free_count = Count1, pay_count = Count2, cooldown = CoolDown}}) ->
%     Now = util:unixtime(),
%     Cd = case CoolDown =:= 0 of
%         true -> 0;
%         false ->
%             case CoolDown - Now > 0 of
%                 true -> CoolDown - Now;
%                 false -> 0
%             end
%     end,
%     case arena_career:c_get_role_info(Rid, SrvId, Career) of
%         false -> {ok, Role};
%         {Rank, Lev} ->
%             D = case arena_career_mgr:get_center_award() of
%                 Day when is_integer(Day) -> Day;
%                 _X ->
%                     ?DEBUG("获取奖励发放时间错误:~w",[_X]),
%                     3
%             end,
%             RangeRole = arena_career:c_get_range(Rid, SrvId, Career),
%             sys_conn:pack_send(ConnPid, 16110, {RangeRole}),
%             sys_conn:pack_send(ConnPid, 16114, {?true, Rank, Lev, Count1 + Count2, Cd, D}),
%             {ok, Role}
%     end.

pack_combat_over(Rid, SrvId, Career, Result, #state{chief_log = OwnerLog}) ->
    Now = util:unixtime(),
    Today = util:unixtime(today),
    Time = case Now > Today + ?award_time of
        true -> Today + ?award_time + 86400 - Now;
        false -> Today + ?award_time - Now
    end,
    Reply = case lists:keyfind(Career, 1, OwnerLog) of
        false -> null;
        {_, Own} -> Own
    end,
    case role_api:lookup(by_id, {Rid, SrvId}, #role.pid) of
        {ok, _Node, Pid} ->
            role:apply(async, Pid, {fun async_combat_info/4, [Reply, Time, Result]});
        _ -> skip
    end.

async_combat_info(Role = #role{arena_career = ArenaCareer, link = #link{conn_pid=ConnPid}}, _Reply, _Time, Result) ->
    Cd = case Result of
        ?arena_career_win -> 0;
        ?arena_career_lose -> util:unixtime() + ?arena_career_cooldown
    end,
    Role1 = Role#role{arena_career = ArenaCareer#arena_career{cooldown = Cd}},
    Role2 = arena_career:log_result(Role1, Result),
    arena_career:notice_client(all, ConnPid, Role2),
    role_listener:guild_chleg(Role,{}),  %% 军团目标
    Role3 = medal:listener({competitive, Result}, Role2),
    Role4 = case erlang:is_process_alive(ConnPid) of
        true -> Role3;
        _ -> arena_career:leave_map(Role3)
    end,
    Role5 = role_listener:special_event(Role4, {1074, finish}), %% 触发完成参加中庭战神任务
    Role6 = case Result of
        ?arena_career_win -> role_listener:special_event(Role5, {2006,1});
        _ -> Role5
    end,
    log:log(log_activity_activeness, {<<"中庭战神玩法">>, 1, Role6}),
    {ok, Role6}.

% async_combat_info(Role = #role{id = {Rid, SrvId}, career = _Career, link = #link{conn_pid = ConnPid}, arena_career = #arena_career{free_count = Count1, pay_count = Count2, cooldown = CoolDown}}, Reply, Label, Time) ->
%    Now = util:unixtime(),
%    Cd = case CoolDown =:= 0 of
%        true -> 0;
%        false ->
%            case CoolDown - Now > 0 of
%                true -> CoolDown - Now;
%                false -> 0
%            end
%    end,
%    %Log = get_log_list(Rid, SrvId),
%    case arena_career:get_role_rank(Rid, SrvId) of
%        false -> {ok, Role};
%        Rank ->
%            RangeRole = arena_career:get_range(Role),
%            %sys_conn:pack_send(ConnPid, 16103, {Count1 + Count2, Cd, Rank}),
%            %sys_conn:pack_send(ConnPid, 16100, {RangeRole}),
%            %case Reply =:= null of
%            %    true -> skip;
%            %    false ->
%            %        sys_conn:pack_send(ConnPid, 16102, Reply)
%            %end,
%            %sys_conn:pack_send(ConnPid, 16108, {Label, Time}),
%            %sys_conn:pack_send(ConnPid, 16101, {Log}),
%            {ok, Role}
%    end.

% tv(#arena_career_result{fight_rid = FromRid, fight_srv_id = FromSrvId, fight_name = FromName, to_fight_rid = ToRid, to_fight_srv_id = ToSrvId, to_fight_name = ToName, result = ?arena_career_win}) -> 
%     From = notice:role_to_msg({FromRid, FromSrvId, FromName}),
%     To = notice:role_to_msg({ToRid, ToSrvId, ToName}),
%     Msg = util:fbin(?L(<<"~s战胜了~s">>), [From, To]), 
%     notice:send(63, Msg);
% tv(_) -> skip.

%% 判断是否插入
%% check_chief(1, OldRank, #arena_career_role{rid = Frid, srv_id = Fsrvid, name = Fname, career = Career}, #arena_career_role{rid = Trid, srv_id = Tsrvid, name = Tname}, State = #state{chief_log = ChiefLog}) -> %% 攻击方最后排名为1
%%     NewChiefLog = case OldRank =:= 1 of
%%         false ->
%%             From = notice:role_to_msg({Frid, Fsrvid, Fname}),
%%             To = notice:role_to_msg({Trid, Tsrvid, Tname}),
%%             CareerMsg = case Career of
%%                 ?career_zhenwu -> ?L(<<"真武">>);
%%                 ?career_cike -> ?L(<<"刺客">>);
%%                 ?career_feiyu -> ?L(<<"飞羽">>);
%%                 ?career_xianzhe -> ?L(<<"贤者">>);
%%                 ?career_qishi -> ?L(<<"骑士">>);
%%                 _ -> <<"">>
%%             end,
%%             Msg = util:fbin(?L(<<"王者诞生！~s在~s中庭战神中击败了排行第一名~s，成功夺取了师门首席之位！">>), [From, CareerMsg, To]),
%%             notice:send(53, Msg),
%%             case lists:keyfind(Career, 1, ChiefLog) of
%%                 false -> %% 当前无公告
%%                     [{Career, {Frid, Fsrvid, Fname, Trid, Tsrvid, Tname}} | ChiefLog];
%%                 {_, _Log} -> %% 已有公告 
%%                     lists:keyreplace(Career, 1, ChiefLog, {Career, {Frid, Fsrvid, Fname, Trid, Tsrvid, Tname}})
%%             end;
%%         true -> ChiefLog 
%%     end,
%%     State#state{chief_log = NewChiefLog};
%% check_chief(_, _, _, _, State) -> State.

update(#role{id = {Rid, SrvId}, career = Career, name = Name, vip = #vip{portrait_id = Face}, eqm = Eqm, looks = Looks, sex = Sex, lev = Lev, pet = PetBag, hp_max = HpMax, mp_max = MpMax, attr = Attr = #attr{fight_capacity = FightCapacity}, skill = Skill, ascend = Ascend}) ->
    arena_career_dao:update({Rid, SrvId, Name, Career, Sex, Lev, Face, HpMax, MpMax, Attr, Looks, Eqm, PetBag, Skill, FightCapacity, Ascend}).

save_result(#arena_career_role{rid = FromRid, srv_id = FromSrvId, rank = FromRank, career = FromCareer, con_wins = FromWins}, #arena_career_role{rid = ToRid, srv_id = ToSrvId, rank = ToRank, career = ToCareer, con_wins = ToWins}) ->
    arena_career_dao:save_combat_result(FromRid, FromSrvId, FromRank, FromCareer, FromWins, ToRid, ToSrvId, ToRank, ToCareer, ToWins).

insert_log(#arena_career_result{fight_rid = FromRid, fight_srv_id = FromSrvId, fight_name = FromName, to_fight_rid = ToRid, to_fight_srv_id = ToSrvId, to_fight_name = ToName, result = Result}, FromUporDown, FromRank, ToUporDown, ToRank) ->
    % send_mail(FromRid, FromSrvId, ToName, Result),
    % send_fail_mail(ToRid, ToSrvId, ToRank, ToUporDown, FromName, Result),
    Now = util:unixtime(),
    FromLog = #arena_career_log{fight_rid = FromRid, fight_srv_id = FromSrvId, fight_name = FromName, result = Result, to_fight_rid = ToRid, to_fight_srv_id = ToSrvId, to_fight_name = ToName, up_or_down = FromUporDown, rank = FromRank, ctime = Now},
    ToLog = #arena_career_log{fight_rid = FromRid, fight_srv_id = FromSrvId, fight_name = FromName, result = Result, to_fight_rid = ToRid, to_fight_srv_id = ToSrvId, to_fight_name = ToName, up_or_down = ToUporDown, rank = ToRank, ctime = Now},
    FromLogList = get_log_list(FromRid, FromSrvId),
    ToLogList = get_log_list(ToRid, ToSrvId),
    add_log(FromRid, FromSrvId, FromLogList, FromLog),
    add_log(ToRid, ToSrvId, ToLogList, ToLog).

% insert_center_log(0, #arena_career_result{fight_rid = FromRid, fight_srv_id = FromSrvId, fight_name = FromName, to_fight_rid = ToRid, to_fight_srv_id = ToSrvId, to_fight_name = ToName, result = Result}, FromUporDown, FromRank) ->
%     send_center_mail(FromRid, FromSrvId, ToName, Result),
%     Now = util:unixtime(),
%     FromLog = #arena_career_log{fight_rid = FromRid, fight_srv_id = FromSrvId, fight_name = FromName, result = Result, to_fight_rid = ToRid, to_fight_srv_id = ToSrvId, to_fight_name = ToName, up_or_down = FromUporDown, rank = FromRank, ctime = Now},
%     FromLogList = get_center_log_list(FromRid, FromSrvId),
%     add_center_log(FromRid, FromSrvId, FromLogList, FromLog);

% insert_center_log(1, #arena_career_result{fight_rid = FromRid, fight_srv_id = FromSrvId, fight_name = FromName, to_fight_rid = ToRid, to_fight_srv_id = ToSrvId, to_fight_name = ToName, result = Result}, ToUporDown, ToRank) ->
%     send_center_fail_mail(ToRid, ToSrvId, ToRank, ToUporDown, FromName, Result),
%     Now = util:unixtime(),
%     ToLog = #arena_career_log{fight_rid = FromRid, fight_srv_id = FromSrvId, fight_name = FromName, result = Result, to_fight_rid = ToRid, to_fight_srv_id = ToSrvId, to_fight_name = ToName, up_or_down = ToUporDown, rank = ToRank, ctime = Now},
%     ToLogList = get_center_log_list(ToRid, ToSrvId),
%     add_center_log(ToRid, ToSrvId, ToLogList, ToLog).

get_log_list(Rid, SrvId) -> 
    case ets:lookup(ets_arena_career_log, {Rid, SrvId}) of
        [] -> [];
        [{_, IR}] -> IR;
        _ -> [] 
    end.
% get_center_log_list(Rid, SrvId) ->
%     case ets:lookup(ets_c_arena_career_log, {Rid, SrvId}) of
%         [] -> [];
%         [{_, IR}] -> IR;
%         _ -> []
%     end.
% add_center_log(Rid, SrvId, LogList, Log) ->
%     NewLogList = lists:sublist([Log | LogList], 5),
%     ets:insert(ets_c_arena_career_log, {{Rid, SrvId}, NewLogList}).

add_log(Rid, SrvId, LogList, Log) ->
    NewLogList = lists:sublist([Log | LogList], 10),
    ets:insert(ets_arena_career_log, {{Rid, SrvId}, NewLogList}).

% add_center_honor(RoleList) ->
%     H20180 = [{{Rid, SrvId}, 20180}  || {Rid, SrvId, Rank, _} <- RoleList, Rank =:= 1],
%     H20181 = [{{Rid, SrvId}, 20181} || {Rid, SrvId, Rank, _} <- RoleList, Rank >= 2 andalso Rank =< 5],
%     H20182 = [{{Rid, SrvId}, 20182} || {Rid, SrvId, Rank, _} <- RoleList, Rank >= 6 andalso Rank =< 10],
%     H20183 = [{{Rid, SrvId}, 20183} || {Rid, SrvId, Rank, _} <- RoleList, Rank >= 11 andalso Rank =< 20],
%     H20184 = [{{Rid, SrvId}, 20184} || {Rid, SrvId, Rank, _} <- RoleList, Rank >= 21 andalso Rank =< 30],
%     honor_mgr:replace_honor_gainer(cross_arena_career_1, H20180),
%     honor_mgr:replace_honor_gainer(cross_arena_career_2, H20181),
%     honor_mgr:replace_honor_gainer(cross_arena_career_3, H20182),
%     honor_mgr:replace_honor_gainer(cross_arena_career_4, H20183),
%     honor_mgr:replace_honor_gainer(cross_arena_career_5, H20184).

% add_honor(AwardList) -> 
%     add_honor(AwardList, []).
% add_honor([], Honor) ->
%     do_add_honor(Honor);
% add_honor([{Rid, SrvId, Rank, Career, _, _} | T], Honor) when Rank =:= 2 orelse Rank =:= 3 ->
%     LabelId = case Career of
%         ?career_zhenwu ->  20158;
%         ?career_xianzhe -> 20159;
%         ?career_cike -> 20160;
%         ?career_feiyu ->   20161;
%         ?career_qishi -> 20162
%     end,
%     NewHonor = case lists:keyfind(Career, 1, Honor) of
%         false ->
%             [{Career, [{{Rid, SrvId}, LabelId}]} | Honor];
%         {_, List} ->
%             lists:keyreplace(Career, 1, Honor, {Career, [{{Rid, SrvId}, LabelId} | List]})
%     end,
%     add_honor(T, NewHonor);
% add_honor([_X | T], Honor) ->
%     add_honor(T, Honor).
% 
% do_add_honor([]) -> ok;
% do_add_honor([{Career, List} | T]) ->
%     case Career of
%         ?career_zhenwu -> 
%             honor_mgr:replace_honor_gainer(arena_career_1, List); 
%         ?career_xianzhe ->
%             honor_mgr:replace_honor_gainer(arena_career_2, List); 
%         ?career_cike ->
%             honor_mgr:replace_honor_gainer(arena_career_3, List); 
%         ?career_feiyu ->
%             honor_mgr:replace_honor_gainer(arena_career_4, List); 
%         ?career_qishi ->
%             honor_mgr:replace_honor_gainer(arena_career_5, List); 
%         _ -> skip
%     end,
%     do_add_honor(T).

% find_award([], _, _) -> false;
% find_award([{Rid, SrvId, Rank, _Career, Lev, ?false} | _T], Rid, SrvId) -> {true, Rank, Lev};
% find_award([_ | T], Rid, SrvId) -> find_award(T, Rid, SrvId).

% find_center_role(AwardList) ->
%     find_center_role(AwardList, []).
% find_center_role([], CenterRole) -> CenterRole;
% find_center_role([{Rid, SrvId, Rank, _Career, _, _} | T], CenterRole) when Rank >= 1 andalso Rank =< 5 ->
%     case arena_career_dao:get_role_info(Rid, SrvId) of
%         {true, R = {_, _, _, _, _, _, Lev, _, _, _, _, _, _, _, _, FightCapacity, _}}
%         when Lev >= 50 andalso FightCapacity >= 8000 ->
%             find_center_role(T, [R | CenterRole]);
%         {true, _} ->
%             ?DEBUG("未达到资格,无法参与跨服"),
%             find_center_role(T, CenterRole);
%         _X ->
%             ?ERR("统计本服参加跨服名单取角色信息失败,Reason:~w",[_X]),
%             find_center_role(T, CenterRole)
%     end;
% find_center_role([_ | T], CenterRole) -> find_center_role(T, CenterRole).

% modify_award(AwardList, Rid, SrvId) ->
%     modify_award(AwardList, Rid, SrvId, []).
% modify_award([], _, _, NewAwardList) -> NewAwardList;
% modify_award([{Rid, SrvId, Rank, Lev, _} | T], Rid, SrvId, NewAwardList) ->
%     T ++ [{Rid, SrvId, Rank, Lev, ?true}] ++ NewAwardList;
% modify_award([Award | T], Rid, SrvId, NewAwardList) ->
%     modify_award(T, Rid, SrvId, [Award | NewAwardList]).
% 
%% 返回本服角色
% get_local_role(TableList) ->
%     get_local_role(TableList, []).
% get_local_role([], LocalRole) -> LocalRole;
% get_local_role([{Rid, SrvId, Rank, Lev} | T], LocalRole) ->
%     case role_api:is_local_role(SrvId) of
%         true ->
%             get_local_role(T, [{Rid, SrvId, Rank, Lev} | LocalRole]);
%         false ->
%             get_local_role(T, LocalRole)
%     end.

%% 发送跨服列表
% send_award_mail([]) -> ok;
% send_award_mail([{Rid, SrvId, Rank, Lev} | T]) ->
%     send_award_mail(Rid, SrvId, Rank, Lev),
%     send_award_mail(T).

%% 发送跨服奖励邮件
% send_award_mail(Rid, SrvId, Rank, Lev) ->
%     Label = ?L(<<"跨服竞技排位奖励">>),
%     Exp = erlang:round(40000 * Lev / (math:pow(Rank, 0.4))),
%     Coin = erlang:round(3000000 / math:pow(Rank, 0.4)),
%     Msg = util:fbin(?L(<<"恭喜您在跨服竞技中排在第~w位，获得了~w绑定金币 ~w经验。">>),[Rank, Coin, Exp]),
%     case mail:send_system({Rid, SrvId},
%             {Label, Msg, [{?mail_coin_bind, Coin}, {?mail_exp, Exp}], []}) of
%         ok -> ok;
%         {false, _R} ->
%             ?ERR("跨服竞技排位发送邮件失败:id:~w,SrvId:~s 原因:~p",[Rid, SrvId, _R]),
%             false 
%     end.

% make_list([], Items) -> Items;
% make_list([{BaseId, Num} | T], Items) ->
%     case item:make(BaseId, 1, Num) of
%         false -> make_list(T, Items);
%         {ok, MakeItems} ->
%             make_list(T, MakeItems ++ Items)
%     end.

%% 发送活动邮件
% send_camp_mail([]) -> skip;  
% send_camp_mail([{Rid, SrvId, Rank, _} | T]) when Rank =< 100 ->
%     Label = ?L(<<"巅峰对决，跨服竞技">>),
%     ItemList = make_list([{32303, 3}, {22243, 1}], []),
%     Msg = util:fbin(?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。第一次跨服竞技结束，您的排名为~w，赢得百名高手大奖，请注意查收，祝您游戏愉快！">>), [Rank]),
%     case mail:send_system({Rid, SrvId},
%            {Label, Msg, [], ItemList}) of
%         ok -> ok;
%         {false, _R} ->
%             ?ERR("跨服竞技百名大奖发送邮件失败:id:~w,SrvId:~s 原因:~p",[Rid, SrvId, _R]),
%             false 
%     end,
%     send_camp_mail(T);
% send_camp_mail([_ | T]) ->
%        send_camp_mail(T).
% 
% %% 发送幸运邮件
% send_luck_mail([], _LuckNum) -> skip;  
% send_luck_mail([{Rid, SrvId, Rank, _} | T], LuckNum) ->
%     case Rank rem 10 =:= LuckNum of
%         true ->
%             Label = ?L(<<"巅峰对决，跨服竞技">>),
%             ItemList = make_list([{27003, 3}, {32512, 2}, {24121, 1}], []),
%             Msg = util:fbin(?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。第一次跨服竞技结束，您的排名为~w，恭喜您获得幸运尾数奖励，请注意查收，祝您游戏愉快！">>), [Rank]),
%             case mail:send_system({Rid, SrvId},
%                     {Label, Msg, [], ItemList}) of
%                 ok -> ok;
%                 {false, _R} ->
%                     ?ERR("跨服竞技幸运号发送邮件失败:id:~w,SrvId:~s 原因:~p",[Rid, SrvId, _R]),
%                     false 
%             end;
%         false -> skip
%     end,
%     send_luck_mail(T, LuckNum).

% send_center_mail(Rid, SrvId, ToName, ?arena_career_win) ->
%     Label = ?L(<<"跨服竞技挑战奖励">>),
%     Msg = util:fbin(?L(<<"恭喜您在跨服竞技中成功击败了【~s】，获得了2000绑定金币 2000经验 10阅历。请再接再厉。跨服排名奖励将定时结算，排名越靠前，奖励越丰厚！">>),[ToName]),
%     case mail:send_system({Rid, SrvId},
%             {Label, Msg, [{?mail_coin_bind, 2000}, {?mail_exp, 2000}, {?mail_attainment, 10}], []}) of
%         ok -> ok;
%         {false, _R} ->
%             ?ERR("跨服竞技发送邮件失败:id:~w,SrvId:~s 原因:~p",[Rid, SrvId, _R]),
%             false 
%     end;
% send_center_mail(Rid, SrvId, ToName, ?arena_career_lose) ->
%     Label = ?L(<<"跨服竞技挑战奖励">>),
%     Msg = util:fbin(?L(<<"很遗憾，您在跨服竞技中挑战【~s】，技逊一筹未能获胜，您获得了1000绑定金币 1000经验奖励。">>),[ToName]),
%     case mail:send_system({Rid, SrvId},
%             {Label, Msg, [{?mail_coin_bind, 1000}, {?mail_exp, 1000}], []}) of
%         ok -> ok;
%         {false, _R} ->
%             ?ERR("跨服竞技发送邮件失败:id:~w, SrvId:~s 原因:~p",[Rid, SrvId, _R]),
%             false 
%     end.

% send_mail(Rid, SrvId, ToName, ?arena_career_win) ->
%     Label = ?L(<<"中庭战神挑战奖励">>),
%     Msg = util:fbin(?L(<<"恭喜您在中庭战神中成功击败了【~s】，获得了2000绑定金币 2000经验 10阅历。请再接再厉。师门排名奖励将在每天18点结算，排名越靠前，奖励越丰厚！">>),[ToName]),
%     case mail:send_system({Rid, SrvId},
%             {Label, Msg, [{?mail_coin_bind, 2000}, {?mail_exp, 2000}, {?mail_attainment, 10}], []}) of
%         ok -> ok;
%         {false, _R} ->
%             ?ERR("中庭战神发送邮件失败:id:~w,SrvId:~s 原因:~p",[Rid, SrvId, _R]),
%             false 
%     end;
% send_mail(Rid, SrvId, ToName, ?arena_career_lose) ->
%     Label = ?L(<<"中庭战神挑战奖励">>),
%     Msg = util:fbin(?L(<<"很遗憾，您在中庭战神中挑战【~s】，技逊一筹未能获胜，您获得了1000绑定金币 1000经验奖励。">>),[ToName]),
%     case mail:send_system({Rid, SrvId},
%             {Label, Msg, [{?mail_coin_bind, 1000}, {?mail_exp, 1000}], []}) of
%         ok -> ok;
%         {false, _R} ->
%             ?ERR("中庭战神发送邮件失败:id:~w, SrvId:~s 原因:~p",[Rid, SrvId, _R]),
%             false 
%     end.

% send_center_fail_mail(Rid, SrvId, _Rank, ?arena_career_rank_normal, FromName, ?arena_career_win) ->
%     Label = ?L(<<"跨服竞技挑战">>),
%     Msg = util:fbin(?L(<<"【~s】趁您不备，在跨服竞技中击败了您！您的师门排名不变。">>),[FromName]),
%     case mail:send_system({Rid, SrvId},
%             {Label, Msg, [], []}) of
%         ok -> ok;
%         {false, _R} ->
%             ?ERR("跨服竞技发送邮件失败:id:~w, SrvId:~s 原因:~p",[Rid, SrvId, _R]),
%             false 
%     end;
% send_center_fail_mail(Rid, SrvId, Rank, ?arena_career_rank_down, FromName, ?arena_career_win) ->
%     Label = ?L(<<"跨服竞技挑战">>),
%     Msg = util:fbin(?L(<<"【~s】趁您不备，在跨服竞技中击败了您！您的师门排名降为~w名。">>),[FromName, Rank]),
%     case mail:send_system({Rid, SrvId},
%             {Label, Msg, [], []}) of
%         ok -> ok;
%         {false, _R} ->
%             ?ERR("跨服竞技发送邮件失败:id:~w, SrvId:~s 原因:~p",[Rid, SrvId, _R]),
%             false 
%     end;
% send_center_fail_mail(_, _, _, _, _, _) -> skip.

% send_fail_mail(Rid, SrvId, _Rank, ?arena_career_rank_normal, FromName, ?arena_career_win) ->
%     Label = ?L(<<"中庭战神挑战">>),
%     Msg = util:fbin(?L(<<"【~s】趁您不备，在中庭战神中击败了您！您的师门排名不变。">>),[FromName]),
%     case mail:send_system({Rid, SrvId},
%             {Label, Msg, [], []}) of
%         ok -> ok;
%         {false, _R} ->
%             ?ERR("中庭战神发送邮件失败:id:~w, SrvId:~s 原因:~p",[Rid, SrvId, _R]),
%             false 
%     end;
% send_fail_mail(Rid, SrvId, Rank, ?arena_career_rank_down, FromName, ?arena_career_win) ->
%     Label = ?L(<<"中庭战神挑战">>),
%     Msg = util:fbin(?L(<<"【~s】趁您不备，在中庭战神中击败了您！您的师门排名降为~w名。">>),[FromName, Rank]),
%     case mail:send_system({Rid, SrvId},
%             {Label, Msg, [], []}) of
%         ok -> ok;
%         {false, _R} ->
%             ?ERR("中庭战神发送邮件失败:id:~w, SrvId:~s 原因:~p",[Rid, SrvId, _R]),
%             false 
%     end;
% send_fail_mail(_, _, _, _, _, _) -> skip.

%% @spec day_diff(UnixTime, UnixTime) -> int()
%% @doc 两个unixtime相差的天数,相邻2天返回1
%% return int() 相差的天数
% day_diff(FromTime, ToTime) when ToTime > FromTime ->
%     FromDate = util:unixtime({today, FromTime}),
%     ToDate = util:unixtime({today, ToTime}),
%     case (ToDate - FromDate) / (3600 * 24) of
%         Diff when Diff < 0 -> 0;
%         Diff -> round(Diff)
%     end;
% 
% day_diff(FromTime, ToTime) when ToTime=:=FromTime ->
%     0;
% 
% day_diff(FromTime, ToTime) ->
%     day_diff(ToTime, FromTime).

timer(Time, Msg) ->
    ?DEBUG("~p秒后发送~p", [Time, Msg]),
    Ref = erlang:send_after(erlang:max(0, round(Time) * 1000), self(), Msg),
    put({timer, Msg}, Ref).

do_active_award() ->
    case arena_career_dao:active_award() of
        {ok, _} -> ignore;
        Else -> catch ?ERR("error: ~p", [Else])
    end.

do_send_award_queue() ->
    case arena_career_dao:get_next_award_queue() of
        {ok, []} ->
            stop;
        {ok, List} ->
            lists:foreach(fun([RoleId, SrvId, Rank]) ->
                case arena_career_dao:fetch_award({RoleId, SrvId}) of
                    true ->
                        {Stone, Gold} = arena_career:calc_award(Rank),
                        GainStone = case Stone > 0 of
                            true -> [#gain{label = stone, val = Stone}];
                            false -> []
                        end,
                        GainGold = case Gold > 0 of
                            true -> [#gain{label = gold, val = Gold}];
                            false -> []
                        end,
                        ?DEBUG("send award ~p ~p", [{RoleId, SrvId}, GainStone ++ GainGold]),
                        case GainStone ++ GainGold of
                            [] -> ignore;
                            Gains ->
                                award:send({RoleId, SrvId}, ?arena_career_award_id, Gains)
                        end;
                    _ ->
                        ignore
                end
            end, List),
            next;
        _Else ->
            catch ?ERR("error: ~p", [_Else]),
            next
    end.

% do_send_wins_award() ->
%     case arena_career_dao:get_wins_rank_range(1, 50) of
%         {ok, List} ->
%             {Rank1, After1} = list_split(1, List),
%             do_send_wins_award(Rank1, xxx),
%             {Rank2, After2} = list_split(1, After1),
%             do_send_wins_award(Rank2, xxx),
%             {Rank3, After3} = list_split(1, After2),
%             do_send_wins_award(Rank3, xxx),
%             {Top4_10, After10} = list_split(7, After3),
%             do_send_wins_award(Top4_10, yyy),
%             {Top11_20, After20} = list_split(10, After10),
%             do_send_wins_award(Top11_20, zzz),
%             {Top21_50, _After50} = list_split(30, After20),
%             do_send_wins_award(Top21_50, zzz),
%             ok;
%         _Error ->
%             ?ERR("~p", [_Error])
%     end.
% 
% do_send_wins_award([[_RoleId, _SrvId]|T], AwardBaseId) ->
%     %award:send() 
%     do_send_wins_award(T, AwardBaseId);
% do_send_wins_award([], _AwardBaseId) ->
%     ok.
%
% list_split(N, List) when N > length(List) ->
%     {List, []};
% list_split(N, List) ->
%     lists:split(N, List).
% 

notice_con_wins(_Winner, WinnerName, WinnerWins, Loser, LoserName, _LoserWins) ->
    case WinnerWins > 0 andalso WinnerWins rem 5 =:= 0 of
        true -> 
            Msg = util:fbin(?L(<<"超神了！~s在中庭战神中连续胜利了~s次">>), 
                    [WinnerName, ?notify_color_num(WinnerWins)]),
            notice:rumor(Msg);
        false ->
            ignore
    end,
    case Loser#arena_career_role.con_wins >= 5 of
        true -> 
            Msg1 = util:fbin(?L(<<"~s在中庭战神中完美绝杀，终结了~s的~s连胜！">>), 
                    [WinnerName, LoserName, ?notify_color_num(Loser#arena_career_role.con_wins)]),
            notice:rumor(Msg1);
        false ->
            ignore
    end.

do_update_wins_rank() ->
    case calendar:day_of_the_week(erlang:date()) of
        1 ->
            db:execute("UPDATE sys_arena_career SET max_con_wins=0, con_wins=0");
        _ ->
            ignore
    end.
