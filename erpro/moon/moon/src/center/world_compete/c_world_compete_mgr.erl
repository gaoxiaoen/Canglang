%%----------------------------------------------------
%% 跨服仙道会管理器
%% @author yankai@jieyou.cn
%% @end
%%----------------------------------------------------
-module(c_world_compete_mgr).

-behaviour(gen_server).

-export([
        start/0,
        start_link/0,
        sign_up/2,
        cancel_match/2,
        start_activity/0,
        stop_activity/0,
        combat_over/3,
        check_role_login_status/2,
        check_activity_status/1,
        force_leave_prepare_combat/2,
        print_all_sign_up_teams_info/0,
        print_activity_status/0,
        reset_next_period/1,
        remove_signing_up_role/1,
        enter_area_failed/2,
        remove_from_matching_queue/2,
        set_match_print_flag/2,
        set_matching_queue_print_flag/1,
        send_day_section_rewards/0,
        print_section_info/1,
        reset_section_info/0,
        change_lineup/3,
        open_section_over_rewards_test/0,
        close_section_over_rewards_test/0,
        set_section_lev/2
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("combat.hrl").
-include("attr.hrl").
-include("mail.hrl").
-include("role.hrl").
-include("world_compete.hrl").

-record(state, {
        queues = [],
        is_started = false,
        current_period = 0,
        timer_pid = 0,
        timer_mref
    }
).

-define(PLATFORM_MAPPING_POLICY_ONE_ON_ONE, 1).     %% 映射策略：一对一
-define(PLATFORM_MAPPING_POLICY_BY_MAPPING, 2).     %% 映射策略：按照映射配置

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------
start() ->
    gen_server:start({local, ?MODULE}, ?MODULE, [], []).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 节点提交排队信息
sign_up(WorldCompeteType, SignupRoles) ->
    gen_server:cast(?MODULE, {sign_up, WorldCompeteType, SignupRoles}).

%% 取消匹配
cancel_match(WorldCompeteType, RoleIds) ->
    gen_server:cast(?MODULE, {cancel_match, WorldCompeteType, RoleIds}).

%% 开始活动
start_activity() ->
    gen_server:cast(?MODULE, cmd_start_activity).

%% 结束活动
stop_activity() ->
    gen_server:cast(?MODULE, cmd_stop_activity).

%% 战斗结束
combat_over(undefined, _Winner, _Loser) ->
    %% ?ERR("仙道会战斗结束后参战者的event错误"),
    ok;
combat_over(WorldCompeteType, Winner, Loser) ->
    gen_server:cast(?MODULE, {combat_over, WorldCompeteType, Winner, Loser}).

%% 检查活动状态
check_activity_status(SrvId) ->
    gen_server:cast(?MODULE, {check_activity_status, SrvId}).

%% 检查角色登陆状态
check_role_login_status(WorldCompeteType, RoleId) ->
    case get_platform_mgr(WorldCompeteType, RoleId) of
        #world_compete_platform_mgr{pid = Pid} when is_pid(Pid) ->
            gen_server:call(Pid, {check_role_login_status, RoleId});
        _ -> {ok, no_platform_mgr, RoleId}
    end.

%% 节点通知强制退出战斗区域
force_leave_prepare_combat(WorldCompeteType, RoleId) ->
    case get_platform_mgr(WorldCompeteType, RoleId) of
        #world_compete_platform_mgr{pid = Pid} when is_pid(Pid) ->
            Pid ! {force_leave_prepare_combat, RoleId};
        _ -> ?ERR("根据[~s]找不到仙道会平台管理器", [RoleId])
    end.

%% 打印目前报了名的队伍信息
print_all_sign_up_teams_info() ->
    case ets:tab2list(world_compete_platform_mgr) of
        L = [_|_] ->
            lists:foreach(fun(#world_compete_platform_mgr{name = _Name, pid = Pid}) ->
                    case is_pid(Pid) of
                        true -> Pid ! print_sign_up_teams_info;
                        false -> ?ERR("仙道会平台管理器[~s]进程关闭了，无法打印报名队伍信息!", [_Name])
                    end
                end, L);
        _ -> ignore
    end.

%% 打印活动状态
print_activity_status() ->
    gen_server:cast(?MODULE, print_activity_status).

%% 重设计时器
reset_next_period(NextPeriod) ->
    gen_server:cast(?MODULE, {reset_next_period, NextPeriod}).

%% 把正在等待报名结果的角色从等待结果队列中移除
remove_signing_up_role(RoleIds) ->
    gen_server:cast(?MODULE, {remove_signing_up_role, RoleIds}).

%% 打印节点发过来的进入战区失败的消息
enter_area_failed({Rid, SrvId}, Reason) ->
    ?ERR("[~w, ~s]进入战区失败:~w", [Rid, SrvId, Reason]).

%% 从待匹配队列中清除
remove_from_matching_queue(WorldCompeteType, RoleId) ->
    case get_platform_mgr(WorldCompeteType, RoleId) of
        #world_compete_platform_mgr{pid = Pid} when is_pid(Pid) ->
            Pid ! {remove_from_matching_queue, RoleId};
        _ -> ?ERR("根据[~s]找不到仙道会平台管理器", [RoleId])
    end.

%% 设置匹配打印标记
%% Flag = true | false
%% Latitude = number()
set_match_print_flag(Flag, Latitude) ->
    cast_to_all_platform({set_match_print_flag, Flag, Latitude}).

%% 设置待匹配队列打印标记
%% Flag = true | false
set_matching_queue_print_flag(Flag) ->
    cast_to_all_platform({set_matching_queue_print_flag, Flag}).

%% 手动发送每日段位赛奖励
send_day_section_rewards() ->
    gen_server:cast(?MODULE, send_day_section_rewards).

%% 打印角色段位赛信息
print_section_info(RoleId) ->
    gen_server:cast(?MODULE, {print_section_info, RoleId}).

%% 重设所有的段位赛信息（设回跟战斗力相关的初始值）
reset_section_info() ->
    gen_server:cast(?MODULE, reset_section_info).

%% 改变阵法
change_lineup(WorldCompeteType, RoleId, LineupId) ->
    case get_platform_mgr(WorldCompeteType, RoleId) of
        #world_compete_platform_mgr{pid = Pid} when is_pid(Pid) ->
            Pid ! {change_lineup, RoleId, LineupId};
        _ -> ?ERR("根据[~s]找不到仙道会平台管理器", [RoleId])
    end.

%% 开启段位赛季末奖励测试
open_section_over_rewards_test() ->
    sys_env:set(is_debug_section_reward, true).

%% 关闭段位赛季末奖励测试
close_section_over_rewards_test() ->
    sys_env:set(is_debug_section_reward, false).

%% 设段位等级
set_section_lev(RoleId, SectionLev) ->
    gen_server:cast(?MODULE, {set_section_lev, RoleId, SectionLev}).


%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------
init([]) ->
    process_flag(trap_exit, true),
    ?INFO("[~w] 正在启动...", [?MODULE]),
    put(signing_up_roles, []),
    {ok, TimerPid} = c_world_compete_flow:create(self()),
    TimerMref = erlang:monitor(process, TimerPid),
    ets:new(world_compete_platform_mgr, [set, named_table, public, {keypos, #world_compete_platform_mgr.name}]),

    %% 初始化平台名称到管理器的映射策略
    put(mapping_policy, ?PLATFORM_MAPPING_POLICY_BY_MAPPING),

    %% 初始化1v1、2v2、3v3的平台管理器
    init_platforms(?WORLD_COMPETE_TYPE_11),
    init_platforms(?WORLD_COMPETE_TYPE_22),
    init_platforms(?WORLD_COMPETE_TYPE_33),

    State = #state{timer_pid = TimerPid, timer_mref = TimerMref},
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(cmd_start_activity, State = #state{timer_pid = TimerPid}) ->
    ?DEBUG("命令开启仙道会"),
    TimerPid ! start_activity,
    {noreply, State};

handle_cast(cmd_stop_activity, State = #state{timer_pid = TimerPid}) ->
    ?DEBUG("命令关闭仙道会"),
    TimerPid ! stop_activity,
    {noreply, State};

handle_cast({sign_up, WorldCompeteType, SignupRoles}, State = #state{is_started = true}) when is_list(SignupRoles) ->
    %% 防止一人报多个类型的仙道会
    RoleIds = [RoleId || #sign_up_role{id = RoleId} <- SignupRoles],
    case can_sign_up(SignupRoles, true) of
        true ->
            erlang:send_after(5000, self(), {remove_signing_up_role, RoleIds}),
            send_to_platform_mgr(WorldCompeteType, SignupRoles, {sign_up, SignupRoles});
        false ->
            ?DEBUG("[~w]正在报名中，等待回复", [RoleIds])
    end,
    {noreply, State};

handle_cast({cancel_match, WorldCompeteType, RoleIds = [{_, SrvId}|_]}, State) ->
    %% ?DEBUG("收到取消报名请求[~w]", [RoleIds]),
    case get_platform_mgr(WorldCompeteType, SrvId) of
        #world_compete_platform_mgr{pid = Pid} when is_pid(Pid) ->
            Pid ! {cancel_match, RoleIds};
        _ -> ignore
    end,
    {noreply, State};

handle_cast({combat_over, WorldCompeteType, Winner, Loser}, State = #state{timer_pid = TimerPid}) ->
    L = Winner ++ Loser,
    case L of
        [#fighter{srv_id = SrvId}|_] ->
            case get_platform_mgr(WorldCompeteType, SrvId) of
                #world_compete_platform_mgr{pid = Pid} when is_pid(Pid) ->
                    Pid ! {combat_over, Winner, Loser, TimerPid};
                _ -> ignore
            end;
        _ -> ignore
    end,
    {noreply, State};

%% 节点请求检查活动状态
handle_cast({check_activity_status, SrvId}, State = #state{is_started = Result}) ->
    c_mirror_group:cast(node, SrvId, world_compete_mgr, check_activity_status_result_inform, [Result]),
    {noreply, State};

handle_cast(print_activity_status, State = #state{timer_pid = TimerPid}) ->
    TimerPid ! print_activity_status,
    {noreply, State};

handle_cast({reset_next_period, NextPeriod}, State = #state{timer_pid = TimerPid}) ->
    TimerPid ! {reset_next_period, NextPeriod},
    {noreply, State};

handle_cast({remove_signing_up_role, RoleIds}, State) ->
    put(signing_up_roles, get(signing_up_roles) -- RoleIds),
    {noreply, State};

handle_cast(send_day_section_rewards, State = #state{timer_pid = TimerPid}) ->
    TimerPid ! send_day_section_rewards,
    {noreply, State};

handle_cast({print_section_info, RoleId}, State = #state{timer_pid = TimerPid}) ->
    TimerPid ! {print_section_info, RoleId},
    {noreply, State};

handle_cast(reset_section_info, State = #state{timer_pid = TimerPid}) ->
    TimerPid ! reset_section_info,
    {noreply, State};

handle_cast({set_section_lev, RoleId, SectionLev}, State = #state{timer_pid = TimerPid}) ->
    TimerPid ! {set_section_lev, RoleId, SectionLev},
    {noreply, State};

handle_cast(_Msg, State) ->
    %% ?ERR("收到未知消息: ~w", [Msg]),
    {noreply, State}.

%% 定时器挂了
handle_info({'DOWN', TimerMref, _Type, _Object, _Reason}, State = #state{timer_mref = TimerMref}) ->
    ?ERR("定时器挂了，重启"),
    case c_world_compete_flow:create(self()) of
        {ok, TimerPid} ->
            TimerMref1 = erlang:monitor(process, TimerPid),
            {noreply, State#state{timer_pid = TimerPid, timer_mref = TimerMref1}};
        _Err ->
            ?ERR("定时器无法创建:~w", [_Err]),
            {noreply, State}
    end;

%% 处理进程退出消息
handle_info({'EXIT', _ExitPid, normal}, State) ->
    {noreply, State};
handle_info({'EXIT', _ExitPid, _Reason}, State = #state{is_started = IsStarted, current_period = CurrentPeriod}) ->
    case ets:tab2list(world_compete_platform_mgr) of
        L = [_|_] ->
            %% 判断是否某个平台对应的仙道会管理器挂了
            lists:foreach(fun(#world_compete_platform_mgr{name = Name, type = WorldCompeteType, pid = Pid}) ->
                        case is_pid(Pid) andalso is_process_alive(Pid) of
                            true -> ignore;
                            false ->
                                case c_world_compete:create(WorldCompeteType, Name) of
                                    {ok, Pid1} ->
                                        Mgr = #world_compete_platform_mgr{name = Name, type = WorldCompeteType, pid = Pid1},
                                        ets:insert(world_compete_platform_mgr, Mgr),
                                        case IsStarted of
                                            true -> Pid1 ! {start_activity, CurrentPeriod};
                                            false -> Pid1 ! stop_activity
                                        end;
                                    _Err -> ?ERR("创建仙道会平台管理器[name=~s]失败:~w", [Name, _Err])
                                end
                        end
                end, L);
        _ -> ignore
    end,
    {noreply, State};

handle_info({remove_signing_up_role, RoleIds}, State) ->
    put(signing_up_roles, get(signing_up_roles) -- RoleIds),
    {noreply, State};

handle_info(prepare_start, State = #state{is_started = false}) ->
    ?INFO("广播仙道会即将开始的消息"),
    Platforms = case c_world_compete_cfg:get_white_platforms() of
        L when is_list(L) -> L;
        _ -> c_mirror_group:get_all_platforms()
    end,
    c_mirror_group:cast(platform, Platforms, world_compete_mgr, prepare_start, []),
    {noreply, State};

handle_info({start_activity, CurrentPeriod}, State = #state{is_started = IsStarted}) ->
    ?INFO("广播仙道会开始的消息"),
    case IsStarted of
        true -> ignore;
        false -> put(signing_up_roles, [])
    end,
    cast_to_all_platform(start_activity),
    Platforms = case c_world_compete_cfg:get_white_platforms() of
        L when is_list(L) -> L;
        _ -> c_mirror_group:get_all_platforms()
    end,
    c_mirror_group:cast(platform, Platforms, world_compete_mgr, start_activity, [CurrentPeriod]),
    {noreply, State#state{is_started = true, current_period = CurrentPeriod}};

handle_info(stop_activity, State) ->
    ?INFO("广播仙道会结束的消息"),
    cast_to_all_platform(stop_activity),
    Platforms = c_mirror_group:get_all_platforms(), %% 结束时就全服广播，预防开启和结束中途白名单被修改过
    c_mirror_group:cast(platform, Platforms, world_compete_mgr, stop_activity, []),
    {noreply, State#state{is_started = false}};

handle_info(_Info, State) ->
    %%?ERR("收到未知消息: ~w", [Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% 初始化仙道会平台管理器
%% WorldCompeteType = integer(), 仙道会类型
init_platforms(WorldCompeteType) ->
    ?INFO("初始化仙道会平台管理器"),
    case get(mapping_policy) of
        ?PLATFORM_MAPPING_POLICY_ONE_ON_ONE ->
            Platforms = c_mirror_group:get_all_platforms(),
            %% 命名规则：模块名 + "_" + 仙道会类型 + "_" + 平台名称
            Names = [c_world_compete_cfg:assemble_name(WorldCompeteType, Platform) || Platform <- Platforms],
            do_init_platforms(WorldCompeteType, Names);
        ?PLATFORM_MAPPING_POLICY_BY_MAPPING ->
            Names = c_world_compete_cfg:get_all_platform_groups(WorldCompeteType),
            do_init_platforms(WorldCompeteType, Names)
    end.    
do_init_platforms(_, []) -> ok;
do_init_platforms(WorldCompeteType, [Name|T]) ->
    case ets:lookup(world_compete_platform_mgr, Name) of
        [#world_compete_platform_mgr{pid = Pid}] when is_pid(Pid) ->
            case is_process_alive(Pid) of
                true -> ignore;
                false ->
                    case c_world_compete:create(WorldCompeteType, Name) of
                        {ok, NewPid} ->
                            Mgr = #world_compete_platform_mgr{name = Name, type = WorldCompeteType, pid = NewPid},
                            ets:insert(world_compete_platform_mgr, Mgr);
                        _Err ->
                            ?ERR("创建仙道会平台管理器[name=~s]失败:~w", [Name, _Err])
                    end
            end;
        _ ->
            case c_world_compete:create(WorldCompeteType, Name) of
                {ok, NewPid} ->
                    Mgr = #world_compete_platform_mgr{name = Name, type = WorldCompeteType, pid = NewPid},
                    ets:insert(world_compete_platform_mgr, Mgr);
                _Err ->
                    ?ERR("创建仙道会平台管理器[name=~s]失败:~w", [Name, _Err])
            end
    end,
    do_init_platforms(WorldCompeteType, T).

%% 根据SrvId获取对应的c_world_compete
get_platform_mgr(WorldCompeteType, {_, SrvId}) -> get_platform_mgr(WorldCompeteType, SrvId);
get_platform_mgr(WorldCompeteType, SrvId) ->
    Platform = c_mirror_group:get_platform(SrvId),
    MgrName = c_world_compete_cfg:get_platform_group_mapping(WorldCompeteType, Platform),
    case ets:lookup(world_compete_platform_mgr, MgrName) of
        [P = #world_compete_platform_mgr{}] -> P;
        _ -> 
            ?ERR("根据MgrName=~w, SrvId=~s获取不到对应的平台管理器", [MgrName, SrvId]),
            undefined
    end.

%% 广播消息到所有的平台管理器
cast_to_all_platform(Msg) ->
    case ets:tab2list(world_compete_platform_mgr) of
        L = [_|_] ->
            lists:foreach(fun(#world_compete_platform_mgr{pid = Pid}) ->
                        case is_pid(Pid) of
                            true -> Pid ! Msg;
                            false -> ignore
                        end
                end, L);
        _ -> ignore
    end.

%% 发送消息给指定的平台管理器
send_to_platform_mgr(_WorldCompeteType, [], _Msg) -> ok;
send_to_platform_mgr(WorldCompeteType, [#sign_up_role{id = {_, SrvId}}|_], Msg) ->
    case get_platform_mgr(WorldCompeteType, SrvId) of
        #world_compete_platform_mgr{pid = Pid} when is_pid(Pid) ->
            Pid ! Msg;
        _ -> ignore
    end.

%% 是否可以报名
can_sign_up([], Result) -> Result;
can_sign_up([#sign_up_role{id = RoleId}|T], Result) ->
    case lists:member(RoleId, get(signing_up_roles)) of
        true -> false;
        false -> can_sign_up(T, Result)
    end.
