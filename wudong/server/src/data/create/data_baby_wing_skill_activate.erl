%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_baby_wing_skill_activate
	%%% @Created : 2017-11-01 18:03:44
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_baby_wing_skill_activate).
-export([cell_list/0]).
-export([get/1]).
-include("baby_wing.hrl").
-include("common.hrl").

    cell_list() ->
    [1,2,3,4].
get(1) -> 
   #base_baby_wing_skill_activate{cell = 1 ,skill_id = 5901001 ,goods = {3903000,1} ,stage = 1 }
;get(2) -> 
   #base_baby_wing_skill_activate{cell = 2 ,skill_id = 5902001 ,goods = {3903000,1} ,stage = 2 }
;get(3) -> 
   #base_baby_wing_skill_activate{cell = 3 ,skill_id = 5903001 ,goods = {3903000,1} ,stage = 3 }
;get(4) -> 
   #base_baby_wing_skill_activate{cell = 4 ,skill_id = 5904001 ,goods = {3903000,1} ,stage = 4 }
;get(_Data) -> [].