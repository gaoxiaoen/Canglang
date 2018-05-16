-ifndef(SHOP_HRL).
-define(SHOP_HRL, 1).

-define(RANDOM_SHOP_MYSTERIOUS, 1).
-define(RANDOM_SHOP_BLACK, 2).
-define(RANDOM_SHOP_SMELT, 6).
-define(RANDOM_SHOP_ATHLETICS, 4).
-define(RANDOM_SHOP_GUILD, 5).
-define(RANDOM_SHOP_BATTLE, 3).
-define(RANDOM_SHOP_STAR ,7).

-record(st_shop,{
	is_change = 0,
	refresh_time = 0,
    refresh_count = 0,
	shop_list = []
}).

-record(shop_item,{
	id,
	goods_id,
	num = 0 ,
	wash_attr,
	gemstone_groove,
	money,
	diamond,
	discount = 0
}).


					   
-record(base_random_shop,{
	shop_id = 0 ,
	pos = 0 ,
	min_level = 0 ,
	max_level = 0 ,
	goods_id = 0 ,
	shop_money = 0 ,
	diamond = 0 ,
	probability = 0,
	is_wash_rule = 0,
	discount = 0}).

-endif.