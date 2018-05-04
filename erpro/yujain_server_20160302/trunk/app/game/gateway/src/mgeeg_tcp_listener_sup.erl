%%%-------------------------------------------------------------------
%%% File        :mgeeg_tcp_listener_sup.erl
%%%-------------------------------------------------------------------

-module(mgeeg_tcp_listener_sup).

-behaviour(supervisor).

-export([
         start_link/0,
         init/1
        ]).

-export([]).

start_link() ->
    supervisor:start_link({local,?MODULE},?MODULE, []).

init([]) ->
    RestartStrategy = one_for_one,
    MaxRestarts = 1000,
    MaxSecondsBetweenRestarts = 3600,
    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},
    {ok, {SupFlags, []}}.
