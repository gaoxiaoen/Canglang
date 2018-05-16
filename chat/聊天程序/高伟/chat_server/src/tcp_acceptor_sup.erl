%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 五月 2018 14:23
%%%-------------------------------------------------------------------
-module(tcp_acceptor_sup).
-author("Administrator").

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
  {ok, {{simple_one_for_one, 10, 10},
    [{tcp_acceptor, {tcp_acceptor, start_link, []},
      transient, brutal_kill, worker, [tcp_acceptor]}]}}.