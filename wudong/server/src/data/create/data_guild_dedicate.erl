%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_guild_dedicate
	%%% @Created : 2017-06-19 20:41:30
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_guild_dedicate).
-export([ids/0,get/1]).
-include("common.hrl").
-include("guild.hrl").

    ids() ->
    [1,2].
get(1) ->
	#base_guild_dedicate{id = 1 ,dedicate = 50 };
get(2) ->
	#base_guild_dedicate{id = 2 ,dedicate = 100 };
get(_) -> [].