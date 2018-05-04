%% Author: caochuncheng2002@gmail.com
%% Created: 2015-09-30
%% Description: 战斗、技能相关的宏定义
%% 注：此文件定义的宏都必须以 F_xxx_xxx中的 F_开头


%% 伤害计算公式类型
-define(F_HARM_FORMULA_REDUCE,1).                %% 1：减法
-define(F_HARM_FORMULA_DIV,2).                   %% 2：除法

%% 技能类型 #r_skill_info.attack_mode
-define(F_ATTACK_MODE_ACTIVE,0).                 %% 0：主动
-define(F_ATTACK_MODE_PASSIVE,1).                %% 1：被动

%% 攻击目录类型 
-define(F_ATTACK_TARGET_ROLE,1).                 %% 1：角色
-define(F_ATTACK_TARGET_PET,2).                  %% 2：宠物
-define(F_ATTACK_TARGET_MONSTER,3).              %% 3：怪物

%% 技能施法目标类型 #r_skill_info.target_type
-define(F_TARGET_TYPE_SELF,1).                   %% 1: 施法者自己
-define(F_TARGET_TYPE_SELF_AROUND,2).            %% 2: 施法者自己的周围
-define(F_TARGET_TYPE_OTHER,3).                  %% 3: 选择的目标
-define(F_TARGET_TYPE_OTHER_AROUND,4).           %% 4: 选择目标的周围区域
-define(F_TARGET_TYPE_SERIAL, 5).                %% 5: 选择目标和周围连续其它目标（目标不重复）,闪电链专用
-define(F_TARGET_TYPE_OVERLAP_SERIAL, 6).        %% 6: 选择目标的连续目标（目标可重复）
-define(F_TARGET_TYPE_ADD_HP_CHAIN, 7).          %% 7：治疗链加血专用（目标不重复）
-define(F_TARGET_TYPE_SELF_RECTANGLE, 8).        %% 8：施法者起点矩形
-define(F_TARGET_TYPE_SELF_AROUND_TRAP, 9).      %% 9：施法者自己的周围-陷阱
-define(F_TARGET_TYPE_OTHER_AROUND_TRAP, 10).    %%10：地图目标点的周围-陷阱

%% 技能有效目标 #r_skill_info.target_kind
-define(F_TARGET_KIND_FRIEND,1).                 %% 2：友方
-define(F_TARGET_KIND_ENEMY,2).                  %% 3：敌方

%% 技能种类 #r_skill_info.type
-define(SKILL_TYPE_SYSTEM, 0).                   %% 0：系统技能
-define(SKILL_TYPE_CATEGORY, 1).                 %% 1：职业技能
-define(SKILL_TYPE_PET, 2).                      %% 2：宠物技能 
-define(SKILL_TYPE_MONSTER, 3).                  %% 3：怪物技能
-define(SKILL_TYPE_FAMILY, 4).                   %% 4：帮派技能

%% 技能攻击延迟类型
-define(SKILL_ATTACK_DELAY_TYPE_NONE, 0).        %% 0：无
-define(SKILL_ATTACK_DELAY_TYPE_CHANT, 1).       %% 1：技能吟唱
-define(SKILL_ATTACK_DELAY_TYPE_DELAY, 2).       %% 2：延迟释放


%% 效果计算类型 #r_skill_effect.type
-define(SKILL_EFFECT_TYPE_BASE_PHY_ATTACK,1).            %% 1：普通物理攻击力
-define(SKILL_EFFECT_TYPE_BASE_MAGIC_ATTACK,2).          %% 2：普通魔法攻击力
-define(SKILL_EFFECT_TYPE_ABSOLUTE_PHY_ATTACK,3).        %% 3：物理伤害绝对值输出
-define(SKILL_EFFECT_TYPE_ABSOLUTE_MAGIC_ATTACK,4).      %% 4：法力伤害绝对值输出
-define(SKILL_EFFECT_TYPE_ADD_HP,5).                     %% 5：加血
-define(SKILL_EFFECT_TYPE_ADD_BUFF,6).                   %% 6：加BUFF
-define(SKILL_EFFECT_TYPE_BORN_MONSTER,7).               %% 7：召唤怪物


%% 最终效果类型 
-define(EFFECT_REDUCE_HP,1).                     %% 1：减血
-define(EFFECT_ADD_HP,2).                        %% 2：加血
-define(EFFECT_REDUCE_MP,3).                     %% 3：减蓝
-define(EFFECT_ADD_MP,4).                        %% 4：加蓝
-define(EFFECT_REDUCE_ANGER,5).                  %% 5：减怒
-define(EFFECT_ADD_ANGER,6).                     %% 6：加怒
-define(EFFECT_ADD_BUFF,7).                      %% 7: 增加BUFF
-define(EFFECT_DEL_BUFF,8).                      %% 8: 删除BUFF



%% BUFF持续类型
-define(BUFF_KEEP_TYPE_REAL_TIME,1).             %% 1：普通的持续一定的时间
-define(BUFF_KEEP_TYPE_FOREVER_TIME,2).          %% 2：没有时间限制
-define(BUFF_KEEP_TYPE_ONLINE_TIME,3).           %% 3：持续的角色在线时间
-define(BUFF_KEEP_TYPE_REAL_INTERVAL_TIME,4).    %% 4：持续的角色在线时间 间隔时间触发
-define(BUFF_KEEP_TYPE_SUMMONED_PET,5).          %% 5：宠物出战时拥有

%% BUFF目标类型
-define(BUFF_TARGET_TYPE_TARGET, 0).
-define(BUFF_TARGET_TYPE_SCOPE, 1).

%% BUFF效果类型
-define(BUFF_EFFECT_ATTR, 1).                    %% 属性
-define(BUFF_EFFECT_ADD_HP, 2).                  %% 加血
-define(BUFF_EFFECT_FANIT, 3).                   %% 眩晕状态
-define(BUFF_EFFECT_REDUCE_HURT, 4).             %% 减免伤害
-define(BUFF_EFFECT_UNRIVALLED, 5).              %% 无敌
-define(BUFF_EFFECT_VIRTUAL,6).                  %% 虚空-不可被攻击，即不可以成为攻击目标 
%%伤害类型
-define(HURT_TYPE_NORMAL, 0).                    %% 一般伤害
-define(HURT_TYPE_DOUBLE_HIT, 1).                %% 暴击伤害
-define(HURT_TYPE_MISS, 2).                      %% 闪避
-define(HURT_TYPE_UNRIVALLED,3).                 %% 无敌

%%属性字段定义
-define(ATTR_POWER, 1).                          %%力量
-define(ATTR_MAGIC, 2).                          %%魔力
-define(ATTR_BODY, 3).                           %%体质
-define(ATTR_SPIRIT, 4).                         %%念力
-define(ATTR_AGILE, 5).                          %%敏捷
-define(ATTR_MAX_HP, 6).                         %%最大生命上限
-define(ATTR_MAX_MP, 7).                         %%最大魔法上限
-define(ATTR_MAX_ANGER, 8).                      %%最大怒气
-define(ATTR_PHY_ATTACK, 9).                     %%物理攻击力
-define(ATTR_MAGIC_ATTACK, 10).                  %%魔法攻击力
-define(ATTR_PHY_DEFENCE, 11).                   %%物理防御
-define(ATTR_MAGIC_DEFENCE, 12).                 %%魔法防御
-define(ATTR_HIT, 13).                           %%命中
-define(ATTR_MISS, 14).                          %%闪避
-define(ATTR_DOUBLE_ATTACK, 15).                 %%暴击
-define(ATTR_TOUGH, 16).                         %%坚韧
-define(ATTR_SEAL, 17).                          %%封印
-define(ATTR_ANTI_SEAL, 18).                     %%抗封
-define(ATTR_CURE_EFFECT, 19).                   %%治疗强度
-define(ATTR_ATTACK_SKILL, 20).                  %%物法修炼，功击修炼
-define(ATTR_PHY_DEFENCE_SKILL, 21).             %%物防修炼
-define(ATTR_MAGIC_DEFENCE_SKILL, 22).           %%魔防修炼
-define(ATTR_SEAL_SKILL, 23).                    %%抗封修炼