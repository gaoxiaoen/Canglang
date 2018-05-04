%%----------------------------------------------------
%% @doc 武神坛 模式一 
%% @author  shawn
%% @end
%%----------------------------------------------------
-module(cross_warlord_type_one).

-behaviour(gen_fsm).

-export([
        start_link/3
    ]
).
-export([
        idel/2                %% 预备时间
        ,match/2               %% 比赛时间
        ,expire/2              %% 结束
    ]
).
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-record(state, {
        map_pid = 0     %% 地图进程ID
        ,map_id = 0     %% 地图Id
        ,zone_id = 0  %% 战场序号
        ,ts = 0         %% 进入某状态的时刻
        ,timeout = 0    %% 超时时间
        ,quality = 0    %% 战区类型
        ,label = 0      %% 0:天龙 1:玄虎
        ,team_list = [] %% 队伍列表
        ,try_num = 0    %% 尝试次数
        ,report = false %% 战斗结果
        ,win_team = []  %% 战胜
        ,lose_team = [] %% 战败 
        ,combat_pid     %% 战区战斗进程PID
        ,ready_list = [] 
    }
).

-include("common.hrl").
-include("combat.hrl").
-include("role.hrl").
-include("cross_warlord.hrl").

%% 启动服务进程
start_link(Seq, Type, Flag)->
    gen_fsm:start_link(?MODULE, [Seq, Type, Flag], []).

pack_to_map(TeamList, State) ->
    pack_to_map(TeamList, State, [], []).
pack_to_map([], #state{map_id = MapId}, TeamInfo, Point) ->
    map:pack_send_to_all(MapId, 18111, {0, TeamInfo, Point});
pack_to_map([{win, #cross_warlord_team{team_code = TeamCode, team_name = TeamName, team_member = TeamMem}} | T], State, TeamInfo, Point) ->
    Fun2 = fun(#cross_warlord_role{id = {Rid, SrvId}}) -> {Rid, SrvId} end,
    pack_to_map(T, State, [{1, TeamCode, TeamName, lists:map(Fun2, TeamMem)} | TeamInfo], [{TeamCode, 1} | Point]); 
pack_to_map([{lose, #cross_warlord_team{team_code = TeamCode, team_name = TeamName, team_member = TeamMem}} | T], State, TeamInfo, Point) ->
    Fun2 = fun(#cross_warlord_role{id = {Rid, SrvId}}) -> {Rid, SrvId} end,
    pack_to_map(T, State, [{0, TeamCode, TeamName, lists:map(Fun2, TeamMem)} | TeamInfo], Point).

%% 获取战区战况
get_status(StateName, #state{timeout = Timeout, ts = Ts, quality = Quality, team_list = TeamList, win_team = Win, lose_team = Lose, ready_list = ReadyList}) ->
    Fun = fun(idel) -> util:time_left(Timeout, Ts) div 1000;
        (_) -> 0
    end,
    WinPoint = [{TeamCode, 1} || #cross_warlord_team{team_code = TeamCode} <- Win],
    LosePoint = [{TeamCode, 0} || #cross_warlord_team{team_code = TeamCode} <- Lose],
    Fun2 = fun(#cross_warlord_role{id = {Rid, SrvId}, name = Name, career = Career, fight_capacity = FightCapacity, pet_fight = PetFight}) -> {Rid, SrvId, Name, Career, FightCapacity, PetFight}
    end,
    NewTeamList = [{TeamCode, TeamName, LineId, LineUpList, lists:map(Fun2, RoleList)} || #cross_warlord_team{team_code = TeamCode, team_name = TeamName, lineup_id = LineId, lineup_list = LineUpList, team_member = RoleList} <- TeamList],
    {Quality, Fun(StateName), NewTeamList, ReadyList, WinPoint ++ LosePoint}.

pack_status(StateName, State = #state{map_id = MapId}) ->
    Reply = get_status(StateName, State),
    map:pack_send_to_all(MapId, 18104, Reply).

%% 初始化
init([Seq, Quality, Label])->
    case map_mgr:create(36022) of
        {false, Reason} ->
            ?ERR("创建武神坛比赛地图失败:~s", [Reason]),
            {stop, normal, #state{}};
        {ok, MapPid, MapId} ->
            State = #state{map_pid = MapPid, map_id = MapId, zone_id = Seq, ts = erlang:now(), timeout = 9 * 60 * 1000, quality = Quality, label = Label},
            {ok, idel, State, 9 * 60 * 1000}
    end.

%% 容错函数
handle_event({combat_over, _, _, _}, StateName, State = #state{report = true}) ->
    ?ERR("战斗结果已经产生,该次结果作废"),
    continue(StateName, State);
handle_event({combat_over, _, _, undefined}, StateName, State) ->
    ?ERR("收到错误的战斗结果消息,重新发起战斗"),
    erlang:send_after(10 * 1000, self(), try_fight),
    continue(StateName, State);
handle_event({combat_over, [], _, _}, _StateName, State = #state{label = Label, quality = Quality, zone_id = Seq, team_list = [TeamA, TeamB]}) ->
    ?INFO("产生平局, 默认判断战力高队伍获胜"),
    {WinTeam, LoseTeam} = case TeamA#cross_warlord_team.team_fight >= TeamB#cross_warlord_team.team_fight of
        true -> {TeamA, TeamB};
        false -> {TeamB, TeamA} 
    end,
    %% 战斗结束,进入结算阶段
    NewState = State#state{win_team = [WinTeam], lose_team = [LoseTeam], report = true, ts = erlang:now(), timeout = 2 * 1000},
    pack_to_map([{win, WinTeam}, {lose, LoseTeam}], NewState),
    cross_warlord_live:cast({del, Label, Quality, Seq}), 
    {next_state, expire, NewState, 2 * 1000};
handle_event({combat_over, Winner, _, {atk, TeamCode}}, StateName, State = #state{label = Label, quality = Quality, zone_id = Seq, team_list = TeamList}) when length(TeamList) =:= 2 ->
    WinAtk = [F || F = #fighter{group = Group} <- Winner, Group =:= group_atk],
    case lists:keyfind(TeamCode, #cross_warlord_team.team_code, TeamList) of
        false -> %% 不太可能出现这种情况
            ?ERR("战胜队伍不在本区,异常情况,重新发起战斗"),
            erlang:send_after(10 * 1000, self(), try_fight),
            continue(StateName, State);
        TeamA ->
            {AtkTeam, DfdTeam} = {[TeamA], TeamList -- [TeamA]},
            {[WinTeam], [LoseTeam], NewState} = case WinAtk of
                [] -> %% AtkTeam输 
                    {DfdTeam, AtkTeam, State#state{win_team = DfdTeam, lose_team = AtkTeam, report = true, ts = erlang:now(), timeout = 2 * 1000}};
                _ ->
                    {AtkTeam, DfdTeam, State#state{win_team = AtkTeam, lose_team = DfdTeam, report = true, ts = erlang:now(), timeout = 2 * 1000}}
            end,
            pack_to_map([{win, WinTeam}, {lose, LoseTeam}], NewState),
            cross_warlord_live:cast({del, Label, Quality, Seq}), 
            {next_state, expire, NewState, 2 * 1000}
    end;
handle_event({combat_over, _, _, _}, StateName, State) ->
    ?ERR("收到错误的战斗结果消息,重新发起战斗"),
    erlang:send_after(10 * 1000, self(), try_fight),
    continue(StateName, State);

%% 更换队伍阵法
handle_event({change_lineup, {Rid, SrvId}, Pid, LineId}, StateName, State = #state{team_list = TeamList}) ->
    RoleList = cross_warlord:get_team_role(TeamList),
    case lists:keyfind({Rid, SrvId}, #cross_warlord_role.id, RoleList) of
        #cross_warlord_role{team_code = TeamCode} ->
            case lists:keyfind(TeamCode, #cross_warlord_team.team_code, TeamList) of
                Team = #cross_warlord_team{lineup_list = LineUpList} ->
                    case lists:member(LineId, [0 | LineUpList]) of
                        true ->
                            NewTeam = Team#cross_warlord_team{lineup_id = LineId},
                            NewState = State#state{team_list =
                                lists:keyreplace(TeamCode, #cross_warlord_team.team_code, TeamList, NewTeam)},
                            role:pack_send(Pid, 18124, {1, ?L(<<"选择阵法成功">>)}),
                            pack_status(StateName, NewState),
                            continue(StateName, NewState);
                        _ ->
                            role:pack_send(Pid, 18124, {0, ?L(<<"您的队伍没有该阵法, 无法选择">>)}),
                            continue(StateName, State)
                    end;
                _ ->
                    continue(StateName, State)
            end;
        _ ->
            continue(StateName, State)
    end;

%% 取消准备
handle_event({cancel_ready, {Rid, SrvId}, Pid}, StateName, State = #state{combat_pid = undefined, ready_list = ReadyList, team_list = TeamList}) ->
    RoleList = cross_warlord:get_team_role(TeamList),
    case lists:keyfind({Rid, SrvId}, #cross_warlord_role.id, RoleList) of
        #cross_warlord_role{} ->
            case lists:member({Rid, SrvId}, ReadyList) of
                true ->
                    NewReadyList = ReadyList -- [{Rid, SrvId}],
                    role:pack_send(Pid, 18123, {1, ?L(<<"取消准备成功">>)}),
                    NewState = State#state{ready_list = NewReadyList},
                    pack_status(StateName, NewState),
                    continue(StateName, NewState);
                false ->
                    role:pack_send(Pid, 18123, {0, ?L(<<"您还没有准备, 无需取消准备">>)}),
                    continue(StateName, State)
            end;
        _ ->
            continue(StateName, State)
    end;

%% 准备
handle_event({ready, {Rid, SrvId}, Pid}, idel, State = #state{combat_pid = undefined, label = Label, quality = Quality, zone_id = Seq, team_list = TeamList, ready_list = ReadyList}) ->
    RoleList = cross_warlord:get_team_role(TeamList),
    RoleLen = length(RoleList),
    case lists:keyfind({Rid, SrvId}, #cross_warlord_role.id, RoleList) of
        #cross_warlord_role{} ->
            case lists:member({Rid, SrvId}, ReadyList) of
                true ->
                    role:pack_send(Pid, 18123, {0, ?L(<<"您已经准备了, 无需再次准备">>)}),
                    continue(idel, State);
                false ->
                    role:pack_send(Pid, 18123, {1, ?L(<<"准备成功">>)}),
                    NewReadyList = [{Rid, SrvId} | ReadyList],
                    case length(NewReadyList) =:= RoleLen of
                        true ->
                            case fight(Label, Quality, Seq, TeamList) of
                                {one_team, WinTeam} ->
                                    %% 一个队伍, 直接获胜
                                    NewState = State#state{win_team = [WinTeam], ts = erlang:now(), timeout = 2 * 1000, report = true ,ready_list = []},
                                    pack_to_map([{win, WinTeam}], NewState),
                                    {next_state, expire, NewState, 2 * 1000};
                                null ->
                                    %% 空闲战区
                                    {next_state, expire, State#state{ts = erlang:now(), timeout = 2 * 1000, report = true, ready_list = []}, 2 * 1000};
                                {ok, CombatPid} ->
                                    NewState = State#state{combat_pid = CombatPid, ready_list = [], ts = erlang:now(), timeout = 44 * 60 * 1000},
                                    cross_warlord_live:cast({add, Label, Quality, Seq, CombatPid}),
                                    {next_state, match, NewState, 44 * 60 * 1000};
                                false ->
                                    NewState = State#state{ready_list = [], ts = erlang:now(), timeout = 44 * 60 * 1000},
                                    {next_state, match, NewState, 44 * 60 * 1000}
                            end;
                        false ->
                            NewState = State#state{ready_list = NewReadyList},
                            pack_status(idel, NewState), 
                            continue(idel, NewState)
                    end
            end;
        _ ->
            continue(idel, State)
    end;
handle_event({ready, {Rid, SrvId}, Pid}, match, State = #state{combat_pid = undefined, label = Label, quality = Quality, zone_id = Seq, team_list = TeamList, ready_list = ReadyList}) ->
    RoleList = cross_warlord:get_team_role(TeamList),
    RoleLen = length(RoleList),
    case lists:keyfind({Rid, SrvId}, #cross_warlord_role.id, RoleList) of
        #cross_warlord_role{} ->
            case lists:member({Rid, SrvId}, ReadyList) of
                true ->
                    role:pack_send(Pid, 18123, {0, ?L(<<"您已经准备了, 无需再次准备">>)}),
                    continue(match, State);
                false ->
                    role:pack_send(Pid, 18123, {1, ?L(<<"准备成功">>)}),
                    NewReadyList = [{Rid, SrvId} | ReadyList],
                    case length(NewReadyList) =:= RoleLen of
                        true ->
                            case fight(Label, Quality, Seq, TeamList) of
                                {one_team, WinTeam} ->
                                    %% 一个队伍, 直接获胜
                                    NewState = State#state{win_team = [WinTeam], ts = erlang:now(), timeout = 2 * 1000, report = true ,ready_list = []},
                                    pack_to_map([{win, WinTeam}], NewState),
                                    {next_state, expire, NewState, 2 * 1000};
                                null ->
                                    %% 空闲战区
                                    {next_state, expire, State#state{ts = erlang:now(), timeout = 2 * 1000, report = true, ready_list = []}, 2 * 1000};
                                {ok, CombatPid} ->
                                    NewState = State#state{combat_pid = CombatPid, ready_list = []},
                                    cross_warlord_live:cast({add, Label, Quality, Seq, CombatPid}),
                                    continue(match, NewState);
                                false ->
                                    NewState = State#state{ready_list = []},
                                    continue(match, NewState)
                            end;
                        false ->
                            NewState = State#state{ready_list = NewReadyList},
                            pack_status(match, NewState), 
                            continue(match, NewState)
                    end
            end;
        _ ->
            continue(match, State)
    end;
handle_event({cancel_ready, _, _}, StateName, State) ->
    ?DEBUG("战斗期间不接受取消准备消息"),
    continue(StateName, State);
handle_event({ready, _, _}, StateName, State) ->
    ?DEBUG("战斗期间不接受准备消息"),
    continue(StateName, State);

handle_event(_Event, StateName, State) ->
    continue(StateName, State).

%% 获取战区信息
handle_sync_event(get_status, _From, StateName, State) ->
    Reply = get_status(StateName, State),
    continue(StateName, {ok, Reply}, State);

handle_sync_event({login, _Id, _Pid}, _From, expire, State) ->
    continue(expire, {false, ?L(<<"武神坛战区已经关闭, 无法再次进入">>)}, State);
handle_sync_event({login, TeamCode, Id, Pid}, _From, StateName, State = #state{team_list = TeamList, map_id = MapId}) ->
    case lists:keyfind(TeamCode, #cross_warlord_team.team_code, TeamList) of
        false ->
            continue(StateName, {false, ?L(<<"武神坛战区尚未开启">>)}, State);
        Team = #cross_warlord_team{team_member = TeamMem} ->
            case lists:keyfind(Id, #cross_warlord_role.id, TeamMem) of
                false ->
                    continue(StateName, {false, ?L(<<"武神坛战区尚未开启">>)}, State);
                Old = #cross_warlord_role{fight_capacity = _OldFightCapacity} ->
                    NewR = Old#cross_warlord_role{pid = Pid},
                    NewTeamMem = lists:keyreplace(Id, #cross_warlord_role.id, TeamMem, NewR),
                    NewTeam = Team#cross_warlord_team{team_member = NewTeamMem},
                    cross_warlord_mgr:update_role(ets, NewR),
                    cross_warlord_mgr:update_team(ets, NewTeam),
                    NewState = State#state{team_list =
                        lists:keyreplace(TeamCode, #cross_warlord_team.team_code, TeamList, NewTeam)},
                    continue(StateName, {ok, MapId}, NewState)
            end
    end;

handle_sync_event({enter_match, _TeamCode, _Id, _Pid, _FightCapacity}, _From, expire, State) ->
    continue(expire, {false, ?L(<<"武神坛战区已经关闭, 无法再次进入">>)}, State);
handle_sync_event({enter_match, TeamCode, Id, Pid, FightCapacity}, _From, StateName, State = #state{quality = Quality, team_list = TeamList, map_id = MapId, label = Label}) ->
    case lists:keyfind(TeamCode, #cross_warlord_team.team_code, TeamList) of
        false ->
            ?DEBUG("TeamCode:~w, TeamList:~w", [TeamCode, TeamList]),
            continue(StateName, {false, ?L(<<"武神坛战区尚未开启">>)}, State);
        Team = #cross_warlord_team{team_member = TeamMem} ->
            case lists:keyfind(Id, #cross_warlord_role.id, TeamMem) of
                false ->
                    continue(StateName, {false, ?L(<<"武神坛战区尚未开启">>)}, State);
                Old = #cross_warlord_role{fight_capacity = OldFightCapacity} ->
                    case cross_warlord:do_check_fight(Label, Quality, OldFightCapacity, FightCapacity) of
                        false ->
                            NewR = Old#cross_warlord_role{pid = Pid},
                            NewTeamMem = lists:keyreplace(Id, #cross_warlord_role.id, TeamMem, NewR),
                            NewTeam = Team#cross_warlord_team{team_member = NewTeamMem},
                            cross_warlord_mgr:update_role(ets, NewR),
                            cross_warlord_mgr:update_team(ets, NewTeam),
                            NewState = State#state{team_list =
                                lists:keyreplace(TeamCode, #cross_warlord_team.team_code, TeamList, NewTeam)},
                            continue(StateName, {ok, MapId}, NewState);
                        true ->
                            continue(StateName, {false, ?L(<<"战力与报名时差距过大, 不能参与武神坛正式比赛">>)}, State)
                    end
            end
    end;
        
handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    continue(StateName, Reply, State).

%% 重试发起战斗
handle_info(try_fight, StateName, State = #state{combat_pid = CombatPid}) when is_pid(CombatPid) ->
    ?DEBUG("战斗正在进行中,不进行重试战斗"),
    continue(StateName, State);
handle_info(try_fight, StateName, State = #state{report = true}) ->
    ?DEBUG("战斗结果已经产生,不再进行重试"),
    continue(StateName, State);
handle_info(try_fight, StateName, State = #state{label = Label, quality = Quality, zone_id = Seq, team_list = TeamList}) when StateName =/= expire ->
    case fight(Label, Quality, Seq, TeamList) of
        {one_team, WinTeam} ->
            %% 一个队伍, 直接获胜
            NewState = State#state{win_team = [WinTeam], ts = erlang:now(), timeout = 2 * 1000, report = true, ready_list = []},
            pack_to_map([{win, WinTeam}], NewState),
            {next_state, expire, NewState, 2 * 1000};
        null ->
            %% 空闲战区
            {next_state, expire, State#state{ts = erlang:now(), timeout = 2 * 1000, report = true, ready_list = []}, 2 * 1000};
        {ok, CombatPid} ->
            NewState = State#state{combat_pid = CombatPid, ready_list = []},
            cross_warlord_live:cast({add, Label, Quality, Seq, CombatPid}),
            continue(match, NewState);
        false ->
            continue(match, State)
    end;
handle_info(try_fight, StateName, State) ->
    ?DEBUG("非比赛阶段不再重试发起战斗"),
    continue(StateName, State);

%% 添加战区队伍
handle_info({add_team, Team = #cross_warlord_team{team_code = TeamCode, team_name = _TeamName}}, idel, State = #state{team_list = TeamList}) when is_record(Team, cross_warlord_team) ->
    case lists:keyfind(TeamCode, #cross_warlord_team.team_code, TeamList) of 
        false ->
            ?DEBUG("收到战区队伍信息:~w, ~s",[TeamCode, _TeamName]),
            continue(idel, State#state{team_list = [Team | TeamList]});
        _ ->
            ?ERR("收到重复的队伍信息,TeamCode:~w, TeamName:~s",[TeamCode, _TeamName]),
            continue(idel, State)
    end;

handle_info(time_stop, expire, State) ->
    continue(expire, State);
handle_info(time_stop, _StateName, State = #state{label = Label, quality = Quality, zone_id = Seq, combat_pid = CombatPid}) -> 
    case is_pid(CombatPid) of
        true -> combat_type:stop_combat(CombatPid);
        false -> skip
    end,
    cross_warlord_live:cast({del, Label, Quality, Seq}), 
    {next_state, expire, State#state{ts = erlang:now(), timeout = 2 * 1000}, 2 * 1000};

handle_info(_Info, StateName, State) ->
    continue(StateName, State).

%% 终止时 该战区无队伍
terminate(_Reason, _StateName, #state{zone_id = Seq, label = Label, report = false, team_list = []}) ->
    cross_warlord_mgr:zone_stop(Seq, Label),
    ok;
terminate(_Reason, _StateName, #state{quality = Quality, zone_id = Seq, label = Label, report = false, team_list = [Team]}) ->
    Log = {type_one, [Team], []},
    cross_warlord_mgr:zone_report(Quality, Log),
    RoleList = cross_warlord:get_team_role([Team]),
    cross_warlord:leave(RoleList),
    cross_warlord_mgr:zone_stop(Seq, Label),
    ok;
terminate(_Reason, _StateName, #state{quality = Quality, zone_id = Seq, label = Label, report = false, team_list = [TeamA, TeamB]}) ->
    {WinTeam, LoseTeam} = case TeamA#cross_warlord_team.team_fight >= TeamB#cross_warlord_team.team_fight of
        true -> {TeamA, TeamB};
        false -> {TeamB, TeamA} 
    end,
    Log = {type_one, [WinTeam], [LoseTeam]},
    cross_warlord_mgr:zone_report(Quality, Log),
    RoleList = cross_warlord:get_team_role([TeamA, TeamB]),
    cross_warlord:leave(RoleList),
    cross_warlord_mgr:zone_stop(Seq, Label),
    ok;

terminate(_Reason, _StateName, #state{quality = Quality, zone_id = Seq, label = Label, report = true, win_team = WinTeam, lose_team = LoseTeam, team_list = TeamList}) ->
    Log = {type_one, WinTeam, LoseTeam},
    cross_warlord_mgr:zone_report(Quality, Log),
    RoleList = cross_warlord:get_team_role(TeamList),
    cross_warlord:leave(RoleList),
    cross_warlord_mgr:zone_stop(Seq, Label),
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%% ----------------------------
%% 内部函数
%% ----------------------------
fight(Label, Quality, Seq, [#cross_warlord_team{lineup_id = LineId1, team_code = TeamCode, team_member = TeamAmem}, #cross_warlord_team{lineup_id = LineId2, team_member = TeamBmem}]) ->
    L1 = roles_to_fighters([{RoleId, Name, CombatCache} || #cross_warlord_role{id = RoleId, name = Name, combat_cache = CombatCache} <- TeamAmem]), 
    L2 = roles_to_fighters([{RoleId, Name, CombatCache} || #cross_warlord_role{id = RoleId, name = Name, combat_cache = CombatCache} <- TeamBmem]), 
    NewL1 = add_line_up(L1, LineId1),
    NewL2 = add_line_up(L2, LineId2),
    case combat:start(?combat_type_cross_warlord, self(), NewL1, NewL2, [{atk, TeamCode}, {replay_id, {?combat_type_cross_warlord, Label, Quality, Seq, 1}}]) of
        {ok, CombatPid} ->
            {ok, CombatPid};
        _Why ->
            ?ERR("发起战斗失败:~w",[_Why]),
            erlang:send_after(10 * 1000, self(), try_fight),
            false
    end;

%% 一个队伍的话
fight(_, _, _, [Team]) ->
    {one_team, Team};
%% 没有队伍
fight(_, _, _, []) ->
    null.

%% 增加阵法
add_line_up(List, LineId1) ->
    add_line_up(List, LineId1, []).
add_line_up([], _, NewL) -> NewL;
add_line_up([CF = #converted_fighter{fighter_ext = FighterExt = #fighter_ext_role{}} | T], LineId1, NewL) ->
    add_line_up(T, LineId1, [CF#converted_fighter{fighter_ext = FighterExt#fighter_ext_role{lineup_id = LineId1}} | NewL]);
add_line_up([CF | T], LineId1, NewL) ->
    add_line_up(T, LineId1, [CF | NewL]).

%% 转换角色参战
roles_to_fighters(RoleIds) ->
    %% 因为偶尔会timeout，所以加入多次尝试
    RoleIds1 = [{RoleId, 0, Name, CombatCache} || {RoleId, Name, CombatCache} <- RoleIds],
    roles_to_fighters(RoleIds1, [], []).
roles_to_fighters([], Result, Fails) ->
    Result1 = fails_to_clone(Fails),
    Result ++ Result1;
roles_to_fighters([{RoleId = {Rid, SrvId}, TryNum, Name, CombatCache}|T], Result, Fails) when TryNum < 3 ->
    case catch c_proxy:role_lookup(by_id, RoleId, to_fighter) of
        {ok, _, #converted_fighter{fighter_ext = #fighter_ext_role{event = Event}}} when (Event =/= ?event_cross_warlord_match) ->
            ?ERR("[~w, ~s]的当前事件状态不正确[Event=~w]，无法加入战斗", [Rid, SrvId, Event]),
            roles_to_fighters(T, Result, [{RoleId, event, Name, CombatCache}|Fails]);
        {ok, _, CF = #converted_fighter{}} ->
            roles_to_fighters(T, [CF|Result], Fails);
        {error, timeout} -> %% 超时，重试3次
            ?INFO("查找并转换跨服角色[~w, ~s]超时，正在重试第~w次", [Rid, SrvId, TryNum+1]),
            roles_to_fighters([{RoleId, TryNum+1, Name, CombatCache}|T], Result, Fails);
        {error, not_found} -> %% 掉线
            ?INFO("[~w, ~s]掉线，查找不到了", [Rid, SrvId]),
            roles_to_fighters(T, Result, [{RoleId, offline, Name, CombatCache} | Fails]);
        _Err -> 
            ?ERR("查找并转换跨服角色[~w, ~s]出错:~w", [Rid, SrvId, _Err]),
            roles_to_fighters(T, Result, [{RoleId, _Err, Name, CombatCache} | Fails])
    end;
roles_to_fighters([{RoleId = {Rid, SrvId}, _TryNum, Name, CombatCache}|T], Result, Fails) ->
    case catch c_proxy:role_lookup(by_id, RoleId, to_fighter) of
        {ok, _, #converted_fighter{fighter_ext = #fighter_ext_role{event = Event}}} when (Event =/= ?event_cross_warlord_match) ->
            ?ERR("[~w, ~s]的当前事件状态不正确[Event=~w]，无法加入战斗", [Rid, SrvId, Event]),
            roles_to_fighters(T, Result, [{RoleId, event, Name, CombatCache}|Fails]);
        {ok, _, CF = #converted_fighter{}} ->
            roles_to_fighters(T, [CF|Result], Fails);
        {error, timeout} -> %% 超时
            ?INFO("查找并转换跨服角色[~w, ~s]还是超时", [Rid, SrvId]),
            roles_to_fighters(T, Result, [{RoleId, timeout, Name, CombatCache}|Fails]);
        {error, not_found} -> %% 掉线
            ?INFO("[~w, ~s]掉线，查找不到了", [Rid, SrvId]),
            roles_to_fighters(T, Result, [{RoleId, offline, Name, CombatCache}|Fails]);
        _Err -> 
            ?ERR("查找并转换跨服角色[~w, ~s]出错:~w", [Rid, SrvId, _Err]),
            roles_to_fighters(T, Result, [{RoleId, _Err, Name, CombatCache}|Fails])
    end.

fails_to_clone(Fails) ->
    fails_to_clone(Fails, []).
fails_to_clone([], Result) -> Result;
fails_to_clone([{RoleId, _Err, Name, {Sex, Career, Lev, HpMax, MpMax, Attr, Eqm, Skill, PetBag, RoleDemon, Looks, Ascend}} | T], Result) ->
    {ok, F} = role_convert:do(to_fighter, {{RoleId, Name, Sex, Career, Lev, HpMax, MpMax, Attr, Eqm, Skill, PetBag, RoleDemon, Looks, Ascend}, cross_warlord}),
    fails_to_clone(T, [F | Result]).

%% -----------------------------
%% 状态处理 
%% -----------------------------

%% 准备时间
%% 空闲战区
idel(timeout, State = #state{team_list = []}) ->
    %% 直接进入结算
    {next_state, expire, State#state{ts = erlang:now(), timeout = 2 * 1000}, 2 * 1000};
idel(timeout, State = #state{label = Label, quality = Quality, zone_id = Seq, team_list = TeamList}) ->
    case fight(Label, Quality, Seq, TeamList) of
        {one_team, WinTeam} ->
            %% 一个队伍, 直接获胜
            NewState = State#state{win_team = [WinTeam], ts = erlang:now(), timeout = 2 * 1000, report = true},
            pack_to_map([{win, WinTeam}], NewState),
            {next_state, expire, NewState, 2 * 1000};
        null ->
            %% 空闲战区
            {next_state, expire, State#state{ts = erlang:now(), timeout = 2 * 1000, report = true}, 2 * 1000};
        {ok, CombatPid} ->
            NewState = State#state{combat_pid = CombatPid, ts = erlang:now(), timeout = 44 * 60 * 1000},
            cross_warlord_live:cast({add, Label, Quality, Seq, CombatPid}),
            {next_state, match, NewState, 44 * 60 * 1000};
        false ->
            NewState = State#state{ts = erlang:now(), timeout = 44 * 60 * 1000},
            {next_state, match, NewState, 44 * 60 * 1000}
    end;
idel(_Any, State) ->
    continue(idel, State).

%% 比赛期间 
match(timeout, State = #state{label = Label, zone_id = Seq, quality = Quality, combat_pid = CombatPid}) ->
    case is_pid(CombatPid) of
        true -> combat_type:stop_combat(CombatPid);
        false -> skip
    end,
    cross_warlord_live:cast({del, Label, Quality, Seq}), 
    {next_state, expire, State#state{ts = erlang:now(), timeout = 2 * 1000}, 2 * 1000};
match(_Any, State) ->
    continue(match, State).

%% 结算期间
expire(timeout, State) ->
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
