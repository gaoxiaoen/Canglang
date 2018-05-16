%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_guild_box_ratio
	%%% @Created : 2017-12-13 23:11:21
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_guild_box_ratio).
-export([get/1]).
-include("guild.hrl").
get(Count) when Count >= 0 andalso  Count =< 3 -> [{1,100},{2,100},{3,50},{4,20},{5,10}];
get(Count) when Count >= 4 andalso  Count =< 6 -> [{2,100},{3,50},{4,20},{5,10}];
get(Count) when Count >= 6 andalso  Count =< 9 -> [{3,50},{4,20},{5,10}];
get(Count) when Count >= 10 andalso  Count =< 999 -> [{5,100}];
get(_) -> [].