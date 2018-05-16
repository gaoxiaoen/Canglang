%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_dun_jiandao_score
	%%% @Created : 2018-03-28 15:41:09
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_dun_jiandao_score).
-export([get/2]).
-export([get_all/0]).
-include("dungeon.hrl").
get(61101, Score) when Score >= 1 andalso Score =< 30 -> [{40001,1},{40002,1}];
get(61101, Score) when Score >= 31 andalso Score =< 70 -> [{40001,2},{40002,2}];
get(61101, Score) when Score >= 71 andalso Score =< 100 -> [{40001,3},{40002,3}];
get(61102, Score) when Score >= 1 andalso Score =< 300 -> [{40001,2},{8301109,1}];
get(61102, Score) when Score >= 301 andalso Score =< 700 -> [{40001,4},{8301109,1}];
get(61102, Score) when Score >= 701 andalso Score =< 1000 -> [{40001,6},{8301109,1}];
get(61103, Score) when Score >= 1 andalso Score =< 900 -> [{40001,3},{8301105,1}];
get(61103, Score) when Score >= 901 andalso Score =< 2100 -> [{40001,5},{8301105,1}];
get(61103, Score) when Score >= 2101 andalso Score =< 2700 -> [{40001,7},{8301105,1}];
get(_dun_id, _score) -> [].

get_all()->[61101,61101,61101,61102,61102,61102,61103,61103,61103].

