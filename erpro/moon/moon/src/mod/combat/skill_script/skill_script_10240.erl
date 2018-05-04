%%----------------------------------------------------
%%
%% 自身回复攻击造成伤害的[值]%的气血          
%%
%% args = [值]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10240).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [Param1]}, Self, Target) ->
    ?parent:attack(Skill, Self, Target, #action_effect_func{restore_self_hp = fun([Dmg]) -> round(Dmg * Param1 / 100) end});

handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).

