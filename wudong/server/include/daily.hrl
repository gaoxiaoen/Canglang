%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 日常计数
%%% @end
%%% Created : 16. 一月 2015 18:56
%%%-------------------------------------------------------------------

-record(st_daily_count, {
    pkey = 0,
    daily_count = dict:new(),
    time = 0,
    is_change = 0
}).

%%计数类型宏定义
-define(DAILY_DUNGEON_COUNT(DunId), 10000000 + DunId). %%副本次数
-define(DAILY_DUNGEON_BUY(DunId), 20000000 + DunId).   %%副本购买次数
-define(DAILY_ACT_RANK(TYPE, ID), 1000 + Type * 10 + ID).  %%冲榜抢购次数
-define(DAILY_CHAT_LIM, 100).
-define(DAILY_ARENA_TIMES, 103).           %%竞技场购买次数
-define(DAILY_DUNGEON_BOSS_DOUBLE_REWARD, 105).           %%挑战boss副本双倍奖励
-define(DAILY_RED_BAG_GET_NUM, 110).           %%抢红包次数
-define(DAILY_OPEN_AD, 111).                     %%开服广告时间
-define(DAILY_ELIMINATE, 112).                     %%消消乐次数
-define(DAILY_CHANGE_NAME, 113).                     %%改名时间
-define(DAILY_GUILD_GOLD_DEDICATE, 115).                     %%仙盟元宝奉献
-define(DAILY_MOUNT_STAGE, 116).
-define(DAILY_WING_STAGE, 117).
-define(DAILY_CROSS_DUNGEON, 118).
-define(DAILY_CHARGE_ACC, 119).%%每日累充
-define(DAILY_DROP_LIMIT, 120).  %%野外掉落统计
-define(DAILY_DUN_DAILY_SWEEP(Type), 5000000 + Type).%%副本扫荡状态
-define(DAILY_FACEBOOK_REG_REWARD, 800).           %%facebook 注册奖励
-define(DAILY_FACEBOOK_SHARE_REWARD, 801).           %%facebook 分享奖励
-define(DAILY_FACEBOOK_INVITE_REWARD, 802).          %%fackbook 邀请奖励
-define(DAILY_FEEDBACK, 803).                       %% GM反馈奖励
-define(DAILY_GUILD_MANOR_CONTRIBUTE, 804).               %%家园每日贡献
-define(DAILY_MORE_EXP, 805).               %%多倍经验
-define(DAILY_MORE_EXP_TIME, 806).          %%多倍经验时间
-define(DAILY_MORE_EXP_ENEMY, 807).         %%多倍经验怪物
-define(DAILY_NEW_SHOP(ID), 60000000 + ID).     %% 新商店计数
-define(DAILY_PK_EVIL(Key), {pk_evil, Key}). %%杀人罪恶统计
-define(DAILY_PK_CHIVALRY(Key), {pk_chivalry, Key}). %%杀人英雄统计
-define(DAILY_FIELD_ELITE, 808).            %%参与击杀野外boss计数
-define(DAILY_SWORD_POOL_EXP, 809).            %%剑池每日经验
-define(DAILY_TASK_REWARD, 810).            %%悬赏任务次数
-define(DAILY_DRAW_TURNTABLE, 811).            %%每日转盘次数
-define(DAILY_COLLECT_EXCHANGE, 812).            %%每日集字兑换次数
-define(DAILY_CROSS_SCUFFLE_TIMES, 813).            %%乱斗参与次数
-define(DAILY_PLANT_WATER_TIMES, 814).            %%种植浇水次数
-define(DAILY_PLANT_GOLD_SILVER_TOWER, 815).     %%每日金银塔
-define(DAILY_PLANT_WEALTH_CAT, 816).     %%每日招财猫
-define(DAILY_PARTY_TIMES, 817).%%晚宴享用次数
-define(DAILY_HI_FAN_TIAN_TIME, 818).      %% 全名hi翻天完成次数列表[{HiId,次数}]
-define(DAILY_HI_FAN_TIAN_POINT, 819).     %% 全名hi翻天今日点数
-define(DAILY_HI_FAN_TIAN_GET_LIST, 820).  %% 全名hi翻天今日领取列表
-define(DAILY_FAIRY_SOUL_TIMES, 821).%%每日猎魂次数
-define(DAILY_GOLD_FAIRY_SOUL_TIMES, 822).%%每日元宝猎魂次数
-define(DAILY_BABY_KILL_TIMES, 823).      %%宝宝每日击杀数量
-define(DAILY_BABY_GET_KILL_LIST, 824).    %% 今日已领取的KillID 列表[KillId]
-define(DAILY_ACT_LUCKY_TURN, 825).    %% 今日免费次数
-define(DAILY_HI_FAN_TIAN_GET_CON, 826).  %% 全名hi翻天今日领取条件
-define(DAILY_CHAT_LIM_STATE, 827).  %% 特殊禁言状态
-define(DAILY_ACT_LOCAL_LUCKY_TURN, 828).    %%本服转盘抽奖免费次数
-define(DAILY_DVIP_GET_GIFT_STATE, 829).     %% 钻石vip每日领取
-define(DAILY_DVIP_DIAMOND, 830).            %% vip 钻石数量
-define(DAILY_DVIP_DIAMOND_EXCHANGE, 831).   %% vip 钻石商城兑换列表[{Index,Time}]
-define(DAILY_DVIP_GOLD_EXCHANGE, 832).      %% 元宝兑换次数限制
-define(DAILY_DVIP_STEP_EXCHANGE, 833).      %% 进阶丹兑换次数
-define(DAILY_DVIP_DUN_DAILY_SWEEP(Type), 6000000 + Type). %%副本扫荡状态
-define(DAILY_DVIP_DRAW_ACT_BUY, 834).        %% 招财进宝
-define(DAILY_DVIP_DRAW_ACT_BUY_2, 835).      %% 招财进宝2
-define(DAILY_DVIP_DRAW_ACT_BUY_COIN_SUM, 836).      %% 招财进宝每日银币数量
-define(DAILY_DVIP_DRAW_ACT_BUY_XINGHUN_SUM, 837).      %% 招财进宝每日灵气数量
-define(DAILY_RECHARGE_INF_ALL_VAL, 838).  %% 充值有礼-每日充值总数
-define(DAILY_RECHARGE_INF_COUNT, 839).  %% 充值有礼领取次数
-define(DAILY_DISPLAY, 840). %% 每日主打广告
-define(DAILY_DOUBLE_GOLD, 841).  %% 每日双倍充值活动
-define(DAILY_RED_PICKUP, 842).  %% 每日捡取红名掉落
-define(DAILY_CROSS_SCUFFLE_ELITE_TIMES, 843).            %%乱斗精英赛参与次数
-define(DAILY_NEW_DOUBLE_GOLD, 844).  %% 每日双倍充值活动
-define(DAILY_ACT_MYSTERY_TREE_FREE, 845).    %% 秘境神树免费时间{index,Time}
-define(DAILY_DUN_MARRY, 846). %% 爱情试炼副本奖励
-define(DAILY_ACT_FESTIVE_BOSS, 847). %% 节日首领
-define(DAILY_WAR_TEAM_APPLY, 848). %% 战队申请
-define(DAILY_FIELD_BOSS, 849). %% 世界boss参与统计
-define(DAILY_ROLE_ATTR_DAN(Type, Id), 7000000 + 1000 + Type * 10 + Id). %%每日属性丹使用数量
-define(DAILY_ACT_CONSUME_SCORE(ID), 80000000 + ID).     %% 新消费积分计数
-define(DAILY_ACT_CONSUME_SCORE_USE, 850).     %% 新消费积分每日使用积分
-define(DAILY_PLAYER_CONSUME, 851).     %% 每日消费记录
-define(DAILY_RE_RECHARGE_INF_ALL_VAL, 852).  %% 回归充值有礼-每日充值总数
-define(DAILY_RE_RECHARGE_INF_COUNT, 853).  %% 回归充值有礼领取次数
-define(DAILY_GUILD_BOX_GET, 854).  %% 每日宝箱获取次数
-define(DAILY_GUILD_FREE_UP, 855).  %% 每日宝箱提升次数
-define(DAILY_GUILD_HELP, 856).  %% 每日宝箱协助次数
-define(DAILY_CROSS_DUNGEON_DAILY_REWARD(Times), 20000000 + Times). %%跨服副本领取状态
-define(DAILY_CROSS_1VN_EXP, 857). %%跨服1vn增加经验
-define(DAILY_CROSS_1VN_REWARD, 858). %%跨服1vn每日奖励
-define(DAILY_CROSS_1VN_WINNER_BET, 859). %%跨服1vn擂主竞猜
-define(DAILY_GUILD_BOSS_GOODS_FEEDING, 860). %%仙盟神兽每日物品喂养
-define(DAILY_GUILD_BOSS_GOLD_FEEDING, 861). %%仙盟神兽每日元宝喂养
-define(DAILY_ACT_CBP_UP, 862). %%每日战力提升差值
-define(DAILY_CROSS_MINE_ATT, 863). %%每日进攻cd {Count,Time} / {已进攻次数,下一次进攻时间戳}
-define(DAILY_ONLINE_TIME, 864). %%每日在线累计
-define(DAILY_CROSS_MINE_MEET, 865). %%每日奇遇
-define(DAILY_CROSS_MINE_THIEF, 866). %%每日进攻小偷
-define(DAILY_FCM, 867). %%防沉迷信息
-define(DAILY_CROSS_MINE_HELP, 868). %%仙晶矿域 每日进攻/协助/刷新次数



