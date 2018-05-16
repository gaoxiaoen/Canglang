%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_guild_medal_reward100
	%%% @Created : 2018-03-06 00:01:55
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_guild_medal_reward100).
-export([get/1]).
-include("guild_fight.hrl").
get(Percent) when Percent >= 61 andalso Percent =< 100 -> 2;
get(Percent) when Percent >= 0 andalso Percent =< 60 -> 1;
get(_Percent) -> 0.

