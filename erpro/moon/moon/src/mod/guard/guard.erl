%%----------------------------------------------------
%%  守卫洛水(塔防进程)
%% @author shawn 
%%----------------------------------------------------

-module(guard).
-behaviour(gen_fsm).

-include("common.hrl").
-include("guard.hrl").
-include("role.hrl").
-include("map.hrl").
-include("assets.hrl").
-include("guild.hrl").
%%

-export([
        active/2 %%副本运行中
        ,idel/2 %%空闲状态
        ,pre_stop/2 %% 副本清理中
        ,pre_start/2 %% 副本准备开启
    ]
).

-export([
        start/0
        ,get_status/1
    ]
).

-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

%% 计算个人得分
calc_role_result([], _Type, _GetPoint, JoinRole) -> JoinRole;
calc_role_result([{{Rid, SrvId}, Name, Career, Lev} | T], 1, GetPoint, JoinRole) ->
    case lists:keyfind({Rid, SrvId}, #role_guard.id, JoinRole) of
        false ->
            case role_api:lookup(by_id, {Rid, SrvId}, [#role.sex, #role.guild, #role.looks, #role.eqm, #role.assets, #role.pid]) of
                {ok, _N, [Sex, Guild, Looks, Eqm, #assets{guard_acc = Guard}, Pid]} ->
                    GuildName = case Guild of
                        #role_guild{name = Gname} -> Gname;
                        _ -> ?L(<<>>)
                    end,
                    R = #role_guard{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, name = Name, sex = Sex, looks = Looks, eqm = Eqm, guild_name = GuildName, career = Career, lev = Lev, point = GetPoint, all_point = Guard + GetPoint, kill_boss = 1},
                    role:apply(async, Pid, {fun add_point/2, [GetPoint]}),
                    calc_role_result(T, 1, GetPoint, [R | JoinRole]);
                _ ->
                    calc_role_result(T, 1, GetPoint, JoinRole)
            end;
        GuardRole = #role_guard{kill_boss = KillBoss, point = Point, all_point = AllPoint} ->
            case role_api:lookup(by_id, {Rid, SrvId}, #role.pid) of
                {ok, _N, Pid} ->
                    role:apply(async, Pid, {fun add_point/2, [GetPoint]});
                _ -> skip
            end,
            calc_role_result(T, 1, GetPoint, lists:keyreplace({Rid, SrvId}, #role_guard.id, JoinRole, GuardRole#role_guard{kill_boss = KillBoss + 1, point = Point + GetPoint, all_point = AllPoint + GetPoint}))
    end;
calc_role_result([{{Rid, SrvId}, Name, Career, Lev} | T], 0, GetPoint, JoinRole) ->
    case lists:keyfind({Rid, SrvId}, #role_guard.id, JoinRole) of
        false ->
            case role_api:lookup(by_id, {Rid, SrvId}, [#role.sex, #role.guild, #role.looks, #role.eqm, #role.assets, #role.pid]) of
                {ok, _N, [Sex, Guild, Looks, Eqm, #assets{guard_acc = Guard}, Pid]} ->
                    GuildName = case Guild of
                        #role_guild{name = Gname} -> Gname;
                        _ -> ?L(<<>>)
                    end,
                    R = #role_guard{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, name = Name, sex = Sex, looks = Looks, eqm = Eqm, guild_name = GuildName, career = Career, lev = Lev, point = GetPoint, all_point = Guard + GetPoint, kill_npc = 1},
                    role:apply(async, Pid, {fun add_point/2, [GetPoint]}),
                    calc_role_result(T, 0, GetPoint, [R | JoinRole]);
                _ ->
                    calc_role_result(T, 0, GetPoint, JoinRole)
            end;
        GuardRole = #role_guard{kill_npc = KillNpc, point = Point, all_point = AllPoint} ->
            case role_api:lookup(by_id, {Rid, SrvId}, #role.pid) of
                {ok, _N, Pid} ->
                    role:apply(async, Pid, {fun add_point/2, [GetPoint]});
                _ -> skip
            end,
            calc_role_result(T, 0, GetPoint, lists:keyreplace({Rid, SrvId}, #role_guard.id, JoinRole, GuardRole#role_guard{kill_npc = KillNpc + 1, point = Point + GetPoint, all_point = AllPoint + GetPoint}))
    end.

clean_npc(#guard{map_pid = MapPid}) ->
    MapPid ! {clear_guard_npc}.

%% 开启新的塔防
start() ->
    case catch gen_fsm:start_link(?MODULE, [], []) of
        {ok, GuardPid} ->
            {ok, GuardPid};
        _Err ->
            ?DEBUG("开启洛水守卫异常:~w",[_Err]),
            {false, ?L(<<"开启洛水守卫异常">>)}
    end.

add_point(Role = #role{name = _Name, assets = Assets = #assets{guard_acc = Guard}}, Point) ->
    ?DEBUG("~s原有积分~w, 增加~w",[_Name, Guard, Point]),
    NewRole = Role#role{assets = Assets#assets{guard_acc = Guard + Point}},
    Nr = role_listener:special_event(NewRole, {30006, 1}), %%参与一次守卫洛水
    {ok, Nr}.

%% 获取战场信息
get_status(GuardPid) ->
    gen_fsm:sync_send_all_state_event(GuardPid, get_status).


%% ----服务器内部实现--------
init([]) ->
    ?DEBUG("创建洛水城塔防进程"),
    process_flag(trap_exit, true),
    case ets:lookup(map_info, ?GUARD_MAP_ID) of
        [#map{pid = MapPid}] ->
            NewState = #guard{td_lev = 1, ts = now(), map_pid = MapPid},
            guard_mgr:guard_start(self()),
            self() ! sync,
            ?DEBUG("找到洛水地图,开始进入准备期"),
            notice:send(54, ?L(<<"群魔乱舞，守卫洛水，大批的妖魔预计在3分钟后进攻洛水城，飞仙同道赶紧准备前往洛水城降服群魔！{open, 18, 点击传送, FFFF66}">>)),
            pack_15400(pre_start, NewState),
            {ok, pre_start, NewState, ?GUARD_TIME_PRE_START};
        _ -> {stop, create_maps_failure}
    end.

handle_event(_Event, StateName, State) ->
    {next_state, StateName, State}.

%% 获取战场信息 
handle_sync_event(get_status, _From, pre_start, State = #guard{ts = Ts}) -> 
    {reply, {?GUARD_STATE_READY, State}, pre_start, State, util:time_left(?GUARD_TIME_PRE_START, Ts)}; 
handle_sync_event(get_status, _From, pre_stop, State = #guard{ts = Ts}) -> 
    {reply, {?GUARD_STATE_OVER, State}, pre_stop, State, util:time_left(?GUARD_TIME_PRE_STOP, Ts)}; 
handle_sync_event(get_status, _From, idel, State = #guard{ts = Ts}) -> 
    {reply, {?GUARD_STATE_RUN, State}, idel, State, util:time_left(?GUARD_TIME_IDEL, Ts)}; 
handle_sync_event(get_status, _From, StateName, State) -> 
    {reply, {?GUARD_STATE_RUN, State}, StateName, State}; 

handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    {reply, Reply, StateName, State}.

handle_info(sync, StateName, State) ->
    guard_mgr:sync_rank(State),
    erlang:send_after(?GUARD_SYNC_TIME, self(), sync),
    continue(StateName, State);

%% 杀怪结果更新
handle_info({result, _Type, _Point, _RoleList}, pre_stop, State) ->
    continue(pre_stop, State);

%% 更新杀怪结果
handle_info({result, _Type, _Point, _RoleList}, StateName, State = #guard{hp = Hp}) when Hp =< 0 ->
    continue(StateName, State);

handle_info({result, Type, Point, RoleList}, StateName, State = #guard{td_lev = TdLev, join_role = JoinRole, surplus_npc = SurNpc, kill = Kill, npc_nums = NpcNums}) ->
    NewState = case Type of
        1 -> State#guard{kill = Kill + 1, surplus_npc = SurNpc - 1, npc_nums = NpcNums - 1};
        0 -> State#guard{kill = Kill + 1, surplus_npc = SurNpc - 1, npc_nums = NpcNums - 1}
    end,
    NewJoinRole = calc_role_result(RoleList, Type, Point, JoinRole),
    Ns = NewState#guard{join_role = NewJoinRole},
    case Ns#guard.surplus_npc =< 0 of
        true ->
            case TdLev =:= ?GUARD_MAX_LEV of
                true -> 
                    clean_npc(Ns),
                    pack_15400(pre_stop, Ns),
                    notice:send(54, ?L(<<"在各位飞仙同道的奋力抵抗下，进攻洛水城的群魔已被降服，妖帝的阴谋被粉碎了。">>)),
                    notice:effect(11, <<"">>),
                    {next_state, pre_stop, Ns#guard{ts = now()}, ?GUARD_TIME_PRE_STOP};
                false -> 
                    notice:send(53, util:fbin(?L(<<"第~w波怪物已经被抵挡，第~w波怪物即将到来，其中包含飞行怪物，请注意保护城主！">>), [TdLev, TdLev + 1])),
                    pack_15400(idel, Ns#guard{td_lev = TdLev + 1}),
                    {next_state, idel, Ns#guard{td_lev = TdLev + 1, ts = now()}, ?GUARD_TIME_IDEL}
            end;
        false ->
            ?DEBUG("剩余怪数:~w,状态:~w",[Ns#guard.surplus_npc, StateName]),
            case Ns#guard.surplus_npc =< 20 andalso StateName =:= active of
                true ->
                    case TdLev =:= ?GUARD_MAX_LEV of
                        true -> continue(StateName, Ns);
                        false -> 
                            notice:send(54, util:fbin(?L(<<"第~w波怪物攻势已缓，第~w波怪物即将到来，其中包含飞行怪物，请注意保护城主！">>), [TdLev, TdLev + 1])),
                            pack_15400(idel, Ns#guard{td_lev = TdLev + 1}),
                            {next_state, idel, Ns#guard{td_lev = TdLev + 1, ts = now()}, ?GUARD_TIME_IDEL}
                    end;
                false -> continue(StateName, Ns)
            end
    end;

%% 遗漏怪物
handle_info({loss_npc, _Type, _}, pre_stop, State) ->
    continue(pre_stop, State);

%% 遗漏怪物
handle_info({loss_npc, _Type, _}, StateName, State = #guard{hp = Hp}) when Hp =< 0 ->
    continue(StateName, State);

%% 遗漏的不是最后一只怪,但是血量不足
handle_info({loss_npc, 0, Point}, _StateName, State = #guard{join_role = _JoinRole, surplus_npc = SurNpc, hp = Hp, td_lev = TdLev, npc_nums = NpcNums}) when SurNpc > 1 andalso Hp =< Point ->
    NewState = State#guard{surplus_npc = SurNpc - 1, hp = 0, npc_nums = NpcNums - 1}, 
    clean_npc(NewState),
    %% send_mail(State#guild_td{td_lev = TdLev - 1}),
    pack_15400(pre_stop, NewState),
    notice:send(54, ?L(<<"道高一尺，魔高一丈！虽然洛水群英奋力抵抗群妖，但是依旧没有抵挡住强大的怪物。">>)),
    {next_state, pre_stop, NewState#guard{ts = now(), td_lev = TdLev - 1}, ?GUARD_TIME_PRE_STOP};

handle_info({loss_npc, 1, Point}, _StateName, State = #guard{join_role = _JoinRole, surplus_npc = SurNpc, hp = Hp, td_lev = TdLev, npc_nums = NpcNums}) when SurNpc > 1 andalso Hp =< Point ->
    NewState = State#guard{surplus_npc = SurNpc - 1, hp = 0, npc_nums = NpcNums - 1}, 
    clean_npc(NewState),
    %% send_mail(State#guild_td{td_lev = TdLev - 1}),
    pack_15400(pre_stop, NewState),
    notice:send(54, ?L(<<"道高一尺，魔高一丈！虽然洛水群英奋力抵抗群妖，但是依旧没有抵挡住强大的怪物。">>)),
    {next_state, pre_stop, NewState#guard{ts = now(), td_lev = TdLev - 1}, ?GUARD_TIME_PRE_STOP};

%% 遗漏本波最后一只怪,
handle_info({loss_npc, 0, Point}, StateName, State = #guard{join_role = _JoinRole, td_lev = TdLev, surplus_npc = 1, hp = Hp, npc_nums = NpcNums}) when Hp > Point ->
    NewState = State#guard{surplus_npc = 0, hp = Hp - Point, npc_nums = NpcNums - 1}, 
    case TdLev =:= ?GUARD_MAX_LEV of
        true -> 
            clean_npc(NewState),
            %% send_mail(State),
            pack_15400(pre_stop, NewState),
            notice:send(54, ?L(<<"在各位飞仙同道的奋力抵抗下，进攻洛水城的群魔已被降服，妖帝的阴谋被粉碎了。">>)),
            notice:effect(11, <<"">>),
            {next_state, pre_stop, NewState#guard{ts = now()}, ?GUARD_TIME_PRE_STOP};
        false -> 
            case StateName =:= active of
                true -> 
                    notice:send(53, util:fbin(?L(<<"第~w波怪物已经被抵挡，第~w波怪物即将到来，其中包含飞行怪物，请注意保护城主！">>), [TdLev, TdLev + 1])),
                    pack_15400(idel, NewState#guard{td_lev = TdLev + 1}),
                    {next_state, idel, NewState#guard{td_lev = TdLev + 1, ts = now()}, ?GUARD_TIME_IDEL};
                false ->
                    continue(StateName, NewState)
            end
    end;

%% 遗漏本波最后一只BOSS, 需要Point滴血以上
handle_info({loss_npc, 1, Point}, StateName, State = #guard{join_role = _JoinRole, td_lev = TdLev, surplus_npc = 1, hp = Hp, npc_nums = NpcNums}) when Hp > Point ->
    NewState = State#guard{surplus_npc = 0, hp = Hp - Point, npc_nums = NpcNums - 1}, 
    case TdLev =:= ?GUARD_MAX_LEV of
        true -> 
            clean_npc(NewState),
            %% send_mail(State),
            pack_15400(pre_stop, NewState),
            notice:send(54, ?L(<<"在各位飞仙同道的奋力抵抗下，进攻洛水城的群魔已被降服，妖帝的阴谋被粉碎了。">>)),
            notice:effect(11, <<"">>),
            {next_state, pre_stop, NewState#guard{ts = now()}, ?GUARD_TIME_PRE_STOP};
        false -> 
            case StateName =:= active of
                true -> 
                    notice:send(53, util:fbin(?L(<<"第~w波怪物已经被抵挡，第~w波怪物即将到来，其中包含飞行怪物，请注意保护城主！">>), [TdLev, TdLev + 1])),
                    pack_15400(idel, NewState#guard{td_lev = TdLev + 1}),
                    {next_state, idel, NewState#guard{td_lev = TdLev + 1, ts = now()}, ?GUARD_TIME_IDEL};
                false ->
                    continue(StateName, NewState)
            end
    end;

%% 遗漏最后一只怪, 且血量刚好为0
handle_info({loss_npc, 0, Point}, _StateName, State = #guard{surplus_npc = 1, hp = Hp, join_role = _JoinRole, td_lev = TdLev, npc_nums = NpcNums}) when Hp =< Point ->
    NewState = State#guard{surplus_npc = 0, hp = 0, npc_nums = NpcNums - 1}, 
    clean_npc(NewState),
    pack_15400(pre_stop, NewState),
    notice:send(54, ?L(<<"道高一尺，魔高一丈！虽然洛水群英奋力抵抗群妖，但是依旧没有抵挡住强大的怪物。">>)),
    %% send_mail(State#guard{td_lev = TdLev - 1}),
    {next_state, pre_stop, NewState#guard{ts = now(), td_lev = TdLev - 1}, ?GUARD_TIME_PRE_STOP};

%% 遗漏最后一只怪, 且血量刚好为0
handle_info({loss_npc, 1, Point}, _StateName, State = #guard{td_lev = TdLev, surplus_npc = 1, hp = Hp, join_role = _JoinRole, npc_nums = NpcNums}) when Hp =< Point ->
    NewState = State#guard{surplus_npc = 0, hp = 0, npc_nums = NpcNums - 1}, 
    clean_npc(NewState),
    pack_15400(pre_stop, NewState),
    notice:send(54, ?L(<<"道高一尺，魔高一丈！虽然洛水群英奋力抵抗群妖，但是依旧没有抵挡住强大的怪物。">>)),
    %% send_mail(State#guard{td_lev = TdLev - 1}),
    {next_state, pre_stop, NewState#guard{ts = now(), td_lev = TdLev - 1}, ?GUARD_TIME_PRE_STOP};

%% 正常情况下怪物的遗漏
handle_info({loss_npc, 0, Point}, StateName, State = #guard{surplus_npc = SurNpc, hp = Hp, join_role = _JoinRole, npc_nums = NpcNums, td_lev = TdLev}) ->
    NewState = State#guard{surplus_npc = SurNpc - 1, hp = Hp - Point, npc_nums = NpcNums - 1}, 
    case SurNpc - 1 =< 20 andalso StateName =:= active of
        true ->
            case TdLev =:= ?GUARD_MAX_LEV of
                true ->
                    pack_15400(StateName, NewState),
                    map:pack_send_to_all(?GUARD_MAP_ID, 10931, {55, util:fbin(?L(<<"在怪物的围攻下，城主灵威仰损失了~w点体力，剩余~w点体力">>), [Point, Hp - Point]), []}),
                    continue(StateName, NewState);
                false ->
                    notice:send(53, util:fbin(?L(<<"第~w波怪物攻势已缓，第~w波怪物即将到来，其中包含飞行怪物，请注意保护城主！">>), [TdLev, TdLev + 1])),
                    pack_15400(idel, NewState#guard{td_lev = TdLev + 1}),
                    {next_state, idel, NewState#guard{td_lev = TdLev + 1, ts = now()}, ?GUARD_TIME_IDEL}
            end;
        false ->
            ?DEBUG("剩余怪数:~w, 状态:~w",[SurNpc -1, StateName]),
            pack_15400(StateName, NewState),
            map:pack_send_to_all(?GUARD_MAP_ID, 10931, {55, util:fbin(?L(<<"在怪物的围攻下，城主灵威仰损失了~w点体力，剩余~w点体力">>), [Point, Hp - Point]), []}),
            continue(StateName, NewState)
    end;

%% BOSS遗漏
handle_info({loss_npc, 1, Point}, StateName, State = #guard{surplus_npc = SurNpc, hp = Hp, join_role = _JoinRole, npc_nums = NpcNums, td_lev = TdLev}) ->
    NewState = State#guard{surplus_npc = SurNpc - 1, hp = Hp - Point, npc_nums = NpcNums - 1}, 
    case SurNpc - 1 =< 20 andalso StateName =:= active of
        true ->
            case TdLev =:= ?GUARD_MAX_LEV of
                true ->
                    pack_15400(StateName, NewState),
                    map:pack_send_to_all(?GUARD_MAP_ID, 10931, {55, util:fbin(?L(<<"在怪物的围攻下，城主灵威仰损失了~w点体力，剩余~w点体力">>), [Point, Hp - Point]), []}),
                    continue(StateName, NewState);
                false ->
                    notice:send(53, util:fbin(?L(<<"第~w波怪物攻势已缓，第~w波怪物即将到来，其中包含飞行怪物，请注意保护城主！">>), [TdLev, TdLev + 1])),
                    pack_15400(idel, NewState#guard{td_lev = TdLev + 1}),
                    {next_state, idel, NewState#guard{td_lev = TdLev + 1, ts = now()}, ?GUARD_TIME_IDEL}
            end;
        false ->
            ?DEBUG("剩余怪数:~w, 状态:~w",[SurNpc -1, StateName]),
            pack_15400(StateName, NewState),
            map:pack_send_to_all(?GUARD_MAP_ID, 10931, {55, util:fbin(?L(<<"在怪物的围攻下，城主灵威仰损失了~w点体力，剩余~w点体力">>), [Point, Hp - Point]), []}),
            continue(StateName, NewState)
    end;

%% 创建NPC消息
handle_info({create_npc, _, _}, pre_stop, State) ->
    continue(pre_stop, State);
handle_info({create_npc, _Time, []}, StateName, State) ->
    continue(StateName, State);
handle_info({create_npc, Time, LevList}, StateName, State = #guard{npc_nums = NpcNums}) ->
    {CreateNum, NewLevList} = create_npc(LevList, ?GUARD_MAP_ID, NpcNums),
    ?DEBUG("创建~w怪,旧列表:~w,新列表:~w, 当前场景怪数:~w",[CreateNum, LevList, NewLevList, NpcNums]),
    case NewLevList =:= [] of
        true -> continue(StateName, State#guard{npc_nums = NpcNums + CreateNum});
        false -> 
            erlang:send_after(erlang:trunc(Time * 1000), self(), {create_npc, Time, NewLevList}), 
            continue(StateName, State#guard{npc_nums = NpcNums + CreateNum})
    end;

%% 时间已到, 关闭副本
handle_info(keep_time_out, pre_stop, State) ->
    continue(pre_stop, State);

handle_info(keep_time_out, _StateName, State = #guard{td_lev = TdLev}) ->
    clean_npc(State),
    ?DEBUG("时间到,守卫结束"),
    notice:send(54, util:fbin(?L(<<"在各位飞仙同道的奋力抵抗下，洛水群英坚守了~w波，成功守卫了洛水城。">>), [TdLev])),
    notice:effect(11, <<"">>),
    pack_15400(pre_stop, State),
    {next_state, pre_stop, State#guard{ts = now(), td_lev = TdLev - 1}, ?GUARD_TIME_PRE_STOP};

handle_info(stop, _, State) ->
    ?INFO("关闭守卫洛水成功"),
    pack_15400(pre_stop, State),
    {stop, normal, State};

handle_info(_Info, StateName, State) ->
    continue(StateName, State).

terminate(normal, _StateName, State) ->
    ?DEBUG("正常关闭:~w", [_StateName]),
    guard_mgr:guard_stop(State),
    ok;

%% 异常挂掉之后 奖励继续发放
terminate(_Reason, _StateName, State) ->
    ?DEBUG("异常关闭:~w", [_StateName]),
    guard_mgr:guard_stop(State),
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%% ----------------------------------------------
check_map_npc(NpcNums) when NpcNums >= 100 -> false;
check_map_npc(_) -> true.

%% ---------创建NPC
create_npc([], _MapId, _NpcNums) -> {0, []};
create_npc([SmallLev | T], MapId, NpcNums) ->
    case check_map_npc(NpcNums) of
        false -> {0, [SmallLev | T]};
        true ->
            NpcInfo = guard_data:get_small(SmallLev),
            Num = create_point(NpcInfo, MapId, 0),
            {Num, T}
    end.

create_point([], _MapId, N) -> N;
create_point([{NpcBaseId, Num, X, Y, PathNum} | T], MapId, N) ->
    create_one_npc(NpcBaseId, Num, X, Y, MapId, PathNum),
    create_point(T, MapId, Num + N).
    
create_one_npc(_NpcBaseId, 0, _X, _Y, _MapId, _PathNum) -> ok;
create_one_npc(NpcBaseId, Num, X, Y, MapId, PathNum) ->
    npc_mgr:create(NpcBaseId, MapId, X, Y, npc_path_data:get_guard_path(PathNum)),
    create_one_npc(NpcBaseId, Num - 1, X, Y, MapId, PathNum).

pack_15400(pre_start, #guard{ts = Ts}) ->
    Time = util:time_left(?GUARD_TIME_PRE_START, Ts) div 1000,
    role_group:pack_cast(world, 15400, {?GUARD_STATE_READY, 0, 0, Time});
pack_15400(pre_stop, _State) ->
    role_group:pack_cast(world, 15400, {?GUARD_STATE_OVER, 0, 0, 0});
pack_15400(_, #guard{map_pid = MapPid, td_lev = TdLev, hp = Hp, end_time = EndTime}) ->
    Now = util:unixtime(),
    ?DEBUG("TdLev:~w, Hp:~w, Time:~w",[TdLev, Hp, EndTime - Now]),
    map:pack_send_to_all(MapPid, 15400, {?GUARD_STATE_RUN, TdLev, Hp, EndTime - Now}).

calc_num(LevList) ->
    calc_num(LevList, 0).
calc_num([], Num) -> Num;
calc_num([Lev | T], Num) ->
    case guard_data:get_small(Lev) of
        L when is_list(L) ->
            calc_num(T, Num + length(L));
        _ ->
            ?ERR("错误的洛水小节怪物数据:~w",[Lev]),
            calc_num(T, Num)
    end.

get_online_nums() ->
    L = role_adm:get_roles_id_online(),
    get_online_nums(L, 0).
get_online_nums([], Num) -> Num;
get_online_nums([{_, L} | T], Num) when is_list(L) ->
    get_online_nums(T, Num + length(L));
get_online_nums([{_, _} | T], Num) ->
    get_online_nums(T, Num).

%% --------------------------------
%% 运行状态
active(_Any, State) ->
    continue(active, State).

%% 空闲状态
idel(timeout, State = #guard{td_lev = TdLev, surplus_npc = N}) ->
    {_, Time, _BossNum, LevList} = guard_data:get_lev(TdLev), 
    OnlineNum = get_online_nums(),
    Ratio = if
        OnlineNum =< 100 -> lists:nth(1, guard_data:get_ratio(TdLev));
        OnlineNum > 100 andalso OnlineNum =< 200 -> lists:nth(2, guard_data:get_ratio(TdLev));
        OnlineNum > 200 andalso OnlineNum =< 300 -> lists:nth(3, guard_data:get_ratio(TdLev));
        OnlineNum > 300 andalso OnlineNum =< 500 -> lists:nth(4, guard_data:get_ratio(TdLev));
        OnlineNum > 500 andalso OnlineNum =< 700 -> lists:nth(5, guard_data:get_ratio(TdLev));
        OnlineNum > 700 andalso OnlineNum =< 1000 -> lists:nth(6, guard_data:get_ratio(TdLev));
        OnlineNum > 1000 -> lists:nth(7, guard_data:get_ratio(TdLev));
        true -> 1
    end,
    ?INFO("TdLev:~w, Ratio:~w, OnlineNum:~w",[TdLev, Ratio, OnlineNum]), 
    AddLev = util:ceil(length(LevList) * Ratio) - length(LevList),
    NewLevList = LevList ++ guard_mgr:get_list(LevList, 1, AddLev), 
    Summary = calc_num(NewLevList),
    ?DEBUG("第~w波怪物开始创建,之前还有~w个",[TdLev, N]),
    ?DEBUG("在线人数为~w人,自动调节系数为:~w,旧小节:~w,调节之后小节:~w,总的怪物数为:~w",[OnlineNum, Ratio, LevList, NewLevList, Summary]),
    self() ! {create_npc, Time, NewLevList}, 
    NewState = State#guard{ts = now(), surplus_npc = N + Summary, kill = 0},
    {next_state, active, NewState};

idel(_Any, State) ->
    continue(idel, State).

%% 准备状态超时, 开启副本
pre_start(timeout, State) ->
    NewState = State#guard{ts = now(), end_time = util:unixtime() + ?GUARD_KEEP_TIME div 1000},
    notice:send(54, ?L(<<"大批的妖魔已经从洛水城东北方和西南方进入洛水城，途径许愿池，飞仙同道赶紧前往诛灭群妖！{open, 18, 点击传送, FFFF66}">>)),
    %% TODO 广播副本信息
    pack_15400(idel, NewState),
    erlang:send_after(?GUARD_KEEP_TIME, self(), keep_time_out), 
    ?DEBUG("准备期超时,进入空闲状态"),
    {next_state, idel, NewState, ?GUARD_TIME_IDEL};

pre_start(_Any, State) ->
    continue(pre_start, State).

%% 清理时间超时，关闭副本
pre_stop(timeout, State) ->
    {stop, normal, State};

pre_stop(_Any, State) ->
    continue(pre_stop, State).

%% ---------------------------------
%% 重新计算超时时间，继续某一状态
continue(active, State) ->
    {next_state, active, State};
continue(idel, State = #guard{ts = Ts}) ->
    {next_state, idel, State, util:time_left(?GUARD_TIME_IDEL, Ts)};
continue(pre_start, State = #guard{ts = Ts}) ->
    {next_state, pre_start, State, util:time_left(?GUARD_TIME_PRE_START, Ts)};
continue(pre_stop, State = #guard{ts = Ts}) ->
    {next_state, pre_stop, State, util:time_left(?GUARD_TIME_PRE_STOP, Ts)}.
