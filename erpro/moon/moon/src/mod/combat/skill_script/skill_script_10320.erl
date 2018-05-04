%%----------------------------------------------------
%%
%% 燃烧目标[值]%的魔法，附加[基础值+精神*精神转换系数]的法术伤害，无视仙宠护主    
%%
%% args = [值，基础值，精神转换系数]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10320).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{dmg_magic = OldDmgMagic, args = [_MpRatio, BaseVal, JsRatio]}, Self = #fighter{attr = #attr{js = Js}}, Target = #fighter{type = ?fighter_type_npc}) ->
    Js1 = case Js > 11000 of
        true -> 11000 + (Js - 11000)/5;
        false -> Js
    end,
    ?parent:attack(Skill#c_skill{dmg_magic = round(OldDmgMagic + BaseVal + Js1 * JsRatio)}, Self, Target, #action_effect_func{can_pet_protect = false});

handle_active(Skill = #c_skill{dmg_magic = OldDmgMagic, args = [MpRatio, BaseVal, JsRatio]}, Self = #fighter{attr = #attr{js = Js}}, Target = #fighter{mp_max = MpMax}) ->
    ?parent:attack(Skill#c_skill{dmg_magic = round(OldDmgMagic + BaseVal + Js * JsRatio)}, Self, Target, #action_effect_func{dmg_mp = fun(_) -> round(MpMax * MpRatio / 100) end, can_pet_protect = false});

handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).

