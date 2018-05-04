%%----------------------------------------------------
%%
%% 造成目标最大生命值[值+暴击转换系数1*暴击/(暴击+参数)]%的伤害，伤害绝对值上限为[基础值+角色自身暴击*暴击转换系数2]，无视仙宠护主    
%%
%% args = [值，暴击转换系数1，参数，基础值，暴击转换系数2]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10310).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [BaseVal1, CritRatio1, AddRatio, BaseVal2, CritRatio2]}, Self = #fighter{attr = #attr{critrate = CritRate}}, Target = #fighter{hp_max = HpMax,attr = #attr{injure_ratio = InjureRatio}}) ->
    ?parent:attack(Skill, Self, Target, #action_effect_func{
            dmg_hp = fun([IsCrit]) ->
                    BaseDmg = case CritRate + AddRatio > 0 of
                        true -> (BaseVal1 + CritRatio1 * CritRate/(CritRate + AddRatio))/100 * HpMax * InjureRatio / 100;
                        false -> (BaseVal1/100) * HpMax * InjureRatio / 100
                    end,
                    case IsCrit of
                        ?true -> round(BaseDmg * 1.5);
                        _ -> round(BaseDmg)
                    end 
            end,
            dmg_hp_max = fun([Dmg, IsCrit]) ->
                    BaseDmg = (BaseVal2 + CritRate * CritRatio2) * InjureRatio / 100,
                    case IsCrit of
                        ?true -> util:check_range(Dmg, 0, round(BaseDmg * 1.5));
                        _ -> util:check_range(Dmg, 0, round(BaseDmg))
                    end
            end, can_pet_protect = false});

handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).

