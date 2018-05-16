-ifndef(ACHIEVE_HRL).
-define(ACHIEVE_HRL, 1).


-include("server.hrl").


-define(ACH_STATE_LOCK, 0).
-define(ACH_STATE_UNLOCK, 1).
-define(ACH_STATE_FINISH, 2).


-define(ACHIEVE_TYPE_1, 1).%%修为成长
-define(ACHIEVE_TYPE_2, 2).%%任务秘境
-define(ACHIEVE_TYPE_3, 3).%%大道之争
-define(ACHIEVE_TYPE_4, 4).%%趣味成就

-define(ACHIEVE_SUBTYPE_1001, 1001).%%等级
-define(ACHIEVE_SUBTYPE_1002, 1002).%%剑池升阶
-define(ACHIEVE_SUBTYPE_1003, 1003).%%转生等级 TODO
-define(ACHIEVE_SUBTYPE_1004, 1004).%%装备进阶
-define(ACHIEVE_SUBTYPE_1005, 1005).%%装备强化
-define(ACHIEVE_SUBTYPE_1006, 1006).%%装备洗练
-define(ACHIEVE_SUBTYPE_1007, 1007).%%装备精炼
-define(ACHIEVE_SUBTYPE_1008, 1008).%%装备熔炼
-define(ACHIEVE_SUBTYPE_1009, 1009).%%装备镶嵌
-define(ACHIEVE_SUBTYPE_1010, 1010).%%宠物收集
-define(ACHIEVE_SUBTYPE_1011, 1011).%%宠物进阶
-define(ACHIEVE_SUBTYPE_1012, 1012).%%宠物升星
-define(ACHIEVE_SUBTYPE_1013, 1013).%%翅膀进阶
-define(ACHIEVE_SUBTYPE_1014, 1014).%%翅膀成长
-define(ACHIEVE_SUBTYPE_1015, 1015).%%翅膀培养
-define(ACHIEVE_SUBTYPE_1016, 1016).%%神兵进阶
-define(ACHIEVE_SUBTYPE_1017, 1017).%%神兵成长
-define(ACHIEVE_SUBTYPE_1018, 1018).%%神兵培养
-define(ACHIEVE_SUBTYPE_1019, 1019).%%坐骑进阶
-define(ACHIEVE_SUBTYPE_1020, 1020).%%坐骑成长
-define(ACHIEVE_SUBTYPE_1021, 1021).%%坐骑培养
-define(ACHIEVE_SUBTYPE_1022, 1022).%%法器进阶
-define(ACHIEVE_SUBTYPE_1023, 1023).%%法器成长
-define(ACHIEVE_SUBTYPE_1024, 1024).%%法器培养
-define(ACHIEVE_SUBTYPE_1025, 1025).%%妖灵进阶
-define(ACHIEVE_SUBTYPE_1026, 1026).%%妖灵成长
-define(ACHIEVE_SUBTYPE_1027, 1027).%%妖灵培养

-define(ACHIEVE_SUBTYPE_1028, 1028).%%足迹进阶
-define(ACHIEVE_SUBTYPE_1029, 1029).%%足迹成长
-define(ACHIEVE_SUBTYPE_1030, 1030).%%足迹培养

-define(ACHIEVE_SUBTYPE_1031, 1031).%%灵猫2进阶
-define(ACHIEVE_SUBTYPE_1032, 1032).%%灵猫2成长
-define(ACHIEVE_SUBTYPE_1033, 1033).%%灵猫2培养

-define(ACHIEVE_SUBTYPE_1034, 1034).%%外观3进阶
-define(ACHIEVE_SUBTYPE_1035, 1035).%%外观3成长
-define(ACHIEVE_SUBTYPE_1036, 1036).%%外观3培养

-define(ACHIEVE_SUBTYPE_1037, 1037).%%外观4进阶
-define(ACHIEVE_SUBTYPE_1038, 1038).%%外观4成长
-define(ACHIEVE_SUBTYPE_1039, 1039).%%外观4培养
-define(ACHIEVE_SUBTYPE_1040, 1040).%%外观5进阶
-define(ACHIEVE_SUBTYPE_1041, 1041).%%外观5成长
-define(ACHIEVE_SUBTYPE_1042, 1042).%%外观5培养

-define(ACHIEVE_SUBTYPE_1043, 1043).%%时装收集
-define(ACHIEVE_SUBTYPE_1044, 1044).%%时装升级
-define(ACHIEVE_SUBTYPE_1045, 1045).%%十荒神器
-define(ACHIEVE_SUBTYPE_1046, 1046).%%神器注灵
-define(ACHIEVE_SUBTYPE_1047, 1047).%%经脉修炼
-define(ACHIEVE_SUBTYPE_1048, 1048).%%经脉畅通
-define(ACHIEVE_SUBTYPE_1049, 1049).%%内功高手
-define(ACHIEVE_SUBTYPE_1050, 1050).%%内功高手
-define(ACHIEVE_SUBTYPE_1051, 1051).%%宝石镶嵌

-define(ACHIEVE_SUBTYPE_2001, 2001).%%日常任务
-define(ACHIEVE_SUBTYPE_2002, 2002).%%帮派任务
-define(ACHIEVE_SUBTYPE_2003, 2003).%%进阶副本
-define(ACHIEVE_SUBTYPE_2004, 2004).%%剧情副本
-define(ACHIEVE_SUBTYPE_2005, 2005).%%经验副本
-define(ACHIEVE_SUBTYPE_2006, 2006).%%神器副本
-define(ACHIEVE_SUBTYPE_2007, 2007).%%灵脉副本
-define(ACHIEVE_SUBTYPE_2008, 2008).%%仙器副本
-define(ACHIEVE_SUBTYPE_2009, 2009).%%九霄塔
-define(ACHIEVE_SUBTYPE_2010, 2010).%%九霄塔层数
-define(ACHIEVE_SUBTYPE_2011, 2011).%%跨服副本
-define(ACHIEVE_SUBTYPE_2012, 2012).%%帮派副本
-define(ACHIEVE_SUBTYPE_2013, 2013).%%帮派元老
-define(ACHIEVE_SUBTYPE_2014, 2014).%%守护副本
-define(ACHIEVE_SUBTYPE_2015, 2015).%%符文塔副本


-define(ACHIEVE_SUBTYPE_3001, 3001).%%竞技场排名
-define(ACHIEVE_SUBTYPE_3002, 3002).%%竞技场胜利
-define(ACHIEVE_SUBTYPE_3003, 3003).%%竞技场连胜
-define(ACHIEVE_SUBTYPE_3004, 3004).%%世界首领参与击杀
-define(ACHIEVE_SUBTYPE_3005, 3005).%%精英首领参与击杀
-define(ACHIEVE_SUBTYPE_3006, 3006).%%世界首领最终击杀
-define(ACHIEVE_SUBTYPE_3007, 3007).%%世界首领累计输出
-define(ACHIEVE_SUBTYPE_3008, 3008).%%领地战个人排名
-define(ACHIEVE_SUBTYPE_3009, 3009).%%领地战帮会排名
-define(ACHIEVE_SUBTYPE_3010, 3010).%%领地战夺旗
-define(ACHIEVE_SUBTYPE_3011, 3011).%%领地战杀敌
-define(ACHIEVE_SUBTYPE_3012, 3012).%%领地战击杀首领
-define(ACHIEVE_SUBTYPE_3013, 3013).%%帮派战力排名 TODO
-define(ACHIEVE_SUBTYPE_3014, 3014).%%巅峰塔夺宝
-define(ACHIEVE_SUBTYPE_3015, 3015).%%巅峰塔层数
-define(ACHIEVE_SUBTYPE_3016, 3016).%%跨服1v1参与
-define(ACHIEVE_SUBTYPE_3017, 3017).%%跨服1v1段位
-define(ACHIEVE_SUBTYPE_3018, 3018).%%六龙争霸胜利
-define(ACHIEVE_SUBTYPE_3019, 3019).%%六龙争霸积分
-define(ACHIEVE_SUBTYPE_3020, 3020).%%跨服竞技场
-define(ACHIEVE_SUBTYPE_3021, 3021).%%杀人数
-define(ACHIEVE_SUBTYPE_3022, 3022).%%善良值
-define(ACHIEVE_SUBTYPE_3023, 3023).%%魔宫杀怪
-define(ACHIEVE_SUBTYPE_3024, 3024).%%魔宫杀人
-define(ACHIEVE_SUBTYPE_3025, 3025).%%魔宫目标
-define(ACHIEVE_SUBTYPE_3026, 3026).%%乱斗连杀
-define(ACHIEVE_SUBTYPE_3027, 3027).%%熊战士
-define(ACHIEVE_SUBTYPE_3028, 3028).%%鸣雷鼓
-define(ACHIEVE_SUBTYPE_3029, 3029).%%鹰射手
-define(ACHIEVE_SUBTYPE_3030, 3030).%%咒术师
-define(ACHIEVE_SUBTYPE_3031, 3031).%%鬼仙
-define(ACHIEVE_SUBTYPE_3032, 3032).%%飞翼妖女
-define(ACHIEVE_SUBTYPE_3033, 3033).%%碾压
-define(ACHIEVE_SUBTYPE_3034, 3034).%%角斗士


-define(ACHIEVE_SUBTYPE_4001, 4001).%%死亡次数
-define(ACHIEVE_SUBTYPE_4002, 4002).%%修炼不辍
-define(ACHIEVE_SUBTYPE_4003, 4003).%%丢三落四
-define(ACHIEVE_SUBTYPE_4004, 4004).%%神佛保佑 TODO
-define(ACHIEVE_SUBTYPE_4005, 4005).%%呼朋唤友
-define(ACHIEVE_SUBTYPE_4006, 4006).%%乐于助人 TODO
-define(ACHIEVE_SUBTYPE_4007, 4007).%%互相帮助 TODO
-define(ACHIEVE_SUBTYPE_4008, 4008).%%加入宗门
-define(ACHIEVE_SUBTYPE_4009, 4009).%%开山立派
-define(ACHIEVE_SUBTYPE_4010, 4010).%%帮派贡献
-define(ACHIEVE_SUBTYPE_4011, 4011).%%快去干活
-define(ACHIEVE_SUBTYPE_4012, 4012).%%护花使者
-define(ACHIEVE_SUBTYPE_4013, 4013).%%剁手达人
-define(ACHIEVE_SUBTYPE_4014, 4014).%%生财有道
-define(ACHIEVE_SUBTYPE_4015, 4015).%%一掷千金
-define(ACHIEVE_SUBTYPE_4016, 4016).%%王城拾宝
-define(ACHIEVE_SUBTYPE_4017, 4017).%%怪物屠戮
-define(ACHIEVE_SUBTYPE_4018, 4018).%%消消乐胜利
-define(ACHIEVE_SUBTYPE_4019, 4019).%%消消乐连胜
-define(ACHIEVE_SUBTYPE_4020, 4020).%%消消乐连败
-define(ACHIEVE_SUBTYPE_4021, 4021).%%答题总榜
-define(ACHIEVE_SUBTYPE_4022, 4022).%%答题连对



-record(st_achieve, {
    pkey = 0,
    lv = 0,
    score = 0,
    log = [],
    achieve_list = [],
    score_list = [],
    attribute = #attribute{},
    rec_log = [],
    is_change = 0
}).

-record(achieve, {
    ach_id = 0,
    value = 0,
    state = 0
}).


-record(base_achieve_lv, {
    lv = 0,
    score = 0
}).

-record(base_achieve_lv_reward, {
    id = 0,
    goods = [],
    lv = 0
}).

-record(base_achieve, {
    ach_id = 0,
    type = 0,
    subtype = 0,
    name = <<>>,
    target_value = 0,
    target_type = 0,
    goods = [],
    score = 0,
    notice_lv = 0,
    compare_type = 0,
    is_use = 1
}).


-endif.