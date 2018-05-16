%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_recharge_rank_reward
	%%% @Created : 2017-08-04 17:21:05
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_recharge_rank_reward).
-export([get_rank/2]).
-export([get_rank_val/3]).
-include("common.hrl").
get_rank(Rank,Val)when Rank =< 1 andalso Val >= 3500  ->1;
get_rank(Rank,Val)when Rank =< 3 andalso Val >= 1500  ->2;
get_rank(Rank,Val)when Rank =< 10 andalso Val >= 800  ->4;
get_rank(Rank,Val)when Rank =< 50 andalso Val >= 100  ->11;
get_rank(Rank,Val)when Rank =< 9999 andalso Val >= 0  ->51;
get_rank(_,_) -> [].
get_rank_val(OpenDay,Rank,Val)when Rank =< 1 andalso Val >= 3500  andalso OpenDay =< 999 ->{{5101406,1},{2003000,30},{8001002,20}};
get_rank_val(OpenDay,Rank,Val)when Rank =< 3 andalso Val >= 1500  andalso OpenDay =< 999 ->{{5101425,1},{2003000,20},{8001002,10}};
get_rank_val(OpenDay,Rank,Val)when Rank =< 10 andalso Val >= 800  andalso OpenDay =< 999 ->{{5101414,1},{2003000,15},{8001002,6}};
get_rank_val(OpenDay,Rank,Val)when Rank =< 50 andalso Val >= 100  andalso OpenDay =< 999 ->{{5101413,1},{2003000,10},{8001002,5}};
get_rank_val(OpenDay,Rank,Val)when Rank =< 9999 andalso Val >= 0  andalso OpenDay =< 999 ->{{5101402,1},{2005000,5}};
get_rank_val(_,_,_) -> [].
