
-define(INVADE_READY_TIME, 5 * 60).


-define(INVADE_STATE_CLOSE, 0).
-define(INVADE_STATE_READY, 1).
-define(INVADE_STATE_START, 2).

-define(INVADE_COLLECT_LIMIT, [3, 4]).

-define(INVADE_OPEN_LV, 45).

-record(st_invade, {
    round = 0,
    world_lv = 0,
    ref = [],
    open_state = 0,
    time = 0,
    is_today = true,
    next_time = 0,
    mon_pids = [],
    box_list = [],
    collect_list = []
}).

-record(base_invade, {
    round = 0,
    boss_ids = [],
    boss_pos = [],
    mon_ids = [],
    mon_pos = [],
    refresh_time = 0
}).

-record(invade_box, {
    color = 0,
    owner = 0,
    time = 0,
    top_three = [],     %%伤害输出前三
    join = [],          %%参与攻击列表
    limit = []             %%同一怪物采集限制
}).