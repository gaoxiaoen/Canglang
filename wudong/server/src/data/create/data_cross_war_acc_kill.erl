%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_war_acc_kill
	%%% @Created : 2018-01-30 14:27:16
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_war_acc_kill).
-export([get/1]).
-include("common.hrl").
get(AccKill) when AccKill >= 1 andalso AccKill =< 2 -> 1;
get(AccKill) when AccKill >= 3 andalso AccKill =< 5 -> 5;
get(AccKill) when AccKill >= 6 andalso AccKill =< 8 -> 10;
get(AccKill) when AccKill >= 9 andalso AccKill =< 10 -> 15;
get(AccKill) when AccKill >= 11 andalso AccKill =< 15 -> 20;
get(AccKill) when AccKill >= 16 andalso AccKill =< 999 -> 25;
get(_) -> 0.
