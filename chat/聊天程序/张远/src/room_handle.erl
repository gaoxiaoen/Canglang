-module(room_handle).
-behaviour(gen_server).

-include("common.hrl").

-export([start_link/0]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() ->
		gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
		process_flag(trap_exit, true),
		my_init([]).

handle_call(Info, _From, State) ->
		my_call(Info, _From, State).

handle_cast(Info, State) ->
		my_cast(Info, State).

my_cast({add_room, RoomName, Socket}, State)  ->
		case lists:member(RoomName, State) of
				true ->
						skip;
				false ->
						New_Rooms = [RoomName | State],
						Name = list_to_atom(RoomName),
						add_room(Name),
						{ok, Len, Data} = tcp_protocol:server_pack(56000, RoomName),
						gen_tcp:send(Socket, <<Len:16>>),
						gen_tcp:send(Socket, Data),
						{noreply, New_Rooms}
		end;

my_cast({delete_room, RoomName, Socket}, State) ->
		case lists:member(RoomName, State) of
				false ->
						skip,
						{noreply, State};
				true ->
						New_Rooms = lists:delete(RoomName, State),
						Name = list_to_atom(RoomName),
						delete_room(Name),
						{ok, Len, Data} = tcp_protocol:server_pack(57000, RoomName),
						gen_tcp:send(Socket, <<Len:16>>),
                        gen_tcp:send(Socket, Data),
						{noreply, New_Rooms}
		end;

my_cast({research, UserId, Socket}, State) ->
		lists:foreach(
		  fun(Room) ->
						  {ok, Len, Data} = tcp_protocol:server_pack(56000, Room),
						  gen_tcp:send(Socket, <<Len:16>>),
						  gen_tcp:send(Socket, Data) end, State
		 ),
		{ok, Len, Data} = tcp_protocol:server_pack(11000, UserId),
		gen_tcp:send(Socket, <<Len:16>>),
		gen_tcp:send(Socket, Data),
		{noreply, State};

my_cast({inroom, RoomNum, UserId, Socket}, State) ->
		io:format("~p~n", [RoomNum]),
		io:format("~p~n", [State]),
		case lists:member(RoomNum, State) of
				false -> skip;
				true -> 
						Name1 = list_to_atom(RoomNum),
						gen_server:cast(Name1, {toroom, RoomNum, UserId, Socket})
		end,
		{noreply, State};

my_cast({msg, RoomNum, UserId, Msg}, State) ->
		case lists:member(RoomNum, State) of
				false -> skip;
				true -> 
						Name1 = list_to_atom(RoomNum),
						gen_server:cast(Name1, {msg, UserId, Msg})
		end,
		{noreply, State};

my_cast({outroom, RoomNum, UserId}, State) ->
		case lists:member(RoomNum, State) of
				false -> skip;
				true -> 
						Name1 = list_to_atom(RoomNum),
						gen_server:cast(Name1, {outroom, UserId, RoomNum})
		end,
		{noreply, State};

my_cast({disconnect, RoomNum, UserId}, State) ->
		case lists:member(RoomNum, State) of
				false -> skip;
				true -> 
						Name1 = list_to_atom(RoomNum),
						gen_server:cast(Name1, {disconnect, UserId, RoomNum})
		end.


handle_info(_Info, State) -> {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

add_room(Name) ->
		supervisor:start_child(room_sup, {"Name", {room_handle, start_link,[Name]},
										 transient, 1000, worker, [room_sup]}).

delete_room(Name) ->
		supervisor:delete_child(room_sup, Name).

my_init([]) ->
		Name = "room1",
		Name1 = list_to_atom(Name),
		supervisor:start_child(room_sup, {Name, {room_work, start_link, [Name1]},
										 transient, 1000, worker, [room_sup]}),
		{ok, [Name]}.

my_call({outroom, RoomNum, UserId}, _From, State) ->
		case lists:member(RoomNum, State) of
			false -> skip;
			true ->
				Name1 = list_to_atom(RoomNum),
				Reply = gen_server:call(Name1, {outroom, UserId, RoomNum}),
				{reply, Reply, State}
		end.








