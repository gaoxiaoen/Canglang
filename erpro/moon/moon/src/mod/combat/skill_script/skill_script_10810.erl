%%----------------------------------------------------
%%
%% 怒气技能：治疗百分比血气
%%
%% args = [HpRatio]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10810).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [HpRatio]}, Self = #fighter{hp_max = HpMax}, _Target) ->
    HealHp = round(HpMax * HpRatio / 100),
    HealHp1 = ?parent:anger_calc_effect(HealHp, Self),
    ?parent:heal(Skill, Self, Self, HealHp1);
handle_active(Skill, Self, Target) ->
    ?parent:heal(Skill, Self, Target, 0).


