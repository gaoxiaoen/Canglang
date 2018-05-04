%%----------------------------------------------------
%%
%% 回复目标[值]%法力          
%%
%% args = [值]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10370).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [MpRatio]}, Self = #fighter{mp_max = MpMax}, Target) ->
    HealMp = round(MpMax * MpRatio / 100),
    ?parent:heal_mp(Skill, Self, Target, HealMp);

handle_active(Skill, Self, Target) ->
    ?parent:heal_mp(Skill, Self, Target, 0).

