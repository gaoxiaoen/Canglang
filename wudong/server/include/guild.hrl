-ifndef(GUILD_HRL).
-define(GUILD_HRL, 1).

-define(ETS_GUILD, ets_guild).  %%仙盟ets表
-define(ETS_GUILD_BOSS_DAMAGE, ets_guild_boss_damage).  %%仙盟boss伤害ets表
-define(ETS_GUILD_MEMBER, ets_guild_member).  %%仙盟ets表
-define(ETS_GUILD_APPLY, ets_guild_apply).       %%仙盟申请列表
-define(ETS_GUILD_HISTORY, ets_guild_history).
%% -define(GUILD_BOX_ETS, ets_guild_box). %%帮派宝箱数据

-define(GUILD_TYPE_SYS, 1).%%系统仙盟类型E
-define(GUILD_TYPE_NORMAL, 0).%%普通仙盟类型E

-define(GUILD_POSITION_CHAIRMAN, 1).  %%掌门
-define(GUILD_POSITION_VICE_CHAIRMAN, 2). %%掌教
-define(GUILD_POSITION_ELDER, 3).    %%长老
-define(GUILD_POSITION_GS, 4).      %%管事
-define(GUILD_POSITION_NORMAL, 5).  %%弟子

-define(GUILD_POSITION_CHAIRMAN_COUNt, 1).%%掌门人数
-define(GUILD_POSITION_VICE_CHAIRMAN_COUNt, 2).%%掌教人数
-define(GUILD_POSITION_ELDER_COUNT, 5).%%长老人数
-define(GUILD_POSITION_GS_COUNT, 10). %%管事人数


-define(GUILD_CREATE_LV, 0).%%创建仙盟等级
-define(GUILD_CHANGE_NAME_GOLD, 300).%%改名所需元宝

-define(GUILD_TIMER_UPDATE, 900).  %%定时更新时间
-define(GUILD_SYS_GUILD_TIME, 300).  %%系统帮派时间
-define(GUILD_IMPEACH_TIME, 60).  %%弹劾时间

%%工会日志条数
-define(GUILD_LOG_LEN, 10).
-define(GUILD_CHAT_LEN, 10).

%%仙盟可申请人数
-define(GUILD_APPLY_MAX, 20).


-define(GUILD_APPLY_TIMEOUT, 2).

%%仙盟技能属性
-define(GUILD_SKILL_ATTRIBUTE, guild_skill_attribute).


%%仙盟入会默认条件
-define(GUILD_DEFAULT_CONDITION, [1, 20, 10000]).


%%弹劾费用
-define(GUILD_IMPEACH_PRICE, 100).

%%帮派每日活跃礼包ID
-define(GUILD_DAILY_HY_GIFT_ID, 11116).

%%帮派进程state
-record(guild_state, {
    sys_guild_ref = 0,
    timer_update_ref = 0,  %%定时更新计时器
    impeach_ref = 0
}).

%%仙盟信息
-record(guild, {
    gkey = 0          %%仙盟ID
    , name = <<"helloworld">>      %%仙盟名称
    , cn_time = 0    %%改名时间
    , icon = 0       %%当前使用的图标
    , icon_list = []      %%已激活图标列表
    , realm = 0      %%阵营
    , lv = 1         %%仙盟等级
    , num = 1        %%仙盟人数
    , pkey = 0   %%会长Key
    , pname = <<>>%%会长昵称
    , pcareer = 0
    , pvip = 0
    , notice = <<"helloworld">>    %%公告
    , notice_cd = 0
    , log = []       %%日志
    , dedicate = 0       %%奉献
    , acc_task = 0      %%仙盟任务完成统计数
    , type = 0           %%仙盟类型,1系统仙盟,0玩家仙盟
    , sys_id = 0         %%系统仙盟id
    , condition = []       %%申请加入条件
    , join_free = 0     %%仙盟剩余空位
    , apply_free = 0    %%申请剩余空位
    , create_time = 0
    , cbp = 0                %%成员战力总和
    , is_change = 0

    %%---活跃相关
    , last_hy_key = 0      %%上一次活跃之星
    , last_hy_val = 0       %%昨日活跃度
    , like_times = 0        %%点赞次数
    , hy_gift_time = 0      %%活跃奖励领取时间

    %%---妖魔入侵
    , max_pass_floor = 0    %%今日最高通关波数
    , pass_pkey = 0        %%通关玩家key
    , pass_floor_list = []  %%通关波数列表 [{floor,passnum}]
    , pass_update_time = 0  %%妖魔通关更新时间

    , boss_star = 1  %% boss星级
    , boss_exp = 0  %% boss经验
    , boss_state = 0  %% 0未召唤 1已召唤 2已击杀 3特殊召唤 4特殊召唤击杀
    , last_name = <<>>  %% 上一次召唤玩家
}).


%%仙盟成员信息
-record(g_member, {
    pkey = 0                 %%玩家key
    , cbp = 0              %%战力
    , pid = undefined        %%玩家进程pid
    , gkey = 0               %%仙盟ID
    , position = 0           %%职位 1会长 2副会长 3普通成员
    , name = <<>>              %%玩家名称
    , realm = 0              %%阵营
    , career = 0             %%玩家职业
    , sex = 1                %%性别
    , lv = 0                 %%玩家等
    , avatar = ""            %%头像
    , vip = 0                %%VIP等
    , is_online = 0          %%状态 0离线 1在线
    , last_login_time = 0    %%上一次登陆时间
    , login_day = 0

    %%---奉献相关
    , acc_dedicate = 0       %%奉献累计值
    , leave_dedicate = 0     %%技能升级剩余奉献
    , daily_dedicate = 0     %%今日奉献值
    , dedicate_time = 0      %%奉献时间

    %%---活跃相关
    , jc_hy_val = 0          %%剑池活跃值
    , jc_hy_time = 0         %%剑池活跃值改变时间
    , sum_hy_val = 0         %%当天总活跃值
    , like_time = 0          %%点赞时间

    %%---每日福利
    , daily_gift_get_time = 0 %%每日福利领取时间

    %%---妖魔入侵
    , highest_pass_floor = 0 %%最高通关波数
    , pass_floor = 0        %%今日通关波数
    , cheer_times = 0       %%今日助威次数
    , cheer_keys = []       %%今日助威的玩家列表 [pkey]
    , be_cheer_times = 0    %%今日被助威次数
    , demon_update_time = 0 %%更新时间
    , cheer_me_keys = []     %%助威我的玩家列表 [pkey]
    , get_demon_gift_list = []  %%领取通关奖励列表 [{floor,num1},{floor,num2}]
    , help_cheer_list = []  %%请求助威玩家 [pkey]
    , help_cheer_time = 0   %%请求助威时间

    , acc_task = 0           %%任务N日累计次数
    , task_log = []           %%每日任务完成次数列表
    , task_count = 0
    , task_time = 0
    , timestamp = 0          %%每日时间戳
    , ip = <<>>              %%来自
    , war_p = 0              %%工会战战功
    , h_war_p = 0             %%最高单次工会战战功
    , h_cbp = 0            %%历史最高战力
    , arena = 0              %%竞技场排名
    , h_arena = 0            %%竞技场最高排名
    , is_change = 0

}).

%%退出帮派的历史数据
-record(g_history, {
    pkey = 0,
    time = 0,
    q_times = 0,
    q_time = 0

    , daily_gift_get_time = 0 %%每日福利领取时间

    , pass_floor = 0        %%今日通关波数
    , cheer_times = 0       %%今日助威次数
    , cheer_keys = []       %%今日助威的玩家列表 [pkey]
    , be_cheer_times = 0    %%今日被助威次数
    , demon_update_time = 0 %%更新时间
    , get_demon_gift_list = []  %%领取通关奖励列表 [{floor,[num1,num2]}]
}).

%%仙盟申请列表
-record(g_apply, {
    akey = 0
    , pkey = 0            %%玩家key
    , gkey = 0          %%仙盟key
    , nickname = ""     %%玩家昵称
    , career = 0        %%职业
    , lv = 0            %%等级
    , cbp = 0         %%战力
    , vip = 0           %%VIP
    , from = 0          %%申请来源,0普通,1推荐
    , timestamp = 0      %%申请时间

}).

%%仙盟基础信息
-record(base_guild, {
    lv = 0,  %%仙盟等级
    dedicate = 0,  %%升级所需奉献值
    max_num = 0  %%最大人数
}).

%%创建功能条件
-record(base_create_guild, {
    type = 0,
    need_lv = 0,
    gold = 0,
    bgold = 0
}).

%%每日福利
-record(base_guild_daily_gift, {
    lv = 0,
    goods_list = []
}).

%%帮派奉献
-record(base_guild_dedicate, {
    id = 0                      %%ID
    , dedicate = 0              %%奉献值比例
}).

%%妖魔入侵
-record(base_dun_demon, {
    floor = 0,
    dun_id = 0,  %%副本id
    mon_list = [], %%怪物列表
    time = 0,   %%每波时间
    exp = 0,     %%每波怪经验奖励
    need_lv = 0,  %%所需玩家等级
    reduce = 0,  %%通关一人降低百分比
    add = 0,     %%助威一次加成百分比
    gift_list = [],  %%通关礼包
    position = {0, 0}  %%直接进入的坐标
}).

-record(g_skill, {
    pkey = 0         %%玩家key
    , skill_list = []   %%技能等级列表
    , attribute = []
    , is_change = 0

}).


-record(base_guild_skill, {
    id = 0          %%技能ID
    , name = <<>>      %%技能名称
    , desc = <<>>       %%技能描述
    , lv = 0         %%技能等级
    , glv = 0        %%仙盟等级
    , plv = 0        %%玩家等级
    , attribute = 0  %%属性值
    , contrib = 0       %%贡献
}).

%%特殊物品效果
-record(base_goods_effect, {
    goods_id = 0,
    buff_id = 0,
    mon_id = 0,
    target_num = 0
}).


%%--------------仙盟神兽--------------------

-define(GUILD_BOSS_OPEN_HOUR, 19).      %% 活动开启时间
-define(GUILD_BOSS_OPEN_MINUTE, 30).    %% 活动开启时间

-define(GUILD_BOSS_CLOSE_HOUR, 20).     %% 活动关闭时间
-define(GUILD_BOSS_CLOSE_MINUTE, 0).    %% 活动关闭时间

-record(ets_g_boss, {
    gkey = 0,
    mid = 0,
    damage_list = []  %% [#g_boss_damage{}]
}).

%%  伤害信息
-record(g_boss_damage, {
    node = none,
    pkey = 0,
    sn = 0,
    name = <<>>,
    lv = 0,
    gkey = 0,
    damage = 0,  %%个人伤害
    damage_ratio = 0,
    cbp = 0,
    rank = 0,
    online = 0,
    pid = none,
    sid = none
}).


%%--------------公会宝箱----------------------------

-define(GUILD_BOX_FREE_UP_COUTN, erlang:element(1, data_version_different:get(7))). %% 每日免费提升次数
-define(GUILD_BOX_HELP_COUTN, erlang:element(2, data_version_different:get(7))). %% 每日可协助次数
-define(GUILD_BOX_HELP_BOX_CD, erlang:element(3, data_version_different:get(7))). %% 每次协助冷却时间
-define(GUILD_BOX_HELP_BOX_IN_CD, erlang:element(4, data_version_different:get(7))). %% 协助进入冷却时间
-define(GUILD_BOX_CLEAN_HELP_CD_COST, erlang:element(5, data_version_different:get(7))). %% 清除协助冷却消耗
-define(GUILD_BOX_GET_BOX_CD, erlang:element(6, data_version_different:get(7))). %% 每次获取冷却时间
-define(GUILD_BOX_GET_BOX_IN_CD, erlang:element(7, data_version_different:get(7))). %% 获取进入冷却时间
-define(GUILD_BOX_CLEAN_GET_CD_COST, erlang:element(8, data_version_different:get(7))). %% 清除获取冷却消耗
-define(GUILD_BOX_GET_COST, erlang:element(9, data_version_different:get(7))). %% 每次提升消耗

-record(player_guild_box, {
    pkey = 0,
    get_cd = 0,
    is_get_cd = 0,
    help_cd = 0,
    is_help_cd = 0,
    index_id = 1,
    index_count = 0,
    last_time = 0 %% 最后刷新操作时间
}).

-record(guild_box, {
    box_key = 0, %% 宝箱key
    pkey = 0,
    pname = "",
    gkey = 0,
    start_time = 0, %% 宝箱创建时间
    end_time = 0, %% 宝箱结束时间
    base_id = 0, %% 宝箱配表ID
    help_list = [], %% 协助列表[{Pkey,Pname}]
    reward_list = [], %% 奖励列表
    is_open = 0 %% 0未被领取 1已被领取
}).

-record(box_state, {
    guild_box_state_list = [] %% [#guild_box{}]
}).

-record(base_guild_box, {
    base_id = 0, %%
    reward_list = [], %% 宝箱奖励
    cd_time = 0,
    other_reward = 0
}).

-record(guild_boss, {
    star = 0,
    mon_id = 0,
    guild_lv_up = 0,
    guild_lv_down = 0,
    sp_call_cost = 0,
    sp_call_reward = [],
    kill_reward = [],
    rank_list = [],
    exp = 0
}).

-record(base_guild_icon, {
    id = 0,
    icon = 0,
    limit = 0
}).

-record(guild_boss_feeding, {
    goods_exp = 0,
    goods_lim = 0,
    gold_cost = 0,
    gold_exp = 0,
    gold_lim = 0
}).

-endif.