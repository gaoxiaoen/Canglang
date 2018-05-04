%%----------------------------------------------------
%%
%% 附加[基础值+角色自身等级*等级转换系数]的法术伤害，无视仙宠护主          
%%
%% args = [基础值，等级转换系数]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10300).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [BaseVal, LevRatio]}, Self = #fighter{lev = Lev}, Target) ->
    ?parent:attack(Skill#c_skill{dmg_magic = round(BaseVal + Lev * LevRatio)}, Self, Target, #action_effect_func{can_pet_protect = false});

handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).

