-define(ETS_TASK_FILTER, ets_task_filter).
-define(TASK_ST_NONE, 0).                %%任务状态无
-define(TASK_ST_ACTIVE, 1).              %%可接
-define(TASK_ST_ACCEPT, 2).              %%已接未完成
-define(TASK_ST_FINISH, 3).              %%已完成

%%任务类型
-define(TASK_TYPE_MAIN, 1).%%任务类型-主线
-define(TASK_TYPE_BRANCH, 2).%%任务类型-支线
-define(TASK_TYPE_CYCLE, 3).%%任务类型-日常跑环
-define(TASK_TYPE_GUILD, 4).%%任务类型-仙盟
-define(TASK_TYPE_CONVOY, 5).%%任务类型-护送
-define(TASK_TYPE_BET, 6).%%任务类型-点金任务
%%-define(TASK_TYPE_RECOMMEND, 7).%%任务类型-推荐任务
-define(TASK_TYPE_MANOR_WAR, 8).%%任务类型-领地任务
-define(TASK_TYPE_REWARD, 9).%%任务类型-悬赏任务
-define(TASK_TYPE_DARK, 10).%%任务类型-魔宫
-define(TASK_TYPE_CHARGE_CRAEER, 11).%%任务类型-转职
-define(TASK_TYPE_EQUIP, 12).%%任务类型-神装
-define(TASK_TYPE_XIAN, 13).%%任务类型-仙阶

-define(AUTO_TASK_TYPE_LIST, [?TASK_TYPE_MAIN, ?TASK_TYPE_BRANCH, ?TASK_TYPE_CHARGE_CRAEER]).%%需要自动接任务的类型列表

%%仙盟任务时限
-define(TASK_GUILD_DROP_TIME, 30 * 60).

%%跑环任务最大环数
-define(TASK_CYCLE_LIMIT, 20).
-define(TASK_GUILD_LIMIT, 20).
%%跑环任务一键完成单任务费用
-define(TASK_CYCLE_ONEKEY_GOLD, 10).
-define(TASK_CYCLE_REWARD_STATE_UNFINISH, 0).    %%未达成
-define(TASK_CYCLE_REWARD_STATE_UNREWARD, 1).       %%可领取
-define(TASK_CYCLE_REWARD_STATE_FINISH, 2).         %%已完成

%%任务动作类型
-define(TASK_ACT_KILL, 1).               %%杀怪
-define(TASK_ACT_COLLECT, 2).            %%采集
-define(TASK_ACT_NPC, 3).                %%npc对话
-define(TASK_ACT_GOODS, 4).              %%掉落
-define(TASK_ACT_DUNGEON, 5).            %%通关指定副本
-define(TASK_ACT_MONEY, 6).              %%收集指定货币--瞬时值
-define(TASK_ACT_ACC_MONEY, 7).              %%收集指定货币--累计值
-define(TASK_ACT_SHOP, 8).           %%购买物品
-define(TASK_ACT_LOGIN, 9).              %%指定时间段登陆
-define(TASK_ACT_PET, 10).                %%收集指定宠物
-define(TASK_ACT_ACTIVITY, 11).           %%参加指定活动
-define(TASK_ACT_TREASURE, 12).          %%寻宝
-define(TASK_ACT_TREASURE_BY_ID, 13).  %%按类型寻宝
-define(TASK_ACT_UPLV, 14).%%升级
-define(TASK_ACT_TASK_TYPE, 15).%%完成指定类型的任务
-define(TASK_ACT_STRENGTHEN, 16).%%装备强化
-define(TASK_ACT_WASH, 17).%%装备洗练
-define(TASK_ACT_STONE, 18).%%镶嵌宝石
-define(TASK_ACT_MOUNT_EQUIP, 19).%%穿戴坐骑装备
-define(TASK_ACT_MOUNT_EQUIP_STRENGTHEN, 20).%%坐骑装备强化
-define(TASK_ACT_MOUNT_STEP, 21).%%坐骑进阶
-define(TASK_ACT_CBP_EVA, 22).%%战力跑分
-define(TASK_ACT_CLICK, 23).%%疯狂点击
-define(TASK_ACT_ARENA, 24).%%竞技场挑战
-define(TASK_ACT_KMB, 25).%%击杀服务器玩家
-define(TASK_ACT_CHARGE, 26).%%充值
-define(TASK_ACT_EQUIP_STRENGTH, 27).%%X件强化Y的装备
-define(TASK_ACT_DUN_EXP, 28).%%经验副本波数
-define(TASK_ACT_MLV, 29).%%计算等级怪
-define(TASK_ACT_BET, 30).%%点金任务
-define(TASK_ACT_PET_STAGE, 31).%%宠物升阶
-define(TASK_ACT_PET_STAR, 32).%%宠物升星
-define(TASK_ACT_DUN_GOD_WEAPON, 33).%%神器副本
-define(TASK_ACT_GET_GOODS, 34). %%收集道具

%%任务动作事件列表
-define(TASK_ACT_EVENT_LIST, [
    {kill, ?TASK_ACT_KILL},
    {collect, ?TASK_ACT_COLLECT},
    {npc, ?TASK_ACT_NPC},
    {goods, ?TASK_ACT_GOODS},
    {dungeon, ?TASK_ACT_DUNGEON},
    {money, ?TASK_ACT_MONEY},
    {acc_money, ?TASK_ACT_ACC_MONEY},
    {shop, ?TASK_ACT_SHOP},
    {login, ?TASK_ACT_LOGIN},
    {pet, ?TASK_ACT_PET},
    {activity, ?TASK_ACT_ACTIVITY},
    {treasure, ?TASK_ACT_TREASURE},
    {treasureid, ?TASK_ACT_TREASURE_BY_ID},
    {uplv, ?TASK_ACT_UPLV},
    {tasktype, ?TASK_ACT_TASK_TYPE},
    {strengthen, ?TASK_ACT_STRENGTHEN},
    {wash, ?TASK_ACT_WASH},
    {stone, ?TASK_ACT_STONE},
    {mequip, ?TASK_ACT_MOUNT_EQUIP},
    {mequipstrengthen, ?TASK_ACT_MOUNT_EQUIP_STRENGTHEN},
    {mstep, ?TASK_ACT_MOUNT_STEP},
    {cbpeva, ?TASK_ACT_CBP_EVA},
    {click, ?TASK_ACT_CLICK},
    {arena, ?TASK_ACT_ARENA},
    {kmb, ?TASK_ACT_KMB},
    {charge, ?TASK_ACT_CHARGE},
    {equipstrength, ?TASK_ACT_EQUIP_STRENGTH},
    {dunexp, ?TASK_ACT_DUN_EXP},
    {mlv, ?TASK_ACT_MLV},
    {bet, ?TASK_ACT_BET},
    {petstage, ?TASK_ACT_PET_STAGE},
    {petstar, ?TASK_ACT_PET_STAR},
    {dungw, ?TASK_ACT_DUN_GOD_WEAPON},
    {getgoods, ?TASK_ACT_GET_GOODS}
]).

-define(TASK_SPEC_ACT_EVENT_LIST,
    [strengthen, wash, treasure, stone, mequip,
        mequipstrengthen, mstep, cbpeva, kmb, charge,
        click, arena, dunexp, petstage, petstar]).

-define(TASK_ID_DUN_TEAM, 11280).%%组队副本任务ID

%%任务状态记录
-record(st_task, {
    pkey = 0,
    tasklist = [],            %%可接任务列表
    activelist = [],           %%已接任务列表
    loglist = [],               %%已完成任务列表
    loglist_cl = [],               %%每日清除的任务列表
    timestamp = 0                %%每日时间戳
    , story = []                  %%剧情ID
    , is_change = 0
}).

%%任务记录
-record(task, {
    taskid = 0,             %%任务id
    name = [],              %%任务名称
    type = 0,               %%任务类型
    chapter = 0,            %%章节
    sort = 0,               %%排序id
    sort_lim = 0,           %%排序上限
    next = 0,               %%连接任务
    loop = 0,               %%是否循环可接
    drop = [],              %%任务丢弃条件
    accept = [],            %%任务接受条件
    finish = [],            %%任务完成条件
    remote = 0,             %%是否远程完成
    npcid = 0,              %%接收npcid
    endnpcid = 0,           %%提交npcid
    talkid = 0,             %%接收对话id
    endtalkid = 0,          %%完成对话id
    goods = [],             %%奖励物品
    accept_time = 0,       %%接受时间
    drop_time = 0,           %%过期丢弃时间
    act = 0,                %%任务动作
    state = 0,             %%任务状态
    state_data = [],         %%任务状态
    times = 0,
    times_lim = 0,
    finish_price = 0,
    extra = []              %% 额外参数
}).

-record(task_filter, {key = 0, tid = []}).

%%对话记录
-record(talk, {
    talkid = 0,             %%说话id
    content = 0             %%说话内容
}).

%%跑环任务
-record(task_cycle, {
    pkey = 0
    , cycle = 0
    , tid = 0
    , log = []
    , is_reward = 0
    , timestamp = 0
    , is_change = 0
}).

%%跑环任务
-record(task_guild, {
    pkey = 0
    , cycle = 0
    , tid = 0
    , log = []
    , is_reward = 0
    , timestamp = 0
    , is_change = 0
}).

-record(base_convoy_time, {
    id = 0,
    time = [],
    reward = 0,
    start_time = 0,
    end_time = 0
}).

-record(base_convoy_reward, {
    lv_min = 0,
    lv_max = 0,
    color1 = [],
    color1_timeout = [],
    color1_be_rob = [],
    color1_rob = [],
    color2 = [],
    color2_timeout = [],
    color2_be_rob = [],
    color2_rob = [],
    color3 = [],
    color3_timeout = [],
    color3_be_rob = [],
    color3_rob = [],
    color4 = [],
    color4_timeout = [],
    color4_be_rob = [],
    color4_rob = []
}).

-define(TASK_CONVOY_TIMES_FIRST, 3).%%首日可护送次数
-define(TASK_CONVOY_TIMES(Vip), data_vip_args:get(20, Vip)).%%每日可护送次数
-define(TASK_CONVOY_ROB_TIMES, 3).%%每日可抢次数
-define(TASK_CONVOY_HELP_TIMES, 2).%%每日帮组次数
-define(TASK_CONVOY_TIMEOUT, 1200).%%护送超时
-record(task_convoy, {
    pkey = 0,       %%玩家KEY
    color = 0,      %%品质颜色（1白，2蓝，3紫，4橙）
    times_total = 0,       %%总护送次数
    extra_times = 0,     %%额外护送次数
    times = 0,          %%今日护送次数
    rob_times = 0,        %%今日抢夺次数
    help_times = 0,
    time = 0                  %%每日时间戳
    , is_change = 0
    , refresh_free = 0          %%免费刷新次数
    , godt = 0
    , help_list = []
}).

%%任务统计
-record(task_cron, {
    task_id = 0,
    name = <<>>,
    type = 0,
    acc_accept = 0,
    acc_finish = 0,
    is_change = 0
}).


%%转职任务
-record(task_change_career, {
    pkey = 0
    , cycle = 0
    , tid = 0
    , log = []
    , is_reward = 0
    , timestamp = 0
    , is_change = 0
}).
