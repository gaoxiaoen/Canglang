%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_create_guild
	%%% @Created : 2017-06-19 20:41:30
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_create_guild).
-export([get/1]).
-include("common.hrl").
-include("guild.hrl").
get(1)->#base_create_guild{type=1,need_lv=30,gold=0,bgold=100};
get(2)->#base_create_guild{type=2,need_lv=1,gold=50,bgold=0};
get(_) -> [].
