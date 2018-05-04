%%----------------------------------------------------
%%
%% %% 受到伤害时[触发几率]%的几率减免受到[伤害属性类别]伤害的[减免百分比]% 
%%
%% args = []
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10530).
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
    ok.

%% 被动 
%% -> {HpDmg, DmgMp}
handle_passive(reduce_dmg, {DmgHp, DmgMp, IsHit, IsMiss},
        #c_skill{id = SkillId, name = _SkillName, args = [HitRate, HpRatio, BaseVal]}, 
        #fighter{id = Sid, name = _Sname, hp_max = ShpMax, hp = Shp, mp = Tmp},
        _Target) ->
    %% 
    case (Shp * 100) =< (HpRatio * ShpMax) of
        true ->
            case util:rand(1, 100) =< HitRate of
                true -> 
                    %% ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
                    %%combat:add_sub_play(combat:gen_sub_play(passive, Self, Self, Skill)),
                    combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_hit),
                    HpDmg = round(DmgHp - (Tmp - DmgMp) * BaseVal),
                    case HpDmg <0 of 
                        true -> {0, round(DmgHp/BaseVal) + DmgMp, IsHit, IsMiss};
                        false -> {HpDmg, round((DmgHp - HpDmg)/BaseVal) + DmgMp, IsHit, IsMiss}
                    end;
                false -> {DmgHp, DmgMp, IsHit, IsMiss}
            end;
        false -> {DmgHp, DmgMp, IsHit, IsMiss}
    end;

handle_passive(reduce_dmg, {DmgHp, DmgMp, IsHit, IsMiss},
        #c_skill{id = SkillId, name = _SkillName, args = [HitRate, AttackType, ReduceRatio, ReduceVal]},
        #fighter{id = Sid, name = _Sname},
        _Target = #fighter{career = Career}) ->
    %%
    case AttackType =:= Career of
        true ->
            case util:rand(1, 1000) =< HitRate * 10 of
                true -> 
                    %% ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
                    %%combat:add_sub_play(combat:gen_sub_play(passive, Self, Self, Skill)),
                    combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_hit),
                    V =  case DmgHp - ReduceVal > 0 of
                        true -> DmgHp - ReduceVal;
                        false -> 1
                    end,
                    HpDmg = round(V - ReduceRatio * V / 100),
                    case HpDmg < 0 of
                        true -> {1, DmgMp, IsHit, IsMiss};
                        false -> {HpDmg, DmgMp, IsHit, IsMiss}
                    end;
                false -> {DmgHp, DmgMp, IsHit, IsMiss}
            end;
        false -> {DmgHp, DmgMp, IsHit, IsMiss}
    end;

handle_passive(_State, Args, _Skill, _Self, _Target) ->
    Args.
