%%----------------------------------------------------
%%
%% 当自身HP小于[HP百分比]时伤害增加[基础值+攻击*攻击转换系数]% 
%%
%% args = [HP百分比，基础值，攻击转换系数]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10170).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [Param1, Param2, Param3]}, Self = #fighter{attr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}, hp = Hp, hp_max = HpMax}, Target) ->
    Avg = (DmgMin + DmgMax)/2,
    DmgAverage = case Avg > 22000 of
        true -> 22000 + (Avg - 22000)/8;
        false -> Avg
    end,
    case (Hp * 100) < (HpMax * Param1) of
        true ->
            Rat = 1 + (Param2 + Param3 * DmgAverage)/100,
            Ratio = case Rat > 3.4 of
                true -> 3.4;
                false -> Rat
            end,
            ?parent:attack(Skill, Self, Target, #action_effect_func{dmg_before_crit = fun([Dmg]) -> round(Dmg * Ratio) end});
        false -> ?parent:attack(Skill, Self, Target)
    end;

handle_active(_Skill, _Self, _Target) ->
    ok.

