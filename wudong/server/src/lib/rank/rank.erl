%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 二月 2015 上午11:53
%%%-------------------------------------------------------------------
-module(rank).
-author("fancy").

%% API
-export([
    get_rank/1,
    get_rank_top_N/2,
    get_world_lv/0,
    get_my_rank/2,
    get_player_max_lv/0,
    reset_catch_world_lv/0
]).
-include("common.hrl").
-include("rank.hrl").

-include_lib("stdlib/include/ms_transform.hrl").

%%战力榜 协议用
get_rank(Type) ->
    MS = ets:fun2ms(fun(Rank) when Rank#a_rank.rank =< ?RANK_NUM andalso Rank#a_rank.type == Type -> Rank end),
    RankList = ets:select(?ETS_RANK, MS),
    SortRankList = lists:sort(fun(R1, R2) -> R1#a_rank.rank < R2#a_rank.rank end, RankList),
    lists:sublist(SortRankList, ?RANK_NUM).

%%获取榜前N
get_rank_top_N(Type, N) ->
    MS = ets:fun2ms(fun(Rank) when Rank#a_rank.rank =< N andalso Rank#a_rank.type == Type -> Rank end),
    RankList = ets:select(?ETS_RANK, MS),
    lists:sort(fun(R1, R2) -> R1#a_rank.rank < R2#a_rank.rank end, RankList).

%%获取人物等级第一名排行榜
get_player_max_lv() ->
    case get_rank_top_N(?RANK_TYPE_LV, 1) of
        [#a_rank{rp = #rp{lv = Lv}} | _] -> Lv;
        _ ->
            0
    end.

%%获取世界等级
get_world_lv() ->
    case cache:get(world_lv) of
        [] ->
            AllRanklist = ets:match_object(?ETS_RANK, #a_rank{type = ?RANK_TYPE_LV, _ = '_'}),
            SortRankList = lists:sort(fun(R1, R2) -> R1#a_rank.rank < R2#a_rank.rank end, AllRanklist),
            Len = length(SortRankList),
            Get = 10,
            DefaultLv = 20,
            WorldLv =
                case Len == 0 of
                    true -> DefaultLv;
                    false ->
                        SubL = lists:sublist(SortRankList, Get),
                        SumLv = lists:sum([R#a_rank.rp#rp.lv || R <- SubL]),
                        case SumLv =< 0 of
                            true -> DefaultLv;
                            false ->
                                Len1 = length(SubL),
                                util:ceil(SumLv / Len1)
                        end
                end,
            cache:set(world_lv, WorldLv, 60 * 15),
            WorldLv;
        WorldLv -> WorldLv
    end.

%%获取排行榜排名 没进排行榜的返回0
get_my_rank(PKey, Type) ->
    case ets:lookup(?ETS_RANK, {Type, PKey}) of
        [] -> 0;
        [Rank | _] -> Rank#a_rank.rank
    end.

reset_catch_world_lv() ->
    cache:set(world_lv, []).

