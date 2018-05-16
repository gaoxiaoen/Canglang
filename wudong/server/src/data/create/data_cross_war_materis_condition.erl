%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_war_materis_condition
	%%% @Created : 2018-01-30 14:27:16
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_war_materis_condition).
-export([get/1]).
-include("common.hrl").
get(1)->[{kill_player, 30}];
get(2)->[{kill_door, 400}];
get(3)->[{kill_bartizan, 200}];
get(4)->[{kill_sarah, 50}];
get(5)->[{kill_insidedoor, 500}];
get(6)->[{kill_base_mon, 5}];
get(_) -> 0.
