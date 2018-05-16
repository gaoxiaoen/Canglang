%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_pet_weapon_skill_activate
	%%% @Created : 2017-07-13 10:42:01
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_pet_weapon_skill_activate).
-export([cell_list/0]).
-export([get/1]).
-include("pet_weapon.hrl").
-include("common.hrl").

    cell_list() ->
    [1,2,3,4].
get(1) -> 
   #base_pet_weapon_skill_activate{cell = 1 ,skill_id = 5501001 ,goods = {3503000,1} ,stage = 1 }
;get(2) -> 
   #base_pet_weapon_skill_activate{cell = 2 ,skill_id = 5502001 ,goods = {3503000,1} ,stage = 2 }
;get(3) -> 
   #base_pet_weapon_skill_activate{cell = 3 ,skill_id = 5503001 ,goods = {3503000,1} ,stage = 3 }
;get(4) -> 
   #base_pet_weapon_skill_activate{cell = 4 ,skill_id = 5504001 ,goods = {3503000,1} ,stage = 4 }
;get(_Data) -> [].