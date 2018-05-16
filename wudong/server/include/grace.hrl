-define(GRACE_READY_TIME, 5 * 60).


-define(GRACE_STATE_CLOSE, 0).
-define(GRACE_STATE_READY, 1).
-define(GRACE_STATE_START, 2).

-define(GRACE_OPEN_LV, 30).

-define(GRACE_NOTICE_TIME, 5).

-define(GRACE_MAX_COLLECT, 20).


-record(st_grace, {
    round = 0,
    ref = [],
    open_state = 0,
    time = 0,
    refresh_time = 0,
    is_today = true,
    next_time = 0,
    collect_list = [],
    collect_count = dict:new()
}).


-record(base_grace, {
    round = 0,
    box_list = [],
    pos_list = [],
    refresh_time = 0
}).
