%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 五月 2018 10:51
%%%-------------------------------------------------------------------
-module(area_server1).
-author("Administrator").

%% API
-export([loop/0,rpc/2]).

%%start(Name,Mod) ->
%%    register(Name,spawn(fun() -> loop(Name,Mod,[]) end)).

%%loop(Name,Mod,_) ->
%%    receive
%%        {rectangel,Width,Ht} ->
%%            io:format("Area of rectangle is ~p~n",[Width*Ht]);
%%%%            loop(Name,Mod,_);
%%        {square,Side} ->
%%            io:format("Area of square is ~p~n",[Side*Side])
%%%%            loop(Name,Mod,_)
%%    end.

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
            From ! Width*Ht,
            loop();
        {From,{square,Side}} ->
            io:format("Area of square is ~p~n",[Side*Side]),
            From ! Side*Side,
            loop();
        {From,{circle,R}} ->
            From ! 3.14 *R*R,
            loop();
        {From,Other} ->
            From ! {error,Other},
            loop()
    end.