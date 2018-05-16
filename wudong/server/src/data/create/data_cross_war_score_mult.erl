%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_war_score_mult
	%%% @Created : 2017-09-06 13:51:29
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_war_score_mult).
-export([get/1]).
-include("common.hrl").
get(Score) when Score >= 10 andalso Score <100 ->1.1;
get(Score) when Score >= 101 andalso Score <1000 ->1.15;
get(Score) when Score >= 1001 andalso Score <9999999 ->1.2;
get(_) -> 0.
