%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_guild_war_position
%%% @Created : 2016-06-12 15:50:03
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_guild_war_position).
-export([group_list/0]).
-export([get/1]).
-include("common.hrl").
-include("guild.hrl").

    group_list() ->
    [1,2,3].
get(1)->[{98,36},{105,46}];
get(2)->[{11,34},{17,45}];
get(3)->[{52,134},{61,142}];
get(_) -> [].