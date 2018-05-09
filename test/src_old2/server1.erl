%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 基本的服务器
%%% @end
%%% Created : 07. 五月 2018 16:58
%%%-------------------------------------------------------------------
-module(server1).
-author("Administrator").

%% API
-export([start/2,rpc/2]).

start(Name,Mod) ->
    register(Name,spawn(fun() ->loop(Name,Mod,Mod:init()) end)).

rpc(Name,Request) ->
    Name ! {self(),Request},
    receive
        {Name,Response} ->Response
    end.

loop(Name,Mod,State) ->
    receive
        {From,Request} ->
            {Response,State1} = Mod:handle(Request,State),
            From ! {Name,Response},
            loop(Name,Mod,State1)
    end.

