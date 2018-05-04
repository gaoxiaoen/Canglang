%%----------------------------------------------------
%%
%% 附加[基础值+攻击*攻击转换系数]的法术伤害，若自身气血不低于[气血百分比]%，则自身气血损耗    
%%
%% args = [基础值，攻击转换系数，气血百分比，气血损耗比]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10380).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{dmg_magic = OldDmgMagic, args = [BaseVal, DmgRatio, HpRatio, HpCostRatio], other_cost = OtherCost}, Self = #fighter{hp_max = ShpMax, hp = Shp, attr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}}, Target) ->
    OtherCost1 = case Shp >= ShpMax * HpRatio /100 of
        true -> 
            CostHp = util:check_range(round(ShpMax*HpCostRatio/100), 0, Shp-1),
            [{hp, CostHp}|lists:keydelete(hp, 1, OtherCost)];
        false ->
            OtherCost
    end,
    Avg = (DmgMin + DmgMax)/2,
    DmgAverage = case Avg =< 40000 of
        true -> Avg;
        false -> (Avg - 40000)/10 + 40000
    end,
    ?parent:attack(Skill#c_skill{dmg_magic = round(OldDmgMagic + BaseVal + DmgAverage * DmgRatio), other_cost = OtherCost1}, Self, Target);


handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).

