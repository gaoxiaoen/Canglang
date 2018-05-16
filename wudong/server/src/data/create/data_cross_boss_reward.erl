%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_boss_reward
	%%% @Created : 2018-04-23 11:03:37
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_boss_reward).
-export([get_by_rank/1]).
-include("common.hrl").
get_by_rank(Rank) when Rank >= 1 andalso Rank =< 1 ->{[{8001002,2},{1022000,150},{10101,20000}], [{21011,1},{1010005,10}]};
get_by_rank(Rank) when Rank >= 2 andalso Rank =< 2 ->{[{8001002,1},{1022000,120},{10101,20000}], [{21011,1},{1010005,8}]};
get_by_rank(Rank) when Rank >= 3 andalso Rank =< 3 ->{[{8001002,1},{1022000,100},{10101,15000}], [{21011,1},{1010005,5}]};
get_by_rank(Rank) when Rank >= 4 andalso Rank =< 6 ->{[{1022000,80},{10101,10000}], [{1010005,5}]};
get_by_rank(Rank) when Rank >= 7 andalso Rank =< 10 ->{[{1022000,60},{10101,10000}], [{1010005,5}]};
get_by_rank(Rank) when Rank >= 11 andalso Rank =< 20 ->{[{1022000,30},{10101,10000}], [{1010005,5}]};
get_by_rank(_Rank) -> [].
