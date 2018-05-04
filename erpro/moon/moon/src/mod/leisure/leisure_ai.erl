%% ----------------------------------------------------------------------------
%% NPC AI
%% @author abu@jieyou.cn
%% @end
%% ----------------------------------------------------------------------------
-module(leisure_ai).

%% include
-include("common.hrl").
-include("role.hrl").
-include("storage.hrl").
-include("combat.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("attr.hrl").
-include("npc.hrl").
-include("leisure.hrl").

%% export 
-export([act/2]).

%% export for unit test
-compile(export_all).

%% for test debug
%%-define(debug_log(P), ?DEBUG("type=~w, value=~w ", P)).
-define(debug_log(P), ok).

%% --------------------------------------------------------------------
%% API function
%% --------------------------------------------------------------------

%% @spec act(Npc, Scene) -> Result
%% Npc = #fighter{}
%% Scene = tuple()
%% Result = #npc{} | #fighter{}
%% @doc 根据Scene提供的场景决定Npc的下一步动作
act(Fighter = #fighter{rid = BaseId}, Scene)when is_record(Fighter, fighter) ->

    NFighter = 
        try do_act(Fighter, leisure_ai_rule:gen_scene(combat, Scene)) of
            NewFighter = #fighter{ai = _Ai, act = _Act} ->
                ?debug_log([{ai, act}, {_Ai, _Act}]),
                NewFighter;
            _Other ->
                ?debug_log([error_result, _Other]),
                Fighter
        catch 
            Type : Reason ->
                ?ELOG("执行AI出错, npc_base_id = ~w, reason = ~w", [BaseId, {Type, Reason}]),
                Fighter
        end,
    %?DEBUG("npc_ai : ~w ~n", [NewNpc#fighter.ai]),
    %?DEBUG("npc_ai act : ~w, ~w~n", [NewNpc#fighter.pid, NewNpc#fighter.act]),
    %?DEBUG("npc_ai talk: ~s~n", [NewNpc#fighter.talk]),
    NFighter.

%% @spec talk(Status, Npc, Target) -> Result
%% Status = atom()
%% Npc = #npc{} 
%% Target = #map_role{}  
%% Result = binary()
%% @doc 根据对话列表和npc当前的状态给出合适的话 <br />
%% Scene : 场景， trace_find : 发现追踪目标， trace_off: 脱离追踪的目标<br />
%% Result : 话语
% talk(Status, Npc = #npc{base_id = Id}, Target) ->
%     {ok, Sentences} = leisure_ai_data:get(talk, Status, Id),
%     Result = case util:rand_list(Sentences) of
%         null ->
%             false;
%         Sen ->
%             {ok, leisure_ai_rule:replace(Sen, Npc, Target)}
%     end,
%     %%?DEBUG("npc ai talk: ~w~n", [Result]),
%     Result.

%% -------------------------------------------------------------------
%% inernal function
%% --------------------------------------------------------------------

%% 出招战斗
do_act(Fighter = #fighter{id = Id, ai = {Useful, History}}, Scene = #combat_scene{opp_side = OppSide}) ->
    case leisure_ai_rule:can_action(Fighter) of
        true ->
            NpcResult = 
                case leisure_ai_rule:pre_process(Fighter) of 
                    [] ->
                        leisure_ai_rule:get_rand_action(Fighter, Scene);
                    [Al|_] ->       %% 当前仅处理第一组条件[1,1000, 1001...]
                        [_H | T] = Al,
                        case do_match(T, Fighter, Scene) of
                            #npc_ai_rule{id = AiId, action = Action} ->
                            ?DEBUG("---Ai选招的结果--AiId~p action ~p~n~n~n", [AiId, Action]),
                                N = combat2:f_atk_times(by_id, Id),
                                case Action of  %%判断选招是否合法
                                    ?energy ->
                                        % case N >= ?max_energy of
                                        %     true ->
                                        %         leisure_ai_rule:get_rand_action(Fighter, Scene);
                                        %     false ->
                                                {Power, IsCrit} = leisure:calc_dmg(Fighter, OppSide),
                                                Fighter#fighter{ai = {Useful, lists:umerge([AiId], History)}, act = #act{type = ?energy, power = Power, is_crit = IsCrit}};
                                        % end;
                                    ?attack ->
                                        case N =< 0 of 
                                            true ->
                                                leisure_ai_rule:get_rand_action(Fighter, Scene);
                                            _ ->
                                                Fighter#fighter{ai = {Useful, lists:umerge([AiId], History)}, act = #act{type = ?attack, power = 0, is_crit = 0}}
                                        end;
                                    ?defence ->
                                        Fighter#fighter{ai = {Useful, lists:umerge([AiId], History)}, act = #act{type = ?defence, power = 0, is_crit = 0}};
                                    _ ->
                                        leisure_ai_rule:get_rand_action(Fighter, Scene)
                                end;
                            false ->
                                leisure_ai_rule:get_rand_action(Fighter, Scene)
                        end
                end,
            ?DEBUG("---Ai选招的结果--~p~n~n~n", [NpcResult#fighter.ai]),
            NpcResult;
        false ->
            leisure_ai_rule:get_rand_action(Fighter, Scene)
    end.

%% 从多个ai规则中匹配合适的规则
do_match(_Rules = [], _Npc, _Scene) ->
    false;
do_match(_Rules = [H | T], Npc, Scene) ->
    case leisure_ai_data:get(ai_rule, H) of
        false ->
            do_match(T, Npc, Scene);
        {ok, Rule} ->
            case leisure_ai_rule:can_verity(Rule, Npc) of 
                false ->
                    do_match(T, Npc, Scene);
                true ->
                    case catch match_ai_rule(Npc, Rule, Scene) of 
                        false ->
                            do_match(T, Npc, Scene);
                        {'EXIT', _} ->
                            ?ELOG("AI rule error: ~w", [H]),
                            do_match(T, Npc, Scene);
                        SuitTar ->
                            case erlang:length(SuitTar) > 0 of 
                                true ->
                                    case do_prob(Rule) of
                                        true ->
                                            Rule;
                                        false ->
                                            do_match(T, Npc, Scene)
                                    end;
                                _ ->
                                    do_match(T, Npc, Scene)
                            end
                    end
            end
    end.


%% 匹配ai规则
match_ai_rule(Npc, Rule = #npc_ai_rule{condition = Condition}, Scene) ->
    NewScene = leisure_ai_rule:handle_type(scene, Rule, Scene),
    match_ai_rule(Npc, Condition, true, NewScene, []).

match_ai_rule(_Npc, _Cons, Flag, _Scene, _SuitTar) when Flag == false ->
    false;

match_ai_rule(_Npc, _Cons = [], _Flag, _Scene, SuitTar) ->
    SuitTar;

match_ai_rule(Npc, _Cons = [{Target, Key, Rela, Value} | T], _Flag, Scene, SuitTar) ->
    Targets = leisure_ai_rule:handle_con_target(Target, SuitTar, Npc, Scene), %%条件所面向的对象
    SuitTarget = leisure_ai_rule:handle_con_rela(Targets, Key, Rela, Value, {Npc, Scene}), %%符合条件的目标
    Flag = leisure_ai_rule:handle_con_count(SuitTarget, 1), %%符合条件目标的数量, Flag == false时条件不成立
    match_ai_rule(Npc, T, Flag, Scene, SuitTarget);

match_ai_rule(Npc, _Cons = [H | T], Flag, Scene, SuitTar) ->
    ?ERR("npc ai data error: ~w~n", [H]),
    match_ai_rule(Npc, T, Flag, Scene, SuitTar).


%% 处理概率
do_prob(_Rule = #npc_ai_rule{prob = Prob}) ->
    util:rand(1, 100) =< Prob.


