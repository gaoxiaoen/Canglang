%%----------------------------------------------------
%%
%% 对目标造成[攻击*攻击系数+精神*精神系数+生命*生命系数]的伤害，
%% 并对下一个目标造成前一个伤害的[百分比]%伤害，
%% 一直传递直到[次数]次用完或者只剩下一个单位	
%%
%% args = [攻击系数，精神系数，生命系数，百分比，次数]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_100060).
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
        Skill = #c_skill{id = SkillId, script_id = ScriptId, args = [DmgC, JsC, HpC, Percent, Times]}, 
        Self = #fighter{pid = Spid, attr = #attr{js = Js}, hp_max = HpMax}, 
        Target = #fighter{pid = Tpid, group = Tgroup}) ->
%%
    PassTimes = case combat:get_script_state(ScriptId) of
        undefined -> 0;
        PassTimes_ -> PassTimes_
    end,
    case PassTimes < Times of
        true ->
            CanCrit = case PassTimes of  %% 只有第一次攻击有暴击
                0 -> true;
                _ -> false
            end,
            combat:set_script_state(ScriptId, PassTimes + 1),
            Ratio = math:pow(Percent / 100, PassTimes),
            ?parent:attack(Skill, Self, Target, #action_effect_func{
                dmg_can_crit = CanCrit,
                dmg_before_crit = fun([Dmg])-> 
                    round((Dmg * DmgC + Js * JsC + HpMax * HpC) * Ratio)
                end}),
            combat:commit_sub_play(), %% 播动画
            %% 以下代码提供给辅助技能脚本200110使用(奥术溅射)
            case skill:class_id(SkillId) of
                ClassId when ClassId =:= 3101 -> %% 技能: 连锁闪电
                    %{DmgHp, _DmgMp} = combat:fetch_master_dmg(Spid),
                    %Tpids = case combat:get_action_state(Spid, {skill_script_200110, skip}) of 
                    %    undefined -> [];
                    %    {Tpids_, _LastTpid, _LastDmg} -> Tpids_
                    %end,
                    %combat:set_action_state(Spid, {skill_script_200110, skip}, {[Tpid|Tpids], Tpid, DmgHp});
                    case [ Tpid2 || #fighter{pid=Tpid2, is_die=IsDie2} <- get(Tgroup), Tpid2 =/= Tpid, IsDie2 =:= ?false] of
                        [] -> %% 对方没有活人了
                            ignore;
                        [NewTpid|_] ->
                            case combat_script_skill:try_act_passive_after(Skill, Self, Target) of  %% 尝试激活"奥术溅射"被动技能
                                [] -> ignore;
                                PassiveSkills ->
                                    {DmgHp, _DmgMp} = combat:fetch_master_dmg(Spid),
                                    %combat:set_action_state(Spid, {skill_script_200110, skip}, {[Tpid], Tpid, DmgHp}), %% 提供给辅助技能200110使用
                                    lists:foreach(fun(PassiveSkill) ->
                                        case PassiveSkill of
                                            #c_skill{} ->
                                                put({skill_script_200110, pre_skill}, {[Tpid], Tpid, DmgHp}), %% 提供给被动技能脚本skill_script_200110"奥术溅射"使用           
                                                combat:do_skill(1, PassiveSkill, Spid, NewTpid);
                                            _ -> ignore
                                        end
                                    end, PassiveSkills),
                                    combat:commit_sub_play()
                            end
                    end,
                    ok;
                _ ->
                    ignore
            end;
        false ->
            combat:erase_script_state(ScriptId),
            ok
    end,
    ok;
handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).


