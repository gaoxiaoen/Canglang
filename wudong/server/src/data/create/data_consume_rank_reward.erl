%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_consume_rank_reward
	%%% @Created : 2017-08-04 17:21:05
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_consume_rank_reward).
-export([get_rank/2]).
-export([get_rank_val/3]).
-include("common.hrl").
get_rank(Rank,Val)when Rank =< 1 andalso Val >= 1000  ->1;
get_rank(Rank,Val)when Rank =< 3 andalso Val >= 500  ->2;
get_rank(Rank,Val)when Rank =< 10 andalso Val >= 100  ->4;
get_rank(Rank,Val)when Rank =< 50 andalso Val >= 10  ->11;
get_rank(Rank,Val)when Rank =< 9999 andalso Val >= 0  ->51;
get_rank(_,_) -> [].
get_rank_val(OpenDay,Rank,Val)when Rank =< 1 andalso Val >= 1000 andalso OpenDay =< 999 ->{{11601,1},{2003000,30},{8001002,20}};
get_rank_val(OpenDay,Rank,Val)when Rank =< 3 andalso Val >= 500 andalso OpenDay =< 999 ->{{8001054,8},{2003000,20},{8001002,10}};
get_rank_val(OpenDay,Rank,Val)when Rank =< 10 andalso Val >= 100 andalso OpenDay =< 999 ->{{8001054,4},{2003000,10},{8001002,6}};
get_rank_val(OpenDay,Rank,Val)when Rank =< 50 andalso Val >= 10 andalso OpenDay =< 999 ->{{8001054,2},{2003000,6},{8001002,5}};
get_rank_val(OpenDay,Rank,Val)when Rank =< 9999 andalso Val >= 0 andalso OpenDay =< 999 ->{{2003000,10},{2005000,10}};
get_rank_val(_,_,_) -> [].
