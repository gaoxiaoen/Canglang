%%----------------------------------------------------
%%
%% 增加目标[攻击*攻击系数+精神*精神系数]的血量，
%% 若目标处于死亡状态，可令其复活，但治疗量减少[百分比]%
%%
%% args = [攻击系数，精神系数，百分比]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_100090).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [DmgC, JsC, Percent]}, Self = #fighter{pid = Spid, attr = #attr{js = Js, dmg_min = DmgMin, dmg_max = DmgMax}}, Target = #fighter{pid = Tpid, is_die = TargetDead, hp = TargetHp}) ->
    BaseHealHp = round((DmgMin + DmgMax) / 2 * DmgC + Js * JsC),
    HealHp = case TargetDead =:= ?true orelse TargetHp =< 0 of
        true ->
            combat:update_fighter(Tpid, [{is_die, ?false}]),
            HealHp0 = round(BaseHealHp * (1 - Percent / 100)),
            ?parent:heal(Skill, Self, Target#fighter{is_die = ?false}, HealHp0),
            HealHp0;
        false ->
            ?parent:heal(Skill, Self, Target, BaseHealHp),
            BaseHealHp
    end,
    combat:commit_sub_play(),
    PassiveSkills = combat_script_skill:try_act_passive_after(Skill, Self, Target),  %% 尝试激活"女神之光"被动技能
    lists:foreach(fun(PassiveSkill) ->
        case PassiveSkill of
            #c_skill{} ->
                put({?MODULE, target}, {Tpid, HealHp}), %% 提供给被动技能脚本skill_script_200100使用           
                combat:do_skill(1, PassiveSkill, Spid, Tpid),
                combat:commit_sub_play();
            _ -> ignore
        end
    end, PassiveSkills),
    ok;

handle_active(Skill, Self, Target) ->
    ?ERR("参数错误"),
    ?parent:heal(Skill, Self, Target, 0).


