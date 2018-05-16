%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_war_score_condition
	%%% @Created : 2018-01-30 14:27:16
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_war_score_condition).
-export([get/1]).
-include("common.hrl").
get(1)->[{kill_player, 24}];
get(2)->[{kill_door, 400}];
get(3)->[{kill_bartizan, 200}];
get(4)->[{kill_sarah, 50}];
get(5)->[{kill_insidedoor, 500}];
get(_) -> 0.
