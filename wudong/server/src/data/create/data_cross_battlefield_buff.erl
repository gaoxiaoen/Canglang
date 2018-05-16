%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_battlefield_buff
	%%% @Created : 2017-11-15 14:28:34
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_battlefield_buff).
-export([buff_list/0]).
-export([get/1]).
-include("common.hrl").

    buff_list() ->
    [56421,56422,56423,56424,56425,56426,56427,56428,56429,56430].
get(Count) when Count >= 1 andalso Count =< 3 ->56421;
get(Count) when Count >= 4 andalso Count =< 6 ->56422;
get(Count) when Count >= 7 andalso Count =< 9 ->56423;
get(Count) when Count >= 10 andalso Count =< 12 ->56424;
get(Count) when Count >= 13 andalso Count =< 15 ->56425;
get(Count) when Count >= 15 andalso Count =< 18 ->56426;
get(Count) when Count >= 18 andalso Count =< 20 ->56427;
get(Count) when Count >= 21 andalso Count =< 23 ->56428;
get(Count) when Count >= 24 andalso Count =< 26 ->56429;
get(Count) when Count >= 27 andalso Count =< 999 ->56430;
get(_) -> [].
