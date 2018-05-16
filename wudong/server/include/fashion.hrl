-ifndef(FASHION_HRL).
-define(FASHION_HRL, 1).

-include("common.hrl").
-include("goods.hrl").

%% 物品记录状态
-record(st_fashion, {
    pkey = 0,
    fashion_list = [],
    fashion_id = 0,
    attribute = #attribute{},
    cbp = 0,
    is_change = 0
}).

-record(fashion, {
    fashion_id = 0, %%时装id
    time = 0,       %%时效,0长期,>0时效
    stage = 0,      %%阶数
    is_use = 0,     %%是否使用
    is_enable = false,
    activation_list = [],
    attribute = #attribute{},
    cbp = 0
}).

-record(base_fashion, {
    fashion_id = 0,
    name = <<>>,
    type = 0,
    attrs = [],
    time_bar = 0,
    from = 0,
    image = 0,
    goods_id = 0,
    goods_num = 0,
    head_id = 0,
    icon = 0
}).

-record(base_fashion_upgrade, {
    fashion_id = 0,
    lv = 0,
    attrs = [],
    goods_id = 0,
    goods_num = 0,
    lv_attr = [],
    full_goods_id = 0 %% 整套id
}).

-endif.