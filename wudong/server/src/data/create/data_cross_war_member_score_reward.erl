%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_war_member_score_reward
	%%% @Created : 2018-01-30 14:27:16
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_war_member_score_reward).
-export([get_by_rank/1]).
-include("common.hrl").

get_by_rank(Rank) when Rank >= 1 andalso Rank =< 1 -> [{2005000,20},{10101,100000}];
get_by_rank(Rank) when Rank >= 2 andalso Rank =< 3 -> [{2005000,15},{10101,80000}];
get_by_rank(Rank) when Rank >= 4 andalso Rank =< 10 -> [{2005000,12},{10101,50000}];
get_by_rank(Rank) when Rank >= 11 andalso Rank =< 50 -> [{2005000,10},{10101,30000}];
get_by_rank(Rank) when Rank >= 51 andalso Rank =< 9999 -> [{2005000,5},{10101,10000}];
get_by_rank(_Rank) -> [].
