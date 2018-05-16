%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_star_luck_cost
	%%% @Created : 2016-06-20 21:00:23
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_star_luck_cost).
-export([get/1]).
-include("star_luck.hrl").
  get(1) -> #base_star_luck_cost{ type=1,pro=7800,cost_bgold=1,cost_gold=0,cost_coin=0,pt=1 };
  get(2) -> #base_star_luck_cost{ type=2,pro=6700,cost_bgold=5,cost_gold=0,cost_coin=0,pt=5 };
  get(3) -> #base_star_luck_cost{ type=3,pro=5000,cost_bgold=25,cost_gold=0,cost_coin=0,pt=15 };
  get(4) -> #base_star_luck_cost{ type=4,pro=1500,cost_bgold=100,cost_gold=0,cost_coin=0,pt=30 };
  get(5) -> #base_star_luck_cost{ type=5,pro=0,cost_bgold=400,cost_gold=0,cost_coin=0,pt=80 };
  get(0) -> #base_star_luck_cost{ type=0,pro=0,cost_bgold=0,cost_gold=500,cost_coin=0,pt=0 };
get(_) -> [].
