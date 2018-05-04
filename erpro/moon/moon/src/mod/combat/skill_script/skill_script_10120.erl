%%----------------------------------------------------
%%
%% 清除目标的指定类型的BUFF 
%%
%% args = [己方BUFF清除效果,敌方BUFF清除效果]   0表示清除所有buff，1表示清除恶性，2表示清除良性
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10120).
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
    Skill = #c_skill{args = [Param1, Param2]}, 
    #fighter{pid = Spid}, 
    #fighter{pid = Tpid}
) ->
    {_, Self = #fighter{group = Sgroup}} = combat:f(by_pid, Spid),
    {_, Target = #fighter{group = Tgroup, buff_atk = TBuffAtk, buff_hit = TBuffHit, buff_round = TBuffRound}} = combat:f(by_pid, Tpid),
    case Sgroup =:= Tgroup of
        true -> %% 己方
            %% 筛选出那些可以驱散的BUFF
            TBuffs = lists:filter(fun(#c_buff{dispel = Dispel}) -> Dispel =:= ?true end, TBuffAtk ++ TBuffHit ++ TBuffRound),
            case Param1 of 
                0 -> %% 清除所有buff
                    %% ?DEBUG("驱散自己所有BUFF:~w", [SBuffs]),
                    lists:foreach(fun(BUFF) -> combat:buff_del(BUFF, Tpid) end, TBuffs);
                _ -> %% 只清除debuff
                    %% ?DEBUG("驱散自己有害的BUFF:~w", [SBuffs]),
                    lists:foreach(
                        fun(BUFF) ->
                                #c_buff{eff_type = EffType} = BUFF,
                                case EffType of
                                    debuff -> combat:buff_del(BUFF, Tpid);
                                    _ -> ignore
                                end
                        end, TBuffs)
            end,
            combat:add_sub_play(combat:gen_sub_play(attack, Self, Target, Skill, 0, 0, 0, 0, ?false, ?true, ?false));
        false -> %% 敌方
            case ?parent:is_hit(Skill, Self, Target) of
                true ->
                    TBuffs = lists:filter(fun(#c_buff{dispel = Dispel}) -> Dispel =:= ?true end, TBuffAtk ++ TBuffHit ++ TBuffRound),
                    case Param2 of
                        0 -> %% 清除所有buff
                            %% ?DEBUG("驱散对方所有BUFF:~w", [TBuffs]),
                            lists:foreach(fun(BUFF) -> combat:buff_del(BUFF, Tpid) end, TBuffs);
                        _ -> %% 只清除buff
                            %% ?DEBUG("驱散对方有益的BUFF:~w", [TBuffs]),
                            lists:foreach(
                                fun(BUFF) ->
                                        #c_buff{eff_type = EffType} = BUFF,
                                        case EffType of
                                            buff -> combat:buff_del(BUFF, Tpid);
                                            _ -> ignore
                                        end
                                end, TBuffs)
                    end,
                    combat:add_sub_play(combat:gen_sub_play(attack, Self, Target, Skill, 0, 0, 0, 0, ?false, ?true, ?false));
                false ->
                    combat:add_sub_play(combat:gen_sub_play(attack, Self, Target, Skill, 0, 0, 0, 0, ?false, ?false, ?false))
            end
    end,
    ok;

handle_active(Skill, Self, Target) ->
    ?parent:attack(Skill, Self, Target).


