%%----------------------------------------------------
%%
%% 当目标气血小于[HP百分比]时伤害增加[基础值+攻击*攻击转换系数]%          
%%
%% args = [HP百分比，基础值，攻击转换系数]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10290).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [HpRatio, BaseVal, Param1]}, Self = #fighter{attr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}}, Target = #fighter{hp = Thp, hp_max = ThpMax}) ->
    Avg = (DmgMin + DmgMax) /2,
    DmgAverage = case Avg > 22000 of
        true -> 22000 + (Avg-22000)/8;
        false -> Avg
    end,
    case (Thp * 100) =< (HpRatio * ThpMax) of
        true ->
            Rat = BaseVal + Param1 * DmgAverage,
            DmgRatio = case Rat > 240 of
                true -> 3.4;
                false -> 1 + (BaseVal + Param1 * DmgAverage)/100
            end,
            ?parent:attack(Skill, Self, Target, #action_effect_func{dmg_adjust = fun([Dmg]) -> round(Dmg * DmgRatio) end});
        false -> ?parent:attack(Skill, Self, Target)
    end;

handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).

