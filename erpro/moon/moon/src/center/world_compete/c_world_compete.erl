%%----------------------------------------------------
%% 跨服排行榜管理器（针对单独平台）
%% @author yankai@jieyou.cn
%% @end
%%----------------------------------------------------
-module(c_world_compete).

-behaviour(gen_server).

-export([
        create/2,
        calc_first_section_mark/1
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("combat.hrl").
-include("attr.hrl").
-include("world_compete.hrl").
-include("role.hrl").

-define(WORLD_COMPETE_MATCH_DIRECTION_UP, 1).       %% 匹配方向：上（允许匹配战斗力更高的）
-define(WORLD_COMPETE_MATCH_DIRECTION_DOWN, 2).     %% 匹配方向：下（只允许匹配战斗更低的）


-define(PREPARE_COMBAT_TIME, 1000 * 30).    %% 在准备区等待进入战斗的时间
-define(MATCH_TEAM_TIME1, 8000).     %% 匹配队伍的间隔时间（毫秒）
-define(MATCH_TEAM_TIME2, 6000).     %% 匹配队伍的间隔时间（毫秒）
-define(MATCH_TEAM_NUM, 200).       %% 每次匹配时挑选多少个队伍做主动匹配方

-record(state, {
        name = <<>>,         %% 名称
        is_started = false,  %% 活动是否已经开始
        type                 %% 仙道会类型
    }
).

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------
create(WorldCompeteType, Name) ->
    gen_server:start_link({local, Name}, ?MODULE, [WorldCompeteType, Name], []).

%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------
init([WorldCompeteType, Name]) ->
    %% 战斗区域信息
    put(match_maps, []),
    %% 成功报名的队伍
    put(sign_up_teams, []),
    %% 等待匹配队友的队伍
    put(teammate_queue, []),
    %% 仙道会战绩和积分
    put(world_compete_marks, []),
    %% 缓存仙道会类型
    put(world_compete_type, WorldCompeteType),
    %% 统计人数
    put(sign_up_statistic, []),
    %% 选择的阵法 [{RoleIds, LineupId}]
    put(selected_lineup, []),
    %% 缓存每个参加仙道会的角色的ets的名字
    EtsName = list_to_atom(atom_to_list(Name) ++ "_role"),
    put(ets_name, EtsName),
    %% 启动一个保存参加仙道会的每个角色的信息的ets
    ets:new(EtsName, [set, named_table, public, {keypos, #sign_up_role.id}]),
    %% 创建地图池
    create_map_pool(),
    State = #state{name = Name, type = WorldCompeteType},
    ?DEBUG("仙道会管理器[~s] 启动成功", [Name]),
    {ok, State}.

handle_call({check_role_login_status, RoleId}, _From, State = #state{is_started = false}) ->
    {reply, {ok, activity_stopped, RoleId}, State};
handle_call({check_role_login_status, RoleId}, _From, State = #state{is_started = true}) ->
    Result = case is_in_match_map(RoleId) of
        {true, MapId, X, Y} ->
            {_, LineupId} = get_selected_lineup(RoleId),
            {in_match_map, MapId, X, Y, LineupId};
        false ->
            case is_in_matching_queue(RoleId) of
                true -> in_matching;
                false ->
                    case is_in_teammate_queue(RoleId) of
                        true -> in_matching;
                        false -> normal
                    end
            end
    end,
    ?DEBUG("[~w]的登陆状态是:~w", [RoleId, Result]),
    {reply, {ok, Result, RoleId}, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(Msg, State) ->
    ?ERR("收到未知消息: ~w", [Msg]),
    {noreply, State}.

handle_info(print_sign_up_teams_info, State = #state{name = Name}) ->
    ?INFO("仙道会平台管理器[~s]的报名队伍信息:等待匹配[~w]组, 已匹配上的[~w]对", [Name, length(get(sign_up_teams)), length(get(match_maps))]),
    {noreply, State};

handle_info(start_activity, State = #state{is_started = false}) ->
    %% 活动开始就清空个人战绩记录
    put(sign_up_teams, []),
    put(teammate_queue, []),
    put(world_compete_marks, []),
    put(sign_up_statistic, []),
    put(selected_lineup, []),
    %% 关闭打印标记，防止刷屏
    put(match_print_flag, false),
    put(match_print_latitude, 0.5),
    put(matching_queue_print_flag, false),
    ets:delete_all_objects(get(ets_name)),
    destroy_all_match_maps(),
    erlang:send_after(?MATCH_TEAM_TIME1, self(), match_teams),
    {noreply, State#state{is_started = true}};

handle_info(stop_activity, State = #state{is_started = true}) ->
    lists:foreach(fun(#sign_up_team{id = RoleIds}) ->
                self() ! {cancel_match, RoleIds}
        end, get(sign_up_teams)),
    %% 打印统计信息
    print_signup_statistic(),
    %% 活动结束后一段时间内清除数据
    erlang:send_after(1000*60*10, self(), clean_up),
    {noreply, State#state{is_started = false}};

handle_info(clean_up, State = #state{is_started = false}) ->
    ets:delete_all_objects(get(ets_name)),
    destroy_all_match_maps(),
    {noreply, State};

handle_info({sign_up, SignupRoles1}, State = #state{type = WorldCompeteType}) ->
    SignupRoles = append_section_info(SignupRoles1, []),
    RoleIds = get_all_sign_up_role_id(SignupRoles),
    ?DEBUG("收到报名请求[~w]", [RoleIds]),
    case can_sign_up(SignupRoles) of
        true ->
            case need_match_teammate(SignupRoles) of
                true ->
                    add_team_to_teammate_queue(SignupRoles),
                    ?DEBUG("[~w]成功加到匹配队友队列", [RoleIds]);
                false ->
                    add_team_to_matching_queue(SignupRoles),
                    ?DEBUG("[~w]成功加到匹配对手队列", [RoleIds])
            end,
            send_to_node(RoleIds, world_compete_mgr, sign_up_result_inform, [RoleIds, {true, WorldCompeteType}]);
        {false, Reason} ->
            send_to_node(RoleIds, world_compete_mgr, sign_up_result_inform, [RoleIds, {false, WorldCompeteType, Reason}])
    end,
    c_world_compete_mgr:remove_signing_up_role(RoleIds),
    {noreply, State};

handle_info({cancel_match, RoleIds = [RoleId = {_, SrvId}|_]}, State) ->
    ?DEBUG("收到取消报名请求[~w]", [RoleIds]),
    case get_signup_team_info(RoleId) of
        #sign_up_team{id = RoleIds1} ->
            case can_cancel_match(RoleIds1) of
                true ->
                    remove_team_from_teammate_queue(RoleIds1),
                    remove_team_from_matching_queue(RoleIds1),
                    %% 按照原始组队信息把队伍拆分出来重新匹配
                    {CancelRoleIds, RejoinSignupRoles} = split_to_origin_teams(RoleId, RoleIds1),
                    ?DEBUG("~w需要取消匹配，~w重新加入匹配队友队列", [CancelRoleIds, [RejoinSignupRoleId || #sign_up_role{id = RejoinSignupRoleId} <- RejoinSignupRoles]]),
                    case RejoinSignupRoles of
                        [_|_] -> add_team_to_teammate_queue(RejoinSignupRoles);
                        _ -> ignore
                    end,
                    change_sign_up_role_status(CancelRoleIds, ?WORLD_COMPETE_ROLE_STATUS_NORMAL),
                    send_to_node(RoleIds1, world_compete_mgr, cancel_match_result_inform, [CancelRoleIds, true]);
                {false, matched} ->
                    send_to_node(RoleIds1, world_compete_mgr, cancel_match_result_inform, [RoleIds1, {false, matched}]);
                _ ->
                    send_to_node(RoleIds1, world_compete_mgr, cancel_match_result_inform, [RoleIds1, false])
            end;
        _ ->
            case can_cancel_match(RoleIds) of
                true ->
                    remove_team_from_teammate_queue(RoleIds),
                    change_sign_up_role_status(RoleIds, ?WORLD_COMPETE_ROLE_STATUS_NORMAL),
                    c_mirror_group:cast(node, SrvId, world_compete_mgr, cancel_match_result_inform, [RoleIds, true]);
                {false, matched} ->
                    send_to_node(RoleIds, world_compete_mgr, cancel_match_result_inform, [RoleIds, {false, matched}]);
                _ ->
                    send_to_node(RoleIds, world_compete_mgr, cancel_match_result_inform, [RoleIds, false])
            end
    end,
    {noreply, State};

handle_info({remove_from_matching_queue, RoleId = {Rid, SrvId}}, State) ->
    ?INFO("正在移除[~w, ~s]的待匹配信息", [Rid, SrvId]),
    change_sign_up_role_status(RoleId, ?WORLD_COMPETE_ROLE_STATUS_NORMAL),
    remove_team_from_matching_queue(RoleId),
    remove_team_from_teammate_queue(RoleId),
    ?INFO("移除成功"),
    {noreply, State};

handle_info(match_teams, State = #state{type = WorldCompeteType, is_started = true}) ->
    match_teammate(),
    {NotMatch, Match} = match_teams(WorldCompeteType),
    put(sign_up_teams, NotMatch),
    notify_prepare_combat(Match, State),
    erlang:send_after(?MATCH_TEAM_TIME2, self(), match_teams),
    {noreply, State};

handle_info({start_combat, Team1 = #sign_up_team{id = RoleIds1}, Team2 = #sign_up_team{id = RoleIds2}, MapPid}, State = #state{type = WorldCompeteType}) ->
    RoleIds = RoleIds1 ++ RoleIds2,
    change_sign_up_role_status(RoleIds, ?WORLD_COMPETE_ROLE_STATUS_NORMAL),
    %% 如果每队的人数数量和对应的仙道会类型要求的人数不对应，则打印出来
    Len1 = length(RoleIds1),
    Len2 = length(RoleIds2),
    IsNumMatched = case WorldCompeteType of
        ?WORLD_COMPETE_TYPE_11 -> Len1 =:= 1 andalso Len2 =:= 1;
        ?WORLD_COMPETE_TYPE_22 -> Len1 =:= 2 andalso Len2 =:= 2;
        ?WORLD_COMPETE_TYPE_33 -> Len1 =:= 3 andalso Len2 =:= 3;
        _ -> true
    end,
    case IsNumMatched of
        true -> ignore;
        false -> ?ERR("仙道会[Type=~w]的战斗人数不匹配：Len1=~w, Len2=~w, RoleIds1=~w, RoleIds2=~w", [WorldCompeteType, Len1, Len2, RoleIds1, RoleIds2])
    end,
    %% 开一个新进程发起战斗
    WorldCompetePid = self(),
    {_, LineupId1} = get_selected_lineup(RoleIds1),
    {_, LineupId2} = get_selected_lineup(RoleIds2),
    ?DEBUG("[~w]选择的阵法是:~w", [RoleIds1, LineupId1]),
    ?DEBUG("[~w]选择的阵法是:~w", [RoleIds2, LineupId2]),
    delete_selected_lineup(RoleIds1),
    delete_selected_lineup(RoleIds2),
    spawn(fun() -> start_combat(Team1#sign_up_team{selected_lineup = LineupId1}, Team2#sign_up_team{selected_lineup = LineupId2}, MapPid, 0, WorldCompetePid) end),
    {noreply, State};

handle_info({start_combat_result, failed1, _SuccessRoleIds, FailedRoleIds, FailedReasons}, State = #state{type = WorldCompeteType}) ->
    ?DEBUG("[~w]发起战斗成功, [~w]参加战斗失败", [_SuccessRoleIds, FailedRoleIds]),
    lists:foreach(fun(RoleId) ->
                AveragePower = calc_average_power([RoleId], 0, 0),
                case combat_util:match_param(RoleId, FailedReasons, other) of
                    timeout -> 
                        deal_other_result(?c_world_compete_result_draw, WorldCompeteType, AveragePower, [RoleId]);
                    _ ->
                        deal_other_result(?c_world_compete_result_loss_perfect, WorldCompeteType, AveragePower, [RoleId])
                end,
                send_to_node([RoleId], world_compete_mgr, start_combat_result_inform, [RoleId, {false, just_failed}])
        end, FailedRoleIds),
    {noreply, State};

handle_info({start_combat_result, failed2, _Why, RoleIds1, RoleIds2}, State = #state{type = WorldCompeteType}) ->
    ?ERR("[~w]和[~w]发起战斗失败:~w", [RoleIds1, RoleIds2, _Why]),
    RoleIds = RoleIds1 ++ RoleIds2,
    lists:foreach(fun(RoleId) ->
                send_to_node([RoleId], world_compete_mgr, start_combat_result_inform, [RoleId, {false, just_failed}])
        end, RoleIds),
    AveragePower1 = calc_average_power(RoleIds1, 0, 0),
    deal_other_result(?c_world_compete_result_draw, WorldCompeteType, AveragePower1, RoleIds1),
    AveragePower2 = calc_average_power(RoleIds2, 0, 0),
    deal_other_result(?c_world_compete_result_draw, WorldCompeteType, AveragePower2, RoleIds2),
    erlang:send_after(2000, self(), {destroy_match_map, RoleIds}),
    {noreply, State};

%% TODO:怎样利用失败原因？
handle_info({start_combat_result, failed3, L1, L2, RoleIds1, RoleIds2, FailedRoleIds, _FailedReasons}, State = #state{type = WorldCompeteType}) ->
    RoleIds = RoleIds1 ++ RoleIds2,
    {Result1, Result2} = if
        length(L1) > 0 andalso length(L2) =<0 ->
            ?ERR("[~w]和[~w]发起战斗失败，[~w]方参战失败，失败的有:~w", [RoleIds1, RoleIds2, RoleIds2, FailedRoleIds]),
            %% 成功个数>0的一方提示另外一方掉线或离场
            lists:foreach(fun(RoleId) ->
                        send_to_node([RoleId], world_compete_mgr, start_combat_result_inform, [RoleId, {false, op_leave}])
                end, RoleIds1),
            %% 成功个数=0的一方提示不稳定
            lists:foreach(fun(RoleId) ->
                        send_to_node([RoleId], world_compete_mgr, start_combat_result_inform, [RoleId, {false, just_failed}])
                end, RoleIds2),
            {?c_world_compete_result_ko_perfect, ?c_world_compete_result_loss_perfect};
        length(L1) =<0 andalso length(L2) > 0 ->
            ?ERR("[~w]和[~w]发起战斗失败，[~w]方参战失败，失败的有:~w", [RoleIds1, RoleIds2, RoleIds1, FailedRoleIds]),
            %% 成功个数>0的一方提示另外一方掉线或离场
            lists:foreach(fun(RoleId) ->
                        send_to_node([RoleId], world_compete_mgr, start_combat_result_inform, [RoleId, {false, op_leave}])
                end, RoleIds2),
            %% 成功个数=0的一方提示不稳定
            lists:foreach(fun(RoleId) ->
                        send_to_node([RoleId], world_compete_mgr, start_combat_result_inform, [RoleId, {false, just_failed}])
                end, RoleIds1),
            {?c_world_compete_result_loss_perfect, ?c_world_compete_result_ko_perfect};
        true ->
            ?ERR("[~w]和[~w]发起战斗失败，双方参战失败", [RoleIds1, RoleIds2]),
            lists:foreach(fun(RoleId) ->
                        send_to_node([RoleId], world_compete_mgr, start_combat_result_inform, [RoleId, {false, just_failed}])
                end, RoleIds),
            {?c_world_compete_result_loss_perfect, ?c_world_compete_result_loss_perfect}
    end,
    AveragePower1 = calc_average_power(RoleIds1, 0, 0),
    deal_other_result(Result1, WorldCompeteType, AveragePower1, RoleIds1),
    AveragePower2 = calc_average_power(RoleIds2, 0, 0),
    deal_other_result(Result2, WorldCompeteType, AveragePower2, RoleIds2),
    erlang:send_after(5000, self(), {destroy_match_map, RoleIds}),
    {noreply, State};

handle_info({combat_over, Winner, Loser, TimerPid}, State) ->
    do_combat_over(Winner, Loser, TimerPid, State),
    {noreply, State};

handle_info({destroy_match_map, RoleIds}, State) ->
    destroy_match_map(RoleIds),
    remove_from_match_map(RoleIds),
    {noreply, State};

%% 角色主动强制退出战区，则清理他的报名信息
handle_info({force_leave_prepare_combat, RoleId}, State) ->
    remove_sign_up_role(RoleId),
    {noreply, State};

%% 设置匹配打印标记
handle_info({set_match_print_flag, Flag, Latitude}, State = #state{type = WorldCompeteType}) ->
    ?INFO("仙道会[type=~w]设置匹配打印标记:~w, 容错值临界=~w", [WorldCompeteType, Flag, Latitude]),
    put(match_print_flag, Flag),
    put(match_print_latitude, Latitude),
    {noreply, State};

%% 设置待匹配队列打印标记
handle_info({set_matching_queue_print_flag, Flag}, State = #state{type = WorldCompeteType}) ->
    ?INFO("仙道会[type=~w]设置待匹配队列打印标记:~w", [WorldCompeteType, Flag]),
    put(matching_queue_print_flag, Flag),
    {noreply, State};

%% 重置地图回调
handle_info({reset_map_callback, MapId, MapPid}, State) ->
    ?DEBUG("地图[Id=~w, Pid=~w]已重置，正式回收", [MapId, MapPid]),
    case get(maps) of
        Maps = [_|_] ->
            put(maps, Maps ++ [{MapId, MapPid, true}]);
        _ -> ignore
    end,
    {noreply, State};

%% 改变阵法
handle_info({change_lineup, RoleId, LineupId}, State) ->
    case do_change_lineup(RoleId, LineupId) of
        {true, RoleIds, LineupId} ->
            lists:foreach(fun(RoleId1) ->
                        send_to_node(RoleId1, world_compete_mgr,  change_lineup_result_inform, [true, RoleId1, LineupId])
                    end, RoleIds);
        false ->
            {_, OldLineupId} = get_selected_lineup(RoleId),
            send_to_node(RoleId, world_compete_mgr,  change_lineup_result_inform, [false, RoleId, OldLineupId])
    end,
    {noreply, State};

handle_info(stop, State) ->
    {stop, normal, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(Reason, #state{name = _Name}) ->
    case Reason of
        normal -> ignore;
        _ -> ?ERR("仙道会平台管理器[~s]异常终止:~w", [_Name, Reason])
    end,
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%%------------------------------------------
%% 报名
%%------------------------------------------
%% 判断能否报名 -> true | {false, Reason}
%% Reason = atom()
can_sign_up([]) -> true;
can_sign_up([#sign_up_role{id = RoleId}|T]) ->
    case ets:lookup(get(ets_name), RoleId) of
        [#sign_up_role{status = ?WORLD_COMPETE_ROLE_STATUS_SIGNUP}] -> {false, in_matching};
        [#sign_up_role{status = ?WORLD_COMPETE_ROLE_STATUS_MATCHED, map_pid = MapPid}] ->
            case is_pid(MapPid) andalso is_process_alive(MapPid) of
                true -> {false, in_match_map};
                false -> can_sign_up(T)
            end;
        _ -> can_sign_up(T)
    end.

%% 获取报名角色信息
get_signup_role_info(RoleId) ->
    case ets:lookup(get(ets_name), RoleId) of
        [_R = #sign_up_role{name = Name, career = Career, sex = Sex, lev = Lev, looks = Looks, eqm = Eqm, attr = #attr{fight_capacity = RolePower}, pet_power = PetPower}] -> {Name, Career, Sex, Lev, Looks, Eqm, RolePower, PetPower};
        _Any -> {<<>>, 0, 0, 1, [], [], 0, 0}
    end.

%% 获取报名角色的战斗力
get_signup_role_power(RoleId) ->
    case ets:lookup(get(ets_name), RoleId) of
        [#sign_up_role{attr = #attr{fight_capacity = FC}}] -> FC;
        _ -> 0
    end.

%% 获取报名角色的职业
get_signup_role_career(RoleId) ->
    {_, Career, _, _, _, _, _, _} = get_signup_role_info(RoleId),
    Career.

%% 获取报名角色的可选阵法 -> [integer()]
get_signup_role_lineup(RoleId) ->
    case ets:lookup(get(ets_name), RoleId) of
        [#sign_up_role{lineups = Lineups}] -> Lineups;
        _ -> []
    end.

%% 获取所有报名角色的id -> [{Rid, SrvId}]
get_all_sign_up_role_id(SignupRoles) ->
    [RoleId || #sign_up_role{id = RoleId} <- SignupRoles].

%% 修改报名者的状态
change_sign_up_role_status(RoleIds, Status) when is_list(RoleIds) ->
    lists:foreach(fun(RoleId) ->
                change_sign_up_role_status(RoleId, Status)
            end, RoleIds);
change_sign_up_role_status(RoleId, Status) ->
    case ets:lookup(get(ets_name), RoleId) of
        [SignupRole = #sign_up_role{}] ->
            ets:insert(get(ets_name), SignupRole#sign_up_role{status = Status});
        _ -> ?ERR("找不到[~w]的报名信息，无法修改其状态为:~w", [RoleId, Status])
    end.

change_sign_up_role_map_info(RoleIds, MapId, MapPid, X, Y) when is_list(RoleIds) ->
    lists:foreach(fun(RoleId) ->
                change_sign_up_role_map_info(RoleId, MapId, MapPid, X, Y)
            end, RoleIds);
change_sign_up_role_map_info(RoleId, MapId, MapPid, X, Y) ->
    case ets:lookup(get(ets_name), RoleId) of
        [SignupRole = #sign_up_role{}] ->
            ets:insert(get(ets_name), SignupRole#sign_up_role{map_id = MapId, map_pid = MapPid, enter_point = {X, Y}});
        _ -> ?ERR("找不到[~w]的报名信息，无法修改其地图信息", [RoleId])
    end.

%% 获取报名者所在的地图信息
get_sign_up_role_map_info(RoleId) ->
    case ets:lookup(get(ets_name), RoleId) of
        [#sign_up_role{map_id = MapId, map_pid = MapPid, enter_point = {X, Y}}] -> {MapId, MapPid, X, Y};
        _ -> undefined
    end.


%% 从ets中移除
remove_sign_up_role(RoleId) -> ets:delete(get(ets_name), RoleId).

remove_sign_up_roles([]) -> ok;
remove_sign_up_roles([RoleId|T]) ->
    remove_sign_up_role(RoleId),
    remove_sign_up_roles(T).


%%------------------------------------------
%% 匹配队友
%%------------------------------------------
%% 判断是否需要匹配队友 -> true | false
%% SignupRoles = [#sign_up_role{}]
need_match_teammate(SignupRoles) ->
    Len = length(SignupRoles),
    case get(world_compete_type) of
        ?WORLD_COMPETE_TYPE_11 -> false;
        ?WORLD_COMPETE_TYPE_22 -> Len < 2;
        ?WORLD_COMPETE_TYPE_33 -> Len < 3
    end.

%% 队伍加入到待匹配队友队列中 -> true | {false, Reason}
%% SignupRoles = [#sign_up_role{}]
add_team_to_teammate_queue(SignupRoles) ->
    RoleIds = [RoleId || #sign_up_role{id = RoleId} <- SignupRoles],
    remove_team_from_teammate_queue(RoleIds),
    lists:foreach(fun(SignupRole) ->
                ets:insert(get(ets_name), SignupRole#sign_up_role{status = ?WORLD_COMPETE_ROLE_STATUS_SIGNUP, map_pid = 0})
            end, SignupRoles),
    TotalPower = simple_calc_total_power(RoleIds),
    {SectionMark, SectionLev} = simple_calc_section_mark(SignupRoles),
    put(teammate_queue, [#sign_up_team{id = RoleIds, total_power = TotalPower, section_mark = SectionMark, section_lev = SectionLev}|get(teammate_queue)]).

%% 把队伍从待匹配队友队列中移除
remove_team_from_teammate_queue(RoleIds) when is_list(RoleIds) ->
    lists:foreach(fun(RoleId) ->
                remove_team_from_teammate_queue(RoleId)
        end, RoleIds);
remove_team_from_teammate_queue(RoleId) ->
    Teams = get(teammate_queue),
    Result = do_remove_team_from_teammate_queue(RoleId, Teams, []),
    put(teammate_queue, Result).
do_remove_team_from_teammate_queue(_, [], Result) -> Result;
do_remove_team_from_teammate_queue(RoleId, [Team = #sign_up_team{id = RoleIds}|T], Result) ->
    case lists:member(RoleId, RoleIds) of
        true -> Result ++ T;
        false -> do_remove_team_from_teammate_queue(RoleId, T, [Team|Result])
    end.

%% 是否在待匹配队友队列中
is_in_teammate_queue(RoleId) ->
    case get(teammate_queue) of
        undefined -> false;
        L -> do_is_in_teammate_queue(RoleId, L)
    end.
do_is_in_teammate_queue(_RoleId, []) -> false;
do_is_in_teammate_queue(RoleId, [#sign_up_team{id = RoleIds}|T]) ->
    case lists:member(RoleId, RoleIds) of
        true -> true;
        false -> do_is_in_teammate_queue(RoleId, T)
    end.

%% 匹配队友
match_teammate() ->
    Teams = get(teammate_queue),
    SortedTeams = lists:reverse(lists:keysort(#sign_up_team.total_power, Teams)),
    WorldCompeteType = get(world_compete_type),
    {Match, NotMatch} = do_match_teammate(WorldCompeteType, SortedTeams, SortedTeams, [], []),
    %% ?DEBUG("match_teammate:~w,~w", [[MatchRoleIds || #sign_up_team{id = MatchRoleIds} <- Match], [NotMatchRoleIds || #sign_up_team{id = NotMatchRoleIds} <- NotMatch]]),
    put(sign_up_teams, get(sign_up_teams) ++ Match),
    put(teammate_queue, NotMatch).

%% do_match_teammate() -> {Match, NotMatch}
%% Match = [#sign_up_team{}] 合并后的新team
%% NotMatch = [#sign_up_team{}] 原来的team
do_match_teammate(_, [], _, Match, NotMatch) -> {Match, NotMatch};
do_match_teammate(?WORLD_COMPETE_TYPE_22, [Team1 = #sign_up_team{match_count = MatchCountOld}|T], Ops, Match, NotMatch) ->
    case make_matched_teammate(?WORLD_COMPETE_TYPE_22, Team1, Ops) of
        Team2 when is_record(Team2, sign_up_team) ->
            NewTeam = combine_teams([Team1, Team2]),
            do_match_teammate(?WORLD_COMPETE_TYPE_22, T -- [Team1, Team2], Ops -- [Team1, Team2], [NewTeam|Match], NotMatch);
        _ ->
            do_match_teammate(?WORLD_COMPETE_TYPE_22, T, Ops -- [Team1], Match, [Team1#sign_up_team{match_count = MatchCountOld + 1}|NotMatch])
    end;
do_match_teammate(?WORLD_COMPETE_TYPE_33, [Team1 = #sign_up_team{match_count = MatchCountOld}|T], Ops, Match, NotMatch) ->
    case make_matched_teammate(?WORLD_COMPETE_TYPE_33, Team1, Ops, [Team1]) of
        Teams when is_list(Teams) ->
            NewTeam = combine_teams(Teams),
            do_match_teammate(?WORLD_COMPETE_TYPE_33, T -- Teams, Ops -- Teams, [NewTeam|Match], NotMatch);
        _ ->
            do_match_teammate(?WORLD_COMPETE_TYPE_33, T, Ops -- [Team1], Match, [Team1#sign_up_team{match_count = MatchCountOld + 1}|NotMatch])
    end.


%% 获取匹配的队友(2v2) -> #sign_up_team{} | undefined
make_matched_teammate(?WORLD_COMPETE_TYPE_22, _Team1, []) -> undefined;
make_matched_teammate(?WORLD_COMPETE_TYPE_22, Team1, [Team1|T]) -> make_matched_teammate(?WORLD_COMPETE_TYPE_22, Team1, T);
make_matched_teammate(?WORLD_COMPETE_TYPE_22, Team1 = #sign_up_team{id = RoleIds1, total_power = TotalPower1, match_count = MatchCount1}, [Team2 = #sign_up_team{id = RoleIds2, total_power = TotalPower2}|T]) when (length(RoleIds1) + length(RoleIds2)) =:= 2 ->
    Latitude = case MatchCount1 of
        0 -> 0.03;
        1 -> 0.05;
        2 -> 0.079;
        3 -> 0.108;
        4 -> 0.137;
        5 -> 0.166;
        6 -> 0.195;
        7 -> 0.224;
        8 -> 0.253;
        9 -> 0.282;
        10 -> 0.311;
        11 -> 0.34;
        12 -> 0.369;
        13 -> 0.398;
        14 -> 0.427;
        15 -> 0.456;
        16 -> 0.485;
        17 -> 0.514;
        18 -> 0.543;
        19 -> 0.572;
        20 -> 0.601;
        21 -> 0.63;
        22 -> 0.659;
        23 -> 0.688;
        24 -> 0.717;
        25 -> 0.746;
        26 -> 0.775;
        27 -> 0.804;
        28 -> 0.833;
        _ -> 0.85
    end,
    if
        TotalPower1 * (1 - Latitude) > TotalPower2 ->
            ?DEBUG("正在给[~w]匹配队友[~w]，战斗力相距过大(~w， ~w，战力浮动:~w)", [RoleIds1, RoleIds2, TotalPower1, TotalPower2, 1-Latitude]),
            make_matched_teammate(?WORLD_COMPETE_TYPE_22, Team1, T);
        TotalPower1 * (1 + Latitude) < TotalPower2 ->
            ?DEBUG("正在给[~w]匹配队友[~w]，战斗力相距过大(~w， ~w，战力浮动:~w)", [RoleIds1, RoleIds2, TotalPower1, TotalPower2, 1+Latitude]),
            make_matched_teammate(?WORLD_COMPETE_TYPE_22, Team1, T);
        true -> Team2
    end;
make_matched_teammate(Type, Team1, [_|T]) -> make_matched_teammate(Type, Team1, T).

%% 获取匹配的队友(3v3) -> [#sign_up_team{}] | undefined
%% 有3种可能：1找2、2找1、1找1找1
make_matched_teammate(?WORLD_COMPETE_TYPE_33, _Team1, [], _) -> undefined;
make_matched_teammate(?WORLD_COMPETE_TYPE_33, Team1, [Team1|T], Result) -> make_matched_teammate(?WORLD_COMPETE_TYPE_33, Team1, T, Result);
make_matched_teammate(?WORLD_COMPETE_TYPE_33, Team1 = #sign_up_team{id = RoleIds1, total_power = TotalPower1, match_count = MatchCount1}, [Team2 = #sign_up_team{id = RoleIds2, total_power = TotalPower2}|T], Result) when (length(RoleIds1) + length(RoleIds2)) =< 3 ->
    Latitude = case MatchCount1 of
        0 -> 0.03;
        1 -> 0.05;
        2 -> 0.079;
        3 -> 0.108;
        4 -> 0.137;
        5 -> 0.166;
        6 -> 0.195;
        7 -> 0.224;
        8 -> 0.253;
        9 -> 0.282;
        10 -> 0.311;
        11 -> 0.34;
        12 -> 0.369;
        13 -> 0.398;
        14 -> 0.427;
        15 -> 0.456;
        16 -> 0.485;
        17 -> 0.514;
        18 -> 0.543;
        19 -> 0.572;
        20 -> 0.601;
        21 -> 0.63;
        22 -> 0.659;
        23 -> 0.688;
        24 -> 0.717;
        25 -> 0.746;
        26 -> 0.775;
        27 -> 0.804;
        28 -> 0.833;
        29 -> 0.862;
        30 -> 0.891;
        _ -> 0.9
    end,
    TotalPower11 = case length(RoleIds1) > 1 of
        true -> round(TotalPower1 / length(RoleIds1));
        false -> TotalPower1
    end,
    TotalPower22 = case length(RoleIds2) > 1 of
        true -> round(TotalPower2 / length(RoleIds2));
        false -> TotalPower2
    end,
    if
        TotalPower11 * (1 - Latitude) > TotalPower22 ->
            ?DEBUG("正在给[~w]匹配队友[~w]，战斗力相距过大(~w， ~w，战力浮动:~w)", [RoleIds1, RoleIds2, TotalPower11, TotalPower22, 1-Latitude]),
            make_matched_teammate(?WORLD_COMPETE_TYPE_33, Team1, T, Result);
        TotalPower11 * (1 + Latitude) < TotalPower22 ->
            ?DEBUG("正在给[~w]匹配队友[~w]，战斗力相距过大(~w， ~w，战力浮动:~w)", [RoleIds1, RoleIds2, TotalPower11, TotalPower22, 1+Latitude]),
            make_matched_teammate(?WORLD_COMPETE_TYPE_33, Team1, T, Result);
        true ->
            ?DEBUG("成功给[~w]匹配到队友", [RoleIds1]),
            case length(RoleIds1) + length(RoleIds2) =:= 3 of
                true ->
                    case check_same_career_exceed(RoleIds1++RoleIds2) of
                        true ->
                            ?DEBUG("同职业过多，跳过"),
                            make_matched_teammate(?WORLD_COMPETE_TYPE_33, Team1, T, Result);
                        false ->
                            [Team2|Result]
                    end;
                false ->
                    NewTeam = simple_combine_teams([Team1, Team2]),
                    NewTeam1 = NewTeam#sign_up_team{match_count = MatchCount1},
                    make_matched_teammate(?WORLD_COMPETE_TYPE_33, NewTeam1, T, [Team2|Result])
            end
    end;
make_matched_teammate(Type, Team1, [_|T], Result) -> make_matched_teammate(Type, Team1, T, Result).

%% 判断是否同一个职业多于2个 -> true | false
check_same_career_exceed(RoleIds) when length(RoleIds) >=3 ->
    {Career1, Career2, Career3, Career4, Career5, _CareerOther} = check_same_career_exceed(RoleIds, 0, 0, 0, 0, 0, 0),
    if
        Career1>2 orelse Career2>2 orelse Career3>2 orelse Career4>2 orelse Career5>2 ->
            true;
        true -> false
    end;
check_same_career_exceed(_) -> false.
check_same_career_exceed([], Career1, Career2, Career3, Career4, Career5, CareerOther) -> {Career1, Career2, Career3, Career4, Career5, CareerOther};
check_same_career_exceed([RoleId|T], Career1, Career2, Career3, Career4, Career5, CareerOther) ->
    case get_signup_role_career(RoleId) of
        ?career_zhenwu -> check_same_career_exceed(T, Career1+1, Career2, Career3, Career4, Career5, CareerOther);
        ?career_cike -> check_same_career_exceed(T, Career1, Career2+1, Career3, Career4, Career5, CareerOther);
        ?career_xianzhe -> check_same_career_exceed(T, Career1, Career2, Career3+1, Career4, Career5, CareerOther);
        ?career_feiyu -> check_same_career_exceed(T, Career1, Career2, Career3, Career4+1, Career5, CareerOther);
        ?career_qishi -> check_same_career_exceed(T, Career1, Career2, Career3, Career4, Career5+1, CareerOther);
        _ -> check_same_career_exceed(T, Career1, Career2, Career3, Career4, Career5, CareerOther+1)
    end.

%% 把多个组合并 -> #sign_up_team{}
combine_teams(Teams) ->
    RoleIds = do_combine_team_roleids(Teams, []),
    TotalPower = calc_total_power(RoleIds),
    {SectionMark, SectionLev} = simple_calc_section_mark(RoleIds),
    #sign_up_team{id = RoleIds, total_power = TotalPower, section_mark = SectionMark, section_lev = SectionLev}.
do_combine_team_roleids([], Result) -> Result;
do_combine_team_roleids([#sign_up_team{id = RoleIds}|T], Result) ->
    do_combine_team_roleids(T, RoleIds++Result).

simple_combine_teams(Teams) ->
    RoleIds = do_simple_combine_team_roleids(Teams, []),
    TotalPower = simple_calc_total_power(RoleIds),
    #sign_up_team{id = RoleIds, total_power = TotalPower}.
do_simple_combine_team_roleids([], Result) -> Result;
do_simple_combine_team_roleids([#sign_up_team{id = RoleIds}|T], Result) ->
    do_simple_combine_team_roleids(T, RoleIds++Result).

%% 根据roleid重组队伍
rebuild_teams(RoleIds) ->
    TotalPower = calc_total_power(RoleIds),
    #sign_up_team{id = RoleIds, total_power = TotalPower}.

%% 拆分出原始组 -> {[要取消的角色id], [要继续排队匹配的人 #sign_up_role{}]}
%% CancelRoleId = {Rid, SrvId}  要取消匹配的角色id
%% RoleIds = [{Rid, SrvId}]  所在组的全部角色id
split_to_origin_teams(CancelRoleId = {_,_}, RoleIds)->
    %% 看看谁跟他原来是一组的，把他们合起来
    case ets:lookup(get(ets_name), CancelRoleId) of
        [#sign_up_role{origin_teammate_ids = OriginTeammateIds}] ->
            L1 = [CancelRoleId|OriginTeammateIds],
            L2 = RoleIds -- L1,
            case L2 of
                [] -> {RoleIds, []};
                [_|_] ->
                    case gen_origin_teams(L2) of
                        {ok, L3} -> {L1, L3};
                        false -> {RoleIds, []}
                    end
            end;
        _ -> {RoleIds, []}
    end;
split_to_origin_teams(#sign_up_team{id = RoleIds1}, #sign_up_team{id = RoleIds2}) ->
    RoleIds = RoleIds1 ++ RoleIds2,
    do_split_to_origin_teams(RoleIds, []).
do_split_to_origin_teams([], Result) -> {ok, Result};
do_split_to_origin_teams([RoleId|T], Result) ->
    case ets:lookup(get(ets_name), RoleId) of
        [#sign_up_role{origin_teammate_ids = OriginTeammateIds}] ->
            L = [RoleId|OriginTeammateIds],
            NewTeam = rebuild_teams(L),
            do_split_to_origin_teams(T -- L, [NewTeam|Result]);
        _ ->
            false
    end.

%% 根据RoleId生成 {ok, [#sign_up_role{}]} | false
gen_origin_teams(OriginTeammateIds) ->
    gen_origin_teams(OriginTeammateIds, []).
gen_origin_teams([], Result) -> {ok, Result};
gen_origin_teams([RoleId = {Rid, SrvId}|T], Result) ->
    case ets:lookup(get(ets_name), RoleId) of
        [SignupRole = #sign_up_role{}] ->
            gen_origin_teams(T, [SignupRole|Result]);
        _ ->
            ?ERR("根据[RoleId=~w,~s]无法获得SignupRole，无法组装原始报名状态", [Rid, SrvId]),
            false
    end.


%%------------------------------------------
%% 匹配对手
%%------------------------------------------
%% 获取报名队伍信息 -> #sign_up_team{} | undefined
%% （包括在匹配对手和匹配队友队列中的队伍）
get_signup_team_info(RoleId) ->
    case is_in_matching_queue(RoleId) of
        true ->
            case get(sign_up_teams) of
                Teams when is_list(Teams) ->
                    do_get_signup_team_info(RoleId, Teams);
                _ -> undefined
            end;
        false ->
            case is_in_teammate_queue(RoleId) of
                true ->
                    case get(teammate_queue) of
                        Teams when is_list(Teams) ->
                            do_get_signup_team_info(RoleId, Teams);
                        _ -> undefined
                    end;
                false -> undefined
            end
    end.
do_get_signup_team_info(_RoleId, []) -> undefined;
do_get_signup_team_info(RoleId, [Team = #sign_up_team{id = RoleIds}|T]) ->
    case lists:member(RoleId, RoleIds) of
        true -> Team;
        false -> do_get_signup_team_info(RoleId, T)
    end.

%% 是否能取消匹配
can_cancel_match([]) -> true;
can_cancel_match([RoleId|T]) ->
    case ets:lookup(get(ets_name), RoleId) of
        [#sign_up_role{status = ?WORLD_COMPETE_ROLE_STATUS_MATCHED}] -> {false, matched};
        _ -> can_cancel_match(T)
    end.

%% 是否已经在待匹配队列中
is_in_matching_queue(RoleIds) when is_list(RoleIds)->
    do_is_in_matching_queue(RoleIds);
is_in_matching_queue(RoleId) ->
    Teams = get(sign_up_teams),
    do_is_in_matching_queue(RoleId, Teams).
do_is_in_matching_queue([]) -> false;
do_is_in_matching_queue([RoleId|T]) ->
    case is_in_matching_queue(RoleId) of
        true -> true;
        false -> do_is_in_matching_queue(T)
    end.
do_is_in_matching_queue(_RoleId, []) -> false;
do_is_in_matching_queue(RoleId, [#sign_up_team{id = RoleIds}|T]) ->
    case lists:member(RoleId, RoleIds) of
        true -> true;
        false -> do_is_in_matching_queue(RoleId, T)
    end.

%% 队伍加入到待匹配队列中 -> true | {false, Reason}
add_team_to_matching_queue(SignupRoles) ->
    TotalPower = calc_total_power(SignupRoles),
    RoleIds = [RoleId || #sign_up_role{id = RoleId} <- SignupRoles],
    %% 防止重复
    remove_team_from_matching_queue(RoleIds),
    %% 修改统计信息
    update_signup_statistic(RoleIds),
    %% 组装报名队伍
    {SectionMark, SectionLev} = simple_calc_section_mark(SignupRoles),
    SignupTeam = #sign_up_team{id = RoleIds, total_power = TotalPower, section_mark = SectionMark, section_lev = SectionLev},
    %% 后来的队伍排在后面
    Teams = get(sign_up_teams),
    Teams1 = Teams ++ [SignupTeam],
    put(sign_up_teams, Teams1),
    %% ?DEBUG("[~w]报名成功", [SignupRoles]),
    lists:foreach(fun(SignupRole) ->
                ets:insert(get(ets_name), SignupRole#sign_up_role{status = ?WORLD_COMPETE_ROLE_STATUS_SIGNUP, map_pid = 0})
            end, SignupRoles).

%% 把队伍从待匹配队列中移除
remove_team_from_matching_queue(RoleIds) when is_list(RoleIds) ->
    lists:foreach(fun(RoleId) ->
                remove_team_from_matching_queue(RoleId)
        end, RoleIds);
remove_team_from_matching_queue(RoleId) ->
    Teams = get(sign_up_teams),
    Result = do_remove_team_from_matching_queue(RoleId, Teams, []),
    put(sign_up_teams, Result).
do_remove_team_from_matching_queue(_, [], Result) -> Result;
do_remove_team_from_matching_queue(RoleId, [Team = #sign_up_team{id = RoleIds}|T], Result) ->
    case lists:member(RoleId, RoleIds) of
        true -> Result ++ T;
        false -> do_remove_team_from_matching_queue(RoleId, T, [Team|Result])
    end.

%% 打印待匹配队列
print_matching_queue(SortedTeams = [_|_]) ->
    case get(matching_queue_print_flag) of
        true ->
            ?INFO("仙道会[Type=~w]待匹配队列信息=========================>", [get(world_compete_type)]),
            lists:foreach(fun(#sign_up_team{id = RoleIds, total_power=TotalPower, match_count = MatchCount}) ->
                        ?INFO("RoleIds=[~w], TotalPower=~w, MatchCount=~w", [RoleIds, TotalPower, MatchCount])
                end, SortedTeams),
            ?INFO("仙道会[Type=~w]待匹配队列信息<=========================\n\n", [get(world_compete_type)]);
        _ -> ignore
    end;
print_matching_queue(_) -> ignore.

%% 匹配队伍 -> {NotMatch, Match}
%% NotMatch = [#sign_up_team{}]
%% Match = [{#sign_up_team{}, #sign_up_team{}}]
match_teams(?WORLD_COMPETE_TYPE_11) ->
    Teams = get(sign_up_teams),
    %% 按总战斗力从大到小排序
    SortedTeams = lists:reverse(lists:keysort(#sign_up_team.section_mark, Teams)),
    print_matching_queue(SortedTeams),
    %% 取前面一部分的组进行主动匹配
    {Match, MatchList} = do_match_teams_by_section(SortedTeams, SortedTeams, [], []),
    %% 没匹配上的组匹配次数+1
    NotMatch = [Team#sign_up_team{match_count = MatchCount+1} || Team = #sign_up_team{match_count = MatchCount} <- (SortedTeams -- MatchList)],
    {NotMatch, Match};
match_teams(_) ->
    Teams = get(sign_up_teams),
    %% 按总战斗力从大到小排序
    SortedTeams = lists:reverse(lists:keysort(#sign_up_team.total_power, Teams)),
    print_matching_queue(SortedTeams),
    %% 取前面一部分的组进行主动匹配
    {Match, MatchList} = do_match_teams_by_power(SortedTeams, SortedTeams, [], []),
    %% 没匹配上的组匹配次数+1
    NotMatch = [Team#sign_up_team{match_count = MatchCount+1} || Team = #sign_up_team{match_count = MatchCount} <- (SortedTeams -- MatchList)],
    {NotMatch, Match}.

%% 根据战斗力匹配
%% Match = [{Team1, Team2}] 匹配到的组
%% MatchList = [#sign_up_team{}] 把匹配到的组展开成单个#sign_up_team{}的列表
do_match_teams_by_power([], _, Match, MatchList) -> {Match, MatchList};
%% do_match_teams_by_power([Team = #sign_up_team{match_count = MatchCount}], _, Match) -> {[Team#sign_up_team{match_count = MatchCount+1}|NotMatch], Match};
do_match_teams_by_power([Team1 = #sign_up_team{total_power = TotalPower1}|T], Ops, Match, MatchList) ->
    Direction = case util:rand(1, 100) < 50 of
        true -> ?WORLD_COMPETE_MATCH_DIRECTION_UP;
        false -> ?WORLD_COMPETE_MATCH_DIRECTION_DOWN
    end,
    case make_matched_op_by_power(Team1, Ops, Direction) of
        {Team2 = #sign_up_team{total_power = TotalPower2}, Latitude} ->
            %% 匹配上的就从主动匹配方去掉匹配到的2个组，同样，被匹配方也是同样操作
            {Latitude1, Latitude2} = if
                TotalPower1 > TotalPower2 -> {0, Latitude};
                TotalPower1 < TotalPower2 -> {Latitude, 0};
                true -> {0, 0}
            end,
            do_match_teams_by_power(T -- [Team1, Team2], Ops -- [Team1, Team2], [{Team1#sign_up_team{match_latitude = Latitude1}, Team2#sign_up_team{match_latitude = Latitude2}}|Match], [Team1, Team2|MatchList]);
        _ ->
            do_match_teams_by_power(T, Ops -- [Team1], Match, MatchList)
    end.


%% 根据战斗力获取匹配的对手 -> #sign_up_team{} | undefined
make_matched_op_by_power(_Team1, [], _Direction) -> undefined;
make_matched_op_by_power(Team1, [Team1|T], Direction) -> make_matched_op_by_power(Team1, T, Direction);
%% make_matched_op_by_power(#sign_up_team{match_count = MatchCount1}, _, _) when MatchCount1 =:= 0 -> undefined;    %% 考虑到中央服和节点的时间差问题，第一次匹配跳过
make_matched_op_by_power(Team1 = #sign_up_team{id = RoleIds1, total_power = TotalPower1, match_count = MatchCount1}, [Team2 = #sign_up_team{id = RoleIds2, total_power = TotalPower2, match_count = MatchCount2}|T], Direction) when (Direction =:= ?WORLD_COMPETE_MATCH_DIRECTION_UP) orelse (Direction =:= ?WORLD_COMPETE_MATCH_DIRECTION_DOWN andalso TotalPower1 > TotalPower2) ->
    Latitude = case MatchCount1 of
        0 -> 0.03;
        1 -> 0.05;
        2 -> 0.079;
        3 -> 0.108;
        4 -> 0.137;
        5 -> 0.166;
        6 -> 0.195;
        7 -> 0.224;
        8 -> 0.253;
        9 -> 0.282;
        10 -> 0.311;
        11 -> 0.34;
        12 -> 0.369;
        13 -> 0.398;
        14 -> 0.427;
        15 -> 0.456;
        16 -> 0.485;
        17 -> 0.514;
        18 -> 0.543;
        19 -> 0.572;
        20 -> 0.601;
        21 -> 0.63;
        22 -> 0.659;
        23 -> 0.688;
        24 -> 0.717;
        25 -> 0.746;
        26 -> 0.775;
        27 -> 0.804;
        _ -> 0.804
    end,
    IsFromSameServer = is_from_same_server(RoleIds1, RoleIds2),
    if
        TotalPower1 * (1 - Latitude) > TotalPower2 -> %% 战斗力相距不能超过一定幅度
            ?DEBUG("正在给[~w]匹配对手[~w]，战斗力相距过大(~w， ~w，战力浮动:~w)", [RoleIds1, RoleIds2, TotalPower1, TotalPower2, 1-Latitude]),
            make_matched_op_by_power(Team1, T, Direction);
        TotalPower1 * (1 + Latitude) < TotalPower2 -> %% 战斗力相距不能超过一定幅度
            ?DEBUG("正在给[~w]匹配对手[~w]，战斗力相距过大(~w， ~w，战力浮动:~w)", [RoleIds1, RoleIds2, TotalPower1, TotalPower2, 1+Latitude]),
            make_matched_op_by_power(Team1, T, Direction);
        (MatchCount1 =:= 1 orelse MatchCount2 =:= 1) andalso IsFromSameServer =:= true -> %% 头N次匹配不给同服匹配
            ?DEBUG("正在给[~w]匹配对手[~w]，该次匹配跳过同服对手", [RoleIds1, RoleIds2]),
            make_matched_op_by_power(Team1, T, Direction);
        true ->
            %% 跟踪打印一下匹配情况
            case get(match_print_flag) of
                true ->
                    LatitudeLow = case get(match_print_latitude) of
                        K when is_number(K) -> K;
                        _ -> 0.25
                    end,
                    case Latitude > LatitudeLow of
                        true -> ?INFO("Type=~w, [~w : power=~w, match_count=~w] 匹配上 [~w : power=~w, match_count=~w]，容错值=~w", [get(world_compete_type), RoleIds1, TotalPower1, MatchCount1, RoleIds2, TotalPower2, MatchCount2, Latitude]);
                        false -> ignore
                    end;
                _ -> ignore
            end,
            {Team2, Latitude}
    end;
make_matched_op_by_power(Team1, [_|T], Direction) -> make_matched_op_by_power(Team1, T, Direction).

%% 是否都来自于同一个服
is_from_same_server(RoleIds1, RoleIds2) ->
    SrvIds1 = [SrvId || {_, SrvId} <- RoleIds1],
    SrvIds2 = [SrvId || {_, SrvId} <- RoleIds2],
    length(SrvIds1 -- SrvIds2) =:= 0.

%% 通知匹配好的队伍进入战区
notify_prepare_combat([], _State) -> ok;
notify_prepare_combat([{TmpTeam1, TmpTeam2}|T], State = #state{type = WorldCompeteType}) ->
    case get_available_map() of
        {MapId, MapPid} ->
            {Team1 = #sign_up_team{id = RoleIds1}, Team2 = #sign_up_team{id = RoleIds2}} = balance_power(WorldCompeteType, TmpTeam1, TmpTeam2),
            {X1, Y1} = ?PREPARE_COMBAT_MAP_XY1,
            Ops1 = get_opponent_info(Team2),
            PreLilian1 = get_pre_lilian_info(Team1, Team2, State),
            PreSectionMark1 = get_pre_section_mark_info(Team1, Team2, State),
            TotalPower1 = simple_calc_total_power(RoleIds1),

            Ops2 = get_opponent_info(Team1),
            PreLilian2 = get_pre_lilian_info(Team2, Team1, State),
            {X2, Y2} = ?PREPARE_COMBAT_MAP_XY2,
            PreSectionMark2 = get_pre_section_mark_info(Team2, Team1, State),
            TotalPower2 = simple_calc_total_power(RoleIds2),

            %% ?DEBUG("PreLilian1=~w, PreSectionMark1=~w~nPreLilian2=~w, PreSectionMark2=~w", [PreLilian1, PreSectionMark1, PreLilian2, PreSectionMark2]),

            %% 缓存计算过的历练、段位积分，供战斗结束用
            lists:foreach(fun(RoleId) ->
                        put({gain_lilian, RoleId}, PreLilian1),
                        put({gain_section_mark, RoleId}, PreSectionMark1)
                    end, RoleIds1),
            lists:foreach(fun(RoleId) ->
                        put({gain_lilian, RoleId}, PreLilian2),
                        put({gain_section_mark, RoleId}, PreSectionMark2)
                    end, RoleIds2),

            %% 计算分组
            Group = calc_group({TotalPower1, length(RoleIds1)}, {TotalPower2, length(RoleIds2)}),
            {Group1, Group2} = case TotalPower1 >= TotalPower2 of
                true -> {Group, 0};
                false -> {0, Group}
            end,

            %% 计算阵法列表
            Lineups1 = calc_lineup(RoleIds1),
            Lineups2 = calc_lineup(RoleIds2),

            PrepareCombatTime = ?PREPARE_COMBAT_TIME,

            send_to_node(RoleIds1, world_compete_mgr, match_result_inform, [RoleIds1, {true, WorldCompeteType, PrepareCombatTime, MapId, X1, Y1, MapPid, Ops2, Ops1, PreLilian1, PreSectionMark1, TotalPower1, round(TotalPower1/10), Group1, Lineups1}]),
            
            send_to_node(RoleIds2, world_compete_mgr, match_result_inform, [RoleIds2, {true, WorldCompeteType, PrepareCombatTime, MapId, X2, Y2, MapPid, Ops1, Ops2, PreLilian2, PreSectionMark2, TotalPower2, round(TotalPower2/10), Group2, Lineups2}]),

            add_to_selected_lineup(RoleIds1, 0),
            add_to_selected_lineup(RoleIds2, 0),
            
            %% 从待匹配列表中移除，并放入到战区
            remove_team_from_matching_queue(RoleIds1),
            remove_team_from_matching_queue(RoleIds2),
            RoleIds = RoleIds1 ++ RoleIds2,
            add_to_match_map(RoleIds, MapPid),
            change_sign_up_role_status(RoleIds, ?WORLD_COMPETE_ROLE_STATUS_MATCHED),
            change_sign_up_role_map_info(RoleIds1, MapId, MapPid, X1, Y1),
            change_sign_up_role_map_info(RoleIds2, MapId, MapPid, X2, Y2),
            erlang:send_after(?PREPARE_COMBAT_TIME, self(), {start_combat, Team1#sign_up_team{lineups = Lineups1}, Team2#sign_up_team{lineups = Lineups2}, MapPid});
        undefined ->
            #sign_up_team{id = RoleIds1} = TmpTeam1,
            #sign_up_team{id = RoleIds2} = TmpTeam2,
            ?ERR("建立[~w, ~w]的战区失败", [RoleIds1, RoleIds2]),
            remove_team_from_matching_queue(RoleIds1),
            remove_team_from_matching_queue(RoleIds2),
            remove_sign_up_roles(RoleIds1 ++ RoleIds2),
            send_to_node(RoleIds1, world_compete_mgr, match_result_inform, [RoleIds1, {false, create_area_failed}]),
            send_to_node(RoleIds2, world_compete_mgr, match_result_inform, [RoleIds2, {false, create_area_failed}])
    end,
    notify_prepare_combat(T, State).

%% 计算阵法列表 -> [阵法ID :: integer()]
calc_lineup(RoleIds) ->
    calc_lineup(RoleIds, []).
calc_lineup([], Result) ->
    merge_lineup(Result);
calc_lineup([RoleId|T], Result) ->
    Lineups = get_signup_role_lineup(RoleId),
    calc_lineup(T, Lineups ++ Result).

merge_lineup(LineUpList) ->
    L = [{Id div 100, Id rem 100} || Id <- LineUpList],
    merge_lineup(L, []).

merge_lineup([], Lines) -> 
    [Id * 100 + Lev || {Id, Lev} <- Lines, Lev =/= 0];
merge_lineup([{Id, Lev} | T], Lines) ->
    {GetId, NewT} = split(Id, Lev, T),
    merge_lineup(NewT, [GetId | Lines]).
    
split(Id, Lev, T) ->
    split(Id, Lev, T, []).
split(Id, Lev, [], NewT) -> {{Id, Lev}, NewT};
split(Id, Lev, [{Id, L} | T], NewT) when L > Lev ->
    split(Id, L, T, NewT);
split(Id, Lev, [{Id, _} | T], NewT) ->
    split(Id, Lev, T, NewT);
split(Id, Lev, [NewId | T], NewT) ->
    split(Id, Lev, T, [NewId | NewT]).

%% 加入已选阵法列表
add_to_selected_lineup(RoleIds, LineupId) ->
    put(selected_lineup, [{RoleIds, LineupId}|get(selected_lineup)]).

%% 删除已选的阵法
delete_selected_lineup(RoleIds) ->
    L = get(selected_lineup),
    Result = delete_selected_lineup(RoleIds, L, []),
    put(selected_lineup, Result).
delete_selected_lineup(_RoleIds, [], Result) -> Result;
delete_selected_lineup(RoleIds, [{RoleIds, _}|T], Result) -> T ++ Result;
delete_selected_lineup(RoleIds, [Rec = {_, _}|T], Result) -> delete_selected_lineup(RoleIds, T, [Rec|Result]);
delete_selected_lineup(RoleIds, [_Rec|T], Result) ->
    ?ERR("delete_selected_lineup error:~w", [_Rec]),
    delete_selected_lineup(RoleIds, T, Result).


%% 获得最后一次选择的阵法 -> {RoleIds = [{Rid, SrvId}], 阵法ID :: integer()}
get_selected_lineup(RoleIds) when is_list(RoleIds) ->
    case lists:keyfind(RoleIds, 1, get(selected_lineup)) of
        {RoleIds, LineupId} -> {RoleIds, LineupId};
        _ -> {RoleIds, 0}
    end;
get_selected_lineup(RoleId) ->
    do_get_selected_lineup(get(selected_lineup), RoleId).
do_get_selected_lineup([], _) -> {[], 0};
do_get_selected_lineup([{RoleIds, LineupId}|T], RoleId) ->
    case lists:member(RoleId, RoleIds) of
        true -> {RoleIds, LineupId};
        false -> do_get_selected_lineup(T, RoleId)
    end.

%% 改变队伍阵法 -> {true, RoleIds, LineupId} | false
do_change_lineup(RoleId, LineupId) ->
    case get_selected_lineup(RoleId) of
        {RoleIds = [_|_], _} ->
            delete_selected_lineup(RoleIds),
            put(selected_lineup, [{RoleIds, LineupId}|get(selected_lineup)]),
            {true, RoleIds, LineupId};
        {[], 0} -> %% 已经开始战斗，不能选择阵法了
            false;
        _Err ->
            ?ERR("修改阵法失败：WorldCompeteType=~w, RoleId=~w, LineupId=~w, Err=~w", [get(world_compete_type), RoleId, LineupId, _Err]),
            false
    end.

%% 判断一下如果双方实力差距过大，则尝试交换一下双方队员，平衡下实力
balance_power(?WORLD_COMPETE_TYPE_11, Team1, Team2) -> {Team1, Team2};
balance_power(WorldCompeteType, Team1 = #sign_up_team{id = OldRoleIds1}, Team2 = #sign_up_team{id = OldRoleIds2}) ->
    OldLen1 = length(OldRoleIds1),
    OldLen2 = length(OldRoleIds2),
    case WorldCompeteType of
        ?WORLD_COMPETE_TYPE_22 ->
            case OldLen1 =:= 2 andalso OldLen2 =:= 2 of
                true -> ignore;
                false -> ?ERR("仙道会2v2平衡双方战斗力前人数不对:team1=~w, team2=~w", [OldLen1, OldLen2])
            end;
        ?WORLD_COMPETE_TYPE_33 ->
            case OldLen1 =:= 3 andalso OldLen2 =:= 3 of
                true -> ignore;
                false -> ?ERR("仙道会3v3平衡双方战斗力前人数不对:team1=~w, team2=~w", [OldLen1, OldLen2])
            end;
        _ -> ignore
    end,
    case split_to_origin_teams(Team1, Team2) of
        {ok, OriginTeams} ->
            [OriginTeam1 = #sign_up_team{id = RoleIds1}|LeftTeams]= lists:reverse(lists:keysort(#sign_up_team.total_power, OriginTeams)),
            LeftTeams1 = lists:reverse(LeftTeams),
            case do_balance_power(WorldCompeteType, LeftTeams1, {[OriginTeam1], length(RoleIds1)}, {[], 0}) of
                R = {_, _} -> R;
                _ -> {Team1, Team2}
            end;
        false ->
            {Team1, Team2}
    end.
do_balance_power(?WORLD_COMPETE_TYPE_33, [], {Side1, _}, {Side2, _}) ->
    %% 检查是否有一边是三个职业一样，是的话就放弃这次调整结果
    Team1 = #sign_up_team{id = RoleIds1} = combine_teams(Side1),
    Team2 = #sign_up_team{id = RoleIds2} = combine_teams(Side2),
    case check_same_career_exceed(RoleIds1) =:= true orelse check_same_career_exceed(RoleIds2) =:= true of
        true -> false;
        false ->
            Len1 = length(RoleIds1),
            Len2 = length(RoleIds2),
            case Len1 =:= Len2 of
                true ->
                    {Team1, Team2};
                false -> false
            end
    end;
do_balance_power(_, [], {Side1, _}, {Side2, _}) ->
    {combine_teams(Side1), combine_teams(Side2)};
do_balance_power(WorldCompeteType = ?WORLD_COMPETE_TYPE_22, [Team = #sign_up_team{id = RoleIds}|T], {Side1, Num1}, {Side2, Num2}) ->
    MaxNum = 2,
    Len = length(RoleIds),
    if
        Num1 < MaxNum andalso Len + Num1 =< MaxNum ->
            do_balance_power(WorldCompeteType, T, {[Team|Side1], Num1+Len}, {Side2, Num2});
        true ->
            do_balance_power(WorldCompeteType, T, {Side1, Num1}, {[Team|Side2], Num2+Len})
    end;
do_balance_power(WorldCompeteType = ?WORLD_COMPETE_TYPE_33, [Team = #sign_up_team{id = RoleIds}|T], {Side1, Num1}, {Side2, Num2}) ->
    MaxNum = 3,
    Len = length(RoleIds),
    if
        Num1 < MaxNum andalso Len + Num1 =< MaxNum ->
            do_balance_power(WorldCompeteType, T, {[Team|Side1], Num1+Len}, {Side2, Num2});
        true ->
            do_balance_power(WorldCompeteType, T, {Side1, Num1}, {[Team|Side2], Num2+Len})
    end.


%% 获取对手信息 -> {Rid, SrvId, Name, Career, FC, PetPower, SectionLev, SectionMark}
get_opponent_info(#sign_up_team{id = RoleIds}) ->
    get_opponent_info(RoleIds, []).
get_opponent_info([], Result) -> Result;
get_opponent_info([RoleId|T], Result) ->
    case ets:lookup(get(ets_name), RoleId) of
        [#sign_up_role{id = {Id, SrvId}, name = Name, career = Career, attr = #attr{fight_capacity = FC}, pet_power = PetPower, section_lev = SectionLev, section_mark = SectionMark}] ->
            get_opponent_info(T, [{Id, SrvId, Name, Career, FC, PetPower, SectionLev, SectionMark}|Result]);
        _ -> get_opponent_info(T, Result)
    end.

%% 获取预计能获得的历练值 -> [{Result, Lilian, AddtLilian}]
get_pre_lilian_info(#sign_up_team{id = RoleIds, match_latitude = Latitude}, #sign_up_team{id = OpRoleIds}, #state{type = WorldCompeteType = ?WORLD_COMPETE_TYPE_11}) ->
    %% Ratio = 2,
    Ratio = 1,
    {L0_lilian, L0_addt_lilian} = calc_lilian_reward(WorldCompeteType, ?c_world_compete_result_draw, RoleIds, OpRoleIds, 0),
    L0 = {?c_world_compete_result_draw, round(L0_lilian/Ratio), round(L0_addt_lilian/Ratio)},
    
    {L1_lilian, L1_addt_lilian} = calc_lilian_reward(WorldCompeteType, ?c_world_compete_result_ko_perfect, RoleIds, OpRoleIds, 0),
    L1 = {?c_world_compete_result_ko_perfect, round(L1_lilian/Ratio), round(L1_addt_lilian/Ratio)},
    
    {L2_lilian, L2_addt_lilian} = calc_lilian_reward(WorldCompeteType, ?c_world_compete_result_ko, RoleIds, OpRoleIds, 0),
    L2 = {?c_world_compete_result_ko, round(L2_lilian/Ratio), round(L2_addt_lilian/Ratio)},

    {L3_lilian, L3_addt_lilian} = calc_lilian_reward(WorldCompeteType, ?c_world_compete_result_loss_perfect, RoleIds, OpRoleIds, Latitude),
    L3 = {?c_world_compete_result_loss_perfect, round(L3_lilian/Ratio), round(L3_addt_lilian/Ratio)},

    {L4_lilian, L4_addt_lilian} = calc_lilian_reward(WorldCompeteType, ?c_world_compete_result_loss, RoleIds, OpRoleIds, Latitude),
    L4 = {?c_world_compete_result_loss, round(L4_lilian/Ratio), round(L4_addt_lilian/Ratio)},
    [L0, L1, L2, L3, L4];
get_pre_lilian_info(#sign_up_team{id = RoleIds, match_latitude = Latitude}, #sign_up_team{id = OpRoleIds}, #state{type = WorldCompeteType}) ->
    Ratio = 1,
    {L0_lilian, L0_addt_lilian} = calc_lilian_reward(WorldCompeteType, ?c_world_compete_result_draw, RoleIds, OpRoleIds, 0),
    L0 = {?c_world_compete_result_draw, round(L0_lilian/Ratio), round(L0_addt_lilian/Ratio)},
    
    {L1_lilian, L1_addt_lilian} = calc_lilian_reward(WorldCompeteType, ?c_world_compete_result_ko_perfect, RoleIds, OpRoleIds, 0),
    L1 = {?c_world_compete_result_ko_perfect, round(L1_lilian/Ratio), round(L1_addt_lilian/Ratio)},
    
    {L2_lilian, L2_addt_lilian} = calc_lilian_reward(WorldCompeteType, ?c_world_compete_result_ko, RoleIds, OpRoleIds, 0),
    L2 = {?c_world_compete_result_ko, round(L2_lilian/Ratio), round(L2_addt_lilian/Ratio)},

    {L3_lilian, L3_addt_lilian} = calc_lilian_reward(WorldCompeteType, ?c_world_compete_result_loss_perfect, RoleIds, OpRoleIds, Latitude),
    L3 = {?c_world_compete_result_loss_perfect, round(L3_lilian/Ratio), round(L3_addt_lilian/Ratio)},

    {L4_lilian, L4_addt_lilian} = calc_lilian_reward(WorldCompeteType, ?c_world_compete_result_loss, RoleIds, OpRoleIds, Latitude),
    L4 = {?c_world_compete_result_loss, round(L4_lilian/Ratio), round(L4_addt_lilian/Ratio)},
    [L0, L1, L2, L3, L4].


%% 创建战斗区域地图 -> {ok, {MapId, MapPid}} | false
create_map() ->
    case map_mgr:create(?PREPARE_COMBAT_MAP_BASE_ID) of
        {false, Reason} ->
            ?ERR("创建仙道会战斗区域地图[MapBaseId=~w]失败: ~s", [?PREPARE_COMBAT_MAP_BASE_ID, Reason]),
            false;
        {ok, MapPid, MapId} ->
            {ok, {MapId, MapPid}}
    end.

%% 创建地图池
create_map_pool() ->
    Maps = do_create_map_pool([], 2000),
    put(maps, Maps).
do_create_map_pool(Maps, 0) -> Maps;
do_create_map_pool(Maps, N) ->
    case create_map() of
        false -> do_create_map_pool(Maps, N-1);
        {ok, {MapId, MapPid}} ->
            R = {MapId, MapPid, true},
            do_create_map_pool([R|Maps], N-1)
    end.

%% 增补一个地图到地图池，并返回它 -> {MapId, MapPid} | undefined
map_pool_increase() ->
    case create_map() of
        false -> undefined;
        {ok, R1 = {MapId, MapPid}} ->
            R2 = {MapId, MapPid, false},
            case get(maps) of
                Maps = [_|_] ->
                    put(maps, [R2|Maps]);
                _ ->
                    put(maps, [R2])
            end,
            R1
    end.

%% 从地图池中取出一个可以用的地图，如果没有可用则创建一个新地图
get_available_map() ->
    case get(maps) of
        Maps = [_|_] ->
            do_get_available_map(Maps, []);
        _ ->
            map_pool_increase()
    end.
do_get_available_map([], _) -> map_pool_increase();
do_get_available_map([{MapId, MapPid, true}|T], Rest) ->
    put(maps, Rest ++ [{MapId, MapPid, false}|T]),
    {MapId, MapPid};
do_get_available_map([R|T], Rest) -> do_get_available_map(T, [R|Rest]).

%% 回收地图
recycle_map(MapPid) when is_pid(MapPid) ->
    case get(maps) of
        Maps = [_|_] -> do_recycle_map(MapPid, [], Maps);
        _ -> ignore
    end;
recycle_map(_) -> ok.
do_recycle_map(_, _, []) -> ok;
do_recycle_map(MapPid, _, [{_, MapPid, true}|_T]) -> ok;
do_recycle_map(MapPid, Rest, [{MapId, MapPid, false}|T]) ->
    %% 这个地方可能会因为map的清除操作比分配的速度慢而导致让后来进的人被清除了，所以采取callback的形式
    put(maps, Rest ++ T),
    map:reset(MapPid, self(), {reset_map_callback, MapId, MapPid});
do_recycle_map(MapPid, Rest, [R|T]) ->
    do_recycle_map(MapPid, [R|Rest], T).


%% 记录匹配的2个组和地图信息，方便战斗结束时销毁地图进程
%% RoleIds = [{Rid, SrvId}]
add_to_match_map(RoleIds, MapPid) ->
    case get(match_maps) of
        [_|_] ->
            remove_from_match_map(RoleIds),
            L = get(match_maps),
            put(match_maps, [{RoleIds, MapPid}|L]);
        _ ->
            put(match_maps, [{RoleIds, MapPid}])
    end.

%% 是否在地图中
is_in_match_map(RoleId) ->
    case get(match_maps) of
        L = [_|_] ->
            do_is_in_match_map(RoleId, L);
        _ -> false
    end.
do_is_in_match_map(_RoleId, []) -> false;
do_is_in_match_map(RoleId, [{RoleIds, MapPid}|T]) ->
    case lists:member(RoleId, RoleIds) of
        true ->
            case is_pid(MapPid) andalso is_process_alive(MapPid) of
                true ->
                    case get_sign_up_role_map_info(RoleId) of
                        {MapId, MapPid, X, Y} -> {true, MapId, X, Y};
                        _ -> false
                    end;
                false -> false
            end;
        false -> do_is_in_match_map(RoleId, T)
    end.


%% 删除匹配地图信息
remove_from_match_map(RoleIds) ->
    case get(match_maps) of
        L = [_|_] ->
            lists:foreach(fun(RoleId) ->
                        L1 = do_remove_from_match_map(RoleId, L, []),
                        put(match_maps, L1)
                end, RoleIds);
        _ -> []
    end.
do_remove_from_match_map(_, [], Result) -> Result;
do_remove_from_match_map(RoleId, [R = {RoleIds, _}|T], Result) ->
    case lists:member(RoleId, RoleIds) of
        true -> Result ++ T;
        false -> do_remove_from_match_map(RoleId, T, [R|Result])
    end.


%% 销毁匹配的地图
destroy_match_map(RoleIds) ->
    case get(match_maps) of
        L = [_|_] ->
            lists:foreach(fun(RoleId) ->
                        do_destroy_match_map(RoleId, L)
                end, RoleIds);
        _ -> ok
    end.
do_destroy_match_map(_RoleId, []) -> ok;
do_destroy_match_map(RoleId, [{RoleIds, MapPid}|T]) ->
    case lists:member(RoleId, RoleIds) of
        true ->
            %% ?DEBUG("[~w]所在的战区地图[pid=~w]销毁", [RoleIds, MapPid]),
            %% case is_pid(MapPid) of
            %%     true -> map:stop(MapPid);
            %%     false -> ignore
            %% end;
            ?DEBUG("[~w]所在的战区地图[pid=~w]回收", [RoleId, MapPid]),
            recycle_map(MapPid);
        false ->
            do_destroy_match_map(RoleId, T)
    end.

%% 销毁所有地图
destroy_all_match_maps() ->
    case get(match_maps) of
        L = [_|_] ->
            do_destroy_all_match_maps(L);
        _ -> ignore
    end.
do_destroy_all_match_maps([]) -> 
    ok;
    %%put(match_maps, []);
do_destroy_all_match_maps([{_, MapPid}|T]) when is_pid(MapPid) ->
    %% map:stop(MapPid),
    recycle_map(MapPid),
    do_destroy_all_match_maps(T);
do_destroy_all_match_maps([_|T]) -> do_destroy_all_match_maps(T).



%%-----------------------------------------
%% 战斗相关
%%-----------------------------------------
%% 发起战斗
start_combat(Team1 = #sign_up_team{id = RoleIds1}, Team2 = #sign_up_team{id = RoleIds2}, MapPid, RetryNum, WorldCompetePid) ->
    {L1, Fails1} = roles_to_fighters(RoleIds1, MapPid),
    {L2, Fails2} = roles_to_fighters(RoleIds2, MapPid),
    RoleIds = RoleIds1 ++ RoleIds2,
    SuccessRoleIds = [{Rid, SrvId} || #converted_fighter{fighter = #fighter{rid = Rid, srv_id = SrvId}} <- (L1 ++ L2)],
    FailedRoleIds = RoleIds -- SuccessRoleIds,
    FailedReasons = Fails1 ++ Fails2,
    if
        length(L1) > 0 andalso length(L2) > 0 ->
            case combat:start(?combat_type_c_world_compete, self(), L1, L2, [{world_compete_combat, {WorldCompetePid, [Team1, Team2, MapPid, RetryNum]}}]) of
                {ok, _CombatPid} ->
                    case length(FailedRoleIds) > 0 of
                        true ->
                            WorldCompetePid ! {start_combat_result, failed1, SuccessRoleIds, FailedRoleIds, FailedReasons};
                        false -> ignore
                    end;
                _Why ->
                    WorldCompetePid ! {start_combat_result, failed2, _Why, RoleIds1, RoleIds2}
            end;
        true ->
            WorldCompetePid ! {start_combat_result, failed3, L1, L2, RoleIds1, RoleIds2, FailedRoleIds, FailedReasons}
    end.

%% 转换角色成参战者 -> {[#converted_fighter{}], [{RoleId, FailedReason}]}
%% FailedReason = event|timeout|offline|term()
%% RoleIds = [{Rid, SrvId}]
roles_to_fighters(RoleIds, MapPid) ->
    %% 因为偶尔会timeout，所以加入多次尝试
    RoleIds1 = [{RoleId, 0} || RoleId <- RoleIds],
    roles_to_fighters(RoleIds1, MapPid, [], []).
roles_to_fighters([], _MapPid, Result, Fails) -> {Result, Fails};
roles_to_fighters([{RoleId = {Rid, SrvId}, TryNum}|T], MapPid, Result, Fails) when TryNum < 3 ->
    case catch c_proxy:role_lookup(by_id, RoleId, to_fighter) of
        {ok, _, #converted_fighter{fighter_ext = #fighter_ext_role{event = Event}}} when (Event =/= ?event_c_world_compete_11 andalso Event =/= ?event_c_world_compete_22 andalso Event =/= ?event_c_world_compete_33) ->
            ?ERR("[~w, ~s]的当前事件状态不正确[Event=~w]，无法加入仙道会战斗", [Rid, SrvId, Event]),
            roles_to_fighters(T, MapPid, Result, [{RoleId, event}|Fails]);
        {ok, _, CF = #converted_fighter{}} ->
            roles_to_fighters(T, MapPid, [CF|Result], Fails);
        {error, timeout} -> %% 超时，重试3次
            ?INFO("查找并转换跨服角色[~w, ~s]超时，正在重试第~w次", [Rid, SrvId, TryNum+1]),
            roles_to_fighters([{RoleId, TryNum+1}|T], MapPid, Result, Fails);
        {error, not_found} -> %% 掉线
            ?INFO("[~w, ~s]掉线，查找不到了", [Rid, SrvId]),
            roles_to_fighters(T, MapPid, Result, [{RoleId, offline}|Fails]);
        _Err -> 
            ?ERR("查找并转换跨服角色[~w, ~s]出错:~w", [Rid, SrvId, _Err]),
            roles_to_fighters(T, MapPid, Result, [{RoleId, _Err}|Fails])
    end;
roles_to_fighters([{RoleId = {Rid, SrvId}, _TryNum}|T], MapPid, Result, Fails) ->
    case catch c_proxy:role_lookup(by_id, RoleId, to_fighter) of
        {ok, _, #converted_fighter{fighter_ext = #fighter_ext_role{event = Event}}} when (Event =/= ?event_c_world_compete_11 andalso Event =/= ?event_c_world_compete_22 andalso Event =/= ?event_c_world_compete_33) ->
            ?ERR("[~w, ~s]的当前事件状态不正确[Event=~w]，无法加入仙道会战斗", [Rid, SrvId, Event]),
            roles_to_fighters(T, MapPid, Result, [{RoleId, event}|Fails]);
        {ok, _, CF = #converted_fighter{}} ->
            roles_to_fighters(T, MapPid, [CF|Result], Fails);
        {error, timeout} -> %% 超时
            ?INFO("查找并转换跨服角色[~w, ~s]还是超时", [Rid, SrvId]),
            roles_to_fighters(T, MapPid, Result, [{RoleId, timeout}|Fails]);
        {error, not_found} -> %% 掉线
            ?INFO("[~w, ~s]掉线，查找不到了", [Rid, SrvId]),
            roles_to_fighters(T, MapPid, Result, [{RoleId, offline}|Fails]);
        _Err -> 
            ?ERR("查找并转换跨服角色[~w, ~s]出错:~w", [Rid, SrvId, _Err]),
            roles_to_fighters(T, MapPid, Result, [{RoleId, _Err}|Fails])
    end.

%% 战斗结束处理
do_combat_over(Winner, Loser, TimerPid, State) when is_list(Winner) andalso is_list(Loser) ->
    WinnerCombatResult = calc_winner_combat_result(Winner),
    LoserCombatResult = op_combat_result(WinnerCombatResult),
    WinnerAveragePower = calc_average_power(Winner, 0, 0),
    LoserAveragePower = calc_average_power(Loser, 0, 0),
    TopPower = get_top_power(Loser),
    deal_combat_result(WinnerCombatResult, Winner, [WinnerAveragePower, TimerPid, State, TopPower]),
    deal_combat_result(LoserCombatResult, Loser, [LoserAveragePower, TimerPid, State, 0]),
    big_win_cast(Winner, Loser),
    RoleIds = [{Rid, SrvId} || #fighter{rid = Rid, srv_id = SrvId} <- (Winner++Loser)],
    remove_team_from_matching_queue(RoleIds),
    erlang:send_after(2000, self(), {destroy_match_map, RoleIds});
do_combat_over(Winner, Loser, _TimerPid, _State) ->
    ?ERR("处理战斗结果时，参战者信息不正确：~w, ~w", [Winner, Loser]).

%% 超级队伍完胜之后全服广播
big_win_cast(Winner, Loser) when is_list(Winner) andalso is_list(Loser) ->
    case need_big_win_cast(Winner) of
        true ->
            WinnerNames = [notice:role_to_msg({Rid, SrvId, Name}) || #fighter{rid = Rid, srv_id = SrvId, name = Name} <- Winner],
            LoserNames = [notice:role_to_msg({Rid, SrvId, Name}) || #fighter{rid = Rid, srv_id = SrvId, name = Name} <- Loser],
            c_mirror_group:cast(all, world_compete_mgr, big_win_cast, [WinnerNames, LoserNames]);
        false -> ignore
    end;
big_win_cast(_, _) -> ignore.
need_big_win_cast([]) -> true;
need_big_win_cast([#fighter{is_die = ?true}|_T]) -> false;
need_big_win_cast([#fighter{rid = Rid, srv_id = SrvId, is_die = ?false}|T]) ->
    RoleId = {Rid, SrvId},
    case get_signup_role_power(RoleId) of
        FC when FC >= 50000 ->
            need_big_win_cast(T);
        _ -> false
    end.
        

%% 计算战斗结果
calc_winner_combat_result(Winner = [_|_]) ->
    calc_winner_combat_result(Winner, ?c_world_compete_result_ko_perfect);
calc_winner_combat_result(_) -> ?c_world_compete_result_draw.
calc_winner_combat_result([], Result) -> Result;
calc_winner_combat_result([#fighter{is_die = IsDie}|T], Result) ->
    case IsDie of
        ?true -> ?c_world_compete_result_ko;
        _ -> calc_winner_combat_result(T, Result)
    end.

op_combat_result(?c_world_compete_result_ko_perfect) -> ?c_world_compete_result_loss_perfect;
op_combat_result(?c_world_compete_result_ko) -> ?c_world_compete_result_loss;
op_combat_result(?c_world_compete_result_loss_perfect) -> ?c_world_compete_result_ko_perfect;
op_combat_result(?c_world_compete_result_loss) -> ?c_world_compete_result_ko;
op_combat_result(_) -> ?c_world_compete_result_draw.


%% 计算平均战斗力
calc_average_power([], Result, Count) -> 
    case Count>0 of
        true -> round(Result/Count);
        false -> 0
    end;
calc_average_power([#fighter{attr = #attr{fight_capacity = FC}}|T], Result, Count) ->
    calc_average_power(T, Result + FC, Count+1);
calc_average_power([#converted_fighter{fighter = #fighter{attr = #attr{fight_capacity = FC}}}|T], Result, Count) ->
    calc_average_power(T, Result + FC, Count+1);
calc_average_power([#converted_fighter{fighter = #fighter{rid = Rid, srv_id = SrvId, name = Name, attr = Attr}}|T], Result, Count) ->
    ?ERR("计算平均战斗力时参战者数据错误:[~w, ~s, ~s], attr=~w", [Rid, SrvId, Name, Attr]),
    calc_average_power(T, Result, Count);
calc_average_power([RoleId = {_, _}|T], Result, Count) ->
    case ets:lookup(get(ets_name), RoleId) of
        [#sign_up_role{attr = #attr{fight_capacity = FC}}] ->
            calc_average_power(T, Result + FC, Count+1);
        _ -> calc_average_power(T, Result, Count)
    end;
calc_average_power([_R|T], Result, Count) ->
    ?ERR("计算平均战斗力时输入了错误的参数:~w", [_R]),
    calc_average_power(T, Result, Count).

%% 获取队伍中最高战力 -> integer()
get_top_power(FighterList) ->
    Powers = [FC || #fighter{attr = #attr{fight_capacity = FC}} <- FighterList],
    case Powers of
        [_|_] -> lists:max(Powers);
        _ -> 0
    end.

%% 计算报名队伍的总战斗力
%% L = [#sign_up_role{}] | [RoleId = {_, _}]
calc_total_power(L) ->
    calc_total_power(L, 0).
calc_total_power([], TotalPower) -> TotalPower;
calc_total_power([#sign_up_role{id = RoleId, attr = #attr{fight_capacity = FC}}|T], TotalPower) ->
    %% 报名时算的总战斗力必须要根据公式来计算
    Power = case get(world_compete_type) of
        ?WORLD_COMPETE_TYPE_11 ->
            round(FC + get_adjust_power(RoleId, FC));
        ?WORLD_COMPETE_TYPE_22 ->
            round(math:pow((FC + get_adjust_power(RoleId, FC))/500, 3));
        _ ->
            round(math:pow((FC + get_adjust_power(RoleId, FC))/500, 3))
    end,
    calc_total_power(T, Power + TotalPower);
calc_total_power([RoleId = {_,_}|T], TotalPower) ->
    %% 报名时算的总战斗力必须要根据公式来计算
    case ets:lookup(get(ets_name), RoleId) of
        [#sign_up_role{attr = #attr{fight_capacity = FC}}] ->
            Power = case get(world_compete_type) of
                ?WORLD_COMPETE_TYPE_11 ->
                    round(FC + get_adjust_power(RoleId, FC));
                _ ->
                    round(math:pow((FC + get_adjust_power(RoleId, FC))/500, 3))
            end,
            calc_total_power(T, Power + TotalPower);
        _ ->
            ?ERR("计算总战斗力时在ets找不到报名角色信息"),
            calc_total_power(T, TotalPower)
    end;
calc_total_power([_R|T], TotalPower) ->
    ?ERR("计算总战斗力时输入了错误的参数:~w", [_R]),
    calc_total_power(T, TotalPower).

%% 计算报名队伍的总战斗力（简单相加）
simple_calc_total_power(RoleIds) ->
    simple_calc_total_power(RoleIds, 0).
simple_calc_total_power([], TotalPower) -> TotalPower;
simple_calc_total_power([RoleId = {_, _}|T], TotalPower) ->
    %% 其他情况下就只简单计算战斗力之和
    case ets:lookup(get(ets_name), RoleId) of
        [#sign_up_role{attr = #attr{fight_capacity = FC}}] ->
            simple_calc_total_power(T, TotalPower + FC);
        _ -> simple_calc_total_power(T, TotalPower)
    end;
simple_calc_total_power([_R|T], TotalPower) ->
    ?ERR("简单计算总战斗力时输入了错误的参数:~w", [_R]),
    simple_calc_total_power(T, TotalPower).


%% 战斗结束时计算奖励
calc_combat_over_rewards(WorldCompeteType, CombatResult, #fighter{name = _Name, rid = Rid, srv_id = SrvId, lev = Lev}, Args) ->
    Rewards = do_calc_combat_over_rewards(WorldCompeteType, CombatResult, [{Rid, SrvId}, Lev|Args]),
    %%?DEBUG("[~s]combat over rewards=~w", [_Name, Rewards]),
    %%calc_rewards_by_type(Rewards, WorldCompeteType);
    Rewards;
calc_combat_over_rewards(WorldCompeteType, CombatResult, RoleId = {Rid, SrvId}, Args) ->
    case ets:lookup(get(ets_name), RoleId) of
        [#sign_up_role{lev = Lev}] ->
            Rewards = do_calc_combat_over_rewards(WorldCompeteType, CombatResult, [RoleId, Lev|Args]),
            Rewards;%%calc_rewards_by_type(Rewards, WorldCompeteType);
        _ -> 
            ?ERR("计算[~w, ~s]的仙道会奖励时在ets中找不到报名信息", [Rid, SrvId]),
            []
    end.

do_calc_combat_over_rewards(_WorldCompeteType, ?c_world_compete_result_ko_perfect, [RoleId, Lev, _AveragePower, _Latitude, _LilianRatio]) ->
    {Lilian, AddtLilian} = get_cached_lilian(RoleId, ?c_world_compete_result_ko_perfect),
    [{exp, Lev * Lev * 4 * 1}, {lilian, Lilian}, {addt_lilian, AddtLilian}, {section_mark, get_cached_section_mark(RoleId, ?c_world_compete_result_ko_perfect)}];
do_calc_combat_over_rewards(_WorldCompeteType, ?c_world_compete_result_ko, [RoleId, Lev, _AveragePower, _Latitude, _LilianRatio]) ->
    {Lilian, AddtLilian} = get_cached_lilian(RoleId, ?c_world_compete_result_ko),
    [{exp, round(Lev * Lev * 4 * 0.85)}, {lilian, Lilian}, {addt_lilian, AddtLilian}, {section_mark, get_cached_section_mark(RoleId, ?c_world_compete_result_ko)}];
do_calc_combat_over_rewards(_WorldCompeteType, ?c_world_compete_result_loss_perfect, [RoleId, Lev, _AveragePower, _Latitude, _LilianRatio]) ->
    {Lilian, AddtLilian} = get_cached_lilian(RoleId, ?c_world_compete_result_loss_perfect),
    [{exp, round(Lev * Lev * 4 * 0.5)}, {lilian, Lilian}, {addt_lilian, AddtLilian}, {section_mark, get_cached_section_mark(RoleId, ?c_world_compete_result_loss_perfect)}];
do_calc_combat_over_rewards(_WorldCompeteType, ?c_world_compete_result_loss, [RoleId, Lev, _AveragePower, _Latitude, _LilianRatio]) ->
    {Lilian, AddtLilian} = get_cached_lilian(RoleId, ?c_world_compete_result_loss),
    [{exp, round(Lev * Lev * 4 * 0.65)}, {lilian, Lilian}, {addt_lilian, AddtLilian}, {section_mark, get_cached_section_mark(RoleId, ?c_world_compete_result_loss)}];
do_calc_combat_over_rewards(_WorldCompeteType, _, [RoleId, Lev, _AveragePower, _Latitude, _LilianRatio]) ->
    {Lilian, AddtLilian} = get_cached_lilian(RoleId, ?c_world_compete_result_draw),
    [{exp, Lev * Lev * 4 * 0.75}, {lilian, Lilian}, {addt_lilian, AddtLilian}, {section_mark, get_cached_section_mark(RoleId, ?c_world_compete_result_draw)}].

%% 计算历练奖励 -> {总历练，附加历练}
calc_lilian_reward(?WORLD_COMPETE_TYPE_11, CombatResult, [RoleId = {Rid, SrvId}|_], [OpRoleId = {OpRid, OpSrvId}|_], _Latitude) ->
    SectionData = get_section_data(RoleId),
    OpSectionData = get_section_data(OpRoleId),
    case SectionData=/=undefined andalso OpSectionData=/=undefined of
        true ->
            Lev = c_world_compete_section_data:section_mark_to_section_lev((SectionData#world_compete_section_data.mark + OpSectionData#world_compete_section_data.mark)/2),
            BaseLilian = case c_world_compete_section_data:get(Lev) of
                #world_compete_section_data{base_lilian = A} -> A;
                _ -> 0
            end,
            Lilian = case CombatResult of
                ?c_world_compete_result_ko_perfect -> BaseLilian * 1.2;
                ?c_world_compete_result_ko -> BaseLilian * 1.1;
                ?c_world_compete_result_loss_perfect -> BaseLilian * 0.8;
                ?c_world_compete_result_loss -> BaseLilian * 0.9;
                _ -> BaseLilian
            end,
            Lilian1 = round(Lilian * get_gain_lilian_ratio()),
            %% ?DEBUG("calc_lilian_reward:Lev=~w, BaseLilian=~w, CombatResult=~w, Lilian=~w", [Lev, BaseLilian, CombatResult, Lilian1]),
            {Lilian1, 0};
        _ -> 
            ?ERR("计算[~w, ~s]与对手[~w, ~s]的仙道会奖励时在ets中找不到报名信息或段位信息[~w][~w]", [Rid, SrvId, OpRid, OpSrvId, SectionData, OpSectionData]),
            {0, 0}
    end;
calc_lilian_reward(WorldCompeteType, CombatResult, RoleIds, _OpRoleIds, Latitude) ->
    AveragePower = calc_average_power(RoleIds, 0, 0),
    do_calc_lilian_reward(WorldCompeteType, CombatResult, AveragePower, Latitude, get_gain_lilian_ratio()).
do_calc_lilian_reward(_WorldCompeteType, CombatResult, AveragePower, Latitude, LilianRatio) ->
    R = case CombatResult of
        ?c_world_compete_result_ko_perfect -> 1;
        ?c_world_compete_result_ko -> 0.85;
        ?c_world_compete_result_loss_perfect -> 0.5;
        ?c_world_compete_result_loss -> 0.65;
        _ -> 0.75
    end,
    %% 根据匹配值计算历练补偿值
    AddtLilian = case Latitude of
        0.166 -> 16;
        0.195 -> 17;
        0.224 -> 19;
        0.253 -> 20;
        0.282 -> 21;
        0.311 -> 22;
        0.34 -> 23;
        0.369 -> 25;
        0.398 -> 26;
        0.427 -> 27;
        0.456 -> 28;
        0.485 -> 29;
        0.514 -> 29;
        0.543 -> 30;
        0.572 -> 31;
        0.601 -> 32;
        0.63 -> 33;
        0.659 -> 34;
        0.688 -> 35;
        0.717 -> 35;
        0.746 -> 36;
        0.775 -> 37;
        0.804 -> 38;
        0.833 -> 38;
        0.862 -> 39;
        0.891 -> 40;
        _ -> 0
    end,
    {round((math:pow(AveragePower, 0.54) /2 * R + AddtLilian)* LilianRatio), AddtLilian}.

%% 根据仙道会类型来增减得益
%calc_rewards_by_type(Rewards, WorldCompeteType) ->
%    case WorldCompeteType of
%        ?WORLD_COMPETE_TYPE_11 ->
%            [{RewardType, round(Val/2)} || {RewardType, Val} <- Rewards];
%        _ -> Rewards
%    end.

%% 从缓存中读取之前计算好的历练 -> {Lilian, AddtLilian}
get_cached_lilian(RoleId, CombatResult) ->
    case get({gain_lilian, RoleId}) of
        L = [_|_] ->
            case lists:keyfind(CombatResult, 1, L) of
                {CombatResult, Lilian, AddtLilian} -> {Lilian, AddtLilian};
                _ -> {0, 0}
            end;
        _ -> {0, 0}
    end.

%% 处理战斗结果
deal_combat_result(_CombatResult, [], _) -> ok;
deal_combat_result(CombatResult, [F = #fighter{rid = Rid, srv_id = SrvId, name = Name, lev = Lev, is_clone = ?false}|T], [AveragePower, TimerPid, State = #state{type = WorldCompeteType}, TopPower]) ->
    Rewards = calc_combat_over_rewards(WorldCompeteType, CombatResult, F, [AveragePower, 0, get_gain_lilian_ratio()]),
    Lilian = combat_util:match_param(lilian, Rewards, 0),
    ?DEBUG("[~s]的仙道会战斗结果:~w，获得奖励:~w", [Name, CombatResult, Rewards]),
    Mark = add_to_world_compete_marks({Rid, SrvId}, Name, Lev, CombatResult, Lilian, WorldCompeteType, TopPower),
    c_mirror_group:cast(node, SrvId, world_compete_mgr, combat_result_inform, [CombatResult, WorldCompeteType, {Rid, SrvId}, Rewards, term_to_binary(Mark)]),
    deal_combat_result(CombatResult, T, [AveragePower, TimerPid, State, TopPower]);
deal_combat_result(CombatResult, [#fighter{name = _Name}|T], [AveragePower, TimerPid, State, TopPower]) ->   %% 不处理克隆人
    ?DEBUG("[~s]是克隆人，不处理他的仙道会战斗结果", [_Name]),
    deal_combat_result(CombatResult, T, [AveragePower, TimerPid, State, TopPower]).

%% 处理异常结束仙道战斗的平局结果
deal_other_result(_Result, _WorldCompeteType, _AveragePower, []) -> ok;
deal_other_result(Result, WorldCompeteType, AveragePower, [RoleId = {Rid, SrvId} | T]) ->
    Rewards = calc_combat_over_rewards(WorldCompeteType, Result, RoleId, [AveragePower, 0, get_gain_lilian_ratio()]),
    Lilian = combat_util:match_param(lilian, Rewards, 0),
    {Name, _Career, _Sex, Lev, _Looks1, _Eqm1, _RolePower, _PetPower} = get_signup_role_info(RoleId),
    Mark = add_to_world_compete_marks(RoleId, Name, Lev, Result, Lilian, WorldCompeteType, 0),
    ?DEBUG("[~s]的仙道会战斗异常，处理结果:~w，获得奖励:~w", [Name, Result, Rewards]),
    c_mirror_group:cast(node, SrvId, world_compete_mgr, combat_result_inform, [Result, WorldCompeteType, {Rid, SrvId}, Rewards, term_to_binary(Mark)]),
    deal_other_result(Result, WorldCompeteType, AveragePower, T);
deal_other_result(Result, WorldCompeteType, AveragePower, RoleId = {Rid, SrvId}) ->
    Rewards = calc_combat_over_rewards(WorldCompeteType, Result, RoleId, [AveragePower, 0, get_gain_lilian_ratio()]),
    Lilian = combat_util:match_param(lilian, Rewards, 0),
    {Name, _Career, _Sex, Lev, _Looks1, _Eqm1, _RolePower, _PetPower} = get_signup_role_info(RoleId),
    Mark = add_to_world_compete_marks(RoleId, Name, Lev, Result, Lilian, WorldCompeteType, 0),
    ?DEBUG("[~s]的仙道会战斗异常，处理结果:~w，获得奖励:~w", [Name, Result, Rewards]),
    c_mirror_group:cast(node, SrvId, world_compete_mgr, combat_result_inform, [Result, WorldCompeteType, {Rid, SrvId}, Rewards, term_to_binary(Mark)]).

%% 获取活动加成系数 -> integer()
get_gain_lilian_ratio() ->
    Platform = sys_env:get(platform),
    get_gain_lilian_ratio(Platform).
get_gain_lilian_ratio("koramgame") ->
    Time1 = util:datetime_to_seconds({{2012,11,28},{0,0,0}}),
    Time2 = util:datetime_to_seconds({{2012,12,5},{23,59,59}}),
    Time3 = util:datetime_to_seconds({{2012,11,29},{23,59,59}}),
    Now = util:unixtime(),
    if
        Time1 =< Now andalso Now < Time3 -> 3;
        Time3 =< Now andalso Now < Time2 -> 2;
        true -> 1
    end;
get_gain_lilian_ratio(_) ->
    Time1 = util:datetime_to_seconds({{2013,1,11},{0,0,0}}),
    Time2 = util:datetime_to_seconds({{2013,1,13},{23,59,59}}),
    Now = util:unixtime(),
    case Time1 =< Now andalso Now < Time2 of
        true -> 2;
        false ->
            case util:seconds_to_datetime(Now) of
                {{2012, 6, 21}, _} -> 2;    %% 补偿
                _ -> 1
            end
    end.


%%--------------------------------------------
%% 排行榜、仙道会战绩相关
%%--------------------------------------------
%% 生成单场战绩数据
to_single_mark(CombatResult, RoleId, Lilian, WorldCompeteType) ->
    Mark = #world_compete_mark{win_count = WinCnt} = case CombatResult of
        ?c_world_compete_result_ko_perfect -> %% 完胜
            #world_compete_mark{combat_count = 1, win_count = 1, ko_perfect_count = 1,
                continuous_win_count = 1, gain_lilian = Lilian, win_rate = 100, win_count_today = 1};
        ?c_world_compete_result_ko ->
            #world_compete_mark{combat_count = 1, win_count = 1,
                continuous_win_count = 1, gain_lilian = Lilian, win_rate = 100, win_count_today = 1};
        ?c_world_compete_result_loss ->
            #world_compete_mark{combat_count = 1, loss_count = 1,
                continuous_loss_count = 1, gain_lilian = Lilian};
        ?c_world_compete_result_loss_perfect ->
            #world_compete_mark{combat_count = 1, loss_count = 1,
                continuous_loss_count = 1, gain_lilian = Lilian};
        _ ->
            #world_compete_mark{combat_count = 1, draw_count = 1,
                continuous_draw_count = 1, gain_lilian = Lilian}
    end,
    Mark1 = case WorldCompeteType of
        ?WORLD_COMPETE_TYPE_11 -> Mark#world_compete_mark{win_count_11 = WinCnt, combat_count_11 = 1, gain_lilian_11 = Lilian};
        ?WORLD_COMPETE_TYPE_22 -> Mark#world_compete_mark{win_count_22 = WinCnt, combat_count_22 = 1, gain_lilian_22 = Lilian};
        ?WORLD_COMPETE_TYPE_33 -> Mark#world_compete_mark{win_count_33 = WinCnt, combat_count_33 = 1, gain_lilian_33 = Lilian}
    end,
    SectionMark = get_cached_section_mark(RoleId, CombatResult),
    Mark1#world_compete_mark{section_mark = SectionMark}.

%% 合并计算个人总战绩
add_to_world_compete_marks(RoleId = {_, SrvId}, Name, Lev, Result, Lilian, WorldCompeteType, TopPower) ->
    SingleMark = to_single_mark(Result, RoleId, Lilian, WorldCompeteType),
    case catch ets:lookup(world_compete_marks, RoleId) of
        [OldMark = #world_compete_mark{section_mark = OldSectionMark, section_lev = OldSectionLev, combat_count = CombatCount}] -> %% 已经打过仙道会
            Mark = merge_mark(SingleMark, OldMark),
            {_Name1, Career1, Sex1, _Lev1, Looks1, Eqm1, RolePower, PetPower} = get_signup_role_info(RoleId),
            NewTopPower = case Mark#world_compete_mark.win_top_power < TopPower of
                true -> TopPower;
                false -> Mark#world_compete_mark.win_top_power
            end,
            AddSectionMark = SingleMark#world_compete_mark.section_mark,
            SectionMark = case CombatCount =< 0 of
                true ->
                    round(calc_first_section_mark(RolePower) + AddSectionMark);
                false ->
                    case OldSectionMark >=1 of
                        true -> %% 打过段位赛
                            OldSectionMark + AddSectionMark;
                        false -> %% 没打过段位赛
                            round(calc_first_section_mark(RolePower) + AddSectionMark)
                    end
            end,
            SectionMark1 = util:check_range(SectionMark, 1, 99999999),
            SectionLev = c_world_compete_section_data:section_mark_to_section_lev(SectionMark1),
            Mark1 = Mark#world_compete_mark{id = RoleId, name = Name, career = Career1, sex = Sex1, lev = Lev, looks = Looks1, eqm = Eqm1, role_power = RolePower, pet_power = PetPower, win_top_power = NewTopPower, update_time = util:unixtime(), section_mark = SectionMark1, section_lev = SectionLev},
            ets:insert(world_compete_marks, Mark1),
            spawn(fun() -> save_role_mark(Mark1) end),
            %% 通知段位积分变更
            c_mirror_group:cast(node, SrvId, world_compete_mgr, section_mark_change_inform, [RoleId, Name, SectionMark1, SectionLev, OldSectionMark, OldSectionLev]),
            %% 如果升段了就通知一下
            SectionLevChanged = SectionLev - OldSectionLev,
            case SectionLevChanged =/= 0 of
                true ->
                    c_mirror_group:cast(node, SrvId, world_compete_mgr, section_lev_change_inform, [RoleId, Name, SectionLevChanged, SectionLev]);
                false ->
                    ignore
            end,
            Mark1;
        [] -> %% 之前还没打过仙道会
            {_Name1, Career1, Sex1, _Lev1, Looks1, Eqm1, RolePower, PetPower} = get_signup_role_info(RoleId),
            AddSectionMark = SingleMark#world_compete_mark.section_mark,
            SectionMark = util:check_range(round(calc_first_section_mark(RolePower) + AddSectionMark), 1, 99999999),
            SectionLev = c_world_compete_section_data:section_mark_to_section_lev(SectionMark),
            Mark1 = SingleMark#world_compete_mark{id = RoleId, name = Name, career = Career1, sex = Sex1, lev = Lev, looks = Looks1, eqm = Eqm1, role_power = RolePower, pet_power = PetPower, win_top_power = TopPower, update_time = util:unixtime(), section_mark = SectionMark, section_lev = SectionLev},
            ets:insert(world_compete_marks, Mark1),
            spawn(fun() -> save_role_mark(Mark1) end),
            %% 通知段位积分变更
            c_mirror_group:cast(node, SrvId, world_compete_mgr, section_mark_change_inform, [RoleId, Name, SectionMark, SectionLev, 0, 0]),
            Mark1;
        _ -> SingleMark
    end.

%% 合并单场战绩至总战绩
merge_mark(_SingleMark = #world_compete_mark{
        gain_lilian = Lilian,
        combat_count = ComCnt, win_count = WinCnt, loss_count = LossCnt, draw_count = DrawCnt, ko_perfect_count = KoPerCnt,
        continuous_win_count = CWinCnt, continuous_loss_count = CLossCnt, continuous_draw_count = CDrawCnt,
        win_count_11 = WinCnt11, combat_count_11 = ComCnt11, gain_lilian_11 = LiLian11,
        win_count_22 = WinCnt22, combat_count_22 = ComCnt22, gain_lilian_22 = LiLian22,
        win_count_33 = WinCnt33, combat_count_33 = ComCnt33, gain_lilian_33 = LiLian33
    }, OldMark = #world_compete_mark{
        gain_lilian = OldLilian,
        combat_count = OldComCnt, win_count = OldWinCnt, loss_count = OldLossCnt, draw_count = OldDrawCnt, ko_perfect_count = OldKoPerCnt,
        continuous_win_count = OldCWinCnt, continuous_loss_count = OldCLossCnt, continuous_draw_count = OldCDrawCnt,
        win_count_11 = OldWinCnt11, combat_count_11 = OldComCnt11, gain_lilian_11 = OldLiLian11,
        win_count_22 = OldWinCnt22, combat_count_22 = OldComCnt22, gain_lilian_22 = OldLiLian22,
        win_count_33 = OldWinCnt33, combat_count_33 = OldComCnt33, gain_lilian_33 = OldLiLian33,
        win_count_today = WinCntToday
    }) ->
    %% 判断连续场次
    Mark = if
        CWinCnt > 0 -> %% 本场胜利，结束连输
            OldMark#world_compete_mark{continuous_win_count = OldCWinCnt+CWinCnt, continuous_loss_count = 0, continuous_draw_count = 0, win_count_today = WinCntToday + CWinCnt};
        CLossCnt > 0 -> %% 本场失败，结束连赢
            OldMark#world_compete_mark{continuous_win_count = 0, continuous_loss_count = OldCLossCnt+CLossCnt, continuous_draw_count = 0};
        true ->
            OldMark#world_compete_mark{continuous_win_count = 0, continuous_loss_count = 0, continuous_draw_count = OldCDrawCnt+CDrawCnt}
    end,
    Mark1 = Mark#world_compete_mark{
        gain_lilian = Lilian+OldLilian,
        combat_count = ComCnt+OldComCnt, win_count = WinCnt+OldWinCnt, loss_count = LossCnt+OldLossCnt, draw_count = DrawCnt+OldDrawCnt,
        ko_perfect_count = KoPerCnt+OldKoPerCnt,
        win_count_11 = WinCnt11+OldWinCnt11, combat_count_11 = ComCnt11+OldComCnt11, gain_lilian_11 = LiLian11+OldLiLian11,
        win_count_22 = WinCnt22+OldWinCnt22, combat_count_22 = ComCnt22+OldComCnt22, gain_lilian_22 = LiLian22+OldLiLian22,
        win_count_33 = WinCnt33+OldWinCnt33, combat_count_33 = ComCnt33+OldComCnt33, gain_lilian_33 = LiLian33+OldLiLian33,
        win_rate = round((WinCnt+OldWinCnt)*100/(ComCnt+OldComCnt))
    },
    %% ?DEBUG("[~s] combat_count=~w, win_count=~w, c_win_count=~w", [Mark1#world_compete_mark.name, Mark1#world_compete_mark.combat_count, Mark1#world_compete_mark.win_count, Mark1#world_compete_mark.continuous_win_count]),
    Mark1.

%% 实时保存个人战绩数据至DETS
%% TODO: 防止中央服仙道会期间异常，活动没有结束就关闭导致数据丢失
save_role_mark(Mark) when is_record(Mark, world_compete_mark) ->
    ?DEBUG("保存的战绩:~s, ~w", [Mark#world_compete_mark.name, Mark#world_compete_mark.win_count_today]),
    dets:insert(world_compete_mark_list, Mark);
save_role_mark(_) -> ignore.

%% 根据个人战绩获取战斗力调整数值
get_adjust_power(RoleId, Power) ->
    case catch ets:lookup(world_compete_marks, RoleId) of
        [#world_compete_mark{continuous_win_count = ContinuousWinCount}] when ContinuousWinCount>0 ->
            round(util:check_range(Power * 0.02 * ContinuousWinCount, 0, Power * 0.2));
        [#world_compete_mark{continuous_loss_count = ContinuousLossCount}] when ContinuousLossCount>0 ->
            -round(Power * 0.02 * ContinuousLossCount);
        _ -> 0
    end.

%% 统计参与人数
update_signup_statistic(RoleIds) ->
    case get(sign_up_statistic) of
        undefined -> put(sign_up_statistic, RoleIds);
        L ->
            L1 = L -- RoleIds,
            put(sign_up_statistic, L1 ++ RoleIds)
    end.

%% 打印参与人数
print_signup_statistic() ->
    ?INFO("仙道会[Type=~w]的参与人数:~w", [get(world_compete_type), length(get(sign_up_statistic))]).

%% 发送给参战者所在的服务器
send_to_node({_, SrvId}, M, F, A) ->
    c_mirror_group:cast(node, SrvId, M, F, A);
send_to_node(RoleIds, M, F, A) when is_list(RoleIds) ->
    SrvIds = distinct([SrvId || {_, SrvId} <- RoleIds]),
    lists:foreach(fun(SrvId) -> c_mirror_group:cast(node, SrvId, M, F, A) end, SrvIds);
send_to_node(RoleIds, M, F, A) ->
    ?ERR("参数错误:~w, ~w, ~w, ~w", [RoleIds, M, F, A]).

distinct(SrvIds) -> distinct(SrvIds, []).
distinct([], Result) -> Result;
distinct([SrvId|T], Result) ->
    DestSrvId = c_mirror_group:get_merge_dest_srv_id(SrvId),
    case lists:member(DestSrvId, Result) of
        true -> distinct(T, Result);
        false -> distinct(T, [DestSrvId|Result])
    end.

%% 计算分组 -> integer()
calc_group({TotalPower1, Num1}, {TotalPower2, Num2}) ->
    AveragePower1 = case Num1 > 0 of
        true -> round(TotalPower1/Num1);
        false -> 0
    end,
    AveragePower2 = case Num2 > 0 of
        true -> round(TotalPower2/Num2);
        false -> 0
    end,
    AveragePower = erlang:max(AveragePower1, AveragePower2),
    power_to_world_compete_group(AveragePower).


%% 战斗力 到 分组 的映射
power_to_world_compete_group(Power) when Power < 10000 -> ?WORLD_COMPETE_GROUP_NEW;
power_to_world_compete_group(Power) when Power >=10000 andalso Power < 16000 -> ?WORLD_COMPETE_GROUP_JINGRUI;
power_to_world_compete_group(Power) when Power >=16000 andalso Power < 22000 -> ?WORLD_COMPETE_GROUP_LINGYUN;
power_to_world_compete_group(Power) when Power >=22000 andalso Power < 30000 -> ?WORLD_COMPETE_GROUP_WUSHUANG;
power_to_world_compete_group(Power) when Power >=30000 andalso Power < 40000 -> ?WORLD_COMPETE_GROUP_JINGSHI;
power_to_world_compete_group(Power) when Power >=40000 andalso Power < 50000 -> ?WORLD_COMPETE_GROUP_DIANFENG;
power_to_world_compete_group(_Power) -> ?WORLD_COMPETE_GROUP_SHASHEN.


%%-----------------------------------------
%% 段位相关
%%-----------------------------------------
%% 升阶所用积分
next_section_mark(Lev) ->
    case c_world_compete_section_data:get(Lev) of
        #world_compete_section_data{next_mark = NextMark} -> NextMark;
        _ ->
            MaxSectionData = c_world_compete_section_data:get(c_world_compete_section_data:max_lev()),
            MaxSectionData#world_compete_section_data.next_mark
    end.

%% 简单计算队伍的段位等级和积分 -> {SectionMark, SectionLev}
simple_calc_section_mark([]) -> {0, 1};
simple_calc_section_mark(RoleIds = [_|_]) ->
    TotalSectionMark = simple_calc_section_mark(RoleIds, 0),
    N = length(RoleIds),
    TeamSectionMark = round(TotalSectionMark/N),
    {TeamSectionMark, c_world_compete_section_data:section_mark_to_section_lev(TeamSectionMark)}.
simple_calc_section_mark([], Result) -> Result;
simple_calc_section_mark([RoleId = {_, _}|T], Result) ->
    case ets:lookup(get(ets_name), RoleId) of
        [#sign_up_role{section_mark = SectionMark}] ->
            simple_calc_section_mark(T, Result + SectionMark);
        _ -> simple_calc_section_mark(T, Result)
    end;
simple_calc_section_mark([#sign_up_role{section_mark = SectionMark}|T], Result) ->
    simple_calc_section_mark(T, Result + SectionMark);
simple_calc_section_mark([_R|T], Result) ->
    ?ERR("简单计算总战斗力时输入了错误的参数:~w", [_R]),
    simple_calc_section_mark(T, Result).


%% 胜负与获得的段位积分
combat_result_to_section_mark(?WORLD_COMPETE_TYPE_11, ?c_world_compete_result_ko_perfect) -> 100;
combat_result_to_section_mark(?WORLD_COMPETE_TYPE_11, ?c_world_compete_result_ko) -> 70;
combat_result_to_section_mark(?WORLD_COMPETE_TYPE_11, ?c_world_compete_result_draw) -> 0;
combat_result_to_section_mark(?WORLD_COMPETE_TYPE_11, ?c_world_compete_result_loss) -> -60;
combat_result_to_section_mark(?WORLD_COMPETE_TYPE_11, ?c_world_compete_result_loss_perfect) -> -90;
combat_result_to_section_mark(_, _) -> 0.

%% 给每个参赛者附上段位信息
append_section_info([], Result) -> lists:reverse(Result);
append_section_info([SignupRole = #sign_up_role{id = RoleId, name = _Name, attr = #attr{fight_capacity = RolePower}}|T], Result) ->
    {SectionMark, SectionLev} = case catch ets:lookup(world_compete_marks, RoleId) of
        [#world_compete_mark{section_mark = OldSectionMark, section_lev = OldSectionLev}] when OldSectionMark > 0 ->
            {OldSectionMark, OldSectionLev};
        _ ->
            S = calc_first_section_mark(RolePower),
            {S, c_world_compete_section_data:section_mark_to_section_lev(S)}
    end,
    %% ?DEBUG("[~s] SectionMark=~w, SectionLev=~w", [_Name, SectionMark, SectionLev]),
    append_section_info(T, [SignupRole#sign_up_role{section_mark = SectionMark, section_lev = SectionLev}|Result]).

%% 根据段位匹配
%% Match = [{Team1, Team2}] 匹配到的组
%% MatchList = [#sign_up_team{}] 把匹配到的组展开成单个#sign_up_team{}的列表
do_match_teams_by_section([], _, Match, MatchList) -> {Match, MatchList};
do_match_teams_by_section([Team1|T], Ops, Match, MatchList) ->
    Direction = case util:rand(1, 100) < 50 of
        true -> ?WORLD_COMPETE_MATCH_DIRECTION_UP;
        false -> ?WORLD_COMPETE_MATCH_DIRECTION_DOWN
    end,
    case make_matched_op_by_section(Team1, Ops, Direction) of
        {Team2, _Latitude} ->
            %% 匹配上的就从主动匹配方去掉匹配到的2个组，同样，被匹配方也是同样操作
            {Latitude1, Latitude2} = {0, 0},
            do_match_teams_by_section(T -- [Team1, Team2], Ops -- [Team1, Team2], [{Team1#sign_up_team{match_latitude = Latitude1}, Team2#sign_up_team{match_latitude = Latitude2}}|Match], [Team1, Team2|MatchList]);
        _ ->
            do_match_teams_by_section(T, Ops -- [Team1], Match, MatchList)
    end.

%% 根据段位获取匹配的对手 -> #sign_up_team{} | undefined
make_matched_op_by_section(_Team1, [], _Direction) -> undefined;
make_matched_op_by_section(Team1, [Team1|T], Direction) -> make_matched_op_by_section(Team1, T, Direction);
make_matched_op_by_section(Team1 = #sign_up_team{id = RoleIds1, section_mark = SectionMark1, section_lev = SectionLev1, match_count = MatchCount1}, [Team2 = #sign_up_team{id = RoleIds2, section_mark = SectionMark2, section_lev = SectionLev2, match_count = MatchCount2}|T], Direction) when (Direction =:= ?WORLD_COMPETE_MATCH_DIRECTION_UP) orelse (Direction =:= ?WORLD_COMPETE_MATCH_DIRECTION_DOWN andalso SectionMark1 > SectionMark2) ->
    SectionLev = case SectionMark1 >= SectionMark2 of
        true -> SectionLev2;
        false -> SectionLev1
    end,
    NextSectionMark1 = next_section_mark(SectionLev),
    NextSectionMark2 = next_section_mark(SectionLev+1),
    Latitude = case sys_env:get(is_debug_world_compete_section) of
        true -> 100000;
        _ ->
            case MatchCount1 of
                0 -> NextSectionMark1 / 10;
                1 -> NextSectionMark1 / 10;
                2 -> NextSectionMark1 / 10;
                3 -> NextSectionMark1 * 2 / 10;
                4 -> NextSectionMark1 * 2 / 10;
                5 -> NextSectionMark1 * 2 / 10;
                6 -> NextSectionMark1 * 3 / 10;
                7 -> NextSectionMark1 * 3 / 10;
                8 -> NextSectionMark1 * 4 / 10;
                9 -> NextSectionMark1 * 4 / 10;
                10 -> NextSectionMark1 * 5 / 10;
                11 -> NextSectionMark1 * 5 / 10;
                12 -> NextSectionMark1 * 6 / 10;
                13 -> NextSectionMark1 * 6 / 10;
                14 -> NextSectionMark1 * 7 / 10;
                15 -> NextSectionMark1 * 8 / 10;
                16 -> NextSectionMark1 * 9 / 10;
                17 -> NextSectionMark1;
                18 -> NextSectionMark1 + NextSectionMark2 / 10;
                19 -> NextSectionMark1 + NextSectionMark2 * 2 / 10;
                20 -> NextSectionMark1 + NextSectionMark2 * 3 / 10;
                21 -> NextSectionMark1 + NextSectionMark2 * 4 / 10;
                22 -> NextSectionMark1 + NextSectionMark2 * 5 / 10;
                23 -> NextSectionMark1 + NextSectionMark2 * 6 / 10;
                24 -> NextSectionMark1 + NextSectionMark2 * 7 / 10;
                25 -> NextSectionMark1 + NextSectionMark2 * 8 / 10;
                26 -> NextSectionMark1 + NextSectionMark2 * 9 / 10;
                _ -> NextSectionMark1 + NextSectionMark2
            end
    end,
    IsFromSameServer = is_from_same_server(RoleIds1, RoleIds2),
    if
        (MatchCount1 =:= 1 orelse MatchCount2 =:= 1) andalso IsFromSameServer =:= true -> %% 头N次匹配不给同服匹配
            ?DEBUG("正在给[~w]匹配对手[~w]，该次匹配跳过同服对手", [RoleIds1, RoleIds2]),
            make_matched_op_by_section(Team1, T, Direction);
        (SectionMark1 > SectionMark2 + Latitude) orelse (SectionMark2 > SectionMark1 + Latitude) -> %% 段位分数相距过大
            ?DEBUG("正在给[~w]匹配对手[~w]，段位相距过大(~w， ~w，段位分数浮动:~w)", [RoleIds1, RoleIds2, SectionMark1, SectionMark2, Latitude]),
            make_matched_op_by_section(Team1, T, Direction);
        true ->
            ?DEBUG("MatchCount1=~w, SectionMark1=~w, SectionMark2=~w, SectionLev=~w, Latitude=~w", [MatchCount1, SectionMark1, SectionMark2, SectionLev, Latitude]),
            {Team2, Latitude}
    end;
make_matched_op_by_section(Team1, [_|T], Direction) -> make_matched_op_by_section(Team1, T, Direction).

%% 计算获得的段位积分 -> integer()
calc_section_mark_reward(?WORLD_COMPETE_TYPE_11, CombatResult, RoleIds, OpRoleIds) ->
    do_calc_section_mark_reward(?WORLD_COMPETE_TYPE_11, CombatResult, simple_calc_section_mark(RoleIds), simple_calc_section_mark(OpRoleIds));
calc_section_mark_reward(_, _, _, _) -> 0.

do_calc_section_mark_reward(WorldCompeteType, CombatResult, {SectionMark1, SectionLev1}, {_SectionMark2, SectionLev2}) ->
    SectionMarkChanged = combat_result_to_section_mark(WorldCompeteType, CombatResult),
    Result = if
        CombatResult =:= ?c_world_compete_result_ko_perfect orelse CombatResult =:= ?c_world_compete_result_ko ->
            if
                SectionLev1 - SectionLev2 < 0 -> SectionMarkChanged * (SectionLev2 - SectionLev1 + 1);
                SectionLev1 - SectionLev2 =:= 0 -> SectionMarkChanged;
                SectionLev1 - SectionLev2 =:= 1 -> SectionMarkChanged * 0.5;
                SectionLev1 - SectionLev2 =:= 2 -> SectionMarkChanged * 0.2;
                true -> 1
            end;
        CombatResult =:= ?c_world_compete_result_loss_perfect orelse CombatResult =:= ?c_world_compete_result_loss ->
            if
                SectionLev1 - SectionLev2 =:= -2 -> SectionMarkChanged * 0.2;
                SectionLev1 - SectionLev2 =:= -1 -> SectionMarkChanged * 0.5;
                SectionLev1 - SectionLev2 >= 0 -> SectionMarkChanged * (SectionLev1 - SectionLev2 + 1);
                true -> 1
            end;
        true -> 0
    end,
    Result1 = round(Result),
    case SectionMark1 + Result1 >= 0 of
        true -> Result1;
        false -> -SectionMark1
    end.

%% 获取预计能获得的段位积分 -> [{Result, SectionMark}]
get_pre_section_mark_info(#sign_up_team{id = RoleIds}, #sign_up_team{id = OpRoleIds}, #state{type = WorldCompeteType}) ->
    L0 = {?c_world_compete_result_draw, calc_section_mark_reward(WorldCompeteType, ?c_world_compete_result_draw, RoleIds, OpRoleIds)},
    L1 = {?c_world_compete_result_ko_perfect, calc_section_mark_reward(WorldCompeteType, ?c_world_compete_result_ko_perfect, RoleIds, OpRoleIds)},
    L2 = {?c_world_compete_result_ko, calc_section_mark_reward(WorldCompeteType, ?c_world_compete_result_ko, RoleIds, OpRoleIds)},
    L3 = {?c_world_compete_result_loss_perfect, calc_section_mark_reward(WorldCompeteType, ?c_world_compete_result_loss_perfect, RoleIds, OpRoleIds)},
    L4 = {?c_world_compete_result_loss, calc_section_mark_reward(WorldCompeteType, ?c_world_compete_result_loss, RoleIds, OpRoleIds)},
    [L0, L1, L2, L3, L4].

%% 从缓存中读取之前计算好的段位积分
get_cached_section_mark(RoleId, CombatResult) ->
    case get({gain_section_mark, RoleId}) of
        L = [_|_] ->
            case lists:keyfind(CombatResult, 1, L) of
                {CombatResult, Mark} -> Mark;
                _ -> 0
            end;
        _ -> 0
    end.

%% 获取报名角色的段位信息
get_section_data(RoleId) ->
    case ets:lookup(get(ets_name), RoleId) of
        [#sign_up_role{section_lev = SectionLev}] -> c_world_compete_section_data:get(SectionLev);
        _ -> undefined
    end.

%% 计算第一次段位积分
calc_first_section_mark(RolePower) ->
    round(math:pow(RolePower, 0.8) / math:pow(6500, 0.8) * 200 - 200).
