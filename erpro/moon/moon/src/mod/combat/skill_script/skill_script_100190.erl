%%----------------------------------------------------
%%
%% 造成[攻击*攻击系数+防御*防御系数+格挡*格挡系数]的伤害，
%% 攻击恐惧对象增加[百分比]%伤害
%%
%% args = [攻击系数，防御系数，格挡系数，百分比]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_100190).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(
        Skill = #c_skill{id = _SkillId, name = _SkillName, args = [DmgC, DefC, EvaC, Percent, MaxHitTimes]}, 
        Self = #fighter{pid = Spid, attr = #attr{evasion = Evasion, defence = Defence}}, 
        Target = #fighter{id = Tid, group = Tgroup, buff_hit = BuffHit, buff_round = BuffRound, buff_atk = BuffAtk}) ->
    %%
    HasFearDebuff = case ?parent:f(by_buffid, BuffHit++BuffRound++BuffAtk, 202140) of %% 恐惧buff
            undefined -> false;
            _ -> true
    end,
    {C, HitTimes} = case HasFearDebuff of 
        false -> {1, 1};
        true -> {1 + Percent / 100, MaxHitTimes}
    end,
    ?log("~s 恐惧加成 ~p", [_SkillName, C]),
    catch util:for(1, HitTimes, fun(_I) ->
        ?parent:attack(
            Skill, 
            Self, 
            Target, 
            #action_effect_func{dmg_before_crit = fun([Dmg]) ->
                round((Dmg * DmgC + Defence * DefC + Evasion * EvaC) * C)
            end}
        ),
        combat:set_cost_flag(Spid, true),
        combat:commit_sub_play(), %% 播动画
        case combat:f(by_id, Tgroup, Tid) of  %% 如果已死，中止连击
            #fighter{is_die = ?false} ->
                ignore;
            _ ->
                throw(die)
        end
    end),
    ok;
handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).


