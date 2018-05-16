%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 五月 2018 14:24
%%%-------------------------------------------------------------------
-module(tcp_reader_sup).
-author("Administrator").

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).


start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
  {ok, {{simple_one_for_one, 10, 10},
    [{tcp_reader, {tcp_reader,start_link,[]},
      temporary, brutal_kill, worker, [tcp_reader]}]}}.
