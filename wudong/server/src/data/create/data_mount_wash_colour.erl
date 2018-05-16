%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_mount_wash_colour
	%%% @Created : 2016-09-13 15:34:41
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_mount_wash_colour).
-export([get/3]).
-include("server.hrl").
get(att,Lv,Value) when Lv >= 1 andalso Lv =< 99 andalso  Value >= 1 andalso Value =< 62-> 1;
get(hp_lim,Lv,Value) when Lv >= 1 andalso Lv =< 99 andalso  Value >= 1 andalso Value =< 937-> 1;
get(def,Lv,Value) when Lv >= 1 andalso Lv =< 99 andalso  Value >= 1 andalso Value =< 62-> 1;
get(att,Lv,Value) when Lv >= 1 andalso Lv =< 99 andalso  Value >= 63 andalso Value =< 125-> 2;
get(hp_lim,Lv,Value) when Lv >= 1 andalso Lv =< 99 andalso  Value >= 938 andalso Value =< 1875-> 2;
get(def,Lv,Value) when Lv >= 1 andalso Lv =< 99 andalso  Value >= 63 andalso Value =< 125-> 2;
get(att,Lv,Value) when Lv >= 1 andalso Lv =< 99 andalso  Value >= 126 andalso Value =< 250-> 3;
get(hp_lim,Lv,Value) when Lv >= 1 andalso Lv =< 99 andalso  Value >= 1876 andalso Value =< 3750-> 3;
get(def,Lv,Value) when Lv >= 1 andalso Lv =< 99 andalso  Value >= 126 andalso Value =< 250-> 3;
get(att,Lv,Value) when Lv >= 1 andalso Lv =< 99 andalso  Value >= 251 andalso Value =< 500-> 4;
get(hp_lim,Lv,Value) when Lv >= 1 andalso Lv =< 99 andalso  Value >= 3751 andalso Value =< 7500-> 4;
get(def,Lv,Value) when Lv >= 1 andalso Lv =< 99 andalso  Value >= 251 andalso Value =< 500-> 4;
get(_,_,_) -> 4.