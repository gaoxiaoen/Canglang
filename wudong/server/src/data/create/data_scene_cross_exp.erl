%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_scene_cross_exp
	%%% @Created : 2016-06-15 16:12:40
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_scene_cross_exp).
-export([get/1]).
-include("common.hrl").
get(Lv) when Lv >= 1 andalso Lv =< 50 ->81;
get(Lv) when Lv >= 51 andalso Lv =< 60 ->105;
get(Lv) when Lv >= 61 andalso Lv =< 70 ->137;
get(Lv) when Lv >= 71 andalso Lv =< 80 ->178;
get(Lv) when Lv >= 81 andalso Lv =< 90 ->232;
get(Lv) when Lv >= 91 andalso Lv =< 100 ->301;
get(Lv) when Lv >= 101 andalso Lv =< 110 ->301;
get(Lv) when Lv >= 111 andalso Lv =< 120 ->301;
get(Lv) when Lv >= 121 andalso Lv =< 130 ->301;
get(Lv) when Lv >= 131 andalso Lv =< 140 ->301;
get(Lv) when Lv >= 141 andalso Lv =< 999 ->301;
get(_) -> 0.
