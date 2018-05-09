%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 五月 2018 10:49
%%%-------------------------------------------------------------------
-module(geometry).
-author("Administrator").

%% API
-export([area/1]).
area({rectangle,Width,Height}) ->
    Width * Height;

area({square,Side}) ->
    Side*Side.

