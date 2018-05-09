%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 五月 2018 14:58
%%%-------------------------------------------------------------------
-module(b).
-author("Administrator").

%% API
%%-export([]).

-compile(export_all).

start(Tag) ->
    spawn(fun() ->loop(Tag) end ).

loop(Tag) ->
    sleep(),
    Val = a:x(),
    io:format("Vsn2 (~p) b:x()=~p~n",[Tag,Val]),
    loop(Tag).

sleep() ->
    receive
        after 3000 ->true
    end.



