%% --------------------------------------------------------------------
%% 大厅相关的rpc操作
%% @author mobin
%% @end
%% --------------------------------------------------------------------
-module(hall_rpc).

%% export
-export([
        handle/3
    ]).

%% include
-include("common.hrl").
-include("role.hrl").
-include("hall.hrl").
-include("pos.hrl").
-include("compete.hrl").

%% 进入大厅
handle(16501, {Type}, Role) ->
    case hall_type:get_hall(Type, Role) of
        {ok, Hall = #hall{}} ->
            case hall:enter(Hall, Role) of
                {ok, NewRole} ->
                    {reply, {}, NewRole};
                {false, ReasonId} ->
                    notice:alert(error, Role, ReasonId),
                    {ok}
            end;
        _ ->
            {ok}
    end;

%% 退出大厅
handle(16502, {}, Role = #role{event = ?event_hall, hall = #role_hall{id = HallId}}) ->
    hall:leave(HallId, Role),
    {ok};

handle(16503, {Type, RoomType}, Role) ->
    case hall_type:get_hall(Type, Role) of
        {ok, Hall = #hall{}} ->
            case hall:enter_and_create_room(Hall, RoomType, Role) of
                {ok} ->
                    {ok};
                {false, ReasonId} ->
                    notice:alert(error, Role, ReasonId),
                    {ok}
            end;
        _ ->
            {ok}
    end;
    
%% 获取房间列表
handle(16504, {Type, PageIndex}, Role = #role{event = ?event_hall, hall = #role_hall{id = HallId}}) ->
    ?DEBUG("请求房间类型[~w]", [Type]),
    case hall:room_list(HallId, Type, PageIndex, Role) of
        {false, ReasonId} ->
            notice:alert(error, Role, ReasonId),
            {ok};
        Reply ->
            {reply, Reply}
    end;

%% 创建房间
handle(16511, {RoomType}, Role = #role{event = ?event_hall, hall = #role_hall{id = HallId}}) ->
    case hall:create_room(HallId, RoomType, Role) of
        {ok} ->
            {ok};
        {false, ReasonId} ->
            notice:alert(error, Role, ReasonId),
            {ok}
    end;

%% 进入房间
handle(16512, {RoomNo}, Role = #role{event = ?event_hall, hall = #role_hall{id = HallId}}) ->
    case hall:enter_room(HallId, RoomNo, Role) of
        {ok} ->
            {ok};
        {false, ReasonId} ->
            notice:alert(error, Role, ReasonId),
            {ok}
    end;

%% 退出房间
handle(16513, {}, Role = #role{event = ?event_hall, hall = #role_hall{id = HallId}}) ->
    case hall:leave_room(HallId, Role) of
        {ok} ->
            {ok};
        {false, ReasonId} ->
            notice:alert(error, Role, ReasonId),
            {ok}
    end;

%% 准备
handle(16514, {}, Role = #role{event = ?event_hall, hall = #role_hall{id = HallId}}) ->
    hall:prepare(HallId, Role),
    {ok};

%% 取消准备
handle(16515, {}, Role = #role{event = ?event_hall, hall = #role_hall{id = HallId}}) ->
    hall:cancel(HallId, Role),
    {ok};

%% 开始
handle(16516, {}, Role = #role{event = ?event_hall, hall = #role_hall{id = HallId}}) ->
    case hall:room_start(HallId, Role) of
        {ok} ->
            {ok};
        {false, ReasonId} ->
            notice:alert(error, Role, ReasonId),
            {ok}
    end;

%% 获取房间内成员列表
handle(16518, {}, Role = #role{event = ?event_hall, hall = #role_hall{id = Hid}}) ->
    hall:room_members(Hid, Role),
    {ok};

%% 自动加入
handle(16519, {Type}, Role = #role{event = ?event_hall, hall = #role_hall{id = HallId}}) ->
    hall:fast_enter_room(HallId, Type, Role),
    {ok};

%% 移除玩家
handle(16520, {RoleId, SrvId}, Role = #role{event = ?event_hall, hall = #role_hall{id = Hid}}) ->
    hall:remove_member({RoleId, SrvId}, Hid, Role),
    {ok};

%% 邀请玩家
handle(16525, {InviteRids}, Role = #role{event = ?event_hall, hall = #role_hall{id = Hid}}) ->
    InviteRids2 = lists:map(fun([RoleId, SrvId]) -> {RoleId, SrvId} end, InviteRids),
    case hall:invite(Hid, InviteRids2, Role) of
        {ok} ->
            {reply, {}};
        {false, ReasonId} ->
            notice:alert(error, Role, ReasonId),
            {ok}
    end;

%% 世界邀请
handle(16526, {}, Role = #role{event = ?event_hall, hall = #role_hall{id = HallId}}) ->
    case hall:world_invite(HallId, Role) of
        {ok} ->
            {reply, {}};
        {false, ReasonId} ->
            notice:alert(error, Role, ReasonId),
            {ok}
    end;

%% 快速换房
handle(16528, {}, Role = #role{event = ?event_hall, hall = #role_hall{id = Hid}}) ->
    hall:change_room(Hid, Role),
    {ok};

%%请求邀请好友列表
handle(16531, {RoomType}, #role{event = ?event_hall, cross_srv_id = CrossSrvId, hall = #role_hall{id = HallId}}) ->
    case hall_mgr:get_hall(CrossSrvId, HallId) of
        {ok, Hall = #hall{}} ->
            Friends = friend:get_friend_list(),
            Friends2 = hall_type:filter_friend_list(Hall, RoomType, Friends),
            ?DEBUG("====大厅好友列表====:~w", [Friends2]),
            {reply, {Friends2}};
        _ ->
            {reply, {[]}}
    end;

%%请求邀请军团列表
handle(16532, {RoomType}, Role = #role{event = ?event_hall, cross_srv_id = CrossSrvId, hall = #role_hall{id = HallId}}) ->
    case hall_mgr:get_hall(CrossSrvId, HallId) of
        {ok, Hall = #hall{}} ->
            Members = guild_mem:members(Role),
            Members2 = hall_type:filter_member_list(Hall, RoomType, Members),
            ?DEBUG("====军团成员列表====:~w", [Members2]),
            {reply, {Members2}};
        _ ->
            {reply, {[]}}
    end;

handle(_Cmd, _Data, _Role = #role{event = _Event}) ->
    ?DEBUG("接到错误指令: cmd = ~w, data = ~w, event = ~w ~n", [_Cmd, _Data, _Event]),
    {ok}.
%% --------------------------------------------------------------------
%% Internal functions
%% --------------------------------------------------------------------

