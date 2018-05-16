-module(chat_server_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% default port
-define(PORT, 2345).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    chat_server_sup:start_link(?PORT).

stop(_State) ->
    ok.
