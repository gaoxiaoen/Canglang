%%----------------------------------------------------
%%
%% [触发几率]%几率附加角色攻击的[攻击百分比]%攻击玩家攻击的目标
%%
%% args = []
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10610).
-export([
    handle_active/3
    ,handle_passive/5
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(_Skill, _Self, _Target) ->
    ignore.

%% 被动 
%% -> {AttackType}
handle_passive(talisman_attack, Args = {#c_skill{times = Times, target = enemy, script_id = ScriptId}},
        Skill = #c_skill{id = SkillId, name = _SkillName, args = [Rate, _DmgRatio]},
        Self = #fighter{id = Sid, name = _Sname, attr = #attr{dmg_min = _DmgMin, dmg_max = _DmgMax}}, 
        Target) when Times>0 andalso ScriptId =/= 10060 andalso ScriptId =/= 10070 ->
    %%
    case util:rand(1, 100) =< Rate of
        true ->
            ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
            combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_before),
            %TalismanDmg = round((DmgMin + DmgMax)/2 * DmgRatio / 100),
            %?parent:talisman_attack(Skill, Self, Target, TalismanDmg);
            ?parent:talisman_attack(Skill, Self, Target);
        false -> ok
    end,
    Args;
handle_passive(_State, Args, _Skill, _Self, _Target) ->
    Args.
