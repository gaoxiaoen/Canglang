%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_question_rank
	%%% @Created : 2017-12-12 18:12:04
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_question_rank).
-export([get/1]).
-export([get_all/0]).
get(Rank) when Rank >= 1 andalso Rank =< 1 -> {1,1,[{1023000,1000}]};
get(Rank) when Rank >= 2 andalso Rank =< 2 -> {2,2,[{1023000,900}]};
get(Rank) when Rank >= 3 andalso Rank =< 3 -> {3,3,[{1023000,800}]};
get(Rank) when Rank >= 4 andalso Rank =< 10 -> {4,10,[{1023000,700}]};
get(Rank) when Rank >= 11 andalso Rank =< 20 -> {11,20,[{1023000,600}]};
get(Rank) when Rank >= 21 andalso Rank =< 100 -> {21,100,[{1023000,550}]};
get(Rank) when Rank >= 101 andalso Rank =< 10000 -> {101,10000,[{1023000,500}]};
get(_) -> [].
get_all() -> [1,2,3,4,11,21,101].
