%%----------------------------------------------------
%% 副本进程: 维护当前副本的状态
%%
%% @author yeahoo2000@gmail.com, abu@jieyou.cn
%% @end
%%----------------------------------------------------
-module(dungeon).
-behaviour(gen_fsm).
-export([
         active/2   %% 激活状态
        ,pause/2    %% 暂停状态
        ,idle/2     %% 空闲状态
    ]
).

%% 有关副本进程的行为的方法
-export([
        start/1             %% 启动副本
        ,start/2             %% 启动副本
        ,get_enter_point/1  %% 取得进入副本的初始点
        ,stop/1             %% 关闭副本
        ,leave/2            %% 玩家退出副本
        ,logout/2           %% 玩家在副本内掉线
        ,enter/3            %% 玩家进入副本
        ,login/2            %% 玩家在副本内上线
        ,switch/2          
        ,get_info/1         %% 取得副本进程的state
        ,post_event/2       %% 向副本进程投递事件
        ,info/1             %% 打印进程信息
        ,to_dungeon_role/1  %% 转换角色数据
        ,get_online_roles/1  %% 获取副本里所有在线玩家的{rid, pid}
        ,combat_start/1          %% 开始战斗
        ,combat_over/2           %% 结束战斗
        ,expedition_fight_start/1

        ,combat2_info/2           %% 休闲玩法战斗结束统计信息
    ]
).

%% gen_fsm callback
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-include("common.hrl").
-include("dungeon.hrl").
-include("role.hrl").
-include("map.hrl").
-include("pos.hrl").
-include("link.hrl").

-define(TIMEOUT_IDLE, 20 * 60 * 1000).   %% 空闲状态保持20分钟，所有玩家掉线后进入空闲状态

-define(debug_log(P), ?DEBUG("type=~w, value=~w", P)).

%% --------------------------------------------------------------------
%% 对外接口
%%---------------------------------------------------------------------
%% 创建副本
start(Data) ->
    start(Data, 1).
start(Data = #dungeon{is_cross = IsCross}, Floor) ->
    case catch gen_fsm:start(?MODULE, [Data, Floor], []) of
        {ok, Pid} -> 
            ?debug_log([start, Pid]),
            case IsCross of
                true ->
                    dungeon_mgr_center:dungeon_started(Pid);
                _ ->
                    dungeon_mgr:dungeon_started(Pid)
            end,
            {ok, Pid};
        _Err ->
            ?ERR("创建副本时发生异常: ~w, ~w", [_Err, Data]),
            {false, ?L(<<"创建副本时发生异常">>)}
    end.

%% 获取副本默认进入点
get_enter_point(Pid) ->
    gen_fsm:sync_send_all_state_event(Pid, get_enter_point).

%% @spec enter(Pid, Role) -> 
%% Pid = pid()
%% 进入副本
enter(Pid, DungeonId, Role = #role{dungeon = RoleDungeons}) when is_pid(Pid) ->
    %%进入副本时记录之前已达成的副本目标
    DungeonRole = to_dungeon_role(Role),
    DungeonRole2 = case lists:keyfind(DungeonId, #role_dungeon.id, RoleDungeons) of
        #role_dungeon{reach_goals = ReachGoals, clear_count = ClearCount} ->
            DungeonRole#dungeon_role{goals = ReachGoals, clear_count = ClearCount};
        _ ->
            DungeonRole
    end,
    Pid ! {enter, DungeonRole2};
enter(_, _, _) ->
    ok.

%% @spec leave(Pid, RoleId) ->
%% Pid = pid()
%% RoleId = {}
%% 退出副本
leave(Pid, Role = #role{}) ->
    leave(Pid, to_dungeon_role(Role));
leave(Pid, DunRole = #dungeon_role{}) when is_pid(Pid) ->
    Pid ! {leave, DunRole};
leave(_Pid, _DunRole) ->
    %?ERR("角色退出副本发生异常: ~w, ~w", [_Pid, _DunRole]),
    ok.

%% @spec stop(Pid) ->
%% Pid = pid()
%% 关闭副本
stop(Pid) ->
    Pid ! stop.

%% @spec logout(Dpid, Rid) ->
%% Dpid = pid()
%% Rid = #role.id
%% 用户下线通知
logout(Dpid, Role = #role{}) ->
    logout(Dpid, to_dungeon_role(Role));
logout(Dpid, DunRole = #dungeon_role{}) when is_pid(Dpid) ->
    Dpid ! {logout, DunRole};
logout(_Dpid, _Rid) ->
    ok.

%% @spec login(Dpid, Rid) ->
%% Dpid = pid()
%% Rid = #role.id
%% 用户上线通知
login(Dpid, Role = #role{}) ->
    login(Dpid, to_dungeon_role(Role));
login(Dpid, DunRole = #dungeon_role{}) when is_pid(Dpid) ->
    Dpid ! {login, DunRole};
login(_Dpid, _Rid) ->
    ok.

switch(DungeonPid, Role = #role{}) when is_pid(DungeonPid) ->
    DungeonPid ! {switch, to_dungeon_role(Role)};
switch(_, _) ->
    ok.

%% @spec get_info(Dpid) -> {ok, #dungeon{}} | {false, Reason}
%% Dpid = pid()
%% 获取副本信息
get_info(DungeonPid) ->
    case is_pid(DungeonPid) of
        true ->
            gen_fsm:sync_send_all_state_event(DungeonPid, get_info);
        false ->
            {false, ?L(<<"不存在此副本">>)}
    end.

%% @spec post_event(Dpid, Event) 
%% Dpid = pid()
%% Event = term()
%% 向副本投递事件
post_event(DungeonPid, Event) ->
    DungeonPid ! {event, self(), Event}.

%% 打印进程信息
info(Dpid) ->
    Dpid ! {info}.

get_online_roles(DungeonPid) ->
    case is_pid(DungeonPid) of
        true ->
            gen_fsm:sync_send_all_state_event(DungeonPid, get_online_roles);
        false ->
            []
    end.

%% @spec combat_over(Dpid, Result) ->
%% Dpid = pid()
%% Rid = #role.id
%% 战斗结束
combat_over(Dpid, Result) when is_pid(Dpid) ->
    Dpid ! {combat_over, Result, self()};
combat_over(_Dpid, _Result) ->
    ok.

%% @spec combat_start(Dpid) ->
%% Dpid = pid()
%% Rid = #role.id
%% 角色死亡通知
combat_start(Dpid) when is_pid(Dpid) ->
    Dpid ! {combat_start, self()};
combat_start(_Dpid) ->
    ok.

expedition_fight_start(Pid) ->
    gen_fsm:sync_send_all_state_event(Pid, expedition_fight_start).

%% @spec combat2_info(Dpid, Message) -> ok
%% Dpid = pid()
combat2_info(Dpid, Message) when is_pid(Dpid) ->
    Dpid ! {combat2_info, Message};
combat2_info(_Dpid, _Message) ->
    ok.

%% --------------------------------------------------------------------
%% 内部处理
%% --------------------------------------------------------------------

init([D = #dungeon{id = Id, type = Type, maps = Maps, enter_point = {EBaseId, Ex, Ey}, extra = Extra}, Floor]) ->
    process_flag(trap_exit, true),
    case create_map(Maps, Floor, []) of
        false -> {stop, create_maps_failure};
        MapList ->
            case Type of
                ?dungeon_type_hide ->
                    [{is_opened, IsOpened}] = Extra,
                    [{_MapId, MapPid, _MapBaseId}] = MapList,
                    map:init_hide_box(MapPid, IsOpened);
                _ ->
                    ignore
            end,
            Handler = dungeon_event:get_event_handler(Id),
            NewState = trigger_event(Handler, {dungeon_started}, self(), D#dungeon{maps = MapList, enter_point = {find_map_id(MapList, EBaseId, Floor), Ex, Ey}, event_handler = Handler}),
            {ok, active, NewState}
    end.

handle_event(_Event, StateName, State) ->
    {next_state, StateName, State}.

%% 取得进入副本后的初始点
handle_sync_event(get_enter_point, _From, StateName, State = #dungeon{enter_point = EnterPoint}) ->
    {reply, EnterPoint, StateName, State};

handle_sync_event(expedition_fight_start, _From, StateName, State = #dungeon{extra = Extra}) ->
    Reply = case get(expedition_fight_start) of
        true ->
            false;
        _ ->
            put(expedition_fight_start, true),
            case lists:keyfind(followers, 1, Extra) of
                {followers, Followers} ->
                    {true, Followers};
                _ ->
                    false
            end     
    end,
    {reply, Reply, StateName, State};

%% 取得副本信息
handle_sync_event(get_info, _From, StateName, State) ->
    {reply, {ok, State}, StateName, State};

handle_sync_event(get_online_roles, _From, StateName, State = #dungeon{online_roles = OnlineRoles}) ->
    Pids = [{Rid, Pid} || #dungeon_role{rid = Rid, pid = Pid} <- OnlineRoles],
    {reply, Pids, StateName, State};

handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    {reply, Reply, StateName, State}.

%% 进入副本
handle_info({enter, DunRole = #dungeon_role{rid = _Rid}}, _StateName, State = #dungeon{id = _Did, event_handler = Handler}) ->
    ?debug_log([enter, {_Rid, self()}]),
    State2 = trigger_event(Handler, {role_enter, DunRole}, self(), State),
    State3 = enter_dungeon(DunRole, State2),
    {next_state, active, State3};

%% 副本里的角色上线
handle_info({login, #dungeon_role{pid = Rpid}}, _StateName, State = #dungeon{online_roles = Roles, id = BaseId}) when length(Roles) >= 3 ->
    role:apply(async, Rpid, {fun do_leave/2, [BaseId]}),
    {next_state, active, State};
handle_info({login, DunRole = #dungeon_role{rid = Rid}}, _StateName, State = #dungeon{offline_roles = Oroles, event_handler = Handler}) ->
    ?debug_log([login, {Rid, self()}]),
    NewState = trigger_event(Handler, {role_login, DunRole}, self(), State),
    NewState2 = enter_dungeon(DunRole, NewState),
    NewOroles = lists:delete(Rid, Oroles),
    {next_state, active, NewState2#dungeon{offline_roles = NewOroles}};

handle_info({switch, DungeonRole = #dungeon_role{rid = Rid, pid = Pid, conn_pid = ConnPid}}, _StateName,
    State = #dungeon{online_roles = OnlineRoles, event_handler = Handler}) ->

    State2 = trigger_event(Handler, {role_login, DungeonRole}, self(), State),
    OnlineRoles2 = case lists:keyfind(Rid, #dungeon_role.rid, OnlineRoles) of 
        false ->
            OnlineRoles;
        _DungeonRole ->
            _DungeonRole2 = _DungeonRole#dungeon_role{pid = Pid, conn_pid = ConnPid},
            lists:keyreplace(Rid, #dungeon_role.rid, OnlineRoles, _DungeonRole2)
    end,
    State3 = State2#dungeon{online_roles = OnlineRoles2},
    {next_state, active, State3};

%% 退出副本
handle_info({leave, DunRole = #dungeon_role{rid = _Rid}}, _StateName, State = #dungeon{offline_roles = Oroles, event_handler = Handler}) ->
    ?debug_log([leave, {_Rid, self()}]),
    NewState = trigger_event(Handler, {role_leave, DunRole}, self(), State),
    NewState2 = #dungeon{online_roles = Roles} = leave_dungeon(DunRole, NewState),
    case {Roles, Oroles} of
        {[], []} ->
            {stop, shutdown, NewState2};
        {[], _} ->
            {next_state, idle, NewState2, idle_timeout(State)};
        _ ->
            {next_state, active, NewState2}
    end;

%% 副本里的角色掉线
handle_info({logout, DunRole = #dungeon_role{rid = Rid}}, _StateName, State = #dungeon{offline_roles = Oroles, event_handler = Handler}) ->
    ?debug_log([logout, {Rid, self()}]),
    NewState = trigger_event(Handler, {role_logout, DunRole}, self(), State),
    NewState2 = #dungeon{online_roles = Roles} = leave_dungeon(DunRole, NewState),
    NewOroles = [Rid | Oroles],
    case Roles of
        [] ->
            {next_state, idle, NewState2#dungeon{offline_roles = NewOroles}, idle_timeout(State)};
        _ ->
            {next_state, active, NewState2#dungeon{offline_roles = NewOroles}}
    end;

%% 战斗开始
handle_info({combat_start, CombatPid}, StateName, State) ->
    {next_state, StateName, State#dungeon{combat_status = start, combat_pid = CombatPid}};

%% 战斗结束
handle_info({combat_over, Result, CombatPid}, StateName, State) ->
    put(expedition_fight_start, false),
    case State#dungeon.combat_pid of
        CombatPid ->
            {next_state, StateName, State#dungeon{combat_status = Result, combat_pid = undefined}};
        _ -> 
            {next_state, StateName, State}
    end;

%% 副本评分事件
handle_info({dungeon_score, Round, NpcBaseIds, ScoreData}, StateName, State = #dungeon{event_handler = Handler}) ->
    ?debug_log([dungeon_score, {Round, NpcBaseIds, ScoreData}]),
    NewState = trigger_event(Handler, {dungeon_score, Round, NpcBaseIds, ScoreData}, self(), State),
    {next_state, StateName, NewState};

%% 接收事件
handle_info({event, From, Event}, StateName, State = #dungeon{event_handler = Handler}) ->
    ?debug_log([event, {Event, self()}]),
    NewState = trigger_event(Handler, Event, From, State),
    {next_state, StateName, NewState};

%% 退出
handle_info(stop, _StateName, State) ->
    {stop, normal, State};

%% 打印进程信息
handle_info({info}, StateName, State = #dungeon{combat_round = _CombatRound, offline_roles = _Oroles, online_roles = _Roles, enter_roles = _Eroles}) ->
    ?debug_log([combat_round, _CombatRound]),
    ?debug_log([offline_roles, _Oroles]),
    ?debug_log([online_roles, _Roles]),
    ?debug_log([enter_roles, _Eroles]),
    {next_state, StateName, State};

%% 存休闲玩法战斗结束信息
handle_info({combat2_info, {NpcHp, RoleHp, _Round}}, StateName, State) ->
    put(combat2_goal_result, {NpcHp, RoleHp, State#dungeon.kill_count}),
    {next_state, StateName, State};

handle_info(_Info, StateName, State) ->
    {next_state, StateName, State}.

terminate(_Reason, _StateName, State = #dungeon{event_handler = Handler, is_cross = IsCross}) ->
    ?debug_log([stop, self()]),
    trigger_event(Handler, {dungeon_stoped}, self(), State),
    case IsCross of
        true ->
            dungeon_mgr_center:dungeon_stoped(self());
        _ ->
            dungeon_mgr:dungeon_stoped(self())
    end,
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%% ----------------------------------------------------
%% 状态处理
%% ----------------------------------------------------

%% 激活状态
active(timeout, _State = #dungeon{online_roles = _Roles}) ->
    ?debug_log([active_timeout, self()]);
active(_Any, State) ->
    continue(active, State).

%% 暂停状态
pause(_Any, State) ->
    continue(pause, State).

%% 空闲状态超时，关闭副本
idle(timeout, State) ->
    ?debug_log([idle_timeout, self()]),
    {stop, normal, State};

idle(_Any, State) ->
    continue(idle, State).

%% --------------------------------------------------------------------
%% 私有函数
%% --------------------------------------------------------------------

%% 重新计算超时时间，继续某一状态
continue(active, State) ->
    {next_state, active, State};
continue(pause, State) ->
    {next_state, pause, State};
continue(idle, State = #dungeon{ts = Ts}) ->
    {next_state, idle, State, util:time_left(?TIMEOUT_IDLE, Ts)}.

%% 根据BaseId查找对应的ID
find_map_id([], _BaseId, _Floor) -> 
    0; 
find_map_id([{MapId, _Pid, EBaseId} | _], BaseId, Floor) when EBaseId =:= BaseId andalso Floor =< 1 -> 
    MapId;
find_map_id(Maps, BaseId, Floor) when Floor > 1 ->
    case length(Maps) >= Floor of
        true ->
            {MapId, _, _} = lists:nth(Floor, Maps),
            MapId;
        false ->
            find_map_id(Maps, BaseId, 1)
    end;
find_map_id([_H | T], BaseId, Floor) -> find_map_id(T, BaseId, Floor).

%% 创建副本相关地图
create_map([], _Floor, L) -> lists:reverse(L);
create_map([MapBaseId | T], Floor, L) when Floor =< 1 ->
    case map_mgr:create(MapBaseId) of
        {false, Reason} ->
            ?ERR("副本进程创建地图失败: ~s", [Reason]),
            false;
        {ok, MapPid, MapId} -> 
            create_map(T, Floor, [{MapId, MapPid, MapBaseId} | L])
    end;
create_map([MapBaseId | T], Floor, L) ->
    case map_mgr:create(no_npc, MapBaseId) of
        {false, Reason} ->
            ?ERR("副本进程创建地图失败: ~s", [Reason]),
            false;
        {ok, MapPid, MapId} -> 
            create_map(T, Floor - 1, [{MapId, MapPid, MapBaseId} | L])
    end.

%% 触发副本事件
trigger_event(Module, Event, From, State) ->
    Module:handle_event(Event, From, State).

%% 转换为副本玩家
to_dungeon_role(#role{id = Rid, pid = Pid, link = #link{conn_pid = ConnPid}, name = Name, sex = Sex, career = Career}) ->
    #dungeon_role{rid = Rid, pid = Pid, conn_pid = ConnPid, name = Name, sex = Sex, career = Career}.

%% 处理进入
enter_dungeon(DungeonRole = #dungeon_role{rid = Rid, pid = Pid, conn_pid = ConnPid}, State = #dungeon{online_roles = OnlineRoles, enter_roles = EnterRoles}) ->
    {DungeonRole2, EnterRoles2} = case lists:keyfind(Rid, #dungeon_role.rid, EnterRoles) of 
        false ->
            {DungeonRole, [DungeonRole | EnterRoles]};
        _DungeonRole ->
            _DungeonRole2 = _DungeonRole#dungeon_role{pid = Pid, conn_pid = ConnPid},
            {_DungeonRole2, lists:keyreplace(Rid, #dungeon_role.rid, EnterRoles, _DungeonRole2)}
    end,
 
    OnlineRoles2 = case lists:keyfind(Rid, #dungeon_role.rid, OnlineRoles) of 
        false ->
            [DungeonRole2 | OnlineRoles];
        _ ->
            OnlineRoles
    end,
    State#dungeon{online_roles = OnlineRoles2, enter_roles = EnterRoles2}.

%% 处理退出
leave_dungeon(DungeonRole = #dungeon_role{rid = Rid}, State = #dungeon{online_roles = OnlineRoles, enter_roles = EnterRoles}) ->
    {DungeonRole2, OnlineRoles2} = case lists:keyfind(Rid, #dungeon_role.rid, OnlineRoles) of
        false ->
            {DungeonRole, OnlineRoles};
        _DungeonRole ->
            {_DungeonRole, lists:keydelete(Rid, #dungeon_role.rid, OnlineRoles)}
    end,

    EnterRoles2 = lists:keyreplace(Rid, #dungeon_role.rid, EnterRoles, DungeonRole2),
    State#dungeon{online_roles = OnlineRoles2, enter_roles = EnterRoles2}.

%% 计算副本空闲状态的时间
idle_timeout(_) ->
    ?TIMEOUT_IDLE.

%% 跟出副本
do_leave(Role, BaseId) ->
    dungeon_type:role_leave(Role, dungeon_data:get(BaseId)).

