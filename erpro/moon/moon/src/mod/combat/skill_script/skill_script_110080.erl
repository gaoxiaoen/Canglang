%%----------------------------------------------------
%%
%% 对目标施放buff
%%
%% args = []
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_110080).
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
    ?parent:cast(Skill, Self, Target).


