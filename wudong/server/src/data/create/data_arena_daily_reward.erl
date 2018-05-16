%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_arena_daily_reward
	%%% @Created : 2017-11-13 15:25:00
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_arena_daily_reward).
-export([get/1]).
-include("common.hrl").
-include("arena.hrl").

    get(Rank) when Rank =<1 andalso Rank >= 1 ->[{1021000,1000}];
    get(Rank) when Rank =<2 andalso Rank >= 2 ->[{1021000,900}];
    get(Rank) when Rank =<3 andalso Rank >= 3 ->[{1021000,800}];
    get(Rank) when Rank =<10 andalso Rank >= 4 ->[{1021000,700}];
    get(Rank) when Rank =<30 andalso Rank >= 11 ->[{1021000,600}];
    get(Rank) when Rank =<50 andalso Rank >= 31 ->[{1021000,550}];
    get(Rank) when Rank =<200 andalso Rank >= 51 ->[{1021000,500}];
    get(Rank) when Rank =<10000 andalso Rank >= 201 ->[{1021000,400}];get(_) -> [].