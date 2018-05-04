%%----------------------------------------------------
%%
%% 攻击伤害提高[命中*命中转换系数]%          
%%
%% args = [命中转换系数]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10270).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [Param1], dmg_ratio = SkDmgRatio}, Self = #fighter{attr = #attr{hitrate = HitRate}}, Target) ->
    FinalHitRate = case HitRate > 1000 of
        true -> 1000 + (HitRate-1000)/5;
        false -> HitRate
    end,
    Rat = 1 + FinalHitRate * Param1 / 100,
    Ratio = case Rat > 3.4 of
        true -> 3.4;
        false -> Rat
    end,
    ?parent:attack(Skill#c_skill{dmg_ratio = round(SkDmgRatio * Ratio)}, Self, Target);

handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).

