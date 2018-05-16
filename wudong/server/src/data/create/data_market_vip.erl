%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_market_vip
	%%% @Created : 2018-03-08 15:04:04
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_market_vip).
-export([get_buy_sell_by_vip/1]).
-include("market.hrl").
-include("common.hrl").

get_buy_sell_by_vip(0) -> {3, 10};
get_buy_sell_by_vip(1) -> {4, 10};
get_buy_sell_by_vip(2) -> {5, 10};
get_buy_sell_by_vip(3) -> {6, 10};
get_buy_sell_by_vip(4) -> {7, 10};
get_buy_sell_by_vip(5) -> {8, 10};
get_buy_sell_by_vip(6) -> {9, 10};
get_buy_sell_by_vip(7) -> {10, 10};
get_buy_sell_by_vip(8) -> {11, 10};
get_buy_sell_by_vip(9) -> {12, 10};
get_buy_sell_by_vip(10) -> {13, 10};
get_buy_sell_by_vip(11) -> {14, 10};
get_buy_sell_by_vip(12) -> {15, 10};
get_buy_sell_by_vip(13) -> {16, 10};
get_buy_sell_by_vip(14) -> {17, 10};
get_buy_sell_by_vip(15) -> {18, 10};
get_buy_sell_by_vip(_Vip) -> {0, 0}. 
