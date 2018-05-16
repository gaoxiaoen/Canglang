%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_random_star_shop
	%%% @Created : 2017-02-06 17:14:00
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_random_star_shop).
-export([get/1]).
-export([get_probability/2]).
-include("shop.hrl").
get(1)->#base_random_shop{shop_id = 1,pos = 1,min_level = 1,max_level = 120,goods_id = [{0,46005,1}],diamond = 0,shop_money = 5000,probability = 10000,is_wash_rule = 0,discount = 0};
get(2)->#base_random_shop{shop_id = 2,pos = 2,min_level = 1,max_level = 120,goods_id = [{0,46010,1}],diamond = 0,shop_money = 5000,probability = 10000,is_wash_rule = 0,discount = 0};
get(3)->#base_random_shop{shop_id = 3,pos = 3,min_level = 1,max_level = 120,goods_id = [{0,46015,1}],diamond = 0,shop_money = 5000,probability = 10000,is_wash_rule = 0,discount = 0};
get(4)->#base_random_shop{shop_id = 4,pos = 4,min_level = 1,max_level = 120,goods_id = [{0,46020,1}],diamond = 0,shop_money = 5000,probability = 10000,is_wash_rule = 0,discount = 0};
get(5)->#base_random_shop{shop_id = 5,pos = 5,min_level = 1,max_level = 120,goods_id = [{0,46025,1}],diamond = 0,shop_money = 5000,probability = 10000,is_wash_rule = 0,discount = 0};
get(6)->#base_random_shop{shop_id = 6,pos = 6,min_level = 1,max_level = 120,goods_id = [{0,46030,1}],diamond = 0,shop_money = 5000,probability = 10000,is_wash_rule = 0,discount = 0};
get(7)->#base_random_shop{shop_id = 7,pos = 7,min_level = 1,max_level = 120,goods_id = [{0,46035,1}],diamond = 0,shop_money = 5000,probability = 10000,is_wash_rule = 0,discount = 0};
get(8)->#base_random_shop{shop_id = 8,pos = 8,min_level = 1,max_level = 120,goods_id = [{0,46040,1}],diamond = 0,shop_money = 5000,probability = 10000,is_wash_rule = 0,discount = 0};
get(_) -> throw({false,13}).


get_probability(Level,1) when Level =< 120 andalso Level >= 1 -> [{1,10000}];
get_probability(Level,2) when Level =< 120 andalso Level >= 1 -> [{2,10000}];
get_probability(Level,3) when Level =< 120 andalso Level >= 1 -> [{3,10000}];
get_probability(Level,4) when Level =< 120 andalso Level >= 1 -> [{4,10000}];
get_probability(Level,5) when Level =< 120 andalso Level >= 1 -> [{5,10000}];
get_probability(Level,6) when Level =< 120 andalso Level >= 1 -> [{6,10000}];
get_probability(Level,7) when Level =< 120 andalso Level >= 1 -> [{7,10000}];
get_probability(Level,8) when Level =< 120 andalso Level >= 1 -> [{8,10000}];
get_probability(Level,_Pos_0) when Level =< 120 andalso Level >= 1 -> [];
get_probability(_,_) -> [].