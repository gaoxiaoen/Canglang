%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 五月 2016 下午3:32
%%%-------------------------------------------------------------------
-author("fengzhenlin").

-record(st_star_luck,{
    pkey = 0,
    dict = dict:new(),  %%星运物品字典,存放#star{}
    free_times = 0,  %%已免费占星次数
    update_time = 0,   %%更新时间
    star_pos = [1],   %%占星位置
    zx_double_times = 0,  %%占星双倍已使用次数
    open_bag_num = 0   %%开启的格子数
}).

-record(star,{
    key = 0,
    goods_id = 0,
    lv = 0,
    exp = 0,
    location = 0,  %%1身上 2背包 3占星
    pos = 0,  %%装备的位置 没装备时为0
    lock = 0,  %%是否锁定
    create_time = 0
}).

-record(base_star_luck,{
    goods_id = 0,
    lv = 0,
    exp = 0,
    init_exp = 0,
    attrs = []
}).

-record(base_star_luck_cost,{
    type = 0,  %%占星类型 0元宝召唤1初级2中级3高级4卓越5史诗
    pro = 0,   %%进阶概率
    cost_bgold = 0,
    cost_gold = 0,
    cost_coin = 0,
    pt = 0      %%占星获得积分
}).

-record(base_star_luck_pro,{
    type = 0,  %%占星类型
    goods_list = []  %%物品概率列表 [{goodsid,pro}]
}).

-record(base_star_lv_open,{
    lv = 0,
    open_num = 0
}).

-record(base_star_bag_open,{
    num = 1,
    cost_gold = 0
}).