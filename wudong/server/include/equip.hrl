%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 装备
%%% @end
%%% Created : 15. 一月 2015 11:59
%%%-------------------------------------------------------------------
-ifndef(EQUIP_HRL).
-define(EQUIP_HRL, 1).
-include("error_code.hrl").
-include("goods.hrl").

-define(HOLE_NUN_PROBABILITY, [20, 35, 35, 10]).  %%开孔数量概率
-define(HOLE_TYPE_PROBABILITY, [20, 50, 30]).    %%开孔形状的概率
-define(HOLE_TYPE, [?GOODS_SUBTYPE_ROUNDNESS_STONE, ?GOODS_SUBTYPE_SQUARE_STONE, ?GOODS_SUBTYPE_HEXAGRAM_STONE]).    %%开孔形状的概率
-define(HOLE_NEED_GOODS, 100000).              %%开孔需要物品的id
-define(HOLE_NEED_MONEY, 100000).              %%开孔需要物品的金钱

-define(WASH_RESTORE_DIAMOND, 20).              %%洗练恢复需要的元宝

-define(ATT, 1).              %%攻击
-define(DEF, 2).              %%防御
-define(HP_LIM, 3).              %%血量


%%装备强化数据
-record(base_strength, {
    level = 0,
    addition_percent = 0,
    need_goods = [],
    need_coin = 0,
    need_player_lv = 0,
    max_exp = 100, direct_probability = [0, 10], critical_probability = 0
}).

%%装备强化数据
-record(st_strength_exp, {
    exp_list = [],
    is_change = 0,
    attribute = #attribute{}       %%全套属性加成
}).


%%----------------------装备精炼部分开始------------------------------
%%装备精炼信息
-record(st_refine_info, {
    att_num = 0,                %% 攻击精炼石数量
    def_num = 0,                %% 防御精炼石数量
    hp_lim_num = 0,             %% 生命精炼石数量
    subtype = 0                %%部位
}).

%%装备精炼数据
-record(st_refine, {
    refin_list = [],    %%  各部位精炼石信息
    is_change = 0,
    attribute = []        %%  全套属性加成
}).


%%精炼基础
-record(base_equip_refine, {
    type = 0,
    goods_id = 0,
    attrs = []
}).


%%----------------------装备精炼------------------------------


%%物品合成数据.
-record(base_gem_compound, {
    source_goods_id,
    destination_goods_id,
    need_num,
    success_rate
}).

-record(base_equip_upgrade, {
    star = 1,
    subtype = 1,
    need_goods = [],
    need_coin = 0,
    need_bgold = 0,
    need_gold = 0,
    get_goods_id = [],
    view_goods_id = []
}).

-record(base_equip_star, {
    subtype = 1,
    star = 1,
    need_player_lv = 20,
    need_goods = [],
    need_coin = 1000,
    addition_percent = []}).

-record(base_compound, {
    id = 10001,
    type = 1,
    material = [{20110, 3}],
    goods = [{20111, 1}],
    need_coin = 1000,
    open_level = 9999}).

-record(st_gemstone, {
    is_change = 0,
    gem_list = []}).

-record(wedding_ring_upgrade, {
    get_goods_id = 0,
    need_coin = 0,
    need_goods = [],
    exchange_goods = []}).


%%强化信息
-record(equip_strength, {
    subtype = 0,    %%部位
    exp = 0,        %%当前经验
    strength = 0         %%等级

}).

%%强化基础
-record(base_equip_strength, {
    subtype = 0,
    strength = 0,
    goods_id = 0,
    num = 0,
    coin = 0,
    success_ratio = 0,
    fail_ratio = 0,
    exp_lim = 0,
    exp_add = 0,
    attrs = []
}).

%%洗练信息
-record(st_equip_wash, {
    pkey = 0,
    wash = [], %%[{Subtype,Plv,Area,Times}]
    wash_attr = [],
    is_change = 0
}).

%% 装备碎片合成
-record(base_equip_compose, {
    id = 0, %% 图纸ID
    subtype = 0, %% 部位
    consume = [], %% 可消耗列表
    cost_num = 0 %% 消耗数量
}).

%% 装备神炼基础
-record(base_equip_god_forging, {
    subtype = 0,
    strength = 0,
    goods_id = 0,
    num = 0,
    attrs = []
}).


%%----------装备附魔-------------
%%装备附魔信息
-record(st_magic_info, {
    att_list = [{0, 0, 3}, {0, 0, 4}, {0, 0, 1}], %% {等级,经验,位置}
    subtype = 0                %%部位
}).

%%装备附魔数据
-record(st_magic, {
    magic_list = [],    %%  各部位附魔信息 [#st_magic_info{}]
    is_change = 0,
    attribute = []        %%  全套属性加成
}).

%%附魔基础
-record(base_equip_magic, {
    subtype = 0,    %% 位置
    lv = 0,         %% 等级
    exp = 0,        %% 经验
    type = 0,       %% 属性类型
    attrs = []      %% 属性
}).


%% --------武魂---------
-record(base_equip_soul, {
    id = 0,
    type = 0,       %% 类型 攻击1 防御2 生命3 暴击4 命中5
    lv = 0,         %% 等级
    goods_id = 0,   %% 物品id
    attrs = [],
    need_goods_id = 0,  %% 合成需要物品id
    need_goods_num = 0  %% 合成需要物品数量
}).

%%装备武魂信息
-record(st_soul_info, {
    info_list = [{1, 1, 0}, {2, 0, 0}, {3, 0, 0}, {4, 0, 0}, {5, 0, 0}], %% 武魂信息 [{位置,开启状态,武魂id}]
    subtype = 0     %% 部位
}).

-record(st_soul, {
    soul_list = [],    %%  各部位武魂信息 [#st_soul_info{}]
    is_change = 0,
    attribute = []     %%  全套属性加成
}).

-record(base_equip_suit, {
    id = 0,
    type = 0,
    desc = "",
    color = 0, %% 装备品质
    stage = 0, %% 装备阶级
    level = 0, %% 装备等级
    attrs = #attribute{}, %% 套装属性
    has_num = 0%% 激活条件，拥有数量
}).

-record(st_equip_suit, {
    pkey = 0,
    wear_info = [], %% 穿戴信息 [{GoodsId, Stage}]
    attr = #attribute{}, %% 套装属性
    act_ids = [] %% 激活ID列表
}).


-record(base_equip_level_up, {
    level = 0,
    subtype = 0,
    cost_goods = 0,
    coin = 0
}).

-record(base_equip_part_shop, {
    type = 0,
    id = 0,
    goods_id = 0,
    goods_num = 0,
    cost = 0,
    cost_list = [],
    limit = 0
}).
-record(st_equip_part_shop, {
    pkey=0,
    list = []
}).

-endif.