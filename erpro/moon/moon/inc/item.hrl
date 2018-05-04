%%----------------------------------------------------
%% 物品数据结构 testgit
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------

%% 绑定，非绑定
-define(item_bind, 1). %% 绑定
-define(item_unbind, 0). %% 非绑定

   

%% 所有物品的TYPE类型分类，决定物品的功能
-define(item_equip,         10). %% 装备
-define(item_material,      11). %% 铸造材料
-define(item_protect,       12). %% 护符
-define(item_skill,         13). %% 技能
-define(item_drug,          20). %% 药品
-define(item_buff,          21). %% buff
-define(item_gain,          22). %% 增益
-define(item_channel,       23). %% 元神
-define(item_mount,         31). %% 坐骑
-define(item_guild,         41). %% 军团
-define(item_task,          50). %% 任务
-define(item_campaign,      52). %% 活动
-define(item_gift,          53). %% 礼包
-define(item_system,        60). %% 系统道具
-define(item_common,        61). %% 普通道具
-define(item_pet,           62). %% 宠物
-define(item_vip,           63). %% VIP

%% 装备子类 （装备位置
-define(item_weapon,        10).     %% 武器
-define(item_hu_wan,        11).     %% 护腕
-define(item_yi_fu,         12).     %% 衣服
-define(item_ku_zi,         13).     %% 裤子
-define(item_xie_zi,        14).     %% 鞋子
-define(item_yao_dai,       15).     %% 腰带
-define(item_hu_shou,       16).     %% 护手
-define(item_hu_fu,         17).     %% 护符
-define(item_jie_zhi,       18).     %% 戒指
-define(item_xiang_lian,    19).     %% 项链


%% 时装ID  中间两位数
-define(dress_clothes,      60).     %% 服饰
-define(dress_weapon,       61).     %% 武饰
-define(dress_head,         62).     %% 头饰
-define(dress_wing,         63).     %% 翅膀


%%TODO 移除飞仙旧物品类型
-define(item_etc,           00). %% 其它类
-define(item_fei_jian,      01). %% 飞剑
-define(item_bi_shou,       02). %% 匕首
-define(item_fa_zhang,      03). %% 法杖
-define(item_shen_gong,     04). %% 神弓
-define(item_chang_qiang,   05). %% 长枪
%%-define(item_hu_shou,       06). %% 护手
%%-define(item_hu_wan,        07). %% 护腕
%%-define(item_yao_dai,       08). %% 腰带
%%-define(item_xie_zi,        09). %% 鞋子
%%-define(item_ku_zi,         80). %% 裤子
%%-define(item_yi_fu,         81). %% 衣服
%%-define(item_hu_fu,         82). %% 护符
%%-define(item_jie_zhi,       83). %% 戒指
-define(item_shi_zhuang,    14). %% 时装
-define(item_xian_jie,      15). %% 仙戒
%%-define(item_task,          16). %% 任务类物品
-define(item_zuo_qi,        17). %% 坐骑
%%-define(item_material,      18). %% 生产原料
%%-define(item_xiang_lian,    19). %% 项链
-define(item_wing,          38). %% 翅膀
%%-define(item_skill,         25). %% 技能类道具
%%-define(item_pet,           26). %% 仙宠类道具
%%-define(item_channel,       30). %% 元神类道具
%%-define(item_gift,          32). %% 礼盒 
-define(item_fly,           40). %% 飞行类道具
-define(item_wedding,       42). %% 婚庆道具
-define(item_weapon_dress,  44). %% 武器时装
-define(item_jewelry_dress, 45). %% 饰品时装
-define(item_zuoqi_dress,   47). %% 坐骑时装
-define(item_demon,         59). %% 精灵守护道具
-define(item_pet_rb,        64). %% 宠物真身卡
-define(item_footprint,     67). %% 足迹
-define(item_chat_frame,    68). %% 炫酷聊天框
-define(item_text_style,    69). %% 个性文字
-define(item_guild_vip,     71). %% 帮会VIP令

%% by bwang宠物装备
-define(item_pet_linjia,72). %% 鳞甲 
-define(item_pet_jingjia,73). %% 胫甲
-define(item_pet_shoujie,74). %% 兽戒
-define(item_pet_lizhua,75). %% 利爪
-define(item_pet_longshi,76). %% 龙石
-define(item_pet_huoyan,77). %% 火焰


%% by bwang宠物装备属性
%%-define(attr_pet_eqm_shengming,450). %% 生命 
%%-define(attr_pet_eqm_fangyu,451). %% 防御
%%-define(attr_pet_eqm_gongji,452). %% 攻击
%%-define(attr_pet_eqm_baonu,453). %% 暴怒
%%-define(attr_pet_eqm_gedang,454). %% 格挡
%%-define(attr_pet_eqm_baoji,455). %% 暴击
%%-define(attr_pet_eqm_jingzhun,455). %% 精准




%% 物品是否可消耗，决定物品是否可以直接使用
-define(use_direct, 1). %% 可直接消耗(客户端双击使用)
-define(cant_use_direct, 0). %% 不可直接消耗
%% 属于基础装备类的物品类型
-define(eqm_base_type, [
        ?item_chang_qiang, ?item_fei_jian, ?item_bi_shou, ?item_fa_zhang, ?item_shen_gong,
        ?item_hu_shou, ?item_hu_wan, ?item_yao_dai, ?item_xie_zi, ?item_ku_zi, ?item_yi_fu,
        ?item_hu_fu, ?item_jie_zhi, ?item_xiang_lian
    ]).
%% 属于装备类的物品类型
-define(eqm_type, [
        ?item_equip,
        ?item_chang_qiang, ?item_fei_jian, ?item_bi_shou, ?item_fa_zhang, ?item_shen_gong,
        ?item_hu_shou, ?item_hu_wan, ?item_yao_dai, ?item_xie_zi, ?item_ku_zi, ?item_yi_fu,
        ?item_hu_fu, ?item_jie_zhi,
        ?item_shi_zhuang, ?item_zuo_qi, ?item_wing,
        ?item_xiang_lian,
        ?item_pet_linjia,?item_pet_jingjia,?item_pet_shoujie,?item_pet_lizhua,?item_pet_longshi,
        ?item_pet_huoyan
    ]).

%% 属于武器的物品类型
-define(eqm, [?item_weapon]).

%% 防具基础类型
-define(armor, [?item_hu_shou, ?item_hu_wan, ?item_yao_dai, ?item_xie_zi, ?item_yi_fu, ?item_ku_zi]).

%% 首饰类型
-define(jewelry, [?item_hu_fu, ?item_xiang_lian, ?item_jie_zhi]).

%% 可强化物品类型
-define(enchant_type, [?item_weapon, ?item_hu_wan, ?item_yi_fu, ?item_ku_zi, ?item_xie_zi, ?item_yao_dai, 
        ?item_hu_shou, ?item_hu_fu, ?item_jie_zhi, ?item_xiang_lian ]).

%% 可刻字物品类型
-define(eqm_sign_type, [
        ?item_chang_qiang, ?item_fei_jian, ?item_bi_shou, ?item_fa_zhang, ?item_shen_gong,
        ?item_hu_shou, ?item_hu_wan, ?item_yao_dai, ?item_xie_zi, ?item_ku_zi, ?item_yi_fu,
        ?item_jie_zhi, ?item_hu_fu, ?item_xiang_lian
    ]).


%% 属于飞行坐骑,物品ID列表
-define(mountain_fly, [19050, 19003, 19004, 19005]).

%% 自动加血加蓝的物品BaseID列表
-define(auto_hp_items, [24000, 24001, 24002, 24003]).
-define(auto_mp_items, [24020, 24021, 24022, 24023]).

%% 锁定状态
-define(lock_release,     0).
-define(lock_exchange,    1).

%% 物品品质
-define(quality_white,  0).
-define(quality_green,  1).
-define(quality_blue,   2).
-define(quality_purple, 3).
-define(quality_pink, 4).
-define(quality_orange, 5).
-define(quality_golden, 6).

%% 套装锁定
-define(suit_lock,    1).
-define(suit_release, 0).

%% 品阶
-define(craft_0, 0). %% 无 
-define(craft_1, 1). %% 精良
-define(craft_2, 2). %% 优秀
-define(craft_3, 3). %% 完美
-define(craft_4, 4). %% 传说
-define(craft_5, 5). %% 传说

%% 物品穿戴效果属性定义
%% #item.attr = [{Label, Flag, Value}, ...]
%% {属性标签, 特殊标识, 值}
%% Flag = 0         标识值为未鉴定属性,不计入属性计算
%% Flag = [1-5]     标识为神佑洗练属性品质(1:白色2:绿色3:蓝色4:紫色5:橙色)
%% Flag = 100       标识值为基本属性
%% Flag = 101       标识值为宝石的物品ID
%% Flag = 102       标识为宠物基本属性
%% Flag = 300       标识为地图坐标
%% Flag = 901~905   装备技能(现在翅膀技能使用)
%% Flag >= 1001 ~ 10010  装备洗炼属性 第一位表示星，末两位表示阶

%% Label 定义(0表示异常值)
%% **********************************************************
%% 孔-宝石
-define(attr_hole1, 5).
-define(attr_hole2, 6).
-define(attr_hole3, 7).
-define(attr_hole4, 8).
-define(attr_hole5, 9).
%% 一二级属性
-define(attr_xl, 11). %% 力量
-define(attr_tz, 12). %% 体质
-define(attr_lq, 13). %% 灵巧
-define(attr_js, 14). %% 慧根
-define(attr_hp_max, 15). %% 血量上限
-define(attr_mp_max, 16). %% 法力上限
-define(attr_aspd, 17).   %% 敏捷
-define(attr_dmg, 18). %% 攻击
-define(attr_dmg_min, 19).%% 攻击下限
-define(attr_dmg_max, 20).%% 攻击上限
-define(attr_defence, 21).%% 防御
-define(attr_hitrate, 22).%% 命中值
-define(attr_evasion, 23).%% 格档
-define(attr_critrate, 24).%% 暴击值
-define(attr_tenacity, 25).%% 坚韧
%% 特殊属性
-define(attr_skill_lev, 26). %% 增加技能等级
-define(attr_dmg_magic, 29). %% 绝对伤害
-define(attr_rst_all, 30).%% 全抗性: 五行属性战斗时有用
-define(attr_rst_metal, 31).%% 金抗性
-define(attr_rst_wood, 32).
-define(attr_rst_water, 33).
-define(attr_rst_fire, 34).
-define(attr_rst_earth, 35).
%%-define(attr_dmg_all, 40).%% 全攻属性
-define(attr_dmg_metal, 41). %% 金攻
-define(attr_dmg_wood, 42).
-define(attr_dmg_water, 43).
-define(attr_dmg_fire, 44).
-define(attr_dmg_earth, 45).
-define(attr_asb_all, 50). %% 五行吸收
-define(attr_asb_metal, 51). %% 金伤害吸收
-define(attr_asb_wood, 52).
-define(attr_asb_water, 53).
-define(attr_asb_fire, 54).
-define(attr_asb_earth, 55).
-define(attr_anti_stun, 60). %% 抗晕
-define(attr_anti_sleep, 61). %% 抗睡
-define(attr_anti_taunt, 62). %% 抗嘲讽
-define(attr_anti_silent, 63). %% 抗沉默
-define(attr_anti_stone, 64). %% 抗石化
-define(attr_anti_poison, 65). %% 抗毒
-define(attr_anti_seal, 66). %% 抗封印
%% 移动速度
-define(attr_speed, 70).
-define(attr_enhance_stun, 71).   %% 眩晕加强
-define(attr_enhance_sleep, 72).  %% 嘲讽加强 
-define(attr_enhance_taunt, 73).  %% 沉默/遗忘加强 
-define(attr_enhance_silent, 74). %% 睡眠加强
-define(attr_enhance_stone, 75).  %% 石化加强 
-define(attr_enhance_poison, 76). %% 中毒加强 
-define(attr_enhance_seal, 77).   %% 封印加强
%% 一二级属性百分比加成
-define(attr_xl_per, 111). %% 力量
-define(attr_tz_per, 112). %% 体质
-define(attr_lq_per, 113). %% 灵巧
-define(attr_js_per, 114). %% 慧根
-define(attr_hp_max_per, 115). %% 血量上限
-define(attr_mp_max_per, 116). %% 法力上限
-define(attr_dmg_per, 118). %% 攻击加成
-define(attr_defence_per, 121).%% 防御
-define(attr_hitrate_per, 122).%% 命中值
-define(attr_evasion_per, 123).%% 躲闪值
-define(attr_critrate_per, 124).%% 暴击值
-define(attr_rst_all_per, 130).%% 全抗性:五行属性战斗时有用
-define(attr_rst_metal_per, 131).   %% 金抗性
-define(attr_rst_wood_per, 132).
-define(attr_rst_water_per, 133).
-define(attr_rst_fire_per, 134).
-define(attr_rst_earth_per, 135).
-define(attr_dmg_magic_per, 136).   %% 绝对伤害加成
-define(attr_tenacity_per, 137).    %% 坚韧加成


%% 移动速度 百分比加成
-define(attr_speed_per, 170).
%% 装备技能 Flag = 901/902/903/904/905 未两位表示技能格子位置
-define(attr_skill, 171).

%% 宠物属性
-define(attr_pet_xl, 200). %% 力量
-define(attr_pet_tz, 201). %% 体质
-define(attr_pet_js, 202). %% 精神
-define(attr_pet_lq, 203). %% 灵巧
-define(attr_pet_baseid, 204). %% 基础ID
-define(attr_pet_lev, 205). %% 等级
-define(attr_pet_grow_val, 206). %% 成长值
-define(attr_pet_xl_val, 208). %% 攻潜力
-define(attr_pet_tz_val, 209). %% 体潜力
-define(attr_pet_js_val, 210). %% 防潜力
-define(attr_pet_lq_val, 211). %% 巧潜力
-define(attr_pet_xl_per, 212). %% 力量系统分配比例
-define(attr_pet_tz_per, 213). %% 体质系统分配比例
-define(attr_pet_js_per, 214). %% 精神系统分配比例
-define(attr_pet_lq_per, 215). %% 灵巧系统分配比例
-define(attr_pet_skill_num, 216). %% 宠物可拥有技能数目
-define(attr_pet_skill, 217). %% 宠物技能ID



%% 宠物魔晶系统
-define(attr_pet_eqm_lev, 220).  %% 宠物装备等级
-define(attr_pet_eqm_exp, 221).  %% 宠物装备经验

-define(attr_pet_hp, 230).              %% 宠物气血
-define(attr_pet_mp, 231).              %% 宠物法力
-define(attr_pet_dmg, 232).             %% 宠物功击
-define(attr_pet_critrate, 233).        %% 宠物暴击
-define(attr_pet_defence, 234).         %% 宠物防御
-define(attr_pet_tenacity, 235).        %% 宠物坚韧
-define(attr_pet_hitrate, 236).         %% 宠物命中
-define(attr_pet_evasion, 237).         %% 宠物闪躲
-define(attr_pet_dmg_magic, 238).       %% 宠物法伤
-define(attr_pet_anti_js, 239).         %% 宠物精神
-define(attr_pet_anti_attack, 240).     %% 宠物反击
-define(attr_pet_anti_seal, 241).       %% 宠物抗封印
-define(attr_pet_anti_stone, 242).      %% 宠物抗石化
-define(attr_pet_anti_stun, 243).       %% 宠物抗眩晕
-define(attr_pet_anti_sleep, 244).      %% 宠物抗睡眠
-define(attr_pet_anti_taunt, 245).      %% 宠物抗嘲讽
-define(attr_pet_anti_silent, 246).     %% 宠物抗遗忘
-define(attr_pet_anti_poison, 247).     %% 宠物抗中毒
-define(attr_pet_blood, 248).           %% 宠物吸血
-define(attr_pet_rebound, 249).         %% 宠物反弹
-define(attr_pet_skill_kill, 250).      %% 宠物冲杀
-define(attr_pet_skill_protect, 251).   %% 宠物护卫
-define(attr_pet_skill_anima, 252).     %% 宠物灵气
-define(attr_pet_resist_metal, 253).    %% 宠物金抗性
-define(attr_pet_resist_wood, 254).     %% 宠物木抗性
-define(attr_pet_resist_water, 255).    %% 宠物水抗性
-define(attr_pet_resist_fire, 256).     %% 宠物火抗性
-define(attr_pet_resist_earth, 257).    %% 宠物土抗性
-define(attr_pet_skill_id, 258).        %% 宠物技能

%% 藏宝图中的地图坐标
-define(attr_treasure_map, 300).    %% 地图id
-define(attr_treasure_x, 301).      %% x坐标
-define(attr_treasure_y, 302).      %% y坐标

%% 神佑属性类型
%% Flag = [1-5]  神佑洗练属性品质(1:白色2:绿色3:蓝色4:紫色5:橙色)
-define(attr_gs_hp,         310).%% 神佑气血属性
-define(attr_gs_mp,         311).%% 神佑法力属性
-define(attr_gs_dmg,		312).%% 神佑攻击属性
-define(attr_gs_dmg_magic,	313).%% 神佑法伤属性
-define(attr_gs_defence,	314).%% 神佑防御属性
-define(attr_gs_js,         315).%% 神佑精神属性
-define(attr_gs_aspd,       316).%% 神佑敏捷属性
-define(attr_gs_hitrate,	317).%% 神佑命中属性
-define(attr_gs_evasion,	318).%% 神佑躲闪属性
-define(attr_gs_critrate,	319).%% 神佑暴击属性
-define(attr_gs_tenacity,	320).%% 神佑坚韧属性
-define(attr_gs_rst_metal,	321).%% 神佑金抗性
-define(attr_gs_rst_wood,	322).%% 神佑木抗性
-define(attr_gs_rst_water,	323).%% 神佑水抗性
-define(attr_gs_rst_fire,	324).%% 神佑火抗性
-define(attr_gs_rst_earth,	325).%% 神佑土抗性
-define(attr_gs_anti_stun,	326).%% 神佑抗晕
-define(attr_gs_anti_sleep,	327).%% 神佑抗睡
-define(attr_gs_anti_taunt,	328).%% 神佑抗嘲讽
-define(attr_gs_anti_silent,329).%% 神佑抗沉默
-define(attr_gs_anti_stone,	330).%% 神佑抗石化

-define(attr_looks_id, 400).    %% 物品外观

%% *********************
%% special字段的Type和Val格式：
%% Type             Val
%% 1:坐骑进阶祝福值    {BlessVal, FailCount}
-define(special_mount, 1).
-define(special_eqm_wish, 2).
-define(special_expire_time, 3).
-define(special_polish_luck, 4).
-define(special_eqm_point, 5). %% {label, val}
-define(special_eqm_advance, 6). %% {label, val} %%宠物装备用，表示为更高属性的装备
-define(special_guagua_item, 7).    %%象{?special_guagua_item, ItemBaseId}  瓜瓜卡
%% 1000 + 属性索引 ， 代表强化全身加成 例如: 1015 代表血

%% *********************

%% *********************
%% extra字段的Type格式：
-define(extra_married_1, 1). %% 婚戒所属角色名
-define(extra_married_2, 2). %% 婚戒对方角色名
-define(extra_mount_lev, 3). %% 坐骑等级
-define(extra_mount_exp, 4). %% 坐骑经验
%-define(extra_mount_feed, 5). %% 坐骑饱食度(不再使用)
-define(extra_mount_growth_dmg, 6). %% 坐骑攻击成长值
-define(extra_mount_growth_def, 7). %% 坐骑防御成长值
-define(extra_mount_growth_cri, 8). %% 坐骑暴击成长值
-define(extra_mount_growth_ten, 9). %% 坐骑坚韧成长值
-define(extra_mount_growth_hp, 10). %% 坐骑生命成长值
-define(extra_mount_growth_js, 11). %% 坐骑精神成长值
-define(extra_mount_growth_dmg_per, 12). %% 坐骑攻击成长值百分比
-define(extra_mount_growth_def_per, 13). %% 坐骑防御成长值百分比
-define(extra_mount_growth_cri_per, 14). %% 坐骑暴击成长值百分比
-define(extra_mount_growth_ten_per, 15). %% 坐骑坚韧成长值百分比
-define(extra_mount_growth_hp_per, 16). %% 坐骑生命成长值百分比
-define(extra_mount_growth_js_per, 17). %% 坐骑精神成长值百分比
-define(extra_mount_grade_cur, 18). %% 坐骑进阶幸运值
-define(extra_mount_grade, 19). %% 坐骑阶数
-define(extra_mount_quality, 20). %% 坐骑洗髓品质
-define(extra_mount_addition, 21). %% 坐骑灵犀值
-define(extra_mount_can_upgrade, 22). %% 是否可以进阶0=否,1=是
-define(extra_eqm_gs_lev, 30).  %% 装备神佑等级
-define(extra_eqm_fumo, 31). %% 装备附魔(基本装备)
-define(extra_eqm_signature, 91). %% 装备签名


%% 婚戒恒久值
-define(extra_married_42, 42). 
%% 婚戒恒久值附件buff属性
-define(extra_married_hp, 43). 
-define(extra_married_mp, 44). 
-define(extra_married_dmg, 45). 
-define(extra_married_defence, 46). 
-define(extra_married_tenacity, 47). 
-define(extra_married_resist_all, 48). 


%% 装备类物品孔的初始化
-define(default_hole, [{?attr_hole1, 101, 0}, {?attr_hole2, 0, 0},{?attr_hole3, 0, 0},{?attr_hole4, 0, 0},{?attr_hole5, 0, 0}]).

%%
-define(extra_dress_color, 90).  %% 0:原配色 1-3:配色方案 
%% *********************

%%------------------------------------
%% 翅膀数据
%%------------------------------------
-define(extra_wing_luck, 80).     %% 翅膀阶数祝福值
-define(extra_wing_lingxi, 81).   %% 翅膀灵犀值

%% 基础物品数据结构
-record(item_base, {
        id                      %% 物品基础ID
        ,name = <<>>            %% 物品名称
        %% 物品标签(0:普通物品, 1:装备 2:药品 3:礼包 4:宝石 5:符文 6:坐骑 7:图纸或配方 8:仙宠 9:仙宠用品 10:传送类道具)
        ,type = 0               %% 物品类型，具体定义见上面的宏
        ,quality = 0            %% 品质(0:白色 1:绿色 2:蓝色 3:紫色 4:橙色)
        ,overlap = 1            %% 最大堆叠数量
        ,set_id = 0             %% 套装ID(0:非套装,1~int:套装)
        ,durability_max = -1    %% 最大耐久度，-1表示永不磨损
        ,upgrade_max = 0        %% 最大修炼等级,0表示不可修炼,
        ,use_type = 0           %% 物品的使用方式(0:不能直接使用 1:消耗, 2:不消耗，可重复使用 3:穿戴)
        ,expire = 0             %% 物品失效时间，永久有效的物品设置为0
        ,cooldown = 0           %% 使用后的冷却时间，0表示无CD，可连续使用
        ,condition = []         %% 使用条件或穿戴条件，满足全部条件后才能使用或穿戴
        ,value = []             %% 物品的价值
                                %% {buy_npc, 100} 跟NPC购买
                                %% {sell_npc, 100} 出售给NPC
                                %% {buy_market, 100}  商场购买
                                %% {buy_coupon, 100} 礼券购买
                                %% 
        ,effect = []            %% 使用效果
                                %% {hp, 100} 回复血量100
                                %% {mp, 100} 回复法力100
                                %% {buff, BuffLabel} Buff效果
                                %% {goto_town, MapId} 回城
                                %% {transfer, {MapId, X, Y}} 传送
                                %% {goto_guild, MapId} 回帮
                                %% {treasure, {MapId, X, Y}} 挖宝
        ,attr = []              %% 穿戴效果-详见上面定义
                                %% {属性标签, 特殊标识, 值}
                                %% {hp_max_per, Flag, 10}
                                %% {dmg_min, 11, 10} 加10点最小攻击
                                %% {hole1, 0, 0} 可打孔镶嵌-1号
        ,desc = <<>>            %% 物品描述
        ,feed_exp               %% 喂养经验
    }
).

%% 角色物品数据结构
-record(item, {
        ver = 0                 %% 物品版本号
        ,id = 0                 %% 物品ID
        ,base_id = 0            %% 对应的基础物品数据
        ,type = 0               %% 物品类型(冗余，方便使用)
        ,use_type = 0           %% 物品使用方式
        ,bind = 0               %% 是否梆定(0:未梆定, 1:已梆定)
        ,source = 0             %% 物品来源
        ,quality = 0            %% 物品品质
        ,upgrade = 0            %% 修炼等级，0表示不可修炼
        ,enchant = -1           %% 强化等级，-1表示不可强化
        ,enchant_fail = 0       %% 强化失败次数 
        ,quantity = 1           %% 数量
        ,wash_cnt = 0           %% 洗炼次数
        ,status = 0             %% 物品锁定状态标志
        ,pos = 0                %% 在包裹中的位置
        ,lasttime = 0           %% 市场交易时间 
        ,durability = -1        %% 当前耐久度(-1表示永不磨损)
        ,attr = []              %% 属性
        ,require_lev = 0        %% 需要人物等级
        ,career = 9             %% 职业 9为不限制 
        ,special = []           %% 特殊信息：[{Type, Val}, ...]
        ,max_base_attr = []     %% 最高修炼属性 [{AttrName, Flag, Value}]
        ,polish_list = []       %% 批量洗练属性保存[{Id, Bind, [{AttrName, Flag, Value},...]}, ...]
                                %% 普通批洗ID：[1-8]，神佑批洗ID：[10-18]
        ,polish = []            %% 单次洗炼属性保存 结构类似批洗[{AttrName, Flag, Val}]
        ,craft = 0              %% 品阶 0:无 1:精良2:优秀3:完美4:传说
        ,extra = []             %% 额外数据：[{Type, Val, <<>>}, ...]
        ,xisui_list = []        %% 坐骑批量洗髓成长值保存[{Id, Quality, [{Key, Growth},...], [{Key, Growth_per},...]}, ...]
    }
).
