%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_elite_daily_reward
	%%% @Created : 2017-09-27 21:23:29
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_elite_daily_reward).
-export([get/1]).
-export([ids/0]).
-include("common.hrl").
-include("cross_elite.hrl").

    ids() ->
    [1,2,3].
get(1) -> 
   #base_cross_elite_daily{id = 1 ,times = 1 ,goods_list = {{1015001,1},{1024000,50}} }; 
get(2) -> 
   #base_cross_elite_daily{id = 2 ,times = 3 ,goods_list = {{1015001,2},{1024000,100}} }; 
get(3) -> 
   #base_cross_elite_daily{id = 3 ,times = 5 ,goods_list = {{1015001,3},{1024000,150}} }; 
get(_) -> []. 
