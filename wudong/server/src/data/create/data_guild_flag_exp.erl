%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_guild_flag_exp
	%%% @Created : 2018-03-06 00:01:55
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_guild_flag_exp).
-export([get/1]).
-include("guild_fight.hrl").
get(Lv) when Lv >= 1 andalso Lv =< 999 -> 10;
get(_Lv) -> [].

