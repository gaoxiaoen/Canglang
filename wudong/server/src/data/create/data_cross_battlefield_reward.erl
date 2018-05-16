%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_battlefield_reward
	%%% @Created : 2017-11-15 14:28:34
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_battlefield_reward).
-export([get/1]).
-export([get_des/1]).
-include("common.hrl").
get(Rank) when Rank >= 1 andalso Rank =< 1 ->{{1022000,1000},{8001085,5}};
get(Rank) when Rank >= 2 andalso Rank =< 2 ->{{1022000,900},{8001085,5}};
get(Rank) when Rank >= 3 andalso Rank =< 3 ->{{1022000,800},{8001085,4}};
get(Rank) when Rank >= 4 andalso Rank =< 10 ->{{1022000,700},{8001085,4}};
get(Rank) when Rank >= 11 andalso Rank =< 20 ->{{1022000,650},{8001085,3}};
get(Rank) when Rank >= 21 andalso Rank =< 100 ->{{1022000,600},{8001085,3}};
get(Rank) when Rank >= 101 andalso Rank =< 10000 ->{{1022000,500},{8001085,2}};
get(_) -> [].
get_des(Rank) when Rank >= 1 andalso Rank =< 1 ->10018;
get_des(Rank) when Rank >= 2 andalso Rank =< 2 ->0;
get_des(Rank) when Rank >= 3 andalso Rank =< 3 ->0;
get_des(Rank) when Rank >= 4 andalso Rank =< 10 ->0;
get_des(Rank) when Rank >= 11 andalso Rank =< 20 ->0;
get_des(Rank) when Rank >= 21 andalso Rank =< 100 ->0;
get_des(Rank) when Rank >= 101 andalso Rank =< 10000 ->0;
get_des(_) -> 0.
