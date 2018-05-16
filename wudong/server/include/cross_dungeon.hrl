-ifndef(CROSS_DUNGEON_HRL).
-define(CROSS_DUNGEON_HRL, 1).


%%组队副本次数
-define(CROSS_DUNGEON_TIMES, 40).
-define(CROSS_DUNGEON_Mb_LIM, 3).

-define(CROSS_DUNGEON_ROOM_TIMEOUT, 300).


-define(CROSS_DUNGEON_SHADOW_TIME, 30).
-define(CROSS_DUNGEON_SHADOW_SUB, 5).

%%房间信息
-record(ets_cross_dun_room, {
    key = 0,       %%房间KEY
    type = 0,   %%0正常玩家创建,1系统
    create_time = 0,%%创建时间
    dun_id = 0,%%副本id
    lv = 0,%%等级
    cbp = 0,%%战力
    password = "",%%密码
    mb_list = [],%%[#dungeon_mb]
    sn = 0,
    pkey = 0,
    nickname = 0,
    avatar = "",
    career = 0,
    sex = 0,
    is_fast = 1,      %%满人快速开启
    ready_ref = none,
    cd = 0,              %%招募CD
    shadow_time = 0,
    buff_id = 0,
    state = 0
}).

%%跨服副本通关记录
-record(st_cross_dun, {
    pkey = 0,
    dun_list = [],
    count_reward_list = [], %% [{id,state}]
    times = 0,
    time = 0,
    is_change = 0
}).

-record(base_dun_cross, {
    dun_id = 0,
    first_drop = 0,
    pass_drop = 0,
    extra_drop = 0,
    buff_id = 0,
    pt_extra = 0
}).

-record(base_dun_cross_reward, {
    times = 0, dixian = {}, tianxian = {}, jinxian = {}, xingjun = {}, xiandi = {}, shenzi = {}, tianshen = {}, manjie = {}
}).

-record(base_dun_cross_reward_lv, {
    times = 0,
    lv = 0,
    reward = [],
    first_reward = []
}).
-endif.