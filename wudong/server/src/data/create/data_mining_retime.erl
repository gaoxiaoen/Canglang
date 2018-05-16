%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_mining_retime
	%%% @Created : 2018-05-14 22:18:13
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_mining_retime).
-export([get/1]).
-export([get_all/0]).
-include("cross_mining.hrl").
-include("common.hrl").
-include("activity.hrl").
get(1) -> {23,59};
get(2) -> {12,00};
get(3) -> {13,00};
get(4) -> {14,00};
get(5) -> {15,00};
get(6) -> {16,00};
get(7) -> {17,00};
get(8) -> {18,00};
get(9) -> {19,00};
get(10) -> {20,00};
get(11) -> {21,00};
get(12) -> {22,00};
get(_) -> [].



    get_all() ->
    [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].
