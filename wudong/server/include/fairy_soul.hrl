%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 八月 2017 10:36
%%%-------------------------------------------------------------------
-author("Administrator").

%% -define(MAX_FAIRY_SOUL, 18).
-define(FAIRY_SOUL_COST,100).
-define(FAIRY_SOUL_LIST_LIMIT,18).
-define(DAILY_FAIRY_SOUL_FREE_TIMES,0).

-record(st_fairy_soul, {
    pkey = 0,
    pos = 1, %% 激活的最大位置
    exp = 0, %% 仙魂经验
    chips = 0, %% 仙魂碎片
    floor = 1, %% 当前猎魂位置
    max_floor = 1, %% 最大探索位置
    list = [],  %% 猎魂列表
    is_first = 0 %% 是否第一次元宝猎魂 0为未花费元宝 1花费元宝未猎魂 2已花费元宝并猎魂
}).

-record(base_fairy_soul, {
    type = 0, %% 类型
    lv = 0, %% 等级
    color = 0, %% 品质
    goods_id = 0, %% 物品id
    need_exp = 0, %% 升级所需经验
    resolved_exp = 0, %% 分解经验
    attribute_list = [] %% 符文属性列表
}).

-record(base_fairy_soul_draw, {
    id = 0,
    cost = 0,
    floor_ratio = [{-1,1},{1,1}], %% -1下降、1上升概率
    type_ratio = [{1,1},{2,1}], %%奖励类型 1为仙魂 2为经验
    color_ratio = [],   %% 品质列表
    goods_list = []
}).


