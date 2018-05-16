-ifndef(CROSS_DUNGEON_GUARD_HRL).
-define(CROSS_DUNGEON_GUARD_HRL, 1).


%%组队副本次数
-define(CROSS_DUNGEON_GUARD_TIMES, 40).
-define(CROSS_DUNGEON_GUARD_Mb_LIM, 3).

-define(CROSS_DUNGEON_GUARD_ROOM_TIMEOUT, 300).

-define(CROSS_DUNGEON_GUARD_SHADOW_TIME, 5).
-define(CROSS_DUNGEON_GUARD_SHADOW_SUB, 5).

-define(ETS_CROSS_DUNGEON_GUARD_MILESTONE, ets_cross_dungeon_guard_milestone).    %%里程碑ets

-record(cross_guard_milestone, {
    key = {0, 0},    %% {DunId,Floor}
    time = 0,
    player_list = [] %% [#milestone_player_info{}]
}).
-record(milestone_player_info, {
    pkey = 0,                   %%玩家key
    sn = 0,                     %%服号
    sex = 0,                     %%性别
    nickname = <<>>,            %%昵称
    power = 0,                  %%战力
    fashion_cloth_id = 0,
    light_weaponid = 0,
    wing_id = 0,
    clothing_id = 0,
    weapon_id = 0

}).

%%房间信息
-record(ets_cross_dun_guard_room, {
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
-record(st_cross_dun_guard, {
    pkey = 0,
    dun_list = [],
    milestone_list = [], %% [{{Dunid,Floor},State,Time}]
    times = 0,
    time = 0,
    lv = 0,
    is_change = 0
}).

-record(base_dun_cross_guard, {
    scene = 0,
    reward = 0,
    buff_id = 0
}).


-record(base_dun_cross_guard_reward, {
    times = 0, dixian = {}, tianxian = {}, jinxian = {}, xingjun = {}, xiandi = {}, shenzi = {}, tianshen = {}, manjie = {}
}).

-record(base_mon_drop_box, {
    mon_id = 0
    , box_list = []
    , ratio = 0     %%创建宝箱的概率  100代表万分之100
    , is_notice = 0
}).

-endif.