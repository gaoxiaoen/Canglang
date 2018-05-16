%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_battlefield_shop
	%%% @Created : 2017-02-06 17:14:00
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_battlefield_shop).
-export([get/1]).
-export([get_probability/2]).
-include("shop.hrl").
get(1)->#base_random_shop{shop_id = 1,pos = 1,min_level = 1,max_level = 120,goods_id = [{0,10108,500000}],diamond = 0,shop_money = 200,probability = 10000,is_wash_rule = 0,discount = 0};
get(2)->#base_random_shop{shop_id = 2,pos = 2,min_level = 1,max_level = 120,goods_id = [{0,21203,5}],diamond = 0,shop_money = 500,probability = 10000,is_wash_rule = 0,discount = 0};
get(3)->#base_random_shop{shop_id = 3,pos = 3,min_level = 1,max_level = 120,goods_id = [{0,20254,3}],diamond = 0,shop_money = 600,probability = 10000,is_wash_rule = 0,discount = 0};
get(4)->#base_random_shop{shop_id = 4,pos = 4,min_level = 1,max_level = 120,goods_id = [{0,20255,3}],diamond = 0,shop_money = 800,probability = 10000,is_wash_rule = 0,discount = 0};
get(5)->#base_random_shop{shop_id = 5,pos = 5,min_level = 1,max_level = 120,goods_id = [{0,24519,1}],diamond = 0,shop_money = 1500,probability = 10000,is_wash_rule = 0,discount = 0};
get(6)->#base_random_shop{shop_id = 6,pos = 6,min_level = 1,max_level = 120,goods_id = [{0,20113,1}],diamond = 0,shop_money = 2500,probability = 10000,is_wash_rule = 0,discount = 0};
get(_) -> throw({false,13}).


get_probability(Level,1) when Level =< 120 andalso Level >= 1 -> [{1,10000}];
get_probability(Level,2) when Level =< 120 andalso Level >= 1 -> [{2,10000}];
get_probability(Level,3) when Level =< 120 andalso Level >= 1 -> [{3,10000}];
get_probability(Level,4) when Level =< 120 andalso Level >= 1 -> [{4,10000}];
get_probability(Level,5) when Level =< 120 andalso Level >= 1 -> [{5,10000}];
get_probability(Level,6) when Level =< 120 andalso Level >= 1 -> [{6,10000}];
get_probability(Level,_Pos_0) when Level =< 120 andalso Level >= 1 -> [];
get_probability(_,_) -> [].