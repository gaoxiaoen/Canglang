%%----------------------------------------------------
%% 造成[攻击*攻击系数]的伤害
%% 
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_100010).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{id = SkillId, args = [DmgMult]}, Self = #fighter{pid = Spid}, Target = #fighter{pid = Tpid, group = Tgroup}) ->
    ?parent:attack(Skill#c_skill{dmg_ratio = DmgMult*100}, Self, Target),
    case skill:class_id(SkillId) of
        ClassId when ClassId =:= 3100 -> %% 技能: 火球
            combat:commit_sub_play(),
            case [ Tpid2 || #fighter{pid=Tpid2, is_die=IsDie2} <- get(Tgroup), Tpid2 =/= Tpid, IsDie2 =:= ?false] of
                [] -> %% 对方没有活人了
                    ignore;
                [NewTpid|_] ->
                    {DmgHp, _DmgMp} = combat:fetch_master_dmg(Spid),
                    %combat:set_action_state(Spid, {skill_script_200110, skip}, {[Tpid], Tpid, DmgHp}), %% 提供给辅助技能200110使用
                    PassiveSkills = combat_script_skill:try_act_passive_after(Skill, Self, Target),  %% 尝试激活"奥术溅射"被动技能
                    lists:foreach(fun(PassiveSkill) ->
                        case PassiveSkill of
                            #c_skill{} ->
                                put({skill_script_200110, pre_skill}, {[Tpid], Tpid, DmgHp}), %% 提供给被动技能脚本skill_script_200110"奥术溅射"使用           
                                combat:do_skill(1, PassiveSkill, Spid, NewTpid);
                            _ -> ignore
                        end
                    end, PassiveSkills),
                    combat:commit_sub_play()
            end,
            ok;
        _ ->
            ok
    end;
handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).

