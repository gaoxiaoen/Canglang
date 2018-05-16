%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_light_weapon_skill_activate
	%%% @Created : 2018-04-28 12:18:24
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_light_weapon_skill_activate).
-export([cell_list/0]).
-export([get/1]).
-include("light_weapon.hrl").
-include("common.hrl").

    cell_list() ->
    [1,2,3,4].
get(1) -> 
   #base_light_weapon_skill_activate{cell = 1 ,skill_id = 5401001 ,goods = {3403000,1} ,stage = 1 }
;get(2) -> 
   #base_light_weapon_skill_activate{cell = 2 ,skill_id = 5402001 ,goods = {3403000,1} ,stage = 2 }
;get(3) -> 
   #base_light_weapon_skill_activate{cell = 3 ,skill_id = 5403001 ,goods = {3403000,1} ,stage = 3 }
;get(4) -> 
   #base_light_weapon_skill_activate{cell = 4 ,skill_id = 5404001 ,goods = {3403000,1} ,stage = 4 }
;get(_Data) -> [].