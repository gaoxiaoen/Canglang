-ifndef(CROSS_ELITE_HRL).
-define(CROSS_ELITE_HRL, 1).

-define(ETS_CROSS_ELITE, ets_cross_elite).
%%准备时间
-define(CROSS_ELITE_READY_TIME, 1800).

%%活动状态--关闭
-define(CROSS_ELITE_STATE_CLOSE, 0).
%%活动状态--准备
-define(CROSS_ELITE_STATE_READY, 1).
%%活动状态--开启
-define(CROSS_ELITE_STATE_START, 2).

%%可进入等级
-define(CROSS_ELITE_ENTER_LV, 50).

%%分组--红
-define(CROSS_ELITE_GROUP_RED, 1).
%%分组--蓝
-define(CROSS_ELITE_GROUP_BLUE, 2).

%%活动可挑战次数
-define(CROSS_ELITE_TIMES_LIM, 15).
%%匹配超时时间
-define(CROSS_ELITE_MATCH_TIMEOUT, 10).

-define(CROSS_ELITE_TOP_NUM, 20).

-record(st_cross_elite, {
    open_state = 0,                 %%活动状态0未开启，1已开启
    time = 0,
    ref = undef,
    vs_ref = undef,
    mb_list = [],
    match_list = [],
    vs_list = [],
    is_finish = 0,
    log = []
}).

%%玩家信息
-record(ce_mb, {
    rank = 0,
    sn = 0,
    key = 0,        %%玩家key
    pid = none,     %%玩家PID
    sid = {},
    name = <<>>,    %%昵称
    avatar = "",     %%头像
    career = 0,     %%职业
    sex = 0,
    node = none,    %%节点
    cbp = 0,
    lv = 0,         %%当前段位
    old_lv = 0,
    score = 0,      %%当前总积分
    hp = 0,
    fight_times = 0,
    win_times = 0,
    time = 0
}).

%%比赛匹配信息
-record(ce_vs, {
    type = 0,
    sn = 0,
    key = 0,        %%玩家key
    pid = none,     %%玩家PID
    sid = {},
    name = <<>>,    %%昵称
    avatar = "",     %%头像
    career = 0,     %%职业
    sex = 0,
    node = none,    %%节点
    shadow = {},
    cbp = 0,
    hp = 0,
    lv = 0,         %%段位
    score = 0,
    loop = 0,       %%循环匹配次数
    score_min = 0,    %%最小积分范围
    score_max = 0,   %%最大积分范围
    time = 0
}).

-record(st_elite, {
    pkey = 0,
    lv = 1,
    score = 0,
    times = 0,
    daily_score = 0,
    reward = [],
    time = 0,
    is_change = 0
}).

-record(base_cross_elite, {
    lv = 0,
    score = 0,
    score_lim = 0,
    daily_reward = [],
    win_score = 0,
    fail_score = 0
}).
-record(base_cross_elite_daily, {
    id = 0, times = 0, goods_list = []
}).
-endif.