%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_manor_building
	%%% @Created : 2017-06-12 19:44:23
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_manor_building).
-export([type_list/0]).
-export([get/1]).
-include("common.hrl").
-include("guild_manor.hrl").

    type_list() ->
    [1,2,3,4,5,6].
get(1) ->
	#base_manor_building{type = 1 ,name = ?T("藏金阁"), manor_lv = 1 ,task_refresh_time = 900 ,talent = {1001} };
get(2) ->
	#base_manor_building{type = 2 ,name = ?T("丹房"), manor_lv = 1 ,task_refresh_time = 900 ,talent = {1002} };
get(3) ->
	#base_manor_building{type = 3 ,name = ?T("积香厨"), manor_lv = 1 ,task_refresh_time = 900 ,talent = {1003} };
get(4) ->
	#base_manor_building{type = 4 ,name = ?T("剑阁"), manor_lv = 2 ,task_refresh_time = 900 ,talent = {1004} };
get(5) ->
	#base_manor_building{type = 5 ,name = ?T("炼器堂"), manor_lv = 2 ,task_refresh_time = 900 ,talent = {1005} };
get(6) ->
	#base_manor_building{type = 6 ,name = ?T("灵兽烂"), manor_lv = 2 ,task_refresh_time = 900 ,talent = {1006} };
get(_) -> [].