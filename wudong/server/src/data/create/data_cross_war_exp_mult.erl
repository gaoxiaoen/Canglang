%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_war_exp_mult
	%%% @Created : 2018-01-30 14:27:16
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_war_exp_mult).
-export([get_by_score/1]).
-include("common.hrl").
get_by_score(Score) when Score >= 0 andalso Score <100 ->1.1;
get_by_score(Score) when Score >= 101 andalso Score <1000 ->1.15;
get_by_score(Score) when Score >= 1001 andalso Score <9999999 ->1.2;
get_by_score(_) -> 0.
