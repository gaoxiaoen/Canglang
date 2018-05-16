-ifndef(ARENA_HRL).
-define(ARENA_HRL, 1).


-define(ARENA_REWARD_TIME, 22 * 3600).

-define(ARENA_REWARD_CD_LIM, 1800).

-define(ARENA_TIMES, 15).%%竞技次数
-define(ARENA_TIMES_TIMER, 7200).%%竞技场次数恢复时间

-define(ARENA_CD, 5 * 60).%%竞技冷却时间
-define(ARENA_CD_LIM, 30 * 60).%%竞技冷却时间上限

%%竞技场玩家排名
-define(ROBOT_NUM, 2000).

%%竞技场清CD费用
-define(ARENA_CLEAN_CD_GOLD, 20).
%%竞技场场景ID

-define(ARENA_TYPE_ROBOT, 0).%%竞技场机器人
-define(ARENA_TYPE_PLAYER, 1).%%竞技场玩家


-define(ARENA_SCORE_WIN, 2).%%  挑战胜利积分
-define(ARENA_SCORE_LOSE, 1).   %%挑战失败积分

-define(ARENA_POS_LIST, [{3, 77}, {19, 77}, {11, 75}]).

-record(arena, {
    pkey = 0               %%玩家KEY
    , type = 0               %%玩家类型（0机器人，1玩家）
    , realm = 0                 %%阵营
    , career = 0            %%职业
    , sex = 0
    , rank = 0               %%排名 0 未上榜
    , max_rank = 0          %%历史最高排名
    , challenge = []          %%挑战列表
    , challenge_cd = 0
    , refresh_cd = 0         %%刷新挑战对手CD
    , times = 0              %%可挑战次数
    , reset_time = 0        %%恢复时间戳
    , buy_times = 0         %%今日已购买次数
    , cd = 0                %%冷却时间
    , in_cd = 0
    , wins = 0              %%连胜
    , combo = 0
    , log = []              %%日志
    , reward = []         %%奖励
    , time = 0              %%每日时间戳
    , nickname = <<>>
    , vip = 0
    , rank_reward = []      %%排名奖励记录
    , is_change = 0
}).

%%竞技场机器人
-record(base_arena_robot, {
    rank_max = 0,
    rank_min = 0,
    name = <<>>,
    power = 0,
    mon_id = 0
}).


%%竞技场购买次数
-record(base_arena_times, {
    vip = 0,
    buy_times = 0,
    limit_times = 0,
    gold = 0,
    add_times = 0

}).


%%竞技场排名奖励
-record(base_arena_rank_reward, {
    rank_max = 0,
    rank_min = 0,
    gold = 0
}).

%%竞技场每日奖励
-record(base_arena_daily_reward, {
    rank_max = 0,
    rank_min = 0,
    gold = 0,
    point = 0

}).

%%被挑战者信息
-record(challenge, {
    type = 0,
    vip = 0,
    pkey = 0,
    nickname = <<>>,
    realm = 0,
    career = 0,
    sex = 0,
    rank = 0,
    cbp = 0,
    wind_id = 0,
    weapon_id = 0,
    clothing_id = 0,
    light_weaponid = 0,
    fashion_cloth_id = 0,
    footprint_id = 0,
    fashion_head_id = 0
}).


-endif.