%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_war_mon_hurt
	%%% @Created : 2018-01-30 14:27:16
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_war_mon_hurt).
-export([get/1]).
-include("common.hrl").
get(38) -> 50000;
get(39) -> 25000;
get(42) -> 25000;
get(43) -> 25000;
get(_MonKind) -> 0.
