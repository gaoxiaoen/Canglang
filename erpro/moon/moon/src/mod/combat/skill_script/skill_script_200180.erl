%%----------------------------------------------------
%%
%% 攻击血量在[百分比1]%以下的对象时，增加[百分比2]%暴击率，
%% 并且有[几率]%几率使暴击伤害从1.5倍伤害变为2倍伤害
%%
%% args = [百分比1，百分比2，几率]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_200180).
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
%% -> {#skill{}}
handle_passive(skill_enhance, {DmgSkill},
        #c_skill{id = SkillId, name = _SkillName, args = [HpPercent, AddCrit, Rate], critrate_ratio = CritrateRatio}, 
        #fighter{id = Sid, name = _Sname}, 
        #fighter{hp = Hp, hp_max = HpMax}) ->
    %%
    ?log("末日浩劫机率: hp/hp_max = ~p, hp_percent/100 = ~p", [Hp/HpMax, HpPercent/100]),
    case (Hp / HpMax) < (HpPercent / 100) of
        true ->
            DmgSkill2 = DmgSkill#c_skill{
                critrate_ratio = CritrateRatio + AddCrit
            },
            case util:rand(1, 1000) < Rate * 10 of
                true ->
                    ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
                    combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_hit),
                    DmgSkill3 = DmgSkill2#c_skill{
                        crit_dmg_ratio = 200   %% 2部伤害
                    },
                    {DmgSkill3};
                _ ->
                    {DmgSkill2}
            end;
        _ ->
            {DmgSkill}
    end;
handle_passive(_State, Args, _Skill, _Self, _Target) ->
    Args.
