%%%-------------------------------------------------------------------
%%% File        :mgeeg_tcp_acceptor_sup.erl
%%%-------------------------------------------------------------------
-module(mgeeg_tcp_acceptor_sup).

-behaviour(supervisor).

-include("mgeeg.hrl").

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local,?MODULE}, ?MODULE, []).

init([]) ->
    RestartStrategy = one_for_one,
    MaxRestarts = 1000,
    MaxSecondsBetweenRestarts = 3600,
    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},
    {ok, {SupFlags, []}}.