%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_feixian_map_free
	%%% @Created : 2018-05-03 16:44:06
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_feixian_map_free).
-export([get_free_num/1]).
-export([get_free_time/1]).
-include("xian.hrl").
get_free_num(1) -> 3;
get_free_num(2) -> 1;
get_free_num(_type) -> [].

get_free_time(1) -> 600;
get_free_time(2) -> 86400;
get_free_time(_type) -> [].

