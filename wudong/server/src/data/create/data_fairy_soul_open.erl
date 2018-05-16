%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_fairy_soul_open
	%%% @Created : 2017-11-14 14:18:52
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_fairy_soul_open).
-export([get/1]).
-export([get_all/0]).
-include("fairy_soul.hrl").
get(90) -> 1;
get(95) -> 2;
get(100) -> 3;
get(105) -> 4;
get(110) -> 5;
get(115) -> 6;
get(120) -> 7;
get(125) -> 8;
get(_) -> [].

    get_all() ->
    [90,95,100,105,110,115,120,125].
