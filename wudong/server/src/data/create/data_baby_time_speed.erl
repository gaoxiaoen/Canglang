%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_baby_time_speed
	%%% @Created : 2018-03-28 11:26:06
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_baby_time_speed).
-export([get/1]).
-include("baby.hrl").
-include("common.hrl").
get(7305001) ->
	#base_baby_time_speed{goods_id = 7305001 ,cost_type = bgold ,cost = 20 ,time = 3600 };
get(7305002) ->
	#base_baby_time_speed{goods_id = 7305002 ,cost_type = bgold ,cost = 100 ,time = 21600 };
get(7305003) ->
	#base_baby_time_speed{goods_id = 7305003 ,cost_type = gold ,cost = 200 ,time = 86400 };
get(_) -> [].

