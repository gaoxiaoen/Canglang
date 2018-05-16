-ifndef(CROSS_BOSS_HRL).
-define(CROSS_BOSS_HRL, 1).

-define(ETS_CROSS_BOSS_BUFF, ets_cross_boss_buff).

%%准备时间
-define(CROSS_BOSS_READY_TIME, 1800).

%%活动状态--关闭
-define(CROSS_BOSS_STATE_CLOSE, 0).
%%活动状态--准备
-define(CROSS_BOSS_STATE_READY, 1).
%%活动状态--开启
-define(CROSS_BOSS_STATE_START, 2).

%%活动进入等级
-define(CROSS_BOSS_ENTER_LV, 70).



-record(base_cross_boss, {
    id = 0
    ,type = 0 %% 类型（1boss，2普通怪物）
    ,boss_id = []
    ,layer = 0 %% 层数
    ,x = 0
    ,y = 0
    ,is_exp = 0 %% 杀死是否有经验
    ,goods_list = [] %% 掉落物品预览 [{物品id,物品数量}]
    ,kill_score = 0 %% 击杀获得积分
    ,kill_goods = [] %% 击杀掉落物品
    ,roll_gift = 0 %% roll 奖励礼包
    ,red_bag_id = 0 %% 红包ID
    ,luck_goods = [] %% 兴运奖励
    ,boss_icon = 0
}).

-record(st_player_cross_boss, {
    pkey = 0
    , drop_num = 0
    , op_time = 0
}).

-record(st_cross_boss, {
    open_state = 0,                 %%活动状态0未开启，1已开启
    time = 0,
    start_time = 0,
    ref = undefined,
    ref_boss_hp = undefined,
    is_kill = 0,
    boss_id = 0,
    boss_ids = [], %% boss配置列表
    hp_percent = 0,
    boss_pid_list = [],
    kill_list = [],
    boss_hp_list = [],
    boss_drop_has_list = [], %% 掉落归属[{mon_id, key}]
    kill_total_num = 0,
    damage_list = [], %% 储存玩家的信息
    damage_guild_list = [] %% 储存公会的信息
}).

%%成员信息
-record(cb_damage, {
    sn = 0,
    sn_name = <<>>, %% 服务器名字
    key = 0,        %%玩家key
    pid = none,     %%玩家PID
    sid = {},
    lv = 0,
    sex = 0,
    layer = 0,      %%当前层数
    avatar = "",
    guild_key = 0,  %%公会Key
    guild_name = <<>>, %%公会昵称
    guild_main = 0, %%1盟主0成员
    guild_main_name = <<>>, %%会长昵称
    kill_player_score = 0, %% 击杀其他仙盟玩家获得积分
    kill_player_num = 0,
    kill_player_main_score = 0, %% 击杀其他仙盟盟主获得积分
    kill_mon_score = 0, %% 击杀boss获得积分
    kill_mon_num = 0,
    kill_boss_score = 0, %% 击杀终极boss获得积分
    kill_boss_num = 0,
    online_min = 0, %% 在线时长（单位分）
    online_score = 0, %% 在线时间获得积分
    score = 0, %% 总积分
    name = <<>>,    %%昵称
    node = none,    %%节点
    is_online = 0,  %%是否在线
    copy = 0,       %%线路
    damage = 0,     %%伤害值
    rank = 0,        %%排名
    is_multiple = 0,%%是否多倍
    recv_score_reward = [], %%领取积分列表
    enter_time = 0, %% 进入时间
    boss_drop_num = 0, %% 掉落归属次数(疲劳度)
    kill_log_list = [] %% 储存击杀pkey列表 [{pkey,kill_num}]
}).

%%公会信息
-record(cb_guild_damage, {
    guild_key = 0,  %%公会Key
    guild_name = <<>>, %%公会昵称
    guild_main_key = 0, %%公会长key
    guild_main_name = <<>>, %%公会长昵称
    player_num = 0, %% 参加的玩家数量
    score = 0,      %%公会总积分
    node = none,    %%节点
    rank = 0        %%排名
}).

%% 采集怪
-record(base_cross_boss_box_mon, {
    id = 0
    ,boss_id = 0
    ,mon_id = 0
    ,x = 0
    ,y = 0
}).

-record(base_cross_boss_score, {
    max_online=0
    ,max_kill_mon=0
    ,max_kill_boss=0
    ,max_kill_guild_main=0
    ,max_kill_guild_player=0
    ,online=0
    ,kill_guild_main=0
    ,kill_guild_player=0
    ,kill_mon=0
    ,kill_boss=0
}).

-endif.