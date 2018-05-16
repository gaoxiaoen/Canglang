-define(BATTLEFIELD_READY_TIME, 30 * 60).


-define(BATTLEFIELD_STATE_CLOSE, 0).
-define(BATTLEFIELD_STATE_READY, 1).
-define(BATTLEFIELD_STATE_START, 2).

-define(BATTLEFIELD_ENTER_LV, 45).

-define(ETS_BF_SKILL, ets_bf_skill).

-record(st_battlefield, {
    ref = [],
    open_state = 0,
    is_finish = 0,
    time = 0,
    copy_list = [],
    p_dict = dict:new(),
    collect_list = [],
    pos_list = []
}).

-record(bf_mb, {
    node = none,
    sn = 0,
    pkey = 0,
    pid = 0,
    sid = {},
    nickname = <<>>,
    vip = 0,
    copy = 0,
    group = 0,
    gname = <<>>,
    cbp = 0,%%战力
    is_apply = 0,
    is_online = 0,
    quit_time = 0,
    logout_time = 0,
    %%战场数据
    acc_kill = 0,
    acc_assists = 0,
    combo = 0,
    acc_die = 0,
    acc_energy = 0,
    score = 0,
    rank = 0,
    rank_val = 0,
    skill_cd = 0,
    step = 0

}).

-record(battlefield, {
    pkey = 0,
    score = 0,
    rank = 0,
    honor = 0,
    is_change = 0,
    time = 0
}).

-record(base_battlefield_box, {
    id = 0,
    x = 0,
    y = 0,
    type = 0,
    mon_id = 0,
    refresh_time = [],
    ref = [],
    notice_ref = [],
    pid_list = [],
    notice = ""
}).

%%战场技能CD
-record(bf_skill, {
    pkey = 0,
    skill_cd = 0
}).

