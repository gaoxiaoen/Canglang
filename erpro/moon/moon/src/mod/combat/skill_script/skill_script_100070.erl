%%----------------------------------------------------
%%
%% 造成[攻击*攻击系数+精神*精神系数+生命*生命系数]的伤害，
%% 攻击虚弱对象增加[百分比1]%伤害，
%% 攻击睡眠并且虚弱的对象增加[百分比2]%的伤害
%%
%% args = [攻击系数，精神系数，生命系数，百分比1，百分比2]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_100070).
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
        Skill = #c_skill{script_id = _ScriptId, args = [DmgC, JsC, HpC, Percent1, Percent2]}, 
        Self = #fighter{attr = #attr{js = Js}, hp_max = HpMax}, 
        Target = #fighter{buff_hit = Buffs}) ->
    Ratio = case ?parent:f(by_buffid, Buffs, 201110) of %% 虚弱buff
        undefined -> 1;
        _ ->
            R1 = 1 + Percent1/100,
            case ?parent:f(by_buffid, Buffs, 200051) of %% 睡眠buff
                undefined -> R1;
                _ -> R1 * (1 + Percent2/100)
            end
    end,
    ?parent:attack(Skill, Self, Target, #action_effect_func{dmg_before_crit = fun([Dmg])-> 
            round((Dmg * DmgC + Js * JsC + HpMax * HpC) * Ratio)
        end});
handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).


