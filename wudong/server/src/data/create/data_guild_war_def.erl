%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_guild_war_def
%%% @Created : 2016-06-12 15:50:03
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_guild_war_def).
-export([ids/0,get/1]).
-include("common.hrl").
-include("guild_war.hrl").

    ids() ->
    [1,2,3].
get(1)->[{42001,98,37},{42001,103,48}];
get(2)->[{42002,13,47},{42002,18,37}];
get(3)->[{42003,52,134},{42003,61,134}];
get(_) -> [].
