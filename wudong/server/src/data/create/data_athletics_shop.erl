%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_athletics_shop
	%%% @Created : 2017-02-06 17:14:00
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_athletics_shop).
-export([get/1]).
-export([get_probability/2]).
-include("shop.hrl").
get(1)->#base_random_shop{shop_id = 1,pos = 1,min_level = 1,max_level = 120,goods_id = [{1,20180,1},{2,20181,1},{3,20182,1},{4,20183,1}],diamond = 0,shop_money = 500,probability = 10000,is_wash_rule = 0,discount = 0};
get(2)->#base_random_shop{shop_id = 2,pos = 2,min_level = 1,max_level = 120,goods_id = [{1,20184,1},{2,20185,1},{3,20186,1},{4,20187,1}],diamond = 0,shop_money = 800,probability = 10000,is_wash_rule = 0,discount = 0};
get(3)->#base_random_shop{shop_id = 3,pos = 3,min_level = 1,max_level = 120,goods_id = [{1,20196,1},{2,20197,1},{3,20198,1},{4,20199,1}],diamond = 0,shop_money = 1500,probability = 10000,is_wash_rule = 0,discount = 0};
get(4)->#base_random_shop{shop_id = 4,pos = 0,min_level = 1,max_level = 120,goods_id = [{0,20120,1}],diamond = 0,shop_money = 140,probability = 1250,is_wash_rule = 0,discount = 0};
get(5)->#base_random_shop{shop_id = 5,pos = 0,min_level = 1,max_level = 120,goods_id = [{0,20130,1}],diamond = 0,shop_money = 140,probability = 1250,is_wash_rule = 0,discount = 0};
get(6)->#base_random_shop{shop_id = 6,pos = 0,min_level = 1,max_level = 120,goods_id = [{0,20140,1}],diamond = 0,shop_money = 140,probability = 1250,is_wash_rule = 0,discount = 0};
get(7)->#base_random_shop{shop_id = 7,pos = 0,min_level = 1,max_level = 120,goods_id = [{0,20121,1}],diamond = 0,shop_money = 400,probability = 1250,is_wash_rule = 0,discount = 0};
get(8)->#base_random_shop{shop_id = 8,pos = 0,min_level = 1,max_level = 120,goods_id = [{0,20131,1}],diamond = 0,shop_money = 400,probability = 1250,is_wash_rule = 0,discount = 0};
get(9)->#base_random_shop{shop_id = 9,pos = 0,min_level = 1,max_level = 120,goods_id = [{0,20141,1}],diamond = 0,shop_money = 400,probability = 1250,is_wash_rule = 0,discount = 0};
get(10)->#base_random_shop{shop_id = 10,pos = 0,min_level = 1,max_level = 120,goods_id = [{0,20123,1}],diamond = 0,shop_money = 3600,probability = 833,is_wash_rule = 0,discount = 0};
get(11)->#base_random_shop{shop_id = 11,pos = 0,min_level = 1,max_level = 120,goods_id = [{0,20133,1}],diamond = 0,shop_money = 3600,probability = 833,is_wash_rule = 0,discount = 0};
get(12)->#base_random_shop{shop_id = 12,pos = 0,min_level = 1,max_level = 120,goods_id = [{0,20143,1}],diamond = 0,shop_money = 3600,probability = 834,is_wash_rule = 0,discount = 0};
get(_) -> throw({false,13}).


get_probability(Level,1) when Level =< 120 andalso Level >= 1 -> [{1,10000}];
get_probability(Level,2) when Level =< 120 andalso Level >= 1 -> [{2,10000}];
get_probability(Level,3) when Level =< 120 andalso Level >= 1 -> [{3,10000}];
get_probability(Level,_Pos_0) when Level =< 120 andalso Level >= 1 -> [{4,1250},{5,1250},{6,1250},{7,1250},{8,1250},{9,1250},{10,833},{11,833},{12,834}];
get_probability(_,_) -> [].