%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_battlefield_def
	%%% @Created : 2016-06-23 17:48:30
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_battlefield_def).
-export([ids/0,get/1]).
-include("common.hrl").
-include("battlefield.hrl").

    ids() ->
    [1,2,3].
get(1)->[{42011,58,26},{42011,63,35}];
get(2)->[{42012,23,34},{42012,29,27}];
get(3)->[{42013,23,72},{42013,28,80}];
get(_) -> [].
