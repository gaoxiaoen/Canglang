%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, junhai
%%% @doc
%%%
%%% @end
%%% Created : 22. 五月 2015 14:45
%%%-------------------------------------------------------------------
-module(goods_from).
-author("fzl").
-include("common.hrl").

%% API
-export([from_types/0]).
-export([init/0]).

%%消费类型说明
from_types() ->
    [
        %%物品与金钱的来源与消耗原因
        {0, ?T("系统gm")},
        {1, ?T("任务奖励")},
        {2, ?T("创建仙盟")},
        {3, ?T("创建仙盟")},
        {4, ?T("仙盟奉献奖励")},
        {5, ?T("仙盟任务")},
        {6, ?T("仙盟改名")},
        {7, ?T("跑环任务奖励")},
        {8, ?T("跑环任务一键完成")},
        {9, ?T("材料副本重置")},
        {10, ?T("材料副本通关奖励")},
        {11, ?T("发布队伍招募")},
        {12, ?T("组队副本购买次数")},
        {13, ?T("竞技场购买次数")},
        {14, ?T("竞技场挑战奖励")},
        {15, ?T("组队副本奖励")},
        {16, ?T("组队副本翻牌")},
        {17, ?T("击杀藏宝图怪物")},
        {18, ?T("夺宝购买精力")},
        {19, ?T("夺宝奖励")},
        {20, ?T("装备开孔")},
        {21, ?T("装备强化")},
        {22, ?T("装备洗练")},
        {23, ?T("购买时装")},
        {24, ?T("交易所出售")},
        {25, ?T("购买随机商店里面物品")},
        {26, ?T("购买翅膀")},
        {27, ?T("随机商店刷新")},
        {28, ?T("清除竞技场CD")},
        {29, ?T("主线副本奖励")},
        {30, ?T("快速祈祷")},
        {31, ?T("购买祈祷时装")},
        {32, ?T("交易所购买物品")},
        {33, ?T("领取护送费用")},
        {34, ?T("护送抢劫奖励")},
        {35, ?T("开背包格子")},
        {36, ?T("洗练恢复")},
        {37, ?T("翅膀升阶")},
        {38, ?T("怪物掉落")},
        {39, ?T("活动副本")},
        {40, ?T("传奇副本")},
        {41, ?T("组队副本翻牌")},
        {42, ?T("主线副本")},
        {43, ?T("宝石拆除")},
        {44, ?T("宝石合成")},
        {45, ?T("装备熔炼")},
        {46, ?T("仙盟签到")},
        {47, ?T("工会任务进度奖励")},
        {48, ?T("封印宠物技能")},
        {49, ?T("祈祷背包")},
        {50, ?T("夺宝道具合成")},
        {51, ?T("挖宝")},
        {52, ?T("配置自定义礼包")},
        {53, ?T("邮件附件")},
        {54, ?T("背包中双击使用物品")},
        {55, ?T("交易所物品超时返回")},
        {56, ?T("交易所出售物品获得元宝")},
        {57, ?T("护送任务")},
        {58, ?T("开礼包消耗元宝")},
        {59, ?T("技能升级消耗")},
        {60, ?T("坐骑升阶")},
        {61, ?T("光武升级消耗")},
        {62, ?T("一键技能学习消耗")},
        {63, ?T("复活")},
        {64, ?T("跑环任务刷星")},
        {65, ?T("护送任务刷新品质")},
        {66, ?T("资源礼包奖励")},
        {67, ?T("坐骑装备洗练")},
        {68, ?T("装备升级")},
        {69, ?T("装备升星")},
        {70, ?T("淘宝")},
        {71, ?T("猎场奖励")},
        {72, ?T("普通次数副本")},
        {73, ?T("淘宝仓库转移")},
        {74, ?T("宝石替换")},
        {75, ?T("点赞")},
        {76, ?T("被点赞")},
        {77, ?T("物品合成")},
        {78, ?T("竞技场积分奖励")},
        {79, ?T("竞技场排名奖励")},
        {80, ?T("仙盟副本通关奖励")},
        {81, ?T("仙盟副本boss气血奖励")},
        {82, ?T("挑战boss双倍奖励")},
        {83, ?T("副本场景掉落")},
        {84, ?T("幸运转盘")},
        {85, ?T("跨服巅峰战场")},
        {86, ?T("挑战单人boss")},
        {87, ?T("世界boss鼓舞")},
        {88, ?T("世界boss奖励")},
        {89, ?T("跨服1v1奖励")},
        {90, ?T("跨服战场奖励")},
        {91, ?T("跨服消消乐奖励")},
        {92, ?T("单人boss清CD")},
        {93, ?T("仙盟改名")},
        {94, ?T("城战竞价")},
        {95, ?T("城战变身")},
        {96, ?T("城主每日福利")},
        {97, ?T("天天任务刷新")},
        {98, ?T("天天任务元宝完成")},
        {99, ?T("天天任务全部完成奖励")},
        {101, ?T("宠物扭蛋")},
        {102, ?T("宠物训练")},
        {103, ?T("开启宠物训练栏")},
        {104, ?T("清训练CD")},
        {105, ?T("签到")},
        {106, ?T("活跃度")},
        {107, ?T("活跃度宝藏")},
        {108, ?T("7天登陆礼包")},
        {109, ?T("等级礼包")},
        {110, ?T("7天目标奖励")},
        {111, ?T("首充礼包奖励")},
        {112, ?T("购买冲榜礼包")},
        {113, ?T("每日充值抽奖")},
        {114, ?T("每日充值兑换")},
        {115, ?T("每日累计充值礼包")},
        {116, ?T("累计消费礼包")},
        {117, ?T("单笔充值礼包")},
        {118, ?T("冲榜活动结算奖励")},
        %%{119, ?T("vip礼包")},
        {120, ?T("礼包码兑换")},
        {121, ?T("充值")},
        {122, ?T("宠物光环升级")},
        {123, ?T("宠物技能封印")},
        {124, ?T("抢购商店购买")},
        {125, ?T("星座守护自动购买")},
        {126, ?T("星辰升级清CD")},
        {127, ?T("疯狂点击攻击获得")},
        {128, ?T("购买普通商店")},
        {129, ?T("冲榜返利奖励")},
        {130, ?T("原力提升突破")},
        {131, ?T("原力清CD")},
        {132, ?T("新每日充值礼包")},
        {133, ?T("新单笔充值礼包")},
        {134, ?T("守护副本奖励")},
        {135, ?T("兑换活动兑换")},
        {136, ?T("在线时长奖励")},
        {137, ?T("在线时长兑换")},
        {138, ?T("膜拜")},
        {139, ?T("经验找回")},
        {140, ?T("功能离线找回")},
        {141, ?T("每日累充")},
        {142, ?T("充值送红包")},
        {143, ?T("抢红包")},
        {144, ?T("领取月卡奖励")},
        {145, ?T("终身卡奖励")},
        {146, ?T("全民福利奖励")},
        {147, ?T("累充转盘")},
        {148, ?T("投资计划")},
        {149, ?T("累充礼包")},
        {150, ?T("翅膀升星")},
        {151, ?T("坐骑升星")},
        {152, ?T("修炼提升突破")},
        {153, ?T("修炼清CD")},
        {154, ?T("开启自动答题")},
        {155, ?T("坐骑装备强化")},
        {156, ?T("一键占星")},
        {157, ?T("普通占星")},
        {158, ?T("物品兑换活动")},
        {159, ?T("占星开背包")},
        {160, ?T("开启精灵")},
        {161, ?T("充值卡")},
        {162, ?T("角色每日累充")},
        {163, ?T("许愿树")},
        {164, ?T("许愿树偷摘")},
        {165, ?T("许愿树物品刷新")},
        {166, ?T("连续充值")},
        {167, ?T("砸蛋")},
        {168, ?T("时装升星")},
        {169, ?T("精灵升星")},
        {170, ?T("改名")},
        {171, ?T("仓库取出物品")},
        {172, ?T("仓库存入物品")},
        {173, ?T("合服签到")},
        {174, ?T("合服仙盟排行")},
        {175, ?T("目标福利")},
        {176, ?T("结婚申请")},
        {177, ?T("结婚撒花")},
        {178, ?T("晚宴红包")},
        {179, ?T("晚宴派喜糖")},
        {180, ?T("大富翁买骰子")},
        {181, ?T("大富翁")},
        {182, ?T("仙盟签到")},
        {183, ?T("仙盟弹劾")},
        {184, ?T("购买vip福利礼包")},
        {185, ?T("结婚")},
        {186, ?T("送花")},
        {187, ?T("喇叭购买")},
        {188, ?T("银币自动购买")},
        {189, ?T("婚戒升级与兑换")},
        {190, ?T("全民夺宝")},
        {191, ?T("宠物技能学习")},
        {192, ?T("宠物升星")},
        {193, ?T("宝石升级")},
        {194, ?T("经脉突破")},
        {195, ?T("清理经脉CD")},
        {196, ?T("坐骑技能激活")},
        {197, ?T("坐骑技能升级")},
        {198, ?T("翅膀技能激活")},
        {199, ?T("翅膀技能升级")},
        {200, ?T("剑池奖励")},
        {201, ?T("跨服副本")},
        {202, ?T("成就")},
        {203, ?T("九霄塔扫荡")},
        {204, ?T("九霄塔通过")},
        {205, ?T("血池使用")},
        {206, ?T("血池购买")},
        {207, ?T("家园宝箱")},
        {208, ?T("家园商店")},
        {209, ?T("领地战目标")},
        {210, ?T("领地晚宴贡献")},
        {211, ?T("领地晚宴")},
        {212, ?T("十荒神器器灵")},
        {213, ?T("经验副本扫荡")},
        {214, ?T("经验副本通关")},
        {215, ?T("经验副本首通")},
        {216, ?T("每日副本扫荡")},
        {217, ?T("每日副本挑战")},
        {218, ?T("坐骑装备")},
        {219, ?T("仙羽装备")},
        {220, ?T("法宝装备")},
        {221, ?T("神兵装备")},
        {222, ?T("坐骑进阶奖励")},
        {223, ?T("仙羽进阶奖励")},
        {224, ?T("法器进阶奖励")},
        {225, ?T("神兵进阶奖励")},
        {226, ?T("坐骑成长丹消耗")},
        {227, ?T("仙羽成长丹消耗")},
        {228, ?T("法器成长丹消耗")},
        {229, ?T("神兵成长丹消耗")},
        {230, ?T("剑池找回")},
        {231, ?T("GM反馈奖励")},
        {232, ?T("家园随从状态")},
        {233, ?T("时装激活")},
        {234, ?T("时装升级")},
        {235, ?T("vip奖励")},
        {236, ?T("vip每周礼包")},
        {237, ?T("商店购买消耗")},
        {238, ?T("首次击杀掉落")},
        {239, ?T("后台邮件")},
        {240, ?T("交易所下架")},
        {241, ?T("妖灵成长丹消耗")},
        {242, ?T("立即完成当前悬赏任务")},
        {243, ?T("法宝进阶")},
        {244, ?T("神兵进阶")},
        {245, ?T("妖灵进阶")},
        {246, ?T("足迹进阶")},
        {247, ?T("坐骑灵脉")},
        {248, ?T("仙羽灵脉")},
        {249, ?T("法宝灵脉")},
        {250, ?T("神兵灵脉")},
        {251, ?T("妖灵灵脉")},
        {252, ?T("足迹灵脉")},
        {253, ?T("幸运转盘抽奖")},
        {254, ?T("幸运转盘抽奖兑换")},
        {255, ?T("幸运转盘抽奖刷新")},
        {256, ?T("鲜花达标榜")},
        {257, ?T("点金任务")},
        {258, ?T("足迹成长丹消耗")},
        {259, ?T("集字兑换")},
        {260, ?T("时装拆分")},
        {261, ?T("百倍返利")},
        {262, ?T("原石鉴定")},
        {263, ?T("神器副本扫荡")},
        {264, ?T("神器副本通关")},
        {265, ?T("乱斗战场")},
        {266, ?T("种植植物")},
        {267, ?T("植物浇水")},
        {268, ?T("植物采集")},
        {269, ?T("守护副本通关")},
        {270, ?T("守护副本扫荡")},
        {271, ?T("灵猫进阶")},
        {272, ?T("灵猫成长丹消耗")},
        {273, ?T("灵猫技能激活")},
        {274, ?T("灵猫灵脉")},
        {275, ?T("连续充值累计奖励")},
        {276, ?T("掉落库")},
        {277, ?T("金银塔抽奖")},
        {278, ?T("时装赠送")},
        {279, ?T("红装兑换")},
        {280, ?T("碎片兑换")},
        {281, ?T("金身进阶")},
        {282, ?T("金身成长丹消耗")},
        {283, ?T("金身技能激活")},
        {284, ?T("金身灵脉")},
        {285, ?T("结婚")},
        {286, ?T("婚礼巡游")},
        {287, ?T("晚宴")},
        {288, ?T("结婚排行榜")},
        {289, ?T("戒指升级")},
        {290, ?T("结婚称号领取")},
        {291, ?T("招财进宝")},
        {292, ?T("结婚烟花使用")},
        {293, ?T("招财猫")},
        {294, ?T("合服七天登陆")},
        {295, ?T("装备附魔")},
        {296, ?T("武魂合成")},
        {297, ?T("武魂开启")},
        {298, ?T("武魂镶嵌")},
        {299, ?T("猎魂")},
        {300, ?T("开启猎魂")},
        {301, ?T("充值返利")},
        {302, ?T("充值有礼")},
        {303, ?T("在线有礼")},
        {304, ?T("每日任务活动")},
        {305, ?T("幸运翻牌活动")},
        {306, ?T("越狱消耗")},
        {307, ?T("红名掉落")},
        {308, ?T("限时翅膀续费")},
        {309, ?T("等级返利激活")},
        {310, ?T("等级返利元宝领取")},
        {311, ?T("开启礼包扣除物品")},
        {312, ?T("创建战队")},
        {313, ?T("乱斗精英赛")},
        {314, ?T("战队精英赛下注")},
        {315, ?T("vip副本")},
        {316, ?T("战队精英赛采集")},
        {317, ?T("消费积分兑换")},
        {318, ?T("红装限时抢购")},
        {319, ?T("首次登陆奖励")},
        {320, ?T("跨服试炼副本通关")},
        {321, ?T("跨服试炼副本领取")},
        {322, ?T("灵佩进阶")},
        {323, ?T("灵佩成长丹消耗")},
        {324, ?T("灵佩技能激活")},
        {325, ?T("灵佩灵脉")},
        {326, ?T("仙宝进阶")},
        {327, ?T("仙宝成长丹消耗")},
        {328, ?T("仙宝技能激活")},
        {329, ?T("仙宝灵脉")},
        {330, ?T("仙盟宝箱提升")},
        {331, ?T("仙盟宝箱协助")},
        {332, ?T("仙盟宝箱奖励")},
        {333, ?T("仙盟宝箱清除获取冷却")},
        {334, ?T("仙盟宝箱清除协助冷却")},
        {335, ?T("跨服副本次数奖励领取")},
        {336, ?T("跨服1vn抢购商店购买")},
        {337, ?T("跨服1vn擂主每日奖励")},
        {338, ?T("跨服1vn膜拜每日奖励")},
        {339, ?T("经验副本投资购买")},
        {340, ?T("经验副本投资领取")},
        {341, ?T("跨服1vn中场投注")},
        {342, ?T("神邸抢购")},
        {343, ?T("神邸唤神")},
        {344, ?T("神邸唤神次数领取")},
        {345, ?T("装备升级")},
        {346, ?T("模具商店兑换")},
        {347, ?T("许愿池抽奖")},
        {348, ?T("跨服许愿池抽奖")},
        {349, ?T("仙盟答题")},
        {350, ?T("仙盟神兽喂养")},
        {351, ?T("仙盟神兽超级召唤")},
        {352, ?T("集聚英雄领取")},
        {353, ?T("跃升冲榜")},
        {354, ?T("奇遇礼包")},
        {355, ?T("天命觉醒")},
        {356, ?T("仙晶矿洞")},
        {357, ?T("购买援助")},
        {358, ?T("援助刷新")},
        {360, ?T("十荒神器洗练")},

        {501, ?T("帮派奉献")},
        {502, ?T("帮派活跃奖励")},
        {503, ?T("帮派每日福利奖励")},
        {504, ?T("帮派妖魔入侵奖励")},
        {505, ?T("王城守卫奖励")},
        {506, ?T("六龙争霸单场奖励")},
        {507, ?T("六龙争霸排名奖励")},
        {508, ?T("答题奖励")},
        {509, ?T("野外boss")},
        {510, ?T("小飞鞋")},
        {511, ?T("复活")},
        {512, ?T("排行榜膜拜")},
        {513, ?T("水果大作战")},
        {514, ?T("水果大作战周排名")},
        {515, ?T("使用特效物品")},
        {520, ?T("宝宝图鉴激活")},
        {521, ?T("子女仙羽成长丹消耗")},
        {522, ?T("子女翅膀升星")},
        {523, ?T("子女翅膀升阶")},
        {524, ?T("灵羽进阶奖励")},
        {525, ?T("资源下载奖励")},
        {526, ?T("子女改名")},
        {527, ?T("宝宝技能升级")},
        {528, ?T("宝宝进阶")},
        {529, ?T("宝宝等级升级")},
        {530, ?T("宝宝变性别")},
        {531, ?T("宝宝击杀数量阶段领取531")},
        {532, ?T("宝宝每日签到领取532")},
        {533, ?T("零元礼包")},
        {534, ?T("宝宝时间加速")},
        {535, ?T("转职任务一键完成")},
        {536, ?T("转职任务奖励")},
        {537, ?T("新招财猫")},
        {538, ?T("疯狂砸蛋刷新")},
        {539, ?T("疯狂砸蛋砸蛋")},
        {540, ?T("疯狂砸蛋次数奖励")},
        {541, ?T("天宫寻宝")},
        {542, ?T("奖池转盘抽奖")},
        {546, ?T("购买钻石VIP")},
        {547, ?T("钻石VIP元宝兑换")},
        {548, ?T("钻石VIP钻石商城兑换")},
        {549, ?T("钻石VIP进阶丹转换")},
        {551, ?T("奖池转盘兑换")},
        {552, ?T("材料副本一键扫荡")},
        {553, ?T("宝宝坐骑进阶")},
        {554, ?T("宝宝坐骑成长丹消耗")},
        {555, ?T("宝宝坐骑技能激活")},
        {556, ?T("宝宝坐骑灵脉")},
        {557, ?T("宝宝武器进阶")},
        {558, ?T("宝宝武器成长丹消耗")},
        {559, ?T("宝宝武器技能激活")},
        {560, ?T("宝宝武器灵脉")},
        {561, ?T("水果大战刷新")},
        {562, ?T("水果大战切水果")},
        {563, ?T("水果大战次数奖励")},
        {564, ?T("丢弃物品")},
        {565, ?T("神装副本")},
        {566, ?T("拆分物品")},
        {567, ?T("仙魂分解")},
        {568, ?T("符文分解")},
        {570, ?T("秘境神树")},
        {571, ?T("丢弃物品获得")},
        {572, ?T("玩家成长丹消耗")},
        {573, ?T("限时仙宠成长活动抽取消耗")},
        {574, ?T("限时仙宠成长活动抽取产出")},
        {575, ?T("限时仙宠成长活动档次领取")},

        {576, ?T("回归活动之兑换扣除物品")},
        {577, ?T("回归活动之兑换获得物品")},
        {578, ?T("回归活动之兑换消耗金币")},
        {579, ?T("回归动之兑换扣除绑定元宝")},
        {580, ?T("回归活动之兑换扣除元宝")},

        %%军强活动专用600~799
        {600, ?T("藏宝阁领取登陆礼包600")},
        {601, ?T("藏宝阁购买限购礼包消耗601")},
        {602, ?T("藏宝阁购买礼包602")},
        {603, ?T("花千骨每日首充领取奖励603")},
        {604, ?T("花千骨每日首充领取累充奖励604")},
        {605, ?T("开服活动江湖榜奖励605")},
        {606, ?T("开服活动进阶目标奖励606")},
        {607, ?T("开服活动累充奖励607")},
        {608, ?T("开服活动全服动员608")},
        {609, ?T("开服活动团购首充609")},
        {610, ?T("投资计划消耗元宝610")},
        {611, ?T("迷宫寻宝消耗元宝611")},
        {612, ?T("迷宫寻宝获得奖励612")},
        {613, ?T("进阶宝箱消耗元宝613")},
        {614, ?T("进阶宝箱领取奖励614")},
        {615, ?T("投资计划领取奖励615")},
        {616, ?T("全民冲榜领取奖励616")},
        {617, ?T("全民冲榜邮件奖励617")},
        {618, ?T("限时抢购元宝消耗618")},
        {619, ?T("限时抢购购买物品619")},
        {620, ?T("限时抢购领取购买次数奖励620")},
        {621, ?T("符文寻宝元宝消耗621")},
        {622, ?T("符文寻宝奖励622")},
        {623, ?T("符文兑换623")},
        {624, ?T("登陆有礼登陆奖励624")},
        {625, ?T("登陆有礼在线奖励625")},
        {626, ?T("神秘兑换扣除物品626")},
        {627, ?T("神秘兑换获得物品627")},
        {628, ?T("特权炫装扣除元宝628")},
        {629, ?T("特权炫装获得物品629")},
        {630, ?T("限时活动-兑换消耗金币630")},
        {631, ?T("限时活动-兑换扣除绑定元宝631")},
        {632, ?T("限时活动-兑换扣除元宝632")},
        {633, ?T("符文副本奖励633")},
        {634, ?T("大额累积充值奖励634")},
        {635, ?T("称号护送活动获得635")},
        {636, ?T("仙境寻宝重置扣除元宝636")},
        {637, ?T("仙境寻宝重置产出637")},
        {638, ?T("仙境寻宝产出638")},
        {639, ?T("仙境寻宝扣除元宝639")},
        {640, ?T("开服活动返利抢购扣元宝640")},
        {641, ?T("开服活动返利抢购产出641")},
        {642, ?T("进阶宝箱重置扣除元宝642")},
        {643, ?T("在线时长奖励643")},
        {644, ?T("普通爱情宣言扣除元宝644")},
        {645, ?T("豪华爱情宣言扣除元宝645")},
        {646, ?T("爱情香囊扣除元宝646")},
        {647, ?T("爱情香囊领取首次奖励647")},
        {648, ?T("爱情香囊领取每日奖励648")},
        {649, ?T("爱情试炼副本重置扣除钻石649")},
        {650, ?T("爱情试炼副本产出650")},
        {651, ?T("仙侣大厅上传头像产出651")},
        {652, ?T("合服活动进阶目标奖励652")},
        {653, ?T("合服活动进阶目标二奖励653")},
        {654, ?T("合服活动进阶目标三奖励654")},
        {655, ?T("合服活动累充奖励655")},
        {656, ?T("合服活动全服动员656")},
        {657, ?T("合服活动团购首充657")},
        {658, ?T("合服活动返利抢购扣元宝658")},
        {659, ?T("合服活动返利抢购产出659")},
        {660, ?T("合服活动兑换消耗金币660")},
        {661, ?T("合服活动兑换扣除绑定元宝661")},
        {662, ?T("合服活动兑换扣除元宝662")},
        {663, ?T("合服活动兑换扣除物品663")},
        {664, ?T("合服活动兑换获得物品664")},
        {665, ?T("爱情树升阶扣除材料665")},
        {666, ?T("爱情树升阶奖励666")},
        {667, ?T("开服活动进阶目标二奖励667")},
        {668, ?T("开服活动进阶目标三奖励668")},
        {669, ?T("全民冲榜二领取奖励669")},
        {670, ?T("全民冲榜三领取奖励670")},
        {671, ?T("开服活动全服动员二671")},
        {672, ?T("开服活动全服动员二672")},
        {673, ?T("跨服深渊领取奖励673")},
        {674, ?T("全名嗨翻天活动674")},
        {675, ?T("攻城战银币捐献不足675")},
        {676, ?T("攻城战元宝捐献不足676")},
        {677, ?T("攻城战材料捐献不足677")},
        {678, ?T("宝宝签到领取奖励678")},
        {679, ?T("攻城战攻破城门奖励679")},
        {680, ?T("攻城战攻破王城门奖励680")},
        {681, ?T("攻城战采集王珠奖励681")},
        {682, ?T("攻城战兑换战车682")},
        {683, ?T("攻城战领取王者奖励683")},
        {684, ?T("攻城战领取成员奖励684")},
        {685, ?T("攻城战终极携带宝珠奖励685")},
        {686, ?T("攻城战实时积分奖励686")},
        {687, ?T("限时抢购礼包扣除元宝687")},
        {688, ?T("限时抢购礼包购买奖励688")},
        {689, ?T("神秘商城刷新扣除元宝689")},
        {690, ?T("神秘商城购买扣除元宝690")},
        {691, ?T("神秘商城购买获得奖励691")},
        {692, ?T("神秘商城领取刷新次数奖励692")},
        {693, ?T("小额充值活动奖励693")},
        {694, ?T("购买巡游次数694")},
        {695, ?T("一元抢购购买扣元宝695")},
        {696, ?T("一元抢购领取次数奖励696")},
        {697, ?T("节日活动累充奖励697")},
        {698, ?T("节日活动返利抢购扣元宝698")},
        {699, ?T("节日活动返利抢购产出699")},
        {700, ?T("节日活动之财神挑战扣绑元700")},
        {701, ?T("节日活动之财神挑战扣元宝701")},
        {702, ?T("节日活动之财神挑战绑元产出702")},
        {703, ?T("节日活动之财神挑战元宝产出703")},
        {704, ?T("节日活动之兑换扣除物品704")},
        {705, ?T("节日活动之兑换获得物品705")},
        {706, ?T("节日活动之兑换消耗金币706")},
        {707, ?T("节日活动之兑换扣除绑定元宝707")},
        {708, ?T("节日活动之兑换扣除元宝708")},
        {709, ?T("节日活动之登陆有礼产出709")},
        {710, ?T("节日活动之红包雨产出710")},
        {711, ?T("仙装分解产出711")},
        {712, ?T("仙装寻宝产出712")},
        {713, ?T("仙装寻宝额外奖励713")},
        {714, ?T("仙装寻宝扣元宝714")},
        {715, ?T("仙装升级扣元宝715")},
        {716, ?T("仙装升级扣材料716")},
        {717, ?T("仙装地仙寻宝扣绑元717")},
        {718, ?T("仙阶升级扣除材料718")},
        {719, ?T("飞仙兑换扣除银币719")},
        {720, ?T("飞仙兑换扣除绑定元宝720")},
        {721, ?T("飞仙兑换扣除元宝721")},
        {722, ?T("飞仙兑换扣除材料722")},
        {723, ?T("飞仙兑换产出723")},
        {724, ?T("飞仙觉醒扣材料724")},
        {725, ?T("飞仙觉醒扣元宝725")},
        {726, ?T("飞仙觉醒扣银币726")},
        {727, ?T("飞仙觉醒扣绑元727")},
        {728, ?T("仙练属性交换扣绑元728")},
        {729, ?T("财神单笔充值奖励729")},
        {730, ?T("聚宝盆领取奖励730")},
        {731, ?T("限时仙装活动抽取消耗731")},
        {732, ?T("限时仙装活动抽取产出732")},
        {733, ?T("限时仙装活动档次领取733")},
        {734, ?T("爱情树领取种子奖励扣元宝734")},
        {735, ?T("爱情树领取种子奖励735")},
        {736, ?T("小额单笔充值奖励736")},
        {737, ?T("宠物回合制副本挑战奖励737")},
        {738, ?T("宠物回合制副本星数奖励738")},
        {739, ?T("宠物回合制副本扫荡奖励739")},
        {740, ?T("双属性符文扣除材料740")},
        {741, ?T("双属性符文合成741")},
        {742, ?T("双属性符文分解返还742")},
        {743, ?T("神祇通灵激活743")},
        {744, ?T("神祇等级提升744")},
        {745, ?T("神祇星级提升745")},
        {746, ?T("神祇激活746")},
        {747, ?T("神魂吞噬747")},
        {748, ?T("神祇副本购买重置748")},
        {749, ?T("神祇副本扫荡749")},
        {750, ?T("神祇副本挑战750")},
        {751, ?T("攻城战膜拜奖励751")},
        {752, ?T("精英boss挑战消耗752")},
        {753, ?T("精英boss每日领取奖励753")},
        {754, ?T("精英boss副本银令牌扣除754")},
        {755, ?T("精英boss副本进入扣除元宝755")},
        {756, ?T("精英boss副本进入扣除道具756")},
        {757, ?T("精英boss副本挑战奖励757")},
        {758, ?T("金令牌购买扣除元宝758")},
        {759, ?T("金令牌产出759")},
        {760, ?T("魔法表情自动购买")},
        {761, ?T("魔法表情道具消耗")},
        {762, ?T("仙盟对战宝箱奖励领取")},
        {763, ?T("仙盟对战挑战奖励")},
        {764, ?T("仙盟对战兑换扣除道具")},
        {765, ?T("仙盟对战兑换获得")},
        {766, ?T("世界boss购买挑战次数")},
        {767, ?T("剑道升级消耗")},
        {768, ?T("剑道升阶消耗")},
        {769, ?T("元素升级消耗")},
        {770, ?T("元素升阶消耗")},
        {771, ?T("元素属性升级消耗")},
        {772, ?T("元素副本产出")},
        {773, ?T("剑道副本产出")},
        {774, ?T("元素副本扫荡")},
        {775, ?T("剑道副本道具购买消耗元宝")},
        {776, ?T("剑道副本道具购买产出")},
        {777, ?T("剑道副本挑战消耗道具")},
        {778, ?T("剑道寻宝元宝消耗")},
        {779, ?T("剑道寻宝奖励")},
        {780, ?T("十荒神器升阶")},
        {781, ?T("返利大厅消费返利")},
        {782, ?T("合服活动消费奖励")},
        {1547, ?T("背包使用")}
    ].

init() ->
    %%日记类型
    db:execute("truncate table consume_type"),
    F = fun({Id, Name}) ->
        timer:sleep(10),
        db:execute(io_lib:format("replace into consume_type set id = ~p, name = '~s'", [Id, Name]))
        end,
    spawn(fun() -> lists:foreach(F, goods_from:from_types()) end),
    ok.

