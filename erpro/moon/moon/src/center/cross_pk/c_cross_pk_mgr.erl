%%----------------------------------------------------
%% 跨服比武场
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(c_cross_pk_mgr).
-behaviour(gen_fsm).
-export(
    [
        start_link/0
        ,get_status/0
        ,get_room_list/1
        ,role_enter/3
        ,role_update/2
        ,role_leave/3
        ,get_roles/2
        ,lookup/2
        ,apply/2
        %% -----------跨服决斗书
        ,find/1
        ,duel_enter/4
        ,duel_logout/1
    ]
).
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).
-export([idle/2, prepare/2, active/2]).

-include("common.hrl").
-include("role.hrl").
-include("cross_pk.hrl").
-include("map.hrl").
-record(state, {
        ts = 0              %% 进入某状态时刻
        ,timeout_val = 0    %% 空间时间(不是固定的)
    }
).

-define(CROSS_PK_TIME, 3600).  
-define(CROSS_PK_CAMP_START, util:datetime_to_seconds({{2012, 9, 10}, {0, 0, 0}})). %% 活动开始时间
-define(CROSS_PK_CAMP_END, util:datetime_to_seconds({{2012, 10, 2}, {23, 59, 59}})). %% 活动结束时间

%% @spec get_status() -> {ok, {Status, Time}}
%% @doc 获取当前状态
get_status() ->
    gen_fsm:sync_send_all_state_event(?MODULE, get_status).

%% 进入指定比武场
role_enter(Role, RolePid, RoomId) ->
    gen_fsm:send_all_state_event(?MODULE, {role_enter, Role, RolePid, RoomId}).

%% 更新比武场角色信息
role_update(Role, MapId) ->
    gen_fsm:send_all_state_event(?MODULE, {role_update, Role, MapId}).

%% 退出比武场
role_leave(RoleId, RolePid, MapId) ->
    gen_fsm:send_all_state_event(?MODULE, {role_leave, RoleId, RolePid, MapId}).

%% 获取已创建房间信息
get_room_list(SrvId) ->
    L = ets:tab2list(cross_pk_map_list),
    NotCampList = [Map || Map <- L, Map#cross_pk_map.id < 10000],
    case c_mirror_group:get_platform(SrvId) of
        Platform when Platform =:= <<"4399">> orelse Platform =:= "4399" -> get_room_list(L, []);
        _ -> get_room_list(NotCampList, [])
    end.
get_room_list([], L) -> 
    {ok, L};
get_room_list([Map | T], L) ->
    get_room_list(T, [room_to_client(Map) | L]).
room_to_client(#cross_pk_map{id = Id, num = Num}) -> {Id, Num, lists:max([Num, ?CROSS_PK_MAP_MAX_NUM])}.

%% 获取指定分区内角色信息
get_roles(MapId, Page) ->
    case lookup(by_mapid, MapId) of
        #cross_pk_map{roles = Roles} ->
            role_page(Roles, Page);
        _ -> 
            {ok, 1, 0, 0, []}
    end.

%% 截取角色
role_page(Roles, Page) ->
    RecordTotal = length(Roles),
    PageTotal = util:ceil(RecordTotal / ?CROSS_PK_PAGE_SIZE),
    NowPage = if
        Page < 1 orelse PageTotal =:= 0 -> 1;
        Page > PageTotal -> PageTotal;
        true -> Page
    end,
    Start = (NowPage - 1) * ?CROSS_PK_PAGE_SIZE,
    PageRoles = lists:sublist(Roles, Start + 1, ?CROSS_PK_PAGE_SIZE),
    {ok, NowPage, RecordTotal, PageTotal, PageRoles}.

%% 查看指定房间信息
lookup(by_id, RoomId) ->
    L = ets:tab2list(cross_pk_map_list),
    lists:keyfind(RoomId, #cross_pk_map.id, L);
lookup(by_mapid, MapId) ->
    L = ets:tab2list(cross_pk_map_list),
    lists:keyfind(MapId, #cross_pk_map.map_id, L).

%% 查找可以进入N数量玩家的房间
find(N) ->
    L = [H | _] = ets:tab2list(cross_pk_map_list),
    case find(N, L) of
        false -> H; %% 默认进第一张图
        Room -> Room
    end.
find(_N, []) -> false;
find(N, [Room = #cross_pk_map{id = Id, num = Num} | T]) when Id < 10000 ->
    case N + Num =< ?CROSS_PK_MAP_MAX_NUM of
        true -> Room;
        false -> find(N, T)
    end;
find(N, [_ | T]) ->
    find(N, T).

%% 处理玩家进入决斗场
duel_enter(PkRole1, PkPid1, PkRole2, PkPid2) ->
    gen_fsm:send_all_state_event(?MODULE, {duel_enter, PkRole1, PkPid1, PkRole2, PkPid2}).

%% 处理玩家掉线/下线
duel_logout(RoleId) ->
    gen_fsm:send_all_state_event(?MODULE, {duel_logout, RoleId}).

apply(async, timeout) ->
    gen_fsm:send_event(?MODULE, timeout);
apply(async, Event) ->
    gen_fsm:send_all_state_event(?MODULE, Event);
apply(sync, Event) ->
    gen_fsm:sync_send_all_state_event(?MODULE, Event).

start_link()->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

%% --------------------------------------------------------------------
%% function callback
%% --------------------------------------------------------------------

init([])->
    ?INFO("正在启动..."),
    process_flag(trap_exit, true),
    ets:new(cross_pk_map_list, [set, named_table, protected, {keypos, #cross_pk_map.id}]),
    ets:new(ets_cross_duel_roles, [set, named_table, public, {keypos, #cross_duel_role.id}]),
    State = #state{ts = util:unixtime(), timeout_val = ?CROSS_PK_TIME},
    new_map(),
    new_map(),
    new_map(),
    self() ! check_camp_time,
    ?INFO("启动完成"),
    {ok, active, State, ?CROSS_PK_TIME * 1000}.

%% 指定决斗角色进入跨服决斗台
handle_event({duel_enter, PkRole1 = #cross_pk_role{id = RoleId1, name = Name1}, RolePid1, PkRole2 = #cross_pk_role{id = RoleId2, name = Name2}, RolePid2}, active, State) ->
    RoomMap = #cross_pk_map{id = RoomId, map_id = MapId, roles = PkRoles} = find(2),
    role:apply(async, RolePid1, {cross_pk, apply_duel_enter, [MapId]}),
    role:apply(async, RolePid2, {cross_pk, apply_duel_enter, [MapId]}),
    NewPkRoles = add_role_to_list([PkRole1, PkRole2], PkRoles),
    update_ets(RoomMap#cross_pk_map{num = length(NewPkRoles), roles = rank_roles(NewPkRoles)}),
    DuelRole1 = to_duel_role(RolePid1, PkRole1, RolePid2, PkRole2),
    DuelRole2 = to_duel_role(RolePid2, PkRole2, RolePid1, PkRole1),
    case catch c_cross_duel:start([DuelRole1#cross_duel_role{room_id = RoomId}, DuelRole2#cross_duel_role{room_id = RoomId}]) of
        {ok, _DuelPid} ->
            c_cross_duel:send_duel_info(PkRole1, RolePid1, PkRole2, RolePid2),
            cross_pk:notice_cast({2, MapId}, {RoleId1, Name1}, {RoleId2, Name2});
        _E ->
            ?ERR("跨服决斗进程开启失败:~w", [_E]),
            role:apply(async, RolePid1, {cross_pk, apply_cancel_duel_event, []}),
            role:apply(async, RolePid2, {cross_pk, apply_cancel_duel_event, []})
    end,
    continue(active, State);
handle_event(_E = {duel_enter, _, _, _, _}, StateName, State) ->
    ?DEBUG("错误的决斗进入消息：~w", [_E]),
    continue(StateName, State);

%% 指定角色处理跨服决斗中下线
handle_event({duel_logout, RoleId}, active, State) ->
    case ets:lookup(ets_cross_duel_roles, RoleId) of
        [] ->
            ?ERR("跨服决斗，处理异常的登出消息:~w", [RoleId]),
            ignore;
        [#cross_duel_role{duel_pid = DuelPid}] when is_pid(DuelPid) ->
            c_cross_duel:over(DuelPid, RoleId); %% 由决斗进程判定胜负
        [#cross_duel_role{info = PkRole, pk_pid = RolePid2, pk_info = PkRole2}] ->
            c_cross_duel:cancel_duel(RolePid2, PkRole, PkRole2)
    end,
    continue(active, State);

%% 角色进入跨服比武场
handle_event({role_enter, Role = #cross_pk_role{id = {_, SrvId}}, RolePid, RoomId}, active, State) ->
    Platform = c_mirror_group:get_platform(SrvId),
    case lookup(by_id, RoomId) of
        false -> 
            role:pack_send(RolePid, 16904, {0, ?L(<<"请求进入的房间不存在">>)});
        #cross_pk_map{} when RoomId > 10000 andalso Platform =/= <<"4399">> andalso Platform =/= "4399" ->
            role:pack_send(RolePid, 16904, {0, ?L(<<"平台标志不正常，不可以进入">>)});
        #cross_pk_map{num = Num} when Num >= ?CROSS_PK_MAP_MAX_NUM ->
            role:pack_send(RolePid, 16904, {0, ?L(<<"该房间已满人，不可以再进入">>)});
        Map = #cross_pk_map{num = _Num, map_id = MapId, roles = Roles} ->
            Roles0 = case lists:keyfind(Role#cross_pk_role.id, #cross_pk_role.id, Roles) of
                false -> [Role | Roles];
                _ -> Roles
            end,
            NewRoles = rank_roles(Roles0),
            NewMap = Map#cross_pk_map{num = length(NewRoles), roles = NewRoles},
            update_ets(NewMap),
            check_need_open_map(),
            role:apply(async, RolePid, {cross_pk, apply_enter_map, [MapId, RoomId]})
    end,
    continue(active, State);
handle_event({role_enter, _RoleId, RolePid, _RoleId}, StateName, State) ->
    role:pack_send(RolePid, 16904, {0, ?L(<<"当前未开启跨服比武场所，不能报名参加">>)}),
    continue(StateName, State);

%% 更新角色
handle_event({role_update, Role = #cross_pk_role{id = RoleId}, MapId}, StateName, State) ->
    case lookup(by_mapid, MapId) of
        Map = #cross_pk_map{num = Num, roles = Roles} ->
            case lists:keyfind(RoleId, #cross_pk_role.id, Roles) of
                false -> %% 处理角色在下线时 中央服重启 需重新注册
                    NewRoles = rank_roles([Role | Roles]),
                    NewMap = Map#cross_pk_map{num = Num + 1, roles = NewRoles},
                    update_ets(NewMap),
                    check_need_open_map();
                _ when Role#cross_pk_role.fight_capacity > 0 ->
                    NRoles = lists:keyreplace(RoleId, #cross_pk_role.id, Roles, Role),
                    NewRoles = rank_roles(NRoles),
                    NewMap = Map#cross_pk_map{roles = NewRoles},
                    update_ets(NewMap);
                _ -> skip
            end;
        _ -> skip
    end,
    continue(StateName, State);

%% 角色退出
handle_event({role_leave, RoleId, _RolePid, MapId}, StateName, State) ->
    case lookup(by_mapid, MapId) of
        Map = #cross_pk_map{num = Num, roles = Roles} when Num > 0 ->
            NewRoles = [Role || Role <- Roles, Role#cross_pk_role.id =/= RoleId],
            NewMap = Map#cross_pk_map{num = length(NewRoles), roles = NewRoles},
            update_ets(NewMap),
            del_empty_map();
        _ -> skip
    end,
    continue(StateName, State);

handle_event(_Event, StateName, State) ->
    {next_state, StateName, State}.

%% 获取当前状态
handle_sync_event(get_status, _From, StateName, State) ->
    Fun = fun(active) -> {?cross_pk_status_active, 0};
        (idle) -> {?cross_pk_status_idle, 0};
        (prepare) -> {?cross_pk_status_pre, 0}
    end,
    Reply = {ok, Fun(StateName)},
    continue(StateName, Reply, State);

handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    {reply, Reply, StateName, State}.

%% 定时检查活动是否开始
handle_info(check_camp_time, StateName, State) ->
    Now = util:unixtime(),
    case Now >= ?CROSS_PK_CAMP_START andalso Now < ?CROSS_PK_CAMP_END of
        true -> %% 在活动时间在 检查是否需要开活动联赛专用区
            L = ets:tab2list(cross_pk_map_list),
            CampList = [Map || Map <- L, Map#cross_pk_map.id >= 10000],
            case check_full_map(CampList) of
                true -> 
                    Id = next_map_id(CampList, 10000),
                    ?DEBUG("建立新活动专区[~p]", [Id]),
                    new_map(Id);
                false -> ok
            end;
        false -> %% 活动结束 回收专用区
            L = ets:tab2list(cross_pk_map_list),
            CampList = [Map || Map <- L, Map#cross_pk_map.id >= 10000],
            kick_out(CampList),
            destroy_map(CampList)
    end,
    erlang:send_after(5000, self(), check_camp_time),
    {next_state, StateName, State};

handle_info(_Info, StateName, State) ->
    {next_state, StateName, State}.

terminate(_Reason, StateName, _State) ->
    case StateName =:= active of
        true ->
            %% c_mirror_group:cast(all, role_group, pack_cast, [world, 16901, {?cross_pk_status_idle, 0}]),
            L = ets:tab2list(cross_pk_map_list),
            kick_out(L),
            destroy_map(L);
        false -> ignore
    end,
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%%------------------------------------
%% 内部方法
%%------------------------------------

%% 空闲状态
idle(_Event, State) ->
    ?INFO("~w 状态下收到消息 ~w", [state_idel, _Event]),
    continue(idle, State).

%% 准备状态
prepare(_Event, State) ->
    ?INFO("~w 状态下收到消息 ~w", [state_prepare, _Event]),
    continue(prepare, State).

%% 活动状态
active(timeout, State) ->
    check_map_role(),
    continue(active, State#state{ts = util:unixtime(), timeout_val = ?CROSS_PK_TIME});
active(_Event, State) ->
    continue(active, State).

%% 继续下一个状态
continue(StateName, State = #state{ts = Ts, timeout_val = TimeVal}) ->
    {next_state, StateName, State, time_left(TimeVal, Ts)}.

continue(StateName, Reply, State = #state{ts = Ts, timeout_val = TimeVal}) ->
    {reply, Reply, StateName, State, time_left(TimeVal, Ts)}.

%% 重新计算剩余时间
time_left(TimeVal, Ts) ->
    EndTime = Ts + TimeVal,
    Now = util:unixtime(),
    case EndTime - Now of
        T when T > 0 -> T * 1000;
        _ -> 1000
    end.

%%----------------------------
%% 分区处理
%%----------------------------

%% 获取下一个分区唯一值
next_map_id() ->
    L = ets:tab2list(cross_pk_map_list),
    next_map_id(L, 0).
next_map_id([], MaxId) -> MaxId + 1;
next_map_id([#cross_pk_map{id = Id} | T], MaxId) ->
    case Id > MaxId of
        true -> next_map_id(T, Id);
        false -> next_map_id(T, MaxId)
    end.

%% 生成一个新区
new_map() ->
    Id = next_map_id(),
    new_map(Id).
new_map(Id) ->
    case map_mgr:create(?CROSS_PK_MAP) of
        {ok, MapPid, MapId} ->
            Map = #cross_pk_map{id = Id, map_id = MapId, map_pid = MapPid},
            update_ets(Map);
        _ ->
            ?ERR("新建跨服准备区地图失败"),
            false
    end.

%% 检查是否需要开新区 如果存在未满区 直接返回
check_need_open_map() ->
    L = ets:tab2list(cross_pk_map_list),
    case check_full_map(L) of
        true -> new_map();
        false -> ok
    end.

%% 检查是否可以回收空区 区域从后删除
del_empty_map() ->
    L = ets:tab2list(cross_pk_map_list),
    del_empty_map(L).
del_empty_map(L) when length(L) > 3 ->
    LastId = length(L),
    case lists:keyfind(LastId, #cross_pk_map.id, L) of
        #cross_pk_map{roles = [], map_pid = MapPid} ->
            OtherL = lists:keydelete(LastId, #cross_pk_map.id, L),
            case check_full_map(OtherL) of
                false -> skip;
                _ -> %% 可以删除空区
                    ets:delete(cross_pk_map_list, LastId),
                    map:stop(MapPid),
                    del_empty_map(OtherL)
            end;
        _ -> skip
    end;
del_empty_map(_L) -> ok.

%% 检查分区是否已爆满
check_full_map(L) ->
    NumList = [?CROSS_PK_MAP_MAX_NUM - Num || #cross_pk_map{num = Num} <- L, Num < ?CROSS_PK_MAP_MAX_NUM],
    CanInRoleNum = lists:sum(NumList),
    CanInRoleNum < 10.

%% 角色列表排序
rank_roles(Roles) ->
    Roles0 = lists:keysort(#cross_pk_role.lev, Roles),
    Roles1 = lists:keysort(#cross_pk_role.fight_capacity, Roles0),
    lists:reverse(Roles1).

%% 更新ETS
update_ets(Map) when is_record(Map, cross_pk_map) ->
    ets:insert(cross_pk_map_list, Map).

%% 销毁地图
destroy_map([]) -> ok;
destroy_map([I | T]) ->
    destroy_map(I),
    destroy_map(T);
destroy_map(#cross_pk_map{map_pid = MapPid}) ->
    map:stop(MapPid).

%% 踢出地图
kick_out([]) -> ok;
kick_out([I | T]) ->
    kick_out(I),
    kick_out(T);
kick_out(#cross_pk_map{id = Id, roles = Roles}) ->
    lists:foreach(fun(#cross_pk_role{id = RoleId}) ->
            case c_proxy:role_lookup(by_id, RoleId, #role.pid) of
                {ok, _Node, Pid} ->
                    role:apply(async, Pid, {cross_pk, apply_leave_map, []});
                _ ->
                    ok
            end
    end, Roles),
    ets:delete(cross_pk_map_list, Id).

%% 对角色校验 如果角色不在地图上 不出现在列表中
check_map_role() ->
    L = ets:tab2list(cross_pk_map_list),
    ?DEBUG("同步校验数据....."),
    check_map_role(L).
check_map_role([]) -> ok;
check_map_role([Map = #cross_pk_map{map_id = MapId, roles = Roles} | T]) ->
    MapRoles = map:role_list(MapId),
    MapRoleRids = [{Rid, SrvId} || #map_role{rid = Rid, srv_id = SrvId} <- MapRoles],
    NewRoles = [Role || Role <- Roles, lists:member(Role#cross_pk_role.id, MapRoleRids)],
    update_ets(Map#cross_pk_map{roles = NewRoles, num = length(NewRoles)}),
    check_map_role(T).

%% -------------------------------------------------------
%% 跨服决斗相关内部函数
%% -------------------------------------------------------

%% 判断处理决斗玩家进入比武场列表
add_role_to_list([], L) -> L;
add_role_to_list([H | T], L) ->
    NewL = add_role_to_list(H, L),
    add_role_to_list(T, NewL);
add_role_to_list(PkRole = #cross_pk_role{id = PkRoleId}, L) ->
    case lists:keyfind(PkRoleId, #cross_pk_role.id, L) of
        false -> [PkRole | L];
        _ -> L
    end.

%% 转换玩家信息
to_duel_role(RolePid1, PkRole1 = #cross_pk_role{id = RoleId1}, RolePid2, PkRole2 = #cross_pk_role{id = RoleId2}) ->
    #cross_duel_role{
        id = RoleId1, pid = RolePid1, info = PkRole1, pk_id = RoleId2, pk_pid = RolePid2, pk_info = PkRole2
    }.
