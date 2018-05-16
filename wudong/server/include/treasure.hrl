-ifndef(TREASURE_HRL).
-define(TREASURE_HRL, 1).


%%藏宝图信息
-record(treasure,{
    pkey = 0,
    map_id = 0,
    scene  = 0,
    x = 0,
    y = 0,
    shadow_kill = 0,
    pet_kill = 0,
    time = 0,
    times = 0,
    is_change = 0
}).

-record(base_treasure,{
    map_id = 0,
    min_lv = 0,
    max_lv = 0,
    use_area = [],
    drop_normal = [],
    drop_shadow = [],
    drop_pet = [],
    shadow_list = [],
    shadow_area = [],
    pet_list =[],
    pet_area = [],
    map_type = [],
    life_time = 0

}).



-endif.