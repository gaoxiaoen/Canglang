%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_war_guild_score_reward
	%%% @Created : 2018-01-30 14:27:16
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_war_guild_score_reward).
-export([get_by_rank/1]).
-include("common.hrl").

get_by_rank(Rank) when Rank >= 1 andalso Rank =< 1 -> [{8002402,3}];
get_by_rank(Rank) when Rank >= 2 andalso Rank =< 3 -> [{8002402,2}];
get_by_rank(Rank) when Rank >= 4 andalso Rank =< 10 -> [{8002402,1}];
get_by_rank(Rank) when Rank >= 11 andalso Rank =< 50 -> [{8002401,2}];
get_by_rank(_Rank) -> [].
