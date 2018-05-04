%%----------------------------------------------------
%%
%% 受到伤害时[触发几率]%几率减免受到的法术伤害的[减免百分比]% 
%%
%% args = []
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10570).
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
%% -> {ratio, Val} | {val, Val}
handle_passive(reduce_magic_dmg, _Args,
        #c_skill{id = SkillId, name = _SkillName, args = [HitRate, ReduceRatio, ReduceVal]},
        _Self = #fighter{id = Sid, name = _Sname},
        _Target) ->
    %%
    case util:rand(1, 100) =< HitRate of
        true ->
            ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
            combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_hit),
            case ReduceRatio > 0 of
                true -> {ratio, ReduceRatio};
                false -> {val, ReduceVal}
            end;
        false -> {val, 0}
    end;
handle_passive(_State, Args, _Skill, _Self, _Target) -> 
    Args.
