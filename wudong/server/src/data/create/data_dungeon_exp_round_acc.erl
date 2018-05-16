%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_dungeon_exp_round_acc
	%%% @Created : 2017-11-08 14:37:35
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_dungeon_exp_round_acc).
-export([get/1]).
-include("common.hrl").
-include("dungeon.hrl").
get(Lv) when Lv>= 1 andalso Lv=<30->5;
get(Lv) when Lv>= 31 andalso Lv=<40->6;
get(Lv) when Lv>= 41 andalso Lv=<45->4;
get(Lv) when Lv>= 46 andalso Lv=<60->5;
get(Lv) when Lv>= 61 andalso Lv=<999->999;
get(_) ->[].
