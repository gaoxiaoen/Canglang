-module(main).
-define(CHATSERVER, [sasl, chat_server]).
-include("common.hrl").
%-include_lib("stdlib/include/ms_transform.hrl").


-export([chat_server_start/0, chat_server_stop/0]).

chat_server_start() ->
        lists:foreach(fun(App) -> application:start(App) end, ?CHATSERVER).

chat_server_stop() ->
        lists:foreach(fun(App) -> application:stop(App) end, ?CHATSERVER).

