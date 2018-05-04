%%----------------------------------------------------
%%
%% 被动技能，任何攻击，有可能会对目标释放buff
%%
%% args = []
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_210160).
-export([
    handle_passive/5
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

%% 被动 
handle_passive(after_hit, {AttackType, Dmg, IsHit},
        _Skill = #c_skill{id = SkillId, name = _SkillName, buff_target = BuffTarget, args = _Args}, 
        #fighter{name = _Sname, id = Sid}, 
        #fighter{pid = Tpid}) ->
    %%
    %{_, Self = #fighter{id = Sid, type = Stype}} = combat:f(by_pid, Spid),
    {_, Target = #fighter{is_nopassive = IsNoPassive}} = combat:f(by_pid, Tpid),
    case IsNoPassive =:= ?false of
        %andalso util:rand(1, 1000) =< HitRate * 10000 of
        true ->
            lists:foreach(fun(Buff) -> 
                case combat_script_buff:do_add_buff(Buff, Target, Target) of
                    true ->
                        ?log("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
                        %% combat:add_sub_play(combat:gen_sub_play(passive, Self, Self, Skill));
                        combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_hit);
                    _ -> ignore
                end
            end, BuffTarget);
        _ ->
            ignore
    end,
    {AttackType, Dmg, IsHit};

handle_passive(_State, Args, _Skill, _Self, _Target) ->
    Args.
