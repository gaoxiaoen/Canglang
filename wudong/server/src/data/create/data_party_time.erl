%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_party_time
	%%% @Created : 2017-09-08 17:27:47
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_party_time).
-export([get/1]).
-export([get_all/0]).
-include("party.hrl").
-include("common.hrl").
get(1) -> {10,30};
get(2) -> {11,30};
get(3) -> {12,30};
get(4) -> {13,0};
get(5) -> {16,30};
get(6) -> {17,30};
get(7) -> {19,0};
get(8) -> {19,30};
get(_) -> [].
get_all()->[1,2,3,4,5,6,7,8].

