%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 三月 2018 11:15
%%%-------------------------------------------------------------------
-author("li").

-include("server.hrl").

-record(st_jiandao, {
    pkey = 0
    , stage = 1
    , point_id = 1 %% 属性点
    , lv = 0
    , attr = #attribute{} %% 剑道属性，包括升级与进阶
    , wear_list = [] %%装备的元素列表 动态计算
    , jiandao_id = 0 %% 形象ID 动态读表
    , skill_list = [] %% 动态读激活表
}).

-record(st_element, {
    element_list = [] %% [#element{}]
    , attr = #attribute{} %% 总属性
}).

-record(element, {
    pkey = 0
    , race = 0 %% 元素类型
    , lv = 0 %% 等级
    , attr = #attribute{} %% 升级总属性
    , e_lv = 0 %% 元素等级
    , e_attr = #attribute{} %% 元素升级后总属性
    , stage = 0 %% 突破阶数
    , stage_attr = #attribute{} %% 突破属性
    , pos = 0
    , is_wear = 0 %% 穿戴0否1是
}).

-record(base_jiandao_uplv, {
    id = 0
    , stage = 0 %% 阶级
    , point_id = 0
    , lv = 0 %% 属性等级
    , attrs = [] %% 属性
    , consume = [] %% 升级消耗
}).

-record(base_jiandao_stage, {
    stage = 0 %% 阶级
    , jiandao_id = 0 %% 剑道造型ID
    , skill_list = [] %% 解锁技能ID列表
    , consume = [] %% 升阶消耗
    , attrs = []  %% 增加属性
    , wear_element_max = 0 %%装备元素最大数量
}).

-record(base_element_up_lv, {
    id = 0
    , race = 0 %% 系别
    , lv = 0 %% 等级
    , attrs = []
    , consume = [] %% 升级消耗
}).

-record(base_element_up_elv, {
    id = 0
    , race = 0 %% 系别
    , e_lv = 0 %% 元素属性等级
    , attrs = []
    , stage_limit = 0
    , consume = [] %% 升级消耗
}).


-define(ELEMENT_FIRE, 1). %% 火系元素
-define(ELEMENT_WIND, 2). %% 风系元素
-define(ELEMENT_WATER, 3). %% 水系元素
-define(ELEMENT_WOOD, 4). %% 木系元素
-define(ELEMENT_LIGHT, 5). %% 光系元素
-define(ELEMENT_DARK, 6). %% 暗系元素
-define(ELEMENT_LIST, [1,2,3,4,5,6]). %% 元素列表
