-module(chat_server_sup).
-behaviour(supervisor).

-export([start/0, start_link/1, init/1]).

start() ->
		spawn(fun() ->
					supervisor:start_link({local, ?MODULE}, ?MODULE, _Arg=[])
			 	end).

start_link(Args) ->
		supervisor:start_link({local, ?MODULE}, ?MODULE, Args).

init([]) ->
		{ok, {
				{one_for_one,  3, 10},
				[{room_sup,
				  {room_sup, start_link,[]},
				 permanent,
				 1000,
				 supervisor,
				 [room_sup]},
				 {data,
				  {data, start_link,[]},
				 transient,
				 1000,
				 worker,
				 [data]},
				 {message_handle,
				  {message_handle,start_link,[]},
				 transient,
				 1000,
				 worker,
				 [message_handle]},
				 {user_handle,
				  {user_handle,start_link,[]},
				 transient,
				 1000,
				 worker,
				 [user_handle]},
				 {room_handle,
				  {room_handle,start_link,[]},
				 transient,
				 1000,
				 worker,
				 [room_handle]}
				]
		  }}.

