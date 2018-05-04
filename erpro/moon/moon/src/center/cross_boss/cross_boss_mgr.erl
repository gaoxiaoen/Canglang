%% --------------------------------------------------------------------
%% 跨服boss管理进程
%% @author wpf (wprehard@qq.com)
%% @end
%% --------------------------------------------------------------------
-module(cross_boss_mgr).
-behaviour(gen_fsm).

%% export functions
-export([
        start_link/0
        ,info/1
        ,role_enter/3
        ,role_leave/3
        ,get_status/0
        ,start_combat/4
        ,over_combat/4
        ,get_enter_count/1
        ,check_enter_count/1
        ,update_enter_flag/2
        ,get_hall/2
        ,to_fight_lev/1
        ,fight_lev_list/0
        ,broadcast_srv/1
        ,apply_leave_hall/1
        ,apply_enter_map/2
        ,apply_leave_map/1
        ,sync_leave_map/1
    ]).
%% debug functions
-export([debug/1]).
%% test functions
-export([gm_status/0, gm_clean_count/0]).
%% gen_fsm callbacks
-export([init/1, handle_event/3,handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).
%% state functions
-export([idel/2, prepare/2, active/2, stop/2]).

%% include
-include("common.hrl").
-include("role.hrl").
-include("boss.hrl").
-include("hall.hrl").
-include("combat.hrl").
-include("pos.hrl").
-include("attr.hrl").

%% macro
-define(DEF_PREPARE_INTERVAL_TIME,  600). %% 活动准备时间(秒)
-define(DEF_ACTIVE_INTERVAL_TIME,   7200). %% 活动持续时间(秒)
-define(DEF_STOP_INTERVAL_TIME,     3600). %% 活动结束后等待时间(秒)

-define(cross_boss_status_idel, 0).
-define(cross_boss_status_active, 1).
-define(cross_boss_status_prepare, 2).
-define(cross_boss_status_stop, 3).

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% @spec to_fight_lev(Fight) -> Lev :: integer()
%% Fight = integer()
to_fight_lev(Fight) when Fight >= 15000 ->                          1;
to_fight_lev(Fight) when Fight >= 11000 andalso Fight < 15000 ->    2;
to_fight_lev(Fight) when Fight >= 9000 andalso Fight < 11000->      3;
to_fight_lev(Fight) when Fight >= 8000 andalso Fight < 9000 ->      4;
to_fight_lev(_Fight) ->                                             5.

%% @spec fight_lev_list() -> list()
fight_lev_list() ->
    [1, 2, 3, 4, 5].

%% @spec fight_lev_to_str(FightLev) -> bitstring()
fight_lev_to_str(1) -> ?L(<<"无双组(15000以上)">>);
fight_lev_to_str(2) -> ?L(<<"凌云组(11000-15000)">>);
fight_lev_to_str(3) -> ?L(<<"精英组(9000-11000)">>);
fight_lev_to_str(4) -> ?L(<<"新锐组(8000-9000)">>);
fight_lev_to_str(_FightLev) -> <<"">>.
    
%% @spec role_enter(RoleId, Pid, FightCapacity) -> any()
%% Role = #role{}
%% FightLev = integer()
role_enter(RoleId, Pid, FightCapacity) ->
    FightLev = to_fight_lev(FightCapacity),
    gen_fsm:send_all_state_event(?MODULE, {role_enter, RoleId, Pid, FightLev}).

%% @spec role_leave(RoleId, Pid, MapId) -> any()
%% Role = #role{}
role_leave(RoleId, Pid, MapId) ->
    gen_fsm:send_all_state_event(?MODULE, {role_leave, RoleId, Pid, MapId}).

%% @spec info(Msg) -> any()
%% Msg = term()
info(Msg) ->
    gen_fsm:send_all_state_event(?MODULE, Msg).

%% @spec get_status() -> {ok, {Status, Time}}
get_status() ->
    gen_fsm:sync_send_all_state_event(?MODULE, get_status).

%% @spec get_enter_count(RoleId) -> integer()
%% RoleId = {integer(), bitstring()}
get_enter_count(RoleId) ->
    case ets:lookup(ets_cross_boss_role_count, RoleId) of
        [C = #cross_boss_role_count{role_id = _, count = Count, buy_cnt = BuyCnt, last = Last}] ->
            case Last >= util:unixtime(today) of
                true -> Count + BuyCnt;
                false -> %% 跨天重置次数和boss列表
                    ets:insert(ets_cross_boss_role_count, C#cross_boss_role_count{count = ?DEF_C_BOSS_COUNT, boss = [], last = util:unixtime()+1}),
                    ?DEF_C_BOSS_COUNT
            end;
        [] ->
            ets:insert(ets_cross_boss_role_count, #cross_boss_role_count{role_id = RoleId, count = ?DEF_C_BOSS_COUNT, last = util:unixtime()+1}),
            ?DEF_C_BOSS_COUNT
    end.

%% @spec check_enter_count(Roles) -> {ok, Ids} | {false, Msg}
%% Roles = [#hall_role{} | ...]
%% Ids = [{integer(), bitstring()} | ...]
check_enter_count(RoleIds) ->
    check_enter_count(RoleIds, []).
check_enter_count([], List) ->
    {ok, List};
check_enter_count([#hall_role{id = RoleId, name = RoleName} | T], List) ->
    case get_enter_count(RoleId) of
        Count when Count =< 0 ->
            {false, util:fbin(?L(<<"~s的次数已满， 无法共同发起挑战">>), [RoleName])};
        Count ->
            check_enter_count(T, [{RoleId, Count} | List])
    end.

%% @spec update_enter_flag(Roles) -> any()
%% Roles = list()
update_enter_flag(_BossId, []) -> ok;
update_enter_flag(BossId, [#cross_boss_role{id = RoleId} | T]) ->
    update_enter_flag(BossId, RoleId),
    update_enter_flag(BossId, T);
update_enter_flag(BossId, RoleId) ->
    case ets:lookup(ets_cross_boss_role_count, RoleId) of
        [C = #cross_boss_role_count{count = Count, boss = Ids}] when Count =< 0 ->
            ets:insert(ets_cross_boss_role_count, C#cross_boss_role_count{last = util:unixtime(), boss = [BossId | Ids]});
        [C = #cross_boss_role_count{count = Count, boss = Ids}] ->
            ets:insert(ets_cross_boss_role_count, C#cross_boss_role_count{count = Count - 1, last = util:unixtime(), boss = [BossId | Ids]});
        _Other ->
            ?ERR("更新玩家的挑战信息出错:~w", [{_Other, RoleId, BossId}])
    end,
    ok.

%% @spec get_hall(RoleId, FightCapactiy) -> {ok, integer()} | {false, Msg}
%% 获取大厅ID
get_hall(RoleId, FightCapacity) ->
    FightLev = to_fight_lev(FightCapacity),
    case ets:lookup(ets_cross_boss_pre_roles, RoleId) of
        [{_, _MapId, _MapPid}] ->
            case gen_fsm:sync_send_all_state_event(?MODULE, {get_hall, FightLev}) of
                {ok, HallId} ->
                    case hall_mgr:get_hall(<<>>, HallId) of
                        {ok, Hall} -> {ok, Hall};
                        _ -> {false, ?L(<<"当前网络状况不稳定，请稍后再尝试">>)}
                    end;
                {false, Msg} ->
                    {false, Msg}
            end;
        _ ->
            {false, ?L(<<"请先进入天位之战准备区，获取大厅资格">>)}
    end.

%% @spec start_combat(HallId, RoomNo, HallRoles, BossId) -> any()
%% RoomNo = integer()
%% HallRoles = [#hall_role{} | ...]
%% BossId = integer()
start_combat(_HallId, _RoomNo, 0, _HallRoles) ->
    {false, ?L(<<"没有选择挑战的BOSS，无法发起挑战">>)};
start_combat(HallId, RoomNo, BossId, HallRoles) ->
    gen_fsm:send_all_state_event(?MODULE, {start_combat, HallId, RoomNo, HallRoles, BossId}).

%% @spec over_combat(Pid, CombatPid, Winner, Loser, Round) -> any()
%% RoomNo = integer()
%% HallRoles = [#hall_role{} | ...]
%% BossId = integer()
over_combat(Pid, CombatPid, Winner, Round) when is_pid(Pid) ->
    case [true || #fighter{type = ?fighter_type_role} <- Winner] of
        [_ | _] -> %% 玩家队伍赢
            %% Pid ! {over_combat, CombatPid, win, Round};
            gen_fsm:send_all_state_event(?MODULE, {over_combat, CombatPid, win, Round});
        _ ->
            gen_fsm:send_all_state_event(?MODULE, {over_combat, CombatPid, lose, Round})
    end;
over_combat(_Pid, _CombatPid, _Winner, _Round) ->
    ?ERR("PID:~w CombatPid:~w Winner:~w Round:~w", [_Pid, _CombatPid, _Winner, _Round]),
    ignore.

%% @spec broadcast_srv(State) -> any()
%% State = atom()
%% @doc 广播活动状态
broadcast_srv(State) ->
    case sys_env:get(srv_open_time) of
        T when is_integer(T) ->
            case T + 7 * 86400 < util:unixtime() of
                true ->
                    do_broadcast(State);
                false -> ignore
            end;
        _ ->
            do_broadcast(State)
    end.

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start_link() ->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 打印高度信息
debug(Type) ->
    info({debug, Type}).

%% gm命令 - 活动状态
gm_status() ->
    gen_fsm:send_event(?MODULE, timeout).

%% gm命令 - 清空次数
gm_clean_count() ->
    L = ets:tab2list(ets_cross_boss_role_count),
    Now = util:unixtime(),
    lists:foreach(fun(C = #cross_boss_role_count{role_id = _}) ->
                ets:insert(ets_cross_boss_role_count, C#cross_boss_role_count{count = ?DEF_C_BOSS_COUNT, boss = [], last = Now})
        end, L).

%% --------------------------------------------------------------------
%% gen_fsm callback functions
%% --------------------------------------------------------------------

%% Func: init/1
%% Returns: {ok, StateName, StateData}          |
%%          {ok, StateName, StateData, Timeout} |
%%          ignore                              |
%%          {stop, StopReason}
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    init_table(),
    load_data(),
    CdSec = get_next_act_time(),
    State = #cross_boss_state{ts = util:unixtime(), t_cd = CdSec},
    cross_boss_rank:start_link(),
    ?INFO("[~w] 启动完成:~w", [?MODULE, CdSec]),
    {ok, idel, State, CdSec * 1000}.

%% Func: handle_event/3
%% Returns: {next_state, NextStateName, NextStateData}          |
%%          {next_state, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}

%% 进入准备区
handle_event({role_enter, RoleId, Pid, FightLev}, active, State = #cross_boss_state{maps = MapList, halls = HallList}) ->
    case get_enter_map(FightLev, MapList) of
        {ok, M = #cross_boss_map{map_id = MapId}} ->
            role:apply(async, Pid, {cross_boss_mgr, apply_enter_map, [MapId]}),
            role:pack_send(Pid, 16806, {?true, util:fbin(?L(<<"成功进入天位之战准备区，根据您的战斗力，您当前被分配在~s">>), [fight_lev_to_str(FightLev)])}),
            add_pre_roles(RoleId, M),
            NewMapList = add_pre_count(MapId, MapList),
            continue(active, State#cross_boss_state{maps = NewMapList});
        _ -> %% 新建准备区地图
            Mapping = #cross_boss_map{map_id = MapId} = new_mapping(),
            case get_enter_hall(FightLev, HallList) of
                {ok, MH = #cross_boss_mapping_hall{hall_id = HallId, maps = MapIds}} ->
                    NewMapping = Mapping#cross_boss_map{fight_lev = FightLev, hall_id = HallId, count = 1},
                    role:apply(async, Pid, {cross_boss_mgr, apply_enter_map, [MapId]}),
                    role:pack_send(Pid, 16806, {?true, util:fbin(?L(<<"成功进入天位之战准备区，根据您的战斗力，您当前被分配在~s">>), [fight_lev_to_str(FightLev)])}),
                    add_pre_roles(RoleId, NewMapping),
                    NewMapList = update_mapping(NewMapping, MapList),
                    NewHallList = update_mapping_hall(MH#cross_boss_mapping_hall{maps = MapIds ++ [MapId]}, HallList),
                    continue(active, State#cross_boss_state{maps = NewMapList, halls = NewHallList});
                _ ->
                    ?ERR("没有找到相应战力区间的大厅：~w", [{RoleId, FightLev}]),
                    continue(active, State)
            end
    end;
handle_event({role_enter, _RoleId, Pid, _FightLev}, StateName, State) when StateName =:= prepare ->
    role:pack_send(Pid, 16806, {?false, ?L(<<"天位之战活动即将开始，在准备时间结束后可以报名参加活动">>)}),
    continue(StateName, State);
handle_event({role_enter, _RoleId, Pid, _FightLev}, StateName, State) ->
    role:pack_send(Pid, 16806, {?false, ?L(<<"天位之战在开服七天之后的周六、日10:00-12：00、14:00-16:00开启，52级8000战斗力以上的玩家可以参加！">>)}),
    continue(StateName, State);

%% 离开准备区地图
handle_event({role_leave, RoleId, Pid, MapId}, StateName, State = #cross_boss_state{maps = MapList}) ->
    case ets:lookup(ets_cross_boss_pre_roles, RoleId) of
        [{_, MapId, _MapPid}] ->
            role:apply(async, Pid, {cross_boss_mgr, apply_leave_map, []}),
            del_pre_roles(RoleId),
            NewMapList = del_pre_count(MapId, MapList),
            continue(StateName, State#cross_boss_state{maps = NewMapList});
        _E -> %% 记录不一致
            ?ERR("玩家[~w]退出的准备区地图[ID: ~w]与系统记录不一致:~w", [RoleId, MapId, _E]),
            role:apply(async, Pid, {cross_boss_mgr, apply_leave_map, []}),
            del_pre_roles(RoleId),
            continue(StateName, State)
    end;

%% 开始战斗
handle_event({start_combat, HallId, RoomNo, HallRoles, BossId}, active, State) ->
    case check_enter_count(HallRoles) of
        {ok, _} ->
            case check_enter_combat(BossId, HallRoles) of
                ok ->
                    spawn(fun() ->
                                AtkList = to_fighter(HallRoles),
                                DfdList = to_fighter([BossId]),
                                CombatRoles = lists:map(fun to_cross_boss_combat_role/1, HallRoles),
                                case combat:start(?combat_type_c_boss, self(), AtkList, DfdList) of
                                    {ok, CombatPid} ->
                                        CombatInfo = #cross_boss_combat{combat_pid = CombatPid, boss_id = BossId, room_no = RoomNo, hall_id = HallId, roles = CombatRoles},
                                        add_combat_info(CombatInfo);
                                    _ ->
                                        ?ERR("战斗发起失败[ATK: ~w~n DFD: ~w", [AtkList, DfdList]),
                                        hall:room_end_combat(HallId, RoomNo)
                                end
                        end),
                    continue(active, State);
                {false, Msg} ->
                    hall:room_end_combat(HallId, RoomNo),
                    notice_combat_fail(Msg, HallRoles), %% TODO: 通知
                    continue(active, State)
            end;
        {false, Msg} ->
            hall:room_end_combat(HallId, RoomNo),
            notice_combat_fail(Msg, HallRoles),
            continue(active, State)
    end;

%% 战斗结束
handle_event({over_combat, CombatPid, win, Round}, StateName, State) ->
    case find_combat_info(CombatPid) of
        {ok, CI = #cross_boss_combat{hall_id = HallId, boss_id = BossId, room_no = RoomNo, roles = Roles}} ->
            update_enter_flag(BossId, Roles),
            hall:room_end_combat(HallId, RoomNo, false),
            spawn(fun() ->
                        handle_award(win, BossId, to_rank_celebrity_data(Roles), Roles),
                        util:sleep(3000), %% 延迟判断退出房间
                        check_leave_hall(Roles)
                end),
            NewCI = CI#cross_boss_combat{round = Round},
            del_combat_info(NewCI),
            cross_boss_rank:update_rank(NewCI),
            ok;
        _E ->
            ?ERR("跨服boss进程收到异常的战斗结束消息[状态：~w STATE：~w, ERR: ~w]", [StateName, State, _E])
    end,
    continue(StateName, State);
handle_event({over_combat, CombatPid, lose, _Round}, StateName, State) ->
    case find_combat_info(CombatPid) of
        {ok, CI = #cross_boss_combat{hall_id = HallId, boss_id = BossId, room_no = RoomNo, roles = Roles}} ->
            hall:room_end_combat(HallId, RoomNo, false),
            spawn(fun() ->
                        handle_award(lose, BossId, [], Roles)
                end),
            del_combat_info(CI),
            ok;
        _E ->
            ?ERR("跨服boss进程收到异常的战斗结束消息[状态：~w STATE：~w, ERR: ~w]", [StateName, State, _E])
    end,
    continue(StateName, State);

%% 其他消息
handle_event({fail_enter, RoleId}, StateName, State) ->
    ets:delete(ets_cross_boss_pre_roles, RoleId),
    continue(StateName, State);

%% debug
handle_event({debug, mapping}, StateName, State = #cross_boss_state{maps = MapList, halls = HallList}) ->
    ?INFO("活动状态：~w，准备区地图共~w个，大厅共~w个", [StateName, length(MapList), length(HallList)]),
    lists:foreach(fun(#cross_boss_map{map_id = _MapId, fight_lev = _FightLev, count = _Count}) ->
                ?INFO("地图ID:~w  对应战力：~w 人数：~w", [_MapId, _FightLev, _Count]) end, MapList),
    lists:foreach(fun(#cross_boss_mapping_hall{hall_id = _HallId, fight_lev = _FightLev, maps = _Maps}) ->
                ?INFO("大厅ID:~w, 对应战力：~w, 对应地图:~w", [_HallId, _FightLev, _Maps]) end, HallList),
    continue(StateName, State);

handle_event(_Event, StateName, State) ->
    ?DEBUG("跨服boss挑战进程在~w状态下，收到异常消息：~w", [StateName, _Event]),
    continue(StateName, State).

%% Func: handle_sync_event/4
%% Returns: {next_state, NextStateName, NextStateData}            |
%%          {next_state, NextStateName, NextStateData, Timeout}   |
%%          {reply, Reply, NextStateName, NextStateData}          |
%%          {reply, Reply, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}                          |
%%          {stop, Reason, Reply, NewStateData}

%% 获取状态
handle_sync_event(get_status, _From, StateName, State = #cross_boss_state{ts = Ts, t_cd = Tcd}) ->
    Fun = fun(idel) -> {?cross_boss_status_idel, Ts + Tcd - util:unixtime()};
        (prepare) -> {?cross_boss_status_prepare, Ts + Tcd - util:unixtime()};
        (active) -> {?cross_boss_status_active, Ts + Tcd - util:unixtime()};
        (stop) -> {?cross_boss_status_idel, get_next_act_time()}
    end,
    Reply = {ok, Fun(StateName)},
    continue(Reply, StateName, State);

%% 获取对应战斗力的大厅ID
handle_sync_event({get_hall, FightLev}, _From, StateName, State = #cross_boss_state{halls = HallList}) ->
    Reply = case lists:keyfind(FightLev, #cross_boss_mapping_hall.fight_lev, HallList) of
        false -> {false, ?L(<<"该战力区间对应大厅暂未开启">>)};
        #cross_boss_mapping_hall{hall_id = HallId} ->
            {ok, HallId}
    end,
    continue(Reply, StateName, State);
    
handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    continue(Reply, StateName, State).

%% Func: handle_info/3
%% Returns: {next_state, NextStateName, NextStateData}          |
%%          {next_state, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}

handle_info(_Info, StateName, State) ->
    ?DEBUG("收到无效消息: ~w", [_Info]),
    continue(StateName, State).

%% Func: terminate/3
%% Purpose: Shutdown the fsm
%% Returns: any
terminate(_Reason, StateName, _StatData = #cross_boss_state{halls = HallList, maps = MapList}) ->
    cross_boss_rank:save_rank(),
    save_data(),
    case StateName =:= active of
        true ->
            c_mirror_group:cast(all, role_group, pack_cast, [world, 16801, {?cross_boss_status_idel, 0}]),
            destroy_hall(HallList),
            kick_out(),
            destroy_map(MapList);
        false -> ignore
    end,
    ?INFO("跨服boss完成信息保存"),
    ok.

%% Func: code_change/4
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState, NewStateData}
code_change(_OldVsn, StateName, StateData, _Extra) ->
    {ok, StateName, StateData}.

%% ---------------------------------------------------
%% StateName Function
%% ---------------------------------------------------

%% Func: StateName/2
%% Returns: {next_state, NextStateName, NextStateData}          |
%%          {next_state, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}

%% 空闲状态
idel(timeout, State) ->
    ?INFO("跨服BOSS挑战，进入准备阶段"),
    broadcast(prepare),
    continue(prepare, State#cross_boss_state{ts = util:unixtime(), t_cd = ?DEF_PREPARE_INTERVAL_TIME});
idel(_Event, State) ->
    ?INFO("~w 状态下收到消息 ~w", [state_idel, _Event]),
    continue(idel, State).

%% 准备状态
prepare(timeout, State) ->
    ?INFO("跨服BOSS挑战，进入开始阶段"),
    broadcast(active),
    HallList = create_hall(),
    continue(active, State#cross_boss_state{halls = HallList, ts = util:unixtime(), t_cd = ?DEF_ACTIVE_INTERVAL_TIME});
prepare(_Event, State) ->
    ?INFO("~w 状态下收到消息 ~w", [state_prepare, _Event]),
    continue(prepare, State).

%% 活动状态
active(timeout, State = #cross_boss_state{halls = HallList, maps = MapList}) ->
    ?INFO("跨服BOSS挑战，进入结算阶段"),
    broadcast(stop),
    spawn(fun() -> 
                destroy_hall(HallList),
                util:sleep(5000), %% 延迟，让玩家先退出大厅房间回到准备区
                kick_out(),
                destroy_map(MapList)
        end),
    cross_boss_rank:update_champion(), %% 更新冠军队伍
    continue(stop, State#cross_boss_state{halls = [], maps = [], ts = util:unixtime(), t_cd = ?DEF_STOP_INTERVAL_TIME});
active(_Event, State) ->
    continue(active, State).

%% 结束试练
stop(timeout, State) ->
    ?INFO("跨服BOSS挑战，进入空闲阶段"),
    cross_boss_rank:update_champion(), %% 更新冠军队伍
    case ets:info(ets_cross_boss_combat_list, size) of
        Len when is_integer(Len) andalso Len > 0 ->
            lists:foreach(fun(#cross_boss_combat{combat_pid = CombatPid}) when is_pid(CombatPid) ->
                        CombatPid ! stop;
                    (_) -> ignore
                end, ets:tab2list(ets_cross_boss_combat_list)); %% 到点定时清除
        _ -> ignore
    end,
    continue(idel, State#cross_boss_state{ts = util:unixtime(), t_cd = get_next_act_time()});
stop(_Event, State) ->
    ?INFO("~w 状态下收到消息 ~w", [stop, _Event]),
    continue(stop, State).

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------

%%% 同步调用
%call(Msg) ->
%    gen_fsm:sync_send_all_state_event(?MODULE, Msg).
%
%%% 异步事件调用
%info_state(Msg) ->
%    gen_fsm:send_event(?MODULE, Msg).

%% 同步单状态调用
%call_state(Msg) ->
%    gen_fsm:sync_send_event(?MODULE, Msg).

%% 状态机的持续执行
continue(StateName, State = #cross_boss_state{ts = Ts, t_cd = Tcd}) ->
    Now = util:unixtime(),
    Timeout = case Ts + Tcd - Now of
        T1 when T1 > 0 ->
            T1 * 1000;
        _ ->
            100
    end,
    {next_state, StateName, State, Timeout}.
continue(Reply, StateName, State = #cross_boss_state{ts = Ts, t_cd = Tcd}) ->
    Now = util:unixtime(),
    Timeout = case Ts + Tcd - Now of
        T1 when T1 > 0 ->
            T1 * 1000;
        _ ->
            1
    end,
    {reply, Reply, StateName, State, Timeout}.

%% ----------------------------------------------------------
%% private functions
%% ----------------------------------------------------------

%% 初始化表
init_table() ->
    %% 玩家次数记录
    ets:new(ets_cross_boss_role_count, [named_table, public, set, {keypos, #cross_boss_role_count.role_id}]),
    %% 准备区玩家列表
    ets:new(ets_cross_boss_pre_roles, [named_table, public, set, {keypos, 1}]),
    %% 已经发起的挑战战斗记录
    ets:new(ets_cross_boss_combat_list, [named_table, public, set, {keypos, #cross_boss_combat.combat_pid}]),
    ok.

%% 导入数据
load_data() ->
    dets:open_file(dets_cross_boss_role_count, [{file, "../var/cross_boss_role_count.dets"}, {keypos, #cross_boss_role_count.role_id}, {type, set}]),
    load_count(),
    %% load_pre_roles(), %% 导入上次活动中在准备区离线的玩家，如果中间关机，保证下次活动中上线能直接进入大厅
    ok.

%% 保存数据
save_data() ->
    save_count(ets:tab2list(ets_cross_boss_role_count)).

%% 导入玩家次数信息
load_count() ->
    case dets:first(dets_cross_boss_role_count) of
        '$end_of_table' -> ?INFO("中央服第一次启动跨服boss，DETS无玩家次数信息");
        _ ->
            dets:traverse(dets_cross_boss_role_count,
                fun(Data = #cross_boss_role_count{}) ->
                        ets:insert(ets_cross_boss_role_count, Data),
                        continue;
                    (_Data) ->
                        ?INFO("中央服DETS玩家次数信息错误：~w", [_Data]),
                        continue
                end
            ),
            ?INFO("中央服跨服boss数据导入完成，共~w条数据", [ets:info(ets_cross_boss_role_count, size)])
    end.

save_count([]) -> ok;
save_count([H = #cross_boss_role_count{} | T]) ->
    dets:insert(dets_cross_boss_role_count, H),
    save_count(T);
save_count([_H | T]) ->
    ?ERR("跨服boss关机保存玩家次数信息出错:~w", [_H]),
    save_count(T).

%% 获取当天本地时间的星期天数
get_day_of_week() ->
    {Date, _} = calendar:local_time(),
    calendar:day_of_the_week(Date).
%% 获取下次活动时间戳秒数
get_next_act_time() ->
    Day = get_day_of_week(),
    Today = util:unixtime(today),
    Now = util:unixtime(),
    StartCd1 = 9*3600 + 49*60,
    StartCd2 = 13*3600 + 49*60,
    if
        %% 周六或周日 10:00-12:00  14:00-16:00
        Day =:= 6 ->
            T1 = Today + StartCd1,
            T2 = Today + StartCd2,
            if
                Now < T1 -> T1 - Now;
                Now =:= T1 -> 1;
                true ->
                    if
                        Now < T2 -> T2 - Now;
                        Now =:= T2 -> 1;
                        true ->
                            (util:unixtime({tomorrow, Now}) - Now) + StartCd1
                    end
            end;
        Day =:= 7 ->
            T1 = Today + StartCd1,
            T2 = Today + StartCd2,
            if
                Now < T1 -> T1 - Now;
                Now =:= T1 -> 1;
                true ->
                    if
                        Now < T2 -> T2 - Now;
                        Now =:= T2 -> 1;
                        true ->
                            (util:unixtime({tomorrow, Now}) - Now) + 5*86400 + StartCd1
                    end
            end;
        true ->
            util:unixtime({tomorrow, Now}) - Now + (5-Day)*86400 + StartCd1
    end.

%% 获取可进入的准备区
get_enter_map(_FightLev, []) ->
    false;
get_enter_map(FightLev, [H = #cross_boss_map{fight_lev = FightLev, count = Count} | _T]) when Count < 110 ->
    {ok, H};
get_enter_map(FightLev, [_ | T]) ->
    get_enter_map(FightLev, T).

%% 获取匹配战力的大厅信息
get_enter_hall(FightLev, HallList) ->
    case lists:keyfind(FightLev, #cross_boss_mapping_hall.fight_lev, HallList) of
        false -> false;
        H -> {ok, H}
    end.

%% 添加新的准备区地图，增加相关映射关系
new_mapping() ->
    case map_mgr:create(30100) of
        {ok, MapPid, MapId} ->
            #cross_boss_map{map_id = MapId, map_pid = MapPid};
        _ ->
            ?ERR("新建跨服准备区地图失败"),
            #cross_boss_map{}
    end.

%% 更新某个准备区的信息
update_mapping(Mapping = #cross_boss_map{map_id = MapId}, List) ->
    case lists:keyfind(MapId, #cross_boss_map.map_id, List) of
        false ->
            List ++ [Mapping];
        _ ->
            lists:keyreplace(MapId, #cross_boss_map.map_id, List, Mapping)
    end.

%% 更新某个大厅的映射关系
update_mapping_hall(MappingHall = #cross_boss_mapping_hall{hall_id = HallId}, List) ->
    case lists:keyfind(HallId, #cross_boss_mapping_hall.hall_id, List) of
        false ->
            List ++ [MappingHall];
        _ ->
            lists:keyreplace(HallId, #cross_boss_mapping_hall.hall_id, List, MappingHall)
    end.

%% 更新准备区的玩家角色列表
add_pre_roles(RoleId, #cross_boss_map{map_id = MapId, map_pid = MapPid}) ->
    add_pre_roles(RoleId, MapId, MapPid).
add_pre_roles(RoleId, MapId, MapPid) ->
    ets:insert(ets_cross_boss_pre_roles, {RoleId, MapId, MapPid}).
del_pre_roles(RoleId) ->
    ets:delete(ets_cross_boss_pre_roles, RoleId).

%% 更新准备区玩家数量
add_pre_count(MapId, MappingList) ->
    case lists:keyfind(MapId, #cross_boss_map.map_id, MappingList) of
        false -> MappingList;
        M = #cross_boss_map{count = Cnt} ->
            lists:keyreplace(MapId, #cross_boss_map.map_id, MappingList, M#cross_boss_map{count = Cnt+1})
    end.
del_pre_count(MapId, MappingList) ->
    case lists:keyfind(MapId, #cross_boss_map.map_id, MappingList) of
        false -> MappingList;
        M = #cross_boss_map{count = Cnt} ->
            lists:keyreplace(MapId, #cross_boss_map.map_id, MappingList, M#cross_boss_map{count = Cnt-1})
    end.

%% 更新战斗信息列表
add_combat_info(CombatInfo = #cross_boss_combat{}) ->
    ets:insert(ets_cross_boss_combat_list, CombatInfo).
del_combat_info(CombatPid) ->
    ets:delete(ets_cross_boss_combat_list, CombatPid).
%% 查找战斗信息
find_combat_info(CombatPid) ->
    case ets:lookup(ets_cross_boss_combat_list, CombatPid) of
        [CI = #cross_boss_combat{}] -> {ok, CI};
        _ -> false
    end.

%% 转化为战斗角色
to_fighter(Rids) when is_list(Rids) ->
    to_fighter(Rids, []).
to_fighter([], Back) ->
    Back;
to_fighter([#hall_role{id = Rid} | T], Back) ->
    case c_proxy:role_lookup(by_id, Rid, to_fighter) of
        {ok, _, Fighter} ->
            to_fighter(T, [Fighter | Back]);
        _ ->
            to_fighter(T, Back)
    end;
to_fighter([25506 | T], Back) ->
    %% 战斗转换为fighter
    to_fighter(T, [25506, 25507] ++ Back);
to_fighter([BossBaseId | T], Back) ->
    %% 战斗转换为fighter
    to_fighter(T, [BossBaseId | Back]).

%% 转换为战斗角色信息
to_cross_boss_combat_role(#hall_role{id = Rid, name = Name, career = Career, lev = Lev, guild_name = Gname, sex = Sex, vip_type = VipType, fight_capacity = Fight}) ->
    #cross_boss_role{id = Rid, name = Name, career = Career, lev = Lev, guild_name = Gname, sex = Sex, vip_type = VipType, fight = Fight}.

%% 异步回调：进出地图
apply_enter_map(Role = #role{id = RoleId}, MapId) ->
    {X1, Y1} = util:rand_list([{1080,1230} ,{1920,1230} ,{1500,1410} ,{1500,1050}]), %% 随机点
    {X, Y} = {X1 + util:rand(-300, 300), Y1 + util:rand(-260, 260)},
    case map:role_enter(MapId, X, Y, Role#role{cross_srv_id = <<"center">>}) of
        {ok, NewRole} -> {ok, NewRole};
        _E ->
            ?ERR("进入跨服准备区地图失败：~w", [_E]),
            cross_boss:inform_center({fail_enter, RoleId}),
            {ok}
    end.
apply_leave_map(Role = #role{cross_srv_id = <<"center">>}) ->
    Rand = util:rand(-100, 100),
    X = util:rand_list([1620, 1380]) + Rand,
    Y = util:rand_list([3540, 3720]) + Rand,
    case map:role_enter(10003, X, Y, Role#role{cross_srv_id = <<>>}) of
        {ok, NewRole} -> {ok, NewRole};
        _E ->
            ?ERR("退出跨服准备区地图失败：~w", [_E]),
            {ok}
    end;
apply_leave_map(_Role) ->
    ?ERR("跨服boss挑战，玩家异步离开准备区地图异常[NAME:~s, SRV:~s]", [_Role#role.name, _Role#role.cross_srv_id]),
    {ok}.
sync_leave_map(Role = #role{cross_srv_id = <<"center">>}) ->
    Rand = util:rand(-100, 100),
    X = util:rand_list([1620, 1380]) + Rand,
    Y = util:rand_list([3540, 3720]) + Rand,
    case map:role_enter(10003, X, Y, Role#role{cross_srv_id = <<>>}) of
        {ok, NewRole} -> {ok, ok, NewRole};
        _E ->
            ?ERR("退出跨服准备区地图失败：~w", [_E]),
            {ok, false}
    end;
sync_leave_map(_Role) ->
    ?ERR("跨服boss挑战，玩家同步离开准备区地图异常[NAME:~s, SRV:~s]", [_Role#role.name, _Role#role.cross_srv_id]),
    {ok, false}.

%% 异步回调：进出大厅
apply_leave_hall(Role = #role{pid = Pid, event = ?event_hall, hall = #role_hall{id = HallId, pid = HallPid}}) ->
    role:pack_send(Pid, 16811, {?true, ?L(<<"您今天剩余挑战BOSS次数为0，自动退出房间">>)}),
    hall:leave_room(HallId, Role),
    hall:leave(HallPid, Role),
    {ok};
apply_leave_hall(_Role) ->
    ?ERR("玩家异步退出大厅失败：~w", [{_Role#role.event, _Role#role.hall}]),
    {ok}.

%% 检查玩家挑战次数判断是否需要踢出大厅
check_leave_hall([]) -> ok;
check_leave_hall([CrossBossRole | T]) ->
    check_leave_hall(CrossBossRole),
    check_leave_hall(T);
check_leave_hall(#cross_boss_role{id = RoleId}) ->
    case get_enter_count(RoleId) > 0 of
        true -> ignore;
        false ->
            case c_proxy:role_lookup(by_id, RoleId, #role.pid) of
                {ok, _, Pid} ->
                    role:apply(async, Pid, {cross_boss_mgr, apply_leave_hall, []});
                _ -> ignore
            end
    end.

%% 检查房间玩家是否都可以挑战此boss
check_enter_combat(_BossId, []) -> ok;
check_enter_combat(BossId, [#hall_role{id = RoleId, name = RoleName} | T]) ->
    case ets:lookup(ets_cross_boss_role_count, RoleId) of
        [#cross_boss_role_count{boss = BossList}] ->
            case lists:member(BossId, BossList) of
                true ->
                    {false, util:fbin(?L(<<"~s 已经挑战过该boss，无法发起挑战">>), [RoleName])};
                false ->
                    check_enter_combat(BossId, T)
            end;
        _ ->
            {false, ?L(<<"无法发起战斗">>)}
    end.

%% 销毁地图
destroy_map([]) -> ok;
destroy_map([#cross_boss_map{map_pid = MapPid} | T]) ->
    map:stop(MapPid),
    destroy_map(T).

%% 销毁大厅
destroy_hall([]) -> ok;
destroy_hall([#cross_boss_mapping_hall{hall_id = HallId} | T]) ->
    hall_mgr:stop(HallId),
    destroy_hall(T).

%% 创建大厅列表
create_hall() ->
    L = fight_lev_list(),
    create_hall(L, []).
create_hall([], BackL) -> BackL;
create_hall([FightLev | T], BackL) ->
    case hall_mgr:create(hall_data:get_hall(2)) of
        {ok, HallId, HallPid} ->
            create_hall(T, [#cross_boss_mapping_hall{fight_lev = FightLev, hall_id = HallId, hall_pid = HallPid} | BackL]);
        _ ->
            create_hall(T, BackL)
    end.

%% 踢出地图
kick_out() ->
    L = ets:tab2list(ets_cross_boss_pre_roles),
    lists:foreach(fun({RoleId, _, _}) ->
            case c_proxy:role_lookup(by_id, RoleId, #role.pid) of
                {ok, _Node, Pid} ->
                    role:apply(sync, Pid, {cross_boss_mgr, sync_leave_map, []});
                _ ->
                    ok
            end
    end, L).

%% 奖励
handle_award(_Resault, _BossId, _Data, []) ->
    ok;
handle_award(win, BossId, Data, [#cross_boss_role{id = RoleId = {_, SrvId}, name = Name} | T]) ->
    case c_proxy:role_lookup(by_id, RoleId, #role.pid) of
        {ok, _N, Pid} -> %% TODO: 这个判定可能会有问题，接下来的异步可能失败，可能成功
            role:apply(async, Pid, {cross_boss, handle_award, [BossId, Data]});
        _ ->
            c_mirror_group:cast(node, SrvId, cross_boss, handle_award_offline, [RoleId, Name, BossId, Data])
    end,
    handle_award(win, BossId, Data, T);
handle_award(lose, BossId, Data, [#cross_boss_role{id = RoleId} | T]) ->
    case c_proxy:role_lookup(by_id, RoleId, #role.pid) of
        {ok, _N, Pid} ->
            role:apply(async, Pid, {cross_boss, handle_lose, [BossId]});
        _ ->
            ignore
    end,
    handle_award(lose, BossId, Data, T).

%% 转为名人榜需求数据
to_rank_celebrity_data(Roles) when is_list(Roles) ->
    [{Id, SrvId, Name, Career, Sex} || #cross_boss_role{id = {Id, SrvId}, name = Name, career = Career, sex = Sex} <- Roles];
to_rank_celebrity_data(_) -> [].

%% 通知战斗发起失败
notice_combat_fail(_Msg, []) -> ok;
notice_combat_fail(Msg, [#hall_role{pid = Pid} | T]) ->
    role:pack_send(Pid, 16811, {?false, Msg}),
    notice_combat_fail(Msg, T).

%% 活动通知
broadcast(State) ->
    c_mirror_group:cast(all, cross_boss_mgr, broadcast_srv, [State]).

do_broadcast(prepare) ->
    role_group:pack_cast(world, 16801, {?cross_boss_status_prepare, ?DEF_PREPARE_INTERVAL_TIME}),
    notice:send(54, ?L(<<"飞仙巅峰，进阶天位！神秘的穹苍天府即将开启，请飞仙同道做好准备，突破极限的天位之战马上就要开始！">>));
do_broadcast(active) ->
    role_group:pack_cast(world, 16801, {?cross_boss_status_active, ?DEF_ACTIVE_INTERVAL_TIME}),
    notice:send(54, ?L(<<"穹苍天府已经开启，天位之战正式开始，请飞仙同道前往进入准备区，迎接突破自身极限的战斗吧！{open,34,我要参加,#00ff24}">>));
do_broadcast(stop) ->
    role_group:pack_cast(world, 16801, {?cross_boss_status_idel, 0}),
    notice:send(54, ?L(<<"本次天位之战已经结束，晋升天位难得，请各位飞仙同道在下一次天位之战开始时准时参加！">>));
do_broadcast(_) ->
    ok.
