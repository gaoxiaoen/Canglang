%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_dungeon_equip
	%%% @Created : 2017-10-17 11:32:19
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_dungeon_equip).
-export([dun_list/0]).
-export([get/1]).
-include("common.hrl").
-include("dungeon.hrl").
dun_list() ->[42001,42002,42003,42004,42005,42006,42007].
get(42001) ->
	#base_dun_equip{dun_id = 42001 ,pre_id = 0 ,next_id = 42002 ,open_day = 3 ,pass_reward = {{2608003,10}} ,task_id = 1200001 };
get(42002) ->
	#base_dun_equip{dun_id = 42002 ,pre_id = 42001 ,next_id = 42003 ,open_day = 4 ,pass_reward = {{2606003,10}} ,task_id = 1200002 };
get(42003) ->
	#base_dun_equip{dun_id = 42003 ,pre_id = 42002 ,next_id = 42004 ,open_day = 5 ,pass_reward = {{2605003,10}} ,task_id = 1200003 };
get(42004) ->
	#base_dun_equip{dun_id = 42004 ,pre_id = 42003 ,next_id = 42005 ,open_day = 6 ,pass_reward = {{2604003,10}} ,task_id = 1200004 };
get(42005) ->
	#base_dun_equip{dun_id = 42005 ,pre_id = 42004 ,next_id = 42006 ,open_day = 7 ,pass_reward = {{2603003,10}} ,task_id = 1200005 };
get(42006) ->
	#base_dun_equip{dun_id = 42006 ,pre_id = 42005 ,next_id = 42007 ,open_day = 8 ,pass_reward = {{2607003,10}} ,task_id = 1200006 };
get(42007) ->
	#base_dun_equip{dun_id = 42007 ,pre_id = 42006 ,next_id = 0 ,open_day = 9 ,pass_reward = {{2601003,10},{2602003,10}} ,task_id = 1200007 };
get(_) -> [].