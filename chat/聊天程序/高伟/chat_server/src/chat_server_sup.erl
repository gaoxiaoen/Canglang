%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 五月 2018 10:57
%%%-------------------------------------------------------------------
-module(chat_server_sup).
-author("Administrator").

-behaviour(supervisor).

%% API
-export([start_link/0, start_child/1, start_child/2, init/1]).

-define(SERVER, ?MODULE).


start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

start_child(Mod) ->
  start_child(Mod, []).

start_child(Mod, Args) ->
  {ok, _} = supervisor:start_child(?MODULE, {Mod, {Mod, start_link, Args}, transient, 100, worker, [Mod]}),
  ok.

init([]) ->
  {ok,{
    {one_for_one, 3, 10},
    []
  }}.