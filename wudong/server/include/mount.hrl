-ifndef(MOUNT_HRL).
-define(MOUNT_HRL, 1).

-include("server.hrl").

-define(MOUNT_OPEN_LV, data_menu_open:get(1)).

-define(MOUNT_STATE_ON, 1).
-define(MOUNT_STATE_OFF, 0).

-define(MOUNT_TYPE_NORMAL, 0).
-define(MOUNT_TYPE_MAGIC, 1).

-record(st_mount, {
    pkey = 0,
    stage = 0,
    exp = 0,
    bless_cd = 0,
    bless_notice = 0,
    current_image_id = 0,
    old_current_image_id = 0,
    current_sword_id = 0,
    own_special_image = [],
    star_list = [],
    skill_list = [],
    equip_list = [],
    grow_num = 0,
    cbp = 0,
    activation_list = [], %% [{id,[激活列表]}]
    mount_attribute = #attribute{},            %%所有坐骑给玩家附加的属性
    is_change = 0,
    spirit = 0,%%灵力值
    spirit_list = [],%%器灵[{id,lv}]
    last_spirit = 0%%上一次提升的灵脉

}).

-record(base_mount_star, {
    mount_id = 1001,
    star = 1,
    need_goods = [],
    lv_attr = [],
    attr_list = []}).

-record(base_mount_stage, {
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
    sword_image = 0,
    exp_full,
    award = {}
}).

%%-record(base_mount_level, {
%%    mount_lv = 0,
%%    stage = 0,
%%    need_exp = 0,
%%    crystal_num = 0,
%%    onekey_num = 0,
%%    once_add_exp = 0,
%%    crit_probability = 0,
%%    add_attr = [],
%%    can_evolve = 0,
%%    activate = 0,
%%    cd = 0
%%}).

-record(base_mount, {
    mount_id = 0,
    icon_id = 0,
    name = "",
    is_special = 0,
    image_id = 0,
    sword_image = 0,
    add_attr = [],
    speed = 0,
    unlock_condition = 0,
    is_double = 0,
    coordinate = [],
    is_showpic
}).

-record(base_mount_skill_activate, {
    cell = 0,
    skill_id = 0,
    goods = 0,
    stage = 0
}).
-record(base_mount_skill_upgrade, {
    skill_id = 0,
    lv = 0,
    goods = {},
    new_skill_id = 0,
    stage = 0,
    attrs = []
}).


-record(base_mount_spirit, {
    type = 0,
    lv = 0,
    attrs = [],
    goods_id = 0,
    goods_num = 0,
    stage = 0
}).
-endif.