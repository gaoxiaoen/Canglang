%%----------------------------------------------------
%%
%% 造成[攻击*攻击系数+暴击*暴击系数]的伤害，对目标释放buff
%%
%% args = [攻击系数，暴击系数]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_110150).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(
        Skill = #c_skill{args = [DmgC, CritC], buff_target = _BuffTarget}, 
        Self = #fighter{attr = #attr{critrate = Critrate}}, 
        Target = #fighter{}) ->
    ?parent:attack(
            Skill, 
            Self, 
            Target, 
            #action_effect_func{dmg_before_crit = fun([Dmg]) ->
                FinalDmg = round(Dmg * DmgC + Critrate * CritC),
                ?log("Dmg=~p, DmgC=~p, Critrate=~p, CritC=~p, FinalDmg=~p", [Dmg, DmgC, Critrate, CritC, FinalDmg]),
                FinalDmg
            end}
    ),
    ok;

handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).


