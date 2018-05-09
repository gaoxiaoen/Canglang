%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 五月 2018 15:26
%%%-------------------------------------------------------------------
-module(sellaprime_app).
-author("Administrator").
-behaviour(application).
%% API
-export([start/2,stop/1]).

start(_Type,StartArgs) ->
    sellaprime_supervisor:start_link(StartArgs).
stop(_State) ->
    ok.
