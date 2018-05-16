-ifndef(DESIGNATION_HRL).
-define(DESIGNATION_HRL, 1).

-include("common.hrl").
-include("goods.hrl").

-define(DES_TIMER,300).

-define(ETS_DESIGNATION_GLOBAL, ets_designation_global).
-record(st_designation, {
    pkey = 0,
    designation_list = [],
    g_designation_list = [],
    attribute = #attribute{},
    cbp = 0,
    is_change = 0
}).

-record(designation, {
    designation_id = 0, %%称号id
    time = 0,       %%时效,0长期,>0时效
    stage = 0,      %%阶数
    is_enable = false,
    activation_list = [],
    attribute = #attribute{},
    cbp = 0
}).

%%全局称号
-record(designation_global, {
    key = 0,
    designation_id = 0,
    pkey = 0,
    get_time = 0
}).

-record(base_designation, {
    designation_id = 0,
    name = <<>>,
    type = 0,
    attrs = [],
    time_bar = 0,
    from = 0,
    image = 0,
    goods_id = 0,
    goods_num = 0,
    is_global = 0       %%是否全服唯一称号1 是0否
}).

-record(base_designation_upgrade, {
    designation_id = 0,
    lv = 0,
    attrs = [],
    lv_attr = [],
    goods_id = 0,
    goods_num = 0
}).

-endif.