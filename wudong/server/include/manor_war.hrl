-ifndef(MANOR_WAR_HRL).
-define(MANOR_WAR_HRL, 1).


-define(ETS_MANOR, ets_manor).
-define(ETS_MANOR_WAR, ets_manor_war).
-define(ETS_MANOR_WAR_STATE,ets_manor_war_state).
%%领地战准备时间
-define(MANOR_WAR_READY_TIME, 1800).

-define(MANOR_WAR_TIME, (30 * 60)).


-define(MANOR_WAR_STATE_CLOSE, 0).
%%-define(MANOR_WAR_STATE_APPLY, 1).
-define(MANOR_WAR_STATE_READY, 2).
-define(MANOR_WAR_STATE_START, 3).

-define(MANOR_WAR_BOSS_REFRESH_TIME, 300).

-define(MANOR_WAR_COPY_NUM, 300).

-define(MANOR_WAR_GROUP_FLAG, 1).

-define(MANOR_WAR_TARGET_FLAG_ATTACK, 1).
-define(MANOR_WAR_TARGET_KILL_ROLE, 2).
-define(MANOR_WAR_TARGET_BOSS_ATTACK, 3).

-define(MANOR_PARTY_TIME, 600).

-define(MANOR_WAR_PARTY_DROP_TIME, 30).
%%
-record(st_manor_war, {
    war_state = 0,  %%领地战状态 0报名，1准备，2开始
    ref = undefined,
    end_time = 0
}).

%%领地信息
-record(manor, {
    scene_id = 0,
    gkey = 0,
    name = <<>>,
    time = 0,
    is_change = 0
}).

%%领地战信息,报名仙盟
-record(manor_war, {
    gkey = 0,
    name = <<>>,
    time = 0,
    scene_list = [],%%[{场景id,占领时间}]
    mb_list = [],
    state = 0,
    party_time = 0, %%晚宴有效期
    party_close_time = 0,%%晚宴结束时间
    party_drop_time = 0,
    party_lv = 0,
    party_exp = 0,
    party_scene = 0,
    party_full = 0,
    party_mbs = [],
    is_change = 0
}).


-record(manor_party_mb, {
    pkey = 0,
    nickname = <<>>,
    gold = 0,
    collect_times = 0,
    rank = 0,
    drink_times = 0,
    drink_time = 0,
    toast_cd = 0,
    plug_cd = 0
}).
%%领地战玩家信息
-record(manor_war_mb, {
    pkey = 0,
    nickname = <<>>,
    gname = <<>>,
    score = 0,
    target_list = [],%%[{id,times,[]]
    rank = 0
}).

-record(base_manor_war, {
    scene_id = 0,
    flag_id = 0,
    flag_x = 0,
    flag_y = 0,
    boss_list = [],
    task_id = 0
}).


-record(base_manor_war_target, {
    target_id = 0,
    stage = 0,
    times = 0,
    reward = {}
}).

-record(base_manor_party, {
    scene_id = 0,
    x = 0,
    y = 0,
    table_list = [],
    collect_times = 0

}).

-record(base_manor_party_reward, {
    scene_id = 0,
    lv = 0,
    collect_reward = [],
    extra_reward = []
}).

-endif.