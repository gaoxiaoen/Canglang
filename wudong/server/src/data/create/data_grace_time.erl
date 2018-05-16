%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_grace_time
	%%% @Created : 2017-04-11 16:14:29
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_grace_time).
-export([ids/0]).
-export([get/1]).
-include("common.hrl").
-include("grace.hrl").

    ids() ->
    [1].
get(1)->[{14,30},{15,0}];
get(_) -> [].
