%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 五月 2018 11:43
%%%-------------------------------------------------------------------
-module(lib_misc).
-author("Administrator").

%% API
-export([]).

sleep(T)->
    receive
    after T->
        true
    end.

flush_buffer() ->
    receive
        _Any ->
            flush_buffer()
    after 0->
        true
    end.

priority_receive() ->
    receive
        {alarm,X} ->
            {alarm,X}
    after 0 ->
        receive
            Any ->
                Any
        end
    end.

on_exit(Pid,Fun) ->
    spawn(fun() ->
                Ref = monitor(process,Pid),
                receive
                    {'Down',Ref,process,Pid,Why} ->
                        Fun(Why)
                end
        end).


