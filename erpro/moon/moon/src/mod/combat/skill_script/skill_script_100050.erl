%%----------------------------------------------------
%%
%% 逃跑
%%
%% args = []
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_100050).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{}, Self = #fighter{id = _Sid}, Target = #fighter{id = _Tid}) ->
    ?parent:escape(Skill, Self, Target).


