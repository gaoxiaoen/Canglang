%%----------------------------------------------------
%%
%% 攻击伤害提高[防御*防御转换系数/100]%          
%%
%% args = [防御转换系数]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10280).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [Param1], dmg_ratio = SkDmgRatio}, Self = #fighter{attr = #attr{defence = Defence}}, Target) ->
    FinalDefence = case Defence > 45000 of
        true -> 45000 + (Defence - 45000)/5;
        false -> Defence
    end,
    Rat = 1 + FinalDefence * Param1 / 10000,
    Ratio = case Rat > 3.4 of
        true -> 3.4;
        false -> Rat
    end,
    ?parent:attack(Skill#c_skill{dmg_ratio = round(SkDmgRatio * Ratio)}, Self, Target);

handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).

