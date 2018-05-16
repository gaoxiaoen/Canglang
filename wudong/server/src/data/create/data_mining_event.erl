%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_mining_event
	%%% @Created : 2018-05-14 22:18:13
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_mining_event).
-export([get/1]).
-export([get_all/0]).
-include("cross_mining.hrl").
-include("common.hrl").
-include("activity.hrl").
get(1) -> 
   #base_mining_event{type = 1 ,re_time = [{10,30},{11,30},{14,30},{15,30},{16,30},{19,30},{20,30},{21,30}] ,life_time = 600 ,reward = [{[{1024001, 1000}], 30}, {[{1024001, 2000}], 20}, {[{1024001, 3000}], 10}] ,num = {8, 10} ,ratio = [{1,10},{2,20},{3,30}] ,cbp = {100000, 500000} ,daily_limit = 10};
get(2) -> 
   #base_mining_event{type = 2 ,re_time = [{10,30},{11,30},{14,30},{15,30},{16,30},{19,30},{20,30},{21,30}] ,life_time = 600 ,reward = [{[{1024001, 1000}], 30}, {[{1024001, 2000}], 20}, {[{1024001, 3000}], 10}] ,num = {15, 20} ,ratio = [{1,10},{2,20},{3,30}] ,cbp = {100000, 500000} ,daily_limit = 10};
get(_) -> [].



    get_all() ->
    [ 1, 2].
