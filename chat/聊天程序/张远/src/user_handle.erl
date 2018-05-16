-module(user_handle).

-behaviour(gen_server).

-include("common.hrl").

-export([start_link/0, add_admin/1]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
	process_flag(trap_exit, true),
	my_init([]).

handle_call(Info, _From, State) ->
	my_call(Info,_From,	State).

handle_cast(Info, State) ->
	my_cast(Info, State).
	

handle_info(_Info, State) ->{noreply, State}.

terminate(Info, Status) ->
	my_terminate(Info, Status).

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%本地接口
%%登录验证
check_user(UserId, Password, UserList) ->
	case lists:keyfind(UserId, 2, UserList) of
		false ->
			{error, not_a_user };
		%%普通用户验证
		{user, _User, Pass} ->
			case Pass == Password of
				false->
					{error, wrong_password};
				true ->
					{ok, user}
			end;
		%%管理员验证	
		{admin, _User, Pass} ->
			case Pass == Password of
				false->
					{error, wrong_password};
				true ->
					{ok, admin}
			end
	end.
	
add_admin(UserId)->
	gen_server:cast(?MODULE, {add_admin, UserId}),
	ok.
	
%%读取本地数据文件(用户数据保存在本地文件,不过数据库)
my_init([]) ->
	{ok, UserList} = file:consult("user_data"),
	{ok, UserList}.

my_call(_Info, _From, State) ->{reply, ok, State}.

%%用户注册
my_cast({reg, RegId, Password, Socket}, State) ->
	case check_user(RegId, "_", State)of
		{error, not_a_user}->
			New_List = [{user, RegId, Password}|State],
			{ok, Len, Data} = tcp_protocol:server_pack(50000, <<1>>),
			gen_tcp:send(Socket, <<Len:16>>),
			gen_tcp:send(Socket, Data),
			{noreply, New_List};
		{error, wrong_password} ->
			gen_tcp:send(Socket, <<1:16>>),
			gen_tcp:send(Socket, <<4>>),
			{noreply, State};
		{ok, _UserId}->
			gen_tcp:send(Socket, <<1:16>>),
			gen_tcp:send(Socket, <<4>>),
			{noreply, State}
	end;

%%用户登录
my_cast({login, UserId, Password, UserPID, Socket}, State) ->
	case check_user(UserId, Password , State) of
		{error, not_a_user} -> 
			gen_tcp:send(Socket, <<1:16>>),
			gen_tcp:send(Socket, <<0>>),
			{noreply, State};
		{error, wrong_password} ->
			gen_tcp:send(Socket, <<1:16>>),
			gen_tcp:send(Socket, <<3>>),
			{noreply, State};
		{ok, user} ->    
			ets:insert(onlinedata, {UserPID, {user, UserId}}),
			gen_server:cast(room_handle, {research, UserId, Socket}),
			{noreply, State};
		{ok, admin} ->
			ets:insert(onlinedata, {UserPID, {admin, UserId}}),
			gen_server:cast(room_handle, {research, UserId, Socket}),
			{noreply, State}
	end;

%%进入房间	
my_cast({enter_room, RoomNum, UserPID, Socket}, State) ->
	case ets:lookup(onlinedata, UserPID)of 
		[{_, {_, UserId}}]->
			gen_server:cast(room_handle, {inroom, RoomNum, UserId, Socket}),
			ets:insert(roomdata, {UserPID, {RoomNum, UserId}}),
			{noreply, State};
		[]->
			gen_tcp:send(Socket, <<1:16>>),
			gen_tcp:send(Socket, <<1>>),
			{noreply, State}
	end;
	
%%离开房间
my_cast({leave_room, UserPID}, State) ->
	[{_, {RoomNum, UserId}}] = ets:lookup(roomdata, UserPID),
	gen_server:cast(room_handle, {outroom, RoomNum, UserId}),
	ets:delete(roomdata, UserPID),
	{noreply, State};
	
%%退出登录
my_cast({logout, UserPID, Socket}, State) ->
	[{_, {_, _}}] = ets:lookup(onlinedata, UserPID),
	ets:delete(onlinedata, UserPID),
	gen_tcp:send(Socket, <<1:16>>),
	gen_tcp:send(Socket, <<5>>),
	{noreply, State};
	
%%断开连接
my_cast({disconnect, UserPID, Socket}, State) ->
	case ets:lookup(roomdata, UserPID)of 
		[{_, {RoomNum, UserId}}] ->
			gen_server:cast(room_handle, {disconnect, RoomNum, UserId}),
			{noreply, State};
		[]->
			case ets:lookup(onlinedata, UserPID)of 
				[{_, {_, _}}]->
					{noreply, State};
				[]->
					{noreply, State}
			end
	end;
	
%%添加管理员
my_cast({add_admin, UserId}, State) ->
	case lists:keyfind(UserId, 2, State) of
		false-> %%非注册的用户
			{noreply, State};
		{admin, _User, _Pass}-> %%该用户已经是管理员
			{noreply, State};
		{user, User, Pass} ->
			New_List = lists:keyreplace(User, 2, State, {admin, User, Pass}),
			{noreply, New_List}
	end.

%%断开的时候保存用户数据到本地文件
my_terminate(_Reason, {UserList, _}) ->
	{ok, S} = file:open("user_data", write),
	lists:foreach(fun(X)-> io:format(S,"~p.~n",[X])end, UserList),
	file:close(S),
	ok.
	
	
	
