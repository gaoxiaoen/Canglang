%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_pet_acc_normal
	%%% @Created : 2018-05-09 14:50:42
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_pet_acc_normal).
-export([get/1]).
-include("common.hrl").
get(5) -> [{att,600}];
get(10) -> [{def,500},{hp_lim,5000}];
get(15) -> [{att,1600}];
get(20) -> [{def,1000},{hp_lim,10000}];
get(25) -> [{att,2400}];
get(_) -> [].
