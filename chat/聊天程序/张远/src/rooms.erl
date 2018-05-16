-module(rooms).
-behaviour(gen_server).
-include("common.hrl").

-export([start_link/1]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

start_link(Name) ->
	gen_server:start_link({local, Name}, ?MODULE, [], []).

init([]) ->
	erlang:process_flag(trap_exit, true),
	{ok, []}.

handle_call(Info, _From, State) ->
	my_call(Info, _From,State).

handle_cast(Info, State) ->
	my_cast(Info, State).


handle_info(_Info, State) ->{noreply, State}.
terminate(_Reason, _State) ->ok.
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


send_msg(Sockets, Len, Msg) ->
    lists:foreach(
        fun( {_,_UserId, Socket} ) ->
			gen_tcp:send(Socket, <<Len:16>>),
            gen_tcp:send(Socket, Msg)
        end, Sockets).

my_call({outroom, UserId, RoomNum}, _From, State) ->
	io:format("~s leave ~s~n", [UserId, RoomNum]),
	{ok, Len, Data} =tcp_protocol:server_pack(54000, [UserId, RoomNum]),
	lists:foreach(
	  fun( {_UserId, Sock} ) ->
			  gen_tcp:send(Sock, <<Len:16>>),
			  gen_tcp:send(Sock, Data)
	  end, State),
	{_, Socket} = lists:keyfind(UserId, 1, State),
	New_State = lists:keydelete(UserId, 1, State),
	io:format("room member: ~n~p~n",[New_State]),
	{reply, Socket, New_State}.

my_cast({toroom, RoomNum, UserId, Socket}, State) ->
	io:format("~s entered to ~s~n",[UserId,RoomNum]),
	{ok, Len, Data} = tcp_protocol:server_pack(52000, [UserId, RoomNum]),
	New_State = [{normal, UserId, Socket} | State],
	io:format("room member: ~n~p~n",[New_State]),
	lists:foreach(
	  fun( {_, _UserId, Sock} ) ->
			  gen_tcp:send(Sock, <<Len:16>>),
			  gen_tcp:send(Sock, Data)
	  end, New_State),
	{noreply, New_State};
	
my_cast({outroom, UserId, RoomNum}, State) ->
	io:format("~s leave ~s~n", [UserId,RoomNum]),
	{ok, Len, Data} =tcp_protocol:server_pack(54000, [UserId, RoomNum]),
	lists:foreach(
	  fun( {_, _UserId, Sock} ) ->
			  gen_tcp:send(Sock, <<Len:16>>),
			  gen_tcp:send(Sock, Data)
	  end, State),
	New_State = lists:keydelete(UserId, 2, State),
	io:format("room member: ~n~p~n",[New_State]),
	{noreply, New_State};
	
my_cast({mssg, UserId, Mssg}, State) ->
	case lists:keyfind(UserId, 2, State) of
		false->
			skip,
			{noreply, State};
		{silent, _, _} ->
			Silent_Msg = "***********",
			{ok, Len, Data} = tcp_protocol:server_pack(53000, [UserId, Silent_Msg]),
			send_msg(State, Len, Data),
			{noreply, State};
		{normal, _UserId, _Socket}->
			{ok, Len, Data} = tcp_protocol:server_pack(53000, [UserId, Mssg]),
			send_msg(State, Len, Data),
			{noreply, State}
	end;	
	
my_cast({disconnect, UserId, RoomNum}, State) ->
	io:format("~s disconnect ~s~n", [UserId,RoomNum]),
	{ok, Len, Data} =tcp_protocol:server_pack(55000, [UserId, RoomNum]),
	lists:foreach(
	  fun( {_, _UserId, Sock} ) ->
			  gen_tcp:send(Sock, <<Len:16>>),
			  gen_tcp:send(Sock, Data)
	  end, State),
	New_State = lists:keydelete(UserId, 1, State),
	io:format("room member: ~n~p~n",[New_State]),
	{noreply, New_State}.
