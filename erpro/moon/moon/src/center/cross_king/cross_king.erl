%%----------------------------------------------------
%% @doc 至尊比赛 
%%      match         比赛阶段
%%      expire         结束阶段
%% </pre> 
%% @author  shawn
%% @end
%%----------------------------------------------------
-module(cross_king).

-behaviour(gen_fsm).

-export([
        start_link/1
        ,apply_get_combat_pid/1
        ,leave_match/1
        ,enter_match/2
        ,exit_match/2
        ,login/4
        ,logout/3
        ,info_list/2
        ,combat_over/4
        ,fail_enter_match/2
        ,get_zone_list/1
    ]
).
-export([
        idel/2                %% 预备时间
        ,check_match/2         %% 检测发起战斗,同时判断是否能结算
        ,match/2               %% 比赛时间
        ,expire/2              %% 结束
    ]
).
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-include("common.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("cross_king.hrl").
-include("combat.hrl").
-include("looks.hrl").

-define(gfs_death_max, 3).
-define(ds_death_max, 7).

-record(state, {
        map_pid = 0     %% 地图进程ID
        ,map_id = 0     %% 地图Id
        ,zone_id = 0  %% 战场序号
        ,report = false %% 结算报告
        ,gfs_list = [] %% 角色信息[#cross_king_role{}]
        ,ds_list = [] %% 角色信息[#cross_king_role{}]
        ,role_list = [] %% 所有角色
        ,off_list = []  %% 不可动角色 {包含下线, 死亡次数达上限, 离开正式区的}
        ,combat_list = [] %% 战斗中的角色
        ,role_size = 0  %% 原始角色数量
        ,ts = 0         %% 进入某状态的时刻
        ,timeout = 0    %% 超时时间
        ,time = 0       %% 竞技场开启时间
    }
).


%% 启动服务进程
start_link(Seq)->
    Time = util:unixtime(),
    gen_fsm:start_link(?MODULE, [Seq, Time], []).

%% 上线
login(ZonePid, Rid, SrvId, Pid) ->
    gen_fsm:sync_send_all_state_event(ZonePid, {login, Rid, SrvId, Pid}).

%% 下线
logout(ZonePid, Rid, SrvId) ->
    gen_fsm:send_all_state_event(ZonePid, {logout, Rid, SrvId}).

%% 进入失败
fail_enter_match(ZonePid, KingRole) ->
    gen_fsm:send_all_state_event(ZonePid, {fail_enter_match, KingRole}).

%% 战斗结束
combat_over(Referees, Winner, Loser, DmgList) ->
    case lists:keyfind(common, 1, Referees) of
        {_, Pid} when is_pid(Pid) ->
            gen_fsm:send_all_state_event(Pid, {combat_over, Winner, Loser, DmgList});
        _ -> skip
    end.

%% 进入正式区 同步
enter_match(ZonePid, KingRole) ->
    gen_fsm:sync_send_all_state_event(ZonePid, {enter_match, KingRole}).

%% 退出战场 同步
exit_match(ZonePid, {Rid, SrvId}) ->
    gen_fsm:sync_send_all_state_event(ZonePid, {exit_match, {Rid, SrvId}}).

%% 查看当前组员信息
info_list(ZonePid, Label) ->
    gen_fsm:sync_send_all_state_event(ZonePid, {info, Label}).

%% 获取当前的所有成员列表
get_zone_list(ZonePid) when is_pid(ZonePid) ->
    gen_fsm:sync_send_all_state_event(ZonePid, zone_list);
get_zone_list(_) -> ok.


init([Seq, StartTime])->
    ?DEBUG("[~w] 正在启动...", [?MODULE]),
    case map_mgr:create(36012) of
        {false, Reason} ->
            ?ERR("创建至尊王者比赛地图失败:~s", [Reason]),
            {stop, normal, #state{}};
        {ok, MapPid, MapId} ->
            State = #state{map_pid = MapPid, map_id = MapId, zone_id = Seq, ts = erlang:now(), time = StartTime, timeout = 20 * 1000},
            ?DEBUG("[~w] 启动完成", [?MODULE]),
            erlang:send_after(30 * 60 * 1000, self(), time_stop),
            {ok, idel, State, 20 * 1000}
    end.

%% 下线
handle_event({logout, Rid, SrvId}, StateName, State = #state{role_list = RoleList, gfs_list = GfsList, ds_list = DsList, off_list = OffList}) ->
    case lists:keyfind({Rid, SrvId}, #cross_king_role.id, RoleList) of
        false ->
            continue(StateName, State);
        KingRole = #cross_king_role{group = Group} ->
            NewKingRole = KingRole#cross_king_role{status = ?cross_king_role_status_logout},
            NewRoleList = lists:keyreplace({Rid, SrvId}, #cross_king_role.id, RoleList, NewKingRole),
            case lists:keyfind({Rid, SrvId}, #cross_king_role.id, OffList) of
                false ->
                    {NewGfsList, NewDsList} = case Group of
                        0 -> %% 屌丝组
                            {GfsList, lists:keydelete({Rid, SrvId}, #cross_king_role.id, DsList)};
                        1 -> %% 高富帅组
                            {lists:keydelete({Rid, SrvId}, #cross_king_role.id, GfsList), DsList}
                    end,
                    NewOffList = [NewKingRole | OffList],
                    NewState = State#state{role_list = NewRoleList, gfs_list = NewGfsList, ds_list = NewDsList, off_list = NewOffList},
                    broadcast_group(NewState),
                    continue(StateName, NewState);
                _ -> %% 下线列表找到数据
                    NewOffList = lists:keyreplace({Rid, SrvId}, #cross_king_role.id, OffList, NewKingRole),
                    continue(StateName, State#state{role_list = NewRoleList, off_list = NewOffList})
            end
    end;

%% 战斗结束
handle_event({combat_over, Winner, Loser, DmgList}, StateName, State = #state{role_list = RoleList, gfs_list = GfsList, ds_list = DsList, combat_list = CombatList, off_list = OffList, map_id = MapId}) ->
    case Winner =:= [] of
        true -> %% 平局
            Gfs = [{Rid, SrvId, IsDie, Pid} || #fighter{pid = Pid, rid = Rid, is_die = IsDie, group = group_atk, srv_id = SrvId, type = ?fighter_type_role} <- Loser],
            Ds = [{Rid, SrvId, IsDie, Pid} || #fighter{pid = Pid, rid = Rid, is_die = IsDie, group = group_dfd, srv_id = SrvId, type = ?fighter_type_role} <- Loser],
            %% 平局的时候, 高富帅状态不回写, 屌丝回满血,
            {NewRoleList, NewGfsList, NewDsList, NewCombatList, NewOffList} = combat_over(MapId, draw_game, Gfs, Ds, RoleList, GfsList, DsList, CombatList, OffList, DmgList),
            NewState = State#state{role_list = NewRoleList, gfs_list = NewGfsList, ds_list = NewDsList, combat_list = NewCombatList, off_list = NewOffList},
            broadcast_group(NewState),
            continue(StateName, NewState);
        false ->
            case find_win(Winner) of
                gfs ->
                    Gfs = [{Rid, SrvId, IsDie, Pid} || #fighter{pid = Pid, rid = Rid, is_die = IsDie, group = group_atk, srv_id = SrvId, type = ?fighter_type_role} <- Winner],
                    Ds = [{Rid, SrvId, IsDie, Pid} || #fighter{pid = Pid, rid = Rid, is_die = IsDie, group = group_dfd, srv_id = SrvId, type = ?fighter_type_role} <- Loser],
                    {NewRoleList, NewGfsList, NewDsList, NewCombatList, NewOffList} = combat_over(MapId, gfs_win, Gfs, Ds, RoleList, GfsList, DsList, CombatList, OffList, DmgList),
                    NewState = State#state{role_list = NewRoleList, gfs_list = NewGfsList, ds_list = NewDsList, combat_list = NewCombatList, off_list = NewOffList},
                    broadcast_group(NewState),
                    continue(StateName, NewState);
                ds ->
                    Gfs = [{Rid, SrvId, Name, IsDie, Pid} || #fighter{name = Name, pid = Pid, rid = Rid, is_die = IsDie, group = group_atk, srv_id = SrvId, type = ?fighter_type_role} <- Loser],
                    Ds = [{Rid, SrvId, Name, IsDie, Pid} || #fighter{name = Name, pid = Pid, rid = Rid, is_die = IsDie, group = group_dfd, srv_id = SrvId, type = ?fighter_type_role} <- Winner],
                    NewGfs = [{Rid, SrvId, IsDie, Pid} || {Rid, SrvId, _, IsDie, Pid} <- Gfs],
                    NewDs = [{Rid, SrvId, IsDie, Pid} || {Rid, SrvId, _, IsDie, Pid} <- Ds],
                    {NewRoleList, NewGfsList, NewDsList, NewCombatList, NewOffList} = combat_over(MapId, ds_win, NewGfs, NewDs, RoleList, GfsList, DsList, CombatList, OffList, DmgList),
                    spawn(fun() -> notice_broad(MapId, Gfs, Ds) end), 
                    spawn(fun() -> award_kill_gfs(NewRoleList) end), 
                    NewState = State#state{role_list = NewRoleList, gfs_list = NewGfsList, ds_list = NewDsList, combat_list = NewCombatList, off_list = NewOffList},
                    broadcast_group(NewState),
                    continue(StateName, NewState)
            end
    end;

%% 角色进入失败
handle_event({fail_enter_match, KingRole = #cross_king_role{id = Id, pid = _RolePid, group = Group}}, StateName, State = #state{role_list = RoleList, gfs_list = GfsList, ds_list = DsList}) ->
    %% TODO 更新战场信息
    NewKingRole = KingRole#cross_king_role{status = ?cross_king_role_status_prepare},
    cross_king_mgr:update_cache(NewKingRole),
    NewGfsList = case Group of
        0 -> GfsList;
        1 -> 
            case lists:keyfind(Id, #cross_king_role.id, GfsList) of
                false -> GfsList;
                _ -> lists:keydelete(Id, #cross_king_role.id, GfsList)
            end
    end,
    NewDsList = case Group of
        1 -> DsList;
        0 -> 
            case lists:keyfind(Id, #cross_king_role.id, DsList) of
                false -> DsList;
                _ -> lists:keydelete(Id, #cross_king_role.id, DsList)
            end
    end,
    NewRoleList = case lists:keyfind(Id, #cross_king_role.id, RoleList) of
        false -> RoleList;
        _ -> lists:keydelete(Id, #cross_king_role.id, RoleList)
    end,
    NewState = State#state{role_list = NewRoleList, gfs_list = NewGfsList, ds_list = NewDsList},
    broadcast_group(NewState),
    continue(StateName, NewState);

%% 容错
handle_event(_Event, StateName, State) ->
    continue(StateName, State).

%% 登陆
handle_sync_event({login, Rid, SrvId, Pid}, _From, idel, State = #state{role_list = RoleList, off_list = OffList, ds_list = DsList, gfs_list = GfsList}) ->
    case lists:keyfind({Rid, SrvId}, #cross_king_role.id, RoleList) of
        false -> 
            continue(idel, false, State);
        KingRole = #cross_king_role{group = 0} ->
            NewKingRole = KingRole#cross_king_role{status = ?cross_king_role_status_match, pid = Pid},
            cross_king_mgr:update_cache(NewKingRole),
            NewRoleList = lists:keyreplace({Rid, SrvId}, #cross_king_role.id, RoleList, NewKingRole),
            NewOffList = case lists:keyfind({Rid, SrvId}, #cross_king_role.id, OffList) of
                false -> OffList;
                _ -> lists:keydelete({Rid, SrvId}, #cross_king_role.id, OffList)
            end,
            NewDsList = case lists:keyfind({Rid, SrvId}, #cross_king_role.id, DsList) of
                false -> DsList ++ [NewKingRole];
                _ -> lists:keydelete({Rid, SrvId}, #cross_king_role.id, DsList) ++ [NewKingRole]
            end,
            NewState = State#state{role_list = NewRoleList, off_list = NewOffList, ds_list = NewDsList},
            broadcast_group(NewState),
            continue(idel, {ok, NewKingRole}, NewState);
        KingRole = #cross_king_role{group = 1} ->
            NewKingRole = KingRole#cross_king_role{status = ?cross_king_role_status_match, pid = Pid},
            cross_king_mgr:update_cache(NewKingRole),
            NewRoleList = lists:keyreplace({Rid, SrvId}, #cross_king_role.id, RoleList, NewKingRole),
            NewOffList = case lists:keyfind({Rid, SrvId}, #cross_king_role.id, OffList) of
                false -> OffList;
                _ -> lists:keydelete({Rid, SrvId}, #cross_king_role.id, OffList)
            end,
            NewGfsList = case lists:keyfind({Rid, SrvId}, #cross_king_role.id, GfsList) of
                false -> GfsList ++ [NewKingRole];
                _ -> lists:keydelete({Rid, SrvId}, #cross_king_role.id, GfsList) ++ [NewKingRole]
            end,
            NewState = State#state{role_list = NewRoleList, off_list = NewOffList, gfs_list = NewGfsList},
            broadcast_group(NewState),
            continue(idel, {ok, NewKingRole}, NewState)
    end;

handle_sync_event({login, _Rid, _SrvId, _Pid}, _From, StateName, State) ->
    continue(StateName, false, State);

%% 角色进入战场
handle_sync_event({enter_match, KingRole = #cross_king_role{id = RoleId, pid = RolePid, group = Group}}, _From, idel, State = #state{role_list = RoleList, map_id = MapId, zone_id = ZoneId, ts = _Ts, gfs_list = GfsList, ds_list = DsList}) ->
    %% TODO 更新战场信息
    NewKingRole = KingRole#cross_king_role{status = ?cross_king_role_status_match},
    case Group of
        1 ->
            role:pack_send(RolePid, 10931, {55, util:fbin(?L(<<"成功进入战场正式区, 您被分配到~w战区王者组">>), [ZoneId]), []});
        _ ->
            role:pack_send(RolePid, 10931, {55, util:fbin(?L(<<"成功进入战场正式区, 您被分配到~w战区求道组">>), [ZoneId]), []})
    end,
    cross_king_mgr:update_cache(NewKingRole),
    {NewGfsList, NewDsList} = case Group of
        0 ->
            case lists:keyfind(RoleId, #cross_king_role.id, DsList) of
                false -> {GfsList, [NewKingRole | DsList]};
                _ -> {GfsList, lists:keyreplace(RoleId, #cross_king_role.id, DsList, NewKingRole)}
            end;
        1 ->
            case lists:keyfind(RoleId, #cross_king_role.id, GfsList) of
                false -> {[NewKingRole | GfsList], DsList};
                _ -> {lists:keyreplace(RoleId, #cross_king_role.id, GfsList, NewKingRole), DsList}
            end
    end,
    NewRoleList = case lists:keyfind(RoleId, #cross_king_role.id, RoleList) of
        false -> [NewKingRole | RoleList];
        _ -> lists:keyreplace(RoleId, #cross_king_role.id, RoleList, NewKingRole)
    end,
    NewState = State#state{role_list = NewRoleList, gfs_list = NewGfsList, ds_list = NewDsList},
    broadcast_group(NewState),
    continue(idel, {ok, MapId}, NewState);

handle_sync_event({enter_match, _ArenaRole}, _From, StateName, State) ->
    Reply = {false, ?L(<<"当前不可以进入至尊王者正式区">>)},
    continue(StateName, Reply, State);

%% 退出正式区
handle_sync_event({exit_match, {Rid, SrvId}}, _From, StateName, State = #state{role_list = RoleList, ds_list = DsList, gfs_list = GfsList, zone_id = _ZoneId, time = _Time, off_list = OffList}) ->
    case lists:keyfind({Rid, SrvId}, #cross_king_role.id, RoleList) of
        false ->
            ?ERR("角色在正式区退出记录不一致[~w:~s]",[Rid, SrvId]),
            continue(StateName, ok, State);
        KingRole = #cross_king_role{pid = RolePid, group = GroupId} ->
            NewKingRole = KingRole#cross_king_role{status = ?cross_king_role_status_leave},
            cross_king_mgr:update_cache(NewKingRole),
            NewRoleList = lists:keyreplace({Rid, SrvId}, #cross_king_role.id, RoleList, NewKingRole),
            case lists:keyfind({Rid, SrvId}, #cross_king_role.id, OffList) of
                false -> %% 未处于off区域
                    {NewGfsList, NewDsList} = case GroupId of
                        0 -> %% 屌丝组
                            {GfsList, lists:keydelete({Rid, SrvId}, #cross_king_role.id, DsList)};
                        1 -> %% 高富帅组
                            {lists:keydelete({Rid, SrvId}, #cross_king_role.id, GfsList), DsList}
                    end,
                    NewOffList = [NewKingRole | OffList],
                    NewState = State#state{role_list = NewRoleList, gfs_list = NewGfsList, ds_list = NewDsList, off_list = NewOffList},
                    %% 进行统计一次
                    role:apply(async, RolePid, {cross_king, leave_match, []}),
                    broadcast_group(NewState),
                    continue(StateName, ok, NewState);
                _ -> %% 已经处于off区域的角色
                    NewOffList = lists:keyreplace({Rid, SrvId}, #cross_king_role.id, OffList, NewKingRole),
                    NewState = State#state{role_list = NewRoleList, off_list = NewOffList},
                    role:apply(async, RolePid, {cross_king, leave_match, []}),
                    broadcast_group(NewState),
                    continue(StateName, ok, NewState)
                
            end
    end;

%% 查看当前成员列表
handle_sync_event(zone_list, _From, StateName, State = #state{gfs_list = GfsList, ds_list = DsList}) ->
    Gfs = [{Rid, SrvId, Name, Career, Fight, PetFight, Kill} || #cross_king_role{id = {Rid, SrvId}, name = Name, career = Career, fight_capacity = Fight, pet_fight = PetFight, kill = Kill} <- GfsList],
    Ds = [{Rid, SrvId, Name, Career, Fight, PetFight, Dmg} || #cross_king_role{id = {Rid, SrvId}, name = Name, career = Career, fight_capacity = Fight, pet_fight = PetFight, dmg = Dmg} <- DsList],
    continue(StateName, {Gfs, Ds}, State);

handle_sync_event({info, Label}, _From, StateName, State = #state{role_list = RoleList, ds_list = DsList, gfs_list = GfsList, off_list = OffList}) ->
    Reply = case Label of
        0 -> DsList ++ [K || K = #cross_king_role{group = Group} <- OffList, Group =:= 0];
        1 -> GfsList ++ [K || K = #cross_king_role{group = Group} <- OffList, Group =:= 1];
        2 -> RoleList;
        3 -> GfsList ++ DsList ++ OffList
    end,
    %% 调试打印
    lists:foreach(fun(#cross_king_role{group = _Group, id = {_Rid, _SrvId}, name = _Name, combat = _Combat, status = _Status}) -> ?DEBUG("Group:~w, Rid:~w, SrvId:~s, Name:~s, Combat:~w, Status:~w", [_Group, _Rid, _SrvId, _Name, _Combat, _Status]) end, Reply),
    continue(StateName, Reply, State);

%% 容错
handle_sync_event(_Event, _From, StateName, State) ->
    continue(StateName, ok, State).

handle_info(time_stop, expire, State) -> continue(expire, State);
handle_info(time_stop, _StateName, State = #state{role_list = RoleList}) -> 
    stop_all_combat(RoleList, []),
    {next_state, expire, State#state{ts = erlang:now(), timeout = 2 * 1000, report = timeout}, 2 * 1000};

handle_info(_Info, StateName, State) ->
    continue(StateName, State).

terminate(_Reason, _StateName, State = #state{role_list = RoleList, zone_id = _ZoneId, map_id = MapId}) ->
    ?DEBUG("竞技关闭[Seq:~w]", [_ZoneId]),
    cross_king_rank:update_rank(RoleList),
    leave(RoleList, State),
    map_mgr:stop(MapId),
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%% ------------------------------------------
%% 内部函数
%% -----------------------------------------

find_win([]) -> gfs;
find_win([#fighter{group = group_atk} | _T]) -> gfs;
find_win([#fighter{group = group_dfd} | _T]) -> ds;
find_win([_ | T]) -> find_win(T).

get_king_role_list(RoleIds) when is_list(RoleIds) ->
    get_king_role_list(RoleIds, []);
get_king_role_list(_) -> [].

get_king_role_list([], RoleList) -> RoleList;
get_king_role_list([{Rid, SrvId, IsDie, Pid} | T], RoleList) ->
    case cross_king_mgr:get_king_role({Rid, SrvId}) of
        KingRole = #cross_king_role{} ->
            get_king_role_list(T, [{IsDie, Pid, KingRole} | RoleList]);
        _ ->
            ?ERR("角色[~w:~s]数据查不到",[Rid, SrvId]),
            get_king_role_list(T, RoleList)
    end.

check_death_ds(MapId, Label, DsRole, DmgList) ->
    check_death_ds(MapId, Label, DsRole, DmgList, []).

%% 输 (不管是否死亡,都要次数加1)
check_death_ds(_, loss, [], _, NewDsRole) -> NewDsRole;
check_death_ds(MapId, loss, [{_, Pid, K = #cross_king_role{id = Id, name = Name, death = Death, dmg = AllDmg}} | T], DmgList, NewDsRole) when Death + 1 < ?ds_death_max ->
    %% 输的情况不管是否死亡,都要次数加1
    Dmg1 = case lists:keyfind(Id, 1, DmgList) of
        false -> 0;
        {_, D} -> D
    end,
    Dmg = case Dmg1 =:= 0 of
        true -> 3000;
        false -> Dmg1
    end,
    NewK = K#cross_king_role{death = Death + 1, combat = ?false, dmg = AllDmg + Dmg},
    role:pack_send(Pid, 17006, {0, Dmg, AllDmg + Dmg, ?ds_death_max - (Death + 1)}),
    broadcast_role(MapId, ds, AllDmg, AllDmg + Dmg, Id, Name, Dmg),
    check_death_ds(MapId, loss, T, DmgList, [{update, NewK} | NewDsRole]);
check_death_ds(MapId, loss, [{_, Pid, K = #cross_king_role{id = Id, name = Name, death = Death, dmg = AllDmg}} | T], DmgList, NewDsRole) ->
    Dmg1 = case lists:keyfind(Id, 1, DmgList) of
        false -> 0;
        {_, D} -> D
    end,
    Dmg = case Dmg1 =:= 0 of
        true -> 3000;
        false -> Dmg1
    end,
    NewK = K#cross_king_role{death = Death + 1, dmg = AllDmg + Dmg, combat = ?false, status = ?cross_king_role_status_idel},
    role:pack_send(Pid, 17006, {0, Dmg, AllDmg + Dmg, ?ds_death_max - (Death + 1)}),
    broadcast_role(MapId, ds, AllDmg, AllDmg + Dmg, Id, Name, Dmg),
    role:apply(async, Pid, {fun role_looks_update/1, []}),
    check_death_ds(MapId, loss, T, DmgList, [{die, NewK} | NewDsRole]);

%% 平 (次数仍要加1)
check_death_ds(_, draw_game, [], _, NewDsRole) -> NewDsRole;
check_death_ds(MapId, draw_game, [{_, Pid, K = #cross_king_role{id = Id, name = Name, death = Death, dmg = AllDmg}} | T], DmgList, NewDsRole) when Death + 1 < ?ds_death_max ->
    Dmg1 = case lists:keyfind(Id, 1, DmgList) of
        false -> 0;
        {_, D} -> D
    end,
    Dmg = case Dmg1 =:= 0 of
        true -> 3000;
        false -> Dmg1
    end,
    NewK = K#cross_king_role{death = Death + 1, combat = ?false, dmg = AllDmg + Dmg},
    role:pack_send(Pid, 17006, {2, Dmg, AllDmg + Dmg, ?ds_death_max - (Death + 1)}),
    broadcast_role(MapId, ds, AllDmg, AllDmg + Dmg, Id, Name, Dmg),
    check_death_ds(MapId, draw_game, T, DmgList, [{update, NewK} | NewDsRole]);
check_death_ds(MapId, draw_game, [{_, Pid, K = #cross_king_role{id = Id, name = Name, death = Death, dmg = AllDmg}} | T], DmgList, NewDsRole) ->
    Dmg1 = case lists:keyfind(Id, 1, DmgList) of
        false -> 0;
        {_, D} -> D
    end,
    Dmg = case Dmg1 =:= 0 of
        true -> 3000;
        false -> Dmg1
    end,
    NewK = K#cross_king_role{death = Death + 1, dmg = AllDmg + Dmg, combat = ?false, status = ?cross_king_role_status_idel},
    role:pack_send(Pid, 17006, {0, Dmg, AllDmg + Dmg, ?ds_death_max - (Death + 1)}),
    broadcast_role(MapId, ds, AllDmg, AllDmg + Dmg, Id, Name, Dmg),
    role:apply(async, Pid, {fun role_looks_update/1, []}),
    check_death_ds(MapId, draw_game, T, DmgList, [{die, NewK} | NewDsRole]);

%% 赢 (死亡次数则加1,不死则不加)
check_death_ds(_, win, [], _, NewDsRole) -> NewDsRole;
check_death_ds(MapId, win, [{?false, Pid, K = #cross_king_role{id = Id, name = Name, death = Death, dmg = AllDmg}} | T], DmgList, NewDsRole) ->
    %% 赢了 没死 
    Dmg1 = case lists:keyfind(Id, 1, DmgList) of
        false -> 0;
        {_, D} -> D
    end,
    Dmg = case Dmg1 =:= 0 of
        true -> 3000;
        false -> Dmg1
    end,
    NewK = K#cross_king_role{combat = ?false, dmg = AllDmg + Dmg},
    role:pack_send(Pid, 17006, {1, Dmg, AllDmg + Dmg, ?ds_death_max - Death}),
    broadcast_role(MapId, ds, AllDmg, AllDmg + Dmg, Id, Name, Dmg),
    check_death_ds(MapId, win, T, DmgList, [{update, NewK} | NewDsRole]);
check_death_ds(MapId, win, [{?true, Pid, K = #cross_king_role{id = Id, name = Name, death = Death, dmg = AllDmg}} | T], DmgList, NewDsRole) when Death + 1 < ?ds_death_max ->
    %% 虽然赢了,但是死了,次数还要加1
    Dmg1 = case lists:keyfind(Id, 1, DmgList) of
        false -> 0;
        {_, D} -> D
    end,
    Dmg = case Dmg1 =:= 0 of
        true -> 3000;
        false -> Dmg1
    end,
    NewK = K#cross_king_role{death = Death + 1, combat = ?false, dmg = AllDmg + Dmg},
    role:pack_send(Pid, 17006, {1, Dmg, AllDmg + Dmg, ?ds_death_max - (Death + 1)}),
    broadcast_role(MapId, ds, AllDmg, AllDmg + Dmg, Id, Name, Dmg),
    check_death_ds(MapId, win, T, DmgList, [{update, NewK} | NewDsRole]);
check_death_ds(MapId, win, [{?true, Pid, K = #cross_king_role{id = Id, name = Name, death = Death, dmg = AllDmg}} | T], DmgList, NewDsRole) ->
    %% 虽然赢了,但是死了,次数还要加1
    Dmg1 = case lists:keyfind(Id, 1, DmgList) of
        false -> 0;
        {_, D} -> D
    end,
    Dmg = case Dmg1 =:= 0 of
        true -> 3000;
        false -> Dmg1
    end,
    NewK = K#cross_king_role{dmg = AllDmg + Dmg, death = Death + 1, combat = ?false, status = ?cross_king_role_status_idel},
    role:pack_send(Pid, 17006, {1, Dmg, AllDmg + Dmg, ?ds_death_max - (Death + 1)}),
    broadcast_role(MapId, ds, AllDmg, AllDmg + Dmg, Id, Name, Dmg),
    role:apply(async, Pid, {fun role_looks_update/1, []}),
    check_death_ds(MapId, win, T, DmgList, [{die, NewK} | NewDsRole]).

check_death_gfs(MapId, Label, GfsRole, KillNum) ->
    check_death_gfs(MapId, Label, GfsRole, KillNum, []).

%% 输 (死亡次数必加1)
check_death_gfs(_, loss, [], _, NewGfsRole) -> NewGfsRole;
check_death_gfs(MapId, loss, [{_, Pid, K = #cross_king_role{kill = Kill, death = Death}} | T], KillNum, NewGfsRole) when Death + 1 < ?gfs_death_max ->
    NewK = K#cross_king_role{pet_status = [], death = Death + 1, combat = ?false},
    role:pack_send(Pid, 17006, {0, 0, Kill, ?gfs_death_max - (Death + 1)}),
    check_death_gfs(MapId, loss, T, KillNum, [{update, NewK} | NewGfsRole]);
check_death_gfs(MapId, loss, [{_, Pid, K = #cross_king_role{kill = Kill, death = Death}} | T], KillNum, NewGfsRole) ->
    NewK = K#cross_king_role{pet_status = [], death = Death + 1, combat = ?false, status = ?cross_king_role_status_idel},
    role:pack_send(Pid, 17006, {0, 0, Kill, ?gfs_death_max - (Death + 1)}),
    role:apply(async, Pid, {fun role_looks_update/1, []}),
    check_death_gfs(MapId, loss, T, KillNum, [{die, NewK} | NewGfsRole]);

%% 平 (不加死亡次数,不计战斗结果)
check_death_gfs(_, draw_game, [], _, NewGfsRole) -> NewGfsRole;
check_death_gfs(MapId, draw_game, [{_, Pid, K = #cross_king_role{kill = Kill, death = Death}} | T], KillNum, NewGfsRole) ->
    NewK = K#cross_king_role{combat = ?false},
    role:pack_send(Pid, 17006, {2, 0, Kill, ?gfs_death_max - Death}),
    check_death_gfs(MapId, draw_game, T, KillNum, [{update, NewK} | NewGfsRole]);

%% 赢 (增加连斩数)
check_death_gfs(_, win, [], _, NewGfsRole) -> NewGfsRole;
check_death_gfs(MapId, win, [{_, Pid, K = #cross_king_role{id = Id, name = Name, kill = Kill, death = Death}} | T], KillNum, NewGfsRole) ->
    NewK = K#cross_king_role{combat = ?false, kill = Kill + KillNum},
    role:pack_send(Pid, 17006, {1, KillNum, Kill + KillNum, ?gfs_death_max - Death}),
    broadcast_role(MapId, gfs, Kill, Kill + KillNum, Id, Name, KillNum),
    check_death_gfs(MapId, win, T, KillNum, [{update, NewK} | NewGfsRole]).

update_state([], RoleList, GfsList, DsList, CombatList, OffList) ->
    {RoleList, GfsList, DsList, CombatList, OffList};
update_state([{die, K = #cross_king_role{id = Id, pid = Pid}} | T], RoleList, GfsList, DsList, CombatList, OffList) ->
    %% 一个屌丝阵亡了/ 一个高富帅阵亡了.
    NewRoleList = case lists:keyfind(Id, #cross_king_role.id, RoleList) of %% 更新玩家列表
        false -> RoleList;
        _ -> lists:keyreplace(Id, #cross_king_role.id, RoleList, K)
    end,
    NewCombatList = case lists:keyfind(Id, #cross_king_role.id, CombatList) of %% 清除战斗列表
        false -> CombatList;
        _ -> lists:keydelete(Id, #cross_king_role.id, CombatList)
    end,
    NewOffList = case lists:keyfind(Id, #cross_king_role.id, OffList) of %% 加入不可战斗列表 
        false -> [K | OffList];
        _ -> lists:keyreplace(Id, #cross_king_role.id, OffList, K)
    end,
    send_zone_info(Pid, NewRoleList),
    update_state(T, NewRoleList, GfsList, DsList, NewCombatList, NewOffList);
update_state([{update, K = #cross_king_role{id = Id, group = 0}} | T], RoleList, GfsList, DsList, CombatList, OffList) ->
    %% 屌丝更新.
    NewRoleList = case lists:keyfind(Id, #cross_king_role.id, RoleList) of %% 更新玩家列表
        false -> RoleList;
        _ -> lists:keyreplace(Id, #cross_king_role.id, RoleList, K)
    end,
    NewCombatList = case lists:keyfind(Id, #cross_king_role.id, CombatList) of %% 清除战斗列表
        false -> CombatList;
        _ -> lists:keydelete(Id, #cross_king_role.id, CombatList)
    end,
    NewDsList = case lists:keyfind(Id, #cross_king_role.id, DsList) of %% 加入活动列表 
        false -> DsList ++ [K];
        _ -> lists:keyreplace(Id, #cross_king_role.id, DsList, K)
    end,
    NewOffList = case lists:keyfind(Id, #cross_king_role.id, OffList) of %% 下线列表清除
        false -> OffList;
        _ -> lists:keydelete(Id, #cross_king_role.id, OffList)
    end,
    update_state(T, NewRoleList, GfsList, NewDsList, NewCombatList, NewOffList);
update_state([{update, K = #cross_king_role{id = Id, group = 1}} | T], RoleList, GfsList, DsList, CombatList, OffList) ->
    %% 高富帅更新.
    NewRoleList = case lists:keyfind(Id, #cross_king_role.id, RoleList) of %% 更新玩家列表
        false -> RoleList;
        _ -> lists:keyreplace(Id, #cross_king_role.id, RoleList, K)
    end,
    NewCombatList = case lists:keyfind(Id, #cross_king_role.id, CombatList) of %% 清除战斗列表
        false -> CombatList;
        _ -> lists:keydelete(Id, #cross_king_role.id, CombatList)
    end,
    NewGfsList = case lists:keyfind(Id, #cross_king_role.id, GfsList) of %% 加入活动列表 
        false -> GfsList ++ [K];
        _ -> lists:keyreplace(Id, #cross_king_role.id, GfsList, K)
    end,
    NewOffList = case lists:keyfind(Id, #cross_king_role.id, OffList) of %% 下线列表清除
        false -> OffList;
        _ -> lists:keydelete(Id, #cross_king_role.id, OffList)
    end,
    update_state(T, NewRoleList, NewGfsList, DsList, NewCombatList, NewOffList).


combat_over(MapId, draw_game, Gfs, Ds, RoleList, GfsList, DsList, CombatList, OffList, DmgList) ->
    GfsRole = get_king_role_list(Gfs),
    DsRole = get_king_role_list(Ds),
    NewGfsRole = check_death_gfs(MapId, draw_game, GfsRole, 0),
    NewDsRole = check_death_ds(MapId, draw_game, DsRole, DmgList),
    UpdateEts = [K || {_, K} <- (NewGfsRole ++ NewDsRole)],
    update_ets_gfs_ds(UpdateEts),
    update_state(NewGfsRole ++ NewDsRole, RoleList, GfsList, DsList, CombatList, OffList);

combat_over(MapId, gfs_win, Gfs, Ds, RoleList, GfsList, DsList, CombatList, OffList, DmgList) ->
    GfsRole = get_king_role_list(Gfs),
    DsRole = get_king_role_list(Ds),
    NewGfsRole = check_death_gfs(MapId, win, GfsRole, length(DsRole)),
    NewDsRole = check_death_ds(MapId, loss, DsRole, DmgList),
    UpdateEts = [K || {_, K} <- (NewGfsRole ++ NewDsRole)],
    update_ets_gfs_ds(UpdateEts),
    update_state(NewGfsRole ++ NewDsRole, RoleList, GfsList, DsList, CombatList, OffList);

combat_over(MapId, ds_win, Gfs, Ds, RoleList, GfsList, DsList, CombatList, OffList, DmgList) ->
    GfsRole = get_king_role_list(Gfs),
    DsRole = get_king_role_list(Ds),
    NewGfsRole = check_death_gfs(MapId, loss, GfsRole, 0),
    NewDsRole = check_death_ds(MapId, win, DsRole, DmgList),
    UpdateEts = [K || {_, K} <- (NewGfsRole ++ NewDsRole)],
    update_ets_gfs_ds(UpdateEts),
    update_state(NewGfsRole ++ NewDsRole, RoleList, GfsList, DsList, CombatList, OffList).

%% 关闭，玩家都退出
leave([], _State) -> ok;
leave([#cross_king_role{pid = RolePid, status = Status} | T], State) ->
    case Status =:= ?cross_king_role_status_match orelse Status =:= ?cross_king_role_status_idel of
        true -> role:apply(async, RolePid, {cross_king, leave_match, []});
        false -> ignore
    end,
    leave(T, State).

%% 玩家离开
leave_match(Role = #role{hp_max = HpMax, mp_max = MpMax, name = _Name, looks = Looks}) ->
    ?DEBUG("角色退出场景[RoleName:~s]", [_Name]),
    {_MapId, X, Y} = util:rand_list(?cross_king_exit),
    XRand = util:rand(-20, 20),
    YRand = util:rand(-20, 20),
    NewLooks = case lists:keyfind(?LOOKS_TYPE_KING, 1, Looks) of
        false -> Looks;
        _ -> lists:keydelete(?LOOKS_TYPE_KING, 1, Looks)
    end,
    NewLooks1 = case lists:keyfind(?LOOKS_TYPE_ALPHA, 1, NewLooks) of
        false -> NewLooks;
        _ -> lists:keydelete(?LOOKS_TYPE_ALPHA, 1, NewLooks)
    end,
    case map:role_enter(10003, X+XRand, Y+YRand, Role#role{event = ?event_no, hp = HpMax, mp = MpMax, cross_srv_id = <<>>, looks = NewLooks1}) of
        {ok, NewRole} -> {ok, NewRole};
        {false, _Why} ->
            ?DEBUG("[~s]退出竞技场失败[Reason:~w]", [_Name, _Why]),
            {ok}
    end.

%% 获取玩家战斗进程ID
apply_get_combat_pid(#role{status = ?status_fight, combat_pid = CombatPid}) ->
    {ok, {ok, CombatPid}};
apply_get_combat_pid(_Role) ->
    {ok, {false, ?L(<<"不在战斗中">>)}}.

%% 获取某方存活人数
get_live(RoleList) -> get_live(RoleList, []).
get_live([], RoleList) -> {length(RoleList), RoleList};
get_live([#cross_king_role{status = 0} | T], RoleList) -> get_live(T, RoleList); %% 死亡状态
get_live([#cross_king_role{status = 1} | T], RoleList) -> get_live(T, RoleList); %% 状态不正确的 
get_live([#cross_king_role{status = 3} | T], RoleList) -> get_live(T, RoleList); %% 离开竞技场
get_live([#cross_king_role{status = 4} | T], RoleList) -> get_live(T, RoleList); %% 下线的
get_live([K = #cross_king_role{death = Death, group = 0} | T], RoleList) when Death < ?ds_death_max ->
    get_live(T, [K | RoleList]);
get_live([K = #cross_king_role{death = Death, group = 1} | T], RoleList) when Death < ?gfs_death_max->
    get_live(T, [K | RoleList]);
get_live([_ | T], RoleList) -> get_live(T, RoleList).

get_free_gfs(GfsList) -> get_free_gfs(GfsList, [], []).
get_free_gfs([], GetGfs, LastGfsList) -> {lists:reverse(GetGfs), lists:reverse(LastGfsList)};
get_free_gfs([K = #cross_king_role{death = Death, status = ?cross_king_role_status_match, combat = ?false} | T], GetGfs, LastGfsList) when Death < ?gfs_death_max -> %% 在正式区中,且无死亡次数,且战斗状态无高富帅才为空闲
    get_free_gfs(T, [K | GetGfs], LastGfsList);
get_free_gfs([K | T], GetGfs, LastGfsList) ->
    get_free_gfs(T, GetGfs, [K | LastGfsList]).

get_free_ds(DsList, Num) ->
    get_free_ds(DsList, Num, []).
get_free_ds([], _Num, GetDs) ->
    {lists:reverse(GetDs), []};
get_free_ds(T, Num, GetDs) when Num =< 0 ->
    {lists:reverse(GetDs), T};
get_free_ds([K | T], Num, GetDs) ->
    get_free_ds(T, Num - 1, [K | GetDs]).

stop_all_combat([], _CombatPidList) -> ok;
stop_all_combat([#cross_king_role{pid = RolePid, status = ?cross_king_role_status_match} | T], CombatPidList) ->
    case role:apply(sync, RolePid, {cross_king, apply_get_combat_pid, []}) of
        {ok, CombatPid} ->
            case lists:member(CombatPid, CombatPidList) of
                true -> stop_all_combat(T, CombatPidList);
                false ->
                    combat_type:stop_combat(CombatPid),
                    stop_all_combat(T, [CombatPid | CombatPidList])
            end;
        _ -> stop_all_combat(T, CombatPidList)
    end;
stop_all_combat([_ | T], CombatPidList) ->
    stop_all_combat(T, CombatPidList).

do_check_match(RoleList, GfsList, DsList, CombatList, OffList) ->
    {GetGfs, LastGfsList} = get_free_gfs(GfsList),
    ?DEBUG("-------取到空余高富帅------"),
    print(GetGfs),
    ?DEBUG("-------剩下高富帅------"),
    print(LastGfsList),
    case GetGfs of
        [] ->
            ?DEBUG("无空闲高富帅"),
            {RoleList, GfsList, DsList, CombatList, OffList};
        GetGfs ->
            ?DEBUG("空闲高富帅为:~w名",[length(GetGfs)]),
            do_combat_start(RoleList, GetGfs, LastGfsList, DsList, CombatList, OffList)
    end.

do_combat_start(RoleList, GetGfs, LastGfsList, DsList, CombatList, OffList) ->
    do_combat_start(RoleList, GetGfs, LastGfsList, DsList, [], [], CombatList, OffList).

do_combat_start(RoleList, [], LastGfsList, DsList, NewGfs, NewDs, CombatList, OffList) ->
    {RoleList, LastGfsList ++ NewGfs, DsList ++ NewDs, CombatList, OffList};
do_combat_start(RoleList, [K = #cross_king_role{id = RoleId, try_time = TryTime}| T], LastGfsList, DsList, NewGfs, NewDs, CombatList, OffList) ->
    {FreeDs, LastDsList} = get_free_ds(DsList, 3),
    FreeDsLen = length(FreeDs),
    if 
        FreeDsLen =:= 0 ->
            {RoleList, [K | T] ++ LastGfsList ++ NewGfs, DsList ++ NewDs, CombatList, OffList};
        true -> %% 找到有空闲屌丝
            {L1, Fails1} = roles_to_fighters([RoleId]),
            {L2, Fails2} = roles_to_fighters([Id || #cross_king_role{id = Id} <- FreeDs]),
            if
                length(L1) =/= 1 -> %% 高富帅有问题
                    case check_fight_fail_reason(gfs, K, Fails1) of
                        error -> %% 状态不对, 直接丢到不可发起列表
                            NewK = K#cross_king_role{status = ?cross_king_role_status_idel},
                            NewRoleList = update_role_list([NewK], RoleList),
                            update_ets_gfs_ds([NewK]),
                            NewOffList = [NewK | OffList],
                            do_combat_start(NewRoleList, T, LastGfsList, DsList, NewGfs, NewDs, CombatList, NewOffList);
                        try_end -> %% 重试次数到头
                            ?DEBUG("重试次数已经到头,不再尝试重试"),
                            NewK = K#cross_king_role{status = ?cross_king_role_status_idel},
                            NewRoleList = update_role_list([NewK], RoleList),
                            update_ets_gfs_ds([NewK]),
                            NewOffList = [NewK | OffList],
                            do_combat_start(NewRoleList, T, LastGfsList, DsList, NewGfs, NewDs, CombatList, NewOffList);
                        try_more -> %% 下线或者断开连接, 尝试重连
                            NewK = K#cross_king_role{try_time = TryTime + 1}, 
                            NewRoleList = update_role_list([NewK], RoleList),
                            update_ets_gfs_ds([NewK]),
                            do_combat_start(NewRoleList, T, LastGfsList, DsList, NewGfs ++ [NewK], NewDs, CombatList, OffList)
                    end;
                length(L2) =/= length(FreeDs) -> %% 屌丝有问题
                    %% {可以重新排队屌丝, 已经到off列表屌丝, 正常屌丝}
                    {BackDs, DelDs, NormalDs} = check_fight_fail_reason(ds, FreeDs, Fails2), 
                    case length(L2) of 
                        0 -> %% 之前屌丝全失败了
                            %% 这位高富帅运气不好, 你重新下一轮吧
                            NewOffList = OffList ++ [DelDs],
                            NewRoleList = update_role_list(BackDs ++ DelDs, RoleList),
                            update_ets_gfs_ds(BackDs ++ DelDs),
                            do_combat_start(NewRoleList, T, LastGfsList, LastDsList, NewGfs ++ [K], NewDs ++ NormalDs ++ BackDs, CombatList, NewOffList);
                        _ -> %% 之前列表不为空 ,表示至少有1个屌丝正常
                            case combat:start(?combat_type_cross_king, self(), L1, L2) of
                                {ok, _CombatPid} ->
                                    lists:foreach(fun(#cross_king_role{group = _Group, id = {_Rid, _SrvId}, name = _Name}) ->
                                                ?DEBUG("Group:~w, Rid:~w, SrvId:~s, Name:~s", [_Group, _Rid, _SrvId, _Name]) end,
                                        [K | NormalDs]),
                                    [NewK] = do_fix_combat([K], ?true),
                                    NewCombatDs = do_fix_combat(NormalDs, ?true),
                                    NewRoleList = update_role_list([NewK] ++ NewCombatDs ++ BackDs ++ DelDs, RoleList),
                                    NewOffList = OffList ++ DelDs,
                                    update_ets_gfs_ds([NewK] ++ NewCombatDs ++ BackDs ++ DelDs),
                                    do_combat_start(NewRoleList, T, LastGfsList, LastDsList, NewGfs, NewDs ++ BackDs, CombatList ++ [NewK] ++ NewCombatDs, NewOffList);
                                _Why ->
                                    ?ERR("发起战斗失败:~w",[_Why]),
                                    %% 发起失败的丢到缓存列表,最后加在列表的末端
                                    NewOffList = OffList ++ DelDs,
                                    NewRoleList = update_role_list(BackDs ++ DelDs, RoleList),
                                    update_ets_gfs_ds(BackDs ++ DelDs),
                                    do_combat_start(NewRoleList, T, LastGfsList, LastDsList, NewGfs ++ [K], NewDs ++ NormalDs ++ BackDs, CombatList, NewOffList)
                            end
                    end;
                true -> %% 全部正常 
                    case combat:start(?combat_type_cross_king, self(), L1, L2) of
                        {ok, _CombatPid} ->
                            lists:foreach(fun(#cross_king_role{group = _Group, id = {_Rid, _SrvId}, name = _Name}) ->
                                        ?DEBUG("Group:~w, Rid:~w, SrvId:~s, Name:~s", [_Group, _Rid, _SrvId, _Name]) end,
                                [K | FreeDs]),
                            [NewK] = do_fix_combat([K], ?true),
                            NewFreeDs = do_fix_combat(FreeDs, ?true),
                            update_ets_gfs_ds([NewK | NewFreeDs]),
                            NewRoleList = update_role_list([NewK | NewFreeDs], RoleList),
                            do_combat_start(NewRoleList, T, LastGfsList, LastDsList, NewGfs, NewDs, CombatList ++ [NewK] ++ NewFreeDs, OffList); %% 发起成功的角色丢到战斗列表
                        _Why -> 
                            ?ERR("发起战斗失败:~w",[_Why]),
                            %% 发起失败的丢到缓存列表,最后加在列表的末端
                            do_combat_start(RoleList, T, LastGfsList, LastDsList, NewGfs ++ [K], NewDs ++ FreeDs, CombatList, OffList)
                    end
            end
    end.

check_fight_fail_reason(gfs, #cross_king_role{id = Id, try_time = TryNum}, Fails) ->
    Flag = case lists:keyfind(Id, 1, Fails) of
        false -> try_more;
        {_, offline} -> try_more; 
        _ -> error
    end,
    NewFlag = case Flag =:= try_more andalso TryNum >= 5 of
        true -> try_end;
        _ -> Flag
    end,
    NewFlag;

check_fight_fail_reason(ds, DsRole, Fails) ->
    check_fight_fail_reason(ds, DsRole, Fails, [], [], []).
check_fight_fail_reason(ds, [], _Fails, BackDs, DelDs, NormalDs) -> {BackDs, DelDs, NormalDs};
check_fight_fail_reason(ds, [K = #cross_king_role{id = Id, try_time = TryNum} | T], Fails, BackDs, DelDs, NormalDs) ->
    Flag = case lists:keyfind(Id, 1, Fails) of
        false -> normal;
        {_, offline} -> try_more;
        _ -> error
    end,
    NewFlag = case Flag =:= try_more andalso TryNum >= 5 of
        true -> try_end;
        _ -> Flag
    end,
    case NewFlag of
        error -> 
            check_fight_fail_reason(ds, T, Fails, BackDs, [K | DelDs], NormalDs);
        try_end -> 
            check_fight_fail_reason(ds, T, Fails, BackDs, [K | DelDs], NormalDs);
        normal ->
            check_fight_fail_reason(ds, T, Fails, BackDs, DelDs, [K | NormalDs]);
        try_more ->
            check_fight_fail_reason(ds, T, Fails, [K | BackDs], DelDs, NormalDs)
    end.

do_fix_combat(RoleList, Label) ->
    do_fix_combat(RoleList, Label, []).
do_fix_combat([], _, NewRoleList) -> lists:reverse(NewRoleList);
do_fix_combat([K | T], Label, NewRoleList) ->
    NewK = K#cross_king_role{combat = Label},
    do_fix_combat(T, Label, [NewK | NewRoleList]).

update_ets_gfs_ds([]) -> ok;
update_ets_gfs_ds([K | T]) ->
    cross_king_mgr:update_cache(K),
    update_ets_gfs_ds(T).

update_role_list([], RoleList) -> RoleList;
update_role_list([K = #cross_king_role{id = {Rid, SrvId}} | T], RoleList) ->
    case lists:keyfind({Rid, SrvId}, #cross_king_role.id, RoleList) of
        false ->
            ?ERR("至尊王者正式区记录不一致:[~w:~s]",[Rid, SrvId]),
            update_role_list(T, RoleList);
        _ ->
            update_role_list(T, lists:keyreplace({Rid, SrvId}, #cross_king_role.id, RoleList, K))
    end.
    
roles_to_fighters(RoleIds) ->
    %% 因为偶尔会timeout，所以加入多次尝试
    RoleIds1 = [{RoleId, 0} || RoleId <- RoleIds],
    roles_to_fighters(RoleIds1, [], []).
roles_to_fighters([], Result, Fails) -> {Result, Fails};
roles_to_fighters([{RoleId = {Rid, SrvId}, TryNum}|T], Result, Fails) when TryNum < 3 ->
    case catch c_proxy:role_lookup(by_id, RoleId, to_fighter) of
        {ok, _, #converted_fighter{fighter_ext = #fighter_ext_role{event = Event}}} when (Event =/= ?event_cross_king_match) ->
            ?ERR("[~w, ~s]的当前事件状态不正确[Event=~w]，无法加入战斗", [Rid, SrvId, Event]),
            roles_to_fighters(T, Result, [{RoleId, event}|Fails]);
        {ok, _, CF = #converted_fighter{}} ->
            roles_to_fighters(T, [CF|Result], Fails);
        {error, timeout} -> %% 超时，重试3次
            ?INFO("查找并转换跨服角色[~w, ~s]超时，正在重试第~w次", [Rid, SrvId, TryNum+1]),
            roles_to_fighters([{RoleId, TryNum+1}|T], Result, Fails);
        {error, not_found} -> %% 掉线
            ?INFO("[~w, ~s]掉线，查找不到了", [Rid, SrvId]),
            roles_to_fighters(T, Result, [{RoleId, offline}|Fails]);
        _Err -> 
            ?ERR("查找并转换跨服角色[~w, ~s]出错:~w", [Rid, SrvId, _Err]),
            roles_to_fighters(T, Result, [{RoleId, _Err}|Fails])
    end;
roles_to_fighters([{RoleId = {Rid, SrvId}, _TryNum}|T], Result, Fails) ->
    case catch c_proxy:role_lookup(by_id, RoleId, to_fighter) of
        {ok, _, #converted_fighter{fighter_ext = #fighter_ext_role{event = Event}}} when (Event =/= ?event_cross_king_match) ->
            ?ERR("[~w, ~s]的当前事件状态不正确[Event=~w]，无法加入战斗", [Rid, SrvId, Event]),
            roles_to_fighters(T, Result, [{RoleId, event}|Fails]);
        {ok, _, CF = #converted_fighter{}} ->
            roles_to_fighters(T, [CF|Result], Fails);
        {error, timeout} -> %% 超时
            ?INFO("查找并转换跨服角色[~w, ~s]还是超时", [Rid, SrvId]),
            roles_to_fighters(T, Result, [{RoleId, timeout}|Fails]);
        {error, not_found} -> %% 掉线
            ?INFO("[~w, ~s]掉线，查找不到了", [Rid, SrvId]),
            roles_to_fighters(T, Result, [{RoleId, offline}|Fails]);
        _Err -> 
            ?ERR("查找并转换跨服角色[~w, ~s]出错:~w", [Rid, SrvId, _Err]),
            roles_to_fighters(T, Result, [{RoleId, _Err}|Fails])
    end.

print([]) -> ok;
print([#cross_king_role{group = _Group, name = _Name, combat = _Combat, status = _Status} | T]) ->
    ?DEBUG("Group:~w, Name:~s, Combat:~w, Status:~w",[_Group, _Name, _Combat, _Status]),
    print(T).

broadcast_group(#state{map_id = MapId, gfs_list = GfsList, ds_list = DsList}) ->
    broadcast_group(MapId, GfsList, DsList).

broadcast_group(MapId, GfsList, DsList) ->
    Gfs = [{Rid, SrvId, Name, Career, Fight, PetFight, Kill} || #cross_king_role{id = {Rid, SrvId}, name = Name, career = Career, fight_capacity = Fight, pet_fight = PetFight, kill = Kill} <- GfsList],
    Ds = [{Rid, SrvId, Name, Career, Fight, PetFight, Dmg} || #cross_king_role{id = {Rid, SrvId}, name = Name, career = Career, fight_capacity = Fight, pet_fight = PetFight, dmg = Dmg} <- DsList],
    map:pack_send_to_all(MapId, 17004, {Gfs, Ds}).

broadcast_role(_, _, _, _, _, _, 0) -> skip;
broadcast_role(MapId, gfs, OldKill, NewKill, {Rid, SrvId}, Name, _Add) ->
    if
        OldKill < 15 andalso NewKill >= 15 ->
            RoleMsg = notice:role_to_msg({Rid, SrvId, Name}),
            map:pack_send_to_all(MapId, 10931, {53, util:fbin(?L(<<"王者无敌，至尊降临，~s成功指导了超过15个求道者，理应受万仙膜拜！">>), [RoleMsg]), []});
        OldKill < 30 andalso NewKill >= 30 ->
            RoleMsg = notice:role_to_msg({Rid, SrvId, Name}),
            map:pack_send_to_all(MapId, 10931, {53, util:fbin(?L(<<"王者无敌，至尊降临，~s成功指导了超过30个求道者，理应受万仙膜拜！">>), [RoleMsg]), []});
        OldKill < 45 andalso NewKill >= 45 ->
            RoleMsg = notice:role_to_msg({Rid, SrvId, Name}),
            map:pack_send_to_all(MapId, 10931, {53, util:fbin(?L(<<"王者无敌，至尊降临，~s成功指导了超过45个求道者，理应受万仙膜拜！">>), [RoleMsg]), []});
        OldKill < 60 andalso NewKill >= 60 ->
            RoleMsg = notice:role_to_msg({Rid, SrvId, Name}),
            map:pack_send_to_all(MapId, 10931, {53, util:fbin(?L(<<"王者无敌，至尊降临，~s成功指导了超过60个求道者，理应受万仙膜拜！">>), [RoleMsg]), []});
        true -> skip
    end;

broadcast_role(MapId, ds, OldDmg, NewDmg, {Rid, SrvId}, Name, _Add) ->
    if
        OldDmg < 150000 andalso NewDmg >= 150000 ->
            RoleMsg = notice:role_to_msg({Rid, SrvId, Name}),
            map:pack_send_to_all(MapId, 10931, {53, util:fbin(?L(<<" 路漫漫其修远兮，~s通过王者指导，求道值已经超过150000，真是求道者的典范！">>), [RoleMsg]), []});
        OldDmg < 300000 andalso NewDmg >= 300000 ->
            RoleMsg = notice:role_to_msg({Rid, SrvId, Name}),
            map:pack_send_to_all(MapId, 10931, {53, util:fbin(?L(<<" 路漫漫其修远兮，~s通过王者指导，求道值已经超过300000，真是求道者的典范！">>), [RoleMsg]), []});
        OldDmg < 450000 andalso NewDmg >= 450000 ->
            RoleMsg = notice:role_to_msg({Rid, SrvId, Name}),
            map:pack_send_to_all(MapId, 10931, {53, util:fbin(?L(<<" 路漫漫其修远兮，~s通过王者指导，求道值已经超过450000，真是求道者的典范！">>), [RoleMsg]), []});
        OldDmg < 600000 andalso NewDmg >= 600000 ->
            RoleMsg = notice:role_to_msg({Rid, SrvId, Name}),
            map:pack_send_to_all(MapId, 10931, {53, util:fbin(?L(<<" 路漫漫其修远兮，~s通过王者指导，求道值已经超过600000，真是求道者的典范！">>), [RoleMsg]), []});
        true -> skip
    end;

broadcast_role(_, _, _, _, _, _, _) -> skip.


%%----------------------------------------------------
%% 状态处理
%%----------------------------------------------------

%% 比赛已经结束
idel(timeout, State = #state{zone_id = ZoneId, gfs_list = GfsList, ds_list = DsList}) ->
    ?INFO("至尊王者~w号战区正式开始,[~w:~w]", [ZoneId, length(GfsList), length(DsList)]),
    {next_state, check_match, State#state{ts = erlang:now(), timeout = 10 * 1000}, 10 * 1000};
idel(_Any, State) ->
    continue(idel, State).

check_match(timeout, State = #state{role_list = RoleList, gfs_list = GfsList, ds_list = DsList, combat_list = CombatList, off_list = OffList}) ->
    %% TODO 检测所有空余的高富帅发起战斗
    ?DEBUG("[至尊王者]轮询开始"),
%%    ?DEBUG("-------高富帅列表顺序----------"),
%%    print(GfsList),
%%    ?DEBUG("--------屌丝列表顺序----------"),
%%    print(DsList),
%%    ?DEBUG("--------战斗列表顺序----------"),
%%    print(CombatList),
%%    ?DEBUG("------不可动列表顺序----------"),
%%    print(OffList),
%%    ?DEBUG("------------end---------------"),
    {GfsLive, _} = get_live(GfsList),
    {DsLive, _} = get_live(DsList),
    case (GfsLive =:= 0 orelse DsLive =:= 0) andalso CombatList =:= [] of
        true ->
            %% 战斗结束了
            Flag = case DsLive =:= 0 of
                true -> gfs;
                false -> ds
            end,
            {next_state, expire, State#state{ts = erlang:now(), timeout = 2 * 1000, report = Flag}, 2 * 1000};
        false ->
            %% 未结束
            {NewRoleList, NewGfsList, NewDsList, NewCombatList, NewOffList} =
            do_check_match(RoleList, GfsList, DsList, CombatList, OffList),
%%          ?DEBUG("-------高富帅列表顺序----------"),
%%          print(NewGfsList),
%%          ?DEBUG("--------屌丝列表顺序----------"),
%%          print(NewDsList),
%%          ?DEBUG("--------战斗列表顺序----------"),
%%          print(NewCombatList),
%%          ?DEBUG("------------end---------------"),
            NewState = State#state{role_list = NewRoleList, gfs_list = NewGfsList, ds_list = NewDsList, combat_list = NewCombatList, off_list = NewOffList, ts = erlang:now(), timeout = 10 * 1000},
            case NewGfsList =:= GfsList andalso NewDsList =:= DsList of
                true -> skip;
                false -> broadcast_group(NewState)
            end,
            {next_state, match, NewState, 10 * 1000}
    end;
check_match(_Any, State) ->
    continue(check_match, State).

match(timeout, State) ->
    {next_state, check_match, State#state{ts = erlang:now(), timeout = 10 * 1000}, 10 * 1000};
match(_Any, State) ->
    continue(match, State).

expire(timeout, State = #state{role_list = RoleList, map_id = MapId, zone_id = _Seq, report = Report}) ->
    ?DEBUG("[至尊王者]时间到结束比赛[Seq:~w]", [_Seq]),
    spawn(fun() ->
                do_send_mail(Report, RoleList)
        end),
    Gfs = [{Rid, SrvId, Name, Career, Lev, Fight, PetFight, Death, Kill} || #cross_king_role{id = {Rid, SrvId}, name = Name, career = Career, fight_capacity = Fight, pet_fight = PetFight, kill = Kill, group = 1, death = Death, lev = Lev} <- RoleList],
    Ds = [{Rid, SrvId, Name, Career, Lev, Fight, PetFight, Death, Dmg} || #cross_king_role{id = {Rid, SrvId}, name = Name, career = Career, fight_capacity = Fight, pet_fight = PetFight, dmg = Dmg, group = 0, death = Death, lev = Lev} <- RoleList],
    case Report of
        timeout ->
            map:pack_send_to_all(MapId, 17005, {1, Gfs, Ds});
        gfs ->
            map:pack_send_to_all(MapId, 17005, {2, Gfs, Ds});
        ds ->
            map:pack_send_to_all(MapId, 17005, {3, Gfs, Ds});
        _ ->
            map:pack_send_to_all(MapId, 17005, {0, Gfs, Ds})
    end,
    {stop, normal, State};
expire(_Any, State) ->
    continue(expire, State).

%% ---------------------
%% 状态处理
%% ---------------------
continue(StateName, State = #state{ts = Ts, timeout = Timeout}) ->
    {next_state, StateName, State, util:time_left(Timeout, Ts)}.

continue(StateName, Reply, State = #state{ts = Ts, timeout = Timeout}) ->
    {reply, Reply, StateName, State, util:time_left(Timeout, Ts)}.

%% -------------
%% 内部函数
%% -------------
send_zone_info(Pid, RoleList) when is_pid(Pid) ->
    Gfs = [{Rid, SrvId, Name, Career, Lev, Fight, PetFight, Death, Kill} || #cross_king_role{id = {Rid, SrvId}, name = Name, career = Career, fight_capacity = Fight, pet_fight = PetFight, kill = Kill, group = 1, death = Death, lev = Lev} <- RoleList],
    Ds = [{Rid, SrvId, Name, Career, Lev, Fight, PetFight, Death, Dmg} || #cross_king_role{id = {Rid, SrvId}, name = Name, career = Career, fight_capacity = Fight, pet_fight = PetFight, dmg = Dmg, group = 0, death = Death, lev = Lev} <- RoleList],
    role:pack_send(Pid, 17005, {0, Gfs, Ds}); 
send_zone_info(_, _) -> skip.


role_looks_update(Role = #role{looks = Looks}) ->
    case lists:keyfind(?LOOKS_TYPE_ALPHA, 1, Looks) of
        false -> 
            NewLooks = [{?LOOKS_TYPE_ALPHA, 0, ?LOOKS_VAL_ALPHA_ARENA} | Looks],
            NewRole = Role#role{looks = NewLooks},
            map:role_update(NewRole),
            {ok, NewRole};
        _Other -> {ok}
    end.

%% 发送邮件
do_send_mail(gfs, []) -> ok;
do_send_mail(gfs, [#cross_king_role{id = {Rid, SrvId}, name = Name, group = 1, kill = Kill, death = Death, lev = Lev} | T]) ->
    c_mirror_group:cast(node, SrvId, cross_king_api, send_mail, [{Rid, SrvId}, Name, win, 1, Death, Lev, Kill]),
    do_send_mail(gfs, T);
do_send_mail(gfs, [#cross_king_role{id = {Rid, SrvId}, name = Name, group = 0, dmg = Dmg, death = Death, lev = Lev} | T]) ->
    c_mirror_group:cast(node, SrvId, cross_king_api, send_mail, [{Rid, SrvId}, Name, loss, 0, Death, Lev, Dmg]),
    do_send_mail(gfs, T);

do_send_mail(ds, []) -> ok;
do_send_mail(ds, [#cross_king_role{id = {Rid, SrvId}, name = Name, group = 1, kill = Kill, death = Death, lev = Lev} | T]) ->
    c_mirror_group:cast(node, SrvId, cross_king_api, send_mail, [{Rid, SrvId}, Name, loss, 1, Death, Lev, Kill]),
    do_send_mail(ds, T);
do_send_mail(ds, [#cross_king_role{id = {Rid, SrvId}, name = Name, group = 0, dmg = Dmg, death = Death, lev = Lev} | T]) ->
    c_mirror_group:cast(node, SrvId, cross_king_api, send_mail, [{Rid, SrvId}, Name, win, 0, Death, Lev, Dmg]),
    do_send_mail(ds, T);

do_send_mail(timeout, []) -> ok;
do_send_mail(timeout, [#cross_king_role{id = {Rid, SrvId}, name = Name, group = 1, kill = Kill, death = Death, lev = Lev} | T]) ->
    c_mirror_group:cast(node, SrvId, cross_king_api, send_mail, [{Rid, SrvId}, Name, timeout, 1, Death, Lev, Kill]),
    do_send_mail(timeout, T);
do_send_mail(timeout, [#cross_king_role{id = {Rid, SrvId}, name = Name, group = 0, dmg = Dmg, death = Death, lev = Lev} | T]) ->
    c_mirror_group:cast(node, SrvId, cross_king_api, send_mail, [{Rid, SrvId}, Name, timeout, 0, Death, Lev, Dmg]),
    do_send_mail(timeout, T);
do_send_mail(_, _) -> skip.

award_kill_gfs(Roles) ->
    AllDs = [{Rid, SrvId, Name} || #cross_king_role{id = {Rid, SrvId}, name = Name, group = 0} <- Roles],
    do_award_kill_gfs(AllDs).

do_award_kill_gfs([]) -> ok;
do_award_kill_gfs([{Rid, SrvId, Name} | T]) ->
    c_mirror_group:cast(node, SrvId, cross_king_api, send_kill_mail, [Rid, SrvId, Name]),
    do_award_kill_gfs(T).

notice_broad(MapId, [{Rid, SrvId, Name, _, _} | _] , Ds) ->
    GfsMsg = notice:role_to_msg({Rid, SrvId, Name}),
    DsMsg = do_msg(Ds),
    L = length(Ds),
    map:pack_send_to_all(MapId, 10931, {53, util:fbin(?L(<<"~s合~w人之力，终于将~s击败，实在太强大！">>), [DsMsg, L, GfsMsg]), []}).

do_msg(Ds) ->
    do_msg(Ds, <<"">>).
do_msg([], Bin) -> Bin;
do_msg([{Rid, SrvId, Name, _, _} | T], Bin) ->
    case Bin of
        <<"">> ->
            B = notice:role_to_msg({Rid, SrvId, Name}),
            do_msg(T, util:fbin(<<"~s">>, [B]));
        _ ->
            B = notice:role_to_msg({Rid, SrvId, Name}),
            do_msg(T, util:fbin(<<"~s、~s">>, [Bin, B]))
    end.
