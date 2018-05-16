%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_six_dragon_rank_reward
	%%% @Created : 2017-12-27 15:50:09
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_six_dragon_rank_reward).
-export([get/1]).
-export([get_all/0]).
-include("cross_six_dragon.hrl").
get(Rank) when Rank >= 1 andalso Rank =< 1 -> {1,1,[{1022000,6000},{8001054,6},{8001002,10}]};
get(Rank) when Rank >= 2 andalso Rank =< 2 -> {2,2,[{1022000,5000},{8001054,5},{8001002,8}]};
get(Rank) when Rank >= 3 andalso Rank =< 3 -> {3,3,[{1022000,4500},{8001054,4},{8001002,7}]};
get(Rank) when Rank >= 4 andalso Rank =< 10 -> {4,10,[{1022000,4000},{8001054,4},{8001002,6}]};
get(Rank) when Rank >= 11 andalso Rank =< 20 -> {11,20,[{1022000,3500},{8001054,3},{8001002,5}]};
get(Rank) when Rank >= 21 andalso Rank =< 50 -> {21,50,[{1022000,3000},{8001054,3},{8001002,4}]};
get(Rank) when Rank >= 51 andalso Rank =< 100 -> {51,100,[{1022000,3000},{8001054,2},{8001002,3}]};
get(Rank) when Rank >= 101 andalso Rank =< 10000 -> {101,10000,[{1022000,2500},{8001054,2},{8001002,2}]};
get(_) -> [].
get_all() -> [1,2,3,4,11,21,51,101].
