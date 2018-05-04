%%----------------------------------------------------
%% 仙道会管理器
%% @author yankai@jieyou.cn
%% @end
%%----------------------------------------------------
-module(world_compete_mgr).

-behaviour(gen_server).

-export([
        start/0,
        start_link/0,
        prepare_start/0,
        start_activity/1,
        stop_activity/0,
        sign_up/2,
        sign_up_result_inform/2,
        match_result_inform/2,
        combat_result_inform/5,
        leave_area/2,
        print_current_status/0,
        get_current_status/1,
        cancel_match/2,
        cancel_match_result_inform/2,
        retry_match/1,
        login/1,
        role_switch/1,
        get_rank_data/2,
        get_rank_role_info/2,
        rank_data_update/1,
        rank_data_update/2,
        check_activity_status_result_inform/1,
        on_team_break_up/1,
        send_activity_over_rewards/2,
        force_clear_sign_up_limit/0,
        op_enter_prepare_combat_failed/1,
        world_compete_type_to_event/1,
        event_to_world_compete_type/1,
        get_signup_counts/1,
        start_combat_result_inform/2,
        reinform_enter_combat_area/1,
        open_sign_up_limit/0,
        close_sign_up_limit/0,
        big_win_cast/2,
        get_mark_day/1,
        get_today_sign_up_count/2,
        power_to_world_compete_group/1,
        send_day_section_rewards/1,
        get_day_section_reward_info/1,
        section_lev_change_inform/4,
        section_mark_change_inform/6,
        get_day_section_reward/2,
        is_cross_teammate_reached_signup_limit/2,
        check_cross_teammate_signup_limit/2,
        change_lineup/3,
        change_lineup_result_inform/3
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("role.hrl").
%%
-include("pos.hrl").
-include("mail.hrl").
-include("world_compete.hrl").
-include("combat.hrl").
-include("team.hrl").
-include("rank.hrl").
-include("gain.hrl").
-include("item.hrl").

-define(SIGN_UP_EXPIRE_TIME, 10).       %% 报名过时时间（单位：秒）
-define(OPEN_TIME, 14 * 24 * 3600).                 %% 开服后第15天才能开放仙道会
-define(CHECK_SIGN_UP_RESULT_TIME, 1000*10). %% 报名结果检查间隔时间（单位：毫秒）
-define(CHECK_LOGIN_STATUS_TIME, 1500). %% 检查登陆状态时间（单位：毫秒）
-define(CHECK_LOGIN_STATUS_TIMEOUT, 30000).  %% 登陆状态检查超时时间（单位：毫秒）
-define(LEAVE_AREA_TIMEOUT, 3000).         %% 离开战区的超时时间（单位：毫秒）


-record(state, {
        is_started = false,
        current_period = 0
    }
).

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------
start() ->
    gen_server:start({local, ?MODULE}, ?MODULE, [], []).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 准备开启活动
prepare_start() ->
    gen_server:cast(?MODULE, prepare_start).

%% 开启活动
start_activity(CurrentPeriod) ->
    gen_server:cast(?MODULE, {start_activity, CurrentPeriod}).

%% 结束活动
stop_activity() ->
    gen_server:cast(?MODULE, stop_activity).

%% @spec sign_up(WorldCompeteType, SignupRoles) -> ok
%% WorldCompeteType = integer()
%% SignupRoles = [#sign_up_role{}]
%% @doc 队长报名
sign_up(WorldCompeteType, SignupRoles) ->
    gen_server:cast(?MODULE, {sign_up, WorldCompeteType, SignupRoles}).

%% @spec sign_up_result_inform(RoleIds, Result) -> ok
%% RoleIds = [{Rid, SrvId}]
%% Result -> {true, WorldCompeteType} | {false, Reason}
%% @doc 中央服通知报名结果
sign_up_result_inform(RoleIds, Result) ->
    gen_server:cast(?MODULE, {sign_up_result_inform, RoleIds, Result}).

%% @spec match_result_inform(RoleIds, Result) -> ok
%% RoleIds = [{Rid, SrvId}]
%% Result -> {true, [...]} | {false, Reason}
%% @doc 中央服通知匹配结果
match_result_inform(RoleIds, Result) ->
    gen_server:cast(?MODULE, {match_result_inform, RoleIds, Result}).

%% @spec combat_result_inform(CombatResult, WorldCompeteType, RoleId, Rewards, MarkBin) -> ok
%% CombatResult = integer()
%% Rewards = [{atom(), integer()}]
%% MarkBin = binary()
%% @doc 中央服通知战斗结果
combat_result_inform(CombatResult, WorldCompeteType, RoleId, Rewards, MarkBin) ->
    gen_server:cast(?MODULE, {combat_result_inform, CombatResult, WorldCompeteType, RoleId, Rewards, MarkBin}).

%% @spec leave_area(RoleId, RolePid) -> ok
%% RoleId = {Rid, SrvId}
%% RolePid = pid()
%% @doc 角色点击离开按钮离开战斗区域
leave_area(RoleId, RolePid) ->
    gen_server:cast(?MODULE, {leave_area, RoleId, RolePid}).

%% @spec print_current_status() -> ok
%% @doc 打印当前仙道会状态
print_current_status() ->
    gen_server:cast(?MODULE, print_current_status).

%% @spec get_current_status(RolePid) -> ok
%% RolePid = pid()
%% @doc 获取当前活动状态
get_current_status(RolePid) ->
    gen_server:cast(?MODULE, {get_current_status, RolePid}).

%% @spec cancel_match(WorldCompeteType, RoleIds) -> ok
%% WorldCompeteType = integer()
%% RoleIds = [{Rid, SrvId}]
%% @doc 取消匹配
cancel_match(WorldCompeteType, RoleIds) ->
    gen_server:cast(?MODULE, {cancel_match, WorldCompeteType, RoleIds}).

%% @spec on_team_break_up(Team) -> ok
%% Team = #team{}
%% @doc 队伍解散时取消报名
on_team_break_up(#team{leader = Leader, member = Members}) ->
    case Leader of
        #team_member{id = LeaderRoleId = {_, _}} ->
            case role_api:lookup(by_id, LeaderRoleId, [#role.event]) of
                {ok, _, [Event]} when Event =:= ?event_c_world_compete_11 orelse Event =:= ?event_c_world_compete_22 orelse Event =:= ?event_c_world_compete_33 ->
                    WorldCompeteType = event_to_world_compete_type(Event),
                    cancel_match(WorldCompeteType, [LeaderRoleId]);
                _Err -> ignore
            end;
        _ ->
            case Members of
                [_|_] ->
                    lists:foreach(fun(#team_member{id = MemberRoleId}) ->
                                case role_api:lookup(by_id, MemberRoleId, [#role.event]) of
                                    {ok, _, [Event]} when Event =:= ?event_c_world_compete_11 orelse Event =:= ?event_c_world_compete_22 orelse Event =:= ?event_c_world_compete_33 ->
                                        WorldCompeteType = event_to_world_compete_type(Event),
                                        cancel_match(WorldCompeteType, [MemberRoleId]);
                                    _Err -> ignore
                                end
                            end, Members);
                _ -> ignore
            end
    end,
    ok;
on_team_break_up(_) -> ok.

%% @spec cancel_match_result_inform(RoleIds, Result) -> ok
%% RoleIds = [{Rid, SrvId}]
%% Result = true | _Any
%% @doc 取消匹配结果通知
cancel_match_result_inform(RoleIds, Result) ->
    gen_server:cast(?MODULE, {cancel_match_result_inform, RoleIds, Result}).

%% @spec retry_match(RoleIds) -> ok
%% RoleIds = [{Rid, SrvId}]
%% @doc 重新匹配
retry_match(RoleIds) ->
    gen_server:cast(?MODULE, {retry_match, RoleIds}).

%% 登陆
login(Role = #role{id = RoleId, combat_pid = CombatPid, event = Event, pos = Pos}) when Event =:= ?event_c_world_compete_11 orelse Event =:= ?event_c_world_compete_22 orelse Event =:= ?event_c_world_compete_33 ->
    WorldCompeteType = case Event of
        ?event_c_world_compete_11 -> ?WORLD_COMPETE_TYPE_11;
        ?event_c_world_compete_22 -> ?WORLD_COMPETE_TYPE_22;
        ?event_c_world_compete_33 -> ?WORLD_COMPETE_TYPE_33
    end,
    case catch center:call(c_world_compete_mgr, check_role_login_status, [WorldCompeteType, RoleId]) of
        {ok, in_matching, RoleId} ->
            gen_server:cast(?MODULE, {reinform_sign_up_success, WorldCompeteType, RoleId}),
            Role;
        {ok, {in_match_map, MapId, X, Y, _LineupId}, RoleId} ->
            %% gen_server:cast(?MODULE, {reinform_enter_combat_area, RoleId}),
            Role#role{cross_srv_id = <<"center">>, pos = Pos#pos{map = MapId, x = X, y = Y}};
        _ -> 
            case is_pid(CombatPid) of
                true -> Role;
                false ->
                    Role#role{event = ?event_no, cross_srv_id = <<>>, pos = Pos#pos{map = 10003, x = 7140, y = 690}}
            end
    end;
login(Role) ->
    Role.

%% @spec role_switch(Role) -> ok
%% Role = #role{}
%% @doc 角色顶号事件处理
role_switch(Role = #role{id = RoleId, combat_pid = CombatPid, event = Event, pos = Pos}) when Event =:= ?event_c_world_compete_11 orelse Event =:= ?event_c_world_compete_22 orelse Event =:= ?event_c_world_compete_33 ->
    WorldCompeteType = case Event of
        ?event_c_world_compete_11 -> ?WORLD_COMPETE_TYPE_11;
        ?event_c_world_compete_22 -> ?WORLD_COMPETE_TYPE_22;
        ?event_c_world_compete_33 -> ?WORLD_COMPETE_TYPE_33
    end,
    case catch center:call(c_world_compete_mgr, check_role_login_status, [WorldCompeteType, RoleId]) of
        {ok, in_matching, RoleId} ->
            gen_server:cast(?MODULE, {reinform_sign_up_success, WorldCompeteType, RoleId}),
            Role;
        {ok, {in_match_map, MapId, X, Y}, RoleId} ->
            Role#role{cross_srv_id = <<"center">>, pos = Pos#pos{map = MapId, x = X, y = Y}};
        _ -> 
            case is_pid(CombatPid) of
                true -> Role;
                false ->
                    Role#role{event = ?event_no, cross_srv_id = <<>>, pos = Pos#pos{map = 10003, x = 7140, y = 690}}
            end
    end;
role_switch(Role) -> Role.

%% 检查活动状态结果通知
%% Result = true | false
check_activity_status_result_inform(Result) ->
    gen_server:cast(?MODULE, {check_activity_status_result_inform, Result}).

%% 获取排行榜数据
get_rank_data(Type, RolePid) ->
    gen_server:cast(?MODULE, {get_rank_data, Type, RolePid}).

%% 获取排行榜上的人物信息
get_rank_role_info(Type, RolePid) ->
    gen_server:cast(?MODULE, {get_rank_role_info, Type, RolePid}).

%% 排行榜数据更新
rank_data_update(CompressedData) ->
    gen_server:cast(?MODULE, {rank_data_update, CompressedData}).

rank_data_update(RankType, CompressedData) ->
    gen_server:cast(?MODULE, {rank_data_update, RankType, CompressedData}).

%% 处理活动结束奖励发放
send_activity_over_rewards(RoleId, Rewards) ->
    gen_server:cast(?MODULE, {send_activity_over_rewards, RoleId, Rewards}).

%% 对手整一组都无法进入战区，则告诉他们的对手
op_enter_prepare_combat_failed(RoleIds) ->
    gen_server:cast(?MODULE, {op_enter_prepare_combat_failed, RoleIds}).

%% 获取仙道会各种类型的已报名次数
get_signup_counts(RoleId) ->
    Types = [?WORLD_COMPETE_TYPE_11, ?WORLD_COMPETE_TYPE_22, ?WORLD_COMPETE_TYPE_33],
    L = [{Type, get_today_sign_up_count(Type, RoleId)} || Type <- Types],
    role_group:pack_send(RoleId, 16006, {L}).

%% 发起战斗结果通知
start_combat_result_inform(RoleId, Result) ->
    gen_server:cast(?MODULE, {start_combat_result_inform, RoleId, Result}).

%% 重新通知进入战区的信息
reinform_enter_combat_area(RoleId) ->
    gen_server:cast(?MODULE, {reinform_enter_combat_area, RoleId}).

%% 开启报名限制
open_sign_up_limit() ->
    gen_server:cast(?MODULE, open_sign_up_limit).

%% 关闭报名限制
close_sign_up_limit() ->
    gen_server:cast(?MODULE, close_sign_up_limit).

%% 获取每日最佳战绩
get_mark_day(RolePid) ->
    gen_server:cast(?MODULE, {get_mark_day, RolePid}).

%% 获取今天的已报名次数
get_today_sign_up_count(WorldCompeteType, RoleId) ->
    case sys_env:get(get_limit_dict_name(WorldCompeteType)) of
        {PrevTime, L} ->
            Now = util:unixtime(),
            case util:is_same_day2(Now, PrevTime) of
                true ->
                    case lists:keyfind(RoleId, 1, L) of
                        {RoleId, Count} -> Count;
                        _ -> 0
                    end;
                false ->
                    0
            end;
        _ -> 0
    end.

%% 处理每日段位奖励发放
send_day_section_rewards(CompressedData) ->
    gen_server:cast(?MODULE, {send_day_section_rewards, CompressedData}).

%% 获取每日段位奖励信息 -> {DayLilian, DayAttainment, 是否可领取 = ?true|?false}
get_day_section_reward_info(RoleId) ->
    case sys_env:get(world_compete_day_section_rewards) of
        L = [_|_] ->
            Now = util:unixtime(),
            case lists:keyfind(RoleId, 1, L) of
                {RoleId, {DayLilian, DayAttainment, _ItemRewards, Deadline, ?true}} when Now =< Deadline -> %% 还没领取且还没超时就可以领取了
                    {DayLilian, DayAttainment, ?true};
                _ ->
                    {0, 0, ?false}
            end;
        _ ->
            {0, 0, ?false}
    end.

%% 段位等级变化通知
section_lev_change_inform(RoleId, Name, SectionLevChanged, SectionLev) ->
    gen_server:cast(?MODULE, {section_lev_change_inform, RoleId, Name, SectionLevChanged, SectionLev}).

%% 段位积分变更通知
section_mark_change_inform(RoleId, Name, SectionMark, SectionLev, OldSectionMark, OldSectionLev) ->
    gen_server:cast(?MODULE, {section_mark_change_inform, RoleId, Name, SectionMark, SectionLev, OldSectionMark, OldSectionLev}).

%% 领取每日段位赛奖励
get_day_section_reward(RoleId, RolePid) ->
    gen_server:cast(?MODULE, {get_day_section_reward, RoleId, RolePid}).

%% 检查跨服队友的报名限制 -> true | false
%% TODO：暂时先这样处理，之后要把这个和rpc那里的c_lookup整合成一个方法，就不用调用2次了
is_cross_teammate_reached_signup_limit(WorldCompeteType, RoleId = {_Rid, SrvId}) ->
    case role_api:is_local_role(RoleId) of
        true -> false; %% 交由原来的逻辑去判断
        false ->
            case catch center:call(SrvId, world_compete_mgr, check_cross_teammate_signup_limit, [WorldCompeteType, RoleId]) of
                true -> true;
                {false, _} -> false;
                _Err ->
                    ?ERR("检查跨服队友[~w, ~s]的报名限制时出错:~w", [_Rid, SrvId, _Err]),
                    true
            end
    end.
check_cross_teammate_signup_limit(WorldCompeteType, RoleId) ->
    gen_server:call(?MODULE, {check_cross_teammate_signup_limit, WorldCompeteType, RoleId}).

%% 选择阵法
change_lineup(WorldCompeteType, RoleId, LineupId) ->
    gen_server:cast(?MODULE, {change_lineup, WorldCompeteType, RoleId, LineupId}).

%% 阵法变化通知
change_lineup_result_inform(Result, RoleId, LineupId) ->
    gen_server:cast(?MODULE, {change_lineup_result_inform, Result, RoleId, LineupId}).
            

%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    put(sign_up_limit, true),
    put(rank_world_compete_win_count_today, []),
    put(rank_world_compete_win_count_yesterday, []),
    State = #state{is_started = false},
    dets:open_file(rank_world_compete_win_count_today, [{file, "../var/rank_world_compete_win_count_today.dets"}, {keypos, #rank_world_compete_win_day.id}, {type, set}]),
    load_marks(),
    center:cast(c_world_compete_mgr, check_activity_status, [sys_env:get(srv_id)]),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, State}.

handle_call({check_cross_teammate_signup_limit, WorldCompeteType, RoleId}, _From, State) ->
    case is_reached_sign_up_limit(WorldCompeteType, RoleId) of
        true ->
            {reply, true, State};
        {false, Num} ->
            {reply, {false, Num}, State}
    end;

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(print_current_status, State = #state{is_started = IsStarted, current_period = CurrentPeriod}) ->
    CanOpen = can_open(),
    ?INFO("当前仙道会状态：能否开启=~w, 是否开启=~w, 所处阶段=~w", [CanOpen, IsStarted, CurrentPeriod]),
    {noreply, State};

handle_cast({get_current_status, RolePid}, State = #state{is_started = IsStarted}) ->
    case can_open() of
        true ->
            case IsStarted of
                true -> role:pack_send(RolePid, 16000, {?true, ?true});
                false -> role:pack_send(RolePid, 16000, {?true, ?false})
            end;
        false ->
            role:pack_send(RolePid, 16000, {?false, ?false})
    end,
    {noreply, State};

%% 活动状态通知
handle_cast({check_activity_status_result_inform, Result}, State) ->
    case Result of
        true -> {noreply, State#state{is_started = true}};
        _ -> {noreply, State#state{is_started = false}}
    end;

handle_cast(prepare_start, State = #state{is_started = false}) ->
    case can_open() of
        true ->
            ?INFO("仙道会即将开始"),
            notice:send(54, ?L(<<"天下第一仙道会即将开始，达到要求的飞仙同道可点击仙道会图标报名">>));
        false -> ignore
    end,
    {noreply, State};

handle_cast({start_activity, CurrentPeriod1}, State = #state{is_started = true, current_period = CurrentPeriod2}) when CurrentPeriod1 =/= CurrentPeriod2 ->
    ?INFO("当前仙道会状态与中央服不一致，使用中央服的替代"),
    {noreply, State#state{current_period = CurrentPeriod1}};
handle_cast({start_activity, CurrentPeriod}, State = #state{is_started = true, current_period = CurrentPeriod}) ->
    ?INFO("仙道会已经处于开启阶段，不需要重复开启"),
    {noreply, State};
handle_cast({start_activity, CurrentPeriod}, State = #state{is_started = false}) ->
    case can_open() of
        true ->
            ?INFO("仙道会开始报名"),
            %% 通知全部玩家报名开始
            notice:send(54, ?L(<<"天下第一仙道会正式开始，各位飞仙同道可点击仙道会图标报名，{open, 25, 我要参加, #00ff24}">>)),
            role_group:pack_cast(world, 16000, {?true, ?true}),
            clear_sign_up_limit(),
            {noreply, State#state{is_started = true, current_period = CurrentPeriod}};
        false ->
            ?INFO("不符合条件，仙道会不能开始"),
            {noreply, State}
    end;

handle_cast(stop_activity, State = #state{is_started = false}) ->
    ?DEBUG("仙道会已经处于关闭阶段，不需要重复关闭"),
    {noreply, State};
handle_cast(stop_activity, State = #state{is_started = true}) ->
    ?DEBUG("仙道会关闭"),
    %% 保存每日战绩
    lists:foreach(fun(Mark) ->
                dets:insert(rank_world_compete_win_count_today, Mark)
        end, get(rank_world_compete_win_count_today)),

    %% 通知全部玩家报名结束
    role_group:pack_cast(world, 16000, {?true, ?false}),
    notice:send(54, ?L(<<"天下第一仙道会已经结束，请等待下次开启仙道会">>)),
    {noreply, State#state{is_started = false}};

handle_cast(open_sign_up_limit, State) ->
    put(sign_up_limit, true),
    {noreply, State};

handle_cast(close_sign_up_limit, State) ->
    put(sign_up_limit, false),
    {noreply, State};

handle_cast({sign_up, WorldCompeteType, SignupRoles}, State = #state{is_started = true}) ->
    %% ?DEBUG("收到类型[~w]的报名请求:~w", [WorldCompeteType, SignupRoles]),
    IsRightTime = case get(sign_up_limit) of
        false -> true;
        true -> is_right_time(WorldCompeteType)
    end,
    case IsRightTime of
        true ->
            do_all_signup(WorldCompeteType, SignupRoles, SignupRoles);
        _ ->
            Reason = case WorldCompeteType of
                ?WORLD_COMPETE_TYPE_11 -> ?L(<<"单人模式只在16:00~17:00, 21:30~22:30时段开放，请准时参加哟！">>);
                ?WORLD_COMPETE_TYPE_22 -> ?L(<<"双人模式只在16:00~17:00, 21:30~22:30时段开放，请准时参加哟！">>);
                _ -> ?L(<<"三人模式只在17:00~18:00, 22:30~23:30时段开放，请准时参加哟！">>)
            end,
            lists:foreach(fun(#sign_up_role{id = RoleId}) ->
                        role_group:pack_send(RoleId, 16001, {WorldCompeteType, ?false, Reason})
                end, SignupRoles)
    end,
    {noreply, State};
handle_cast({sign_up, WorldCompeteType, SignupRoles}, State) ->
    lists:foreach(fun(#sign_up_role{id = RoleId}) ->
                role_group:pack_send(RoleId, 16001, {WorldCompeteType, ?false, ?L(<<"仙道会已经关闭，请下次再报名">>)})
            end, SignupRoles),
    {noreply, State};

handle_cast({sign_up_result_inform, RoleIds, Result}, State) ->
    do_signup_result_inform(RoleIds, Result),
    {noreply, State};

handle_cast({op_enter_prepare_combat_failed, RoleIds}, State) ->
    lists:foreach(fun(RoleId) ->
                notice(RoleId, ?L(<<"你的对手进入战斗区域失败">>))
            end, RoleIds),
    {noreply, State};

handle_cast({get_day_section_reward, RoleId, RolePid}, State) ->
    case sys_env:get(world_compete_day_section_rewards) of
        L = [_|_] ->
            Now = util:unixtime(),
            case lists:keyfind(RoleId, 1, L) of
                {RoleId, {DayLilian, DayAttainment, ItemRewards, Deadline, ?true}} when Now =< Deadline -> %% 还没领取且还没超时就可以领取了
                    L1 = lists:keydelete(RoleId, 1, L),
                    sys_env:save(world_compete_day_section_rewards, L1),
                    Items = [#gain{label = item, val = [ItemBaseId, Bind, Quantity]} || {ItemBaseId, Bind, Quantity} <- ItemRewards],
                    case catch role:apply(sync, RolePid, {fun do_get_day_section_reward/4, [DayAttainment, DayLilian, ItemRewards]}) of
                        true ->
                            ItemMsg = items_to_msg(ItemRewards),
                            Msg = case ItemMsg of
                                <<>> ->
                                    util:fbin(<<"领取成功：阅历~w，历练~w">>, [DayAttainment, DayLilian]);
                                _ ->
                                    util:fbin(<<"领取成功：阅历~w，历练~w，~s">>, [DayAttainment, DayLilian, ItemMsg])
                            end,    
                            role:pack_send(RolePid, 16013, {?true, Msg}),
                            GL = [#gain{label = attainment, val = DayAttainment}, #gain{label = lilian, val = DayLilian}] ++ Items,
                            notice:inform(RolePid, notice_inform:gain_loss(GL, ?L(<<"仙道会段位奖励">>)));
                        _Err ->
                            role:pack_send(RolePid, 16013, {?false, ?L(<<"领取失败">>)})
                    end;
                {RoleId, {_, _, Deadline, ?true}} when Now > Deadline ->
                    role:pack_send(RolePid, 16013, {?false, ?L(<<"超过领取时间，不能再领取了">>)});
                _ ->
                    role:pack_send(RolePid, 16013, {?false, ?L(<<"没有可以领取的奖励">>)})
            end;
        _ ->
            role:pack_send(RolePid, 16013, {?false, ?L(<<"没有可以领取的奖励">>)})
    end,
    {noreply, State};

%%-------------------------------
%% 取消匹配相关
%%-------------------------------
handle_cast({cancel_match, WorldCompeteType, RoleIds}, State) ->
    center:cast(c_world_compete_mgr, cancel_match, [WorldCompeteType, RoleIds]),
    {noreply, State};

handle_cast({cancel_match_result_inform, RoleIds, Result}, State) ->
    do_cancel_match_result_inform(RoleIds, Result),
    {noreply, State};

%% 重新匹配
handle_cast({retry_match, RoleIds}, State) ->
    lists:foreach(fun(RoleId) ->
                %% TODO:这里不知道为何发不到给跨服组队的队友
                %% role_api:c_pack_send(RoleId, 16002, {1, ?true, ?L(<<"重新匹配成功">>)})
                role_group:pack_send(RoleId, 16002, {1, ?true, ?L(<<"重新匹配成功">>)})
        end, RoleIds),
    {noreply, State};

handle_cast({reinform_sign_up_success, WorldCompeteType, RoleId}, State) ->
    role_group:pack_send(RoleId, 16001, {WorldCompeteType, ?true, ?L(<<"报名成功">>)}),
    {noreply, State};

handle_cast({reinform_enter_combat_area, RoleId}, State) ->
    case get({enter_combat_area_time, RoleId}) of
        {Time1, PrepareCombatTime1, {_, TeammatePower, OpsPower, PreLilian, PreSectionMark, Lineups, LineupId, TotalPower, MorePower, Group, GroupMsg}} ->
            Time = util:check_range(Time1 + PrepareCombatTime1 - util:unixtime(), 0, PrepareCombatTime1),
            Msg = {Time * 1000, TeammatePower, OpsPower, PreLilian, PreSectionMark, Lineups, LineupId, TotalPower, MorePower, Group, GroupMsg},
            role_group:pack_send(RoleId, 16003, Msg);
        _ -> ignore
    end,
    {noreply, State};

%% 中央服通知匹配结果
handle_cast({match_result_inform, RoleIds, Result}, State) ->
    case Result of
        {true, WorldCompeteType, PrepareCombatTime, MapId, X, Y, MapPid, TeammatePower, OpsPower, PreLilian, PreSectionMark, TotalPower, MorePower, Group, Lineups} ->
            lists:foreach(fun(RoleId = {Rid, SrvId}) ->
                        case cross_util:is_local_srv(SrvId) of
                            true ->
                                %% 防止被刷，所以还是在这里增加次数
                                add_to_sign_up_limit(WorldCompeteType, RoleId),
                                case role_api:lookup(by_id, RoleId, [#role.pid]) of
                                    {ok, _, [RolePid]} ->
                                        Msg = {PrepareCombatTime, TeammatePower, OpsPower, PreLilian, PreSectionMark, Lineups, 0, TotalPower, MorePower, Group, world_compete_group_to_msg(Group)},
                                        put({enter_combat_area_time, RoleId}, {util:unixtime(), round(PrepareCombatTime/1000), Msg}),
                                        catch role:apply(async, RolePid, {fun do_enter_prepare_combat/6, [MapId, X, Y, MapPid, Msg]});
                                    _Err2 ->
                                        ?ERR("[~w, ~s]进入仙道会战斗区域失败，查找角色时错误:~w", [Rid, SrvId, _Err2])
                                end;
                            false -> ignore
                        end
                    end, RoleIds);
        _Err3 ->
            ?ERR("[~w]匹配失败，中央服返回结果:~w", [RoleIds, _Err3]),
            lists:foreach(fun(RoleId) ->
                        notice(RoleId, ?L(<<"匹配失败">>))
                    end, RoleIds)
    end,
    {noreply, State};

handle_cast({combat_result_inform, CombatResult, WorldCompeteType, RoleId, Rewards, MarkBin}, State) ->
    do_combat_result_inform(CombatResult, WorldCompeteType, RoleId, Rewards, MarkBin),
    {noreply, State};

handle_cast({rank_data_update, CompressedData}, State) ->
    case catch binary_to_term(CompressedData) of
        [RankWinRateGlobal, RankLilianGlobal, RankWinRateLocal, RankLilianLocal, RankSectionLocal] ->
            case format_rank_data(RankWinRateGlobal, []) of
                Rank1 = [_|_] -> rank_mgr:async({update_world_compete_rank_data, ?rank_cross_world_compete_winrate, Rank1});
                _ -> ignore
            end,
            case format_rank_data(RankWinRateLocal, []) of
                Rank2 = [_|_] -> rank_mgr:async({update_world_compete_rank_data, ?rank_world_compete_winrate, Rank2});
                _ -> ignore
            end,
            case format_rank_data(RankLilianGlobal, []) of
                Rank3 = [_|_] -> rank_mgr:async({update_world_compete_rank_data, ?rank_cross_world_compete_lilian, Rank3});
                _ -> ignore
            end,
            case format_rank_data(RankLilianLocal, []) of
                Rank4 = [_|_] -> rank_mgr:async({update_world_compete_rank_data, ?rank_world_compete_lilian, Rank4});
                _ -> ignore
            end,
            case format_rank_data(RankSectionLocal, []) of
                Rank5 = [_|_] -> rank_mgr:async({update_world_compete_rank_data, ?rank_world_compete_section, Rank5});
                _ -> ignore
            end;
        _ -> ?ERR("中央服传回来的仙道会排行榜数据无法解压:~w", [CompressedData])
    end,
    {noreply, State};

handle_cast({rank_data_update, RankType, CompressedData}, State)
when RankType =:= ?rank_platform_world_compete_winrate 
orelse RankType =:= ?rank_platform_world_compete_lilian
orelse RankType =:= ?rank_platform_world_compete_section
->
    case catch binary_to_term(CompressedData) of
        Ranks when is_list(Ranks) ->
            %% ?DEBUG("收到中央服更新仙道会排行榜数据:\n排行榜类型:~w\n数据:~w", [RankType, Ranks]),
            case format_rank_data(Ranks, []) of
                Rank = [_|_] -> rank_mgr:async({update_world_compete_rank_data, RankType, Rank});
                _ -> ignore
            end;
        _ -> ?ERR("中央服传回来的仙道会排行榜数据无法解压:~w", [CompressedData])
    end,
    {noreply, State};

handle_cast({rank_data_update, _RankType = ?rank_platform_world_compete_win_today, CompressedData}, State) ->
    case catch binary_to_term(CompressedData) of
        Ranks when is_list(Ranks) ->
            ?INFO("收到中央服更新仙道会当日战绩数据:~w", [length(Ranks)]),
            case format_rank_data2(Ranks, []) of
                L = [_|_] ->
                    put(rank_world_compete_win_count_today, L);
                _ -> ignore
            end;
        _ -> ?ERR("中央服传回来的仙道会当日战绩数据无法解压:~w", [CompressedData])
    end,
    {noreply, State};

handle_cast({rank_data_update, _RankType = ?rank_platform_world_compete_win_yesterday, CompressedData}, State) ->
    case catch binary_to_term(CompressedData) of
        Ranks when is_list(Ranks) ->
            ?INFO("收到中央服更新仙道会昨日战绩数据:~w", [length(Ranks)]),
            case format_rank_data2(Ranks, []) of
                L = [_|_] ->
                    %% 收到昨日MVP数据表示要清掉当日战绩榜
                    put(rank_world_compete_win_count_today, []),
                    sys_env:save(rank_world_compete_win_count_yesterday, L);
                _ -> ignore
            end;
        _ -> ?ERR("中央服传回来的仙道会昨日战绩数据无法解压:~w", [CompressedData])
    end,
    {noreply, State};

handle_cast({get_rank_data, {rank_win_rate, Type}, RolePid}, State) ->
    %% ?DEBUG("仙道会胜率榜数据:~w", [get(rank_win_rate)]),
    role:pack_send(RolePid, 16012, {get({rank_win_rate, Type})}),
    {noreply, State};
handle_cast({get_rank_data, {rank_lilian, Type}, RolePid}, State) ->
    %% ?DEBUG("仙道会历练榜数据:~w", [get(rank_lilian)]),
    role:pack_send(RolePid, 16013, {get({rank_lilian, Type})}),
    {noreply, State};

handle_cast({get_rank_role_info, {RankType, Type, RoleId = {Rid, SrvId}}, RolePid}, State) ->
    case get({RankType, Type}) of
        L = [_|_] ->
            case lists:keyfind(RoleId, #world_compete_mark.id, L) of
                #world_compete_mark{name = Name, career = Career, sex = Sex, lev = Lev, looks = Looks, eqm = Eqm} ->
                    role:pack_send(RolePid, 16014, {Rid, SrvId, Name, Career, Lev, Sex, Eqm, Looks});
                _ -> ignore
            end;
        _ -> ignore
    end,            
    {noreply, State};

handle_cast({send_activity_over_rewards, RoleId, Rewards}, State) ->
    mail_mgr:deliver(RoleId, {?L(<<"仙道会胜利奖励">>), ?L(<<"您在本次仙道会中成绩卓著，获得了以下奖励，请查收">>), [], Rewards}),
    {noreply, State};

%% 每日段位奖励保存在sys_env里（:D~方便啊啊哈哈哈）
handle_cast({send_day_section_rewards, CompressedData}, State) ->
    ?INFO("收到中央服传回来的仙道会每日段位奖励"),
    case catch binary_to_term(CompressedData) of
        [DaySectionRewards, SeasonOverRewards, SeasonOverTopRewards] ->
            %% 保存奖励
            Deadline = (util:unixtime(today) + 86400),
            Rewards = [{RoleId, {DayLilian, DayAttainment, ItemRewards, Deadline, ?true}} || {RoleId, _SectionLev, DayLilian, DayAttainment, ItemRewards} <- DaySectionRewards],
            sys_env:save(world_compete_day_section_rewards, Rewards),

            %% 发放称号
            case gen_honors(DaySectionRewards, []) of
                Honors = [_|_] ->
                    honor_mgr:replace_honor_gainer(world_compete_section_lev, Honors);
                _ -> ignore
            end,

            %% 发放段位赛每月奖励（根据等级定奖品）
            case SeasonOverRewards of
                [_|_] ->
                    lists:foreach(fun({RoleId, _SectionLev, SeasonRewards}) ->
                                case SeasonRewards of
                                    [_|_] ->
                                        mail_mgr:deliver(RoleId, {?L(<<"仙道会段位赛每季奖励">>), ?L(<<"恭喜您在仙道会段位赛中表现出色，以此鼓励。请注意，段位等级将会重置。">>), [], SeasonRewards});
                                    _ -> ignore
                                end
                        end, SeasonOverRewards);
                _ -> ignore
            end,
            
            %% 发放段位赛每月奖励（根据排名定奖品）
            case SeasonOverTopRewards of
                [_|_] ->
                    lists:foreach(fun({RoleId, SeasonTopRewards}) ->
                                case SeasonTopRewards of
                                    [_|_] ->
                                        mail_mgr:deliver(RoleId, {?L(<<"仙道会段位赛每季排名奖励">>), ?L(<<"恭喜您在仙道会段位赛中名列前茅，以此鼓励。">>), [], SeasonTopRewards});
                                    _ -> ignore
                                end
                        end, SeasonOverTopRewards);
                _ -> ignore
            end;
        _ -> ?ERR("中央服传回来的仙道会每日段位奖励数据无法解压:~w", [CompressedData])
    end,
    {noreply, State};

%% 角色主动点按钮退出
handle_cast({leave_area, RoleId, RolePid}, State) ->
    %% 不允许未倒数完就点退出
    case get({enter_combat_area_time, RoleId}) of
        {EnterCombatAreaTime, PrepareCombatTime, _} ->
            case util:unixtime() - EnterCombatAreaTime > PrepareCombatTime of
                true ->
                    case catch role:apply(sync, RolePid, {fun do_leave_prepare_combat/1, []}) of
                        true ->
                            %% center:cast(c_world_compete_mgr, force_leave_prepare_combat, [RoleId]);
                            ok;
                        _Err ->
                            ?ERR("[~w]强制离开仙道会战区失败:~w", [RoleId, _Err])
                    end;
                false -> notice(RolePid, ?L(<<"不能中途离场">>))
            end;
        _ ->
            case catch role:apply(sync, RolePid, {fun do_leave_prepare_combat/1, []}) of
                true ->
                    %% center:cast(c_world_compete_mgr, force_leave_prepare_combat, [RoleId]);
                    ok;
                _Err ->
                    ?ERR("[~w]强制离开仙道会战区失败:~w", [RoleId, _Err])
            end
    end,
    {noreply, State};


handle_cast({start_combat_result_inform, RoleId, Result}, State) ->
    case Result of
        true -> ignore;
        {false, just_failed} ->
            notice(RoleId, ?L(<<"当前超时空通道不稳定，发起战斗失败了">>));
        {false, op_leave} ->
            notice(RoleId, ?L(<<"很可惜，您的对手离场或者掉线，无法参与战斗">>));
        _ -> ignore
    end,
    {noreply, State};

handle_cast({get_mark_day, RolePid}, State) ->
    MarkToday = case get(rank_world_compete_win_count_today) of
        L1 = [_|_] -> L1;
        _ -> []
    end,
    MvpToday = case MarkToday of
        [H|_] -> [H];
        _ -> []
    end,
    MvpYesterday = case sys_env:get(rank_world_compete_win_count_yesterday) of
        L2 = [_|_] -> L2;
        _ -> []
    end,
    Msg = {MarkToday, MvpToday, MvpYesterday},
    role:pack_send(RolePid, 16012, Msg),
    {noreply, State};

handle_cast({section_lev_change_inform, RoleId, Name, SectionLevChanged, SectionLev}, State) ->
    %% 升段通知
    case SectionLevChanged > 0 of
        true -> section_lev_up_cast(RoleId, Name, SectionLev);
        false -> ignore
    end,
    {noreply, State};

handle_cast({section_mark_change_inform, RoleId, Name, SectionMark, SectionLev, OldSectionMark, OldSectionLev}, State) ->
    %% 记录日志
    log:log(log_world_compete_section, {RoleId, Name, SectionMark, SectionLev, OldSectionMark, OldSectionLev}),
    {noreply, State};

%%-------------------------------
%% 阵法相关
%%-------------------------------
handle_cast({change_lineup, WorldCompeteType, RoleId, LineupId}, State) ->
    center:cast(c_world_compete_mgr, change_lineup, [WorldCompeteType, RoleId, LineupId]),
    {noreply, State};

handle_cast({change_lineup_result_inform, true, RoleId, LineupId}, State) ->
    role_group:pack_send(RoleId, 16014, {?true, <<"选择阵法成功">>, LineupId}),
    {noreply, State};
handle_cast({change_lineup_result_inform, false, RoleId, OldLineupId}, State) ->
    role_group:pack_send(RoleId, 16014, {?false, <<"选择阵法失败">>, OldLineupId}),
    {noreply, State};

handle_cast(_Msg, State) ->
    ?ERR("收到未知消息: ~w", [_Msg]),
    {noreply, State}.

%% 中央服通知退出
handle_info({leave_area, RoleId}, State) ->
    case role_api:lookup(by_id, RoleId, [#role.pid]) of
        {ok, _, [RolePid]} ->
            role:apply(sync, RolePid, {fun do_leave_prepare_combat/1, []});
        _Err -> ?ERR("[~w]退出仙道会战区时出错:~w", [RoleId, _Err])
    end,
    {noreply, State};

handle_info(_Info, State) ->
    %% ?ERR("收到未知消息: ~w", [Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% 是否过了开服指定天数 -> true | false
can_open() ->
    case sys_env:get(srv_open_time) of
        SrvOpenTime when is_integer(SrvOpenTime) ->
            util:unixtime() - SrvOpenTime >= ?OPEN_TIME;
        _Other ->
            ?ERR("未设置正确的开服时间[~w]，无法开启仙道会", [_Other]),
            false
    end.

%% 角色报名
do_all_signup(WorldCompeteType, SignupRoles, []) -> center:cast(c_world_compete_mgr, sign_up, [WorldCompeteType, SignupRoles]);
do_all_signup(WorldCompeteType, SignupRoles, [SignupRole = #sign_up_role{id = RoleId}|T]) ->
    case is_reached_sign_up_limit(WorldCompeteType, RoleId) of
        true ->
            role_group:pack_send(RoleId, 16001, {WorldCompeteType, ?false, util:fbin(?L(<<"你今天的报名次数已满~w次">>), [?SIGN_UP_MAX_NUM])}),
            lists:foreach(fun(#sign_up_role{id = OtherRoleId}) ->
                        role_group:pack_send(OtherRoleId, 16001, {WorldCompeteType, ?false, util:fbin(?L(<<"队友今天的报名次数已满~w次">>), [?SIGN_UP_MAX_NUM])})
                end, SignupRoles -- [SignupRole]);
        {false, _} ->
            do_all_signup(WorldCompeteType, SignupRoles, T)
    end.

%% 处理报名结果通知
do_signup_result_inform([], _) -> ok;
do_signup_result_inform([RoleId = {Rid, SrvId}|T], Result) ->
    case Result of
        {true, WorldCompeteType} ->
            case role_api:is_local_role(RoleId) of
                true ->
                    case role_api:lookup(by_id, RoleId, [#role.pid]) of
                        {ok, _, [RolePid]} when is_pid(RolePid) ->
                            case catch role:apply(sync, RolePid, {fun do_signup_success/2, [WorldCompeteType]}) of
                                true ->
                                    role:pack_send(RolePid, 16001, {WorldCompeteType, ?true, ?L(<<"报名成功">>)});
                                false ->
                                    ?ERR("[~w, ~s]报名[Type=~w]成功后修改角色event失败:false，取消报名", [Rid, SrvId, WorldCompeteType]),
                                    center:cast(c_world_compete_mgr, cancel_match, [WorldCompeteType, [RoleId]]),
                                    role:pack_send(RolePid, 16001, {WorldCompeteType, ?true, ?L(<<"报名失败，请重新报名">>)});
                                _Err ->
                                    ?ERR("[~w, ~s]报名[Type=~w]成功后修改角色event失败:~w，取消报名", [Rid, SrvId, WorldCompeteType, _Err]),
                                    center:cast(c_world_compete_mgr, cancel_match, [WorldCompeteType, [RoleId]]),
                                    role:pack_send(RolePid, 16001, {WorldCompeteType, ?true, ?L(<<"报名失败，请重新报名">>)})
                            end;
                        _ ->
                            ?ERR("[~w]报名成功后修改角色event失败，查找不到角色", [RoleId])
                    end;
                false -> ?DEBUG("[~w, ~s]是跨服角色，不处理", [Rid, SrvId])
            end;
        {false, WorldCompeteType, in_matching} ->
            role_group:pack_send(RoleId, 16001, {WorldCompeteType, ?false, ?L(<<"已经报过名了">>)});
        {false, WorldCompeteType, in_match_map} ->
            role_group:pack_send(RoleId, 16001, {WorldCompeteType, ?false, ?L(<<"已经匹配成功，不能再报名">>)});
        _ ->
            ?ERR("报名失败，中央服返回：~w", [Result])
    end,
    do_signup_result_inform(T, Result).

%% 报名成功修改角色事件
do_signup_success(Role = #role{event = ?event_no, combat_pid = CombatPid}, WorldCompeteType) when not is_pid(CombatPid) ->
    Event = world_compete_type_to_event(WorldCompeteType),
    Role1 = Role#role{event = Event},
    {ok, true, Role1};
do_signup_success(Role = #role{event = _Event, combat_pid = _CombatPid}, _WorldCompeteType) ->
    ?ERR("角色当前状态为：Event=~w, CombatPid=~w, WorldCompeteType=~w", [_Event, _CombatPid, _WorldCompeteType]),
    {ok, false, Role};
do_signup_success(Role, _) ->
    {ok, false, Role}.

%% 处理取消报名结果通知
do_cancel_match_result_inform([], _) -> ok;
do_cancel_match_result_inform([RoleId = {_Rid, _SrvId}|T], Result) ->
    case Result of
        true ->
            case role_api:is_local_role(RoleId) of
                true ->
                    case role_api:lookup(by_id, RoleId, [#role.pid]) of
                        {ok, _, [RolePid]} ->
                            case catch role:apply(sync, RolePid, {fun do_signup_cancel/1, []}) of
                                true -> role:pack_send(RolePid, 16002, {0, ?true, <<>>});
                                _ -> role:pack_send(RolePid, 16002, {0, ?false, ?L(<<"取消报名失败">>)})
                            end;
                        _Err ->
                            ?ERR("[~w]取消匹配失败:~w", [RoleId, _Err]),
                            role_group:pack_send(RoleId, 16002, {0, ?false, ?L(<<"取消报名失败">>)})
                    end;
                false -> ?DEBUG("[~w, ~s]是跨服角色，不处理", [_Rid, _SrvId])
            end;
        {false, matched} ->
            role_group:pack_send(RoleId, 16002, {0, ?false, ?L(<<"取消报名失败，已经匹配上了，请耐心等待">>)});
        _ ->
            role_group:pack_send(RoleId, 16002, {0, ?false, ?L(<<"取消报名失败">>)})
    end,
    do_cancel_match_result_inform(T, Result).

do_signup_cancel(Role = #role{event = Event}) when Event =:= ?event_c_world_compete_11 orelse Event =:= ?event_c_world_compete_22 orelse Event =:= ?event_c_world_compete_33 ->
    {ok, true, Role#role{event = ?event_no}};
do_signup_cancel(Role) ->
    {ok, true, Role}.

%% 角色进入战区
do_enter_prepare_combat(Role = #role{pid = RolePid, name = _Name, event = Event}, MapId, X, Y, MapPid, Msg) when Event =:= ?event_c_world_compete_11 orelse Event =:= ?event_c_world_compete_22 orelse Event =:= ?event_c_world_compete_33 ->
    case catch map:role_enter(MapId, X, Y, Role#role{cross_srv_id = <<"center">>}) of
        {ok, NewRole} -> 
            ?DEBUG("[~s]进入战斗区域成功, MapPid=~w", [_Name, MapPid]),
            role:pack_send(RolePid, 16003, Msg),
            {ok, NewRole#role{event_pid = MapPid}};
        {false, _Why} -> 
            ?ERR("[~s]进入战斗区域失败:~s", [_Name, _Why]),
            notice(RolePid, ?L(<<"进入战区失败，请在原地耐心等待战斗发起">>)),
            {ok, Role};
        _Other ->
            ?ERR("[~s]进入战斗区域失败:~w", [_Name, _Other]),
            notice(RolePid, ?L(<<"进入战区失败，请在原地耐心等待战斗发起">>)),
            {ok, Role}
    end;
do_enter_prepare_combat(Role = #role{pid = RolePid, name = _Name, event = Event}, _, _, _, _, _) ->
    ?ERR("[~s]进入战斗区域失败: Event=~w", [_Name, Event]),
    notice(RolePid, ?L(<<"进入战区失败，请在原地耐心等待战斗发起">>)),
    {ok, Role}.

%% 角色离开战区
do_leave_prepare_combat(Role = #role{name = _Name, event = _Event})  ->
    case catch map:role_enter(10003, 7140, 690, Role#role{cross_srv_id = <<>>}) of
        {ok, NewRole} -> 
            ?DEBUG("[~s]离开仙道会战斗区域成功", [_Name]),
            campaign_task:listener(NewRole, world_compete, 1),
            {ok, true, NewRole#role{event = ?event_no, event_pid = 0, cross_srv_id = <<>>}};
        {false, _Why} -> 
            ?ERR("[~s]离开仙道会战斗区域失败:~s", [_Name, _Why]),
            {ok, false, Role};
        _Other ->
            ?ERR("[~s]离开仙道会战斗区域失败:~w", [_Name, _Other]),
            {ok, false, Role}
    end.

%% 通知每个参战的角色仙道会比赛结果
do_combat_result_inform(CombatResult, WorldCompeteType, RoleId, Rewards, MarkBin) when is_binary(MarkBin) ->
    M = case binary_to_term(MarkBin) of
        Mark when is_record(Mark, world_compete_mark) -> Mark;
        _ -> #world_compete_mark{}
    end,
    do_combat_result_inform(CombatResult, WorldCompeteType, RoleId, Rewards, M);
do_combat_result_inform(CombatResult, WorldCompeteType, RoleId = {Rid, SrvId}, Rewards, Mark = #world_compete_mark{name = Name, combat_count = CombatCount, win_rate = WinRate, continuous_win_count = CwinCount}) ->
    %% ?DEBUG("收到中央服的仙道会战斗结果通知：~w, [~w, ~s], ~w, ~w", [CombatResult, _Rid, _SrvId, Rewards, _WinCnt]),
    Exp = round(combat_util:match_param(exp, Rewards, 0)),
    Lilian = round(combat_util:match_param(lilian, Rewards, 0)),
    AddtLilian = round(combat_util:match_param(addt_lilian, Rewards, 0)),
    NewLilian = case campaign_adm:is_camp_time(world_compete) of %% 后台开启双倍积分
        true -> Lilian * 2;
        _ -> Lilian
    end,
    SectionMark = round(combat_util:match_param(section_mark, Rewards, 0)),
    case role_api:lookup(by_id, RoleId, [#role.event, #role.pos, #role.pid]) of
        {ok, _, [Event, #pos{map = MapId}, RolePid]} when (Event =:= ?event_c_world_compete_11 orelse Event =:= ?event_c_world_compete_22 orelse Event =:= ?event_c_world_compete_33) andalso MapId > 100000 ->
            role:apply(async, RolePid, {world_compete_medal, recalc_medal, [Mark]}), %% 通知角色进程重新计算仙道会勋章
            role_group:pack_send(RoleId, 16004, {CombatResult, [{0, 0, Exp}, {3, 0, NewLilian}, {5, 0, AddtLilian}, {6, 0, SectionMark}], ?LEAVE_AREA_TIMEOUT});
        _ -> ignore
    end,
    %% 胜率和连胜率广播
    case CwinCount >= 5 of
        true -> notice:send(53, util:fbin(?L(<<"天下第一，仙道争雄！~s在仙道会中连续~w次击败了对手，实在是战略无双，仙法超群！">>), [notice:role_to_msg({Rid, SrvId, Name}), CwinCount]), [?PREPARE_COMBAT_MAP_BASE_ID]);
        false -> ignore
    end,
    case CombatCount >= 20 andalso WinRate >= 75 of
        true -> notice:send(53, util:fbin(?L(<<"~s实力超群，多次与对手仙道斗法，最终击败了其他飞仙同道，达到~w%的胜率，天下第一，指日可待！">>), [notice:role_to_msg({Rid, SrvId, Name}), WinRate]), [?PREPARE_COMBAT_MAP_BASE_ID]);
        false -> ignore
    end,    
    %% 通过邮件发奖励
    case Rewards of
        [_|_] ->
            Subject = ?L(<<"仙道会奖励">>),
            Content = case WorldCompeteType of
                ?WORLD_COMPETE_TYPE_11 ->
                    case CombatResult of
                        ?c_world_compete_result_ko_perfect -> util:fbin(?L(<<"您在本次仙道会中战胜对手，获得了~w经验、~w仙道历练，请查收">>), [Exp, NewLilian]);
                        ?c_world_compete_result_ko -> util:fbin(?L(<<"您在本次仙道会中战胜对手，获得了~w经验、~w仙道历练，请查收">>), [Exp, NewLilian]);
                        ?c_world_compete_result_loss_perfect -> util:fbin(?L(<<"您在本次仙道会中战败于对手，获得了~w经验、~w仙道历练，请查收">>), [Exp, NewLilian]);
                        ?c_world_compete_result_loss -> util:fbin(?L(<<"您在本次仙道会中战败于对手，获得了~w经验、~w仙道历练，请查收">>), [Exp, NewLilian]);
                        _ -> util:fbin(?L(<<"您在本次仙道会中与对手打成平局，获得了~w经验、~w仙道历练，请查收">>), [Exp, NewLilian])
                    end;
                ?WORLD_COMPETE_TYPE_22 ->
                    case CombatResult of
                        ?c_world_compete_result_ko_perfect -> util:fbin(?L(<<"您在本次仙道会中~s对手，获得了~w经验、~w仙道历练，请查收">>), [?L(<<"完胜">>), Exp, NewLilian]);
                        ?c_world_compete_result_ko -> util:fbin(?L(<<"您在本次仙道会中~s对手，获得了~w经验、~w仙道历练，请查收">>), [?L(<<"小胜">>), Exp, NewLilian]);
                        ?c_world_compete_result_loss_perfect -> util:fbin(?L(<<"您在本次仙道会中~s对手，获得了~w经验、~w仙道历练，请查收">>), [?L(<<"完败于">>), Exp, NewLilian]);
                        ?c_world_compete_result_loss -> util:fbin(?L(<<"您在本次仙道会中~s对手，获得了~w经验、~w仙道历练，请查收">>), [?L(<<"小败于">>), Exp, NewLilian]);
                        _ -> util:fbin(?L(<<"您在本次仙道会中与对手打成平局，获得了~w经验、~w仙道历练，请查收">>), [Exp, NewLilian])
                    end;
                ?WORLD_COMPETE_TYPE_33 ->
                    case CombatResult of
                        ?c_world_compete_result_ko_perfect -> util:fbin(?L(<<"您在本次仙道会中~s对手，获得了~w经验、~w仙道历练，请查收">>), [?L(<<"完胜">>), Exp, NewLilian]);
                        ?c_world_compete_result_ko -> util:fbin(?L(<<"您在本次仙道会中~s对手，获得了~w经验、~w仙道历练，请查收">>), [?L(<<"小胜">>), Exp, NewLilian]);
                        ?c_world_compete_result_loss_perfect -> util:fbin(?L(<<"您在本次仙道会中~s对手，获得了~w经验、~w仙道历练，请查收">>), [?L(<<"完败于">>), Exp, NewLilian]);
                        ?c_world_compete_result_loss -> util:fbin(?L(<<"您在本次仙道会中~s对手，获得了~w经验、~w仙道历练，请查收">>), [?L(<<"小败于">>), Exp, NewLilian]);
                        _ -> util:fbin(?L(<<"您在本次仙道会中与对手打成平局，获得了~w经验、~w仙道历练，请查收">>), [Exp, NewLilian])
                    end;
                _ -> <<>>
            end,
            campaign_listener:handle(world_compete, RoleId, {WorldCompeteType, CwinCount}),
            AssetsRewards = [{?mail_exp, Exp}, {?mail_lilian, NewLilian}],
            mail_mgr:deliver(RoleId, {Subject, Content, AssetsRewards, []});
        _ -> ignore
    end,
    %% 延迟一会退出战区
    erlang:send_after(?LEAVE_AREA_TIMEOUT, self(), {leave_area, RoleId}).

%% 生成排行榜数据格式
format_rank_data([], Result) -> lists:reverse(Result);
format_rank_data([#world_compete_mark{id = RoleId = {Rid, SrvId}, name = Name, lev = Lev, career = Career, sex = Sex, looks = Looks, eqm = Eqm, gain_lilian = Lilian, win_rate = WinRate, win_count = WinCnt, section_mark = SectionMark, section_lev = SectionLev}|T], Result) ->
    Rank = #rank_world_compete{id = RoleId, rid = Rid, srv_id = SrvId, name = Name, lev = Lev, career = Career, sex = Sex, looks = Looks, eqm = Eqm, lilian = Lilian, win_rate = WinRate, wc_lev = world_compete_medal:get_wc_lev_by_win_cnt(WinCnt), section_mark = SectionMark, section_lev = SectionLev},
    format_rank_data(T, [Rank|Result]);
format_rank_data([_|T], Result) ->
    format_rank_data(T, Result).

format_rank_data2([], Result) -> lists:reverse(Result);
format_rank_data2([#world_compete_mark{id = RoleId = {Rid, SrvId}, name = Name, lev = Lev, career = Career, sex = Sex, looks = Looks, eqm = Eqm, win_count_today = WinCntToday, role_power = RolePower, pet_power = PetPower}|T], Result) ->
    Rank = #rank_world_compete_win_day{id = RoleId, rid = Rid, srv_id = SrvId, name = Name, lev = Lev, career = Career, sex = Sex, looks = Looks, eqm = Eqm, role_power = RolePower, pet_power = PetPower, win_count = WinCntToday},
    format_rank_data2(T, [Rank|Result]);
format_rank_data2([_|T], Result) ->
    format_rank_data2(T, Result).

%%---------------------------
%% 报名次数限制
%%---------------------------
get_limit_dict_name(?WORLD_COMPETE_TYPE_11) -> world_compete_sign_up_limit_11;
get_limit_dict_name(?WORLD_COMPETE_TYPE_22) -> world_compete_sign_up_limit_22;
get_limit_dict_name(?WORLD_COMPETE_TYPE_33) -> world_compete_sign_up_limit_33.

add_to_sign_up_limit(WorldCompeteType, RoleId) ->
    case sys_env:get(get_limit_dict_name(WorldCompeteType)) of
        {PrevTime, L} ->
            case lists:keyfind(RoleId, 1, L) of
                {RoleId, Count} ->
                    L1 = [{RoleId, Count+1} | lists:keydelete(RoleId, 1, L)],
                    sys_env:save(get_limit_dict_name(WorldCompeteType), {PrevTime, L1});
                _ ->
                    L1 = [{RoleId, 1} | L],
                    sys_env:save(get_limit_dict_name(WorldCompeteType), {PrevTime, L1})
            end;
        _ ->
            sys_env:save(get_limit_dict_name(WorldCompeteType), {util:unixtime(), [{RoleId, 1}]})
    end.

%% 是否达到了报名次数上限 -> true | {false, 已经报名的次数（不包含此次）}
is_reached_sign_up_limit(WorldCompeteType, RoleId) ->
    case sys_env:get(get_limit_dict_name(WorldCompeteType)) of
        {_PrevTime, L} ->
            case lists:keyfind(RoleId, 1, L) of
                {RoleId, Count} when Count >= ?SIGN_UP_MAX_NUM -> true;
                {RoleId, Count} -> {false, Count};
                _ -> {false, 0}
            end;
        _ -> {false, 1}
    end.

%% 清除报名次数
clear_sign_up_limit() ->
    Types = [?WORLD_COMPETE_TYPE_11, ?WORLD_COMPETE_TYPE_22, ?WORLD_COMPETE_TYPE_33],
    lists:foreach(fun(Type) -> clear_sign_up_limit(Type) end, Types).
clear_sign_up_limit(Type) ->
    Now = util:unixtime(),
    case sys_env:get(get_limit_dict_name(Type)) of
        {PrevTime, _} ->
            case util:is_same_day2(Now, PrevTime) of
                true -> ignore;
                false -> sys_env:save(get_limit_dict_name(Type), {Now, []})
            end;
        _ -> sys_env:save(get_limit_dict_name(Type), {Now, []})
    end.

force_clear_sign_up_limit() ->
    Types = [?WORLD_COMPETE_TYPE_11, ?WORLD_COMPETE_TYPE_22, ?WORLD_COMPETE_TYPE_33],
    lists:foreach(fun(Type) -> sys_env:save(get_limit_dict_name(Type), {util:unixtime(), []}) end, Types).

%% 通知角色某消息
notice(RoleId = {_, _}, Msg) ->
    case role_api:lookup(by_id, RoleId, [#role.pid]) of
        {ok, _, [RolePid]} ->
            notice(RolePid, Msg);
        _ -> ignore
    end;
notice(RolePid, Msg) when is_pid(RolePid) ->
    role:pack_send(RolePid, 10931, {55, Msg, []});
notice(_, _) -> ignore.

%% 超级队伍取胜广播
big_win_cast(WinnerNames, LoserNames) ->
    Len1 = length(WinnerNames),
    Len2 = length(LoserNames),
    if
        Len1 > 0 andalso Len2 > 0 -> %% 正常
            Str1 = gen_big_win_cast_msg(WinnerNames),
            Str2 = gen_big_win_cast_msg(LoserNames),
            notice:send(53, util:fbin(?L(<<"~s在仙道会中犹如天神下凡，完胜了~s，真是所向披靡，太令人崇拜了！">>), [Str1, Str2]), [?PREPARE_COMBAT_MAP_BASE_ID]);
        Len1 =:= 0 andalso Len2 >= 2 -> %% 回合上限到了，双败
            Str = gen_big_win_cast_msg(LoserNames),
            notice:send(53, util:fbin(?L(<<"~s在仙道会中大战~w回合，不分胜负，最终同归于尽！">>), [Str, 99]), [?PREPARE_COMBAT_MAP_BASE_ID]);
        true ->
            ?DEBUG("这种情况下不广播: WinnerNames=~w, LoserNames=~w", [WinnerNames, LoserNames]),
            ok
    end.

gen_big_win_cast_msg(Names) ->
    do_gen_big_win_cast_msg(Names, <<>>).
do_gen_big_win_cast_msg([], Result) -> Result;
do_gen_big_win_cast_msg([Name|T], Result) when Result =:= <<>> ->
    do_gen_big_win_cast_msg(T, Name);
do_gen_big_win_cast_msg([Name|T], Result) ->
    Sp = util:to_binary(","),
    do_gen_big_win_cast_msg(T, <<Result/binary, Sp/binary, Name/binary>>).

%% 段位赛升段广播
section_lev_up_cast({Rid, SrvId}, Name, SectionLev) ->
    Msg = util:fbin(?L(<<"修为精湛的~s在仙道会段位赛中力克强敌，成功晋升为~w段">>), [notice:role_to_msg({Rid, SrvId, Name}), SectionLev]),
    notice:send(53, Msg).

%% 判断当前阶段是否可以报名某种类型的仙道会
is_right_time(?WORLD_COMPETE_TYPE_11) -> is_right_time({16, 0, 0}, {17, 0, 0}) orelse is_right_time({21, 30, 0}, {22, 30, 0});
is_right_time(?WORLD_COMPETE_TYPE_22) -> is_right_time({16, 0, 0}, {17, 0, 0}) orelse is_right_time({21, 30, 0}, {22, 30, 0});
is_right_time(?WORLD_COMPETE_TYPE_33) -> is_right_time({17, 0, 0}, {18, 0, 0}) orelse is_right_time({22, 30, 0}, {23, 30, 0});
is_right_time(_) -> false.

is_right_time({Hour1, Min1, Sec1}, {Hour2, Min2, Sec2}) ->
    Now = util:unixtime(),
    Today = util:unixtime({today, Now}),
    Time1 = Hour1 * 3600 + Min1 * 60 + Sec1,
    Time2 = Hour2 * 3600 + Min2 * 60 + Sec2,
    case (Today + Time1) =< Now andalso Now =< (Today + Time2) of
        true -> true;
        false -> false
    end.

%% 载入仙道会当日战绩
load_marks() ->
    case dets:first(rank_world_compete_win_count_today) of
        '$end_of_table' -> ?INFO("仙道会当日战绩数据导入进程字典完成，DETS没有数据");
        _ ->
            put(load_marks_flag, true),
            dets:traverse(rank_world_compete_win_count_today,
                fun(Mark) when is_record(Mark, rank_world_compete_win_day) ->
                        put(rank_world_compete_win_count_today, [eqm_parse(Mark)|get(rank_world_compete_win_count_today)]),
                        continue;
                    (_Data) ->
                        ?INFO("仙道会当日战绩数据格式有误，可能已经无效，删除全部"),
                        put(load_marks_flag, false),
                        continue
                end
            ),
            case get(load_marks_flag) of
                true -> ignore;
                false ->
                    dets:delete_all_objects(rank_world_compete_win_count_today),
                    put(rank_world_compete_win_count_today, [])
            end,
            ?INFO("仙道会当日战绩数据导入进程字典完成，共~w条数据", [])
    end,
    case sys_env:get(rank_world_compete_win_count_yesterday) of
        MarkYesterDay = [_|_] -> 
            MarkYesterDay1 = eqm_parse(MarkYesterDay, []),
            sys_env:save(rank_world_compete_win_count_yesterday, MarkYesterDay1);
        _ -> ignore
    end.

%% 装备版本转换
%% 装备版本转换
eqm_parse(Mark = #rank_world_compete_win_day{eqm = Eqm}) ->
    Eqm2 = case item_parse:do(Eqm) of
        {ok, Eqm1} -> Eqm1;
        _ -> []
    end,
    Mark#rank_world_compete_win_day{eqm = Eqm2}.
eqm_parse([], Result) -> lists:reverse(Result);
eqm_parse([Mark = #rank_world_compete_win_day{eqm = Eqm}|T], Result) ->
    Eqm2 = case item_parse:do(Eqm) of
        {ok, Eqm1} -> Eqm1;
        _ -> []
    end,
    eqm_parse(T, [Mark#rank_world_compete_win_day{eqm = Eqm2}|Result]).

%% 生成称号
gen_honors([], Result) -> Result;
gen_honors([{RoleId, SectionLev, _DayLilian, _DayAttainment, _ItemRewards}|T], Result) ->
    HonorId = case SectionLev of
        7 -> 60016;
        8 -> 60017;
        9 -> 60018;
        10 -> 60019;
        11 -> 60020;
        12 -> 60021;
        13 -> 60022;
        14 -> 60023;
        15 -> 60024;
        16 -> 60025;
        17 -> 60026;
        18 -> 60027;
        19 -> 60028;
        20 -> 60029;
        _ -> -1
    end,
    case achievement_data_honor:get(HonorId) of
        {ok, _HonorBase} ->
            gen_honors(T, [{RoleId, HonorId}|Result]);
        _ ->
            gen_honors(T, Result)
    end.

%% 领取每日段位奖励
%% ItemRewards = [{ItemBaseId, Bind, Quantity}]
do_get_day_section_reward(Role = #role{name = _Name}, DayAttainment, DayLilian, ItemRewards) ->
    Items = [#gain{label = item, val = [ItemBaseId, Bind, Quantity]} || {ItemBaseId, Bind, Quantity} <- ItemRewards],
    Rewards = [#gain{label = attainment , val = DayAttainment}, #gain{label = lilian, val = DayLilian}] ++ Items,
    case role_gain:do(Rewards, Role) of
        {ok, NewRole} ->
            log:log(log_attainment, {<<"仙道会">>, <<"段位赛每日奖励">>, Role, NewRole}),
            log:log(log_xd_lilian, {<<"仙道会">>, <<"段位赛每日奖励">>, Role, NewRole}),
            {ok, true, NewRole};
        {false, _Err} ->
            ?ERR("[~s]领取段位赛每日奖励失败:~w", [_Name, _Err]),
            {ok, false, Role}
    end.

%% 物品信息转换成文字 -> bitstring()
items_to_msg(Items) ->
    items_to_msg(Items, <<>>).
items_to_msg([], Result) -> Result;
items_to_msg([{ItemBaseId, _, Quantity}|T], Result) ->
    case item_data:get(ItemBaseId) of
        {ok, #item_base{name = Name}} ->
            Msg = util:fbin(<<"~s*~w">>, [Name, Quantity]),
            items_to_msg(T, <<Result/binary, Msg/binary>>);
        _ ->
            items_to_msg(T, Result)
    end.

%% 仙道会类型 到 event的映射
world_compete_type_to_event(?WORLD_COMPETE_TYPE_11) -> ?event_c_world_compete_11;
world_compete_type_to_event(?WORLD_COMPETE_TYPE_22) -> ?event_c_world_compete_22;
world_compete_type_to_event(?WORLD_COMPETE_TYPE_33) -> ?event_c_world_compete_33.

%% event 到仙道会类型的映射
event_to_world_compete_type(?event_c_world_compete_11) -> ?WORLD_COMPETE_TYPE_11;
event_to_world_compete_type(?event_c_world_compete_22) -> ?WORLD_COMPETE_TYPE_22;
event_to_world_compete_type(?event_c_world_compete_33) -> ?WORLD_COMPETE_TYPE_33.

%% 战斗力 到 分组 的映射
power_to_world_compete_group(Power) when Power < 10000 -> ?WORLD_COMPETE_GROUP_NEW;
power_to_world_compete_group(Power) when Power >=10000 andalso Power < 16000 -> ?WORLD_COMPETE_GROUP_JINGRUI;
power_to_world_compete_group(Power) when Power >=16000 andalso Power < 22000 -> ?WORLD_COMPETE_GROUP_LINGYUN;
power_to_world_compete_group(Power) when Power >=22000 andalso Power < 30000 -> ?WORLD_COMPETE_GROUP_WUSHUANG;
power_to_world_compete_group(Power) when Power >=30000 andalso Power < 40000 -> ?WORLD_COMPETE_GROUP_JINGSHI;
power_to_world_compete_group(Power) when Power >=40000 andalso Power < 50000 -> ?WORLD_COMPETE_GROUP_DIANFENG;
power_to_world_compete_group(_Power) -> ?WORLD_COMPETE_GROUP_SHASHEN.

%% 战斗力 到 分组消息 的映射
world_compete_group_to_msg(?WORLD_COMPETE_GROUP_NEW) -> ?L(<<"根据您的战力，此次匹配您进入了仙道会新秀组（0~10000战斗力）">>);
world_compete_group_to_msg(?WORLD_COMPETE_GROUP_JINGRUI) -> ?L(<<"根据您的战力，此次匹配您进入了仙道会精锐组（10000~16000战斗力）">>);
world_compete_group_to_msg(?WORLD_COMPETE_GROUP_LINGYUN) -> ?L(<<"根据您的战力，此次匹配您进入了仙道会凌云组（16000~22000战斗力）">>);
world_compete_group_to_msg(?WORLD_COMPETE_GROUP_WUSHUANG) -> ?L(<<"根据您的战力，此次匹配您进入了仙道会无双组（22000~30000战斗力）">>);
world_compete_group_to_msg(?WORLD_COMPETE_GROUP_JINGSHI) -> ?L(<<"根据您的战力，此次匹配您进入了仙道会惊世组（30000~40000战斗力）">>);
world_compete_group_to_msg(?WORLD_COMPETE_GROUP_DIANFENG) -> ?L(<<"根据您的战力，此次匹配您进入了仙道会巅峰组（40000~50000战斗力）">>);
world_compete_group_to_msg(?WORLD_COMPETE_GROUP_SHASHEN) -> ?L(<<"根据您的战力，此次匹配您进入了仙道会杀神组（大于50000战斗力）">>);
world_compete_group_to_msg(_) -> <<>>.
