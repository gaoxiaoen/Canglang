%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_element_unlock
	%%% @Created : 2018-03-28 15:41:09
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_element_unlock).
-export([get/1]).
-export([get_all/0]).
-include("element.hrl").
get(1) -> 5;
get(2) -> 2;
get(3) -> 1;
get(4) -> 4;
get(5) -> 7;
get(6) -> 6;
get(_Race) -> [].

get_all()->[5,2,1,4,7,6].

