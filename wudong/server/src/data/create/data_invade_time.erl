%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_invade_time
	%%% @Created : 2016-06-07 20:56:20
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_invade_time).
-export([ids/0]).
-export([get/1]).
-include("common.hrl").
-include("invade.hrl").

    ids() ->
    [1,2].
get(1)->[{11,0},{11,15}];
get(2)->[{21,30},{21,45}];
get(_) -> [].
