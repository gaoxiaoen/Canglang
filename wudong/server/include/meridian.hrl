-ifndef(MERIDIAN_HRL).
-define(MERIDIAN_HRL, 1).

-include("server.hrl").


-define(MERIDIAN_STATE_CLOSE, 0).%%未激活
-define(MERIDIAN_STATE_ACTIVATE, 1).%%可以激活
-define(MERIDIAN_STATE_HAD_ACTIVATE, 2).%%已激活
-define(MERIDIAN_STATE_UP, 3).%%可以修炼

-define(MERIDIAN_IN_CD_TIME, 1800).

-record(st_meridian, {
    pkey = 0,
    meridian_list = [],
    is_change = 0,
    attribute = #attribute{}

}).

-record(meridian, {
    type = 0,
    subtype = 0,
    lv = 0,
    break_lv = 0,
    cd = 0,
    in_cd = 0
}).

-record(meridian_info, {
    type = 0,
    is_activate = 0,
    lv_total = 0,
    break_lv = 0,
    subtype_list = [],
    attrs = [],
    in_cd = 0,
    cd = 0,
    cd_price = 0
}).
-record(base_meridian_activate, {
    type = 0,
    attrs = [],
    lv_need = 0,
    lv_max = 0,
    break_lv_max = 0,
    subtype_lv_max = 0,
    name = <<>>
}).

-record(base_meridian_upgrade, {
    type = 0,
    subtype = 0,
    lv = 0,
    attrs = [],
    plv = 0,
    break_lv = 0,
    ratio = 0,
    cd = 0,
    cost_num = 0
}).

-record(base_meridian_break, {
    type = 0,
    break_lv = 0,
    plv = 0,
    ratio = 0,
    cd = 0,
    goods = {0, 0},
    attr_per = 0,
    lv_total = 0
}).
-endif.