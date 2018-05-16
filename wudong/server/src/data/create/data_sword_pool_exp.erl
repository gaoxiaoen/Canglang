%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_sword_pool_exp
	%%% @Created : 2017-06-23 15:51:52
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_sword_pool_exp).
-export([type_list/0]).
-export([get/1]).
-include("common.hrl").
-include("sword_pool.hrl").

    type_list() ->
    [2,3,1,4,5,6,7,8,9].
get(2) -> 
   #base_sword_pool_exp{type = 2 ,exp = 3 ,times = {{16,19,1},{20,39,2},{40,59,3},{60,61,4},{62,62,5},{63,65,6},{66,999,7}} ,buy_times = 33 ,price = 3 ,week = {1,2,3,4,5,6,7}};
get(3) -> 
   #base_sword_pool_exp{type = 3 ,exp = 5 ,times = {{15,39,1},{40,54,2},{55,64,3},{65,74,4},{75,84,5},{85,94,6},{95,104,7},{105,114,8},{115,124,9},{125,134,10},{135,144,11},{145,154,12},{155,164,13},{165,174,14},{175,184,15},{185,194,16},{195,204,17},{205,214,18},{215,224,19},{225,234,20},{235,999,21}} ,buy_times = 0 ,price = 5 ,week = {1,2,3,4,5,6,7}};
get(1) -> 
   #base_sword_pool_exp{type = 1 ,exp = 1 ,times = {{30,999,20}} ,buy_times = 0 ,price = 1 ,week = {1,2,3,4,5,6,7}};
get(4) -> 
   #base_sword_pool_exp{type = 4 ,exp = 1 ,times = {{40,999,20}} ,buy_times = 0 ,price = 1 ,week = {1,2,3,4,5,6,7}};
get(5) -> 
   #base_sword_pool_exp{type = 5 ,exp = 1 ,times = {{42,999,20}} ,buy_times = 0 ,price = 1 ,week = {1,2,3,4,5,6,7}};
get(6) -> 
   #base_sword_pool_exp{type = 6 ,exp = 2 ,times = {{20,999,10}} ,buy_times = 5 ,price = 2 ,week = {1,2,3,4,5,6,7}};
get(7) -> 
   #base_sword_pool_exp{type = 7 ,exp = 5 ,times = {{50,999,20}} ,buy_times = 0 ,price = 5 ,week = {1,2,3,4,5,6,7}};
get(8) -> 
   #base_sword_pool_exp{type = 8 ,exp = 10 ,times = {{45,999,1}} ,buy_times = 0 ,price = 10 ,week = {1,2,3,4,5,6,7}};
get(9) -> 
   #base_sword_pool_exp{type = 9 ,exp = 5 ,times = {{45,999,3}} ,buy_times = 0 ,price = 5 ,week = {1,2,3,4,5,6,7}};
get(_) -> [].


