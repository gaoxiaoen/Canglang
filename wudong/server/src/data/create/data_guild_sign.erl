%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_guild_sign
	%%% @Created : 2017-06-19 20:41:30
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_guild_sign).
-export([ids/0,get_award/1]).
-include("common.hrl").
-include("guild.hrl").

    ids() ->
    [5,10,15,25].
get_award(5)->[5,10111,20];
get_award(10)->[10,10111,40];
get_award(15)->[15,10111,60];
get_award(25)->[25,10111,80];
get_award(_) -> [].