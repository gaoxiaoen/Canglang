%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2017 14:54
%%%-------------------------------------------------------------------
-module(area_consume_rank_load).
-author("Administrator").
-include("activity.hrl").
-include("common.hrl").
-include("server.hrl").

%% API
-export([
    init/0,
    rank_list/2,
    replace/1,
    clean/0,
    rank_list_by_group/4,
    sort_rank_list_limit/2
]).
-define(SHOW_LIMIT_LV, 50).
init() ->
    case db:get_all("select sn,pkey,nickname,consume_gold,change_time,lv from area_consume_rank ") of
        [] ->
            [];
        Data ->
            F = fun([Sn, Pkey, NickName, ConsumeGold, ChangeTime, Lv]) ->
                #area_consume_rank_log{sn = Sn, pkey = Pkey, nickname = util:to_list(NickName), consume_gold = ConsumeGold, change_time = ChangeTime, lv = Lv}
            end,
            lists:map(F, Data)
    end.

rank_list(LogList, Base) ->
    GroupList = activity_area_group:get_id_list(data_area_consume_rank, area_consume_rank),
    LogSortList = sort_log_list_by_group(LogList),
    %%分类排行
    F = fun(Group) ->
        case lists:keyfind(Group, 1, LogSortList) of
            false -> {Group, []};
            {_, L} ->
                {Group, sort_rank_list_limit(L, Base)}
        end
    end,
    lists:map(F, ?IF_ELSE(GroupList == [], [0], GroupList)).

rank_list_by_group(LogList, RankLogList, Group, Base) ->
    GroupList = activity_area_group:get_group_list(data_area_consume_rank, area_consume_rank),
    F = fun(Log) ->
        case Group == activity_area_group:get_sn_group(Log#area_consume_rank_log.sn, GroupList) of
            false ->
                [];
            true ->
                [Log]
        end
    end,
    SortList = sort_rank_list(lists:flatmap(F, LogList), Base),
    case lists:keytake(Group, 1, RankLogList) of
        false -> [{Group, SortList} | RankLogList];
        {_, _, T} ->
            [{Group, SortList} | T]
    end.

%% 刷新排行榜
sort_rank_list(LogList, Base) ->
    F0 = fun(A, B) ->
        if
            A#area_consume_rank_log.consume_gold > B#area_consume_rank_log.consume_gold -> true;
            A#area_consume_rank_log.consume_gold < B#area_consume_rank_log.consume_gold -> false;
            true ->
                A#area_consume_rank_log.change_time < B#area_consume_rank_log.change_time
        end
    end,
    LogList1 = lists:sort(F0, LogList),
    F = fun(Log, {Rank0, L}) ->
        Rank = check_rank(Rank0, Log, Base),
        {Rank + 1, L ++ [Log#area_consume_rank_log{rank = Rank}]}
    end,
    {_, RankList} = lists:foldl(F, {1, []}, LogList1),
    RankList.

%% 刷新排行榜
sort_rank_list_limit(LogList, Base) ->
    F0 = fun(A, B) ->
        if
            A#area_consume_rank_log.consume_gold > B#area_consume_rank_log.consume_gold -> true;
            A#area_consume_rank_log.consume_gold < B#area_consume_rank_log.consume_gold -> false;
            true ->
                A#area_consume_rank_log.change_time < B#area_consume_rank_log.change_time
        end
    end,
    LogList1 = lists:sort(F0, LogList),
    F = fun(Log, {Rank0, L}) ->
        Rank = check_rank(Rank0, Log, Base),
        {Rank + 1, L ++ [Log#area_consume_rank_log{rank = Rank}]}
    end,
    {_, RankList} = lists:foldl(F, {1, []}, [X || X <- LogList1, X#area_consume_rank_log.lv >= ?SHOW_LIMIT_LV orelse X#area_consume_rank_log.lv == 0]),
    RankList.

check_rank(Rank0, Log, Base) ->
    Rank1 = area_consume_rank:get_rank(Rank0, Log#area_consume_rank_log.consume_gold, Base),
    if
        Rank1 == [] -> Rank0;
        Rank1 =< Rank0 -> Rank0;
        true -> Rank1
    end.


%%根据划分的服务器组分类
sort_log_list_by_group(LogList) ->
    GroupList = activity_area_group:get_group_list(data_area_consume_rank, area_consume_rank),
    F = fun(Log, L) ->
        Group = activity_area_group:get_sn_group(Log#area_consume_rank_log.sn, GroupList),
        case lists:keytake(Group, 1, L) of
            false -> [{Group, [Log]} | L];
            {value, {_, L1}, T} ->
                [{Group, [Log | L1]} | T]
        end
    end,
    lists:foldl(F, [], LogList).


replace(Log) ->
    Sql = io_lib:format("replace into area_consume_rank set sn = ~p,pkey=~p,nickname='~s',consume_gold=~p,change_time=~p,lv = ~p",
        [Log#area_consume_rank_log.sn, Log#area_consume_rank_log.pkey, Log#area_consume_rank_log.nickname, Log#area_consume_rank_log.consume_gold, Log#area_consume_rank_log.change_time, Log#area_consume_rank_log.lv]),
    db:execute(Sql).

clean() ->
    db:execute("truncate area_consume_rank ").

