%%----------------------------------------------------
%%
%% 随机在[id,id··id]中召唤怪物[n]只          
%%
%% args = [{随机召唤数量n，是否重复召唤，[怪物ID，怪物ID,...]}]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10470).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = Args}, Self, _Target) ->
    case Args of
        [{Count, Rep, NpcList}] ->
            {NewNpcList, OList} = case {Rep, erlang:get(script_10470_config)} of
                {?true, DList} when is_list(DList) -> {(NpcList -- DList), DList};
                _ -> {NpcList, []}
            end,
            CallList = do_script_10470_rand_npc(Count, NewNpcList, []),
            {L1, L2} = do_script_10470(CallList, Skill, Self, [], []),
            case L1 of
                [SubPlay|_] ->
                    combat:add_sub_play(SubPlay),
                    lists:foreach(fun(SummonSubPlay) -> combat:add_sub_play(SummonSubPlay) end, L2);
                _ -> ignore
            end,
            erlang:put(script_10480_config, ((OList -- CallList) ++ CallList)), %% 防重复
            ok;
        _ -> ignore
    end,
    ok;

handle_active(Skill, Self, Target) ->
    ?parent:heal(Skill, Self, Target, 0).

%% ---------------------------------
do_script_10470([], _, _, L1, L2) -> {L1, L2};
do_script_10470([NpcBaseId|T], Skill, Self = #fighter{group = Sgroup}, L1, L2) ->
    case combat:add_fighter(npc, Sgroup, undefined, [NpcBaseId]) of
        {F, Fext} ->
            NL1 = [combat:gen_sub_play(attack, Self, Self, Skill, 0, 0, 0, 0, ?false, ?true, ?false)|L1],
            NL2 = [combat:gen_summon_sub_play(Self, F, Fext)|L2],
            do_script_10470(T, Skill, Self, NL1, NL2);
        _ -> do_script_10470(T, Skill, Self, L1, L2)
    end.
do_script_10470_rand_npc(Count, _, List) when Count =< 0 -> List;
do_script_10470_rand_npc(_Count, [], List) -> List;
do_script_10470_rand_npc(Count, NpcList, List) ->
    NpcBaseId = util:rand_list(NpcList),
    do_script_10470_rand_npc((Count - 1), (NpcList -- [NpcBaseId]), [NpcBaseId | List]).
