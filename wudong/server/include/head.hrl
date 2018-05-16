-ifndef(HEAD_HRL).
-define(HEAD_HRL, 1).

-include("common.hrl").
-include("goods.hrl").

%% 物品记录状态
-record(st_head, {
    pkey = 0,
    head_list = [],
    head_id = 0,
    attribute = #attribute{},
    cbp = 0,
    is_change = 0
}).

-record(head, {
    head_id = 0, %%时装id
    time = 0,       %%时效,0长期,>0时效
    stage = 0,      %%阶数
    is_use = 0,     %%是否使用
    is_enable = false,
    activation_list = [],
    attribute = #attribute{},
    cbp = 0
}).

-record(base_head, {
    head_id = 0,
    name = <<>>,
    type = 0,
    attrs = [],
    time_bar = 0,
    from = 0,
    image = 0,
    goods_id = 0,
    goods_num = 0
}).

-record(base_head_upgrade, {
    head_id = 0,
    lv = 0,
    attrs = [],
    lv_attr = [],
    goods_id = 0,
    goods_num = 0
}).

-endif.