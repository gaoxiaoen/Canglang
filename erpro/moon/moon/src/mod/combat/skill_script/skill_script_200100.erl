%%----------------------------------------------------
%%
%% 使用女神之光时，有[几率]%的几率触发群体加血，除被施法者外的其他人可以增加治疗量的[百分比]%的血量 
%%
%% args = [百分比1，百分比2，几率]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_200100).
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

% handle_active(
%         Skill = #c_skill{args = [_Rate, Percent]}, 
%         Self = #fighter{}, 
%         Target = #fighter{pid = Tpid}) ->
%     case get({skill_script_100090, target}) of
%         {Tpid, _HealHp} -> %% 100090脚本的目标参战者不加血
%             ignore;
%         {_OtherTpid, HealHp} ->
%             ?parent:heal(Skill, Self, Target, round(HealHp * Percent / 100))
%     end;
% handle_active(Skill, Self, Target) ->
%     ?parent:heal(Skill, Self, Target, 0).
% 
% 
% passive_after_active(ActiveSkill, PassiveSkill = #c_skill{args = [Rate, _Percent]}, _Self = #fighter{pid = Spid}, _Target = #fighter{group = Tgroup}) ->
%     case skill:class_id(ActiveSkill#c_skill.id) of
%         3008 -> %% 技能：神圣恩赐
%             case util:rand(1, 100) =< Rate of
%                 true ->
%                     RealT = [F || F = #fighter{type = Type, pid = Fpid} <- get(Tgroup), Type=/=?fighter_type_pet, Fpid=/=Spid],
%                     combat:do_multi(length(RealT), RealT, Spid, PassiveSkill),
%                     combat:commit_sub_play();
%                 false ->
%                     ignore
%             end;
%         _ ->
%             ignore
%     end,
%     erase({skill_script_100090, target}),
%     ok.

% handle_active(
%         Skill = #c_skill{args = [_Rate, Percent]}, 
%         Self = #fighter{}, 
%         Target = #fighter{pid = Tpid}) ->
%     case get({skill_script_100090, target}) of
%         {Tpid, _HealHp} -> %% 100090脚本的目标参战者不加血
%             ignore;
%         {_OtherTpid, HealHp} ->
%             ?parent:heal(Skill, Self, Target, round(HealHp * Percent / 100))
%     end;
% handle_active(Skill, Self, Target) ->
%     ?parent:heal(Skill, Self, Target, 0).
% 
% 
% passive_after_active(ActiveSkill, PassiveSkill = #c_skill{args = [Rate, _Percent]}, _Self = #fighter{id = Sid, pid = Spid, group = Sgroup}, _Target = #fighter{}) ->
%     case skill:class_id(ActiveSkill#c_skill.id) of
%         3205 -> %% 技能：女神之光
%             case util:rand(1, 1000) =< Rate * 10 * 1000 of
%                 true ->
%                     combat:add_to_show_passive_skills(Sid, PassiveSkill#c_skill.id, ?show_passive_skills_hit),
%                     RealS = [F || F = #fighter{type = Type, pid = Fpid} <- get(Sgroup), Type=/=?fighter_type_pet, Fpid=/=Spid],
%                     combat:do_multi(length(RealS), RealS, Spid, PassiveSkill),
%                     combat:commit_sub_play();
%                 false ->
%                     ignore
%             end;
%         _ ->
%             ignore
%     end,
%     erase({skill_script_100090, target}),
%     ok.

handle_active(
        Skill = #c_skill{args = [_Rate, Percent]}, 
        Self = #fighter{pid = _Spid, group = _Sgroup}, 
        _Target = #fighter{pid = Tpid, group = Tgroup}) ->
    case erase({skill_script_100090, target}) of
        {_OtherTpid, HealHp} ->
            RealHealHp = round(HealHp * Percent / 100),
            L = [F || F = #fighter{pid = Fpid, is_die = IsDie} <- get(Tgroup), Fpid=/=Tpid, IsDie=:=?false],
            % L = [F || F = #fighter{type = _Type, pid = Fpid} <- get(Sgroup), Fpid=/=Spid],
            L2 = util:rand_list(L, 2),
            lists:foreach(fun(Target) ->
                ?parent:heal(Skill#c_skill{other_cost=[]}, Self, Target, RealHealHp)
            end, L2);
        _ ->
            ignore
    end,
    ok;
handle_active(Skill, Self, Target) ->
    ?parent:heal(Skill, Self, Target, 0).

%% 尝试激活被动技能, 只提供给“女神之光”使用 
%% -> true | false
try_act_passive_after(#c_skill{id = ActiveSkillId}, _PassiveSkill = #c_skill{args = [Rate, _Percent]}, _Self, _Target = #fighter{}) ->
    case skill:class_id(ActiveSkillId) of
        3205 -> %% 技能：女神之光 
            case util:rand(1, 1000) =< Rate * 10 of
                true -> true;
                false -> false
            end;
        _ ->
            false
    end.

