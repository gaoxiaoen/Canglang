%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_hunt_time
	%%% @Created : 2016-06-14 18:15:53
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_hunt_time).
-export([ids/0]).
-export([get/1]).
-include("common.hrl").
-include("cross_hunt.hrl").

    ids() ->
    [1,2].
get(1)->[{15,0},{15,20}];
get(2)->[{21,0},{21,20}];
get(_) -> [].
