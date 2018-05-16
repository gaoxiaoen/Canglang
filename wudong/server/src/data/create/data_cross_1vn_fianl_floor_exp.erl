
%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_1vn_fianl_floor_exp
	%%% @Created : 2018-01-10 20:36:48
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_1vn_fianl_floor_exp).
-export([get/1]).
-export([get_all/0]).
-include("common.hrl").
get(1) -> 20;
get(2) -> 40;
get(3) -> 60;
get(4) -> 80;
get(5) -> 100;
get(6) -> 120;
get(_) -> [].

get_all()->[1,2,3,4,5,6].