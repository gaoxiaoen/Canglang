-ifndef(SWORD_POOL_HRL).
-define(SWORD_POOL_HRL, 1).


-define(SWORD_POOL_TYPE_DUN_EXP, 1).
-define(SWORD_POOL_TYPE_DUN_MATERIAL, 2).
-define(SWORD_POOL_TYPE_DUN_STORY, 3).
-define(SWORD_POOL_TYPE_TASK_CYCLE, 4).
-define(SWORD_POOL_TYPE_TASK_GUILD, 5).
-define(SWORD_POOL_TYPE_ARENA, 6).
-define(SWORD_POOL_TYPE_DUN_CROSS, 7).
-define(SWORD_POOL_TYPE_WORLD_BOSS, 8).
-define(SWORD_POOL_TYPE_CONVOY, 9).


-include("server.hrl").

-record(st_sword_pool, {
    pkey = 0,
    figure = 0,
    lv = 0,
    exp = 25,
    target_list = [],
    find_back_list = [],
    time = 0,
    exp_daily = 0,
    goods_daily = 0,
    attribute = #attribute{},
    cbp = 0,
    is_change = 0
}).


-record(base_sword_pool, {
    lv = 0,
    attrs = [],
    figure = 0,
    exp = 0,
    goods = {},
    exp_daily = 0,
    goods_daily = {}
}).
-record(base_sword_pool_exp, {
    type = 0,
    desc = "",
    exp = 0,
    times = 0,
    buy_times = 0,
    price = 0,
    week = []
}).


-endif.