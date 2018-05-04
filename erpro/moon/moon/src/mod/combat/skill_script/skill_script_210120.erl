%%----------------------------------------------------
%%
%% 当自身气血低于[气血百分比]%时，触发BUFF 
%%
%% args = [百分比]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_210120).
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
%% -> any()
handle_passive(hp_below, Args,
        #c_skill{id = SkillId, name = _SkillName, args = [HpRatio, Rate], buff_self = BuffSelf}, 
        _Self = #fighter{id = _Sid, pid = _Spid, name = _Sname},
        Target = #fighter{id = Tid, pid = Tpid, hp_max = ThpMax, hp = Thp}) ->
    %%
    case util:rand(1, 1000) =< Rate * 10 of
        true ->
            if
                (Thp * 100) =< (HpRatio * ThpMax) ->
                    case combat:check_skill_limit(Tpid, SkillId, 1) of
                        true ->
                            %% ?DEBUG("[~s]的被动技能[~s]触发，尝试添加BUFF", [_Sname, _SkillName]),
                            combat:add_to_show_passive_skills(Tid, SkillId, ?show_passive_skills_hit),
                            %% 对自己施加BUFF
                            lists:foreach(fun(Buff) -> combat_script_buff:do_add_buff(Buff, Target, Target) end, BuffSelf);
                        false ->
                            %%?DEBUG("[~s]的被动技能[~s]触发次数达到上限[~w]，不能再触发", [_Sname, _SkillName, 1])
                            ok
                    end;
                true -> 
                    ignore
            end;
        _ ->
            ignore
    end,
    Args;
handle_passive(_State, Args, _Skill, _Self, _Target) ->
    Args.
