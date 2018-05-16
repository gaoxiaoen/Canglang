%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_mineral_att
	%%% @Created : 2018-05-14 22:18:13
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_mineral_att).
-export([get/1]).
-include("cross_mining.hrl").
-include("common.hrl").
-include("activity.hrl").
get(Cbp) when Cbp >= 0 andalso Cbp =< 40000-> 1;
get(Cbp) when Cbp >= 40001 andalso Cbp =< 65000-> 1.2;
get(Cbp) when Cbp >= 65001 andalso Cbp =< 80000-> 1.25;
get(Cbp) when Cbp >= 80001 andalso Cbp =< 100000-> 1.3;
get(Cbp) when Cbp >= 100001 andalso Cbp =< 200000-> 1.5;
get(Cbp) when Cbp >= 200001 andalso Cbp =< 300000-> 1.52;
get(Cbp) when Cbp >= 300001 andalso Cbp =< 500000-> 1.58;
get(Cbp) when Cbp >= 500001 andalso Cbp =< 666000-> 1.6;
get(Cbp) when Cbp >= 666001 andalso Cbp =< 800000-> 1.65;
get(Cbp) when Cbp >= 800001 andalso Cbp =< 1800000-> 1.8;
get(Cbp) when Cbp >= 1800001 andalso Cbp =< 3000000-> 1.82;
get(Cbp) when Cbp >= 3000001 andalso Cbp =< 3500000-> 1.85;
get(Cbp) when Cbp >= 3500001 andalso Cbp =< 4500000-> 1.9;
get(Cbp) when Cbp >= 4500001 andalso Cbp =< 6000000-> 2;
get(Cbp) when Cbp >= 6000001 andalso Cbp =< ?INF-> 3;
get(_) -> [].


