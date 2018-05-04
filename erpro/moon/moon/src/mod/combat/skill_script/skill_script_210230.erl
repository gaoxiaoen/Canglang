%%----------------------------------------------------
%%
%% 当受到一次伤害高于剩余血量的攻击时，触发buff
%%
%% args = []
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_210230).
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
handle_passive(before_dmg, Args = {Dmg},
        Skill = #c_skill{id = SkillId, name = _SkillName, args = [Rate], buff_target = _BuffTarget, buff_self = BuffSelf}, 
        #fighter{id = _Sid, pid = _Spid, name = _Sname}, 
        #fighter{pid = Tpid, id = Tid}) ->
    %%
    {_, Target = #fighter{hp = Hp}} = combat:f(by_pid, Tpid),
    case Dmg > Hp of
        true ->
            case util:rand(1, 1000) =< Rate * 10
            andalso not combat:is_skill_in_cooldown(Tid, Skill) of
                true ->
                    combat:add_to_skill_cooldown(Tid, SkillId),
                    ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
                    combat:add_to_show_passive_skills(Tid, SkillId, ?show_passive_skills_hit),
                    lists:foreach(fun(Buff) -> 
                            combat:buff_add(Buff, Target, Target)
                    end, BuffSelf);
                _ ->
                    ignore
            end;
        _ ->
            ignore
    end,
    Args;
    
handle_passive(_State, Args, _Skill, _Self, _Target) ->
    Args.
