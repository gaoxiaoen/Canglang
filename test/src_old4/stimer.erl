%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 五月 2018 11:50
%%%-------------------------------------------------------------------
-module(stimer).
-author("Administrator").

%% API
-export([start/2,cancel/1]).

start(Time,Fun) ->
    spawn(fun() ->timer(Time,Fun) end).

cancel(Pid) ->
    Pid!cancel.

timer(Time,Fun) ->
    receive
        cancel ->void
    after    %% 使用after 进行数
        Time->
            Fun()
    end.
