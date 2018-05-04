%%----------------------------------------------------
%%
%% 被攻击时，有[几率]%几率减少[百分比]%的伤害 
%%
%% args = [几率，百分比]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_200210).
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
%% -> {HpDmg, DmgMp}
handle_passive(reduce_dmg, {DmgHp, DmgMp, IsHit, IsMiss},
        #c_skill{id = SkillId, name = _SkillName, args = [Rate, Percent]}, 
        #fighter{id = _Sid},
        _Target = #fighter{id = Tid, name = _Tname}) ->
    %% 
    case util:rand(1, 1000) =< Rate * 10 of
        true -> 
            ?log("[~s]的被动技能[~s]触发", [_Tname, _SkillName]),
            %%combat:add_sub_play(combat:gen_sub_play(passive, Self, Self, Skill)),
            combat:add_to_show_passive_skills(Tid, SkillId, ?show_passive_skills_hit),
            NewDmgHp = round(DmgHp - DmgHp * Percent / 100),
            {erlang:max(0, NewDmgHp), DmgMp, IsHit, IsMiss};
        false -> 
            {DmgHp, DmgMp, IsHit, IsMiss}
    end;
handle_passive(_State, Args, _Skill, _Self, _Target) ->
    Args.
