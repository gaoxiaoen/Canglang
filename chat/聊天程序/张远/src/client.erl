-module(client).

-include("common.hrl").
-include("error.hrl").

-export([start/0, user_register/2, login/2, 
		 enter_room/1, leave_room/0, logout/0, 
		 said/1, client_send_message/1, client_recv_message/2, 
		 add_room/1, delete_room/1]).

start() ->
	{ok, Socket} = gen_tcp:connect("localhost", 6666,
								 [binary, 
								  {active, false}, 
								  {packet, 0}
								  ]),
	create_process_handle_message([Socket]),
    client_main_loop(),
	ok.

%%客户端的主逻辑
client_main_loop() ->
        io:format("Welcome to chat server!!~n"),
        io:format("Please choose to register or log in:~n"),
        io:format("1:Register~n2:Login~n"),
        case io:get_line("ID:") of
                "1\n" ->
                   io:format("enter your account~n"),
                   Account = io:get_line("Account:"),
                   io:format("enter your password~n"),
                   PassWord = io:get_line("PassWord:"),
                   user_register(Account, PassWord),
                   timer:sleep(200),
                   login(Account, PassWord);
                "2\n" ->
                   io:format("enter your account~n"),
                   Account = io:get_line("Account:"),
                   io:format("enter your password~n"),
                   PassWord = io:get_line("PassWord:"),
                   login(Account, PassWord)
        end,
        timer:sleep(200),
        enter_room(io:get_line("The Name of Room:")), 
        io:format("You can chat~").
        
	
%%创建进程 来接受和发送消息
create_process_handle_message([Socket]) ->
	register(client_send_message,
			spawn(fun()->client_send_message(Socket) end)
			),
	register(client_recv_message,
			spawn(fun()->client_recv_message(Socket, []) end)
			).
		
%%用户注册
user_register(UserName, Password) ->
	Pass_Word = crypto:md5(Password),
    {ok, Len, Data} = tcp_protocol:client_pack(?RE_REGISTER, [UserName, Pass_Word]),
	client_send_message ! {Len, Data},
	ok.

%%用户登录
login(UserName, Password) ->
	Pass_Word = crypto:md5(Password),
	{ok, Len, Data} = tcp_protocol:client_pack(?RE_LOGIN, [UserName, Pass_Word]),
	client_send_message ! {Len, Data},
	ok.

%%进房间
enter_room(RoomNum) ->
    {ok, Len, Data} = tcp_protocol:client_pack(?RE_SELECT_ROOM, RoomNum),
	client_send_message ! {Len, Data}, 
	ok.

%%在同一个房间里发消息给其他客户端
said(Msg)->
	{ok, Len, Data} = tcp_protocol:client_pack(?RE_SENDMSG, Msg),
	client_send_message ! {Len, Data},
	ok.
	
%%离开房间
leave_room() ->
    {ok, Len, Data} = tcp_protocol:client_pack(?RE_LEAVE_ROOM, <<1>>),
	client_send_message ! {Len, Data},
	ok.
	
%%退出登录
logout() ->
	{ok, Len, Data} = tcp_protocol:client_pack(?RE_LOGOUT, <<1>>),
	client_send_message ! {Len, Data},
	ok.

%%管理员加房间
add_room(RoomName) ->
	{ok, Len, Data} = tcp_protocol:client_pack(?RE_ADD_ROOM, RoomName),
	client_send_message ! {Len, Data},
	ok.

%%管理员删除房间
delete_room(RoomName) ->
	{ok, Len, Data} = tcp_protocol:client_pack(?RE_DELETE_ROOM, RoomName),
	client_send_message ! {Len, Data},
	ok.

%%客户端发送消息
client_send_message(Socket)->
	receive
		{Len, Data} ->
			gen_tcp:send(Socket, <<Len:16>>),
			gen_tcp:send(Socket, Data)
            %io:format("client_send_message:got it!!~~~")
	end,
	client_send_message(Socket).

%%客户端接收消息
client_recv_message(Socket, RoomList) ->
	case gen_tcp:recv(Socket, 2) of
		{ok, <<Len:16>>} ->
			case gen_tcp:recv(Socket, Len) of
				{ok, <<?RE_REGISTER_REPLY:16, _Bin/binary>>} ->
					io:format("Congratulations!!!Register ok!!~n"),
					client_recv_message(Socket, RoomList); 
				{ok, <<?RE_LOGIN_REPLY:16, Bin/binary>>} ->
    		        UserId = binary_to_list(Bin),
    		        io:format("Welcom, ~s~nRoom list:~n", [UserId]),
					lists:foreach(fun(Name)-> io:format("~s~n",[Name]) end, RoomList),
					client_recv_message(Socket, RoomList);
				{ok, <<?RE_SELECT_ROOM_REPLY:16, Len1:16, Bin/binary>>} ->
					<<Userid:Len1/binary-unit:8, _Len2:16, Roomnum/binary>> = Bin,
					UserId = binary_to_list(Userid),
					RoomNum = binary_to_list(Roomnum),
       		     	io:format("~s entered to ~s~n", [UserId, RoomNum]),
					client_recv_message(Socket, RoomList);
   	 		    {ok, <<?RE_BROADCAST_MSG:16, Len1:16, Bin/binary>>} ->
					<<Userid:Len1/binary-unit:8, _Len2:16, Data/binary>> = Bin,
					UserId = binary_to_list(Userid),
					Msg = binary_to_list(Data),
      		        io:format("~s said: ~s~n", [UserId, Msg]),
            		client_recv_message(Socket, RoomList);
				{ok, <<?RE_LEAVE_ROOM_REPLY:16, Len1:16, Bin/binary>>} ->
					<<Userid:Len1/binary-unit:8, _Len2:16, Roomnum/binary>> = Bin,
					UserId = binary_to_list(Userid),
					RoomNum = binary_to_list(Roomnum),
					io:format("~s leave ~s~n", [UserId, RoomNum]),
					client_recv_message(Socket, RoomList);
				{ok, <<?RE_DISCONNECT:16, Len1:16, Bin/binary>>} ->
					<<Userid:Len1/binary-unit:8, _Len2:16, Roomnum/binary>> = Bin,
					UserId = binary_to_list(Userid),
					RoomNum = binary_to_list(Roomnum),
					io:format("~s disconnect ~s~n", [UserId, RoomNum]),
					client_recv_message(Socket, []);
				{ok, <<?RE_NEW_ADDED_ROOM_NAME:16, Bin/binary>>} ->
    		        RoomName = binary_to_list(Bin),
					New_Rooms = [RoomName|RoomList],
					client_recv_message(Socket, New_Rooms);
				{ok, <<?RE_NEW_DELETED_ROOM_NAME:16, Bin/binary>>} ->
    		        RoomName = binary_to_list(Bin),
					New_Rooms = lists:delete(RoomName, RoomList),
					client_recv_message(Socket, New_Rooms);
				{ok, <<?ILLEGAL_NAME>>}->
					io:format("Illegal name, please register first!~n"),
					client_recv_message(Socket, RoomList);
				{ok, <<?LOGIN_FIRST>>}->
					io:format("Please login first!~n"),
					client_recv_message(Socket, RoomList);
				{ok, <<?ENTER_ROOM>>}->
					io:format("Please enter room first!~n"),
					client_recv_message(Socket, RoomList);
				{ok, <<?WRONG_PASSWORD>>}->
					io:format("Wrong Password.~n"),
					client_recv_message(Socket, RoomList);
				{ok, <<?USERNAME_EXIST>>}->
					io:format("Id exist.~n"),
					client_recv_message(Socket, RoomList);
				{ok, <<?LOGOUT_SUCCESS>>}->
					io:format("Logout success.~n"),
					client_recv_message(Socket, []);
				{ok, <<?NO_PRIVILEGE>>}->
					io:format("You have no privilege to do so.~n"),
					client_recv_message(Socket, RoomList);
				{error, Reason} ->
					io:format("~p~n",[Reason]),
            		client_recv_message(Socket, RoomList)
			end;

		{error, Reason} ->
			io:format("~p~n",[Reason])
	end.
