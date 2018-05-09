%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 五月 2018 15:35
%%%-------------------------------------------------------------------
-module(dist_demo).
-author("Administrator").

%% API
-export([start/1,rpc/4]).

start(Node) ->
    spawn(Node,fun() ->loop() end).
rpc(Pid,M,F,A) ->
    Pid ! {rpc,self(),M,F,A},
    receive
        {Pid,Response} ->
            Response
    end.
loop() ->
    receive
        {rpc,Pid,M,F,A} ->
            Pid ! {self(),(catch apply(M,F,A))},
            loop()
    end.

