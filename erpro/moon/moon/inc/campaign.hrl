%%----------------------------------------------------
%% 活动-数据结构
%%
%% @author Shawn
%%----------------------------------------------------
-define(CAMP_VER, 12).     %% 活动版本
-define(CAMP_REPAY_CONSUME_VER, 1).     %% 至尊消费特权模块
-define(CAMP_SUIT_VER, 1).              %% 时装套装活动

-define(ONLYONE,      0). %% 活动类型仅可以参加1次 
-define(EVERYDAY,     1). %% 活动期间每天可以参加一次 

-define(STARTMODE_1,        0). %% 合服即开启
-define(STARTMODE_2,  3600 * 16). %% 16点开启

%% 春节签到需要时间
-define(spring_festive_sign_time_need, 1800).
%% 春节领取总签到奖励日期
-define(spring_festive_reward_sign_date, {2013, 2, 25}).

-record(campaign, {
    id          = 0
    ,mode  = 0
    ,title      = <<>>
    ,begin_time = 0  %% {{2011,1,1},{1,1,1}}
    ,end_time   = 0  %% {{2011,1,1},{1,1,1}}
    ,do_begin = []      
    ,do_end = []
    ,do_login = []
    ,do_logout = []
    ,do_charge = []
    ,desc    = <<>>
}).

%%------------------------------------------------------
%% 后台控制活动
%%------------------------------------------------------

%% 按钮类型
-define(camp_button_type_mail, 1).       %% 邮件发放
-define(camp_button_type_location, 2).   %% 传送类
-define(camp_button_type_jump, 3).       %% 跳转类
-define(camp_button_type_exchange, 4).   %% 激活码兑换类
-define(camp_button_type_buy, 5).        %% 购买类
-define(camp_button_type_item_exchange, 6). %% 物品兑换类
-define(camp_button_type_hand, 7). %% 手动领取类

%% 结算类型
-define(camp_settlement_type_everyday, 1). %% 活动期间每天
-define(camp_settlement_type_all, 2).      %% 整个活动期间
-define(camp_settlement_type_end, 3).      %% 活动结束时间

%% 大类型
-define(camp_type_rank, 1).         %% 排行榜类型
-define(camp_type_game, 2).         %% 功能类活动
-define(camp_type_online, 3).       %% 在线类活动
-define(camp_type_pay, 4).          %% 充值类活动
-define(camp_type_play, 5).         %% 趣味玩法类
-define(camp_type_gold, 6).         %% 消费活动类

%% 二级类型[注意 排行榜二级类型参考rank.hrl中的相关榜类型 后台生成时对排行榜二级类型作+1偏移 加载数据时作-1偏移还原]
-define(camp_type_game_power, 2001).            %% 个人战斗力
-define(camp_type_game_totalpower, 2002).       %% 个人综合战斗力
-define(camp_type_game_eqm_enchant, 2003).      %% 装备强化
-define(camp_type_game_skill, 2004).            %% 技能阶数
-define(camp_type_game_petpower, 2005).         %% 宠物战斗力
-define(camp_type_game_pet_potential_avg, 2006).%% 宠物平均潜力
-define(camp_type_game_pet_grow, 2007).         %% 宠物成长
-define(camp_type_game_pet_skill_lev, 2008).    %% 宠物技能等级
-define(camp_type_game_mount_step, 2009).       %% 坐骑进阶等级
-define(camp_type_game_mount_lev, 2010).        %% 坐骑等级
-define(camp_type_game_channel_lev, 2011).      %% 元神等级
-define(camp_type_game_channel_step, 2012).     %% 元神境界
-define(camp_type_game_answer_rank, 2022).      %% 答题排名
-define(camp_type_game_guild_td_score, 2023).    %% 帮会降妖积分
-define(camp_type_game_guard_rank, 2024).       %% 洛水攻城排行
-define(camp_type_game_super_boss_total_dmg_rank, 2025).%% 远古巨龙总伤害排行
-define(camp_type_game_super_boss_dmg_rank, 2026).      %% 远古巨龙单次伤害排行
-define(camp_type_game_guild_arena_rank, 2027). %% 帮会战排行
-define(camp_type_game_guild_war_rank, 2028).   %% 阵营战排行
-define(camp_type_game_area_rank, 2029).        %% 竞技场各组排行
-define(camp_type_game_eqm_purple, 2030).       %% 紫色装备数量
-define(camp_type_game_eqm_orange, 2031).       %% 橙色装备数量
-define(camp_type_game_eqm_polish, 2032).       %% 洗练橙色装备数量
-define(camp_type_game_dungeon_tower, 2034).    %% 表镇妖塔
-define(camp_type_game_dungeon_tower_hard, 2035).%% 里镇妖塔
-define(camp_type_game_dungeon_loong, 2036).     %% 表洛水龙宫
-define(camp_type_game_dungeon_loong_hard, 2037).%% 里洛水龙宫
-define(camp_type_game_stone_quech, 2044).        %% 宝石淬炼
-define(camp_type_game_wing_step, 2045).          %% 翅膀进阶
-define(camp_type_game_activity, 2047).           %% 活跃度
-define(camp_type_game_wedding, 2049).            %% 结婚
-define(camp_type_game_sworn, 2050).              %% 结拜
-define(camp_type_game_eqm_make, 2051).           %% 装备生产
-define(camp_type_game_wedding_item, 2052).       %% 结婚信物等级(单方奖励)
-define(camp_type_game_wedding_item2, 2053).      %% 结婚信物等级(双方都奖励)
-define(camp_type_game_pet_magic_lev, 2054).      %% 魔晶等级   
-define(camp_type_game_dungeon_demon, 2055).      %% 精灵幻境
-define(camp_type_game_dungeon_tower_all, 2057).  %% 镇妖塔(不区分里表)
-define(camp_type_game_dungeon_loong_all, 2058).  %% 洛水龙宫(不区分里表)
-define(camp_type_game_world_compete, 2059).      %% 仙道会
-define(camp_type_game_escort, 2060).             %% 护送
-define(camp_type_game_god_lev, 2061).            %% 神估等级
-define(camp_type_game_soul_world_magic_lev, 2062).%% 灵戒洞天法宝等级
-define(camp_type_game_soul_world_spirit_lev, 2063).%% 灵戒洞天妖灵等级
-define(camp_type_game_demon_shape_lev, 2064).    %% 守护化形阶数
-define(camp_type_game_demon_lev, 2065).          %% 守护等级
-define(camp_type_game_wedding_price, 2066).      %% 结婚价格999
-define(camp_type_game_sworn_price, 2067).        %% 结拜价格288
-define(camp_type_game_wedding_sworn_price, 2068).%% 结婚价格999/结拜价格288
-define(camp_type_game_wing_skill_step, 2070).    %% 技能技能阶数
-define(camp_type_game_king, 2071).               %% 参与至尊王者赛
-define(camp_type_game_king_kills, 2072).         %% 至尊王者赛连斩数
-define(camp_type_game_world_compete_wins, 2073). %% 仙道会连胜数
-define(camp_type_game_demon_skill_step, 2074).   %% 守护神通等级
-define(camp_type_game_condense_eqm, 2076).       %% 装备凝炼
-define(camp_type_game_hole_lev, 2078).           %% 灵器聚灵等级
-define(camp_type_game_pet_magic_lev_qua, 2079).  %% 魔晶等级与品质
-define(camp_type_game_soul_world_spirit_lev_qua, 2080).%% 妖灵等级与品质
-define(camp_type_game_pet_rb_qua, 2081).%% 宠物真身品质
-define(camp_type_game_stone_smelt, 2082).%% 宝石熔炼

-define(camp_type_online_time, 3001).    %% 在线时长
-define(camp_type_online_login, 3002).   %% 每天登录
-define(camp_type_offline_time, 3003).   %% 离线时长
-define(camp_type_online_time_vip, 3004).          %% VIP在线时长
-define(camp_type_online_time_vip_no, 3005).       %% 非VIP在线时长
-define(camp_type_online_time_vip_week, 3006).     %% 周VIP在线时长
-define(camp_type_online_time_vip_month, 3007).    %% 月VIP在线时长
-define(camp_type_online_time_vip_half_year, 3008).%% 半年VIP在线时长
-define(camp_type_online_days, 3009).              %% 连续在线天数

-define(camp_type_pay_first, 4001).      %% 首充
-define(camp_type_pay_everyday, 4002).   %% 每天首充
-define(camp_type_pay_everytime, 4003).  %% 每次充值
-define(camp_type_pay_acc, 4004).        %% 累计充值
-define(camp_type_pay_updatefirst, 4005).%% 更新首充
-define(camp_type_pay_gold_each, 4006).  %% 单笔充值每X晶钻
-define(camp_type_pay_rate, 4007).       %% 单笔充值返还百分比
-define(camp_type_pay_each_task, 4008).  %% 充值任务
-define(camp_type_pay_acc_task, 4009).   %% 充值任务
-define(camp_type_pay_acc_ico, 4010).    %% 累计充值 独立日常充值图标
-define(camp_type_pay_acc_each, 4011).   %% 累计充值每X晶钻
-define(camp_type_pay_acc_ico2, 4012).   %% 累计充值 独立活动充值图标
-define(camp_type_pay_acc_ico3, 4013).   %% 累计充值 新版活动手动领取充值图标

-define(camp_type_play_buy, 5001).       %% 物品购买
-define(camp_type_play_exchange, 5002).  %% 物品兑换
-define(camp_type_play_nothing, 5003).   %% 纯描述
-define(camp_type_play_card, 5004).      %% 激活码/媒体卡
-define(camp_type_play_escort_child, 5005).%%护送小屁孩
-define(camp_type_play_escort, 5006).   %% 护送翻倍活动
-define(camp_type_play_flower, 5007).   %% 每次送花
-define(camp_type_play_flower_acc, 5008). %% 累计送花
-define(camp_type_play_flower_acc_each, 5009). %% 累计每送花x朵
-define(camp_type_play_practice, 5010).        %% 无限试练
-define(camp_type_play_spring_double, 5011).   %% 双倍温泉
-define(camp_type_play_casino3, 5013).       %% 寻宝 天宫赐福
-define(camp_type_play_casino4, 5014).       %% 寻宝 吉祥道场
-define(camp_type_play_npc_store_sm, 5015).  %% 神秘商店
-define(camp_type_play_lottery_camp, 5016).  %% 活动转盘 奇宝转盘
-define(camp_type_play_escort_double, 5017).   %% 双倍护送奖励
-define(camp_type_play_arena_double, 5018).    %% 双倍竞技积分
-define(camp_type_play_luck, 5020).            %% 运势
-define(camp_type_play_longzhu, 5021).         %% 召唤神龙（七星龙珠）
-define(camp_type_play_world_compete, 5022).   %% 双倍仙道会积分
-define(camp_type_play_guild_arena, 5023).     %% 双倍帮战积分
-define(camp_type_play_online_buy, 5025).      %% 在线时长达多少秒后可购买
-define(camp_type_play_task_xx, 5026).         %% 修行任务
-define(camp_type_play_task_xx_double, 5027).  %% 修行任务双倍奖励
-define(camp_type_play_dungeon_poetry, 5028).  %% 古诗乱斗
-define(camp_type_play_new_exchange, 5030).    %% 超值兑换(新版每日福利独立图标)
-define(camp_type_play_charge_card, 5032).     %% 至尊金卡之充值累积阶段
-define(camp_type_play_charge_card_reward, 5033).%% 至尊金卡充值之回馈阶段
-define(camp_type_play_longgong, 5034).   %% 单次龙宫寻宝
-define(camp_type_play_longgong_acc, 5035). %% 累计龙宫寻宝
-define(camp_type_play_longgong_acc_each, 5036). %% 每累计龙宫寻宝X次
-define(camp_type_play_xianfu, 5037).   %% 单次仙府寻宝
-define(camp_type_play_xianfu_acc, 5038). %% 累计仙府寻宝
-define(camp_type_play_xianfu_acc_each, 5039). %% 每累计仙府寻宝X次
-define(camp_type_play_tianguan, 5040).   %% 单次天官赐福
-define(camp_type_play_tianguan_acc, 5041). %% 累计天官赐福
-define(camp_type_play_tianguan_acc_each, 5042). %% 每累计天官赐福X次
-define(camp_type_play_jixiang, 5043).   %% 单次吉祥道场
-define(camp_type_play_jixiang_acc, 5044). %% 累计吉祥道场
-define(camp_type_play_jixiang_acc_each, 5045). %% 每累计吉祥道场X次
-define(camp_type_play_casino_total, 5046).   %% 单次所有寻宝
-define(camp_type_play_casino_total_acc, 5047). %% 累计所有寻宝
-define(camp_type_play_casino_total_acc_each, 5048). %% 每累计所有寻宝X次
-define(camp_type_play_tree, 5051). %% 散财树
-define(camp_type_play_lottery_gold, 5052). %% 晶钻转盘
-define(camp_type_play_repay_consume, 5053). %% 至尊消费特权

-define(camp_type_gold_casino_acc, 6001).         %% 仙境寻宝消耗
-define(camp_type_gold_casino_acc_each, 6002).    %% 仙境寻宝每消耗
-define(camp_type_gold_sm_acc, 6003).             %% 神秘商店消耗X到Y晶钻
-define(camp_type_gold_sm_acc_each, 6004).        %% 神秘商店每消耗X晶钻
-define(camp_type_gold_casino_sm_acc, 6005).      %% 仙境寻宝、神秘商店消耗X到Y晶钻
-define(camp_type_gold_casino_sm_acc_each, 6006). %% 仙境寻宝、神秘商店每消耗X晶钻
-define(camp_type_gold_shop_acc, 6007).           %% 商城消耗X到Y晶钻
-define(camp_type_gold_shop_acc_each, 6008).      %% 商城每消耗X晶钻
-define(camp_type_gold_casino_shop_sm, 6009).     %% 仙境/神秘/商城总消耗
-define(camp_type_gold_casino_shop_sm_each, 6010).%% 仙境/神秘/商城每消耗X晶钻
-define(camp_type_gold_loss_gold_all, 6011).      %% 所有总消耗
-define(camp_type_gold_loss_gold_all_each, 6012). %% 所有总消耗中每消耗X晶钻
-define(camp_type_gold_pet_magic, 6013).          %% 魔晶消耗
-define(camp_type_gold_pet_magic_each, 6014).     %% 魔晶每消耗X晶钻
-define(camp_type_gold_casino_shop_sm_ico, 6015). %% 仙境/神秘/商城总消耗(独立图标)
-define(camp_type_gold_loss_gold_all_ico, 6016).  %% 所有总消耗(独立图标)
-define(camp_type_gold_loss_gold_all_new_ico, 6017).%% 所有总消耗(新版每日消费独立图标)
-define(camp_type_gold_wing_skill_acc, 6018).     %% 翅膀技能总消耗
-define(camp_type_gold_wing_skill_each, 6019).    %% 翅膀技能每消耗
-define(camp_type_gold_demon_skill_acc, 6020).    %% 神通技能总消耗
-define(camp_type_gold_demon_skill_each, 6021).   %% 神通技能每消耗
-define(camp_type_gold_soul_world_call_acc, 6022).%% 灵戒洞天召唤总消耗
-define(camp_type_gold_soul_world_call_each, 6023).%% 灵戒洞天召唤每消耗
-define(camp_type_gold_pet_egg_each, 6026).%% 刷宠物蛋每消耗
-define(camp_type_gold_pet_egg_acc, 6027).%% 刷宠物蛋总消耗

-define(camp_can_hand_reward, [ %% 支持手工领取类型
        ?camp_type_play_buy, ?camp_type_play_exchange, ?camp_type_play_card
        ,?camp_type_play_online_buy,?camp_type_pay_acc_ico3,?camp_type_play_new_exchange
    ]
).

-define(camp_need_acc_gold, [ %% 需要累计晶钻消耗类型
        ?camp_type_gold_casino_acc, ?camp_type_gold_casino_acc_each
        ,?camp_type_gold_sm_acc, ?camp_type_gold_sm_acc_each
        ,?camp_type_gold_casino_sm_acc, ?camp_type_gold_casino_sm_acc_each
        ,?camp_type_gold_shop_acc, ?camp_type_gold_shop_acc_each
        ,?camp_type_gold_casino_shop_sm, ?camp_type_gold_casino_shop_sm_each
        ,?camp_type_gold_loss_gold_all, ?camp_type_gold_loss_gold_all_each
        ,?camp_type_gold_pet_magic, ?camp_type_gold_pet_magic_each
        ,?camp_type_play_flower_acc_each, ?camp_type_play_flower_acc
        ,?camp_type_gold_casino_shop_sm_ico, ?camp_type_gold_loss_gold_all_ico
        ,?camp_type_pay_acc_each,?camp_type_gold_loss_gold_all_new_ico
        ,?camp_type_gold_wing_skill_acc, ?camp_type_gold_wing_skill_each
        ,?camp_type_gold_demon_skill_acc, ?camp_type_gold_demon_skill_each
        ,?camp_type_gold_soul_world_call_acc, ?camp_type_gold_soul_world_call_each
        ,?camp_type_play_longgong_acc_each, ?camp_type_play_longgong_acc
        ,?camp_type_play_xianfu_acc_each, ?camp_type_play_xianfu_acc
        ,?camp_type_play_tianguan_acc_each, ?camp_type_play_tianguan_acc
        ,?camp_type_play_jixiang_acc_each, ?camp_type_play_jixiang_acc
        ,?camp_type_play_casino_total_acc_each, ?camp_type_play_casino_total_acc
        ,?camp_type_gold_pet_egg_acc, ?camp_type_gold_pet_egg_each
    ]
).

-define(camp_need_continue, [ %% 需要重复执行多次
        ?camp_type_gold_casino_acc_each, ?camp_type_gold_casino_sm_acc_each
        ,?camp_type_gold_sm_acc_each, ?camp_type_gold_shop_acc_each
        ,?camp_type_pay_gold_each, ?camp_type_gold_casino_shop_sm_each
        ,?camp_type_gold_loss_gold_all_each, ?camp_type_gold_pet_magic_each
        ,?camp_type_play_flower_acc_each, ?camp_type_pay_acc_each
        ,?camp_type_gold_wing_skill_each, ?camp_type_gold_demon_skill_each
        ,?camp_type_gold_soul_world_call_each
        ,?camp_type_play_longgong_acc_each, ?camp_type_play_xianfu_acc_each
        ,?camp_type_play_tianguan_acc_each, ?camp_type_play_jixiang_acc_each
        ,?camp_type_play_casino_total_acc_each
        ,?camp_type_gold_pet_egg_each
    ]
).

-define(camp_reward_each_out_check, [ %% 条件达成则直接发放奖励 不用对条件作出已奖励次数判断
     %%   ?camp_type_pay_everytime
    ]
).

-define(camp_return_reward_base_id, 111000).

%% 更新活动公告
-record(camp_update_notice, {
        id = 0                  %% 标志
        ,new_content = <<>>     %% 新内容
        ,update_content = <<>>  %% 更新内容
        ,bug_content = <<>>     %% BUG修复
        ,start_time = 0         %% 开始时间
        ,end_time = 0           %% 结束时间
    }
).

%% 活动任务
-record(campaign_task, {
        id = 0              %% 任务ID
        ,name = <<>>        %% 任务名称
        ,items = []         %% 物品奖励
        ,status = 1         %% 任务状态[1:正在进行 2:已完成 3:已领取] 
        ,start_time = 0     %% 开始时间
        ,count = 1          %% 完成了多少次
        ,max_count = 1      %% 最多可完成多少次数
        ,type = 2           %% 类型(1:整个活动期间 2:活动时间每天)
        ,label = label      %% 事件标签
        ,target = 0         %% 目标
        ,value = 0          %% 当前值
        ,target_val = 1     %% 目标值
    }
).


%% 特殊活动类型
-record(campaign_special, {
        id = 0
        ,items = []
        ,start_time = 0
        ,status = 0 %% 0:未领取 1:领取
        ,cond_list = []
    }
).

%% 春节活动
-record(campaign_spring_festive, {
        ver = 1
        ,online_days = []    %% 活动期间有哪些天是登录满30分钟的[{{Y, M, D}, State},..]
        ,all_online_reward = 0  %% 是否领取了总在线天数奖励
        ,day_loss_gold = 0  %% 当天消耗总晶钻
        ,last_loss_gold = 0  %% 最后消耗晶钻时间unixtime
        ,day_loss_reward = 0 %% 最后领取奖晶钻消耗奖励时间
    }
).

%% 晶钻转盘角色结构
-record(campaign_lottery_gold, {
        ver = 1
        ,id = 0             %% 活动ID
        ,layer = 1          %% 当前晶钻转盘层数
        ,gold = 0           %% 当前抽中的晶钻 0:表示已领取
    }
).

%% 至尊消费特权活动
-record(campaign_repay_consume, {
        ver = ?CAMP_REPAY_CONSUME_VER
        ,camp_id = 0        %% 活动ID
        ,status = 0         %% 【0 额度统计 1 商场消费统计 2 奖励可领取 3 奖励已领取】
        ,consume_all = 0    %% 消费额度
        ,consume_shop = 0   %% 商城消费
    }
).

%% 时装套装活动
-record(campaign_suit, {
        ver = ?CAMP_SUIT_VER
        ,camp_id = 0        %% 活动ID
        ,target_list = []   %% 目标奖励列表{Step, Index, Status, GoldVal}
        ,fill_list = []     %% 已经填充的礼包列表{Step, Index, Status, GoldVal}
    }
).

%% 劳模数据结构
-record(model_worker, {
        ver = 1
        ,id = 0         %% 活动id
        ,charge = 0     %% 充值积分
        ,active = 0     %% 活动积分
        ,score = 0      %% 总积分
        ,start_time = 0 %% 活动开始时间
        ,finish_time = 0 %% 活动结束时间
        ,rank = 0        %% 排行
        ,team = 0        %% 队伍
    }).

%% 角色身上活动数据
-record(campaign_role, {
        ver = ?CAMP_VER
        ,first_charge = 0           %% 是否已首充
        ,day_online = {0, 0}        %% 玩家当天在线时间{Time:unixtime(), AccTime}
        ,acc_gold = []              %% 累计消费晶钻[{CondId, EachAcc, Acc, LastTime}...]
        ,last_gold = 0              %% 最后一次充值晶钻数 作用于单笔充值每X晶钻[4006]
        ,loss_gold = {label, 0, 0}  %% 手工配置活动使用 累计消费晶钻值{Label:标志指定活动, G1:累计值, G2:每消耗X晶钻}
        ,reward_list = []           %% 手工领取列表[{Id, Time}]
        ,task_list = []             %% 活动任务列表[#campaign_task{}...]
        ,special_list = []          %% 特殊活动[#campaign_special{} ..]
        ,keep_days = {0, 0}         %% {Days, Time}
        ,mail_list = []             %% 后台活动信件发放奖励列表[{CondId, N, Time}....] 针对类型?camp_need_continue
        ,camp_card = {label, 0, 0}  %% {参与的至尊活动，已累计晶钻数，已抽取特权}
        ,spring_festive = #campaign_spring_festive{}        %% 春节活动相关
        ,lottery_gold = #campaign_lottery_gold{}            %% 晶钻转盘活动相关
        ,repay_consume = #campaign_repay_consume{}          %% 至尊消费特权活动 
        ,suit = #campaign_suit{}                            %% 时装套装活动
        ,accumulative = []          %% 指定时间内累计某功能次数类活动
        ,model_worker = #model_worker{}   %% 劳模活动
    }
).

%% 日常消费记录表（飞仙周年庆红包）结构
-record(campaign_daily_consume, {
        ver = 1
        ,consume_days = []    %% 活动期间每天消费额[{{Y, M, D}, Gold, State},..]
    }).
%% 总活动情况
-record(campaign_total, {  
        id = 0              %% 总活动标志
        ,name = <<>>        %% 总活动名称
        ,title = <<>>       %% 总活动标题 客户端
        ,ico = <<>>         %% 总活动图标 客户端
        ,alert = <<>>       %% 总活动提示 客户端
        ,gif = <<>>         %% 总活动动画 客户端
        ,start_time = 0     %% 活动开始时间[0:无限制]
        ,end_time = 0       %% 活动结束时间[0:无限制]
        ,camp_list = []     %% 具体活动列表
        ,is_open = 0        %% 是否打开活动界面[0:不打开， 1：打开]
    }
).

%% 具体活动
-record(campaign_adm, {
        id = 0              %% 活动ID
        ,title = <<>>       %% 活动标题  客户端专用
        ,ico = <<>>         %% 活动图标  客户端专用
        ,star = 0           %% 星级[1~5] 客户端专用
        ,alert = <<>>       %% 活动提示  客户端专用
        ,publicity = <<>>   %% 活动宣传  客户端专用 
        ,content = <<>>     %% 活动内容  客户端专用 
        ,start_time = 0     %% 开始时间[0:无限制]
        ,end_time = 0       %% 结束时间[0:无限制]
        ,is_show_time = 0   %% 是否显示倒计时[0:不显示 1:显示]
        ,msg = <<>>         %% 相关提示信息
        ,conds = []         %% 活动条件列表
        ,sort_val = 0       %% 显示排序字段
    }
).

%% 活动条件
-record(campaign_cond, {
        id = 0              %% 活动条件ID
        ,type = 0           %% 类型[1:排行榜 2:功能类 3:在线类 4:充值类 5:趣味玩法类]
        ,sec_type = 0       %% 二级类型
        ,button = 0         %% 按钮类型[1:邮件发放 2:传送类型 3:跳转类型 4:兑换类型 5:购买类型]
        ,min_lev = 0        %% 最小等级[0:无限制]
        ,max_lev = 0        %% 最大等级[0:无限制]
        ,settlement_type = 0%% 奖励结算方式[1:活动期间每天、2:整个活动期间、3:活动截止时间]
        ,reward_num = 0     %% 奖励限制次数[0:无限制]
        ,coin = 0           %% 奖励金币
        ,coin_bind = 0      %% 奖励绑定金币
        ,gold = 0           %% 奖励晶钻
        ,gold_bind = 0      %% 奖励绑定晶钻
        ,items = []         %% 奖励物品列表 [{BaseId, Bind, Num}...]
        ,mail_subject = <<>>%% 邮件标题
        ,mail_content = <<>>%% 邮件内容
        ,button_content = <<>> %% 按钮内容
        ,button_bind = <<>> %% 按钮绑定内容
        ,is_button = 0      %% 是否按钮显示
        ,msg = <<>>         %% 条件描述 
        ,conds = []         %% 达成条件
        ,sort_val = 0       %% 显示排序字段
        ,sex = 99           %% 性别要求
        ,career = 0         %% 职业要求
        ,reward_msg = <<>>  %% 奖励说明
        ,hf = <<>>          %% 横幅
        ,skin_type = 1      %% 外观类型[1:宠物变身 2:坐骑外观 3:人物变身]
        ,skin_id = 0        %% 外观ID号
        ,attr_msg = <<>>    %% 属性加成信息
        ,say_msg = <<>>     %% 宠物说话信息
        ,flash_items = []   %% 闪光效果物品列表 [BaseId1,BaseId2]
    }
).


%% 达成条件字段#campaign_cond.conds说明: Max=0表示无限制
%% [] 无特殊要求
%% [{pay_acc, Min, Max}]        要求累计充值
%% [{pay_each, Min, Max}]       每次充值要求
%% [{pay_update, Min, Max}]     更新首值要求
%% [{pay_everyday, Min, Max}]   每天首值要求
%% [{pay_first, Min, Max}]      历史首值要求
%% [{pay_gold_each, Min}]  单笔充值每X晶钻
%% [{pay_acc_each, Min}]   累计充值每X晶钻
%% [{rank, Time, StartIndex, EndIndex}] %% 排行榜类型奖励 Time:发放时间(unixtime) StartIndex:开始 EndIndex:结束
%% [{loss, item, [{BaseId, Num}]}]  扣除物品
%% [{loss, item, BaseId, Num}]  扣除物品
%% [{loss, Type, Val}] 扣除资产  Val:具体数值
%%     Type: coin(金币)/gold(晶钻)/coin_bind(绑定金币)/gold_bind(绑定晶钻)/coin_all(所有金币)
%%           guild_war(帮战积分)/arena(竞技积分)/quiz(答题积分)/guild_devote(帮贡)/career_devote(师门积分)
%%           exp(经验)/psychic(灵力)/energy(精力)/attainment(阅历)/lilian(仙道历练)
%% [{power, Min, Max}] 个人战斗力
%% [{total_power, Min, Max}] 个人综合战斗力
%% [{eqm_enchant, Min, Max}] 装备强化等级
%% [{skill, Min, Max}]  技能阶数达到
%% [{petpower, Min, Max}]  宠物战斗力
%% [{pet_potential_avg, Min, Max}] 宠物平均潜力
%% [{pet_grow, Min, Max}] 宠物平均潜力
%% [{pet_skill_lev, Min, Max}] 宠物技能等级
%% [{mount_step, Min, Max}] 坐骑进阶等级
%% [{mount_lev, Min, Max}] 坐骑等级
%% [{channel_lev, Min, Max}] 元神等级
%% [{channel_step, Min, Max}] 元神境界
%% [{casino_acc, Min, Max}] 仙境寻宝消耗X到Y晶钻
%% [{casino_acc_each, N}]  仙境寻宝每消耗N晶钻
%% [{npc_store_sm_acc, Min, Max}] 神秘商店消耗X到Y晶钻
%% [{npc_store_sm_acc_each, N}] 神秘商店每消耗N晶钻
%% [{casino_sm_acc, Min, Max}] 仙境、神秘商店消耗X到Y晶钻
%% [{casino_sm_acc_each, N}] 仙境、神秘商店每消耗N晶钻
%% [{shop_acc, Min, Max}] 商城消耗X到Y晶钻
%% [{shop_acc_each, N}] 商城每消耗N晶钻
%% [{answer_rank, Min, Max}] 答题排行
%% [{guild_td_score, Min, Max}] 帮会降妖积分
%% [{guard_rank, Min, Max}] 洛水攻城排行
%% [{super_boss_total_dmg_rank, Min, Max}] 远古巨龙总伤害排行
%% [{super_boss_dmg_rank, Min, Max}] 远古巨龙单次伤害排行
%% [{guild_arena_rank, Min, Max}] 帮会战排行
%% [{guild_war_rank, Min, Max}] 阵营战排行
%% [{arena_rank, Min, Max}] 竞技场各组排行
%% [{eqm_purple, Min, Max}] 紫色装备数量
%% [{eqm_orange, Min, Max}] 橙色装备数量
%% [{eqm_polish, Min, Max}] 洗练橙色装备数量
%% [{online_time, Min, Max}] 每天在线时长
%% [{online_time_vip, Min, Max}] VIP每天在线时长
%% [{online_time_vip_no, Min, Max}] 非VIP每天在线时长
%% [{online_time_vip_week, Min, Max}] 周VIP每天在线时长
%% [{online_time_vip_month, Min, Max}] 月VIP每天在线时长
%% [{online_time_vip_half_year, Min, Max}] 半年VIP每天在线时长
%% [{offline_time, Min, Max}] 角色离线时间
%% [{casino_shop_sm, Min, Max}] 仙境寻宝/神秘商店/商城总消耗X到Y晶钻
%% [{casino_shop_sm_each, Min}] 仙境寻宝/神秘商店/商城每消耗X晶钻
%% [{loss_gold_all, Min, Max}] 所有总消耗(市场除外)X到Y晶钻
%% [{loss_gold_all_each, Min}] 所有总消耗(市场除外)每消耗X晶钻
%% [{pet_magic, Min, Max}] 魔晶总消耗X到Y晶钻
%% [{pet_magic_each, Min}] 魔晶每消耗X晶钻
%% [{stone_quech, Min, Max}]  宝石淬炼
%% [{wing_step, Min, Max}]  翅膀进阶
%% [{activity, Min, Max}] 活跃度达到x值
%% [{flower, Min, Max}]  单次送花X朵
%% [{flower_acc, Min, Max}] 累计送花X到Y朵
%% [{flower_acc_each, Min}] 每累计送花X朵
%% [{practice, Min, Max}] 无限试练到X至Y波
%% [{eqm_make, Quality, Lev}] 装备生产
%% [{wedding_item, Min, Max}] 结婚信物等级
%% [{pet_magic_lev, Min, Max}] 魔晶等级

%% [{login, Type}]  每天登录(1:所有玩家 2:VIP玩家 3:非VIP玩家 4:充值玩家 5:非充值玩家, 6:周VIP玩家 7:月VIP玩家, 8:半年VIP玩家)
%% [{wedding, Type}]   角色结婚(0:无限制 1:普通婚礼 2:豪华婚礼)
%% [{sworn, Type}]  角色结拜(0:无限制 1:普通结拜 2:生死结拜)
%% [{world_compete, Type}] 仙道会(0:无限制 11:单打 22:双打 33:三打三)
%% [{escort, Type}]  护送[0:无限制 1:正义 2:非正义]



%% 指定时间内累计某功能次数类活动
-record(campaign_accumulative,
    {
        type   %% 活动类型 atom()
        ,label %% 监听类型 atom()
        ,target %% 监听类型子类 any()
        ,start_time = 0%% 开始时间
        ,end_time = 0  %% 结束时间
        ,current = 0  %% 当前值
        ,rewards = []   %% 奖励 [{Cond = integer(), Items = [{ItemId, Bind, Num}]}]
        ,mail = {<<>>, <<>>} %% 邮件内容{title, content}
    }
).

-record(campaign_role_reward, { %% 可领取奖励列表 存于ETS中，防止数据库失效时被刷
        key = {0, 0}  %% {{RoleId, SrvId}, CondId} 
        ,camp_id
        ,cond_id
        ,num = 1
        ,last_time = 0     %% 最后奖励时间
        ,gains = []    %% [#gain{}]
    }
).

