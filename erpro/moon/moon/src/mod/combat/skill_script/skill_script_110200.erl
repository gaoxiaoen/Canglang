%%----------------------------------------------------
%%
%% 造成[攻击*攻击系数+防御*防御系数]的伤害，给目标加buff
%%
%% args = [攻击系数，防御系数]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_110200).
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
        Skill = #c_skill{args = [DmgC, DefC], buff_target = _BuffTarget}, 
        Self = #fighter{attr = #attr{defence = Defence}}, 
        Target = #fighter{}) ->
    %%
    ?parent:attack(
            Skill, 
            Self, 
            Target, 
            #action_effect_func{dmg_before_crit = fun([Dmg]) ->
                round(Dmg * DmgC + Defence * DefC)
            end}
    ),
    %lists:foreach(fun(Buff) -> combat_script_buff:do_add_buff(Buff, Self, Target) end, BuffTarget),
    ok;

handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).


