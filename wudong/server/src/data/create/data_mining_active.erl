%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_mining_active
	%%% @Created : 2018-05-14 22:18:13
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_mining_active).
-export([get/1]).
-include("cross_mining.hrl").
-include("common.hrl").
-include("activity.hrl").
get(Num) when Num >= 0 andalso Num =< 200-> 4;
get(Num) when Num >= 201 andalso Num =< 2000-> 9;
get(Num) when Num >= 2001 andalso Num =< 4000-> 18;
get(Num) when Num >= 4001 andalso Num =< 6000-> 40;
get(Num) when Num >= 6001 andalso Num =< 8000-> 56;
get(Num) when Num >= 8001 andalso Num =< 10000-> 75;
get(Num) when Num >= 10001 andalso Num =< 15000-> 90;
get(Num) when Num >= 15001 andalso Num =< 99999999-> 140;
get(_) -> [].


