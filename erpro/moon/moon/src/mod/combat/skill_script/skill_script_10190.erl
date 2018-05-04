%%----------------------------------------------------
%%
%% 转换[防御*防御转换百分比*防御转换攻击系数]为攻击    
%%
%% args = [防御转换百分比，防御转换攻击系数]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10190).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [Param1, Param2]}, 
    Self = #fighter{attr = #attr{defence = Def}},
    Target
) ->
    Val = round(Def * Param1 * Param2 / 100),
    ?parent:attack(Skill, Self, Target, #action_effect_func{dmg_adjust = fun([Dmg]) -> Dmg + Val end});

handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).

