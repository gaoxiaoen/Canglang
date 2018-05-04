%%----------------------------------------------------
%% 排行榜相关数据结构定义
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------

-define(RANK_NOLOGIN_TIME, 604800).     %%  7 * 24 * 3600 秒 没有登陆的时间
-define(rank_row_count, 9).            %%每页显示的数据
-define(rank_reward_dungeon, 0).        %% 副本评分比例
-define(rank_reward_open_srv_3, 3).     %% 开服3天奖励
-define(rank_reward_open_srv_5, 5).     %% 开服5天奖励
-define(rank_reward_merge_srv, 7).      %% 合服7天奖励
-define(in_rank_num, 300).              %% 上榜数量

%% 装备系数
-define(purple_fac, 2).             %% 紫装系数
-define(orange_fac, 3).             %% 橙装系数
-define(arms_fac, 10.8).            %% 武器系数
-define(armor_fac_jacket, 6).       %% 法袍系数
-define(armor_fac_belt, 5.1).       %% 腰带系数
-define(armor_fac_cuff, 4.2).       %% 法腕系数
-define(armor_fac_nipper, 4.5).     %% 护手系数
-define(armor_fac_pants, 5.4).      %% 法裤系数
-define(armor_fac_shoes, 4.8).      %% 法靴系数

%% 装备位置
-define(arms_pos, 0).               %% 武器位置
-define(armor_pos_jacket, 2).       %% 法袍位置
-define(armor_pos_belt, 5).         %% 腰带位置
-define(armor_pos_cuff, 1).         %% 法腕位置
-define(armor_pos_nipper, 6).       %% 护手位置
-define(armor_pos_pants, 3).        %% 法裤位置
-define(armor_pos_shoes, 4).        %% 法靴位置
-define(decoration_pos_amulet_1, 8).%% 护符_1
-define(decoration_pos_amulet_2, 9).%% 护符_2
-define(decoration_pos_ring_1, 11). %% 戒指_1
-define(decoration_pos_ring_2, 12). %% 戒指_2

%% 排行榜类型
-define(rank_role_lev, 0).          %% 个人等级排行榜
-define(rank_role_coin, 2).          
-define(rank_super_boss, 1).         %% 伐龙排行
-define(rank_role_pet, 4).          %% 仙宠
-define(rank_role_achieve, 5).      %% 成就
-define(rank_role_power, 6).        %% 战斗力
-define(rank_role_soul, 7).         %% 元神
-define(rank_role_skill, 8).        %% 技能
-define(rank_role_pet_power, 9).    %% 宠物战斗力
-define(rank_cross_role_pet_power, 10).%% 跨服宠物战斗力排行榜
-define(rank_arms, 11).             %% 武器
-define(rank_armor, 12).            %% 防具
-define(rank_mount_power, 13).      %% 坐骑战斗力
-define(rank_cross_mount_power, 14).%% 跨服坐骑战斗力
-define(rank_practice, 15).         %% 试练排行榜
-define(rank_pet_grow, 16).         %% 宠物成长排行榜
-define(rank_pet_potential, 17).    %% 宠物潜力排行榜
-define(rank_mount_lev, 18).        %% 坐骑等级排行榜
-define(rank_guild_lev, 20).        %% 帮会等级
-define(rank_guild_power, 27).        %% 帮会战斗力
-define(rank_guild_combat, 21).     %% 仙岛斗法
-define(rank_guild_last, 22).       %% 上场仙岛斗法
-define(rank_guild_exploits, 23).   %% 上场个人战功
-define(rank_soul_world, 24).       %% 灵戒
-define(rank_soul_world_array, 25). %% 魔阵
-define(rank_soul_world_spirit, 26).%% 妖灵
-define(rank_vie_acc, 30).          %% 竞技累积
-define(rank_vie_last, 31).         %% 上场竞技
-define(rank_vie_cross, 32).        %% 跨服战绩
-define(rank_vie_kill, 33).         %% 竞技斩杀人数
-define(rank_vie_last_kill, 34).    %% 上场竞技斩杀人数
-define(rank_wit_acc, 40).          %% 答题累积
-define(rank_wit_last, 41).         %% 上场答题
-define(rank_flower_acc, 50).       %% 送花累积
-define(rank_flower_day, 51).       %% 今日送花累积
-define(rank_cross_flower, 52).     %% 跨服送花积分榜 
-define(rank_glamor_acc, 60).       %% 魅力累积
-define(rank_glamor_day, 61).       %% 今日魅力累积
-define(rank_cross_glamor, 62).     %% 跨服魅力积分榜 
-define(rank_popu_acc, 70).         %% 人气累积
-define(rank_darren_coin, 72).      %% 金币达人榜
-define(rank_darren_casino, 73).    %% 寻宝达人榜
-define(rank_darren_exp, 74).       %% 练级达人榜
-define(rank_darren_attainment, 75).%% 阅历达人榜
-define(rank_celebrity, 90).        %% 全服名人榜
-define(rank_married, 95).          %% 仙侣榜
-define(rank_total_power, 98).         %% 综合战斗力（个人战斗力+宠物战斗力）
-define(rank_cross_total_power, 99).   %% 跨服排行榜：综合战斗力（个人战斗力+宠物战斗力）
-define(rank_cross_world_compete_winrate, 100).        %% 跨服仙道会：胜率（全服）
-define(rank_world_compete_winrate, 101).         %% 跨服仙道会：胜率（本服）
-define(rank_cross_world_compete_lilian, 102).         %% 跨服仙道会：历练（全服）
-define(rank_world_compete_lilian, 103).          %% 跨服仙道会：历练（本服）
-define(rank_platform_world_compete_winrate, 104).       %% 跨服仙道会：胜率（本平台）
-define(rank_platform_world_compete_lilian, 105).        %% 跨服仙道会：历练（本平台）
-define(rank_world_compete_win, 106).     %% 仙道会战胜场数
-define(rank_platform_world_compete_win_today, 107).    %% 跨服仙道会：每日最佳战绩（本平台）
-define(rank_platform_world_compete_win_yesterday, 108).    %% 跨服仙道会：昨日最佳战绩（本平台）
-define(rank_world_compete_section, 109).          %% 跨服仙道会：段位（本服）
-define(rank_platform_world_compete_section, 110).        %% 跨服仙道会：段位（本平台）

%%---------------------------------------------
%% 跨服排行榜类型(17400 ~ 17499)
%%---------------------------------------------
-define(rank_cross_pet_lev, 17400).             %% 宠物等级
-define(rank_cross_pet_power, 17401).           %% 宠物战力
-define(rank_cross_pet_grow, 17402).            %% 宠物成长
-define(rank_cross_pet_potential, 17403).       %% 宠物潜力
-define(rank_cross_role_power, 17404).          %% 角色战力
-define(rank_cross_role_lev, 17405).            %% 角色等级
-define(rank_cross_role_coin, 17406).           %% 角色金币
-define(rank_cross_role_skill, 17407).          %% 角色技能
-define(rank_cross_role_achieve, 17408).        %% 角色成就
-define(rank_cross_role_soul, 17409).           %% 角色元神
-define(rank_cross_mount_power1, 17411).        %% 坐骑战力排行榜
-define(rank_cross_mount_lev, 17412).           %% 坐骑等级排行榜
-define(rank_cross_arms, 17413).                %% 武器
-define(rank_cross_armor, 17414).               %% 防具
-define(rank_cross_guild_lev, 17415).           %% 帮会等级
-define(rank_cross_arena_kill, 17416).          %% 竞技场斩杀数
-define(rank_cross_world_compete_win, 17417).   %% 仙道会战胜场数
-define(rank_cross_soul_world, 17418).          %% 灵戒
-define(rank_cross_soul_world_array, 17419).    %% 魔阵
-define(rank_cross_soul_world_spirit, 17420).   %% 妖灵

%% 各排行榜上榜下限值
-define(rank_min_role_lev, 20).              %% 个人等级排行榜
-define(rank_min_role_coin, 0).              %% 个人财富
-define(rank_min_role_pet, 0).               %% 仙宠
-define(rank_min_role_pet_power, 0).         %% 宠物战斗力
-define(rank_min_role_achieve, 1).           %% 成就
-define(rank_min_role_power, 800).           %% 战斗力
-define(rank_min_role_soul, 1).              %% 元神
-define(rank_min_role_skill, 1).             %% 技能
-define(rank_min_arms, 50).                 %% 武器
-define(rank_min_armor, 50).                %% 防具
-define(rank_min_mount_power, 1).            %% 坐骑
-define(rank_min_practice, 1).               %% 试练
-define(rank_min_guild_lev, 1).              %% 帮会等级
-define(rank_min_guild_power, 1).            %% 帮会战斗力
-define(rank_min_guild_combat, 99999999).    %% 仙岛斗法
-define(rank_min_guild_last, 9999999999).    %% 上场仙岛斗法
-define(rank_min_guild_exploits, 999999999). %% 上场个人战功
-define(rank_min_vie_acc, 10).               %% 竞技累积
-define(rank_min_vie_last, 5).               %% 上场竞技
-define(rank_min_vie_kill, 1).               %% 竞技斩杀人数
-define(rank_min_flower_day, 99).            %% 今日送花积分
-define(rank_min_glamor_day, 99).            %% 今日魅力积分
-define(rank_min_vie_last_kill, 1).          %% 上场竞技斩杀人数
-define(rank_min_vie_cross, 99999999999).    %% 跨服战绩
-define(rank_min_wit_acc, 1).                %% 答题累积
-define(rank_min_wit_last, 1).               %% 上场答题
-define(rank_min_flower_acc, 1).             %% 送花累积
-define(rank_min_glamor_acc, 1).             %% 魅力累积
-define(rank_min_popu_acc, 99999999).        %% 人气累积
-define(rank_min_total_power, 1000).         %% 上榜总战力需求

%% 需要保存到库的排行榜
-define(rank_need_save, [
        ?rank_role_lev, ?rank_role_coin, ?rank_role_power
        ,?rank_role_soul, ?rank_role_skill, ?rank_role_achieve
        ,?rank_role_pet, ?rank_role_pet_power
        ,?rank_arms, ?rank_armor, ?rank_guild_lev, ?rank_guild_power
        ,?rank_vie_acc, ?rank_vie_kill
        ,?rank_flower_acc, ?rank_glamor_acc, ?rank_celebrity
        ,?rank_flower_day, ?rank_glamor_day
        ,?rank_wit_acc, ?rank_wit_last, ?rank_married
        ,?rank_total_power, ?rank_cross_total_power
        ,?rank_cross_role_pet_power, ?rank_mount_power, ?rank_cross_mount_power
        ,?rank_cross_world_compete_winrate, ?rank_world_compete_winrate, ?rank_cross_world_compete_lilian, ?rank_world_compete_lilian
        ,?rank_platform_world_compete_section, ?rank_world_compete_section
        ,?rank_practice, ?rank_world_compete_win
        ,?rank_darren_coin, ?rank_darren_casino, ?rank_darren_exp, ?rank_darren_attainment
        ,?rank_pet_grow, ?rank_pet_potential, ?rank_mount_lev
        ,?rank_cross_pet_lev, ?rank_cross_pet_potential, ?rank_cross_pet_grow, ?rank_cross_pet_power
        ,?rank_cross_role_power, ?rank_cross_role_lev, ?rank_cross_role_coin, ?rank_cross_role_skill
        ,?rank_cross_role_achieve, ?rank_cross_role_soul
        ,?rank_cross_mount_lev, ?rank_cross_mount_power1, ?rank_cross_arms, ?rank_cross_armor
        ,?rank_cross_guild_lev, ?rank_cross_arena_kill, ?rank_cross_world_compete_win
        ,?rank_cross_soul_world, ?rank_cross_soul_world_array, ?rank_cross_soul_world_spirit
    ]).

%% 允许加载数据失败的榜 加载失败 重新上榜 针对数据变化较快的榜
-define(rank_allow_load_fail, [
        ?rank_role_lev, ?rank_role_coin, ?rank_role_power
        ,?rank_arms, ?rank_armor, ?rank_guild_lev, ?rank_guild_power
        ,?rank_total_power, ?rank_cross_total_power
        ,?rank_cross_role_pet_power, ?rank_cross_mount_power
        ,?rank_practice
    ]
).

%% 排行榜数据
%% {LastList, RList, Val}
%% LastList = list() 上一次发放称号获得列表
%% RList = list() 当前排行榜数据
%% Val = integer() 当前排行榜上限下限值
-record(rank, {
        type = 0                   %% 主键查询 排行榜类型
        ,honor_roles = []          %% 称号角色列表
        ,roles = []                %% 排行角色列表
        ,last_val = 0              %% 上榜下限值
    }
).

%% 排行榜角色信息 特殊信息保存
-record(rank_role, {
        id = {0, 0}    %% 角色唯一标志
        ,info = []     %% 角色信息列表
    }
).

%% 排行榜角色信息 特殊信息保存
-record(rank_cross_role, {
        id = {0, 0}    %% 角色唯一标志
        ,worship = 0   %% 角色被膜拜次数
        ,disdain = 0   %% 角色被鄙视次数
        ,info = []     %% 角色信息列表
    }
).

%%---------------------------------------------------
%% 个人排行榜
%%---------------------------------------------------
%% 等级排行榜记录数据结构
-record(rank_role_lev, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        guild = <<>>,    %% 帮会名称     显示
        lev = 0,        %% 等级     F   显示
        exp = 0,        %% 经验     S
        vip = 0,        %% VIP等级  T   显示
        date = 0,       %% 上榜日期
        eqm = [],       %% 装备
        looks = []      %% 外观
    }
).

-record(rank_cross_role_lev, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        guild = <<>>,    %% 帮会名称     显示
        lev = 0,        %% 等级     F   显示
        exp = 0,        %% 经验     S
        vip = 0,        %% VIP等级  T   显示
        date = 0,       %% 上榜日期
        eqm = [],       %% 装备
        looks = []      %% 外观
    }
).

%% 财富排行榜记录数据结构
-record(rank_role_coin, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        guild = <<>>,       %% 帮会名称       显示
        coin = 0,       %% 金币数   F   显示
        gold = 0,       %% 晶钻数   S
        vip = 0,        %% VIP等级  T   显示
        date = 0,       %% 上榜日期
        lev = 0,        %% 角色等级
        eqm = [],       %% 装备
        looks = []      %% 外观
    }
).

-record(rank_cross_role_coin, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        guild = <<>>,       %% 帮会名称       显示
        coin = 0,       %% 金币数   F   显示
        gold = 0,       %% 晶钻数   S
        vip = 0,        %% VIP等级  T   显示
        date = 0,       %% 上榜日期
        lev = 0,        %% 角色等级
        eqm = [],       %% 装备
        looks = []      %% 外观
    }
).

%% 成就排行榜记录数据结构
-record(rank_role_achieve, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        guild = <<>>,       %% 帮会名称       显示
        achieve = 0,    %% 成就值   F   显示
        lev = 0,        %% 等级     S
        vip = 0,        %% VIP等级  T   显示
        date = 0,        %% 上榜日期
        eqm = [],       %% 装备
        looks = []      %% 外观
    }
).

-record(rank_cross_role_achieve, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        guild = <<>>,       %% 帮会名称       显示
        achieve = 0,    %% 成就值   F   显示
        lev = 0,        %% 等级     S
        vip = 0,        %% VIP等级  T   显示
        date = 0,        %% 上榜日期
        eqm = [],       %% 装备
        looks = []      %% 外观
    }
).

%% 个人战斗力排行榜记录数据结构
-record(rank_role_power, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0 ,         %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        ascend = 0,     %% 进阶方向
        sex = 0,        %% 性别
        guild = <<>>,       %% 帮会名称       显示
        power = 0,      %% 战斗力   F   显示
        lev = 0,        %% 等级     S
        vip = 0,        %% VIP等级  T   显示
        date = 0,       %% 上榜日期
        eqm = [],       %% 装备
        looks = []      %% 外观
    }
).

-record(rank_cross_role_power, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0 ,         %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        ascend = 0,     %% 进阶方向
        sex = 0,        %% 性别
        guild = <<>>,       %% 帮会名称       显示
        power = 0,      %% 战斗力   F   显示
        lev = 0,        %% 等级     S
        vip = 0,        %% VIP等级  T   显示
        date = 0,       %% 上榜日期
        eqm = [],       %% 装备
        looks = []      %% 外观
    }
).

%% 个人元神排行榜记录数据结构
-record(rank_role_soul, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0 ,         %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        guild = <<>>,       %% 帮会名称       显示
        soul = 0,       %% 元神值   F   显示
        lev = 0,        %% 等级     S
        vip = 0,        %% VIP等级  T   显示
        date = 0,        %% 上榜日期
        eqm = [],       %% 装备
        looks = []      %% 外观
    }
).

-record(rank_cross_role_soul, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0 ,         %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        guild = <<>>,       %% 帮会名称       显示
        soul = 0,       %% 元神值   F   显示
        lev = 0,        %% 等级     S
        vip = 0,        %% VIP等级  T   显示
        date = 0,        %% 上榜日期
        eqm = [],       %% 装备
        looks = []      %% 外观
    }
).

%% 个人技能排行榜记录数据结构
-record(rank_role_skill, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        guild = <<>>,       %% 帮会名称       显示
        skill = 0,      %% 技能度   F   显示
        lev = 0,        %% 等级     S
        vip = 0,        %% VIP等级  T   显示
        date = 0,        %% 上榜日期
        eqm = [],       %% 装备
        looks = []      %% 外观
    }
).

-record(rank_cross_role_skill, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        guild = <<>>,       %% 帮会名称       显示
        skill = 0,      %% 技能度   F   显示
        lev = 0,        %% 等级     S
        vip = 0,        %% VIP等级  T   显示
        date = 0,        %% 上榜日期
        eqm = [],       %% 装备
        looks = []      %% 外观
    }
).

%%-------------------------------------------
%% 宠物榜
%%-------------------------------------------

%% 仙宠排行榜记录数据结构(等级)
-record(rank_role_pet, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示   
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业
        sex = 0,        %% 性别
        petid = 0,      %% 仙宠id
        color = 0,      %% 仙宠颜色     显示
        petname = <<>>, %% 仙宠名称     显示
        petlev = 0,     %% 宠等级   F   显示
        aptitude = 0,   %% 资质     S   显示
        growrate = 0,   %% 成长值   T   显示
        vip = 0,        %% VIP等级  T   显示
        petrb = 0,      %% 宠物珍稀度
        date = 0,       %% 上榜日期
        pet
    }
).

%% 仙宠排行榜记录数据结构(跨服等级)
-record(rank_cross_pet_lev, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示   
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业
        sex = 0,        %% 性别
        petid = 0,      %% 仙宠id
        color = 0,      %% 仙宠颜色     显示
        petname = <<>>, %% 仙宠名称     显示
        petlev = 0,     %% 宠等级   F   显示
        aptitude = 0,   %% 资质     S   显示
        growrate = 0,   %% 成长值   T   显示
        vip = 0,        %% VIP等级  T   显示
        petrb = 0,      %% 宠物珍稀度
        date = 0,       %% 上榜日期
        pet
    }
).

%% 仙宠排行榜记录数据结构(战力)
-record(rank_role_pet_power, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示   
        realm = 0 ,         %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业
        sex = 0,        %% 性别
        petid = 0,      %% 仙宠id
        color = 0,      %% 仙宠颜色     显示
        petname = <<>>, %% 仙宠名称     显示
        petlev = 0,     %% 宠等级   F   显示
        power = 0,      %% 战斗力   T   显示
        guild = <<>>,   %% 军团名称
        vip = 0,        %% VIP等级  T   显示
        petrb = 0,      %% 宠物珍稀度
        date = 0,       %% 上榜日期
        pet
    }
).

%% 仙宠排行榜记录数据结构(跨服战力)
-record(rank_cross_role_pet_power, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示   
        realm = 0 ,         %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业
        sex = 0,        %% 性别
        petid = 0,      %% 仙宠id
        color = 0,      %% 仙宠颜色     显示
        petname = <<>>, %% 仙宠名称     显示
        petlev = 0,     %% 宠等级   F   显示
        power = 0,      %% 战斗力   T   显示
        vip = 0,        %% VIP等级  T   显示
        petrb = 0,      %% 宠物珍稀度
        date = 0,       %% 上榜日期
        pet
    }
).

%% 仙宠排行榜记录数据结构(成长)
-record(rank_pet_grow, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示   
        realm = 0 ,         %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业
        sex = 0,        %% 性别
        petid = 0,      %% 仙宠id
        color = 0,      %% 仙宠颜色     显示
        petname = <<>>, %% 仙宠名称     显示
        petlev = 0,     %% 宠等级   F   显示
        grow = 0,      %% 成长   T   显示
        vip = 0,        %% VIP等级  T   显示
        petrb = 0,      %% 宠物珍稀度
        date = 0,       %% 上榜日期
        pet
    }
).

%% 仙宠排行榜记录数据结构(跨服成长)
-record(rank_cross_pet_grow, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示   
        realm = 0 ,         %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业
        sex = 0,        %% 性别
        petid = 0,      %% 仙宠id
        color = 0,      %% 仙宠颜色     显示
        petname = <<>>, %% 仙宠名称     显示
        petlev = 0,     %% 宠等级   F   显示
        grow = 0,      %% 成长   T   显示
        vip = 0,        %% VIP等级  T   显示
        petrb = 0,      %% 宠物珍稀度
        date = 0,       %% 上榜日期
        pet
    }
).

%% 仙宠排行榜记录数据结构(潜力)
-record(rank_pet_potential, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示   
        realm = 0 ,         %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业
        sex = 0,        %% 性别
        petid = 0,      %% 仙宠id
        color = 0,      %% 仙宠颜色     显示
        petname = <<>>, %% 仙宠名称     显示
        petlev = 0,     %% 宠等级   F   显示
        potential = 0,      %% 潜力   T   显示
        vip = 0,        %% VIP等级  T   显示
        petrb = 0,      %% 宠物珍稀度
        date = 0,       %% 上榜日期
        pet
    }
).

%% 仙宠排行榜记录数据结构(跨服潜力)
-record(rank_cross_pet_potential, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示   
        realm = 0 ,         %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业
        sex = 0,        %% 性别
        petid = 0,      %% 仙宠id
        color = 0,      %% 仙宠颜色     显示
        petname = <<>>, %% 仙宠名称     显示
        petlev = 0,     %% 宠等级   F   显示
        potential = 0,      %% 潜力   T   显示
        vip = 0,        %% VIP等级  T   显示
        petrb = 0,      %% 宠物珍稀度
        date = 0,       %% 上榜日期
        pet
    }
).

%%---------------------------------------------
%% 装备排行榜
%%---------------------------------------------
%% 武器排行榜
-record(rank_equip_arms, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        guild = <<>>,   %% 帮会名称       显示
        arms = <<>>,    %% 武器名称     显示
        score = 0,      %% 武器分   F   显示
        lev = 0,        %% 等级     S
        vip = 0,        %% VIP等级  T   显示
        date = 0,       %% 上榜日期
        quality = 0,    %% 品质
        item            %% 武器物品
    }
).

-record(rank_cross_equip_arms, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        guild = <<>>,   %% 帮会名称       显示
        arms = <<>>,    %% 武器名称     显示
        score = 0,      %% 武器分   F   显示
        lev = 0,        %% 等级     S
        vip = 0,        %% VIP等级  T   显示
        date = 0,       %% 上榜日期
        quality = 0,    %% 品质
        item            %% 武器物品
    }
).

%% 防具排行榜
-record(rank_equip_armor, {
        id = {0, 0, 0}, %% 唯一识别ID 第三个值为 防具类型
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        guild = <<>>,   %% 帮会名称       显示
        armor = <<>>,   %% 防具名称     显示
        score = 0,      %% 防具分   F   显示
        lev = 0,        %% 等级     S
        vip = 0,        %% VIP等级  T   显示
        date = 0,       %% 上榜日期
        quality = 0,    %% 品质
        type,           %% 类型即位置（2:法袍 3:腰带 4:法腕 5:护手 6:法裤 7:法靴）
        item            %% 防具物品
    }
).

-record(rank_cross_equip_armor, {
        id = {0, 0, 0}, %% 唯一识别ID 第三个值为 防具类型
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        guild = <<>>,   %% 帮会名称       显示
        armor = <<>>,   %% 防具名称     显示
        score = 0,      %% 防具分   F   显示
        lev = 0,        %% 等级     S
        vip = 0,        %% VIP等级  T   显示
        date = 0,       %% 上榜日期
        quality = 0,    %% 品质
        type,           %% 类型即位置（2:法袍 3:腰带 4:法腕 5:护手 6:法裤 7:法靴）
        item            %% 防具物品
    }
).

%%---------------------------------------------
%% 帮会排行榜
%%---------------------------------------------

%% 帮会等级排行榜
-record(rank_guild_lev, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 帮会ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 帮会名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        icon = 0,       %% 帮会图标     显示
        cId = 0,    %% 帮主id
        cName = <<>>,   %% 帮主名称     显示
        lev = 0,        %% 等级     F   显示
        fund = 0,       %% 帮会资金 S   显示
        num = 0,        %% 帮会人数 T   显示
        chief_rid = 0,  %% 帮主ID
        chief_srv_id = 0, %% 帮主服务器标志
        date = 0        %% 上榜日期
    }
).

%% 帮会战力排行榜
-record(rank_guild_power, {
        id = {0, 0}, %% 唯一识别ID {帮会ID, 服务器ID}
        rid = 0,        %% 帮会ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 帮会名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        icon = 0,       %% 帮会图标     显示
        cId = 0,    %% 帮主id
        cName = <<>>,   %% 帮主名称     显示
        lev = 0,        %% 等级     F   显示
        power = 0,      %%军团总战力
        fund = 0,       %% 帮会资金 S   显示
        num = 0,        %% 帮会人数 T   显示
        chief_rid = 0,  %% 帮主ID
        chief_srv_id = 0, %% 帮主服务器标志
        date = 0        %% 上榜日期
    }
).


%% 帮会等级排行榜
-record(rank_cross_guild_lev, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 帮会ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 帮会名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        icon = 0,       %% 帮会图标     显示
        cId = 0,    %% 帮主id
        cName = <<>>,   %% 帮主名称     显示
        lev = 0,        %% 等级     F   显示
        fund = 0,       %% 帮会资金 S   显示
        num = 0,        %% 帮会人数 T   显示
        chief_rid = 0,  %% 帮主ID
        chief_srv_id = 0, %% 帮主服务器标志
        date = 0        %% 上榜日期
    }
).

%% 仙岛斗法排行榜
-record(rank_guild_combat, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 帮会ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 帮会名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        cName = <<>>,    %% 帮会名称     显示
        icon = 0,       %% 帮会图标     显示
        accScore = 0,   %% 总积分   F   显示
        score = 0,      %% 周积分   S   显示
        lev = 0,        %% 帮会等级 T   显示
        date = 0        %% 上榜日期
    }
).

%% 上场仙岛积分排行榜
-record(rank_guild_last, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 帮会ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 帮会名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        cName = <<>>,    %% 帮会名称     显示
        icon = 0,       %% 帮会图标     显示
        score = 0,      %% 上场积分 F   显示
        lev = 0,        %% 帮会等级 S   显示
        num = 0,        %% 参战人数 T   显示
        date = 0        %% 上榜日期
    }
).
        
%% 上场个人战功
-record(rank_guild_exploits, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业
        sex = 0,        %% 性别
        score = 0,      %% 战功积分 F
        lev = 0,        %% 玩家等级 S   显示
        vip = 0,        %% VIP等级  T
        kill = 0,       %% 杀敌数       显示
        die = 0,        %% 死亡次数     显示
        guild = <<>>,       %% 帮会名称       显示
        ssan = 0,       %% 仙石数       显示
        date = 0        %% 上榜日期
    }
).
 
%%------------------------------------------
%% 竞技排行榜
%%------------------------------------------

%% 总成绩排行榜
-record(rank_vie_acc, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        score = 0,      %% 总积分   F   显示
        lev = 0,        %% 等级     S   显示
        vip = 0,        %% VIP等级  T   显示
        guild = <<>>,       %% 帮会名称       显示
        date = 0        %% 上榜日期
    }
).

%% 总斩杀次数排行榜
-record(rank_vie_kill, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        kill = 0,      %% 杀人次数   F   显示
        lev = 0,        %% 等级     S   显示
        vip = 0,        %% VIP等级  T   显示
        guild = <<>>,       %% 帮会名称       显示
        date = 0        %% 上榜日期
    }
).

-record(rank_cross_vie_kill, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        kill = 0,      %% 杀人次数   F   显示
        lev = 0,        %% 等级     S   显示
        vip = 0,        %% VIP等级  T   显示
        guild = <<>>,       %% 帮会名称       显示
        date = 0        %% 上榜日期
    }
).

%% 上场战成绩排行榜
-record(rank_vie_last, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        score = 0,      %% 上周积分 F   显示
        lev = 0,        %% 等级     S   显示
        guild = <<>>,       %% 帮会名称       显示
        vip = 0,        %% VIP等级  T   显示
        date = 0        %% 上榜日期
    }
).

%% 上场战斩杀排行榜
-record(rank_vie_last_kill, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        kill = 0,      %% 上场斩杀 F   显示
        lev = 0,        %% 等级     S   显示
        guild = <<>>,       %% 帮会名称       显示
        vip = 0,        %% VIP等级  T   显示
        date = 0        %% 上榜日期
    }
).

%% 跨服战绩排行榜
-record(rank_vie_cross, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        win = 0,        %% 获胜次数 F   显示
        guild = <<>>,       %% 帮会名称       显示
        lev = 0,        %% 等级     S   显示
        vip = 0,        %% VIP等级  T   显示
        date = 0        %% 上榜日期
    }
).

%%------------------------------------------
%% 智力答题排行榜
%%------------------------------------------

%% 上场答题排行榜
-record(rank_wit_last, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         
        sex = 0,        %% 性别
        guild = <<>>,       %% 帮会名称  显示
        score = 0,      %% 上周积分 F   显示
        lev = 0,        %% 等级     S   显示
        vip = 0,        %% VIP等级  T   显示
        date = 0        %% 上榜日期
    }
).

%% 累积答题排行榜
-record(rank_wit_acc, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         
        sex = 0,        %% 性别
        guild = <<>>,       %% 帮会名称  显示
        score = 0,      %% 累积积分 F   显示
        lev = 0,        %% 等级     S   显示
        vip = 0,        %% VIP等级  T   显示
        date = 0        %% 上榜日期
    }
).

%%------------------------------------------
%% 送花排行榜
%%------------------------------------------

%% 累积送花榜
-record(rank_flower_acc, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        flower = 0,     %% 累积积分 F   显示
        lev = 0,        %% 等级     S   显示
        vip = 0,        %% VIP等级  T   显示
        guild = <<>>,       %% 帮会名称       显示
        date = 0        %% 上榜日期
    }
).

%% 上周送花榜
-record(rank_flower_last, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        flower = 0,     %% 上周积分 F   显示
        lev = 0,        %% 等级     S   显示
        vip = 0,        %% VIP等级  T   显示
        guild = <<>>,       %% 帮会名称       显示
        date = 0        %% 上榜日期
    }
).

%% 今日送花榜
-record(rank_flower_day, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        flower = 0,     %% 今日积分 F   显示
        lev = 0,        %% 等级     S   显示
        vip = 0,        %% VIP等级  T   显示
        guild = <<>>,   %% 帮会名称       显示
        face = 0,       %% 头像 
        date = 0        %% 上榜日期
    }
).

%% 跨服今日送花榜
-record(rank_cross_flower, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,      %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        flower = 0,     %% 今日积分 F   显示
        lev = 0,        %% 等级     S   显示
        vip = 0,        %% VIP等级  T   显示
        guild = <<>>,   %% 帮会名称       显示
        face = 0        %% 头像 
    }
).

%%------------------------------------------
%% 魅力排行榜
%%------------------------------------------

%% 累积魅力榜
-record(rank_glamor_acc, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        glamor = 0,     %% 累积魅力 F   显示
        lev = 0,        %% 等级     S   显示
        vip = 0,        %% VIP等级  T   显示
        guild = <<>>,       %% 帮会名称       显示
        date = 0        %% 上榜日期
    }
).

%% 上周魅力榜
-record(rank_glamor_last, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        glamor = 0,     %% 上周魅力 F   显示
        lev = 0,        %% 等级     S   显示
        vip = 0,        %% VIP等级  T   显示
        guild = <<>>,       %% 帮会名称       显示
        date = 0        %% 上榜日期
    }
).

%% 今日魅力榜
-record(rank_glamor_day, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,      %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        glamor = 0,     %% 今日魅力 F   显示
        lev = 0,        %% 等级     S   显示
        vip = 0,        %% VIP等级  T   显示
        guild = <<>>,   %% 帮会名称       显示
        face = 0,       %% 头像 
        date = 0        %% 上榜日期
    }
).

%% 跨服今日魅力榜
-record(rank_cross_glamor, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        glamor = 0,     %% 今日魅力 F   显示
        lev = 0,        %% 等级     S   显示
        vip = 0,        %% VIP等级  T   显示
        guild = <<>>,   %% 帮会名称       显示
        face = 0       %% 头像 
    }
).

%%------------------------------------------
%% 人气排行榜
%%------------------------------------------

%% 累积人气榜
-record(rank_popu_acc, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性gg
        popu = 0,       %% 累积人气 F   显示
        lev = 0,        %% 等级     S   显示
        vip = 0,        %% VIP等级  T   显示
        guild = <<>>,       %% 帮会名称       显示
        date = 0        %% 上榜日期
    }
).

%% 上周人气榜
-record(rank_popu_last, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        popu = 0,       %% 上周人气 F   显示
        lev = 0,        %% 等级     S   显示
        vip = 0,        %% VIP等级  T   显示
        guild = <<>>,       %% 帮会名称       显示
        date = 0        %% 上榜日期
    }
).

%%-----------------------------
%% 达人榜
%%-----------------------------

%% 金币达人榜
-record(rank_darren_coin, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,      %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        val = 0,        %% 数值 F   显示
        lev = 0,        %% 等级     S   显示
        vip = 0,        %% VIP等级  T   显示
        guild = <<>>,       %% 帮会名称       显示
        date = 0,        %% 上榜日期
        eqm = [],       %% 装备
        looks = []      %% 外观
    }
).

%% 寻宝达人榜
-record(rank_darren_casino, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,      %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        val = 0,        %% 数值 F   显示
        lev = 0,        %% 等级     S   显示
        vip = 0,        %% VIP等级  T   显示
        guild = <<>>,       %% 帮会名称       显示
        date = 0,        %% 上榜日期
        eqm = [],       %% 装备
        looks = []      %% 外观
    }
).

%% 经验达人榜
-record(rank_darren_exp, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,      %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        val = 0,        %% 数值 F   显示
        lev = 0,        %% 等级     S   显示
        vip = 0,        %% VIP等级  T   显示
        guild = <<>>,       %% 帮会名称       显示
        date = 0,        %% 上榜日期
        eqm = [],       %% 装备
        looks = []      %% 外观
    }
).

%% 阅历达人榜
-record(rank_darren_attainment, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,      %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        val = 0,        %% 数值 F   显示
        lev = 0,        %% 等级     S   显示
        vip = 0,        %% VIP等级  T   显示
        guild = <<>>,       %% 帮会名称       显示
        date = 0,        %% 上榜日期
        eqm = [],       %% 装备
        looks = []      %% 外观
    }
).

%%-----------------------------
%% 副本排行榜
%%-----------------------------

-record(rank_dungeon, {
        id = {0, 0}         %% 唯一识别
        ,rid = 0            %% 角色ID
        ,srv_id = <<>>      %% 服务器标志
        ,name = <<>>        %% 角色名称
        ,sex = 0            %% 玩家性别
        ,career = 0         %% 玩家职业
        ,top_harm = 0       %% 最高单次伤害
        ,total_hurt = 0     %% 承受的总伤害
        ,combat_round = 0   %% 回合
        ,dun_score = 0      %% 副本评分
        ,score_grade               %% 星星级别 3, 2, 1。
        ,date = 0        %% 上榜日期
    }
).

%%-----------------------------
%% 名人榜
%%-----------------------------

%% 开发服名人榜
%% 名人榜基础数据
-record(rank_data_celebrity, {
        id              %% 唯一标志
        ,name           %% 名称 
        ,condition      %% 条件
        ,rewards = 0    %% 奖励
        ,honor = <<>>   %% 称号
        ,color = <<>>   %% 称号颜色
    }
).
%% 记录开服第一个达到条件的玩家的名称，该名称永久记录，且不会换人。
-record(rank_global_celebrity, {
        id              %% 唯一识别
        ,date = 0       %% 上榜时间
        ,r_list = []    %% 角色列表 [#rank_celebrity_role{}..]
    }
).
-record(rank_celebrity_role, {
        id              %% {角色ID, 服务器标志}
        ,rid            %% 角色ID
        ,srv_id         %% 服务器标志
        ,name           %% 名称
        ,career         %% 职业
        ,sex            %% 性别
        ,looks = []     %% 外观
    }).

%% 排行榜奖励数据
%% 开服活动奖励
-record(rank_reward_base, {
        rtype            %% 排行榜类型
        ,sort            %% 榜内排行
        ,items = []      %% 物品奖励
        ,assets = []     %% 资产奖励
        ,subject = <<>>  %% 信件标题
        ,content = <<>>  %% 信件内容
    }
).

%%-----------------------------
%% 仙侣榜
%%-----------------------------

%% 榜单基础数据
-record(rank_married, {
        ids = {0, 0}            %% 双方ID组合
        ,names = {<<>>, <<>>}   %% 双方名称组合
        ,intimacy = 0           %% 亲密度
        ,type = 0               %% 婚礼规格
        ,ring_lev = 0           %% 定情信物等级，推送时转换为BaseId
        ,index = 0              %% 本服第几对
        ,time = 0               %% 双方结婚时间
    }).

%%----------------------------------
%% 坐骑
%%----------------------------------

%% 坐骑战斗力
-record(rank_mount_power, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        lev = 0,        %% 玩家等级
        guild = <<>>,   %% 帮会名称       显示
        mount = <<>>,   %% 坐骑名称
        step = 0,       %% 坐骑阶数
        mount_lev = 0,  %% 坐骑等级
        quality = 0,    %% 坐骑品质
        power = 0,      %% 坐骑战斗力
        vip = 0,        %% VIP等级  T   显示
        date = 0,       %% 上榜日期
        eqm = [],       %% 装备
        looks = []      %% 外观
    }
).

%% 坐骑战斗力
-record(rank_cross_mount_power, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        lev = 0,        %% 玩家等级
        guild = <<>>,   %% 帮会名称       显示
        mount = <<>>,   %% 坐骑名称
        step = 0,       %% 坐骑阶数
        mount_lev = 0,  %% 坐骑等级
        quality = 0,    %% 坐骑品质
        power = 0,      %% 坐骑战斗力
        vip = 0,        %% VIP等级  T   显示
        date = 0,       %% 上榜日期
        eqm = [],       %% 装备
        looks = []      %% 外观
    }
).

%% 坐骑战斗力
-record(rank_mount_lev, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        lev = 0,        %% 玩家等级
        guild = <<>>,   %% 帮会名称       显示
        mount = <<>>,   %% 坐骑名称
        step = 0,       %% 坐骑阶数
        mount_lev = 0,  %% 坐骑等级
        quality = 0,    %% 坐骑品质
        power = 0,      %% 坐骑战斗力
        vip = 0,        %% VIP等级  T   显示
        date = 0,       %% 上榜日期
        eqm = [],       %% 装备
        looks = []      %% 外观
    }
).

%% 坐骑战斗力
-record(rank_cross_mount_lev, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        lev = 0,        %% 玩家等级
        guild = <<>>,   %% 帮会名称       显示
        mount = <<>>,   %% 坐骑名称
        step = 0,       %% 坐骑阶数
        mount_lev = 0,  %% 坐骑等级
        quality = 0,    %% 坐骑品质
        power = 0,      %% 坐骑战斗力
        vip = 0,        %% VIP等级  T   显示
        date = 0,       %% 上榜日期
        eqm = [],       %% 装备
        looks = []      %% 外观
    }
).


%% 无限试练
-record(rank_practice, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称     显示
        realm = 0,      %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业         显示
        sex = 0,        %% 性别
        lev = 0,        %% 玩家等级
        guild = <<>>,   %% 帮会名称       显示
        vip = 0,        %% VIP等级  T   显示
        score = 0,      %% 积分
        date = 0        %% 上榜日期
    }
).


%%-----------------------------
%% 跨服排行榜
%%-----------------------------
%% 综合战斗力（本地）
-record(rank_total_power, {
        id = {0,0}          %% 唯一识别
        ,rid                %% 角色ID
        ,srv_id             %% 服务器标志
        ,name = <<>>        %% 名称
        ,career             %% 职业
        ,ascend = 0         %% 进阶方向
        ,sex                %% 性别
        ,lev                %% 等级
        ,guild = <<>>       %% 帮会名称       显示
        ,realm = 0          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        ,role_power = 0     %% 角色战斗力
        ,pet_power = 0      %% 宠物战斗力
        ,total_power = 0    %% 综合战斗力
        ,wc_lev = 0         %% 仙道勋章等级
        ,vip = 0            %% VIP类型
        ,date = 0           %% 上榜时间
        ,eqm = []           %% 装备
        ,looks = []         %% 外观
        ,pet                %% 角色宠物
    }
).

%% 综合战斗力
-record(rank_cross_total_power, {
        id = {0,0}          %% 唯一识别
        ,rid                %% 角色ID
        ,srv_id             %% 服务器标志
        ,name = <<>>        %% 名称
        ,career             %% 职业
        ,ascend = 0         %% 进阶方向
        ,sex                %% 性别
        ,lev                %% 等级
        ,realm = 0          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        ,guild = <<>>       %% 帮会名称       显示
        ,role_power = 0     %% 角色战斗力
        ,pet_power = 0      %% 宠物战斗力
        ,total_power = 0    %% 综合战斗力
        ,wc_lev = 0         %% 仙道勋章等级
        ,vip = 0            %% VIP类型
        ,eqm = []           %% 装备
        ,looks = []         %% 外观
        ,pet                %% 角色宠物
    }
).

%% 跨服仙道会排行榜记录数据结构
-record(rank_world_compete, {
        id = {0, 0},        %% 角色ID
        rid = 0,
        srv_id = 0,
        name = <<>>,        %% 角色名称
        lev = 0,            %% 角色等级
        career = 0,
        sex = 0,
        looks = [],
        eqm = [],
        lilian = 0,         %% 获得的历练数（排序用）
        win_rate = 0,       %% 胜率（排序用）
        wc_lev = 0,         %% 仙道勋章等级
        section_mark = 0,   %% 仙道会段位积分
        section_lev = 0     %% 仙道会段位等级
    }
).

%% 仙道会排行榜记录数据结构(战胜场数)
-record(rank_world_compete_win, {
        id = {0, 0},        %% 角色ID
        rid = 0,
        srv_id = 0,
        name = <<>>,        %% 角色名称
        lev = 0,            %% 角色等级
        career = 0,
        sex = 0,
        vip = 0,            %% VIP类型
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        guild = <<>>,       %% 帮会名称       显示
        looks = [],
        eqm = [],
        win_count = 0,      %% 胜利场数
        date = 0           %% 上榜时间
    }
).

%% 跨服仙道会排行榜记录数据结构(战胜场数)
-record(rank_cross_world_compete_win, {
        id = {0, 0},        %% 角色ID
        rid = 0,
        srv_id = 0,
        name = <<>>,        %% 角色名称
        lev = 0,            %% 角色等级
        career = 0,
        sex = 0,
        vip = 0,            %% VIP类型
        realm = 0,          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        guild = <<>>,       %% 帮会名称       显示
        looks = [],
        eqm = [],
        win_count = 0,      %% 胜利场数
        date = 0             %% 上榜时间
    }
).

%% 跨服仙道会每日最佳战绩排行榜(战胜场数)
-record(rank_world_compete_win_day, {
        id = {0, 0},
        rid = 0,
        srv_id = 0,
        name = <<>>,
        lev = 0,            %% 角色等级
        career = 0,
        sex = 0,
        looks = [],
        eqm = [],
        role_power = 0,
        pet_power = 0,
        win_count = 0       %% 胜利场数
    }
).


%%------------------------------
%% 灵戒洞天
%%------------------------------
%% 灵戒战力排行榜数据结构
-record(rank_soul_world, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称  
        realm = 0 ,     %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业    
        sex = 0,        %% 性别
        role_lev = 0,   %% 角色等级
        guild = <<>>,   %% 帮会名称 
        power = 0,      %% 战斗力  
        vip = 0,        %% VIP等级
        date = 0,       %% 上榜日期
        spirits = [],   %% 妖灵
        arrays = []     %% 神魔阵
    }
).

-record(rank_cross_soul_world, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称  
        realm = 0 ,     %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业    
        sex = 0,        %% 性别
        role_lev = 0,   %% 角色等级
        guild = <<>>,   %% 帮会名称 
        power = 0,      %% 战斗力  
        vip = 0,        %% VIP等级
        date = 0,       %% 上榜日期
        spirits = [],   %% 妖灵
        arrays = []     %% 神魔阵
    }
).

%% 魔阵等级排行榜数据结构
-record(rank_soul_world_array, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称  
        realm = 0 ,     %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业    
        sex = 0,        %% 性别
        role_lev = 0,   %% 角色等级
        guild = <<>>,   %% 帮会名称 
        lev = 0,        %% 等级  
        vip = 0,        %% VIP等级
        date = 0,       %% 上榜日期
        arrays = []     %% 神魔阵
    }
).

-record(rank_cross_soul_world_array, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称  
        realm = 0 ,     %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业    
        sex = 0,        %% 性别
        role_lev = 0,   %% 角色等级
        guild = <<>>,   %% 帮会名称 
        lev = 0,        %% 等级  
        vip = 0,        %% VIP等级
        date = 0,       %% 上榜日期
        arrays = []     %% 神魔阵
    }
).

%% 妖灵战力排行榜数据结构
-record(rank_soul_world_spirit, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称  
        realm = 0 ,     %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业    
        sex = 0,        %% 性别
        role_lev = 0,   %% 角色等级
        guild = <<>>,   %% 帮会名称 
        spirit_name,    %% 妖灵名称
        spirit_lev,     %% 妖灵等级
        quality = 0,    %% 品质
        power = 0,      %% 战斗力  
        vip = 0,        %% VIP等级
        date = 0,       %% 上榜日期
        spirit          %% 妖灵
    }
).

-record(rank_cross_soul_world_spirit, {
        id = {0, 0}, %% 唯一识别ID
        rid = 0,        %% 角色ID        
        srv_id = 0,     %% 服务器ID
        name = <<>>,    %% 角色名称  
        realm = 0 ,     %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        career = 0,     %% 职业    
        sex = 0,        %% 性别
        role_lev = 0,   %% 角色等级
        guild = <<>>,   %% 帮会名称 
        spirit_name,    %% 妖灵名称
        spirit_lev,     %% 妖灵等级
        quality = 0,    %% 品质
        power = 0,      %% 战斗力  
        vip = 0,        %% VIP等级
        date = 0,       %% 上榜日期
        spirit          %% 妖灵
    }
).

