-include("server.hrl").

-define(PET_SKILL_POS_MAX, 8).

-define(PET_STATE_FREE, 0).
-define(PET_STATE_ASSIST, 1).
-define(PET_STATE_FIGHT, 2).


-record(st_pet, {
    pkey = 0,  %%玩家key
%%    fight_pet = #fpet{}, %%出战宠物
    pet_list = [],  %%宠物列表[#pet{}]
    figure = 0,     %%当前形象
    stage = 1,      %%当前阶数
    stage_lv = 0,   %%阶数等级
    stage_exp = 0,  %%阶数经验

    stage_attribute = #attribute{},%%阶数属性

    pic_list = [],   %%图鉴列表[{figureid,lv}]
    pic_attribute = #attribute{},%%图鉴属性
    pic_normal_attribute = #attribute{},%%普通宠物额外属性
    pic_special_attribute = #attribute{},%%珍稀宠物额外属性

    assist_attribute = #attribute{}, %%助战属性
    egg_list = [],      %%宠物蛋列表
    assist_acc_attribute = #attribute{},%%助战种类属性
    assist_star_attribute = #attribute{},%%助战星级属性
    assist_xh_attribute = #attribute{},%%助战仙魂属性
    %%总属性
    attribute = #attribute{},
    cbp = 0,
    is_change = 0
}).


-record(pet, {
    key = 0,  %%petkey
    type_id = 0,  %%宠物类型id
    name = "",  %%宠物名字
    figure = 0,
    star = 0,  %%星级
    star_exp = 0,%%星级经验
    state = 0,  %%状态0空闲2出战1助战
    assist_cell = 0,%%助战位置
    time = 0,  %%创建时间
    skill = [], %%宠物技能 [{cell,skill_id}]

    skill_attribute = #attribute{},%%技能属性
    star_attribute = #attribute{},%%星级属性

    attribute = #attribute{},%%单个宠物总属性
    cbp = 0,
    is_change = 0,
    war_pos = 0, %% 出战位置，动态读取阵型图
    war_skill = [] %% 宠物回合制技能
}).

%%宠物蛋信息
-record(pet_egg, {
    goods_key = 0,
    pet_type_id = 0,
    star = 0
}).

%%------宠物信息------------
-record(base_pet, {
    id = 0,  %%宠物id
    name = "",  %%宠物名字
    figure = 0,  %%形象
    star = 0,  %%星级
    att_param = 1,
    skill_list = [], %%基础技能列表
    war_skill_list = [] %%回合制基础技列表 [{SkillId,[Id,Key,Value],[AttType]}]
}).

-record(base_pet_star, {
    star = 0,
    exp = 0,
    merge_exp = 0,
    attrs = []
}).

-record(base_pet_pic, {
    figure_id = 0,
    pet_id = 0,
    type = 0,
    attrs = []
}).

-record(base_pet_stage, {
    stage = 0,
    lv = 0,
    exp = 0,
    add_exp = 0,
    goods = {},
    attrs = []
}).

-record(base_pet_egg, {
    id = 0,
    type = 0,
    pet_type_id = 0,
    ratio = 0,
    star_list = []
}).

