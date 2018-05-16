%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_battlefield_time
	%%% @Created : 2017-11-15 14:28:34
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_battlefield_time).
-export([ids/0]).
-export([get/1]).
-include("common.hrl").

    ids() ->
    [1].
get(1)->{[1,3,5,7],[{21,00},{21,30}]};
get(_) -> [].
