%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_wash_transfer_consume
	%%% @Created : 2016-09-13 15:34:41
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_wash_transfer_consume).
-export([get/1]).
-include("error_code.hrl").
get(1)-> 100;
get(6)-> 500;
get(11)-> 1000;
get(21)-> 2000;
get(41)-> 3000;
get(71)-> 4000;
get(_Data) -> throw({false,0}).