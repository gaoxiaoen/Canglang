%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 五月 2018 20:13
%%%-------------------------------------------------------------------
-module(motor_controller).
-author("Administrator").

%% API
-export([add_event_handler/0]).

add_event_handler() ->
    event_handler:add_handler(errors,fun controller/1).
controller(too_hot) ->
    io:format("Turn off the motor~n");
controller(X)->
    io:format("~w ignored event:~p~n",[?MODULE,X]).


