-ifndef(CROSS_ARENA_HRL).
-define(CROSS_ARENA_HRL, 1).


-define(CROSS_ARENA_RANK_MAX, 1000).%%最大排名

-define(CROSS_ARENA_TIMES, 15).%%竞技次数
-define(CROSS_ARENA_TIMES_TIMER, 7200).%%竞技场次数恢复时间
-define(CROSS_ARENA_CLEAN_CD_GOLD, 20).

-define(CROSS_ARENA_LV, 1).%%开启等级

-record(cross_arena, {
    pkey = 0               %%玩家KEY
    , pid = none
    , node = none
    , nickname = <<>>
    , career = 0
    , sex = 0
    , lv = 0
    , cbp = 0
    , shadow = []
    , times = 0              %%挑战次数
    , reset_time = 0
    , buy_times = 0
    , in_cd = 0
    , cd = 0
    , time = 0              %%每日时间戳

    , rank = 0               %%排名 0 未上榜
    , vs = 0

    , challenge = []          %%挑战列表
    , refresh_cd = 0         %%刷新挑战对手CD
    , log = []
}).

%%竞技场次数信息
-record(cross_arena_mb, {
    pkey = 0,
    times = 0,
    reset_time = 0,
    buy_times = 0,
    cd = 0,
    in_cd = 0,
    time = 0,
    score = 0,
    score_reward = [],
    is_change = 0
}).

%%竞技场购买次数
-record(base_cross_arena_times, {
    vip = 0,
    buy_times = 0,
    gold = 0,
    add_times = 0

}).


%%竞技场每日奖励
-record(base_cross_arena_daily_reward, {
    rank_max = 0,
    rank_min = 0,
    goods = []

}).

%%被挑战者信息
-record(cross_challenge, {
    type = 0,
    vip = 0,
    sn = 0,
    pkey = 0,
    nickname = <<>>,
    realm = 0,
    career = 0,
    sex = 0,
    rank = 0,
    cbp = 0,
    wind_id = 0,
    weapon_id = 0,
    clothing_id = 0,
    light_weaponid = 0,
    fashion_cloth_id = 0,
    footprint_id = 0,
    fashion_head_id = 0
}).


-endif.