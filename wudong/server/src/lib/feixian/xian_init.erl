%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 十月 2017 15:48
%%%-------------------------------------------------------------------
-module(xian_init).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("xian.hrl").
-include("goods.hrl").

%% API
-export([
    init/1
]).

init(Player) ->
    xian_map:init(Player),
    xian_exchange:init(Player),
    NPlayer = xian_upgrade:init(Player),
    NewPlayer = xian_skill:init(NPlayer),
    NewPlayer.