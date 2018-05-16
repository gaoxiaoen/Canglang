-ifndef(COMMON_HRL).
-define(COMMON_HRL, 1).

-define(WDJT,2018).

%%调试级别记录
%%打印
-define(PRINT(Format),
    logger:test_msg(?MODULE, ?LINE, Format, [])).
-define(PRINT(Format, Args),
    logger:test_msg(?MODULE, ?LINE, Format, Args)).
%%调试级别记录
-define(DEBUG(Format),
    logger:debug_msg(?MODULE, ?LINE, Format, [])).
-define(DEBUG(Format, Args),
    logger:debug_msg(?MODULE, ?LINE, Format, Args)).
%%警告级别记录
-define(WARNING(Format),
    logger:warning_msg(?MODULE, ?LINE, Format, [])).
-define(WARNING(Format, Args),
    logger:warning_msg(?MODULE, ?LINE, Format, Args)).
%%错误级别记录
-define(ERR(Format),
    logger:error_msg(?MODULE, ?LINE, Format, [])).
-define(ERR(Format, Args),
    logger:error_msg(?MODULE, ?LINE, Format, Args)).

%%中文替换
-define(T(T), unicode:characters_to_binary(lan:l(T))).

%%全局缓存
-define(GLOBAL_DATA_RAM, global_data_ram).

%% -define(CMDIN(Cmd,Data),plogger:cmdin(Cmd,Data)).
%% -define(CMDOUT(Cmd,Size0,Size1),plogger:cmdout(Cmd,Size0,Size1)).
-define(RECORD_TO_TUPLE_LIST(Ref, Rec), lists:zip(record_info(fields, Rec), tl(tuple_to_list(Ref)))).

-define(CALL(Pid, Request),
    try
        gen_server:call(Pid, Request)
    catch
        _:_ ->
            []
    end
).

-define(CALL_TIME_OUT(Pid, Request, TimeOut),
    try
        gen_server:call(Pid, Request, TimeOut)
    catch
        _:_ ->
            []
    end
).

-define(CAST(Pid, Request),
    catch gen_server:cast(Pid, Request)
).

-define(IS_TRUE(Val), ((is_integer(Val) andalso Val =/= 0) orelse Val =:= true)).
-define(IS_FALSE(Val), ((is_integer(Val) andalso Val =:= 0) orelse Val =:= false)).

-define(DO_IF(Bool, Clause),
    case Bool of
        true ->
            Clause;
        false ->
            false
    end
).

-define(EMPTY_DEFAULT(Value, Default),
    case Value of
        [] -> Default;
        _ -> Value
    end
).

-define(FIND_DEFAULT(Target, Pos, List, Default),
    case lists:keyfind(Target, Pos, List) of
        false -> Default;
        Data -> Data
    end
).

%% Condition ? TrueClause : FalseClause
-define(IF_ELSE(Bool, TrueClause, FalseClause),
    case Bool of
        true ->
            TrueClause;
        false ->
            FalseClause
    end
).
-define(ASSERT_TRUE(Bool, Msg),
    case Bool of
        true ->
            throw(Msg);
        _ ->
            ok
    end
).

-define(ASSERT(Bool, Cause),
    case Bool of
        false ->
            throw(Cause);
        true ->
            ok
    end
).

-define(CATCH_OK(Code, DefaultValue),
    case catch begin Code end of
        {ok, Value} ->
            Value;
        E ->
            ?PRINT(" E ~p ~n", [E]),
            DefaultValue
    end
).

-define(SEX(Career),
    case Career == ?CAREER1 of
        true -> ?MAN;
        false -> ?WOMAN
    end
).

-define(IS_NONEGATIVE_INTEGER(X), (is_integer(X) andalso X >= 0)).

-define(CATCH(X), (fun() ->
    try begin X end catch A:B -> ?ERR("~p : ~p : ~p", [A, B, erlang:get_stacktrace()]), {A, B} end end)()).

-define(DB_POOL, game_db_pool).
-define(DB_POOL_NUM, 25).

-define(LOG_WORKER_NUM, 5).

-define(SCENE_AGENT_NUM, 10).

-define(SERVER_SEND_MSG, 1).

-define(DIFF_SECONDS_1970_1900, 2208988800).
-define(DIFF_SECONDS_0000_1900, 62167219200).
-define(ONE_DAY_SECONDS, 86400).
-define(ONE_HOUR_SECONDS, 3600).
-define(FIFTEEN_MIN_SECONDS, 900).

-define(CMD_LOG, cmd_log).
%% %%flash843安全沙箱
%% -define(FL_POLICY_REQ, <<"<polic">>).
%% -define(FL_POLICY_FILE, <<"<cross-domain-policy><allow-access-from domain='*' to-ports='*' /></cross-domain-policy>">>).

%%tcp_server监听参数
-define(TCP_OPTIONS, [binary, {packet, 0}, {active, false}, {reuseaddr, true}, {nodelay, true}, {delay_send, true}, {send_timeout, 2000}, {keepalive, true}, {exit_on_close, true}, {high_watermark, 128 * 1024}, {low_watermark, 64 * 1024}]).
-define(RECV_TIMEOUT, 5000).
%%ets 建表参数
-define(ETS_OPTIONS, [named_table, public, set, {read_concurrency, true}, {write_concurrency, true}]).

%% 心跳包时间间隔
-define(HEARTBEAT_TICKET_TIME, 24 * 1000).    %%seconds
%% 最大心跳包检测失败次数
-define(HEARTBEAT_MAX_FAIL_TIME, 3).

%%ETS
-define(SERVER_STATUS, server_status).                  %% 服务器信息
-define(ETS_NODE, ets_node).                            %% 节点列表
-define(ETS_ONLINE, ets_online).                         %%玩家在线列表
-define(ETS_KF_NODES, ets_kf_nodes).                     %%跨服节点列表
-define(ETS_KF_MERGE_SN, ets_kf_merge_sn).                     %%跨服合服服务器对照
-define(ETS_SN_NAME, ets_sn_name).                     %%服务器名称
-define(ETS_KF_PLAYER, ets_kf_player).                   %%跨服玩家数据表
-define(ETS_WAR_NODES, ets_war_nodes).                   %%跨服城战信息
-define(ETS_CROSS_NODE, ets_cross_node).                    %%跨服区域分配信息
-define(ETS_CAMPAIGN_JOIN_LOG, ets_campaign_join_log).   %% 玩家活动参与记录
-define(LOGIN_FINISH, true).
-define(CAREER1, 1).          %%战士
-define(CAREER2, 2).          %%法师
-define(CAREER3, 3).          %%猎人
-define(CAREER4, 4).          %%萝莉


-define(SIGN_PLAYER, 1).        %%玩家标记
-define(SIGN_MON, 2).           %%怪物标记
-define(SIGN_PET, 3).           %%宠物标记
-define(SIGN_MAGIC_WEAPON, 4).        %%法宝标记
-define(SIGN_GOD_WEAPON, 5).        %%神器标记
-define(SIGN_BABY, 6).        %%宝宝标记

-define(MAN, 0).    %%男
-define(WOMAN, 1).  %%女

-define(GOODS_BIND, 0).          %默认不绑定
-define(GOODS_BIND_ED, 1).       %绑定

-define(HEARTBEAT, heartbeat).
-define(HEARTBEAT_SPEEDUP, heartbeat_speedup).

%%--品质颜色---
-define(WHITE, 0).       %%白色
-define(GREEN, 1).       %%绿色
-define(BLUE, 2).        %%蓝色
-define(PURPLE, 3).      %%紫色
-define(ORANGE, 4).      %%橙色
-define(GOD_EQUIP, 5).   %%神装

%%---GM----
-define(NO_GM, 0).  %%普通玩家
-define(GM_GUIDE, 1).  %%新手指导员

%%进程字典key
-define(PROC_GLOBAL_CACHE, 10000).            %%全局缓存
-define(PROC_GLOBAL_CHAT, 10001).             %%聊天
-define(PROC_EXE_ADD, 10002).                 %%经验加成
-define(PROC_GLOBAL_RANK, 10004).             %%排行榜
-define(PROC_GLOBAL_ACT, 10005).             %%活动
-define(PROC_GLOBAL_REG_REQUEST, 10006).      %%角色名请求
-define(PROC_GLOBAL_MARRY, 10007).             %%结婚

%%进程状态key
%% 【非玩家属性，只作数据存储，我们使用独立进程字典|影响玩家属性，跟场景数据有关，我们存储到player结构】
-define(PROC_STATUS_GOODS, 80001).            %%物品状态信息
-define(PROC_STATUS_TASK, 80002).             %%任务状态信息
-define(PROC_STATUS_DAILY, 80003).            %%日常状态信息
-define(PROC_STATUS_MAIL, 80004).             %%邮件状态信息
-define(PROC_STATUS_PET, 80005).              %%宠物状态信息
-define(PROC_STATUS_GIFT, 80010).             %%礼包状态信息
-define(PROC_STATUS_SHOP, 80011).             %%商城状态信息
-define(PROC_STATUS_MOUNT, 80013).            %%坐骑状态信息
-define(PROC_STATUS_TASK_CYCLE, 80014).       %%跑环任务状态信息
-define(PROC_STATUS_MYSTICAL_SHOP, 80016).    %%神秘商店信息
-define(PROC_STATUS_BLACK_SHOP, 80017).         %%黑店信息
-define(PROC_STATUS_SMELT_SHOP, 80018).         %%熔炼商店
-define(PROC_STATUS_ATHLETICS_SHOP, 80019).   %%竞技商店
-define(PROC_STATUS_PRAY, 80020).             %%祈祷
-define(PROC_STATUS_PLAY_POINT, 80021).     %%玩法剩余次数
-define(PROC_STATUS_RELATION, 80022).         %%关系状态
-define(PROC_STATUS_SIGN_IN, 80023).          %%签到
-define(PROC_STATUS_TREASURE, 80024).         %%藏宝图
-define(PROC_STATUS_FASHION, 80026).         %%时装系统
-define(PROC_STATUS_DUN_ACTIVITY, 80027).     %%活动副本
-define(PROC_STATUS_LIGHT_WEAPON, 80028).     %%光武系统
-define(PROC_STATUS_WING, 80029).             %%翅膀
-define(PROC_STATUS_DAY7LOGIN, 80030).         %%7天登陆
-define(PROC_STATUS_LVGIFT, 80031).             %%等级礼包
-define(PROC_STATUS_VIP, 80033).              %%VIP
-define(PROC_STATUS_CHARGE, 80034).           %%充值界面
-define(PROC_STATUS_D7TARGET, 80035).         %%7天目标界面
-define(PROC_STATUS_DESIGNATION, 80036).         %%称号
-define(PROC_STATUS_PLAYER_GUIDE, 80037).     %%新手引导进度
-define(PROC_STATUS_GUILD_SKILL, 80038).%%仙盟技能属性
-define(PROC_STATUS_CONVOY, 80039).             %%护送
-define(PROC_STATUS_FIRST_CHARGE, 80040).       %%首冲
-define(PROC_STATUS_DAILY_CHARGE, 80041).       %%每日充值
-define(PROC_STATUS_ACC_CHARGE, 80042).       %%累计充值
-define(PROC_STATUS_ACC_CONSUME, 80043).       %%累计消费
-define(PROC_STATUS_ONE_CHARGE, 80044).       %%单笔充值
-define(PROC_STATUS_GOLD_COUNT, 80045).       %%元宝统计
-define(PROC_STATUS_GUILD_SHOP, 80046).   %%仙盟商店
-define(PROC_STATUS_ACT_RANK, 80047).        %%冲榜活动信息
-define(PROC_STATUS_PLAYER_GIFT, 80050).     %%玩家礼包类领取状态
-define(PROC_STATUS_LIM_SHOP, 80051).   %%抢购商店
-define(PROC_STATUS_CRAZY_CLICK, 80053).   %%疯狂点击
-define(PROC_STATUS_ACT_RANK_GOAL, 80054).   %%冲榜达标返还
-define(PROC_STATUS_TAOBAO_BAG, 80055).  %%淘宝背包
-define(PROC_STATUS_TAOBAO_INFO, 80056).  %%淘宝信息
-define(PROC_STATUS_YUANLI, 80057).  %%原力信息
-define(PROC_STATUS_XIULIAN, 80058).  %%修炼信息
-define(PROC_STATUS_NEW_DAILY_CHARGE, 80059).  %%新每日充值
-define(PROC_STATUS_NEW_ONE_CHARGE, 80060).  %%新每日充值
-define(PROC_STATUS_ONLINE_GIFT, 80063).  %%在线奖励
-define(PROC_STATUS_ROLE_GOODS_COUNT, 80064).  %%个人物品产出统计
-define(PROC_STATUS_EXCHANGE, 80065).  %%兑换活动
-define(PROC_STATUS_ONLINE_TIME_GIFT, 80066).  %%在线奖励活动
-define(PROC_STATUS_BATTLE_FIELD_SHOP, 80067). %%战场商店
-define(PROC_STATUS_FINDBACK_EXP, 80071). %%离线找回经验
-define(PROC_STATUS_DAILY_ACC_CHARGE, 80074).  %%每日累计充值
-define(PROC_STATUS_FRIEND_LIKE, 80075).  %%好友评价
-define(PROC_STATUS_MONTH_CARD, 80076).  %%月卡
-define(PROC_STATUS_INVEST, 80077).  %%投资计划
-define(PROC_STATUS_LIVE_CARD, 80078).  %%月卡
-define(PROC_STATUS_MONTH_CARD_GIFT, 80079).  %%全民福利
-define(PROC_STATUS_D_F_CHARGE_RETURN, 80081).  %%每日首冲返还
-define(PROC_STATUS_ACC_CHARGE_GIFT, 80082).  %%累充礼包
-define(PROC_STATUS_ATTR_DAN, 80083).  %%属性丹
-define(PROC_STATUS_ACC_CHARGE_TURNTABLE, 80084).  %%累充转盘
%%-define(PROC_STATUS_CHAT_BUBBLE, 80085).  %%聊天气泡
-define(PROC_STATUS_STAR_LUCK, 80086).  %%星运
-define(PROC_STATUS_GOODS_EXCHANGE, 80087).  %%物品兑换
-define(PROC_STATUS_SPRITE, 80088).  %%精灵表
-define(PROC_STATUS_STAR_SHOP, 80089).  %%星运商店表
-define(PROC_STATUS_CROSS_BOSS_TIMES, 80090).  %%跨服boss次数
-define(PROC_STATUS_CROSS_HUNT, 80091).  %%跨服猎场目标
-define(PROC_STATUS_BATTLEFIELD, 80092).  %%战场信息
-define(PROC_STATUS_ROLE_D_ACC_CHARGE, 80093).  %%角色每日累充
-define(PROC_STATUS_CON_CHARGE, 80094).  %%连续充值
-define(PROC_STATUS_CROSS_ARENA, 80095).  %%跨服竞技场信息
-define(PROC_STATUS_OPEN_EGG, 80096).  %%砸蛋
-define(PROC_STATUS_GEM_EXP, 80097).  %%宝石经验
-define(PROC_STATUS_DROP_VITALITY, 80098).  %%掉落活跃度
-define(PROC_STATUS_MERGE_SIGN_IN, 80099).  %%合服签到
-define(PROC_STATUS_TARGET_ACT, 80100).  %%目标福利
-define(PROC_STATUS_MARRY, 80101).  %%结婚
-define(PROC_STATUS_MONOPOLY, 80102).  %%大富翁
-define(PROC_STATUS_TASK_DAILY, 80103).  %%跨服天天任务
-define(PROC_STATUS_EQUIP_STRENTH, 80104).  %%装备强化
-define(PROC_STATUS_VPI_GIFT, 80105).  %%vip福利礼包
-define(PROC_STATUS_WASH, 80106).    %%洗练信息
-define(PROC_STATUS_LV_ATTR, 80108).%%玩家等级属性
-define(PROC_STATUS_MERIDIAN, 80109).%%经脉
-define(PROC_STATUS_ACHIEVE, 80110).%%成就
-define(PROC_STATUS_SWORD_POOL, 80111).%%剑池
-define(PROC_STATUS_CROSS_DUNGEON, 80112).%%跨服副本
-define(PROC_STATUS_TOWER_DUNGEON, 80113).%%九霄塔副本
-define(PROC_STATUS_TOWER_DUNGEON_RANK, 80114).%%九霄塔副本排行
-define(PROC_STATUS_HP_POOL, 80115).%%血池信息
-define(PROC_STATUS_MAGIC_WEAPON, 80116).%%法宝
-define(PROC_STATUS_GOD_WEAPON, 80117).%%十荒神器
-define(PROC_STATUS_MON_PHOTO, 80118).%%图鉴
-define(PROC_STATUS_DUN_MATERIAL, 80119).%%材料副本
-define(PROC_STATUS_DUN_EXP, 80120).%%经验副本
-define(PROC_STATUS_DUN_DAILY, 80121).%%每日副本
-define(PROC_STATUS_TREASURE_HOURSE, 80122).%%玩家藏宝阁
-define(PROC_STATUS_SMELT, 80123).%%外观装备熔炼
-define(PROC_STATUS_SKILL, 80124).%%玩家技能信息
-define(PROC_STATUS_FINDBACK_SRC, 80125). %%资源离线找回
-define(PROC_STATUS_EQUIP_REFINE, 80126).  %%装备精炼
-define(PROC_STATUS_TASK_GUILD, 80127).       %%仙盟任务状态信息
-define(PROC_STATUS_FOOTPRINT, 80128).         %%足迹
-define(PROC_STATUS_BUBBLE, 80129).         %%泡泡
-define(PROC_STATUS_HQG_DAILY_CHARGE, 80130). %% 花千骨每日充值
-define(PROC_STATUS_OPEN_ACT_JH_RANK, 80131). %% 开服活动之江湖榜
-define(PROC_STATUS_OPEN_ACT_UP_TARGET, 80132). %% 开服活动之进阶目标
-define(PROC_STATUS_OPEN_ACT_GROUP_CHARGE, 80133). %% 开服活动之团购首充
-define(PROC_STATUS_OPEN_ACC_CHARGE, 80134). %%开服活动之累积充值
-define(PROC_STATUS_OPEN_ALL_TARGET, 80135). %%开服活动之全服动员
-define(PROC_STATUS_ACT_INVEST, 80136). %%投资资金活动
-define(PROC_STATUS_BUFF, 80137).%%玩家持续BUFF
-define(PROC_STATUS_ELITE, 80138).%%玩家开服1v1
-define(PROC_STATUS_ACT_MAP, 80139).%%地图寻宝
-define(PROC_STATUS_UPLV_BOX, 80140).%%进阶宝箱
-define(PROC_STATUS_PET_WEAPON, 80141).%%妖灵
-define(PROC_STATUS_MORE_EXP, 80142).%%多倍经验
-define(PROC_STATUS_ELIMINATE, 80143).%%消消乐
-define(PROC_STATUS_OPEN_ALL_RANK, 80144). %%开服活动之全民冲榜
-define(PROC_STATUS_WEEK_CARD, 80145). %%充值周卡
-define(PROC_STATUS_HEAD, 80146). %%头饰系统
-define(PROC_STATUS_CROSS_FRUIT, 80147). %%跨服水果大作战
-define(PROC_STATUS_LIMIT_BUY, 80148). %%限时抢购
-define(PROC_STATUS_FUWEN, 80149). %%符文基本信息
-define(PROC_STATUS_DRAW_TURN, 80150). %% 抽奖转盘
-define(PROC_STATUS_CROSS_FLOWER, 80151). %% 跨服鲜花榜
-define(PROC_STATUS_FUWEN_MAP, 80153). %% 符文寻宝
-define(PROC_STATUS_DUN_FUWEN_TOWER, 80154). %% 符文塔
-define(PROC_STATUS_HUNDRED_RETURN, 80155). %% 百倍返利
-define(PROC_STATUS_LOGIN_ONLINE, 80156). %% 登陆有礼
-define(PROC_STATUS_NEW_EXCHANGE, 80157). %% 新兑换活动
-define(PROC_STATUS_DUN_GOD_WEAPON, 80158).%%神器副本
-define(PROC_STATUS_ACT_EQUIP_SELL, 80159).%%特权炫装
-define(PROC_STATUS_ACT_CONVOY, 80160). %% 护送称号活动
-define(PROC_STATUS_ACC_CHARGE_D, 800161). %%大额累计充值
-define(PROC_STATUS_CONSUME_BACK_CHARGE, 800162). %%消费抽返利
-define(PROC_STATUS_CONSUME_RANK, 80163). %% 消费活动排行榜
-define(PROC_STATUS_RECHARGE_RANK, 80164). %% 充值活动排行榜
-define(PROC_STATUS_XJ_MAP, 80165). %% 仙境迷宫
-define(PROC_STATUS_DUN_GUARD, 80167).%%守护副本
-define(PROC_STATUS_CAT, 80168).%% 灵猫数据
-define(PROC_STATUS_FLOWER_RANK, 80169). %% 单服鲜花榜
-define(PROC_STATUS_ACT_CON_CHARGE, 80170).       %% 连续充值
-define(PROC_STATUS_OPEN_ACT_BACK_BUY, 80171). %% 开服活动返利抢购
-define(PROC_STATUS_GOLD_SILVER_TOWER, 80172). %% 金银塔
-define(PROC_STATUS_GOLDEN_BODY, 80173). %% 金身
-define(PROC_STATUS_MARRY_RANK, 80174). %% 结婚榜
-define(PROC_STATUS_MARRY_ROOM, 80175). %% 结婚大厅
-define(PROC_STATUS_MARRY_GIFT, 80176). %% 爱情香囊
-define(PROC_STATUS_MARRY_TREE, 80177). %% 爱情树
-define(PROC_STATUS_MARRY_HEART, 80178). %% 羁绊
-define(PROC_STATUS_MARRY_RING, 80179). %% 结婚戒指
-define(PROC_STATUS_MARRY_DESIGNATION, 80180). %% 结婚称号
-define(PROC_STATUS_MARRY_DUNGEON, 80181). %% 爱情试炼副本
-define(PROC_STATUS_BUY_MONEY, 80182). %% 招财进宝
-define(PROC_STATUS_OPEN_ACT_UP_TARGET2, 80183). %% 开服活动之进阶目标2
-define(PROC_STATUS_OPEN_ACT_UP_TARGET3, 80184). %% 开服活动之进阶目标3
-define(PROC_STATUS_MERGE_ACT_GROUP_CHARGE, 80185). %% 合服活动之团购首充
-define(PROC_STATUS_MERGE_ACT_UP_TARGET, 80186). %% 合服活动之进阶目标1
-define(PROC_STATUS_MERGE_ACT_UP_TARGET2, 80187). %% 合服活动之进阶目标2
-define(PROC_STATUS_MERGE_ACT_UP_TARGET3, 80188). %% 合服活动之进阶目标3
-define(PROC_STATUS_MERGE_ACC_CHARGE, 80189). %%合服活动之累积充值
-define(PROC_STATUS_MERGE_ACT_BACK_BUY, 80190). %% 合服活动返利抢购
-define(PROC_STATUS_MERGE_EXCHANGE, 80191). %% 合服活动兑换活动
-define(PROC_STATUS_DECORATION, 80192).         %%挂饰
-define(PROC_STATUS_MERGE_DAY7LOGIN, 80193).         %%合服7天登陆
-define(PROC_STATUS_OPEN_ALL_RANK2, 80194). %%开服活动之全民冲榜2
-define(PROC_STATUS_OPEN_ALL_RANK3, 80195). %%开服活动之全民冲榜3
-define(PROC_STATUS_OPEN_ALL_TARGET2, 80196). %%开服活动之全服动员2
-define(PROC_STATUS_OPEN_ALL_TARGET3, 80197). %%开服活动之全服动员3
-define(PROC_STATUS_EQUIP_MAGIC, 80198).         %% 装备附魔
-define(PROC_STATUS_EQUIP_SOUL, 80199).         %% 武魂
-define(PROC_STATUS_CROSS_DARK_BRIBE, 80200).  %% 跨服深渊个人数据
-define(PROC_STATUS_PLAYER_MASK, 80201).       %% 玩家掩码数据模块
-define(PROC_STATUS_CROSS_WAR, 80202). %% 跨服攻城战玩家私有数据
-define(PROC_STATUS_PLAYER_BABY, 80203).       %%玩家宝宝数据
-define(PROC_STATUS_FAIRY_SOUL, 80204). %%仙魂基本信息
-define(PROC_STATUS_BABY_WING, 80205).             %%子女翅膀
-define(PROC_STATUS_FREE_GIFT, 80206).             %%零元礼包
-define(PROC_STATUS_TASK_CHANGE_CAREER, 80207).             %%转职
-define(PROC_STATUS_NEW_WEALTH_CAT, 80208).             %%新招财猫
-define(PROC_STATUS_MYSTERY_SHOP, 80209). %%神秘商城
-define(PROC_STATUS_ACT_THROW_EGG, 80210).             %%疯狂砸蛋
-define(PROC_STATUS_WELKIN_HUNT, 80311).             %%天宫寻宝
-define(PROC_STATUS_LIMIT_TIME_GIFT, 80312). %% 限时礼包
-define(PROC_STATUS_CROSS_BOSS_DROP_NUM, 80313). %% 跨服boss掉落归属次数
%%-define(PROC_STATUS_ACT_LUCKY_TURN, 80314).             %%跨服转盘抽奖
%%-define(PROC_STATUS_ACT_LOCAL_LUCKY_TURN,80315).        %%本服转盘抽奖
-define(PROC_STATUS_SMALL_CHARGE, 80316). %% 小额充值活动
-define(PROC_STATUS_ONE_GOLD_BUY, 80317). %% 一元抢购活动
-define(PROC_STATUS_HI_FAN_TIAN, 80318). %% 全民hi翻天
-define(PROC_STATUS_ACT_THROW_FRUIT, 80319).             %%水果大战
-define(PROC_STATUS_FESTIVAL_LOGIN_GIFT, 80320). %% 节日活动之登陆有礼
-define(PROC_STATUS_FESTIVAL_ACC_CHARGE, 80321). %% 节日活动之累积充值
-define(PROC_STATUS_FESTIVAL_BACK_BUY, 80322). %% 节日活动返利抢购
-define(PROC_STATUS_BABY_MOUNT, 80323).             %%宝宝坐骑
-define(PROC_STATUS_BABY_WEAPON, 80324).             %%宝宝武器
-define(PROC_STATUS_ONLINE_REWARD, 80325).             %%在线有礼
-define(PROC_STATUS_ACT_DAILY_TASK, 80326).             %%节日活动之每日任务
-define(PROC_STATUS_FESTIVAL_EXCHANGE, 80327). %% 节日活动之兑换
-define(PROC_STATUS_ACT_FLIP_CARD, 80328).             %%节日活动之幸运翻牌
-define(PROC_STATUS_FESTIVAL_RED_GIFT, 80329). %% 节日活动之红包
-define(PROC_STATUS_ACT_OTHER_CHARGE, 80330). %% 额外特惠
-define(PROC_STATUS_ACT_SUPER_CHARGE, 80331). %% 超值特惠
-define(PROC_STATUS_ACT_CHARGE, 80332). %% 玩家当天充值数据
-define(PROC_STATUS_PLAYER_FASHION_SUIT, 80333).  %%玩家套装
-define(PROC_STATUS_DUN_EQUIP, 80334). %% 神装副本
-define(PROC_STATUS_XIAN_MAP, 80335). %% 飞仙寻宝
-define(PROC_STATUS_XIAN_STAGE, 80336). %% 飞仙阶数
-define(PROC_STATUS_XIAN_EXCHANGE, 80337). %% 仙阶兑换
-define(PROC_STATUS_XIAN_SKILL, 80338). %% 仙术
-define(PROC_STATUS_CS_CHARGE, 80339). %% 财神单笔充值活动
-define(PROC_STATUS_ACT_JBP, 80340). %% 聚宝盆
-define(PROC_STATUS_LIMIT_XIAN, 80341). %% 仙装限时活动
-define(PROC_STATUS_BUY_RED_EQUIP, 80342). %%红装抢购活动
-define(PROC_STATUS_EQUIP_SUIT, 80343). %%装备套装属性
-define(PROC_STATUS_PET_MAP, 80344). %% 宠物阵型图
-define(PROC_STATUS_CROSS_DUNGEON_GUARD, 80345).%%跨服试炼副本
-define(PROC_STATUS_PET_WAR_DUN, 80346). %% 宠物对战关卡
-define(PROC_STATUS_JADE, 80347). %% 玉佩
-define(PROC_STATUS_GOD_TREASURE, 80348). %% 仙宝
-define(PROC_STATUS_SMALL_CHARGE_D, 80349). %% 小额单笔充值
-define(PROC_STATUS_LIMIT_PET, 80350). %% 仙宠限时活动
-define(PROC_STATUS_RETURN_EXCHANGE, 80351). %% 回归活动之兑换
-define(PROC_STATUS_RE_LOGIN, 80352).         %%回归登陆
-define(PROC_STATUS_GUILD_BOX, 80353).         %%公会宝箱
-define(PROC_STATUS_CROSS_1VN_SHOP, 80354).         %%跨服1vn抢购商店
-define(PROC_STATUS_GODNESS, 80355). %% 神祇
-define(PROC_STATUS_EXP_DUNGEON, 80356).         %%经验副本投资
-define(PROC_STATUS_DUN_GODNESS, 80357).  %% 神祇副本
-define(PROC_STATUS_GODNESS_LIMIT, 80358). %% 神邸限购
-define(PROC_STATUS_CALL_GODNESS, 80359). %% 神邸唤神
-define(PROC_STATUS_ELITE_BOSS_DUN, 80360). %% 精英bossVip副本
-define(PROC_STATUS_EQUIP_SHOP, 80361). %% 装备升级
-define(PROC_STATUS_WISHING_WELL, 80362). %% 许愿池(单)
-define(PROC_STATUS_CROSS_WISHING_WELL, 80363). %% 许愿池(跨)
-define(PROC_STATUS_VIP_FACE, 80364). %% vip表情
-define(PROC_STATUS_GUILD_FIGHT, 80365). %% 公会对战
-define(PROC_STATUS_ACT_INVITATION, 80367). %% 邀请码
-define(PROC_STATUS_MARKET, 80368). %% 集市
-define(PROC_STATUS_ACT_CBP_RANK, 80369). %% 跃升冲榜
-define(PROC_STATUS_ELEMENT, 80370). %% 玩家元素
-define(PROC_STATUS_JIANDAO, 80371). %% 玩家剑道
-define(PROC_STATUS_ACT_MEET_LIMIT, 80372). %% 奇遇礼包
-define(PROC_STATUS_DUN_ELEMENT, 80373). %% 元素副本
-define(PROC_STATUS_DUN_JIANDAO, 80374). %% 剑道副本
-define(PROC_STATUS_AWAKE, 80375). %% 天命觉醒
-define(PROC_STATUS_CBP,80376).%战力记录
-define(PROC_STATUS_JIANDAO_MAP,80377).%% 剑道寻宝
-define(PROC_STATUS_FCM,80378).%% 防沉迷
-define(PROC_STATUS_NEW_FREE_GIFT, 80379).   %% 新零元礼包
-define(PROC_STATUS_CROSS_MINE_HELP, 80380).   %% 仙晶矿域
-define(PROC_STATUS_ACT_CONSUME_REBATE, 80381). %%返利大厅消费返利
-define(PROC_STATUS_MERGE_ACT_CONSUME, 80382). %%合服消费奖励

-endif.