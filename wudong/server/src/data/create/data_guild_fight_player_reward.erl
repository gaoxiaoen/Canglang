%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_guild_fight_player_reward
	%%% @Created : 2018-03-06 00:01:55
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_guild_fight_player_reward).
-export([get/1]).
-include("guild_fight.hrl").
get(Lv) when Lv >= 1 andalso Lv =< 100 -> {1, []};
get(Lv) when Lv >= 101 andalso Lv =< 200 -> {1, []};
get(Lv) when Lv >= 201 andalso Lv =< 999 -> {1, []};
get(_Lv) -> [].

