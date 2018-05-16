%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 十一月 2017 18:36
%%%-------------------------------------------------------------------
-author("li").

-define(BATTLE_MAX_ROUND, 30). %% 最大回合数

-define(DIE_TYPE1,0).   %%死亡移除
-define(DIE_TYPE2,1).   %%死亡更新
-define(RAGE_LIM, 4). %% 怒气值上限
-define(PET_PUT_ON_MAX, 5). %%最高上阵5只宠物

-record(base_pet_war_dun,{
    id = 0 %% 关卡ID
    , is_boss %% 0小怪关卡1boss关卡
    , chapter %% 章节
    , desc = ""
    , mon_list = [] %% 怪物列表
    , map_id = 0 %% 排布阵型ID
    , first_pass_reward = [] %% 首次通关奖励
    , daily_pass_reward = [] %% 日常通关奖励
    , saodang_num = 0 %% 扫荡次数
    , lv = 0 %% 玩家等级
    , mapBgId = 0
}).

-record(base_pet_map,{
    id = 0 %% 阵型ID
    ,map = [] %% 阵型
}).

%%宠物战
%% 布阵图
-record(st_pet_map,{
    pkey = 0
    , use_map_id = 1
    , map_list = [] %% [{{MapId, PosId}, PetKey}]
}).

-record(base_pet_war_star,{
    id = 0
    , chapter = 0 %% 章节
    , star = 0 %% 星数
    , reward = [] %% 奖励
}).

-record(st_pet_war_dun,{
    pkey = 0
    , dun_id = 0
    , recv_star_list = [] %% 领取的星数奖励[{chapter,star}]
    , saodang_list = [] %% 扫荡列表[{DunId, Num}]
    , op_time = 0
}).

-record(base_round_mon, {
    %% -- 基础数据
    mon_id = 0,               %%怪物类型id
    image = 0,
    name = <<>>,           %%怪物名称
    lv = 0,               %%怪物等级
    hp_lim = 0,           %%默认血量
    hp_num = 0,           %%每次回血血量
    mp_lim = 0,           %%默认蓝量
    mp_num = 0,           %%每次回蓝量
    mana_lim = 0,           %%法盾值上限
    mana = 0,           %%法盾值
    %%属性
    speed = 0,              %%移动速度
    base_speed = 0,         %%移动速度
    att_speed = 0,          %%攻击速度
    att = 0,     %%攻击
    def = 0,    %%防御
    hp = 0,
    hit = 0,     %%命中
    dodge = 0,   %%闪躲
    crit = 0,    %%暴击
    ten = 0,     %%坚韧
    crit_inc = 0,%%暴击伤害
    crit_dec = 0,%%暴击免伤
    hurt_inc = 0,%%伤害加成
    hurt_dec = 0,%%伤害减免
    pvp_inc = 0,
    pvp_dec = 0,
    crit_ratio = 0,%%人物暴击率
    hit_ratio = 0,%%人物命中率
    hurt_fix = 0,%%固定伤害
    hp_lim_inc = 0,         %%气血增加百分比
    skill = [],             %%技能列表
    key = 0,                %%怪物唯一id
    buff_list = [],        %%buff列表
    eff_list = [],         %%效果列表
    war_pos = 0              %%出战位置
}).