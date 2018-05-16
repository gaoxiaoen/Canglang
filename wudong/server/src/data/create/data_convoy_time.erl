%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_convoy_time
	%%% @Created : 2017-09-07 16:53:45
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_convoy_time).
-export([ids/0]).
-export([get/1]).
-include("common.hrl").
-include("task.hrl").

    ids() ->
    [1,2].
get(1) ->
   #base_convoy_time{id = 1 ,time = [{15,00},{15,30}] ,reward = 2 };
get(2) ->
   #base_convoy_time{id = 2 ,time = [{20,30},{21,00}] ,reward = 2 };
get(_) -> [].