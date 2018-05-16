%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_market_args
	%%% @Created : 2018-03-08 15:04:04
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_market_args).
-export([get_vip_limit/0]).
-export([get_lv_limit/0]).
-export([max_sell_num/0]).
-include("market.hrl").
-include("common.hrl").

get_vip_limit() -> 3.
get_lv_limit() -> 80.
max_sell_num() -> 10.