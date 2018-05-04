%%----------------------------------------------------
%%
%% 攻击伤害提高[攻击*攻击转换系数]% 
%%
%% args = [攻击转换系数]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10160).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [Param1], dmg_ratio = SkDmgRatio}, Self = #fighter{attr = Attr = #attr{dmg_min = DmgMin, dmg_max = DmgMax, critrate = Crit}}, Target) ->
    Avg = (DmgMin + DmgMax)/2,
    DmgAverage = case Avg > 22000 of
        true -> 22000 + (Avg-22000)/8;
        false -> Avg
    end,
    Crit1 = case DmgAverage > 13000 of
        true -> util:check_range(Crit, 0, Crit - 100);
        false -> Crit
    end,
    Rat = 1 + DmgAverage * Param1 / 100,
    Ratio = case Rat > 3.4 of
        true -> 3.4;
        false -> Rat
    end,
    ?parent:attack(Skill#c_skill{dmg_ratio = round(SkDmgRatio * Ratio)}, Self#fighter{attr = Attr#attr{critrate = Crit1}}, Target);

handle_active(_Skill, _Self, _Target) ->
    ok.

