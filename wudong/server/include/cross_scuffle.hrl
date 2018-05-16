-ifndef(CROSS_SCUFFLE_HRL).
-define(CROSS_SCUFFLE_HRL, 1).

-define(ETS_CROSS_SCUFFLE_RECORD, ets_cross_scuffle_record).
%%准备时间
-define(CROSS_SCUFFLE_READY_TIME, 1800).

%%活动状态--关闭
-define(CROSS_SCUFFLE_STATE_CLOSE, 0).
%%活动状态--准备
-define(CROSS_SCUFFLE_STATE_READY, 1).
%%活动状态--开启
-define(CROSS_SCUFFLE_STATE_START, 2).

%%可进入等级
-define(CROSS_SCUFFLE_ENTER_LV, 50).

%%分组--红
-define(CROSS_SCUFFLE_GROUP_RED, 1).
%%分组--蓝
-define(CROSS_SCUFFLE_GROUP_BLUE, 2).

-define(CROSS_SCUFFLE_TEAM_TIMEOUT, 60).

%%单局总时间
-define(CROSS_SCUFFLE_PLAY_TIME, 210).

%%每日奖励次数
-define(DAILY_CROSS_SCUFFLE_TIMES_LIM, 10).

-define(SCUFFLE_COMBO_BUFF_ID,56721).

-record(st_cross_scuffle, {
    open_state = 0,                 %%活动状态0未开启，1已开启
    time = 0,
    ref = none,
    team_list = [],                    %%待匹配的队伍列表
    match_list = [],                 %%匹配列表[{team_key,num}],team_key 队伍key,如果没有队伍则为玩家自身key
    mb_list = [],
    play_list = []
}).

-record(scuffle_mb, {
    node = 0,
    sn = 0,
    pkey = 0,
    pid = 0,
    nickname = <<>>,
    career = 0,
    sex = 0,
    s_career = 0,
    avatar = "",    %%头像
    times = 0,
    is_agree = 0,   %%是否同意 1是0否
    team_key = 0,  %%队伍key,如果没有队伍则为玩家自身key
    match_time = 0, %%匹配时间
    group = 0,
    score = 0,
    acc_kill = 0,
    acc_die = 0,
    acc_kill_mon = 0,
    acc_kill_mon_time = 0,
    acc_damage = 0,
    acc_damage_time = 0,
    is_alive = true,
    combo = 0,
    acc_combo = 0,
    time = 0,
    rank = 0
}).

-record(scuffle_team, {
    team_key = 0,
    time = 0,
    mb_list = []
}).

-record(ets_cross_scuffle_record, {
    pkey = 0,
    pid = 0,
    figure = 0,
    group = 0,
    time = 0
}).

-record(base_scuffle_career, {
    career = 0,
    figure = 0,
    name = <<>>,
    attrs = [],
    skill = [],
    move_speed = 0,
    att_speed = 0,
    att_area = 0
}).

-endif.