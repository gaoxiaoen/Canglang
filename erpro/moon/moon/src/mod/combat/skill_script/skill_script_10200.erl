%%----------------------------------------------------
%%
%% 被攻击方无法对这次攻击进行反击    
%%
%% args = []
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10200).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill, Self, Target) -> 
    ?parent:attack(Skill, Self, Target, #action_effect_func{anti_attack_before = fun(_) -> 0 end}).


