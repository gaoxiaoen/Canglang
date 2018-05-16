-ifndef(CROSS_ELIMINATE_HRL).
-define(CROSS_ELIMINATE_HRL, 1).

-define(ETS_CROSS_ELIMINATE, ets_cross_eliminate).


-define(CROSS_ELIMINATE_SCORE, 3000).

-define(CROSS_ELIMINATE_MAX_TIMES, 5).

-define(CROSS_ELIMINATE_MAX_RANK, 50).
-define(CROSS_ELIMINATE_LV, 45).

-define(CROSS_ELIMINATE_MATCH_TIMEOUT, 5).
-define(CROSS_ELIMINATE_MB_TYPE_PLAYER, 0).
-define(CROSS_ELIMINATE_MB_TYPE_ROBOT, 1).


%%消消乐匹配列表
-record(st_eliminate, {
    match_list = [],
    pid_list = [],
    log_list = [],
    rank_list = [],
    reward_list = [],
    ref = []
}).

-record(eliminate_mb, {
    type = 0,%%0玩家,1系统
    pkey = 0,
    sn = 0,
    node = none,
    nickname = 0,
    career = 0,
    sex =0,
    avatar = <<>>,
    lv = 0,
    vip = 0,
    cbp = 0,
    fashion_cloth_id = 0,
    light_weaponid = 0,
    wing_id = 0,
    clothing_id = 0,
    weapon_id = 0,
    hp_lim = 0,
    shadow = [],
    sid = 0,
    pid = none,
    times = 0,
    combo = 0,
    score = 0,
    mon_list = [],
    group = 0,
    x = 0,
    y = 0,
    time = 0,
    rela_time = 0

}).

%%
-record(eliminate_log, {
    sn = 0,
    pkey = 0,
    nickname = <<>>,
    wins = 0,
    rank = 0
}).

-record(eliminate_mon, {
    id = 0,
    mid = 0,
    type = 0,
    x = 0,
    y = 0,
    key = 0,
    pid = none,
    buff = 0,
    group = 0,
    score = 0,
    eli_score = 0
}).


-record(elimination_reward, {
    pkey = 0,
    rank = 0,
    time = 0
}).

-record(player_eliminate, {
    pkey = 0,
    wins = 0,
    winning_streak = 0,
    losing_streak = 0,
    times = 0,
    time = 0,
    is_change = 0
}).

-endif.
