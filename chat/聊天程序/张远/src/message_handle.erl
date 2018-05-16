-module(message_handle).

-behaviour(gen_server).

-include("common.hrl").

-export([start_link/0]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, 
		 code_change/3]).

%%监听6666号端口
start_link() ->
		gen_server:start_link({local, ?MODULE}, ?MODULE, [6666], []).

init([Port]) ->
		process_flag(trap_exit, true),
		my_init([Port]).

handle_call(_Request, _From, State) -> {noreply, State}.
handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVsn, State, _Extra) -> {ok, State}.

%%开单独进程处理读写socket
main_loop(Listen_Socket) ->
		case gen_tcp:accept(Listen_Socket) of
				{ok, Socket} ->
                        io:format("main_loop:get_formation~n"),
						spawn(fun()-> loop_accept(Socket, 0) end);
				{error, Reason} ->
						error_logger:error_msg("error")
		end,
		main_loop(Listen_Socket).

%%读写socket上的消息的转发到不同的回调模块
loop_accept(Socket, UserPID) ->
		case gen_tcp:recv(Socket, 2) of
				{ok, <<Len:16>>} ->
						case gen_tcp:recv(Socket, Len) of
								{ok, <<?RE_REGISTER:16, Len1:16, Bin/binary>>} ->
                                        io:format("client send register~n"),
										<<Regid:Len1/binary-unit:8,_Len2:16, Password/binary>> = Bin,
										RegId = binary_to_list(Regid),
										gen_server:cast(user_handle, {reg, RegId, Password, Socket}),
										loop_accept(Socket, UserPID);
								{ok, <<?RE_LOGIN:16, Len1:16, Bin/binary>>} ->
                                        io:format("client send login~n"),
										<<Logid:Len1/binary-unit:8, _Len2:16, Password/binary>> = Bin,
										UserId = binary_to_list(Logid),
										Userpid = erlang:spawn_link(fun() -> user_handle(UserId, Password, Socket) end),
										loop_accept(Socket, Userpid);
								{ok, <<?RE_SELECT_ROOM:16, Bin/binary>>} ->
                                        io:format("client select room"),
										RoomNum = binary_to_list(Bin),
										gen_server:cast(user_handle, {enter_room, RoomNum, UserPID, Socket}),
										loop_accept(Socket, UserPID);
								{ok, <<?RE_SENDMSG:16, Bin/binary>>} ->
										Msg = binary_to_list(Bin),
										case ets:lookup(roomdata, UserPID) of
												[{_, {RoomNum, UserId}}] ->
														gen_server:cast(room_handle, {msg, RoomNum, UserId, Msg}),
														loop_accept(Socket, UserPID);
												[] ->
														gen_tcp:send(Socket, <<1:16>>),
														gen_tcp:send(Socket, <<2>>),
														loop_accept(Socket, UserPID)
										end;
								{ok, <<?RE_LEAVE_ROOM:16, Bin/binary>>} ->
										case Bin of
											<<1>> ->
												gen_server:cast(user_handle, {leave_room, UserPID})
										end,
										loop_accept(Socket, UserPID);
								{ok, <<?RE_LOGOUT:16, Bin/binary>>} ->
										case Bin of
												<<1>> ->
														gen_server:cast(user_handle, {logout, UserPID, Socket})
										end,
										loop_accept(Socket, UserPID);
								{ok, <<?RE_ADD_ROOM:16, Bin/binary>>} ->
										RoomName = binary_to_list(Bin),
										gen_server:cast(room_handle, {add_room, RoomName, Socket}),
										loop_accept(Socket, UserPID);
								{ok, <<?RE_DELETE_ROOM:16, Bin/binary>>} ->
										RoomName = binary_to_list(Bin),
										gen_server:cast(room_handle, {delete_room, RoomName, Socket}),
										loop_accept(Socket, UserPID);
								{error, Reason} ->
										error_logger:error_msg("error!")
		end;
			{error, closed} ->
					gen_server:cast(user_handle, {disconnect, UserPID, Socket})
	end.

user_handle(UserId, Password, Socket) ->
		UserPID = self(),
		gen_server:cast(user_handle, {login, UserId, Password, UserPID, Socket}),
		ok.

my_init([Port]) ->
		case gen_tcp:listen(Port, [binary, {packet, 0}, {active, false}]) of 
				{ok, Listen} ->
                        io:format("get a connect~~~~~~~~~~~~"),
						spawn_link(fun() -> main_loop(Listen) end );
				{error, Reason} ->
						error_logger:error_msg("ssfsfsf")
		end,
		{ok, 0}.
