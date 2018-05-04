%%----------------------------------------------------
%%
%% 攻击力变为对方的[值1]%攻击+自身的[值2]%的攻击，无视仙宠护主          
%%
%% args = [值1,值2]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10340).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [DmgRatio1, DmgRatio2]}, Self = #fighter{attr = #attr{dmg_min = SelfDmgMin, dmg_max = SelfDmgMax}}, Target = #fighter{attr = #attr{dmg_min = TargetDmgMin, dmg_max = TargetDmgMax}}) ->
    SelfDmgAverage = round((SelfDmgMin + SelfDmgMax)/2),
    TargetDmgAverage = round((TargetDmgMin + TargetDmgMax)/2),
    DmgAverage = erlang:min(TargetDmgAverage * DmgRatio1 / 100, SelfDmgAverage*2) + SelfDmgAverage * DmgRatio2 / 100,
    ?parent:attack(Skill, Self, Target, #action_effect_func{dmg_adjust = fun(_) -> DmgAverage end, can_pet_protect = false});

handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).

