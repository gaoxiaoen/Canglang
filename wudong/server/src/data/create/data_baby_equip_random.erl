%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_baby_equip_random
	%%% @Created : 2017-09-04 21:32:45
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_baby_equip_random).
-export([get/1]).
-export([id_range/1]).
-include("common.hrl").
-include("baby.hrl").
get(Lv) when Lv >= 0 andalso Lv =< 1 -> {1,[{1,3500},{2,3000},{3,2000},{4,1000},{5,0}]};
get(Lv) when Lv >= 1 andalso Lv =< 999 -> {2,[{1,3500},{2,3000},{3,2000},{4,1000},{5,0}]};
get(Lv) when Lv >= 1000 andalso Lv =< 9999 -> {3,[{1,0},{2,0},{3,0},{4,0},{5,1}]};
get(_) -> {0,[]}.

id_range(1) -> {0,1};
id_range(2) -> {1,999};
id_range(3) -> {1000,9999};
id_range(_) -> {0,0}.