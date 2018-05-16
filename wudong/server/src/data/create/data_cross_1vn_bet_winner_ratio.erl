%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_1vn_bet_winner_ratio
	%%% @Created : 2018-01-10 20:36:48
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_1vn_bet_winner_ratio).
-export([get/1]).
-include("common.hrl").
get(Rank) when Rank >= 1 andalso Rank =< 1->2;
get(Rank) when Rank >= 2 andalso Rank =< 3->3;
get(Rank) when Rank >= 4 andalso Rank =< 6->4;
get(_) -> [].
