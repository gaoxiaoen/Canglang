%%----------------------------------------------------
%%
%% 单体技能命中时，有[几率]%对其他所有单位造成原伤害的[百分比]%的伤害
%%
%% args = [几率，百分比]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_20010).
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
    ?parent:attack(Skill, Self, Target).


