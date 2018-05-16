%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2017 14:54
%%%-------------------------------------------------------------------
-module(cross_recharge_rank_load).
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
    rank_list_by_group/3
]).
-define(CROSS_RECHARGE_LIMIT_LV,50).

init() ->
    case db:get_all("select sn,pkey,nickname,recharge_gold,change_time,lv from cross_recharge_rank ") of
        [] ->
            [];
        Data ->
            F = fun([Sn, Pkey, NickName, RechargeGold, ChangeTime,Lv]) ->
                #cross_recharge_rank_log{sn = Sn, pkey = Pkey, nickname = util:to_list(NickName), recharge_gold = RechargeGold, change_time = ChangeTime,lv = Lv}
                end,
            lists:map(F, Data)
    end.

rank_list(LogList,Base) ->
    LogSortList = sort_log_list_by_group(LogList),
    %%分类排行
    F = fun(Group) ->
        case lists:keyfind(Group, 1, LogSortList) of
            false -> {Group, []};
            {_, L} ->
                {Group, sort_rank_list(L,Base)}
        end
        end,
    lists:map(F,[0]).

rank_list_by_group(LogList, RankLogList, Group) ->
    GroupList = activity_area_group:get_group_list(data_cross_recharge_rank, cross_recharge_rank),
    F = fun(Log) ->
        case Group == activity_area_group:get_sn_group(Log#cross_recharge_rank_log.sn, GroupList) of
%%             false -> [];
            false -> [Log];
            true ->
                [Log]
        end
        end,
    SortList = sort_rank_list(lists:flatmap(F, LogList),[]),
    case lists:keytake(Group, 1, RankLogList) of
        false -> [{Group, SortList} | RankLogList];
        {_, _, T} ->
            [{Group, SortList} | T]
    end.

%% 刷新排行榜
sort_rank_list(LogList,Base) ->
    F0 = fun(A, B) ->
        if
            A#cross_recharge_rank_log.recharge_gold > B#cross_recharge_rank_log.recharge_gold -> true;
            A#cross_recharge_rank_log.recharge_gold < B#cross_recharge_rank_log.recharge_gold -> false;
            true ->
                A#cross_recharge_rank_log.change_time < B#cross_recharge_rank_log.change_time
        end
         end,
    LogList1 = lists:sort(F0, LogList),
    F = fun(Log, {Rank0, L}) ->
        Rank = check_rank(Rank0, Log,Base),
        {Rank + 1, L ++ [Log#cross_recharge_rank_log{rank = Rank}]}
        end,
    {_, RankList} = lists:foldl(F, {1, []}, [X||X<-LogList1,X#cross_recharge_rank_log.lv >= ?CROSS_RECHARGE_LIMIT_LV orelse X#cross_recharge_rank_log.lv == 0 ]),
    RankList.

check_rank(Rank0, Log,Base) ->
    Rank1 = cross_recharge_rank:get_rank(Rank0, Log#cross_recharge_rank_log.recharge_gold,Base),
    if
        Rank1 == [] -> Rank0;
        Rank1 =< Rank0 -> Rank0;
        true -> Rank1
    end.

%%根据划分的服务器组分类
sort_log_list_by_group(LogList) ->
%%     GroupList = activity_area_group:get_group_list(data_cross_recharge_rank, cross_recharge_rank),
    F = fun(Log, L) ->
        Group = 0,
%%         Group = activity_area_group:get_sn_group(Log#cross_recharge_rank_log.sn, GroupList),
        case lists:keytake(Group, 1, L) of
            false -> [{Group, [Log]} | L];
            {value, {_, L1}, T} ->
                [{Group, [Log | L1]} | T]
        end
        end,
    lists:foldl(F, [], LogList).

replace(Log) ->
    Sql = io_lib:format("replace into cross_recharge_rank set sn = ~p,pkey=~p,nickname='~s',recharge_gold=~p,change_time=~p,lv = ~p",
        [Log#cross_recharge_rank_log.sn, Log#cross_recharge_rank_log.pkey, Log#cross_recharge_rank_log.nickname, Log#cross_recharge_rank_log.recharge_gold, Log#cross_recharge_rank_log.change_time,Log#cross_recharge_rank_log.lv]),
    db:execute(Sql).

clean() ->
    db:execute("truncate cross_recharge_rank ").

