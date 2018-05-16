-module(chat_server_sup).

-behaviour(supervisor).

%% API
-export([start_link/1]).

%% Supervisor callbacks
-export([init/1]).


%% ===================================================================
%% API functions
%% ===================================================================

start_link(Port) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, [Port]).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([Port]) ->
    {ok,
        {{one_for_one, 5, 60},
            [
                %% client_acceptor
                {
                    client_acceptor,
                    {client_acceptor, start_link, [Port]},
                    permanent,
                    2000,
                    worker,
                    [client_acceptor]
                },
                %% chat_room
                {
                    chat_room,
                    {chat_room, start_link, []},
                    permanent,
                    2000,
                    worker,
                    [chat_room]
                }
            ]
        }
    }.



