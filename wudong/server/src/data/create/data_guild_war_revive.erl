%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_guild_war_revive
%%% @Created : 2016-06-12 15:50:03
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_guild_war_revive).
-export([get/1]).
-include("common.hrl").
-include("guild.hrl").
get(1)->50;
get(2)->75;
get(3)->100;
get(4)->125;
get(5)->150;
get(_) -> false.