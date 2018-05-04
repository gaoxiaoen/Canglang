%%----------------------------------------------------
%%
%% 治疗目标[基础值+精神*精神转换系数]%气血 
%%
%% args = [基础值，精神转换系数]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10130).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [Param1, Param2]}, Self = #fighter{hp_max = HpMax, attr = #attr{js = Js}}, #fighter{pid = Tpid}) ->
    case combat:f(by_pid, Tpid) of
        {_, Target} ->
            ?parent:heal(Skill, Self, Target, round(HpMax * (Param1 + Param2 * Js)/100));
        false -> ok
    end;

handle_active(Skill, Self, Target) ->
    ?parent:heal(Skill, Self, Target, 0).


