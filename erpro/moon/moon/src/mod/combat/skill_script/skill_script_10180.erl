%%----------------------------------------------------
%%
%% 复活并恢复其[基础值+精神*精神转换系数]气血    
%%
%% args = [基础值，精神转换系数]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10180).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [Param1, Param2]}, Self = #fighter{attr = #attr{js = Js}}, Target = #fighter{pid = Tpid, is_die = IsDie}) ->
    case IsDie of
        ?true ->
            combat:update_fighter(Tpid, [{is_die, ?false}]),
            Js1 = case Js > 11000 of
                true -> 11000 + (Js - 11000)/5;
                false -> Js
            end,
            ?parent:heal(Skill, Self, Target#fighter{is_die = ?false}, round(Param1 + Param2 * Js1)),
            ok;
        ?false -> ok
    end;

handle_active(_Skill, _Self, _Target) ->
    ok.

