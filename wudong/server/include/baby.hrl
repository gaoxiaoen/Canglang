%%%-------------------------------------------------------------------
%%% @author lzx
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%             宝宝系统
%%% @end
%%% Created : 06. 八月 2017 15:55
%%%-------------------------------------------------------------------
-author("lzx").
-include("server.hrl").

-define(CHANGE_NAME_GOODS_ID, 1026000).
-define(CHANGE_BABY_SEX_GOODS_ID, 7306001).
-define(GOODS_BABY_CREATE_GOODS_ID, 7304001).     %% 天之子
-define(SIGN_UP_DAYS, 7).              %% 7天签到


-define(BABY_FIGHT_STATE, 1).                            %% 出站
-define(BABY_RESET_STATE, 0).                            %% 休息状态
-define(BABY_BORN_LEFT_TIME_TIPS, [72 * 60, 48 * 60, 24 * 60, 12 * 60, 6 * 60, 3 * 60, 1 * 60]).  %% 宝宝出生剩余时间提示
-define(BABY_BORN_LAST_TIME, 0).                        %% 结婚后马上出生
-define(BABY_SINGLE_SIGN_TYPE, 1).                       %% 单人签到
-define(BABY_SINGLE_DOUBLE_TYPE, 2).                     %% 双人签到
-define(BABY_COUPLE_LOVE_LV(PKEY), {baby_couple_love_lv, PKEY}). %% 夫妻等级

-define(BABY_OPEN_LV, data_menu_open:get(61)).           %% 开放等级


%% baby基础配置数据
-record(base_baby, {
    id = 0,
    name = "",      %%名字
    figure = {},    %% 形象列表
    sex = 1,        %% 性别
    skill_list = [], %%技能列表
    special_skill = 0 %%特殊技能数量
}).

%%baby 升级经验配置
-record(base_baby_exp, {
    lv = 0,         %%等级
    exp = 0,        %%经验
    add_exp = 0,    %% 添加经验
    goods = {},     %% 使用经验
    attrs = []      %% 属性列表
}).


%%baby baby进阶等级配置
-record(base_baby_step, {
    id = 0,         %% 形象ID
    step = 0,       %%第几阶
    exp = 0,
    add_exp = 0,
    goods = {},
    attrs = []
}).


%%baby 幻化配置表
-record(base_baby_pic, {
    figure_id = 0,
    star = 0,
    baby_id = 0,
    goods = {},
    chip_goods = {},
    attrs = [],
    skill_id = 0
}).


%% baby 签到配置表
-record(base_baby_sign, {
    type = 0,
    dayt = 0,
    award = []
}).


%%baby 每日击杀配置
-record(base_baby_kill_daily, {
    kill_id = 0,
    num = 0,
    goods = []
}).


%% 加速类型
-record(base_baby_time_speed, {
    goods_id = 0,
    cost_type = 0,
    cost = 0,
    time = 0
}).


%% baby 数据
-record(baby_st, {
    pkey = 0,                   %% 玩家ID
    baby_key = 0,               %% 唯一ID
    type_id = 0,                %% 类型IDs
    figure_id = 0,              %%形象ID
    figure_list = [],           %% 激活形象列表
    name = "",
    skill_list = [],            %% 技能列表{cell,skillid}
    equip_list = [],            %% 装备列表{subtypeid,equiptypeId,equipid}
    my_love = 0,                %% 关爱等级
    other_love = 0,             %% 伴侣关爱等级
    step = 0,                   %% 当前阶级
    step_exp = 0,               %% 当前阶级经验
    lv = 0,                     %% 等级
    lv_exp = 0,                 %% 等级经验
    state = 0,                  %% 是否出战0,1
    attribute = #attribute{},    %%总属性
    cbp = 0,                     %%总战力
    born_time = 0,              %% 出生时间
    is_change = 0               %% 数据是否改变
}).



