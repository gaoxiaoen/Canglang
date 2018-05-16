-module(chat_server_app).
-behaviour(application).
-export([start/2, stop/1]).

start(_Type, _StartArgs) ->
		chat_server_sup:start_link(_StartArgs).

stop(_State) -> {ok}.


