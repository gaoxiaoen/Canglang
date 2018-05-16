%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 五月 2018 14:22
%%%-------------------------------------------------------------------
-module(tcp_listener_sup).
-author("Administrator").

-behaviour(supervisor).

%% API
-export([start_link/1]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

start_link(Port) ->
  supervisor:start_link(?MODULE, {10, Port}).

init({AcceptorCount, Port}) ->
  {ok,
    {{one_for_all, 10, 10},
      [
        {
          tcp_acceptor_sup,
          {tcp_acceptor_sup, start_link, []},
          transient,
          infinity,
          supervisor,
          [tcp_acceptor_sup]
        },
        {
          tcp_listener,
          {tcp_listener, start_link, [AcceptorCount, Port]},
          transient,
          100,
          worker,
          [tcp_listener]
        }
      ]
    }
  }.