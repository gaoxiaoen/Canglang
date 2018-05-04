%%----------------------------------------------------
%% NPC进程
%%
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(npc).
-behaviour(gen_fsm).
-export([
        patrol/2    %% 巡逻
        ,trace/2    %% 追踪
        ,combat/2   %% 战斗
        ,freeze/2   %% 定住
    ]
).
-export( [
        start_link/1
        ,stop/1
        ,stop/2
        ,enter_map/4
        ,fight/2
        ,fight/3
        ,fight/4
        ,fight_info/2
        ,pause/1
        ,resume/1
        ,reload/1
        ,fighter_group/2
        ,enable/1
        ,disable/2
        ,cast_fight_status/4
    ]
).
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).
-include("common.hrl").
-include("role.hrl").
-include("npc.hrl").
-include("combat.hrl").
-include("pos.hrl").
-include("link.hrl").
-include("map.hrl").
%%
-include("team.hrl").
-include("task.hrl").
-include("attr.hrl").
-include("dungeon.hrl").
-include("expedition.hrl").

-define(TIMEOUT_COMBAT, 10000).    %% 每10秒检查一次战斗进程

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------

%% @spec start_link(Npc) -> ok
%% Npc = #npc{}
%% @doc 创建怪物进程
start_link(Npc) ->
    gen_fsm:start_link(?MODULE, [Npc], []).

%% @spec stop(Id) -> ok
%% @doc 移除指定的NPC
stop(Id) when is_pid(Id) ->
    Id ! stop;
stop(Id) ->
    case npc_mgr:lookup(by_id, Id) of
        #npc{pid = Pid} -> stop(Pid);
        _ -> ok
    end.
%% @spec stop(by_base_id, BaseId) -> ok
%% BaseId = integer()
%% @doc 移除指定BaseId的所有NPC
stop(by_base_id, BaseId) ->
    case npc_mgr:lookup(by_base_id, BaseId) of
        false -> ok;
        Npcs -> do_stop(Npcs)
    end.
do_stop([]) -> ok;
do_stop([#npc{pid = Pid} | T]) when is_pid(Pid) ->
    Pid ! stop,
    do_stop(T);
do_stop([_ | T]) ->
    do_stop(T).

%% @spec enter_map(NpcPid, MapGid, X, Y) -> ok
%% NpcPid = pid()
%% MapGid = {integer(), int()}
%% X = integer()
%% Y = integer()
%% @doc 进入指定地点
enter_map(NpcPid, MapGid, X, Y) ->
    NpcPid ! {enter_map, MapGid, X, Y}.

%% @spec 广播战斗状态,(目前仅洛水反击采用)
%% @doc 进入指定地点
cast_fight_status(?combat_type_guard_counter, Referees, AtkList, DfdList) ->
    case lists:keyfind(guard_counter_npc, 1, Referees) of
        {guard_counter_npc, NpcPid} ->
            guard_counter:combat_start({Referees, [{GuardRid, GuardSrvId} || #fighter{type = ?fighter_type_role, rid = GuardRid, srv_id = GuardSrvId} <- AtkList ++ DfdList]}),
            NpcPid ! {cast_fight_status, 1};
        _ -> skip
    end;
cast_fight_status(?combat_type_guild_td, [{npc_pid, NpcPid}], _AtkList, _DfdList) ->
    NpcPid ! {cast_fight_status, 1};
cast_fight_status(_CombatType, _Referee, _AtkList, _DfdList) -> skip.

%% @spec fight(NpcId, Role) -> true | {false, Reason}
%% NpcId = integer()
%% Role = NewRole = #role{}
%% Reason = bitstring()
%% @doc 某角色对指定NPC发起战斗
fight(Npc, Role) ->
    fight(Npc, Role, ?combat_type_npc).

fight(Npc, Role, CombatType) when is_record(Npc, npc) -> 
    do_fight(Npc, Role, CombatType, undefined);
fight(NpcId, Role, CombatType) ->
    fight(NpcId, Role, CombatType, undefined).

fight(Npc, Role, CombatType, Referees) when is_record(Npc, npc) -> 
    case fight_special_check(Npc, Role) of
        {false, Reason} ->
            {false, Reason};
        _ ->
            do_fight(Npc, Role, CombatType, Referees)
    end;
fight(NpcId, Role = #role{cross_srv_id = CrossSrvId}, CombatType, Referees) ->
    case npc_mgr:get_npc(CrossSrvId, NpcId) of
        false -> 
            {false, ?L(<<"目标不存在，无法发起战斗">>)};
        Npc = #npc{} ->
            fight(Npc, Role, CombatType, Referees)
    end.

do_fight(#npc{disabled = Disabled}, _Role, _, _) when Disabled =/= <<>> ->
    {false, Disabled};
do_fight(#npc{pos = #pos{map = NmapId, x = Nx, y = Ny}}, #role{pos = #pos{map = MapId, x = X, y = Y}}, _, _) when (NmapId =/= MapId) orelse (abs(Nx - X) > 2000) orelse (abs(Ny - Y) > 2000) ->
    {false, ?L(<<"距离目标太远，无法发起战斗">>)};
do_fight(#npc{special_type = ?npc_special_type_fly}, #role{ride = ?ride_no}, _, _) ->
    {false, ?L(<<"飞行怪物只有飞行状态才可击杀">>)};

%% 帮会boss
do_fight(Npc = #npc{id = NpcId, name = _Name, owner = _Owner, fun_type = ?npc_fun_type_guild_boss}, Role = #role{pos = #pos{map_pid = MapPid}}, _CombatType, Referees) ->
    Referees1 = case is_list(Referees) of
        true -> [{common, MapPid}] ++ Referees;
        false -> MapPid
    end,
    case catch guild_boss:get_current_status(Role, NpcId) of
        {ok, CurHp} when is_integer(CurHp) andalso CurHp > 0 ->
            ?DEBUG("发起战斗时帮会boss的当前血量是:~w", [CurHp]),
            {ok, CF = #converted_fighter{fighter = F}} = npc_convert:do(to_fighter, Npc),
            CF1 = CF#converted_fighter{fighter = F#fighter{hp = CurHp}},
            DfdList = [CF1],
            case combat:start(?combat_type_npc, Referees1, role_api:fighter_group(Role), DfdList) of
                {ok, _CombatPid} -> ok;
                {error, _Err} -> ?ELOG("玩家对[~s]发起战斗失败:~w", [_Name, _Err])
            end,
            true;
        {ok, CurHp1} when is_integer(CurHp1) andalso CurHp1 =< 0 -> {false, util:fbin(?L(<<"~s已经死亡">>), [_Name])};
        _ -> {false, util:fbin(?L(<<"无法对~s发起战斗">>), [_Name])}
    end;

%% 击杀洛水反击BOSS
do_fight(Npc = #npc{id = _NpcId, name = _Name, owner = _Owner, fun_type = ?npc_fun_type_guard_counter_boss}, Role = #role{pos = #pos{map_pid = MapPid}}, _CombatType, Referees) ->
    Referees1 = case is_list(Referees) of
        true -> [{common, MapPid}] ++ Referees;
        false -> MapPid
    end,
    case catch guard_counter:get_current_status() of
        {ok, CurHp} when is_integer(CurHp) andalso CurHp > 0 ->
            ?DEBUG("发起战斗时洛水boss的当前血量是:~w", [CurHp]),
            {ok, CF = #converted_fighter{fighter = F}} = npc_convert:do(to_fighter, Npc),
            CF1 = CF#converted_fighter{fighter = F#fighter{hp = CurHp}},
            DfdList = [CF1],
            case combat:start(?combat_type_npc, Referees1, role_api:fighter_group(Role), DfdList) of
                {ok, _CombatPid} -> ok;
                {error, _Err} -> ?ELOG("玩家对[~s]发起战斗失败:~w", [_Name, _Err])
            end,
            true;
        {ok, CurHp1} when is_integer(CurHp1) andalso CurHp1 =< 0 -> {false, util:fbin(?L(<<"~s已经死亡">>), [_Name])};
        _Err ->
            ?DEBUG("~w",[_Err]),
            {false, util:fbin(?L(<<"无法对~s发起战斗">>), [_Name])}
    end;

%% 帮会副本怪
do_fight(#npc{pid = Pid, slave = Slave, owner = OwnerId}, Role, CombatType = ?combat_type_guild_td, _Referees) when is_pid(Pid) ->
    Pid ! {fight, role_api:fighter_group(Role), CombatType, {[{npc_pid, Pid}], Slave, OwnerId}},
    true;

%% 洛水反击
do_fight(#npc{pid = Pid, slave = Slave, owner = OwnerId}, Role = #role{pos = #pos{map_pid = MapPid}}, CombatType = ?combat_type_guard_counter, Referees) when is_pid(Pid) ->
    Referees1 = case is_list(Referees) of
        true -> [{common, MapPid}, {guard_counter_npc, Pid}] ++ Referees;
        false -> MapPid
    end,
    Pid ! {fight, role_api:fighter_group(Role), CombatType, {Referees1, Slave, OwnerId}},
    true;

%% 旧远征王军
% do_fight(Npc = #npc{base_id = NpcBaseId, name = _Name}, Role = #role{pos = #pos{map_pid = MapPid}, event_pid = EventPid},
%     CombatType = ?combat_type_expedition, Referees) ->
%     case dungeon:expedition_fight_start(EventPid) of
%         true ->
%             Referees2 = add_referee(Referees, MapPid),
%             DfdList = fighter_group(Npc, Role),
%             case combat:start(CombatType, Referees2, role_api:fighter_group(Role), DfdList, expedition_data:get(NpcBaseId)) of
%                 {ok, _CombatPid} -> 
%                     ok;
%                 {error, _Err} -> 
%                     ?ELOG("玩家对[~s]发起战斗失败:~w", [_Name, _Err])
%             end,
%             true;
%         false ->
%             false
%     end;
%% 新远征王军
do_fight(Npc = #npc{base_id = NpcBaseId, name = _Name}, Role = #role{pos = #pos{map_pid = MapPid}, event_pid = EventPid},
    CombatType = ?combat_type_expedition, Referees) ->
    case dungeon:expedition_fight_start(EventPid) of
        {true, Followers} ->
            Referees2 = add_referee(Referees, MapPid),
            DfdList = fighter_group(Npc, Role),
            {ok, F} = role_convert:do(to_fighter, Role),
            AtkList0 = lists:foldr(fun(Follower, Acc) ->
                case role_convert:do(to_fighter, {Follower, clone}) of
                    {ok, CF} -> [CF|Acc];
                    _ -> Acc
                end
            end, [F], Followers),
            AtkList = lists:reverse(AtkList0),
            case combat:start(CombatType, Referees2, AtkList, DfdList, expedition_data:get(NpcBaseId)) of
                {ok, _CombatPid} -> 
                    ok;
                {error, _Err} -> 
                    ?ELOG("玩家对[~s]发起战斗失败:~w", [_Name, _Err])
            end,
            true;
        false ->
            {false, ?MSGID(<<"玩家发起战斗失败">>)}
    end;

%%生存模式
do_fight(Npc = #npc{name = _Name}, Role = #role{event_pid = EventPid, pos = #pos{map_pid = MapPid}},
    CombatType = ?combat_type_survive, Referees) ->
    Referees2 = add_referee(Referees, MapPid),

    Args = case dungeon:get_info(EventPid) of
        {ok, #dungeon{args = _Args}} ->
            _Args;
        _ ->
            []
    end,

    DfdList = fighter_group(Npc, Role),
    case combat:start(CombatType, Referees2, role_api:fighter_group(Role), DfdList, Args) of
        {ok, _CombatPid} -> 
            ok;
        {error, _Err} -> 
            ?ELOG("玩家对[~s]发起战斗失败:~w", [_Name, _Err])
    end,
    true;

%%限时模式
do_fight(Npc = #npc{name = _Name}, Role = #role{event_pid = EventPid, pos = #pos{map_pid = MapPid}},
    CombatType = ?combat_type_time, Referees) ->
    Referees2 = add_referee(Referees, MapPid),

    Args = case dungeon:get_info(EventPid) of
        {ok, #dungeon{combat_round = UsedRound, args = [TotalRound, NpcCount]}} ->
            [NpcCount, UsedRound, TotalRound];
        _ ->
            []
    end,

    DfdList = fighter_group(Npc, Role),
    case combat:start(CombatType, Referees2, role_api:fighter_group(Role), DfdList, Args) of
        {ok, _CombatPid} -> 
            ok;
        {error, _Err} -> 
            ?ELOG("玩家对[~s]发起战斗失败:~w", [_Name, _Err])
    end,
    true;

%% 如果是狂暴怪顺便把归属人id顺便传过去 Jange 2012/8/4
do_fight(#npc{pid = Pid, base_id = NpcBaseId, slave = Slave, owner = OwnerId}, Role = #role{pos = #pos{map_pid = MapPid}}, CombatType, Referees) when is_pid(Pid) ->
    case vip:kill_vip_boss(Role, NpcBaseId) of
        true ->
            Referees1 = case is_list(Referees) of
                true -> [{common, MapPid}] ++ Referees;
                false -> MapPid
            end,
            Pid ! {fight, role_api:fighter_group(Role), CombatType, {Referees1, Slave, OwnerId}},
            true;
        {false, Reason} ->
            {false, Reason}
    end;    
do_fight(Npc = #npc{base_id = NpcBaseId, name = _Name, owner = _Owner, pos = #pos{x = NpcX, y = NpcY}}, Role = #role{pos = #pos{map_pid = MapPid}}, CombatType, Referees) ->
    Referees1 = case is_list(Referees) of
        true -> [{common, MapPid}] ++ Referees;
        false -> MapPid
    end,
    case super_boss:is_super_boss(NpcBaseId) of
        true ->
            case catch super_boss:get_current_status(NpcBaseId) of
                {CurHp, CurHpMax} when is_integer(CurHp) andalso CurHp > 0 ->
                    {ok, CF = #converted_fighter{fighter = F}} = npc_convert:do(to_fighter, Npc),
                    ?DEBUG("发起战斗时世界boss的最大血量是:~w, 当前血量是:~w", [CurHpMax, CurHp]),
                    CF1 = CF#converted_fighter{fighter = F#fighter{hp = CurHp, hp_max = CurHpMax, x = NpcX, y = NpcY}},
                    DfdList = [CF1],
                    case combat:start(?combat_type_npc, Referees1, role_api:fighter_group(Role), DfdList) of
                        {ok, _CombatPid} -> ok;
                        {error, _Err} -> ?ELOG("玩家对[~s]发起战斗失败:~w", [_Name, _Err])
                    end,
                    true;
                {CurHp1, _} when is_integer(CurHp1) andalso CurHp1 =< 0 -> {false, util:fbin(?L(<<"~s已经死亡">>), [_Name])};
                _ -> {false, util:fbin(?L(<<"无法对~s发起战斗">>), [_Name])}
            end;
        false ->
            DfdList = fighter_group(Npc, Role),
            case combat:start(CombatType, Referees1, role_api:fighter_group(Role), DfdList) of
                {ok, _CombatPid} -> ok;
                {error, _Err} -> ?ELOG("玩家对[~s]发起战斗失败:~w", [_Name, _Err])
            end,
            true
    end.

add_referee(Referees, MapPid) ->
    case is_list(Referees) of
        true ->
            [{common, MapPid} | Referees];
        false -> 
            MapPid
    end.

%% @spec fight_info(NpcPid, Info) -> ok
%% NpcPid = pid()
%% Info = tuple()
%% @doc 将战斗变化信息发送给指定的NPC
%% <div>例如:NPC战斗组中的成员挂了、战斗结束、对手逃跑等</div>
fight_info(NpcPid, {Flag, Info}) ->
    NpcPid ! {fight_info, {Flag, Info}};
fight_info(NpcPid, {Flag, Info, NpcBaseId, WinRole}) ->
    FunType = case npc_data:get(NpcBaseId) of
        {ok, #npc_base{fun_type = Type}} -> Type;
        _ -> 0
    end,

    case FunType of
        ?npc_fun_type_guild_td ->
            NpcPid ! {fight_info, {Flag, Info, NpcBaseId, WinRole}};
        ?npc_fun_type_guard ->
            NpcPid ! {fight_info, {Flag, Info, ?npc_fun_type_guard, WinRole}};
        _ ->
            NpcPid ! {fight_info, {Flag, Info}}
    end.

%% @spec pause(NpcPid) -> ok
%% NpcPid = pid()
%% @doc 暂停活动
pause(NpcPid) ->
    NpcPid ! pause.

%% @spec resume(NpcPid) -> ok
%% NpcPid = pid()
%% @doc 恢复活动
resume(NpcPid) ->
    NpcPid ! resume.

%% @spec reload(NpcPid) -> ok
%% NpcPid = pid()
%% @doc 重载NPC，重新加载属性
reload(NpcPid) ->
    NpcPid ! reload.

%% spec fighter_group(NpcFighterList) -> list()
%% NpcFighterList = [{integer(), integer(), integer()}] or [{[{integer(), integer()}...], integer(), integer()}]
%% 例如:[{25012,100,0},{25013,100,0}...] 或者 [{[{25012, 50}, {25013, 50}], 100, 0}...]
%% {[{id1,rate1},{id2,rate2},…],rate,diff}
%% N -> integer() 表示玩家的队伍有几个人
%% @doc 获取NPC参战者列表
fighter_group(Npc = #npc{slave = Slave}, _Role) when is_record(_Role, role) ->
    S = fighter_group(Slave, 1),
    {ok, F} = npc_convert:do(to_fighter, Npc),
    [F | S];
fighter_group(Npc = #npc{slave = Slave}, N) when is_integer(N) ->
    S = fighter_group(Slave, N),
    {ok, F} = npc_convert:do(to_fighter, Npc),
    [F | S];
fighter_group(NpcFighterList, N) ->
    %% ?DEBUG("NpcFighterList=~w,N=~w", [NpcFighterList, N]),
    NpcFighterList2 = case length(NpcFighterList) >=6 of
        true ->
            ?ELOG("Npc参战者列表数量错误:~w", [NpcFighterList]),
            [F1, F2, F3, F4, F5 | _] = NpcFighterList,
            [F1,F2,F3,F4,F5];
        false ->
            NpcFighterList
    end,
    fighter_group(NpcFighterList2, [], N).
fighter_group([], L, _N) -> L;
fighter_group([NpcFighter | T], L, N) ->
    case NpcFighter of
        {BaseId, Rate, Diff} when is_integer(BaseId) ->
            FinalRate = Rate + Diff * (N - 1),
            case util:rand(1, 100) =< FinalRate of
                true ->
                    case npc_data:get(BaseId) of
                        false ->
                            ?ERR("指定base_id[~w]的NPC不存在", [BaseId]),
                            fighter_group(T, L, N);
                        {ok, NpcBase} ->
                            Npc = npc_convert:base_to_npc(0, NpcBase, #pos{}),
                            {ok, F} = npc_convert:do(to_fighter, Npc),
                            fighter_group(T, [F | L], N)
                    end;
                false ->
                    fighter_group(T, L, N)
            end;
        {Mons, _Rate, _Diff} when is_list(Mons) ->
            fighter_group(T, L, N);
        _ ->
            ?ERR("NPC参战者格式错误:~w", [NpcFighter]),
            fighter_group(T, L, N)
    end.

%% @spec enable(NpcPid)  
%% NpcPid = pid()
%% @doc 激活npc让它可以进入战斗 
enable(NpcPid) ->
    NpcPid ! enable.

%% @spec disable(NpcPid, Reason) ->
%% NpcPid = pid()
%% Reason = bitstring()
disable(NpcPid, Reason) ->
    NpcPid ! {disable, Reason}.

%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------

init([Npc = #npc{id = NpcId, name = Name, pos = Pos = #pos{map = MapId, x = X, y = Y, line = Line}, t_patrol = Tpatrol, fun_type = FunType}])->
    State = Npc#npc{pid = self(), ts = now(), def_xy = {X, Y}},
    case map:npc_enter({Line, MapId}, npc_convert:do(to_map_npc, State)) of
        false ->
            ?ERR("NPC[~s]尝试进入不存在的地图: ~w", [Name, MapId]),
            {stop, normal};
        {MapBaseId, MapPid} ->
            process_flag(trap_exit, true),
            N = State#npc{pos = Pos#pos{map_pid = MapPid, map_base_id = MapBaseId}},
            sync(N), %% 同步在线信息
            case FunType of
                ?npc_fun_type_guild_war_white ->
                    guild_war_npc:action(create, NpcId);
                ?npc_fun_type_guild_war_red ->
                    guild_war_npc:action(create, NpcId);
                _ ->
                    ok
            end,
            {ok, patrol, N, Tpatrol};
        _X -> 
            ?DEBUG("未知的返回值：~p",[_X]),
            {stop, normal}
    end.

handle_event(_Event, StateName, State) ->
    {next_state, StateName, State}.

handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    {reply, Reply, StateName, State}.

%% 收到进入战斗的广播消息
handle_info({cast_fight_status, Status}, StateName, State = #npc{name = _Name, pos = #pos{map_pid = MapPid}}) ->
    map:npc_update(MapPid, npc_convert:do(to_map_npc, State#npc{status = Status})),
    continue(StateName, State);

%% 重复发起战斗处理
handle_info({fight, [], _, _}, combat, State) ->
    continue(combat, State);
handle_info({fight, AtkList, _, _}, combat, State = #npc{fun_type = ?npc_fun_type_guild_td}) -> %% 处理军团副本中重复发起战斗
    [#converted_fighter{pid = Pid} | _] = AtkList,
    role:pack_send(Pid, 14909, {1}),
    continue(combat, State);

handle_info({fight, AtkList, _, _}, combat, State) ->
    [#converted_fighter{pid = _Pid} | _] = AtkList,
%%    role:pack_send(Pid, 10705, {0, ?L(<<"目标正在战斗中，无法发起战斗">>)}),
    continue(combat, State);

%% 正常发起战斗处理
handle_info({fight, AtkList, CombatType, AddtArgs}, StateName, State = #npc{id = NpcId, slave = Slave, name = _Name, base = #npc_base{id = _NpcBaseId, lock = Lock}, fun_type = FunType}) ->
    {Referees, Slave1, OwnerId} = case AddtArgs of
        {A, B} -> {A, B, 0};
        %% 如果传来的是完整玩家id才匹配
        {A, B, {C, D}} -> {A, B, {C, D}};
        {A, B, _} -> {A, B, 0};
        _ -> {AddtArgs, Slave, 0}
    end,
    S = fighter_group(Slave1, length(AtkList)),
    NpcWithRoleAttr = npc_convert:make_role_attr(State#npc{owner = OwnerId}, AtkList),
    {ok, F} = npc_convert:do(to_fighter, NpcWithRoleAttr),
    DfdList = [F | S],
    case combat:start(CombatType, Referees, AtkList, DfdList) of
        {ok, CombatPid} when is_pid(CombatPid) ->
            case FunType of
                ?npc_fun_type_guild_war_white ->
                    guild_war_npc:action(combat, NpcId);
                ?npc_fun_type_guild_war_red ->
                    guild_war_npc:action(combat, NpcId);
                _ ->
                    ok
            end,
            case Lock of %% 非锁定怪不进入战斗状态
                1 ->
                    {next_state, combat, State#npc{ts = now(), combat_pid = CombatPid}, ?TIMEOUT_COMBAT};
                _ -> continue(StateName, State)
            end;
        {error, _Err} ->
            ?ELOG("对[~s]发起战斗失败:~w", [_Name, _Err]),
            continue(StateName, State)
    end;

%% 进入指定地图
handle_info({enter_map, _MapGid = {Line, MapId}, X, Y}, StateName, State = #npc{name = Name, pos = Pos}) ->
    P = Pos#pos{map = MapId, x = X, y = Y, line = Line},
    case map:npc_enter(MapId, npc_convert:do(to_map_npc, State#npc{pos = P})) of
        false ->
            ?ERR("NPC[~s]尝试进入不存在的地图: ~w:~w", [Name, Line, MapId]),
            continue(StateName, State);
        {MapBaseId, MapPid} ->
            N = State#npc{pos = P#pos{map_pid = MapPid, map_base_id = MapBaseId}},
            sync(N), %% 同步在线信息
            continue(StateName, N)
    end;

handle_info({fight_info, {ally_killed, _Gid}}, StateName, State) ->
    continue(StateName, State);

handle_info({fight_info, {emeny_join, _Emeny}}, StateName, State) ->
    continue(StateName, State);

handle_info({fight_info, {emeny_killed, _Gid}}, StateName, State) ->
    continue(StateName, State);

handle_info({fight_info, {emeny_escape, _Gid}}, StateName, State) ->
    continue(StateName, State);

%% 战斗结束:胜利
handle_info({fight_info, {stop, win}}, combat, State = #npc{fun_type = ?npc_fun_type_guard_counter, t_patrol = Tpatrol}) ->
    NewState = trace_to_patrol(State),
    {next_state, patrol, NewState, Tpatrol};
handle_info({fight_info, {stop, win}}, combat, State = #npc{t_patrol = Tpatrol}) ->
    {next_state, patrol, State#npc{ts = now()}, Tpatrol};

%% 战斗结束:失败
handle_info({fight_info, {stop, lost}}, patrol, State = #npc{t_patrol = _Tpatrol, base = #npc_base{id = _NpcBaseId}}) ->
    %%case super_boss:is_super_boss(NpcBaseId) of
    %%    true -> 
    %%        self() ! stop,
    %%        {next_state, patrol, State#npc{ts = now()}, Tpatrol};
    %%    false ->
    %%        continue(patrol, State)
    %%end;
    continue(patrol, State);
handle_info({fight_info, {stop, lost}}, combat, State = #npc{t_patrol = Tpatrol}) ->
    self() ! stop,
    {next_state, patrol, State#npc{ts = now()}, Tpatrol};

%% 战斗结束: 进入战斗失败
handle_info({fight_info, {stop, enter_fail}}, combat, State = #npc{fun_type = ?npc_fun_type_guard_counter, t_patrol = Tpatrol}) ->
    NewState = trace_to_patrol(State),
    {next_state, patrol, NewState, Tpatrol};
handle_info({fight_info, {stop, enter_fail}}, combat, State = #npc{t_patrol = Tpatrol}) ->
    {next_state, patrol, State#npc{ts = now()}, Tpatrol};

%% 战斗结束:其它情况
handle_info({fight_info, {stop, _Result}}, combat, State = #npc{fun_type = ?npc_fun_type_guard_counter, t_patrol = Tpatrol}) ->
    NewState = trace_to_patrol(State),
    {next_state, patrol, NewState, Tpatrol};
handle_info({fight_info, {stop, _Result}}, combat, State = #npc{t_patrol = Tpatrol}) ->
    {next_state, patrol, State#npc{ts = now()}, Tpatrol};

%% 非combat状态下收到战斗结束消息，无需处理
handle_info({fight_info, {stop, _Result}}, StateName, State) ->
    continue(StateName, State);

%% 守卫洛水战胜玩家
handle_info({fight_info, {stop, lost, ?npc_fun_type_guard, WinRole}}, combat, State = #npc{t_patrol = Tpatrol}) ->
    RoleList = [{{Rid, SrvId}, Name, Career, Lev} || #fighter{rid = Rid, srv_id = SrvId, name = Name, career = Career, lev = Lev} <- WinRole], 
    put(result, lost),
    put(role_id_list, RoleList),
    self() ! stop,
    {next_state, patrol, State#npc{ts = now()}, Tpatrol};

%% 塔防怪 存储战胜玩家
handle_info({fight_info, {stop, lost, _BaseId, WinRole}}, combat, State = #npc{t_patrol = Tpatrol}) ->
    RoleList = [{Rid, SrvId} || #fighter{rid = Rid, srv_id = SrvId} <- WinRole], 
    put(result, lost),
    put(role_id_list, RoleList),
    self() ! stop,
    {next_state, patrol, State#npc{ts = now()}, Tpatrol};

handle_info({fight_info, {stop, _Result, _Win}}, StateName, State) ->
    continue(StateName, State);

%% 暂停活动
handle_info(pause, _StateName, State) ->
    {next_state, freeze, State};

%% 恢复活动
handle_info(resume, freeze, State = #npc{t_patrol = Tpatrol}) ->
    {next_state, patrol, State#npc{ts = now()}, Tpatrol};

%% 重载NPC属性
handle_info(reload, StateName, State = #npc{base_id = BaseId, pos = #pos{map_pid = MapPid}}) ->
    case npc_data:get(BaseId) of
        %% 该NPC已经不存在于npc_data.erl中了
        %% 也许已经被抛弃了，那么自杀吧
        false ->
            self() ! stop,
            continue(StateName, State);
        {ok, NpcBase = #npc_base{
                type = Type, name = Name, hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax,
                lev = Lev, nature = Nature, speed = Speed, slave = Slave, talk = Talk,
                attr = Attr, guard_range = GuardRange, t_trace = Ttrace, t_patrol = {Tmin, Tmax}
            }
        } ->
            N = State#npc{
                type = Type, name = Name, hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax,
                lev = Lev, nature = Nature, speed = Speed, slave = Slave, talk = Talk,
                attr = Attr, guard_range = GuardRange, t_trace = Ttrace, base = NpcBase,
                t_patrol = util:rand(Tmin, Tmax)
            },
            map:npc_update(MapPid, npc_convert:do(to_map_npc, N)), %% 更新地图上的NPC信息
            %% 检查下类型变化
            case Type of
                1 ->
                    sync(N),
                    continue(StateName, N);
                0 ->
                    ?INFO("NPC[~s]已经转换成了固定NPC", [Name]),
                    sync(N#npc{pid = 0}),
                    {stop, normal, N} %% 直接中止，不能再走stop流程
            end
    end;

%% 结束进程
handle_info(stop, _StateName, State) ->
    ?DEBUG("NPC进程退出"),
    {stop, normal, State};

%% 激活npc
handle_info(enable, StateName, State) ->
    NewState = State#npc{disabled = <<>>},
    sync(NewState),
    continue(StateName, NewState);

%% 禁止npc被激杀
handle_info({disable, Reason}, StateName, State) ->
    NewState = State#npc{disabled = Reason},
    sync(NewState),
    continue(StateName, NewState);

handle_info(_Info, StateName, State) ->
    continue(StateName, State).

terminate(_Reason, _StateName, State = #npc{fun_type = ?npc_fun_type_guild_td, id = Id, pos = #pos{map_pid = MapPid}}) ->
    map:npc_leave(MapPid, Id),
    catch ets:delete(npc_online, Id),
    case get(result) of
        zb_arrive -> %% 走完全程
            hook_zb_arrive(State);
        lost ->  %% 战斗死亡
            RoleList = case get(role_id_list) of
                undefined -> [];
                L -> L
            end,
            hook_zb_kill(RoleList, State);
        _ -> %% 异常死亡
            hook_zb_die(State)
    end,
    ?DEBUG("Npc进程退出"),
    ok;

terminate(_Reason, _StateName, Npc = #npc{id = Id, pos = #pos{map_pid = MapPid}, fun_type = FunType}) ->
    map:npc_leave(MapPid, Id),
    catch ets:delete(npc_online, Id), %% 从在线NPC表中注销
    case FunType of
        ?npc_fun_type_guard -> %% 守卫洛水怪
            guard_result(Npc);
        ?npc_fun_type_guild_war_white ->
            guild_war_npc:action(kill, Id);
        ?npc_fun_type_guild_war_red ->
            guild_war_npc:action(kill, Id);
        ?npc_fun_type_npc_store_dung ->
            npc_store_dung:close(Id);
        _ ->
            ok
    end,
    %% ?DEBUG("Npc进程退出"),
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%% ----------------------------------------------------
%% 状态处理
%% ----------------------------------------------------

%% 所有怪物改成不会移动, qingxuan 13/7/19
%% ----------------------
%% %% 塔防怪初始化路径 
 patrol(timeout, State = #npc{path = [], t_patrol = Tpatrol, paths = Paths,fun_type = FunType})
 when FunType =:= ?npc_fun_type_guild_td orelse FunType =:= ?npc_fun_type_guard ->
     Path = util:rand_list(Paths), %% 从预设路径中随机抽取一条
     {next_state, patrol, State#npc{path = Path, ts = now()}, Tpatrol};
 patrol(timeout, State = #npc{path = [{X, Y} | T], pos = #pos{map_pid = MapPid}, fun_type = FunType})
 when FunType =:= ?npc_fun_type_guild_td orelse FunType =:= ?npc_fun_type_guard ->
     zb_move(State, MapPid, X, Y, T);
%% 
%% %% 帮战机器人
%% patrol(timeout, State = #npc{id = NpcId, paths = [], t_patrol = Tpatrol, fun_type = FunType}) when FunType =:= ?npc_fun_type_guild_war_white orelse FunType =:= ?npc_fun_type_guild_war_red ->
%%     guild_war_npc:action(attack_elem, NpcId),
%%     {next_state, patrol, State, Tpatrol};
%% patrol(timeout, State = #npc{paths = [{X, Y} | T], t_patrol = Tpatrol, pos = Pos = #pos{map_pid = MapPid}, fun_type = FunType}) when FunType =:= ?npc_fun_type_guild_war_white orelse FunType =:= ?npc_fun_type_guild_war_red ->
%%     NewState = State#npc{paths = T, ts = now(), pos = Pos#pos{x = X, y = Y}},
%%     move(NewState, MapPid, X, Y),
%%     {next_state, patrol, NewState, Tpatrol};
%% 
%% %% 春节活动NPC巡游
%% patrol(timeout, State = #npc{id = NpcId, path = [], paths = [], t_patrol = Tpatrol, fun_type = ?npc_fun_type_campaign_npc}) -> %% 无预设路径 或 路径走完
%%     catch campaign_npc_mgr:npc_move_over(NpcId),
%%     {next_state, patrol, State, Tpatrol};
%% patrol(timeout, State = #npc{path = [], paths = Paths, t_patrol = Tpatrol, fun_type = ?npc_fun_type_campaign_npc}) ->
%%     Path = util:rand_list(Paths), %% 从预设路径中随机抽取一条
%%     {next_state, patrol, State#npc{path = Path, paths = [], ts = now()}, Tpatrol};
%% patrol(timeout, State = #npc{path = [{X, Y} | T], t_patrol = Tpatrol, pos = Pos = #pos{map_pid = MapPid}, fun_type = ?npc_fun_type_campaign_npc}) ->
%%     NewState = State#npc{path = T, ts = now(), pos = Pos#pos{x = X, y = Y}},
%%     move(NewState, MapPid, X, Y),
%%     {next_state, patrol, NewState, Tpatrol};
%% 
%% %% 洛水反击怪, 巡逻外加追踪的怪物
%% %% 初始化路径
%% patrol(timeout, State = #npc{path = [], t_patrol = Tpatrol, paths = Paths, fun_type = ?npc_fun_type_guard_counter}) ->
%%     Path = util:rand_list(Paths), %% 从预设路径中随机抽取一条
%%     {next_state, patrol, State#npc{path = Path, ts = now()}, Tpatrol};
%% %% 走到路径 
%% patrol(timeout, State = #npc{path = [{-1, -1}], fun_type = ?npc_fun_type_guard_counter}) ->
%%     case do_patrol(State) of
%%         null ->
%%             {stop, normal, State};
%%         Pid ->
%%             {next_state, trace, State#npc{target = Pid, ts = now()}, 0}
%%     end;
%% %% 走到最后一个点
%% patrol(timeout, State = #npc{path = [{X, Y},{-1, -1}], pos = Pos = #pos{map_pid = MapPid}, fun_type = ?npc_fun_type_guard_counter}) ->
%%     case do_patrol(State) of
%%         null ->
%%             move(State, MapPid, X, Y),
%%             NewState = State#npc{pos = Pos#pos{x = X, y = Y}},
%%             Tpatrol = guard_counter:get_npc_die_cd(),
%%             {next_state, patrol, NewState#npc{ts = now(), path = [{-1, -1}]}, Tpatrol};
%%         Pid ->
%%             {next_state, trace, State#npc{target = Pid, ts = now()}, 0}
%%     end;
%% %% 移动至下一点
%% patrol(timeout, State = #npc{path = [{X, Y} | T], t_patrol = Tpatrol, pos = Pos = #pos{map_pid = MapPid}, fun_type = ?npc_fun_type_guard_counter}) ->
%%     case do_patrol(State) of
%%         null ->
%%             move(State, MapPid, X, Y),
%%             NewState = State#npc{pos = Pos#pos{x = X, y = Y}},
%%             {next_state, patrol, NewState#npc{ts = now(), path = T}, Tpatrol};
%%         Pid ->
%%             {next_state, trace, State#npc{target = Pid, ts = now()}, 0}
%%     end;
%% 
%% %% 前一次巡逻结束，看看附近有没有目标，准备下一次巡逻(未设定巡逻路径的情况)
%% patrol(timeout, State = #npc{path = [], nature = 1, disabled = <<>>, t_patrol = Tpatrol, def_xy = {DefX, DefY}, pos = Pos = #pos{map_pid = MapPid, map_base_id = MapBaseId, x = X, y = Y}, paths = []}) ->
%%     case do_patrol(State) of
%%         null ->
%%             {Nx, Ny} = do_rand_path({X, Y}, {DefX, DefY}, State),
%%             case map_mgr:get_path(MapBaseId, {X, Y}, {Nx, Ny}) of
%%                 blocked ->
%%                     {next_state, patrol, State#npc{ts = now()}, Tpatrol};
%%                 {Tx, Ty} ->
%%                     NewState = State#npc{pos= Pos#pos{x = Tx, y = Ty}, ts = now()},
%%                     move(NewState, MapPid, Tx, Ty),
%%                     {next_state, patrol, NewState, Tpatrol}
%%             end;
%%         Pid ->
%%             {next_state, trace, State#npc{target = Pid, ts = now()}, 0}
%%     end;
%%  
%% 前一次巡逻结束, 准备下一次巡逻(未设定巡逻路径的情况)
%% patrol(timeout, State = #npc{path = [], t_patrol = Tpatrol, def_xy = {DefX, DefY}, pos = Pos = #pos{map_pid = _MapPid, map_base_id = MapBaseId, x = X, y = Y}, paths = []}) ->
%%     {Nx, Ny} = do_rand_path({X, Y}, {DefX, DefY}, State),
%%     case map_mgr:get_path(MapBaseId, {X, Y}, {Nx, Ny}) of
%%         blocked ->
%%             {next_state, patrol, State#npc{ts = now()}, Tpatrol};
%%         {Tx, Ty} ->
%%             NewState = State#npc{pos= Pos#pos{x = Tx, y = Ty}, ts = now()},
%%             move(NewState, MapPid, Tx, Ty), 
%%             {next_state, patrol, NewState, Tpatrol}
%%     end;
%% 
%% 前一次巡逻结束，准备下一次巡逻(已经设定巡逻路径的情况)
patrol(timeout, State = #npc{path = [], t_patrol = Tpatrol, paths = Paths}) ->
    Path = util:rand_list(Paths), %% 从预设路径中随机抽取一条
    {next_state, patrol, State#npc{path = Path, ts = now()}, Tpatrol};
%% 
%% %% 按指定路径巡逻，并看看附近有没有可追踪目标
%% patrol(timeout, State = #npc{nature = 1, disabled = <<>>, path = [{X, Y} | T], t_patrol = Tpatrol, pos = Pos = #pos{map_pid = MapPid}}) ->
%%     case do_patrol(State) of
%%         null ->
%%             NewState = State#npc{path = T, ts = now(), pos = Pos#pos{x = X, y = Y}},
%%             move(NewState, MapPid, X, Y),
%%             {next_state, patrol, NewState#npc{t_patrol = Tpatrol}, Tpatrol};
%%         Pid ->
%%             {next_state, trace, State#npc{target = Pid, ts = now()}, 0}
%%     end;
%% 
%% 指定指定路径巡逻，不追踪目标
patrol(timeout, State = #npc{path = [{X, Y} | T], t_patrol = Tpatrol, pos = Pos = #pos{map_pid = MapPid}}) ->
    NewState = State#npc{path = T, ts = now(), pos = Pos#pos{x = X, y = Y}},
    move(NewState, MapPid, X, Y),
    {next_state, patrol, NewState, Tpatrol};
patrol(timeout, State = #npc{t_patrol = Tpatrol}) ->
    {next_state, patrol, State, Tpatrol};

patrol(_Any, State = #npc{name = _Name, path = _Path, fun_type = _FunType, base_id = _BaseId}) ->
    ?DEBUG("NPC[~s:~w]在巡逻状态下收到无效消息_Any:~w, Path:~w, FunType:~w", [_Name, _BaseId, _Any, _Path, _FunType]),
    continue(patrol, State).

%% 追踪触发
trace(timeout, State = #npc{id = Id, target = Target, fun_type = FunType, pos = Pos = #pos{map_pid = MapPid, x = X, y = Y}, off_trace_range = OffTraceRange, t_trace = Ttrace, t_patrol = Tpatrol, slave = Slave}) ->
    case is_pid(Target) andalso is_process_alive(Target) of
        true ->
            case role_api:lookup(by_pid, Target, to_map_role) of
                {ok, _, MapRole = #map_role{x = Tx, y = Ty, pid = Pid}} ->
                    Dx = math:pow(X - Tx, 2),
                    Dy = math:pow(Y - Ty, 2),
                    R = math:pow(OffTraceRange, 2),
                    Rc = get_fight_range(FunType),
                    if
                        Dx + Dy =< Rc -> %% 已经抓住目标，直接发起战斗
                            case role_api:lookup(by_pid, Pid) of
                                {ok, _, Role = #role{status = _Status, combat_pid = CombatPid}} -> 
                                    case is_pid(CombatPid) andalso is_process_alive(CombatPid) of
                                        false -> 
                                            DfdList = role_api:fighter_group(Role),
                                            S = fighter_group(Slave, length(DfdList)),
                                            {ok, Boss} = npc_convert:do(to_fighter, State),
                                            AtkList = [Boss | S],
                                            case combat_type:check(?combat_type_npc, State, Role) of
                                                %% 洛水反击怪
                                                {guard_counter, NewCombatType, Referees} ->
                                                    Referees1 = [{common, MapPid}, {guard_counter_npc, self()}] ++ Referees,
                                                    case combat:start(NewCombatType, Referees1, AtkList, DfdList) of
                                                        {ok, NewCombatPid} ->
                                                            {next_state, combat, State#npc{combat_pid = NewCombatPid, ts = now()}, ?TIMEOUT_COMBAT};
                                                        {error, _Err} ->
                                                            NewState = trace_to_patrol(State),
                                                            {next_state, patrol, NewState, Tpatrol} 
                                                    end;
                                                {true, NewCombatType} ->
                                                    case combat:start(NewCombatType, MapPid, AtkList, DfdList) of
                                                        {ok, NewCombatPid} ->
                                                            {next_state, combat, State#npc{combat_pid = NewCombatPid, ts = now()}, ?TIMEOUT_COMBAT};
                                                        {error, _Err} ->
                                                            ?ELOG("怪物抓到人但是发起战斗失败:~w", [_Err]),
                                                            NewState = trace_to_patrol(State),
                                                            {next_state, patrol, NewState, Tpatrol}
                                                    end;
                                                %% 兼容狂暴怪处理
                                                {rob, NewCombatType, _} ->
                                                    case combat:start(NewCombatType, MapPid, AtkList, DfdList) of
                                                        {ok, NewCombatPid} ->
                                                            {next_state, combat, State#npc{combat_pid = NewCombatPid, ts = now()}, ?TIMEOUT_COMBAT};
                                                        {error, _Err} ->
                                                            ?ELOG("怪物抓到人但是发起战斗失败:~w", [_Err]),
                                                            NewState = trace_to_patrol(State),
                                                            {next_state, patrol, NewState, Tpatrol}
                                                    end;
                                                {true, NewCombatType, Referees} ->
                                                    Referees1 = [{common, MapPid}] ++ Referees,
                                                    case combat:start(NewCombatType, Referees1, AtkList, DfdList) of
                                                        {ok, NewCombatPid} ->
                                                            {next_state, combat, State#npc{combat_pid = NewCombatPid, ts = now()}, ?TIMEOUT_COMBAT};
                                                        {error, _Err} ->
                                                            ?ELOG("怪物抓到人但是发起战斗失败:~w", [_Err]),
                                                            NewState = trace_to_patrol(State),
                                                            {next_state, patrol, NewState, Tpatrol}
                                                    end;
                                                _ -> %% 无法通过combat_check
                                                    NewState = trace_to_patrol(State),
                                                    {next_state, patrol, NewState, Tpatrol}
                                            end;
                                        _ -> %% 人当前处于不可战斗的状态
                                            NewState = trace_to_patrol(State),
                                            {next_state, patrol, NewState, Tpatrol}
                                    end;
                                _ -> %% 人已经不可见
                                    NewState = trace_to_patrol(State),
                                    {next_state, patrol, NewState, Tpatrol}
                            end;
                        Dx + Dy =< R -> %% 仍在追踪范围内
                            NewState = State#npc{ts = now(), pos = Pos#pos{x = Tx, y = Ty}},
                            move(NewState, MapPid, Tx, Ty),
                            {next_state, trace, NewState, Ttrace};
                        true -> %% 其它情况放弃追踪目标
                            ?DEBUG("脱离追踪"),
                            case npc_ai:talk(trace_off, State, MapRole) of
                                {ok, Sentence} ->
                                    Sentence1 = ?L(Sentence),
                                    {ok, Msg} = proto_101:pack(srv, 10123, {1, Id, Sentence1}),
                                    map:send_to_near(MapPid, {X, Y}, Msg);
                                _ ->
                                    ok
                            end,
                            NewState = trace_to_patrol(State),
                            {next_state, patrol, NewState, Tpatrol}
                    end;
                _ -> %% 无法查询到人的信息
                    NewState = trace_to_patrol(State),
                    {next_state, patrol, NewState, Tpatrol}
            end;
        false -> %% 角色进程不存活
            NewState = trace_to_patrol(State),
            {next_state, patrol, NewState, Tpatrol}
    end;

trace(_Any, State) ->
    continue(trace, State).

%% 战斗超时，转入patrol状态
combat(timeout, State = #npc{combat_pid = Cpid}) ->
    case is_pid(Cpid) andalso is_process_alive(Cpid) of
        false -> continue(patrol, State#npc{combat_pid = 0});
        true -> continue(combat, State#npc{ts = now()})
    end;

combat(_Any, State = #npc{name = _Name}) ->
    ?DEBUG("NPC[~s]在战斗状态下收到无效消息: ~w", [_Name, _Any]),
    continue(combat, State).

%% 被定住
freeze(_Any, State = #npc{name = _Name}) ->
    ?DEBUG("NPC[~s]在定住状态下收到无效消息: ~w", [_Name, _Any]),
    continue(freeze, State).

%% ----------------------------------------------------
%% 状态维护
%% ----------------------------------------------------
%% 重新计算超时时间，继续某一状态
continue(patrol, State = #npc{ts = Ts, t_patrol = Tp}) ->
    {next_state, patrol, State, util:time_left(Tp, Ts)};
continue(combat, State = #npc{ts = Ts}) ->
    {next_state, combat, State, util:time_left(?TIMEOUT_COMBAT, Ts)};
continue(trace, State = #npc{t_trace = Ttrace}) ->
    {next_state, trace, State, Ttrace};
continue(freeze, State) ->
    {next_state, freeze, State}.

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------
%% 洛水反击怪的距离为300像素
get_fight_range(?npc_fun_type_guard_counter) -> 90000;
get_fight_range(_) -> math:pow(50,2).

%% 当怪物从追踪转换成巡逻时, 处理怪物后续路径
trace_to_patrol(State = #npc{pos = #pos{map_pid = MapPid, x = X, y = Y}, fun_type = ?npc_fun_type_guard_counter}) ->
    {NewState, NextX, NextY} = guard_counter:npc_return(State, X, Y), 
    move(NewState, MapPid, NextX, NextY),
    NewState#npc{ts = now(), target = 0};
trace_to_patrol(State) ->
    State#npc{ts = now(), target = 0}.

%% 同步在线信息
sync(State) when is_record(State, npc) ->
    ets:insert(npc_online, State).

%% npc移动
move(Npc, MapPid, X, Y) ->
    sync(Npc),
    map:npc_move(MapPid, Npc#npc.id, X, Y).

%% 与npc战斗的特殊处理，
fight_special_check(_, _) ->
    ok.

%% ----------------
%% 帮会副本怪处理
%% ---------------
%% 到达终点
hook_zb_arrive(Npc = #npc{base_id = BaseId}) ->
    guild_td_mgr:kill_npc(guild_td_data:get_type(BaseId), [], Npc).

%% 怪物异常终止
hook_zb_die(_Npc) -> skip.

%% 被玩家杀死
hook_zb_kill([], Npc = #npc{base_id = BaseId}) ->
    ?ERR("被玩家杀死,但是找不到进攻的玩家列表,NpcBaseId:~w",[Npc#npc.base_id]),
    guild_td_mgr:kill_npc(guild_td_data:get_type(BaseId), [], Npc);
hook_zb_kill(RoleList, Npc = #npc{base_id = BaseId}) ->
    guild_td_mgr:kill_npc(guild_td_data:get_type(BaseId), RoleList, Npc).

%% ---------------
%% 守卫洛水怪处理
%% --------------
guard_result(#npc{base_id = BaseId}) ->
    {Type, LossHp, Point} = guard_data:get_type(BaseId),
    case get(result) of
        zb_arrive -> %% 走完全程
            guard_mgr:kill_npc(Type, [], LossHp, Point);
        lost ->  %% 战斗死亡
            RoleList = case get(role_id_list) of
                undefined -> [];
                L -> L
            end,
            case RoleList of
                [] -> guard_mgr:kill_npc(Type, [], LossHp, Point);
                R -> guard_mgr:kill_npc(Type, R, LossHp, Point)
            end;
        _ -> %% 异常死亡
            skip
    end.

%% 在目的地消失
zb_move(Npc, _MapPid, -1, -1, []) ->
    put(result, zb_arrive),
    {stop, normal, Npc};
%% 到达目的地
zb_move(Npc = #npc{pos = Pos} , MapPid, X, Y, [{-1, -1}]) ->
    sync(Npc),
    NewX = X + util:rand(-20, 20),
    NewY = Y + util:rand(-20, 20),
    map:npc_move(MapPid, Npc#npc.id, NewX, NewY),
    NewNpc = Npc#npc{pos= Pos#pos{x = NewX, y = NewY}, path = [{-1, -1}], ts = now()},
    {next_state, patrol, NewNpc, 1000}; %% 在目的地停留1000ms
zb_move(Npc = #npc{fun_type = ?npc_fun_type_guard, pos = Pos, t_patrol = Tpatrol}, MapPid, X, Y, Path) ->
    sync(Npc),
    NewX = X,
    NewY = Y,
    map:npc_move(MapPid, Npc#npc.id, NewX, NewY),
    NewNpc = Npc#npc{pos= Pos#pos{x = NewX, y = NewY}, path = Path, ts = now()},
    {next_state, patrol, NewNpc, Tpatrol};
zb_move(Npc = #npc{fun_type = ?npc_fun_type_guild_td, pos = Pos, t_patrol = Tpatrol}, MapPid, X, _Y, Path) ->
    sync(Npc),
    NewX = X + util:rand(-180, 0),
    NewY = 460 + util:rand(-40, 40),
    %%?DEBUG("   NPC 坐标  [~w, ~w]", [NewX, NewY]),
    map:npc_move(MapPid, Npc#npc.id, NewX, NewY),
    NewNpc = Npc#npc{pos= Pos#pos{x = NewX, y = NewY}, path = Path, ts = now()},
    {next_state, patrol, NewNpc, Tpatrol};
zb_move(Npc = #npc{pos = Pos, t_patrol = Tpatrol}, MapPid, X, Y, Path) ->
    sync(Npc),
    NewX = X + util:rand(-20, 0),
    NewY = Y + util:rand(-20, 0),
    map:npc_move(MapPid, Npc#npc.id, NewX, NewY),
    NewNpc = Npc#npc{pos= Pos#pos{x = NewX, y = NewY}, path = Path, ts = now()},
    {next_state, patrol, NewNpc, Tpatrol}.	
	
