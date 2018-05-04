%%----------------------------------------------------
%% 处理不同类型的战斗
%% @author yankai@jieyou.cn
%%----------------------------------------------------
-module(combat_type).
-export([
        check/2
        ,check/3
        ,combat_start_limit/3
        ,enter_combat_failed/3
        ,combat_over/1
        ,combat_over_leave/1
        ,is_limited_skill/2
        ,calc_combat_max_round/1
        ,calc_combat_round_time/3
        ,stop_combat/1
        ,reset_special_npc_killed_count/1
        ,check_combat_round_result/3
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("team.hrl").
-include("link.hrl").
-include("npc.hrl").
-include("pos.hrl").
-include("gain.hrl").
-include("storage.hrl").
-include("drop.hrl").
-include("item.hrl").
-include("assets.hrl").
%%  
-include("arena.hrl").
-include("world_compete.hrl").
-include("boss.hrl").
-include("mail.hrl").
-include("dungeon.hrl").
-include("train.hrl").
-include("misc.hrl").
-include("pet.hrl").
-include("demon.hrl").

%% 角色更新数据
-record(role_update_data, {
        fighter = #fighter{},   %% 参战者
        skill_history = [],     %% 技能使用记录
        hit_history = [],       %% 命中与被命中记录
        item_use_history = [],  %% 物品使用记录
        caught_pets = [],       %% 抓取到的宠物
        pet_killed = [],        %% 战斗中被杀死的宠物
        role_killed = [],       %% 战斗中被杀死的角色
        is_winner = true,       %% 是否胜利者
        combat_type = 0,        %% 战斗类型
        is_fighting_super_boss = 0  %% 是否在挑战超级世界boss
    }).

%% @spec check(Attacker, Defender) -> true | {false, Reason}
%% CombatType = atom() 指定战斗类型，如果不指定，则填undefined
%% Attacker = #role{}
%% Defender = #role{}
%% Reason = bitstring()
%% @doc 角色发起战斗处理(只处理角色对角色的情况，角色对NPC或NPC对角色的战斗由npc.erl处理)
%% <div>战斗的类型由防守方当前的活动类型(#role.event)决定</div>
%% <div>切磋战斗由combat_rpc.erl特殊处理</div>

check(Attacker, Defender) ->
    check(undefined, Attacker, Defender).

%% 过滤无法发起战斗的情况
check(_CombatType, _Attacker, #role{combat_pid = CombatPid}) when is_pid(CombatPid) ->
    {false, ?MSGID(<<"对方正在战斗中">>)};
check(_CombatType, _Attacker, #role{hp = Hp}) when Hp < 1 ->
    {false, ?MSGID(<<"对方已经死亡，无法发起战斗">>)};
check(_CombatType, _Attacker, #role{status = Status}) when Status =:= ?status_die ->
    {false,  ?MSGID(<<"对方已经死亡，无法发起战斗">>)};
check(_CombatType, _Attacker, #role{event = Event}) when Event =:= ?event_hall ->
    {false, ?MSGID(<<"在大厅中，就不要打打杀杀的嘛！">>)};
check(CombatType, #role{event = Event}, _) when CombatType=/= ?combat_type_c_world_compete andalso (Event =:= ?event_c_world_compete_11 orelse Event =:= ?event_c_world_compete_22 orelse Event =:= ?event_c_world_compete_33) ->
    {false, ?MSGID(<<"报名参加了仙道会，不能发起其他战斗">>)};
check(_CombatType, #role{event = Event1}, #role{event = Event2}) when Event1 =:= ?event_pk_duel orelse Event2 =:= ?event_pk_duel ->
    {false, ?MSGID(<<"参加跨服决斗中，不能发起其他战斗">>)};
check(_CombatType, _Attacker, #role{status = Status}) when Status =/= ?status_normal ->
    {false, ?MSGID(<<"目前无法对其发起战斗">>)};
check(_CombatType, #role{pos = #pos{map_pid = AtkMapPid}}, #role{pos = #pos{map_pid = DfdMapPid}}) when AtkMapPid =/= DfdMapPid ->
    {false, ?MSGID(<<"不能发起战斗，目标不在同一场景">>)};

%% 切磋
check(?combat_type_challenge, Attacker = #role{cross_srv_id = <<"center">>}, Defender) ->
    ?ARENA_CALL(combat, start, [?combat_type_challenge, role_api:fighter_group(Attacker), role_api:fighter_group(Defender)]),
    true;
check(?combat_type_challenge, Attacker, Defender) ->
    combat:start(?combat_type_challenge, role_api:fighter_group(Attacker), role_api:fighter_group(Defender)),
    %% 测试录像：
    %% combat:start(?combat_type_challenge, 0, role_api:fighter_group(Attacker), role_api:fighter_group(Defender), [{replay_id, 1}]),
    true;

%% 野外刺杀
check(undefined, Attacker, Defender = #role{event = ?event_no}) ->
    combat:start(?combat_type_kill, role_api:fighter_group(Attacker), role_api:fighter_group(Defender));
    
%% 抢劫跑商的角色
check(undefined, Attacker, Defender = #role{event = ?event_trade}) ->
    case is_combat_protect_over(Defender) of
        true ->
            combat:start(?combat_type_rob_trade, role_api:fighter_group(Attacker), role_api:fighter_group(Defender)),
            true;
        false -> {false, ?MSGID(<<"对方处于保护状态，暂时不能发起战斗">>)}
    end;

%% 抢劫运镖的角色
check(undefined, _Attacker = #role{team_pid = TeamPid}, _Defender = #role{event = ?event_escort}) when is_pid(TeamPid) -> {false, ?L(<<"组队状态不可以打劫">>)};
check(undefined, Attacker, Defender = #role{event = ?event_escort}) ->
    case is_combat_protect_over(Defender) of
        true ->
            case escort:check_combat_start(Attacker, Defender) of
                ok ->
                    escort:combat_start(Attacker, Defender),
                    true;
                {false, Reason} -> {false, Reason}
            end;
        false -> {false, ?MSGID(<<"对方处于保护状态，暂时不能发起战斗">>)}
    end;

%% 抢劫小屁孩的角色
check(undefined, _Attacker = #role{event = ?event_escort_child}, _Defender) -> {false, ?L(<<"你正在护送美女中，就不要多事了嘛！">>)};
check(undefined, _Attacker = #role{team_pid = TeamPid}, _Defender = #role{event = ?event_escort_child}) when is_pid(TeamPid) -> {false, ?L(<<"组队状态不可以打劫">>)};
check(undefined, Attacker, Defender = #role{event = ?event_escort_child}) ->
    case is_combat_protect_over(Defender) of
        true ->
            case escort_child:check_combat_start(Attacker, Defender) of
                ok ->
                    escort_child:combat_start(Attacker, Defender),
                    true;
                {false, Reason} -> 
                    {false, Reason}
            end;
        false -> 
            {false, ?MSGID(<<"对方处于保护状态，暂时不能发起战斗">>)}
    end;

%% 抢劫重阳节护送美女登高的角色
check(undefined, _Attacker = #role{event = ?event_escort_cyj}, _Defender) -> {false, ?L(<<"你正在护送美女中，就不要多事了嘛！">>)};
check(undefined, _Attacker = #role{team_pid = TeamPid}, _Defender = #role{event = ?event_escort_cyj}) when is_pid(TeamPid) -> {false, ?L(<<"组队状态不可以打劫">>)};
check(undefined, Attacker, Defender = #role{event = ?event_escort_cyj}) ->
    case is_combat_protect_over(Defender) of
        true ->
            case escort_cyj:check_combat_start(Attacker, Defender) of
                ok ->
                    escort_cyj:combat_start(Attacker, Defender),
                    true;
                {false, Reason} -> 
                    {false, Reason}
            end;
        false -> 
            {false, ?MSGID(<<"对方处于保护状态，暂时不能发起战斗">>)}
    end;

%% 单人竞技场战斗(无视组队，只会取单人加入战场)
check(undefined, Attacker = #role{id = AtkId}, Defender = #role{id = DfdId, event = ?event_arena_match, event_pid = EventPid, cross_srv_id = <<"center">>}) ->
    case arena_center:check(combat_start, EventPid, AtkId, DfdId) of
        {false, Reason} -> 
            {false, Reason};
        true ->
            case role_convert:do(to_fighter, Attacker) of
                {ok, A} ->
                    case role_convert:do(to_fighter, Defender) of
                        {ok, D} ->
                            ?ARENA_CALL(combat, start, [?combat_type_arena, EventPid, [A], [D]]),
                            true;
                        _ ->
                            {false, ?MSGID(<<"发起战斗失败">>)}
                    end;
                _ ->
                    {false, ?MSGID(<<"发起战斗失败">>)}
            end
    end;
check(undefined, Attacker = #role{id = AtkId}, Defender = #role{id = DfdId, event = ?event_arena_match, event_pid = EventPid}) ->
    case arena:check(combat_start, EventPid, AtkId, DfdId) of
        {false, Reason} -> 
            {false, Reason};
        true ->
            case role_convert:do(to_fighter, Attacker) of
                {ok, A} ->
                    case role_convert:do(to_fighter, Defender) of
                        {ok, D} ->
                            combat:start(?combat_type_arena, EventPid, [A], [D]),
                            true;
                        _ ->
                            {false,?MSGID(<<"发起战斗失败">>)}
                    end;
                _ ->
                    {false, ?MSGID(<<"发起战斗失败">>)}
            end
    end;

%% 巅峰对决
check(undefined, Attacker = #role{id = AtkId}, Defender = #role{id = DfdId, event = ?event_top_fight_match, event_pid = EventPid, cross_srv_id = <<"center">>}) ->
    case top_fight_center:check(combat_start, EventPid, AtkId, DfdId) of
        {false, Reason} -> 
            {false, Reason};
        true ->
            case role_convert:do(to_fighter, Attacker) of
                {ok, A} ->
                    case role_convert:do(to_fighter, Defender) of
                        {ok, D} ->
                            ?ARENA_CALL(combat, start, [?combat_type_top_fight, EventPid, [A], [D]]),
                            true;
                        _ ->
                            {false, ?MSGID(<<"发起战斗失败">>)}
                    end;
                _ ->
                    {false, ?MSGID(<<"发起战斗失败">>)}
            end
    end;

%% 帮战
check(undefined, Attacker, Defender = #role{event = ?event_guild_war, event_pid = EventPid}) ->
    case guild_war:combat(combat_check, {EventPid, Attacker, Defender}) of
        {false, Reason} -> 
            {false, Reason};
        {ok} ->
            AtkRoles = role_api:fighter_group(Attacker),
            DfdRoles = role_api:fighter_group(Defender),
            guild_war:combat(combat_start, {EventPid, [{Rid, SrvId} || #converted_fighter{fighter = #fighter{rid = Rid, srv_id = SrvId}} <- AtkRoles ++ DfdRoles]}),
            case combat:start(?combat_type_guild_war, EventPid, AtkRoles, DfdRoles) of
                {ok, _CombatPid} -> true;
                _Err -> 
                    ?ERR("发起帮战战斗失败:~w", [_Err]),
                    {false,?MSGID(<<"发起战斗失败">>)}
            end
    end;

%% 帮战主将赛
check(?combat_type_guild_war_compete, EventPid, {Attacker, Defender}) ->
    AtkRoles = role_api:fighter_group(Attacker),
    DfdRoles = role_api:fighter_group(Defender),
    case combat:start(?combat_type_guild_war_compete, EventPid, AtkRoles, DfdRoles) of
        {ok, _CombatPid} -> true;
        _Err -> 
            ?ERR("发起帮战战斗失败:~w", [_Err]),
            {false, ?MSGID(<<"发起战斗失败">>)}
    end;

%% 新帮战
check(undefined, Attacker, Defender = #role{event = ?event_guild_arena, event_pid = EventPid, cross_srv_id = <<"center">>}) ->
    case guild_arena:combat_check(Attacker, Defender) of
        {false, Reason} -> 
            {false, Reason};
        {ok} ->
            AtkRoles = role_api:fighter_group(Attacker),
            DfdRoles = role_api:fighter_group(Defender),
            guild_arena:combat_start(EventPid, [{Rid, SrvId} || #converted_fighter{fighter = #fighter{rid = Rid, srv_id = SrvId}} <- AtkRoles ++ DfdRoles]),
            Referees = [{guild_arena_pid, EventPid}],
            case ?ARENA_CALL(combat, start, [?combat_type_guild_arena, Referees, AtkRoles, DfdRoles]) of
                {ok, _CombatPid} -> true;
                _Err -> 
                    ?ERR("发起帮战战斗失败:~w", [_Err]),
                    {false, ?L(<<"发起战斗失败">>)}
            end
    end;
check(undefined, Attacker, Defender = #role{event = ?event_guild_arena, event_pid = EventPid}) ->
    case guild_arena:combat_check(Attacker, Defender) of
        {false, Reason} -> 
            {false, Reason};
        {ok} ->
            AtkRoles = role_api:fighter_group(Attacker),
            DfdRoles = role_api:fighter_group(Defender),
            guild_arena:combat_start([{Rid, SrvId} || #converted_fighter{fighter = #fighter{rid = Rid, srv_id = SrvId}} <- AtkRoles ++ DfdRoles]),
            case combat:start(?combat_type_guild_arena, EventPid, AtkRoles, DfdRoles) of
                {ok, _CombatPid} -> true;
                _Err -> 
                    ?ERR("发起帮战战斗失败:~w", [_Err]),
                    {false, ?L(<<"发起战斗失败">>)}
            end
    end;

%% 帮会副本 
check(?combat_type_npc, #role{event = ?event_guild_td, event_pid = EventPid}, Defender) when is_record(Defender, npc) andalso is_pid(EventPid) ->
    {true, ?combat_type_guild_td};

%% 竞技场 
check(?combat_type_npc, #role{id = {RoleId, SrvId}, event = ?event_arena_match, event_pid = ArenaPid}, #npc{base_id = NpcBaseId}) ->
    case arena:check(combat_start_robot, ArenaPid, {RoleId, SrvId}, NpcBaseId) of
        true -> {true, ?combat_type_arena_robot, [{ref_arena_robot, ArenaPid}]};
        {false, Reason} -> {false, Reason}
    end;

%% 帮战杀机器人
check(?combat_type_npc, #role{id = Rid, event = ?event_guild_war, event_pid = WarPid}, #npc{fun_type = FunType}) ->
    case FunType =:= ?npc_fun_type_guild_war_white orelse FunType =:= ?npc_fun_type_guild_war_red of
        true ->
            case guild_war:combat(combat_robot_check, {WarPid, Rid, FunType}) of
                {ok} ->
                    {true, ?combat_type_guild_war_robot, [{ref_guild_war, WarPid}]};
                {false, Reason} ->
                    {false, Reason}
            end;
        false ->
            {false, <<"">>}
    end;

%% 新帮战机器人
check(?combat_type_npc, Attacker = #role{event = ?event_guild_arena, cross_srv_id = <<"center">>, event_pid = EventPid}, #npc{base_id = NpcBaseId}) ->
    case guild_arena:combat_check(Attacker, NpcBaseId) of
        true -> {true, ?combat_type_guild_arena_robot, [{guild_arena_robot, EventPid}]};
        {false, Reason} -> {false, Reason}
    end;
check(?combat_type_npc, Attacker = #role{event = ?event_guild_arena}, #npc{base_id = NpcBaseId}) ->
    case guild_arena:combat_check(Attacker, NpcBaseId) of
        true -> {true, ?combat_type_guild_arena_robot};
        {false, Reason} -> {false, Reason}
    end;

%% 帮会怪物
check(?combat_type_npc, #role{event = ?event_guild}, #npc{fun_type = ?npc_fun_type_guild_monster}) ->
    {true, ?combat_type_guild_monster};

%% 洛水反击战-人攻击怪物
check(?combat_type_npc, #role{event = ?event_guard_counter, event_pid = EventPid}, #npc{fun_type = ?npc_fun_type_guard_counter, base_id = BaseId}) ->
    {guard_counter, ?combat_type_guard_counter, [{guard_counter, EventPid}, {guard_counter_base_id, BaseId}]};

%% 洛水反击战-怪物攻击人
check(?combat_type_npc, #npc{fun_type = ?npc_fun_type_guard_counter, base_id = BaseId}, #role{event = ?event_guard_counter, event_pid = EventPid}) ->
    {guard_counter, ?combat_type_guard_counter, [{guard_counter, EventPid}, {guard_counter_base_id, BaseId}]};

%% 洛水反击战-人攻击BOSS
check(?combat_type_npc, #role{event = ?event_guard_counter, event_pid = EventPid}, #npc{fun_type = ?npc_fun_type_guard_counter_boss}) ->
    {true, ?combat_type_npc, [{guard_counter_boss, EventPid}]};

%% 生存模式杀怪
check(?combat_type_npc, #role{event = ?event_dungeon, event_pid = EventPid, dungeon_ext = #dungeon_ext{type = ?dungeon_type_survive}},
    _Defender) when is_pid(EventPid) ->
    {true, ?combat_type_survive, [{dungeon_score, EventPid}]};

%% 限时模式杀怪
check(?combat_type_npc, #role{event = ?event_dungeon, event_pid = EventPid, dungeon_ext = #dungeon_ext{type = ?dungeon_type_time}},
    _Defender) when is_pid(EventPid) ->
    {true, ?combat_type_time, [{dungeon_score, EventPid}]};

%% 多人副本内杀怪
check(?combat_type_npc, #role{event = ?event_dungeon, event_pid = EventPid, dungeon_ext = #dungeon_ext{type = ?dungeon_type_expedition}},
    _Defender) when is_pid(EventPid) ->
    {true, ?combat_type_expedition, [{dungeon_score, EventPid}]};
%% 副本内杀怪
check(?combat_type_npc, #role{event = ?event_dungeon, event_pid = EventPid}, Defender) when is_record(Defender, npc) andalso is_pid(EventPid) ->
    {true, ?combat_type_npc, [{dungeon_score, EventPid}]};
check(?combat_type_npc, _Attacker, Defender = #role{event = ?event_dungeon, event_pid = EventPid}) when is_pid(EventPid) ->
    case is_combat_protect_over(Defender) of
        true -> {true, ?combat_type_npc, [{dungeon_score, EventPid}]};
        false -> {false, ?MSGID(<<"对方处于保护状态，暂时不能发起战斗">>)}
    end;
check(?combat_type_npc, _Attacker, Defender) when is_record(Defender, role) ->
    case is_combat_protect_over(Defender) of
        true ->
            {true, ?combat_type_npc};
        false ->
            {false, ?MSGID(<<"对方处于保护状态，暂时不能发起战斗">>)}
    end;

%% 杀悬赏怪
check(?combat_type_npc, #role{id = Rid}, #npc{id = NpcId, fun_type = ?npc_fun_type_task_wanted}) ->
    case task_wanted:combat_check(Rid, NpcId) of
        {ok} ->
            {true, ?combat_type_npc};
        {false, Reason} ->
            {false, Reason}
    end;

%% 杀帮会boss
check(?combat_type_npc, Role, #npc{id = NpcId, fun_type = ?npc_fun_type_guild_boss}) ->
    case guild_boss:combat_check(Role, NpcId) of
        {ok} ->
            {true, ?combat_type_npc};
        {false, Reason} ->
            {false, Reason}
    end;

%% 杀世界boss 注：这块一定在放到倒数第二
check(?combat_type_npc, Role = #role{id = {RoleId, SrvId}, pid = RolePid, lev = _Lev, team_pid = TeamPid, anticrack = #anticrack{boss_counter = BossCounter}}, Npc = #npc{id = NpcId, base_id = NpcBaseId}) ->
    case boss_data:get(NpcBaseId) of
        %% {ok, _Boss = #boss_base{npc_lev = NpcLev}} when Lev >= (NpcLev + 30) ->
        %%     {false, ?L(<<"大神，您已经如此高等级了，此等小妖就交给其他历练中的小仙们降服吧。">>)};
        {ok, _Boss} ->
            case boss_unlock:check_combat_start(RoleId, SrvId, Npc, TeamPid) of
                {false, Reason} -> {false, Reason};
                ok ->
                    case BossCounter >= 5 of
                        true ->
                            Data = case get({captcha_next, NpcId}) of
                                true -> {next, {NpcId}};
                                _ -> {NpcId}
                            end,
                            case captcha:check(combat_rpc, 10705, Data, Role) of
                                false -> {false, <<"">>};
                                _ -> 
                                    role:apply(async, RolePid, {fun set_killboss_counter/2, [0]}),
                                    {true, ?combat_type_npc}
                            end;
                        false -> 
                            role:apply(async, RolePid, {fun set_killboss_counter/2, [BossCounter + 1]}),
                            {true, ?combat_type_npc}
                    end
            end;
        _ ->
            {true, ?combat_type_npc}
    end;

check(?combat_type_npc, Attacker, _Defender) when is_record(Attacker, role) ->
    {true, ?combat_type_npc};

%% 挑战排行榜杀模拟玩家的NPC
check(?combat_type_arena_career, Attacker, Defender = #role{career = Career}) when is_record(Attacker, role) andalso is_record(Defender, role) ->
    {ok, CF1} = role_convert:do(to_fighter, Attacker),
    {ok, CF2 = #converted_fighter{fighter = F}} = role_convert:do(to_fighter, {Defender, clone}),
    CF3 = CF2#converted_fighter{fighter = F#fighter{secret_ai = Career + 20}},
    combat:start(?combat_type_arena_career, [CF1], [CF3]),
    true;

check(?combat_type_c_arena_career, Attacker, Defender) when is_record(Attacker, role) andalso is_record(Defender, role) ->
    {ok, CF1} = role_convert:do(to_fighter, Attacker),
    {ok, CF2} = role_convert:do(to_fighter, {Defender, clone}),
    combat:start(?combat_type_c_arena_career, [CF1], [CF2]),
    true;

%% 妖精碎片掠夺
check(?combat_type_demon_challenge, Attacker, Defender) when is_record(Attacker, role) andalso is_record(Defender, converted_fighter) ->
    {ok, CF1} = role_convert:do(to_fighter, Attacker),
    #converted_fighter{fighter = F = #fighter{career = Career}} = Defender,
    CF2 = Defender#converted_fighter{fighter = F#fighter{secret_ai = Career + 20}},
    combat:start(?combat_type_demon_challenge, [CF1], [CF2]),
    true;

%% 荣耀学院：试炼场
check(?combat_type_trial, Attacker, Defender) when is_record(Attacker, role) ->
    {ok, CF1} = role_convert:do(to_fighter, Attacker),
    combat:start(?combat_type_trial, [CF1], [Defender]),
    true;

%% 生死结拜战斗
check(?combat_type_sworn, Attacker, _Defender) when is_record(Attacker, role) -> 
    {true, ?combat_type_sworn};

%% 幻灵秘境战斗
check(?combat_type_lottery_secret, Attacker, Defender) when is_record(Attacker, role) andalso is_record(Defender, role) ->
    {ok, CF1} = role_convert:do(to_fighter, Attacker),
    {ok, CF2} = role_convert:do(to_fighter, {Defender, lottery_secret}),
    combat:start(?combat_type_lottery_secret, [CF1], [CF2]),
    true;

%% 飞仙历练
check(?combat_type_train_rob, Attacker = #role{train = #role_train{center = Center}}, Defender = #role{train = #role_train{id = Fid}}) when is_record(Attacker, role) andalso is_record(Defender, role) ->
    {ok, CF1} = role_convert:do(to_fighter, Attacker),
    {ok, CF2} = role_convert:do(to_fighter, {Defender, clone}),
    combat:start(?combat_type_train_rob, [{train_id, {Center, Fid}}], [CF1], [CF2]),
    true;
%% 飞仙历练
check(?combat_type_train_arrest, Attacker = #role{train = #role_train{center = Center}}, Defender = #role{train = #role_train{id = Fid}}) when is_record(Attacker, role) andalso is_record(Defender, role) ->
    {ok, CF1} = role_convert:do(to_fighter, Attacker),
    {ok, CF2} = role_convert:do(to_fighter, {Defender, clone}),
    combat:start(?combat_type_train_arrest, [{train_id, {Center, Fid}}], [CF1], [CF2]),
    true;

%% 无法确定的战斗类型，一律不能发起战斗
check(_CombatType, _AtkList, _Defender) ->
    {false, ?L(<<"当前状态无法发起战斗">>)}.


%% @spec check_combat_result(Combat, AtkList, DfdList) -> integer()
%% Combat = #combat{}
%% AtkList = [#fighter{}]
%% DfdList = [#fighter{}]
%% @doc 每个回合检查战斗结果
check_combat_round_result(Combat = #combat{type = CombatType}, AtkList, DfdList) when CombatType =:= ?combat_type_rob_escort orelse CombatType =:= ?combat_type_rob_escort_child orelse CombatType =:= ?combat_type_rob_escort_cyj ->
    AtkSlaves = [F || F = #fighter{ms_rela = MsRela} <- AtkList, MsRela =:= ?ms_rela_escort],
    DfdSlaves = [F || F = #fighter{ms_rela = MsRela} <- DfdList, MsRela =:= ?ms_rela_escort],
    A = check_ms_rela_die(CombatType, AtkSlaves, false),
    D = check_ms_rela_die(CombatType, DfdSlaves, false),
    if
        A =:= true andalso D =:= true -> %% 双方同时护送失败
            ?combat_round_result_draw_game;
        A =:= true -> %% 进攻方护送失败
            ?combat_round_result_dfd_win;
        D =:= true -> %% 防守方护送失败
            ?combat_round_result_atk_win;
        true ->
            common_check_combat_round_result(Combat, AtkList, DfdList)
    end;
check_combat_round_result(Combat = #combat{round = Round, type = ?combat_type_survive}, AtkList, DfdList) ->
    Result = common_check_combat_round_result(Combat, AtkList, DfdList),
    Result2 = case Result of
        ?combat_round_result_atk_win -> %% 如果玩家那方全杀npc，则判断是否有下一波
            case combat:has_next_wave() of
                true -> 
                    ?combat_round_result_next;
                false -> 
                    Result
            end;
        _ -> 
            Result
    end,
    case Result2 of
        ?combat_round_result_next -> %% 判断是否超过回合限制
            case get(round_info) of
                [_, TotalRound] ->
                    case Round >= TotalRound of
                        true ->
                            ?combat_round_result_atk_win;
                        false ->
                            Result2
                    end;
                _ ->
                    Result2
            end;
        _ ->
            Result2
    end;

check_combat_round_result(Combat = #combat{round = Round, type = ?combat_type_time}, AtkList, DfdList) ->
    Result = common_check_combat_round_result(Combat, AtkList, DfdList),
    
    %% 判断是否超过回合限制
    IsLose = case get(round_info) of
        [UsedRound, TotalRound] ->
            UsedRound + Round >= TotalRound;
        _ ->
            false
    end,

    case Result of
        ?combat_round_result_next -> 
            case IsLose of
                true ->
                    ?combat_round_result_dfd_win;
                false ->
                    Result
            end;
        ?combat_round_result_atk_win ->
            case IsLose of
                true ->
                    case get(remain_npc_count) of
                        RemainNpcCount when is_integer(RemainNpcCount) andalso RemainNpcCount > 1 ->
                            ?combat_round_result_dfd_win;
                        _ ->
                            Result
                    end;
                false ->
                    Result
            end;
        _ -> 
            Result
    end;
check_combat_round_result(Combat = #combat{type = CombatType}, AtkList, DfdList)
when (CombatType =:= ?combat_type_expedition) orelse
(CombatType =:= ?combat_type_jail)
->
    Result = common_check_combat_round_result(Combat, AtkList, DfdList),
    case Result of
        ?combat_round_result_atk_win -> %% 如果玩家那方全杀npc，则判断是否有下一波
            case combat:has_next_wave() of
                true -> ?combat_round_result_next;
                false -> Result
            end;
        _ -> Result
    end;
check_combat_round_result(Combat, AtkList, DfdList) ->
    common_check_combat_round_result(Combat, AtkList, DfdList).

common_check_combat_round_result(#combat{type = CombatType, round = Round}, AtkList, DfdList) ->
    A = combat_util:is_all_die(AtkList),
    D = combat_util:is_all_die(DfdList),
    MaxRound = combat_type:calc_combat_max_round(CombatType),
    if
        A =:= true andalso D =:= true -> %% 双方同时阵亡
            ?combat_round_result_draw_game;
        A =:= true -> %% 进攻方全部阵亡
            ?combat_round_result_dfd_win;
        D =:= true -> %% 防守方全部阵亡
            ?combat_round_result_atk_win;
        Round >= MaxRound -> %% 已经达到最大回合数
            ?combat_round_result_draw_game;
        true -> %% 继续下一回合
            ?combat_round_result_next
    end.

%% 检查护送的对象和护送者是否死亡或者逃走
check_ms_rela_die(CombatType, [], Result) when CombatType =:= ?combat_type_rob_escort orelse CombatType =:= ?combat_type_rob_escort_child orelse CombatType =:= ?combat_type_rob_escort_cyj -> Result;
check_ms_rela_die(CombatType, [#fighter{type = ?fighter_type_npc, ms_rela = ?ms_rela_escort, is_die = IsDie, is_escape = IsEscape, ms_rela_master_pid = MasterPid}|T], Result) when CombatType =:= ?combat_type_rob_escort orelse CombatType =:= ?combat_type_rob_escort_child orelse CombatType =:= ?combat_type_rob_escort_cyj ->
    if
        IsDie =:= ?true orelse IsEscape =:= ?true -> true;
        true ->
            case combat:f(by_pid, MasterPid) of
                {_, #fighter{is_die = IsMasterDie, is_escape = IsMasterEscape}} when IsMasterDie =:= ?true orelse IsMasterEscape =:= ?true -> true;
                false -> true;
                _ -> check_ms_rela_die(CombatType, T, Result)
            end
    end;
check_ms_rela_die(_, _, Result) -> Result.


%% @spec combat_limit(Combat, AtkList, DfdList) -> {NewAtkList, NewDfdList}
%% Combat = #combat{}
%% AtkList = [#converted_fighter{}]
%% DfdList = [#converted_fighter{}]
%% @doc 战斗开始时的约束处理
combat_start_limit(#combat{type = ?combat_type_npc}, AtkList, DfdList) ->
    do_combat_start_limit(catch_pet, AtkList, DfdList);
combat_start_limit(_Combat, AtkList, DfdList) ->
    {AtkList, DfdList}.

do_combat_start_limit(catch_pet, AtkList, DfdList) ->
    case combat_util:is_all_npc(AtkList) of
        true -> 
            %% 如果怪追人而发起的战斗，则判断进攻方
            {do_combat_start_limit(catch_pet, AtkList, has_runaway(DfdList), [], AtkList), DfdList};
        false ->
            case combat_util:is_all_npc(DfdList) of
                true -> {AtkList, do_combat_start_limit(catch_pet, DfdList, has_runaway(AtkList), [], DfdList)};
                false -> {AtkList, DfdList}
            end
    end.
do_combat_start_limit(catch_pet, K, false, _L, _M) -> K;
do_combat_start_limit(catch_pet, [], true, L, M) -> 
    case L of
        [] -> M;    %% 如果L为空表示非伴随出现的可捕捉仙宠，不需要过滤
        _ -> lists:reverse(L)
    end;
do_combat_start_limit(catch_pet, [F = #converted_fighter{fighter = #fighter{rid = NpcBaseId, type = ?fighter_type_npc}}|T], true, L, M) ->
    case pet_api:is_capturable_npc(NpcBaseId) of
        true -> do_combat_start_limit(catch_pet, T, true, L, M);
        false -> do_combat_start_limit(catch_pet, T, true, [F|L], M)
    end.

has_runaway(L) -> has_runaway(L, false).
has_runaway([], Result) -> Result;
has_runaway([#converted_fighter{fighter = #fighter{last_combat_result = ?combat_result_escape}}|_T], _Result) -> true;
has_runaway([_F|T], Result) -> has_runaway(T, Result).


%% @spec enter_combat_failed(Combat, AtkList, DfdList) -> ok
%% Combat = #combat{}
%% AtkList = [#fighter{}]
%% DfdList = [#fighter{}]
%% 进入战斗失败的处理
enter_combat_failed(#combat{type = ?combat_type_cross_king, referees = Referees}, Atk, Dfd) -> 
    cross_king:combat_over(Referees, [], Atk ++ Dfd, []);
enter_combat_failed(#combat{type = ?combat_type_cross_warlord, referees = Referees}, Atk, Dfd) -> 
    cross_warlord:combat_over(Referees, [], Atk ++ Dfd, undefined);
enter_combat_failed(_, _, _) -> ok.

%% @spec combat_over(Combat) -> ok | ignore
%% Combat = #combat{}
%% @doc 战斗结束时，根据不同的战斗类型作相应处理
%% 处理切磋战斗结束
combat_over(Combat = #combat{type = Type, winner = Winner, loser = Loser}) when Type=:=?combat_type_rob_escort orelse Type=:=?combat_type_kill ->
    L = Winner ++ Loser,
    RoleKilled = [F || F = #fighter{group = Group} <- L, Group=:=group_dfd],
    put(role_killed, RoleKilled),
    common_over(Combat),
    ok;
combat_over(Combat = #combat{type = ?combat_type_compete, winner = Winner, loser = Loser}) ->
    Winner2 = [Fighter || Fighter = #fighter{type = ?fighter_type_role} <- Winner],
    Loser2 = [Fighter || Fighter = #fighter{type = ?fighter_type_role} <- Loser],
    compete_mgr:combat_over(Winner2, Loser2),
    common_over(Combat),
    ok;
combat_over(Combat = #combat{type = ?combat_type_jail, winner = Winner, loser = Loser}) ->
    Winner1 = [Fighter#fighter{result = ?combat_result_win} || Fighter <- Winner],
    Fighters = Winner1 ++ Loser,
    [#fighter{rid = RoleId, srv_id = SrvId, pid = RolePid, result = Result, life = Life}] = [Fighter || Fighter = #fighter{type = ?fighter_type_role} <- Fighters],
    LeftTime = combat:get_left_time(),
    jail_mgr:combat_over({RoleId, SrvId}, RolePid, Result, Life, LeftTime),
    common_over(Combat),
    ok;
combat_over(Combat = #combat{type = ?combat_type_arena_career, winner = Winner, loser = Loser}) ->
    Winner1 = [recover(?combat_type_arena_career, F) || F <- Winner],
    Loser1 = [recover(?combat_type_arena_career, F) || F <- Loser],
    lists:foreach(fun(F) -> combat:clear_pet_killed(F) end, Winner1 ++ Loser1),
    assign_gains(winner, arena_career:combat_award(winner), Winner1), %% 安排奖励
    assign_gains(loser, arena_career:combat_award(loser), Loser1),
    common_over(Combat#combat{winner = Winner1, loser = Loser1}),
    ok;
combat_over(Combat = #combat{type = ?combat_type_demon_challenge, winner = [Winner], loser = [Loser]}) ->
    Winner1 = recover(?combat_type_demon_challenge, Winner),
    Loser1 = recover(?combat_type_demon_challenge, Loser),
    lists:foreach(fun(F) -> combat:clear_pet_killed(F) end, [Winner1, Loser1]),
    case Winner1#fighter.is_clone of
        ?false -> %% win
            Type = case Loser1 of
                #fighter{subtype = ?fighter_subtype_demon_virtual_role} ->
                    ?demon_challenge_type_virtual;
                _ ->
                    ?demon_challenge_type_real
            end,
            Gains = role:apply(sync, Winner1#fighter.pid, {demon, deal_grab, [{Type, Loser1#fighter.rid, Loser1#fighter.srv_id}]}),
            case Gains of
                {error, _} -> ignore;
                _ -> assign_gains(winner, Gains, [Winner1]) %% 安排奖励;
            end;
        _ -> %% lose
            Type = case Winner1 of
                #fighter{subtype = ?fighter_subtype_demon_virtual_role} ->
                    ?demon_challenge_type_virtual;
                _ ->
                    ?demon_challenge_type_real
            end,
            role:apply(sync, Loser1#fighter.pid, {demon, loss_notify, [{Type, Winner1#fighter.rid, Winner1#fighter.srv_id}]}),
            ignore
    end,
    common_over(Combat#combat{winner = [Winner1], loser = [Loser1]}),
    ok;
combat_over(Combat) ->
    common_over(Combat),
    ok.

%% @spec combat_over_leave(CombatPid, Combat) -> ok
%% Combat = #combat{}
%% @doc 战斗结算完毕后离开战斗
combat_over_leave(Combat = #combat{type = ?combat_type_arena, winner = Winner, loser = Loser, referees = Referees}) ->
    common_over_leave(Combat),
    %% 任务物品掉落
    case catch task:combat_over(Winner, Loser) of
        ok -> ok;
        Err1 -> ?ERR("战斗结算完毕后离开战斗时发生错误[任务物品掉落]:~w", [Err1])
    end,
    %% 竞技场
    Referee = combat_util:match_param(common, Referees, 0),
    case catch arena:combat_over(Referee, Winner, Loser) of
        ok -> ok;
        Err2 -> ?ERR("战斗结算完毕后离开战斗时发生错误[竞技场]:~w", [Err2])
    end;

combat_over_leave(Combat = #combat{type = ?combat_type_top_fight, winner = Winner, loser = Loser, referees = Referees}) ->
    common_over_leave(Combat),
    %% 任务物品掉落
    case catch task:combat_over(Winner, Loser) of
        ok -> ok;
        Err1 -> ?ERR("战斗结算完毕后离开战斗时发生错误[任务物品掉落]:~w", [Err1])
    end,
    %% 竞技场
    Referee = combat_util:match_param(common, Referees, 0),
    case catch top_fight_center:combat_over(Referee, Winner, Loser) of
        ok -> ok;
        Err2 -> ?ERR("战斗结算完毕后离开战斗时发生错误[竞技场]:~w", [Err2])
    end;

combat_over_leave(Combat = #combat{type = ?combat_type_npc, round = Round, winner = Winner, loser = Loser, referees = Referees}) ->
    common_over_leave(Combat),
    %% 任务物品掉落
    case catch task:combat_over(Winner, Loser) of
        ok -> ok;
        Err1 -> ?ERR("战斗结算完毕后离开战斗时发生错误[任务物品掉落]:~w", [Err1])
    end,
    %% 排行榜
    case center:is_cross_center() of
        false ->
            case catch rank_celebrity:combat_over(Combat) of
                ok -> ok;
                Err5 -> ?ERR("战斗结算完毕后离开战斗时发生错误[排行榜]:~w", [Err5])
            end,
            %% 超级世界boss
            case get(is_fighting_super_boss) of
                ?true ->
                    case catch super_boss_mgr:combat_over(Combat) of
                        ok -> ok;
                        Err7 ->?ERR("战斗结算完毕后离开战斗时发生错误[超级世界boss]:~w", [Err7])
                    end;
                _ -> ignore
            end,
            %% 帮派boss
            case get(is_fighting_guild_boss) of
                true ->
                    case catch guild_boss:combat_over(Combat) of
                        ok -> ok;
                        _R -> ?ERR("挑战帮派boss离开时发生错误 ~w", [_R])
                    end;
                _ -> ignore
            end;
        true -> ignore
    end,
    %% 必须先统计评分再通知地图清怪触发评分
    %% 通知副本进程副本评分数据
    Referee2 = combat_util:match_param(dungeon_score, Referees, 0),
    if
        is_pid(Referee2) ->
            DungeonScoreData = [{{RoleId, SrvId}, combat:get_dungeon_score_data(Combat, Pid)} || #fighter{rid = RoleId, srv_id = SrvId, pid = Pid, type=Type} <- Winner, Type=:=?fighter_type_role],
            %%副本胜利了才记录评分
            case DungeonScoreData of
                [] ->
                    ignore;
                _ ->
                    Referee2 ! {dungeon_score, Round, fighter_to_base_id(Loser, []), DungeonScoreData}
            end;
        true -> 
            ignore
    end,

    %%世界Boss不通知地图删掉怪物
    case get(is_fighting_super_boss) of
        ?true ->
            ignore;
        _ ->
            %% 通知裁判进程某些怪物被杀
            Referee1 = combat_util:match_param(common, Referees, 0),
            if
                is_pid(Referee1) ->
                    %% TODO:如果以后人和NPC一起作战，这里可能有问题!!
                    Referee1 ! {combat_over_result, [{kill_npc, fighter_to_base_id(Loser, [])}, {round, Round}, {combat_pid, self()}]};
                true -> ignore
            end
    end;
    
combat_over_leave(Combat = #combat{type = ?combat_type_survive, round = Round, winner = Winner, loser = Loser, referees = Referees}) ->
    common_over_leave(Combat),
    %% 排行榜
    case center:is_cross_center() of
        false ->
            case catch rank_celebrity:combat_over(Combat) of
                ok -> ok;
                Err5 -> ?ERR("战斗结算完毕后离开战斗时发生错误[排行榜]:~w", [Err5])
            end;
        true -> 
            ignore
    end,
    %% 必须先统计评分再通知地图清怪触发评分
    %% 通知副本进程副本评分数据
    Referee2 = combat_util:match_param(dungeon_score, Referees, 0),
    if
        is_pid(Referee2) ->
            DungeonScoreData = [{{RoleId, SrvId}, combat:get_dungeon_score_data(Combat, Pid)} || #fighter{rid = RoleId, srv_id = SrvId, pid = Pid, type=Type} <- Winner, Type=:=?fighter_type_role],
            %%副本胜利了才记录评分
            case DungeonScoreData of
                [] ->
                    ignore;
                _ ->
                    %%只统计已死的
                    Loser2 = [F || F = #fighter{is_die = ?true} <- Loser],
                    Referee2 ! {dungeon_score, Round, fighter_to_base_id(Loser2, []), DungeonScoreData}
            end;
        true -> 
            ignore
    end,
    %% 通知裁判进程某些怪物被杀
    Referee1 = combat_util:match_param(common, Referees, 0),
    if
        is_pid(Referee1) ->
            %% TODO:如果以后人和NPC一起作战，这里可能有问题!!
            Referee1 ! {combat_over_result, [{kill_npc, fighter_to_base_id(Loser, [])}, {round, Round}, {combat_pid, self()}]};
        true -> ignore
    end;
    
combat_over_leave(Combat = #combat{type = ?combat_type_time, round = Round, winner = Winner, loser = Loser, referees = Referees}) ->
    common_over_leave(Combat),
    %% 排行榜
    case center:is_cross_center() of
        false ->
            case catch rank_celebrity:combat_over(Combat) of
                ok -> ok;
                Err5 -> ?ERR("战斗结算完毕后离开战斗时发生错误[排行榜]:~w", [Err5])
            end;
        true -> 
            ignore
    end,
    %% 必须先统计评分再通知地图清怪触发评分
    %% 通知副本进程副本评分数据
    Referee2 = combat_util:match_param(dungeon_score, Referees, 0),
    if
        is_pid(Referee2) ->
            DungeonScoreData = [{{RoleId, SrvId}, combat:get_dungeon_score_data(Combat, Pid)} || #fighter{rid = RoleId, srv_id = SrvId, pid = Pid, type=Type} <- Winner, Type=:=?fighter_type_role],
            %%副本胜利了才记录评分
            case DungeonScoreData of
                [] ->
                    ignore;
                _ ->
                    Referee2 ! {dungeon_score, Round, fighter_to_base_id(Loser, []), DungeonScoreData}
            end;
        true -> 
            ignore
    end,
    %% 通知裁判进程某些怪物被杀
    Referee1 = combat_util:match_param(common, Referees, 0),
    if
        is_pid(Referee1) ->
            %% TODO:如果以后人和NPC一起作战，这里可能有问题!!
            Referee1 ! {combat_over_result, [{kill_npc, fighter_to_base_id(Loser, [])}, {round, Round}, {combat_pid, self()}]};
        true -> ignore
    end;

combat_over_leave(Combat = #combat{type = ?combat_type_expedition, round = Round, winner = Winner, loser = Loser, referees = Referees}) ->
    common_over_leave(Combat),
    %% 排行榜
    case center:is_cross_center() of
        false ->
            case catch rank_celebrity:combat_over(Combat) of
                ok -> ok;
                Err5 -> ?ERR("战斗结算完毕后离开战斗时发生错误[排行榜]:~w", [Err5])
            end;
        true -> 
            ignore
    end,
    %% 必须先统计评分再通知地图清怪触发评分
    %% 通知副本进程副本评分数据
    Referee2 = combat_util:match_param(dungeon_score, Referees, 0),
    if
        is_pid(Referee2) ->
            DungeonScoreData = [{{RoleId, SrvId}, combat:get_dungeon_score_data(Combat, Pid)} || #fighter{rid = RoleId, srv_id = SrvId, pid = Pid, type=Type} <- Winner, Type=:=?fighter_type_role],
            Referee2 ! {dungeon_score, Round, fighter_to_base_id(Loser, []), DungeonScoreData};
        true -> 
            ignore
    end,
    %% 通知裁判进程某些怪物被杀
    Referee1 = combat_util:match_param(common, Referees, 0),
    if
        is_pid(Referee1) ->
            %% TODO:如果以后人和NPC一起作战，这里可能有问题!!
            Referee1 ! {combat_over_result, [{kill_npc, fighter_to_base_id(Loser, [])}, {round, Round}, {combat_pid, self()}]};
        true -> ignore
    end;


%%世界树战斗结束
combat_over_leave(Combat = #combat{type = ?combat_type_tree, winner = Winner, loser = Loser}) ->
    common_over_leave(Combat),
    Winner1 = [Fighter#fighter{result = ?combat_result_win} || Fighter <- Winner],
    Fighters = Winner1 ++ Loser,
    [#fighter{pid = RolePid, result = Result}] = [Fighter || Fighter = #fighter{type = ?fighter_type_role} <- Fighters],
    role:apply(async, RolePid, {tree_api, async_combat_over_leave, [Result]});

%%NPC海盗战斗结束
combat_over_leave(Combat = #combat{type = ?combat_type_wanted_npc, winner = Winner, loser = Loser}) ->
    common_over_leave(Combat),
    Winner1 = [Fighter#fighter{result = ?combat_result_win} || Fighter <- Winner],
    Fighters = Winner1 ++ Loser,
    [Fighter] = [Fighter || Fighter = #fighter{type = ?fighter_type_role} <- Fighters],
    wanted_mgr:combat_over_leave(Fighter);

%%玩家海盗战斗结束
combat_over_leave(Combat = #combat{type = ?combat_type_wanted_role, winner = Winner, loser = Loser}) ->
    common_over_leave(Combat),
    Winner1 = [Fighter#fighter{result = ?combat_result_win} || Fighter <- Winner],
    Fighters = Winner1 ++ Loser,
    [Fighter] = [Fighter || Fighter = #fighter{type = ?fighter_type_role, is_clone = ?false} <- Fighters],
    wanted_mgr:combat_over_leave(Fighter);
    
combat_over_leave(Combat = #combat{type = ?combat_type_c_boss, pid = CombatPid, round = Round, referees = Referees, winner = Winner}) ->
    common_over_leave(Combat),
    %% 通知裁判进程某些怪物被杀
    Referee1 = combat_util:match_param(common, Referees, 0),
    %% 跨服boss打完
    if
        is_pid(Referee1) ->
            cross_boss_mgr:over_combat(Referee1, CombatPid, Winner, Round);
        true -> ignore
    end;

combat_over_leave(Combat = #combat{type = ?combat_type_c_ore, referees = Referees, winner = Winner, loser = Loser}) ->
    common_over_leave(Combat),
    %% 仙府打劫或争夺
    cross_ore_mgr:combat_over(Referees, Winner, Loser);

combat_over_leave(Combat = #combat{type = ?combat_type_rob_escort}) ->
    common_over_leave(Combat),
    escort:combat_over(Combat),
    % friend:combat_over(Combat);
    ok;

combat_over_leave(Combat = #combat{type = ?combat_type_rob_escort_child}) ->
    common_over_leave(Combat),
    escort_child:combat_over(Combat),
    % friend:combat_over(Combat);
    ok;

combat_over_leave(Combat = #combat{type = ?combat_type_rob_escort_cyj}) ->
    common_over_leave(Combat),
    escort_cyj:combat_over(Combat),
    % friend:combat_over(Combat);
    ok;

combat_over_leave(Combat = #combat{type = ?combat_type_kill}) ->
    common_over_leave(Combat),
    % friend:combat_over(Combat),
    achievement:combat_over(Combat);

%% 帮会怪物
combat_over_leave(Combat = #combat{type = ?combat_type_guild_monster}) ->
    common_over_leave(Combat),
    guild_pool:combat_over(Combat);

%% 帮战
combat_over_leave(Combat = #combat{type = ?combat_type_guild_war, winner = Winner, loser = Loser, referees = Referees}) ->
    common_over_leave(Combat),
    Referee = combat_util:match_param(common, Referees, 0),
    guild_war:combat(combat_over, {Referee, Winner, Loser});

%% 帮战机器人
combat_over_leave(Combat = #combat{type = ?combat_type_guild_war_robot, winner = Winner, loser = Loser, referees = Referees}) ->
    common_over_leave(Combat),
    _Referee = combat_util:match_param(common, Referees, 0),
    case lists:keyfind(ref_guild_war, 1, Referees) of
        {_, Wpid} ->
            guild_war:combat(combat_over, {Wpid, Winner, Loser});
        _ ->
            ok
    end;

%% 帮战主将赛
combat_over_leave(Combat = #combat{type = ?combat_type_guild_war_compete, winner = Winner, loser = Loser, referees = Referees}) ->
    common_over_leave(Combat),
    Referee = combat_util:match_param(common, Referees, 0),
    guild_war_compete:combat(compete_combat_over, {Referee, Winner, Loser});

%% 新帮战
combat_over_leave(Combat = #combat{type = ?combat_type_guild_arena, winner = Winner, loser = Loser, referees = Referees}) ->
    common_over_leave(Combat),
    %% Referee = combat_util:match_param(common, Referees, 0),
    case lists:keyfind(guild_arena_pid, 1, Referees) of
        {_, EventPid} ->
            guild_arena:combat_over(EventPid, Winner, Loser);
        _ ->
            guild_arena:combat_over(ok, Winner, Loser)
    end;

%% 新帮战机器人
combat_over_leave(Combat = #combat{type = ?combat_type_guild_arena_robot, winner = Winner, loser = Loser, referees = Referees}) ->
    common_over_leave(Combat),
    case lists:keyfind(guild_arena_robot, 1, Referees) of
        {_, EventPid} ->
            guild_arena:combat_over(EventPid, robot, Winner, Loser);
        _ ->
            guild_arena:combat_over(robot, Winner, Loser)
    end;

%% 洛水反击战
combat_over_leave(Combat = #combat{type = ?combat_type_guard_counter, winner = Winner, loser = Loser, referees = Referees}) ->
    common_over_leave(Combat),
    case lists:keyfind(guard_counter, 1, Referees) of
        {_, EventPid} ->
            guard_counter:kill_normal(EventPid, Referees, Winner, Loser);
        _ -> skip
    end;

%% 帮会副本
combat_over_leave(Combat = #combat{type = ?combat_type_guild_td, winner = Winner, loser = Loser, referees= Referees}) ->
    common_over_leave(Combat),
    guild_td:combat(combat_over, {Referees, Winner, Loser});

%% 竞技场 
combat_over_leave(Combat = #combat{type = ?combat_type_arena_robot, referees= Referees}) ->
    common_over_leave(Combat),
    case lists:keyfind(ref_arena_robot, 1, Referees) of
        false ->
            ?ERR("竞技场斩杀机器人事件缺少裁判进程"),
            ok;
        {_, ArenaPid} -> 
            arena:combat_over_robot(ArenaPid, Combat)
    end;

%% 中庭战神
combat_over_leave(Combat = #combat{type = ?combat_type_arena_career, winner = Winner, loser = Loser, referees = Referees}) ->
    common_over_leave(Combat),
    Referee = combat_util:match_param(common, Referees, 0),
    arena_career:combat(combat_over, {Referee, Winner, Loser});

%% 跨服师门竞技
combat_over_leave(Combat = #combat{type = ?combat_type_c_arena_career, winner = Winner, loser = Loser, referees = Referees}) ->
    common_over_leave(Combat),
    Referee = combat_util:match_param(common, Referees, 0),
    arena_career:combat(c_combat_over, {Referee, Winner, Loser});

%% 妖精碎片掠夺
combat_over_leave(Combat = #combat{type = ?combat_type_demon_challenge, winner = Winner, loser = Loser, referees = Referees}) ->
    common_over_leave(Combat),
    Referee = combat_util:match_param(common, Referees, 0),
    demon_challenge:over(Referee, Winner, Loser);

%% 荣耀学院：试炼场
combat_over_leave(Combat = #combat{type = ?combat_type_trial, winner = Winner, loser = Loser, referees = Referees}) ->
    common_over_leave(Combat),
    Referee = combat_util:match_param(common, Referees, 0),
    trial_combat:over(Referee, Winner, Loser);

%% 跨服仙道会
combat_over_leave(Combat = #combat{type = ?combat_type_c_world_compete, winner = Winner, loser = Loser}) ->
    common_over_leave(Combat),
    WorldCompeteType = get_world_compete_type(Winner, Loser),
    c_world_compete_mgr:combat_over(WorldCompeteType, Winner, Loser);

%% 生死结拜战斗
combat_over_leave(Combat = #combat{type = ?combat_type_sworn}) ->
    common_over_leave(Combat),
    sworn:combat_over();

%% 幻灵秘境战斗
combat_over_leave(Combat = #combat{type = ?combat_type_lottery_secret, winner = Winner, loser = Loser}) ->
    common_over_leave(Combat),
    lottery_secret:combat_over(Winner, Loser);

%% 武神坛
combat_over_leave(Combat = #combat{type = ?combat_type_cross_warlord, winner = Winner, loser = Loser, referees = Referees}) ->
    common_over_leave(Combat),
    case get(combat_start_addt_args) of
        AddtArgs = [_|_] ->
            case combat_util:match_param(atk, AddtArgs, undefined) of
                TeamCode when is_integer(TeamCode) ->
                    cross_warlord:combat_over(Referees, Winner, Loser, {atk, TeamCode});
                _Err ->
                    ?ERR("无法获取武神坛战斗的信息:~w",[_Err]),
                    cross_warlord:combat_over(Referees, Winner, Loser, undefined)
            end;
        _Err ->
            ?ERR("无法获取武神坛战斗的信息:~w",[_Err]),
            cross_warlord:combat_over(Referees, Winner, Loser, undefined)
    end;

%% 至尊王者
combat_over_leave(Combat = #combat{type = ?combat_type_cross_king, winner = Winner, loser = Loser, referees = Referees}) ->
    common_over_leave(Combat),
    Atk = [{Rid, SrvId} || #fighter{rid = Rid, srv_id = SrvId, group = group_atk, type = ?fighter_type_role} <- (Winner ++ Loser)],
    Dfd = [{Rid, SrvId, Pid} || #fighter{rid = Rid, srv_id = SrvId, pid = Pid, group = group_dfd, type = ?fighter_type_role} <- (Winner ++ Loser)],
    DmgList = case Atk of
        [{Rid, SrvId}] ->
            List1 = [{R, S, combat:get_role_to_role_dmg(P, {Rid, SrvId})} || {R, S, P} <- Dfd],
            [{{R, S}, Dmg} || {R, S, {Dmg, _}} <- List1]; 
        _ -> []
    end,
    cross_king:combat_over(Referees, Winner, Loser, DmgList);

%% 跨服决斗
combat_over_leave(Combat = #combat{type = ?combat_type_c_duel, referees = Referees, winner = Winner}) ->
    common_over_leave(Combat),
    Referee1 = combat_util:match_param(common, Referees, 0),
    if
        is_pid(Referee1) ->
            case Winner of
                [#fighter{rid = Rid, srv_id = SrvId}] ->
                    c_cross_duel:over_combat(Referee1, {Rid, SrvId});
                _ ->
                    c_cross_duel:over_combat(Referee1, 0)
            end;
        true -> ignore
    end;

%% 飞仙历练打劫
combat_over_leave(Combat = #combat{type = ?combat_type_train_rob, winner = Winner, loser = Loser, referees = Referees}) ->
    common_over_leave(Combat),
    Referee = combat_util:match_param(train_id, Referees, {0, {0, 0}}),
    train_common:combat_over(rob, {Referee, Winner, Loser});
%% 飞仙历练缉拿
combat_over_leave(Combat = #combat{type = ?combat_type_train_arrest, winner = Winner, loser = Loser, referees = Referees}) ->
    common_over_leave(Combat),
    Referee = combat_util:match_param(train_id, Referees, {0, {0, 0}}),
    train_common:combat_over(arrest, {Referee, Winner, Loser});
%% 切磋
combat_over_leave(Combat = #combat{type = ?combat_type_challenge, winner = Winner, loser = Loser}) ->
    Fwin = fun(Role) ->
            NR1 = role_listener:special_event(Role, {30034, 1}),
            NR2 = role_listener:special_event(NR1, {30035, 1}),
            {ok, NR2}
    end,
    Flost = fun(Role) ->
            NR = role_listener:special_event(Role, {30034, 1}),
            {ok, NR}
    end,
    [role:apply(async, Pid, {Fwin, []}) || #fighter{pid = Pid, type = ?fighter_type_role, is_clone = ?false} <- Winner],
    [role:apply(async, Pid, {Flost, []}) || #fighter{pid = Pid, type = ?fighter_type_role, is_clone = ?false} <- Loser],
    %% ?DEBUG("其他类型的战斗结束:~w", [_CombatType]),
    common_over_leave(Combat);

combat_over_leave(Combat = #combat{type = _CombatType}) ->
    %% ?DEBUG("其他类型的战斗结束:~w", [_CombatType]),
    common_over_leave(Combat).


%% @spec is_limited_skill(CombatType, SkillId) -> false | true
%% CombatType = atom()
%% SkillId = integer()
%% @doc 判断技能是否能在此战斗类型下使用
is_limited_skill(Conds, SkillId) ->
    A = case lists:keyfind(combat_type, 1, Conds) of
        {combat_type, CombatType} -> is_limited_skill(combat_type, CombatType, SkillId);
        _ -> false
    end,
    B = case lists:keyfind(super_boss, 1, Conds) of
        {super_boss, ?true} -> is_limited_skill(super_boss, {}, SkillId);
        _ -> false
    end,
    A=:=true orelse B=:=true.
is_limited_skill(combat_type, ?combat_type_arena, 1002) -> true;
is_limited_skill(combat_type, ?combat_type_top_fight, 1002) -> true;
is_limited_skill(combat_type, ?combat_type_guild_arena, 1002) -> true;
is_limited_skill(combat_type, ?combat_type_guild_war, 1002) -> true;
is_limited_skill(combat_type, ?combat_type_guild_war_compete, 1002) -> true;
is_limited_skill(combat_type, ?combat_type_guild_war_robot, 1002) -> true;
is_limited_skill(combat_type, ?combat_type_arena_career, 1002) -> true;
is_limited_skill(combat_type, ?combat_type_c_arena_career, 1002) -> true;
is_limited_skill(combat_type, ?combat_type_demon_challenge, 1002) -> true;
is_limited_skill(combat_type, ?combat_type_cross_king, 1002) -> true;
is_limited_skill(combat_type, ?combat_type_cross_warlord, 1002) -> true;
is_limited_skill(combat_type, ?combat_type_c_world_compete, 1002) -> true;
is_limited_skill(combat_type, ?combat_type_practice, 1002) -> true;
is_limited_skill(combat_type, ?combat_type_c_boss, 1002) -> true;
is_limited_skill(combat_type, ?combat_type_train_rob, 1002) -> true;
is_limited_skill(combat_type, ?combat_type_train_arrest, 1002) -> true;
is_limited_skill(super_boss, _, 1002) -> true;
is_limited_skill(_, _, _) -> false.

%% @spec calc_combat_max_round(CombatType) -> integer()
%% CombatType = atom()
%% @doc 计算战斗最大回合数
calc_combat_max_round(?combat_type_c_world_compete) -> 99;
calc_combat_max_round(?combat_type_practice) -> 400;
calc_combat_max_round(?combat_type_cross_king) -> 30;
calc_combat_max_round(_CombatType) -> ?default_max_round.

%% @spec calc_combat_round_time(Type, AtkList, DfdList) -> integer()
%% Type = atom()
%% AtkList = DfdList = [#converted_fighter{}]
%% @doc 计算战斗回合选招等待时间
calc_combat_round_time(?combat_type_tutorial, _, _) -> %% 帮战的出招时间
    infinity;
calc_combat_round_time(?combat_type_guild_war, _, _) -> %% 帮战的出招时间
    10000;
calc_combat_round_time(?combat_type_guild_war_compete, _, _) -> %% 帮战的出招时间
    10000;
calc_combat_round_time(?combat_type_guild_arena, _, _) -> %% 新帮战的出招时间
    10000;
calc_combat_round_time(?combat_type_guild_war_robot, _, _) -> %% 帮战的出招时间
    10000;
calc_combat_round_time(?combat_type_cross_king, _, _) -> %% 至尊王者出招时间
    10000;
%% calc_combat_round_time(_, [], DfdList) -> 15000;
calc_combat_round_time(_Type, AtkList, DfdList) ->
    case do_calc_combat_round_time(AtkList, 15000) of
        {new_guy, Time} -> Time;
        {npc, PrepareTime} ->
            case do_calc_combat_round_time(DfdList, 15000) of
                {new_guy, Time1} -> Time1;
                _ -> PrepareTime * 1000
            end;
        _ ->
            case do_calc_combat_round_time(DfdList, 15000) of
                {new_guy, Time2} -> Time2;
                {npc, PrepareTime1} -> PrepareTime1 * 1000;
                _ -> 15000
            end
    end.
do_calc_combat_round_time([], Result) -> Result;
do_calc_combat_round_time([#converted_fighter{fighter = #fighter{type = ?fighter_type_role, lev = Lev}} | T], Result) ->
    case Lev =< 12 of
        true -> {new_guy, 20000};
        false -> do_calc_combat_round_time(T, Result)
    end;
do_calc_combat_round_time([#converted_fighter{fighter = #fighter{type = ?fighter_type_npc}, fighter_ext = #fighter_ext_npc{prepare_time = PrepareTime}} | _T], _Result) ->
    {npc, PrepareTime};
do_calc_combat_round_time([_|T], Result) ->
    do_calc_combat_round_time(T, Result).


%% @spec reset_special_npc_killed_count(Role) -> #role{}
%% Role = #role{}
%% @doc 重置特殊击杀怪物计数器
reset_special_npc_killed_count(Role = #role{combat = CombatParams}) ->
    LastCombatTime = combat_util:match_param(last_combat_time, CombatParams, 0),
    SpecialNpcKilledCount = combat_util:match_param(special_npc_killed_count, CombatParams, 0),

    %% 如果当次战斗和上次战斗是发生在不同一天，则重置特殊怪物击杀计数器
    SpecialNpcKilledCount1 = case util:is_same_day(LastCombatTime, erlang:now()) of
        true -> SpecialNpcKilledCount;
        false -> 0
    end,
    CombatParams1 = [{last_combat_time, erlang:now()} | lists:keydelete(last_combat_time, 1, CombatParams)],
    CombatParams2 = [{special_npc_killed_count, SpecialNpcKilledCount1} | lists:keydelete(special_npc_killed_count, 1, CombatParams1)],
    Role#role{combat = CombatParams2}.

%% @spec stop_combat(CombatPid) -> ok
%% CombatPid = pid()
%% @doc 停止指定的战斗
stop_combat(CombatPid) when is_pid(CombatPid) ->
    CombatPid ! stop,
    ok;
stop_combat(_) ->
    ok.

%%----------------------------------------------------
%% ** 内部函数 **
%%----------------------------------------------------

%% 战斗保护时间是否已经过去
is_combat_protect_over(#role{combat = CombatParams})->
    LastCombatTime = combat_util:match_param(last_combat_time, CombatParams, 0),
    case LastCombatTime of
        {_, _, _} ->
            Left = util:time_left(?NO_COMBAT_TIME, LastCombatTime),
            if
                Left =< 0 -> true;
                true -> false
            end;
        _ -> true
    end;
is_combat_protect_over(_R) ->
    true.

%% 获取实际上抓到的宠物（调用宠物模块时失败的宠物不当做最终抓获成功）
get_caught_pets(Pid) ->
    case get({caught_pets, Pid}) of
        undefined -> [];
        Ps -> Ps
    end.

%% 处理共有的战斗结束处理
common_over(#combat{type = CombatType, winner = Winner, loser = Loser, observer = Observer}) ->
    %% 获取损益参数
    GLflag = get_all_gl_flags(Winner),

    %% 失败者产出掉落物品、NPC击杀名单、资产列表（玩家）
    {Rewards, NpcKilled, _AssetsList} = loser_exit_combat(Loser, CombatType, [], [], [], [], [], GLflag),

    %% 保存NpcKilled，供combat_over_leave使用
    put(npc_killed, NpcKilled),

    RoleKilled = case CombatType of
        ?combat_type_kill -> get(role_killed);
        ?combat_type_rob_escort -> get(role_killed);
        ?combat_type_rob_escort_child -> get(role_killed);
        ?combat_type_rob_escort_cyj -> get(role_killed);
        _ -> []
    end,

    %% 分配物品
    Winner1 = [R || R = #fighter{type = Type} <- Winner, Type =:= ?fighter_type_role],
    assign_gains(winner, Rewards, Winner1),
    winner_exit_combat(Winner, CombatType, Rewards, NpcKilled, RoleKilled, []),

    %% 通知观战者退出
    combat:stop_all_observe(Observer).

%% 处理共有的战斗结束处理（面板播放完之后）
common_over_leave(Combat = #combat{type = CombatType, winner = Winner, loser = Loser}) ->
    WinnerNpc = [F || F = #fighter{type = Type} <- Winner, Type =:= ?fighter_type_npc],
    LoserNpc = [F || F = #fighter{type = Type} <- Loser, Type =:= ?fighter_type_npc],
    WinnerRole = [F || F = #fighter{type = Type, is_clone = IsClone} <- Winner, Type =:= ?fighter_type_role andalso IsClone =:= ?false],
    LoserRole = [F || F = #fighter{type = Type, is_clone = IsClone} <- Loser, Type =:= ?fighter_type_role andalso IsClone =:= ?false],

    %% 通知副本进程：战斗结果
    case WinnerRole of
        [] -> ignore;
        [#fighter{pid = WinnerRolePid}|_] ->
            case combat:f_ext(by_pid, WinnerRolePid) of
                #fighter_ext_role{event = ?event_dungeon, event_pid = WinerDunPid} ->
                    dungeon:combat_over(WinerDunPid, win);
                _ -> ignore
            end
    end,
    case LoserRole of
        [] -> ignore;
        [#fighter{pid = LoserRolePid}|_] ->
            case combat:f_ext(by_pid, LoserRolePid) of
                #fighter_ext_role{event = ?event_dungeon, event_pid = LoserDunPid} ->
                    dungeon:combat_over(LoserDunPid, lose);
                _ -> ignore
            end
    end,
    
    %% 先处理NPC的回写，以防角色回写出错导致NPC无法再战斗
    lists:foreach(fun(#fighter{pid = Pid}) ->
                %% 通知NPC进程退出战斗
                case is_pid(Pid) of
                    false -> ignore;
                    true -> npc:fight_info(Pid, {stop, win})
                end
        end, WinnerNpc),
    lists:foreach(fun(#fighter{pid = Pid, base_id = NpcBaseId}) ->
                %% 通知NPC进程退出战斗
                case is_pid(Pid) of
                    false -> ignore;
                    true -> npc:fight_info(Pid, {stop, lost, NpcBaseId, WinnerRole})
                end
        end, LoserNpc),

    %% 再处理角色的回写
    lists:foreach(fun(F = #fighter{pid = Pid, name = _Name}) ->
                NpcKilled = get(npc_killed),
                case is_pid(Pid) of
                    true ->
                        case catch role:apply(sync, Pid, {fun do_combat_over_leave/5, [Combat, recover(CombatType, F), NpcKilled, get_caught_pets(Pid)]}) of
                            true -> ok;
                            _Err -> ?ERR("胜利者[~s]的角色回写失败:~w", [_Name, _Err])
                        end;
                    false -> ?ERR("胜利者[~s]的角色进程在战斗结束时已经不存在，无法回写", [_Name])
                end
        end, WinnerRole),
    lists:foreach(fun(F = #fighter{pid = Pid, name = _Name}) ->
                NpcKilled = get(npc_killed),
                case is_pid(Pid) of
                    true ->
                        case catch role:apply(sync, Pid, {fun do_combat_over_leave/5, [Combat, recover(CombatType, F), NpcKilled, get_caught_pets(Pid)]}) of
                            true -> ok;
                            _Err -> ?ERR("战败者[~s]的角色回写失败:~w", [_Name, _Err])
                        end;
                    false -> ?ERR("战败者[~s]的角色进程在战斗结束时已经不存在，无法回写", [_Name])
                end
        end, LoserRole),
    %% 保存录像
    case get(combat_start_addt_args) of
        AddtArgs = [_|_] ->
            case combat_util:match_param(replay_id, AddtArgs, undefined) of
                undefined -> ignore;
                ReplayId ->
                    case combat:get_all_replay() of
                        {{10710, RP_10710}, {10720, RP_10720}, {10721, RP_10721}} ->
                            combat_replay_mgr:save_replay({ReplayId, CombatType, RP_10710, RP_10720, RP_10721});
                        _ -> ?ERR("无法保存[Id=~w]的录像，录像保存不正确", [ReplayId])
                    end
            end;
        _ -> ignore
    end.
%%eprof:stop_profiling(),
%%eprof:analyze(total, [{sort, calls}]),
%%eprof:stop().

%% 从参战者列表中取出所有的NpcBaseId
fighter_to_base_id([], L) -> L;
fighter_to_base_id([#fighter{type = ?fighter_type_npc, rid = NpcBaseId} | T], L) ->
    fighter_to_base_id(T, [NpcBaseId | L]);
fighter_to_base_id([_H | T], L) ->
    fighter_to_base_id(T, L).

%% 战斗结束回写前恢复战斗前的某些属性
recover(?combat_type_challenge, F = #fighter{pid = Pid, group = Group}) ->
    case combat:get_original_fighter(Group, Pid) of
        undefined -> F#fighter{is_die = ?false};
        #fighter{hp = OldHp, mp = OldMp} -> F#fighter{hp = OldHp, mp = OldMp, is_die = ?false}
    end;
recover(?combat_type_arena_career, F = #fighter{pid = Pid, group = Group}) ->
    case combat:get_original_fighter(Group, Pid) of
        undefined -> F#fighter{is_die = ?false};
        #fighter{hp = OldHp, mp = OldMp} -> F#fighter{hp = OldHp, mp = OldMp, is_die = ?false}
    end;
recover(?combat_type_c_arena_career, F = #fighter{pid = Pid, group = Group}) ->
    case combat:get_original_fighter(Group, Pid) of
        undefined -> F#fighter{is_die = ?false};
        #fighter{hp = OldHp, mp = OldMp} -> F#fighter{hp = OldHp, mp = OldMp, is_die = ?false}
    end;
recover(?combat_type_demon_challenge, F = #fighter{pid = Pid, group = Group}) ->
    case combat:get_original_fighter(Group, Pid) of
        undefined -> F#fighter{is_die = ?false};
        #fighter{hp = OldHp, mp = OldMp} -> F#fighter{hp = OldHp, mp = OldMp, is_die = ?false}
    end;
recover(?combat_type_c_world_compete, F = #fighter{pid = Pid, group = Group}) ->
    case combat:get_original_fighter(Group, Pid) of
        undefined -> F#fighter{is_die = ?false};
        #fighter{hp = OldHp, mp = OldMp} -> F#fighter{hp = OldHp, mp = OldMp, is_die = ?false}
    end;
recover(?combat_type_practice, F = #fighter{pid = Pid, group = Group}) ->
    case combat:get_original_fighter(Group, Pid) of
        undefined -> F#fighter{is_die = ?false};
        #fighter{hp = OldHp, mp = OldMp} -> F#fighter{hp = OldHp, mp = OldMp, is_die = ?false}
    end;
recover(?combat_type_sworn, F = #fighter{pid = Pid, group = Group}) ->
    case combat:get_original_fighter(Group, Pid) of
        undefined -> F#fighter{is_die = ?false};
        #fighter{hp = OldHp, mp = OldMp} -> F#fighter{hp = OldHp, mp = OldMp, is_die = ?false}
    end;
recover(?combat_type_c_boss, F = #fighter{pid = Pid, group = Group, is_die = ?true}) ->
    case combat:get_original_fighter(Group, Pid) of
        undefined -> F#fighter{is_die = ?false};
        #fighter{} -> F#fighter{hp = 1, is_die = ?false}
    end;
recover(?combat_type_cross_king, F = #fighter{pid = Pid, group = group_dfd, is_die = ?false}) ->
    case combat:get_original_fighter(group_dfd, Pid) of
        undefined -> F#fighter{is_die = ?false};
        #fighter{hp_max = HpMax, mp_max = MpMax} -> F#fighter{hp = HpMax, mp = MpMax, is_die = ?false}
    end;
recover(?combat_type_cross_king, F = #fighter{pid = Pid, group = Group, is_die = ?true}) ->
    case combat:get_original_fighter(Group, Pid) of
        undefined -> F#fighter{is_die = ?false};
        #fighter{hp_max = HpMax, mp_max = MpMax} -> F#fighter{hp = HpMax, mp = MpMax, is_die = ?false}
    end;
recover(?combat_type_cross_warlord, F = #fighter{pid = Pid, group = Group}) ->
    case combat:get_original_fighter(Group, Pid) of
        undefined -> F#fighter{is_die = ?false};
        #fighter{hp_max = HpMax, mp_max = MpMax} -> F#fighter{hp = HpMax, mp = MpMax, is_die = ?false}
    end;
recover(?combat_type_lottery_secret, F = #fighter{pid = Pid, group = Group}) ->
    case combat:get_original_fighter(Group, Pid) of
        undefined -> F#fighter{is_die = ?false};
        #fighter{hp = OldHp, mp = OldMp} -> F#fighter{hp = OldHp, mp = OldMp, is_die = ?false}
    end;
recover(?combat_type_train_rob, F = #fighter{pid = Pid, group = Group}) ->
    case combat:get_original_fighter(Group, Pid) of
        undefined -> F#fighter{is_die = ?false};
        #fighter{hp = OldHp, mp = OldMp} -> F#fighter{hp = OldHp, mp = OldMp, is_die = ?false}
    end;
recover(?combat_type_train_arrest, F = #fighter{pid = Pid, group = Group}) ->
    case combat:get_original_fighter(Group, Pid) of
        undefined -> F#fighter{is_die = ?false};
        #fighter{hp = OldHp, mp = OldMp} -> F#fighter{hp = OldHp, mp = OldMp, is_die = ?false}
    end;
recover(_CombatType, F = #fighter{hp_max = HpMax, mp_max = MpMax}) -> 
    case get(is_fighting_guild_boss) of
        true -> F#fighter{hp = HpMax, mp = MpMax, is_die = ?false};
        _ -> F
    end.

%% 获取胜利者的损益参数
get_all_gl_flags(Winner) -> do_get_all_gl_flags(Winner, []).
do_get_all_gl_flags([], L) -> L;
do_get_all_gl_flags([#fighter{gl_flag = GLflag}|T], L) ->
    do_get_all_gl_flags(T, GLflag++L).

do_gains([], Ret) -> [Ret];
do_gains([{_, L} | T], Ret) ->
    Ret1 = Ret ++ L,
    do_gains(T, Ret1).

%% ----------------------------------------------------
%% 胜负者处理
%% ----------------------------------------------------
%% 处理战败者的退出通知
%% 从战败者身上扣除的物品通过Loss变量传入
loser_exit_combat([], _CombatType, _GL, _GLspecial, Rewards, NpcKilled, AssetsList, _GLflag) -> 
    %% ?DEBUG("战败者掉落物品:~w", [Rewards]), 
    {Rewards, NpcKilled, AssetsList};

%% NPC的固定奖励存放在#fighter.rewards中，直接取出即可
%% 同时查询是否有特殊物品掉落
%% 参数Rewards表示额外添加进去的奖励
loser_exit_combat([#fighter{pid = Pid, base_id = NpcBaseId, lev = Lev, type = ?fighter_type_npc, gl_flag = _NpcGLflag} | T], _CombatType, _GL, _GLspecial, Rewards, NpcKilled, AssetsList, GLflag) ->
    #fighter_ext_npc{rewards = R} = combat:f_ext(by_pid, Pid),
    %% 产生NPC掉落的物品
    
    DropRatio = case platform_cfg:get_cfg(drop_ratio) of
        false -> 1;
        Value -> Value / 100
    end,
    NewRatio = erlang:round(100 * DropRatio),
    {Sitems, Items} = case boss_data:get(NpcBaseId) of
        {false, _} -> drop:produce([NpcBaseId], NewRatio);
        _ -> {[], []}
    end,
    ?DEBUG("*******  Items ~w", [Items]),
    S = [SGain || {_, SGain} <- Sitems],   %% 高级货
    [I] = case Items of
        [] -> [[]];
        _ -> do_gains(Items, []) %% [[NGain || NGain <- L] || {_, L} <- Items, length(L) > 0]    %% 一般货
    end,
    
    case get(loser_npc_lev) of
        undefined -> put(loser_npc_lev, Lev);
        _ -> ignore
    end,
    AllRewards = S ++ I ++ R,
    %% 保存怪物掉落的归属信息
    AllRewards1 = [append_owner_info(NpcBaseId, RR) || RR <- AllRewards] ++ Rewards,
    loser_exit_combat(T, _CombatType, _GL, _GLspecial, AllRewards1, [NpcBaseId | NpcKilled], AssetsList, GLflag);

%% 从失败的参战者身上扣除指定的物品或作为本次战斗的奖励
%% TODO:战斗前必须锁定参战者的背包，不能在战斗时转移物品
%% 并通知失败的参战者退出战斗
loser_exit_combat([F = #fighter{pid = Pid, rid = Rid, srv_id = SrvId, name = Name, type = ?fighter_type_role, is_clone = IsClone} | T], CombatType, _GL, GLspecial, Rewards, NpcKilled, AssetsList, GLflag) 
    when IsClone=:=?false   %% 非克隆玩家
    orelse (IsClone=:=?true andalso 
            (CombatType=:=?combat_type_arena_career orelse CombatType=:=?combat_type_demon_challenge) ) ->  %% 中庭战神的克隆玩家, 妖精碎片掠夺
    %%
    NF0 = case F#fighter.result of
        ?combat_result_abort -> F;
        _ -> F#fighter{result = ?combat_result_lost}
    end,
    MyGains = case get({loser_gain, Pid}) of
        undefined -> [];
        K -> K
    end,
    NF = NF0#fighter{gl = MyGains, gl_special = GLspecial},
    LoserData = #role_update_data{fighter = NF, hit_history = combat:get_hit_history(Pid), 
        item_use_history = combat:get_item_use_history(Pid), caught_pets = get_caught_pets(Pid), pet_killed = combat:fetch_pet_killed(Pid), is_winner = false, combat_type = CombatType, is_fighting_super_boss = get(is_fighting_super_boss)},
    case is_pid(Pid) of
        true ->
            case catch role:apply(sync, Pid, {fun combat_over_calc/3, [self(), LoserData]}) of
                {true, L, CaughtPets, _, Assets} ->
                    put({caught_pets, Pid}, CaughtPets),
                    ?DEBUG("战败者[~s, ~w, ~s]退出战斗成功", [Name, Rid, SrvId]),
                    loser_exit_combat(T, CombatType, _GL, GLspecial, L ++ Rewards, NpcKilled, [Assets|AssetsList], GLflag);
                E ->
                    combat_over_offline_calc(LoserData),
                    ?ERR("战败者[~s, ~w, ~s]退出战斗失败: ~w", [Name, Rid, SrvId, E]),
                    loser_exit_combat(T, CombatType, _GL, GLspecial, Rewards, NpcKilled, AssetsList, GLflag)
            end;
        false -> 
            combat_over_offline_calc(LoserData),
            ?ERR("战败者[~s, ~w, ~s]的角色进程在战斗结束时已经不存在，无法回写", [Name, Rid, SrvId]),
            loser_exit_combat(T, CombatType, _GL, GLspecial, Rewards, NpcKilled, AssetsList, GLflag)
    end;
loser_exit_combat([_|T], CombatType, _GL, GLspecial, Rewards, NpcKilled, AssetsList, GLflag) ->
    loser_exit_combat(T, CombatType, _GL, GLspecial, Rewards, NpcKilled, AssetsList, GLflag).


%% 处理胜利者的退出通知
winner_exit_combat([], _CombatType, _GL, _NpcKilled, _RoleKilled, FinalGLs) ->
    FinalGLs1 = [{FighterId, G, L} || {FighterId, _, G, L} <- FinalGLs],
    Fighters = [{FighterId, ConnPid} || {FighterId, ConnPid, _, _} <- FinalGLs],
    lists:foreach(fun({FighterId, ConnPid}) -> 
                FinalGLs2 = filter_teamate_gl(FighterId, FinalGLs1),
                MsgBody = {?combat_result_win, ?TIME_END_CALC, FinalGLs2},
                sys_conn:pack_send(ConnPid, 10790, MsgBody) end, Fighters),
    ok;
winner_exit_combat([#fighter{pid = _Pid, type = ?fighter_type_npc} | T], CombatType, GL, NpcKilled, RoleKilled, FinalGLs) ->
    winner_exit_combat(T, CombatType, GL, NpcKilled, RoleKilled, FinalGLs);
winner_exit_combat([F = #fighter{pid = Pid, rid = Rid, srv_id = SrvId, name = Name, type = ?fighter_type_role, is_clone = IsClone} | T], CombatType, _GL, NpcKilled, RoleKilled, FinalGLs) 
    when IsClone=:=?false   %% 非克隆玩家
    orelse (IsClone=:=?true andalso 
            (CombatType=:=?combat_type_arena_career orelse CombatType=:=?combat_type_demon_challenge) ) ->  %% 中庭战神的克隆玩家, 妖精碎片掠夺
    %%
    MyGains = case get({winner_gain, Pid}) of
        undefined -> [];
        K -> K
    end,
    NF = F#fighter{result = ?combat_result_win, gl = MyGains, npc_killed = NpcKilled},
    WinnerData = #role_update_data{fighter = NF, hit_history = combat:get_hit_history(Pid), 
        item_use_history = combat:get_item_use_history(Pid), caught_pets = get_caught_pets(Pid), pet_killed = combat:fetch_pet_killed(Pid), role_killed = RoleKilled, is_winner = true, combat_type = CombatType, is_fighting_super_boss = get(is_fighting_super_boss)},
    case is_pid(Pid) of
        true ->
            case catch role:apply(sync, Pid, {fun combat_over_calc/3, [self(), WinnerData]}) of
                {true, _L, CaughtPets, FinalGL, _} -> 
                    put({caught_pets, Pid}, CaughtPets),
                    ?DEBUG("胜利者[~s, ~w, ~s]退出战斗成功", [Name, Rid, SrvId]),
                    winner_exit_combat(T, CombatType, _GL, NpcKilled, RoleKilled, [FinalGL|FinalGLs]);
                E -> 
                    combat_over_offline_calc(WinnerData),
                    ?ERR("胜利者[~s, ~w, ~s]退出战斗失败: ~w", [Name, Rid, SrvId, E]),
                    winner_exit_combat(T, CombatType, _GL, NpcKilled, RoleKilled, FinalGLs)
            end;
        false -> 
            combat_over_offline_calc(WinnerData),
            ?ERR("战败者[~s, ~w, ~s]的角色进程在战斗结束时已经不存在，无法回写", [Name, Rid, SrvId]),
            winner_exit_combat(T, CombatType, _GL, NpcKilled, RoleKilled, FinalGLs)
    end;
winner_exit_combat([_| T], CombatType, GL, NpcKilled, RoleKilled, FinalGLs) ->
    winner_exit_combat(T, CombatType, GL, NpcKilled, RoleKilled, FinalGLs).


%% 过滤其他队员的得益
filter_teamate_gl(MyFighterId, FinalGLs) ->
    do_filter_teamate_gl(MyFighterId, FinalGLs, []).
do_filter_teamate_gl(_MyFighterId, [], Result) -> Result;
do_filter_teamate_gl(MyFighterId, [FinalGL = {FighterId, G, L}|T], Result) ->
    case MyFighterId =:= FighterId of
        true -> do_filter_teamate_gl(MyFighterId, T, [FinalGL|Result]);
        false -> %% 过滤掉队友得益信息，只看到队友的物品得益
            NG = [Gain || Gain = {Type, _, _, _} <- G, Type=:=10 orelse Type=:=11],
            do_filter_teamate_gl(MyFighterId, T, [{FighterId, NG, L}|Result])
    end.

%% 获取仙道会比赛类型
get_world_compete_type(Winner, Loser) ->
    L = [Pid || #fighter{pid = Pid, type = Type} <- Winner ++ Loser, Type =:= ?fighter_type_role],
    do_get_world_compete_type(L).
do_get_world_compete_type([]) -> undefined;
do_get_world_compete_type([Pid|T]) ->
    case combat:f_ext(by_pid, Pid) of
        #fighter_ext_role{event = ?event_c_world_compete_11} -> ?WORLD_COMPETE_TYPE_11;
        #fighter_ext_role{event = ?event_c_world_compete_22} -> ?WORLD_COMPETE_TYPE_22;
        #fighter_ext_role{event = ?event_c_world_compete_33} -> ?WORLD_COMPETE_TYPE_33;
        _ -> do_get_world_compete_type(T)
    end.
        

%% ----------------------------------------------------
%% 得益分配
%% ----------------------------------------------------
assign_gains(_WinnerOrLoser, Gains, Winners) when Gains =:= [] orelse Winners =:= [] -> ok;
assign_gains(winner, Gains, Winners) ->
    %% 把得益分类
    classify_gains(Gains),
    %% 分类处理
    lists:foreach(fun(Label) -> do_assign_gains(Label, Winners) end, get(winner_gain_labels)),
    %%lists:foreach(fun(#fighter{name = _Name, pid = _Pid}) -> ?DEBUG("[~s]获得的物品有:~w", [_Name, get({winner_gain, _Pid})]) end, Winners),
    ok;
assign_gains(loser, Gains, Losers) ->
    %% 以前不支持，现在临时简单处理，by qingxuan
    lists:foreach(fun(#fighter{pid = Pid}) -> 
        case get({loser_gain, Pid}) of
            undefined -> put({loser_gain, Pid}, Gains);
            K -> put({loser_gain, Pid}, K ++ Gains)
        end
    end, Losers),
    ok.

classify_gains([]) -> ok;
classify_gains([Gain = #gain{label = Label}|T]) ->
    case get({winner_gains, Label}) of
        undefined -> put({winner_gains, Label}, [Gain]);
        L -> put({winner_gains, Label}, [Gain|L])
    end,
    case get(winner_gain_labels) of
        undefined -> put(winner_gain_labels, [Label]);
        K ->
            case lists:member(Label, K) of
                true -> ignore;
                false -> put(winner_gain_labels, [Label | K])
            end
    end,
    classify_gains(T).

do_assign_gains(Label, Winners)
when (Label =:= exp) orelse
(Label =:= exp_npc) orelse
(Label =:= coin) orelse 
(Label =:= coin_bind) orelse 
(Label =:= psychic) orelse
(Label =:= psychic_npc) orelse
(Label =:= attainment) orelse
(Label =:= stone)
->  %% 按照经验公式计算
    case get({winner_gains, Label}) of
        undefined -> ok;
        L ->
            N = length(Winners),
            lists:foreach(
                fun(F = #fighter{pid = Pid, lev = Lev}) ->
                        L1 = filter_special_npc_rewards(L, F),
                        Total = lists:sum([Val || #gain{val = Val} <- L1]),
                        Per = Total / N * (1 + 0.4 * (N - 1)),
                        Ratio = case get(loser_npc_lev) of
                            undefined -> 1;
                            NpcLev ->
                                Sub = erlang:abs(Lev - NpcLev),
                                case Sub > 5 of
                                    true -> erlang:max(0.1, 1 - ((Sub-5)/5));
                                    false -> 1
                                end
                        end,
                        MyGain = #gain{label = Label, val = round(Per * Ratio)},
                        case get({winner_gain, Pid}) of
                            undefined -> put({winner_gain, Pid}, [MyGain]);
                            K -> put({winner_gain, Pid}, [MyGain | K])
                        end
                end, Winners)
    end;
do_assign_gains(Label, Winners) 
when (Label =:= gold) orelse (Label =:= gold_bind) 
->  %% 均分
    case get({winner_gains, Label}) of
        undefined -> ok;
        L ->
            N = length(Winners),
            lists:foreach(fun(F = #fighter{pid = Pid}) ->
                        L1 = filter_special_npc_rewards(L, F),
                        Total = lists:sum([Val || #gain{val = Val} <- L1]),
                        Per = round(Total / N),
                        MyGain = #gain{label = Label, val = Per},
                        case get({winner_gain, Pid}) of
                            undefined -> put({winner_gain, Pid}, [MyGain]);
                            K -> put({winner_gain, Pid}, [MyGain | K])
                        end
                end, Winners)
    end;
do_assign_gains(Label, Winners) 
when (Label =:= honor) orelse (Label =:= energy)
->  %% 每个人都一样
    case get({winner_gains, Label}) of
        undefined -> ok;
        L ->
            lists:foreach(fun(F = #fighter{pid = Pid}) ->
                        L1 = filter_special_npc_rewards(L, F),
                        Total = lists:sum([Val || #gain{val = Val} <- L1]),
                        MyGain = #gain{label = Label, val = Total},
                        case get({winner_gain, Pid}) of
                            undefined -> put({winner_gain, Pid}, [MyGain]);
                            K -> put({winner_gain, Pid}, [MyGain | K])
                        end
                end, Winners)
    end;
do_assign_gains(Label, Winners) 
when (Label =:= item) orelse (Label =:= item_chg) 
-> %% 物品分配法
    case get({winner_gains, Label}) of
        undefined -> ok;
        L ->
            %% 为每一个物品挑选拾取者
            lists:foreach(fun(Item) -> 
                        %% Pid = choose_picker(Winners),
                        [
                        if 
                            Pid =/= undefined ->
                                case get({winner_gain, Pid}) of
                                    undefined -> put({winner_gain, Pid}, [Item]);
                                    K -> put({winner_gain, Pid}, [Item | K])
                                end;
                            true -> 
                                ?ERR("choose_picker returns undefined!")
                        end
                        || #fighter{pid = Pid} <- Winners ]
                end, L),
            %% 对每一个拾取者过滤掉达到刷怪上限获得的物品
            lists:foreach(fun(F = #fighter{pid = Pid}) ->
                        Rewards = case get({winner_gain, Pid}) of
                            undefined -> [];
                            K1 -> K1
                        end,
                        Rewards1 = filter_special_npc_rewards(Rewards, F),
                        put({winner_gain, Pid}, Rewards1)
                end, Winners)
    end;

do_assign_gains(Label, Winners) 
when (Label =:= fragile)  
-> %% 碎片分配法
    case get({winner_gains, Label}) of
        undefined -> ok;
        L ->
            %% 为每一个物品挑选拾取者
            lists:foreach(fun(Item) -> 
                        Pid = choose_picker(Winners),
                        if 
                            Pid =/= undefined ->
                                case get({winner_gain, Pid}) of
                                    undefined -> put({winner_gain, Pid}, [Item]);
                                    K ->
                                        case lists:keyfind(fragile, #gain.label, K) of
                                            #gain{} -> skip;
                                            false ->
                                                put({winner_gain, Pid}, [Item | K])
                                        end
                                end;
                            true -> 
                                ?ERR("choose_picker returns undefined!")
                        end
                end, L),
            %% 对每一个拾取者过滤掉达到刷怪上限获得的物品
            lists:foreach(fun(F = #fighter{pid = Pid}) ->
                        Rewards = case get({winner_gain, Pid}) of
                            undefined -> [];
                            K1 -> K1
                        end,
                        Rewards1 = filter_special_npc_rewards(Rewards, F),
                        put({winner_gain, Pid}, Rewards1)
                end, Winners)
    end;


do_assign_gains(Label, _Winners) ->
    ?ERR("未知的得益物品类型:~w", [Label]).

%% 选择拾取者
choose_picker([]) -> undefined;
choose_picker(Fighters) ->
    Pids = case erlang:get(item_pickers) of
        undefined -> [Pid || #fighter{pid = Pid} <- Fighters];
        [] -> [Pid || #fighter{pid = Pid} <- Fighters];
        K -> K
    end,
    N = length(Pids),
    SelPid = do_choose_picker(Pids, Pids, N, (util:rand(1, 100) rem N)),
    erlang:put(item_pickers, Pids--[SelPid]),
    SelPid.

do_choose_picker([], L, N, M) when N > M ->
    do_choose_picker(L, L, N-1, M);
do_choose_picker([], [H|_T], M, M) ->
    H;
do_choose_picker([H|_T], _L, M, M) ->
    H;
do_choose_picker([_H|T], L, N, M) when N > M ->
    do_choose_picker(T, L, N-1, M).

%% 格式化损益
format_gl(G, L, []) -> {G, L};
format_gl(G, L, [H|T]) ->
    case do_format_gl(H) of
        undefined -> format_gl(G, L, T);
        {gain, R} -> format_gl([R|G], L, T);
        {loss, R} -> format_gl(G, [R|L], T)
    end.

do_format_gl(Rec) when is_record(Rec, gain) ->
    case Rec of
        %% 因为背包满的也显示在战斗结算面板-_-!!!
        #gain{label = Label, val = Val, err_code = ErrCode} when ErrCode =:= ?gain_no_error orelse ErrCode =:= ?gain_bag_full ->
            Flag = case ErrCode of
                ?gain_no_error -> 0;
                ?gain_bag_full -> 1
            end,
            R = case Label of
                exp -> {0, 0, Val, Flag};
                exp_npc -> {0, 0, Val, Flag};
                exp_per -> {1, 1, Val, Flag};
                gold -> {2, 2, Val, Flag};
                gold_bind -> {2, 2, Val, Flag};
                coin -> {3, 3, Val, Flag};
                coin_bind -> {3, 3, Val, Flag};
                coin_all -> {3, 3, Val, Flag};
                psychic -> {4, 4, Val, Flag};
                psychic_npc -> {4, 4, Val, Flag};
                psychic_per -> {5, 5, Val, Flag};
                honor -> {6, 6, Val, Flag};
                energy -> {7, 7, Val, Flag};
                attainment -> {8, 8, Val, Flag};
                guild_contrib -> {9, 9, Val, Flag};
                item -> 
                    case Val of
                        [BaseId, 1, Quantity] -> {11, BaseId, Quantity, Flag};
                        [BaseId, _, Quantity] -> {10, BaseId, Quantity, Flag};
                        _ -> undefined
                    end;
                stone -> {12, 12, Val, Flag};
                scale -> {13, 13, Val, Flag}; %% 龙鳞
                fragile -> %% 妖精碎片
                    [BaseId, Num] = Val,
                    {14, BaseId, Num, Flag};
                badge -> {15, 15, Val, Flag};
                _ -> ?ERR("不支持的物品类型:~w", [Label]), undefined
            end,
            {gain, R};
        _ -> undefined
    end;
do_format_gl(Rec) when is_record(Rec, loss) ->
    #loss{label = Label, val = Val} = Rec,
    Flag = 0,
    R = case Label of
        exp -> {0, 0, Val, Flag};
        exp_npc -> {0, 0, Val, Flag};
        exp_per -> {1, 1, Val, Flag};
        gold -> {2, 2, Val, Flag};
        gold_bind -> {2, 2, Val, Flag};
        coin -> {3, 3, Val, Flag};
        coin_bind -> {3, 3, Val, Flag};
        coin_all -> {3, 3, Val, Flag};
        psychic -> {4, 4, Val, Flag};
        psychic_npc -> {4, 4, Val, Flag};
        psychic_per -> {5, 5, Val, Flag};
        honor -> {6, 6, Val, Flag};
        energy -> {7, 7, Val, Flag};
        attainment -> {8, 8, Val, Flag};
        guild_contrib -> {9, 9, Val, Flag};
        item -> 
            case Val of
                [BaseId, 1, Quantity] -> {11, BaseId, Quantity, Flag};
                [BaseId, _, Quantity] -> {10, BaseId, Quantity, Flag};
                _ -> undefined
            end;
        stone -> {12, 12, Val, Flag};
        scale -> {13, 13, Val, Flag}; %% 龙鳞
        _ -> ?ERR("不支持的物品类型:~w", [Label]), undefined
    end,
    {loss, R};
do_format_gl(Rec) ->
    ?ERR("格式化损益错误:~w", [Rec]),
    undefined.

%% 调用杀怪触发器
do_kill_npc([], Role) -> Role;
do_kill_npc([H | T], Role) -> 
    {NewRole, NpcBaseId} = case npc_data:get(H) of
        {ok, #npc_base{id = BaseId, fun_type = ?npc_fun_type_frenzy}} ->
            {role_listener:special_event(Role, {1043, finish}), BaseId};
        _ ->
            {Role, H}
    end,
    do_kill_npc(T, role_listener:kill_npc(NewRole, NpcBaseId, 1));
do_kill_npc(_, Role) -> Role.
 
%% 处理普通损益，成功一个算一个，不成功的不作处理了
do_gain_loss([], Role, RealGL, FailedGL) -> {Role, RealGL, FailedGL};
do_gain_loss([H = #gain{label = item, val = [ItemBaseId, _Bind, _Quantity], misc = Misc} | T], Role = #role{id = Id, career = Career}, RealGL, FailedGL) when ItemBaseId >= 50000 andalso ItemBaseId =< 60000 ->
    case drop_data_mgr:career_item(ItemBaseId, Career) of
        {ok, #drop_rule_career{item_id = NewItemBaseId, bind = Bind, notice = Notice}} ->
            Misc2 = case Notice of
                1 -> 
                    case lists:keyfind(drop_notice, 1, Misc) of
                        {drop_notice, {NpcBaseId, _, _}} -> [{drop_notice, {NpcBaseId, NewItemBaseId, Bind}}];
                        false -> []
                    end;
                _ -> []
            end,
            H2 = #gain{label = item, val = [NewItemBaseId, Bind, 1], misc = Misc2},
            case role_gain:do([H2], Role) of
                {false, H3} -> 
                    award:send(Id, 104009, [H2]),
                    do_gain_loss(T, Role, RealGL, [H3|FailedGL]);
                {ok, NewRole} -> 
                    case role_gain:do_misc(Misc2, NewRole) of
                        {ok, NewRole2} -> do_gain_loss(T, NewRole2, [H2|RealGL], FailedGL);
                        _ -> do_gain_loss(T, NewRole, [H2|RealGL], FailedGL)
                    end;
                _Else -> ?ERR("处理损益失败:~w", [_Else])
            end;
        {false, _Reason} ->
            ?ERR("掉落数据有误，不存在职业物品信息[ItemBaseId:~w, Career:~w]", [ItemBaseId, Career]),
            do_gain_loss(T, Role, RealGL, [H |FailedGL])
    end;
do_gain_loss([H = #gain{label = item, misc = Misc} | T], Role = #role{id = Id}, RealGL, FailedGL) ->
    case do_add_item(H, Role) of
        {false, H2} ->
            award:send(Id, 104009, [H2]),
            do_gain_loss(T, Role, RealGL, [H2|FailedGL]);
        {ok, NewRole} -> 
            case role_gain:do_misc(Misc, NewRole) of
                {ok, NewRole2} -> do_gain_loss(T, NewRole2, [H|RealGL], FailedGL);
                _ -> do_gain_loss(T, NewRole, [H|RealGL], FailedGL)
            end;
        _Else -> ?ERR("处理损益失败:~w", [_Else])
    end;
do_gain_loss([H | T], Role = #role{id = Id}, RealGL, FailedGL) ->
    case role_gain:do([H], Role) of
        {false, H2} ->
            award:send(Id, 104009, [H2]),
            do_gain_loss(T, Role, RealGL, [H2|FailedGL]);
        {ok, NewRole} -> 
            do_gain_loss(T, NewRole, [H|RealGL], FailedGL);
        _Else -> ?ERR("处理损益失败:~w", [_Else])
    end.

%% 处理特殊损益，扣除成功的物品等作为奖励
do_gain_loss_sp([], Role, RealGL, FailedGL) -> {Role, RealGL, FailedGL};
do_gain_loss_sp([H | T], Role = #role{id = Id}, RealGL, FailedGL) ->
    case role_gain:do([H], Role) of
        {false, H2} -> 
            award:send(Id, 104009, [H2]),
            do_gain_loss_sp(T, Role, RealGL, [H2|FailedGL]);
        {ok, NewRole} -> do_gain_loss_sp(T, NewRole, [role_gain:convert(H) | RealGL], FailedGL);
        _Else -> ?ERR("处理特殊损益失败:~w", [_Else])
    end.

%% 掉落物品堆叠数必须为1, 否则会有问题
do_add_item(H = #gain{label = item, val = [ItemBaseId, Bind, _]}, Role) ->
    case do_find_add(ItemBaseId, Bind, Role) of
        false ->
            ?DEBUG("无法堆叠物品,或者之前没有该物品:ItemBaseId:~w",[ItemBaseId]),
            case role_gain:do([H], Role) of
                {false, H2} -> {false, H2};
                {ok, NewRole} -> {ok, NewRole}
            end;
        NewRole when is_record(NewRole, role) ->
            {ok, NewRole};
        _Err -> ?ERR("处理堆叠物品时失败:~w",[_Err])
    end.

do_find_add(ItemBaseId, Bind, Role = #role{link = #link{conn_pid = ConnPid}, bag = Bag = #bag{items = Items}}) ->
    case item_data:get(ItemBaseId) of
        {ok, #item_base{overlap = 1}} -> false;
        {ok, #item_base{overlap = OverLap}} ->
            case get_same_items(ItemBaseId, Bind, OverLap, Items) of
                false -> false;
                MinPosItem = #item{quantity = Q} ->
                    NewItem = MinPosItem#item{quantity = Q + 1},
                    NewItems = lists:keyreplace(MinPosItem#item.id, #item.id, Items, NewItem),
                    storage_api:refresh_single(ConnPid, {?storage_bag, NewItem}),
                    ?DEBUG("~w堆叠成功,新的数量为:~w",[ItemBaseId,Q+1]),
                    Role#role{bag = Bag#bag{items = NewItems}}
            end;
        _ -> false
    end.

get_same_items(ItemBaseId, Bind, OverLap, Items) ->
    get_same_items(ItemBaseId, Bind, OverLap, Items, 0).
get_same_items(_ItemBaseId, _Bind, _OverLap, [], 0) -> false;
get_same_items(_ItemBaseId, _Bind, _OverLap, [], MinPosItem) -> MinPosItem;
get_same_items(ItemBaseId, Bind, OverLap, [Item = #item{base_id = ItemBaseId, bind = Bind, quantity = Q} | T], 0) 
when Q < OverLap ->
    get_same_items(ItemBaseId, Bind, OverLap, T, Item);
get_same_items(ItemBaseId, Bind, OverLap, [Item = #item{pos = Pos1, base_id = ItemBaseId, bind = Bind, quantity = Q} | T], #item{pos = Pos2}) when Q < OverLap andalso Pos1 < Pos2 ->
    get_same_items(ItemBaseId, Bind, OverLap, T, Item);
get_same_items(ItemBaseId, Bind, OverLap, [_ | T], MinPosItem) ->
    get_same_items(ItemBaseId, Bind, OverLap, T, MinPosItem).


%% ----------------------------------------------------
%% 角色数据回写
%% ----------------------------------------------------
%% 战斗结束时进行战斗结算
%% GL: 普通的损益数据，比如获得或损失的经验，灵力，金币等
%% GLSpecial: 特殊的损益数据，比如要扣除后奖励给胜利者的物品
combat_over_calc(
    Role = #role{combat_pid = P, link = #link{conn_pid = ConnPid}, combat = CombatParams, assets = Assets},
    CombatPid,
    #role_update_data{fighter = #fighter{id = FighterId, rid = Rid, srv_id = SrvId, name = _Name, gl = GL1, gl_special = GLspecial, is_escape = IsEscape, result = Result, last_skill = LastSkill}, item_use_history = ItemUseHistory, skill_history = _SkillHistory, pet_killed = _PetKilled, role_killed = _RoleKilled, is_winner = _IsWinner, combat_type = _CombatType}
) ->
    case is_pid(P) of
        true when CombatPid =/= P -> {ok, false};
        _ ->
            %% 处理损益
            {Role1, RealGL, FailedGL} = do_gain_loss(GL1, Role, [], []),
            {Role3, RealSpecialGL, FailedSpecialGL} = do_gain_loss_sp(GLspecial, Role1, [], []),
            CaughtPets = [],

            %% 处理背包修改
            #role{bag = Bag} = Role3,
            ItemUseResult = case ItemUseHistory of
                [_|_] -> storage:del(Bag, ItemUseHistory);
                _ -> false
            end,
            Role4 = case ItemUseResult of
                {ok, NewStorage, DelList, FreshList} when is_record(NewStorage, bag) ->
                    %% 推送物品使用情况给玩家
                    storage_api:refresh_client([{?storage_bag, [], DelList, FreshList}], ConnPid),
                    Role3#role{bag = NewStorage};
                false -> Role3;
                _Err ->
                    ?ERR("[~s]背包回写出错:~w", [_Name, _Err]),
                    Role3
            end,

            %% 记录战斗的一些信息
            LastCombatResult = case Result of
                ?combat_result_win -> ?combat_result_win;
                _ -> 
                    case IsEscape of
                        ?true -> ?combat_result_escape;
                        ?false -> ?combat_result_lost
                    end
            end,
            OldLastSkill = combat_util:match_param(last_skill, CombatParams, 0),
            LastSkill1 = case combat:is_illegal_auto_skill(LastSkill) of
                true -> OldLastSkill;
                false -> LastSkill
            end,
            %%?DEBUG("[~s]特殊怪物击杀计数:~w", [_Name, SpecialNpcKilledCount1]),
            CombatExts = [{last_combat_time, erlang:now()}, {last_combat_result, LastCombatResult}, {last_skill, LastSkill1}, {special_npc_killed_count, 1}],
            CombatParams1 = combat_util:update_role_combat(CombatExts, CombatParams),
            Role10 = Role4#role{combat = CombatParams1},

            %% 格式化损益数据并通知客户端播放结算面板
            {G, L} = format_gl([], [], RealGL ++ RealSpecialGL ++ FailedGL ++ FailedSpecialGL),
            if
                Result =:= ?combat_result_abort -> %% 中断
                    sys_conn:pack_send(ConnPid, 10790, {?combat_result_abort, 0, []});
                Result =/= ?combat_result_win andalso IsEscape=:=?false ->
                    MsgBody = {Result, ?TIME_END_CALC, [{FighterId, G, L}]},
                    sys_conn:pack_send(ConnPid, 10790, MsgBody);
                true ->
                    ignore
            end,

            case has_bag_full_item(FailedGL ++ FailedSpecialGL) of
                true ->
                    %%notice:inform(RolePid, ?L(<<"您的背包已满，不能获得物品">>));
                    notice:alert(error, Role10, ?MSGID(<<"背包已满，奖励发送到奖励大厅">>));
                false -> ignore
            end,

            %% 把部分掉落记录到日志里
            LogGL = get_log_gl(RealGL ++ RealSpecialGL, []),
            log:log(log_item_drop, {LogGL, Rid, SrvId, _Name}),
            
            MyGLInfo = {FighterId, ConnPid, G, L},
            MyAsset = {FighterId, Rid, SrvId, Assets},
            {ok, {true, RealSpecialGL, CaughtPets, MyGLInfo, MyAsset}, Role10}
    end.

%% 中庭战神-离线-输
combat_over_offline_calc(#role_update_data{
        combat_type = ?combat_type_arena_career, 
        is_winner = false, 
        fighter = #fighter{rid = Rid, srv_id = SrvId}}) ->
    offline_gain:send({Rid, SrvId}, arena_career:combat_award(loser)),
    ok;
%% 中庭战神-离线-赢
combat_over_offline_calc(#role_update_data{
        combat_type = ?combat_type_arena_career, 
        is_winner = true, 
        fighter = #fighter{rid = Rid, srv_id = SrvId}}) ->
    offline_gain:send({Rid, SrvId}, arena_career:combat_award(winner)),
    ok;
combat_over_offline_calc(_) ->
    ok.

%% 判断是否有因为背包满了而获取不到的物品
has_bag_full_item([]) -> false;
has_bag_full_item([#gain{err_code = ?gain_bag_full}|_T]) -> true;
has_bag_full_item([_|T]) -> has_bag_full_item(T).

%% 挑选出需要记录到掉落日志的物品
get_log_gl([], L) -> L;
get_log_gl([G = #gain{label = Label, val = Val}|T], L) when Label =:= item orelse Label =:= item_chg ->
    case get_owner_info(G) of
        undefined -> get_log_gl(T, L);
        NpcBaseId -> 
            case Val of
                [ItemBaseId, _, _] -> get_log_gl(T, [{NpcBaseId, ItemBaseId}|L]);
                _ -> get_log_gl(T, L)
            end
    end;
get_log_gl([_|T], L) -> get_log_gl(T, L).

%%------------------------------------------------------------------------
%% 防刷怪
%%------------------------------------------------------------------------
need_filter_special_npc_rewards(SpecialNpcKilledCount, NpcBaseId) ->
    case is_over_killed_special_npc(SpecialNpcKilledCount) of
        true -> is_special_npc(NpcBaseId);
        false -> false
    end.

is_over_killed_special_npc(SpecialNpcKilledCount) ->
    SpecialNpcKilledCount >= ?combat_special_npc_kill_max.

is_special_npc(NpcBaseId) ->
    case npc_data:get(NpcBaseId) of
        {ok, #npc_base{looks_type = LooksType}} when LooksType=:=3 orelse LooksType=:=4 orelse LooksType=:=9 -> 
            true;
        _ -> false
    end.

%% 给掉落加上来源信息
append_owner_info(NpcBaseId, Gain = #gain{misc = Misc}) ->
    Gain#gain{misc = [{owned_by_npc, NpcBaseId}|Misc]};
append_owner_info(NpcBaseId, Loss = #loss{misc = Misc}) ->
    Loss#loss{misc = [{owned_by_npc, NpcBaseId}|Misc]}.

%% 获取掉落的来源信息
get_owner_info(#gain{misc = Misc}) ->
    case lists:keyfind(owned_by_npc, 1, Misc) of
        {owned_by_npc, NpcBaseId} -> NpcBaseId;
        _ -> undefined
    end;
get_owner_info(#loss{misc = Misc}) ->
    case lists:keyfind(owned_by_npc, 1, Misc) of
        {owned_by_npc, NpcBaseId} -> NpcBaseId;
        _ -> undefined
    end;
get_owner_info(_) -> undefined.

filter_special_npc_rewards(Rewards, F) ->
    do_filter_special_npc_rewards(Rewards, F, []).
do_filter_special_npc_rewards([], _, L) -> L;
do_filter_special_npc_rewards([G|T], F = #fighter{special_npc_killed_count = SpecialNpcKilledCount}, L) ->
    case get_owner_info(G) of
        undefined -> do_filter_special_npc_rewards(T, F, [G|L]);
        NpcBaseId -> 
            case need_filter_special_npc_rewards(SpecialNpcKilledCount, NpcBaseId) of
                true -> do_filter_special_npc_rewards(T, F, L);
                false -> do_filter_special_npc_rewards(T, F, [G|L])
            end
    end.

%%-------------------------------------------------------------------------------------------------------------


%% 战斗完毕离开战斗时回写状态和场景广播
do_combat_over_leave(Role = #role{combat_pid = P, pos = Pos = #pos{map_pid = MapPid, x = X, y = Y}}, #combat{type = CombatType, pid = CombatPid}, F = #fighter{type = ?fighter_type_role, is_escape = IsEscape}, NpcKilled, _CaughtPets) ->
    case is_pid(P) of
        true when CombatPid =/= P -> {ok, false};
        _ ->
            Role1 = Role#role{status = ?status_normal, combat_pid = 0},
            Role2 = #role{status = _NewStatus} = status_update(CombatType, Role1, F),
            %% 宠物回血回蓝
            Role22 = pet_status_update(Role2),
            %% 属性更新
            Role3 = role_api:push_attr(Role22),
            %% 处理杀死怪物
            Role6 = do_kill_npc(NpcKilled, Role3),
            %%更新场景角色状态
            map:role_update(Role6),
            %% 逃跑时，坐标重置
            Role7 = case IsEscape of
                ?true -> 
                    NewX = X - 420,
                    map:role_jump(MapPid, self(), X, Y, NewX, Y),
                    Role6#role{pos = Pos#pos{x = NewX}};
                _ -> Role6
            end,
            %% 新手剧情副本（完成并退出副本）
            Role8 = tutorial:check_finish(Role7, NpcKilled),
            {ok, true, Role8}
    end;
do_combat_over_leave(_, _, _, _, _) -> ok.

%%-----------------------------------------------------
%% 根据战斗类型来处理气血、魔法和状态等
%%-----------------------------------------------------
status_update(_X, Role = #role{hp_max = RoleHpMax, mp_max = RoleMpMax}, #fighter{}) ->
    Role#role{status = ?status_normal, hp = RoleHpMax, mp = RoleMpMax}.

pet_status_update(Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{attr = PetAttr}}}) ->
    Role#role{pet = PetBag#pet_bag{
        active = Pet#pet{
            attr = PetAttr#pet_attr{
                hp = PetAttr#pet_attr.hp_max
                ,mp = PetAttr#pet_attr.mp_max
            }
        }
    }};
pet_status_update(Role) ->
    Role.

%% 设置杀boss次数
set_killboss_counter(Role = #role{anticrack = Anticrack}, Counter) ->
    {ok, Role#role{anticrack = Anticrack#anticrack{boss_counter = Counter}}}.
