%%----------------------------------------------------
%% @doc 竞技场
%%
%% <pre>
%% 竞技场状态机
%% 
%% 竞技场的几个状态
%%      match        比赛阶段
%%      expire         结束阶段
%% </pre> 
%% @author yqhuang(QQ:19123767)
%% @author abu
%% @end
%%----------------------------------------------------
-module(top_fight_center).

-behaviour(gen_fsm).

-export([
        start_link/4
        ,stop/1
        ,close/1
        ,login/4
        ,logout/3
        ,logout_update/1
        ,enter_match/2
        ,exit_match/2
        ,combat_over/3
        ,combat_over_robot/2
        ,check/4
        ,get_event_pid/1
        ,get_rank/1
        ,get_arena_role/2
        ,revive/4
        ,leave_match/3
        ,delete_buff/3
        ,add_buff/3
        ,add_buff_to_role/1
        ,check_after_pre/1
        ,group_list/3
        ,group_num/1
        ,kill_report/3
        %% ,apply_add_arena_score/1
        ,async_settlement/2
        ,apply_get_combat_pid/1

        %% ----tmp
        ,init_robot/4
        ,debug/1
    ]
).
-export([
        match/2
        ,expire/2
    ]
).
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-include("common.hrl").
-include("top_fight.hrl").
-include("looks.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("pos.hrl").
-include("assets.hrl").
-include("buff.hrl").
-include("mail.hrl").
%%

-record(state, {
        map_pid = 0     %% 地图进程ID
        ,map_id = 0     %% 地图Id
        ,arena_lev = 0  %% 战场级别
        ,arena_seq = 0  %% 战场序号
        ,arena_name = <<>> %% 战区名称
        ,week = 0       %% 周数
        ,report = false %% 结算报告
        ,role_list = [] %% 竞技场角色信息[#top_fight_role{}]
        ,role_size = 0  %% 原始角色数量
        ,ts = 0         %% 进入某状态的时刻
        ,time = 0       %% 竞技场开启时间
        ,robot_alive_dragon = 0   %% 离火机器人数量
        ,robot_alive_tiger = 0    %% 玄水机器人数量
        ,robot_relive_dragon = 0  %% 可复活次数
        ,robot_relive_tiger = 0   %% 可复活次数
    }
).

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------

%% 启动竞技场服务进程
start_link(ArenaLev, ArenaSeq, Time, RoleSize)->
    gen_fsm:start_link(?MODULE, [ArenaLev, ArenaSeq, Time, RoleSize], []).

%% 比赛前期结束后检查
check_after_pre(ArenaPid) ->
    gen_fsm:send_all_state_event(ArenaPid, check_after_pre).

%% 强制中止比赛
stop(ArenaPid) ->
    gen_fsm:send_all_state_event(ArenaPid, stop).

%% 关闭竞技场
close(ArenaPid) ->
    gen_fsm:send_all_state_event(ArenaPid, close).

%% 进入战场 同步
enter_match(ArenaPid, ArenaRole) ->
    gen_fsm:sync_send_all_state_event(ArenaPid, {enter_match, ArenaRole}).

%% 进入战场 同步
exit_match(ArenaPid, {RoleId, SrvId}) ->
    gen_fsm:sync_send_all_state_event(ArenaPid, {exit_match, {RoleId, SrvId}}).

%% 战斗结束
combat_over(ArenaPid, Winner, Loser) ->
    WinnerIds = parse_fighter(Winner),
    LoserIds = parse_fighter(Loser),
    gen_fsm:send_all_state_event(ArenaPid, {combat_over, WinnerIds, LoserIds}),
    ok.

%% 机器人战斗结束
combat_over_robot(ArenaPid, #combat{winner = Winner, loser = Loser}) ->
    gen_fsm:send_all_state_event(ArenaPid, {combat_over_robot, Winner, Loser}),
    ok.

%% @spec check(combat_start, EventPid, {SRoleId, SsrvId}, {TRoleId, TSrvId}) -> true | {false, Reason}
%% @doc
%% 检查发起战斗条件
check(combat_start, SeventPid, {SRoleId, SsrvId}, {TRoleId, TSrvId}) ->
    gen_fsm:sync_send_all_state_event(SeventPid, {combat_start, {SRoleId, SsrvId}, {TRoleId, TSrvId}});

%% 检查与机器人发起战斗条件 
check(combat_start_robot, ArenaPid, {RoleId, SrvId}, NpcBaseId) ->
    gen_fsm:sync_send_all_state_event(ArenaPid, {combat_start_robot, RoleId, SrvId, NpcBaseId}).

%% 获取排行榜信息
get_rank(ArenaPid) ->
    gen_fsm:sync_send_all_state_event(ArenaPid, {get_rank}).

%% 获取角色竞技场信息
get_arena_role(ArenaPid, {RoleId, SrvId}) ->
    gen_fsm:sync_send_all_state_event(ArenaPid, {get_arena_role, RoleId, SrvId}).

%% 删除buff通知
delete_buff(ArenaPid, RoleId, SrvId) ->
    gen_fsm:send_all_state_event(ArenaPid, {delete_buff, RoleId, SrvId}).

%% 添加buff
add_buff(ArenaPid, {RoleId, SrvId}, {TRoleId, TSrvId}) ->
    gen_fsm:sync_send_all_state_event(ArenaPid, {add_buff, RoleId, SrvId, TRoleId, TSrvId}).

%% 上线
login(ArenaPid, RoleId, SrvId, Pid) ->
    gen_fsm:sync_send_all_state_event(ArenaPid, {login, RoleId, SrvId, Pid}).

%$% 下线
logout(ArenaPid, RoleId, SrvId) ->
    gen_fsm:send_all_state_event(ArenaPid, {logout, RoleId, SrvId}).

%% 获取组员列表
group_list(ArenaPid, RoleId, SrvId) ->
    gen_fsm:sync_send_all_state_event(ArenaPid, {group_list, RoleId, SrvId}).

%% 获取分组统计信息
group_num(ArenaPid) ->
    gen_fsm:sync_send_all_state_event(ArenaPid, group_num).

%% 获取斩杀人数 
kill_report(ArenaPid, RoleId, SrvId) ->
    gen_fsm:sync_send_all_state_event(ArenaPid, {kill_report, RoleId, SrvId}).

%% 异步结算
async_settlement(ArenaPid, Param) ->
    gen_fsm:send_all_state_event(ArenaPid, {async_settlement, Param}).

%% 角色进程:退出更新角色竞技场积分
logout_update(Role = #role{id = {RoleId, SrvId}, event = ?event_top_fight_match, event_pid = ArenaPid}) ->
    case is_pid(ArenaPid) of
        true ->
            case gen_fsm:sync_send_all_state_event(ArenaPid, {logout_update, RoleId, SrvId}) of
                {ok, #top_fight_role{kill = Kill, kill_added = KillAdded}} ->
                    %% NewRole = Role#role{assets = Assets#assets{arena = (ArenaScore + Score - ScoreAdded), acc_arena = (AccArena + Score - ScoreAdded)}},
                    %% catch rank:listener(vie_acc, NewRole),
                    NewRole2 = rank:listener(arena_kill, Role, (Kill - KillAdded)),
                    {ok, NewRole2};
                _ ->
                    {ok, Role}
            end;
        false -> 
            {ok, Role}
    end;
logout_update(Role) ->
    {ok, Role}.

%% 打印调试信息
debug(Pid) ->
    Pid ! {debug}.


%%----------------------------------------------------
%% 状态机内部逻辑
%%----------------------------------------------------

init([ArenaLev, ArenaSeq, StartTime, RoleSize])->
    ?DEBUG("[~w] 正在启动...", [?MODULE]),
    case map_mgr:create(?top_fight_match_map_id) of
        {false, Reason} ->
            ?ERR("创建竞技场地图失败:~s", [Reason]),
            {stop, normal, #state{}};
        {ok, MapPid, MapId} ->
            ArenaName = case ArenaLev of
                ?top_fight_lev_low -> util:fbin(?L(<<"巅峰对决第~w战区">>), [ArenaSeq]);
                ?top_fight_lev_middle -> util:fbin(?L(<<"巅峰对决第~w战区">>), [ArenaSeq]);
                ?top_fight_lev_hight -> util:fbin(?L(<<"巅峰对决第~w战区">>), [ArenaSeq]);
                ?top_fight_lev_super -> util:fbin(?L(<<"巅峰对决第~w战区">>), [ArenaSeq]);
                ?top_fight_lev_angle -> util:fbin(?L(<<"巅峰对决第~w战区">>), [ArenaSeq])
            end,
            %% {_Year, CurrWeek} = calendar:iso_week_number(),
            State = #state{map_pid = MapPid, map_id = MapId, arena_lev = ArenaLev, arena_seq = ArenaSeq, arena_name = ArenaName, ts = erlang:now(), time = StartTime, week = 1, role_size = RoleSize},
            %% NewState = init_robot(State, ArenaLev, MapId, RoleSize),
            ?DEBUG("[~w] 启动完成", [?MODULE]),
            {ok, match, State}
    end.

%% 前期结束后检查
handle_event(check_after_pre, StateName, State = #state{role_list = RoleList, robot_alive_dragon = AliveDragon, robot_alive_tiger = AliveTiger}) ->
    case settlement(RoleList, #top_fight_report{robot_alive_dragon = AliveDragon, robot_alive_tiger = AliveTiger}) of
        {true, Report = #top_fight_report{talive = TAlive, dalive = DAlive, tiger_list = TigerList, dragon_list = DragonList}} ->
            case TAlive > DAlive of
                true -> 
                    send_by_arena_role_list(TigerList, {17304, {3, convert_17304(RoleList)}}),      %% 胜负已分，发送退出信息
                    send_by_arena_role_list(DragonList, {17304, {1, convert_17304(RoleList)}});      %% 胜负已分，发送退出信息
                false ->
                    case TAlive =:= DAlive of
                        true ->
                            send_by_arena_role_list(TigerList, {17304, {1, convert_17304(RoleList)}}),      %% 胜负已分，发送退出信息
                            send_by_arena_role_list(DragonList, {17304, {1, convert_17304(RoleList)}});      %% 胜负已分，发送退出信息
                        false ->
                            send_by_arena_role_list(TigerList, {17304, {1, convert_17304(RoleList)}}),      %% 胜负已分，发送退出信息
                            send_by_arena_role_list(DragonList, {17304, {3, convert_17304(RoleList)}})      %% 胜负已分，发送退出信息
                    end
            end,
            %% send_by_arena_role_list(RoleList, {17304, {3, convert_17304(RoleList)}}),         %% 胜负已分，发送退出信息
            case StateName of
                match -> 
                    erlang:send_after(?top_fight_timeout_stop_combat, self(), stop_all_combat),
                    {next_state, expire, State#state{report = Report}, ?top_fight_timeout_expire};
                _ -> continue(StateName, State)
            end;
        {false, _Report} ->
            continue(StateName, State)
    end;

%% 时间到 比赛结束 
handle_event(stop, match, State = #state{arena_lev = _ArenaLev, arena_seq = _ArenaSeq, role_list = RoleList}) ->
    ?DEBUG("[竞技场]比赛中止[ArenaLev:~w, ArenaSeq:~w]", [_ArenaLev, _ArenaSeq]),
    Report = #top_fight_report{talive = TAlive, dalive = DAlive, tiger_list = TigerList, dragon_list = DragonList} = case settlement(RoleList, #top_fight_report{}) of
        {true, Rep} -> Rep;
        {false, Rep} -> Rep
    end,
    case TAlive > DAlive of
        true ->
            send_by_arena_role_list(TigerList, {17304, {3, convert_17304(RoleList)}}),
            send_by_arena_role_list(DragonList, {17304, {1, convert_17304(RoleList)}});
        false ->
            case TAlive =:= DAlive of
                true ->
                    send_by_arena_role_list(TigerList, {17304, {1, convert_17304(RoleList)}}),
                    send_by_arena_role_list(DragonList, {17304, {1, convert_17304(RoleList)}});
                false ->
                    send_by_arena_role_list(TigerList, {17304, {1, convert_17304(RoleList)}}),
                    send_by_arena_role_list(DragonList, {17304, {3, convert_17304(RoleList)}})
            end
    end,
    erlang:send_after(?top_fight_timeout_stop_combat, self(), stop_all_combat),
    {next_state, expire, State#state{ts = erlang:now(), report = Report}, ?top_fight_timeout_expire};
handle_event(stop, StateName, State = #state{arena_lev = _ArenaLev, arena_seq = _ArenaSeq}) ->
    ?DEBUG("[竞技场]比赛已经中止[ArenaLev:~w, ArenaSeq:~w]", [_ArenaLev, _ArenaSeq]),
    continue(StateName, State);

%% 关闭竞技场 
handle_event(close, expire, State = #state{arena_lev = _ArenaLev, arena_seq = _ArenaSeq}) ->
    ?DEBUG("[竞技场]收到关闭竞技场信息[ArenaLev:~w, ArenaSeq:~w]", [_ArenaLev, _ArenaSeq]),
    {stop, normal, State};
%% 关闭竞技场 
handle_event(close, _StateName, State = #state{arena_lev = _ArenaLev, arena_seq = _ArenaSeq}) ->
    ?DEBUG("[竞技场]先停止比赛再关闭[ArenaLev:~w, ArenaSeq:~w]", [_ArenaLev, _ArenaSeq]),
    {stop, normal, State};
%% 强制关闭竞技场
handle_event(close_force, _StateName, State = #state{arena_lev = _ArenaLev, arena_seq = _ArenaSeq}) ->
    ?DEBUG("[竞技场]收到关闭竞技场信息[ArenaLev:~w, ArenaSeq:~w]", [_ArenaLev, _ArenaSeq]),
    {stop, normal, State};

%% 战斗结束结算
handle_event({combat_over, WinnerIds, LoserIds}, StateName, State) ->
    NewState = do_combat_over(State, WinnerIds, LoserIds),
    continue(StateName, NewState);

%% 机器人战斗结束结算
handle_event({combat_over_robot, Winner, Loser}, StateName, State) ->
    NewState = do_combat_over_robot(State, Winner, Loser),
    continue(StateName, NewState);

%% 删除buff
handle_event({delete_buff, RoleId, SrvId}, match, State = #state{role_list = RoleList}) ->
    case lists:keyfind({RoleId, SrvId}, #top_fight_role.role_id, RoleList) of
        false -> continue(match, State);
        ArenaRole = #top_fight_role{group_id = GroupId} ->
            NewArenaRole = ArenaRole#top_fight_role{has_buff = ?false, buff_time = 0},
            NewRoleList = lists:keyreplace({RoleId, SrvId}, #top_fight_role.role_id, RoleList, NewArenaRole),
            send_self_to_group(GroupId, NewArenaRole, RoleList),
            continue(match, State#state{role_list = NewRoleList})
    end;

%% 下线
handle_event({logout, RoleId, SrvId}, StateName, State = #state{week = _Week, time = _Time, arena_lev = _ArenaLev, arena_seq = _ArenaSeq, role_list = RoleList}) ->
    case lists:keyfind({RoleId, SrvId}, #top_fight_role.role_id, RoleList) of
        false -> continue(StateName, State);
        ArenaRole = #top_fight_role{group_id = GroupId, name = _Name, score = _Score, kill = _Kill, career = _Career, lev = _Lev, death = _Death, fight_capacity = _Fc, pet_fight_capacity = _PetFc} ->
            %% 写日志
            send_self_to_group(GroupId, ArenaRole#top_fight_role{status = ?top_fight_role_status_logout}, RoleList),
            %top_fight_dao_log:replace_insert_log(RoleId, SrvId, Name, Week, Time, Score, Kill, ArenaLev, ArenaSeq, Career, Lev, GroupId, Death, Fc, PetFc),
            async_settlement(self(), #top_fight_sp{send_13317 = ?true, send_13304 = ?true}),
            NewRoleList = lists:keyreplace({RoleId, SrvId}, #top_fight_role.role_id, RoleList, ArenaRole#top_fight_role{status = ?top_fight_role_status_logout}),
            continue(StateName, State#state{role_list = NewRoleList})
    end;

%% 异步结算
handle_event({async_settlement, #top_fight_sp{send_13317 = Send13317, send_13304 = Send13304, role_pid = RolePid}}, match, State = #state{map_id = MapId, time = Time, role_list = RoleList, robot_alive_dragon = AliveDragon, robot_alive_tiger = AliveTiger}) ->
    case settlement(RoleList, #top_fight_report{robot_alive_dragon = AliveDragon, robot_alive_tiger = AliveTiger}) of
        {true, Report = #top_fight_report{talive = TAlive, dalive = DAlive, tiger_list = TigerList, dragon_list = DragonList}} -> %% 胜负已分
            case Send13317 of
                ?true -> map:pack_send_to_all(MapId, 17317, {TAlive + AliveTiger, DAlive + AliveDragon});      %% 更新两队人数
                ?false -> ignore
            end,
            case is_pid(RolePid) of
                true -> 
                    role:pack_send(RolePid, 17317, {TAlive + AliveTiger, DAlive + AliveDragon});
                false -> ignore
            end,
            case {Send13304, (util:unixtime() - Time) > (?top_fight_timeout_match_pre_cross/1000)} of
                {?true, true} -> 
                    case TAlive > DAlive of
                        true -> 
                            send_by_arena_role_list(TigerList, {17304, {3, convert_17304(RoleList)}}),      %% 胜负已分，发送退出信息
                            send_by_arena_role_list(DragonList, {17304, {2, convert_17304(RoleList)}});      %% 胜负已分，发送退出信息
                        false ->
                            case TAlive =:= DAlive of
                                true ->
                                    send_by_arena_role_list(TigerList, {17304, {2, convert_17304(RoleList)}}),      %% 胜负已分，发送退出信息
                                    send_by_arena_role_list(DragonList, {17304, {2, convert_17304(RoleList)}});      %% 胜负已分，发送退出信息
                                false ->
                                    send_by_arena_role_list(TigerList, {17304, {2, convert_17304(RoleList)}}),      %% 胜负已分，发送退出信息
                                    send_by_arena_role_list(DragonList, {17304, {3, convert_17304(RoleList)}})      %% 胜负已分，发送退出信息
                            end
                    end;
                _ -> ignore
            end,
            case (util:unixtime() - Time) > (?top_fight_timeout_match_pre_cross/1000) of
                true -> 
                    erlang:send_after(?top_fight_timeout_stop_combat, self(), stop_all_combat),
                    {next_state, expire, State#state{report = Report}, ?top_fight_timeout_expire};
                false -> continue(match, State)
            end;
        {false, #top_fight_report{talive = TAlive, dalive = DAlive}} ->
            case Send13317 of
                ?true -> map:pack_send_to_all(MapId, 17317, {TAlive + AliveTiger, DAlive + AliveDragon});      %% 更新两队人数
                ?false -> ignore
            end,
            case is_pid(RolePid) of
                true -> 
                    role:pack_send(RolePid, 17317, {TAlive + AliveTiger, DAlive + AliveDragon});
                false -> ignore
            end,
            continue(match, State)
    end;
handle_event({async_settlement, #top_fight_sp{send_13317 = Send13317, role_pid = RolePid}}, expire, State = #state{robot_alive_dragon = AliveDragon, robot_alive_tiger = AliveTiger, map_id = MapId, role_list = RoleList}) ->
    case settlement(RoleList, #top_fight_report{robot_alive_dragon = AliveDragon, robot_alive_tiger = AliveTiger}) of
        {true, #top_fight_report{talive = TAlive, dalive = DAlive}} -> %% 胜负已分
            case Send13317 of
                ?true -> map:pack_send_to_all(MapId, 17317, {TAlive + AliveTiger, DAlive + AliveDragon});      %% 更新两队人数
                ?false -> ignore
            end,
            case is_pid(RolePid) of
                true -> 
                    role:pack_send(RolePid, 17317, {TAlive + AliveTiger, DAlive + AliveDragon});
                false -> ignore
            end,
            continue(expire, State);
        {false, #top_fight_report{talive = TAlive, dalive = DAlive}} ->
            case Send13317 of
                ?true -> map:pack_send_to_all(MapId, 17317, {TAlive + AliveTiger, DAlive + AliveDragon});      %% 更新两队人数
                ?false -> ignore
            end,
            case is_pid(RolePid) of
                true -> 
                    role:pack_send(RolePid, 17317, {TAlive + AliveTiger, DAlive + AliveDragon});
                false -> ignore
            end,
            continue(expire, State)
    end;

%% 容错
handle_event(_Event, StateName, State) ->
    continue(StateName, State).

%% 角色进入战场
handle_sync_event({enter_match, ArenaRole = #top_fight_role{role_pid = RolePid, group_id = GroupId, score = Score, kill = Kill}}, _From, match, State = #state{arena_name = ArenaName, role_list = RoleList, map_id = MapId, arena_lev = ArenaLev, arena_seq = ArenaSeq, ts = Ts}) ->
    Reply = [{_RoleId, _SrvId, _Name, _GroupId, _Score, _Kill} || #top_fight_role{role_id = {_RoleId, _SrvId}, name = _Name, group_id = _GroupId, kill = _Kill, score = _Score} <- RoleList],
    role:pack_send(RolePid, 17309, {Reply}),
    %role:pack_send(RolePid, 17300, {-3}),
    role:pack_send(RolePid, 17316, {groups_info(GroupId, RoleList)}),
    role:pack_send(RolePid, 17311, {2, round((util:time_left(?top_fight_timeout_match_pre_cross, Ts)  + ?top_fight_timeout_matching)/ 1000)}),
    role:pack_send(RolePid, 17318, {Score, Kill}),
    role:pack_send(RolePid, 17324, {ArenaLev, ArenaSeq, GroupId}),
    send_self_to_group(GroupId, ArenaRole, RoleList),
    NewState = State#state{role_list = [ArenaRole#top_fight_role{status = ?top_fight_role_status_match} | RoleList]},
    async_settlement(self(), #top_fight_sp{send_13317 = ?true, role_pid = RolePid}),
    notice:inform(RolePid, util:fbin(?L(<<"你已经进入~s">>), [ArenaName])),
    continue(match, {ok, MapId}, NewState);

handle_sync_event({enter_match, _ArenaRole}, _From, StateName, State) ->
    Reply = {false, ?L(<<"当前状态已经不可以进入战场了">>)},
    continue(StateName, Reply, State);

%% 角色退出战场
handle_sync_event({exit_match, {RoleId, SrvId}}, _From, StateName, State = #state{role_list = RoleList, arena_lev = ArenaLev, arena_seq = ArenaSeq, time = Time, week = Week}) ->
    ArenaRole = #top_fight_role{group_id = GroupId, role_pid = RolePid, kill = Kill, score = Score} = lists:keyfind({RoleId, SrvId}, #top_fight_role.role_id, RoleList),
    top_fight_center_mgr:del_cache(ArenaRole),
    NewRoleList = lists:keyreplace({RoleId, SrvId}, #top_fight_role.role_id, RoleList, ArenaRole#top_fight_role{status = ?top_fight_role_status_leave, score_added = Score, kill_added = Kill}),
    NewState = State#state{role_list = NewRoleList},
    send_group_delete(GroupId, {RoleId, SrvId}, NewRoleList),   %% 删除组成员
    role:apply(async, RolePid, {top_fight_center, leave_match, [ArenaRole, {Time, Week, ArenaLev, ArenaSeq}]}),
    async_settlement(self(), #top_fight_sp{send_13317 = ?true, send_13304 = ?true}),
    continue(StateName, ok, NewState);

%% 检查是否可发起战斗
handle_sync_event({combat_start, {SRoleId, SsrvId}, {TRoleId, TSrvId}}, _From, match, State) ->
    Reply = do_check({combat_start, {SRoleId, SsrvId}, {TRoleId, TSrvId}}, State),
    continue(match, Reply, State);
handle_sync_event({combat_start, {_SRoleId, _SsrvId}, {_TRoleId, _TSrvId}}, _From, StateName, State) ->
    continue(StateName, {false, ?L(<<"比赛已经结束">>)}, State);

%% 检查是否可发起战斗
handle_sync_event({combat_start_robot, RoleId, SrvId, NpcBaseId}, _From, match, State = #state{arena_lev = ArenaLev}) ->
    Reply = do_check({combat_start_robot, ArenaLev, RoleId, SrvId, NpcBaseId}, State),
    continue(match, Reply, State);
handle_sync_event({combat_start_robot, _RoleId, _SrvId, _NpcBaseId}, _From, StateName, State) ->
    continue(StateName, {false, ?L(<<"比赛已经结束">>)}, State);

%% 获取排行榜信息
handle_sync_event({get_rank}, _From, match, State = #state{role_list = RoleList}) ->
    Reply = [{RoleId, SrvId, Name, GroupId, Score, Kill} || #top_fight_role{role_id = {RoleId, SrvId}, name = Name, kill = Kill, group_id = GroupId, score = Score} <- RoleList],
    continue(match, {ok, Reply}, State);
handle_sync_event({get_rank}, _From, StateName, State) ->
    continue(StateName, [], State);

%% 获取角色竞技场信息
handle_sync_event({get_arena_role, RoleId, SrvId}, _From, StateName, State = #state{role_list = RoleList}) ->
    case lists:keyfind({RoleId, SrvId}, #top_fight_role.role_id, RoleList) of
        ArenaRole when is_record(ArenaRole, top_fight_role) ->
            continue(StateName, {ok, ArenaRole}, State);
        _ ->
            continue(StateName, {false, ?L(<<"没找到">>)}, State)
    end;

%% 添加buff
handle_sync_event({add_buff, RoleId, SrvId, TRoleId, TSrvId}, _From, match, State) ->
    case do_add_buff(RoleId, SrvId, TRoleId, TSrvId, State) of
        {false, Reason} ->
            continue(match, {false, Reason}, State);
        {ok, NewState} ->
            continue(match, ok, NewState)
    end;

%% 获取组员列表
handle_sync_event({group_list, RoleId, SrvId}, _From, StateName, State = #state{role_list = RoleList}) ->
    case lists:keyfind({RoleId, SrvId}, #top_fight_role.role_id, RoleList) of
        #top_fight_role{group_id = GroupId} ->
            continue(StateName, {ok, groups_info(GroupId, RoleList)}, State);
        _ ->
            continue(StateName, {false, ?L(<<"没找到">>)}, State)
    end;

%% 获取分组统计信息
handle_sync_event(group_num, _From, StateName, State = #state{role_list = RoleList, robot_alive_dragon = AliveDragon, robot_alive_tiger = AliveTiger}) ->
    Fun = fun(#top_fight_role{group_id = GroupId, death = Death, status = Status}, {Tiger, Dragon}) ->
        case {GroupId, Status} of
            {?top_fight_group_tiger, ?top_fight_role_status_match} ->
                case Death >=3 of
                    true -> {Tiger, Dragon};
                    false -> {Tiger + 1, Dragon}
                end;
            {?top_fight_group_dragon, ?top_fight_role_status_match} ->
                case Death >= 3 of
                    true -> {Tiger, Dragon};
                    false -> {Tiger, Dragon + 1}
                end;
            _ ->
                {Tiger, Dragon}
        end
    end,
    {Tiger, Dragon} = lists:foldl(Fun, {0, 0}, RoleList),
    continue(StateName, {ok, Dragon + AliveDragon, Tiger + AliveTiger}, State);

%% 获取斩杀人数
handle_sync_event({kill_report, RoleId, SrvId}, _From, StateName, State = #state{role_list = RoleList}) ->
    case lists:keyfind({RoleId, SrvId}, #top_fight_role.role_id, RoleList) of
        #top_fight_role{score = Score, kill = Kill} ->
            continue(StateName, {ok, Score, Kill}, State);
        _ ->
            continue(StateName, {false, ?L(<<"没找到">>)}, State)
    end;

%% 上线
handle_sync_event({login, RoleId, SrvId, Pid}, _From, match, State = #state{role_list = RoleList}) ->
    case lists:keyfind({RoleId, SrvId}, #top_fight_role.role_id, RoleList) of
        false -> 
            continue(match, {false, ?L(<<"没找到巅峰对决角色信息">>)}, State);
        ArenaRole = #top_fight_role{arena_lev = ArenaLev, arena_seq = ArenaSeq, group_id = GroupId, death = Death} ->
            Status = case Death >= 3 of
                true -> ?top_fight_role_status_idel;
                false -> ?top_fight_role_status_match
            end,
            async_settlement(self(), #top_fight_sp{send_13317 = ?true, role_pid = Pid}),
            NewArenaRole = ArenaRole#top_fight_role{status = Status, role_pid = Pid},
            role:pack_send(Pid, 17324, {ArenaLev, ArenaSeq, GroupId}),
            send_self_to_group(GroupId, NewArenaRole, RoleList),
            NewRoleList = lists:keyreplace({RoleId, SrvId}, #top_fight_role.role_id, RoleList, NewArenaRole),
            continue(match, {ok, NewArenaRole}, State#state{role_list = NewRoleList})
    end;

%% 登出
handle_sync_event({logout_update, RoleId, SrvId}, _From, StateName, State = #state{role_list = RoleList}) ->
    case lists:keyfind({RoleId, SrvId}, #top_fight_role.role_id, RoleList) of
        ArenaRole = #top_fight_role{score = Score, kill = Kill} ->
            NewRoleList = lists:keyreplace({RoleId, SrvId}, #top_fight_role.role_id, RoleList, ArenaRole#top_fight_role{score_added = Score, kill_added = Kill}),
            continue(StateName, {ok, ArenaRole}, State#state{role_list = NewRoleList});
        _ -> continue(StateName, false, State)
    end;

%% 容错
handle_sync_event(_Event, _From, StateName, State) ->
    continue(StateName, ok, State).

handle_info(stop_all_combat, StateName, State = #state{role_list = RoleList}) ->
    stop_all_combat(RoleList, []),
    continue(StateName, State);

handle_info({debug}, StateName, State) ->
    ?DEBUG("top_fight_center state: ~w", [State]),
    continue(StateName, State);

handle_info(_Info, StateName, State) ->
    continue(StateName, State).

terminate(_Reason, _StateName, State = #state{role_list =  RoleList, report = false, robot_alive_dragon = AliveDragon, robot_alive_tiger = AliveTiger}) ->
    case settlement(RoleList, #top_fight_report{robot_alive_dragon = AliveDragon, robot_alive_tiger = AliveTiger}) of
        {true, Report} ->
            terminate(_Reason, _StateName, State#state{report = Report});
        {false, Report} ->
            terminate(_Reason, _StateName, State#state{report = Report})
    end;

terminate(_Reason, _StateName, State = #state{arena_lev = _ArenaLev, arena_seq = _ArenaSeq, map_id = MapId, role_list = RoleList, report = _Report = #top_fight_report{talive = TAlive, dalive = DAlive}}) ->
    ?DEBUG("巅峰对决关闭[ArenaLev:~w, ArenaSeq:~w, role_length = ~w]", [_ArenaLev, _ArenaSeq, length(RoleList)]),
    NewRoleList = kill_qsort(score_qsort(RoleList)),
    leave(RoleList, State),
    save_score_log(RoleList, State),
    if
        TAlive > DAlive ->
            send_mail_group(NewRoleList, ?top_fight_group_tiger, 1);
            %% send_win_mail(TigerList),
            %% send_loser_mail(DragonList);
        TAlive =:= DAlive -> 
            send_mail_group(NewRoleList, ?false, 1);
            %% send_loser_mail(TigerList),
            %% send_loser_mail(DragonList),
            ignore;
        true ->
            send_mail_group(NewRoleList, ?top_fight_group_dragon, 1)
            %% send_win_mail(DragonList),
            %% send_loser_mail(TigerList)
    end,
    award_champion(NewRoleList, State),
    map_mgr:stop(MapId),
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%%----------------------------------------------------
%% 状态处理
%%----------------------------------------------------

%% 比赛已经结束
match(timeout, State = #state{role_list = RoleList, robot_alive_dragon = AliveDragon, robot_alive_tiger = AliveTiger}) ->
    ?DEBUG("[竞技场]比赛结束"),
    %% map:pack_send_to_all(MapId, 17304, {1}),
    Report = #top_fight_report{talive = TAlive, dalive = DAlive, tiger_list = TigerList, dragon_list = DragonList} = case settlement(RoleList, #top_fight_report{robot_alive_dragon = AliveDragon, robot_alive_tiger = AliveTiger}) of
        {true, Rep} -> Rep;
        {false, Rep} -> Rep
    end,
    case TAlive > DAlive of
        true -> 
            send_by_arena_role_list(TigerList, {17304, {3, convert_17304(RoleList)}}),      %% 胜负已分，发送退出信息
            send_by_arena_role_list(DragonList, {17304, {1, convert_17304(RoleList)}});      %% 胜负已分，发送退出信息
        false ->
            case TAlive =:= DAlive of
                true ->
                    send_by_arena_role_list(TigerList, {17304, {1, convert_17304(RoleList)}}),      %% 胜负已分，发送退出信息
                    send_by_arena_role_list(DragonList, {17304, {1, convert_17304(RoleList)}});      %% 胜负已分，发送退出信息
                false ->
                    send_by_arena_role_list(TigerList, {17304, {1, convert_17304(RoleList)}}),      %% 胜负已分，发送退出信息
                    send_by_arena_role_list(DragonList, {17304, {3, convert_17304(RoleList)}})      %% 胜负已分，发送退出信息
            end
    end,
    erlang:send_after(?top_fight_timeout_stop_combat, self(), stop_all_combat),
    {next_state, expire, State#state{ts = erlang:now(), report = Report}, ?top_fight_timeout_expire};
match(_Any, State) ->
    continue(match, State).

%% 时间到结束比赛
expire(timeout, State = #state{arena_lev = _ArenaLev, arena_seq = _ArenaSeq}) ->
    %% 竞技场进程退出
    ?DEBUG("[竞技场]时间到结束比赛[ArenaLev:~w, ArenaSeq:~w]", [_ArenaLev, _ArenaSeq]),
    {stop, normal, State};
expire(_Any, State) ->
    continue(expire, State).

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------

%% 竞技场关闭，玩家都退出竞技场
leave([], _State) ->
    ok;
leave([ArenaRole = #top_fight_role{role_pid = RolePid, status = Status} | T], State = #state{time = Time, week = Week, arena_lev = ArenaLev, arena_seq = ArenaSeq}) ->
    case Status =:= ?top_fight_role_status_match orelse Status =:= ?top_fight_role_status_idel of
        true -> role:apply(async, RolePid, {top_fight_center, leave_match, [ArenaRole, {Time, Week, ArenaLev, ArenaSeq}]});
        false -> ignore
    end,
    leave(T, State).

%% 玩家离开竞技场
leave_match(Role = #role{id = {_RoleId, _SrvId}, looks = Looks, hp_max = HpMax, mp_max = MpMax, name = _Name, pos = #pos{last = _LastPos}}, #top_fight_role{kill = Kill, kill_added = KillAdded, score = _Score, group_id = _GroupId, career = _Career, lev = _Lev, death = _Death, fight_capacity = _Fc, pet_fight_capacity = _PetFc}, {_Time, _Week, _ArenaLev, _ArenaSeq}) ->
    ?DEBUG("角色退出场景[RoleName:~s]", [_Name]),
    %top_fight_dao_log:replace_insert_log(RoleId, SrvId, Name, Week, Time, Score, Kill, ArenaLev, ArenaSeq, Career, Lev, GroupId, Death, Fc, PetFc),
    {ExitMapId, _X, _Y} = ?top_fight_exit,
    {X, Y} = util:rand_list([{1440, 3420}, {960, 3720}, {1440, 3870}, {2100, 3480}]),
    NewX = util:rand(X - 50, X + 50),
    NewY = util:rand(Y - 50, Y + 50),
    NewLooks = lists:keydelete(?LOOKS_TYPE_MODEl, 1, Looks),
    NewLooks2 = lists:keydelete(?LOOKS_TYPE_ACT, 1, NewLooks),
    NewLooks3 = lists:keydelete(?LOOKS_TYPE_ALPHA, 1, NewLooks2),
    NewLooks4 = lists:keydelete(?LOOKS_TYPE_ARENA_SUPERMAN, 1, NewLooks3),
    Role2 = role_listener:acc_event(Role, {106, Kill - KillAdded}), %%竞技场中参战总次数
    case map:role_enter(ExitMapId, NewX, NewY, Role2#role{event = ?event_no, hp = HpMax, mp = MpMax, looks = NewLooks4, cross_srv_id = <<>>}) of
        {ok, NewRole} ->
            catch rank:listener(vie_acc, NewRole),
            NewRole2 = rank:listener(arena_kill, NewRole, (Kill - KillAdded)),
            case buff:del_buff_by_label_no_push(NewRole2, ?top_fight_buff_label) of
                false -> 
                    NewRole3 = role_api:push_attr(NewRole2),
                    {ok, NewRole3};
                {ok, NewRole3} ->
                    NewRolePush = role_api:push_attr(NewRole3),
                    {ok, NewRolePush}
            end;
        {false, _Why} ->
            ?DEBUG("[~s]退出竞技场失败[Reason:~w]", [_Name, _Why]),
            {ok}
    end.

%% 检查发起战斗条件
do_check({combat_start, {SRoleId, SSrvId}, {TRoleId, TSrvId}}, #state{role_list = RoleList}) ->
    case {lists:keyfind({SRoleId,SSrvId}, #top_fight_role.role_id, RoleList), lists:keyfind({TRoleId,TSrvId}, #top_fight_role.role_id, RoleList)} of
        {#top_fight_role{group_id = SGroupId, death = SDeath, status = ?top_fight_role_status_match}, #top_fight_role{group_id = TGroupId, death = TDeath, last_death_time = LastDeathTime, status = ?top_fight_role_status_match}} ->
            case SGroupId =:= TGroupId of
                true ->
                    {false, ?L(<<"不可以攻击同组玩家">>)};
                false ->
                    case SDeath >= 3 of
                        true ->
                            {false, ?L(<<"你已经阵亡3次，不可以再参战了">>)};
                        false ->
                            case TDeath >= 3 of
                                true ->
                                    {false, ?L(<<"对方已经阵亡3次，不可以再抗战了">>)};
                                false ->
                                    case (util:unixtime() - LastDeathTime) < 5 of %% 死亡有10秒的保护时间
                                        true ->
                                            {false, ?L(<<"做人要厚道，别老杀人家，待会吧">>)};
                                        false ->
                                            true
                                    end
                            end
                    end
            end;
        {#top_fight_role{status = ?top_fight_role_status_idel}, _} ->
            {false, ?L(<<"您已经进入灵魂状态，无法继续战斗但是可以鼓舞您的组员">>)};
        {_, #top_fight_role{status = ?top_fight_role_status_idel}} ->
            {false, ?L(<<"对方状态不可以发起战斗">>)};
        _ ->
            {false, ?L(<<"对方状态不可以发起战斗">>)}
    end;

do_check({combat_start_robot, ArenaLev, RoleId, SrvId, NpcBaseId}, #state{role_list = RoleList}) ->
    case lists:keyfind({RoleId, SrvId}, #top_fight_role.role_id, RoleList) of
        #top_fight_role{death = Death} when Death >= 3 -> {false, ?L(<<"你已经阵亡3次，不可以再参战了">>)};
        #top_fight_role{status = ?top_fight_role_status_idel} -> {false, ?L(<<"您已经进入灵魂状态，无法继续战斗但是可以鼓舞您的组员">>)};
        #top_fight_role{group_id = GroupId, status = ?top_fight_role_status_match} ->
            case catch lists:member(NpcBaseId, top_fight_data:robot_base(ArenaLev, GroupId)) of
                false -> true;
                _ -> {false, ?L(<<"不可以攻击同组玩家">>)}
            end;
        _ -> {false, ?L(<<"当前状态不可以发起战斗">>)}
    end.

%% 提取角色信息
parse_fighter([#fighter{type = ?fighter_type_role, rid = RoleId, srv_id = SrvId, gl_flag = GLflag} | T]) ->
    ArenaBuff = case lists:keyfind(arena_buff_score, 1, GLflag) of
        {_, ?true} -> ?true;
        _ -> ?false
    end,
    [{RoleId, SrvId, ArenaBuff} | parse_fighter(T)];
parse_fighter([#fighter{} | T]) ->
    parse_fighter(T);
parse_fighter([]) ->
    [].

%% 战斗结束结算
do_combat_over(State, WinnerIds, LoserIds) ->
    case {length(WinnerIds) > 0, length(LoserIds) > 0} of
        {true, true} ->
            [Winner | _] = WinnerIds,
            [Loser | _] = LoserIds,
            update_role_data(State, Winner, Loser);
        {false, true} ->
            update_role_data(State, LoserIds); %% 双方都挂了
        _ ->
            State 
    end.

%% 战斗结束
update_role_data(State, {WRoleId, WSrvId}, {LRoleId, LSrvId}) ->
    update_role_data(State, {WRoleId, WSrvId, ?false}, {LRoleId, LSrvId, ?false});
update_role_data(State = #state{arena_lev = ArenaLev, map_id = MapId, role_list = RoleList}, {WRoleId, WSrvId, WUseBuff}, {LRoleId, LSrvId, _LUseBuff}) ->
    case lists:keyfind({WRoleId, WSrvId}, #top_fight_role.role_id, RoleList) of
        WArenaRole = #top_fight_role{role_id = {RoleId, SrvId}, role_pid = WRolePid, kill = Kill, name = Name, group_id = WGroupId, lev = WLev, mask = WMask, score = Score, fight_capacity = WFightCapacity, series_kill = SeriesKill} ->
            case lists:keyfind({LRoleId, LSrvId}, #top_fight_role.role_id, RoleList) of
                LArenaRole = #top_fight_role{fight_capacity = LFightCapacity, name = LName, death = Death, role_pid = LRolePid, group_id = GroupId, mask = LMask, kill = LKill, score = LScore} ->
                    OldScore = calc_score(ArenaLev),
                    AddScore = case WUseBuff of
                        ?true -> round(OldScore * 1.5);
                        _ -> OldScore
                    end,
                    AddLScore = calc_loser_score(ArenaLev),
                    NewWArenaRole = WArenaRole#top_fight_role{kill = (Kill + 1), score = Score + AddScore, series_kill = (SeriesKill + 1)},
                    NewLArenaRole = LArenaRole#top_fight_role{death = (Death + 1), series_kill = 0, last_death_time = util:unixtime(), score = (LScore + AddLScore)},
                    NewLArenaRole2 = case Death >= 2 of
                        true -> 
                            Convert = convert_17304(RoleList),
                            role:pack_send(LRolePid, 17304, {2, Convert}),
                            NR2 = NewLArenaRole#top_fight_role{status = ?top_fight_role_status_idel},
                            send_self_to_group(GroupId, NR2, RoleList),
                            NR2;
                        false -> 
                            role:pack_send(LRolePid, 17310, {Death + 1, WGroupId, WMask, RoleId, SrvId, Name, WLev}),
                            NewLArenaRole 
                    end,
                    win_report(NewWArenaRole#top_fight_role.kill, RoleId, SrvId, Name, MapId),
                    catch win_notice(NewWArenaRole, WFightCapacity, LFightCapacity, OldScore),
                    lose_notice(NewLArenaRole2),
                    NewRoleList = lists:keyreplace({WRoleId, WSrvId}, #top_fight_role.role_id, RoleList, NewWArenaRole),
                    NewRoleList2 = lists:keyreplace({LRoleId, LSrvId}, #top_fight_role.role_id, NewRoleList, NewLArenaRole2),
                    map:pack_send_to_all(MapId, 17308, {RoleId, SrvId, Name, WGroupId, (Score + AddScore), (Kill + 1)}),
                    map:pack_send_to_all(MapId, 17308, {LRoleId, LSrvId, LName, GroupId, (LScore + AddLScore), LKill}),
                    WNName = case WMask of
                        ?false -> Name;
                        _ -> ?L(<<"蒙面仙使">>) 
                    end,
                    LNName = case LMask of
                        ?false -> LName;
                        _ -> ?L(<<"蒙面仙使">>) 
                    end,
                    Msg = util:fbin(?L(<<"经过一番苦战，<font color='#ff3030'>~s</font>凭借高超的仙法，让<font color='#00ff24'>~s</font>完全失去反抗之力，甘败下风。">>), [WNName, LNName]),
                    map:pack_send_to_all(MapId, 17321, {Msg}),
                    {X, Y} = case GroupId of
                        ?top_fight_group_dragon -> ?top_fight_relive_dragon;
                        ?top_fight_group_tiger -> ?top_fight_relive_tiger
                    end,
                    % add_arena_score([NewWArenaRole, NewLArenaRole2]),
                    NewX = util:rand(X - 100, X + 100),
                    NewY = util:rand(Y - 100, Y + 100),
                    role:apply(async, LRolePid, {top_fight_center, revive, [NewX, NewY, (Death + 1)]}),
                    case (Kill + 1) >= 10 of
                        true -> role:apply(async, WRolePid, {fun role_looks_update/1, []});
                        false -> ignore
                    end,
                    role:pack_send(WRolePid, 17318, {(Score + AddScore), (Kill + 1)}),
                    role:pack_send(LRolePid, 17318, {(LScore + AddLScore), LKill}),
                    NewState = State#state{role_list = NewRoleList2},
                    %% check_all_win(NewState),
                    async_settlement(self(), #top_fight_sp{send_13317 = ?true, send_13304 = ?true}),
                    NewState;
                _ ->
                    State 
            end;
        _ ->
            State 
    end.

%% 负方
update_role_data(State, [{RoleId, SrvId} | T]) ->
    update_role_data(State, [{RoleId, SrvId, ?false} | T]);
update_role_data(State = #state{role_list = RoleList}, [{RoleId, SrvId, _UseBuff} | T]) ->
    case lists:keyfind({RoleId, SrvId}, #top_fight_role.role_id, RoleList) of
        ArenaRole = #top_fight_role{death = Death, role_pid = RolePid, group_id = GroupId} ->
            NewArenaRole = case Death >= 2 of
                true -> 
                    role:pack_send(RolePid, 17304, {2, convert_17304(RoleList)}),
                    NAR = ArenaRole#top_fight_role{status = ?top_fight_role_status_idel},
                    send_self_to_group(GroupId, NAR, RoleList),
                    NAR;
                false -> 
                    role:pack_send(RolePid, 17310, {Death + 1, 0, 0, 0, <<>>, <<>>, 0}),
                    ArenaRole
            end,
            {X, Y} = case GroupId of
                ?top_fight_group_dragon -> ?top_fight_relive_dragon;
                ?top_fight_group_tiger -> ?top_fight_relive_tiger
            end,
            NewX = util:rand(X - 100, X + 100),
            NewY = util:rand(Y - 100, Y + 100),
            role:apply(async, RolePid, {top_fight_center, revive, [NewX, NewY, (Death + 1)]}),
            NewArenaRole2 = NewArenaRole#top_fight_role{death = (Death + 1), series_kill = 0, last_death_time = util:unixtime()},
            NewRoleList = lists:keyreplace({RoleId, SrvId}, #top_fight_role.role_id, RoleList, NewArenaRole2),
            NewState = State#state{role_list = NewRoleList},
            %% check_all_win(State),
            async_settlement(self(), #top_fight_sp{send_13317 = ?true, send_13304 = ?true}),
            %% add_arena_score([NewArenaRole2]),
            lose_notice(NewArenaRole2),
            update_role_data(NewState, T);
        _ ->
            update_role_data(State, T)
    end;
update_role_data(State, []) ->
    State.

%% 机器人战斗结束结算
do_combat_over_robot(State, Winner, Loser) ->
    NewState = robot_deal_winner(State, Winner),
    NewState2 = robot_deal_loser(NewState, Loser),
    NewState2.

robot_deal_winner(State, []) -> State;
robot_deal_winner(State = #state{arena_lev = ArenaLev, map_id = MapId, role_list = RoleList}, [#fighter{type = ?fighter_type_role, rid = RoleId, srv_id = SrvId, gl_flag = GLflag} | T]) ->
    case lists:keyfind({RoleId, SrvId}, #top_fight_role.role_id, RoleList) of
        ArenaRole = #top_fight_role{role_pid = RolePid, score = Score, name = Name, group_id = GroupId, kill = Kill} ->
            OldScore = top_fight_data:robot_score(ArenaLev),
            AddScore = case lists:keyfind(arena_buff_score, 1, GLflag) of
                {_, ?true} -> round(OldScore * 1.5);
                _ -> OldScore
            end,
            %% AddScore = case catch role:apply(sync, RolePid, {fun calc_buff_score/2, [OldScore]}) of
            %%     {ok, BuffScore} -> BuffScore;
            %%     _ -> OldScore
            %% end,
            map:pack_send_to_all(MapId, 17308, {RoleId, SrvId, Name, GroupId, (Score + AddScore), Kill}),
            role:pack_send(RolePid, 17318, {(Score + AddScore), Kill}),
            NewRoleList = lists:keyreplace({RoleId, SrvId}, #top_fight_role.role_id, RoleList, ArenaRole#top_fight_role{score = (Score + AddScore)}),
            NewState = State#state{role_list = NewRoleList},
            Robot = case GroupId of
                ?top_fight_group_dragon -> ?L(<<"玄水">>);
                _ -> ?L(<<"离火">>) 
            end,
            Msg = util:fbin(?L(<<"经过一番战斗，您击败了不知名的~s使者，获得~w积分!">>), [Robot, AddScore]),
            role:pack_send(RolePid, 10931, {53, Msg}),
            robot_deal_winner(NewState, T);
        _ -> robot_deal_winner(State, T)
    end;
robot_deal_winner(State, [_Fighter | T]) ->
    robot_deal_winner(State, T).

robot_deal_loser(State, []) -> State;
robot_deal_loser(State = #state{role_list = RoleList}, [#fighter{type = ?fighter_type_role, rid = RoleId, srv_id = SrvId} | T]) ->
    case lists:keyfind({RoleId, SrvId}, #top_fight_role.role_id, RoleList) of
        ArenaRole = #top_fight_role{role_pid = RolePid, death = Death, group_id = GroupId} ->
            NewArenaRole = case Death >= 2 of
                true -> 
                    role:pack_send(RolePid, 17304, {2, convert_17304(RoleList)}),
                    NAR = ArenaRole#top_fight_role{status = ?top_fight_role_status_idel},
                    send_self_to_group(GroupId, NAR, RoleList),
                    NAR;
                false -> 
                    role:pack_send(RolePid, 17310, {Death + 1, 0, 0, 0, <<>>, <<>>, 0}),
                    ArenaRole
            end,
            {X, Y} = case GroupId of
                ?top_fight_group_dragon -> ?top_fight_relive_dragon;
                ?top_fight_group_tiger -> ?top_fight_relive_tiger
            end,
            NewX = util:rand(X - 100, X + 100),
            NewY = util:rand(Y - 100, Y + 100),
            role:apply(async, RolePid, {top_fight_center, revive, [NewX, NewY, (Death + 1)]}),
            NewArenaRole2 = NewArenaRole#top_fight_role{death = (Death + 1), series_kill = 0, last_death_time = util:unixtime()},
            NewRoleList = lists:keyreplace({RoleId, SrvId}, #top_fight_role.role_id, RoleList, NewArenaRole2),
            NewState = State#state{role_list = NewRoleList},
            async_settlement(self(), #top_fight_sp{send_13317 = ?true, send_13304 = ?true}),
            lose_notice(NewArenaRole2),
            Robot = case GroupId of
                ?top_fight_group_dragon -> ?L(<<"玄水">>);
                _ -> ?L(<<"离火">>) 
            end,
            Msg = util:fbin(?L(<<"经过一番战斗，您被不知名的~s使者击败了!">>), [Robot]),
            role:pack_send(RolePid, 10931, {53, Msg}),
            robot_deal_loser(NewState, T);
        _ ->
            robot_deal_loser(State, T)
    end;
robot_deal_loser(State = #state{arena_lev = ArenaLev, map_id = MapId, robot_alive_dragon = AliveDragon, robot_alive_tiger = AliveTiger, robot_relive_dragon = ReliveDragon, robot_relive_tiger = ReliveTiger}, [#fighter{type = ?fighter_type_npc, rid = NpcBaseId} | T]) ->
    case check_npc_group(ArenaLev, NpcBaseId) of
        ?top_fight_group_dragon ->
            case ReliveDragon > 0 of
                true ->
                    {X, Y} = ?top_fight_relive_dragon,
                    NewX = util:rand(X - 100, X + 100),
                    NewY = util:rand(Y - 100, Y + 100),
                    npc_mgr:create(util:rand_list(top_fight_data:robot_base(ArenaLev, ?top_fight_group_dragon)), MapId, NewX, NewY),
                    async_settlement(self(), #top_fight_sp{send_13317 = ?true, send_13304 = ?true}),
                    robot_deal_loser(State#state{robot_relive_dragon = ReliveDragon - 1}, T);
                false ->
                    async_settlement(self(), #top_fight_sp{send_13317 = ?true, send_13304 = ?true}),
                    robot_deal_loser(State#state{robot_alive_dragon = AliveDragon - 1}, T)
            end;
        ?top_fight_group_tiger ->
            case ReliveTiger > 0 of
                true ->
                    {X, Y} = ?top_fight_relive_tiger,
                    NewX = util:rand(X - 100, X + 100),
                    NewY = util:rand(Y - 100, Y + 100),
                    npc_mgr:create(util:rand_list(top_fight_data:robot_base(ArenaLev, ?top_fight_group_tiger)), MapId, NewX, NewY),
                    async_settlement(self(), #top_fight_sp{send_13317 = ?true, send_13304 = ?true}),
                    robot_deal_loser(State#state{robot_relive_tiger = ReliveTiger - 1}, T);
                false ->
                    async_settlement(self(), #top_fight_sp{send_13317 = ?true, send_13304 = ?true}),
                    robot_deal_loser(State#state{robot_alive_tiger = AliveTiger - 1}, T)
            end
    end.

%% 判断npc分组
check_npc_group(ArenaLev, NpcBaseId) ->
    case lists:member(NpcBaseId, top_fight_data:robot_base(ArenaLev, ?top_fight_group_tiger)) of
        true -> ?top_fight_group_tiger;
        false -> ?top_fight_group_dragon
    end.

%% 复活
revive(Role = #role{looks = Looks}, _X, _Y, Death) ->
    NewRole = case Death >= 3 of
        true ->
            NewLooks = case lists:keyfind(?LOOKS_TYPE_ALPHA, 1, Looks) of
                false -> [{?LOOKS_TYPE_ALPHA, 0, ?LOOKS_VAL_ALPHA_ARENA} | Looks];
                _Other -> lists:keyreplace(?LOOKS_TYPE_ALPHA, 1, Looks, {?LOOKS_TYPE_ALPHA, 0, ?LOOKS_VAL_ALPHA_ARENA})
            end,
            NR = Role#role{looks = NewLooks},
            map:role_update(NR),
            NR;
        false -> Role
    end,
    NewRole2 = role_api:revive(NewRole#role{status = ?status_normal}),
    {ok, NewRole2}.

role_looks_update(Role = #role{looks = Looks}) ->
    case lists:keyfind(?LOOKS_TYPE_ARENA_SUPERMAN, 1, Looks) of
        false -> 
            NewLooks = [{?LOOKS_TYPE_ARENA_SUPERMAN, 0, ?LOOKS_VAL_ARENA_SUPERMAN} | Looks],
            NewRole = Role#role{looks = NewLooks},
            map:role_update(NewRole),
            {ok, NewRole};
        _Other -> 
            {ok}
    end.

%% 获取角色EventPid
get_event_pid(#role{event_pid = EventPid}) ->
    {ok, {ok, EventPid}}.

%% 计算积分
calc_score(ArenaLev) ->
    case ArenaLev of
        ?top_fight_lev_low -> 35;
        ?top_fight_lev_middle -> 35;
        ?top_fight_lev_hight -> 35;
        ?top_fight_lev_super -> 35;
        ?top_fight_lev_angle -> 35;
        _ -> 35
    end.

%% 战败积分
calc_loser_score(?top_fight_lev_low) -> 18;
calc_loser_score(?top_fight_lev_middle) -> 18;
calc_loser_score(?top_fight_lev_hight) -> 18;
calc_loser_score(?top_fight_lev_super) -> 18;
calc_loser_score(?top_fight_lev_angle) -> 18;
calc_loser_score(_) -> 18.

%% 结算
%% 统计最高杀人数及生存人数
%% 被依据:
%%      1、判断赢胜方
%%      2、计算冠军玩家
%%      3、刷新冠军信息
%% 4、发退出竞技场信息
settlement([ArenaRole = #top_fight_role{role_id = {RoleId, SrvId}, name = Name, kill = Kill, group_id = ?top_fight_group_tiger, status = Status} | T], 
    Report = #top_fight_report{trole_kill = TRoleKill, tkill_sum = TKillSum, talive = TAlive, tiger_list = TigerList}
) ->
    NewTigerList = [ArenaRole | TigerList],
    NewTKillSum = (TKillSum + Kill),
    case {Kill >= TRoleKill, Status} of
        {true, ?top_fight_role_status_match} ->
            settlement(T, Report#top_fight_report{trole_id = RoleId, tsrv_id = SrvId, tname = Name, trole_kill = Kill, tkill_sum = NewTKillSum, talive = (TAlive + 1), tiger_list = NewTigerList});
        {true, _} ->
            settlement(T, Report#top_fight_report{trole_id = RoleId, tsrv_id = SrvId, tname = Name, trole_kill = Kill, tkill_sum = NewTKillSum, tiger_list = NewTigerList});
        {false, ?top_fight_role_status_match} ->
            settlement(T, Report#top_fight_report{tkill_sum = NewTKillSum, talive = (TAlive + 1), tiger_list = NewTigerList});
        {false, _} ->
            settlement(T, Report#top_fight_report{tkill_sum = NewTKillSum, tiger_list = NewTigerList})
    end;
settlement([ArenaRole = #top_fight_role{role_id = {RoleId, SrvId}, name = Name, kill = Kill, group_id = ?top_fight_group_dragon, status = Status} | T], 
    Report = #top_fight_report{drole_kill = DRoleKill, dkill_sum = DKillSum, dalive = DAlive, dragon_list = DragonList}
) ->
    NewDragonList = [ArenaRole | DragonList],
    NewDKillSum = (DKillSum + Kill),
    case {Kill >= DRoleKill, Status} of
        {true, ?top_fight_role_status_match} ->
            settlement(T, Report#top_fight_report{drole_id = RoleId, dsrv_id = SrvId, dname = Name, drole_kill = Kill, dkill_sum = NewDKillSum, dalive = (DAlive + 1), dragon_list = NewDragonList});
        {true, _} ->
            settlement(T, Report#top_fight_report{drole_id = RoleId, dsrv_id = SrvId, dname = Name, drole_kill = Kill, dkill_sum = NewDKillSum, dragon_list = NewDragonList});
        {false, ?top_fight_role_status_match} ->
            settlement(T, Report#top_fight_report{dkill_sum = NewDKillSum, dalive = (DAlive + 1), dragon_list = NewDragonList});
        {false, _} ->
            settlement(T, Report#top_fight_report{dkill_sum = NewDKillSum, dragon_list = NewDragonList})
    end;
settlement([], Report = #top_fight_report{talive = TAlive, dalive = DAlive, robot_alive_dragon = AliveDragon, robot_alive_tiger = AliveTiger}) ->
    case {TAlive + AliveTiger, DAlive + AliveDragon} of
        {0, _} ->
            {true, Report};
        {_, 0} ->
            {true, Report};
        _ ->
            case {TAlive, DAlive} of
                {0, 0} -> {true, Report};
                _ -> {false, Report}
            end
    end.

%% 发送信息
send_by_arena_role_list([#top_fight_role{role_pid = RolePid, name = _Name, status = ?top_fight_role_status_match} | T], {Cmd, Data}) ->
    role:pack_send(RolePid, Cmd, Data),
    send_by_arena_role_list(T, {Cmd, Data});
send_by_arena_role_list([#top_fight_role{role_pid = RolePid, name = _Name, role_id = {_RoleId, _SrvId}, status = ?top_fight_role_status_idel} | T], {Cmd, Data}) ->
    role:pack_send(RolePid, Cmd, Data),
    send_by_arena_role_list(T, {Cmd, Data});
send_by_arena_role_list([#top_fight_role{name = _Name} | T], {Cmd, Data}) ->
    send_by_arena_role_list(T, {Cmd, Data});
send_by_arena_role_list([], {_Cmd, _Data}) ->
    {ok}.

%% 读组员信息
groups_info(?top_fight_group_tiger, [#top_fight_role{role_id = {RoleId, SrvId}, group_id = ?top_fight_group_tiger, name = Name, status = Status, has_buff = HasBuff} | T]) ->
    [{RoleId, SrvId, Name, Status, HasBuff} | groups_info(?top_fight_group_tiger, T)];
groups_info(?top_fight_group_dragon, [#top_fight_role{role_id = {RoleId, SrvId}, group_id = ?top_fight_group_dragon, name = Name, status = Status, has_buff = HasBuff} | T]) ->
    [{RoleId, SrvId, Name, Status, HasBuff} | groups_info(?top_fight_group_dragon, T)];
groups_info(Type, [_ArenaRole | T]) ->
    groups_info(Type, T);
groups_info(_Type, []) ->
    [].

%% 更新/增加组员信息
send_self_to_group(?top_fight_group_tiger, ArenaRole = #top_fight_role{role_id = {RoleId, SrvId}, name = Name, status = Status, has_buff = HasBuff}, [#top_fight_role{role_pid = RolePid, group_id = ?top_fight_group_tiger} | T]) ->
    role:pack_send(RolePid, 17312, {RoleId, SrvId, Name, Status, HasBuff}),
    send_self_to_group(?top_fight_group_tiger, ArenaRole, T);
send_self_to_group(?top_fight_group_dragon, ArenaRole = #top_fight_role{role_id = {RoleId, SrvId}, name = Name, status = Status, has_buff = HasBuff}, [#top_fight_role{role_pid = RolePid, group_id = ?top_fight_group_dragon} | T]) ->
    role:pack_send(RolePid, 17312, {RoleId, SrvId, Name, Status, HasBuff}),
    send_self_to_group(?top_fight_group_dragon, ArenaRole, T);
send_self_to_group(Type, ArenaRole, [_ArenaRole | T]) ->
    send_self_to_group(Type, ArenaRole, T);
send_self_to_group(_Type, _ArenaRole, []) ->
    ok.

%% 删除组员
send_group_delete(?top_fight_group_tiger, {RoleId, SrvId}, [#top_fight_role{group_id = ?top_fight_group_tiger, role_pid = RolePid} | T]) ->
    role:pack_send(RolePid, 17313, {RoleId, SrvId}),
    send_group_delete(?top_fight_group_tiger, {RoleId, SrvId}, T);
send_group_delete(?top_fight_group_dragon, {RoleId, SrvId}, [#top_fight_role{group_id = ?top_fight_group_dragon, role_pid = RolePid} | T]) ->
    role:pack_send(RolePid, 17313, {RoleId, SrvId}),
    send_group_delete(?top_fight_group_dragon, {RoleId, SrvId}, T);
send_group_delete(Group, {RoleId, SrvId}, [_ArenaRole | T]) ->
    send_group_delete(Group, {RoleId, SrvId}, T);
send_group_delete(_Group, {_RoleId, _SrvId}, []) ->
    ok.

%% 增加buff
do_add_buff(RoleId, SrvId, TRoleId, TSrvId, State = #state{role_list = RoleList}) ->
    case lists:keyfind({RoleId, SrvId}, #top_fight_role.role_id, RoleList) of
        false ->
            {false, ?L(<<"非法操作">>)};
        ArenaRole = #top_fight_role{op_buff = OpBuff, death = Death, name = Name} ->
            case {Death < 3, OpBuff >= 3} of
                {true, _} ->
                    {false, ?L(<<"死亡3次变为灵魂状态后才可以鼓舞组员">>)};
                {_, true} ->
                    {false, ?L(<<"你已经为队友加了3次鼓舞了">>)};
                {false, false} ->
                    case lists:keyfind({TRoleId, TSrvId}, #top_fight_role.role_id, RoleList) of
                        false ->
                            {false, ?L(<<"找不到队友">>)};
                        #top_fight_role{has_buff = ?true} ->
                            {false, ?L(<<"队友已经加了buff">>)};
                        #top_fight_role{status = 0} ->
                            {false, ?L(<<"队友已经阵亡">>)};
                        TArenaRole = #top_fight_role{role_pid = TRolePid, group_id = GroupId} ->
                            case is_pid(TRolePid) of
                                true ->
                                    %% case catch role:apply(sync, TRolePid, {arena_center, add_buff_to_role, []}) of
                                    %%     ok -> 
                                            role:apply(async, TRolePid, {top_fight_center, add_buff_to_role, []}),
                                            NewRoleList = lists:keyreplace({RoleId,SrvId}, #top_fight_role.role_id, RoleList, ArenaRole#top_fight_role{op_buff = (OpBuff + 1)}),
                                            NewTArenaRole = TArenaRole#top_fight_role{has_buff = ?true, buff_time = util:unixtime()},
                                            NewRoleList2 = lists:keyreplace({TRoleId, TSrvId}, #top_fight_role.role_id, NewRoleList, NewTArenaRole),
                                            send_self_to_group(GroupId, NewTArenaRole, RoleList),
                                            role:pack_send(TRolePid, 17323, {util:fbin(?L(<<"~s作为您坚强的后盾，对你进行了鼓舞，您的攻击力和五行抗性增加了20%">>), [Name])}),
                                            {ok, State#state{role_list = NewRoleList2}};
                                    %%     {false, Reason} ->
                                    %%         {false, Reason};
                                    %%     _ ->
                                    %%         {false, ?L(<<"添加buff有误">>)}
                                    %% end;
                                false ->
                                    {false, ?L(<<"队友可能下线了">>)}
                            end
                    end
            end
    end.

%% 角色添加buff
add_buff_to_role(Role) ->
    case buff:add(Role, ?top_fight_buff_label) of
        {ok, NewRole = #role{buff = #rbuff{buff_list = _BuffList}}} ->
            NewRole2 = role_api:push_attr(NewRole),
            {ok, NewRole2};
        {false, _Reason} ->
            {ok}
    end.

%% 发邮件
send_mail_group([], _GroupId, _Sscort) -> ok;
send_mail_group([#top_fight_role{score = Score, role_id = {RoleId, SrvId}, group_id = GroupId, arena_seq = Seq} | T], GroupId, Scort) ->
    NewScore = calc_mail_score(Scort, Score),
    MailContent = get_mail_content(win, Seq, Scort, NewScore),
    ?top_fight_NCAST(SrvId, mail, send_system, [{RoleId, SrvId}, {?L(<<"系统邮件">>), MailContent, [{?mail_arena, NewScore + 60 + 40}], []}]),
    send_mail_group(T, GroupId, Scort + 1);
send_mail_group([#top_fight_role{role_id = {RoleId, SrvId}, score = Score, arena_seq = Seq} | T], GroupId, Scort) ->
    NewScore = calc_mail_score(Scort, Score),
    MailContent = get_mail_content(lose, Seq, Scort, NewScore),
    ?top_fight_NCAST(SrvId, mail, send_system, [{RoleId, SrvId}, {?L(<<"系统邮件">>), MailContent, [{?mail_arena, NewScore + 60}], []}]),
    send_mail_group(T, GroupId, Scort + 1).

calc_mail_score(1, Score) ->
    case sys_env:get(merge_time) of
        undefined -> Score;
        MergeTime ->
            case util:unixtime({today, MergeTime}) =:= util:unixtime({today, util:unixtime()}) of
                true -> Score * 2;
                false -> Score
            end
    end;
calc_mail_score(_, Score) -> Score.

get_mail_content(win, 1, 1, Score) ->
    util:fbin(?L(<<"恭喜您所在的小组获得巅峰对决的胜利，额外获得40点仙法竞技积分，本次竞技中击败数排名第~w，获得~w个人积分和60基础积分！由于在第一战区排名第一，特此获得了巅峰霸主的称号和至尊战袍的时装外观！">>), [1, Score]);
get_mail_content(win, Seq, 1, Score) ->
    util:fbin(?L(<<"恭喜您所在的小组获得巅峰对决的胜利，额外获得40点仙法竞技积分，本次竞技中击败数排名第~w，获得~w个人积分和60基础积分！由于在第~w战区排名第一，特此获得了巅峰王者的称号！">>), [1, Score, Seq]);
get_mail_content(win, _Seq, Rank, Score) ->
    util:fbin(?L(<<"恭喜您所在的小组获得巅峰对决的胜利，额外获得40点仙法竞技积分，本次竞技中击败数排名第~w，获得~w个人积分和60基础积分！">>), [Rank, Score]);
get_mail_content(lose, 1, 1, Score) ->
    util:fbin(?L(<<"恭喜您本次竞技中击败数排名第~w，获得~w个人积分和60基础积分！由于在第一战区排名第一，特此获得了巅峰霸主的称号和至尊战袍的时装外观！">>), [1, Score]);
get_mail_content(lose, Seq, 1, Score) ->
    util:fbin(?L(<<"恭喜您本次竞技中击败数排名第~w，获得~w个人积分和60基础积分！由于在第~w战区排名第一，特此获得了巅峰王者的称号！">>), [1, Score, Seq]);
get_mail_content(_, _Seq, Rank, Score) ->
    util:fbin(?L(<<"本次竞技中击败数排名第~w，获得~w个人积分和60基础积分！">>), [Rank, Score]).

%% 发送胜利邮件
%% send_win_mail([]) -> ok;
%% send_win_mail([#top_fight_role{score = Score, role_id = {RoleId, SrvId}} | T]) ->
%%     NewScore = Score + 20,
%%     mail:send_system({RoleId, SrvId}, {<<"系统邮件">>, util:fbin(<<"恭喜您所在的小组获得仙法竞技的胜利，您获得了额外的40点仙法竞技积分和~w个人积分！开服前3天击败数排名前3的玩家可以额外获得竞技场礼盒，请继续努力。">>, [NewScore]) , [{?mail_arena, NewScore + 40}], []}),
%%     send_win_mail(T).
%% %% 发送胜利邮件
%% send_loser_mail([]) -> ok;
%% send_loser_mail([#top_fight_role{role_id = {RoleId, SrvId}, score = Score, kill = Kill, death = Death} | T]) ->
%%     case (Kill + Death)> 0 of
%%         true -> mail:send_system({RoleId, SrvId}, {<<"系统邮件">>, util:fbin(<<"您在本次仙法竞技中获得~w个人积分！开服前3天击败数排名前3的玩家可以额外获得竞技场礼盒，请继续努力。">>, [(Score + 20)]), [{?mail_arena, Score + 20}], []});
%%         false -> ignore
%%     end,
%%     send_loser_mail(T).

%% 杀人公告
win_report(SeriesKill, RoleId, SrvId, Name, MapId) ->
    RoleName = util:fbin(<<"{role, ~w, ~s, ~s, #ffe100}">>, [RoleId, SrvId, Name]),
    case SeriesKill of
        5 ->
            Msg = util:fbin(?L(<<"玩家~s已经杀死了5人，他正在大杀特杀!">>), [RoleName]),
            map:pack_send_to_all(MapId, 10931, {53, Msg, []});
        10 ->
            Msg = util:fbin(?L(<<"玩家~s已经杀死了10人，看来只有神才能阻止他了!">>), [RoleName]),
            map:pack_send_to_all(MapId, 10931, {53, Msg, []});
        15 ->
            Msg = util:fbin(?L(<<"玩家~s已经杀死了15人，暴走的~s如同神一般，拜托谁去杀了他吧!">>), [RoleName, RoleName]),
            map:pack_send_to_all(MapId, 10931, {53, Msg, []});
        20 ->
            Msg = util:fbin(?L(<<"玩家~s已经杀死了20人，超神的~s如入无人之境，正在疯狂屠戳!">>), [RoleName, RoleName]),
            map:pack_send_to_all(MapId, 10931, {53, Msg, []});
        25 ->
            Msg = util:fbin(?L(<<"玩家~s已经杀死了25人，~s的大名将成为所有人的噩梦!">>), [RoleName, RoleName]),
            map:pack_send_to_all(MapId, 10931, {53, Msg, []});
        _ ->
            ignore
    end.

%% 胜方提示
win_notice(_WinArenaRole = #top_fight_role{role_pid = RolePid}, _WFightCapacity, _LFightCapacity,  Score) ->
    role:pack_send(RolePid, 17323, {util:fbin(?L(<<"经过一番苦战，您取得了胜利，获得~w点积分">>), [Score])}).

%% 负方提示
lose_notice(_LoseArenaRole = #top_fight_role{role_pid = RolePid, death = _Death}) ->
    role:pack_send(RolePid, 17323, {util:fbin(?L(<<"很可惜，您技逊一筹，获得了~w积分">>), [18])}).

%% 奖励20个竞技场积分
%% 条件:死亡次数或者斩杀人数等于1时可获得奖励
%% add_arena_score([]) -> ok;
%% add_arena_score([#top_fight_role{kill = Kill, death = Death, role_pid = RolePid} | T]) ->
%%     case (Kill + Death) =:= 1 of
%%         true ->
%%             role:apply(async, RolePid, {arena, apply_add_arena_score, []}),
%%             add_arena_score(T);
%%         false ->
%%             add_arena_score(T)
%%     end.

%% 按杀人数快速排序
kill_qsort([]) -> [];
kill_qsort([ArenaRole = #top_fight_role{kill = Kill} | T]) ->
    kill_qsort([AR || AR = #top_fight_role{kill = ARKill} <- T, ARKill > Kill])
    ++ [ArenaRole] ++
    kill_qsort([AR || AR = #top_fight_role{kill = ARKill} <- T, ARKill =< Kill]).
%% 按积分快速排序
score_qsort([]) -> [];
score_qsort([ArenaRole = #top_fight_role{score = Score} | T]) ->
    score_qsort([AR || AR = #top_fight_role{score = AScore} <- T, AScore > Score])
    ++ [ArenaRole] ++
    score_qsort([AR || AR = #top_fight_role{score = AScore} <- T, AScore =< Score]).

%% 发放奖励
award_champion([], _State) ->
    ?DEBUG("用户列表为空"),
    ok;
award_champion([ArenaRole = #top_fight_role{kill =  Kill, role_id = {RoleId, SrvId}, name = _Name} | T], #state{arena_seq = _ArenaSeq, time = Time}) ->
    ?DEBUG("~w, ~w, ~w, ~s", [Time, Kill, RoleId, SrvId]),
    case Kill =/= 0 of
        true ->
            %top_fight_center_mgr:update_last_win(ArenaLev, RoleId, SrvId, Name, Kill),
            top_fight_dao_log:update_winner(RoleId, SrvId, Time, ?true),
            %RoleName = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>, [RoleId, SrvId, Name]),
            %?top_fight_NCAST(SrvId, notice, send, [53, util:fbin(?L(<<"巅峰对决第~w区结束，玩家~s技压群雄，夺得本区第一名，受众人膜拜。">>), [ArenaSeq, RoleName])]),
            StartGameTime = sys_env:get(srv_open_time), %% 开服时间
            case (util:unixtime() - StartGameTime - 259200) < 0 of
                true -> award_tanhua([ArenaRole | T], 1, 1);
                false -> ignore
            end;
        false -> ignore
    end.
award_tanhua([], _Order, _LastKill) ->
    ok;
award_tanhua([#top_fight_role{role_id = {RoleId, SrvId}, kill = Kill, arena_lev = ArenaLev} | T], Order, LastKill) ->
    BoxId = case ArenaLev of
        ?top_fight_lev_low -> 29100;
        ?top_fight_lev_middle -> 29101;
        ?top_fight_lev_hight -> 29102;
        _ -> 29103
    end,
    case Order =< 3 andalso Kill =/= 0 of
        true ->
            {ok, [Item]} = item:make(BoxId, 1, 1),
            ?top_fight_NCAST(SrvId, mail, send_system, [{RoleId, SrvId}, {?L(<<"系统邮件">>), util:fbin(?L(<<"您在巅峰对决中仙力超群，获得仙法竞技第~w名。">>), [Order]), [], [Item]}]),
            award_tanhua(T, Order + 1, Kill);
        false ->
            case Kill =:= LastKill andalso Kill =/= 0 of
                true ->
                    {ok, [Item]} = item:make(BoxId, 1, 1),
                    ?top_fight_NCAST(SrvId, mail, send_system, [{RoleId, SrvId}, {?L(<<"系统邮件">>), ?L(<<"您在巅峰对决中仙力超群，获得仙法竞技第3名。">>), [], [Item]}]),
                    award_tanhua(T, Order + 1, Kill);
                false ->
                    ignore
            end
    end.

%% 异步增加20个竞技场积分
%% apply_add_arena_score(Role = #role{assets = Assets = #assets{arena = ArenaScore, acc_arena = AccArena}}) ->
%%     {ok, Role#role{assets = Assets#assets{arena = (ArenaScore + 20), acc_arena = (AccArena + 20)}}}.

%% 停止所有玩家战斗
stop_all_combat([], _CombatPidList) ->
    ok;
stop_all_combat([#top_fight_role{role_pid = RolePid, name = _Name, status = ?top_fight_role_status_match} | T], CombatPidList) ->
    case role:apply(sync, RolePid, {top_fight_center, apply_get_combat_pid, []}) of
        {ok, CombatPid} ->
            case lists:member(CombatPid, CombatPidList) of
                true -> stop_all_combat(T, CombatPidList);
                false ->
                    combat_type:stop_combat(CombatPid),
                    stop_all_combat(T, [CombatPid | CombatPidList])
            end;
        _ -> stop_all_combat(T, CombatPidList)
    end;
stop_all_combat([_ArenaRole | T], CombatPidList) ->
    stop_all_combat(T, CombatPidList).

%% 获取玩家战斗进程ID
apply_get_combat_pid(#role{status = ?status_fight, combat_pid = CombatPid}) ->
    {ok, {ok, CombatPid}};
apply_get_combat_pid(_Role) ->
    {ok, {false, ?L(<<"非战斗状态">>)}}.

%% 转换17304协议数据
convert_17304(RoleList) ->
    [{RoleId, SrvId, Name, Lev, Career, Kill, Death, (Score + additional_score(ArenaLev))} || #top_fight_role{role_id = {RoleId, SrvId}, name = Name, lev = Lev, career = Career, kill = Kill, death = Death, score = Score, arena_lev = ArenaLev} <- RoleList].

additional_score(?top_fight_lev_super) -> 60;
additional_score(?top_fight_lev_angle) -> 60;
additional_score(_) -> 20.

%% 初始化机器人
init_robot(State, ArenaLev, MapId, RoleSize) ->
    SupplyNum = top_fight_data:supply(ArenaLev, RoleSize),
    Div = SupplyNum div 2,
    Rem = SupplyNum rem 2,
    DragonNum = Div,
    TigerNum = Div + Rem,
    DNpcs = top_fight_data:robot_base(ArenaLev, ?top_fight_group_dragon),
    TNpcs = top_fight_data:robot_base(ArenaLev, ?top_fight_group_tiger),
    RobotDragon = create_robot(?top_fight_group_dragon, DNpcs, MapId, DragonNum),
    RobotTiger = create_robot(?top_fight_group_tiger, TNpcs, MapId, TigerNum),
    State#state{robot_alive_dragon = RobotDragon, robot_alive_tiger = RobotTiger, robot_relive_dragon = RobotDragon * 2, robot_relive_tiger = RobotTiger * 2}.

create_robot(_GroupId, _NpcList, _MapId, Num) when Num < 1 -> 0;
create_robot(GroupId, NpcList, MapId, Num) ->
    {X, Y} = case GroupId of
        ?top_fight_group_dragon -> ?top_fight_relive_dragon;
        _ -> ?top_fight_relive_tiger
    end,
    NewX = util:rand(X - 100, X + 100),
    NewY = util:rand(Y - 100, Y + 100),
    case npc_mgr:create(util:rand_list(NpcList), MapId, NewX, NewY) of
        {ok, _NpcBaseId} ->
            1 + create_robot(GroupId, NpcList, MapId, Num - 1);
        _Reason ->
            ?ERR("竞技场生成机器人失败:~w", [_Reason]),
            create_robot(GroupId, NpcList, MapId, Num - 1)
    end.

%% 查找积分buff
%% calc_buff_score(_Role = #role{buff = #rbuff{buff_list = BuffList}}, OldScore) ->
%%     case buff:search(BuffList, ?top_fight_buff_score) of
%%         [] -> 
%%             {ok, {ok, OldScore}};
%%         _ -> 
%%             {ok, {ok, round(OldScore * 1.5)}}
%%     end.

%% 重新计算超时时间，继续某一状态
continue(match, State) ->
    {next_state, match, State};
continue(expire, State = #state{ts = Ts}) ->
    {next_state, expire, State, util:time_left(?top_fight_timeout_expire, Ts)}.

continue(match, Reply, State) ->
    {reply, Reply, match, State};
continue(expire, Reply, State = #state{ts = Ts}) ->
    {reply, Reply, expire, State, util:time_left(?top_fight_timeout_expire, Ts)}.

%% 记录积分
save_score_log(RoleList, State) ->
    lists:foreach(fun(Trole)-> do_save_score_log(Trole, State) end, RoleList).

do_save_score_log(#top_fight_role{role_id = {RoleId, SrvId}, group_id = GroupId, name = Name, score = Score, kill = Kill, career = Career, lev = Lev, death = Death, fight_capacity = Fc, pet_fight_capacity = PetFc}, #state{week = Week, time = Time, arena_lev = ArenaLev, arena_seq = ArenaSeq}) ->
    top_fight_dao_log:replace_insert_log(RoleId, SrvId, Name, Week, Time, Score, Kill, ArenaLev, ArenaSeq, Career, Lev, GroupId, Death, Fc, PetFc).

