%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 五月 2018 16:58
%%%-------------------------------------------------------------------
-module(server1).
-author("Administrator").

%% API
-export([start/2,rpc/2]).

start(Name,Mod) ->
    register(Name,spawn(fun()-> loop(Name,Mod,Mod:init())end)).

rpc(Name,Request) ->
    io:format("[svr] rpc is begin .....~n"),
    Name ! {self(),Request},
    receive
        {Name,Response} ->
            io:format("[svr] response = ~p,Name=-~p ~n",[Response,Name]),
            Response
    end.

loop(Name,Mod,State) ->
    io:format("[svr]loop is begin....~n"),
    receive
        {From,Request} ->
            {Response,State1} = Mod:handle(Request,State),
            io:format("[svr] response = ~p,state1=~p,from=~p ~n",[Response,State1,From]),
            From ! {Name,Response},
            From ! {Name,Response},
            loop(Name,Mod,State1)
    end.


