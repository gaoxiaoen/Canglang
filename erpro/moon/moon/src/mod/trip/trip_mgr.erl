%%----------------------------------------------------
%% 跨服旅行管理器
%% @author yankai@jieyou.cn
%% @end
%%----------------------------------------------------
-module(trip_mgr).

-behaviour(gen_server).

-export([
        start_link/0,
        get_optional_platform/1,
        get_optional_srv/2,
        get_tele_door_info/1,
        enter_center_city_by_door/2,
        enter_center_city_by_item/1,
        enter_center_city_by_coin/1,
        leave_center_city/1,
        create_tele_door/5,
        create_tele_door_no_cost/4,
        create_tele_door_by_remote/3,
        clear_tele_door_available_num/0,
        shutdown_tele_door/0,
        limit_enter/1,
        is_enter_limited/0,
        kick_expire_role/1
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("map.hrl").
-include("role.hrl").
-include("item.hrl").
-include("gain.hrl").
-include("pos.hrl").
%%

-record(state, {
        tele_door_change_time = 0    %% 传送门状态有更改的时间
    }
).

-define(MAP_ELEM_TELE_DOOR_BASE_ID, 60462).     %% 地图元素：传送门BaseId
-define(CENTER_CITY_MAP_BASE_ID, 36031).     %% 跨服地图：中心城 的BaseId
-define(TELE_POS_LIST, [{4440, 3180}, {5520, 3750}, {5820, 3280}, {4440, 3660}]).   %% 洛水城和跨服中心城的传送坐标列表
-define(TELE_DOOR_COLLAPSE_TIME, 1000*60*30).   %% 传送门自动崩溃时间

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 获取可选平台 -> [Platform]
%% Platform = <<"4399">>
get_optional_platform(RolePid) ->
    gen_server:cast(?MODULE, {get_optional_platform, RolePid}).

%% 获取指定平台下所有可选的服务器id -> [SrvId]
%% SrvId = <<"4399_3">>
get_optional_srv(Platform, RolePid) ->
    Platform1 = util:to_binary(Platform),
    gen_server:cast(?MODULE, {get_optional_srv, Platform1, RolePid}).

%% 获取传送门信息
get_tele_door_info(RolePid) ->
    gen_server:cast(?MODULE, {get_tele_door_info, RolePid}).

%% 穿过传送门进入中心城
enter_center_city_by_door(Role, Type) ->
    gen_server:cast(?MODULE, {enter_center_city_by_door, Role, Type}).

%% 直接使用道具进入中心城
enter_center_city_by_item(Role) ->
    gen_server:cast(?MODULE, {enter_center_city_by_item, Role}).

%% 直接花费金币进入中心城
enter_center_city_by_coin(Role) ->
    gen_server:cast(?MODULE, {enter_center_city_by_coin, Role}).

%% 离开中央服地图
leave_center_city(Role) when is_record(Role, role)->
    gen_server:cast(?MODULE, {leave_center_city, Role}).

%% 通知指定的服务器上创建传送门
%% SrvId = <<"XXX">>  要创建传送门的目标SrvId
%% UseNum = integer() 使用物品的个数
create_tele_door(SrvId, UseNum, RoleId, RolePid, Name) ->
    SrvId1 = util:to_binary(SrvId),
    gen_server:cast(?MODULE, {create_tele_door, SrvId1, UseNum, RoleId, RolePid, Name}).

%% 通知指定的服务器上创建传送门（不需要消耗物品）
%% SrvId = <<"XXX">>  要创建传送门的目标SrvId
%% IncreaseNum = integer()  传送门增加多少次使用次数
create_tele_door_no_cost(SrvId, IncreaseNum, RoleId, RoleName) ->
    SrvId1 = util:to_binary(SrvId),
    gen_server:cast(?MODULE, {create_tele_door_no_cost, SrvId1, IncreaseNum, RoleId, RoleName}).

%% 响应远端号召，创建传送门
create_tele_door_by_remote(RoleId, Name, IncreaseNum) ->
    gen_server:cast(?MODULE, {do_create_tele_door, RoleId, Name, IncreaseNum}).

%% 清除传送门可用次数
clear_tele_door_available_num() ->
    gen_server:cast(?MODULE, clear_tele_door_available_num).

%% 直接关闭传送门
shutdown_tele_door() ->
    gen_server:cast(?MODULE, shutdown_tele_door).

%% 设置能否进入中心城的标识
%% Flag = true | false
limit_enter(Flag) ->
    gen_server:cast(?MODULE, {limit_enter, Flag}).

%% 是否限制进入中心城 -> true | false
is_enter_limited() ->
    case sys_env:get(limit_enter_center_city) of
        true -> true;
        _ -> false
    end.

%% 踢走超过停留时间的角色 -> true | false
kick_expire_role(RoleId) ->
    gen_server:cast(?MODULE, {kick_expire_role, RoleId}).


%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    State = #state{tele_door_change_time = util:unixtime()},
    ?INFO("[~w] 启动完成", [?MODULE]),
    sys_env:save(limit_enter_center_city, false),
    erlang:send_after(5000, self(), check_tele_door_exist),
    {ok, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast({get_optional_platform, RolePid}, State) ->
    Platforms = case sys_env:get(platform_list) of
        L = [_|_] ->
            [{Platform} || Platform <- L];
        _ -> []
    end,
    role:pack_send(RolePid, 18301, {Platforms}),
    {noreply, State};

handle_cast({get_optional_srv, Platform, RolePid}, State) ->
    SrvIds = case sys_env:get(platform_srv_list) of
        L = [_|_] ->
            case lists:keyfind(Platform, 1, L) of
                {Platform, L1} ->
                    [{SrvId} || SrvId <- L1];
                _ -> []
            end;
        _ -> []
    end,
    role:pack_send(RolePid, 18302, {SrvIds}),
    {noreply, State};

handle_cast({get_tele_door_info, RolePid}, State) ->
    {CurNum, MaxNum} = get_tele_door_available_num(),
    role:pack_send(RolePid, 18303, {CurNum, MaxNum}),
    {noreply, State};

handle_cast({enter_center_city_by_door, #role{pid = RolePid}, Type}, State) ->
    case can_use_tele_door() of
        true ->
            do_change_tele_door_available_num(1, 0),
            {X, Y} = get_tele_pos(Type),
            role:apply(async, RolePid, {fun do_enter_center_city/5, [?CENTER_CITY_MAP_BASE_ID, X, Y, self()]}),
            {noreply, State#state{tele_door_change_time = util:unixtime()}};
        false ->
            role:pack_send(RolePid, 18304, {?false, ?L(<<"传送门使用次数达到上限，暂时无法使用">>)}),
            {noreply, State#state{tele_door_change_time = util:unixtime()}}
    end;

handle_cast({enter_center_city_by_item, #role{pid = RolePid}}, State) ->
    {X, Y} = get_tele_pos(1),
    role:apply(async, RolePid, {fun do_enter_center_city/5, [?CENTER_CITY_MAP_BASE_ID, X, Y, self()]}),
    {noreply, State};

handle_cast({enter_center_city_by_coin, #role{pid = RolePid}}, State) ->
    {X, Y} = get_tele_pos(1),
    role:apply(async, RolePid, {fun do_enter_center_city/5, [?CENTER_CITY_MAP_BASE_ID, X, Y, self()]}),
    {noreply, State};

handle_cast({leave_center_city, #role{pid = RolePid, name = _Name}}, State) ->
    ?DEBUG("[~s]离开圣城回到原服", [_Name]),
    role:apply(async, RolePid, {fun do_leave_center_city/1, []}),
    {noreply, State};

%% 扣减物品并通知目标服开启传送门
handle_cast({create_tele_door, SrvId, UseNum, RoleId, RolePid, Name}, State) ->
    %% 扣减物品
    case catch role:apply(sync, RolePid, {fun do_cost_item/2, [UseNum]}) of
        true ->
            center:cast(SrvId, trip_mgr, create_tele_door_by_remote, [RoleId, Name, 5*UseNum]),
            role:pack_send(RolePid, 18306, {?true, ?L(<<"创建传送门成功">>)});
        {false, Reason} ->
            role:pack_send(RolePid, 18306, {?false, Reason})
    end,
    {noreply, State};

%% 通知目标服开启传送门（不需要扣除物品）
handle_cast({create_tele_door_no_cost, SrvId, IncreaseNum, RoleId, Name}, State) ->
    center:cast(SrvId, trip_mgr, create_tele_door_by_remote, [RoleId, Name, IncreaseNum]),
    {noreply, State};

%% 收到开启消息后创建传送门（如果已经存在则增加次数）
handle_cast({do_create_tele_door, _RoleId = {Rid, SrvId}, Name, IncreaseNum}, State) ->
    {X, Y} = do_create_tele_door(),
    do_change_tele_door_available_num(0, IncreaseNum),
    notice:send(53, util:fbin(?L(<<"飞仙大能~s在起源圣城施展神功打通了本服通往起源圣城的接引通道，通道位于许愿池旁{location,~w,~w,~w,ffff00}，名额有限，欲前往圣城的玩家要抓紧机会啦">>), [notice:role_to_msg({Rid, SrvId, Name}), 10003, X, Y])),
    {noreply, State#state{tele_door_change_time = util:unixtime()}};

%% 清除传送门可用次数
handle_cast(clear_tele_door_available_num, State) ->
    do_clear_tele_door_available_num(),
    {noreply, State};

%% 直接关闭传送门
handle_cast(shutdown_tele_door, State) ->
    do_clear_tele_door_available_num(),
    do_close_tele_door(),
    {noreply, State};

%% 设置进入限制标识
handle_cast({limit_enter, Flag}, State) ->
    sys_env:save(limit_enter_center_city, Flag),
    {noreply, State};

%% 踢走超时停留的角色
handle_cast({kick_expire_role, RoleId}, State) ->
    case role_api:lookup(by_id, RoleId, [#role.id, #role.pid, #role.event]) of
        {ok, _Node, [RoleId, RolePid, ?event_no]} ->
            case catch role:apply(sync, RolePid, {fun sync_leave_center_city/1, []}) of
                {true, Role} ->
                    team_api:quit(Role),
                    center:cast(c_trip_mgr, confirm_kick_expire_role, [RoleId]);
                _ -> ignore
            end;
        _ ->
            ignore
    end,
    {noreply, State};

handle_cast(Msg, State) ->
    ?ERR("收到未知消息: ~w", [Msg]),
    {noreply, State}.

handle_info({enter_center_city_by_door_result, true, RoleId}, State) ->
    center:cast(c_trip_mgr, enter_center_city, [RoleId]),
    {noreply, State};

handle_info({enter_center_city_by_door_result, false}, State) ->
    do_change_tele_door_available_num(-1, 0),
    {noreply, State};

%% 进程重启后检查一下传送门看看是否还有剩余次数，如果有则创建一个门
handle_info(check_tele_door_exist, State = #state{tele_door_change_time = LastTime}) ->
    case can_use_tele_door() of
        true -> 
            case LastTime + ?TELE_DOOR_COLLAPSE_TIME =< util:unixtime() of
                true ->
                    ?INFO("传送门荒废了太久，依法关闭!"),
                    do_clear_tele_door_available_num(),
                    do_close_tele_door();
                false ->
                    do_create_tele_door()
            end;
        false -> do_close_tele_door()
    end,
    erlang:send_after(1000 * 60 * 3, self(), check_tele_door_exist),
    {noreply, State};

handle_info(Info, State) ->
    ?ERR("收到未知消息: ~w", [Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%% 创建传送门 -> {X, Y}
do_create_tele_door() ->
    %%{X, Y} = util:rand_list(?TELE_POS_LIST),
    [{X, Y}|_] = ?TELE_POS_LIST,
    case map_data_elem:get(?MAP_ELEM_TELE_DOOR_BASE_ID) of
        Elem = #map_elem{} ->
            map:elem_enter(10003, Elem#map_elem{id = ?MAP_ELEM_TELE_DOOR_BASE_ID, x = X, y = Y});
        _ -> ignore
    end,
    {X, Y}.

%% 关闭传送门
do_close_tele_door() ->
    map:elem_leave(10003, ?MAP_ELEM_TELE_DOOR_BASE_ID).

%% 获取传送门可用次数 -> {CurNum, MaxNum}
get_tele_door_available_num() ->
    case sys_env:get(tele_door_available_num) of
        {CurNum, MaxNum} -> {CurNum, MaxNum};
        _ -> {0, 0}
    end.

%% 是否能通过传送门 -> true | false
can_use_tele_door() ->
    {CurNum, MaxNum} = get_tele_door_available_num(),
    case CurNum >= MaxNum of
        true -> false;
        false -> true
    end.

%% 传送门可用次数变更
do_change_tele_door_available_num(CurNumChangedVal, MaxNumChangedVal) ->
    {CurNum, MaxNum} = get_tele_door_available_num(),
    CurNum1 = util:check_range(CurNum + CurNumChangedVal, 0, CurNum + CurNumChangedVal),
    MaxNum1 = util:check_range(MaxNum + MaxNumChangedVal, 0, 100000),
    ?DEBUG("传送门情况：当前使用次数:~w，最大次数:~w",[CurNum1, MaxNum1]),
    sys_env:save(tele_door_available_num, {CurNum1, MaxNum1}).

%% 把传送门可用次数清零
do_clear_tele_door_available_num() ->
    sys_env:save(tele_door_available_num, {0, 0}).

%% 获取落脚点 -> {X, Y}
get_tele_pos(_Type = 1) ->
    util:rand_list(?TELE_POS_LIST);
get_tele_pos(_Type = 2) ->
    {4320, 5400};
get_tele_pos(_) ->
    {4320, 5400}.

%% 进入跨服地图：中心城
do_enter_center_city(Role = #role{id = RoleId, pid = RolePid, name = _Name, event = ?event_no}, MapId, X, Y, TripMgrPid) ->
    case catch map:role_enter(MapId, X, Y, Role#role{cross_srv_id = <<"center">>}) of
        {ok, NewRole} -> 
            ?DEBUG("[~s]进入中心城成功", [_Name]),
            TripMgrPid ! {enter_center_city_by_door_result, true, RoleId},
            {ok, NewRole};
        {false, _Why} -> 
            ?ERR("[~s]进入中心城失败:~s", [_Name, _Why]),
            role:pack_send(RolePid, 18304, {?false, ?L(<<"进入圣城失败">>)}),
            TripMgrPid ! {enter_center_city_by_door_result, false},
            {ok, Role};
        _Other ->
            ?ERR("[~s]进入中心城失败:~w", [_Name, _Other]),
            role:pack_send(RolePid, 18304, {?false, ?L(<<"进入圣城失败">>)}),
            TripMgrPid ! {enter_center_city_by_door_result, false},
            {ok, Role}
    end;
do_enter_center_city(Role = #role{pid = RolePid, name = _Name}, _, _, _, TripMgrPid) ->
    role:pack_send(RolePid, 18304, {?false, ?L(<<"当前状态下无法进入圣城">>)}),
    TripMgrPid ! {enter_center_city_by_door_result, false},
    {ok, Role}.

%% 离开跨服地图：中心城
do_leave_center_city(Role = #role{id = RoleId, pid = RolePid, name = _Name, event = _Event, cross_srv_id = <<"center">>}) ->
    {X, Y} = util:rand_list(?TELE_POS_LIST),
    case catch map:role_enter(10003, X, Y, Role#role{cross_srv_id = <<>>}) of
        {ok, NewRole} ->
            center:cast(c_trip_mgr, leave_center_city, [RoleId]),
            team_api:quit(NewRole),
            {ok, NewRole#role{event = ?event_no, event_pid = 0, cross_srv_id = <<>>}};
        {false, _Why} -> 
            ?ERR("[~s]离开中心城失败:~s", [_Name, _Why]),
            role:pack_send(RolePid, 18305, {?false, ?L(<<"离开圣城失败">>)}),
            {ok, Role};
        _Other ->
            ?ERR("[~s]离开中心城失败:~w", [_Name, _Other]),
            role:pack_send(RolePid, 18305, {?false, ?L(<<"离开圣城失败">>)}),
            {ok, Role}
    end;
do_leave_center_city(Role) ->
    {ok, Role}.

sync_leave_center_city(Role = #role{name = _Name, event = _Event, cross_srv_id = <<"center">>, pos = #pos{map_base_id = 36031}}) ->
    {X, Y} = util:rand_list(?TELE_POS_LIST),
    case catch map:role_enter(10003, X, Y, Role#role{cross_srv_id = <<>>}) of
        {ok, NewRole} ->
            NewRole1 = NewRole#role{event = ?event_no, event_pid = 0, cross_srv_id = <<>>},
            {ok, {true, NewRole1}, NewRole1};
        {false, _Why} -> 
            ?ERR("[~s]离开中心城失败:~s", [_Name, _Why]),
            {ok, false, Role};
        _Other ->
            ?ERR("[~s]离开中心城失败:~w", [_Name, _Other]),
            {ok, false, Role}
    end;
sync_leave_center_city(Role) ->
    {ok, {true, Role}, Role}.

%% 创建传送门开启
do_cost_item(Role, UseNum) ->
    LossList = [#loss{label = item, val = [33161, 0, UseNum]}],
    case role_gain:do(LossList, Role) of
        {false, #loss{msg = _Msg}} ->
            {ok, {false, ?L(<<"创建传送门失败">>)}, Role};
        {ok, NewRole} ->
            {ok, true, NewRole};
        _Any ->
            {ok, {false, ?L(<<"创建传送门失败">>)}, Role}
    end.
