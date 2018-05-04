%% --------------------------------------------------------------------
%% 根据大厅的类型，执行不同的操作
%% @author abu
%% @end
%% --------------------------------------------------------------------
-module(hall_type).

-export([
        filter_friend_list/3       %% 过滤好友列表
        ,filter_member_list/3       %% 过滤军团成员列表
        ,check_enter/2       %% 进入大厅与房间时的检测
        ,check_enter_room/3 %% 进入房间时的检测
        ,check_prepare_map/1
        ,enter_room/2         %% 进入房间
        ,get_hall/2         %% 获取大厅
        ,create_room/2      %% 创建房间
        ,room_start/2       %% 房间开始时的操作
        ,match_room/4       %% 匹配房间, 当玩家选择 快速进入时匹配
        ,reply_invite/5     %% 处理回复邀请
        ,deal_invite/3    %% 处理邀请
        ,get_invite_msg/3
        ,get_world_invite_msg/4
    ]).

%% include
-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("pos.hrl").
-include("condition.hrl").
-include("hall.hrl").
-include("hall_lang.hrl").
%%
-include("practice.hrl").
-include("boss.hrl").
-include("compete.hrl").
-include("attr.hrl").
-include("dungeon.hrl").
-include("notification.hrl").
-include("sns.hrl").
-include("guild.hrl").
-include("unlock_lev.hrl").

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------
filter_friend_list(#hall{type = ?hall_type_expedition}, RoomType, Friends) ->
    LevLimit = expedition:get_lev_limit(RoomType),
    Friends2 = [F || F = #friend{type = ?sns_friend_type_hy, online = ?true, 
            lev = Lev} <- Friends, Lev >= LevLimit],
    lists:filter(fun(#friend{pid = RolePid}) ->
                case role_api:lookup(by_pid, RolePid, [#role.expedition]) of
                    {ok, _, [Expedition]} ->
                        LeftCount = expedition:get_left_count(Expedition),
                        LeftCount > 0;
                    _ -> 
                        false
                end
        end, Friends2);
filter_friend_list(#hall{type = ?hall_type_compete}, _RoomType, Friends) ->
    LevLimit = ?compete_unlock_lev,
    Friends2 = [F || F = #friend{type = ?sns_friend_type_hy, online = ?true, 
            lev = Lev} <- Friends, Lev >= LevLimit],
    lists:filter(fun(#friend{pid = RolePid}) ->
                case role_api:lookup(by_pid, RolePid, [#role.compete]) of
                    {ok, _, [Data]} ->
                        LeftCount = compete_mgr:get_left_count(Data),
                        LeftCount > 0;
                    _ -> 
                        false
                end
        end, Friends2);
filter_friend_list(_Hall, _RoomType, Friends) ->
    Friends.

filter_member_list(#hall{type = ?hall_type_expedition}, RoomType, Members) ->
    LevLimit = expedition:get_lev_limit(RoomType),
    Members2 = [F || F = #guild_member{pid = Pid, lev = Lev} <- Members, Pid =/= 0,
        Lev >= LevLimit],
    lists:filter(fun(#guild_member{pid = RolePid}) ->
                case role_api:lookup(by_pid, RolePid, [#role.expedition]) of
                    {ok, _, [Expedition]} ->
                        LeftCount = expedition:get_left_count(Expedition),
                        LeftCount > 0;
                    _ -> 
                        false
                end
        end, Members2);
filter_member_list(#hall{type = ?hall_type_compete}, _RoomType, Members) ->
    LevLimit = ?compete_unlock_lev,
    Members2 = [F || F = #guild_member{pid = Pid, lev = Lev} <- Members, Pid =/= 0,
        Lev >= LevLimit],
    lists:filter(fun(#guild_member{pid = RolePid}) ->
                case role_api:lookup(by_pid, RolePid, [#role.compete]) of
                    {ok, _, [Data]} ->
                        LeftCount = compete_mgr:get_left_count(Data),
                        LeftCount > 0;
                    _ -> 
                        false
                end
        end, Members2);
filter_member_list(_Hall, _RoomType, Members) ->
    Members.

%% check_enter(Hall, Role) -> {ok} | {false, Reason}
%% Hall = #hall{}
%% Role = #role{}
%% Reason = bitstring()
%% 进入大厅与房间时的检测
check_enter(Hall, Role) ->
    case check([base], Role, Hall) of
        {ok} ->
            ok;
        {false, ReasonId} ->
            {false, ReasonId}
    end.

check_enter_room(#hall{type = ?hall_type_expedition}, RoomType, #hall_role{lev = Lev, pid = Pid}) -> 
    HighestRoomType = expedition:get_highest_room_type(Lev),
    case RoomType =< HighestRoomType of
        true ->
            case role_api:lookup(by_pid, Pid, [#role.expedition]) of
                {ok, _, [Data]} ->
                    case expedition:get_left_count(Data) > 0 of
                        true ->
                            ok;
                        false ->
                            {false, ?MSGID(<<"已达到当天远征王军的进入上限">>)}
                    end;
                _ ->
                    {false, ?MSGID(<<"已达到当天远征王军的进入上限">>)}
            end;
        false ->
            {false, ?MSGID(<<"等级不够">>)}
    end;
check_enter_room(#hall{type = ?hall_type_compete}, _RoomType, #hall_role{pid = Pid, lev = Lev}) ->
    LevLimit = ?compete_unlock_lev,
    case Lev >= LevLimit of
        true ->
            case role_api:lookup(by_pid, Pid, [#role.compete]) of
                {ok, _, [Data]} ->
                    case compete_mgr:get_left_count(Data) > 0 of
                        true ->
                            ok;
                        false ->
                            {false, ?MSGID(<<"已达到当天竞技场的进入上限">>)}
                    end;
                _ ->
                    {false, ?MSGID(<<"已达到当天竞技场的进入上限">>)}
            end;
        false ->
            {false, ?MSGID(<<"等级不够">>)}
    end;
check_enter_room(_Hall, _RoomType, _HallRole) ->
    ok.

%%检查是否大厅准备地图
check_prepare_map(MapId) ->
    lists:member(MapId, [?compete_prepare_map_id]).

enter_room(#hall{type = ?hall_type_compete}, Role = #role{pid = RolePid, id = {RoleId, SrvId}, link = #link{conn_pid = ConnPid},
        pos = Pos = #pos{map = MapId, map_pid = MapPid, x = X, y = Y}}) ->
    map:role_leave(MapPid, RolePid, RoleId, SrvId, X, Y), %% 离开上一个地图
    sys_conn:pack_send(ConnPid, 10110, {?compete_prepare_map_id, ?compete_prepare_x, ?compete_prepare_y}),
    Role#role{
        pos = Pos#pos{
            last = {MapId, X, Y}, 
            map = ?compete_prepare_map_id,
            x = ?compete_prepare_x, 
            y = ?compete_prepare_y
        } 
    };
enter_room(_, Role) ->
    Role.

%% room_start(Hall, Room) ->
%% Hall = #hall{}
%% Room = #hall_room{}
%% 房间开启
room_start(#hall{id = HallId, type = ?hall_type_expedition}, #hall_room{room_no = RoomNo, room_type = RoomType,
        leader = Leader, members = Members}) ->
    spawn(fun() -> expedition:enter_dungeon(RoomType, HallId, RoomNo, Leader, Members) end);
room_start(#hall{id = HallId, type = ?hall_type_compete}, #hall_room{room_no = RoomNo,
        leader = Leader, members = Members}) ->
    compete_mgr:sign_up(HallId, RoomNo, [Leader#hall_role{is_owner = 1}| Members]);
room_start(_Hall, _Room) ->
    ok.

%% match_room(HallRole, HallState, Rooms) -> false | {ok, RoomNo}
%% HallRole = #hall_role{} 请求的玩家
%% HallState = #hall{}  大厅进程状态
%% Rooms = [#hall_room, ...] 房间列表
%% RoomNo = integer() 匹配到的房间号
%% 匹配房间，用于大厅中的快速进入
match_room(#hall{type = ?hall_type_expedition}, HallRole = #hall_role{lev = Lev}, RoomType, Rooms) ->
    case RoomType =:= 0 of
        true ->
            HighestRoomType = expedition:get_highest_room_type(Lev),
            match_all_type_room(HallRole, HighestRoomType, Rooms);
        false ->
            common_match_room(HallRole, Rooms)
    end;
match_room(#hall{}, HallRole = #hall_role{}, _RoomType, Rooms) -> %% 通用匹配
    common_match_room(HallRole, Rooms).

get_hall(?hall_type_expedition, _) ->
    expedition:get_hall();
get_hall(?hall_type_compete, _) ->
    compete_mgr:get_hall();
get_hall(_, _) ->
    ok.

create_room(#hall{type = ?hall_type_compete}, _) ->
    #hall_room{limit_count = 2};
create_room(_, _) ->
    #hall_room{limit_count = 3}.

get_invite_msg(#hall{type = ?hall_type_expedition}, Name, RoomType) ->
    case dungeon_data:get(RoomType) of
        #dungeon_base{name = DungeonName} ->
            util:fbin(?invite_friend, [Name, DungeonName]);
        _ ->
            <<>>
    end;
get_invite_msg(#hall{type = ?hall_type_compete}, Name, _RoomType) ->
    util:fbin(?compete_invite_friend, [Name]);
get_invite_msg(_, _Name, _RoomType) ->
    <<>>.

get_world_invite_msg(#hall{id = HallId, type = ?hall_type_expedition}, _Name, RoomType, RoomNo) ->
    util:fbin(?world_invite, [notice:get_dungeon_msg(RoomType), ?notify_type_hall, HallId, RoomNo, notice_color:get_color_item(5)]);
get_world_invite_msg(#hall{id = HallId, type = ?hall_type_compete}, _Name, _RoomType, RoomNo) ->
    util:fbin(?compete_world_invite, [?notify_type_hall, HallId, RoomNo, notice_color:get_color_item(5)]);
get_world_invite_msg(_, _Name, _RoomType, _RoomNo) ->
    <<>>.

%% @spec reply_invite(HallType, HallId, RoomId, Rid) -> {ok} | {false, Reason}
%% HallType = HallId = RoomId = integer()
%% Rid = rid()
%% 处理玩家回复大厅邀请
reply_invite(HallType, HallId, _RoomNo, _Rid, #role{event = ?event_hall, hall = #role_hall{id = Hid}}) when HallType =/= ?hall_type_cross_boss andalso HallId =/= Hid ->
    {false, ?L(<<"您已在大厅里，不能进入其它组队大厅">>)};

reply_invite(_HallType, _HallId, _RoomId, _Rid, _Role) ->
    {ok}.

deal_invite(#hall{}, InviteRids, #role{}) ->
    lists:foldl(fun(Rid, Return) ->
                case role_api:get_pid(Rid) of
                    undefined -> 
                        Return;
                    RolePid -> 
                        [RolePid | Return]
                end
        end, [], InviteRids).

%% --------------------------------------------------------------------
%% Internal functions
%% --------------------------------------------------------------------

check([], _Role, _Hall) ->
    {ok};
check(_Conds = [H | T], Role, Hall) ->
    case check(H, Role, Hall) of
        {ok} ->
            check(T, Role, Hall);
        {false, Reason} ->
            {false, Reason}
    end;
check(base, Role, Hall) ->
    check([event, hall], Role, Hall);
check(hall, #role{hall = #role_hall{id = HallId}, cross_srv_id = CrossSrvId, event = ?event_hall}, #hall{type = Htype, id = Hid}) ->
    case hall_mgr:get_hall(CrossSrvId, HallId) of
        {ok, #hall{id= HallId, type = HallType}} ->
            case HallId =:= Hid of
                true ->
                    {ok};
                false ->
                    case HallType =:= Htype andalso Htype =:= ?hall_type_cross_boss of
                        true ->
                            {ok};
                        false ->
                            {false, ?MSGID(<<"您已在大厅中，不能进入其它大厅">>)}
                    end
            end;
        _ ->
            {false, ?MSGID(<<"当前不能进入">>)}
    end;
check(event, #role{event = Event}, _Hall) when Event =/= ?event_no andalso Event =/= ?event_hall ->
    {false, ?MSGID(<<"当前状态下无法进入大厅">>)};

check(Cond = #condition{}, Role, _Hall) ->
    case role_cond:check([Cond], Role) of
        true ->
            {ok};
        {false, #condition{msg = Msg}} ->
            {false, Msg}
    end;

check(_, _Role, _Hall) ->
    {ok}.

match_all_type_room(_HallRole, 0, _RoomList) ->
    false;
match_all_type_room(HallRole, RoomType, RoomList) ->
    RoomList1 = [Room || Room = #hall_room{room_type = Type} <- RoomList, Type =:= RoomType],
    case common_match_room(HallRole, RoomList1) of
        false ->
            match_all_type_room(HallRole, RoomType - 1, RoomList);
        {ok, RoomNo} ->
            {ok, RoomNo}
    end.

%% 搜索房间，符合通用要求
common_match_room(_HallRole, []) ->
    false;
common_match_room(HallRole, [H | T]) ->
    case check_suitable(HallRole, H) of
        false ->
            common_match_room(HallRole, T);
        true ->
            {ok, H#hall_room.room_no}
    end.

%% 通用检测是否满足房间的要求
check_suitable(#hall_role{}, #hall_room{members = Members, limit_count = LimitCount}) when length(Members) >= (LimitCount - 1) ->
    false;
check_suitable(#hall_role{}, #hall_room{status = Status}) when Status =/= ?hall_room_status_common ->
    false;
check_suitable(_, _) ->
    true.
