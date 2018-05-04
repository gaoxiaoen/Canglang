%%----------------------------------------------------
%%
%% 治疗目标[基础值+精神*精神转换系数]气血 
%%
%% args = [基础值，精神转换系数]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10110).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [Param1, Param2]}, Self, Target) ->
    #fighter{attr = #attr{js = Js}} = Self,
    Js1 = case Js > 8500 of
        true -> 8500 + (Js - 8500)/5;
        false -> Js
    end,
    HealHp = Param1 + round(Param2 * Js1),
    ?parent:heal(Skill, Self, Target, HealHp);

handle_active(Skill, Self, Target) ->
    ?parent:heal(Skill, Self, Target, 0).


