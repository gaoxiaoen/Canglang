%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_pet_acc_special
	%%% @Created : 2018-05-09 14:50:42
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_pet_acc_special).
-export([get/1]).
-include("common.hrl").
get(5) -> [{att,800}];
get(10) -> [{def,800},{hp_lim,8000}];
get(15) -> [{att,2400}];
get(20) -> [{def,1800},{hp_lim,18000}];
get(25) -> [{att,4800}];
get(30) -> [{def,3000},{hp_lim,30000}];
get(35) -> [{att,8000}];
get(_) -> [].
