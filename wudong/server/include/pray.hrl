-ifndef(PRAY_HRL).
-define(PRAY_HRL,1).

-define(PRAY_STATE_FINSH,1).
-define(PRAY_STATE_ING,2).

-record(st_pray,{
	pkey = 0,
	fashion_id = 101001,
	fashion_time = 3600*24*12,
	cell_num = 100,
	left_cell_num = 100,
	quick_times = 3,
	equip_remain_time,
	bag_list = [],
	timerRef 
}).

-record(pray_goods,{
	pkey,
	key = 1 ,
	goods_id = 2 ,
	wash_attr = [],
	num,
	state,
	gemstone_groove = []
}).

-record(base_pray_exp,{
	min_lv = 31 ,
	max_lv = 40 ,
	exp = 100 ,
	max_exp = 10000
}).

-record(base_pray_equip,{
	min_lv = 0 ,
	max_lv = 0 ,
	color = [] ,
	level = [] ,
	sub_type = [],
	need_time = 300 
}).

-record(base_pray_bag,{
	bag_num = 1 ,
	diamond = 2 ,
	time = 3600
}).

-endif.