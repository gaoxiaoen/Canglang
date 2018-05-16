%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% 红包
%%% @end
%%% Created : 26. 四月 2016 下午2:16
%%%-------------------------------------------------------------------
-author("fengzhenlin").

-define(RED_BAG_ETS, red_bag_ets).

-define(RED_BAG_NOTICE_TIME, 5000).
-define(RED_BAG_EXPIRE_TIME, 86400). %%红包过期时间
-define(RED_BAG_EXPIRE_CHECT_TIME, 300).  %%过期检查时间

-record(redbag_notice, {
    key = 0,
    msg = "" %%公告内容
}).

-record(red_bag_st, {
    notice_list = [],  %%红包公告列表 [#redbag_notice{}]
    ref = 0  %%红包公告计时器
    , expire_ref = 0  %%过期红包检查
}).

-record(red_bag, {
    type = 0,   %%1普通,2帮派,3结婚
    scene = 0,
    gkey = 0,      %%帮派key
    key = 0,
    pkey = 0,
    name = "",     %%玩家名字
    career = 0,
    sex = 0,
    avatar = "",   %% 玩家头像
    couple_key = 0,
    couple_name = <<>>,
    couple_career = 0,
    couple_sex = 0,
    couple_avatar = 0,
    goods_id = 0,  %%红包物品id
    get_num = 0, %%已领取次数
    get_gold = 0,  %%已领取的总元宝数

%%---普通红包相关
    get_list = [],  %%已领取的玩家key
    gold_list = [], %%普通红包[gold_num1,gold_num2]

%%---帮派红包相关
    guild_get_list = [],  %%已领取的玩家信息 [#red_bag_g_p{}]
    guild_get_count_list = [],  %%领取统计 [{档位,getnum}]
    guild_red_type = 0,     %% 1个人红包 2系统红包
    time = 0  %%红包创建时间
}).

%%普通红包
-record(base_red_bag, {
    goods_id = 0,
    max_num = 0,
    random_id = 0
}).

%%充值送红包结构
-record(base_red_bag_charge, {
    charge = 0,  %%充值元宝
    goods_id = 0,  %%红包物品ID
    num = 0   %%数量
}).

%%帮派红包
-record(base_red_bag_guild, {
    goods_id = 0,
    max_num = 0,
    gold_list = []  %%奖励列表 [{个数,{min_gold, max_gold}}]
}).

%%帮派红包领取玩家信息
-record(red_bag_g_p, {
    pkey = 0,
    name = "",
    career = 0,
    sex = 0,
    avatar = "",
    get_gold = 0
}).