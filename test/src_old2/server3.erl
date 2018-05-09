%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 五月 2018 17:51
%%%-------------------------------------------------------------------
-module(server3).
-author("Administrator").

%% API
-export([start/2,rpc/2,swap_code/2]).

start(Name,Mod) ->
%%    当spawn命令被执行时，系统就会创建一个新的进程，每个进程都带有一个邮箱，这个邮箱是和进程同步创建的
%%    当某个进程发送消息后，消息会被放入该进程的邮箱，只有当程序执行一条接受语句时才会读取邮箱。
%%    将一个进程注册进去，并给其一个别名为Name,唯一的标识该创建的进程
    register(Name,spawn(fun() -> loop(Name,Mod,Mod:init()) end)).

swap_code(Name,Mod) ->
    rpc(Name,{swap_code,Mod}).

rpc(Name,Request) ->
    Name ! {self(),Request},  %% ! 被称为发送操作符,self() 是客户端进程的标识符
    receive
        {Name,Response} ->Response
    end.

loop(Name,Mod,OldState) ->
    receive
        {From,{swap_code,NewCallBackMod}} ->
            From ! {Name,ack},
            loop(Name,NewCallBackMod,OldState);
        {From,Request} ->
            {Response,NewState} = Mod:handle(Request,OldState),
            From ! {Name,Response},
            loop(Name,Mod,NewState)
    end.
