%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_festival_back_buy_time
	%%% @Created : 2018-05-14 21:34:16
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_festival_back_buy_time).
-export([get/1]).
-include("activity.hrl").
get(Days) when Days >= 1 andalso Days =< 7 ->[1,2,3,4,5,6,7];
get(Days) when Days >= 8 andalso Days =< 14 ->[8,9,10,11,12,13,14];
get(Days) when Days >= 15 andalso Days =< 999 ->[15,16,17,18,19,20,21];
get(_Days) -> [].

