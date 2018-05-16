%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_manor_war_scene
	%%% @Created : 2017-07-24 17:09:43
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_manor_war_scene).
-export([scene_list/0]).
-export([get/1]).
-include("common.hrl").
-include("manor_war.hrl").

    scene_list() ->
    [13003,10002,10003,10004,10006].
get(13003) ->
	#base_manor_war{scene_id = 13003 ,flag_id = 37402 ,flag_x = 34 ,flag_y = 52 ,boss_list = [{64534,23,45}] ,task_id = 800001 };
get(10002) ->
	#base_manor_war{scene_id = 10002 ,flag_id = 37403 ,flag_x = 35 ,flag_y = 65 ,boss_list = [{64534,47,62}] ,task_id = 800002 };
get(10003) ->
	#base_manor_war{scene_id = 10003 ,flag_id = 37404 ,flag_x = 23 ,flag_y = 28 ,boss_list = [{64534,29,38}] ,task_id = 800003 };
get(10004) ->
	#base_manor_war{scene_id = 10004 ,flag_id = 37405 ,flag_x = 67 ,flag_y = 88 ,boss_list = [{64534,54,107}] ,task_id = 800005 };
get(10006) ->
	#base_manor_war{scene_id = 10006 ,flag_id = 37406 ,flag_x = 27 ,flag_y = 40 ,boss_list = [{64534,24,109}] ,task_id = 800006 };
get(_) -> [].