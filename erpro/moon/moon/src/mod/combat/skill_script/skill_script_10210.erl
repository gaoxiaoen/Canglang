%%----------------------------------------------------
%%
%% 治疗目标[值]%气血    
%%
%% args = [值]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10210).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [Param1]}, Self, Target = #fighter{hp_max = HpMax}) ->
    HealHp = round(HpMax * Param1 / 100),
    ?parent:heal(Skill, Self, Target, HealHp);

handle_active(Skill, Self, Target) ->
    ?parent:heal(Skill, Self, Target, 0).
