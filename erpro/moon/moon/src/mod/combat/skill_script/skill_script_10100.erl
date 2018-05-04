%%----------------------------------------------------
%%
%% 直接加暴击
%%
%% args = [附加暴击]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10100).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [Param1]}, Self, Target) ->
    #fighter{attr = Attr = #attr{critrate = Crit}} = Self,
    ?parent:attack(Skill, Self#fighter{attr = Attr#attr{critrate = Crit + Param1}}, Target);
handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).


