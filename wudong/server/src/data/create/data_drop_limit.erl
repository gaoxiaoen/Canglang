%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_drop_limit
	%%% @Created : 2018-04-23 10:44:29
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_drop_limit).
-export([get/1]).
-export([get_unlimited/1]).
-include("drop.hrl").
-include("common.hrl").
get(Lv) when Lv>= 1 andalso Lv=<55 ->  50;
get(Lv) when Lv>= 56 andalso Lv=<60 ->  50;
get(Lv) when Lv>= 61 andalso Lv=<63 ->  60;
get(Lv) when Lv>= 64 andalso Lv=<66 ->  60;
get(Lv) when Lv>= 67 andalso Lv=<68 ->  60;
get(Lv) when Lv>= 69 andalso Lv=<70 ->  65;
get(Lv) when Lv>= 71 andalso Lv=<71 ->  65;
get(Lv) when Lv>= 72 andalso Lv=<80 ->  65;
get(Lv) when Lv>= 81 andalso Lv=<95 ->  70;
get(Lv) when Lv>= 96 andalso Lv=<107 ->  70;
get(Lv) when Lv>= 108 andalso Lv=<122 ->  70;
get(Lv) when Lv>= 123 andalso Lv=<137 ->  75;
get(Lv) when Lv>= 138 andalso Lv=<152 ->  75;
get(Lv) when Lv>= 153 andalso Lv=<172 ->  75;
get(Lv) when Lv>= 173 andalso Lv=<192 ->  80;
get(Lv) when Lv>= 193 andalso Lv=<222 ->  80;
get(Lv) when Lv>= 223 andalso Lv=<252 ->  80;
get(Lv) when Lv>= 253 andalso Lv=<282 ->  85;
get(Lv) when Lv>= 283 andalso Lv=<312 ->  85;
get(Lv) when Lv>= 313 andalso Lv=<342 ->  85;
get(Lv) when Lv>= 343 andalso Lv=<362 ->  90;
get(_) -> 0. 
get_unlimited(Lv) when Lv>= 1 andalso Lv=<55 ->  [];
get_unlimited(Lv) when Lv>= 56 andalso Lv=<60 ->  [];
get_unlimited(Lv) when Lv>= 61 andalso Lv=<63 ->  [];
get_unlimited(Lv) when Lv>= 64 andalso Lv=<66 ->  [];
get_unlimited(Lv) when Lv>= 67 andalso Lv=<68 ->  [];
get_unlimited(Lv) when Lv>= 69 andalso Lv=<70 ->  [];
get_unlimited(Lv) when Lv>= 71 andalso Lv=<71 ->  [];
get_unlimited(Lv) when Lv>= 72 andalso Lv=<80 ->  [];
get_unlimited(Lv) when Lv>= 81 andalso Lv=<95 ->  [];
get_unlimited(Lv) when Lv>= 96 andalso Lv=<107 ->  [];
get_unlimited(Lv) when Lv>= 108 andalso Lv=<122 ->  [];
get_unlimited(Lv) when Lv>= 123 andalso Lv=<137 ->  [];
get_unlimited(Lv) when Lv>= 138 andalso Lv=<152 ->  [];
get_unlimited(Lv) when Lv>= 153 andalso Lv=<172 ->  [];
get_unlimited(Lv) when Lv>= 173 andalso Lv=<192 ->  [];
get_unlimited(Lv) when Lv>= 193 andalso Lv=<222 ->  [];
get_unlimited(Lv) when Lv>= 223 andalso Lv=<252 ->  [];
get_unlimited(Lv) when Lv>= 253 andalso Lv=<282 ->  [];
get_unlimited(Lv) when Lv>= 283 andalso Lv=<312 ->  [];
get_unlimited(Lv) when Lv>= 313 andalso Lv=<342 ->  [];
get_unlimited(Lv) when Lv>= 343 andalso Lv=<362 ->  [];
get_unlimited(_) -> [].