%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_mining_cd
	%%% @Created : 2018-05-14 22:18:13
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_mining_cd).
-export([get/1]).
-include("cross_mining.hrl").
-include("common.hrl").
-include("activity.hrl").
get(Count) when Count >= 1 andalso Count =< 3-> 10;
get(Count) when Count >= 4 andalso Count =< 10-> 60;
get(Count) when Count >= 11 andalso Count =< 15-> 180;
get(Count) when Count >= 16 andalso Count =< 20-> 300;
get(Count) when Count >= 21 andalso Count =< 30-> 600;
get(Count) when Count >= 31 andalso Count =< ?INF-> 1800;
get(_) -> [].


