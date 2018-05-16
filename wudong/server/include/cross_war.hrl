%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 八月 2017 11:22
%%%-------------------------------------------------------------------
-author("li").

%% 玩家私有数据
-record(st_cross_war, {
    pkey = 0,
    contrib = 0,
    contrib_list = [], %% 贡献列表
    is_member_reward = 0, %% 每日奖励0未领取1已领取
    is_king_reward = 0, %% 是否领取城主奖励
    op_time = 0, %% 操作时间
    guild_key = 0, %% 捐献时刻所在的公会
    is_orz = 0,
    is_db = 0 %% 0不写库，1写库
}).

%% 战场地图
-record(cross_war_map, {
    king_gold_x = 0,
    king_gold_y = 0, %% 宝珠坐标
    king_gold_pkey = 0, %% 携带宝珠玩家
    banner_info_list = [], %% [{x,y,sign}] 旗帜的信息列表
    jt_info_list = [] %% 箭塔 [{x,y,hp,hp_lim}] 箭塔的信息列表
}).

%% 跨服城主数据
-record(cross_war_king, {
    pkey = 0, %% 城主key
    nickname = <<>>,
    sex = 0,
    wing_id = 0,
    wepon_id = 0,
    clothing_id = 0,
    light_wepon_id = 0,
    fashion_cloth_id = 0,
    fashion_head_id = 0,
    couple_key = 0, %% 城主夫人key
    couple_nickname = <<>>,
    couple_sex = 0,
    couple_wing_id = 0,
    couple_wepon_id = 0,
    couple_clothing_id = 0,
    couple_light_wepon_id = 0,
    couple_fashion_cloth_id = 0,
    couple_fashion_head_id = 0,
    acc_win = 0, %% 连续占领次数
    node = null,
    sn = 0,
    sn_name = <<>>,
    g_key = 0,
    g_name = <<>>,
    war_info = [] %% [#cross_war_log{}]
}).

%% 跨服系统数据
-record(sys_cross_war, {
    open_state = 0,
    ref = null,
    clean_ref = null,
    update_score_ref = null,
    add_exp_ref = null,
    time = 0,
    mon_list = [],
    king_info = #cross_war_king{}, %% 城主信息 入库
    last_king_info = #cross_war_king{}, %% 上届城主信息，临时数据，不入库
    guild_sort_time = 0, %% 公会排序时间
    player_sort_time = 0, %% 玩家排序时间
    king_gold = {0, 0}, %% 王珠携带{GKey, Pkey}
    win_sign = 0, %% 上局赢方
    collect_num = 0, %% 采集宝珠次数 发奖励限制

    %% 缓存数据
    kill_war_door_list = [], %% 攻破城门玩家 [#cross_war_log{}] 入库
    kill_king_door_list = [], %% 攻破王城门玩家 [#cross_war_log{}] 入库
    kill_banner_time = 0, %% 攻破旗帜时间
    kill_banner_sign = 0, %% 攻破旗帜方
    def_guild_list = [], %% 防御方公会列表 [#cross_war_guild{}]
    att_guild_list = [], %% 攻击方公会列表 [#cross_war_guild{}]
    def_player_list = [], %% 防御方玩家列表 [Pkey]
    att_player_list = [], %% 攻击方玩家列表 [Pkey]

    map = #cross_war_map{} %% 战场地图
}).

%% 日志
-record(cross_war_log, {
    rank = 0, %% 积分排名
    pkey = 0,
    nickname = <<>>,
    sex = 0,
    g_name = <<>>,
    sn = 0,
    sn_name = <<>>,
    wing_id = 0,
    wepon_id = 0,
    clothing_id = 0,
    light_wepon_id = 0,
    fashion_cloth_id = 0,
    fashion_head_id = 0
}).

%% 跨服公会数据
-record(cross_war_guild, {
    g_key = 0,
    sign = 0, %% 阵营：1防守方2攻击方
    change_sign_time = 0, %% 切换阵营时间
    g_name = <<>>,
    sn = 0,
    sn_name = <<>>,
    is_main = 0, %% 0非城主1城主2上届城主
    node = null,
    g_pkey = 0, %% 帮主
    g_main_name = <<>>, %% 帮主名字
    g_main_sex = 0,
    g_main_wing_id = 0,
    g_main_wepon_id = 0,
    g_main_clothing_id = 0,
    g_main_light_wepon_id = 0,
    g_main_fashion_cloth_id = 0,
    g_main_fashion_head_id = 0,

    score = 0,
    score_rank = 0, %% 积分排名
    score_time = 0, %% 加积分时间
    contrib_val = 0, %% 捐献值
    contrib_time = 0, %% 捐献时间
    contrib_rank = 0, %% 捐献值排名
    player_born_xy_list = [] %% 活动开启时拿到数据
}).

%% 跨服玩家数据
-record(cross_war_player, {
    pkey = 0,
    sign = 0,
    sn = 0,
    sn_name = <<>>,
    career = 0,
    sex = 0,
    nickname = <<>>,
    wing_id = 0,
    wepon_id = 0,
    clothing_id = 0,
    light_wepon_id = 0,
    fashion_cloth_id = 0,
    fashion_head_id = 0,
    couple_pkey = 0,
    couple_sex = 0,
    couple_nickname = <<>>,
    couple_wing_id = 0,
    couple_wepon_id = 0,
    couple_clothing_id = 0,
    couple_light_wepon_id = 0,
    couple_fashion_cloth_id = 0,
    couple_fashion_head_id = 0,
    node = null,
    position = 0, %% 帮派职位
    acc_kill_num = 0, %% 连杀数
    g_key = 0,
    g_name = <<>>,
    score = 0,
    score_rank = 0, %% 积分排名
    score_time = 0, %% 加积分时间
    contrib_val = 0, %% 捐献值
    contrib_time = 0, %% 捐献时间
    contrib_rank = 0, %% 捐献值排名
    has_materis = 0, %% 当前拥有的攻城资源
    has_bomb = 0, %% 当前拥有的炸弹资源
    has_car = 0, %% 当前拥有的战车资源
    is_online = 0, %% 0不在线，1在线
    sid = null, %% 玩家网络进程
    crown = 0 %% 0无皇冠1有皇冠
}).

-define(ETS_CROSS_WAR_GUILD, ets_cross_war_guild).
-define(ETS_CROSS_WAR_PLAYER, ets_cross_war_player).

-define(CROSS_WAR_CONTRIB_DEF, 1). %% 防守贡献
-define(CROSS_WAR_CONTRIB_ATT, 2). %% 攻击贡献
-define(CROSS_WAR_TYPE_KING_REWARD, 1). %% 城主奖励
-define(CROSS_WAR_TYPE_MEMBER_REWARD, 2). %% 成员奖励
-define(CROSS_WAR_CHANGE_SIGN_CD, 10800). %% 切换阵营cd时间 3小时
-define(CROSS_WAR_SIGN_GUILD_MAX_NUM, 6). %% 阵营方最多6个阵营

%% 怪物ID相关
-define(CROSS_WAR_MON_ID_BOMB, 50114). %% 炸弹
-define(CROSS_WAR_MON_ID_BOMB2, 50110). %% 自爆炸弹
-define(CROSS_WAR_MON_ID_KING_GOLD, 50101). %% 王珠

%%清除数据(同跨服节点)定时器
-define(CROSS_WAR_ADDEXP_TIME, 10).
-define(CROSS_WAR_CLEAN_TIME, 60*60).
-define(CROSS_WAR_SORT_TIME, 60). %%排序CD时间
-define(CROSS_WAR_UPDATE_SCORE, 5). %% 通知客户端更新时间

-define(CROSS_WAR_LIMIT_LV, 80). %% 等级限制

%%准备倒计时
-define(CROSS_WAR_READY_TIME, 30 * 60).
%%活动状态--关闭
-define(CROSS_WAR_STATE_CLOSE, 0).
%%活动状态--报名
-define(CROSS_WAR_STATE_APPLY, 1).

%%活动状态--准备
-define(CROSS_WAR_STATE_READY, 2).
%%活动状态--开始
-define(CROSS_WAR_STATE_START, 3).

%%仙盟类型--防守
-define(CROSS_WAR_TYPE_DEF, 1).
%%仙盟类型--进攻
-define(CROSS_WAR_TYPE_ATT, 2).