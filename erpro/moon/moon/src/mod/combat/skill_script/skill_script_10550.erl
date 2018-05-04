%%----------------------------------------------------
%%
%% [触发几率]%几率反弹受到伤害的[反弹伤害的百分比]%
%%
%% args = []
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10550).
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
handle_passive(feedback_dmg, Args = {Dmg, IsHit, _FeedbackDmg},
        #c_skill{name = _SkillName, args = [HitRate, BaseVal]}, 
        _Self = #fighter{pid = _Spid}, 
        _Target = #fighter{pid = _Tpid}) ->
    %%
    case util:rand(1, 100) =< HitRate of
        true ->
            %% ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
            {Dmg, IsHit, round(Dmg * BaseVal/100)};
        false -> 
            Args
    end;
handle_passive(_State, Args, _Skill, _Self, _Target) ->
    Args.

