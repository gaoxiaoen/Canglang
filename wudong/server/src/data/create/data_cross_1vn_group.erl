%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_1vn_group
	%%% @Created : 2018-01-10 20:36:48
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_1vn_group).
-export([get/1]).
-include("common.hrl").
get(Lv) when Lv >= 80 andalso Lv =< 119 ->1;
get(Lv) when Lv >= 120 andalso Lv =< 999 ->2;
get(_) -> [].
