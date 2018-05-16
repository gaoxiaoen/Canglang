%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_dungeon_cross_guard
	%%% @Created : 2017-11-22 21:09:23
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_dungeon_cross_guard).
-export([dun_list/0]).
-export([get/1]).
-include("common.hrl").
-include("cross_dungeon_guard.hrl").

    dun_list() ->
    [12015,12016,12017,12018].
get(12015) ->
	#base_dun_cross_guard{scene = 12015 ,reward = [{10106,1},{7405001,1},{7415001,1},{8001002,1}] };
get(12016) ->
	#base_dun_cross_guard{scene = 12016 ,reward = [{10106,1},{7405001,1},{7415001,1},{8001085,1}] };
get(12017) ->
	#base_dun_cross_guard{scene = 12017 ,reward = [{8001652,1},{10106,1},{7405001,1},{7415001,1}] };
get(12018) ->
	#base_dun_cross_guard{scene = 12018 ,reward = [{8001652,1},{10106,1},{7405001,1},{7415001,1}] };
get(_) -> [].