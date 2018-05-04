%%----------------------------------------------------
%%
%% 附加[基础值+精神*精神转换系数]的法术伤害 
%%
%% args = [基础值，精神转换系数]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10150).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [Param1, Param2]}, Self = #fighter{attr = #attr{js = Js}}, Target) ->
    Js1 = case Js >= 11000 of
        true -> 11000 + (Js - 11000)/5;
        false -> Js
    end,
    ?parent:attack(Skill#c_skill{dmg_magic = round(Param1 + Param2 * Js1)}, Self, Target);

handle_active(_Skill, _Self, _Target) ->
    ok.

