%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_battlefield_position
	%%% @Created : 2016-06-23 17:48:30
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_battlefield_position).
-export([group_list/0]).
-export([get/1]).
-include("common.hrl").

    group_list() ->
    [1,2,3].
get(1)->[{58,26},{63,35}];
get(2)->[{23,26},{29,34}];
get(3)->[{23,72},{28,80}];
get(_) -> [].