%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_gods_weapon_wash_cost
	%%% @Created : 2018-05-14 16:35:42
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_gods_weapon_wash_cost).
-export([get/1]).
-include("god_weapon.hrl").
-include("common.hrl").
-include("activity.hrl").
get(1) ->{20000, 1};
get(2) ->{40000, 2};
get(3) ->{60000, 3};
get(4) ->{80000, 4};
get(5) ->{100000, 5};
get(6) ->{120000, 6};
get(7) ->{140000, 7};
get(_) -> [].


