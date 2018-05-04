%%----------------------------------------------------
%%
%% 玄天之魂和逆天之魂触发概率特殊处理
%% 玄天触发率=技能等级^0.3*（0.6-气血百分比）*0.65
%%
%% args = []
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10710).
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
    ignore.

%% 被动 
%% -> {AttackType}
handle_passive(be_hit, {AttackType, Dmg, IsHit},
        Skill = #c_skill{id = Id}, 
        #fighter{pid = Spid}, 
        #fighter{pid = Tpid}) ->
    %%
    {_, Self = #fighter{hp = Hp, hp_max = HpMax}} = combat:f(by_pid, Spid),
    {_, Target = #fighter{id = Tid}} = combat:f(by_pid, Tpid),
    case combat:is_skill_in_cooldown(Tid, Skill) of
        true -> 
            {AttackType, Dmg, IsHit};
        false ->     
            HitRate = round(math:pow(Id rem 900, 0.3) * (0.6 - Hp / HpMax) * 65),
            %% ?DEBUG("天命玄天技能触发概率 ~w", [HitRate]),
            skill_script_10500:handle_passive(be_hit, {AttackType, Dmg, IsHit}, Skill#c_skill{args = [HitRate]}, Self, Target)
    end;
handle_passive(_State, Args, _Skill, _Self, _Target) ->
    Args.
