%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_war_score_target
	%%% @Created : 2018-01-30 14:27:16
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_war_score_target).
-export([get/1,get_by_score/1]).
-include("common.hrl").
get(1)->[{10106,10},{8001057,1},{8001002,1}];
get(2)->[{10106,10},{8002401,1},{1007000,1}];
get(3)->[{10106,15},{8001054,1},{8001002,1}];
get(4)->[{10106,15},{8001054,2},{8001057,2}];
get(5)->[{10106,20},{8002402,1},{1007000,1}];
get(6)->[{10106,20},{8001054,3},{8001002,3}];
get(_) -> [].
get_by_score(Score) when Score > 0 andalso Score =< 500 ->1;
get_by_score(Score) when Score > 500 andalso Score =< 1000 ->2;
get_by_score(Score) when Score > 1000 andalso Score =< 1500 ->3;
get_by_score(Score) when Score > 1500 andalso Score =< 2000 ->4;
get_by_score(Score) when Score > 2000 andalso Score =< 3000 ->5;
get_by_score(Score) when Score > 3000 andalso Score =< 5000 ->6;
get_by_score(_) -> 0.
