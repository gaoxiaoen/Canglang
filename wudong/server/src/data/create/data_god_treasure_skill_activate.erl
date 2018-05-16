%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_god_treasure_skill_activate
	%%% @Created : 2017-11-29 18:02:55
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_god_treasure_skill_activate).
-export([cell_list/0]).
-export([get/1]).
-include("god_treasure.hrl").
-include("common.hrl").

    cell_list() ->
    [1,2,3,4].
get(1) -> 
   #base_god_treasure_skill_activate{cell = 1 ,skill_id = 6301001 ,goods = {6303000,1} ,stage = 1 }
;get(2) -> 
   #base_god_treasure_skill_activate{cell = 2 ,skill_id = 6302001 ,goods = {6303000,1} ,stage = 2 }
;get(3) -> 
   #base_god_treasure_skill_activate{cell = 3 ,skill_id = 6303001 ,goods = {6303000,1} ,stage = 3 }
;get(4) -> 
   #base_god_treasure_skill_activate{cell = 4 ,skill_id = 6304001 ,goods = {6303000,1} ,stage = 4 }
;get(_Data) -> [].