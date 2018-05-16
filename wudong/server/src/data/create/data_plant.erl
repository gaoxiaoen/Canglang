%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_plant
	%%% @Created : 2017-06-08 15:05:22
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_plant).
-export([goods_list/0]).
-export([get/1]).
-include("plant.hrl").
goods_list() -> [10001].
get(10001) ->
	#base_plant{goods_id = 10001 ,plant_goods = [] ,water_goods = [] ,collect_goods = [] ,water_times = 3 ,collect_times = 3 ,grow_time = 60 ,bud_time = 60 ,water_time = 60 ,collect_time = 3 };
get(_) -> [].
