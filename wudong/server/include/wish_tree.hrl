-ifndef(WISH_TREE_HRL).
-define(WISH_TREE_HRL, 1).

-define(ETS_WISH_TREE, ets_wish_tree).

-define(REFRESH_MONEY, 2).

%%许愿树状态
-record(wish_tree,{
    pkey = 0,               %%世界等级
    lv = 1,                 %%许愿树等级
    exp= 0,					%%许愿树经验
	free_times = 0,			%%免费刷新次数
	refresh_progress = 0,	%%刷新进度
	goods_list = [],		%%本次抽出来的物品
	orange_goods_list = [], %%本次抽出来的橙色物品，不可被偷摘
	pick_goods_record = [], %%摘取记录
	client_rank_value = 0,  %%客户端排序随机值
	maturity_degree = 0,	%%成熟度
	max_maturity_degree = 0,%%最大成熟度
	all_visit_record = [],  %%永久访问记录
	visit_record = [],		%%本轮访问记录
	last_watering_time = 0,	%%上次浇水时间
	pick_goods = false,	    %%是否能被偷摘
	watering_times = 0,		%%浇水次数
	fertilizer_times = 0,	%%施肥次数
	harvest_time = -1	    %%收获时间
}).

%%访问记录
-record(visit_record,{
	pkey = 0 ,
	nickname = "" ,
	is_thks = 0,
	is_pick = 0,
	is_remind = 0,
	watering_time = 0 ,
	fertilizer_times = 0
}).

-record(base_wish,{
	tree_lv = 1 ,
	lv_up_exp = 1 ,
	add_exp = 10 ,
	goods_list = [] ,
	need_times = 3600 ,
	orange_goods_list = [] ,
	add_ref = 0 ,
	max_ref_process = 0,
	maturity_degree = 100
}).

-record(base_wish_tree_watering,{
		times = 1 ,
		cd_times = 10 ,
		reduce_times = 300 ,
		add_exp = 100,
		add_intimacy = 0}).

-record(base_wish_tree_fertilize,{
	times = 4 ,
	need_money = 25 ,
	add_maturity = 300 ,
	add_exp = 100,
	add_intimacy = 0}).

-endif.