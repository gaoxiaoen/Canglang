%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_mineral_hp
	%%% @Created : 2018-05-14 22:18:13
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_mineral_hp).
-export([get/1]).
-include("cross_mining.hrl").
-include("common.hrl").
-include("activity.hrl").
get(Cbp) when Cbp >= 0 andalso Cbp =< 666727-> 1;
get(Cbp) when Cbp >= 666728 andalso Cbp =< 2362101-> 1.1;
get(Cbp) when Cbp >= 2362102 andalso Cbp =< 4158683-> 1.2;
get(Cbp) when Cbp >= 4158684 andalso Cbp =< 9600717-> 1.5;
get(Cbp) when Cbp >= 9600718 andalso Cbp =< 12952061-> 1.7;
get(Cbp) when Cbp >= 12952062 andalso Cbp =< 22948794-> 1.8;
get(Cbp) when Cbp >= 22948795 andalso Cbp =< 35000000-> 1.9;
get(Cbp) when Cbp >= 35000001 andalso Cbp =< 46489709-> 2;
get(Cbp) when Cbp >= 46489709 andalso Cbp =< 50000000-> 2.1;
get(Cbp) when Cbp >= 50000000 andalso Cbp =< 60000000-> 2.3;
get(Cbp) when Cbp >= 60000001 andalso Cbp =< 65000000-> 2.4;
get(Cbp) when Cbp >= 65000001 andalso Cbp =< ?INF-> 2.5;
get(_) -> [].


