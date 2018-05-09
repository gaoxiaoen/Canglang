%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 五月 2018 12:03
%%%-------------------------------------------------------------------
-module(clock).
-author("Administrator").

%% API
-export([start/2,stop/0]).

start(Time,Fun) ->
    register(clock,spawn(fun() ->tick(Time,Fun) end)).

stop() ->clock ! stop.

tick(Time,Fun) ->
    receive
        stop ->
            void
    after Time->
        Fun(),
        tick(Time,Fun)
    end.


