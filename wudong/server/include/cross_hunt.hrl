-ifndef(CROSS_HUNT_HRL).
-define(CROSS_HUNT_HRL, 1).


-define(CROSS_HUNT_READY_TIME, 5 * 60).


-define(CROSS_HUNT_STATE_CLOSE, 0).
-define(CROSS_HUNT_STATE_READY, 1).
-define(CROSS_HUNT_STATE_START, 2).

-define(CROSS_HUNT_MAX_MEMBER_COUNT, 60).


-define(CROSS_HUNT_OPEN_LV, 45).

-define(MAX_CROSS_HUNT_KILL, 99).

-define(ETS_ch_mb_target, ets_ch_mb_target).
-define(ETS_CROSS_HUNT_MON, ets_cross_hunt_mon).

-define(CH_TARGET_ST_UNFINISH, 0).
-define(CH_TARGET_ST_FINISH, 1).
-define(CH_TARGET_ST_REWARD, 2).


-define(CROSS_HUNT_BOSS_ST_NO, 0).
-define(CROSS_HUNT_BOSS_ST_UNCREATE, 1).
-define(CROSS_HUNT_BOSS_ST_CREATE, 2).
-define(CROSS_HUNT_BOSS_ST_DIE, 3).

-define(CROSS_HUNT_MON_TYPE_BOSS, 1).
-define(CROSS_HUNT_MON_TYPE_NORMAL, 0).

-record(st_cross_hunt, {
    round = 0,
    world_lv = 0,
    ref = [],
    open_state = 0,
    time = 0,
    mon_list = [],
    copy_list = [],
    boss_damage_list = [],
    p_dict = dict:new()
}).

-record(cross_hunt_mb, {
    node = none,
    pkey = 0,
    pid = 0,
    sid = {},
    nickname = <<>>,
    lv = 0,
    career = 0,
    copy = 0,
    is_online = 0,
    gkey = 0,
    target = []
}).

-record(base_cross_hunt, {
    id = 0,
    mon_list = [],
    mid = 0,        %%怪物id
    type = 0,       %%类型0小怪1boss
    pos_list = [],  %%坐标列表
    refresh = 0,    %%刷新频率
    repeat = 0,        %%是否重复刷新
    goods_id = 0,       %%掉落物id
    create_time = 0,   %%创建时间戳
    boss_state = 0,
    boss_key_pid = [],
    ref = 0,
    m_pid_dict = []
}).

-record(base_hunt_target, {
    goods_id = 0,
    mid = 0
}).

-record(ch_mb_target, {
    pkey = 0,
    target = [],
    kill_count = [],
    time = 0,
    is_change = 0
}).

-record(h_target, {
    goods_id = 0,
    num = 0,
    cur = 0,
    reward_id = 0,
    is_reward = 0,
    mid = 0
}).

%%boss伤害数据
-record(ch_boss_damage, {
    node = none,
    pid = 0,
    pkey = 0,
    nickname = <<>>,
    gkey = 0,
    lv = 0,
    career = 0,
    damage = 0,
    rank = 0
}).

-endif.