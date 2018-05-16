%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_one_gold_buy_reward
	%%% @Created : 2017-12-27 11:41:22
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_one_gold_buy_reward).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").

%% {lv_min, lv_max, buy_num, goods_id, goods_num} 
get(1) -> {1, 999, 3, 10101, 10000};
get(2) -> {1, 999, 10, 8001002, 3};
get(3) -> {1, 999, 50, 8002404, 1};
get(4) -> {1, 999, 100, 1010005, 3};
get(5) -> {1, 999, 500, 8001054, 5};
get(6) -> {1, 999, 500, 8001054, 5};
get(_ID) -> [].

get_all()->[1,2,3,4,5,6].

