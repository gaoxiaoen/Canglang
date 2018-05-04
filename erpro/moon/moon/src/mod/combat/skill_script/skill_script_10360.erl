%%----------------------------------------------------
%%
%% 攻击附加[基础值+气血*气血转换系数]的法术伤害          
%%
%% args = [基础值，气血转换系数]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10360).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{dmg_magic = OldDmgMagic, args = [BaseVal, HpRatio]}, Self = #fighter{hp = Hp}, Target) ->
    ?parent:attack(Skill#c_skill{dmg_magic = round(OldDmgMagic + BaseVal + Hp * HpRatio)}, Self, Target);

handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).

