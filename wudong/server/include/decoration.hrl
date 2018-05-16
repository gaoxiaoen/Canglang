-ifndef(DECORATION_HRL).
-define(DECORATION_HRL, 1).

-include("common.hrl").
-include("goods.hrl").

-record(st_decoration, {
    pkey = 0,
    decoration_list = [],
    decoration_id = 0,
    attribute = #attribute{},
    cbp = 0,
    is_change = 0
}).

-record(decoration, {
    decoration_id = 0, %%挂饰id
    time = 0,       %%时效,0长期,>0时效
    stage = 0,      %%阶数
    is_use = 0,     %%是否使用
    is_enable = false,
    activation_list = [],
    attribute = #attribute{},
    cbp = 0
}).

-record(base_decoration, {
    decoration_id = 0,
    name = <<>>,
    type = 0,
    attrs = [],
    time_bar = 0,
    from = 0,
    image = 0,
    goods_id = 0,
    goods_num = 0
}).

-record(base_decoration_upgrade, {
    decoration_id = 0,
    lv = 0,
    attrs = [],
    lv_attr = [],
    goods_id = 0,
    goods_num = 0
}).

-endif.