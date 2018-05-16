-ifndef(BABY_WING_HRL).
-define(BABY_WING_HRL, 1).

-include("server.hrl").

%% -define(WING_OPEN_LV, data_menu_open:get(56)).
%% -define(WING_OPEN_LV, 1).
-define(BABY_WING_OPEN_LV, 85).


-record(st_baby_wing, {
    pkey = 0,
    stage = 0,
    exp = 0,
    bless_cd = 0,
    bless_notice = 0,
    current_image_id = 0,
    own_special_image = [],
    star_list = [],
    wing_attribute = #attribute{},            %%所有翅膀给玩家附加的属性
    cbp = 0,
    skill_list = [],
    equip_list = [],
    grow_num = 0,
    is_change = 0,
    spirit = 0,%%灵力值
    spirit_list = [],
    last_spirit = 0
}).

-record(base_baby_wing_stage, {
    stage = 0,
    exp = 0,
    exp_min = 0,
    exp_max = 0,
    goods_ids = [],
    gid_auto = 0,
    num = 0,
    cd = 0,
    attrs = [],
    bless_attrs = [],
    image = 0,
    exp_full,
    award = {}
}).

-record(base_baby_wing, {
    wing_id = 0,
    describe = "",
    icon_id = 0,
    name = "",
    is_special = 0,
    image_id = 0,
    add_attr = [],
    speed = 0,
    unlock_condition = 0,
    from_describe = "",
    get_way = 0,
    price = 0,
    is_showpic
}).

-record(base_baby_wing_star, {
    wing_id = 1001,
    star = 1,
    need_goods = [],
    attr_list = []}).


-record(base_baby_wing_skill_activate, {
    cell = 0,
    skill_id = 0,
    goods = 0,
    stage = 0
}).
-record(base_baby_wing_skill_upgrade, {
    skill_id = 0,
    lv = 0,
    goods = {},
    new_skill_id = 0,
    stage = 0,
    attrs = []
}).


-record(base_baby_wing_spirit, {
    type = 0,
    lv = 0,
    attrs = [],
    goods_id = 0,
    goods_num = 0,
    stage = 0
}).


-endif.