%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_dark_buff
	%%% @Created : 2017-11-23 18:26:41
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_dark_buff).
-export([get/1]).
-export([get_id/1]).
-include("common.hrl").
get(Value) when Value >= 500 andalso Value =< 999 ->[56902,56907];
get(Value) when Value >= 1000 andalso Value =< 4999 ->[56903,56908];
get(Value) when Value >= 5000 andalso Value =< 19999 ->[56904,56909];
get(Value) when Value >= 20000 andalso Value =< 39999 ->[56905,56910];
get(Value) when Value >= 40000 andalso Value =< 9999999 ->[56906,56911];
get(_) -> [].
get_id(Value) when Value >= 500 andalso Value =< 999 ->1;
get_id(Value) when Value >= 1000 andalso Value =< 4999 ->2;
get_id(Value) when Value >= 5000 andalso Value =< 19999 ->3;
get_id(Value) when Value >= 20000 andalso Value =< 39999 ->4;
get_id(Value) when Value >= 40000 andalso Value =< 9999999 ->5;
get_id(_) -> 0.
