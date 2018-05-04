%%----------------------------------------------------
%%
%% 使用蓝瓶
%%
%% args = []
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_100040).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(_Skill = #c_skill{}, _Self = #fighter{id = _Sid}, _Target = #fighter{id = _Tid}) ->
    ok;
handle_active(_Skill, _Self, _Target) ->
    ok.


