%%----------------------------------------------------
%%
%% 被命中触发buff类 
%%
%% args = []
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10500).
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
%% -> {Dmg}
handle_passive(be_hit, {AttackType, Dmg, IsHit},
        Skill = #c_skill{id = SkillId, name = _SkillName, buff_self = BuffSelf, buff_target = BuffTarget, args = [HitRate]}, 
        #fighter{pid = Spid}, 
        #fighter{pid = Tpid}) ->
    %%
    {_, Self = #fighter{id = Sid, type = Stype}} = combat:f(by_pid, Spid),
    {_, Target = #fighter{id = Tid, is_nopassive = IsNoPassive}} = combat:f(by_pid, Tpid),
    case IsNoPassive  of
        ?true ->
            ignore;
        ?false ->
            case Stype=:=?fighter_type_role andalso combat:is_skill_in_cooldown(Tid, Skill)=:=true of
                true -> 
                    ignore;
                false ->
                    case util:rand(1, 1000) =< HitRate * 10 of
                        true ->
                            erlang:put({script_10500, Tpid}, false),
                            %%?DEBUG("尝试给[~s]添加BUFF", [_Sname]),
                            lists:foreach(fun(Buff) -> 
                                        case combat_script_buff:do_add_buff(Buff, Self, Self) of
                                            true -> erlang:put({script_10500, Tpid}, true);
                                            false -> ignore
                                        end
                                end, BuffSelf),
                            %% ?DEBUG("尝试给[~s]添加BUFF", [_Tname]),
                            lists:foreach(fun(Buff) -> 
                                        case combat_script_buff:do_add_buff(Buff, Self, Target) of
                                            true -> erlang:put({script_10500, Tpid}, true);
                                            false -> ignore
                                        end
                                end, BuffTarget),
                            case erlang:get({script_10500, Tpid}) of
                                true -> 
                                    %% ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
                                    %% combat:add_sub_play(combat:gen_sub_play(passive, Self, Self, Skill));
                                    combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_hit);
                                false -> ignore
                            end,
                            put({script_10500, Tpid}, undefined),
                            combat:add_to_skill_cooldown(Sid, SkillId);
                        false -> 
                            ignore
                    end;
                _ ->
                    ignore
            end
    end,
    {AttackType, Dmg, IsHit};

handle_passive(_State, Args, _Skill, _Self, _Target) ->
    Args.
