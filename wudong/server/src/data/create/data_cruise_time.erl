%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cruise_time
	%%% @Created : 2017-09-13 16:44:56
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cruise_time).
-export([get/1]).
-export([get_all/0]).
-include("marry.hrl").
-include("common.hrl").
get(1) -> {10,40};
get(2) -> {11,40};
get(3) -> {12,40};
get(4) -> {13,10};
get(5) -> {15,40};
get(6) -> {17,40};
get(7) -> {19,10};
get(8) -> {19,40};
get(_) -> [].
get_all()->[1,2,3,4,5,6,7,8].

