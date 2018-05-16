%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_hp_pool_goods
	%%% @Created : 2017-11-22 14:10:14
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_hp_pool_goods).
-export([get/1]).
-include("common.hrl").
-include("hp_pool.hrl").
get(1009001) -> 
   #base_hp_pool_goods{goods_id = 1009001 ,hp = 1000000 ,price_type = 1 ,price = 1000};
get(1009002) -> 
   #base_hp_pool_goods{goods_id = 1009002 ,hp = 10000000 ,price_type = 1 ,price = 10000};
get(_) -> [].


