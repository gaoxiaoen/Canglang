%%%-------------------------------------------------------------------
%%% @author luobaqun
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 四月 2018 上午10:26
%%%-------------------------------------------------------------------
-author("luobaqun").



-define(EVENT_TYPE_1, 1).    %% 灵宝
-define(EVENT_TYPE_2, 2).    %% 小偷

-define(MINERAL_TYPE_1, 1).    %% 矿点类型1 普通
-define(MINERAL_TYPE_2, 2).    %% 矿点类型2 高级
-define(MINERAL_TYPE_3, 3).    %% 矿点类型3 稀有
-define(MINERAL_TYPE_4, 4).    %% 矿点类型4 史诗
-define(MINERAL_TYPE_5, 5).    %% 矿点类型5 传说

-define(ATT_MINE_VAL, 2).  %% 抢夺系数 2=50%

-define(MINERAL_TYPE_LIST, [?MINERAL_TYPE_1, ?MINERAL_TYPE_2, ?MINERAL_TYPE_3,?MINERAL_TYPE_4,?MINERAL_TYPE_5]).    %% 矿点类列表

-define(MINING_MAP_MAX, 25).  %% 地图大小

-define(MINE_ATT_LOG, 1). %% 进攻
-define(MINE_DEF_LOG, 2). %% 防御

-define(MINE_EVENT_LOG_TYPE_1, 1). %% 灵宝出世
-define(MINE_EVENT_LOG_TYPE_2, 2). %% 击杀小偷
-define(MINE_EVENT_LOG_TYPE_3, 3). %% 灵宝奖励
-define(MINE_EVENT_LOG_TYPE_4, 4). %% 小偷刷新

-define(ETS_CROSS_MINERAL_INFO, ets_cross_mineral_info).    %% 所有矿区数据
-define(ETS_CROSS_MINERAL_LOG, ets_cross_mineral_log).    %% 个人日志
-define(ETS_CROSS_MINERAL_ALL_LOG, ets_cross_mineral_all_log).    %% 全服日志
-define(ETS_CROSS_MINERAL_DAILY_MEET, ets_cross_mineral_daily_meet).    %% 玩家每日奇遇


-define(LOG_TYPE1, 1). %% 手动领取奖励
-define(LOG_TYPE2, 2). %% 奇遇结算
-define(LOG_TYPE3, 3). %% 邮件结算
-define(LOG_TYPE4, 4). %% 进攻小偷


-define(SCORE_TYPE_1, 1).  %% 攻占无人普通矿点
-define(SCORE_TYPE_2, 2).  %% 攻占无人高级矿点
-define(SCORE_TYPE_3, 3).  %% 攻占无人稀有矿点
-define(SCORE_TYPE_4, 4).  %% 攻占无人史诗矿点
-define(SCORE_TYPE_5, 5).  %% 攻占无人传说矿点

-define(SCORE_TYPE_6, 6).   %% 攻占玩家普通矿点
-define(SCORE_TYPE_7, 7).   %% 攻占玩家高级矿点
-define(SCORE_TYPE_8, 8).   %% 攻占玩家稀有矿点
-define(SCORE_TYPE_9, 9).   %% 攻占玩家史诗矿点
-define(SCORE_TYPE_10, 10). %% 攻占玩家传说矿点

-define(SCORE_TYPE_11, 11).  %% 小偷
-define(SCORE_TYPE_12, 12).  %% 灵宝


%% 矿洞管理进程数据
-record(st_cross_mining_manage, {
    mining_list = [],   %% 矿洞信息列表 [#mining_info{}]
    max_page = 0,       %% 最大分页
    active = 0,         %% 全服活跃度

    play_list = [],    %% [#mining_info_rank{}]
    rank_list = [],     %% [#mining_info_rank{}]
    log_list = none     %% 战报列表
}).

%% 矿洞积分信息
-record(mining_info_rank, {
    pkey = 0,
    sn = 0,
    nickname = [],
    cbp = 0,
    vip = 0,
    score = 0,
    dvip = 0,
    time = 0,
    rank = 0
}).

%% 矿洞统计信息
-record(mining_info, {
    key = {0, 0}, %% {type,page}
    type = 0,   %% 矿洞类型 普通 高级 稀有
    page = 0,
    mid = 0
}).

%% 矿洞数据
-record(st_cross_mining, {
    type = 0,   %% 矿洞类型 普通 高级 稀有
    page = 0,   %% 分页
    ref = none, %% 定时器
    see_list = [] %% 当前查看该矿的玩家列表
}).

%% 矿点数据
-record(mineral_info, {
    key = {0, 0, 0},    %% {type,page,id}
    type = 0,           %% 矿洞类型 普通 高级 稀有
    page = 0,           %% 分页
    id = 0,             %% 位置编号

    mtype = 0,          %% 矿点类型
    start_time = 0,     %% 创建时间戳

    first_hold_time = 0,%% 第一次被占领时间点
    last_hold_time = 0, %% 上一次被占领时间点
    ripe_time = 0,      %% 成熟时间戳 成熟在结算之前 first_hold_time + lift_time
    end_time = 0,       %% 结算时间戳
    is_notice = 0,      %% 是否推送成熟
    hp = 0,             %% 当前血量
    hp_lim = 0,         %% 总血量
    is_hit = 0,         %% 收获期是否被攻击
    hold_sn = 0,        %% 占领玩家服号
    hold_key = 0,       %% 占领玩家key
    hold_sex = 0,       %% 占领玩家性别
    hold_vip = 0,       %% 占领玩家vip
    hold_dvip = 0,      %% 占领玩家dvip
    hold_avatar = [],   %% 占领玩家头像
    hold_name = [],     %% 占领玩家名称
    hold_cbp = 0,     %% 占领玩家战斗力
    hold_guild_name = [],   %% 占领玩家工会名

    meet_type = 0,         %% 奇遇类型
    meet_start_time = 0,   %% 奇遇开始时间
    meet_end_time = 0,     %% 奇遇结束时间

    thief_start_time = 0,   %% 小偷开始时间
    thief_end_time = 0,     %% 小偷结束时间
    thief_cbp = 0,           %% 小偷战斗力

    help_list = []   %% [#help_info{}]

}).


-record(base_mineral_info, {
    type = 0,
    desc = [],
    life_time = 0,
    ripe_time = 0,
    att_ratio = 0,
    cbp_limit = 0,
    hp_lim = 0,
    reward = [],
    att_hp = [],
    re_ratio = [],
    event_ratio = 0,
    help_limit = 0
}).

-record(base_mining_event, {
    id = 0,
    type = 0,
    re_time = [],
    life_time = 0,
    reward = [],
    cbp = {0, 0},
    num = {0, 0},
    daily_limit = 0,
    ratio = []
}).

%% 全服日志
-record(ets_cross_mineral_all_log, {
    key = ets_cross_mineral_all_log,
    event_log = [], %% 奇遇日志 [#cross_event_log{}]
    def_log = [],    %% 防御日志 [#cross_att_log{}]
    att_log = []    %% 攻击日志 [#cross_att_log{}]
}).

-record(ets_cross_mineral_log, {
    pkey = 0,
    event_log = [], %% 奇遇日志 [#cross_event_log{}]
    def_log = [],    %% 防御日志 [#cross_att_log{}]
    att_log = []    %% 攻击日志 [#cross_att_log{}]
}).
%% 进攻日志
-record(cross_att_log, {
    pkey = 0,           %% 玩家key
    pname = [],         %% 玩家name
    location_type = 0,  %% 矿区
    location_page = 0,  %% 分页
    location_id = 0,    %% 位置
    time = 0,           %% 时间戳
    reward = [],        %% 奖励
    state = 0           %% 0失败 1成功 2进攻成功未占领
}).

%% 事件日志
-record(cross_event_log, {
    type = 0,   %% 事件类型 1灵宝出世 2击杀小偷
    name = [],  %% 角色名
    pkey = 0,  %%
    location_type = 0,  %% 矿区
    location_page = 0,  %% 分页
    location_id = 0,    %% 位置
    location_mtype = 0,    %% 矿点类型
    reward = [],        %% 奖励
    time = 0           %% 时间戳
}).


%% 玩家每日奇遇次数
-record(ets_cross_mineral_daily_meet, {
    pkey = 0,
    count = 0,
    time = 0
}).


-record(base_cross_mine_vip_help, {
    vip = 0, %% vip等级
    att = 0,    %% 攻击次数
    ratio = 0,  %% 镜像百分比
    att_num = 0, %% 每次可使用攻击人数
    att_len = 0, %% 攻击队列上限
    help_count = 0, %% 防御次数
    reset_list = [] %% 刷新消耗
}).

-record(st_cross_mine_help, {
    pkey = 0,
    my_help_list = [],   %% 已购买列表 [#help_info{}]
    reset_list = []   %% 刷新镜像列表 [#help_info{}]
}).

-record(help_info, {
    id = 0,
    pkey = 0,
    nickname = [],
    cbp = 0,
    sex = 0,
    vip = 0,
    dvip = 0,
    avatar = 0,
    time = 0
}).

