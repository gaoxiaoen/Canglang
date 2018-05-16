%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 五月 2017 15:50
%%%-------------------------------------------------------------------
-author("li").

-record(st_fuwen, {
    pkey = 0,
    pos = 0, %% 激活的最大位置
    exp = 0, %% 符文经验
    chips = 0 %% 符文碎片
}).

-record(base_fuwen,{
    type = 0, %% 类型
    lv = 0, %% 等级
    color = 0, %% 品质
    need_exp = 0, %% 升级所需经验
    need_chip = 0, %% 兑换需要的碎片
    attribute_list = [] %% 符文属性列表
}).

%% 11120 至尊精华

%% 双属性符文
-record(base_double_attr_fuwen, {
    goods_id = 0, %%
    desc = "", %% 描述
    consume_fuwen1 = {0,0}, %% 消耗符文1
    consume_fuwen2 = {0,0}, %% 消耗符文2
    need_exp = 0, %% 合成所需经验（精华）
    dun_desc = "" %% 开启关卡
}).
