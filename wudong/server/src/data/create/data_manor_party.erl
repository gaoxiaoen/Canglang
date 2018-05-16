%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_manor_party
	%%% @Created : 2017-07-24 17:09:43
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_manor_party).
-export([get/1]).
-include("common.hrl").
-include("manor_war.hrl").
get(13003) ->
	#base_manor_party{scene_id = 13003 ,x = 34 ,y = 52 ,table_list = [{64535,34,52},{37401,30,56},{37401,39,56},{37401,34,45}] ,collect_times = 5 };
get(10002) ->
	#base_manor_party{scene_id = 10002 ,x = 35 ,y = 65 ,table_list = [{64535,35,65},{37401,32,71},{37401,37,71},{37401,40,64}] ,collect_times = 5 };
get(10003) ->
	#base_manor_party{scene_id = 10003 ,x = 23 ,y = 28 ,table_list = [{64535,23,28},{37401,23,23},{37401,19,27},{37401,25,32}] ,collect_times = 5 };
get(10004) ->
	#base_manor_party{scene_id = 10004 ,x = 67 ,y = 88 ,table_list = [{64535,67,88},{37401,63,90},{37401,69,90},{37401,63,83},{37401,69,83}] ,collect_times = 5 };
get(10006) ->
	#base_manor_party{scene_id = 10006 ,x = 27 ,y = 40 ,table_list = [{64535,27,40},{37401,23,36},{37401,24,44},{37401,31,38}] ,collect_times = 5 };
get(_) -> [].