%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 一月 2016 上午10:46
%%%-------------------------------------------------------------------
-author("fengzhenlin").

-include("common.hrl").

-define(ACT_RANK_EQUIP_STREN, 1).  %%装备榜
-define(ACT_RANK_PET, 2).  %%宠物榜
-define(ACT_RANK_BAOSHI, 3).  %%宝石榜
-define(ACT_RANK_MOUNT, 4).  %%坐骑榜
-define(ACT_RANK_WING, 5).  %%翅膀榜
-define(ACT_RANK_COMBATPOWER, 6).  %%战力榜
-define(ETS_ACT_TIME, ets_act_time).


%% 活动中定点刷的状态
-define(ACT_CLOSE_STATE, 0).     %% 关闭状态
-define(ACT_READY_STATE, 1).     %% 准备状态
-define(ACT_OPEN_STATE, 2).      %% 开启状态

%%  一周七天
-define(OPEN_WEEK_LIST, [1, 2, 3, 4, 5, 6, 7]).

-define(GLOBAL_RAM_TIMER_CAMP_IS_OPEN, global_ram_timer_camp_is_open).

%% 活动类型ID
-define(CAMP_ACT_FESTIVE_BOSS, 116). %%节日首领

-define(INF, 4200000000).  %% 默认无穷上限 42e

-record(state, {
    refresh_times = 0
    , http_ref = 0  %%http更新活动计时器
    , act_rank = [] %%冲榜活动数据 #rank_act{}
    , act_rank_ref = 0  %%冲榜计时器
    , daily_charge_record = []  %%每日充值抽奖记录 {pkey,name,goodsid}
    , online_time_record = []   %%在线时长抽奖记录
    , acc_charge_turntable_record = []  %%累充转盘抽奖记录
    , lim_shop = []  %%抢购商店 #lim_shop{}
    , consume_back_charge_log_list = [] %%消费抽返利
    , consume_rank_list = [] %%消费榜活动数据 #consume_rank_info{}
    , consume_rank_ref = 0  %%消费榜计时器
    , recharge_rank_list = [] %% 充值榜活动数据 #recharge_rank_info{}
    , recharge_rank_ref = 0  %% 充值榜计时器
    , marry_rank_list = [] %%   结婚榜活动数据 #marry_rank_info{}
    , marry_rank_ref = 0  %%    结婚榜计时器
    , act_one_gold_ref = null %%活动状态定时器
    , act_one_gold_log = [] %% 一元抢购日志 [{Pkey, Node, Sn, Nickname, Buynum, ActNum, GoodsId, GoodsNum}]
    , cross_1vn_shop = [] %% [{{type,id},count}]
    , cross_1vn_shop_base = [] %% [{{type,id},count}]
    , cross_1vn_shop_round = 0 %% [{{type,id},count}]
    , festival_charge_score = 0 %% 全服充值积分
    , festival_red_gift_ref = null %%红包雨定时器
    , festival_red_gift_list = [] %%节日红包集合
    , festival_red_gift_id = 0 %%当前档位的红包ID
    , festival_red_gift_1_key = {0, 0} %%红包雨第一名{Id,Pkey}
    , act_wishing_well_log = [] %% 许愿池数据(单)
    , act_wishing_well_rank = [] %% 许愿池排行(单)
    , act_wishing_well_ref = 0  %% 许愿池计时器(单)
    , cross_act_wishing_well_log = [] %% 许愿池数据(跨)
    , cross_act_wishing_well_rank = [] %% 许愿池排行(跨)
    , cross_act_wishing_well_ref = 0  %% 许愿池计时器(跨)

}).

-record(open_info, {
    gp_id = []  %%开启渠道列表 [{start,end}]
    , gs_id = []  %%开启服id列表
    , open_day = 0  %%开服第几天开启
    , end_day = 0  %%开服第几天结束
    , start_time = 0   %%开始时间
    , end_time = 0   %%结束时间
    , merge_st_day = 0  %%合服开始天数
    , merge_et_day = 0  %%合服结束天数
    , merge_times_list = []  %%第N次合服生效,空则不受控制
    , ignore_gs = []  %%不开改活动的服列表
    , priority = 0  %%优先级 0普通 1最优先(覆盖开服活动)
    , after_open_day = 0  %%开服多少天后才可开始
    , limit_open_day = 0 %%全服活动第N天开启
    , limit_end_day = 0 %%全服活动第N天后不开启,已经开启的全服活动继续开启
}).

%%活动总览信息
-record(act_info, {
    icon = 0,  %%图标id
    act_name = "",
    act_desc = "",
    show_goods_list = [],
    show_pos_day = 0, %%多少天之后放进二级界面
    ad_pic = []  %%登录广告图片
}).

%%----------首冲---------
-record(st_first_charge, {
    pkey = 0,  %%玩家key
    get_list = [],  %%已领取的天数
    charge_time = 0,  %%充值时间
    last_get_time = 0  %%最后领取时间
}).

-record(base_first_charge, {
    open_info = #open_info{}   %%活动开启时间信息  注意:所有的base活动record,都要将#open_info{}放在第一位
    , act_info = #act_info{}
    , act_id = 0  %%活动子类型
    , gift_list = []  %%礼包列表
}).

%%--------冲榜-----------
%%个人排榜信息
-record(st_act_rank, {
    pkey = 0,
    equip_stren_lv = 0,
    equip_stren_lv_time = 0,
    baoshi_lv = 0,
    baoshi_lv_time = 0
}).

%%全服排榜信息
-record(rank_act, {
    dict = dict:new()  %%榜 #ar{}
}).

-record(ar, {
    type = 0   %%榜类型 1装备2宠物3宝石4坐骑5翅膀6战神
    , rank = [] %%排名信息 #pinfo{}
    , reward_list = []  %%已领奖的玩家key [pkey]
}).

%%冲榜玩家信息结构
-record(pinfo, {
    pkey = 0,
    sn = 0,
    pf = 0,
    name = "",
    lv = 0,
    career = 0,
    vip = 0,
    realm = 0,
    info = 0,  %%排名数据 如战力排名代表战力
    rank = 0
}).

-record(base_act_rank, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , type = 0  %%榜类型 1装备2宠物3宝石4坐骑5翅膀6战神
    , openday = 0  %%开始时间
    , gift_list = []  %%礼包列表 {rank,giftid},
    , sell_goods = []  %%促销物品 {goodsid,maxnum,gold}
    , min_val = 0    %%进入排行榜最少数值
}).

%%---------冲榜达标返还---------
-record(st_act_rank_goal, {
    pkey = 0,
    act_id = 0,  %%活动子id
    get_list = []  %%已领取的活动id 列表
}).

-record(base_act_rank_goal, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , goal_list = [] %%目标列表 [#base_act_ar_goal{}]
}).

-record(base_ar_goal, {
    id = 0,
    type = 0,
    goal = 0,
    gift_id = 0
}).

%%----------每日充值---------
-record(st_daily_charge, {
    pkey = 0,
    get_list = [],  %%领取时间列表 [time]
    last_charge_time = 0
}).

-record(base_daily_charge, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , goods_list = []  %%抽取库的物品id列表 [{goodsid,num,pro}]
    , get_exchange = {0, 0}  %%额外获得的兑换物品 {goodsid,num}
    , exchage_goods = {}  %%可兑换的物品 {goodsid,num,neednum}
}).

%%---------累计充值--------
-record(st_acc_charge, {
    pkey = 0,
    acc_val = 0,  %%累计充值额度
    act_id = 0,  %%子活动id
    get_acc_ids = [],  %%已领取的累计充值活动id
    time = 0
}).

-record(base_acc_charge, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , gift_list = []  %%[{累计充值金额,礼包ID}]
}).

%%---------累计消费--------
-record(st_acc_consume, {
    pkey = 0,
    acc_val = 0,  %%累计消费额度
    act_id = 0,  %%子活动id
    get_acc_ids = [],  %%已领取的累计消费活动id
    time = 0
}).

-record(base_acc_consume, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , gift_list = []
}).

%%---------单笔充值----------
-record(st_one_charge, {
    pkey = 0,
    charge_list = 0,  %%单笔充值额度列表 单位元宝
    act_id = 0,  %%子活动id
    get_acc_ids = [],  %%已领取的单笔充值活动id
    time = 0
}).

-record(base_one_charge, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , gift_list = []
}).

%%--------抢购商店-----------
%%全服抢购信息
-record(lim_shop, {
    act_id = 0,
    dict = dict:new(),  %%购买的商品信息 {商品编号id,buytimes}
    auto_del_ref = 0,  %%全服抢购，自动减少购买次数 计时器
    act_day = 1
}).

%%个人抢购信息
-record(st_lim_shop, {
    pkey = 0,
    act_id = 0,  %%当前活动子id
    dict = dict:new(),  %%购买的商品信息 {商品编号id,buytimes}
    update_time = 0     %%最后刷新时间
}).

%%抢购活动类型
-record(lim_shop_type, {
    is_global_del = 0,  %%道具可购买总数会是否由于其他玩家购买减少
    is_refresh = 0  %%道具购买次数是否每日重置
}).

-record(base_lim_shop, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , goods_list = [] %%商品列表 [#base_lim_shop_goods{}]
}).

-record(base_lim_shop_goods, {
    id = 0,  %%编号id
    lim_type = 0,  %%抢购类型 1:个人抢购1 2:个人抢购2 3:全服抢购1 4:全服抢购2
    goods_id = 0,
    goods_num = 0,
    max_num = 0,  %%道具销售总数
    can_buy_num = 0,
    cost_gold = 0,
    cost_bgold = 0,
    old_cost_gold = 0,
    is_sell_out = 0,  %%道具是否售罄
    is_auto_del = 0   %%系统是否自动减少可购买总数
}).

%%-------跑环双倍------
-record(base_cycle_double, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , mul = 0

}).

%%-----新每日充值-------
-record(st_new_daily_charge, {
    pkey = 0,
    get_time = 0,  %%领取时间
    last_charge_time = 0
}).

-record(base_new_daily_charge, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , gift_id = 0
}).

%%-----新单笔充值-------
-record(st_new_one_charge, {
    pkey = 0,
    act_id = 0,
    get_time = 0,  %%领取时间
    max_charge = 0  %%活动时间内，充值最大金额
}).

-record(base_new_one_charge, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , charge_val = 0
    , gift_id = 0
}).

%%----在线奖励---------
-record(st_online_gift, {
    pkey = 0,
    get_list = 0,
    get_time = 0
}).

-record(base_online_gift, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , open_time = []  %%开始时间 [{openHour,openSec},{EndHour,EndSec}]
    , gift_list = []  %%物品列表 [{goodsid,goodsnum}]
    , mail_title = ""
    , mail_content = ""
}).

%%----兑换活动------
-record(st_exchange, {
    pkey = 0,
    act_id = 0,  %%子活动id
    get_list = []  %%已领取的累计充值活动id
}).

-record(base_exchange, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , gift_list = []  %%[{累计充值金额,礼包ID}]
}).

%%----------在线时长奖励---------
-record(st_online_time_gift, {
    pkey = 0,
    act_id = 0,  %%子活动id
    get_list = [],  %%领取时间列表 [{time,gid,gnum}]
    last_get_time = 0,  %%最后领取时间
    online_time = 0,  %%今天累计在线时间
    online_update_time = 0  %%在线时长累计跟新时间
}).

-record(base_online_time_gift, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , gift_list = []  %%抽取库的物品id列表 [#base_ot_gift{}]
}).

-record(base_ot_gift, {
    online_time = 0  %%在线时长
    , goods_list = []  %%[{goodsid,num,pro}]
    , get_exchange = {0, 0}  %%额外获得的兑换物品 {goodsid,num}
}).

-record(base_ot_exchange, {
    act_id = 0
    , exchange_goods = []  %%可兑换的物品 [{goodsid,num,neednum}]
}).

%%---------累计充值--------
-record(st_daily_acc_charge, {
    pkey = 0,
    acc_val = 0,  %%累计充值额度
    act_id = 0,  %%子活动id
    get_acc_ids = [],  %%已领取的累计充值活动id
    time = 0
}).

-record(base_daily_acc_charge, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , gift_list = []  %%[{累计充值金额,礼包ID}]
}).

%%-------活动集合内容------
-record(base_act_content, {
    id = 0, %%活动类型
    name = "",
    desc = "",
    goods_list = [],
    order = 0
}).

%%------累充抽奖------
-record(st_acc_charge_turntable, {
    pkey = 0,
    act_id = 0,
    acc_val = 0,
    times = 0,  %%已抽奖次数
    luck_val = 0,  %%幸运值
    update_time = 0  %%最后更新时间
}).

-record(base_acc_charge_turntable, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , charge_val = 0  %%充值满N钻，获得转盘一次
    , act_id = 0
    , cost_gold = 0  %%每次抽奖消耗元宝
    , gift_list = [] %% [{物品ID,数量,权重,幸运值,幸运权重}]
}).


%%-----每日首冲返还-------
-record(st_d_f_charge_return, {
    pkey = 0,
    get_time = 0
}).

-record(base_d_f_charge_return, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , min_charge = 0  %%单笔最低充值元宝
    , pro = 0  %%返还比例
}).

%%------累充礼包-----------
-record(st_acc_charge_gift, {
    pkey = 0,
    act_id = 0,
    acc_val = 0,  %%累充
    times = 0  %%已抽奖次数
}).

-record(base_acc_charge_gift, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , charge_val = 0  %%充值满N钻，获得转盘一次
    , act_id = 0
    , gift_id = 0
}).

%%-----开服广告-------
-record(base_ad, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , min_lv = 0
    , pic_list = []  %%图片id列表 [{图片id,跳转id}]
}).

%%----物品兑换------
-record(st_goods_exchange, {
    pkey = 0,
    act_id = 0,
    get_list = [], %已领取兑换列表[{id,times}]
    get_time = 0  %%最后兑换时间
}).

-record(base_goods_exchange, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , exchange_list = [] %%兑换物品列表[#base_ge{}]
}).

-record(base_ge, {
    id = 0,
    name = "",
    get_goods = {0, 0},
    cost_goods = [], %%消耗的物品[{id,num}]
    max_times = 0
}).


%%----集字活动-----
-record(base_act_collect_exchange, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , exchange_list = [] %% [#base_ce{}..]
}).

-record(st_collect_exchange, {
    pkey = 0,
    count = 0
}).

-record(base_ce, {
    id = 0,
    get_goods = {0, 0},
    red_id = 0, %% 红装图纸，大于99才不可兑换
    limit_list = [],
    cost_goods = [] %%消耗的物品[{id,num}]

}).

%%----角色每日累充------
-record(st_role_d_acc_charge, {
    pkey = 0,
    act_id = 0,
    acc_val = 0,  %%今天累充额度
    update_time = 0,  %%累充更新时间
    get_list = []  %%领取列表 [{id,day,time}]  id代表充值档数,day代表领取的天数
}).

-record(base_role_d_acc_charge, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , goods_list = [] %%物品列表 [#base_rdac_g{}]
}).

-record(base_rdac_g, {
    day = 0,
    gift_list = [],  %%累充列表 [{charge,giftid}],
    show_list = []   %%显示列表 [{1,1},{,2,4},{5,7}]
}).

%%----连续充值------
-record(st_con_charge, {
    pkey = 0,
    act_id = 0,
    charge_list = [],  %% 累充列表 [{val,time}]
    get_list = [],  %%领取列表 [{day,time}]
    update_time = 0, %%最后更新时间
    get_gift_time = 0  %%终极礼包领取时间
}).

-record(base_con_charge, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , goods_list = []  %%物品列表 [{充值额度,礼包ID}]
    , last_gift_id = 0  %%终极礼包ID
}).

%%----砸蛋------
-record(st_open_egg, {
    pkey = 0,
    act_id = 0,
    charge_val = 0,  %%累充额度
    use_times = 0,  %%已用次数
    get_list = [], %%领取列表 [{posId,id}]
    goods_list = [],  %%库 [{id,goodsId,num,lv,pro}]
    update_time = 0  %%最后更新时间
}).

-record(base_open_egg, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , one_charge = 0
    , cost_gold_list = []
    , goods_list = [] %%奖品库 [#base_open_egg_goods{}]
}).

-record(base_open_egg_goods, {
    lv = 0,  %%几等奖
    goods_list = [], %%物品库 [{goods_id,num,pro,pro1}] pro:最终被抽中的概率 pro1:组成库被抽中的概率
    num = 0   %%组成库的数量
}).


%% -------抽奖转盘---------

-record(st_draw_turntable, {
    pkey = 0,
    act_id = 0,
    score = 0, %% 积分
    location = 0, %% 指向位置
    exchange_list = [], %% 兑换列表 [{id,count}..]
    turntable_id = 1, %% 转盘id
    count = 0 %% 转动次数
}).

-record(base_draw_turntable, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , refresh_cost = 0 %% 刷新价格
    , one_cost = 0 %% 单次价格
    , ten_cost = 0 %% 十次价格
    , turntable_list = []    %% 转盘列表
    , exchange_list = [] %% [{编号,物品id,限制次数,消耗积分}...]
}).

-record(base_draw_turntable_goods, {
    id = 0
    , turntable_id = 0
    , goods_list = []
    , floor = 0
    , ceil = 0
    , reset_id = 0
}).


%%----合服签到------
-record(st_merge_sign_in, {
    pkey = 0,
    act_id = 0,
    get_list = [],  %%普通领取列表 [{day,time,state}] state:0不可领取 1可领取 2已领取
    get_gift_time = 0,  %%普通终极礼包领取时间
    charge_list = [],  %% 累充列表 [{val,time}]
    charge_get_list = [],  %%至尊领取列表 [{day,time}]
    charge_gift_time = 0,  %%至尊终极礼包领取时间
    update_time = 0 %%最后更新时间
}).

-record(base_merge_sign_in, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , goods_list = []  %% 普通签到物品列表 [礼包Id]
    , last_gift_id = 0  %%终极礼包ID
    , charge_goods_list = []  %%至尊物品列表 [{充值额度,礼包ID}]
    , charge_last_gift_id = 0  %%至尊终极礼包ID
}).

%%-----合服充值多倍-----
-record(base_charge_mul, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , charge_list = []  %%充值多倍 [{st,et,mul}]
}).

%%-----目标福利-----
-record(st_target_act, {
    pkey = 0,
    act_id = 0,
    target_list = []  %%已领取列表 [#tar_act{}]
}).

-record(base_target_act, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , target_list = []  %%目标列表 [#base_tar_act{}]
}).

-record(base_tar_act, {
    type = 0,
    list = []  %%目标 [{最少值,礼包id}]
}).

-record(tar_act, {
    type = 0,
    cur_val = 0,
    get_list = []  %%领取的目标值
}).

%%----大富翁-----
-record(base_act_monopoly, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , icon = 0 %%本期奖励
    , gift_list = []  %%圈数奖励 [{round,gift_id}]
}).

%%---vip福利------
-record(st_vip_gift, {
    pkey = 0,
    act_id = 0,
    buy_list = [],  %%购买列表 [{viplv,buytimes}]
    update_time = 0 %%最后更新时间
}).

-record(base_vip_gift, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , gift_list = []  %%vip礼包 [#base_vg{}]
}).

-record(base_vg, {
    vip_lv = 0,
    gift_id = 0,
    times = 0,
    gold = 0,
    old_gold = 0
}).

%%---藏宝阁--------
-record(base_treasure_hourse, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , treasure_hourse_sub_list = []
}).

%% 藏宝阁子结构
-record(base_treasure_hourse_sub, {
    limit_charge_gold = 0 %% 充值额度限制
    , show_day = 0 %% 显示天数
    , act_open_day = 0 %% 活动开启天数
    , login_gift = 0 %% 登录礼包
    , buy_gift_list = 0 %% 限购列表 [{商品ID， BasePrice, CostGold, BuyNum, GiftId,ShowType,ShowStage}]
}).

%%藏宝阁
-record(st_treasure_hourse, {
    pkey = 0
    , act_id = 0 %% 活动ID
    , charge_gold = 0 %% 充值总钻石
    , act_open_time = 0 %% 活动达标后开启时间
    , act_open_day = 0 %% 活动开启天数
    , is_recv = 0 %% 是否领取当天活动登陆礼包
    , buy_list = [] %% [{商品id, 商品num}]
    , recv_time = 0
    , op_time = 0 %% 当天领取活动登陆礼包，操作时间
}).

%%Pkey, ActId, ChargeGold, IsRecv, OpTime, ActOpenTime

-record(treasure_hourse_state, {
    state_sub_list = [] %% [#treasure_hourse_state_sub{}]
}).

-record(treasure_hourse_state_sub, {
    pkey = 0,
    act_id = 0,
    charge_gold = 0,
    is_recv = 0,
    op_time = 0,
    act_open_time = 0
}).

%% 开服活动集合--------------------------
%% 开服之江湖榜
-record(base_open_jh_rank, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , list = [] %% [{act_type, 参数, gift_id}]
}).
%% 江湖榜
-record(st_open_act_jh_rank, {
    pkey = 0,
    act_id = 0,
    recv_list = [], %% [{act_type, 条件参数}]
    op_time = 0
}).

-define(OPEN_JH_RANK_LV, 1). %% 冲级大礼
-define(OPEN_JH_RANK_TOWER, 2). %% 决战符文塔
-define(OPEN_JH_RANK_DAILY_THREE, 3). %% 经脉副本
-define(OPEN_JH_RANK_EXP_DUNGEON, 4). %% 经验副本
-define(OPEN_JH_RANK_ARENA, 5). %% 单服竞技场
-define(OPEN_JH_RANK_KF_ARENA, 6). %% 跨服竞技场
-define(OPEN_JH_RANK_COMBAT_TARGET, 7). %% 战力目标
-define(OPEN_JH_RANK_GUARD, 8). %%守护副本

%% 开服之进阶目标
-record(base_open_up_target, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , list = [] %% [{act_type, 参数, [{GoodsId, GoodsNum, Time}]}]
}).

-record(base_up_target_time, {
    open_day = 0
    , end_day = 0
    , act_type_list1 = [] %% 进阶目标1类型索引
    , act_type_list2 = [] %% 进阶目标2类型索引
    , act_type_list3 = [] %% 进阶目标3类型索引
}).

-record(base_up_target, {
    id = 0 %% 序号
    , act_type = 0 %% 活动索引类型
    , type = 0 %% 类型(1坐骑,2仙羽,3法宝,4神兵,5妖灵,6宠物进阶,7宠物升星,8足迹系统9灵猫10金身)
    , args = 0 %% 等级参数
    , reward_list = [] %% 奖励
}).

%% 进阶目标
-record(st_open_act_up_target, {
    pkey = 0,
    act_id = 0,
    open_day = 0,
    recv_list = [], %% [{act_type, 条件参数}]
    op_time = 0
}).

%% 进阶目标2
-record(st_open_act_up_target2, {
    pkey = 0,
    act_id = 0,
    open_day = 0,
    recv_list = [], %% [{act_type, 条件参数}]
    op_time = 0
}).

%% 进阶目标3
-record(st_open_act_up_target3, {
    pkey = 0,
    act_id = 0,
    open_day = 0,
    recv_list = [], %% [{act_type, 条件参数}]
    op_time = 0
}).

-define(OPEN_UP_TARGET_MOUNT, 1). %% 坐骑进阶
-define(OPEN_UP_TARGET_WING, 2).  %% 仙羽进阶
-define(OPEN_UP_TARGET_MAGIC_WEAPON, 3). %% 法宝进阶
-define(OPEN_UP_TARGET_LIGHT_WEAPON, 4). %% 神兵进阶
-define(OPEN_UP_TARGET_PET_WEAPON, 5). %% 妖灵
-define(OPEN_UP_TARGET_PET_UP_LV, 6). %% 宠物进阶
-define(OPEN_UP_TARGET_PET_UP_STAR, 7). %% 宠物升星
-define(OPEN_UP_TARGET_FOOTPRINT, 8). %%足迹进阶
-define(OPEN_UP_TARGET_CAT_UP_LV, 9). %%灵猫进阶
-define(OPEN_UP_TARGET_GOLDEN_BODY_UP_LV, 10). %%金身进阶
-define(OPEN_UP_TARGET_GOD_TREASURE_UP_LV, 11). %%仙宝进阶
-define(OPEN_UP_TARGET_JADE_UP_LV, 12). %%玉佩进阶
-define(OPEN_UP_TARGET_BABY_WING, 13). %% 灵羽进阶
-define(OPEN_UP_TARGET_BABY_MOUNT, 14). %% 灵骑进阶
-define(OPEN_UP_TARGET_BABY_WEAPON, 15). %% 灵弓进阶

%% 开服之首充团购
-record(base_open_group_charge, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , charge_list = [] %% [{GroupNum, ChargeGold, GiftId}]
}).

-record(st_open_act_group_charge, {
    pkey = 0,
    act_id = 0,
    recv_list = [], %% [{充值人数, 额度}]
    charge_list = [],
    op_time = 0
}).

-define(ETS_OPEN_GROUP_CHARGE, ets_open_group_charge).
-record(ets_open_group_charge, {
    key = {0, 0, 0}, %% {act_id, base_charge_num, base_charge_gold}
    act_id = 0,
    base_charge_num = 0,
    base_charge_gold = 0,
    charge_num = 0,
    player_list = [] %% 充值玩家信息
}).

%% 开服之累充活动
-record(base_open_acc_charge, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , charge_list = [] %% [{AccChargeGold,GiftId}]
}).

-record(st_open_act_acc_charge, {
    pkey = 0,
    act_id = 0,
    recv_list = [], %% 已领取的奖励
    acc_charge_gold = 0, %% 累充钻石
    op_time = 0 %% 上次写库时间
}).


%% 开服之全服总动员
-record(base_open_all_target, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , list = [] %% [{act_type, 等级参数, 配置人数, gift_id}]
}).

-define(OPEN_ALL_TARGET_MOUNT, 1). %% 坐骑进阶
-define(OPEN_ALL_TARGET_WING, 2).  %% 仙羽进阶
-define(OPEN_ALL_TARGET_MAGIC_WEAPON, 3). %% 法宝进阶
-define(OPEN_All_TARGET_LIGHT_WEAPON, 4). %% 神兵进阶
-define(OPEN_ALL_TARGET_PET_WEAPON, 5). %% 妖灵进阶
-define(OPEN_ALL_TARGET_PET_UP_LV, 6). %% 宠物进阶
-define(OPEN_ALL_TARGET_PET_UP_STAR, 7). %% 宠物升星
-define(OPEN_ALL_TARGET_FOOTPRINT, 8). %% 足迹进阶
-define(OPEN_ALL_TARGET_CAT_UP_LV, 9). %% 灵猫进阶
-define(OPEN_ALL_TARGET_GOLDEN_BODY_UP_LV, 10). %% 金身进阶
-define(OPEN_ALL_TARGET_JADE_UP_LV, 11). %% 玉佩进阶
-define(OPEN_ALL_TARGET_GOD_TREASURE_UP_LV, 12). %% 仙宝进阶

-define(OPEN_ALL_TARGET_LIST, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]). %% 坐骑 仙羽 法宝 神兵

-record(st_open_act_all_target, {
    pkey = 0,
    act_id = 0,
    recv_list = [],
    op_time = 0
}).
-define(ETS_OPEN_ALL_TARGET, ets_open_all_target).

-record(ets_open_all_target, {
    key = {0, 0, 0, 0}, %% {act_id, act_type, base_lv, base_num}
    act_id = 0,
    act_type = 0, %% 1坐骑,2仙羽,3法宝,4神兵,5灵童,6灵弓,7灵兽
    base_lv = 0, %% 目标阶数
    base_num = 0, %% 目标人数
    num = 0, %% 当前到达人数
    player_list = [] %% 玩家信息[{pkey, lv}]
}).

-record(st_open_act_all_target2, {
    pkey = 0,
    act_id = 0,
    recv_list = [],
    op_time = 0
}).
-define(ETS_OPEN_ALL_TARGET2, ets_open_all_target2).

-record(st_open_act_all_target3, {
    pkey = 0,
    act_id = 0,
    recv_list = [],
    op_time = 0
}).
-define(ETS_OPEN_ALL_TARGET3, ets_open_all_target3).

%% 开服活动全民冲榜
-record(base_open_act_all_rank, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , list = [] %% [{rank_type, 奖励发放类型1邮件发放2手动领取， 名次min, 名次max, 等级参数, gift_id}]
}).

-define(OPEN_ALL_RANK_MAIL_SEND, 1). %% 全民冲榜奖励邮件发送
-define(OPEN_ALL_RANK_RECV, 2). %% 全民冲榜奖励手动领取

-define(OPEN_ALL_RANK_MOUNT, 1). %% 坐骑升级
-define(OPEN_ALL_RANK_WING, 2). %% 仙羽升级
-define(OPEN_ALL_RANK_MAGIC_WEAPON, 3). %% 法器升级
-define(OPEN_ALL_RANK_LIGHT_WEAPON, 4). %% 神兵升级
-define(OPEN_ALL_RANK_PET_WEAPON, 5). %% 妖灵进阶
-define(OPEN_ALL_RANK_PET_UP_LV, 6). %% 宠物进阶
-define(OPEN_ALL_RANK_PET_UP_STAR, 7). %% 宠物升星
-define(OPEN_ALL_RANK_FOOTPRINT, 8). %% 足迹进阶
-define(OPEN_ALL_RANK_CAT_UP_LV, 9). %% 灵猫进阶
-define(OPEN_ALL_RANK_GOLDEN_BODY_UP_LV, 10). %% 金身进阶
-define(OPEN_ALL_RANK_BABY_WING, 11). %% 灵羽升级
-define(OPEN_ALL_RANK_BABY_UP_LV, 12). %% 子女进阶
-define(OPEN_ALL_RANK_BABY_UP_STAR, 13). %% 子女升星
-define(OPEN_ALL_RANK_JADE_UP_LV, 14). %% 玉佩升星
-define(OPEN_ALL_RANK_GOD_TREASURE_UP_LV, 15). %% 仙宝升星


-record(st_open_act_all_rank, {
    pkey = 0
    , act_id = 0
    , recv_list = [] %% [{rank_type, base_lv}]
    , op_time = 0
}).

-record(st_open_act_all_rank2, {
    pkey = 0
    , act_id = 0
    , recv_list = [] %% [{rank_type, base_lv}]
    , op_time = 0
}).

-record(st_open_act_all_rank3, {
    pkey = 0
    , act_id = 0
    , recv_list = [] %% [{rank_type, base_lv}]
    , op_time = 0
}).

%% 开服活动帮派争霸
-record(base_open_act_guild_rank, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , list = [] %% [{rank, 1帮主2成员，gift_id}]
}).

%% 开服活动返利抢购
-record(base_open_act_back_buy, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , act_type = 0 %% 活动索引类型
}).

-record(base_act_back_buy, {
    id = 0 %% 序号
    , order_id = 0 %% 下标
    , act_type = 0 %% 活动索引类型
    , goods_id = 0 %% 商品ID
    , goods_num = 0 %% 商品数量
    , hour = 0 %% 0非限时 N小时数
    , sys_limit_num = 0 %% 系统限购次数
    , limit_num = 0 %% 个人限购次数
    , discount = 0 %% 折扣
    , base_price = 0 %% 原价
    , price = 0 %% 现价
}).

-record(st_act_back_buy, {
    pkey = 0
    , open_day = 0
    , buy_list = [] %% [{id, num}]
    , op_time = 0
}).

-define(ETS_OPEN_BACK_BUY, ets_open_back_buy).
-record(ets_open_back_buy, {
    key = {0, 0} %% {open_day, order_id}
    , open_day = 0
    , order_id = 0
    , total_num = 0 %% 系统抢购次数
}).

%%%%%%%%%%%%%

%% 花千骨每日首充
-record(base_hqg_daily_charge, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , acc_charge_list = [] %% [{Type, ChargeGold, GiftId, FirstGiftId}] Type 1小累充 2大累充
}).

%% 玩家花千骨每日首充
-record(st_hqg_daily_charge, {
    act_id = 0,
    pkey = 0,
    acc_charge = 0, %% 累积充值额度
    recv_acc = [], %% 已领取额度奖励
    op_time = 0, %% 操作时间
    type1 = 0, %% 是否使用累充1
    type2 = 0, %% 是否使用累充2
    recv_first_list = [] %% 领取的首充额度值
}).

-define(HQG_DAILY_CHARGE_FIRST, 1). %% 首充
-define(HQG_DAILY_CHARGE_ACC, 2). %% 累充

-define(HQG_DAILY_CHARGE_ACC1, 1). %% 累充1
-define(HQG_DAILY_CHARGE_ACC2, 2). %% 累充2

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%地宫寻宝活动
-record(base_act_map, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , reward_type = 0 %% 奖励类型 策划需配置成act_id
    , mb_reward_list = [] %% 密保奖励列表
    , bd_reward_lits = [] %% 标底奖励列表
}).

%% 地宫寻宝配表
-record(base_act_map_reward, {
    id = 0
    , order_id = 0 %% 界面第几个宝箱
    , reward_type = 0 %% 策划配置成 活动ID
    , type = 0 %% 1固定奖励2秘保奖励3标底奖励
    , goods_list = [] %%[{goods_type, num}]
}).

%%玩家日志ets缓存数据
-record(ets_map_log, {
    pkey = 0
    , log_list = [] %% [{操作时间，goods_type, goods_num}]
}).

%%系统数据
-record(ets_map_log_sys, {
    act_id = 0
    , log_list = [] %% 当前20条记录 [{nickname, 操作时间，goods_type, goods_num}]
    , pass_num = 0 %% 活动内系统通关次数
}).

%%玩家数据
-record(st_act_map, {
    pkey = 0
    , act_id = 0
    , step = 0 %% 当前步数
    , pass_num = 0 %% 通关次数， 用来标识当前是否通关
    , use_free_num = 0 %% 已使用的免费次数
    , recv_list = [] %% 当前领取的坑
    , op_time = 0
}).

-define(ETS_MAP_LOG_SYS, ets_map_log_sys).
-define(ETS_MAP_LOG, ets_map_log).
-define(ACT_MAP_STEP_COST, data_version_different:get(6)). %% 每走一步消耗50钻
-define(ACT_MAP_REWARD_1, 1). %% 固定奖励
-define(ACT_MAP_REWARD_2, 2). %% 密保奖励
-define(ACT_MAP_REWARD_3, 3). %% 标底奖励
-define(ACT_MAP_PASS_NUM_FREE, 5). %% 通关5次免费寻宝一次

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-record(base_uplv_box, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , reward_type = 0 %% 奖励类型
    , goods_list %% 界面展示礼包[{Id, Num}]
}).

-record(base_uplv_box_reward, {
    id = 0
    , order_id = 0 %% 下标ID
    , reward_type = 0
    , goods_id = 0
    , type = 0 %% 1普通 2翻倍
    , range_num = [0, 0] %% 奖励个数范围
    , show_goods_list = [] %% 显示的物品列表
}).

-record(st_uplv_box, {
    pkey = 0
    , act_id = 0
    , open_day = 0
    , op_time = 0
    , recv_list = []
    , use_free_num = 0 %% 使用过的免费次数
    , online_time = 0 %% 活动内在线时间
    , last_login_time = 0
}).

-record(ets_uplv_box_log, {
    pkey = 0
    , log_list = [] %% 日志 [[goods_id, goods_num], .. ]
}).

-define(ETS_UPLV_BOX_LOG, ets_uplv_box_log). %% 玩家日志表
-define(UPLV_BOX_ONLINE_TIME, 15). %% 超过30秒钟更新次缓存数据
-define(UPLV_BOX_OPEN_COST, 50). %% 提前开宝箱消耗
-define(UPLV_BOX_RESET_COST, 100). %% 重置宝箱消耗
-define(UPLV_BOX_CD_TIME, 1800). %% 获取单次免费CD时间
-define(UPLV_BOX_MAX_FREE_TIME, 3). %% 当天开启宝箱最大免费次数

%%------------限时抢购
-record(base_limit_buy, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , type = 0 %% 奖励类型
    , reward_list = [] %% 抢购次数奖励礼包
}).

-record(base_limit_buy_shop, {
    id = 0, %% 序号
    time = 0, %% 时间段
    goods_id = 0,
    goods_num = 0,
    price1 = 0, %%原价
    price2 = 0, %%现价
    buy_num = 0, %%个人限购次数
    sys_buy_num = 0, %%系统限购次数
    type = 0 %%活动类型
}).

-record(st_limit_buy, {
    pkey = 0
    , act_id = 0
    , buy_list = [] %%玩家抢购的商品信息
    , recv_list = [] %%玩家领取的列表
    , op_time = 0
}).

-record(ets_limit_buy, {
    act_id = 0
    , buy_list = [] %%[{shop_id, num}]
    , log = [] %% [{nickname, 时间点，物品ID，物品数量}]
    , db_flag = 0 %% 用于标记数据库写入
}).
-define(ETS_LIMIT_BUY, ets_limit_buy).

-define(RANK_LIMIT, 20).

-record(st_cross_flower, {
    pid_list = [],
    log_list = [],  %% [#flower_log{}..]
    rank_give_list = [],
    rank_get_list = [],
    reward_list = [],
    ref = [],
    is_change = 0
}).

-record(flower_log, {
    sn = 0,
    pkey = 0,
    nickname = <<>>,
    sex = 0,
    avatar = "",
    give = 0,
    get = 0,
    give_rank = 0,
    get_rank = 0,
    give_change_time = 0,
    get_change_time = 0
}).

-record(player_flower_log, {
    pkey = 0,
    act_id = 0,
    give = 0,
    get = 0,
    give_list = [],
    get_list = []
}).

-record(base_act_cross_flower, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , give_list = [] %% [#base_cross_flower{}..]
    , get_list = [] %% [#base_cross_flower{}..]
    , get_rank_info = []
    , give_rank_info = []
}).

-record(base_cross_flower, {
    id = 0
    , must = 0
    , award = []
}).

-record(base_fuwen_map_discount, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , discount = 0
}).

-record(base_jiandao_map_discount, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , discount = 0
}).

%% 符文寻宝相关
-record(base_fuwen_map, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , one_cost = 0 %% 寻宝一次消耗
    , ten_cost = 0 %% 寻宝十次消耗
    , chip_min = 0
    , chip_max = 0
    , cd_time = 0
    , type = 0 %% 奖励类型
    , list = [] %% 随机库 [{符文库ID,概率,幸运值下限,幸运值上限,[{道具ID,道具数量,权重,是否珍惜,位置}]}]
}).

-record(base_fuwen_map_reward, {
    id = 0 %% 序号
    , type = 0 %% 活动库索引
    , bag_id = 0 %% 符文库ID
    , p = 0 %% 概率
    , luck_min = 0 %% 幸运值下限
    , luck_max = 0 %% 幸运值上限
    , reward_list = [] %% 符文库 [{goods_type, power}]
}).

-record(st_fuwen_map, {
    pkey = 0
    , act_id = 0
    , luck_value = 0 %% 幸运值
    , fuwen_bag_id = 0 %% 符文库ID
    , last_free_time = 0 %% 上次免费时间
    , op_time = 0 %% 操作时间
}).

%% 剑道寻宝相关
-record(base_jiandao_map, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , one_cost = 0 %% 寻宝一次消耗
    , ten_cost = 0 %% 寻宝十次消耗
    , chip_min = 0
    , chip_max = 0
    , cd_time = 0
    , type = 0 %% 奖励类型
    , list = [] %% 随机库 [{符文库ID,概率,幸运值下限,幸运值上限,[{道具ID,道具数量,权重,是否珍惜,位置}]}]
}).

-record(base_jiandao_map_reward, {
    id = 0 %% 序号
    , type = 0 %% 活动库索引
    , bag_id = 0 %% 符文库ID
    , p = 0 %% 概率
    , luck_min = 0 %% 幸运值下限
    , luck_max = 0 %% 幸运值上限
    , reward_list = [] %% 符文库 [{goods_type, power}]
}).

-record(st_jiandao_map, {
    pkey = 0
    , act_id = 0
    , luck_value = 0 %% 幸运值
    , jiandao_bag_id = 0 %% 符文库ID
    , last_free_time = 0 %% 上次免费时间
    , op_time = 0 %% 操作时间
}).

-record(base_act_stone_ident, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , exchange_list = [] %% [#base_stone_ident{}..]
}).

%% 原石鉴定
-record(base_stone_ident, {
    id = 0,
    get_goods = 0,
    cost_goods = []
}).

-record(st_hundred_return, {
    pkey = 0,
    act_id = 0,
    state = 0
}).

-record(base_hundred_return, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , cost = 0
    , value = 0
    , get_list = [] %% [{id,num}..]
}).

%% 登陆有礼
-record(base_login_online, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , online_two_gift = [] %% 在线两小时礼包
    , online_four_gift = [] %% 在线四小时礼包
    , online_eight_gift = [] %% 在线八小时礼包
    , login_gift = [] %% 登陆礼包
}).

-record(st_login_online, {
    pkey = 0
    , act_id = 0
    , charge_gold = 0
    , is_recv_login = 0
    , recv_online_list = []
    , op_time = 0
}).

-define(LOGIN_ONLINE_TWO_HOUR, 2 * 3600).
-define(LOGIN_ONLINE_FOUR_HOUR, 4 * 3600).
-define(LOGIN_ONLINE_EIGHT_HOUR, 8 * 3600).

%% 神秘兑换（新兑换活动）
-record(st_new_exchange, {
    pkey = 0,
    act_id = 0,
    exchange_list = [],  %% [{Id, Num}]
    op_time = 0
}).

-record(base_new_exchange, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , list = []  %%[#base_new_exchange_sub{}]
}).

-record(base_new_exchange_sub, {
    id = 0 %%
    , exchange_cost = [] %% 兑换消耗
    , exchange_get = [] %% 兑换获得
    , exchange_num = 0 %% 兑换次数
}).

%%------------------特权炫装------------------
-record(base_act_equip_sell, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , list = []  %%[#base_new_exchange_sub{}]
}).

-record(base_act_equip_sell_sub, {
    id = 0
    , page = 0
    , dec = ""
    , goods_info = [] %% [{GoodsId, GoodsNum}]
    , sell_num = 0
    , price = 0
    , cbp = 0
    , bind = 0
}).

-record(st_equip_sell, {
    pkey = 0
    , act_id = 0
    , buy_list = [] %% [{序号ID，num}]
}).

%%-----------------护送活动-----------------
-record(base_act_convoy, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , convoy_num = 0
    , reward_list = [] %%[{goods_num, goods_id}]
}).

-record(st_act_convoy, {
    pkey = 0
    , act_id = 0 %% 子活动id
    , convoy_num = 0 %% 护送次数
    , is_recv = 0 %% 是否已经领取
    , op_time = 0 %% 操作时间
}).

%%-----------------大额充值------------------
-record(base_acc_charge_d, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , gift_list = [] %%[{AccChargeVal, [{goods_num, goods_id}]}]
}).

-record(st_acc_charge_d, {
    pkey = 0,
    acc_val = 0,  %%累计充值额度
    act_id = 0,  %%子活动id
    get_acc_ids = [],  %%已领取的累计充值活动id
    time = 0
}).

%%----------------消费返充值比例---------------
-record(base_consume_back_charge, {
    id = 0 %% 序号
    , charge_gold = 0 %% 充值钻石
    , back_num = 0 %% 返利次数
    , power = 0 %% 权重
    , act_type = 0 %% 活动类型
}).

-record(base_act_consume_back_charge, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_type_info = [] %% [{渠道号，活动类型}] 渠道号默认为0则开放 处理ios和安卓混服需求
    , act_type = 0
    , act_id = 0
    , list = [] %%[{BackNum,Consume}]
}).

-record(st_consume_back_charge, {
    pkey = 0
    , act_id = 0
    , consume_gold = 0 %% 当前消耗的元宝
    , back_num = 0 %% 已经返还的次数,还未使用
    , back_gold = 0 %% 返还总元宝数
    , back_list = [] %% 当天抽中的列表 [{charge_gold, percent, is_use}]
    , log = [] %% 日志 [{charge_gold, percent, is_use, out_time}]
    , op_time = 0
    , is_db = 0 %% 是否入库
}).

-define(CONSUME_BACK_CHARGE_MAX_NUM, 10).

%%---------单服消费活动---------
-define(CONSUME_RANK_LIMIT, 50).

-record(base_consume_rank, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , rank_info = []
}).

-record(st_consume_rank, {
    pkey = 0
    , act_id = 0 %% 子活动id
    , consume_gold = 0 %% 消费元宝
    , change_time = 0
    , name = ""
    , lv = 0
}).

%%消费排行榜玩家信息结构
-record(consume_rank_info, {
    pkey = 0,
    name = "",
    consume_gold = 0,
    rank = 0,
    change_time = 0,
    lv = 0
}).

-record(rank_info, {
    top = 0,
    down = 0,
    limit = 0,
    reward = []
}).

%%---------单服充值活动---------
-define(RECHARGE_RANK_LIMIT, 50).
-record(base_recharge_rank, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , rank_info = []  %% [#rank_info{}]
}).

-record(st_recharge_rank, {
    pkey = 0
    , act_id = 0 %% 子活动id
    , recharge_gold = 0 %% 充值元宝
    , change_time = 0
    , name = ""
    , lv = 0
}).

%%充值排行榜玩家信息结构
-record(recharge_rank_info, {
    pkey = 0,
    name = "",
    recharge_gold = 0,
    rank = 0,
    change_time = 0,
    lv = 0
}).


%%---------结婚榜活动---------
-record(base_marry_rank, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , reward_list = []
}).
-record(st_marry_rank, {
    pkey = 0
    , act_id = 0 %% 子活动id
    , rank = 0 %% 排名
    , state = 0 %% 领取状态 0不可领取 1可领取 2已领取
    , record_time = 0
}).
%%结婚排行榜玩家信息结构
-record(marry_rank_info, {
    bpkey = 0,
    bname = "",
    bavatar = "",
    gpkey = 0,
    gname = "",
    gavatar = "",
    rank = 0,
    marry_time = 0
}).

%%---------跨服消费榜活动---------
-define(CROSS_CONSUME_RANK_LIMIT, 50).

-record(cross_consume_rank_log, {
    sn = 0,
    pkey = 0,
    nickname = <<>>,
    consume_gold = 0,
    change_time = 0,
    rank = 0,
    lv = 0
}).

-record(st_cross_consume_rank, {
    pid_list = [],
    log_list = [],  %% [#cross_consume_rank_log{}..]
    rank_list = [],
    reward_list = [],
    ref = [],
    is_change = 0
}).


-record(base_act_cross_consume_rank, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , rank_info = []
}).

-record(base_cross_consume_rank, {
    id = 0
    , must = 0
    , award = []
}).

%%---------跨服充值榜活动---------
-define(CROSS_RECHARGE_RANK_LIMIT, 50).

-record(cross_recharge_rank_log, {
    sn = 0,
    pkey = 0,
    nickname = <<>>,
    recharge_gold = 0,
    change_time = 0,
    lv = 0,
    rank = 0
}).

-record(st_cross_recharge_rank, {
    pid_list = [],
    log_list = [],  %% [#cross_recharge_rank_log{}..]
    rank_list = [],
    reward_list = [],
    ref = [],
    is_change = 0
}).

-record(base_act_cross_recharge_rank, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , rank_info = []
}).

-record(base_cross_recharge_rank, {
    id = 0
    , must = 0
    , award = []
}).


%% 区域充值榜

%%---------跨服充值榜活动---------
-define(AREA_RECHARGE_RANK_LIMIT, 50).

-record(area_recharge_rank_log, {
    sn = 0,
    pkey = 0,
    nickname = <<>>,
    recharge_gold = 0,
    change_time = 0,
    lv = 0,
    rank = 0
}).

-record(st_area_recharge_rank, {
    pid_list = [],
    log_list = [],  %% [#cross_recharge_rank_log{}..]
    rank_list = [],
    reward_list = [],
    ref = [],
    is_change = 0
}).

-record(base_act_area_recharge_rank, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , rank_info = []
}).

-record(base_area_recharge_rank, {
    id = 0
    , must = 0
    , award = []
}).


%%---------区域跨服消费榜活动---------
-define(AREA_CONSUME_RANK_LIMIT, 50).

-record(area_consume_rank_log, {
    sn = 0,
    pkey = 0,
    nickname = <<>>,
    consume_gold = 0,
    change_time = 0,
    rank = 0,
    lv = 0
}).

-record(st_area_consume_rank, {
    pid_list = [],
    log_list = [],  %% [#cross_consume_rank_log{}..]
    rank_list = [],
    reward_list = [],
    ref = [],
    is_change = 0
}).


-record(base_act_area_consume_rank, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , rank_info = []
}).

-record(base_area_consume_rank, {
    id = 0
    , must = 0
    , award = []
}).


%%------------仙境迷宫---------------
-record(base_xj_map, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , act_type = 0 %% 活动类型
    , goods_list = [] %% 展示奖励列表
    , saizi_list = [] %% 骰子权值列表
    , free_go_num = 0 %% 每日免费寻宝次数
    , one_go_cast = 0 %% 寻1次宝花费元宝
    , one_go_consume = 0 %% 寻1次花费卷
    , reset_num = 0 %% 每日重置次数
    , one_reset_cast = 0 %% 重置一次花费元宝
    , reset_reward_list = []  %%重置奖励
}).

-record(st_xj_map, {
    pkey = 0
    , act_id = 0
    , use_free_num = 0 %% 使用过的免费次数
    , use_reset_num = 0 %% 使用过的充值次数
    , step = 0 %% 当前步数
    , op_time = 0
}).

-record(ets_xj_map, {
    pkey = 0,
    nickname = "",
    log_list = []
}).

-define(ETS_XJ_MAP, ets_xj_map).

-record(base_xj_map_reward, {
    id = 0
    , order_id = 0
    , reward_type = 0
    , goods_list = []
    , p = 0
}).

-record(st_flower_rank, {
    log_list = [],  %% [#flower_rank_log{}..]
    rank_give_list = [],
    rank_get_list = [],
    reward_list = []
}).

-record(flower_rank_log, {
    pkey = 0,
    nickname = <<>>,
    sex = 0,
    avatar = "",
    give = 0,
    get = 0,
    give_rank = 0,
    get_rank = 0,
    give_change_time = 0,
    get_change_time = 0
}).

-record(player_flower_rank_log, {
    pkey = 0,
    act_id = 0,
    give = 0,
    get = 0,
    give_list = [],
    get_list = []
}).

-record(base_act_flower_rank, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , give_list = [] %% [#base_flower_rank{}..]
    , get_list = [] %% [#base_flower_rank{}..]
    , get_rank_info = []
    , give_rank_info = []
}).

-record(base_flower_rank, {
    id = 0
    , must = 0
    , award = []
}).

%% 连续充值配置
-record(base_act_con_recharge, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , gold_list = []
    , daily_list = [] %% 每日奖励 [#base_con_recharge_award{}]
    , cum_list = []  %% 连续奖励 [#base_con_recharge_award{}]
    , day_list = []
    , cum_recharge = [] %% [{id,gold,need_gold}]
}).

%% 奖励基础
-record(base_con_recharge_award, {
    id = 0
    , day = 0 %% 天数
    , gold = 0 %% 元宝数
    , award = [] %% 奖励 [{GoodsId,GoodsNum}]
}).

%%玩家连续充值
-record(st_con_recharge, {
    pkey = 0
    , act_id = 0
    , recharge_list = [] %% [{天数,充值额度}]
    , award_list = [] %% 已领取累充奖励列表 [id1,id2]
    , daily_list = [] %% 每天已领取列表 [id1,id2]
    , act_list = [] %% 已经大额激活列表 [{id,gold,state}]
    , change_time = 0
}).

%%金银塔
-record(st_gold_silver_tower, {
    pkey = 0
    , act_id = 0
    , count_list = 0 %% 当前层抽奖次数
    , index_floor = 0 %% 当前层数
}).


%% 金银塔
-record(base_gold_silver_tower, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , cost_one = 0  %%单次价格
    , cost_ten = 0  %%十次价格
    , cost_fifty = 0  %%五十次价格
    , fashion_id = 0 %% 展示时装id
    , reward_list = [] %% [#base_gold_silver_tower_goods{}]
}).

%%  金银塔
-record(base_gold_silver_tower_goods, {
    floor = 0 %% 层数
    , lower = 0 %% 伪随机下限
    , up = 0 %% 伪随机上限
    , reset_id = 0 %% 重置id
    , goods_list = [{0, 0, 0, 0}] %% [{编号id,物品id,物品数量,权值}]
}).

%% 红装兑换
-record(base_red_goods_exchange, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , cost_id = 0 %% 材料id
    , exchange_list = [] %% [{编号,位置,消耗数量,物品id,得到数量}...]
}).
%% 红装兑换物品
-record(base_red_goods_exchange_list, {
    id = 0, %% 编号
    index = 0 %% 位置
}).

%% 碎片兑换
-record(base_debris_exchange, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , cost_id = 0 %% 材料id
    , exchange_list = [] %% [{编号,位置,消耗数量,物品id,得到数量}...]
}).

%% 碎片兑换物品
-record(base_debris_exchange_list, {
    id = 0, %% 编号
    index = 0, %% 位置
    cost_num = 0, %% 消耗数量
    goods_id = 0, %% 物品id
    get_num = 0 %% 得到数量
}).


%% 招财进宝
-record(st_buy_money, {
    pkey = 0
    , coin_free_num = 0 %% 招财过的免费次数
    , coin_all_num = 0 %% 招财过的总次数(不含免费)
    , xinghun_free_num = 0 %% 进宝过的免费次数
    , xinghun_all_num = 0 %% 进宝过的总次数(不含免费)
    , online_time = 0 %% 当日内在线时间
    , last_login_time = 0
}).


-record(base_buy_money, {
    id = 0,
    cost = 0,
    reward = 0,
    luck_list = [] %% [{倍率,权值}]
}).

%%-----------------------合服活动相关-----------------------------------------
%% 合服之首充团购
-record(base_merge_group_charge, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , charge_list = [] %% [{GroupNum, ChargeGold, GiftId}]
}).

-record(st_merge_act_group_charge, {
    pkey = 0,
    act_id = 0,
    recv_list = [], %% [{充值人数, 额度}]
    charge_list = [],
    op_time = 0
}).

-define(ETS_MERGE_GROUP_CHARGE, ets_merge_group_charge).
-record(ets_merge_group_charge, {
    key = {0, 0, 0}, %% {act_id, base_charge_num, base_charge_gold}
    act_id = 0,
    base_charge_num = 0,
    base_charge_gold = 0,
    charge_num = 0,
    player_list = [] %% 充值玩家信息
}).

%%合服进阶目标
-record(base_merge_up_target, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , list = [] %% [{act_type, 参数, [{GoodsId, GoodsNum, Time}]}]
}).

%% 进阶目标
-record(st_merge_act_up_target, {
    pkey = 0,
    act_id = 0,
    recv_list = [], %% [{act_type, 条件参数}]
    op_time = 0
}).

%% 进阶目标2
-record(st_merge_act_up_target2, {
    pkey = 0,
    act_id = 0,
    recv_list = [], %% [{act_type, 条件参数}]
    op_time = 0
}).

%% 进阶目标3
-record(st_merge_act_up_target3, {
    pkey = 0,
    act_id = 0,
    recv_list = [], %% [{act_type, 条件参数}]
    op_time = 0
}).

-define(MERGE_UP_TARGET_MOUNT, 1). %% 坐骑进阶
-define(MERGE_UP_TARGET_WING, 2).  %% 仙羽进阶
-define(MERGE_UP_TARGET_MAGIC_WEAPON, 3). %% 法宝进阶
-define(MERGE_UP_TARGET_LIGHT_WEAPON, 4). %% 神兵进阶
-define(MERGE_UP_TARGET_PET_WEAPON, 5). %% 妖灵
-define(MERGE_UP_TARGET_PET_UP_LV, 6). %% 宠物进阶
-define(MERGE_UP_TARGET_PET_UP_STAR, 7). %% 宠物升星
-define(MERGE_UP_TARGET_FOOTPRINT, 8). %%足迹进阶
-define(MERGE_UP_TARGET_CAT_UP_LV, 9). %%灵猫进阶
-define(MERGE_UP_TARGET_GOLDEN_BODY_UP_LV, 10). %%金身进阶
-define(MERGE_UP_TARGET_GOD_TREASURE_UP_LV, 11). %%仙宝进阶
-define(MERGE_UP_TARGET_JADE_UP_LV, 12). %%玉佩进阶
-define(MERGE_UP_TARGET_BABY_WING, 13). %% 灵羽进阶
-define(MERGE_UP_TARGET_BABY_MOUNT, 14). %% 灵骑进阶
-define(MERGE_UP_TARGET_BABY_WEAPON, 15). %% 灵弓进阶

%% 合服之累充活动
-record(base_merge_acc_charge, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , charge_list = [] %% [{AccChargeGold,GiftId}]
}).

-record(st_merge_act_acc_charge, {
    pkey = 0,
    act_id = 0,
    recv_list = [], %% 已领取的奖励
    acc_charge_gold = 0, %% 累充钻石
    op_time = 0 %% 上次写库时间
}).

%% 合服活动返利抢购
-record(base_merge_act_back_buy, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , act_type = 0 %% 活动索引类型
}).

-record(st_merge_back_buy, {
    pkey = 0
    , act_id = 0
    , buy_list = [] %% [{id, num}]
    , op_time = 0
}).

-define(ETS_MERGE_BACK_BUY, ets_merge_back_buy).
-record(ets_merge_back_buy, {
    key = {0, 0} %% {act_id, order_id}
    , act_id = 0
    , order_id = 0
    , total_num = 0 %% 系统抢购次数
}).

%% 合服活动帮派争霸
-record(base_merge_act_guild_rank, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , list = [] %% [{rank, 1帮主2成员，gift_id}]
}).

%% 合服活动兑换
-record(st_merge_exchange, {
    pkey = 0,
    act_id = 0,  %%子活动id
    exchange_list = [],  %%已领取的累计充值活动id
    op_time = 0
}).

-record(base_merge_exchange, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , list = []  %%[#base_merge_exchange_sub{}]
}).

-record(base_merge_exchange_sub, {
    id = 0 %%
    , exchange_cost = [] %% 兑换消耗
    , exchange_get = [] %% 兑换获得
    , exchange_num = 0 %% 兑换次数
}).

%%--------------------------------------------------------
-record(ets_act_info, {
    open_day = 0,
    act_info = []
}).
-define(ETS_ACT_OPEN_INFO, ets_act_open_info).

-define(ACT_INFO_LIST, [1, 2, 3, 4, 5, 6, 7]).
-define(ACT_UP_TARGET_ONE, 1). %% 进阶目标1
-define(ACT_UP_TARGET_TWO, 2). %% 进阶目标2
-define(ACT_UP_TARGET_THREE, 3). %% 进阶目标3
-define(ACT_BACK_BUY, 4). %% 返利抢购
-define(ACT_UPLV_BOX, 5). %% 进阶宝箱
-define(ACT_ACC_CHARGE, 6). %% 累积充值
-define(ACT_ACC_CONSUME, 7).%%累计消费
%%-------------------------------------------------------------------

-define(ETS_ACT_WEALTH_CAT_LOG, ets_act_wealth_cat_log).

-record(base_wealth_cat, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , vals = [] %% 赌注
    , ratio_list = [] %% [{id,倍数,权值}]
}).


-record(act_wealth_cat_log, {
    act_id = 0,
    log = [] %% [[nickname, cost，ratio]]
}).


-record(base_merge_day7, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , day = 0
    , reward = []
}).

-record(st_merge_day7, {
    pkey = 0,  %%玩家key
    day_list = []  %% 已领取天数 [{day,times}]
}).

%%-----------------------------------------------------------
%% 副本双倍奖励活动
-record(base_act_dungeon_double, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
}).

%% 仙境寻宝双倍活动
-record(base_act_xj_map_double, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
}).

%% 掉落活动
-record(base_act_mon_drop, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
}).

%%基本配置表
-record(base_hi_config, {
    id = 0,
    desc = "",
    type = 0,
    val = 0,
    fun_id = {0, 0},
    time_limit = 0,
    condition = []      %%触发参数
}).

%%全名嗨翻天配置
-record(base_hi_fan_tian, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , award_list = []  %%{id,积分档,[{物品ID,物品数量}]}
}).


%%幸运转盘配置
-record(base_act_lucky_turn, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , award_list = []  %%{{次数区间1,次数区间2},[{物品ID,物品数量,权重,是否发送传闻}]}
    , score_list = []  %%{物品ID,物品数量,兑换积分,兑换上限制}
    , free_time = 0     %% 免费次数
    , one_cost = 0
    , one_score = 0
    , ten_cost = 0
    , ten_score = 0
    , one_back = 0     %%没有的字段
    , ten_back = 0     %%字段没用了
    , backlist = []
    , initgold = 0
}).


-record(base_free_gift, {
    act_id = 0,     %% 活动id
    type = 0,       %% 档次
    state = 0,      %% 状态 0未购买，1已购买未发送 2已发送
    buy_time = 0,   %% 购买时间戳
    delay_day = 0,  %% 延迟天数
    desc = "",      %% 描述
    reward = []     %% 奖励物品
}).

-record(st_free_gift, {
    pkey = 0,
    list = []  %% [#base_free_gift]
}).

%%
-record(base_act_free_gift_help, {
    cost = 0,
    type = 0,       %% 类型
    delay_day = 0,  %% 延迟天数
    reward = [],    %% 奖励物品
    re_reward = [], %% 返回物品
    desc = ""       %% 描述
}).

-record(base_act_free_gift, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , gift_list = #base_act_free_gift_help{}
}).



-record(base_new_free_gift, {
    act_id = 0,     %% 活动id
    type = 0,       %% 档次
    state = 0,      %% 状态 0未购买，1已购买未发送 2已发送
    buy_time = 0,   %% 购买时间戳
    delay_day = 0,  %% 延迟天数
    desc = "",      %% 描述
    reward = []     %% 奖励物品
}).

-record(st_new_free_gift, {
    pkey = 0,
    list = []  %% [#base_free_gift]
}).

%%
-record(base_act_new_free_gift_help, {
    cost = 0,
    type = 0,       %% 类型
    delay_day = 0,  %% 延迟天数
    reward = [],    %% 奖励物品
    re_reward = [], %% 返回物品
    desc = ""       %% 描述
}).

-record(base_act_new_free_gift, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , gift_list = #base_act_new_free_gift_help{}
}).









-define(ETS_ACT_NEW_WEALTH_CAT_LOG, ets_act_new_wealth_cat_log).

-record(base_new_wealth_cat, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , vals = [] %% [#base_new_wealth_cat_help{}]
}).

-record(act_new_wealth_cat_log, {
    act_id = 0,
    log = [] %% [[nickname, cost，ratio]]
}).

-record(base_new_wealth_cat_help, {
    id = 0
    , val = 0 %% 赌注
    , ratio_list = [] %% [{id,倍数,权值}]
}).
-record(st_new_wealth_cat, {
    act_id = 0
    , pkey = 0
    , id = 1 %% 当前档位
}).


%%-------------------疯狂砸蛋--------------------
-define(ETS_ACT_THROW_EGG_LOG, ets_act_throw_egg_log).

-record(act_throw_egg_log, {
    act_id = 0,
    log = [] %% [[nickname, goods_id，goods_num]]
}).

-record(st_act_throw_egg, {
    act_id = 0
    , pkey = 0
    , egg_info = [] %% 蛋池信息
    , count = 0 %% 今日次数
    , count_list = [] %% 次数奖励领取状态 [{编号id,次数,状态(1已领取)}]
    , is_free = 0 %% 是否免费 0未使用 1已使用
    , re_set_count = 0 %% 刷新次数
    , online_time = 0 %% 操作时间
    , last_login_time = 0
}).

-record(base_act_throw_egg, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , cost = 0 %% 砸蛋花费
    , online_time_reward = 0 %% 免费砸蛋所需时间
    , re_cost = 0 %% 刷新花费
    , free_reset_count = 0 %% 免费刷新次数
    , count_reward = [] %%次数奖励 [{编号id,次数,goods_id,goods_num}]
    , general_reward = [] %%普通蛋奖励 [{goods_id,goods_num,ratio}]
    , sp_reward = [] %%极品蛋奖励 [{goods_id,goods_num,ratio}]
    , egg_ratio = 0 %% 特殊蛋概率
}).

%%-------------------------------------------
%%---------------天宫寻宝--------------------
-define(ETS_ACT_WELKIN_HUNT, ets_act_welkin_hunt).

-record(act_welkin_hunt_log, {
    act_id = 0,
    log = [] %% [[nickname, goods_id，goods_num]]
}).

-record(st_act_welkin_hunt, {
    act_id = 0
    , pkey = 0
    , score = 0
    , count = 0
    , log_list = []
}).

-record(base_act_welkin_hunt, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , goods_cost = 0
    , reward_list = []  %% [#base_act_welkin_hunt_help{}]
    , exchange_list = []  %% [{编号id,score,goods_id,goods_num}]
}).

-record(base_act_welkin_hunt_help, {
    up = 0,
    down = 0,
    reward_list = [], %% 奖励列表 [{goods_id,goods_num,ratio}]
    sp_list = [] %% 特殊物品列表
}).

%%
-record(st_luck_turn, {
    act_id = 0
    , pkey = 0
    , score = 0
    , ex_list = []      %%[{下标,兑换次数}]
    , draw_time = 0     %% 抽奖次数
}).

%% 跨服转盘
-record(cross_st_luck_turn, {
    act_id = 0,         %%活动ID
    gold = 0,           %%奖池
    log_list = []       %%中奖日志
}).
%%%神秘商城
-define(MYSTERY_SHOP_ORDER_MAX, 9). %% 最大九个格子
-record(st_mystery_shop, {
    pkey = 0
    , act_id = 0
    , shop_info = [] %% 当前商城列表 [{Order, _OldOrderRefreshNum, OrderGoodsId, OrderGoodsNum, OrderPrice, OrderIsRarity, IsBuy}]
    , refresh_num = 0 %% 玩家当前总的刷新次数
    , refresh_time = 0 %% 商城刷新时间
    , recv_refresh_reward = [] %% 领取的刷新次数奖励 [base_refresh_num]
    , buy_num = 0
    , op_time = 0
}).

-record(base_mystery_shop, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , show_list = [] %% [{GoodsId, Flag}] Flag 0普通1珍惜
    , refresh_cost = 0 %% 单次刷新花费
    , refresh_cd_time = 0 %% 免费刷新cd时间
    , act_type = 0 %% 活动类型索引
}).

%% 限时礼包活动
-record(base_limit_time_gift, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , list = [] %% [#base_limit_time_gift_sub{}]
}).


-record(base_limit_time_gift_sub, {
    id = 0
    , desc = "" %% 描述
    , cost_gold = 0 %% 现价元宝
    , base_cost_gold = 0 %% 原价元宝
    , sell_list = []
    , buy_num = 0
}).

-record(st_limit_time_gift, {
    pkey = 0,
    act_id = 0,
    buy_list = [], %% [{ID, Num}]
    op_time = 0
}).


-record(base_act_baby_equip_sex, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
}).

%% 小额充值推送
-record(base_act_small_charge, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , list = [] %% [{GoldNum, [{GoodsId, GoodsNum}], LimitBuyNum}]
}).

-record(st_act_small_charge, {
    pkey = 0,
    act_id = 0,
    charge_list = [],
    recv_list = [],
    buy_num = 0,
    op_time = 0
}).

%% 一元夺宝
-record(base_act_one_gold_buy, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , act_type = 0 %% 活动索引类型
    , reward_list = [] %% [{BuyNum,GoodsId, Num}]
    , price_list = [] %% [{BuyNum,SumGold}]
}).

%% 一元夺宝的商品信息
-record(base_one_gold_goods, {
    id = 0, %% 序号
    act_type = 0, %% 活动索引类型
    act_num = 0, %% 轮次
    act_time = 0, %% 持续时间 单位秒
    act_start_time = {0, 0, 0}, %% 开始时间 单位小时 {hour,min,sec}
    goods_id = 0, %% 商品ID
    goods_num = 0, %% 商品数量
    total_num = 0, %% 总的购买次数
    order_id = 0 %% 商架序号
}).

-define(ETS_ONE_GOLD_GOODS, ets_one_gold_goods).
-define(ONE_GOLD_BUY_READY, 0). %%准备
-define(ONE_GOLD_BUY_START, 1). %%开启
-define(ONE_GOLD_BUY_END, 2). %%结束
-define(ONE_GOLD_BUY_CLOSE, 3). %%关闭

%% 一元夺宝 ets 结构
-record(ets_one_gold_goods, {
    key = {0, 0, 0, 0}, %% {act_id, act_type, act_num, order_id}
    act_id = 0,
    act_type = 0, %% 活动索引类型
    act_num = 0, %% 轮次
    order_id = 0, %% 商架序号
    goods_id = 0, %% 商品ID
    goods_num = 0, %% 商品数量
    total_num = 0, %% 总的购买次数
    buy_list = [], %% 购买记录[{pkey, sn, nickname, buynum}]
    log = [], %% 中奖日志 [{pkey, sn, nickname, buynum}]
    op_time = 0
}).
%% 玩家私有数据
-record(st_one_gold_buy, {
    pkey = 0,
    act_id = 0,
    buy_num = 0,
    recv_list = [], %% [num]
    op_time = 0
}).

-record(st_hi_fan, {
    pkey = 0,
    act_id = 0,
    val = 0, %% hi点
    list = [],
    last_login_time = 0
}).

%% 广告展示
-record(base_display, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , display_id = {0, 0, 0}
}).

%% 节日活动之登陆有礼
-record(base_festival_login_gift, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , list = [] %% [{天数，奖励}]
}).

-record(st_festival_login_gift, {
    pkey = 0
    , act_id = 0
    , login_day_num = 1
    , charge_gold = 0
    , recv_list = [] %% [{天数,领取次数}]
    , op_time = 0
}).

%% 节日活动之累充
-record(base_festival_acc_charge, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , charge_list = [] %% [{AccChargeGold,GiftId}]
}).

-record(st_festival_act_acc_charge, {
    pkey = 0,
    act_id = 0,
    recv_list = [], %% 已领取的奖励
    acc_charge_gold = 0, %% 累充钻石
    op_time = 0 %% 上次写库时间
}).

%% 节日活动返利抢购
-record(base_festival_act_back_buy, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , act_type = 0 %% 活动索引类型
}).

-record(base_festival_back_buy, {
    id = 0 %% 序号
    , order_id = 0 %% 下标
    , act_type = 0 %% 活动索引类型
    , goods_id = 0 %% 商品ID
    , goods_num = 0 %% 商品数量
    , hour = 0 %% 0非限时 N小时数
    , sys_limit_num = 0 %% 系统限购次数
    , limit_num = 0 %% 个人限购次数
    , discount = 0 %% 折扣
    , base_price = 0 %% 原价
    , price = 0 %% 现价
}).

-record(st_festival_back_buy, {
    pkey = 0
    , open_day = 0
    , buy_list = [] %% [{id, num}]
    , op_time = 0
}).

-define(ETS_FESTIVAL_BACK_BUY, ets_festival_back_buy).
-record(ets_festival_back_buy, {
    key = {0, 0} %% {open_day, order_id}
    , open_day = 0
    , order_id = 0
    , total_num = 0 %% 系统抢购次数
}).

%%-------------------节日活动之财神挑战-----------
-record(base_festival_challenge_cs, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , gold = 0
    , bgold = 0
    , consume_goods_id = 0
    , consume_goods_num = 0
}).

%%--------------------节日活动之神秘兑换----------
-record(st_festival_exchange, {
    pkey = 0,
    act_id = 0,  %%子活动id
    exchange_list = [],  %%已领取的累计充值活动id
    op_time = 0
}).

-record(base_festival_exchange, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , list = []  %%[#base_festival_exchange_sub{}]
}).

-record(base_festival_exchange_sub, {
    id = 0 %%
    , exchange_cost = [] %% 兑换消耗
    , exchange_get = [] %% 兑换获得
    , exchange_num = 0 %% 兑换次数
}).


%%--------------------节日活动之红包雨------------
-record(base_act_festival_red_gift, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , open_list = []  %%[Hour1, Hour2, ... ]
    , exchange_score = {0, 0} %% {ScoreMin, ScoreMax}
}).

-record(base_festival_red_gift, {
    id = 0, %% 红包序号
    score_min = 0, %% 积分下限
    score_max = 0, %% 积分上限
    rank_1_gift = [], %% 第一名特殊红包[{goods_id, goods_num}]
    gift_info = [], %% 红包信息 [{GoodsId, GoodsNum, RedGiftNum}]
    gift_sum = 0 %% 红包总数量
}).

%% 玩家红包私有数据
-record(st_festival_red_gift, {
    pkey = 0,
    act_id = 0,
    recv_list = [],
    op_time = 0
}).

-record(red_gift, {
    id = 0
    , type = 0 %% 红包种类1第一名特殊红包2普通红包
    , goods_list = []
}).

-define(FESTIVAL_RED_GIFT_RANK_1, 9999). %% 第一名特殊红包优先级为最高
-define(ETS_FESTIVAL_RED_GIFT, ets_festival_red_gift).

%% ets玩家领取红包缓存
-record(ets_festival_red_gift, {
    key = {0, 0} %% {Id, Pkey}
    , id = 0 %% 红包ID
    , pkey = 0
    , sn = 0
    , career = 0
    , avatar = "" %% 头像地址
    , sex = 0
    , nickname = ""
    , head_id = 0 %% 头饰ID
    , red_gift = [] %% 红包内容
    , recv_time = 0 %% 领取时间
    , rank = 0 %% 排名
    , type = 0 %% 红包种类1第一名特殊红包2普通红包
}).

%% 玩家当天充值数据
-record(st_act_charge, {
    pkey = 0,
    charge_list = [],
    op_time = 0
}).

%%-------------------水果大战--------------------
-define(ETS_ACT_THROW_FRUIT_LOG, ets_act_throw_fruit_log).

-record(act_throw_fruit_log, {
    act_id = 0,
    log = [] %% [[nickname, goods_id，goods_num]]
}).

-record(st_act_throw_fruit, {
    act_id = 0
    , pkey = 0
    , fruit_info = [] %% 蛋池信息
    , count = 0 %% 今日次数
    , count_list = [] %% 次数奖励领取状态 [{编号id,次数,状态(1已领取)}]
    , is_free = 0 %% 是否免费 0未使用 1已使用
    , re_set_count = 0 %% 刷新次数
    , online_time = 0 %% 操作时间
    , last_login_time = 0
}).

-record(base_act_throw_fruit, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , cost = 0 %% 砸蛋花费
    , online_time_reward = 0 %% 免费砸蛋所需时间
    , re_cost = 0 %% 刷新花费
    , free_reset_count = 0 %% 免费刷新次数
    , count_reward = [] %%次数奖励 [{编号id,次数,goods_id,goods_num}]
    , general_reward = [] %%普通蛋奖励 [{goods_id,goods_num,ratio}]
    , sp_reward = [] %%极品蛋奖励 [{goods_id,goods_num,ratio}]
    , fruit_ratio = 0 %% 特殊蛋概率
}).


%% 充值有礼
-record(base_recharge_inf, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , val = 0
    , rank_info = []
}).


%% ----------------在线有礼------------------
-record(base_online_reward, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , time_list = [] %% 时间
    , reward = [] %% [{id,goods_id,goods_num,ratio}]
}).

%% 在线有礼
-record(st_online_reward, {
    pkey = 0
    , use_count = 0 %% 已经使用次数
    , online_time = 0 %% 当日内在线时间
    , reward = [] %% 已领取编号列表 [Id1,Id2]
    , last_login_time = 0
}).


%% ----------------在线有礼------------------

%% ----------------每日任务------------------
-define(ACT_FLIP_CARD, 1).
-define(CHALLENGE_CS, 2).
-record(base_daily_task, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , award_list = []  %%{id,类型,次数,[{物品ID,物品数量}]}
}).

%% 每日任务
-record(st_act_daily_task, {
    pkey = 0
    , trigger_list = []  %% 触发列表 [{Tid,Count}]
    , get_list = []     %% 已经领取列表
    , last_login_time = 0
}).


%% -----------------幸运翻牌---------------------
-record(base_act_flip_card, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , cost = 0
    , ratio_list = [] %% 权值列表 [{相同卡数,权值}]
    , reward_list = [] %% [{id,goods_id,goods_num,ratio}]
    , luck_reward = [] %% [{相同卡数,[{goods_id,goods_num}]},{相同卡数,[{goods_id,goods_num}]}]
}).

-record(st_act_flip_card, {
    pkey = 0
    , same_flag = 1    %% 相同标记
    , card_list = []    %% 卡列表 [{id,state,goods_id,goods_num}]
    , log_list = []
    , last_login_time = 0
}).

%% 双倍充值
-record(base_double_gold, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , mul = 0 %% 倍数
}).

%% 双倍充值
-record(base_new_double_gold, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , mul = 0 %% 倍数
}).

-record(ets_act_time, {local_time = 0, time = 0}).


%% 额外特惠活动
-record(base_act_other_charge, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , charge_list = [] %% [{Id,AccChargeGold,GoodsList}]
}).

-record(st_act_other_charge, {
    pkey = 0,
    act_id = 0,
    recv_list = [], %% 已领取的奖励
    acc_charge_gold = 0, %% 累充钻石
    op_time = 0 %% 上次写库时间
}).

%% 超值特惠活动
-record(base_act_super_charge, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , charge_list = [] %% [{AccChargeGold,GiftId}]
}).

-record(st_act_super_charge, {
    pkey = 0,
    act_id = 0,
    recv_list = [], %% 已领取的奖励
    acc_charge_gold = 0, %% 累充钻石
    op_time = 0 %% 上次写库时间
}).

%% 等级返利
-record(base_act_lv_back, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , award_list = []
}).


%%
-record(st_lv_back, {
    act_id = 0
    , pkey = 0
    , buy_id = 0
    , get_award_id = []
}).


%% 神树
-record(st_act_mystery_tree, {
    act_id = 0
    , pkey = 0
    , score = 0
    , count = 0
    , log_list = []
}).

-record(base_act_mystery_tree, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , goods_cost = 0
    , reward_list = []  %% [#base_act_mystery_tree_help{}]
    , exchange_list = []  %% [{编号id,score,goods_id,goods_num}],
    , free_time = 0
    , free_list = []
}).

-record(base_act_mystery_tree_help, {
    up = 0,
    down = 0,
    reward_list = [], %% 奖励列表 [{goods_id,goods_num,ratio}]
    sp_list = [] %% 特殊物品列表
}).


%% 记录玩家参与活动的信息
-record(campaign_join_log, {
    id,            %% {role_id, campid,act_id}
    info = []    %% 玩家参与的信息, 格式根据活动配置
}).


%% 节日boss基础数据
-record(base_act_festive_boss, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , camp_id = 0      %% 活动ID
    , act_id = 0       %% 活动子ID
    , readytime = []   %%活动准备时间
    , opentime = []    %% 活动开启时间
    , endtime = []     %% 活动结束时间
    , monids = []      %% 怪物ID
    , kill_award = []   %%击杀奖励
    , show_award = []   %% 奖励显示
    , maxtired = 0      %%最大疲劳度
}).

%% 节日boss 刷新点
-record(base_act_festive_boss_pos, {
    scene_id = 0,
    pos = []
}).

%% 财神单笔充值
-record(base_cs_charge_d, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , list = []
}).

-record(base_cs_charge_d_sub, {
    login_flag = all
    , num = 0
    , charge_gold = 0
    , reward_list = []
}).

-record(st_cs_charge_d, {
    pkey = 0,
    act_id = 0,
    charge_list = [],
    recv_list = [],
    buy_num = 0,
    op_time = 0
}).

%% 单笔充值3档(小额单笔充值)
-record(base_small_charge_d, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , list = []
}).

-record(base_small_charge_d_sub, {
    login_flag = all
    , num = 0
    , charge_gold = 0
    , reward_list = []
}).

-record(st_small_charge_d, {
    pkey = 0,
    act_id = 0,
    charge_list = [],
    recv_list = [], %% [{ChargeGold, Num}]
    buy_num = 0,
    op_time = 0
}).

%% 聚宝盆
-record(base_act_jbp, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , list = [] %% #base_act_jbp_sub{}
}).

-record(base_act_jbp_sub, {
    id = 0
    , login_flag = all
    , charge_gold = 0
    , list = [] %% [{DayNum, RewardList}]
}).

-record(st_act_jbp, {
    pkey = 0,
    act_id = 0,
    charge_list = [], %% [{ChargeGold, Time}]
    recv_list = [], %% [{{Id, Day}, Time}}]
    op_time = 0
}).

%% 限时仙装活动
-record(base_act_limit_xian, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , show_id = 0 %% 显示类型
    , one_cost = 0 %% 单抽消耗
    , ten_cost = 0 %% 十连抽消耗
    , reward_list = [] %% 奖池数据[{Gid, Gnum, OnePower, TenPower}]
    , score_list = [] %% {Min, Max, RewardList}
    , rank_list = [] %% {Rank, MinScore, RewardList}
}).

-record(st_act_limit_xian, {
    pkey = 0
    , act_id = 0
    , score = 0 %% 积分
    , recv_list = [] %% 领取过的档次积分
    , op_time = 0
}).

-define(ETS_LIMIT_XIAN, ets_limit_xian).

-record(ets_limit_xian, {
    pkey = 0,
    rank = 0,
    sn = 0,
    nickname = 0,
    score = 0,
    add_time = 0
}).

-record(base_act_consume_score, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , skip_str = ""
    , list = [] %%[{Id,GoodsId,GoodsNum,LimitCount,Score}]
}).


%% 红装限时抢购
-record(base_buy_red_equip, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , reset_cost = 0
    , list = []  %%[#base_buy_red_equip_info{}]
}).

-record(base_buy_red_equip_info, {
    id = 0,
    goods_id = 0,
    goods_num = 0,
    old_cost = 0,
    now_cost = 0,
    discount = 0,
    ratio = 0,
    is_paper = 0
}).

-record(st_buy_red_equip, {
    act_id = 0
    , pkey = 0
    , re_count = 0
    , info_list = [] %% [{Id,State}]
}).


-define(ETS_LIMIT_PET, ets_limit_pet).

-record(ets_limit_pet, {
    pkey = 0,
    rank = 0,
    sn = 0,
    nickname = 0,
    score = 0,
    add_time = 0
}).

%% 限时仙宠活动
-record(base_act_limit_pet, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , one_cost = 0 %% 单抽消耗
    , ten_cost = 0 %% 十连抽消耗
    , reward_list = [] %% 奖池数据[{Gid, Gnum, OnePower, TenPower}]
    , score_list = [] %% {Min, Max, RewardList}
    , rank_list = [] %% {Rank, MinScore, RewardList}
}).

-record(st_act_limit_pet, {
    pkey = 0
    , act_id = 0
    , score = 0 %% 积分
    , recv_list = [] %% 领取过的档次积分
    , op_time = 0
}).


%%------------------回归活动--------------------
%% 充值有礼
-record(base_re_recharge_inf, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , val = 0
    , rank_info = []
}).


%%--------------------回归活动之神秘兑换----------
-record(st_return_exchange, {
    pkey = 0,
    act_id = 0,  %%子活动id
    exchange_list = [],  %%已领取的累计充值活动id
    op_time = 0
}).

-record(base_return_exchange, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , list = []  %%[#base_festival_exchange_sub{}]
}).

-record(base_return_exchange_sub, {
    id = 0 %%
    , exchange_cost = [] %% 兑换消耗
    , exchange_get = [] %% 兑换获得
    , exchange_num = 0 %% 兑换次数
}).


%% 回归活动广告
-record(base_re_notice, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , notice_list = [] %% [#base_re_notice_info{}]
}).

%% 回归活动广告内容
-record(base_re_notice_info, {
    id = 0,
    title = ""
    , content = ""
    , skip_id = 0
    , page_id = 0
}).

%% 回归登陆
-record(base_re_login, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , reward = [] %% [{Day,Reward}]
}).

-record(st_re_login, {
    pkey = 0,  %%玩家key
    day_list = []  %% 已领取天数 [{day,times}]
}).


%% 经验副本投资
-record(st_act_exp_dungeon, {
    pkey = 0
    , get_list = []     %% 已领取层数 [id]
    , is_buy = 0     %% 是否已购买
    , op_time = 0 %% 操作时间
}).

%% 经验副本配置
-record(base_act_exp_dungeon, {
    id = 0,
    floor = 0,
    reward = []

}).


%% 神邸限购活动
-record(base_godness_limit, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , list = [] %% [#base_limit_time_gift_sub{}]
}).


-record(base_godness_limit_sub, {
    id = 0
    , desc = "" %% 描述
    , show_type = 0
    , cost_gold = 0
    , sell_list = []
}).

-record(st_godness_limit, {
    pkey = 0,
    act_id = 0,
    buy_list = [], %% [{ID, Num}]
    op_time = 0
}).


-record(st_call_godnesst, {
    pkey = 0,
    act_id = 0,
    get_list = [], %% [Id]
    op_time = 0,
    count = 0,
    value = 0,
    free_count = 0
}).


-record(base_call_godness, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , show_list = []        %% 展示列表
    , count_reward = [] %% [{id,count,[{goods_id,goods_num}]}]
    , free_count = 0
    , show_id = 0
    , max_value = 0 %%幸运值上限
    , one_cost = 0
    , ten_cost = 0
    , reward_list = []  %%礼包列表 [#call_godness_info{}]
}).

-record(call_godness_info, {
    id = 0,
    top = 0,
    down = 0,
    value_down = 0,
    value_top = 0,
    reward = []
}).

%% 许愿池(单)
-record(st_act_wishing_well, {
    pkey = 0
    , nickname = []
    , act_id = 0
    , gold_coin = 0 %% 金币数
    , charge_val = 0 %% 未转化金币的充值数
    , charge_count = 0 %% 已经兑换金币次数
    , count_list = [] %% [{Type,Count}] Type 1金币 2元宝
    , score = 0
    , op_time = 0
}).

%% 许愿池(单)
-record(base_act_wishing_well, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , coin_draw = [] %% #base_act_wishing_well_gold{}
    , gold_draw = [] %% #base_act_wishing_well_gold{}
    , rank_list = [] %%
    , next_list = [] %% [{count,value}]
}).
%% 许愿池元宝
-record(base_act_wishing_well_gold, {
    one_cost = 0        %% 单抽消耗
    , one_score = 0     %% 单抽积分
    , ten_cost = 0      %% 十连抽消耗
    , ten_score = 0     %% 十连抽积分
    , reward_list = []  %%
}).
-record(act_wishing_well_mb, {
    pkey = 0,
    rank = 0,
    sn = 0,
    nickname = 0,
    score = 0,
    add_time = 0
}).


%% 许愿池(跨)
-record(st_cross_act_wishing_well, {
    pkey = 0
    , nickname = []
    , act_id = 0
    , gold_coin = 0 %% 金币数
    , charge_val = 0 %% 未转化金币的充值数
    , charge_count = 0 %% 已经兑换金币次数
    , count_list = [] %% [{Type,Count}] Type 1金币 2元宝
    , score = 0
    , op_time = 0
}).

%% 许愿池(跨)
-record(base_cross_act_wishing_well, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , coin_draw = [] %% #base_act_wishing_well_gold{}
    , gold_draw = [] %% #base_act_wishing_well_gold{}
    , rank_list = [] %%
    , next_list = [] %% [{count,value}]
}).
%% 许愿池元宝
-record(base_cross_act_wishing_well_gold, {
    one_cost = 0        %% 单抽消耗
    , one_score = 0     %% 单抽积分
    , ten_cost = 0      %% 十连抽消耗
    , ten_score = 0     %% 十连抽积分
    , reward_list = []  %%
}).
-record(cross_act_wishing_well_mb, {
    pkey = 0,
    rank = 0,
    sn = 0,
    nickname = 0,
    score = 0,
    add_time = 0
}).

%% 仙盟双倍活动
-record(base_act_guild_fight, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
}).


-record(st_act_invitation, {
    pkey = 0,  %%玩家key
    nickname = <<>>,  %%玩家昵称
    invite_code = [],
    invite_num = 0,
    get_list = [],  %%已领取的天数
    key_list = [],  %%邀请玩家列表
    use_invited_code = [],  %%使用的邀请码信息
    use_invited_key = 0,  %%使用邀请码玩家key
    be_invited = 0
}).

-record(base_act_invitation, {
    id = 0,  %%编号
    num = 0, %%邀请玩家数
    gold = 0,   %%充值要求
    type = 0, %%类型 1(下笔充值单笔返利） 2（本角色历史充值元宝数为基数）
    ratio = 0 %% 百分比
}).


-record(base_collection_hero, {
    id = 0,
    gold = 0,
    goods_list = []
}).


%% -----------------------跃升冲榜----------------------------------------------
-define(ETS_ACT_CBP_RANK, ets_act_cbp_rank).    %% 跃升冲榜排名表
-define(ETS_ACT_CBP_INFO, ets_act_cbp_info).    %% 跃升冲榜数据表
-define(ETS_ACT_CBP_LOG, ets_act_cbp_log).    %% 跃升冲榜历史记录表


-record(ets_act_cbp_log, {
    key = {0, 0, 0},  %% {top,day,pkey}
    top = 0,
    day = 0,
    pkey = 0,
    nickname = ""
}).

-record(ets_act_cbp_rank, {
    pkey = 0,
    rank = 0,
    act_id = 0,
    nickname = [],
    vip = 0,
    cbp_change = 0 %% 战力变化
}).

-record(ets_act_cbp_info, {
    pkey = 0,
    nickname = [],
    vip = 0,
    change_time = 0, %% 变更时间
    start_cbp = 0, %%初始战力
    high_cbp = 0 %% 最高战力
}).

%% 跃升冲榜活动
-record(base_act_cbp_rank, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , skip_str = 0
    , lv_limit = 0
    , cbp_limit = 0 %% 上榜战斗力限制
    , up_reward = [] %% [{id,limit,[{goods_id,goods_num}]}]
    , rank_reward = [] %% [#base_act_cbp_rank_reward{}]
}).

-record(st_act_cbp_rank, {
    pkey = 0,       %% 玩家key
    nickname = 0,   %% 玩家nickname
    vip = 0,        %% 玩家vip
    act_id = 0,     %% 活动id
    get_list = [],  %% 达标奖励列表 [{id,state}]
    start_cbp = 0,  %% 活动初始战力
    is_change = 0,  %% 是否变更
    high_cbp = 0    %% 最高战力
}).

-record(base_act_cbp_rank_reward, {
    top = 0,
    down = 0,
    rank_reward = [],   %% 排名奖励
    daily_reward = []       %% 每日奖励
}).


-record(st_act_meet_limit, {
    pkey = 0,
    act_id = 0,
    get_list = [],  %% 已领取最大key [{type,id}]
    child_list = []     %% [#base_child_list{}]
}).

-record(base_child_list, {
    key = {0, 0}, %% {type,id}
    type = 0,
    id = 0,
    gold = 0,
    state = 0,
    kill_mon = 0,
    start_time = 0, %%激活时间
    online_time = 0, %%在线时间
    end_time = 0,
    is_notice = 0,
    goods_list = []
}).


-record(base_act_meet_limit, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , c_act_list = [] %% 子活动列表 [#base_child_act_meet_limit{}]
}).

-record(base_child_act_meet_limit, {
    type = 0,
    id = 0,
    limit_timer = 0,  %% 限购时间
    open_limit = [],  %% [{lv,100},{vip,3}]
    online_time = 0,  %% 在线时长推送
    kill_mon = 0,       %% 杀怪数量推送
    goods_list = [],  %% 物品列表
    gold = 0,       %% 充值元宝数
    title = []         %% 标题
}).




-record(st_act_consume_rebate, {
    pkey = 0,
    act_id = 0,
    recv_list = [], %% 已领取的奖励
    acc_consume = 0, %%累计消费
    op_time = 0, %% 上次写库时间
    is_change = 0
}).

%% 合服之消费活动
-record(base_merge_acc_consume, {
    open_info = #open_info{}
    , act_info = #act_info{}
    , act_id = 0
    , consume_list = [] %% [{acc,GiftId}]
}).

-record(st_merge_act_acc_consume, {
    pkey = 0,
    act_id = 0,
    recv_list = [], %% 已领取的奖励
    acc_consume = 0, %%累计消费
    op_time = 0,%% 上次写库时间
    is_change = 0
}).