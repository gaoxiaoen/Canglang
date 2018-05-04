%%----------------------------------------------------
%% 跨服比武场
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(cross_pk).
-export([
        get_status/0
        ,get_room_list/1
        ,role_enter/2
        ,role_update/1
        ,role_leave/1
        ,apply_enter_map/2
        ,apply_enter_map/3
        ,apply_leave_map/1
        ,get_roles/2
        ,logout/1
        %% ------------------
        ,check_duel/1
        ,check_duel_sync/1
        ,check_duel/2
        ,start_duel/2
        ,apply_duel_enter/2
        ,apply_cancel_duel_event/1
        ,notice_cast/3
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("cross_pk.hrl").
-include("attr.hrl").
-include("gain.hrl").
-include("pos.hrl").

%% 角色下线处理
logout(Role = #role{id = RoleId, event = ?event_pk_duel}) ->
    %% 清除event状态
    center:cast(c_cross_pk_mgr, duel_logout, [RoleId]),
    logout(Role#role{event = ?event_no});
logout(Role = #role{id = RoleId, pid = Pid, cross_srv_id = <<"center">>, pos = Pos = #pos{map = MapId, map_base_id = ?CROSS_PK_MAP}}) ->
    center:cast(c_cross_pk_mgr, role_leave, [RoleId, Pid, MapId]),
    team_api:quit(Role),
    {ok, Role#role{cross_srv_id = <<>>, pos = Pos#pos{map = 10003, x = 1620, y = 3540, map_base_id = 10003}}};
logout(Role) -> {ok, Role}.

%% 获取状态
get_status() ->
    case center:call(c_cross_pk_mgr, get_status, []) of
        {ok, {StatusId, Time}} -> {StatusId, Time};
        _ -> {0, 0}
    end.

%% 获取房间列表信息
get_room_list(#role{id = {_, SrvId}}) ->
    get_room_list(SrvId);
get_room_list(SrvId) ->
    case center:call(c_cross_pk_mgr, get_room_list, [SrvId]) of
        {ok, L} when is_list(L) -> L;
        _ -> []
    end.

%% 获取角色信息列表
get_roles(#role{pos = #pos{map = MapId}}, Page) -> 
    case center:call(c_cross_pk_mgr, get_roles, [MapId, Page]) of
        {ok, NowPage, RecordTotal, PageTotal, PageRoles} -> 
            {NowPage, RecordTotal, PageTotal, role_to_client(PageRoles, [])};
        _ -> {1, 0, 0, []}
    end.

%% 进入指定比武场
role_enter(Role, RoomId) ->
    case check_enter_pre(Role) of
        {false, Reason} -> {false, Reason};
        ok ->
            {ok, CrossRole} = role_convert:do(to_cross_pk_role, Role),
            center:cast(c_cross_pk_mgr, role_enter, [CrossRole, Role#role.pid, RoomId]),
            {ok}
    end.

%% 更新指定角色在比武场境中的信息
role_update(Role = #role{cross_srv_id = <<"center">>, pos = #pos{map = MapId, map_base_id = ?CROSS_PK_MAP}}) ->
    %% ?DEBUG("===============>~w, ~w, ~w", [Role#role.attr, Role#role.vip, Role#role.guild]),
    {ok, CrossRole} = role_convert:do(to_cross_pk_role, Role),
    center:cast(c_cross_pk_mgr, role_update, [CrossRole, MapId]);
role_update(_Role) -> ok.

%% 退出跨服比武场
role_leave(#role{event = ?event_pk_duel}) ->
    {false, ?L(<<"您在跨服决斗中，不要临阵逃脱，拿起武器战斗吧！">>)};
role_leave(Role = #role{cross_srv_id = <<"center">>, id = RoleId, pid = Pid, pos = #pos{map = MapId, map_base_id = ?CROSS_PK_MAP}}) ->
    center:cast(c_cross_pk_mgr, role_leave, [RoleId, Pid, MapId]),
    apply_leave_map(Role);
role_leave(_Role) ->
    {false, ?L(<<"您当前不在跨服比武场">>)}.

%% 异步回调：进入地图
apply_enter_map(Role, MapId) ->
    apply_enter_map(Role, MapId, 1).
apply_enter_map(Role = #role{id = RoleId, pid = Pid, link = #link{conn_pid = ConnPid}, cross_srv_id = <<>>}, MapId, RoomId) when RoomId >= 10000 ->
    GL = [#loss{label = coin, val = 50000}],
    case role_gain:do(GL, Role) of
        {false, _} ->
            center:cast(c_cross_pk_mgr, role_leave, [RoleId, Pid, MapId]),
            sys_conn:pack_send(ConnPid, 16904, {?coin_less, ?L(<<"金币不足">>)}),
            {ok};
        {ok, NRole} ->
            %% {X1, Y1} = util:rand_list([{1080,1230} ,{1920,1230} ,{1500,1410} ,{1500,1050}]), %% 随机点
            {X1, Y1} = util:rand_list([{1560,990} ,{3360,960} ,{3420,1770} ,{1620,1800}]), %% 随机点
            {X, Y} = {X1 + util:rand(-300, 300), Y1 + util:rand(-260, 260)},
            case map:role_enter(MapId, X, Y, NRole#role{cross_srv_id = <<"center">>}) of
                {ok, NewRole} -> 
                    sys_conn:pack_send(ConnPid, 16904, {1, <<>>}),
                    {ok, NewRole};
                _E ->
                    ?ERR("进入跨服比武场地图失败：~w", [_E]),
                    center:cast(c_cross_pk_mgr, role_leave, [RoleId, Pid, MapId]),
                    sys_conn:pack_send(ConnPid, 16904, {0, ?L(<<"进入跨服比武场地图失败">>)}),
                    {ok, NRole}
            end
    end;
apply_enter_map(Role = #role{id = RoleId, pid = Pid, link = #link{conn_pid = ConnPid}, cross_srv_id = <<>>}, MapId, _RoomId) ->
    %% {X1, Y1} = util:rand_list([{1080,1230} ,{1920,1230} ,{1500,1410} ,{1500,1050}]), %% 随机点
    {X1, Y1} = util:rand_list([{1560,990} ,{3360,960} ,{3420,1770} ,{1620,1800}]), %% 随机点
    {X, Y} = {X1 + util:rand(-300, 300), Y1 + util:rand(-260, 260)},
    case map:role_enter(MapId, X, Y, Role#role{cross_srv_id = <<"center">>}) of
        {ok, NewRole} -> 
            sys_conn:pack_send(ConnPid, 16904, {1, ?L(<<"现在在跨服比武场中组队可以报名仙道会哦，快试试吧">>)}),
            {ok, NewRole};
        _E ->
            ?ERR("进入跨服比武场地图失败：~w", [_E]),
            center:cast(c_cross_pk_mgr, role_leave, [RoleId, Pid, MapId]),
            sys_conn:pack_send(ConnPid, 16904, {0, ?L(<<"进入跨服比武场地图失败">>)}),
            {ok}
    end;
apply_enter_map(_Role, _MapId, _RoomId) ->
    ?ERR("跨服比武场，玩家异步进入跨服区地图异常[NAME:~s, SRV:~s]", [_Role#role.name, _Role#role.cross_srv_id]),
    {ok}.
apply_leave_map(Role = #role{cross_srv_id = <<"center">>, pos = #pos{map_base_id = ?CROSS_PK_MAP}}) ->
    Rand = util:rand(-100, 100),
    X = util:rand_list([1620, 1380]) + Rand,
    Y = util:rand_list([3540, 3720]) + Rand,
    team_api:quit(Role),
    case map:role_enter(10003, X, Y, Role#role{cross_srv_id = <<>>}) of
        {ok, NewRole} -> 
            {ok, NewRole};
        _E ->
            ?ERR("退出跨服比武场地图失败：~w", [_E]),
            {ok}
    end;
apply_leave_map(_Role) ->
    ?ERR("跨服比武场，玩家异步离开跨服区地图异常[NAME:~s, SRV:~s]", [_Role#role.name, _Role#role.cross_srv_id]),
    {ok}.

%% 检查是否可以决斗
check_duel(#role{status = Status, event = Event})
when Status =/= ?status_normal orelse Event =/= ?event_no ->
    {false, ?L(<<"当前状态不能发起决斗">>)};
check_duel(#role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {false, ?L(<<"组队状态不能发起决斗">>)};
check_duel(#role{attr = #attr{fight_capacity = Fight}}) when Fight < 8000 ->
    {false, ?L(<<"您的战斗力不足8000，无法发起决斗！">>)};
check_duel(#role{cross_srv_id = <<"center">>, pos = #pos{map = MapId, map_base_id = MapBaseId}}) when MapId =/= 36031 andalso MapBaseId =/= 30015 ->
    {false, ?L(<<"您不能在此地发起跨服决斗">>)};
check_duel(_) -> ok.

%% 同步检查是否可以决斗
check_duel_sync(#role{status = Status, event = Event})
when Status =/= ?status_normal orelse Event =/= ?event_no ->
    {ok, {false, ?L(<<"对方当前状态不能发起决斗">>)}};
check_duel_sync(#role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {ok, {false, ?L(<<"对方处于组队状态不能发起决斗">>)}};
check_duel_sync(#role{attr = #attr{fight_capacity = Fight}}) when Fight < 8000 ->
    {ok, {false, ?L(<<"对方的战斗力不足8000，无法发起决斗！">>)}};
check_duel_sync(#role{cross_srv_id = <<"center">>, pos = #pos{map = MapId, map_base_id = MapBaseId}}) when MapId =/= 36031 andalso MapBaseId =/= 30015 ->
    {false, ?L(<<"对方在参加跨服活动中，无法发起决斗">>)};
check_duel_sync(_) ->
    {ok, ok}.

%% @spec check_duel(Role, PkRoleId) -> {ok, PkPid} | {false, Msg}
%% @doc 检查是否可以跨服决斗
check_duel(Role, PkRoleId) ->
    case check_duel(Role) of
        {false, Msg} -> {false, Msg};
        ok ->
            case check_duel_item(Role) of
                {false, Msg} -> {false, Msg};
                ok ->
                    case role_api:c_lookup(by_id, PkRoleId, #role.pid) of
                        {ok, Node, _} when Node =:= node() -> {false, ?L(<<"决斗书只能对跨服玩家发起">>)};
                        {ok, _, Pid} ->
                            case role:c_apply(sync, Pid, {fun check_duel_sync/1, []}) of
                                ok -> {ok, Pid};
                                {false, Msg} -> {false, Msg};
                                _E ->
                                    ?DEBUG("_E:~w", [_E]),
                                    {false, ?L(<<"对方不在线">>)}
                            end;
                        _ -> {false, ?L(<<"对方不在线，无法发起决斗">>)}
                    end
            end
    end.

%% @spec start_duel(Role, PkPid) -> {ok} | {ok, NewRole} | {false, Msg}
%% Role = #role{} 被邀请人
%% PkPid = pid()
%% @doc 系统开启决斗
start_duel(Role = #role{pid = PkPid2}, PkPid1) ->
    NewRole = Role#role{event = ?event_pk_duel},
    PkRole2 = case role_convert:do(to_cross_pk_role, NewRole) of
        {ok, I} -> I;
        _ -> #cross_pk_role{}
    end,
    case role:c_apply(sync, PkPid1, {fun apply_start_duel/2, [PkRole2]}) of
        {ok, PkRole1} ->
            case node(PkPid1) =:= node() of
                true -> ok; %% 同服只公告一次
                false -> notice_cast(1, PkRole1, PkRole2)
            end,
            center:cast(c_cross_pk_mgr, duel_enter, [PkRole1, PkPid1, PkRole2, PkPid2]),
            {ok, NewRole};
        {false, Msg} -> {false, Msg};
        _ -> {false, ?L(<<"对方不在线">>)}
    end.

%% @spec apply_duel_enter(Role) -> {ok} | {ok, NewRole}
%% 异步回调：进入跨服决斗台
apply_duel_enter(Role = #role{id = RoleId, pid = Pid, link = #link{conn_pid = ConnPid}, cross_srv_id = <<>>}, MapId) ->
    {X1, Y1} = {2400, 1200},
    {X, Y} = {X1 + util:rand(-300, 300), Y1 + util:rand(-260, 260)},
    case map:role_enter(MapId, X, Y, Role#role{cross_srv_id = <<"center">>}) of
        {ok, NewRole} ->
            sys_conn:pack_send(ConnPid, 16904, {1, <<>>}),
            {ok, NewRole};
        _E ->
            center:cast(c_cross_pk_mgr, role_leave, [RoleId, Pid, MapId]),
            sys_conn:pack_send(ConnPid, 16904, {0, ?L(<<"进入跨服比武场地图失败">>)}),
            {ok}
    end;
apply_duel_enter(#role{cross_srv_id = <<"center">>, pos = #pos{map_base_id = ?CROSS_PK_MAP}}, _MapId) ->
    {ok};
apply_duel_enter(_Role, _MapId) ->
    ?DEBUG("跨服比武场，玩家异步进入跨服区地图异常[NAME:~s, SRV:~s]", [_Role#role.name, _Role#role.cross_srv_id]),
    {ok}.

%% @spec apply_cancel_duel_event(Role) -> {ok} | {ok, NewRole}
%% @doc 异步回调：取消跨服决斗活动状态
apply_cancel_duel_event(Role = #role{event = ?event_pk_duel}) ->
    NewRole = Role#role{event = ?event_no},
    map:role_update(NewRole),
    {ok, NewRole};
apply_cancel_duel_event(_) ->
    {ok}.

%% @spec notice_cast(Type, PkRole1, PkRole2) -> any()
%% @doc 跨服决斗书公告
notice_cast(1, #cross_pk_role{id = {Rid1, SrvId1}, name = Name1}, #cross_pk_role{id = {Rid2, SrvId2}, name = Name2}) ->
    RoleMsg1 = notice:role_to_msg({Rid1, SrvId1, Name1}),
    RoleMsg2 = notice:role_to_msg({Rid2, SrvId2, Name2}),
    notice:send(53, util:fbin(?L(<<"~s向~s发起了决斗，江湖恩怨，今日了结，且看胜负谁属！">>), [RoleMsg1, RoleMsg2]));
notice_cast({2, MapId}, {{Rid1, SrvId1}, Name1}, {{Rid2, SrvId2}, Name2}) ->
    RoleMsg1 = notice:role_to_msg({Rid1, SrvId1, Name1}),
    RoleMsg2 = notice:role_to_msg({Rid2, SrvId2, Name2}),
    Msg = util:fbin(?L(<<"~s与~s马上将进行决斗，大家快来决斗台围观。">>), [RoleMsg1, RoleMsg2]),
    map:pack_send_to_all(MapId, 10931, {53, Msg, []}); %% 中央服地图
notice_cast(3, {{Rid1, SrvId1}, Name1}, {{Rid2, SrvId2}, Name2}) ->
    RoleMsg1 = notice:role_to_msg({Rid1, SrvId1, Name1}),
    RoleMsg2 = notice:role_to_msg({Rid2, SrvId2, Name2}),
    Msg = util:fbin(?L(<<"~s在决斗中战胜了~s，胜负已分，成王败寇。">>), [RoleMsg1, RoleMsg2]),
    notice:send(53, Msg);
notice_cast(4, {{Rid1, SrvId1}, Name1}, {{Rid2, SrvId2}, Name2}) ->
    RoleMsg1 = notice:role_to_msg({Rid1, SrvId1, Name1}),
    RoleMsg2 = notice:role_to_msg({Rid2, SrvId2, Name2}),
    Msg = util:fbin(?L(<<"~s在跨服决斗中临阵脱逃，胜利属于~s">>), [RoleMsg1, RoleMsg2]),
    notice:send(53, Msg);
notice_cast(_, _, _) -> ok.

%%-------------------------------------
%% 内部方法
%%-------------------------------------

%% 检测是否可进入跨服比武场
check_enter_pre(#role{cross_srv_id = <<"center">>}) ->
    {false, ?L(<<"当然正在跨服场境中">>)};
check_enter_pre(#role{status = Status}) when Status =/= ?status_normal ->
    {false, ?L(<<"状态异常，不能进入">>)};
check_enter_pre(#role{event = Event}) when Event =/= ?event_no ->
    {false, ?L(<<"当前状态不能进入">>)};
check_enter_pre(#role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {false, ?L(<<"组队状态下无法进入">>)};
check_enter_pre(#role{ride = ?ride_fly}) ->
    {false, ?L(<<"飞行状态不能进入">>)};
check_enter_pre(#role{attr = #attr{fight_capacity = FightCapacity}}) when FightCapacity < 8000 ->
    {false, ?L(<<"很可惜，您的战斗力不足8000，无法进入，请努力修炼再来吧！">>)};
check_enter_pre(_) -> ok.

%% 角色信息转换
role_to_client([], L) -> lists:reverse(L);
role_to_client([#cross_pk_role{id = {Rid, SrvId}, name = Name, sex = Sex, career = Career, lev = Lev, vip = Vip, guild = Guild, fight_capacity = FC, team_pid = TeamPid, status = Status} | T], L) ->
    Team = case TeamPid =:= 0 of
        true -> 1;
        _ -> 2
    end,
    RoleInfo = {Rid, SrvId, Name, Sex, Career, Lev, Vip, Guild, FC, Team, Status},
    role_to_client(T, [RoleInfo | L]).

check_duel_item(Role) ->
    case storage_api:has_item(?CROSS_DUEL_BOOK, Role) of
        true -> ok;
        false ->
            {false, ?L(<<"您背包没有决斗书，无法发起决斗">>)}
    end.

%% 同步开启决斗，设置event
apply_start_duel(Role, PkRole2) ->
    case check_duel(Role) of
        {false, Msg} -> {ok, {false, Msg}};
        ok ->
            L = [#loss{label = item, val = [?CROSS_DUEL_BOOK, 0, 1], msg = ?L(<<"对方没有决斗书，无法发起决斗">>)}],
            case role_gain:do(L, Role) of
                {false, #loss{msg = Msg}} -> {ok, {false, Msg}};
                {ok, Role1} ->
                    NewRole = Role1#role{event = ?event_pk_duel},
                    PkRole = case role_convert:do(to_cross_pk_role, NewRole) of
                        {ok, I} -> I;
                        _ -> #cross_pk_role{}
                    end,
                    notice_cast(1, PkRole, PkRole2),
                    {ok, {ok, PkRole}, NewRole}
            end
    end.

