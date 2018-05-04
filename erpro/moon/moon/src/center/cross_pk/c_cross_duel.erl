%%----------------------------------------------------
%% 跨服决斗书决斗进程
%% @author wpf(wprehard@qq.com)
%%----------------------------------------------------
-module(c_cross_duel).
-behaviour(gen_fsm).
-export([
        start/1
        ,over_combat/2
        ,over/2
        ,cancel_duel/3
        ,send_duel_info/4
    ]).
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).
-export([idel/2, duel/2]).

-include("common.hrl").
-include("cross_pk.hrl").
-include("role.hrl").
-include("combat.hrl").

-record(state, {
        combat_pid = 0  %% 关联的战斗进程PID
        ,id_1 = 0       %% 决斗邀请方角色ID
        ,id_2 = 0       %% 决斗接受放角色ID
        ,ts = 0         %% 进入某状态时刻
        ,t_cd = 0       %% 空间时间(不是固定的)
    }
).

%% @spec start_link(Roles) -> {ok, pid()}
%% @doc 开启决斗进程
start(DuelRoles) ->
    gen_fsm:start(?MODULE, [DuelRoles], []).

%% @spec over_combat(Pid, WinnerId) -> any()
%% @doc 战斗结束
over_combat(Pid, WinnerId) when is_pid(Pid) ->
    Pid ! {over_combat, WinnerId};
over_combat(_Pid, _WinnerId) ->
    ignore.

%% @spec over(Pid, LogoutId) -> any()
%% @doc 结束决斗进程
over(Pid, RoleId) when is_pid(Pid) ->
    Pid ! {over, RoleId};
over(_Pid, _) ->
    ignore.

%% @spec cancel_duel(RolePid2, PkRole1, PkRole2)
%% RolePid = pid() 剩余胜利方的角色进程PID
%% @doc 取消玩家的决斗
cancel_duel(RolePid, #cross_pk_role{id = RoleId1, name = Name1}, #cross_pk_role{id = RoleId2, name = Name2}) ->
    ets:delete(ets_cross_duel_roles, RoleId2),
    ets:delete(ets_cross_duel_roles, RoleId1),
    rpc:cast(node(RolePid), cross_pk, notice_cast, [4, {RoleId1, Name1}, {RoleId2, Name2}]), %% 公告胜利方所在服
    role:pack_send(RolePid, 16915, {?true}), %% 通知胜利
    role:apply(async, RolePid, {cross_pk, apply_cancel_duel_event, []});
cancel_duel(_, _, _) -> ignore.

%% @spec send_duel_info(PkRole1, RolePid1, PkRole2, RolePid2) -> any()
%% @doc 推送决斗信息
send_duel_info(#cross_pk_role{id = {Rid1, SrvId1}, name = Name1, career = Career1, fight_capacity = Fight1, pet_fight = PetFight1}, RolePid1, #cross_pk_role{id = {Rid2, SrvId2}, name = Name2, career = Career2, fight_capacity = Fight2, pet_fight = PetFight2}, RolePid2) ->
    Msg1 = {?CROSS_DUEL_IDEL_CD, Rid2, SrvId2, Name2, Career2, Fight2, PetFight2},
    Msg2 = {?CROSS_DUEL_IDEL_CD, Rid1, SrvId1, Name1, Career1, Fight1, PetFight1},
    role:pack_send(RolePid1, 16914, Msg1),
    role:pack_send(RolePid2, 16914, Msg2),
    ok.

%% 决斗结束
over_duel(WinnerId) ->
    case ets:lookup(ets_cross_duel_roles, WinnerId) of
        [] ->
            ?ERR("决斗结束，未找到胜利玩家信息"),
            ignore;
        [#cross_duel_role{pid = RolePid1, info = #cross_pk_role{name = Name1}, pk_id = RoleId2, pk_pid = RolePid2, pk_info = #cross_pk_role{name = Name2}}] ->
            ets:delete(ets_cross_duel_roles, RoleId2),
            ets:delete(ets_cross_duel_roles, WinnerId),
            role:apply(async, RolePid1, {cross_pk, apply_cancel_duel_event, []}),
            role:apply(async, RolePid2, {cross_pk, apply_cancel_duel_event, []}),
            role:pack_send(RolePid1, 16915, {?true}), %% 通知胜利
            role:pack_send(RolePid2, 16915, {?false}),
            case node(RolePid1) =:= node(RolePid2) of
                true ->
                    rpc:cast(node(RolePid1), cross_pk, notice_cast, [3, {WinnerId, Name1}, {RoleId2, Name2}]);
                false ->
                    rpc:cast(node(RolePid1), cross_pk, notice_cast, [3, {WinnerId, Name1}, {RoleId2, Name2}]),
                    rpc:cast(node(RolePid2), cross_pk, notice_cast, [3, {WinnerId, Name1}, {RoleId2, Name2}])
            end,
            ok;
        _E ->
            ?ERR("决斗结束，找到错误的胜利玩家信息:~w", [_E]),
            ets:delete(ets_cross_duel_roles, WinnerId),
            ignore
    end.

%% --------------------------------------------------------------------
%% gen_fsm callback functions
%% --------------------------------------------------------------------

%% Func: init/1
%% Returns: {ok, StateName, StateData}          |
%%          {ok, StateName, StateData, Timeout} |
%%          ignore                              |
%%          {stop, StopReason}
init([DuelRoles]) ->
    update_duel_role(self(), DuelRoles),
    NewState = update_state(DuelRoles, #state{ts = util:unixtime(), t_cd = ?CROSS_DUEL_IDEL_CD}),
    {ok, idel, NewState, ?CROSS_DUEL_IDEL_CD*1000}.

%% Func: handle_event/3
%% Returns: {next_state, NextStateName, NextStateData}          |
%%          {next_state, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}

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
    
handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    continue(Reply, StateName, State).

%% Func: handle_info/3
%% Returns: {next_state, NextStateName, NextStateData}          |
%%          {next_state, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}

handle_info({over, _}, duel, State) ->
    continue(duel, State); %% 决斗已经开战，继续战斗
handle_info({over, RoleId}, StateName, State = #state{combat_pid = CombatPid, id_1 = RoleId1, id_2 = RoleId2})
when RoleId =:= RoleId1 orelse RoleId =:= RoleId2 ->
    case is_pid(CombatPid) andalso is_process_alive(CombatPid) of
        true ->
            continue(StateName, State); %% 等战斗结束
        false ->
            case ets:lookup(ets_cross_duel_roles, RoleId) of
                [] -> ?ERR("跨服决斗中，玩家掉线，未找到信息");
                [#cross_duel_role{info = PkRole1, pk_pid = RolePid2, pk_info = PkRole2}] ->
                    cancel_duel(RolePid2, PkRole1, PkRole2)
            end,
            {stop, normal, State}
    end;
handle_info({over, _}, StateName, State) ->
    ?ERR("跨服决斗收到异常的离线信息"),
    continue(StateName, State);

handle_info({over_combat, 0}, _, State = #state{id_1 = RoleId1}) ->
    over_duel(RoleId1), %% 默认一个赢
    {stop, normal, State};
handle_info({over_combat, WinnerId}, _StateName, State = #state{id_1 = RoleId1, id_2 = RoleId2})
when (WinnerId =:= RoleId1) orelse (WinnerId =:= RoleId2) ->
    over_duel(WinnerId),
    {stop, normal, State};

handle_info(_Info, StateName, State) ->
    ?DEBUG("收到无效消息: ~w", [_Info]),
    continue(StateName, State).

%% Func: terminate/3
%% Purpose: Shutdown the fsm
%% Returns: any
terminate(normal, _StateName, _Stat) ->
    ?DEBUG("*********************"),
    ok;
terminate(_Reason, _StateName, _State = #state{id_1 = RoleId1}) ->
    ?DEBUG("*********************"),
    over_duel(RoleId1), %% 默认一个赢
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
idel(timeout, State = #state{id_1 = RoleId1, id_2 = RoleId2}) ->
    ?DEBUG("~w 状态下收到消息", [state_idel]),
    AtkList = to_fighter([RoleId1]),
    DfdList = to_fighter([RoleId2]),
    case combat:start(?combat_type_c_duel, self(), AtkList, DfdList) of
        {ok, CombatPid} ->
            continue(duel, State#state{combat_pid = CombatPid, ts = util:unixtime(), t_cd = ?CROSS_DUEL_DUEL_CD});
        _ ->
            ?ERR("战斗发起失败"),
            {stop, normal, State}
    end;
idel(_Event, State) ->
    ?INFO("~w 状态下收到消息 ~w", [state_idel, _Event]),
    continue(idel, State).

%% 决斗状态
duel(timeout, State = #state{combat_pid = CombatPid}) ->
    CombatPid ! stop,
    continue(duel, State);
duel(_Event, State) ->
    continue(duel, State).

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
continue(StateName, State = #state{ts = Ts, t_cd = Tcd}) ->
    Now = util:unixtime(),
    Timeout = case Ts + Tcd - Now of
        T1 when T1 > 0 ->
            T1 * 1000;
        _ ->
            100
    end,
    {next_state, StateName, State, Timeout}.
continue(Reply, StateName, State = #state{ts = Ts, t_cd = Tcd}) ->
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

%% 更新决斗角色信息
update_duel_role(_DuelPid, []) -> ok;
update_duel_role(DuelPid, [H = #cross_duel_role{} | T]) ->
    ets:insert(ets_cross_duel_roles, H#cross_duel_role{duel_pid = DuelPid}),
    update_duel_role(DuelPid, T);
update_duel_role(_, [_H | _T]) ->
    ?ERR("_H: ~w", [_H]),
    ok.

%% 更新决斗信息
update_state([#cross_duel_role{id = RoleId1}, #cross_duel_role{id = RoleId2}], State) ->
    State#state{id_1 = RoleId1, id_2 = RoleId2};
update_state(CombatPid, State) when is_pid(CombatPid) ->
    State#state{combat_pid = CombatPid};
update_state(_, State) ->
    State.

%% 转化为战斗角色
to_fighter(Rids) when is_list(Rids) ->
    to_fighter(Rids, []).
to_fighter([], Back) ->
    Back;
to_fighter([RoleId | T], Back) ->
    case c_proxy:role_lookup(by_id, RoleId, to_fighter) of
        {ok, _, Fighter} ->
            to_fighter(T, [Fighter | Back]);
        _ ->
            to_fighter(T, Back)
    end.
