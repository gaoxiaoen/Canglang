%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_pet_assist_acc
	%%% @Created : 2018-05-09 14:50:42
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_pet_assist_acc).
-export([get/1]).
-include("common.hrl").
get(3) -> [{att,1200}];
get(4) -> [{def,1000},{hp_lim,10000}];
get(5) -> [{att,3200}];
get(6) -> [{def,2000},{hp_lim,20000}];
get(7) -> [{att,4800}];
get(_) -> [].
