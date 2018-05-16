%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% %% 飞仙系统
%%% @end
%%% Created : 11. 十月 2017 13:47
%%%-------------------------------------------------------------------
-author("li").

-include("server.hrl").

%% 仙装升级
-record(base_xian, {
    goods_id = 0,
    lv = 0, %% 等级
    need_exp = 0, %% 升级所需经验
    attribute_list = [], %% 仙装属性列表
    resolved_back = 0, %% 分解返还
    cost = 0 %% 每次升级时消耗
}).

%% 仙装寻宝
-record(base_xian_map, {
    id = 0,
    type = 0,
    goods_id = 0,
    goods_num = 0,
    power = 0
}).

-record(st_xian_map,{
    pkey = 0,
    time1 = 0, %% 地仙寻宝时间
    num1 = 0, %% 当天使用地仙寻宝免费次数
    time2 = 0, %% 鸿钧寻宝时间
    num2 = 0, %% 当天使用鸿钧寻宝免费次数
    op_time = 0
}).

%% 玩家仙阶信息
-record(st_xian_stage, {
    pkey = 0,
    stage = 1,
    task_info = [], %% [{任务Id, 当前Num, 提交状态0未提交1已提交}] 当前任务完成信息
    attr = #attribute{},
    op_time = 0,
    is_db = 0
}).

%% 仙装升级
-record(base_xian_upgrade, {
    stage = 0,
    desc = "",
    attr = [],
    condition = [], %% [{TaskId, Type, Id, Num}]
    pass_goods = [], %% 副本通关奖励
    drop_goods = [] %% 副本通关掉落
}).

-define(XIAN_MAP_TYPE1, 1). %% 地仙寻宝
-define(XIAN_MAP_TYPE2, 2). %% 鸿钧寻宝

-define(XIAN_MAP_TYPE_GO1, 1). %% 寻宝1次
-define(XIAN_MAP_TYPE_GO10, 10). %% 寻宝10次

-record(base_xian_exchange, {
    id = 0
    , exchange_cost = [] %% 兑换消耗
    , exchange_get = [] %% 兑换获得
    , exchange_num = 0 %% 兑换次数
}).

%% 仙装兑换
-record(st_xian_exchange, {
    pkey = 0,
    exchange_list = [],  %% [{Id, Num}]
    op_time = 0
}).

%% 仙术
-record(st_xian_skill, {
    pkey = 0,
    skill_lv_list = [], %% [{仙装部位subtype, 觉醒Lv}]
    attr = #attribute{}, %% 由skill_lv_list动态读表
    skill_list = [], %% 主动技能由skill_lv_list动态读表[SkillId]
    passive_skill_list = [], %% 被动技能由skill_lv_list动态读表[{SkillId, SkillType}]
    cbp = 0 %% 由skill_lv_list动态读表
}).