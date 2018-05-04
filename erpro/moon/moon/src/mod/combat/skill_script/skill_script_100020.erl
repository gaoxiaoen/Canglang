%%----------------------------------------------------
%%
%% 保护、防御
%%
%% args = []
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_100020).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{}, Self = #fighter{id = Sid}, Target = #fighter{id = Tid}) ->
    case Sid =:= Tid of
        true ->
            ?parent:defence(Skill, Self, Target);
        false ->
            ?parent:protect(Skill, Self, Target)
    end,
    ok;
handle_active(Skill, Self, Target) ->
    ?parent:defence(Skill, Self, Target).


