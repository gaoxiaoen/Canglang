%%----------------------------------------------------
%%
%% 附加[基础值+攻击*攻击转换系数]的法术伤害          
%%
%% args = [基础值，攻击转换系数]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10250).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [Param1, Param2]}, Self = #fighter{attr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}}, Target) ->
    Avg = (DmgMin + DmgMax)/2,
    DmgAverage = case Avg =< 40000 of
        true -> Avg;
        false -> (Avg - 40000)/10 + 40000
    end,
    ?parent:attack(Skill#c_skill{dmg_magic = round(Param1 + Param2 * DmgAverage)}, Self, Target);

handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).

