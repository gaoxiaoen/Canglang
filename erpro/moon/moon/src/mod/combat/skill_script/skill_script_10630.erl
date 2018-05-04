%%----------------------------------------------------
%%
%% 命中对对方施加buff -> list()
%%
%% args = []
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10630).
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
handle_passive(buff_target_on_attack, Args,
        Skill = #c_skill{id = SkillId, name = _SkillName, args = [Rate], buff_target = _BuffTarget},
        #fighter{id = Sid, pid = Spid, name = _Sname}, 
        #fighter{pid = Tpid}) ->
    %%
    {_, _Self = #fighter{type = Stype}} = combat:f(by_pid, Spid),
    {_, _Target = #fighter{id = Tid, is_nopassive = IsNoPassive}} = combat:f(by_pid, Tpid),
    case IsNoPassive of
        ?true -> 
            Args;
        _ ->
            case Stype=:=?fighter_type_role andalso combat:is_skill_in_cooldown(Tid, Skill)=:=true of
                true -> 
                    Args;
                false ->
                    case util:rand(1, 100) =< Rate of
                        true ->
                            ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
                            combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_before),
                            Args;
                        false -> 
                            Args
                    end
            end
    end;
handle_passive(_State, Args, _Skill, _Self, _Target) ->
    Args.
