%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 一月 2017 14:32
%%%-------------------------------------------------------------------
-module(market_util).
-author("hxming").
-include("common.hrl").
-include("server.hrl").

%% API
-export([
    get_tip/2
    , match_name/2

]).


%%交易手续费
get_tip(Player, Price) ->
    case data_vip_args:get(54, Player#player.vip_lv) of
        [] ->
            util:ceil(Price * 0.4);
        Per ->
            util:ceil(Price * Per / 100)
    end.

match_name(Target, Match) ->
    F = fun(Item) -> lists:member(Item, Match) end,
    lists:all(F, Target).