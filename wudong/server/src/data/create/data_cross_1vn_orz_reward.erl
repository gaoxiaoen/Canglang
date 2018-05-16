%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_1vn_orz_reward
	%%% @Created : 2018-01-10 20:36:48
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_1vn_orz_reward).
-export([get/1]).
-include("common.hrl").
get(Lv) when Lv >= 1 andalso Lv =< 100->{{10101,1000}};
get(Lv) when Lv >= 101 andalso Lv =< 200->{{10101,1500}};
get(Lv) when Lv >= 201 andalso Lv =< 999->{{10101,2000}};
get(_) -> [].
