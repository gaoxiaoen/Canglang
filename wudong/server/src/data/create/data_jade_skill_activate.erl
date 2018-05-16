%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_jade_skill_activate
	%%% @Created : 2017-11-29 18:03:07
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_jade_skill_activate).
-export([cell_list/0]).
-export([get/1]).
-include("jade.hrl").
-include("common.hrl").

    cell_list() ->
    [1,2,3,4].
get(1) -> 
   #base_jade_skill_activate{cell = 1 ,skill_id = 6201001 ,goods = {6203000,1} ,stage = 1 }
;get(2) -> 
   #base_jade_skill_activate{cell = 2 ,skill_id = 6202001 ,goods = {6203000,1} ,stage = 2 }
;get(3) -> 
   #base_jade_skill_activate{cell = 3 ,skill_id = 6203001 ,goods = {6203000,1} ,stage = 3 }
;get(4) -> 
   #base_jade_skill_activate{cell = 4 ,skill_id = 6204001 ,goods = {6203000,1} ,stage = 4 }
;get(_Data) -> [].