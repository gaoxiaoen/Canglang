%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 四月 2017 16:34
%%%-------------------------------------------------------------------
-module(arena_score).
-author("hxming").
-include("cross_arena.hrl").
-include("common.hrl").
-include("server.hrl").
-include("tips.hrl").

%% API
-compile(export_all).


update_arena_score(Score) ->
    Mb = lib_dict:get(?PROC_STATUS_CROSS_ARENA),
    NewMb = Mb#cross_arena_mb{score = Mb#cross_arena_mb.score + Score, is_change = 1},
    lib_dict:put(?PROC_STATUS_CROSS_ARENA, NewMb).

check_score_reward() ->
    Mb = lib_dict:get(?PROC_STATUS_CROSS_ARENA),
    check_score_reward(Mb).
check_score_reward(Mb) ->
    Mb = lib_dict:get(?PROC_STATUS_CROSS_ARENA),
    F = fun(Id) ->
        Score = hd(data_arena_score_reward:get(Id)),
        if Mb#cross_arena_mb.score < Score -> false;
            true ->
                case lists:member(Id, Mb#cross_arena_mb.score_reward) of
                    false -> true;
                    true -> false
                end
        end
        end,
    case lists:any(F, data_arena_score_reward:ids()) of
        true -> 1;
        false -> 0
    end.

%%获取积分奖励列表
get_score_reward_list() ->
    Mb = lib_dict:get(?PROC_STATUS_CROSS_ARENA),
    F = fun(Id) ->
        [Score, GoodsList] = data_arena_score_reward:get(Id),
        State =
            if Mb#cross_arena_mb.score < Score -> 0;
                true ->
                    case lists:member(Id, Mb#cross_arena_mb.score_reward) of
                        false -> 1;
                        true -> 2
                    end
            end,
        [Id, Score, State, [tuple_to_list(Item) || Item <- GoodsList]]
        end,
    RewardList = lists:map(F, data_arena_score_reward:ids()),
    {Mb#cross_arena_mb.score, RewardList}.

%%提取竞技场积分奖励
score_reward(Id) ->
    Mb = lib_dict:get(?PROC_STATUS_CROSS_ARENA),
    do_score_reward(Id, Mb).


do_score_reward(0, Mb) ->
    F = fun(Id) ->
        [Score, _] = data_arena_score_reward:get(Id),
        if Mb#cross_arena_mb.score < Score -> false;
            true ->
                case lists:member(Id, Mb#cross_arena_mb.score_reward) of
                    true -> false;
                    false -> true
                end
        end
        end,
    case lists:filter(F, data_arena_score_reward:ids()) of
        [] -> {20, [], 0};
        Ids ->
            ScoreReward = Ids ++ Mb#cross_arena_mb.score_reward,
            NewMb = Mb#cross_arena_mb{score_reward = ScoreReward, is_change = 1},
            lib_dict:put(?PROC_STATUS_CROSS_ARENA, NewMb),
            GoodsList = lists:flatmap(fun(Id) -> lists:last(data_arena_score_reward:get(Id)) end, Ids),
            GoodsList1 = lists:foldl(fun({Gid, Num}, L) ->
                case lists:keyfind(Gid, 1, L) of
                    false ->
                        [{Gid, Num} | L];
                    {_, Count} ->
                        lists:keyreplace(Gid, 1, L, {Gid, Num + Count})
                end end, [], GoodsList),
            {1, GoodsList1, 0}
    end;
do_score_reward(Id, Mb) ->
    case data_arena_score_reward:get(Id) of
        [] ->
            IsReward = check_score_reward(Mb),
            {17, [], IsReward};
        [Score, GoodsList] ->
            if Mb#cross_arena_mb.score < Score ->
                IsReward = check_score_reward(Mb),
                {18, [], IsReward};
                true ->
                    case lists:member(Id, Mb#cross_arena_mb.score_reward) of
                        true ->
                            IsReward = check_score_reward(Mb),
                            {19, [], IsReward};
                        false ->
                            ScoreReward = [Id | Mb#cross_arena_mb.score_reward],
                            NewMb = Mb#cross_arena_mb{score_reward = ScoreReward, is_change = 1},
                            lib_dict:put(?PROC_STATUS_CROSS_ARENA, NewMb),
                            IsReward = check_score_reward(NewMb),
                            {1, GoodsList, IsReward}
                    end
            end
    end.

%%提示大厅数据
get_score_reward_state() ->
    case check_score_reward() of
        false -> #tips{};
        true ->
            #tips{state = 1}
    end.

get_notice_player(_Player) ->
    Mb = lib_dict:get(?PROC_STATUS_CROSS_ARENA),
    check_score_reward(Mb).
