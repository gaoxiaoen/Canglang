-define(parent, combat_script_skill).

%% 影响行动的处理函数
-record(action_effect_func, 
    {
        anti_attack_before = undefined, %% 计算反击前
        anti_attack_after = undefined,  %% 计算反击后
        dmg_adjust = undefined,         %% 攻击力修正
        dmg_before_crit = undefined,    %% 计算暴击前
        dmg_after_crit = undefined,     %% 计算暴击后
        dmg_mp = undefined,             %% 计算魔法伤害
        dmg_can_crit = true,            %% 计算暴击前(能否暴击)
        dmg_hp = undefined,             %% 计算伤害
        dmg_hp_max = undefined,         %% 计算伤害上限
        restore_self_hp = undefined,     %% 回复自身血气
        can_pet_protect = true,         %% 该技能能否触发宠物保护
        dmg_magic_reduce = undefined,    %% 魔法伤害减免
        dmg_can_hit = true,              %% 命中
        dmg_after_hit = undefined             %% 如果命中时执行
    }).


