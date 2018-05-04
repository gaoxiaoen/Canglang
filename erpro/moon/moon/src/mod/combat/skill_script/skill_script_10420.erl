%%----------------------------------------------------
%%
%% 复活并恢复其[基础值+精神*精神转换系数]气血，额外随机回复[最小百分比]%-[最大百分比]%气血          
%%
%% args = [基础值，精神转换系数,最小百分比,最大百分比]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10420).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(_Skill, _Self, _Target = #fighter{is_die = ?false}) -> ok;

handle_active(Skill = #c_skill{args = [BaseVal, JsRatio, MinHpRatio, MaxHpRatio]}, Self = #fighter{attr = #attr{js = Js}}, Target = #fighter{pid = Tpid, is_die = ?true, hp_max = ThpMax}) ->
    combat:update_fighter(Tpid, [{is_die, ?false}]),
    Js1 = case Js > 11000 of
        true -> 11000 + (Js - 11000)/5;
        false -> Js
    end,
    HealHp = round(BaseVal + Js1 * JsRatio + util:rand(MinHpRatio, MaxHpRatio) * ThpMax / 100),
    ?parent:heal(Skill, Self, Target#fighter{is_die = ?false}, HealHp);

handle_active(Skill, Self, Target) ->
    ?parent:heal(Skill, Self, Target, 0).

