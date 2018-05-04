%%----------------------------------------------------
%%
%%  命中目标时一定几率触发追击(被动)
%%
%% args = [机率, 追击次数]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10510).
-export([
    handle_active/3
    ,passive_after_active/4
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(_Skill, _Self, _Target) ->
    ignore.

%% 主动攻击后触发
passive_after_active(_ActiveSkill, #c_skill{id = SkillId, name = _SkillName, args = [HitRate, AddTimes]},  Self = #fighter{id = Sid, name = _Sname, pid = Spid}, _Target = #fighter{pid = Tpid}) ->
    case util:rand(1, 100) =< HitRate of
        true -> 
            %% ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
            combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_before),
            NormalAttackSkill = combat:get_normal_attack_skill(Self),
            util:for(1, AddTimes, fun(_) ->
                        combat:do_skill(1, NormalAttackSkill, Spid, Tpid),
                        combat:commit_play()
                end);
        false -> 
            ignore
    end;
passive_after_active(_ActiveSkill, _PassiveSkill, _Self, _Target) ->
    ignore.
