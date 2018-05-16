%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_mining_help_cost
	%%% @Created : 2018-05-14 22:18:13
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_mining_help_cost).
-export([get/1]).
-include("cross_mining.hrl").
-include("common.hrl").
-include("activity.hrl").
get(Cbp) when Cbp >= 0 andalso Cbp =< 222242-> {800,1};
get(Cbp) when Cbp >= 222243 andalso Cbp =< 787367-> {1600,2};
get(Cbp) when Cbp >= 787368 andalso Cbp =< 1386227-> {1800,3};
get(Cbp) when Cbp >= 1386228 andalso Cbp =< 3200239-> {4000,5};
get(Cbp) when Cbp >= 3200240 andalso Cbp =< 4317353-> {4800,6};
get(Cbp) when Cbp >= 4317354 andalso Cbp =< 7649598-> {5200,7};
get(Cbp) when Cbp >= 7649599 andalso Cbp =< 11666666-> {7000,8};
get(Cbp) when Cbp >= 11666667 andalso Cbp =< 15496569-> {7500,9};
get(Cbp) when Cbp >= 15496570 andalso Cbp =< 16666666-> {8000,10};
get(Cbp) when Cbp >= 16666667 andalso Cbp =< 20000000-> {9000,11};
get(Cbp) when Cbp >= 20000001 andalso Cbp =< 21666666-> {10000,12};
get(Cbp) when Cbp >= 21666667 andalso Cbp =< ?INF-> {12000,14};
get(_) -> [].


