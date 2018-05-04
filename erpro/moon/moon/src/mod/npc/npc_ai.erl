%% ----------------------------------------------------------------------------
%% NPC AI
%% @author abu@jieyou.cn
%% @end
%% ----------------------------------------------------------------------------
-module(npc_ai).

%% include
-include("common.hrl").
-include("role.hrl").
-include("storage.hrl").
-include("combat.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("attr.hrl").
-include("npc.hrl").

%% export 
-export([act/2, talk/3]).

%% export for unit test
-compile(export_all).

%% for test debug
%%-define(debug_log(P), ?DEBUG("type=~w, value=~w ", P)).
-define(debug_log(P), ok).

%% --------------------------------------------------------------------
%% API function
%% --------------------------------------------------------------------

%% @spec act(Npc, Scene) -> Result
%% Npc = #npc{} | #fighter{}
%% Scene = tuple()
%% Result = #npc{} | #fighter{}
%% @doc 根据Scene提供的场景决定Npc的下一步动作
act(Npc = #fighter{rid = BaseId, subtype = Subtype}, Scene)when is_record(Npc, fighter) ->
    case Subtype of
        ?fighter_subtype_demon -> 
            ok;
        _ -> ignore
    end,
    case Npc of
        #fighter{base_id = 10338} -> ok;
        _ -> ok
    end,
    %?DEBUG("npc ai actor: ~w~n", [Npc#fighter.rid]),
    NewNpc = try do_act(Npc, npc_ai_rule:gen_scene(combat, Scene)) of
        NewFighter = #fighter{ai = _Ai, act = _Act} ->
            ?debug_log([{ai, act}, {_Ai, _Act}]),
            NewFighter;
        _Other ->
            ?debug_log([error_result, _Other]),
            Npc
    catch 
        Type : Reason ->
            ?ELOG("执行AI出错, npc_base_id = ~w, reason = ~w", [BaseId, {Type, Reason}]),
            Npc
    end,
    %?DEBUG("npc_ai : ~w ~n", [NewNpc#fighter.ai]),
    %?DEBUG("npc_ai act : ~w, ~w~n", [NewNpc#fighter.pid, NewNpc#fighter.act]),
    %?DEBUG("npc_ai talk: ~s~n", [NewNpc#fighter.talk]),
    NewNpc;
act(Npc, Scene)when is_record(Npc, npc) ->
    %% ?DEBUG("npc ai actor: ~w~n", [Npc#npc.base_id]),
    do_act(Npc, npc_ai_rule:gen_scene(common, Scene)).

%% @spec talk(Status, Npc, Target) -> Result
%% Status = atom()
%% Npc = #npc{} 
%% Target = #map_role{}  
%% Result = binary()
%% @doc 根据对话列表和npc当前的状态给出合适的话 <br />
%% Scene : 场景， trace_find : 发现追踪目标， trace_off: 脱离追踪的目标<br />
%% Result : 话语
talk(Status, Npc = #npc{base_id = Id}, Target) ->
    {ok, Sentences} = npc_ai_data:get(talk, Status, Id),
    Result = case util:rand_list(Sentences) of
        null ->
            false;
        Sen ->
            {ok, npc_ai_rule:replace(Sen, Npc, Target)}
    end,
    %%?DEBUG("npc ai talk: ~w~n", [Result]),
    Result.

%% -------------------------------------------------------------------
%% inernal function
%% --------------------------------------------------------------------

%% 出招战斗
do_act(Npc, Scene) ->
    case npc_ai_rule:can_action(Npc) of
        true ->
            NpcResult = case npc_ai_rule:pre_process(Npc) of 
                {false, _} ->
                    npc_ai_rule:default_action(Npc, Scene);
                {Al, NewNpc} ->
                    [_H | T] = Al,
                    case do_match(T, Npc, Scene) of
                        false ->
                            %?DEBUG("do_match result: def action"),
                            npc_ai_rule:default_action(NewNpc, Scene);
                        {Rule, SuitTar} ->
                            %?DEBUG("do_match result: rule=~w~n", [Rule#npc_ai_rule.id]),
                            Tar = case Npc of
                                #fighter{type = ?fighter_type_role} ->  %% 角色ai，选取对方最弱成员
                                    npc_ai_rule:get_lowest_hp(SuitTar);
                                _ ->
                                    npc_ai_rule:get_not_die(SuitTar)
                            end,
                            NewSuitTar = case Tar of
                                false -> [];
                                Other -> [Other]
                            end,
                            NewScene = npc_ai_rule:handle_type(scene, Rule, Scene),
                            do_action(Rule, NewSuitTar, NewNpc, NewScene)
                    end
            end,
            NpcResult;
        false ->
            npc_ai_rule:default_action(Npc, Scene)
    end.

%% 从多个ai规则中匹配合适的规则
do_match(_Rules = [], _Npc, _Scene) ->
    false;
do_match(_Rules = [H | T], Npc, Scene) ->
    %?DEBUG("do match: rule = ~w~n", [H]),
    case npc_ai_data:get(ai_rule, H) of
        false ->
            do_match(T, Npc, Scene);
        {ok, Rule} ->
            case npc_ai_rule:can_verity(Rule, Npc) of 
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
                            case do_prob(Rule) of
                                true ->
                                    {Rule, SuitTar};
                                false ->
                                    do_match(T, Npc, Scene)
                            end
                    end
            end
    end.


%% 匹配ai规则
match_ai_rule(Npc, Rule = #npc_ai_rule{condition = Condition}, Scene) ->
    NewScene = npc_ai_rule:handle_type(scene, Rule, Scene),
    match_ai_rule(Npc, Condition, true, NewScene, []).
match_ai_rule(_Npc, _Cons, Flag, _Scene, _SuitTar) when Flag == false ->
    false;
match_ai_rule(_Npc, _Cons = [], _Flag, _Scene, SuitTar) ->
    SuitTar;
match_ai_rule(Npc, _Cons = [{Target, Key, Rela, Value, Count} | T], _Flag, Scene, SuitTar) ->
    Targets = npc_ai_rule:handle_con_target(Target, SuitTar, Npc, Scene),
    Star = npc_ai_rule:handle_con_rela(Targets, Key, Rela, Value),
    %?DEBUG("~w", [{Target, Key, Rela, Value, Count}]),
    %?DEBUG("suit_tar: ~w", [Star]),
    Cresult = npc_ai_rule:handle_con_count(Star, Count), 
    match_ai_rule(Npc, T, Cresult, Scene, Star);
match_ai_rule(Npc, _Cons = [H | T], Flag, Scene, SuitTar) ->
    ?ERR("npc ai data error: ~w~n", [H]),
    match_ai_rule(Npc, T, Flag, Scene, SuitTar).

%% 处理行为
do_action(Rule, SuitTar, Npc, Scene) ->
    %?DEBUG("action SuitTar: ~w", [SuitTar]),
    do_action(Rule, Rule#npc_ai_rule.action, SuitTar, Npc, Scene).

do_action(_Rule, _Actions = [], _SuitTar, Npc, _Scene) ->
    Npc;
do_action(Rule, _Actions = [_H = {ATar, AType, AVal} | T], SuitTar, Npc, Scene) ->
    Targets = npc_ai_rule:handle_action_target(ATar, Npc, SuitTar, Scene),
    NewNpc = npc_ai_rule:handle_action_type(AType, AVal, Targets, Rule, Npc, Scene),
    do_action(Rule, T, SuitTar, NewNpc, Scene).

%% 处理概率
do_prob(_Rule = #npc_ai_rule{prob = Prob}) ->
    util:rand(1, 100) =< Prob.


