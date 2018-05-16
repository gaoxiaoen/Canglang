%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_footprint_skill_activate
	%%% @Created : 2017-07-13 10:40:47
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_footprint_skill_activate).
-export([cell_list/0]).
-export([get/1]).
-include("footprint_new.hrl").
-include("common.hrl").

    cell_list() ->
    [1,2,3,4].
get(1) -> 
   #base_footprint_skill_activate{cell = 1 ,skill_id = 5601001 ,goods = {3603000,1} ,stage = 1 }
;get(2) -> 
   #base_footprint_skill_activate{cell = 2 ,skill_id = 5602001 ,goods = {3603000,1} ,stage = 2 }
;get(3) -> 
   #base_footprint_skill_activate{cell = 3 ,skill_id = 5603001 ,goods = {3603000,1} ,stage = 3 }
;get(4) -> 
   #base_footprint_skill_activate{cell = 4 ,skill_id = 5604001 ,goods = {3603000,1} ,stage = 4 }
;get(_Data) -> [].