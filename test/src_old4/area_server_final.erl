%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 终极版本
%%% @end
%%% Created : 08. 五月 2018 10:51
%%%-------------------------------------------------------------------
-module(area_server_final).
-author("Administrator").

%% API
-export([loop/0,area/2,start/0]).

start() ->
    spawn(area_server_final,loop,[]).

area(Pid,What) ->
    rpc(Pid,What).

rpc(Pid,Request) ->
    Pid ! {self(),Request},
    receive
        Response ->
            Response
    end.

loop() ->
    receive
        {From,{rectangle,Width,Ht}} ->
            io:format("Area of rectangle is ~p~n",[Width*Ht]),
            From ! {self(),Width*Ht},
            loop();
        {From,{square,Side}} ->
            io:format("Area of square is ~p~n",[Side*Side]),
            From ! {self(),Side*Side},
            loop();
        {From,{circle,R}} ->
            From ! {self(),3.14 *R*R},
            loop();
        {From,Other} ->
            From ! {self(),error,Other},
            loop()
    end.