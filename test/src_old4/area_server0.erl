%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 五月 2018 10:51
%%%-------------------------------------------------------------------
-module(area_server0).
-author("Administrator").

%% API
-export([loop/0]).

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

loop() ->
    receive
        {From,{rectangle,Width,Ht}} ->
            io:format("Area of rectangle is ~p~n",[Width*Ht]),
            From ! Width*Ht,
            loop();
        {square,Side} ->
            io:format("Area of square is ~p~n",[Side*Side]),
            loop()
    end.