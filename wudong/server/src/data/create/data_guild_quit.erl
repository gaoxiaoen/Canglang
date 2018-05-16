%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_guild_quit
	%%% @Created : 2017-08-31 17:32:16
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_guild_quit).
-export([ids/0]).
-export([get/1]).
-include("common.hrl").
-include("guild.hrl").

    ids() ->
    [1,2,3,4,5].
get(1)->0;
get(2)->3600;
get(3)->19800;
get(4)->43200;
get(5)->86400;
get(_) -> [].
