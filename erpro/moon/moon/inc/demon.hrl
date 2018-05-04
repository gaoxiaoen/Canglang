%%---------------------------------------------
%% 精灵守护(侍宠)数据结构
%% @author wpf(wprehard@qq.com)
%% @end
%%---------------------------------------------

-define(DEMON_ROLE_VER, 3).
-define(DEMON_VER, 4).

-define(DEMON_STEP_MAX, 100). %% 守护阶数最高阶
-define(SKILL_STEP_MAX, 10). %% 守护技能最高等级
-define(SKILL_EXP_STEP_SIZE, 2). %% 技能升级经验步长
-define(STEP_EXP_STEP_SIZE, 50). %% 守护升级经验步长

-define(VAL_LUCK_COIN, 1). %% 金币刷新技能单次幸运值
-define(VAL_LUCK_GOLD, 2). %% 晶钻刷新技能单次幸运值

-define(POLISH_SKILL_COIN, 30000). %% 单次刷技能金币
-define(POLISH_SKILL_GOLD, pay:price(demon, polish_skill_gold, null)). %% 单次刷技能晶钻
-define(BATCH_POLISH_SKILL_COIN, 200000). %% 批量刷技能金币
-define(BATCH_POLISH_SKILL_GOLD, pay:price(demon, batch_polish_skill_gold, null)). %% 批量刷技能晶钻

-define(SKILL_BAG_MAX, 12). %% 技能背包格子数
-define(SHAPE_MAX_LEV, 10). %% 化形最高阶

-define(demon_challenge_type_real, 1).   %% 真实玩家
-define(demon_challenge_type_virtual, 0).   %% 虚拟玩家数据（来自中庭战神）
-define(demon_challenge_map_id, 1028).   %% 场景
-define(demon_challenge_left_pos_x, 480).  %% 左边站位坐标
-define(demon_challenge_right_pos_x, 780).  %% 右边站位坐标
-define(GRAB_TIMES, 20). %% 每天掠夺次数
%% 金 1
%% 木 2
%% 水 3
%% 火 4
%% 土 5

%% 角色精灵守护信息
-record(role_demon, {
        ver                 = ?DEMON_ROLE_VER
        ,active             = 0                     %% 出战的契约兽 #demon2
        ,follow             = 0                     %% 
        ,bag                = []                    %% 契约兽背包[#demon2{}...]
        ,attr               = []                    %% 
        ,exp                = 0                     %% 
        ,step               = 0                     %% 
        ,op_id              = 1                     %% 下一个兽的id
        ,skill_bag          = []                    %% 
        ,skill_polish       = []                    %% 记录献祭一半时的信息
        ,luck_coin          = 0                     %% 
        ,luck_gold          = 0                     %% 
        ,shape_lev          = 0                     %% 
        ,shape_skills       = []                    %% 碎片信息[{base_id, num}]
        ,grab_times         = {?GRAB_TIMES, 0}      %% 每天剩余掠夺次数记录, 每天已购买次数
    }).

%% 单个守护信息
-record(demon, {
        ver = ?DEMON_VER
        ,id = 0                 %% 守护的ID，不重复共5个
        ,name = <<>>            %% 守护名称
        ,craft = 0              %% 品质类型(1:白2:绿3:蓝4:紫5:橙)
        ,attr = []              %% 守护属性列表[{A, C, V, Lock} | ...]
                                %% A:属性类型 C:属性品质 V:属性值 Lock:是否洗髓锁
        ,skills = []            %% 守护技能 [{Sid, Step, Exp} | ...]
        ,intimacy = 0           %% 亲密度
        ,polish_attrs = []      %% 批量洗练属性槽 [{PolishId, Craft, AttrList} | ...]
        ,shape_lev = 0          %% 化形阶数
        ,shape_skills = []       %% 化形技能
        ,shape_luck = 0         %% 化形进阶当前幸运值
        ,shape_max_luck = 10     %% 化形进阶当前幸运值
    }).

%%契约兽属性数据结构
-record(demon_attr, {
        dmg        = 0,        %%攻击
        critrate   = 0,        %%暴怒
        hp_max     = 0,        %%生命
        mp_max     = 0,        %%魔法
        defence    = 0,        %%防御
        tenacity   = 0,        %%坚韧
        evasion    = 0,        %%格挡
        hitrate    = 0,        %%精准
        dmg_magic  = 0         %%绝对伤害
    }).

-record(demon_ratio, {
        dmg_per        = 100,        %%攻击
        critrate_per   = 100,        %%暴怒
        hp_max_per     = 100,        %%生命
        mp_max_per     = 100,        %%魔法
        defence_per    = 100,        %%防御
        tenacity_per   = 100,        %%坚韧
        evasion_per    = 100,        %%格挡
        hitrate_per    = 100,        %%精准
        dmg_magic_per  = 100         %%绝对伤害
    }).

%%契约兽基础数据结构
-record(demon2, {
        ver             = ?DEMON_VER
        ,id             = 0                 %% id，表示序号(有相同时使用)
        ,base_id        = 0                 %% 基础id
        ,name           = <<>>              %% 名称
        ,mod            = 0                 %% 0：休息， 1：出战
        ,craft          = 0                 %% 品质类型(1:白2:绿3:蓝4:紫5:橙)

        ,lev            = 1                 %% 当前等级
        ,exp            = 0                 %% 经验

        ,grow           = 1                 %% 成长值
        ,grow_max       = 0                 %% 成长上限
        ,bless          = 0                 %% 祝福值

        ,debris         = 0                 %% 召唤所需要的碎片数量
        ,debris_num     = 0                 %% 召唤所需要的碎片数量

        ,devour         = 0                 %% 吞噬值

        ,attack_type    = 0                 %% 攻击类型

        ,attr           = #demon_attr{}     %% 守护属性列表[{A, V} | ...]
        
        %% A:属性类型  V:属性值 
        ,ratio          = #demon_ratio{}

        ,skills         = []                %% 守护技能 [{Sid, Step, Exp} | ...]
        ,ext_attr       = []                %% 额外的属性加成 
    }).



%% 技能基础数据
-record(demon_skill, {
        id = 0                  %% 技能ID
        ,name = <<>>            %% 技能名称
        ,type = 0               %% 技能分类，见技能分类定义
        ,step = 0               %% 等级
        ,craft = 0              %% 品质：1:初级2:中级3:高级4:至尊5:神级
        ,exp = 0                %% 升级所需经验
        ,next_id = 0            %% 升级下一级技能ID，0表示最高级
        ,limit = []             %% 限制守护类型 [DemonId | ...]
        %% 针对战斗分别作为角色技能、宠物技能映射
        ,combat_info = 0        %% 对应的战斗技能信息，角色技能：{c_skill, CSkillId, TargetNum, Cd, Args, Buffs}
        ,pet_info = 0           %% 对应的宠物技能信息，宠物技能：{pet_skill, PetSkillId, Args, BuffSelf, BuffTarget, Cd}
    }).

%% 属性值固定定义
%% 气血 1
%% 法力 2
%% 攻击 3
%% 防御 4
%% 躲闪 5
%% 命中 6
%% 暴击 7
%% 坚韧 8
%% 法伤 9
%% 金抗 10
%% 木抗 11
%% 水抗 12
%% 火抗 13
%% 土炕 14

%% 技能分类定义
%% 1	金系攻击
%% 2	木系攻击
%% 3	水系攻击
%% 4	火系攻击
%% 5	土系攻击
%% 6	法伤吸收
%% 7	伤害抵抗
%% 8	宠物回血
%% 9	金系护宠
%% 10	木系护宠
%% 11	水系护宠
%% 12	火系护宠
%% 13	土系护宠
%% 14	宠物不死













