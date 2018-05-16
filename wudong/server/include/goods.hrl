-ifndef(GOODS_HRL).
-define(GOODS_HRL, 1).
-include("error_code.hrl").
-include("server.hrl").
-define(GOODS_LOCATION_WHOUSE, 0).     %%在仓库里面
-define(GOODS_LOCATION_BODY, 1).     %%在身上
-define(GOODS_LOCATION_BAG, 2).      %%在背包
-define(GOODS_LOCATION_MOUNT, 3).        %%在宠物背包中
-define(GOODS_LOCATION_WING, 4).        %%在翅膀背包中
-define(GOODS_LOCATION_MAGIC_WEAPON, 5).        %%在法宝背包中
-define(GOODS_LOCATION_LIGHT_WEAPON, 6).        %%在神兵背包中
-define(GOODS_LOCATION_PET_WEAPON, 7).        %%在妖灵背包中
-define(GOODS_LOCATION_FUWEN, 8).           %%在符文背包中
-define(GOODS_LOCATION_FOOTPRINT, 9).           %%在足迹背包中
-define(GOODS_LOCATION_BODY_FUWEN, 10).  %%身上符文
-define(GOODS_LOCATION_CAT, 11).  %%在灵猫背包中
-define(GOODS_LOCATION_GOLDEN_BODY, 12).  %%在金身背包中
-define(GOODS_LOCATION_FAIRY_SOUL, 13).  %%在仙魂背包中
-define(GOODS_LOCATION_BODY_FAIRY_SOUL, 14).  %%身上仙魂
-define(GOODS_LOCATION_BABY_WING, 15).        %%在子女翅膀背包中
-define(GOODS_LOCATION_BABY, 16).         %%子女装备背包中
-define(GOODS_LOCATION_BABY_MOUNT, 17).         %%子女坐骑装备背包中
-define(GOODS_LOCATION_BABY_WEAPON, 18).         %%子女武器装备背包中
-define(GOODS_LOCATION_XIAN, 19). %% 仙装背包中
-define(GOODS_LOCATION_BODY_XIAN, 20). %% 身上仙装
-define(GOODS_LOCATION_JADE, 21).  %%在玉佩背包中
-define(GOODS_LOCATION_GOD_TREASURE, 22).  %%在仙宝背包中
-define(GOODS_LOCATION_GOD_SOUL, 23). %% 神魂背包中
-define(GOODS_LOCATION_BODY_GOD_SOUL, 24). %% 身上神魂


-define(BIND, 1).      %%绑定状态
-define(NO_BIND, 0).   %%非绑定状态

-define(DEFAULT_CELL_NUM, 308).     %%玩家背包出生默认格子数
-define(DEFAULT_WAREHOUSE_NUM, 25). %%玩家仓库出生默认格子数
-define(DEFAULT_FUWEN_NUM, 200). %%玩家符文仓库出生默认格子数
-define(DEFAULT_XIAN_NUM, 150). %%玩家仙装仓库出生默认格子数
-define(DEFAULT_GOD_SOUL_NUM, 150). %%玩家神魂仓库出生默认格子数


-define(DEFAULT_FAIRY_SOUL_NUM, 200). %%玩家仙魂仓库出生默认格子数

%%----------------------物品类型、子类型定义-----------------------
-define(GOODS_TYPE_OTHER, 0).   %%其他
-define(GOODS_TYPE_EQUIP, 1).   %%装备
-define(GOODS_TYPE_CONSUME, 2). %%消耗品
%% -define(GOODS_TYPE_MOUNT, 4).%%坐骑装备
%% -define(GOODS_TYPE_SPRITE, 5).%%精灵装备
%% -define(GOODS_TYPE_WING, 7).%%翅膀装备
%% -define(GOODS_TYPE_PET, 8).%%翅膀装备
-define(GOODS_TYPE_EQUIP10, 10). %%外观类装备类型
-define(GOODS_TYPE_FUWEN, 12).%%符文
-define(GOODS_TYPE_FAIRL_SOUL, 13).%%仙魂
-define(GOODS_TYPE_XIAN, 14). %%仙装
-define(GOODS_TYPE_XIAN_YU, 15). %%仙玉
-define(GOODS_TYPE_XIAN_LING, 16). %%仙令
-define(GOODS_TYPE_GOD_SOUL, 17). %%神魂
-define(GOODS_TYPE_VIP_FACE, 22). %%vip表情道具卡
-define(GOODS_TYPE_MAGIC_FACE, 23). %%魔法表情道具相关

-define(GOODS_SUBTYPE_NECKLACE, 1). %%头盔
-define(GOODS_SUBTYPE_RING, 2).       %%项链
-define(GOODS_SUBTYPE_GLOVE, 3).    %%战袍
-define(GOODS_SUBTYPE_SHOE, 4).     %%战靴
-define(GOODS_SUBTYPE_CLOTHES, 5).  %%护腿
-define(GOODS_SUBTYPE_BELT, 6).     %%腰带
-define(GOODS_SUBTYPE_WEAPON, 7).   %%武器
-define(GOODS_SUBTYPE_WEAPON_2, 8). %%副武器
-define(GOODS_SUBTYPE_FASHION1, 542).    %%活动时装
-define(GOODS_SUBTYPE_FASHION2, 543).    %%剧情时装
-define(GOODS_SUBTYPE_FASHION3, 544).    %%特殊时装
-define(GOODS_SUBTYPE_FASHION4, 545).    %%限时时装
-define(GOODS_SUBTYPE_LIGHT_WEAPON, 10).  %%光武
-define(GOODS_SUBTYPE_MOUNT, 11).   %%坐骑
-define(GOODS_SUBTYPE_WING, 12).   %%翅膀
-define(GOODS_SUBTYPE_FINGER_RING, 130).   %%饰品
-define(GOODS_SUBTYPE_HANDGUARD, 131).   %%

-define(GOODS_SUBTYPE_FOOTPRINT1, 554).    %%足迹
-define(GOODS_SUBTYPE_FOOTPRINT2, 555).    %%足迹
-define(GOODS_SUBTYPE_FOOTPRINT3, 556).    %%足迹
-define(GOODS_SUBTYPE_FOOTPRINT4, 557).    %%足迹

-define(GOODS_SUBTYPE_BUBBLE1, 550).    %%活动泡泡
-define(GOODS_SUBTYPE_BUBBLE2, 551).    %%剧情泡泡
-define(GOODS_SUBTYPE_BUBBLE3, 552).    %%特殊泡泡
-define(GOODS_SUBTYPE_BUBBLE4, 553).    %%限时泡泡


-define(GOODS_SUBTYPE_HEAD1, 554).    %%头饰1
-define(GOODS_SUBTYPE_HEAD2, 555).    %%头饰2
-define(GOODS_SUBTYPE_HEAD3, 556).    %%头饰3
-define(GOODS_SUBTYPE_HEAD4, 557).    %%头饰4

-define(GOODS_SUBTYPE_DECORATION1, 741).    %%活动挂饰
-define(GOODS_SUBTYPE_DECORATION2, 742).    %%剧情挂饰
-define(GOODS_SUBTYPE_DECORATION3, 743).    %%特殊挂饰
-define(GOODS_SUBTYPE_DECORATION4, 744).    %%限时挂饰


-define(GOODS_SUBTYPE_PET_HALO_EXP, 113).  %%宠物经验水晶
-define(GOODS_SUBTYPE_PET_CARD, 24).  %%宠物卡
-define(GOODS_SUBTYPE_MOUNT_CARD, 26).%%坐骑卡
-define(GOODS_SUBTYPE_VIP_CARD, 35).  %%vip卡
-define(GOODS_SUBTYPE_FREE_VIP_CARD, 36).  %%vip体验卡
-define(GOODS_SUBTYPE_WEEK_CARD, 37). %%充值周卡

-define(GOODS_SUBTYPE_DESIGNATION1, 546).  %%活动称号
-define(GOODS_SUBTYPE_DESIGNATION2, 547).  %%剧情称号
-define(GOODS_SUBTYPE_DESIGNATION3, 548).  %%特殊称号
-define(GOODS_SUBTYPE_DESIGNATION4, 549).  %%限时称号

-define(GOODS_SUBTYPE_SPIRTE, 30).  %%精灵激活道具
-define(GOODS_SUBTYPE_EFFECT_GOODS, 50).    %%有特殊效果的物品
-define(GOODS_SUBTYPE_ROUNDNESS_STONE, 61).  %%圆形石头
-define(GOODS_SUBTYPE_SQUARE_STONE, 62).  %%方形石头
-define(GOODS_SUBTYPE_HEXAGRAM_STONE, 63).  %%六芒星石头
-define(GOODS_SUBTYPE_LUCKY_STONE, 64).  %%强化幸运石
-define(GOODS_SUBTYPE_FASHION_1, 97).    %%时装

-define(GOODS_SUBTYPE_XINGHUN, 70).        %%星魂值
-define(GOODS_SUBTYPE_EXP, 71).        %%获得经验
-define(GOODS_SUBTYPE_BCOIN, 72).        %%获得绑定银币
-define(GOODS_SUBTYPE_BGOLD, 73).        %%获得绑定元宝
-define(GOODS_SUBTYPE_GOLD, 100).         %%获得非绑定元宝
-define(GOODS_SUBTYPE_SWEET, 730).         %%获得甜蜜值

-define(GOODS_SUBTYPE_EQUIP_PART, 1061).         %%获得装备碎片
-define(GOODS_SUBTYPE_ACT_GOLD, 1070).         %%活动金币

-define(GOODS_SUBTYPE_GUILD_CONTRIB, 81).%%获得仙盟贡献
-define(GOODS_SUBTYPE_GUILD_VIGOR, 82).    %%获得增加仙盟活跃度
-define(GOODS_SUBTYPE_COIN, 78).        %%获得银币
-define(GOODS_SUBTYPE_SKILL_STONE, 80). %%宠物技能水晶
-define(GOODS_SUBTYPE_ARENA_PT, 101).       %%竞技积分
-define(GOODS_SUBTYPE_DIVINE, 103).       %%占星积分
%%-define(GOODS_SUBTYPE_HONOUR, 89).     %%荣耀
-define(GOODS_SUBTYPE_HONOUR, 574).     %%荣耀
-define(GOODS_SUBTYPE_SD, 575).     %%六龙历练
-define(GOODS_SUBTYPE_REPUTE, 576).     %%声望
-define(GOODS_SUBTYPE_EXPLOIT_PRI, 577). %%玩家功勋
-define(GOODS_SUBTYPE_GUILD_CONTRIB_GOODS, 578).%%直接获得仙盟贡献
-define(GOODS_SUBTYPE_GIFT_BAG, 90).  %%礼包
-define(GOODS_SUBTYPE_FUWEN_GIFT_BAG, 92). %%符文塔礼包
-define(GOODS_SUBTYPE_SIN, 111).  %%神罚值
-define(GOODS_SUBTYPE_ADD_WING, 86).  %%增加翅膀的道具
-define(GOODS_SUBTYPE_TREASURE, 25).%%藏宝图
-define(GOODS_SUBTYPE_INVEST_1, 115).    %%豪华投资
-define(GOODS_SUBTYPE_INVEST_2, 116).   %%至尊投资
-define(GOODS_SUBTYPE_ATTR_DAN, 204).  %%属性丹
-define(GOODS_SUBTYPE_ATTR_DAN_1, 205).  %%属性丹
-define(GOODS_SUBTYPE_ATTR_DAN_2, 206).  %%属性丹
-define(GOODS_SUBTYPE_ATTR_DAN_3, 231).  %%属性丹
-define(GOODS_SUBTYPE_ATTR_DAN_4, 595).  %%属性丹
-define(GOODS_SUBTYPE_ATTR_DAN_5, 596).  %%属性丹
-define(GOODS_SUBTYPE_ATTR_DAN_6, 597).  %%属性丹
-define(GOODS_SUBTYPE_ATTR_DAN_7, 598).  %%属性丹
-define(GOODS_SUBTYPE_ATTR_DAN_8, 599).  %%属性丹
-define(GOODS_SUBTYPE_ATTR_DAN_9, 600).  %%属性丹
-define(GOODS_SUBTYPE_ATTR_DAN_10, 815).  %%属性丹
-define(GOODS_SUBTYPE_ATTR_DAN_11, 951).  %%属性丹
-define(GOODS_SUBTYPE_ATTR_DAN_12, 952).  %%属性丹

-define(GOODS_SUBTYPE_STAR_LUCK_1, 207).  %%星运
-define(GOODS_SUBTYPE_STAR_LUCK_2, 208).  %%星运
-define(GOODS_SUBTYPE_STAR_LUCK_3, 209).  %%星运
-define(GOODS_SUBTYPE_STAR_LUCK_4, 210).  %%星运
-define(GOODS_SUBTYPE_STAR_LUCK_5, 211).  %%星运
-define(GOODS_SUBTYPE_STAR_LUCK_6, 212).  %%星运
-define(GOODS_SUBTYPE_STAR_LUCK_7, 213).  %%星运
-define(GOODS_SUBTYPE_STAR_LUCK_8, 214).  %%星运
-define(GOODS_SUBTYPE_STAR_LUCK_9, 215).  %%星运
-define(GOODS_SUBTYPE_CHARGE_CARD, 232).  %%充值卡
-define(GOODS_SUBTYPE_CANCAL_CHANGE, 249).  %%取消变身功能
-define(GOODS_SUBTYPE_OPEN_EGG_MUL, 250).  %%砸蛋倍数物品
-define(GOODS_SUBTYPE_HP_POOL, 272).  %%血池物品
-define(GOODS_SUBTYPE_RED_BAG, 280).%%全服红包
-define(GOODS_SUBTYPE_RED_BAG_GUILD, 281).%%帮派红包
-define(GOODS_SUBTYPE_REIKI, 282).  %%十荒神器器灵
-define(GOODS_SUBTYPE_MARRY_RING_CRYSTAL, 726).  %% 爱情结晶

-define(GOODS_SUBTYPE_RED_BAG_MARRY, 724).%%结婚红包
-define(GOODS_SUBTYPE_CREATE_BABY, 769).   %% 天之子


%%坐骑装备子类
-define(GOODS_SUBTYPE_EQUIP_MOUNT_1, 301).
-define(GOODS_SUBTYPE_EQUIP_MOUNT_2, 302).
-define(GOODS_SUBTYPE_EQUIP_MOUNT_3, 303).
-define(GOODS_SUBTYPE_EQUIP_MOUNT_4, 304).
%%翅膀装备子类
-define(GOODS_SUBTYPE_EQUIP_WING_1, 305).
-define(GOODS_SUBTYPE_EQUIP_WING_2, 306).
-define(GOODS_SUBTYPE_EQUIP_WING_3, 307).
-define(GOODS_SUBTYPE_EQUIP_WING_4, 308).
%%法宝装备子类
-define(GOODS_SUBTYPE_EQUIP_MAGIC_WEAPON_1, 309).
-define(GOODS_SUBTYPE_EQUIP_MAGIC_WEAPON_2, 310).
-define(GOODS_SUBTYPE_EQUIP_MAGIC_WEAPON_3, 311).
-define(GOODS_SUBTYPE_EQUIP_MAGIC_WEAPON_4, 312).
%%神兵装备子类
-define(GOODS_SUBTYPE_EQUIP_LIGHT_WEAPON_1, 313).
-define(GOODS_SUBTYPE_EQUIP_LIGHT_WEAPON_2, 314).
-define(GOODS_SUBTYPE_EQUIP_LIGHT_WEAPON_3, 315).
-define(GOODS_SUBTYPE_EQUIP_LIGHT_WEAPON_4, 316).
%%妖灵装备子类
-define(GOODS_SUBTYPE_EQUIP_PET_WEAPON_1, 317).
-define(GOODS_SUBTYPE_EQUIP_PET_WEAPON_2, 318).
-define(GOODS_SUBTYPE_EQUIP_PET_WEAPON_3, 319).
-define(GOODS_SUBTYPE_EQUIP_PET_WEAPON_4, 320).
%%足迹备子类
-define(GOODS_SUBTYPE_EQUIP_FOOTPRINT_1, 321).
-define(GOODS_SUBTYPE_EQUIP_FOOTPRINT_2, 322).
-define(GOODS_SUBTYPE_EQUIP_FOOTPRINT_3, 323).
-define(GOODS_SUBTYPE_EQUIP_FOOTPRINT_4, 324).

%%灵猫装备子类
-define(GOODS_SUBTYPE_EQUIP_CAT_1, 325).
-define(GOODS_SUBTYPE_EQUIP_CAT_2, 326).
-define(GOODS_SUBTYPE_EQUIP_CAT_3, 327).
-define(GOODS_SUBTYPE_EQUIP_CAT_4, 328).


%%金身装备子类
-define(GOODS_SUBTYPE_EQUIP_GOLDEN_BODY_1, 329).
-define(GOODS_SUBTYPE_EQUIP_GOLDEN_BODY_2, 330).
-define(GOODS_SUBTYPE_EQUIP_GOLDEN_BODY_3, 331).
-define(GOODS_SUBTYPE_EQUIP_GOLDEN_BODY_4, 332).

%%子女翅膀装备子类
-define(GOODS_SUBTYPE_EQUIP_BABY_WING_1, 333).
-define(GOODS_SUBTYPE_EQUIP_BABY_WING_2, 334).
-define(GOODS_SUBTYPE_EQUIP_BABY_WING_3, 335).
-define(GOODS_SUBTYPE_EQUIP_BABY_WING_4, 336).

%%子女坐骑装备子类
-define(GOODS_SUBTYPE_EQUIP_BABY_MOUNT_1, 337).
-define(GOODS_SUBTYPE_EQUIP_BABY_MOUNT_2, 338).
-define(GOODS_SUBTYPE_EQUIP_BABY_MOUNT_3, 339).
-define(GOODS_SUBTYPE_EQUIP_BABY_MOUNT_4, 340).

%%子女武器装备子类
-define(GOODS_SUBTYPE_EQUIP_BABY_WEAPON_1, 823).
-define(GOODS_SUBTYPE_EQUIP_BABY_WEAPON_2, 824).
-define(GOODS_SUBTYPE_EQUIP_BABY_WEAPON_3, 825).
-define(GOODS_SUBTYPE_EQUIP_BABY_WEAPON_4, 826).

%%玉佩装备子类
-define(GOODS_SUBTYPE_EQUIP_JADE_1, 865).
-define(GOODS_SUBTYPE_EQUIP_JADE_2, 866).
-define(GOODS_SUBTYPE_EQUIP_JADE_3, 867).
-define(GOODS_SUBTYPE_EQUIP_JADE_4, 868).

%%仙宝装备子类
-define(GOODS_SUBTYPE_EQUIP_GOD_TREASURE_1, 861).
-define(GOODS_SUBTYPE_EQUIP_GOD_TREASURE_2, 862).
-define(GOODS_SUBTYPE_EQUIP_GOD_TREASURE_3, 863).
-define(GOODS_SUBTYPE_EQUIP_GOD_TREASURE_4, 864).

%% 宝宝装备子类型
-define(GOODS_SUBTYPE_EQUIP_BABY_1, 759).
-define(GOODS_SUBTYPE_EQUIP_BABY_2, 760).
-define(GOODS_SUBTYPE_EQUIP_BABY_3, 761).
-define(GOODS_SUBTYPE_EQUIP_BABY_4, 762).
-define(GOODS_SUBTYPE_EQUIP_BABY_5, 763).
-define(GOODS_SUBTYPE_EQUIP_BABY_6, 764).
-define(GOODS_SUBTYPE_EQUIP_BABY_7, 765).
-define(GOODS_SUBTYPE_EQUIP_BABY_8, 766).

%% 表情卡相关
-define(GOODS_SUBTYPE_VIP_FACE_CARD, 777).
%%仙盟勋章
-define(GOODS_SUBTYPE_GUILD_MEDAL, 1073).

%% 宝宝装备列表
-define(GOODS_SUBTYPE_EQUIP_BABY_LIST, [?GOODS_SUBTYPE_EQUIP_BABY_1, ?GOODS_SUBTYPE_EQUIP_BABY_2,
    ?GOODS_SUBTYPE_EQUIP_BABY_3, ?GOODS_SUBTYPE_EQUIP_BABY_4, ?GOODS_SUBTYPE_EQUIP_BABY_5,
    ?GOODS_SUBTYPE_EQUIP_BABY_6, ?GOODS_SUBTYPE_EQUIP_BABY_7, ?GOODS_SUBTYPE_EQUIP_BABY_8
]).


%% 具有随机属性的装备大类型
-define(GOODS_TYPE_EQUIP_RANDOM_LIST, [
    ?GOODS_TYPE_EQUIP10
]).

%% 具有随机属性的装备子类型
-define(GOODS_SUBTYPE_EQUIP_RANDOM_LIST, [
    ?GOODS_SUBTYPE_EQUIP_BABY_1, ?GOODS_SUBTYPE_EQUIP_BABY_2, ?GOODS_SUBTYPE_EQUIP_BABY_3,
    ?GOODS_SUBTYPE_EQUIP_BABY_4, ?GOODS_SUBTYPE_EQUIP_BABY_5, ?GOODS_SUBTYPE_EQUIP_BABY_6,
    ?GOODS_SUBTYPE_EQUIP_BABY_7, ?GOODS_SUBTYPE_EQUIP_BABY_8
]).


-define(GOODS_SUBTYPE_MON_PHOTO, 541).      %%图鉴

-define(GOODS_SUBTYPE_UP_LV, 571).%%提升玩家等级1级
-define(GOODS_SUBTYPE_UP_TO_LV, 572).%%提升玩家等级到N
-define(GOODS_SUBTYPE_UP_STAGE_MOUNT, 431).%%提升坐骑阶数1阶
-define(GOODS_SUBTYPE_UP_TO_STAGE_MOUNT, 581).%%提升坐骑阶数到N
-define(GOODS_SUBTYPE_UP_STAGE_WING, 432).%%提升翅膀阶数1阶
-define(GOODS_SUBTYPE_UP_TO_STAGE_WING, 582).%%提升翅膀阶数到N
-define(GOODS_SUBTYPE_UP_STAGE_MAGIC_WEAPON, 433).%%提升法宝阶1阶
-define(GOODS_SUBTYPE_UP_TO_STAGE_MAGIC_WEAPON, 583).%%提升法宝阶数到N
-define(GOODS_SUBTYPE_UP_STAGE_LIGHT_WEAPON, 434).%%提升神兵阶数1阶
-define(GOODS_SUBTYPE_UP_TO_STAGE_LIGHT_WEAPON, 584).%%提升神兵阶数到N
-define(GOODS_SUBTYPE_UP_STAGE_PET_WEAPON, 435).%%提升妖灵阶数1阶
-define(GOODS_SUBTYPE_UP_TO_STAGE_PET_WEAPON, 585).%%提升妖灵阶数到N
-define(GOODS_SUBTYPE_UP_STAGE_FOOTPRINT, 436).%%提升足迹阶数1阶
-define(GOODS_SUBTYPE_UP_TO_STAGE_FOOTPRINT, 586).%%提升足迹阶数到N
-define(GOODS_SUBTYPE_UP_STAGE_CAT, 437).%%提升灵猫阶数1阶
-define(GOODS_SUBTYPE_UP_TO_STAGE_CAT, 587).%%提升灵猫阶数到N
-define(GOODS_SUBTYPE_UP_STAGE_GOLDEN_BODY, 438).%%提升金身阶数1阶
-define(GOODS_SUBTYPE_UP_TO_STAGE_GOLDEN_BODY, 588).%%提升金身阶数到N
-define(GOODS_SUBTYPE_UP_STAGE_BABY_WING, 439). %%提升子女翅膀阶数1阶
-define(GOODS_SUBTYPE_UP_TO_STAGE_BABY_WING, 589).  %%提升子女翅膀阶数到N
-define(GOODS_SUBTYPE_UP_STAGE_JADE, 942).%%提升玉佩阶数1阶
%% -define(GOODS_SUBTYPE_UP_TO_STAGE_JADE, 589).%%提升玉佩阶数到N
-define(GOODS_SUBTYPE_UP_STAGE_GOD_TREASURE, 941).%%提升仙宝阶数1阶
%% -define(GOODS_SUBTYPE_UP_TO_STAGE_GOD_TREASURE, 589).%%提升仙宝阶数到N


-define(GOODS_SUBTYPE_UP_STAGE_BABY_MOUNT, 440). %%提升子女坐骑阶数1阶
-define(GOODS_SUBTYPE_UP_TO_STAGE_BABY_MOUNT, 590).  %%提升子女坐骑阶数到N
-define(GOODS_SUBTYPE_UP_STAGE_BABY_WEAPON, 818). %%提升子女武器阶数1阶
-define(GOODS_SUBTYPE_UP_TO_STAGE_BABY_WEAPON, 820).  %%提升子女武器阶数到N

-define(GOODS_SUBTYPE_UP_STAGE_MOUNT_LIMIT, 660).%%提升坐骑阶数1阶 (特定等级使用)
-define(GOODS_SUBTYPE_UP_STAGE_WING_LIMIT, 661).%%提升翅膀阶数1阶 (特定等级使用)
-define(GOODS_SUBTYPE_UP_STAGE_MAGIC_WEAPON_LIMIT, 662).%%提升法宝阶1阶 (特定等级使用)
-define(GOODS_SUBTYPE_UP_STAGE_LIGHT_WEAPON_LIMIT, 663).%%提升神兵阶数1阶 (特定等级使用)
-define(GOODS_SUBTYPE_UP_STAGE_PET_WEAPON_LIMIT, 664).%%提升妖灵阶数1阶 (特定等级使用)
-define(GOODS_SUBTYPE_UP_STAGE_FOOTPRINT_LIMIT, 665).%%提升足迹阶数1阶 (特定等级使用)
-define(GOODS_SUBTYPE_UP_STAGE_CAT_LIMIT, 666).%%提升灵猫阶数1阶 (特定等级使用)
-define(GOODS_SUBTYPE_UP_STAGE_GOLDEN_BODY_LIMIT, 667).%%提升金身阶数1阶 (特定等级使用)
-define(GOODS_SUBTYPE_UP_STAGE_BABY_WING_LIMIT, 668).%%提升子女翅膀阶数1阶 (特定等级使用)
-define(GOODS_SUBTYPE_UP_STAGE_BABY_MOUNT_LIMIT, 669).%%提升子女坐骑阶数1阶 (特定等级使用)
-define(GOODS_SUBTYPE_UP_STAGE_BABY_WEAPON_LIMIT, 819).%%提升子女坐骑阶数1阶 (特定等级使用)
-define(GOODS_SUBTYPE_UP_STAGE_JADE_LIMIT, 943).%%提升玉佩阶数1阶 (特定等级使用)
-define(GOODS_SUBTYPE_UP_STAGE_GOD_TREASURE_LIMIT, 944).%%提升仙宝阶数1阶 (特定等级使用)


-define(GOODS_SUBTYPE_UP_CHANGE_SEX, 728).%% 变性丹

-define(GOODS_SUBTYPE_BUFF, 573).%%buff

%%符文相关
-define(GOODS_SUBTYPE_FUWEN_1, 611).
-define(GOODS_SUBTYPE_FUWEN_2, 612).
-define(GOODS_SUBTYPE_FUWEN_3, 613).
-define(GOODS_SUBTYPE_FUWEN_4, 614).
-define(GOODS_SUBTYPE_FUWEN_5, 615).
-define(GOODS_SUBTYPE_FUWEN_6, 616).
-define(GOODS_SUBTYPE_FUWEN_7, 617).
-define(GOODS_SUBTYPE_FUWEN_8, 618).
-define(GOODS_SUBTYPE_FUWEN_9, 619).
-define(GOODS_SUBTYPE_FUWEN_10, 620).
-define(GOODS_SUBTYPE_FUWEN_11, 621).
-define(GOODS_SUBTYPE_FUWEN_12, 622).
-define(GOODS_SUBTYPE_FUWEN_13, 623).
-define(GOODS_SUBTYPE_FUWEN_14, 624).
-define(GOODS_SUBTYPE_FUWEN_15, 625).
-define(GOODS_SUBTYPE_FUWEN_16, 626).
-define(GOODS_SUBTYPE_FUWEN_WHITE, 630). %% 白色类的经验符文
%%部分字段
-define(GOODS_SUBTYPE_FUWEN_EXP, 851). %% 符文经验
-define(GOODS_SUBTYPE_FUWEN_CHIP, 852). %% 符文碎片

%%双属性符文相关
-define(GOODS_SUBTYPE_DOUBLE_FUWEN_1, 671).
-define(GOODS_SUBTYPE_DOUBLE_FUWEN_2, 672).
-define(GOODS_SUBTYPE_DOUBLE_FUWEN_3, 673).
-define(GOODS_SUBTYPE_DOUBLE_FUWEN_4, 674).
-define(GOODS_SUBTYPE_DOUBLE_FUWEN_5, 675).
-define(GOODS_SUBTYPE_DOUBLE_FUWEN_6, 676).
-define(GOODS_SUBTYPE_DOUBLE_FUWEN_7, 677).
-define(GOODS_SUBTYPE_DOUBLE_FUWEN_8, 678).

-define(GOODS_SUBTYPE_DOUBLE_FUWEN_EXP, 695). %% 至尊精华


%%仙装相关
-define(GOODS_SUBTYPE_XIAN_1, 641).
-define(GOODS_SUBTYPE_XIAN_2, 642).
-define(GOODS_SUBTYPE_XIAN_3, 643).
-define(GOODS_SUBTYPE_XIAN_4, 644).

%%仙玉
-define(GOODS_SUBTYPE_XIAN_YU, 833).

%%仙魂相关
-define(GOODS_SUBTYPE_FAIRY_SOUL_1, 801).
-define(GOODS_SUBTYPE_FAIRY_SOUL_2, 802).
-define(GOODS_SUBTYPE_FAIRY_SOUL_3, 803).
-define(GOODS_SUBTYPE_FAIRY_SOUL_4, 804).
-define(GOODS_SUBTYPE_FAIRY_SOUL_5, 805).
-define(GOODS_SUBTYPE_FAIRY_SOUL_6, 806).
-define(GOODS_SUBTYPE_FAIRY_SOUL_7, 807).
-define(GOODS_SUBTYPE_FAIRY_SOUL_8, 808).
-define(GOODS_SUBTYPE_FAIRY_SOUL_9, 809).
-define(GOODS_SUBTYPE_FAIRY_SOUL_10, 810).
-define(GOODS_SUBTYPE_FAIRY_SOUL_11, 811).
-define(GOODS_SUBTYPE_FAIRY_SOUL_12, 812).

-define(GOODS_SUBTYPE_FAIRY_SOUL_EXP, 813). %% 仙魂经验
-define(GOODS_SUBTYPE_FAIRY_SOUL_CHIP, 814). %% 仙魂碎片


%%仙境活动兑换卡
-define(GOODS_SUBTYPE_XJ_CARD, 651).

-define(GOODS_SUBTYPE_MANOR_PT, 650).%%家园物资类型

%%时装子类列表
-define(FASHION_SUBTYPE_LIST, [
    ?GOODS_SUBTYPE_FASHION1, ?GOODS_SUBTYPE_FASHION2, ?GOODS_SUBTYPE_FASHION3, ?GOODS_SUBTYPE_FASHION4,
    ?GOODS_SUBTYPE_HEAD1, ?GOODS_SUBTYPE_HEAD2, ?GOODS_SUBTYPE_HEAD3, ?GOODS_SUBTYPE_HEAD4,
    ?GOODS_SUBTYPE_BUBBLE1, ?GOODS_SUBTYPE_BUBBLE2, ?GOODS_SUBTYPE_BUBBLE3, ?GOODS_SUBTYPE_BUBBLE4,
    ?GOODS_SUBTYPE_DESIGNATION1, ?GOODS_SUBTYPE_DESIGNATION2, ?GOODS_SUBTYPE_DESIGNATION3, ?GOODS_SUBTYPE_DESIGNATION4,
    ?GOODS_SUBTYPE_DECORATION1, ?GOODS_SUBTYPE_DECORATION2, ?GOODS_SUBTYPE_DECORATION3, ?GOODS_SUBTYPE_DECORATION4
]).


%%外观类灵脉
-define(GOODS_SUBTYPE_MOUNT_SPIRIT, 631).
-define(GOODS_SUBTYPE_WING_SPIRIT, 632).
-define(GOODS_SUBTYPE_MAGIC_WEAPON_SPIRIT, 633).
-define(GOODS_SUBTYPE_LIGHT_WEAPON_SPIRIT, 634).
-define(GOODS_SUBTYPE_PET_WEAPON_SPIRIT, 635).
-define(GOODS_SUBTYPE_FOOTPRINT_SPIRIT, 636).
-define(GOODS_SUBTYPE_CAT_SPIRIT, 637).
-define(GOODS_SUBTYPE_GOLDEN_BODY_SPIRIT, 638).
-define(GOODS_SUBTYPE_BABY_WING_SPIRIT, 639).
-define(GOODS_SUBTYPE_BABY_MOUNT_SPIRIT, 640).
-define(GOODS_SUBTYPE_BABY_WEAPON_SPIRIT, 821).
-define(GOODS_SUBTYPE_GOD_TREASURE_SPIRIT, 961).
-define(GOODS_SUBTYPE_JADE_SPIRIT, 962).

%%神魂相关
-define(GOODS_SUBTYPE_GOD_SOUL_1, 981).
-define(GOODS_SUBTYPE_GOD_SOUL_2, 982).
-define(GOODS_SUBTYPE_GOD_SOUL_3, 983).
-define(GOODS_SUBTYPE_GOD_SOUL_4, 984).
-define(GOODS_SUBTYPE_GOD_SOUL_5, 985).
-define(GOODS_SUBTYPE_GOD_SOUL_6, 986).

%%神祇碎片
-define(GOODS_SUBTYPE_GOD_CHIP, 1049).
%%神祇之聚灵神火
-define(GOODS_SUBTYPE_GOD_FIRE, 1050).
%%神祇之银星沙
-define(GOODS_SUBTYPE_GOD_STONE_1, 1051).
%%神祇之金星沙
-define(GOODS_SUBTYPE_GOD_STONE_2, 1052).
%%神祇之恒星沙
-define(GOODS_SUBTYPE_GOD_STONE_3, 1053).


%%仙晶
-define(GOODS_SUBTYPE_FAIRY_CRYSTAL, 1083).


%%----------------------物品类型、子类型定义----end-----------------


%%----------------------物品使用的原因-----------
-define(GOODS_USE_BY_BAG, 1). %%背包使用
-define(GOODS_USE_DIRECT, 0).  %%这种一般为银币，经验等数值奖励，在任务的时候，发放给玩家，直接变成了数值，而不会进入背包里面

%%虚拟物品ID
-define(GOODS_ID_EXP, 10108).
-define(GOODS_ID_COIN, 10107).
-define(GOODS_ID_BCOIN, 10109).
-define(GOODS_ID_BGOLD, 10106).
-define(GOODS_ID_ARENA_PT, 10299).
-define(GOODS_ID_GUILD_CONTRIB, 10111).
-define(GOODS_ID_HONOR, 10103).
-define(GOODS_ID_DRAGON_ATT, 28200).
-define(GOODS_ID_DRAGON_DEF, 28201).
-define(GOODS_ID_DRAGON_BOX, 28204).
-define(GOODS_ID_GOLD, 10199).
-define(GOODS_ID_XIANYU, 7405001).
-define(GOODS_ID_MEDAL, 7750002).

%%--------属性丹类型 ----
-define(GOODS_DAN_TYPE_MOUNT, 1).%%坐骑丹
-define(GOODS_DAN_TYPE_WING, 2).%%翅膀丹
-define(GOODS_DAN_TYPE_MAGIC_WEAPON, 3).%%法宝
-define(GOODS_DAN_TYPE_LIGHT_WEAPON, 4).%%神兵
-define(GOODS_DAN_TYPE_PET_WEAPON, 5).%%神兵
-define(GOODS_DAN_TYPE_FOOTPRINT, 6).%%足迹
-define(GOODS_DAN_TYPE_CAT, 7).%%灵猫
-define(GOODS_DAN_TYPE_GOLDEN_BODY, 8).%%金身
-define(GOODS_DAN_TYPE_BABY_WING, 9).%%子女翅膀丹
-define(GOODS_DAN_TYPE_BABY_MOUNT, 10).%%子女坐骑丹
-define(GOODS_DAN_TYPE_BABY_WEAPON, 11).%%子女武器丹
-define(GOODS_DAN_TYPE_JADE, 12).%%玉佩
-define(GOODS_DAN_TYPE_GOD_TREASURE, 13).%%仙宝


-define(GOODS_GROW_ID_MOUNT, 3102000). %% 坐骑成长丹
-define(GOODS_GROW_ID_WING, 3202000). %% 仙羽成长丹
-define(GOODS_GROW_ID_MAGIC_WEAPON, 3302000). %% 法宝成长丹
-define(GOODS_GROW_ID_LIGHT_WEAPON, 3402000). %% 神兵成长丹
-define(GOODS_GROW_ID_PET_WEAPON, 3502000). %% 妖灵成长丹
-define(GOODS_GROW_ID_FOOTPRINT, 3602000). %% 足迹成长丹
-define(GOODS_GROW_ID_CAT, 3702000). %% 灵猫成长丹
-define(GOODS_GROW_ID_GOLDEN_BODY, 3802000). %% 金身成长丹
-define(GOODS_GROW_ID_BABY_WING, 3902000). %% 子女仙羽成长丹
-define(GOODS_GROW_ID_BABY_MOUNT, 4002000). %% 子女坐骑成长丹
-define(GOODS_GROW_ID_BABY_WEAPON, 6002000). %% 子女武器成长丹
-define(GOODS_GROW_ID_JADE, 6202000). %% 玉佩成长丹
-define(GOODS_GROW_ID_GOD_TREASURE, 6302000). %% 仙宝成长丹


%% 物品记录状态
-record(st_goods, {
    key = 0,
    sid,
    dict = none,                                  %%玩家物品字典
    max_cell = ?DEFAULT_CELL_NUM,                 %%已经开启的格子数目
    leftover_cell_num = ?DEFAULT_CELL_NUM,        %%剩余格子
    weared_equip = [],                            %%玩家身上穿戴的装备
    equip_attribute = #attribute{},              %%所有装备给玩家附加的属性，这部分不包含套装属性
    stone_suit_attribute = #attribute{},         %%镶嵌套装属性
    stren_suit_attribute = #attribute{},         %%强化套装属性
    soul_suit_attribute = #attribute{},         %%武魂套装属性
    star_attribute = #attribute{},               %%装备星级套装属性
    equip_num_attribute = #attribute{},          %%装备数量套装属性
    gemstone_suit_attribute = #attribute{},      %%装备宝石套装属性
    weared_fuwen = [],                            %%玩家身上的符文
    fuwen_attribute = #attribute{},              %%所有符文给玩家添加的属性
    maxfuwen_cell_num = ?DEFAULT_FUWEN_NUM,          %%符文背包最大格子数
    leftfuwen_cell_num = ?DEFAULT_FUWEN_NUM,          %%符文剩余的格子数

    weared_xian = [],                            %%玩家身上的仙装
    xian_attribute = #attribute{},              %%所有仙装给玩家添加的属性
    maxxian_cell_num = ?DEFAULT_XIAN_NUM,          %%仙装背包最大格子数
    leftxian_cell_num = ?DEFAULT_XIAN_NUM,          %%仙装剩余的格子数

    weared_god_soul = [],                            %%玩家身上的神魂
    maxgod_soul_cell_num = ?DEFAULT_GOD_SOUL_NUM,          %%神魂背包最大格子数
    leftgod_soul_cell_num = ?DEFAULT_GOD_SOUL_NUM,          %%神魂剩余的格子数

    weared_fairy_soul = [],                             %% 玩家身上的仙魂
    left_fairy_soul_cell_num = ?DEFAULT_FAIRY_SOUL_NUM,     %%仙魂剩余的格子数
    max_fairy_cell_num = ?DEFAULT_FAIRY_SOUL_NUM,
    fairy_soul_attribute = #attribute{},                %%所有仙魂给玩家添加的属性

    warehouse_dict = none,                             %%仓库字典
    warehouse_max_cell = ?DEFAULT_CELL_NUM,             %%仓库物品字典
    warehouse_leftover_cell_num = ?DEFAULT_CELL_NUM  %%仓库物品字典
}).

-record(weared_equip, {
    pos,
    goods_id,
    goods_key,
    equip_attribute
}).

-record(weared_fuwen, {
    pos = 0,
    goods_id = 0,
    goods_key = 0,
    fuwen_attribute = #attribute{}
}).

-record(weared_xian, {
    pos = 0,
    goods_id = 0,
    goods_key = 0,
    xian_attribute = #attribute{}
}).

-record(weared_god_soul, {
    pos = 0,
    goods_id = 0,
    goods_key = 0,
    wear_key = 0,
    god_soul_attribute = #attribute{}
}).

-record(weared_fairy_soul, {
    pos = 0,
    goods_id = 0,
    goods_key = 0,
    fairy_soul_attribute = #attribute{}
}).

-record(equip_attr_view, {
    goods_id = 0,
    stren = 0,
    star = 0,
    gem = [],
    wash = [],
    refine_attr = [],
    magic_info = [],
    god_forging = 0,
    level = 0
}).



-record(baby_equip_attr_view, {
    goods_id = 0,
    fix_attrs = 0,
    random_attrs = 0,
    sex = 0,
    color = 0,
    goods_lv = 0,
    star = 0,
    cbp = 0

}).

-record(goods_type, {
    goods_id = 0,            %%类型ID
    display = 0,
    goods_icon = 0,
    goods_name = none,        %%名字
    describe = none,        %%描述
    type = 0,                %%大类
    subtype = 0,            %%子类型
    color = 0,                %%物品颜色
    star = 0,               %%星级
    sex = 0,                %%性别没有限制填0
    career = 0,                %%职业,没有限制填0
    need_lv = 0,            %%佩戴或者使用需要的等级
    equip_lv = 0,            %%装备等级
    max_overlap = 0,        %%单格最大叠加数量
    sell_price = 0,            %%出售价格，如果为0，则表明该物品不可出售
    bind = 0,                %%产出时默认是否绑定
    expire_time = 0,        %%拥有时间，0则是永久拥有
    can_drop = 0,            %%是否可以扔掉
    use_panel = 0,            %%使用的地方
    is_rarity = 0,
    special_param_list,        %%特殊参数列表，比如存储银币类数量
    max_wash_hole = 0,
    max_gstone_hole = 0,
    attr_list,             %%物品属性
    rand_attr_list,        %% 随机属性
    client_label = 0,       %%客户端标签
    role_warning_num = 0,  %%当天个人产出报警阀值
    server_warning_num = 0,  %%当天全服产出报警阀值
    extra_val = 0,
    is_sell = 0,             %%是否可出售
    market_type = 0,        %%集市大类
    market_subtype = 0,       %%集市子类
    drop_give_list = [],   %%
    smelt = 0,
    smelt_sort = 0,
    batch = 0
}).

-record(goods, {
    key = none,
    pkey = 0,
    goods_id = 0,
    location = 0,
    cell = 0,
    state = 0, %%0正常，1，删除，重要装备删除后，并不会直接在数据库中删除，而是简单的把该字段置为1,用于重找回功能
    num = 0,
    bind = 0,
    expire_time = 0,
    create_time = 0,
    origin = 0,
    goods_lv = 0,       %% 物品等级
    level = 0,          %% 装备升级等级
    star = 0,
    stren = 0,
    color = 0,
    exp = 0,
    lock = 0,  %% 锁定状态
    wear_key = 0, %% 穿戴在某一子系统的key
    god_forging = 0, %% 神炼等级
    wash_luck_value = 0,
    wash_attr = [],         %%物品当前所有洗练出来的属性
    xian_wash_attr = [], %% 仙练属性，出生就有，且后续可以洗练
    god_soul_attr = [],
    gemstone_groove = [],
    refine_attr = [],       %% 精炼属性
    total_attrs = [],       %%总属性
    magic_attrs = [],   %% 附魔属性
    soul_attrs = [], %% 武魂属性
    fix_attrs = [],  %% 固定属性
    random_attrs = [],%% 随机属性
    sex = 0,          %% 性别为0
    combat_power = 0,
    is_change = 0
}).

-record(give_goods, {
    goods_id = 0,
    num = 0,
    location = ?GOODS_LOCATION_BAG,
    bind = ?BIND,
    from = 0,
    expire_time = 0, %%有效时间
    args = [],
    share = 0,      %%是否伤害共享,1是0否
    goods_type = #goods_type{}
}).

-record(base_attr_dan, {
    goods_id = 0,
    type = 1,
    stage_max_num = [],
    attr_percent_list = [],
    attr_list = [],
    step_lim = 0
}).

-record(base_grow_dan, {
    goods_id = 0,
    type = 1,
    stage_max_num = [],
    attr_percent = [],
    step_lim = 0
}).

-record(base_gift, {
    goods_id = 0,   %%礼包id
    need_gold = 0,  %%打开所需元宝0无
    need_goods = [],%%打开所需要的物品
    choose_get = [], %% 自选物品
    must_get = [],  %%必定开出
    random_num = 0, %%随机开出数量
    random_repeat = 0,  %%随机是否重复抽取1是0否
    career0 = [],   %%随机开出无职业[{物品id,数量,绑定状态,权值}]
    career1 = [],   %%随机开出职业1[{物品id,数量,绑定状态,权值}]
    career2 = [],    %%随机开出职业2[{物品id,数量,绑定状态,权值}]
    cherish_list = [] %% 珍惜道具[{goods_id, goods_num}]
}).

%% 人物属性丹
-record(base_role_attr_dan, {
    id = 1,
    goods_id = 0,
    type = 1,
    daily_limit = 0,
    max_count = 0,
    attr_list = []
}).


-endif.