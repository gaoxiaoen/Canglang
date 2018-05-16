%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_guild_answer_time
	%%% @Created : 2018-03-09 17:01:30
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_guild_answer_time).
-export([ids/0]).
-export([get_week/1]).
-export([get_time/1]).
-include("common.hrl").

ids() ->
    [1,2].
get_week(1) ->[1,2,3,4,5,6,7];
get_week(2) ->[1,2,3,4,5,6,7];
get_week(_) -> [].
get_time(1) ->[{11,50},{12,00}];
get_time(2) ->[{22,00},{22,10}];
get_time(_) -> [].
