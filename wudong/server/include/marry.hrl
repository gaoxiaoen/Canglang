-ifndef(MARRY_HRL).
-define(MARRY_HRL, 1).

-include("server.hrl").
-define(ETS_MARRY, ets_marry).

-define(WEEDING_CAR_MID, 45101).
-define(WEEDING_CAR_GIFT_ID, 7203001).

-define(MARRY_LV,data_menu_open:get(49)).

-record(wedding_car, {
    marry_key = 0,
    mon_key = 0,
    x = 0,
    y = 0,
    boy_roll = 0,
    girl_roll = 0,
    boy = #player{},
    girl = #player{}
}).

-record(marry_state, {
    cruise_list = [],
    cruise_time = 0,
    cruise_state = 0,
    car = #wedding_car{},
    roll_list = []
}).

-record(st_marry, {
    mkey = 0,
    type = 0,
    key_boy = 0,
    key_girl = 0,
    time = 0,
    cruise = 0,
    heart_lv = [{0, 0}, {0, 0}], %% 羁绊等级 {玩家key,阶数}
    ring_lv = [{0, 0}, {0, 0}],   %% 戒指等级 {玩家key,阶数}
    cruise_num = 0 %% 巡游次数
}).


-record(base_marry, {
    type = 0,
    price = {},
    close = 0,
    goods_list = [],
    cruise = 0,
    cruise_price = 0
}).

-record(base_marry_heart, {
    type = 0,
    lv = 0,
    attrs = [],
    goods_num = 0,
    stage = 0
}).

-record(st_marry_heart, {
    pkey = 0,
    is_change = 0,
    heart_list = [], %%羁绊[{id,lv}]
    last_heart = 0   %%上一次提升的灵脉
}).

-record(st_cruise, {
    akey = 0,
    date = 0,
    time = 0,
    mkey = 0
}).

-record(base_cruise, {
    type = 0,
    price_type = 0,
    price = 0,
    goods_id = 0,
    num = 0
}).

-record(cruise_roll, {
    type = 0,
    pkey = 0,
    nickname = <<>>,
    time = 0,
    goods_id = 0,
    goods_num = 0,
    roll_plist = [],%%{pkey,point}
    point_h = 0,
    nickname_h = <<>>,
    pkey_h = 0

}).

%% 结婚戒指
-record(st_ring, {
    pkey = 0,
    stage = 0,
    exp = 0,
    type = 0, %% 类型 0单身戒指 1结婚戒指
    attribute = #attribute{},
    cbp = 0,
    is_change = 0,
    is_upgrade = false
}).

%%戒指
-record(base_marry_ring, {
    stage = 0,
    exp = 0,
    type = 0,
    attrs = [],
    buff_id = 0
}).


%% 结婚礼包 -- 爱情香囊
-record(st_marry_gift, {
    pkey = 0,
    buy_type = 0, %% 0没有1有购买
    recv_first = 0, %% 固定奖励领取0未领1已领取
    daily_recv = 0, %% 0当天未领1已领取
    buy_out_time = 0, %% 购买礼包时间
    is_buy = 0, %% 0没有为他购买1为他购买
    op_time = 0
}).

%% 结婚称号
-record(st_marry_designation, {
    pkey = 0,
    designation = [] %% 已兑换称号列表
}).

-record(base_marry_designation, {
    id = 0,
    designation_id = 0,
    goods_id = 0,
    ring_lv = 0,
    heart_lv = 0,
    tree_lv = 0
}).

-record(base_marry_gift, {
    type = 0 %% 婚礼类型
    , cost = 0 %% 购买花费元宝
    , first_goods = [] %% 首次奖励物品
    , daily_goods = [] %% 每日奖励物品
    , time = 0 %% 过期时间
}).

%% 姻缘树
-record(base_marry_tree, {
    lv = 0, %% 等级
    exp = 0, %% 当前阶所需经验
    attri = [], %% 当前阶基础属性
    reward_list = [], %% 进阶成功奖励
    cost = 0, %% 单次进阶消耗
    tree_reward = [], %%树上的奖励
    cd_time = 0 %% 果树CD时间
}).

-record(st_marry_tree, {
    pkey = 0,
    lv = 1, %% 等级
    exp = 0, %% 经验
    attri = #attribute{}, %% 属性值
    cbp = 0,
    tree_reward_list = [] %% 当前领取的奖励[{lv, recvTime}]
}).

-define(ETS_MARRY_TREE, ets_marry_tree).
-record(ets_marry_tree, {
    pkey = 0,
    lv = 0
}).
-define(MARRY_TREE_SEED, 7207001). %% 爱情树种子
-define(MARRY_TREE_MAX_LV, 300). %% 爱情树最大等级

-endif.
