-ifndef(JADE_HRL).
-define(JADE_HRL, 1).

-include("server.hrl").



-define(JADE_OPEN_LV, data_menu_open:get(74)).

-record(st_jade, {
    pkey = 0,
    stage = 0,
    exp = 0,
    bless_cd = 0,
    jade_id = 0,
    figure = 0,
    skill_list = [],
    equip_list = [],
    grow_num = 0,
    cbp = 0,
    attribute = #attribute{},
    spirit = 0,%%灵力值
    spirit_list = [],
    last_spirit = 0,
    is_change = 0
}).

-record(base_jade_stage, {
    stage = 0,
    jade_id = 0,
    figure = 0,
    exp = 0,
    exp_min = 0,
    exp_max = 0,
    goods_ids = [],
    gid_auto = 0,
    num = 0,
    cd = 0,
    attrs = [],
    bless_attrs = [],
    exp_full,
    award = {}
}).


-record(base_jade_skill_activate, {
    cell = 0,
    skill_id = 0,
    goods = 0,
    stage = 0
}).
-record(base_jade_skill_upgrade, {
    skill_id = 0,
    lv = 0,
    goods = {},
    new_skill_id = 0,
    stage = 0,
    attrs = []
}).

-record(base_jade_spirit, {
    type = 0,
    lv = 0,
    attrs = [],
    goods_id = 0,
    goods_num = 0,
    stage = 0
}).

-endif.