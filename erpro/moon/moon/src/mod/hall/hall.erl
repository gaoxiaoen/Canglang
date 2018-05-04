%% --------------------------------------------------------------------
%% 大厅
%% @author mobin
%% @end
%% --------------------------------------------------------------------
-module(hall).

-behaviour(gen_server).

%% export functions
-export([
        start_link/1,
        stop/1
    ]).

-export([
        enter/2
        ,enter_and_create_room/3
        ,direct_enter_room/3
        ,leave/2
        ,login_leave/2
        ,role_login/2
        ,role_logout/2
        ,back_to_hall/1
        ,destory_room/2
        ,create_room/3
        ,enter_room/3
        ,fast_enter_room/3
        ,leave_room/2
        ,change_room/2
        ,prepare/2
        ,cancel/2
        ,room_start/2
        ,room_end_combat/2
        ,room_end_combat/3
        ,remove_member/3
        ,room_list/4
        ,room_members/2
        ,invite/3
        ,add_friends/2
        ,world_invite/2
        ,chat/2
        ,gm_clear_empty_room/0
    ]).

%% 用于debug
-export([
        debug/2
        ,info/2
    ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-define(page_size, 3).

%% include
-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("attr.hrl").
-include("vip.hrl").
-include("pos.hrl").
-include("hall.hrl").
-include("notification.hrl").
%%
-include("guild.hrl").
-include("looks.hrl").
-include("pet.hrl").
-include("chat_rpc.hrl").

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% @spec start_link(HallBase) -> {ok,Pid} | ignore | {error,Error}
%% 开启大厅
start_link(HallBase) ->
    gen_server:start_link(?MODULE, [HallBase], []).

%% @spec stop(Pid) -> 
%% 关闭大厅
stop(Pid) ->
    info(Pid, {stop}).

enter(Hall = #hall{id = HallId, pid = HallPid}, Role) ->
    case hall_type:check_enter(Hall, Role) of
        ok ->
            HallPid ! {enter, to_hall_role(Role)},
            Role2 = Role#role{event = ?event_hall, event_pid = HallPid,
                hall = #role_hall{id = HallId, pid = HallPid}},
            {ok, Role2};
        {false, ReasonId} ->
            {false, ReasonId}
    end.

enter_and_create_room(Hall = #hall{pid = HallPid}, RoomType, Role) ->
    case hall_type:check_enter(Hall, Role) of
        ok ->
            HallPid ! {enter_and_create_room, RoomType, to_hall_role(Role)},
            {ok};
        {false, ReasonId} ->
            {false, ReasonId}
    end.

%% @spec room_list(HallId, PageNo, PageSize, #role{}} ->
%% HallId = PageNo = PageSize = integer()
%% 获取房间列表
room_list(HallId, Type, PageIndex, #role{cross_srv_id = CrossSrvId}) ->
    case hall_mgr:get_hall(CrossSrvId, HallId) of
        {ok, #hall{pid = HallPid}} ->
            gen_server:call(HallPid, {room_list, Type, PageIndex});
        _ ->
            {false, ?MSGID(<<"当前状态不能打开此大厅">>)}
    end.

add_friends(HallId, Role = #role{cross_srv_id = CrossSrvId, link = #link{conn_pid = ConnPid}}) ->
    case hall_mgr:get_hall(CrossSrvId, HallId) of
        {ok, #hall{pid = HallPid}} ->
            Targets = gen_server:call(HallPid, {add_friends, to_hall_role(Role)}),
            Targets2 = lists:filter(fun(#hall_role{id = TargetRid}) ->
                        not friend:check_friend_or_applied_to(Role, TargetRid)
                end, Targets),
            ?DEBUG("hall:add_friends[~w] filter[~w]", [length(Targets), length(Targets2)]),
            case length(Targets2) > 0 of
                true ->
                    sys_conn:pack_send(ConnPid, 16530, {Targets});
                false ->
                    ignore
            end;
        _ ->
            ignore
    end,
    {ok}.
    
%% @spec leave(HallPid, Role) -> {ok, NewRole}
%% 离开大厅
leave(HallId, Role = #role{pid = RolePid, cross_srv_id = CrossSrvId}) ->
    case hall_mgr:get_hall(CrossSrvId, HallId) of
        {ok, #hall{pid = HallPid}} ->
            HallPid ! {leave, to_hall_role(Role)};
        _ ->
            role:apply(async, RolePid, {fun apply_leave/1, []})
    end,
    {ok}.

login_leave(HallId, Role = #role{cross_srv_id = CrossSrvId}) ->
    case hall_mgr:get_hall(CrossSrvId, HallId) of
        {ok, #hall{pid = HallPid}} ->
            HallPid ! {login_leave, to_hall_role(Role)};
        _ ->
            ignore
    end,
    {ok}.

%% @spec direct_enter_room(HallId, RoomNo, Role) -> {ok, NewRole} | {false, Reason}
%% HallId = integer()
%% RoomNo = integer()
%% Role = NewRole = #role{}
%% Reason = bitstring()
%% 直接进入房间
direct_enter_room(HallId, RoomNo, Role = #role{cross_srv_id = CrossSrvId, event = Event, hall = RoleHall}) ->
    case hall_mgr:get_hall(CrossSrvId, HallId) of
        {ok, Hall = #hall{pid = HallPid}} ->
            LeaveReply = case Event =:= ?event_hall andalso RoleHall#role_hall.pid =/= HallPid of
                true -> %% 跨大厅邀请
                    gen_server:call(RoleHall#role_hall.pid, {leave2, to_hall_role(Role)});
                _ ->
                    true
            end,
            case LeaveReply of
                true ->
                    case hall_type:check_enter(Hall, Role) of
                        ok ->
                            enter_room(HallId, RoomNo, Role),
                            ok;
                        {false, Reason} ->
                            {false, Reason}
                    end;
                {false, Reason} ->
                    {false, Reason}
            end;
        _ ->
            {false, ?MSGID(<<"当前状态不能打开此大厅">>)}
    end.

%% @spec role_login(HallPid, Role) -> {ok} | {false}
%% HallPid = pid()
%% Role = NewRole = #role{}
%% 玩家在大厅中上线
role_login(HallId, HallRole = #hall_role{}) ->
    case hall_mgr:get_hall(<<>>, HallId) of
        {ok, #hall{pid = HallPid}} ->
            ?CATCH(gen_server:call(HallPid, {role_login, HallRole}));
        _ ->
            ignore
    end;
role_login(HallPid, Role) when is_pid(HallPid) ->
    ?CATCH(gen_server:call(HallPid, {role_login, to_hall_role(Role)}));
role_login(_HallPid, _Role) ->
    false.

%% @spec role_logout(HallPid, Role) 
%% HallPid = pid()
%% Role = #role{}
%% 玩家在大厅中下线
role_logout(HallId, HallRole = #hall_role{}) ->
    case hall_mgr:get_hall(<<>>, HallId) of
        {ok, #hall{pid = HallPid}} ->
            HallPid ! {role_logout, HallRole};
        _ ->
            ignore
    end;
role_logout(HallPid, Role) ->
    info(HallPid, {role_logout, to_hall_role(Role)}).

%%打完回到房间
back_to_hall(Role = #role{cross_srv_id = CrossSrvId, hall = #role_hall{id = HallId}, pos = #pos{last = Last}}) ->
    case hall_mgr:get_hall(CrossSrvId, HallId) of
        {ok, Hall = #hall{pid = HallPid}} ->
            case catch gen_server:call(HallPid, {back_to_hall, to_hall_role(Role)}) of
                ok ->
                    Role2 = #role{pos = Pos2}= hall_type:enter_room(Hall, Role),
                    %%确保上一地图是进入大厅前的地图
                    Role2#role{event = ?event_hall, pos = Pos2#pos{last = Last}};
                _ ->
                    Role#role{event = ?event_no, event_pid = 0, hall = #role_hall{}}
            end;
        _ ->
            Role#role{event = ?event_no, event_pid = 0, hall = #role_hall{}}
    end.

%% 销毁房间
destory_room(HallId, RoomNo) ->
    case hall_mgr:get_hall(<<>>, HallId) of
        {ok, #hall{pid = HallPid}} ->
            HallPid ! {destory_room, RoomNo};
        _ ->
            ignore
    end.

%% @spec create_room(HallPid, Role) 
%% 创建房间
create_room(HallId, RoomType, Role = #role{cross_srv_id = CrossSrvId}) ->
    case hall_mgr:get_hall(CrossSrvId, HallId) of
        {ok, #hall{pid = HallPid}} ->
            HallPid ! {create_room, RoomType, to_hall_role(Role)},
            {ok};
        _ ->
            {false, ?MSGID(<<"当前状态不能打开此大厅">>)}
    end.

%% @spec enter_room(HallId, RoomId, Role) 
%% 进入房间
enter_room(HallId, RoomNo, Role = #role{cross_srv_id = CrossSrvId}) ->
    case hall_mgr:get_hall(CrossSrvId, HallId) of
        {ok, #hall{pid = HallPid}} ->
            HallPid ! {enter_room, RoomNo, to_hall_role(Role)},
            {ok};
        _ ->
            {false, ?MSGID(<<"当前状态不能打开此大厅">>)}
    end.

%% @spec fast_enter_room(HallId, Role) 
%% 快速进入房间
fast_enter_room(HallId, Type, Role = #role{cross_srv_id = CrossSrvId}) ->
    case hall_mgr:get_hall(CrossSrvId, HallId) of
        {ok, #hall{pid = HallPid}} ->
            HallPid ! {fast_enter_room, Type, to_hall_role(Role), 0},
            {ok};
        _ ->
            {false, ?MSGID(<<"当前状态不能打开此大厅">>)}
    end.

%% @spec leave_room(HallId, Role) -> 
%% HallId = integer()
%% Role = #role{}
%% 离开房间
leave_room(HallId, Role = #role{cross_srv_id = CrossSrvId}) ->
    case hall_mgr:get_hall(CrossSrvId, HallId) of
        {ok, #hall{pid = HallPid}} ->
            HallPid ! {leave_room, to_hall_role(Role)},
            {ok};
        _ ->
            {false, ?MSGID(<<"当前状态不能打开此大厅">>)}
    end.

change_room(HallId, Role = #role{cross_srv_id = CrossSrvId}) ->
    case hall_mgr:get_hall(CrossSrvId, HallId) of
        {ok, #hall{pid = HallPid}} ->
            HallPid ! {change_room, to_hall_role(Role)},
            {ok};
        _ ->
            {false, ?MSGID(<<"当前状态不能打开此大厅">>)}
    end.

%% @spec prepare(HallId, Role) -> 
%% HallId = integer()
%% Role = #role{}
%% 房间里准备
prepare(HallId, Role = #role{cross_srv_id = CrossSrvId, link = #link{conn_pid = ConnPid}}) ->
    case hall_mgr:get_hall(CrossSrvId, HallId) of
        {ok, #hall{pid = HallPid}} ->
            HallPid ! {change_status, ?hall_role_status_prepare, to_hall_role(Role)};
        _ ->
            notice:alert(error, ConnPid, ?MSGID(<<"当前状态不能打开此大厅">>))
    end.

%% @spec cancel(HallId, Role) 
%% HallId = integer()
%% Role = #role{}
%% 取消准备状态
cancel(HallId, Role = #role{cross_srv_id = CrossSrvId, link = #link{conn_pid = ConnPid}}) ->
    case hall_mgr:get_hall(CrossSrvId, HallId) of
        {ok, #hall{pid = HallPid}} ->
            HallPid ! {change_status, ?hall_role_status_common, to_hall_role(Role)};
        _ ->
            notice:alert(error, ConnPid, ?MSGID(<<"当前状态不能打开此大厅">>))
    end.

%% @room_start(HallId, Role) -> {ok} | {false, Reason}
%% HallId = integer()
%% Role = #role{}
%% Reason = bitstring()
%% 房间开始
room_start(HallId, Role = #role{cross_srv_id = CrossSrvId}) ->
    case hall_mgr:get_hall(CrossSrvId, HallId) of
        {ok, #hall{pid = HallPid}} ->
            gen_server:call(HallPid, {room_start, to_hall_role(Role)});
        _ ->
            {false, ?MSGID(<<"当前状态不能打开此大厅">>)}
    end.

%% @room_end_combat(HallId, RoomNo) ->
%% HallId = integer()
%% RoomNo = integer()
%% 房间的战斗结束
room_end_combat(HallId, RoomNo) ->
    room_end_combat(HallId, RoomNo, true).

%% PrepareFlag = true | false
%% true: 不处理准备状态
%% false: 把准备状态都重置为 不准备
room_end_combat(HallId, RoomNo, PrepareFlag) ->
    case hall_mgr:get_hall(<<>>, HallId) of
        {ok, #hall{pid = HallPid}} ->
            info(HallPid, {room_end_combat, RoomNo, PrepareFlag}),
            {ok};
        _ ->
            {false, ?L(<<"当前状态不能打开此大厅">>)}
    end.

%% HallId = integer()
%% Role = #role{}
%% Reason = bitstring()
%% 房间管理
remove_member({RoleId, SrvId}, HallId, Role = #role{cross_srv_id = CrossSrvId}) ->
    case hall_mgr:get_hall(CrossSrvId, HallId) of
        {ok, #hall{pid = HallPid}} ->
            gen_server:call(HallPid, {remove_member, {RoleId, SrvId}, to_hall_role(Role)});
        _ ->
            {false, ?L(<<"当前状态不能打开此大厅">>)}
    end.


%% @spec room_members(HallId, #role{}) 
%% HallId = integer()
%% 获取房间里的成员列表
room_members(HallId, Role = #role{cross_srv_id = CrossSrvId}) ->
    case hall_mgr:get_hall(CrossSrvId, HallId) of
        {ok, #hall{pid = HallPid}} ->
            info(HallPid, {room_members, to_hall_role(Role)});
        _ ->
            {false, ?L(<<"当前状态不能打开此大厅">>)}
    end.

%% @spec invite(HallId, Rid, Role) -> {ok} | {false, Reason}
%% HallId = integer()
%% Rid = rid()
%% Role = #role{}
%% Reason = bitstring()
%% 邀请进入房间
invite(HallId, InviteRids, Role = #role{cross_srv_id = CrossSrvId}) ->
    case hall_mgr:get_hall(CrossSrvId, HallId) of
        {ok, Hall = #hall{pid = HallPid}} ->
            InvitePids = hall_type:deal_invite(Hall, InviteRids, Role),
            gen_server:call(HallPid, {invite, InvitePids, to_hall_role(Role)});
        _ ->
            {false, ?MSGID(<<"当前状态不能打开此大厅">>)}
    end.

world_invite(HallId, Role = #role{cross_srv_id = CrossSrvId}) ->
    case hall_mgr:get_hall(CrossSrvId, HallId) of
        {ok, #hall{pid = HallPid}} ->
            gen_server:call(HallPid, {world_invite, to_hall_role(Role)});
        _ ->
            {false, ?MSGID(<<"当前状态不能打开此大厅">>)}
    end.

%% 房间聊天
chat(#role{link = #link{conn_pid = ConnPid}, hall = #role_hall{id = HallId}, cross_srv_id = CrossSrvId, id = Rid = {RoleId, SrvId},
        name = Name, sex = Sex}, Msg) ->
    case hall_mgr:get_hall(CrossSrvId, HallId) of
        {ok, #hall{pid = HallPid}} ->
            Reply = {?chat_hall_room, RoleId, SrvId, Name, Sex, 0, [], [], Msg},
            HallPid ! {chat, Rid, ConnPid, Reply};
        _ ->
            notice:alert(error, ConnPid, ?MSGID(<<"您还没加入房间">>))
    end.

gm_clear_empty_room() ->
    case expedition:get_hall() of
        {ok, #hall{pid = HallPid}} ->
            HallPid ! {clear};
        _ ->
            ok
    end.

%% 打印调试信息
debug(HallId, Type) ->
    case hall_mgr:get_hall(<<>>, HallId) of
        {ok, #hall{pid = HallPid}} ->
            info(HallPid, {debug, Type});
        _ ->
            ?ERR("不存在大厅: ~w", [HallId])
    end.

%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------

%% @spec init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
init([Hall = #hall{id = Id, type = Type}]) ->
    ?DEBUG("开启大厅: type = ~w", [Type]),
    process_flag(trap_exit, true),
    erlang:register(list_to_atom(lists:concat(["hall_", Type, "_", Id])), self()),
    NewHall = Hall#hall{pid = self()},
    put(role_list, []),
    put(room_list, []),
    sync(NewHall),

    {ok, NewHall}.

%% @spec: handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages

%% 玩家在大厅中上线
handle_call({role_login, #hall_role{id = Rid = {RoleId, SrvId}, pid = Pid, conn_pid = ConnPid}}, _From, State) ->
    RoleList = get(role_list),
    Reply = case lists:keyfind(Rid, #hall_role.id, RoleList) of
        HallRole = #hall_role{name = _Name, room_no = RoomNo} when RoomNo =/= 0 ->
            RoomList = get(room_list),
            case lists:keyfind(RoomNo, #hall_room.room_no, RoomList) of
                false ->
                    ignore;
                Room = #hall_room{status = Status, leader = Leader, members = Members} ->
                    case lists:keyfind(Rid, #hall_role.id, Members) of
                        #hall_role{} ->
                            HallRole2 = HallRole#hall_role{pid = Pid, conn_pid = ConnPid, status = ?hall_role_status_common},
                            update_role(HallRole2, RoleList),

                            ?DEBUG("角色[~s]登陆大厅", [_Name]),
                            Members2 = lists:keyreplace(Rid, #hall_role.id, Members, HallRole2),
                            Room2 = Room#hall_room{members = Members2},
                            update_room(Room2),
                            case Status of
                                ?hall_room_status_fight ->
                                    ignore;
                                _ ->
                                    cast_all_members([Leader | Members], 16521, {RoleId, SrvId, ?hall_role_status_common}),
                                    pack_send_room_members(Pid, Room2)
                            end;
                        _ ->
                            #hall_role{id = LeaderId} = Leader,
                            case LeaderId =:= Rid of
                                true ->
                                    %%role_switch 房主情况
                                    HallRole2 = HallRole#hall_role{pid = Pid, conn_pid = ConnPid, status = ?hall_role_status_common},
                                    ?DEBUG("角色[~s]登陆大厅", [_Name]),
                                    update_role(HallRole2, RoleList),
                                    Room2 = Room#hall_room{leader = HallRole2},
                                    update_room(Room2),
                                    case Status of
                                        ?hall_room_status_fight ->
                                            ignore;
                                        _ ->
                                            pack_send_room_members(Pid, Room2)
                                    end;
                                false ->
                                    ignore
                            end
                    end
            end,
            {ok};
        _ ->
            false
    end,
    {reply, Reply, State};

%% 接受邀请，离开大厅
handle_call({leave2, #hall_role{id = Rid}}, _From, State) ->
    RoleList = get(role_list),
    Reply = case lists:keyfind(Rid, #hall_role.id, RoleList) of
        false ->
            true;
        #hall_role{room_no = RoomNo} when RoomNo =/= 0 ->
            {false, ?L(<<"您已在房间里">>)};
        _ ->
            put(role_list, lists:keydelete(Rid, #hall_role.id, RoleList)),
            true
    end,
    {reply, Reply, State};

handle_call({back_to_hall, #hall_role{id = Rid, pid = Pid}}, _From, State) ->
    RoleList = get(role_list),
    Reply = case lists:keyfind(Rid, #hall_role.id, RoleList) of
        false ->
            false;
        #hall_role{room_no = RoomNo} when RoomNo =/= 0 ->
            case lists:keyfind(RoomNo, #hall_room.room_no, get(room_list)) of
                Room = #hall_room{} ->
                    pack_send_room_members(Pid, Room),
                    ok;
                _ ->
                    false
            end;
        _ ->
            false
    end,
    {reply, Reply, State};

%% 房间开始
handle_call({room_start, #hall_role{id = Rid}}, _From, State = #hall{type = _Type}) ->
    Result = case get_hall_role(Rid) of
        #hall_role{room_no = RoomNo} ->
            case lists:keyfind(RoomNo, #hall_room.room_no, get(room_list)) of
                #hall_room{status = ?hall_room_status_fight} ->
                    {false, ?MSGID(<<"房间已经开始">>)};
                #hall_room{leader = #hall_role{id = LeaderId}} when LeaderId =/= Rid ->
                    {false, ?MSGID(<<"您不是房主，请由房主发起">>)};
                _Room = #hall_room{} ->
                    _Room;
                _ ->
                    {false, ?MSGID(<<"您不在房间里">>)}
            end;
        _Other ->
            _Other
    end,
    Reply = case Result of
        Room = #hall_room{leader = Leader, members = Members} ->
            case [M || M = #hall_role{status = Status} <- Members, Status =/= ?hall_role_status_prepare] of
                [] ->
                    update_room(Room#hall_room{status = ?hall_room_status_fight, mates = [Leader | Members]}),
                    cast_all_members([Leader | Members], 16517, {}),
                    hall_type:room_start(State, Room),
                    {ok};
                _ ->
                    {false, ?MSGID(<<"还有成员未准备">>)}
            end;
        Other ->
            Other
    end,
    {reply, Reply, State};

handle_call({remove_member, RemoveRid, #hall_role{id = Rid}}, _From, State = #hall{type = HallType}) ->
    Reply = case get_hall_role(Rid) of
        #hall_role{room_no = RoomNo} ->
            case lists:keyfind(RoomNo, #hall_room.room_no, get(room_list)) of
                #hall_room{leader = #hall_role{id = Rid}} ->
                    case lists:keyfind(RemoveRid, #hall_role.id, get(role_list)) of
                        HallRole = #hall_role{status = Status, conn_pid = ConnPid} ->
                            self() ! {leave_room, HallRole},
                            %%竞技场大厅要同时踢出大厅
                            case HallType =:= ?hall_type_compete orelse Status =:= ?hall_role_status_offline of
                                true ->
                                    self() ! {leave, HallRole},
                                    ok;
                                _ ->
                                    ok
                            end,
                            notice:alert(error, ConnPid, ?MSGID(<<"您被房主请出了房间">>));
                        _ ->
                            ok
                    end,
                    {ok};
                _ ->
                    {false, ?MSGID(<<"您不是房主，不能进行设置">>)}
            end;
        Other ->
            Other
    end,
    {reply, Reply, State};

%% 房间列表
handle_call({room_list, Type, PageIndex}, _From, State) ->
    RoomList = case Type =:= 0 of
        true ->
            %%全部房间
            [Room || Room = #hall_room{status = ?hall_room_status_common} <- get(room_list)];
        false ->
            %%过滤
            [Room || Room = #hall_room{status = ?hall_room_status_common, room_type = RoomType} <- get(room_list), RoomType =:= Type]
    end,
    RoomList2 = lists:reverse(RoomList),

    TotalPage = util:ceil(length(RoomList2) / ?page_size),
    SubList = case PageIndex > TotalPage of
        true ->
            [];
        false ->
            lists:sublist(RoomList2, (PageIndex - 1) * ?page_size + 1, ?page_size)
    end,
    Reply = {TotalPage, to_room_list(SubList)},
    {reply, Reply, State};

handle_call({add_friends, #hall_role{id = Rid}}, _From, State) ->
    Reply = case lists:keyfind(Rid, #hall_role.id, get(role_list)) of
        #hall_role{room_no = RoomNo} when RoomNo =/= 0 ->
            case lists:keyfind(RoomNo, #hall_room.room_no, get(room_list)) of
                #hall_room{mates = Mates} ->
                    lists:foldl(fun(Target = #hall_role{id = TargetRid}, Return) ->
                                case TargetRid =:= Rid of
                                    true ->
                                        Return;
                                    false ->
                                        [Target | Return]
                                end
                        end, [], Mates);
                _ ->
                    []
            end;
        _ ->
            []
    end,
    {reply, Reply, State};

%% 邀请玩家进入房间
handle_call({invite, InvitePids, #hall_role{id = Rid, name = Name}}, _From, State = #hall{id = HallId}) ->
    Reply = case get_hall_role(Rid) of
        #hall_role{room_no = RoomNo} ->
            case lists:keyfind(RoomNo, #hall_room.room_no, get(room_list)) of
                #hall_room{room_type = RoomType} ->
                    lists:foreach(fun(InvitePid) -> 
                                Msg = hall_type:get_invite_msg(State, Name, RoomType),
                                notification:send(online, InvitePid, ?notify_type_hall, Msg, [HallId, RoomNo])
                        end, InvitePids);
                _ ->
                    ignore
            end,
            {ok};
        Other ->
            Other
    end,
    {reply, Reply, State};

%% 世界邀请
handle_call({world_invite, #hall_role{id = Rid = {RoleId, SrvId}, name = Name, sex = Sex}}, _From, State = #hall{id = _HallId}) ->
    Reply = case get_hall_role(Rid) of
        #hall_role{room_no = RoomNo} ->
            case lists:keyfind(RoomNo, #hall_room.room_no, get(room_list)) of
                #hall_room{room_type = RoomType} ->
                    Msg = hall_type:get_world_invite_msg(State, Name, RoomType, RoomNo),
                    role_group:pack_cast(world, 10910, {1, RoleId, SrvId, Name, Sex, 0, [], [], Msg});
                _ ->
                    ignore
            end,
            {ok};
        Other ->
            Other
    end,
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%% @spec: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
handle_cast(_Msg, State) ->
    {noreply, State}.

%% @spec: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages

%% 进入大厅
handle_info({enter, HallRole = #hall_role{}}, State) ->
    add_role(HallRole),
    {noreply, State};


%% 离开大厅
handle_info({leave, HallRole = #hall_role{id = Rid, pid = RolePid}}, State) ->
    case lists:keyfind(Rid, #hall_role.id, get(role_list)) of
        false ->
            ignore;
        _ ->
            role_leave_room(HallRole),
            remove_role(Rid)
    end,
    role:apply(async, RolePid, {fun apply_leave/1, []}),
    {noreply, State};

handle_info({login_leave, HallRole = #hall_role{id = Rid}}, State) ->
    case lists:keyfind(Rid, #hall_role.id, get(role_list)) of
        false ->
            ignore;
        _ ->
            role_leave_room(HallRole),
            remove_role(Rid)
    end,
    {noreply, State};

%% 下线
handle_info({role_logout, #hall_role{id = Rid}}, State) ->
    RoleList = get(role_list),
    case lists:keyfind(Rid, #hall_role.id, RoleList) of
        HallRole = #hall_role{room_no = RoomNo} when RoomNo =/= 0 ->
            case lists:keyfind(RoomNo, #hall_room.room_no, get(room_list)) of
                Room = #hall_room{} ->
                    update_role(HallRole#hall_role{status = ?hall_role_status_offline}, RoleList),
                    logout_room(Room, HallRole),
                    ok;
                _ ->
                    remove_role(Rid)
            end;
        false ->
            ok;
        #hall_role{} ->
            remove_role(Rid)
    end,
    {noreply, State};

handle_info({enter_and_create_room, RoomType, HallRole = #hall_role{id = Rid, conn_pid = ConnPid, pid = RolePid}},
    State) ->
    add_role(HallRole),
    State2 = case apply_room(RoomType, HallRole, State) of
        false ->
            remove_role(Rid),
            State;
        RoomNo ->
            sys_conn:pack_send(ConnPid, 16503, {RoomNo}),
            role:apply(async, RolePid, {fun async_enter_hall/2, [State]}),
            State#hall{base_room_no = RoomNo}
    end,
    {noreply, State2};

%% 创建房间
handle_info({create_room, RoomType, #hall_role{id = Rid, conn_pid = ConnPid}}, State) ->
    RoleList = get(role_list),
    NewState = case lists:keyfind(Rid, #hall_role.id, RoleList) of
        false ->
            State;
        #hall_role{room_no = CurRoomNo} when CurRoomNo =/= 0 ->
            notice:alert(error, ConnPid, ?MSGID(<<"您已在房间里">>)),
            State;
        HallRole = #hall_role{} ->
            case apply_room(RoomType, HallRole, State) of
                false ->
                    State;
                RoomNo ->
                    sys_conn:pack_send(ConnPid, 16511, {RoomNo}),
                    State#hall{base_room_no = RoomNo}
            end
    end,
    {noreply, NewState};

%% 销毁房间
handle_info({destory_room, RoomNo}, State = #hall{}) ->
    case lists:keyfind(RoomNo, #hall_room.room_no, get(room_list)) of
        %%只销毁已开始的房间
        #hall_room{status = ?hall_room_status_fight, room_no = RoomNo, leader = Leader, members = Members} ->
            remove_room(RoomNo),
            lists:foreach(fun(#hall_role{id = Rid}) -> remove_role(Rid) end, [Leader | Members]);
        _ ->
            ok
    end,
    {noreply, State};

%% 进入房间
handle_info({enter_room, RoomNo, HallRole = #hall_role{id = Rid, conn_pid = ConnPid, pid = RolePid}}, State) ->
    case lists:keyfind(RoomNo, #hall_room.room_no, get(room_list)) of
        #hall_room{status = Status} when Status =/= ?hall_room_status_common ->
            notice:alert(error, ConnPid, ?MSGID(<<"房间已开始了战斗，请稍候再进入">>));
        #hall_room{limit_count = Limit, members = Member} when Limit =< (length(Member) + 1) ->
            notice:alert(error, ConnPid, ?MSGID(<<"房间人数已满">>));
        Room = #hall_room{room_type = RoomType, members = Members} ->
            case hall_type:check_enter_room(State, RoomType, HallRole) of
                ok ->
                    RoleList = get(role_list),
                    case lists:keyfind(Rid, #hall_role.id, RoleList) of
                        false ->
                            add_role(HallRole#hall_role{room_no = RoomNo}),
                            role:apply(async, RolePid, {fun async_enter_hall/2, [State]}),
                            update_room_and_inform(Room#hall_room{members = [HallRole | Members]});
                        #hall_role{room_no = CurRoomNo} when CurRoomNo =/= 0 ->
                            notice:alert(error, ConnPid, ?MSGID(<<"您已在房间里">>));
                        #hall_role{} ->
                            update_room_and_inform(Room#hall_room{members = [HallRole | Members]}),
                            update_role(HallRole#hall_role{room_no = RoomNo}, RoleList)
                    end;
                {false, ReasonId} ->
                    notice:alert(error, ConnPid, ReasonId)
            end;
        _ ->
            sys_conn:pack_send(ConnPid, 16512, {}),
            notice:alert(error, ConnPid, ?MSGID(<<"房间不存在">>))
    end,
    {noreply, State};

handle_info({change_status, NewStatus, #hall_role{id = Rid = {RoleId, SrvId}, name = _Name, conn_pid = ConnPid}}, State) ->
    case get_hall_role(Rid) of
        #hall_role{room_no = RoomNo} ->
            case lists:keyfind(RoomNo, #hall_room.room_no, get(room_list)) of
                Room = #hall_room{leader = Leader, members = Members} ->
                    case lists:keyfind(Rid, #hall_role.id, Members) of
                        HallRole = #hall_role{status = Status} when Status =/= NewStatus ->
                            Members2 = lists:keyreplace(Rid, #hall_role.id, Members, HallRole#hall_role{status = NewStatus}),
                            Room2 = Room#hall_room{members = Members2},
                            update_room(Room2),
                            cast_all_members([Leader | Members2], 16521, {RoleId, SrvId, NewStatus});
                        _ ->
                            ?DEBUG("角色[~s]新状态[~w]", [_Name, NewStatus]),
                            ignore
                    end;
                _ ->
                    notice:alert(error, ConnPid, ?MSGID(<<"您不在房间里">>))
            end;
        {false, ReasonId} ->
            notice:alert(error, ConnPid, ReasonId)
    end,
    {noreply, State};

%% 自动加入
handle_info({fast_enter_room, RoomType, HallRole = #hall_role{id = Rid, conn_pid = ConnPid}, ExceptRoomNo}, State) ->
    case lists:keyfind(Rid, #hall_role.id, get(role_list)) of
        false ->
            ok;
        #hall_role{room_no = CurRoomNo} when CurRoomNo =/= 0 ->
            notice:alert(error, ConnPid, ?MSGID(<<"您已在房间里">>));
        #hall_role{} ->
            RoomList = get(room_list),
            RoomList1 = case ExceptRoomNo =:= 0 of
                true ->
                    RoomList;
                false ->
                    [Room || Room = #hall_room{room_no = RoomNo} <- RoomList, RoomNo =/= ExceptRoomNo]
            end,

            RoomList2 = case RoomType =:= 0 of
                true ->
                    RoomList1;
                false ->
                    [Room || Room = #hall_room{room_type = Type} <- RoomList1, Type =:= RoomType]
            end,

            case hall_type:match_room(State, HallRole, RoomType, RoomList2) of
                false ->
                    notice:alert(error, ConnPid, ?MSGID(<<"没有找到合适的房间">>));
                {ok, RoomNo} ->
                    self() ! {enter_room, RoomNo, HallRole}
            end
    end,
    {noreply, State};

%% 离开房间
handle_info({leave_room, HallRole}, State = #hall{}) ->
    role_leave_room(HallRole),
    {noreply, State};

%% 换房
handle_info({change_room, HallRole = #hall_role{id = Rid}}, State) ->
    case lists:keyfind(Rid, #hall_role.id, get(role_list)) of
        #hall_role{room_no = RoomNo} when RoomNo =/= 0 ->
            case lists:keyfind(RoomNo, #hall_room.room_no, get(room_list)) of
                #hall_room{room_type = RoomType} ->
                    self() ! {leave_room, HallRole},
                    self() ! {fast_enter_room, RoomType, HallRole, RoomNo};
                _ ->
                    ignore
            end;
        _ ->
            ignore
    end,
    {noreply, State};

%% 获取房间成员列表
handle_info({room_members, #hall_role{id = Rid, pid = Rpid}}, State) ->
    case lists:keyfind(Rid, #hall_role.id, get(role_list)) of
        false ->
            ok;
        #hall_role{room_no = 0} ->
            ok;
        #hall_role{room_no = RoomNo} ->
            case lists:keyfind(RoomNo, #hall_room.room_no, get(room_list)) of
                Room = #hall_room{} ->
                    pack_send_room_members(Rpid, Room),
                    ok;
                _ ->
                    ok
            end
    end,
    {noreply, State};

%% 房间战斗结束
handle_info({room_end_combat, RoomNo, _}, State) ->
    case lists:keyfind(RoomNo, #hall_room.room_no, get(room_list)) of
        Room = #hall_room{leader = Leader, members = Members} ->
            All = [Leader | Members],
            IsAllOffline = lists:foldl(fun(#hall_role{status = Status}, Flag) ->
                        case Status of
                            ?hall_role_status_offline ->
                                Flag;
                            _ ->
                                false
                        end
                end, true, All),
            case IsAllOffline of
                true ->
                    %%玩家掉光要删除房间
                    remove_room(RoomNo),
                    lists:foreach(fun(#hall_role{id = Rid}) -> remove_role(Rid) end, [Leader | Members]);
                _ ->
                    Members2 = lists:map(fun(HallRole = #hall_role{id = {RoleId, SrvId}, status = Status}) ->
                                case Status of
                                    ?hall_role_status_offline ->
                                        HallRole;
                                    _ ->
                                        cast_all_members(All, 16521, {RoleId, SrvId, ?hall_role_status_common}),
                                        HallRole#hall_role{status = ?hall_role_status_common} 
                                end
                        end, Members),
                    update_room(Room#hall_room{status = ?hall_room_status_common, members = Members2})
            end;
        _ ->
            ok
    end,
    {noreply, State};

%% 清理死房间
handle_info({clear}, State = #hall{}) ->
    lists:foreach(fun(#hall_room{status = ?hall_room_status_common, room_no = RoomNo, leader = Leader, members = Members}) ->
                All = [Leader | Members],
                OffCount = lists:foldl(fun(#hall_role{id = Rid}, Return) -> 
                            case role_api:get_pid(Rid) of
                                undefined ->
                                    Return + 1;
                                _ ->
                                    Return
                            end
                    end, 0, All),
                case OffCount =:= length(All) of 
                    true ->
                        remove_room(RoomNo);
                    false ->
                        ignore
                end;
            (_) ->
                ok
        end, get(room_list)),
    {noreply, State};

handle_info({chat, Rid, ConnPid, Reply}, State) ->
    case lists:keyfind(Rid, #hall_role.id, get(role_list)) of
        #hall_role{room_no = RoomNo} ->
            case lists:keyfind(RoomNo, #hall_room.room_no, get(room_list)) of
                #hall_room{leader = Leader, members = Members} ->
                    lists:foreach(fun(#hall_role{status = Status, conn_pid = TargetConnPid}) ->
                                case Status =:= ?hall_role_status_offline of
                                    true ->
                                        ok;
                                    _ ->
                                        sys_conn:pack_send(TargetConnPid, 10910, Reply)
                                end
                        end, [Leader | Members]);
                _ ->
                    notice:alert(error, ConnPid, ?MSGID(<<"您还没加入房间">>))
            end;
        _ ->
            notice:alert(error, ConnPid, ?MSGID(<<"您还没加入房间">>))
    end,
    {noreply, State};

%% 关闭大厅
handle_info({stop}, State = #hall{id = Id}) ->
    lists:foreach(fun(#hall_role{pid = RolePid}) ->
                role:apply(async, RolePid, {fun apply_leave/1, []})
        end, get(role_list)),
    catch ets:delete(hall_info, Id),
    {stop, normal, State};

%% 打印调试信息
handle_info({debug, hall}, State) ->
    ?INFO("hall : ~w", [State]),
    {noreply, State};
handle_info({debug, role}, State) ->
    ?INFO("hall role : ~w", [get(role_list)]),
    {noreply, State};
handle_info({debug, room}, State) ->
    ?INFO("hall room : ~w", [get(room_list)]),
    {noreply, State};
handle_info(_Info, State) ->
    {noreply, State}.

%% @spec: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
terminate(_Reason, _State) ->
    ok.

%% @spec: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------

%% 同步大厅在线信息
sync(Hall) when is_record(Hall, hall) ->
    ets:insert(hall_info, Hall).

%% 异步调用
info(Pid, Msg) when is_pid(Pid) ->
    Pid ! Msg;
info(_Pid, _Msg) ->
    ok.

apply_room(RoomType, HallRole = #hall_role{conn_pid = ConnPid}, State = #hall{base_room_no = BaseRoomNo}) ->
    case hall_type:check_enter_room(State, RoomType, HallRole) of
        ok ->
            case apply_room_no(BaseRoomNo) of
                false ->
                    notice:alert(error, ConnPid, ?MSGID(<<"房间过多，暂时不能再创建房间">>)),
                    false;
                RoomNo ->
                    HallRoom = hall_type:create_room(State, HallRole),
                    HallRoom2 = HallRoom#hall_room{room_no = RoomNo, room_type = RoomType, leader = HallRole},

                    update_role(HallRole#hall_role{room_no = RoomNo}, get(role_list)),
                    add_room(HallRoom2),

                    RoomNo
            end;
        {false, ReasonId} ->
            notice:alert(error, ConnPid, ReasonId),
            false
    end.

%% 将role角色转换为hall_role
to_hall_role(#role{id = Id, pid = Pid, link = #link{conn_pid = ConnPid}, name = Name, sex = Sex, career = Career, lev = Lev, attr = #attr{fight_capacity = FightCapacity}, vip = #vip{type = VipType}, guild = #role_guild{name = Gname}, pet = #pet_bag{active = Active}, looks = Looks}) ->
    PetFc = case Active of
        #pet{fight_capacity = Pfc} ->
            Pfc;
        _ ->
            0
    end,
    #hall_role{id = Id, pid = Pid, conn_pid = ConnPid, name = Name, sex = Sex, career = Career, lev = Lev, fight_capacity = FightCapacity, vip_type = VipType, guild_name = Gname, pet_fight_capacity = PetFc, looks = Looks};
to_hall_role(#role{id = Id, pid = Pid, link = #link{conn_pid = ConnPid}, name = Name, sex = Sex, career = Career, lev = Lev, vip = #vip{type = VipType}, guild = #role_guild{name = Gname}, looks = Looks}) ->
    #hall_role{id = Id, pid = Pid, conn_pid = ConnPid, name = Name, sex = Sex, career = Career, lev = Lev, fight_capacity = 1, pet_fight_capacity = 0, vip_type = VipType, guild_name = Gname, looks = Looks}.

%% 申请房间号
apply_room_no(BaseRoomNo) ->
    RoomList = get(room_list),
    apply_room_no(BaseRoomNo, BaseRoomNo + 1, RoomList).
apply_room_no(RoomNo1, RoomNo2, _) when RoomNo1 =:= RoomNo2 ->
    false;
apply_room_no(RoomNo1, RoomNo2, RoomList) when RoomNo2 > 9999 ->
    apply_room_no(RoomNo1, 1, RoomList);
apply_room_no(RoomNo1, RoomNo2, RoomList) ->
    case lists:keyfind(RoomNo2, #hall_room.room_no, RoomList) of
        false ->
            RoomNo2;
        _ ->
            apply_room_no(RoomNo1, RoomNo2 + 1, RoomList)
    end.

add_role(HallRole = #hall_role{id = Rid}) ->
    RoleList = get(role_list),
    case lists:keyfind(Rid, #hall_role.id, RoleList) of
        false ->
            put(role_list, [HallRole | RoleList]);
        _ ->
            ok
    end.

update_role(HallRole = #hall_role{id = Rid}, RoleList) ->
    RoleList2 = lists:keyreplace(Rid, #hall_role.id, RoleList, HallRole),
    put(role_list, RoleList2).

remove_role(Rid) ->
    RoleList = get(role_list),
    put(role_list, lists:keydelete(Rid, #hall_role.id, RoleList)).

async_enter_hall(Role = #role{}, Hall = #hall{id = HallId, pid = HallPid}) ->
    Role2 = Role#role{event = ?event_hall, event_pid = HallPid, hall = #role_hall{id = HallId, pid = HallPid}},
    Role3 = hall_type:enter_room(Hall, Role2),
    {ok, Role3}.

update_leave_room(Room = #hall_room{room_no = RoomNo, status = Status, leader = Leader = #hall_role{id = LeaderId}, members = Members}, #hall_role{id = Rid}) ->
    case LeaderId =:= Rid of
        false ->
            NewMembers = lists:keydelete(Rid, #hall_role.id, Members),
            NewRoom = Room#hall_room{members = NewMembers},
            update_room_and_inform(NewRoom),
            ok;
        true ->
            case change_leader(Members) of
                NewLeader = #hall_role{id = NewLeaderId} ->
                    NewMembers = lists:keydelete(NewLeaderId, #hall_role.id, Members),
                    NewRoom = Room#hall_room{members = NewMembers, leader = NewLeader},
                    update_room_and_inform(NewRoom),
                    ok;
                _ -> %% 房间里已没人在线，可以销毁房间
                    case Status of
                        ?hall_room_status_fight ->
                            update_room(Room#hall_room{leader = Leader#hall_role{status = ?hall_role_status_offline}});
                        _ ->
                            lists:foreach(fun(#hall_role{id = MemberRid}) -> 
                                        remove_role(MemberRid)
                                end, Members),
                            remove_room(RoomNo)
                    end,
                    ok
            end
    end.

logout_room(Room = #hall_room{room_no = RoomNo, status = Status, leader = Leader = #hall_role{id = LeaderId},
        members = Members}, #hall_role{id = Rid = {RoleId, SrvId}}) ->
    case LeaderId =:= Rid of
        false ->
            Members2 = case lists:keyfind(Rid, #hall_role.id, Members) of
                Hrole = #hall_role{} ->
                    lists:keyreplace(Rid, #hall_role.id, Members, Hrole#hall_role{status = ?hall_role_status_offline});
                _ ->
                    Members
            end,
            NewRoom = Room#hall_room{members = Members2},
            case Status of
                ?hall_room_status_fight ->
                    ignore;
                _ ->
                    cast_all_members([Leader | Members2], 16521, {RoleId, SrvId, ?hall_role_status_offline})
            end,
            update_room(NewRoom),
            ok;
        true ->
            case change_leader(Members) of
                NewLeader = #hall_role{id = NewLeaderId} ->
                    NewMembers = lists:keydelete(NewLeaderId, #hall_role.id, Members),
                    NewRoom = Room#hall_room{members = [Leader#hall_role{status = ?hall_role_status_offline} | NewMembers], leader = NewLeader},
                    update_room_and_inform(NewRoom),
                    ok;
                _ -> %% 房间里已没人在线，可以销毁房间
                    case Status of
                        ?hall_room_status_fight ->
                            update_room(Room#hall_room{leader = Leader#hall_role{status = ?hall_role_status_offline}});
                        _ ->
                            lists:foreach(fun(#hall_role{id = MemberRid}) -> 
                                        remove_role(MemberRid)
                                end, [Leader | Members]),
                            remove_room(RoomNo)
                    end,
                    ok
            end
    end.


add_room(Room = #hall_room{room_no = RoomNo}) ->
    RoomList = get(room_list),
    case lists:keyfind(RoomNo, #hall_room.room_no, RoomList) of
        false ->
            put(room_list, [Room | RoomList]);
        _ ->
            ?ERR("重复创建房间: ~w", [RoomNo]),
            ok
    end.

remove_room(RoomNo) ->
    RoomList2 = lists:keydelete(RoomNo, #hall_room.room_no, get(room_list)),
    put(room_list, RoomList2).

update_room_and_inform(Room = #hall_room{}) ->
    pack_send_room_members(Room),
    update_room(Room).
update_room(Room = #hall_room{room_no = RoomNo}) ->
    NewRoomList = lists:keyreplace(RoomNo, #hall_room.room_no, get(room_list), Room),
    put(room_list, NewRoomList).

%% 从列表中选出一个房主
change_leader([]) ->
    false;
change_leader([H | T]) ->
    case H#hall_role.status =/= ?hall_role_status_offline of
        true ->
            H;
        false ->
            change_leader(T)
    end.

%% 异步执行退出大厅
apply_leave(Role = #role{link = #link{conn_pid = ConnPid}, pos = #pos{map = MapId, last = {LmapId, Lx, Ly}}}) ->
    Role3 = case hall_type:check_prepare_map(MapId) of
        true ->
            case map:role_enter(LmapId, Lx, Ly, Role) of
                {ok, Role2} ->
                    Role2;
                {false, _Reason} ->
                    Role
            end;
        false ->
            Role
    end,
    NewRole = Role3#role{event = ?event_no, event_pid = 0, hall = #role_hall{}},
    sys_conn:pack_send(ConnPid, 16502, {}),
    {ok, NewRole}.

%% 将room list转换为协议
to_room_list(RoomList) ->
    to_room_list(RoomList, []).
to_room_list([], Back) ->
    lists:reverse(Back);
to_room_list([#hall_room{room_no = RoomNo, room_type = RoomType, leader = Leader, members = Members} | T], Back) ->
    Value = {RoomNo, RoomType, [Leader | Members]},
    to_room_list(T, [Value | Back]).

%% 打包房间信息
pack_room_members(#hall_room{room_no = RoomNo, leader = Leader, members = Members, room_type = RoomType}) ->
    PackedMembers = lists:map(fun pack_member/1, [Leader#hall_role{is_owner = 1} | Members]),
    {RoomNo, RoomType, PackedMembers}.

pack_member(#hall_role{is_owner = IsOwner, name = Name, id = {RoleId, SrvId}, career = Career, status = Status, fight_capacity = FightCapacity, looks = Looks, sex = Sex}) ->
    {IsOwner, RoleId, SrvId, Name, Career, FightCapacity, Sex, Status, Looks}.

%% 发送房间成员列表
pack_send_room_members(#hall_room{status = ?hall_room_status_fight}) ->
    ?DEBUG("房间正在战斗中，不发16518"),
    ok;
pack_send_room_members(Room = #hall_room{leader = Leader, members = Members}) ->
    Reply = pack_room_members(Room),
    lists:foreach(fun(#hall_role{name = _Name, conn_pid = ConnPid, status = Status}) ->
                case Status =:= ?hall_role_status_offline of
                    true ->
                        ?DEBUG("玩家[~s]掉线不发16518", [_Name]),
                        ignore;
                    false ->
                        sys_conn:pack_send(ConnPid, 16518, Reply)
                end
        end, [Leader | Members]),
    ok.

pack_send_room_members(RolePid, Room) when is_pid(RolePid) ->
    {ok, RoomBin} = proto_165:pack(srv, 16518, pack_room_members(Room)),
    RolePid ! {socket_proxy, RoomBin};
pack_send_room_members(_Rpid, _Room) ->
    ok.

get_hall_role(Rid) ->
    case lists:keyfind(Rid, #hall_role.id, get(role_list)) of
        false ->
            {false, ?MSGID(<<"您不在大厅">>)};
        #hall_role{room_no = 0} ->
            {false, ?MSGID(<<"您不在房间里">>)};
        HallRole ->
            HallRole
    end.

role_leave_room(#hall_role{id = Rid, conn_pid = ConnPid}) ->
    RoleList = get(role_list),
    case lists:keyfind(Rid, #hall_role.id, RoleList) of
        HallRole = #hall_role{room_no = RoomNo} when RoomNo =/= 0 ->
            case lists:keyfind(RoomNo, #hall_room.room_no, get(room_list)) of
                Room = #hall_room{} ->
                    update_role(HallRole#hall_role{room_no = 0}, RoleList),
                    update_leave_room(Room, HallRole),
                    ok;
                _ ->
                    update_role(HallRole#hall_role{room_no = 0}, RoleList),
                    ok
            end;
        _ ->
            ignore
    end,
    sys_conn:pack_send(ConnPid, 16513, {}).

cast_all_members([], _Cmd, _Reply) ->
    ok;
cast_all_members([#hall_role{conn_pid = ConnPid, status = Status} | T], Cmd, Reply) when Status =/= ?hall_role_status_offline ->
    sys_conn:pack_send(ConnPid, Cmd, Reply),
    cast_all_members(T, Cmd, Reply);
cast_all_members([_ | T], Cmd, Reply) ->
    cast_all_members(T, Cmd, Reply).
