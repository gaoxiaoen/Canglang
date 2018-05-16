%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_battlefield_time
	%%% @Created : 2016-06-23 17:48:30
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_battlefield_time).
-export([ids/0]).
-export([get/1]).
-include("common.hrl").

    ids() ->
    [1].
get(1)->{[1,2,3,4,5,6,7],[{19,00},{19,20}]};
get(_) -> [].
