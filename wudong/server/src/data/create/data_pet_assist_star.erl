%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_pet_assist_star
	%%% @Created : 2018-05-09 14:50:42
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_pet_assist_star).
-export([get/1]).
-include("common.hrl").
get(40) -> [{att,4000}];
get(50) -> [{def,3000},{hp_lim,30000}];
get(55) -> [{att,8000}];
get(60) -> [{def,5000},{hp_lim,50000}];
get(65) -> [{att,12000}];
get(70) -> [{def,8000},{hp_lim,80000}];
get(_) -> [].
