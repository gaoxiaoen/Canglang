%%----------------------------------------------------
%%
%% 火球或连锁闪电命中时，有[几率]%对其他所有单位造成原伤害的[百分比]%的伤害 
%%
%% args = [几率, 百分比]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_200110).
-export([
    handle_active/3
    ,try_act_passive_after/4
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(
        Skill = #c_skill{args = [_Rate, Percent]}, 
        Self = #fighter{group = _Sgroup, pid = Spid}, 
        _Target = #fighter{group = Tgroup}) ->
    case erase({?MODULE, pre_skill}) of  %% 火球术或连锁闪电的伤害值
        {ActTpids, _Tpid, PreDmgHp} ->
            DmgHp = round(PreDmgHp * Percent / 100),
            L = [F || F = #fighter{type = Type, pid = Fpid, is_die=IsDie} <- get(Tgroup), Type=/=?fighter_type_pet, not lists:member(Fpid, ActTpids), IsDie=:=?false],
            lists:foreach(fun(Target) ->
                ?parent:attack(Skill, Self, Target, #action_effect_func{
                    dmg_before_crit = fun([_Dmg]) ->
                        DmgHp
                    end
                }),
                combat:set_cost_flag(Spid, true)
                %combat:commit_sub_play() 
            end, L);
        _ ->
            ignore
    end,
    ok;
handle_active(_Skill, _Self, _Target) ->
    ?ERR("skill missing args"),
    ok.
    

%% 尝试激活被动技能, 只提供给“连锁闪电”“火球”使用 
%% -> true | false
try_act_passive_after(#c_skill{id = ActiveSkillId}, _PassiveSkill = #c_skill{args = [Rate, _Percent]}, _Self, _Target = #fighter{}) ->
    case skill:class_id(ActiveSkillId) of
        ClassId when ClassId =:= 3100 orelse ClassId =:= 3101 -> %% 技能：火球，连锁闪电 
            ?log("尝试激活：奥术溅射"),
            util:rand(1, 1000) =< Rate * 10;
        _ ->
            false
    end.

