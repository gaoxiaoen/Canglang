%%----------------------------------------------------
%% @doc 竞技场管理进程
%%
%% @author mobin
%% @end
%%----------------------------------------------------
-module(compete_mgr).

-behaviour(gen_fsm).

%%外部方法
-export([
        start_link/0
        ,login/1
        ,logout/1
        ,role_switch/1
        ,push_status/1
        ,get_status/1
        ,get_today_honor/1
        ,get_buff_count/1
        ,get_hall/0
        ,sign_up/3
        ,cancel_match/2
        ,combat_over/2
        ,add_enter_count/1
        ,get_left_count/1
        ,set_left_time/1
        ,set_matching_queue_print_flag/1
    ]
).

%%状态
-export([
        idle/2,
        active/2
    ]
).

-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-include("common.hrl").
-include("role.hrl").
-include("assets.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("pos.hrl").
-include("hall.hrl").
-include("combat.hrl").
-include("role_online.hrl").

-include("compete_config.hrl").
-include("compete_lang.hrl").
-include("compete.hrl").
-include("unlock_lev.hrl").

-record(state, {
        begin_time,
        duration,
        hall
    }
).

-define(match_time1, 8000).     %% 匹配队伍的间隔时间（毫秒）
-define(match_time2, 6000).     %% 匹配队伍的间隔时间（毫秒）
-define(prepare_combat_time, 6 * 1000).    %% 等待进入战斗的时间
-define(clear_map_timer, 5 * 1000).    %% 清除地图的时间
-define(map_base_id, 1038).

-define(offline_award_id, 109008).
-define(max_buff_count, 5).

%%------------------------------------------------------
%% 外部方法
%%------------------------------------------------------
start_link() ->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 登陆
login(Role = #role{id = Rid, pid = Pid, link = #link{conn_pid = ConnPid}, event = ?event_compete,
        pos = #pos{last = {MapId, X, Y}}, hall = #role_hall{id = HallId}}) ->
    push_status(Role),
    case ets:lookup(compete_role, Rid) of
        [SignupRole = #sign_up_role{status = _Status, hall_id = HallId}] ->
            ets:insert(compete_role, SignupRole#sign_up_role{pid = Pid, conn_pid = ConnPid}),
            hall:role_login(HallId, #hall_role{id = Rid, pid = Pid, conn_pid = ConnPid}),
            Role;
        _ ->
            case HallId =/= 0 of
                true ->
                    hall:login_leave(HallId, Role);
                false ->
                    ignore
            end,
            Role#role{event = ?event_no, event_pid = 0, pos = #pos{map = MapId, x = X, y = Y}, hall = #role_hall{}}
    end;
login(Role) ->
    push_status(Role),
    Role.

logout(Role = #role{id = Rid, event = ?event_compete}) ->
    Role2 = case ets:lookup(compete_role, Rid) of
        [SignupRole = #sign_up_role{status = Status}] ->
            gen_fsm:send_all_state_event(?MODULE, {logout, SignupRole}),
            %%匹配中掉线要置event 为hall
            case Status of
                ?compete_status_teammate ->
                    Role#role{event = ?event_hall};
                ?compete_status_team ->
                    Role#role{event = ?event_hall};
                _ ->
                    Role
            end;
        _ ->
            %%由login来处理event
            Role
    end,
    {ok, delete_buff(Role2)};
logout(Role) ->
    {ok, delete_buff(Role)}.

role_switch(Role = #role{id = Rid, pid = Pid, event = ?event_compete, link = #link{conn_pid = ConnPid}}) ->
    case ets:lookup(compete_role, Rid) of
        [SignupRole = #sign_up_role{hall_id = HallId}] ->
            ets:insert(compete_role, SignupRole#sign_up_role{pid = Pid, conn_pid = ConnPid}),
            hall:role_login(HallId, #hall_role{id = Rid, pid = Pid, conn_pid = ConnPid});
        _ ->
            ignore
    end,
    Role;
role_switch(Role) ->
    Role.

push_status(#role{id = Rid, lev = Lev, link = #link{conn_pid = ConnPid}, compete = Compete}) ->
    UnlockLev = ?compete_unlock_lev,
    case Lev < UnlockLev of 
        true ->
            ignore;
        false ->
            LeftCount = get_left_count(Compete),
            TodayHonor = get_today_honor(Rid),
            BuffCount = get_buff_count(Rid),
            gen_fsm:send_all_state_event(?MODULE, {push_status, ConnPid, LeftCount, TodayHonor, BuffCount})
    end.

get_status(ConnPid) ->
    gen_fsm:send_all_state_event(?MODULE, {get_status, ConnPid}).

get_today_honor(Rid) ->
    case ets:lookup(compete_rank, Rid) of
        [#compete_rank{honor = Honor}] ->
            Honor;
        _ ->
            0
    end.

get_buff_count(Rid) ->
    case ets:lookup(compete_buff, Rid) of
        [{_, Count}] ->
            Count;
        _ ->
            0
    end.

get_hall() ->
    gen_fsm:sync_send_all_state_event(?MODULE, {get_hall}).

sign_up(HallId, RoomNo, HallRoles) ->
    SignupRoles = lists:map(fun(HallRole) ->
                to_sign_up_role(HallId, RoomNo, HallRole)
        end, HallRoles),
    gen_fsm:send_event(?MODULE, {sign_up, SignupRoles}).

cancel_match(Rid, ConnPid) ->
    gen_fsm:send_all_state_event(?MODULE, {cancel_match, Rid, ConnPid}).

combat_over(Winner, Loser) ->
    gen_fsm:send_all_state_event(?MODULE, {combat_over, Winner, Loser}).
    
add_enter_count(Role = #role{id = Rid, compete = {EnterCount, Last}}) ->
    EnterCount2 = case Last >= util:unixtime({today, util:unixtime()}) of
        true ->
            EnterCount + 1;
        false ->
            1
    end,
    %%第10次时发放奖励
    case EnterCount2 =:= 10 of
        true ->
            award:send(Rid, 109007);
        false ->
            ignore
    end,
    {ok, Role#role{compete = {EnterCount2, util:unixtime()}}}.

get_left_count({EnterCount, Last}) ->
    case Last >= util:unixtime({today, util:unixtime()}) of
        true ->
            ?compete_limit_count - EnterCount;
        false ->
            ?compete_limit_count
    end.


%% 设置Timeout时间
set_left_time(LeftTime) ->
    gen_fsm:sync_send_all_state_event(?MODULE, {set_left_time, LeftTime}).

%% 设置待匹配队列打印标记
%% Flag = true | false
set_matching_queue_print_flag(Flag) ->
    gen_fsm:sync_send_all_state_event(?MODULE, {set_matching_queue_print_flag, Flag}).
    
%%------------------------------------------------------
%% 状态机消息处理
%%------------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true), 
    
    %% 启动一个保存参加竞技场的每个角色的信息的ets
    ets:new(compete_role, [set, named_table, public, {keypos, #sign_up_role.id}]),
    %%死亡Buff {Rid, BuffCount}
    ets:new(compete_buff, [set, named_table, public, {keypos, 1}]),

    %%put(matching_queue_print_flag, true),

    %%开服第二天开启
    {StateName, State} = case can_open() of
        true ->
            case is_in_active(?start_time_list) of
                false ->
                    Duration = get_start_duration(?start_time_list, lists:nth(1, ?start_time_list)),
                    {idle, #state{begin_time = erlang:now(), duration = Duration}};
                LeftTime ->
                    _State = change_to_active(#state{}),
                    {active, _State#state{duration = LeftTime * 1000}}
            end;
        false ->
            Duration = get_tomorrow_duration(lists:nth(1, ?start_time_list)),
            {idle, #state{begin_time = erlang:now(), duration = Duration}}
    end,
    #state{begin_time = BeginTime, duration = Duration2} = State,

    ?INFO("[~w] 启动完成...", [?MODULE]),
    {ok, StateName, State, util:time_left(Duration2, BeginTime)}.

handle_event({get_status, ConnPid}, StateName, State) ->
    Reply = case StateName of
        idle ->
            ?false;
        _ ->
            ?true
    end,
    sys_conn:pack_send(ConnPid, 16200, {Reply}),
    continue(StateName, State);

handle_event({push_status, ConnPid, LeftCount, TodayHonor, BuffCount}, StateName, State) ->
    Status = case StateName of
        idle ->
            ?false;
        _ ->
            ?true
    end,
    sys_conn:pack_send(ConnPid, 16201, {Status, LeftCount, TodayHonor, BuffCount}),
    continue(StateName, State);

handle_event({cancel_match, Rid, ConnPid}, StateName, State) ->
    ?DEBUG("收到取消匹配请求[~w]", [Rid]),
    
    case ets:lookup(compete_role, Rid) of
        [SignupRole = #sign_up_role{status = Status, is_leader = ?true}] ->
            case Status of
                ?compete_status_teammate ->
                    %%匹配队友中
                    cancel_match_teammate(SignupRole);
                ?compete_status_team ->
                    cancel_match_team(SignupRole);
                _ ->
                    sys_conn:pack_send(ConnPid, 16203, {?false})
            end;
        _ ->
            sys_conn:pack_send(ConnPid, 16203, {?false})
    end,
    continue(StateName, State);

handle_event({logout, SignupRole = #sign_up_role{id = Rid, status = Status, hall_id = HallId}}, StateName, State) ->
    ?DEBUG("竞技场收到下线请求[~w]", [Rid]),
    case Status of
        ?compete_status_teammate ->
            %%匹配队友中
            cancel_match_teammate(SignupRole);
        ?compete_status_team ->
            cancel_match_team(SignupRole);
        _ ->
            %%匹配成功后掉线不需要特殊处理
            ignore 
    end,
    hall:role_logout(HallId, #hall_role{id = Rid}),
    continue(StateName, State);

handle_event({combat_over, Winner, Loser}, StateName, State) ->
    WinnerInfos = [{{RoleId, SrvId}, IsDie} || #fighter{rid = RoleId, srv_id = SrvId, is_die = IsDie} <- Winner],
    LoserInfos = [{{RoleId, SrvId}, IsDie} || #fighter{rid = RoleId, srv_id = SrvId, is_die = IsDie} <- Loser],
    deal_combat_result(?combat_result_win, WinnerInfos),
    deal_combat_result(?combat_result_lost, LoserInfos),

    Rids = [Rid || {Rid, _} <- WinnerInfos ++ LoserInfos],

    clear_matched_info(Rids),
    continue(StateName, State);

handle_event(_Event, StateName, State) ->
    ?DEBUG("在[~w]状态下收到无效事件:~w", [StateName, _Event]),
    continue(StateName, State).

handle_sync_event({get_hall}, _From, StateName, State = #state{hall = Hall}) ->
    Reply = case StateName of
        active ->
            {ok, Hall};
        _ ->
            ok
    end,
    continue(Reply, StateName, State);

%% 设置Timeout时间
handle_sync_event({set_left_time, LeftTime}, _From, StateName, State) ->
    Duration = LeftTime * 1000,
    ?INFO("竞技场 [~w] 时间更新成功:~w", [StateName, Duration]),
    continue(ok, StateName, State#state{begin_time = erlang:now(), duration = Duration});

handle_sync_event({set_matching_queue_print_flag, Flag}, _From, StateName, State) ->
    ?INFO("竞技场设置待匹配队列打印标记:~w", [Flag]),
    put(matching_queue_print_flag, Flag),
    continue(ok, StateName, State);

handle_sync_event(_Event, _From, StateName, State) ->
    ?DEBUG("在[~w]状态下收到无效事件:~w", [StateName, _Event]),
    continue(ignore, StateName, State).

handle_info(match, active, State) ->
    match_teammate(),
    match_team(),
    erlang:send_after(?match_time2, self(), match),
    continue(active, State);

handle_info({start_combat, #sign_up_team{id = Rids1}, #sign_up_team{id = Rids2}}, StateName, State) ->
    Rids = Rids1 ++ Rids2,
    ?DEBUG("[~w]开始竞技场战斗", [Rids]),
    {L1, Fails1} = roles_to_fighters(Rids1, [], []),
    {L2, Fails2} = roles_to_fighters(Rids2, [], []),
    FailedRids = Fails1 ++ Fails2,
    if
        length(L1) > 0 andalso length(L2) > 0 ->
            case combat:start(?combat_type_compete, L1, L2) of
                {ok, _CombatPid} ->
                    case length(FailedRids) > 0 of
                        true ->
                            ?DEBUG("[~w]参加竞技场战斗失败", [FailedRids]),
                            start_combat_failed(?combat_result_lost, FailedRids);
                        false ->
                            ignore
                    end;
                _Why ->
                    ?ERR("[~w]和[~w]发起战斗失败:~w", [Rids1, Rids2, _Why]),
                    start_combat_failed(?combat_result_lost, Rids),
                    clear_matched_info(Rids)
            end;
        length(L1) > 0 andalso length(L2) =< 0 ->
            ?ERR("[~w]和[~w]发起战斗失败，[~w]方参战失败，失败的有:~w", [Rids1, Rids2, Rids2, FailedRids]),
            start_combat_failed(?combat_result_win, Rids1),
            start_combat_failed(?combat_result_lost, Rids2),
            clear_matched_info(Rids);
        length(L1) =< 0 andalso length(L2) > 0 ->
            ?ERR("[~w]和[~w]发起战斗失败，[~w]方参战失败，失败的有:~w", [Rids1, Rids2, Rids1, FailedRids]),
            start_combat_failed(?combat_result_lost, Rids1),
            start_combat_failed(?combat_result_win, Rids2),
            clear_matched_info(Rids);
        true ->
            ?ERR("[~w]和[~w]发起战斗失败，双方参战失败", [Rids1, Rids2]),
            start_combat_failed(?combat_result_lost, Rids),
            clear_matched_info(Rids)
    end,
    continue(StateName, State);

handle_info({clear_matched_map, Rid}, StateName, State) ->
    clear_matched_map(Rid),
    continue(StateName, State);

handle_info(clean_up, StateName, State = #state{hall = Hall}) ->
    ets:delete_all_objects(compete_role),
    ets:delete_all_objects(compete_buff),
    
    compete_rank:stop_activity(),

    %%清地图，大厅
    clear_all_matched_map(),

    case Hall of
        #hall{pid = HallPid} ->
            hall:stop(HallPid);
        _ ->
            ignore
    end,
    put(matched_rooms, []),
    continue(StateName, State#state{hall = undefined});

handle_info(_Info, StateName, State) ->
    ?DEBUG("在[~w]状态下收到无效消息:~w", [StateName, _Info]),
    continue(StateName, State).

terminate(_Reason, _StateName, _State) ->
    ok.
    
code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%%----------------------------------------------------
%% 状态处理
%%----------------------------------------------------
%% 空闲时间
idle({sign_up, SignupRoles}, State) ->
    lists:foreach(fun(#sign_up_role{conn_pid = ConnPid, 
                    is_leader = IsLeader, hall_id = HallId, room_no = RoomNo}) ->
                case IsLeader of
                    ?true ->
                        %%回到房间
                        hall:room_end_combat(HallId, RoomNo, false);
                    _ ->
                        ignore
                end,
                notice:alert(error, ConnPid, ?MSGID(<<"2V2匹配竞技已结束，敬请期待下次开放吧">>))
        end, SignupRoles),
    continue(idle, State);
idle(timeout, State) ->
    State2 = change_to_active(State),
    continue(active, State2);
idle(_Any, State) ->
    continue(idle, State).

active({sign_up, SignupRoles}, State) ->
    %%防止重复加入
    lists:foreach(fun(#sign_up_role{id = Rid}) ->
                remove_from_teammate_queue(Rid),
                remove_from_team_queue(Rid)
        end, SignupRoles),

    Status = case length(SignupRoles) =:= 1 of
        true ->
            [_SignupRole = #sign_up_role{id = _Rid, name = _Name}] = SignupRoles,
            put(teammate_queue, [_SignupRole | get(teammate_queue)]),

            ?DEBUG("[~w][~w]成功加到匹配队友队列", [_Rid, _Name]),
            ?compete_status_teammate;
        false ->
            [SignupRole1, SignupRole2] = SignupRoles,
            Team = combine_teammates(SignupRole1, SignupRole2),
            put(team_queue, [Team | get(team_queue)]),

            ?DEBUG("成功加到匹配对手队列", []),
            ?compete_status_team
    end,

    %%回写角色event
    lists:foreach(fun(SignupRole = #sign_up_role{pid = RolePid, conn_pid = ConnPid}) ->
                sys_conn:pack_send(ConnPid, 16204, {Status}),
                ets:insert(compete_role, SignupRole#sign_up_role{status = Status}),

                role:apply(async, RolePid, {fun async_sign_up/1, []})
        end, SignupRoles),
    continue(active, State);
active(timeout, State) ->
    %%取消所有匹配
    TeammateQueue = get(teammate_queue),
    lists:foreach(fun(#sign_up_role{id = Rid}) ->
                notify_match_failed(Rid)
        end, TeammateQueue),
    put(teammate_queue, []),

    TeamQueue = get(team_queue),
    lists:foreach(fun(#sign_up_team{id = Rids}) ->
                notify_match_failed(Rids)
        end, TeamQueue),
    put(team_queue, []),

    %%传闻
    Msg = util:fbin(?compete_end, []),
    role_group:pack_cast(world, 10932, {7, 1, Msg}),

    %%推送状态
    broadcast_status(?false),

    %% 活动结束后一段时间内清除数据
    erlang:send_after(1000 * 60 * 10, self(), clean_up),

    Duration = get_start_duration(?start_time_list, lists:nth(1, ?start_time_list)),
    continue(idle, State#state{begin_time = erlang:now(), duration = Duration});
active(_Any, State) ->
    continue(active, State).

%%------------------------------------------------------
%% 内部方法
%%------------------------------------------------------
continue(Reply, StateName, State = #state{begin_time = BeginTime, duration = Duration}) ->
    {reply, Reply, StateName, State, util:time_left(Duration, BeginTime)}.
continue(StateName, State = #state{begin_time = BeginTime, duration = Duration}) ->
    {next_state, StateName, State, util:time_left(Duration, BeginTime)}.

get_start_duration([], FirstTime) ->
    get_tomorrow_duration(FirstTime);
get_start_duration([H | T], FirstTime) ->
    case get_duration(H) of
        0 ->
            get_start_duration(T, FirstTime);
        Duration ->
            Duration
    end.

%%获取距离下一次活动的剩余时间，错过了则返回0
get_duration({Hour, Min, Sec}) ->
    Now = util:unixtime(),

    Today = util:unixtime({today, Now}),
    Time = Hour * 3600 + Min * 60 + Sec,
    Duration = case (Today + Time) > Now of
        true -> 
            Today + Time - Now;
        false ->
            0
    end,
    Duration * 1000.

get_tomorrow_duration({Hour, Min, Sec}) ->
    Now = util:unixtime(),
    Tomorrow = util:unixtime({tomorrow, Now}),
    Time = Hour * 3600 + Min * 60 + Sec,

    Duration = Tomorrow + Time - Now,
    Duration * 1000.

%% 是否过了开服指定天数 -> true | false
can_open() ->
    case sys_env:get(srv_open_time) of
        SrvOpenTime when is_integer(SrvOpenTime) ->
            SrvOpenTime2 = util:unixtime({today, SrvOpenTime}),
            util:unixtime() - SrvOpenTime2 >= 24 * 3600;
        _Other ->
            ?ERR("未设置正确的开服时间[~w]，无法开启竞技场", [_Other]),
            false
    end.

is_in_active([]) ->
    false;
is_in_active([{Hour, Min, Sec} | T]) ->
    Now = util:unixtime(),

    Today = util:unixtime({today, Now}),
    Time = Hour * 3600 + Min * 60 + Sec,
    EndTime = Today + Time + ?active_time * 60,
    case Now >= (Today + Time) andalso Now =< EndTime - 5 * 60 of
        true -> 
            EndTime - Now;
        false ->
            is_in_active(T)
    end.

change_to_active(State) ->
    Hall = create_hall(#hall{type = ?hall_type_compete}),

    %%传闻
    Msg = util:fbin(?compete_start, []),
    role_group:pack_cast(world, 10932, {7, 1, Msg}),

    %%推送状态
    broadcast_status(?true),

    %% 等待匹配队友的玩家
    put(teammate_queue, []),
    %% 等待匹配对手的队伍
    put(team_queue, []),
    %%已匹配的地图
    put(matched_maps, []),
    %%已匹配的房间
    put(matched_rooms, []),

    compete_rank:start_activity(),
    erlang:send_after(?match_time1, self(), match),

    State#state{hall = Hall, begin_time = erlang:now(), duration = min_to_millisec(?active_time)}.

create_hall(Hall) ->
    {ok, Id, Pid} = hall_mgr:create(Hall),
    Hall#hall{id = Id, pid = Pid}.

min_to_millisec(Minute) ->
    Minute * 60 * 1000.

to_sign_up_role(HallId, RoomNo, #hall_role{id = Id, name = Name, conn_pid = ConnPid, is_owner = IsOwner,
        pid = Pid, fight_capacity = FightCapacity, pet_fight_capacity = PetFightCapacity, career = Career}) ->
    #sign_up_role{id = Id, name = Name, conn_pid = ConnPid, is_leader = IsOwner, pid = Pid, career = Career,
        total_power = FightCapacity + PetFightCapacity, hall_id = HallId, room_no = RoomNo}.

%% 通知角色某消息
notice(Rid, MsgId) ->
    case role_api:lookup(by_id, Rid, [#role.link]) of
        {ok, _, [#link{conn_pid = ConnPid}]} ->
            notice:alert(error, ConnPid, MsgId);
        _ -> 
            ignore
    end.

start_combat_failed(CombatResult, Rids) ->
    ReasonId = case CombatResult of
        ?combat_result_win ->
            ?MSGID(<<"很可惜，您的对手离场或者掉线，无法参与战斗">>);
        _ ->
            ?MSGID(<<"当前网络不稳定，发起战斗失败了">>)
    end,
    lists:foreach(fun(Rid) ->
                notice(Rid, ReasonId),
                deal_combat_result(CombatResult, {Rid, ?false})
        end, Rids).

get_combat_honor(CombatResult, Rid) ->
    RankNum = rank:fight_rank(Rid),
    RankNum2 = case RankNum of
        0 ->
            500;
        _ ->
            RankNum
    end,
    Grade = if
        RankNum2 =< 500 * 0.05 ->
            1;
        RankNum2 =< 500 * 0.2 ->
            2;
        RankNum2 =< 500 * 0.45 ->
            3;
        RankNum2 =< 500 * 0.7 ->
            4;
        true ->
            5
    end,
    Honor = case CombatResult of
        ?combat_result_win ->
            compete_data:win_honor(Grade);
        _ ->
            compete_data:lose_honor(Grade)
    end,
    ?DEBUG("[~w]获得~w荣誉，战果~w，全服排名~w", [Rid, Honor, CombatResult, RankNum]),
    %%特殊时间获得积分有加成
    case is_in_bonus_time(?start_time_list) of
        true ->
            util:ceil(Honor * ?bonus_factor);
        false ->
            Honor
    end.

get_combat_badge(CombatResult) ->
    Weights = case CombatResult of
        ?combat_result_win ->
            compete_data:win_badge_weights();
        _ ->
            compete_data:lose_badge_weights()
    end,
    Rands = [Rand || {_, Rand} <- Weights],
    SumRand = lists:sum(Rands),

    RandValue = case SumRand > 0 of
        true -> util:rand(1, SumRand);
        false -> 1
    end,
    get_combat_badge(RandValue, Weights).
get_combat_badge(RandValue, [{Badge, Rand} | T]) when RandValue =< Rand orelse T =:= [] ->
    Badge;
get_combat_badge(RandValue, [{_, Rand} | T]) ->
    get_combat_badge(RandValue - Rand, T).

deal_combat_result(_CombatResult, []) ->
    ok;
deal_combat_result(CombatResult, [FighterInfo | T]) ->
    deal_combat_result(CombatResult, FighterInfo),
    deal_combat_result(CombatResult, T);
deal_combat_result(CombatResult, {Rid, IsDie}) ->
    %%更新死亡Buff
    Count = case CombatResult of
        ?combat_result_win ->
            0;
        _ ->
            case ets:lookup(compete_buff, Rid) of
                [{_Rid, _Count}] ->
                    erlang:min(_Count + 1, ?max_buff_count);
                _ ->
                    1
            end
    end,
    ets:insert(compete_buff, {Rid, Count}),

    %%发奖励
    case ets:lookup(compete_role, Rid) of
        [SignupRole = #sign_up_role{status = ?compete_status_map}] ->
            %%扣了次数才有奖励
            Honor = get_combat_honor(CombatResult, Rid),
            Badge = get_combat_badge(CombatResult),
            Gains = case Badge =:= 0 of
                true ->
                    [];
                false ->
                    [#gain{label = badge, val = Badge}]
            end,
            Gains2 = [#gain{label = honor, val = Honor} | Gains],

            %%更新今日荣誉，保证在同一进程处理同一ets的修改
            compete_rank:update_honor(SignupRole, Honor),

            case role_api:lookup(by_id, Rid, [#role.pid]) of
                {ok, _, [Pid]} when is_pid(Pid) ->
                    role:apply(async, Pid, {fun async_deal_combat_result/6, [Gains2, CombatResult, Honor, Badge, IsDie]});
                _ ->
                    award:send(Rid, ?offline_award_id, Gains2),
                    medal_compete:add_compete_result(Rid, {CombatResult, IsDie}) %% 竞技勋章离线处理
            end;
        _ -> 
            ignore
    end,
    ets:delete(compete_role, Rid).

async_deal_combat_result(Role = #role{id = Rid, link = #link{conn_pid = ConnPid}}, Gains, 
    CombatResult, Honor, Badge, IsDie) ->
    sys_conn:pack_send(ConnPid, 16205, {CombatResult, Honor, Badge}),
    Role3 = delete_buff(Role),
    %% check_medal会重新push_attr
    Role4 = 
        case role_gain:do(Gains, Role3) of
            {ok, _Role3} ->
                _Role3;
            _ ->
                award:send(Rid, ?offline_award_id, Gains),
                Role3
        end,
    Role5 = medal_compete:check_medal(Role4, compete_2v2, {CombatResult, IsDie}), %% 竞技勋章监听
    {ok, Role5}.

async_sign_up(Role) ->
    {ok, Role#role{event = ?event_compete}}.

async_back_to_hall(Role) ->
    {ok, Role#role{event = ?event_hall}}.

remove_from_teammate_queue(Rid) ->
    TeammateQueue = get(teammate_queue),
    TeammateQueue2 = lists:keydelete(Rid, #sign_up_role.id, TeammateQueue),
    put(teammate_queue, TeammateQueue2).

remove_from_team_queue(Rid) ->
    TeamQueue = get(team_queue),
    TeamQueue2 = lists:filter(fun(#sign_up_team{id = Rids}) ->
                case lists:member(Rid, Rids) of
                    true ->
                        false;
                    false ->
                        true
                end
        end, TeamQueue),
    put(team_queue, TeamQueue2).

cancel_match_teammate(Self = #sign_up_role{id = Rid}) ->
    remove_from_teammate_queue(Rid),

    %%通知自己
    notify_cancel_match(Self).

cancel_match_team(Self = #sign_up_role{id = Rid, hall_id = HallId, room_no = RoomNo}) ->
    %%通知自己
    notify_cancel_match(Self),

    TeamQueue = get(team_queue),
    {TargetTeams, OtherTeams} = lists:partition(fun(#sign_up_team{id = Rids}) ->
                lists:member(Rid, Rids)
        end, TeamQueue), 

    RejoinRids = [L -- [Rid] || #sign_up_team{id = L} <- TargetTeams],
    RejoinRids2 = lists:flatten(RejoinRids),
    lists:foreach(fun(RejoinRid) ->
                case ets:lookup(compete_role, RejoinRid) of
                    %%同一个房间的要一起cancel
                    [SignupRole = #sign_up_role{hall_id = HallId, room_no = RoomNo}] ->
                        notify_cancel_match(SignupRole);
                    [RejoinRole = #sign_up_role{}] ->
                        change_role_status(RejoinRid, ?compete_status_teammate),
                        put(teammate_queue, [RejoinRole | get(teammate_queue)]);
                    _ -> 
                        ?ERR("找不到[~w]的竞技场信息，无法修改其状态", [RejoinRid])
                end
        end, RejoinRids2),
    put(team_queue, OtherTeams).

change_role_status([], _Status) ->
    ok;
change_role_status([Rid | T], Status) ->
    change_role_status(Rid, Status),
    change_role_status(T, Status);
change_role_status(Rid, Status) ->
    case ets:lookup(compete_role, Rid) of
        [SignupRole = #sign_up_role{conn_pid = ConnPid}] ->
            sys_conn:pack_send(ConnPid, 16204, {Status}),
            ets:insert(compete_role, SignupRole#sign_up_role{status = Status});
        _ -> 
            ?ERR("找不到[~w]的竞技场信息，无法修改其状态为:~w", [Rid, Status])
    end.

is_in_bonus_time([]) ->
    false;
is_in_bonus_time([{Hour, Min, Sec} | T]) ->
    Now = util:unixtime(),

    Today = util:unixtime({today, Now}),
    Time = Hour * 3600 + Min * 60 + Sec,
    case Now >= (Today + Time) andalso Now =< (Today + Time + ?bonus_timer) of
        true -> 
            true;
        false ->
            is_in_bonus_time(T)
    end.

%% 打印待匹配队列
print_matching_queue(SortedQueue = [_|_]) ->
    case get(matching_queue_print_flag) of
        true ->
            ?INFO("竞技场待匹配队列信息=========================>", []),
            lists:foreach(fun(#sign_up_team{id = RoleIds, total_power = TotalPower, match_count = MatchCount}) ->
                        ?INFO("RoleIds=[~w], TotalPower=~w, MatchCount=~w", [RoleIds, TotalPower, MatchCount])
                end, SortedQueue),
            ?INFO("竞技场待匹配队列信息<=========================\n\n", []);
        _ -> 
            ignore
    end;
print_matching_queue(_) -> 
    ignore.

%% 匹配对手
match_team() ->
    Queue = get(team_queue),
    %%排序
    SortFun = fun(#sign_up_team{total_power = TotalPower1}, #sign_up_team{total_power = TotalPower2}) ->
            TotalPower1 > TotalPower2
    end,
    SortedQueue = lists:sort(SortFun, Queue),

    print_matching_queue(SortedQueue),

    {Match, NotMatch} = do_match_team(SortedQueue, SortedQueue, []),

    %% 没匹配上的组匹配次数+1
    NotMatch2 = lists:foldl(fun(Team = #sign_up_team{id = Rids, match_count = MatchCount}, Return) ->
                case MatchCount >= ?team_match_limit of
                    %%达到上限次数提示匹配失败
                    true ->
                        notify_match_failed(Rids),
                        Return;
                    false ->
                        [Team#sign_up_team{match_count = MatchCount + 1} | Return]
                end
        end, [], NotMatch),

    put(team_queue, NotMatch2),
    notify_prepare_combat(Match).

%% Match = [{Team1, Team2}] 匹配到的组
do_match_team([], NotMatch, Match) ->
    {Match, NotMatch};
do_match_team([Target1 = #sign_up_team{total_power = TotalPower1, match_count = MatchCount1} | T], Queue, Match) ->
    Latitude = compete_data:team_latitude(MatchCount1),
    case make_matched_team(Target1, Latitude, Queue) of
        Target2 = #sign_up_team{total_power = TotalPower2} ->
            {Latitude1, Latitude2} = if 
                TotalPower1 > TotalPower2 -> 
                    {0, Latitude};
                TotalPower1 < TotalPower2 -> 
                    {Latitude, 0};
                true -> 
                    {0, 0}
            end,
            Group = {Target1#sign_up_team{match_latitude = Latitude1}, Target2#sign_up_team{match_latitude = Latitude2}},
            do_match_team(T -- [Target2], Queue -- [Target1, Target2], [Group | Match]);
        _ ->
            do_match_team(T, Queue, Match)
    end.

%% 获取匹配的对手
make_matched_team(_, _, []) ->
    undefined;
make_matched_team(Target, Latitude, [Target | T]) -> 
    make_matched_team(Target, Latitude, T);
make_matched_team(Target = #sign_up_team{id = _Rid1, total_power = TotalPower1}, Latitude,
    [H = #sign_up_team{id = _Rid2, total_power = TotalPower2} | T]) ->
    if
        TotalPower1 * (1 - Latitude) > TotalPower2 ->
            ?DEBUG("正在给[~w]匹配对手[~w]，战斗力相距过大(~w， ~w，战力浮动:~w)", [_Rid1, _Rid2, TotalPower1, TotalPower2, 1 - Latitude]),
            %%队列是有序的，后面的对手肯定不符合条件，直接匹配失败
            undefined;
        TotalPower1 * (1 + Latitude) < TotalPower2 ->
            ?DEBUG("正在给[~w]匹配对手[~w]，战斗力相距过大(~w， ~w，战力浮动:~w)", [_Rid1, _Rid2, TotalPower1, TotalPower2, 1 + Latitude]),
            make_matched_team(Target, Latitude, T);
        true -> 
            H
    end;
make_matched_team(Target, Latitude, [_ | T]) ->
    make_matched_team(Target, Latitude, T).

%% 匹配队友
match_teammate() ->
    Queue = get(teammate_queue),
    %%排序
    SortFun = fun(#sign_up_role{total_power = TotalPower1}, #sign_up_role{total_power = TotalPower2}) ->
            TotalPower1 > TotalPower2
    end,
    SortedQueue = lists:sort(SortFun, Queue),

    %% ?DEBUG("竞技场待匹配队友数[~w]", [length(SortedQueue)]),

    {Match, NotMatch} = do_match_teammate(SortedQueue, SortedQueue, []),

    NotMatch2 = lists:foldl(fun(SignupRole = #sign_up_role{match_count = MatchCount, id = Rid}, Return) ->
                case MatchCount >= ?teammate_match_limit of
                    true ->
                        %%达到上限次数提示匹配失败
                        notify_match_failed(Rid),
                        Return;
                    false ->
                        [SignupRole#sign_up_role{match_count = MatchCount + 1} | Return]
                end
        end, [], NotMatch),
    %% ?DEBUG("match_teammate:~w, ~w", [[MatchRoleIds || #sign_up_team{id = MatchRoleIds} <- Match], [NotMatchRoleIds || #sign_up_role{id = NotMatchRoleIds} <- NotMatch]]),
    put(team_queue, get(team_queue) ++ Match),
    put(teammate_queue, NotMatch2).

do_match_teammate([], NotMatch, Match) ->
    {Match, NotMatch};
do_match_teammate([Target = #sign_up_role{id = Rid1, match_count = MatchCount1} | T], Queue, Match) ->
    Latitude = compete_data:teammate_latitude(MatchCount1),
    case make_matched_teammate(Target, Latitude, Queue) of
        MatchedTarget = #sign_up_role{id = Rid2} ->
            %%推送匹配队友成功
            change_role_status(Rid1, ?compete_status_team),
            change_role_status(Rid2, ?compete_status_team),

            Team = combine_teammates(Target, MatchedTarget),
            do_match_teammate(T -- [MatchedTarget], Queue -- [Target, MatchedTarget], [Team | Match]);
        _ ->
            do_match_teammate(T, Queue, Match)
    end.

combine_teammates(#sign_up_role{id = Id1, total_power = TotalPower1}, #sign_up_role{id = Id2, total_power = TotalPower2}) ->
    #sign_up_team{id = [Id1, Id2], total_power = TotalPower1 + TotalPower2}.

%% 获取匹配的队友(2v2)
make_matched_teammate(_, _, []) ->
    undefined;
make_matched_teammate(Target, Latitude, [Target | T]) -> 
    make_matched_teammate(Target, Latitude, T);
make_matched_teammate(Target = #sign_up_role{id = _Rid1, total_power = TotalPower1, career = Career1, match_count = MatchCount}, Latitude,
    [H = #sign_up_role{id = _Rid2, total_power = TotalPower2, career = Career2} | T]) ->
    if
        Career1 =:= Career2 andalso MatchCount =< ?teammate_career_match ->
            ?DEBUG("正在给[~w]匹配队友[~w]，职业[~w]相同(~w)", [_Rid1, _Rid2, Career1, MatchCount]),
            make_matched_teammate(Target, Latitude, T);
        TotalPower1 * (1 - Latitude) > TotalPower2 ->
            ?DEBUG("正在给[~w]匹配队友[~w]，战斗力相距过大(~w， ~w，战力浮动:~w)", [_Rid1, _Rid2, TotalPower1, TotalPower2, 1 - Latitude]),
            %%队列是有序的，后面的玩家肯定不符合条件，直接匹配失败
            undefined;
        TotalPower1 * (1 + Latitude) < TotalPower2 ->
            ?DEBUG("正在给[~w]匹配队友[~w]，战斗力相距过大(~w， ~w，战力浮动:~w)", [_Rid1, _Rid2, TotalPower1, TotalPower2, 1 + Latitude]),
            make_matched_teammate(Target, Latitude, T);
        true -> 
            H
    end;
make_matched_teammate(Target, Latitude, [_ | T]) ->
    make_matched_teammate(Target, Latitude, T).

notify_cancel_match(#sign_up_role{id = Rid, pid = RolePid, conn_pid = ConnPid, is_leader = IsLeader,
    hall_id = HallId, room_no = RoomNo}) ->
    sys_conn:pack_send(ConnPid, 16203, {?true}),
    ets:delete(compete_role, Rid),

    role:apply(async, RolePid, {fun async_back_to_hall/1, []}),

    case IsLeader of
        ?true ->
            hall:room_end_combat(HallId, RoomNo, false);
        _ ->
            ignore
    end.

notify_match_failed([]) ->
    ok;
notify_match_failed([Rid | T]) ->
    notify_match_failed(Rid),
    notify_match_failed(T);
notify_match_failed(Rid) ->
    case ets:lookup(compete_role, Rid) of
        [#sign_up_role{conn_pid = ConnPid, hall_id = HallId, room_no = RoomNo, 
                is_leader = IsLeader, pid = RolePid}] ->
            sys_conn:pack_send(ConnPid, 16204, {?compete_status_normal}),
            ets:delete(compete_role, Rid),

            role:apply(async, RolePid, {fun async_back_to_hall/1, []}),

            case IsLeader of
                ?true ->
                    hall:room_end_combat(HallId, RoomNo, false);
                _ ->
                    ignore
            end;
        _ -> 
            ?ERR("找不到[~w]的竞技场信息", [Rid])
    end.

%% 通知匹配好的队伍进入战区
notify_prepare_combat([]) -> 
    ok;
notify_prepare_combat([{Team1 = #sign_up_team{id = Rids1}, Team2 = #sign_up_team{id = Rids2}} | T]) ->
    Rids = Rids1 ++ Rids2,
    case create_map() of
        {ok, MapPid, MapId} ->
            %%标记地图已用
            add_to_matched_map(Rids, MapId, MapPid),

            %%标记参战房间
            add_to_matched_room(Rids),

            %%更改角色状态并通知客户端
            change_role_status(Rids, ?compete_status_matched),

            enter_combat_area(Rids1, MapId, 6, 1),
            enter_combat_area(Rids2, MapId, 4, 1),

            ?DEBUG("[~w]准备开始竞技场战斗", [Rids]),
            erlang:send_after(?prepare_combat_time, self(), {start_combat, Team1, Team2});
        _ ->
            ?ERR("建立[~w, ~w]的竞技场战区失败", [Rids1, Rids2]),
            notify_match_failed(Rids)
    end,
    notify_prepare_combat(T).

enter_combat_area([], _, _, _) ->
    ok;
enter_combat_area([Rid = {RoleId, SrvId} | T], MapId, Dir, Index) ->
    case role_api:lookup(by_id, Rid, [#role.pid]) of
        {ok, _, [RolePid]} ->
            role:apply(async, RolePid, {fun async_enter_combat_area/4, [MapId, Dir, Index]});
        _Err2 ->
            %%进不了战斗地图就让他上线回主城
            ets:delete(compete_role, Rid),
            ?ERR("[~w, ~s]进入竞技场战斗区域失败，查找角色时错误:~w", [RoleId, SrvId, _Err2])
    end,
    enter_combat_area(T, MapId, Dir, Index + 1).

async_enter_combat_area(Role = #role{id = Rid, name = _Name, pos = Pos = #pos{last = Last}}, MapId, Dir, Index) ->
    {NewX, NewY} = get_enter_pos(Dir, Index),
    Role5 = case map:role_enter(MapId, NewX, NewY, Role#role{pos = Pos#pos{dir = Dir}}) of
        {ok, Role2 = #role{pos = NewPos}} -> 
            ?DEBUG("[~s]进入竞技场区域成功", [_Name]),
            {ok, Role3} = add_enter_count(Role2),
            %%标记已扣进入次数
            ets:update_element(compete_role, Rid, {#sign_up_role.status, ?compete_status_map}),
            %%buff
            Role4 = add_buff(Role3),
            %%确保上一地图是进入竞技场大厅前的地图
            Role4#role{pos = NewPos#pos{last = Last}};
        {false, _Why} -> 
            ?ERR("[~s]进入竞技场区域失败:~s", [_Name, _Why]),
            Role
    end,
    {ok, Role5}.

get_enter_pos(6, 1) ->
    {495 - 110, ?combat_lower_pos_y}; 
get_enter_pos(6, 2) ->
    {495, ?combat_upper_pos_y}; 
get_enter_pos(4, 1) ->
    {795 + 110, ?combat_lower_pos_y}; 
get_enter_pos(4, 2) ->
    {795, ?combat_upper_pos_y}; 
get_enter_pos(_, _) ->
    get_enter_pos(6, 1). 

broadcast_status(Result) ->
    lists:foreach(fun(#role_online{pid = Pid, lev = Lev}) ->
                UnlockLev = ?compete_unlock_lev,
                case Lev < UnlockLev of
                    true ->
                        ignore;
                    false ->
                        role:pack_send(Pid, 16200, {Result})
                end
        end, ets:tab2list(role_online)).

add_to_matched_room(Rids) ->
    %%查找所有参与战斗的房间信息
    Rooms = lists:foldl(fun(Rid, Return) ->
                case ets:lookup(compete_role, Rid) of
                    [#sign_up_role{hall_id = HallId, room_no = RoomNo, is_leader = IsLeader}] ->
                        case IsLeader of
                            ?true ->
                                [{HallId, RoomNo} | Return];
                            _ ->
                                Return
                        end;
                    _ -> 
                        Return
                end
            end, [], Rids),

    case get(matched_rooms) of
        L = [_ | _] ->
            put(matched_rooms, [{Rids, Rooms} | L]);
        _ ->
            put(matched_rooms, [{Rids, Rooms}])
    end.

clear_matched_info(Rids) ->
    %%只要一个角色Id查找即可
    case Rids of
        [Rid | _] ->
            %%通知房间结束战斗
            clear_matched_room(Rid),
            %%清理地图
            erlang:send_after(?clear_map_timer, self(), {clear_matched_map, Rid});
        _ ->
            ignore
    end.
    
clear_matched_room(Rid) ->
    case get(matched_rooms) of
        L = [_ | _] ->
            L2 = lists:filter(fun({Rids, Rooms}) ->
                        case lists:member(Rid, Rids) of
                            true ->
                                lists:foreach(fun({HallId, RoomNo}) ->
                                            hall:room_end_combat(HallId, RoomNo, false)
                                    end, Rooms),
                                false;
                            false ->
                                true
                        end
                end, L),
            put(matched_rooms, L2);
        _ ->
            ignore
    end.

%%-----------------------------------------
%% 地图相关
%%-----------------------------------------
%% 创建战斗区域地图 -> {ok, {MapId, MapPid}} | false
create_map() ->
    case map_mgr:create(?map_base_id) of
        {false, Reason} ->
            ?ERR("创建竞技场战斗区域地图[MapBaseId=~w]失败: ~s", [?map_base_id, Reason]),
            false;
        Other ->
            Other
    end.

%% 记录匹配的2个组和地图信息，方便战斗结束时销毁地图进程
add_to_matched_map(Rids, MapId, MapPid) ->
    case get(matched_maps) of
        L = [_ | _] ->
            put(matched_maps, [{Rids, MapId, MapPid} | L]);
        _ ->
            put(matched_maps, [{Rids, MapId, MapPid}])
    end.

clear_matched_map(Rid) ->
    case get(matched_maps) of
        L = [_ | _] ->
            L2 = lists:filter(fun({Rids, _MapId, MapPid}) ->
                        case lists:member(Rid, Rids) of
                            true ->
                                map:stop(MapPid),
                                false;
                            false ->
                                true
                        end
                end, L),
            put(matched_maps, L2);
        _ ->
            ignore
    end.

clear_all_matched_map() ->
    case get(matched_maps) of
        L = [_ | _] ->
            lists:foreach(fun({_Rids, _MapId, MapPid}) ->
                        map:stop(MapPid)
                end, L);
        _ ->
            ignore
    end,
    put(matched_maps, []).

%%-----------------------------------------
%% 战斗相关
%%-----------------------------------------
roles_to_fighters([], Result, Fails) -> 
    {Result, Fails};
roles_to_fighters([Rid = {RoleId, SrvId} | T], Result, Fails) ->
    case role_api:lookup(by_id, Rid, to_fighter) of
        {ok, _, #converted_fighter{fighter_ext = #fighter_ext_role{event = Event}}} when Event =/= ?event_compete ->
            ?ERR("[~w, ~s]的当前事件状态不正确[Event=~w]，无法加入竞技场战斗", [RoleId, SrvId, Event]),
            roles_to_fighters(T, Result, [Rid | Fails]);
        {ok, _, CF = #converted_fighter{}} ->
            roles_to_fighters(T, [CF | Result], Fails);
        {error, not_found} -> %% 掉线
            ?INFO("[~w, ~s]掉线，查找不到了", [RoleId, SrvId]),
            roles_to_fighters(T, Result, [Rid | Fails]);
        _Err -> 
            ?ERR("查找并转换角色[~w, ~s]出错:~w", [RoleId, SrvId, _Err]),
            roles_to_fighters(T, Result, [Rid | Fails])
    end.

add_buff(Role = #role{id = Rid}) ->
    case ets:lookup(compete_buff, Rid) of
        [{_, Count}] when Count =/= 0 ->
            ?DEBUG("角色[NAME:~w][~w]在竞技场增加~w次Buff", [Role#role.name, Rid, Count]),
            add_buff(Role, Count);
        _ ->
            Role
    end.
add_buff(Role, 0) ->
    role_attr:calc_attr(Role);
add_buff(Role, Count) ->
    case buff:add(Role, compete_all_1) of
        {ok, Role2} ->
            add_buff(Role2, Count - 1);
        _ ->
            Role
    end.

%%不带属性计算
delete_buff(Role) ->
    delete_buff(Role, ?max_buff_count).
delete_buff(Role, 0) ->
    Role;
delete_buff(Role, Count) ->
    case buff:del_buff_by_label_no_push(Role, compete_all_1) of
        {ok, Role2} ->
            delete_buff(Role2, Count - 1);
        _ ->
            Role
    end.
