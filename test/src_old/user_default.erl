%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 五月 2018 16:49
%%%-------------------------------------------------------------------
-module(user_default).
-author("Administrator").

%% API
%%-export([]).
-compile(export_all).

hello() ->
    "Hello Joe how are you?".
away(Time) ->
    io:format("Joe is away and will be back in ~w minutes ~n",[Time]).