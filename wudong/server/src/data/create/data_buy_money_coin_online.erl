%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_buy_money_coin_online
	%%% @Created : 2018-04-19 14:40:17
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_buy_money_coin_online).
-export([get/1]).
-export([get_all/0]).
-export([get_next/1]).
-include("activity.hrl").
get(1) -> 1;
get(31) -> 2;
get(92) -> 3;
get(_) -> [].
get_next(Time) when Time =< 1 -> 1;
get_next(Time) when Time =< 31 -> 31;
get_next(Time) when Time =< 92 -> 92;
get_next(_) -> 0.

    get_all() ->
    [ 1, 31, 92].
