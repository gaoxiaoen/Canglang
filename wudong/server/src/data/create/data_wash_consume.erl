%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_wash_consume
	%%% @Created : 2017-06-21 16:44:14
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_wash_consume).
-export([get/1]).
-include("error_code.hrl").
get(Lv) when Lv>=1 andalso Lv=<999 ->[2001000,1,2002000];
get(_) -> [0,0,0].
