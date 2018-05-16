%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_1vn_bet_winner_ratio_change
	%%% @Created : 2018-01-10 20:36:48
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_1vn_bet_winner_ratio_change).
-export([get_ratio_change/1]).
-include("common.hrl").
get_ratio_change(Rank) when Rank >= 1 andalso Rank =< 1->{1,0.1,0.2};
get_ratio_change(Rank) when Rank >= 2 andalso Rank =< 2->{2,0.1,0.2};
get_ratio_change(Rank) when Rank >= 3 andalso Rank =< 3->{2,0.1,0.2};
get_ratio_change(Rank) when Rank >= 4 andalso Rank =< 4->{2,0.1,0.2};
get_ratio_change(Rank) when Rank >= 5 andalso Rank =< 5->{2,0.1,0.2};
get_ratio_change(Rank) when Rank >= 6 andalso Rank =< 6->{2,0.1,0.2};
get_ratio_change(_) -> [].
