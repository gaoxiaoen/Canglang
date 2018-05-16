-module(tcp_protocol).

-include("common.hrl").

-export([client_pack/2, server_pack/2]).

client_pack(?RE_REGISTER, [Id, Password]) ->
    Data1 = list_to_binary(Id),
	Len1 = byte_size(Data1),
	Len2 = byte_size(Password),
    Data = <<?RE_REGISTER:16, Len1:16, Data1/binary, 
			 Len2:16, Password/binary>>,
	Len = byte_size(Data),
    {ok, Len, Data};
client_pack(?RE_LOGIN, [Id, Password]) ->
    Data1 = list_to_binary(Id),
	Len1 = byte_size(Data1),
	Len2 = byte_size(Password),
    Data = <<?RE_LOGIN:16, Len1:16, Data1/binary, 
			 Len2:16, Password/binary>>,
	Len = byte_size(Data),
    {ok, Len, Data};
client_pack(?RE_SELECT_ROOM, RoomNum) ->
    Room = list_to_binary(RoomNum),
    Data = <<?RE_SELECT_ROOM:16, Room/binary>>,
	Len = byte_size(Data),
    {ok, Len, Data};
client_pack(?RE_SENDMSG, Msg) ->
    Msgt = list_to_binary(Msg),
    Data = <<?RE_SENDMSG:16, Msgt/binary>>,
	Len = byte_size(Data),
    {ok, Len, Data};
client_pack(?RE_LEAVE_ROOM, LMsg) ->
    Data = <<?RE_LEAVE_ROOM:16, LMsg/binary>>,
	Len = byte_size(Data),
    {ok, Len, Data};
client_pack(?RE_LOGOUT, LogMsg) ->
    Data = <<?RE_LOGOUT:16, LogMsg/binary>>,
	Len = byte_size(Data),
    {ok, Len, Data};
client_pack(?RE_ADD_ROOM, RoomName) ->
    Room = list_to_binary(RoomName),
    Data = <<?RE_ADD_ROOM:16, Room/binary>>,
	Len = byte_size(Data),
    {ok, Len, Data};
client_pack(?RE_DELETE_ROOM, RoomName) ->
    Room = list_to_binary(RoomName),
    Data = <<?RE_DELETE_ROOM:16, Room/binary>>,
	Len = byte_size(Data),
    {ok, Len, Data}.

server_pack(?RE_REGISTER_REPLY, RegRe) ->
    Data = <<?RE_REGISTER_REPLY:16, RegRe/binary>>,
	Len = byte_size(Data),
    {ok, Len, Data};
server_pack(?RE_LOGIN_REPLY, LoginRe) ->
	Stat = list_to_binary(LoginRe),
    Data = <<?RE_LOGIN_REPLY:16, Stat/binary>>,
	Len = byte_size(Data),
	{ok, Len, Data};
server_pack(?RE_SELECT_ROOM_REPLY, [UserId, RoomNum]) ->
	Userid = list_to_binary(UserId),
	Len1 = byte_size(Userid),
	Roomnum = list_to_binary(RoomNum),
	Len2 = byte_size(Roomnum),
	Data = <<?RE_SELECT_ROOM_REPLY:16, Len1:16, Userid/binary, 
			 Len2:16, Roomnum/binary>>,
	Len = byte_size(Data),
	{ok, Len, Data};
server_pack(?RE_BROADCAST_MSG, [UserId, Msg]) ->
    Userid = list_to_binary(UserId),
    Len1 = byte_size(Userid),
    Msgt = list_to_binary(Msg),
    Len2 = byte_size(Msgt),
    Data = <<?RE_BROADCAST_MSG:16, Len1:16, Userid/binary, 
			 Len2:16, Msgt/binary>>,
	Len = byte_size(Data),
    {ok, Len, Data};
server_pack(?RE_LEAVE_ROOM_REPLY, [UserId, RoomNum]) ->
	Userid = list_to_binary(UserId),
	Len1 = byte_size(Userid),
	Roomnum = list_to_binary(RoomNum),
	Len2 = byte_size(Roomnum),
	Data = <<?RE_LEAVE_ROOM_REPLY:16, Len1:16, Userid/binary, 
			 Len2:16, Roomnum/binary>>,
	Len = byte_size(Data),
	{ok, Len, Data};
server_pack(?RE_DISCONNECT, [UserId, RoomNum]) ->
	Userid = list_to_binary(UserId),
	Len1 = byte_size(Userid),
	Roomnum = list_to_binary(RoomNum),
	Len2 = byte_size(Roomnum),
	Data = <<?RE_DISCONNECT:16, Len1:16, Userid/binary, 
			 Len2:16, Roomnum/binary>>,
	Len = byte_size(Data),
	{ok, Len, Data};
server_pack(?RE_NEW_ADDED_ROOM_NAME, RoomName) ->
	Stat = list_to_binary(RoomName),
    Data = <<?RE_NEW_ADDED_ROOM_NAME:16, Stat/binary>>,
	Len = byte_size(Data),
	{ok, Len, Data};
server_pack(?RE_NEW_DELETED_ROOM_NAME, RoomName) ->
	Stat = list_to_binary(RoomName),
    Data = <<?RE_NEW_DELETED_ROOM_NAME:16, Stat/binary>>,
	Len = byte_size(Data),
	{ok, Len, Data}.
