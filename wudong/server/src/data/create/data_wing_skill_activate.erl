%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_wing_skill_activate
	%%% @Created : 2018-02-28 11:24:56
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_wing_skill_activate).
-export([cell_list/0]).
-export([get/1]).
-include("wing.hrl").
-include("common.hrl").

    cell_list() ->
    [1,2,3,4].
get(1) -> 
   #base_wing_skill_activate{cell = 1 ,skill_id = 5201001 ,goods = {3203000,1} ,stage = 1 }
;get(2) -> 
   #base_wing_skill_activate{cell = 2 ,skill_id = 5202001 ,goods = {3203000,1} ,stage = 2 }
;get(3) -> 
   #base_wing_skill_activate{cell = 3 ,skill_id = 5203001 ,goods = {3203000,1} ,stage = 3 }
;get(4) -> 
   #base_wing_skill_activate{cell = 4 ,skill_id = 5204001 ,goods = {3203000,1} ,stage = 4 }
;get(_Data) -> [].