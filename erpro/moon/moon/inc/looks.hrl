%%---------------------------------------------------- 
%% 外观效果相关处理 
%% @author yeahoo2000@gmail.com 
%%---------------------------------------------------- 
 
%% 外观效果 
%% Looks = [{外观类型, 物品ID, 值}, ....]. 

%% 衣柜里的LOOKS
-define(WARDROBE_DRESS_LOOKS, [?LOOKS_TYPE_DRESS, ?LOOKS_TYPE_WING, ?LOOKS_TYPE_WEAPON_DRESS, ?LOOKS_TYPE_FOOTPRINT, ?LOOKS_TYPE_CHATFRAME, ?LOOKS_TYPE_TEXT]).

%% -------------------------------------------------------------------------- 
%% LOOK_TYPE 外观类型 
%% -------------------------------------------------------------------------- 
%% 外观类型 
-define(LOOKS_TYPE_RIDE, 1).   %% 坐骑 
-define(LOOKS_TYPE_WEAPON, 2). %% 武器  (武器强化光环特效)    
-define(LOOKS_TYPE_DRESS, 3).  %% 时装 (  
-define(LOOKS_TYPE_SETS, 4).   %% 套装 (全身强化特效 
-define(LOOKS_TYPE_HEAD, 5).   %% 头    （时装中的头饰
-define(LOOKS_TYPE_ALL, 6).    %% 全套强化 
-define(LOOKS_TYPE_WING, 7).   %% 翅膀外观  (时装中的翅膀
-define(LOOKS_TYPE_ACT, 8).    %% 活动标志[运镖, 竞技, 跑商, 护送小孩] 
-define(LOOKS_TYPE_CLOTHES, 9). %% 是否穿了上衣 
-define(LOOKS_TYPE_MODEl, 10). %% 外观模型 
-define(LOOKS_TYPE_VIP, 11).   %% VIP类型 
-define(LOOKS_TYPE_ALPHA, 12). %% 透明  
-define(LOOKS_SPRING, 13).     %% 温泉 
-define(LOOKS_TYPE_HONOR, 14). %% 称号 
-define(LOOKS_TYPE_GUILD_WAR, 15).  %% 帮战中正在击打晶石 
-define(LOOKS_SPRING_UNINTERACT, 16).     %% 温泉中不可以在进行交互动作 
-define(LOOKS_TYPE_GUILD_WAR_HONOR, 17).  %% 帮战胜利帮会的外观 
-define(LOOKS_TYPE_ARENA_SUPERMAN, 18).  %% 竞技场猛人标志 
-define(LOOKS_TYPE_FLY_SIGN, 20).  %% 飞行符 
-define(LOOKS_TYPE_GUARD_HONOR, 21). %% 守卫洛水城主 
-define(LOOKS_TYPE_WEDDING, 25).    %% 婚礼外观模型 
-define(LOOKS_TYPE_WEDDING_FIRE, 26).    %% 婚礼烟花模型 
-define(LOOKS_TYPE_WEDDING_TITLE, 27).   %% 婚礼临时称号
-define(LOOKS_TYPE_WEAPON_DRESS, 30). %% 武器时装    附加强二十特效
-define(LOOKS_TYPE_JEWELRY_DRESS, 31). %% 饰品时装  
-define(LOOKS_TYPE_GUILD_ARENA, 32). %% 新帮战中
-define(LOOKS_TYPE_CHANGE_MODE, 33). %% 变身中 
-define(LOOKS_TYPE_ROOM, 34).       %% 房间外观
-define(LOOKS_TYPE_KING, 35).       %% 至尊王者 
-define(LOOKS_TYPE_DEMON, 36).      %% 精灵守护跟随
-define(LOOKS_TYPE_DEMON_BOTH, 37). %% 精灵守护双修
-define(LOOKS_TYPE_CAMP_DRESS, 38). %% 活动时装 
-define(LOOKS_TYPE_RIDE_BOTH, 39).  %% 双人骑乘
-define(LOOKS_TYPE_SUN_BATH, 40).   %% 日光浴
-define(LOOKS_TYPE_SUN_BATH_POS, 41).   %% 日光浴位置
-define(LOOKS_TYPE_SPRING_SIT, 42).     %% 温泉双修
-define(LOOKS_TYPE_PET_CLOUD, 43).      %% 宠物筋斗云
-define(LOOKS_TYPE_CAREER_ASCEND, 44).  %% 职业进阶方向
-define(LOOKS_TYPE_CAREER_ASCEND_EFFECT, 45).  %% 职业进阶特效
-define(LOOKS_TYPE_GUARD_COUNTER, 46).  %% 洛水反击采集中
-define(LOOKS_TYPE_FOOTPRINT, 47).      %% 足迹
-define(LOOKS_TYPE_CHATFRAME, 48).      %% 聊天框
-define(LOOKS_TYPE_TEXT, 49).      %% 文字
-define(LOOKS_TYPE_WEAPON_ENCHANT, 50).      %% 武器强化二十级特效
%% -------------------------------------------------------------------------- 
%% LOOK_VAL 外观类型属性值 
%% -------------------------------------------------------------------------- 
%% 强化引起外观时 
-define(LOOKS_VAL_ENCHANT_NORMAL,   10). %% 武器、坐骑、时装 翅膀无强化 
-define(LOOKS_VAL_ENCHANT_NINE,  11). %% 武器、坐骑、时装 翅膀 +9 
-define(LOOKS_VAL_ENCHANT_TWELVE, 12). %% 武器、坐骑、时装 翅膀 +12  
 
%% 达到某些条件影响外观 
-define(LOOKS_VAL_ALL_TEN, 21).  %% 全身装备+10 
-define(LOOKS_VAL_ALL_ELEVEN, 22).  %% 全身装备+11 
-define(LOOKS_VAL_ALL_TWELVE, 23). %% 全身装备+12 

%% 变身
-define(LOOKS_VAL_MODE_CHILD, 600). %% 变身小孩
-define(LOOKS_VAL_MODE_ZHENYAOTA_1, 601).
-define(LOOKS_VAL_MODE_ZHENYAOTA_2, 602).
-define(LOOKS_VAL_MODE_ZHENYAOTA_3, 603).
-define(LOOKS_VAL_MODE_ZHENYAOTA_4, 604).
-define(LOOKS_VAL_MODE_ZHENYAOTA_5, 605).
-define(LOOKS_VAL_MODE_ZHENYAOTA_6, 606).
-define(LOOKS_VAL_MODE_ZHENYAOTA_7, 607).
-define(LOOKS_VAL_MODE_ZHENYAOTA_8, 608).
-define(LOOKS_VAL_MODE_ZHENYAOTA_9, 609).
-define(LOOKS_VAL_MODE_ZHENYAOTA_10, 610).
-define(LOOKS_VAL_MODE_ZHENYAOTA_11, 611).
-define(LOOKS_VAL_MODE_ZHENYAOTA_12, 612).
-define(LOOKS_VAL_MODE_LONGGONG_1, 613).
-define(LOOKS_VAL_MODE_LONGGONG_2, 614).
-define(LOOKS_VAL_MODE_LONGGONG_3, 615).
-define(LOOKS_VAL_MODE_LONGGONG_4, 616).
-define(LOOKS_VAL_MODE_LONGGONG_5, 617).
-define(LOOKS_VAL_MODE_LONGGONG_6, 618).
-define(LOOKS_VAL_MODE_LONGGONG_7, 619).
-define(LOOKS_VAL_MODE_LONGGONG_8, 620).
-define(LOOKS_VAL_MODE_LONGGONG_9, 621).
-define(LOOKS_VAL_MODE_LONGGONG_10, 622).
-define(LOOKS_VAL_MODE_LONGGONG_11, 623).
-define(LOOKS_VAL_MODE_LONGGONG_12, 624).
-define(LOOKS_VAL_MODE_dun_1, 620).
-define(LOOKS_VAL_MODE_boss_change_1, 625).
-define(LOOKS_VAL_MODE_boss_change_2, 626).
-define(LOOKS_VAL_MODE_huodong_change_1, 627).
 
-define(LOOKS_VAL_SET_11, 211). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_12, 212). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_13, 213). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_14, 214). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_15, 215). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_16, 216). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_17, 217). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
 
-define(LOOKS_VAL_SET_21, 221). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_22, 222). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_23, 223). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_24, 224). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_25, 225). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_26, 226). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_27, 227). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
 
-define(LOOKS_VAL_SET_31, 231). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_32, 232). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_33, 233). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_34, 234). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_35, 235). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_36, 236). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_37, 237). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
 
-define(LOOKS_VAL_SET_41, 241). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_42, 242). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_43, 243). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_44, 244). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_45, 245). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_46, 246). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_47, 247). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
 
-define(LOOKS_VAL_SET_51, 251). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_52, 252). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_53, 253). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_54, 254). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_55, 255). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_56, 256). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
-define(LOOKS_VAL_SET_57, 257). %% 套装效果,二位数字,第一位代表职业,第二位代表本职业第几套特效 
 
-define(LOOKS_VAL_PET_NORMAL, 100). %% 普通宠物 
-define(LOOKS_VAL_PET_BEST,   101). %% 化形宠物 
-define(LOOKS_VAL_PET_SUPER,  102). %% 极品宠物 
 
-define(LOOKS_VAL_ACT_ESCORT_WHITE,  110). %% 白色镖车  
-define(LOOKS_VAL_ACT_ESCORT_GREEN,  111). %% 绿色镖车  
-define(LOOKS_VAL_ACT_ESCORT_BLUE,   112). %% 蓝色镖车  
-define(LOOKS_VAL_ACT_ESCORT_PURPLE, 113). %% 紫色镖车  
-define(LOOKS_VAL_ACT_ESCORT_ORANGE, 114). %% 橙色镖车  
 
-define(LOOKS_VAL_ACT_ARENA_DRAGON,  115). %% 竞技场青龙  
-define(LOOKS_VAL_ACT_ARENA_TIGER,   116). %% 竞技场白虎  
 
-define(LOOKS_VAL_ACT_GUILDWAR_ATK,  117). %% 帮战进攻联盟   
-define(LOOKS_VAL_ACT_GUILDWAR_DFD,  118). %% 帮战防守联盟   

-define(LOOKS_VAL_ACT_ESCORTCHILD_WHITE,  120). %% 白色小孩镖车  
-define(LOOKS_VAL_ACT_ESCORTCHILD_GREEN,  121). %% 绿色小孩镖车  
-define(LOOKS_VAL_ACT_ESCORTCHILD_BLUE,   122). %% 蓝色小孩镖车  
-define(LOOKS_VAL_ACT_ESCORTCHILD_PURPLE, 123). %% 紫色小孩镖车  
-define(LOOKS_VAL_ACT_ESCORTCHILD_ORANGE, 124). %% 橙色小孩镖车
 
-define(LOOKS_VAL_MODEL_ARENA,       200). %% 竞技场蒙面装 
-define(LOOKS_VAL_ARENA_SUPERMAN,    201). %% 竞技场猛人标志  
 
-define(LOOKS_VAL_ALPHA_ARENA,       250). %% 人物透明 别人看是透明，自己看是半透明 
 
%% 温泉中 
-define(LOOKS_SPRING_PADDLE_ACTIVE, 1).   %% 戏水 主动模式 
-define(LOOKS_SPRING_PADDLE_PASSIVE, 2).  %% 戏水 被动模式 
-define(LOOKS_SPRING_MASSAGE_ACTIVE, 3).  %% 按摩 主动模式 
-define(LOOKS_SPRING_MASSAGE_PASSIVE, 4). %% 按摩 被动模式 
-define(LOOKS_SPRING_RUB_ACTIVE, 5).      %% 搓背 主动模式 
-define(LOOKS_SPRING_RUB_PASSIVE, 6).     %% 搓背 被动模式 
-define(LOOKS_SPRING_INTERACTIVE_UNABLE, 7).    %% 不可进行互动 

%% 阳光浴
-define(LOOKS_SUN_BATH_PASSIVE, 0).          %% 阳光浴 被动者
-define(LOOKS_SUN_BATH_ACTIVE, 1).          %% 阳光浴 主动者

%% 温泉双修
-define(LOOKS_SPRING_SIT_NORMAL, 0).        %% 普通双修
-define(LOOKS_SPRING_SIT_COUPLE, 1).        %% 夫妻双修
 
%% 帮战外观 
-define(LOOKS_GUILD_WAR_CHIEF, 1).  %% 帮主  
-define(LOOKS_GUILD_WAR_MEMBER, 2). %% 帮众 

%% 至尊王者
-define(LOOKS_VAL_KING_DS, 1).  %% 求道者
-define(LOOKS_VAL_KING_GFS, 2). %% 指导者

%% 新帮战外观
-define(LOOKS_GUILD_ARENA_CHIEF, 3).  %% 帮主  
-define(LOOKS_GUILD_ARENA_MEMBER, 4). %% 帮众 

%% 跨服帮战外观
-define(LOOKS_GUILD_ARENA_CROSS_WINNER, 5). %% 天下第一帮所有成员
-define(LOOKS_GUILD_ARENA_CROSS_WINNER_CHIEF, 6). %% 天下第一帮帮主
-define(LOOKS_GUILD_ARENA_CROSS_JOIN, 7). %% 参加跨服帮战都有此称号
 
%% 飞行符 
-define(LOOKS_VAL_FLY_SIGN, 1). %% 飞行符特效 
 
%% 婚礼外观值 
-define(LOOKS_VAL_WEDDING_COM, 1). %% 普通 
-define(LOOKS_VAL_WEDDING_LUX, 2). %% 豪华套餐1 
-define(LOOKS_VAL_WEDDING_FIRE, 15). %% 婚礼烟花特效外观 
-define(LOOKS_VAL_WEDDING_MALE_TITLE, 1). %% 新郎临时称号
-define(LOOKS_VAL_WEDDING_FEMALE_TITLE, 2). %% 新娘临时称号
-define(LOOKS_VAL_WEDDING_GUEST_TITLE, 3). %% 贵宾临时称号

%% 房间里的房主与成员
-define(LOOKS_VAL_ROOM_LEADER, 1).  %% 房主
-define(LOOKS_VAL_ROOM_MEMBER, 2).  %% 成员

%% 精灵守护模型值
-define(LOOKS_VAL_DEMON_METAL,  10). %% 金守护
-define(LOOKS_VAL_DEMON_WOOD,   20). %% 木守护
-define(LOOKS_VAL_DEMON_WATER,  30). %% 水守护
-define(LOOKS_VAL_DEMON_FIRE,   40). %% 火守护
-define(LOOKS_VAL_DEMON_EARTH,  50). %% 土守护

%% 双人骑乘形象
-define(LOOKS_VAL_RIDEBOTH_1, 1). %% 骑乘拥有者
-define(LOOKS_VAL_RIDEBOTH_2, 2). %% 跟随者

%% 职业进阶方向
-define(LOOKS_VAL_CAREER_1, 1).
-define(LOOKS_VAL_CAREER_2, 2).
