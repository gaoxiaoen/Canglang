%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_flower_group
	%%% @Created : 2017-05-17 19:05:27
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_flower_group).
-export([id_list/0]).
-export([get/1]).
-include("common.hrl").
-include("achieve.hrl").

    id_list() ->
    [0,1,2].
get(30001) -> 1;
get(30002) -> 1;
get(30098) -> 1;
get(1001) -> 2;
get(_) -> 0.
