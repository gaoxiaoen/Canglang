%%----------------------------------------------------
%%
%% 附加[基础值+命中*命中转换系数]的法术伤害，无视仙宠护主          
%%
%% args = [基础值，命中转换系数]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10330).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [BaseVal, HitRateRatio]}, Self = #fighter{attr = #attr{hitrate = HitRate}}, Target) ->
    HitRate1 = case HitRate > 3000 of
        true -> 3000 + (HitRate - 3000)/5;
        false -> HitRate
    end,
    ?parent:attack(Skill#c_skill{dmg_magic = round(BaseVal + HitRate1 * HitRateRatio)}, Self, Target, #action_effect_func{can_pet_protect = false});

handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).

