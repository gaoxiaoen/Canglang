%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_elite_boss_goods
	%%% @Created : 2018-03-27 11:49:42
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_elite_boss_goods).
-export([get/1]).
get(N) when N >= 1 andalso N =< 4 -> 30;
get(N) when N >= 5 andalso N =< 8 -> 40;
get(N) when N >= 9 andalso N =< 12 -> 50;
get(N) when N >= 13 andalso N =< 16 -> 60;
get(N) when N >= 17 andalso N =< 20 -> 70;
get(N) when N >= 21 andalso N =< 24 -> 80;
get(N) when N >= 25 andalso N =< 28 -> 100;
get(N) when N >= 29 andalso N =< 32 -> 200;
get(N) when N >= 33 andalso N =< 36 -> 300;
get(N) when N >= 37 andalso N =< 40 -> 400;
get(N) when N >= 41 andalso N =< 44 -> 500;
get(N) when N >= 45 andalso N =< 48 -> 1000;
get(N) when N >= 49 andalso N =< 52 -> 2000;
get(N) when N >= 53 andalso N =< 9999999 -> 3000;
get(_N) -> 9999999999999999999.

