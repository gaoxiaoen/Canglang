-ifndef(GOD_WEAPON_HRL).
-define(GOD_WEAPON_HRL, 1).

-include("server.hrl").



-define(GOD_WEAPON_OPEN_LV, 20).

-define(GOD_WEAPON_STATE_LOCK, 0).
-define(GOD_WEAPON_STATE_UNLOCK, 1).
-define(GOD_WEAPON_STATE_ACTIVATED, 2).
-define(GOD_WEAPON_STATE_USED, 3).
-define(REIKI, 6101000). %% 器灵id

-record(st_god_weapon, {
    pkey = 0,
    is_change = 0,
    weapon_list = [],
    weapon_star = [], %% [#god_weapon_star{}]
    skill_id = 0,
    weapon_id = 0,
    attribute = #attribute{},
    attribute_star = #attribute{},
    cbp = 0
}).

-record(god_weapon, {
    weapon_id = 0,
    type = 0,           %% 上一次提升的类型
    spirit_list = [],   %% 器灵[{id,lv}]
    stage = 0,
    cbp = 0,
    attribute = #attribute{}
}).


-record(god_weapon_star, {
    weapon_id = 0,
    star = 0,
    wash = [], %% [#god_weapon_wash{}]
    attribute = #attribute{}   %% 总属性 等级+洗练
}).

-record(god_weapon_wash, {
    id = 0,             %% 编号id
    now_attr_type = 0,  %% 当前属性类型
    now_attr_num = 0,   %% 当前属性值
    now_star = 0,           %% 星级

    next_attr_type = 0, %% 洗练出属性类型
    next_attr_num = 0,  %% 洗练出属性值
    next_star = 0,           %% 星级
    count = 0           %% 洗练次数
}).




-record(base_god_weapon, {
    weapon_id = 0,
    name = <<>>,
    figure = 0,
    desc = <<>>,
    attrs = [],
    skill_id = 0,
    ratio = 0,
    condition = []
}).

-record(base_god_weapon_spirit, {
    weapon_id = 0,
    type = 0,
    lv = 0,
    attrs = [],
    goods_id = 0,
    goods_num = 0
}).


-record(base_god_weapon_upgrade, {
    weapon_id = 1,
    grade = 1,
    need_goods = [],
    attr = [],
    last_weapon = []
}).

-record(base_god_weapon_wash_star, {
    grade = 0,
    ratio_list = [],
    reset = [],
    max_star = 0
}).

-record(base_god_weapon_wash_open, {
    id = 0,
    grade = 0,
    weapon_id=0,
    attrs = [],
    reset = []
}).


-endif.