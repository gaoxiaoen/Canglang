%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_battlefield_combo
	%%% @Created : 2017-11-15 14:28:34
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_battlefield_combo).
-export([get/1]).
-include("common.hrl").
get(Combo) when Combo >= 1 andalso Combo =< 3 ->20;
get(Combo) when Combo >= 4 andalso Combo =< 999 ->10;
get(_) -> [].
