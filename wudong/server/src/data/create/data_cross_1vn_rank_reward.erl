%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_1vn_rank_reward
	%%% @Created : 2018-01-10 20:36:48
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_1vn_rank_reward).
-export([get/2]).
-include("common.hrl").
get(1,Rank) when Rank >= 1 andalso Rank =< 1 ->{{8002405,1},{2003000,10}};
get(1,Rank) when Rank >= 2 andalso Rank =< 10 ->{{8002404,1},{2003000,8}};
get(1,Rank) when Rank >= 11 andalso Rank =< 50 ->{{8002403,1},{2003000,6}};
get(1,Rank) when Rank >= 51 andalso Rank =< 200 ->{{8002402,1},{2003000,4}};
get(1,Rank) when Rank >= 201 andalso Rank =< 9999 ->{{8002402,1},{2003000,2}};
get(2,Rank) when Rank >= 1 andalso Rank =< 1 ->{{8002405,1},{2003000,10}};
get(2,Rank) when Rank >= 2 andalso Rank =< 10 ->{{8002404,1},{2003000,8}};
get(2,Rank) when Rank >= 11 andalso Rank =< 50 ->{{8002403,1},{2003000,6}};
get(2,Rank) when Rank >= 51 andalso Rank =< 200 ->{{8002402,1},{2003000,4}};
get(2,Rank) when Rank >= 201 andalso Rank =< 9999 ->{{8002402,1},{2003000,2}};
get(_,_) -> [].
