%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 五月 2018 14:09
%%%-------------------------------------------------------------------
-module(server_sup).
-author("Administrator").

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1, start_child/1, start_child/2]).

-define(SERVER, ?MODULE).

start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

start_child(Mod) ->
  start_child(Mod, []).

start_child(Mod, Args)->
  {ok, _} = supervisor:start_child(?MODULE,
    {Mod, {Mod, start_link, Args}, transient, 100, worker, [Mod]}),
  ok.

init([]) ->
  {ok, {
    {one_for_one, 3, 10},[]
  }}.