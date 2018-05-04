%%----------------------------------------------------
%%
%% 造成[攻击*攻击系数+暴击*暴击系数+精准*精准系数]的伤害，若次技能击杀了目标，则对下一个目标再次释放此技能
%%
%% args = [攻击系数，暴击系数，精准系数]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_100140).
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
        Skill = #c_skill{args = [DmgC, CritC, HitC]}, 
        Self = #fighter{pid = Spid, attr = #attr{critrate = Critrate, hitrate = Hitrate}}, 
        Target = #fighter{pid = Tpid, type = Ttype}) ->
    %%
    case combat:get_action_state(Spid, {?MODULE, dead}) of
        LastTargetDead when LastTargetDead=:=undefined orelse LastTargetDead=:=?true -> %% 第一次攻击或上一个目标已死亡
            CanDmg = case Ttype of
                ?fighter_type_pet ->
                    case combat:f_master(Tpid) of
                        #fighter{is_die = ?true} -> %% 主人已死的话，宠物不受功击，如果有复活技能，这里会产生问题...
                            false;
                        _ -> 
                            true
                    end;
                _ ->
                    true
            end,
            case CanDmg of
                true ->
                    ?parent:attack(
                            Skill, 
                            Self, 
                            Target, 
                            #action_effect_func{dmg_before_crit = fun([Dmg]) ->
                                FinalDmg = round(Dmg * DmgC + Critrate * CritC + Hitrate * HitC),
                                FinalDmg
                            end}
                    ),
                    {_, #fighter{is_die = IsDead}} = combat:f(by_pid, Tpid),
                    combat:set_action_state(Spid, {?MODULE, dead}, IsDead),
                    combat:commit_sub_play(); %% 播动画
                _ ->
                    ignore
            end,
            ok;
        _ ->
            ok
    end;

handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).


