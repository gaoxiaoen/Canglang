%%----------------------------------------------------
%%
%% 攻击伤害提高[攻击*攻击转换系数]%，若自身气血不低于[气血百分比]%，则自身气血损耗[气血损耗比]%    
%%
%% args = [攻击转换系数，气血百分比，气血损耗比]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10400).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [DmgRatio, HpRatio, HpCostRatio], other_cost = OtherCost, dmg_ratio = SkDmgRatio}, Self = #fighter{hp_max = ShpMax, hp = Shp, attr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}}, Target) ->
    Avg = (DmgMin + DmgMax)/2,
    DmgAverage = case Avg > 22000 of
        true -> 22000 + (Avg-22000)/8;
        false -> Avg
    end,
    Rat = 1 + DmgAverage * DmgRatio / 100,
    Ratio = case Rat > 3.4 of
        true -> 3.4;
        false -> Rat
    end,
    OtherCost1 = case Shp >= ShpMax * HpRatio /100 of
        true -> 
            CostHp = util:check_range(round(ShpMax*HpCostRatio/100), 0, Shp-1),
            [{hp, CostHp}|lists:keydelete(hp, 1, OtherCost)];
        false ->
            OtherCost
    end,
    ?parent:attack(Skill#c_skill{dmg_ratio = round(SkDmgRatio * Ratio), other_cost = OtherCost1}, Self, Target);

handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).

