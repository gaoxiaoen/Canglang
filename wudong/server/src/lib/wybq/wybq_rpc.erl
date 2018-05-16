%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 三月 2017 16:43
%%%-------------------------------------------------------------------
-module(wybq_rpc).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("wybq.hrl").

%% API
-export([handle/3]).

handle(43401, Player, _) ->
%%     ?DEBUG("43401 ###~n", []),
    wybq:get_info(Player),
    ok;

handle(43402, Player, {OrtherPkey}) ->
%%     io:format("43402 Key:~p~n", [OrtherPkey]),
    wybq:compare(Player, OrtherPkey),
    ok;

handle(_Cmd, _Player, _) ->
    ok.
