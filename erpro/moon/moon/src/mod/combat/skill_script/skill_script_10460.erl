%%----------------------------------------------------
%%
%% 当自身气血小于[HP百分比]时伤害增加[基础值+攻击*攻击转换系数]%，若自身气血不低于[气血百分比]%，则自身气血损耗[气血损耗值]          
%%
%% args = [HP百分比，基础值，攻击转换系数，气血百分比，气血损耗值]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10460).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [ShpRatio1, BaseVal, DmgRatio, ShpRatio2, HpCost], other_cost = OtherCost}, Self = #fighter{attr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}, hp = Shp, hp_max = ShpMax}, Target) ->
    Avg = (DmgMin + DmgMax)/2,
    DmgAverage = case Avg > 22000 of
        true -> 22000 + (Avg - 22000)/8;
        false -> Avg
    end,
    ActionEffectFunc = case (Shp * 100) < (ShpMax * ShpRatio1) of
        true ->
            Rat = 1 + (BaseVal + DmgAverage * DmgRatio)/100,
            Ratio = case Rat > 3.4 of
                true -> 3.4;
                false -> Rat
            end,
            #action_effect_func{dmg_before_crit = fun([Dmg]) -> round(Dmg * Ratio) end};
        false -> #action_effect_func{}
    end,
    OtherCost1 = case Shp >= ShpMax * ShpRatio2 /100 of
        true -> 
            CostHp = util:check_range(HpCost, 0, Shp-1),
            [{hp, CostHp}|lists:keydelete(hp, 1, OtherCost)];
        false ->
            OtherCost
    end,
    ?parent:attack(Skill#c_skill{other_cost = OtherCost1}, Self, Target, ActionEffectFunc);

handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).

