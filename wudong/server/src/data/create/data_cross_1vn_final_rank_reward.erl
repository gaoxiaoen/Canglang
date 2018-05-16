%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_1vn_final_rank_reward
	%%% @Created : 2018-01-10 20:36:48
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_1vn_final_rank_reward).
-export([get/2]).
-export([get_daily/2]).
-include("common.hrl").
get(1,Rank) when Rank >= 1 andalso Rank =< 1 ->{{6603108,1},{7415001,50},{8001057,30},{10106,500}};
get(1,Rank) when Rank >= 2 andalso Rank =< 3 ->{{7415001,40},{8001057,20},{10106,300}};
get(1,Rank) when Rank >= 4 andalso Rank =< 5 ->{{7415001,35},{8001057,15},{10106,200}};
get(1,Rank) when Rank >= 6 andalso Rank =< 20 ->{{7415001,20},{8001057,12},{10106,150}};
get(1,Rank) when Rank >= 21 andalso Rank =< 50 ->{{7415001,15},{8001057,10},{10106,100}};
get(1,Rank) when Rank >= 51 andalso Rank =< 100 ->{{7415001,10},{8001057,8},{10106,80}};
get(1,Rank) when Rank >= 101 andalso Rank =< 300 ->{{7415001,5},{8001057,5},{10106,60}};
get(1,Rank) when Rank >= 301 andalso Rank =< 9999 ->{{7415001,2},{8001057,3},{10106,30}};
get(2,Rank) when Rank >= 1 andalso Rank =< 1 ->{{7415001,50},{8001057,30},{10106,500}};
get(2,Rank) when Rank >= 2 andalso Rank =< 3 ->{{7415001,40},{8001057,20},{10106,300}};
get(2,Rank) when Rank >= 4 andalso Rank =< 5 ->{{7415001,35},{8001057,15},{10106,200}};
get(2,Rank) when Rank >= 6 andalso Rank =< 20 ->{{7415001,20},{8001057,12},{10106,150}};
get(2,Rank) when Rank >= 21 andalso Rank =< 50 ->{{7415001,15},{8001057,10},{10106,100}};
get(2,Rank) when Rank >= 51 andalso Rank =< 100 ->{{7415001,10},{8001057,8},{10106,80}};
get(2,Rank) when Rank >= 101 andalso Rank =< 300 ->{{7415001,5},{8001057,5},{10106,60}};
get(2,Rank) when Rank >= 301 andalso Rank =< 9999 ->{{7415001,2},{8001057,3},{10106,30}};
get(_,_) -> [].
get_daily(1,Rank) when Rank >= 1 andalso Rank =< 1 ->{{10106,188},{8001054,10},{2003000,20}};
get_daily(1,Rank) when Rank >= 2 andalso Rank =< 3 ->{{10106,128},{8001054,8},{2003000,15}};
get_daily(1,Rank) when Rank >= 4 andalso Rank =< 5 ->{{10106,88},{8001054,5},{2003000,12}};
get_daily(1,Rank) when Rank >= 6 andalso Rank =< 20 ->{{10106,68},{2003000,10}};
get_daily(1,Rank) when Rank >= 21 andalso Rank =< 50 ->{{10106,58},{2003000,8}};
get_daily(1,Rank) when Rank >= 51 andalso Rank =< 100 ->{{10106,38},{2003000,5}};
get_daily(1,Rank) when Rank >= 101 andalso Rank =< 300 ->{{10106,28},{2003000,3}};
get_daily(1,Rank) when Rank >= 301 andalso Rank =< 9999 ->{{10106,18},{2003000,1}};
get_daily(2,Rank) when Rank >= 1 andalso Rank =< 1 ->{{10106,188},{8001054,10},{2003000,20}};
get_daily(2,Rank) when Rank >= 2 andalso Rank =< 3 ->{{10106,128},{8001054,8},{2003000,15}};
get_daily(2,Rank) when Rank >= 4 andalso Rank =< 5 ->{{10106,88},{8001054,5},{2003000,12}};
get_daily(2,Rank) when Rank >= 6 andalso Rank =< 20 ->{{10106,68},{2003000,10}};
get_daily(2,Rank) when Rank >= 21 andalso Rank =< 50 ->{{10106,58},{2003000,8}};
get_daily(2,Rank) when Rank >= 51 andalso Rank =< 100 ->{{10106,38},{2003000,5}};
get_daily(2,Rank) when Rank >= 101 andalso Rank =< 300 ->{{10106,28},{2003000,3}};
get_daily(2,Rank) when Rank >= 301 andalso Rank =< 9999 ->{{10106,18},{2003000,1}};
get_daily(_,_) -> [].
