%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_convoy_refresh
	%%% @Created : 2017-09-07 16:53:45
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_convoy_refresh).
-export([get/1]).
-include("common.hrl").
-include("task.hrl").
get(1)->[1008000,1];
get(2)->[1008000,2];
get(3)->[1008000,3];
get(_) -> [0,0].
