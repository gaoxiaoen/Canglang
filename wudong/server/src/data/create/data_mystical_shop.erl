%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_mystical_shop
	%%% @Created : 2017-02-06 17:14:00
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_mystical_shop).
-export([get/1]).
-export([get_probability/2]).
-include("shop.hrl").
get(1)->#base_random_shop{shop_id = 1,pos = 1,min_level = 1,max_level = 600,goods_id = [{0,3101000,5}],diamond = 120,shop_money = 0,probability = 370,is_wash_rule = 0,discount = 0};
get(2)->#base_random_shop{shop_id = 2,pos = 2,min_level = 1,max_level = 600,goods_id = [{0,3201000,5}],diamond = 120,shop_money = 0,probability = 370,is_wash_rule = 0,discount = 0};
get(3)->#base_random_shop{shop_id = 3,pos = 3,min_level = 1,max_level = 600,goods_id = [{0,3301000,5}],diamond = 120,shop_money = 0,probability = 370,is_wash_rule = 0,discount = 0};
get(4)->#base_random_shop{shop_id = 4,pos = 4,min_level = 1,max_level = 600,goods_id = [{0,3401000,5}],diamond = 120,shop_money = 0,probability = 370,is_wash_rule = 0,discount = 0};
get(5)->#base_random_shop{shop_id = 5,pos = 5,min_level = 1,max_level = 600,goods_id = [{0,3103000,5}],diamond = 120,shop_money = 0,probability = 370,is_wash_rule = 0,discount = 0};
get(6)->#base_random_shop{shop_id = 6,pos = 6,min_level = 1,max_level = 600,goods_id = [{0,3103000,5}],diamond = 50,shop_money = 0,probability = 370,is_wash_rule = 0,discount = 0};
get(7)->#base_random_shop{shop_id = 7,pos = 7,min_level = 1,max_level = 600,goods_id = [{0,3203000,5}],diamond = 50,shop_money = 0,probability = 370,is_wash_rule = 0,discount = 0};
get(8)->#base_random_shop{shop_id = 8,pos = 8,min_level = 1,max_level = 600,goods_id = [{0,3303000,5}],diamond = 50,shop_money = 0,probability = 370,is_wash_rule = 0,discount = 0};
get(9)->#base_random_shop{shop_id = 9,pos = 9,min_level = 1,max_level = 600,goods_id = [{0,3403000,5}],diamond = 50,shop_money = 0,probability = 370,is_wash_rule = 0,discount = 0};
get(_) -> throw({false,13}).


get_probability(Level,1) when Level =< 600 andalso Level >= 1 -> [{1,370}];
get_probability(Level,2) when Level =< 600 andalso Level >= 1 -> [{2,370}];
get_probability(Level,3) when Level =< 600 andalso Level >= 1 -> [{3,370}];
get_probability(Level,4) when Level =< 600 andalso Level >= 1 -> [{4,370}];
get_probability(Level,5) when Level =< 600 andalso Level >= 1 -> [{5,370}];
get_probability(Level,6) when Level =< 600 andalso Level >= 1 -> [{6,370}];
get_probability(Level,7) when Level =< 600 andalso Level >= 1 -> [{7,370}];
get_probability(Level,8) when Level =< 600 andalso Level >= 1 -> [{8,370}];
get_probability(Level,9) when Level =< 600 andalso Level >= 1 -> [{9,370}];
get_probability(Level,_Pos_0) when Level =< 600 andalso Level >= 1 -> [];
get_probability(_,_) -> [].