%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_elite_rank_reward
	%%% @Created : 2017-09-27 21:23:29
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_elite_rank_reward).
-export([get/1]).
-export([get_des/1]).
-include("common.hrl").
get(Rank)when Rank>= 1 andalso Rank =< 1->{{8001054,10},{8001057,10}};
get(Rank)when Rank>= 2 andalso Rank =< 2->{{8001054,9},{8001057,9}};
get(Rank)when Rank>= 3 andalso Rank =< 3->{{8001054,8},{8001057,8}};
get(Rank)when Rank>= 4 andalso Rank =< 10->{{8001054,7},{8001057,7}};
get(Rank)when Rank>= 11 andalso Rank =< 20->{{8001054,6},{8001057,6}};
get(Rank)when Rank>= 21 andalso Rank =< 50->{{8001054,5},{8001057,5}};
get(Rank)when Rank>= 51 andalso Rank =< 200->{{8001054,4},{8001057,4}};
get(Rank)when Rank>= 201 andalso Rank =< 10000->{{8001054,3},{8001057,3}};
get(_) -> [].
get_des(Rank) when Rank >=1 andalso Rank =< 1->10006;
get_des(Rank) when Rank >=2 andalso Rank =< 2->0;
get_des(Rank) when Rank >=3 andalso Rank =< 3->0;
get_des(Rank) when Rank >=4 andalso Rank =< 10->0;
get_des(Rank) when Rank >=11 andalso Rank =< 20->0;
get_des(Rank) when Rank >=21 andalso Rank =< 50->0;
get_des(Rank) when Rank >=51 andalso Rank =< 200->0;
get_des(Rank) when Rank >=201 andalso Rank =< 10000->0;
get_des(_) -> [].
