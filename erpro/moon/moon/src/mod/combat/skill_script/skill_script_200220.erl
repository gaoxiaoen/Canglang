%%----------------------------------------------------
%%
%% 格挡成功时，有[几率]%几率对攻击者造成[攻击*攻击系数]的伤害
%%
%% args = [几率，攻击系数]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_200220).
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
        #c_skill{id = SkillId, name = _SkillName, args = [Rate, DmgC]}, 
        _Self = #fighter{pid = _Spid, name = _Sname}, 
        _Target = #fighter{pid = _Tpid, id = Tid, name = _Tname}) ->
    %%
    case IsHit of
        ?true ->
            Args;
        ?false -> %% 格档成功
            case util:rand(1, 100) =< Rate of
                true ->
                    %% ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
                    ?log("[~s]的被动技能[~s]触发", [_Tname, _SkillName]),
                    combat:add_to_show_passive_skills(Tid, SkillId, ?show_passive_skills_hit),
                    {Dmg, IsHit, round(Dmg * DmgC)};
                false ->
                    Args
            end
    end;    
handle_passive(_State, Args, _Skill, _Self, _Target) ->
    Args.

