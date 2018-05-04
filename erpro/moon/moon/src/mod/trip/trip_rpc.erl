%%----------------------------------------------------
%% 跨服旅行 远程调用
%% @author yankai@jieyou.cn
%%----------------------------------------------------
-module(trip_rpc).
-export([
        handle/3
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("center.hrl").
%%
-include("attr.hrl").
-include("gain.hrl").

%% 获取可选平台
handle(18301, _, #role{pid = Pid}) ->
    trip_mgr:get_optional_platform(Pid),
    {ok};

%% 获取可选服务器
handle(18302, {Platform}, #role{pid = Pid}) ->
    trip_mgr:get_optional_srv(Platform, Pid),
    {ok};

%% 获取传送门信息
handle(18303, _, #role{pid = Pid}) ->
    trip_mgr:get_tele_door_info(Pid),
    {ok};

%% 传送门操作
handle(18304, _, #role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {reply, {?false, ?L(<<"组队状态下不能使用传送门">>)}};
handle(18304, _, #role{attr = #attr{fight_capacity = RolePower}}) when RolePower < 6500 ->
    {reply, {?false, util:fbin(?L(<<"当前无法进入圣城，战斗力不足~w">>), [6500])}};
handle(18304, _, #role{lev = Lev}) when Lev < 52 ->
    {reply, {?false, util:fbin(?L(<<"当前无法进入圣城，等级不足~w">>), [52])}};
handle(18304, {Type}, Role = #role{event = ?event_no}) ->
    case trip_mgr:is_enter_limited() of
        true ->
            {reply, {?false, ?L(<<"当前无法进入圣城，太拥挤了">>)}};
        false ->
            trip_mgr:enter_center_city_by_door(Role, Type),
            {ok}
    end;
handle(18304, _, _Role) ->
    {reply, {?false, ?L(<<"当前状态无法通过传送门">>)}};

%% 离开中心城
handle(18305, _, Role = #role{event = ?event_no, cross_srv_id = <<"center">>}) ->
    trip_mgr:leave_center_city(Role),
    {ok};
handle(18305, _, #role{cross_srv_id = <<"center">>}) ->
    {reply, {?false, ?L(<<"当前正在参加活动，无法离开圣城">>)}};
handle(18305, _, _Role) ->
    {ok};

%% 开启传送门
handle(18306, {_Platform, SrvId, UseNum}, #role{id = RoleId, name = Name, pid = Pid}) when UseNum > 0 ->
    trip_mgr:create_tele_door(SrvId, UseNum, RoleId, Pid, Name),
    {ok};

%% 穿过固定传送门，花费金币进入中心城
handle(18307, _, #role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {reply, {?false, ?L(<<"组队状态下不能使用传送门">>)}};
handle(18307, _, #role{attr = #attr{fight_capacity = RolePower}}) when RolePower < 6500 ->
    {reply, {?false, util:fbin(?L(<<"当前无法进入圣城，战斗力不足~w">>), [6500])}};
handle(18307, _, #role{lev = Lev}) when Lev < 52 ->
    {reply, {?false, util:fbin(?L(<<"当前无法进入圣城，等级不足~w">>), [52])}};
handle(18307, _, Role = #role{event = ?event_no, cross_srv_id = <<>>, combat_pid = CombatPid}) when not is_pid(CombatPid) ->
    case trip_mgr:is_enter_limited() of
        true -> {reply, {?false, ?L(<<"当前无法进入圣城，太拥挤了">>)}};
        false ->
            case center:is_connect() of
                false ->
                    {reply, {?false, ?L(<<"时空不稳定，暂时不能使用时光穿梭">>)}};
                _ ->
                    LL = [#loss{label = coin_all, val = 5000}],
                    case role_gain:do(LL, Role) of
                        {false, Reason} -> 
                            {reply, {?false, Reason}};
                        {ok, Role1} ->
                            trip_mgr:enter_center_city_by_coin(Role1),
                            {ok, Role1}
                    end
            end
    end;
handle(18307, _, _Role) ->
    {reply, {?false, ?L(<<"当前状态下无法进入圣城">>)}};

handle(_Cmd, _Data, _Role = #role{name = _Name}) ->
    ?ERR("收到[~s]发送的无效信息[Cmd:~w Data:...]", [_Name, _Cmd]),
    {ok}.
