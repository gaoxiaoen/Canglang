%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_baby_daily_kill
	%%% @Created : 2018-03-28 11:26:06
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_baby_daily_kill).
-export([get/1]).
-export([ids/0]).
-include("common.hrl").
-include("baby.hrl").
get(1) ->
	#base_baby_kill_daily{kill_id = 1 ,num = 10000 ,goods = [{7302001,2}] };
get(2) ->
	#base_baby_kill_daily{kill_id = 2 ,num = 20000 ,goods = [{7302001,2}] };
get(3) ->
	#base_baby_kill_daily{kill_id = 3 ,num = 30000 ,goods = [{7302001,2}] };
get(_) -> [].

ids() -> [1,2,3].
