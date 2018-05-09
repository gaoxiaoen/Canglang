%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 五月 2018 17:34
%%%-------------------------------------------------------------------
-module(server2).
-author("Administrator").

%% API
-export([start/2,rpc/2]).

start(Name,Mod) ->
    register(Name,spawn(fun() ->loop(Name,Mod,Mod:init()) end)).

rpc(Name,Request) ->
    Name ! {self(),Request},
    receive
        {Name,crash} ->exit(rpc);
        {Name,ok,Response} ->Response
    end.

loop(Name,Mod,OldState) ->
    receive
        {From,Request} ->
            try Mod:handle(Request,OldState) of
                {Response,NewState} ->
                    From ! {Name,ok,Response},
                    loop(Name,Mod,NewState)
            catch
                _: Why->
                    log_the_error(Name,Request,Why),
                    %% 发送一个消息来让客户端崩溃
                    From ! {Name,crash},
%%                  以*开始*状态继续循环
                    loop(Name,Mod,OldState)
            end
    end.

log_the_error(Name,Request,Why) ->
    io:format("Server ~p request ~p ~n"
                "caused exception ~p~n",
        [Name,Request,Why]).