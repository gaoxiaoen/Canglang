%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_strength_lucky_stone
	%%% @Created : 2016-01-26 14:27:31
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_strength_lucky_stone).
-export([get/1]).
-include("error_code.hrl").
get(20100) -> 10;
get(20101) -> 25;
get(20102) -> 40;
get(20103) -> 60;
get(20104) -> 90;
get(_Data) -> throw({false,0}).