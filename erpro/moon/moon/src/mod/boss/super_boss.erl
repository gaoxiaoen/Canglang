%%----------------------------------------------------
%% @doc 世界boss模块
%%
%% <pre>
%% 世界boss模块
%% 对应多个super_boss_area
%% </pre>
%% @author mobin
%%----------------------------------------------------
-module(super_boss).

-behaviour(gen_server).

-export([
        start_link/4,
        is_super_boss/1,
        get_boss_info/2,
        get_current_status/1,
        is_critical/1,
        hit_boss/2,
        drop/3,
        revive/3
    ]
).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("boss.hrl").
-include("combat.hrl").
-include("npc.hrl").
-include("gain.hrl").
-include("role.hrl").
-include("assets.hrl").
-include("link.hrl").
-include("pos.hrl").
-include("boss_config.hrl").
-include("boss_lang.hrl").

-define(role_timer, 5 * 60).
-define(boss_info_timer, 40 * 1000).

-define(exit_map_id, 1405).
-define(recent_num, 6).

-record(state, {
        boss, 
        scene
    }).


%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------
%% @spec start_link() ->
%% @doc 启动超级世界boss进程
start_link(NpcBaseId, MapBaseId, SummonerId, IsUltimate) ->
    gen_server:start_link(?MODULE, [NpcBaseId, MapBaseId, SummonerId, IsUltimate], []).


%% @spec is_super_boss(NpcBaseId) -> true | false
%% @doc 是否超级世界boss
is_super_boss(NpcBaseId) ->
    lists:member(NpcBaseId, super_boss_data:bosses()).

get_boss_info(ConnPid, NpcBaseId) ->
    case ets:lookup(super_boss, NpcBaseId) of
        [{_, BossPid}] when is_pid(BossPid) ->
            BossPid ! {super_boss_info, ConnPid};
        _ ->
            ignore
    end.

%% @spec get_current_status(NpcBaseId) -> {Hp, HpMax}
%% @doc 获取超级世界boss状态（返回当前hp）
get_current_status(NpcBaseId) ->
    case ets:lookup(super_boss_status, NpcBaseId) of
        [{_, Hp, HpMax, _}] ->
            {Hp, HpMax};
        _ ->
            {0, 0}
    end.

is_critical(Rid) ->
    case ets:lookup(super_boss_role, Rid) of
        %%超时会被删除
        [#super_boss_role{is_critical = IsCritical}]->
            IsCritical;
        _ ->
            false
    end.

%% @spec hit_boss(DmgHp, RoleDmgList) -> ok
%% @doc 对超级世界boss造成伤害，并记录伤害来源
hit_boss(DmgHp, Fighter = #fighter{rid = RoleId, srv_id = SrvId}) ->
    case ets:lookup(super_boss_role, {RoleId, SrvId}) of
        %%超时会被删除
        [SuperBossRole = #super_boss_role{boss_pid = SuperBossPid, total_dmg = TotalDmg}] when is_pid(SuperBossPid)->
            ets:insert(super_boss_role, SuperBossRole#super_boss_role{total_dmg = TotalDmg + DmgHp, prev_dmg = 0}),
            gen_server:cast(SuperBossPid, {hit, DmgHp, Fighter});
        _ ->
            ignore
    end.

drop(Rid, RolePid, DmgHp) ->
    case ets:lookup(super_boss_role, Rid) of
        %%超时会被删除
        [SuperBossRole = #super_boss_role{total_dmg = TotalDmg, prev_dmg = PrevDmg, reward = Reward}]->
            AccumulateDmg = TotalDmg + PrevDmg,
            Value = DmgHp - PrevDmg + (AccumulateDmg rem ?unit_dmg),
            RollCount = AccumulateDmg div ?unit_dmg + 1,
            Drop = get_drop(Value, RollCount),
            %% 每回合有伤害时至少有一个掉落
            Drop2 = case DmgHp - PrevDmg > 0 of
                true ->
                    Drop + 1;
                false ->
                    Drop
            end,
            ets:insert(super_boss_role, SuperBossRole#super_boss_role{prev_dmg = DmgHp, reward = Reward + Drop2}),
            case Drop2 > 0 of
                true ->
                    role:pack_send(RolePid, 12852, {Drop2});
                false ->
                    ignore
            end;
        _ ->
            ignore
    end.

%% 处理复活
revive(SuperBossPid, Type, Role) ->
    SuperBossPid ! {revive, Type, Role}.

%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------
%% @spec init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
init([NpcBaseId, MapBaseId, SummaryId, IsUltimate]) ->
    ?INFO("正在创建世界boss[~w]...", [NpcBaseId]),
    case npc_data:get(NpcBaseId) of
        {ok, #npc_base{hp_max = HpMax}} ->
            Scene = #super_boss_scene{exit_map_id = ExitMapId} = super_boss_data:scene(MapBaseId),

            ets:insert(super_boss_status, {NpcBaseId, HpMax, HpMax, ExitMapId}), 
            
            SuperBoss = #super_boss{hp = HpMax, hp_max = HpMax, npc_base_id = NpcBaseId, is_ultimate = IsUltimate},
            State = #state{boss = SuperBoss, scene = Scene},

            put(info, #super_boss_info{summary_id = SummaryId, npc_base_id = NpcBaseId, invaid_map_id = ExitMapId}),
            put(combat_area, []),
            put(ranks, []),
            put(reward, 0),

            %% 提前创建1个战斗区域
            create_area(State),
            
            ?INFO("世界boss[~w]创建完成", [NpcBaseId]),
            %%用于判断是否需求广播
            put(prev_hp, HpMax),
            erlang:send_after(15000, self(), cast_status),

            put(recent_list, []),
            put(best_rank, #super_boss_rank{}),
            erlang:send_after(?boss_info_timer, self(), update_boss_info),
            {ok, State};
        _ -> 
            ?ELOG("创建世界boss失败，不存在的NPC:~w", [NpcBaseId]),
            {stop, <<>>}
    end.

handle_call({stop_directly}, _From, State) ->
    ?DEBUG("super_boss stop_directly"),
    force_combat_over(),
    force_exit_combat_area(),
    self() ! stop,
    {reply, ok, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast({hit, DmgHp, #fighter{pid = _Pid, rid = RoleId, srv_id = SrvId, name = Name}}, State = #state{boss = SuperBoss = #super_boss{is_die = IsDie,
            hp = Hp, hp_max = HpMax, npc_base_id = NpcBaseId, is_ultimate = IsUltimate},
            scene = #super_boss_scene{exit_map_id = ExitMapId}}) ->
    %%最终Boss无限血量
    NewHp = case IsUltimate of
        ?true ->
            HpMax;
        ?false ->
            combat_util:check_range(Hp - DmgHp, 0, HpMax)
    end,
    IsDie2 = combat_util:is_die(NewHp),
    ets:insert(super_boss_status, {NpcBaseId, NewHp, HpMax, ExitMapId}), 

    %%编年史监听
    % rank_celebrity:listener(dragon_boss_hit, {RoleId, SrvId}, DmgHp),

    SuperBoss2 = SuperBoss#super_boss{hp = NewHp, is_die = IsDie2},
    case {IsDie, IsDie2} of
        {?false, ?true} -> 
            %%最后一击
            SuperBossInfo = get(info),
            put(info, SuperBossInfo#super_boss_info{last_rid = {RoleId, SrvId}}),
            put(last_name, Name),

            %%勋章监听处理世界boss最后一击
            role:apply(async, _Pid, {medal, kill_super_boss, [NpcBaseId]}),

            %% 强迫所有未结束的战斗结束
            force_combat_over(),
            
            %%立即广播Boss状态
            cast_status(0, HpMax),

            super_boss_mgr:boss_die(),
            erlang:send_after(800, self(), {boss_die, 1});
        {?false, ?false} ->
            %%记录死亡数
            SuperBossInfo = #super_boss_info{kill_count = KillCount} = get(info),
            put(info, SuperBossInfo#super_boss_info{kill_count = KillCount + 1});
        _ ->
            ok
    end,
    {noreply, State#state{boss = SuperBoss2}};

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 通知某个角色巨龙当前状态
handle_info({notify_status, ConnPid}, State = #state{boss = #super_boss{hp = Hp, hp_max = HpMax}}) ->
    sys_conn:pack_send(ConnPid, 12862, {Hp, HpMax}),
    {noreply, State};

%% 广播巨龙的状态
handle_info(cast_status, State = #state{boss = #super_boss{hp = Hp, hp_max = HpMax}}) when Hp > 0 ->
    %%改成对需求的广播
    PrevHp = get(prev_hp),
    case PrevHp > Hp of
        true ->
            cast_status(Hp, HpMax),
            put(prev_hp, Hp);
        false ->
            ignore
    end,
    erlang:send_after(5000, self(), cast_status),
    {noreply, State};

handle_info(update_boss_info, State = #state{boss = #super_boss{is_die = IsDie}}) ->
    case IsDie of
        ?false ->
            update_boss_info(),

            erlang:send_after(?boss_info_timer, self(), update_boss_info);
        ?true ->
            ignore
    end,
    {noreply, State};

handle_info({enter_combat_area, AreaRole = #super_boss_area_role{pid = RolePid, rid = Rid, conn_pid = ConnPid}},
    State = #state{boss = #super_boss{npc_base_id = NpcBaseId, is_die = IsDie}, scene = #super_boss_scene{enter_point = {X, Y}}}) ->
    case IsDie of
        ?true ->
            notice:alert(error, ConnPid, ?MSGID(<<"该恶龙已被击杀">>));
        _ ->
            case get_available_area(State) of
                undefined ->
                    notice:alert(error, ConnPid, ?MSGID(<<"没有可进入的战斗区域">>));
                Area = #super_boss_area{map_id = MapId} ->
                    role:apply(async, RolePid, {fun async_enter_combat_area/4, [MapId, {X, Y}, self()]}),
                    AreaRole1 = AreaRole#super_boss_area_role{map_id = MapId},

                    %%更新区域
                    add_role_to_area(Area, AreaRole1),
                    ets:insert(super_boss_role, #super_boss_role{rid = Rid, boss_pid = self(), enter_time = util:unixtime()}),

                    %%持续时间定时器
                    erlang:send_after((?role_timer + 1) * 1000, self(), {role_timeout, Rid}),
                    %%暴击定时器
                    erlang:send_after((?role_timer - 30) * 1000, self(), {role_critical, Rid}),

                    sys_conn:pack_send(ConnPid, 12850, {NpcBaseId, ?role_timer, 0})
            end
    end,
    {noreply, State};

handle_info({exit_combat_area, Rid}, State = #state{scene = #super_boss_scene{exit_map_id = ExitMapId, exit_point = {X, Y}}}) ->
    exit_combat_area(Rid, ExitMapId, X, Y),
    {noreply, State};

handle_info({role_timeout, Rid}, State = #state{scene = #super_boss_scene{exit_map_id = ExitMapId, exit_point = {X, Y}}}) ->
    %%确保不是上次进入的定时器
    Now = util:unixtime(),
    case ets:lookup(super_boss_role, Rid) of
        [#super_boss_role{enter_time = EnterTime}] when Now > EnterTime + ?role_timer ->
            ?DEBUG("超时退出世界Bossid=~w", [Rid]),
            case role_api:lookup(by_id, Rid, [#role.combat_pid]) of
                {ok, _, [CombatPid]} when is_pid(CombatPid) ->
                    %%正在战斗要先结束战斗
                    CombatPid ! stop,
                    erlang:send_after(2000, self(), {role_timeout, Rid});
                _ -> 
                    exit_combat_area(Rid, ExitMapId, X, Y)
            end;
        _ ->
            ignore
    end,
    {noreply, State};

handle_info({role_critical, Rid}, State) ->
    %%确保不是上次进入的定时器
    Now = util:unixtime(),
    case ets:lookup(super_boss_role, Rid) of
        [SuperBossRole = #super_boss_role{enter_time = EnterTime}] when Now + 1 > EnterTime + (?role_timer - 30) ->
            ?DEBUG("世界Boss, 暴击角色id=~w", [Rid]),
            ets:insert(super_boss_role, SuperBossRole#super_boss_role{is_critical = true}),
            case role_api:lookup(by_id, Rid, [#role.pid, #role.combat_pid]) of
                {ok, _, [RolePid, CombatPid]} when is_pid(CombatPid) ->
                    ?DEBUG("世界Boss, 加动态Buff角色id=~w", [Rid]),
                    combat:add_dynamic_buff(CombatPid, RolePid, 100120, 50);
                _ -> 
                    ignore
            end;
        _ ->
            ignore
    end,
    {noreply, State};

handle_info({role_die, #fighter{rid = RoleId, srv_id = SrvId, name = _Name}}, State) ->
    case find_area_role({RoleId, SrvId}) of
        AreaRole = #super_boss_area_role{} ->
            update_area_role(AreaRole#super_boss_area_role{dead_time = util:unixtime()});
        _ ->
            ignore
    end,
    {noreply, State};

handle_info({super_boss_info, ConnPid}, State) ->
    #super_boss_info{npc_base_id = NpcBaseId, invaid_map_id = InvaidMapId, kill_count = KillCount} = get(info),

    LastName = case get(last_name) of
        undefined ->
            <<>>;
        _LastName ->
            _LastName
    end,

    #super_boss_rank{name = Name, lev = Lev, career = Career, best_dmg = BestDmg, sex = Sex, looks = Looks} = get(best_rank),
    RecentList = get(recent_list),

    KillCount2 = util:floor(math:pow(KillCount, ?kill_count_index) * ?kill_count_factor),
    sys_conn:pack_send(ConnPid, 12866, {NpcBaseId, InvaidMapId, KillCount2, LastName, Name, Lev, Career, Sex, BestDmg, Looks, RecentList}),
    {noreply, State};

handle_info({revive, Type, #role{id = Rid, pid = Pid, link = #link{conn_pid = ConnPid}, assets = #assets{gold = Gold}}},
    State = #state{scene = #super_boss_scene{enter_point = {X, Y}}}) ->
    case find_area_role(Rid) of
        AreaRole = #super_boss_area_role{map_id = MapId, dead_time = DeadTime} when DeadTime =/= 0 ->
            case Type of
                0 -> %% 倒计时
                    TimeLeft = DeadTime + ?revive_wait_time - 1 - util:unixtime(),
                    case TimeLeft =< 0 of
                        true ->
                            role:apply(async, Pid, {fun async_revive_and_return/4, [MapId, X, Y]}),
                            update_area_role(AreaRole#super_boss_area_role{dead_time = 0});
                        false ->
                            sys_conn:pack_send(ConnPid, 12863, {?false}),
                            notice:alert(error, ConnPid, ?MSGID(<<"时间未到，不能提前复活">>))
                    end;
                1 -> %% 花晶钻提前复活
                    case Gold >= ?revive_cost of
                        false ->
                            notice:alert(error, ConnPid, ?MSGID(<<"晶钻不足">>));
                        true ->
                            role:apply(async, Pid, {fun async_revive/1, []}),
                            update_area_role(AreaRole#super_boss_area_role{dead_time = 0})
                    end
            end;
        _ ->
            ignore
    end,
    {noreply, State};

%% 登录
handle_info({login, Rid, Pid, ConnPid, EnterTime, Reward}, State = #state{boss = #super_boss{npc_base_id = NpcBaseId}}) ->
    case find_area_role(Rid) of
        AreaRole  = #super_boss_area_role{dead_time = DeadTime} ->
            AreaRole1 = AreaRole#super_boss_area_role{pid = Pid, conn_pid = ConnPid},
            update_area_role(AreaRole1),

            LeftTime = EnterTime + ?role_timer - util:unixtime(),
            sys_conn:pack_send(ConnPid, 12850, {NpcBaseId, LeftTime, Reward}),

            TimeLeft = DeadTime + ?revive_wait_time - 1 - util:unixtime(),
            case TimeLeft > 0 of
                true ->
                    %%推送复活界面
                    sys_conn:pack_send(ConnPid, 12853, {TimeLeft + 1});
                _ ->
                    ignore
            end,
            erlang:send_after(2000, self(), {notify_status, ConnPid});
        _ ->
            ignore
    end,
    {noreply, State};

handle_info(timeout, State = #state{boss = #super_boss{is_die = IsDie}}) ->
    case IsDie of
        ?true ->
            ignore;
        ?false ->
            force_combat_over()
    end,
    erlang:send_after(300, self(), {clear, 1}),
    {noreply, State};

handle_info({clear, Times}, State = #state{boss = #super_boss{npc_base_id = NpcBaseId, is_die = IsDie}}) ->
    case Times >= 7 of
        true ->
            ?ERR("世界Boss[~w]无法清理所有战区", [NpcBaseId]),
            force_exit_combat_area(),
            update_boss_info(),
            clear_and_stop(NpcBaseId);
        false ->
            case IsDie of
                ?true ->
                    case get(clear_die) of
                        true ->
                            clear_and_stop(NpcBaseId);
                        _ ->
                            erlang:send_after(1000, self(), {clear, Times + 1})
                    end;
                ?false ->
                    case clear_area() of
                        true ->
                            update_boss_info(),
                            clear_and_stop(NpcBaseId);
                        false ->
                            erlang:send_after(1000, self(), {clear, Times + 1})
                    end
            end
    end,
    {noreply, State};

%%世界Boss死亡时要清理地图和更新最强先锋
handle_info({boss_die, Times}, State = #state{boss = #super_boss{npc_base_id = NpcBaseId}}) ->
    case clear_area() of
        true ->
            boss_die(NpcBaseId);
        false ->
            case Times >= 8 of
                true ->
                    force_exit_combat_area(),
                    boss_die(NpcBaseId);
                false ->
                    erlang:send_after(500, self(), {boss_die, Times + 1})
            end
    end,
    {noreply, State};

handle_info(gm_kill_boss, State = #state{boss = SuperBoss = #super_boss{npc_base_id = NpcBaseId, hp_max = HpMax},
        scene = #super_boss_scene{exit_map_id = ExitMapId}}) ->
    ets:insert(super_boss_status, {NpcBaseId, 0, HpMax, ExitMapId}), 

    SuperBoss2 = SuperBoss#super_boss{hp = 0, is_die = ?true},
    put(last_name, <<"gm_kill_boss">>),
    %% 强迫所有未结束的战斗结束
    force_combat_over(),

    %%立即广播Boss状态
    cast_status(0, HpMax),

    super_boss_mgr:boss_die(),
    erlang:send_after(500, self(), {boss_die, 1}),
    {noreply, State#state{boss = SuperBoss2}};

handle_info(stop, State) ->
    {stop, normal, State};

handle_info(_Info, State) ->
    ?DEBUG("收到无效消息:~w", [_Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%------------------------------------------------------
%% 内部实现
%%------------------------------------------------------
%% 增加一个战斗区域
add_area(Area) ->
    case get(combat_area) of
        undefined -> 
            put(combat_area, [Area]);
        L -> 
            put(combat_area, [Area | L])
    end.

%% 创建战斗区域 -> #super_boss_area{} | undefined
create_area(#state{boss = #super_boss{npc_base_id = NpcBaseId}, scene = #super_boss_scene{map_id = MapBaseId, pos = {X, Y}}}) ->
    case map_mgr:create(MapBaseId) of
        {false, Reason} ->
            ?ERR("创建世界boss战斗区域地图[MapBaseId=~w]失败: ~s", [MapBaseId, Reason]),
            undefined;
        {ok, MapPid, MapId} ->
            %% 创建地图上的NPC
            {ok, NpcBase} = npc_data:get(NpcBaseId),
            case npc_mgr:create(NpcBase, MapId, X, Y) of
                {ok, _NpcId} -> 
                    NewArea = #super_boss_area{map_id = MapId, map_pid = MapPid, role_num = 0},
                    add_area(NewArea),
                    ?DEBUG("创建世界boss战斗区域成功，NPC[NpcBaseId=~w]进入地图", [NpcBaseId]),
                    NewArea;
                _Err ->
                    ?ELOG("创建世界boss战斗区域出错，无法建立地图NPC[NpcBaseId:~w, Reason:~w]", [NpcBaseId, _Err]),
                    undefined
            end
    end.

%% 获取当前可用的战斗区域
get_available_area(State) ->
    get_available_area(get(combat_area), State).
get_available_area([], State) ->
    create_area(State);
get_available_area([Area = #super_boss_area{role_num = RoleNum} | T], State) ->
    case RoleNum < ?AREA_ROLE_MAX of
        true -> 
            Area;
        false -> 
            get_available_area(T, State)
    end.

%% 查找战斗区域
find_area(MapId) ->
    case get(combat_area) of
        L = [_|_] ->
            case lists:keyfind(MapId, #super_boss_area.map_id, L) of
                false -> 
                    undefined;
                Area -> 
                    {Area, L}
            end;
        _ -> 
            undefined
    end.

remove_area(MapId) ->
    case get(combat_area) of
        L = [_|_] ->
            L2 = lists:keydelete(MapId, #super_boss_area.map_id, L),
            put(combat_area, L2);
        _ -> 
            ignore
    end.

async_enter_combat_area(Role = #role{id = Rid, name = _Name, link = #link{conn_pid = ConnPid}, pos = #pos{map = LastMapId, x = LastX, y = LastY}}, MapId, {NewX, NewY}, SuperBossPid) ->
    Role1 = Role#role{event = ?event_super_boss, event_pid = SuperBossPid},
    Role2 = case map:role_enter(MapId, NewX, NewY, Role1) of
        {ok, NewRole = #role{pos = NewPos}} -> 
            ?DEBUG("[~s]进入战斗区域成功", [_Name]),
            case is_pid(SuperBossPid) of
                true -> erlang:send_after(10, SuperBossPid, {notify_status, ConnPid});
                false -> ignore
            end,
            NewRole#role{pos = NewPos#pos{last = {LastMapId, LastX, LastY}}};
        {false, _Why} -> 
            ?ERR("[~s]进入战斗区域失败:~s", [_Name, _Why]),
            SuperBossPid ! {enter_failed, Rid},
            Role
    end,
    {ok, Role2}.

%% 查找战斗区域玩家 -> #super_boss_area_role{} | undefined
find_area_role(Rid) ->
    case get(combat_area) of
        L = [_|_] -> 
            find_area_role(Rid, L);
        _ -> 
            undefined
    end.
find_area_role(_Rid, []) ->
    undefined;
find_area_role(Rid, [#super_boss_area{roles = Roles} | T]) ->
    case lists:keyfind(Rid, #super_boss_area_role.rid, Roles) of
        false -> 
            find_area_role(Rid, T);
        AreaRole = #super_boss_area_role{} -> 
            AreaRole
    end.

add_role_to_area(Area = #super_boss_area{map_id = MapId, role_num = RoleNum, roles = Roles}, 
    AreaRole = #super_boss_area_role{rid = Rid}) ->
    L = get(combat_area),
    %%这里RoleNum和Roles可能存在不同步
    Roles2 = [AreaRole | lists:keydelete(Rid, #super_boss_area_role.rid, Roles)],
    Areas2 = lists:keyreplace(MapId, #super_boss_area.map_id, L,
        Area#super_boss_area{role_num = RoleNum + 1, roles = Roles2}),
    put(combat_area, Areas2).

%% 更新区域角色
update_area_role(AreaRole = #super_boss_area_role{rid = Rid, map_id = MapId}) ->
    case find_area(MapId) of
        undefined -> 
            ignore;
        {Area = #super_boss_area{roles = Roles}, Areas} ->
            Roles2 = lists:keyreplace(Rid, #super_boss_area_role.rid, Roles, AreaRole),
            Areas2 = lists:keyreplace(MapId, #super_boss_area.map_id, Areas,
                Area#super_boss_area{roles = Roles2}),
            put(combat_area, Areas2)
    end.

%% 把角色从区域中去掉
remove_role_from_area(#super_boss_area_role{rid = Rid, map_id = MapId}) ->
    case find_area(MapId) of
        undefined -> 
            ignore;
        {Area = #super_boss_area{role_num = RoleNum, roles = Roles}, Areas} ->
            Roles2 = lists:keydelete(Rid, #super_boss_area_role.rid, Roles),
            Areas2 = lists:keyreplace(MapId, #super_boss_area.map_id, Areas,
                Area#super_boss_area{role_num = RoleNum - 1, roles = Roles2}),
            put(combat_area, Areas2)
    end.

exit_combat_area(Rid, ExitMapId, ExitX, ExitY) ->
    case ets:lookup(super_boss_role, Rid) of
        [] ->
            ok;
        [#super_boss_role{reward = Reward, total_dmg = TotalDmg}] ->
            case find_area_role(Rid) of
                AreaRole = #super_boss_area_role{pid = Pid, lev = Lev} ->
                    case is_pid(Pid) andalso erlang:is_process_alive(Pid) of
                        true ->
                            role:apply(async, Pid, {fun async_exit_combat_area/5, [ExitMapId, ExitX, ExitY, Reward]});
                        _ ->
                            %%金币，经验
                            {Coin, Exp} = get_coin_and_exp(Reward, Lev),
                            Gains = get_gains(Reward, Exp, Coin),
                            award:send(Rid, ?offline_award_id, Gains)
                    end,
                    save_rank(AreaRole, TotalDmg),
                    add_reward(Reward),
                    %%清除ETS,更新area信息
                    ets:delete(super_boss_role, Rid),
                    remove_role_from_area(AreaRole);
                _ ->
                    ignore
            end
    end.

%% 强迫战斗结束
force_combat_over() ->
    lists:foreach(fun(#super_boss_area{roles = Roles}) ->
                lists:foreach(fun(#super_boss_area_role{rid = Rid, pid = RolePid}) -> 
                            case role_api:lookup(by_pid, RolePid, [#role.combat_pid]) of
                                {ok, _, [CombatPid]} when is_pid(CombatPid) ->
                                    CombatPid ! stop;
                                %%包括在场景不战斗或掉线情况
                                _ -> 
                                    erlang:send_after(200, self(), {exit_combat_area, Rid})
                            end
                    end, Roles)
        end, get(combat_area)).

cast_status(Hp, HpMax) ->
    lists:foreach(fun(#super_boss_area{roles = Roles}) ->
                lists:foreach(fun(#super_boss_area_role{conn_pid = ConnPid}) ->
                            sys_conn:pack_send(ConnPid, 12862, {Hp, HpMax})
                    end, Roles)
        end, get(combat_area)).

clear_area() ->
    Areas = get(combat_area),
    lists:foreach(fun(#super_boss_area{map_id = MapId, map_pid = MapPid, role_num = RoleNum, roles = Roles}) ->
                case RoleNum =:= 0 of
                    true ->
                        remove_area(MapId),
                        MapPid ! stop;
                    false ->
                        lists:foreach(fun(#super_boss_area_role{rid = Rid, pid = RolePid}) -> 
                                    case role_api:lookup(by_pid, RolePid, [#role.combat_pid]) of
                                        {ok, _, [CombatPid]} when CombatPid =/= 0 ->
                                            ignore;
                                        _ -> 
                                            self() ! {exit_combat_area, Rid}
                                    end
                            end, Roles)
                end
        end, Areas),
    case get(combat_area) of
        [_|_] ->
            false;
        _ -> 
            true
    end.

%%强制退出场景
force_exit_combat_area() ->
    lists:foreach(fun(#super_boss_area{roles = Roles}) ->
                lists:foreach(fun(#super_boss_area_role{rid = Rid}) -> 
                            self() ! {exit_combat_area, Rid}
                    end, Roles)
        end, get(combat_area)).

boss_die(NpcBaseId) ->
    update_boss_info(),
    %%传闻
    #super_boss_rank{name = BestName} = get(best_rank),
    LastName = get(last_name),
    #super_boss_info{best_rid = BestRid, last_rid = LastRid} = get(info),
    Msg = util:fbin(?super_boss_die, [notice:get_role_msg(BestName, BestRid), notice:get_npc_msg(NpcBaseId), notice:get_role_msg(LastName, LastRid)]),
    role_group:pack_cast(world, 10932, {7, 1, Msg}),
    put(clear_die, true).


%% 角色复活并退出战斗区域
async_exit_combat_area(Role = #role{id = Rid, name = _Name, lev = Lev, link = #link{conn_pid = ConnPid},
        status = Status}, _ExitMapId, ExitX, ExitY, Reward) ->
    Role1 = case map:role_enter(?exit_map_id, ExitX, ExitY, Role) of
        {ok, _Role} -> 
            _Role;
        {false, _Why} ->
            ?ERR("[~s]退出战斗区域失败[Reason:~w]", [_Name, _Why]),
            Role
    end,
    Role2 = Role1#role{event = ?event_no, event_pid = 0},

    Role3 = case Status of
        ?status_die ->
            role_api:revive(Role2);
        _ ->
            Role2#role{status = ?status_normal}
    end,

    %%金币，经验
    {Coin, Exp} = get_coin_and_exp(Reward, Lev),
    sys_conn:pack_send(ConnPid, 12851, {Reward, Exp, Coin}),

    Gains = get_gains(Reward, Exp, Coin),
    case role_gain:do(Gains, Role3) of
        {ok, Role4} ->
            {ok, Role4};
        _ ->
            award:send(Rid, ?offline_award_id, Gains),
            {ok, Role3}
    end.

get_coin_and_exp(Reward, Lev) ->
    Coin = util:ceil(Reward * ?coin_factor),
    Exp = case super_boss_data:exp(Lev) of
        undefined ->
            0;
        _Exp ->
            _Exp
    end,
    {Coin, Exp}.

get_gains(Reward, Exp, Coin) ->
    Gains = case Exp =:= 0 of
        true ->
            [];
        false ->
            [#gain{label = exp, val = Exp}]
    end,
    Gains2 = case Coin =:= 0 of
        true ->
            Gains;
        false ->
            [#gain{label = coin, val = Coin} | Gains]
    end,
    case Reward =:= 0 of
        true ->
            Gains2;
        false ->
            [#gain{label = scale, val = Reward} | Gains2]
    end.
    
%% 保存排行榜数据
save_rank(#super_boss_area_role{rid = Rid, name = Name, sex = Sex, career = Career, lev = Lev,
        guild_name = GuildName, looks = Looks, eqm = Eqm}, DmgHpTotal) ->
    #super_boss_info{summary_id = SummaryId} = get(info),
    Rank = #super_boss_rank{summary_id = SummaryId, rid = Rid, name = Name, sex = Sex, guild_name = GuildName,
        looks = Looks, eqm = Eqm, career = Career, lev = Lev, best_dmg = DmgHpTotal, total_dmg = DmgHpTotal},
    save_rank_to_dict(Rank).

%% 记录对当前开放的超级世界boss的伤害
save_rank_to_dict(Rank) -> 
    NewRanks = case get(ranks) of
        undefined -> 
            save_rank_to_dict(Rank, []);
        L -> 
            save_rank_to_dict(Rank, L)
    end,
    put(ranks, NewRanks),
    NewRanks.
save_rank_to_dict(Rank = #super_boss_rank{rid = Rid, best_dmg = BestDmg, total_dmg = TotalDmg}, OldRanks) ->
    case lists:keyfind(Rid, #super_boss_rank.rid, OldRanks) of
        #super_boss_rank{total_dmg = OldTotalDmg, best_dmg = OldBestDmg} ->
            NewTotalDmg = OldTotalDmg + TotalDmg,
            BestDmg2 = erlang:max(BestDmg, OldBestDmg),
            lists:keyreplace(Rid, #super_boss_rank.rid, OldRanks,
                Rank#super_boss_rank{total_dmg = NewTotalDmg, best_dmg = BestDmg2});
        false ->
            [Rank | OldRanks]
    end.

%% 更新最强先锋、最近加入战斗角色
update_boss_info() ->
    Ranks = get(ranks),
    %%最近加入战斗角色
    Ranks2 = lists:sublist(Ranks, ?recent_num),
    RecentList = [RecentName || #super_boss_rank{name = RecentName} <- Ranks2],
    put(recent_list, RecentList),

    %%最强先锋
    BestRank = #super_boss_rank{rid = Rid, name = Name, best_dmg = BestDmg} = get_best_rank(Ranks, #super_boss_rank{best_dmg = 0}),
    SuperBossInfo = #super_boss_info{best_rid = LastBestRid, npc_base_id = NpcBaseId} = get(info),

    case Rid of
        {0, _} ->
            ignore;
        _ ->
            #super_boss_rank{name = LastBestName} = get(best_rank),
            case LastBestRid of
                {0, _} ->
                    ignore;
                _ ->
                    case LastBestRid =/= Rid of
                        true ->
                            %%传闻
                            rank_celebrity:listener(dragon_boss_hit, Rid, BestDmg),
                            Msg = util:fbin(?super_boss_best, [notice:get_role_msg(Name, Rid), notice:get_role_msg(LastBestName, LastBestRid),
                                    notice:get_npc_msg(NpcBaseId)]),
                            role_group:pack_cast(world, 10932, {7, 1, Msg});
                        false ->
                            ignore
                    end
            end,
            put(best_rank, BestRank),
            put(info, SuperBossInfo#super_boss_info{best_rid = Rid})
    end.
    
get_best_rank([], BestRank) ->
    BestRank;
get_best_rank([Rank = #super_boss_rank{best_dmg = BestDmg} | T], BestRank = #super_boss_rank{best_dmg = OldBestDmg}) ->
    case BestDmg > OldBestDmg of
        true ->
            get_best_rank(T, Rank);
        false ->
            get_best_rank(T, BestRank)
    end.

%%---------------------------------------------------
%% 复活相关
%%---------------------------------------------------
%% 普通复活
async_revive_and_return(Role = #role{link = #link{conn_pid = ConnPid}}, MapId, X, Y) ->
    NewX = util:rand(X - 50, X + 50),
    NewY = util:rand(Y - 50, Y + 50),
    Role2 = case map:role_enter(MapId, NewX, NewY, Role) of
        {ok, Role1} ->
            Role1;
        {false, _Why} ->
            Role
    end,
    
    Role3 = role_api:revive(Role2),
    sys_conn:pack_send(ConnPid, 12863, {?true}),
    {ok, Role3}.

%% 花费晶钻复活
async_revive(Role = #role{assets = Assets = #assets{gold = Gold}, link = #link{conn_pid = ConnPid}}) ->
    Role2 = role_api:revive(Role),
    Role3 = role_api:push_assets(Role2, Role2#role{assets = Assets#assets{gold = Gold - ?revive_cost}}),
    sys_conn:pack_send(ConnPid, 12863, {?true}),
    {ok, Role3}.

get_common_odds(RollCount) ->
    CommonOdds = 1 / (1 + 2 * ?critical_odds) * ?drop_factor * (math:pow(RollCount, ?drop_index)
        - math:pow(RollCount - 1, ?drop_index)),
    util:floor(CommonOdds * 100000).

get_drop(Value, RollCount) ->
    get_drop(Value, RollCount, 0).
get_drop(Value, _, Return) when Value < ?unit_dmg ->
    Return;
get_drop(Value, RollCount, Return) ->
    CommonOdds = get_common_odds(RollCount),
    RandValue = util:rand(1, 100000),
    Drop = case RandValue =< CommonOdds of
        true ->
            RandValue2 = util:rand(1, 100000),
            CriticalOdds = util:floor(?critical_odds * 100000),
            case RandValue2 =< CriticalOdds of
                true ->
                    ?critical_drop;
                false ->
                    ?common_drop
            end;
        false ->
            0
    end,
    %%?DEBUG("龙鳞计算value=[~w], drop = [~w], common=[~w], RollCount=[~w]", [Value, Drop, CommonOdds, RollCount]),
    Value2 = Value - ?unit_dmg,
    get_drop(Value2, RollCount + 1, Return + Drop).

add_reward(Reward) ->
    case get(reward) of
        undefined ->
            put(reward, Reward);
        Sum ->
            put(reward, Sum + Reward)
    end.

clear_and_stop(NpcBaseId) ->
    #super_boss_info{kill_count = KillCount, last_rid = {LastRid, LastSrvid}, best_rid = {BestRid, BestSrvid}} = get(info),

    LastName = case get(last_name) of
        undefined ->
            <<>>;
        _LastName ->
            _LastName
    end,

    #super_boss_rank{name = BestName} = get(best_rank),

    log:log(log_super_boss, {<<"世界Boss最后一击">>, LastRid, LastSrvid, LastName, NpcBaseId}),
    log:log(log_super_boss, {<<"世界Boss最强先锋">>, BestRid, BestSrvid, BestName, NpcBaseId}),

    Ranks = get(ranks),
    Reward = get(reward),

    super_boss_mgr:send_info(NpcBaseId, KillCount, Reward, Ranks),

    SuperBossInfo = get(info),
    super_boss_dao:save_info(SuperBossInfo),

    self() ! stop.




