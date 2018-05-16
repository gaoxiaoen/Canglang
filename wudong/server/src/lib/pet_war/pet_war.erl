%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 十一月 2017 15:59
%%%-------------------------------------------------------------------
-module(pet_war).
-author("li").

-include("common.hrl").
-include("server.hrl").

%% API
-export([
    init/1
]).

init(Player) ->
    pet_war_dun:init(Player),
    pet_map:init(Player),
    Player.
