%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 十二月 2017 15:15
%%%-------------------------------------------------------------------
-module(godness_init).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("godness.hrl").
-include("goods.hrl").

%% API
-export([init/1]).

init(#player{key = Pkey} = Player) ->
    GodnessList = godness_load:load(Pkey),
    F = fun(Godness) ->
        Godness00 = godness:cacl_suit_skill(Godness),
        godness_attr:cacl_singleton_godness_attribute(Godness00)
    end,
    NewGodnessList = lists:map(F, GodnessList),
    StGodness =
        #st_godness{
            pkey = Pkey,
            godness_list = NewGodnessList
        },
    NStGodness = godness_attr:calc_player_attribute(StGodness),
    NewStGodness = godness:update_skill(NStGodness),
    lib_dict:put(?PROC_STATUS_GODNESS, NewStGodness),
    Player#player{
        godness_skill = NewStGodness#st_godness.skill_list,
        passive_skill = NewStGodness#st_godness.godsoul_skill_list ++ Player#player.passive_skill
    }.