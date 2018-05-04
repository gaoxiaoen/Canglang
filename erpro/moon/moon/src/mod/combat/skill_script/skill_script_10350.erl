%%----------------------------------------------------
%%
%% 夫妻技能，若施放技能时夫妻另一方配合施放，则造成伤害为自身攻击*[值1]+另一方攻击*[值2]，若另一方被控制或者不在场，则伤害为自身攻击*[值1]          
%%
%% args = [值1,值2]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10350).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [DmgRatio1, DmgRatio2]}, Self = #fighter{attr = #attr{dmg_min = SelfDmgMin, dmg_max = SelfDmgMax}, partner = PartnerId, group = Group}, Target) ->
    {PartnerDmgMin, PartnerDmgMax} = case combat:f(by_rid, Group, PartnerId) of
        false -> {0, 0};
        #fighter{is_die = ?false, is_stun = ?false, is_taunt = ?false, is_silent = ?false, is_sleep = ?false, is_stone = ?false, is_escape = ?false, attr = #attr{dmg_min = PdmgMin, dmg_max = PdmgMax}} -> {PdmgMin, PdmgMax};
        _ -> {0, 0}
    end,
    RealDmgMin = round(SelfDmgMin * DmgRatio1/100 + PartnerDmgMin * DmgRatio2/100),
    RealDmgMax = round(SelfDmgMax * DmgRatio1/100 + PartnerDmgMax * DmgRatio2/100),
    DmgAverage = round((RealDmgMin + RealDmgMax) /2),
    ?parent:attack(Skill, Self, Target, #action_effect_func{dmg_adjust = fun(_) -> DmgAverage end});

handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).

