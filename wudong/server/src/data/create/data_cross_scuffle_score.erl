%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_scuffle_score
	%%% @Created : 2017-09-11 20:24:19
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_scuffle_score).
-export([get/1]).
-include("common.hrl").
get(Combo) when Combo >=-1 andalso Combo =< -1 -> 150; 
get(Combo) when Combo >=0 andalso Combo =< 3 -> 5; 
get(Combo) when Combo >=4 andalso Combo =< 7 -> 10; 
get(Combo) when Combo >=8 andalso Combo =< 999 -> 15; 
get(_) -> 0. 
