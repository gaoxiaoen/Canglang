%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_arena_daily_reward
	%%% @Created : 2017-11-13 15:25:12
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_arena_daily_reward).
-export([get/1]).
-include("common.hrl").
-include("cross_arena.hrl").

    get(Rank) when Rank >=1 andalso Rank =< 1 ->[{8001053,20}];

    get(Rank) when Rank >=2 andalso Rank =< 2 ->[{8001053,18}];

    get(Rank) when Rank >=3 andalso Rank =< 3 ->[{8001053,16}];

    get(Rank) when Rank >=4 andalso Rank =< 10 ->[{8001053,14}];

    get(Rank) when Rank >=11 andalso Rank =< 30 ->[{8001053,12}];

    get(Rank) when Rank >=31 andalso Rank =< 50 ->[{8001053,11}];

    get(Rank) when Rank >=51 andalso Rank =< 200 ->[{8001053,10}];

    get(Rank) when Rank >=201 andalso Rank =< 10000 ->[{8001053,8}];
get(_) -> [].