%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_guild_war_time
%%% @Created : 2016-06-12 15:50:03
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_guild_war_time).
-export([ids/0]).
-export([get/1]).
-include("common.hrl").

    ids() ->
    [1].
get(1)->{[2,4,6],[{20,00},{20,20}]};
get(_) -> [].
