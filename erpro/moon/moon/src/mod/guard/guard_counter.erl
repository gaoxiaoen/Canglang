%%----------------------------------------------------
%%  洛水反击
%% @author shawn 
%%----------------------------------------------------

-module(guard_counter).
-behaviour(gen_fsm).

-include("common.hrl").
-include("guard.hrl").
-include("role.hrl").
-include("looks.hrl").
-include("team.hrl").
-include("map.hrl").
-include("combat.hrl").
-include("assets.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("npc.hrl").

-export([
        idel/2 %%空闲状态
        ,attack/2 %% 进攻状态
        ,atk_boss/2 %% 击杀穷奇状态
        ,expire/2 %% 结算状态
    ]
).

-export([
        combat_start/1
        ,move_disturb/1
        ,click_elem/2
        ,apply_click/2
        ,get_current_status/0
        ,do_revive_and_exit_combat_area/1
        ,do_exit_combat_area/1
        ,start/0
        ,kill_normal/4
        ,m/2
        ,hit_boss/2
        ,get_status/1
        ,is_boss/1
        ,login/3
        ,logout/2
        ,npc_return/3
        ,get_npc_die_cd/0
        ,get_rand_patrol/0
        ,keys_sort/2
    ]
).

-record(state, {
        map_pid = 0         %% 地图进程ID
        ,map_id = 0         %% 地图Id
        ,role_size = 0      %% 角色数量
        ,role_list = []     %% 进入活动的角色
        ,clickers = []      %% 采集中的玩家列表
        ,elems = []         %% 封印元素ID列表
        ,ts = 0             %% 进入某状态的时刻
        ,timeout = 0        %% 超时时间
        ,end_time = 0       %% 结束时间
        ,lev = 0
        ,boss = {}
        ,guard_super_boss   %% 巨龙
        ,npc_id = 0
    }
).

-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

get_rand_patrol() ->
    2500 + util:rand(-20, 600).

get_npc_die_cd() -> 10000.

npc_return(Npc, X, Y) ->
    {Path, NextX, NextY} = find_min_road(X, Y),
    {Npc#npc{path = Path}, NextX, NextY}.

find_min_road(X, Y) ->
    find_min_road(X, Y, [], road()).

road() ->
    [{1,780,900}, {2,1260,1140}, {3,1740,1440}, {4,2220,1740}, {5,2820,2040}, {6,3420,2340}, {7,4020,2610}, {8,4440,2940}, {9,4980,3270}, {10,5460,3600}, {11,960,810}, {12,1380,1050}, {13,1860,1350}, {14,2340,1650}, {15,2940,1950}, {16,3540,2250}, {17,4140,2520}, {18,4560,2580}, {19,5100,3180}, {20,5580,3510}, {21,1140,690}, {22,1560,930}, {23,2040,1230}, {24,2520,1530}, {25,3120,1830}, {26,3720,2130}, {27,4320,2400}, {28,4740,2730}, {29,5280,3060}, {30,5760,3390}, {31,1320,600}, {32,1740,840}, {33,2160,1140}, {34,2640,1440}, {35,3240,1740}, {36,3840,2040}, {37,4440,2310}, {38,4860,2640}, {39,5400,2970}, {40,5880,3330}].

%% 没有发现 
find_min_road(X, Y, [], []) -> {[{-1, -1}], X, Y};
find_min_road(X, Y, Roads, []) ->
    Roads1 = keys_sort(1, Roads),
    NewRoads = lists:sublist(Roads1, 3),
    case util:rand_list(NewRoads) of
        {PathNum, _, NextX, NextY} ->
            {guard_counter_data:get_return_road(PathNum), NextX, NextY};
        _ ->
            {[{-1, -1}], X, Y}
    end;

find_min_road(X, Y, Roads, [{PathNum, NextX, NextY} | T]) ->
    Dx = math:pow(X - NextX, 2),
    Dy = math:pow(Y - NextY, 2),
    NewLen = Dx + Dy,
    find_min_road(X, Y, [{PathNum, NewLen, NextX, NextY} | Roads], T).

keys_sort(N, TupleList) ->
    do_keys_sort(get_sort_key(N), TupleList).
do_keys_sort([],TupleList) -> TupleList;
do_keys_sort([H|T], TupleList) ->
    NewTupleList = lists:keysort(H, TupleList),
    do_keys_sort(T,NewTupleList).

%% 获取排行榜排序key
get_sort_key(1) -> [2].

combat_start({Refrees, Fighters}) ->
    case lists:keyfind(guard_counter, 1, Refrees) of
        {_, EventPid} ->
            EventPid ! {disturb, Fighters};
        _ -> ok
    end;
combat_start(_) -> ok.

check_follow(#role{team = #role_team{is_leader = 1}}) -> true;
check_follow(#role{team = #role_team{follow = 1}}) -> false;
check_follow(_) -> true.

click_elem(Role = #role{id = Rid, pid = Pid, event_pid = Epid}, #map_elem{id = Id}) ->
    case is_pid(Epid) andalso check_follow(Role) of
        true -> Epid ! {click, Rid, Pid, Id};
        _ -> ok
    end.

is_boss(22138) -> true;
is_boss(_) -> false.

m(Pid, Event) ->
    gen_fsm:send_event(Pid, Event).

get_current_status() ->
    gen_fsm:sync_send_all_state_event(?MODULE, get_current_status).

login(ZonePid, RoleId, Pid) ->
    gen_fsm:sync_send_all_state_event(ZonePid, {login, RoleId, Pid}).

logout(ZonePid, RoleId) when is_pid(ZonePid) ->
    ZonePid ! {disturb, [RoleId]};
logout(_, _) -> skip.

get_status(Pid) ->
    gen_fsm:sync_send_all_state_event(Pid, get_status).

hit_boss(TotalDmg, RoleDmgList) ->
    gen_fsm:send_all_state_event(?MODULE, {hit, TotalDmg, RoleDmgList}).

start() ->
    case catch gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []) of
        {ok, GuardPid} ->
            {ok, GuardPid};
        _Err ->
            ?DEBUG("开启洛水反击异常:~w",[_Err]),
            {false, ?L(<<"开启洛水反击异常">>)}
    end.

kill_normal(EventPid, Referees, Winner, Loser) ->
    %% 计算小怪积分
    case [{Rid, SrvId} || #fighter{rid = Rid, srv_id = SrvId, type = ?fighter_type_role} <- Winner] of
        L = [_|_] -> 
            Point = case lists:keyfind(guard_counter_base_id, 1, Referees) of
                false -> 0;
                {guard_counter_base_id, BaseId} ->
                    guard_counter_data:to_point(BaseId)
            end,
            gen_fsm:send_all_state_event(EventPid, {kill_normal, L, Point});
        _ -> skip
    end,
    D = [{Rid, SrvId, Pid} || #fighter{rid = Rid, srv_id = SrvId, pid = Pid, type = ?fighter_type_role, is_die = ?true} <- Loser],
    %% 统计死亡名单
    case D of
        [_|_] ->
            EventPid ! {combat_over, D};
        _ ->
            skip
    end,
    %% 更新NPC状态
    case lists:keyfind(common, 1, Referees) of
        {common, MapPid} -> reappear_npc(MapPid, Winner);
        _ -> skip
    end.

%% 若npc胜利，npc重新显示
reappear_npc(MapPid, Winner) when is_pid(MapPid) ->
    case lists:keyfind(?fighter_type_npc, #fighter.type, Winner) of
        false -> skip;
        #fighter{pid = Pid} ->
            case combat:f_ext(by_pid, Pid) of
                #fighter_ext_npc{npc_id = NpcId} ->
                    case npc_mgr:lookup(by_id, NpcId) of
                        false -> false;
                        Npc -> map:npc_update(MapPid, npc_convert:do(to_map_npc, Npc#npc{status = 0}))
                    end;
                _ -> false
            end
    end;
reappear_npc(_, _) -> false.

%% -------------------------------------------------------------
init([]) ->
    ?DEBUG("创建洛水反击进程"),
    process_flag(trap_exit, true),
    case map_mgr:create(34002) of
        {false, Reason} ->
            ?ERR("创建洛水反击地图失败:~s", [Reason]),
            {stop, normal, #state{}};
        {ok, MapPid, MapId} ->
            Now = util:unixtime(),
            State = #state{map_pid = MapPid, map_id = MapId, ts = erlang:now(), timeout = 300 * 1000, elems = [604651], end_time = Now + 2100},
            ?DEBUG("[~w] 启动完成", [?MODULE]),
            %%  进程持续时间为35分钟
            notice:send(54, ?L(<<"洛水反击之战将在5分钟后开启，众仙友请准备好，打响洛水反击之战！">>)),
            erlang:send_after(2100 * 1000, self(), time_stop),
            guard_mgr:guard_counter_start(self()),
            role_group:pack_cast(world, 15412, {1, 300}), 
            {ok, idel, State, 300 * 1000}
    end.

%% 玩家造成伤害
handle_event({hit, DmgHp, RoleDmgList}, atk_boss, State = #state{guard_super_boss = GuardBoss, npc_id = NpcId, map_id = MapId}) ->
    NewGuardBoss = #guard_super_boss{is_die = IsDie} = update_boss(GuardBoss, DmgHp),
    case IsDie of
        ?true ->
            Bin = to_role_name(RoleDmgList), 
            notice:send(54, util:fbin(?L(<<"仙友~s面对穷奇这样的巨魔，居然轻松写意，随手一挥，轻松毙敌于剑下，真乃众仙之偶像！">>), [Bin])),
            NewState = record_dmg(RoleDmgList, State), 
            %% 巨龙已死
            catch npc_mgr:remove(NpcId),
            stop_combat(State),
            role_group:pack_cast(world, 15412, {0, 0}), 
            map:pack_send_to_all(MapId, 15410, {?true, 0, ?guard_counter_boss_hp}),
            map:pack_send_to_all(MapId, 15419, {}),
            {next_state, expire, NewState#state{ts = erlang:now(), timeout = 4 *1000, guard_super_boss = NewGuardBoss}, 4 * 1000};
        _ ->
            NewState = record_dmg(RoleDmgList, State),
            continue(atk_boss, NewState#state{guard_super_boss = NewGuardBoss})
    end;

%% 结束状态下 只记录玩家的伤害,但是不处理怪物的死亡 
handle_event({hit, _DmgHp, RoleDmgList}, expire, State = #state{guard_super_boss = #guard_super_boss{is_die = _IsDie}}) ->
    NewState = record_dmg(RoleDmgList, State),
    continue(expire, NewState);

%% 玩家击杀小怪 
handle_event({kill_normal, List, Point}, StateName, State = #state{role_list = RoleList}) when StateName =:= atk_boss orelse StateName =:= attack ->
    NewRoleList = record_kill(List, Point, RoleList),
    continue(StateName, State#state{role_list = NewRoleList});

handle_event(_Event, StateName, State) ->
    continue(StateName, State).

handle_sync_event({login, RoleId, Pid}, _From, StateName, State = #state{role_list = RoleList}) when StateName =:= attack orelse StateName =:= atk_boss ->
    case lists:keyfind(RoleId, #guard_counter_role.id, RoleList) of
        false -> 
            continue(StateName, false, State);
        Grole ->
            NewGrole = Grole#guard_counter_role{pid = Pid},
            NewRoleList = lists:keyreplace(RoleId, #guard_counter_role.id, RoleList, NewGrole),
            continue(StateName, {ok, self()}, State#state{role_list = NewRoleList})
    end;
handle_sync_event({login, _, _}, _From, StateName, State) ->
    continue(StateName, false, State);

handle_sync_event(get_status, _From, StateName, State = #state{timeout = Timeout, ts = Ts, end_time = EndTime}) ->
    Fun = fun(idel) -> {1, util:time_left(Timeout, Ts) div 1000};
        (expire) -> {0, 0}; 
        (_) -> {2, EndTime - util:unixtime()}
    end,
    continue(StateName, {ok, Fun(StateName)}, State); 

handle_sync_event(get_current_status, _From, StateName, State = #state{guard_super_boss = GuardBoss}) ->
    Reply = case GuardBoss of
        #guard_super_boss{hp = Hp} -> {ok, Hp};
        _ -> false
    end,
    continue(StateName, Reply, State); 

handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    continue(StateName, Reply, State).

handle_info({enter_zone, {Rid, SrvId}, Pid, Name, GuildName, Career, Lev, Sex, Looks, Eqm, AllPoint}, attack, State = #state{role_list = RoleList, map_id = MapId, role_size = RoleSize}) ->
    NewRoleList = case lists:keyfind({Rid, SrvId}, #guard_counter_role.id, RoleList) of 
        false ->
            case RoleSize >= 150 of
                false ->
                    Grole = #guard_counter_role{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, pid = Pid, name = Name, career = Career, lev = Lev, sex = Sex, looks = Looks, all_point = AllPoint, guild_name = GuildName, eqm = Eqm},
                    role:apply(async, Pid, {fun do_enter_match/3, [MapId, self()]}),
                    [Grole | RoleList];
                true ->
                    role:pack_send(Pid, 15407, {?false, ?L(<<"已经有足够多的勇士在击杀穷奇, 不能进入">>)}), 
                    RoleList
            end;
        Grole ->
            NewGrole = Grole#guard_counter_role{pid = Pid},
            role:apply(async, Pid, {fun do_enter_match/3, [MapId, self()]}),
            lists:keyreplace({Rid, SrvId}, #guard_counter_role.id, RoleList, NewGrole)
    end,
    continue(attack, State#state{role_size = length(NewRoleList), role_list = NewRoleList});

handle_info({enter_zone, {Rid, SrvId}, Pid, Name, GuildName, Career, Lev, Sex, Looks, Eqm, AllPoint}, atk_boss, State = #state{role_list = RoleList, map_id = MapId, role_size = RoleSize}) ->
    NewRoleList = case lists:keyfind({Rid, SrvId}, #guard_counter_role.id, RoleList) of 
        false ->
            case RoleSize >= 150 of
                false ->
                    Grole = #guard_counter_role{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, pid = Pid, name = Name, career = Career, lev = Lev, sex = Sex, looks = Looks, all_point = AllPoint, guild_name = GuildName, eqm = Eqm},
                    role:apply(async, Pid, {fun do_enter_match/3, [MapId, self()]}),
                    [Grole | RoleList];
                true ->
                    role:pack_send(Pid, 15407, {?false, ?L(<<"已经有足够多的勇士在击杀穷奇, 不能进入">>)}), 
                    RoleList
            end;
        Grole ->
            NewGrole = Grole#guard_counter_role{pid = Pid},
            role:apply(async, Pid, {fun do_enter_match/3, [MapId, self()]}),
            lists:keyreplace({Rid, SrvId}, #guard_counter_role.id, RoleList, NewGrole)
    end,
    continue(atk_boss, State#state{role_size = length(NewRoleList), role_list = NewRoleList});

handle_info({enter_zone, _, Pid, _, _, _, _, _, _, _, _}, StateName, State) ->
    role:pack_send(Pid, 15407, {?false, ?L(<<"洛水反击关闭中, 不能进入">>)}), 
    continue(StateName, State);

handle_info({exit_zone, {Rid, SrvId}}, StateName, State = #state{clickers = Clickers}) ->
    case lists:keyfind({Rid, SrvId}, #guard_counter_clicker.id, Clickers) of
        false ->
            continue(StateName, State);
        _ ->
            continue(StateName, State#state{clickers = lists:keydelete({Rid, SrvId}, #guard_counter_clicker.id, Clickers)})
    end;

%% 时间已到, 关闭副本
handle_info(time_stop, expire, State) ->
    continue(expire, State);

handle_info(time_stop, _StateName, State = #state{map_id = MapId}) ->
    ?DEBUG("时间到"),
    stop_combat(State),
    role_group:pack_cast(world, 15412, {0, 0}), 
    map:pack_send_to_all(MapId, 15419, {}),
    {next_state, expire, State#state{ts = now(), timeout = 4 * 1000}, 4 * 1000};

handle_info(stop, expire, State) ->
    ?INFO("洛水反击正在关闭中"),
    continue(expire, State);
handle_info(stop, _StateName, State = #state{map_id = MapId}) ->
    ?INFO("关闭守卫洛水成功"),
    stop_combat(State),
    role_group:pack_cast(world, 15412, {0, 0}), 
    map:pack_send_to_all(MapId, 15419, {}),
    {next_state, expire, State#state{ts = now(), timeout = 4 * 1000}, 4 * 1000};

%% 在进攻状态下才产生怪物
%% 当前小节已经取完, 重新计算当前活动人数, 取下一波数量
handle_info({create_npc, _NextTime, _NextLevTime, []}, StateName, State)
when StateName =:= attack orelse StateName =:= atk_boss ->
    continue(StateName, State);
handle_info({create_npc, NextTime, NextLevTime, LevList}, StateName, State = #state{map_id = MapId, lev = Lev, role_size = RoleSize}) when StateName =:= attack orelse StateName =:= atk_boss ->
    NewLevList = create_npc(LevList, MapId),
    %% 假设下一波数据为空,则提取下一波数据进行下一次轮询
    case NewLevList =:= [] of
        true ->
            %% 当前波的小节已经出完,取下一波数据,并重新调整进攻的怪物数
            ?DEBUG("第~w波怪物已经产出完毕,正在准备产出下一波",[Lev]),
            NewLev = Lev + 1,
            case guard_counter_data:get_lev(NewLev) of
                false -> continue(StateName, State);
                {GetNextTime, GetNextLevTime, GetLevList} ->
                    Ratio = if
                        RoleSize =< 40 -> lists:nth(1, guard_counter_data:get_ratio(NewLev));
                        RoleSize > 40 andalso RoleSize =< 60 -> lists:nth(2, guard_counter_data:get_ratio(NewLev));
                        RoleSize > 60 andalso RoleSize =< 80 -> lists:nth(3, guard_counter_data:get_ratio(NewLev));
                        RoleSize > 80 andalso RoleSize =< 120 -> lists:nth(4, guard_counter_data:get_ratio(NewLev));
                        RoleSize > 120 -> lists:nth(5, guard_counter_data:get_ratio(NewLev));
                        true -> 1
                    end,
                    NextRatio = if
                        RoleSize =< 40 -> lists:nth(1, guard_counter_data:get_next_ratio(NewLev));
                        RoleSize > 40 andalso RoleSize =< 60 -> lists:nth(2, guard_counter_data:get_next_ratio(NewLev));
                        RoleSize > 60 andalso RoleSize =< 80 -> lists:nth(3, guard_counter_data:get_next_ratio(NewLev));
                        RoleSize > 80 andalso RoleSize =< 120 -> lists:nth(4, guard_counter_data:get_next_ratio(NewLev));
                        RoleSize > 120 -> lists:nth(5, guard_counter_data:get_next_ratio(NewLev));
                        true -> 1
                    end,
                    AddLev = util:ceil(length(GetLevList) * Ratio) - length(GetLevList),
                    NewGetLevList = GetLevList ++ guard_mgr:get_list(GetLevList, 1, AddLev), 
                    NewNextLevTime = round(NextLevTime * NextRatio),
                    ?DEBUG("人数为:~w, 调整下一波出怪系数为:~w, 离下一波出怪系数为:~w",[RoleSize, Ratio, NextRatio]),
                    erlang:send_after(NewNextLevTime * 1000, self(), {create_npc, GetNextTime, GetNextLevTime, NewGetLevList}), 
                    continue(StateName, State#state{lev = Lev + 1})
            end;
        false ->
            %% 同波情况下,继续出下一小节的怪物
            erlang:send_after(round(NextTime * 1000), self(), {create_npc, NextTime, NextLevTime, NewLevList}), 
            continue(StateName, State)
    end;

handle_info({create_npc, _NextTime, _NextLevTime, _}, StateName, State) ->
    continue(StateName, State);

handle_info({disturb, Rids}, StateName, State) when is_list(Rids) ->
    Groles = to_guard_counter_role(Rids, State),
    NewState = do_disturb(Groles, State),
    continue(StateName, NewState);

handle_info({disturb, ElemId}, StateName, State = #state{clickers = Clickers}) when is_integer(ElemId) ->
    NewState = do_disturb(elem, ElemId, Clickers, State),
    continue(StateName, NewState#state{clickers = [], elems = []});

%% 在进攻状态下, 检测封印状态
handle_info(check_elem, attack, State = #state{role_list = RoleList, map_id = MapId}) ->
    Now = util:unixtime(),
    case do_check(Now, State) of
        ok -> %% 检测完毕,没有已经采集完毕的玩家
            erlang:send_after(1000, self(), check_elem),
            continue(attack, State);
        {true, Rid} ->
            Boss = case lists:keyfind(Rid, #guard_counter_role.id, RoleList) of
                false ->
                    {};
                G = #guard_counter_role{id = {RoleId, SrvId}, name = Name} -> 
                    %% TODO 公告
                    Bin = notice:role_to_msg({RoleId, SrvId, Name}),
                    notice:send(54, util:fbin(?L(<<"仙友~s面对穷奇毫无畏惧，一举击破穷奇的保护盾，获得了屠魔勇士的称号！趁此良机，众仙友请速速支援！">>), [Bin])),
                    G
            end,
            %% 创建巨龙
            case npc_mgr:create(22138, MapId, 612, 402) of
                {ok, Id} ->
                    NewState = State#state{guard_super_boss = init_boss()},
                    put(prev_hp, ?guard_counter_boss_hp),
                    erlang:send_after(15000, self(), cast_status),
                    {next_state, atk_boss, NewState#state{npc_id = Id, ts = erlang:now(), timeout = 2500 * 1000, boss = Boss}, 2500 * 1000};
                _ ->
                    ?ERR("创建巨龙失败"),
                    stop_combat(State),
                    role_group:pack_cast(world, 15412, {0, 0}), 
                    map:pack_send_to_all(MapId, 15419, {}),
                    {next_state, expire, State#state{ts = now(), timeout = 4 *1000, boss = Boss}, 4 * 1000}
            end
    end;

handle_info(check_elem, StateName, State) ->
    continue(StateName, State);

handle_info(cast_status, atk_boss, State = #state{map_id = MapId, guard_super_boss = GuardSuperBoss}) ->
    case GuardSuperBoss of
        #guard_super_boss{hp = Hp} ->
            PrevHp = get(prev_hp),
            case PrevHp > Hp of
                true ->
                    map:pack_send_to_all(MapId, 15410, {?true, Hp, ?guard_counter_boss_hp}),
                    put(prev_hp, Hp);
                false -> ignore
            end,
            erlang:send_after(5000, self(), cast_status);
        _ ->
            ignore
    end,
    continue(atk_boss, State);
handle_info(cast_status, StateName, State) ->
    continue(StateName, State);

%% 玩家死亡, 回到复活点,等待复活
handle_info({combat_over, DeadRoles}, attack, State = #state{role_list = RoleList, map_id = MapId}) ->
    NewRoleList = do_update_roles(DeadRoles, RoleList, MapId),
    continue(attack, State#state{role_list = NewRoleList});

handle_info({combat_over, DeadRoles}, atk_boss, State = #state{role_list = RoleList, map_id = MapId}) ->
    NewRoleList = do_update_roles(DeadRoles, RoleList, MapId),
    continue(atk_boss, State#state{role_list = NewRoleList});

handle_info({combat_over, DeadRoles}, expire, State = #state{role_list = RoleList, map_id = MapId}) ->
    NewRoleList = do_kick_roles(DeadRoles, RoleList, MapId),
    continue(expire, State#state{role_list = NewRoleList});

%% 采集
handle_info({click, Rid, Rpid, ElemId}, attack, State = #state{clickers = Clickers, elems = Elems}) ->
    case lists:keyfind(Rid, #guard_counter_clicker.id, Clickers) of
        false ->
            %% 没有采集中
            case lists:member(ElemId, Elems) of
                false ->
                    continue(attack, State);
                true ->
                    Clicker = #guard_counter_clicker{id = Rid, pid = Rpid, elem_id = ElemId, click_time = util:unixtime()},
                    ?DEBUG("进行采集成功"),
                    role:apply(async, Rpid, {fun apply_click/2, [on]}),
                    NewState = State#state{clickers = [Clicker | Clickers]},
                    continue(attack, NewState)
            end;
        _ ->
            %% 当前正在采集,忽略再次采集
            continue(attack, State)
    end;

handle_info({click, _, _, _}, StateName, State) ->
    continue(StateName, State);

handle_info({revive, Type, Rid, Pid}, StateName, State = #state{role_list = RoleList}) when StateName =:= attack orelse StateName =:= atk_boss orelse StateName =:= expire ->
    case lists:keyfind(Rid, #guard_counter_role.id, RoleList) of
        false ->
            continue(StateName, State);
        Grole = #guard_counter_role{is_die = ?false} ->
            NewGrole = case Type of
                0 ->
                    Grole#guard_counter_role{is_die = ?true, dead_time = util:unixtime()};
                1 ->
                    role:apply(async, Pid, {fun do_revive/2, [gold]}),
                    Grole#guard_counter_role{is_die = ?false, dead_time = 0}
            end,
            NewRoleList = lists:keyreplace(Rid, #guard_counter_role.id, RoleList, NewGrole),
            continue(StateName, State#state{role_list = NewRoleList});
        Grole = #guard_counter_role{is_die = ?true, dead_time = DeadTime} ->
            NewRoleList = case Type of
                1 -> 
                    role:apply(async, Pid, {fun do_revive/2, [gold]}),
                    NewGrole = Grole#guard_counter_role{is_die = ?false, dead_time = 0},
                    lists:keyreplace(Rid, #guard_counter_role.id, RoleList, NewGrole);
                0 ->
                    TimeLeft = DeadTime + 9 - util:unixtime(),  
                    case TimeLeft =< 0 of
                        true ->
                            role:apply(async, Pid, {fun do_revive/2, [normal]}),
                            NewGrole = Grole#guard_counter_role{is_die = ?false, dead_time = 0},
                            lists:keyreplace(Rid, #guard_counter_role.id, RoleList, NewGrole);
                        false ->
                            role:pack_send(Pid, 15409, {?false, ?L(<<"复活时间未到, 无法复活">>)}),
                            RoleList
                    end
            end,
            continue(StateName, State#state{role_list = NewRoleList})
    end;

handle_info(sync, StateName, State = #state{role_list = RoleList, map_id = MapId}) ->
    guard_mgr:sync_c_rank(RoleList, MapId),
    erlang:send_after(?GUARD_SYNC_TIME, self(), sync),
    continue(StateName, State);

handle_info(_Info, StateName, State) ->
    continue(StateName, State).

%% 异常挂掉之后 奖励继续发放
terminate(_Reason, _StateName, #state{role_list = RoleList, guard_super_boss = GuardBoss, boss = Boss}) ->
    ?DEBUG("洛水反击关闭:~w", [_StateName]),
    IsDie = case GuardBoss of
        #guard_super_boss{is_die = Die} -> Die;
        _ -> ?false
    end,
    case IsDie of
        ?true ->
            notice:send(54, ?L(<<"众仙友众志成城，成功击杀妖魔首领穷奇，洛水之战凯旋而归！">>));
        ?false ->
            notice:send(54, ?L(<<"妖魔残余势力不容小觑，可惜反击之战功亏一篑！众仙友暂不可懈怠，他日妖魔必将继续来侵洛水，守卫洛水依然任重道远！">>))
    end,
    guard_mgr:guard_counter_stop(RoleList, IsDie, Boss),
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%%----------------------------------------------------
%% 内部函数 
%%----------------------------------------------------
do_enter_match(Role = #role{pid = Pid, name = _Name}, MapId, EventPid) ->
    {X, Y} = util:rand_list([{5460, 2850}, {5280, 3240}, {4860, 3210}]),
    NewX = util:rand(X - 5, X + 5),
    NewY = util:rand(Y - 5, Y + 5),
    case map:role_enter(MapId, NewX, NewY, Role#role{event = ?event_guard_counter, event_pid = EventPid}) of
        {ok, NewRole} ->
            ?DEBUG("~s成功进入正式区",[_Name]),
            role:pack_send(Pid, 15407, {?true, ?L(<<"成功进入洛水反击">>)}), 
            {ok, NewRole};
        {false, _Why} ->
            role:pack_send(Pid, 15407, {?false, ?L(<<"进入洛水反击地图失败">>)}), 
            ?ERR("~s进入正式区失败,原因:~w",[_Name, _Why]),
            {ok}
    end.

init_boss() ->
    #guard_super_boss{hp = ?guard_counter_boss_hp, hp_max = ?guard_counter_boss_hp}.

stop_combat(#state{map_pid = MapPid, role_list = RoleList}) ->
    MapPid ! {clear_fun_type_npc, ?npc_fun_type_guard_counter},
    %% 终止现有的战斗
    lists:foreach(fun(#guard_counter_role{id = RoleId}) ->
                case role_api:lookup(by_id, RoleId, [#role.combat_pid, #role.event]) of
                    {ok, _, [CombatPid, ?event_guard_counter]} when is_pid(CombatPid) ->
                        CombatPid ! stop;
                    _Err ->
                        ignore
                end
        end, RoleList).

clean_zone(#state{role_list = RoleList}) ->
    lists:foreach(fun(#guard_counter_role{pid = Pid}) ->
                role:apply(async, Pid, {fun do_revive_and_exit_combat_area/1, []})
        end, RoleList).

%% 普通复活
do_revive(Role = #role{hp_max = HpMax, status = ?status_die, link = #link{conn_pid = ConnPid}}, normal) ->
    NewRole = role_api:push_attr(Role#role{hp = round(HpMax/2), status = ?status_normal}),
    map:role_update(NewRole),
    sys_conn:pack_send(ConnPid, 15409, {?true, <<>>}),
    {ok, NewRole};
%% 花费晶钻复活
do_revive(Role = #role{hp_max = HpMax, mp_max = MpMax, status = ?status_die, link = #link{conn_pid = ConnPid}}, gold) ->
    L = [#loss{label = gold, val = pay:price(?MODULE, do_revive, null)}],
    case do_revive_loss(Role, L) of
        {false, _Reason} ->
            ?DEBUG("角色[NAME:~s]复活扣除失败:~w", [Role#role.name, _Reason]),
            sys_conn:pack_send(ConnPid, 15409, {?false, ?L(<<"晶钻不足, 不能复活">>)}),
            {ok, Role};
        {ok, Role0} ->
            NewRole = role_api:push_attr(Role0#role{hp = HpMax, mp = MpMax, status = ?status_normal}),
            map:role_update(NewRole),
            sys_conn:pack_send(ConnPid, 15409, {?true, <<>>}),
            {ok, NewRole}
    end;
do_revive(Role, _) ->
    {ok, Role}.

%% 复活扣除消耗
do_revive_loss(Role, LossList) ->
    case role_gain:do(LossList, Role) of
        {false, #loss{msg = Msg}} -> {false, Msg};
        {ok, NewRole} ->
            log:log(log_gold, {<<"洛水反击">>, <<"晶钻复活">>, <<"洛水反击晶钻复活">>, Role, NewRole}),
            {ok, NewRole};
        _ -> {false, ?L(<<"晶钻不足, 不能马上复活">>)}
    end.

do_update_roles([], RoleList, _) -> RoleList;
do_update_roles([{Rid, SrvId, Pid} | T], RoleList, MapId) ->
    NewRoleList = case lists:keyfind({Rid, SrvId}, #guard_counter_role.id, RoleList) of
        false ->
            ?DEBUG("角色在洛水反击区域死亡,但进程无记录该角色"),
            RoleList;
        Grole ->
            NewGrole = Grole#guard_counter_role{is_die = ?true, dead_time = util:unixtime()},
            role:apply(async, Pid, {fun do_return_to_revive_point/2, [MapId]}),
            lists:keyreplace({Rid, SrvId}, #guard_counter_role.id, RoleList, NewGrole)
    end,
    do_update_roles(T, NewRoleList, MapId).

do_kick_roles([], RoleList, _) -> RoleList;
do_kick_roles([{Rid, SrvId, Pid} | T], RoleList, MapId) ->
    case lists:keyfind({Rid, SrvId}, #guard_counter_role.id, RoleList) of
        false ->
            ?DEBUG("角色在洛水反击区域死亡,但进程无记录该角色");
        _Grole ->
            role:apply(async, Pid, {fun do_revive_and_exit_combat_area/1, []})
    end,
    do_kick_roles(T, RoleList, MapId).

get_exit_pos() ->
    {10003, 1440 + util:rand(-5, 5), 5640 + util:rand(-5, 5)}.

get_revive_point() -> util:rand_list([{5460, 2850}, {5280, 3240}, {4860, 3210}]).

%% 角色退出战斗区域
do_exit_combat_area(Role = #role{name = _Name, hp = _Hp, event = ?event_guard_counter, looks = Looks}) ->
    {ExitMapId, ExitX, ExitY} = get_exit_pos(),
    Role1 = Role#role{status = ?status_normal},
    NewLooks = case lists:keyfind(?LOOKS_TYPE_GUARD_COUNTER, 1, Looks) of
        false -> Looks;
        _ -> lists:keydelete(?LOOKS_TYPE_GUARD_COUNTER, 1, Looks)
    end,
    Role3 = case map:role_enter(ExitMapId, ExitX, ExitY, Role1#role{looks = NewLooks, event = ?event_no, event_pid = 0}) of
        {ok, Role2} -> Role2;
        {false, _Why} ->
            ?ERR("[~s]退出战斗区域失败[Reason:~w]", [_Name, _Why]),
            Role1
    end,
    {ok, Role3};
do_exit_combat_area(Role) ->
    {ok, Role}.

%% 角色复活并退出战斗区域
do_revive_and_exit_combat_area(Role = #role{pid = Pid, name = _Name, hp_max = HpMax, status = Status, event = _Event}) ->
    case do_exit_combat_area(Role) of
        {ok, Role1} ->
            Role2 = case Status of
                ?status_die ->
                    role:pack_send(Pid, 15409, {?true, <<>>}),
                    Role1#role{hp = round(HpMax/2), status = ?status_normal};
                _ ->
                    Role1#role{status = ?status_normal}
            end,
            Role3 = role_api:push_attr(Role2),
            {ok, Role3};
        _ -> {ok, Role}
    end.

do_return_to_revive_point(Role = #role{event = _Event, status = _Status, name = _Name}, MapId) ->
    {X, Y} = get_revive_point(),
    NewX = util:rand(X - 50, X + 50),
    NewY = util:rand(Y - 50, Y + 50),
    Role2 = case map:role_enter(MapId, NewX, NewY, Role) of
        {ok, Role1} ->
            Role1;
        {false, _Why} ->
            ?ERR("[~s]回到复活点失败[Reason:~w]", [_Name, _Why]),
            Role
    end,
    {ok, Role2}.

update_boss(GuardBoss = #guard_super_boss{hp = Hp}, Dmg) ->
    case max(0, Hp - Dmg) of
        0 -> 
            GuardBoss#guard_super_boss{hp = 0, is_die = ?true};
        NewHp ->
            GuardBoss#guard_super_boss{hp = NewHp, is_die = ?false}
    end.

to_role_name(RoleDmgList) ->
    to_role_name(RoleDmgList, <<>>).
to_role_name([], Bin) -> Bin;
to_role_name([{#fighter{rid = Rid, srv_id = SrvId, name = Name}, _} | T], Bin) ->
    B = notice:role_to_msg({Rid, SrvId, Name}),
    NewBin = util:fbin(<<"~s ~s">>,[Bin, B]),
    to_role_name(T, NewBin).

record_dmg([], State) -> State;
record_dmg([{#fighter{rid = Rid, srv_id = SrvId}, DmgTotal} | T], State = #state{role_list = RoleList}) ->
    case lists:keyfind({Rid, SrvId}, #guard_counter_role.id, RoleList) of
        false ->
            record_dmg(T, State);
        Grole = #guard_counter_role{pid = Pid, point = Point, all_point = AllPoint}->
            GetPoint = round(DmgTotal / 8000),
            NewGrole = Grole#guard_counter_role{point = Point + GetPoint, all_point = AllPoint + GetPoint},
            role:apply(async, Pid, {fun add_point/2, [GetPoint]}),
            NewRoleList = lists:keyreplace({Rid, SrvId}, #guard_counter_role.id, RoleList, NewGrole),
            record_dmg(T, State#state{role_list = NewRoleList})
    end.

record_kill([], _, RoleList) -> RoleList;
record_kill([{Rid, SrvId} | T], GetPoint, RoleList) ->
    case lists:keyfind({Rid, SrvId}, #guard_counter_role.id, RoleList) of
        false -> record_kill(T, GetPoint, RoleList);
        Grole = #guard_counter_role{pid = Pid, point = Point, all_point = AllPoint, kill_npc = KillNpc} ->
            NewGrole = Grole#guard_counter_role{point = Point + GetPoint, all_point = AllPoint + GetPoint,kill_npc = KillNpc + 1},
            role:apply(async, Pid, {fun add_point/2, [GetPoint]}),
            NewRoleList = lists:keyreplace({Rid, SrvId}, #guard_counter_role.id, RoleList, NewGrole),
            record_kill(T, GetPoint, NewRoleList)
    end.

add_point(Role = #role{name = _Name, assets = Assets = #assets{guard_acc = Guard}}, Point) ->
    ?DEBUG("~s原有积分~w, 增加~w",[_Name, Guard, Point]),
    NewRole = Role#role{assets = Assets#assets{guard_acc = Guard + Point}},
    Nr = role_listener:special_event(NewRole, {30030, 1}), %%参与一次洛水反击
    {ok, Nr}.

%% 检查攻击封印元素是否有效
do_check(Now, State = #state{clickers = Clickers, elems = Elems}) ->
    do_check(Now, Clickers, Elems, State).

do_check(_Now, [], _Elems, _State) -> ok;
do_check(Now, [H = #guard_counter_clicker{click_time = Ctime, elem_id = ElemId} | T], Elems, State) ->
    case Now - Ctime >= ?guard_counter_elem_wait of
        true ->
            case lists:member(ElemId, Elems) of
                true -> do_check_done(H, Elems, State);
                false -> do_check(Now, T, Elems, State)
            end;
        false ->
            do_check(Now, T, Elems, State)
    end.

do_check_done(#guard_counter_clicker{id = Rid}, Elems, #state{map_id = MapId}) ->
    CleanElems = [604701 | Elems],
    [map:elem_leave(MapId, ElemId) || ElemId <- CleanElems],
    [self() ! {disturb, ElemId} || ElemId <- Elems],
    {true, Rid}.

%% 处理打断
do_disturb([], State) -> State;
do_disturb([#guard_counter_role{pid = Rpid, id = Rid} | T], State = #state{clickers = Clickers}) ->
    case lists:keyfind(Rid, #guard_counter_clicker.id, Clickers) of
        false ->
            do_disturb(T, State);
        _C ->
            role:apply(async, Rpid, {fun apply_click/2, [off]}),
            do_disturb(T, State#state{clickers = lists:keydelete(Rid, #guard_counter_clicker.id, Clickers)})
    end.

do_disturb(elem, _ElemId, _Clicker = [], State) -> State;
do_disturb(elem, ElemId, [_C = #guard_counter_clicker{id = Rid, elem_id = Eid, pid = Rpid} | T], State = #state{clickers = Clickers}) when ElemId =:= Eid ->
    role:apply(async, Rpid, {fun apply_click/2, [off]}),
    do_disturb(elem, ElemId, T, State#state{clickers = lists:keydelete(Rid, #guard_counter_clicker.id, Clickers)});
do_disturb(elem, ElemId, [_ | T], State) ->
    do_disturb(elem, ElemId, T, State).

to_guard_counter_role(Rids, State) ->
    to_guard_counter_role(Rids, State, []).
to_guard_counter_role([], _State, Back) -> Back;
to_guard_counter_role([H | T], State = #state{role_list = Roles}, Back) ->
    case lists:keyfind(H, #guard_counter_role.id, Roles) of
        false ->
            to_guard_counter_role(T, State, Back);
        Grole ->
            to_guard_counter_role(T, State, [Grole | Back])
    end.

%% 角色移动打断采集
move_disturb(_Role = #role{looks = Looks, id = Rid, event = ?event_guard_counter, event_pid = Epid}) ->
    case is_pid(Epid) of
        true ->
            case lists:keyfind(?LOOKS_TYPE_GUARD_COUNTER, 1, Looks) of
                false -> ok;
                _ ->
                    Epid ! {disturb, [Rid]}
            end;
        _ -> ok
    end;
move_disturb(_) -> ok.

create_npc([], _MapId) -> [];
create_npc([SmallLev | T], MapId) ->
    NpcInfo = guard_counter_data:get_small(SmallLev),
    create_point(NpcInfo, MapId),
    T.

create_point([], _MapId) -> ok;
create_point([{NpcBaseId, Num, X, Y, PathNum} | T], MapId) ->
    create_one_npc(NpcBaseId, Num, X, Y, MapId, PathNum),
    create_point(T, MapId).
    
create_one_npc(_NpcBaseId, 0, _X, _Y, _MapId, _PathNum) -> ok;
create_one_npc(NpcBaseId, Num, X, Y, MapId, PathNum) ->
    npc_mgr:create(NpcBaseId, MapId, X, Y, guard_counter_data:get_paths(PathNum)),
    create_one_npc(NpcBaseId, Num - 1, X, Y, MapId, PathNum).

%% 点击后玩家的广播处理
apply_click(Role = #role{looks = Looks}, on) ->
    case lists:keyfind(?LOOKS_TYPE_GUARD_COUNTER, 1, Looks) of
        false ->
            NewRole = Role#role{looks = [{?LOOKS_TYPE_GUARD_COUNTER, 0, 0} | Looks]},
            {ok, NewRole};
        _ ->
            {ok, Role}
    end;

apply_click(Role = #role{looks = Looks}, off) ->
    case lists:keyfind(?LOOKS_TYPE_GUARD_COUNTER, 1, Looks) of
        false -> {ok, Role};
        _ ->
            NewRole = Role#role{looks = lists:keydelete(?LOOKS_TYPE_GUARD_COUNTER, 1, Looks)},
            {ok, NewRole}
    end.

%%----------------------------------------------------
%% 超时 
%%----------------------------------------------------
idel(timeout, State = #state{map_id = MapId, end_time = EndTime}) ->
    %% TODO
    %% 创建怪物 不断产生
    notice:send(54, ?L(<<"洛水一战，成功守卫洛水，为彻底粉碎穷奇所率领的妖魔军队，众仙友请拿起武器，打响洛水反击之战！">>)),
    case guard_counter_data:get_lev(1) of
        false -> skip;
        {NextTime, NextLevTime, LevList} ->
            NewLevList = create_npc(LevList, MapId),
            erlang:send_after(round(NextTime * 1000), self(), {create_npc, NextTime, NextLevTime, NewLevList})
    end,
    erlang:send_after(?GUARD_SYNC_TIME, self(), sync),
    erlang:send_after(5 * 1000, self(), check_elem),
    role_group:pack_cast(world, 15412, {2, EndTime - util:unixtime()}), 
    {next_state, attack, State#state{lev = 1, ts = erlang:now(), timeout = 2500 * 1000}, 2500 * 1000};
idel(_Any, State) ->
    continue(idel, State).

%% 进攻状态不进行跳转
attack(timeout, State) ->
    ?DEBUG("attack状态超时"),
    {next_state, atk_boss, State#state{ts = erlang:now(), timeout = 2500 * 1000}, 2500 * 1000};
attack(_Any, State) ->
    continue(attack, State).

%% boss状态
atk_boss(timeout, State = #state{map_id = MapId}) ->
    ?DEBUG("atk_boss状态超时"),
    stop_combat(State),
    role_group:pack_cast(world, 15412, {0, 0}), 
    map:pack_send_to_all(MapId, 15419, {}),
    {next_state, expire, State#state{ts = erlang:now(), timeout = 4 * 1000}, 4 * 1000};
atk_boss(_Any, State) ->
    continue(atk_boss, State).

%% 结算, 统计奖励以及统计当前战绩
expire(timeout, State) ->
    ?INFO("清除玩家退出活动区域"),
    clean_zone(State),
    {stop, normal, State};
expire(_Any, State) ->
    continue(expire, State).

%%----------------------------------------------------
%% 辅助函数
%%----------------------------------------------------
continue(StateName, State = #state{ts = Ts, timeout = Timeout}) ->
    {next_state, StateName, State, util:time_left(Timeout, Ts)}.

continue(StateName, Reply, State = #state{ts = Ts, timeout = Timeout}) ->
    {reply, Reply, StateName, State, util:time_left(Timeout, Ts)}.
