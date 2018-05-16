-ifndef(PET_WEAPON_HRL).
-define(PET_WEAPON_HRL, 1).

-include("server.hrl").



-define(PET_WEAPON_OPEN_LV, data_menu_open:get(5)).

-record(st_pet_weapon, {
    pkey = 0,
    stage = 0,
    exp = 0,
    bless_cd = 0,
    weapon_id = 0,
    figure = 0,
    skill_list = [],
    equip_list = [],
    grow_num = 0,
    cbp = 0,
    attribute = #attribute{},
    spirit = 0,%%灵力值
    spirit_list =[],
    last_spirit = 0,
    is_change = 0
}).

-record(base_pet_weapon_stage, {
    stage = 0,
    weapon_id = 0,
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


-record(base_pet_weapon_skill_activate, {
    cell = 0,
    skill_id = 0,
    goods = 0,
    stage = 0
}).
-record(base_pet_weapon_skill_upgrade, {
    skill_id = 0,
    lv = 0,
    goods = {},
    new_skill_id = 0,
    stage = 0,
    attrs = []
}).

-record(base_pet_weapon_spirit, {
    type = 0,
    lv = 0,
    attrs = [],
    goods_id = 0,
    goods_num = 0,
    stage = 0
}).

-endif.