%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_mount_skill_activate
	%%% @Created : 2018-04-28 12:18:25
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_mount_skill_activate).
-export([cell_list/0]).
-export([get/1]).
-include("mount.hrl").
-include("common.hrl").

    cell_list() ->
    [1,2,3,4].
get(1) -> 
   #base_mount_skill_activate{cell = 1 ,skill_id = 5101001 ,goods = {3103000,1} ,stage = 1 }
;get(2) -> 
   #base_mount_skill_activate{cell = 2 ,skill_id = 5102001 ,goods = {3103000,1} ,stage = 2 }
;get(3) -> 
   #base_mount_skill_activate{cell = 3 ,skill_id = 5103001 ,goods = {3103000,1} ,stage = 3 }
;get(4) -> 
   #base_mount_skill_activate{cell = 4 ,skill_id = 5104001 ,goods = {3103000,1} ,stage = 4 }
;get(_Data) -> [].