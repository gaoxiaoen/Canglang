%%----------------------------------------------------
%%
%% 玩家受到伤害时[触发几率]%几率减免受到的伤害的[减免百分比]% 
%%
%% args = []
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10620).
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
        #c_skill{id = SkillId, name = _SkillName, args = [Rate, ReduceRatio]}, 
        #fighter{id = Sid, name = _Sname},
        _Target) ->
    %% 
    DmgHp1 = case util:rand(1, 100) =< Rate of
        true ->
            ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
            combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_hit),
            case ReduceRatio > 0 of
                true -> util:check_range(round(DmgHp * (100 - ReduceRatio)/100), 0, DmgHp);
                false -> DmgHp
            end;
        false -> DmgHp
    end,
    {DmgHp1, DmgMp, IsHit, IsMiss};
handle_passive(_State, Args, _Skill, _Self, _Target) ->
    Args.
