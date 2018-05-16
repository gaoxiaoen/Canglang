%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_baby_mount_skill_activate
	%%% @Created : 2017-12-06 17:11:23
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_baby_mount_skill_activate).
-export([cell_list/0]).
-export([get/1]).
-include("baby_mount.hrl").
-include("common.hrl").

    cell_list() ->
    [1,2,3,4].
get(1) -> 
   #base_baby_mount_skill_activate{cell = 1 ,skill_id = 6001001 ,goods = {4003000,1} ,stage = 1 }
;get(2) -> 
   #base_baby_mount_skill_activate{cell = 2 ,skill_id = 6002001 ,goods = {4003000,1} ,stage = 2 }
;get(3) -> 
   #base_baby_mount_skill_activate{cell = 3 ,skill_id = 6003001 ,goods = {4003000,1} ,stage = 3 }
;get(4) -> 
   #base_baby_mount_skill_activate{cell = 4 ,skill_id = 6004001 ,goods = {4003000,1} ,stage = 4 }
;get(_Data) -> [].