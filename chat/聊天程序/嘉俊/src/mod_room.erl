-module(mod_room).

%% API
-export([create_room/2, close_room/2, get_room_list/2, join_room/2, chat/2, get_name_by_id/1, transform_admin/2, leave_room/2]).

-include("chatroomstatus.hrl").
-include("roominfo.hrl").
-include("clientinfo.hrl").

create_room({PlyId, Name}, State = #chatroomstatus{rooms = Rooms, roomAllocId = AllocId, plyToRoomId = PlyToRoomId}) ->

    %% 判断玩家是否已经在房间了
    case maps:find(PlyId, PlyToRoomId) of
        {ok, _Value} ->
            io:format("ERROR [ROOM] create room failed, already in room, ply: ~p~n", [PlyId]),
            {error, "create room failed, already in room"};
        error ->
            %% 新建房间,建立房间号 => 房间的映射
            PlyMap = #{PlyId => Name},
            NewRoom = #roominfo{roomid = AllocId, admin = PlyId, plymap = PlyMap},
            NewRooms = Rooms#{AllocId => NewRoom},

            %% 建立玩家标志与房间号的映射
            NewPlyToRoomId = PlyToRoomId#{PlyId => AllocId},
            NewState = State#chatroomstatus{rooms = NewRooms, roomAllocId = AllocId + 1, plyToRoomId = NewPlyToRoomId},

            RetList = ["create room succ, roomid:", integer_to_list(AllocId)],
            Ret = string:join(RetList, " "),

            io:format("INFO [ROOM] create room succ, ply:~p, room:~p,~n", [PlyId, AllocId]),
            {ok, Ret, NewState}
    end.


close_room(PlyId, State = #chatroomstatus{rooms = Rooms, plyToRoomId = PlyToRoomId}) ->

    %% 判断玩家是否在房间了
    case maps:find(PlyId, PlyToRoomId) of
        {ok, RoomId} ->
            %% 判断房间是否存在
            case maps:find(RoomId, Rooms) of
                {ok, Room} ->
                    %% 判断房主是否该玩家
                    Admin = Room#roominfo.admin,
                    CompRes = string:equal(PlyId, Admin),
                    if
                        CompRes == false ->
                            io:format("INFO [ROOM] close room failed, ply is not room master. ply:~p, roomid:~p~n", [PlyId, RoomId]),
                            {error, "close room failed, you are not room master"};
                        CompRes == true ->
                            %% 清除玩家房间信息以及将房间关闭 还要通知所有玩家
                            %% NewPlyRoomID = maps:remove(PlyId, PlyToRoomId),
                            NewPlyRoomID = maps:fold(fun(K,_,V) -> maps:remove(K,V) end, PlyToRoomId, Room#roominfo.plymap),
                            io:format("after: ~p~n", [NewPlyRoomID]),

                            NewRooms = maps:remove(RoomId, Rooms),
                            NewState = State#chatroomstatus{rooms = NewRooms, plyToRoomId = NewPlyRoomID},

                            Ret = "close room succ",
                            io:format("INFO [ROOM] close room success, ply:~p, roomid:~p~n", [PlyId, RoomId]),
                            {ok, Ret, NewState}
                    end;
                error ->
                    io:format("ERROR [ROOM] close room failed,room not exist. ply:~p~n", [PlyId]),
                    {error, "close room failed, room not exist"}
            end;
        error ->
            io:format("ERROR [ROOM] close room failed,not in room. ply:~p~n", [PlyId]),
            {error, "close room failed, you are not in room"}
    end.


get_room_list(PlyId, #chatroomstatus{rooms = Rooms}) ->
    RoomList = maps:to_list(Rooms),
    io:format("INFO [ROOM] get room list success. ply:~p,~nroom:~p~n", [PlyId, RoomList]),
    {ok, RoomList}.

join_room({PlyId, RoomId}, State = #chatroomstatus{rooms = Rooms, plyToRoomId = PlyToRoomId}) ->
    %% 判断玩家是否已经在房间了
    case maps:find(PlyId, PlyToRoomId) of
        {ok, _Value} ->
            io:format("ERROR [ROOM] join room failed, already in room, ply: ~p~n", [PlyId]),
            {error, "join room failed, already in room"};
        error ->
            %% 判断房间是否存在
            case maps:find(RoomId, Rooms) of
                {ok, Room} ->
                    NewPlyRoomId = PlyToRoomId#{PlyId => RoomId},

                    Name = get_name_by_id(PlyId),
                    PlyMap = Room#roominfo.plymap,
                    NewPlyMap = PlyMap#{PlyId => Name},
                    NewRoom = Room#roominfo{plymap = NewPlyMap},
                    NewRooms = Rooms#{RoomId => NewRoom},
                    NewState = State#chatroomstatus{rooms = NewRooms, plyToRoomId = NewPlyRoomId},

                    RetList = ["join room succ, roomid:", integer_to_list(RoomId)],
                    Ret = string:join(RetList, " "),

                    io:format("INFO [ROOM] join room success,. ply:~p, roomId: ~p~n", [PlyId,RoomId]),
                    {ok, Ret, NewState};
                error ->
                    io:format("ERROR [ROOM] join room failed,room not exist. ply:~p, roomId:~p~n", [PlyId,RoomId]),
                    {error, "join room failed, room not exist"}
            end
    end.

chat({PlyId, Content}, #chatroomstatus{rooms = Rooms, plyToRoomId = PlyToRoomId}) ->
    %% 判断玩家是否已经在房间了
    case maps:find(PlyId, PlyToRoomId) of
        error ->
            io:format("ERROR [ROOM] chat failed, not in room, ply: ~p~n", [PlyId]),
            {error, "not in room, join room first"};
        {ok, RoomId} ->
            %% 判断房间是否存在
            case maps:find(RoomId, Rooms) of
                {ok, Room} ->
                    Name = get_name_by_id(PlyId),
                    FContent = binary_to_list(list_to_binary([Name," say:", Content])),
                    maps:map(fun(Key,_) -> sendMsg(Key, FContent) end, Room#roominfo.plymap),
                    io:format("INFO [ROOM] chat success,. ply:~p, roomId: ~p~n", [PlyId,RoomId]),
                    Ret = "send chat content success",
                    {ok, Ret};
                error ->
                    io:format("ERROR [ROOM] chat failed,room not exist. ply:~p~n", [PlyId]),
                    {error, "room not exist"}
            end
    end.

sendMsg(Key,Msg)->
    case ets:lookup(clientinfo, Key) of
        [Record]->
            Pid=Record#clientinfo.pid,
            Pid ! {chat,Msg};
        []->
            io:format("no clientinfo found ~p~n", [Key])
    end,
    ok.

%% 根据id获取玩家名字
get_name_by_id(Id) ->
    case ets:lookup(clientinfo, Id) of
        [Record]->
            Record#clientinfo.name;
        []->
            "unknown"
    end.

%% 转移房主
transform_admin(PlyId, State = #chatroomstatus{rooms = Rooms, plyToRoomId = PlyToRoomId}) ->
    %% 判断玩家是否在房间了
    case maps:find(PlyId, PlyToRoomId) of
        {ok, RoomId} ->
            %% 判断房间是否存在
            case maps:find(RoomId, Rooms) of
                {ok, Room} ->
                    %% 判断房主是否该玩家
                    Admin = Room#roominfo.admin,
                    CompRes = string:equal(PlyId, Admin),
                    if
                        CompRes == false ->
                            io:format("INFO [ROOM] close room failed, ply is not room master. ply:~p, roomid:~p~n", [PlyId, RoomId]),
                            {error, "transform room failed, you are not room master"};
                        CompRes == true ->

                            %%  判断房间人数
                            PlySize = maps:size(Room#roominfo.plymap),
                            if
                                PlySize == 1 ->
                                    case close_room(PlyId, State) of
                                        {ok, Ret, NewState} ->
                                            {ok, Ret, NewState};
                                        {error, Ret} ->
                                            {error, Ret}
                                    end;
                                true ->
                                    {_, Key} = map_op:first_not_equal_key(Room#roominfo.plymap, PlyId),
                                    NewRoom = Room#roominfo{admin = Key},
                                    NewRooms = Rooms#{RoomId => NewRoom},
                                    NewState = State#chatroomstatus{rooms = NewRooms},

                                    Ret = "transform room succ",
                                    io:format("INFO [ROOM] transform room success, ply:~p, roomid:~p, newadmin:~p~n", [PlyId, RoomId, Key]),
                                    {ok, Ret, NewState}
                            end
                    end;
                error ->
                    io:format("ERROR [ROOM] transform room failed,room not exist. ply:~p~n", [PlyId]),
                    {error, "transform room failed, room not exist"}
            end;
        error ->
            io:format("ERROR [ROOM] transform room failed,not in room. ply:~p~n", [PlyId]),
            {error, "transform room failed, you are not in room"}
    end.

%% 离开房间
leave_room(PlyId, State = #chatroomstatus{rooms = Rooms, plyToRoomId = PlyToRoomId}) ->
    %% 判断玩家是否在房间了
    case maps:find(PlyId, PlyToRoomId) of
        {ok, RoomId} ->
            %% 判断房间是否存在
            case maps:find(RoomId, Rooms) of
                {ok, Room} ->
                    %% 判断房主是否该玩家
                    Admin = Room#roominfo.admin,
                    CompRes = string:equal(PlyId, Admin),
                    if
                        CompRes == false ->
                            PlyMap = Room#roominfo.plymap,
                            NewPlyRoomId = maps:remove(PlyId, PlyToRoomId),
                            NewPlyMap = maps:remove(PlyId, PlyMap),

                            NewRoom = Room#roominfo{plymap = NewPlyMap},
                            NewRooms = Rooms#{RoomId => NewRoom},
                            NewState = State#chatroomstatus{rooms = NewRooms, plyToRoomId = NewPlyRoomId},
                            Ret = "leave room success",
                            {ok, Ret, NewState};
                        CompRes == true ->
                            case transform_admin(PlyId, State) of
                                {ok, Ret, NewState} ->
                                    {ok, Ret, NewState};
                                {error, Ret} ->
                                    {error, Ret}
                            end
                    end;
                error ->
                    io:format("ERROR [ROOM] leave room failed,room not exist. ply:~p~n", [PlyId]),
                    {error, "leave room failed, room not exist"}
            end;
        error ->
            io:format("ERROR [ROOM] transform room failed,not in room. ply:~p~n", [PlyId]),
            {error, "leave room failed, you are not in room"}
    end.



