%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_fairy_soul_open_cost
	%%% @Created : 2017-11-14 15:04:41
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_fairy_soul_open_cost).
-export([get/1]).
-include("fairy_soul.hrl").
get(Count) when Count >=1 andalso Count =< 10-> 100;
get(Count) when Count >=11 andalso Count =< 15-> 200;
get(Count) when Count >=16 andalso Count =< 20-> 250;
get(Count) when Count >=21 andalso Count =< 25-> 300;
get(Count) when Count >=26 andalso Count =< 30-> 350;
get(Count) when Count >=31 andalso Count =< 999-> 500;
get(_) -> [].
