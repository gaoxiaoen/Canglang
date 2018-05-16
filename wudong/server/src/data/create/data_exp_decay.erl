%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_exp_decay
	%%% @Created : 2017-04-26 16:02:06
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_exp_decay).
-export([get/1]).
-include("common.hrl").
get(Lv) when Lv>= 0 andalso Lv=< 5 -> 1; 
get(Lv) when Lv>= 6 andalso Lv=< 10 -> 1; 
get(Lv) when Lv>= 11 andalso Lv=< 15 -> 1; 
get(Lv) when Lv>= 16 andalso Lv=< 20 -> 1; 
get(Lv) when Lv>= 21 andalso Lv=< 999 -> 1; 
get(_) -> 0. 
