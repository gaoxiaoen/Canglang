%%----------------------------------------------------
%%
%% 造成[攻击*攻击系数+暴击*暴击系数+精准*精准系数]的伤害，攻击致盲对象时，若不出现格档，可连续攻击目标[次数]次
%%
%% args = [攻击系数，暴击系数，精准系数，次数]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_100130).
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
        Skill = #c_skill{args = [DmgC, CritC, HitC, Times]}, 
        Self = #fighter{pid = Spid, attr = #attr{critrate = Critrate, hitrate = Hitrate}}, 
        Target = #fighter{id = Tid, group = Tgroup, buff_hit = TBuffHit, buff_atk = TBuffAtk, buff_round = TBuffRound}) ->
    case ?parent:f(by_buffid, TBuffHit ++ TBuffAtk ++ TBuffRound, 201101) of %% 致盲buff
        undefined -> 
            ?log("对方无致盲buff"),
            ?parent:attack(
                    Skill, 
                    Self, 
                    Target, 
                    #action_effect_func{dmg_before_crit = fun([Dmg]) ->
                        round(Dmg * DmgC + Critrate * CritC + Hitrate * HitC)
                    end}
            );
        _ -> %% TODO "若不出现格档"如何判断?
            ?log("对方有致盲buff"),
            catch util:for(1, Times, fun(_I) ->
                ?log("连击~p", [_I]),
                ?parent:attack(
                        Skill, 
                        Self, 
                        Target, 
                        #action_effect_func{
                            dmg_before_crit = fun([Dmg]) ->
                                round(Dmg * DmgC + Critrate * CritC + Hitrate * HitC)
                            end,
                            dmg_after_hit = fun([Dmg, IsHit]) ->
                                put(tmp_is_hit, IsHit),  %% 临时标识命中or格挡
                                Dmg
                            end
                        }
                ),
                combat:set_cost_flag(Spid, true),
                combat:commit_sub_play(), %% 播动画
                case combat:f(by_id, Tgroup, Tid) of  %% 如果已死，中止连击
                    #fighter{is_die = ?false} ->
                        ignore;
                    _ ->
                        throw(die)
                end,
                case get(tmp_is_hit) of
                    ?false -> 
                        ?log("连击被格挡~p", [_I]), 
                        throw(evasion);  %% 连击被格挡, 中止连击
                    _ -> ignore
                end
            end),
            erase(tmp_is_hit),
            ok
    end;

handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).


