%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_guild_medal_reward
	%%% @Created : 2018-03-06 00:01:55
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_guild_medal_reward).
-export([get/1]).
-include("guild_fight.hrl").
get(Rank) when Rank >= 1 andalso Rank =< 20 -> 5;
get(Rank) when Rank >= 21 andalso Rank =< 50 -> 4;
get(Rank) when Rank >= 51 andalso Rank =< 100 -> 3;
get(_Rank) -> 0.

