%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 十二月 2017 15:19
%%%-------------------------------------------------------------------
-author("li").
-include("server.hrl").

-record(st_godness, {
    pkey = 0
    , godness_list = []
    , godsoul_skill_list = [] %% 出战时生效，被动技能
    , skill_list = [] %% 技能列表 通灵主动技能
    , attr = #attribute{} %% 属性
}).

-record(godness, {
    godness_id = 0 %% 神祇ID
    , desc = "" %% 神祇描述
    , consume = [] %% 激活所需碎片
    , icon = 0 %% 形象ID
    , up_star_cost = 0
    , uplv_attr = []
    , change_add_attr = []
    , init_skill = []
    , max_lv = []
    , uplv_mult = []
    , change_mult = []

    , key = 0
    , pkey = 0
    , is_war = 0 %% 是否出战 0未出战1出战
    , lv = 1 %% 等级
    , star = 1 %% 星级
    , exp = 0 %% 经验
    , suit_skill_list = [] %% 激活神魂套装技能列表 [{SuitId, N, SkillId}]
    , suit_attr = #attribute{} %% 神魂套装基础属性
    , suit_percent_attr = #attribute{} %% 神魂技能加成属性百分比
    , skill_list = [] %% [SkillId]
    , skill_cbp = 0
    , wear_god_soul_attr = #attribute{} %% 当前神祇穿戴神魂总属性
    , sum_attr = #attribute{} %% 神祇常规总属性 = 等级星级属性+穿戴神魂属性
    , war_attr = #attribute{} %% 出战时生效属性
}).

-record(base_god_soul, {
    subtype = 0
    , color = 0
    , lv = 0
    , attrs = []
    , need_exp = 0 %% 升级所需经验
}).

-record(base_godness_stage, {
    godness_id = 0 %% 神祇ID
    , lv = 0 %% 等级
    , need_exp = 0
    , attrs = []
}).

-record(base_godness_star, {
    godness_id = 0 %% 神祇ID
    , star = 0 %% 星级
    , consume = []
    , attrs = []
}).

-define(GODNESS_EXP_GOODSLIST, [7500001, 7500002, 7500003]). %% 经验石道具列表
-define(GODNESS_SKILL_COST_GOOODSID, 7500101). %% 技能升级消耗道具