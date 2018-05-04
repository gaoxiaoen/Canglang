%%----------------------------------------------------
%%
%% 角色攻击动作前触发精灵守护化形攻击
%%
%% args = []
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10600).
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
handle_passive(demon_attack, Args = {#c_skill{times = Times, target = enemy, script_id = ScriptId}},
        Skill = #c_skill{id = SkillId, name = _SkillName, args = [Rate]}, 
        Self = #fighter{id = Sid, name = _Sname, pid = Spid}, 
        Target) when Times>0 andalso ScriptId =/= 10060 andalso ScriptId =/= 10070 ->
    %%
    %% 灵动技能加概率
    PassiveSkills = case combat:f_ext(by_pid, Spid) of
        #fighter_ext_role{passive_skills = L} -> L;
        _ -> []
    end,
    RateAdd= case combat:f(by_scriptid, PassiveSkills, 10640) of
        #c_skill{args = [Val]} -> Val;
        _ -> 0 
    end,
    ?DEBUG("灵动加 ~w", [RateAdd]),
    case util:rand(1, 100) =< round(Rate * (1 + RateAdd / 100)) of
        true ->
            ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
            combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_before),
            ?parent:demon_attack(Skill, Self, Target);
        false -> ok
    end,
    Args;
handle_passive(_State, Args, _Skill, _Self, _Target) ->
    Args.
