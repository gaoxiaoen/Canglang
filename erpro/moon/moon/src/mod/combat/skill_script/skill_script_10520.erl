%%----------------------------------------------------
%%
%% 命中目标时一定几率额外附加一定伤害 
%%
%% args = []
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10520).
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
handle_passive(raise_dmg, {Dmg},
        #c_skill{id = SkillId, name = _SkillName, args = [HitRate, BaseVal, AddVal]}, 
        #fighter{id = Sid, name = _Sname}, 
        _Target) ->
    %%
    NewDmg = case util:rand(1, 100) =< HitRate of
        true ->
            %% ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
            combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_before),
            round(Dmg * (1 + BaseVal / 100)) + AddVal;
        false -> Dmg
    end,
    {NewDmg};
handle_passive(_State, Args, _Skill, _Self, _Target) ->
    Args.
