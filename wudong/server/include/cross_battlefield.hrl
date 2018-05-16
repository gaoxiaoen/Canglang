-define(CROSS_BATTLEFIELD_READY_TIME, 1800).

-define(CROSS_BATTLEFIELD_STATE_CLOSE, 0).
-define(CROSS_BATTLEFIELD_STATE_READY, 1).
-define(CROSS_BATTLEFIELD_STATE_START, 2).


-define(CROSS_BATTLEFIELD_ENTER_LV, 48).
-define(CROSS_BATTLEFIELD_COPY_NUM, 8).

-record(st_cross_battlefield, {
    ref = [],
    open_state = 0,
    is_finish = 0,
    time = 0,
    p_dict = dict:new(),
    history_list = [],
    mon_list = [],
    rank_list = [],
    copy_list = [],
    buff_list = [],
    first_info = {0, <<>>},%%首位登顶玩家{sn,nickname}
    box_first_time = 0,%%顶层宝箱首次时间
    box_list = []
}).

%%记录
-record(cross_bf_box, {
    copy = 0,
    pkey = 0,
    nickname = <<>>,
    buff_id = 0,
    refresh_time = 0
}).

-record(cross_bf_mb, {
    node = none,
    pf = 0,
    sn = 0,
    pkey = 0,
    pid = 0,
    sid = {},
    nickname = <<>>,
    career = 0,
    sex = 0,
    vip = 0,
    cbp = 0,
    layer = 0,
    layer_h = 0,
    copy = 0,
    quit_time = 0,
    %%战场数据
    kill = 0,%%当前击杀
    acc_kill = 0,%%累计击杀
    acc_die = 0,%%死亡统计,到达一定次数会降层
    combo_kill = 0,%%连杀
    combo_time = 0,
    last_combo_kill = 0,
    acc_combo_kill = 0,%%最大连杀
    score = 0,%%积分
    h_score = 0,
    enter_time = 0,
    rank = 0
}).


