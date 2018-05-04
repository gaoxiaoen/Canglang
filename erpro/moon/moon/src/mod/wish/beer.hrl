
-define(AREA_ROLE_MAX, 30).
-define(ENTER_LEV, 1).

-define(MAPBASEID, 180).
-define(INIT_X, 500).
-define(INIT_Y, 500).

-define(THINKING_TIME, 15000).
-define(EFFECT_TIME, 4000).
-define(WAIT_TIME, 180000).

-define(MAX_BEER, 1). %%每天参与酒桶节活动次数
-define(MAX_EGG, 5). %%丢鸡蛋能够获得奖励的次数
-define(MAX_FLOWERS, 5). %%丢鲜花能够获得奖励的次数
-define(MAX_FIREWORKS, 5). %%丢烟花能够获得奖励的次数

-define(FLOWER_RAND, 50).
-define(EGG_RAND, 50).
-define(FireWork_RAND, 100).


-define(beer_npc_left_pos_x, 478).
-define(beer_npc_left_pos_y, 380).

-define(beer_npc_right_pos_x, 828).
-define(beer_npc_right_pos_y, 380).


-record(beer_data, {
    special = 0,
    title_num = 0
    }).

-record(beer_award, {
    award1 = [],
    award2 = []
    }).

%% 酒桶节地图区域信息
-record(beer_map, {
    map_id = 0,
    map_pid = 0,
    role_num = 0,
    roles = []
    }).

%% 酒桶节进程角色基础信息
-record(beer_role, {
    rid = 0,
    pid = 0,
    map_id = 0,
    map_pid = 0,
    conn_pid = 0,
    guide = [0]
    }).

%% ets角色存储角色活动信息
-record(beer_role_info, {
	rid = 0,
	beer_times = ?MAX_BEER, 
	egg_times = ?MAX_EGG,
	flower_times = ?MAX_FLOWERS,
	firework_times = ?MAX_FIREWORKS
	}).