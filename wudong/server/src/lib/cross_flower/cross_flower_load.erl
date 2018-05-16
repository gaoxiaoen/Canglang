%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2017 14:54
%%%-------------------------------------------------------------------
-module(cross_flower_load).
-author("Administrator").
-include("activity.hrl").
-include("common.hrl").
-include("server.hrl").

%% API
-export([
    init/0,
    rank_give_list/1,
    rank_give_list_by_group/3,
    rank_get_list/1,
    rank_get_list_by_group/3,
    replace/1,
    dbget_cross_flower_achieve/1,
    dbupdate_cross_flower_achieve/1,
    clean/0,
    get_rank_limit/1,
    give_rank_limit/1
]).

init() ->
    case db:get_all("select sn,pkey,nickname,give,obtain,sex,avatar,give_change_time,get_change_time from cross_flower ") of
        [] ->
            [];
        Data ->
            F = fun([Sn, Pkey, NickName, Give, Get, Sex, Avatar, GiveTime, GetTime]) ->
                #flower_log{sn = Sn, pkey = Pkey, nickname = util:to_list(NickName), give = Give, get = Get, sex = Sex, avatar = util:to_list(Avatar), give_change_time = GiveTime, get_change_time = GetTime}
            end,
            lists:map(F, Data)
    end.

rank_give_list(LogList) ->
    LogSortList = sort_log_list_by_group(LogList),
    %%分类排行
    F = fun(Group) ->
        case lists:keyfind(Group, 1, LogSortList) of
            false -> {Group, []};
            {_, L} ->
                {Group, sort_give_list(L)}
        end
    end,
    lists:map(F, activity_area_group:get_sort_group_list(data_cross_flower, cross_flower)).


rank_give_list_by_group(LogList, GiveLogList, Group) ->
    GroupList = activity_area_group:get_group_list(data_cross_flower, cross_flower),
    F = fun(Log) ->
        case Group == activity_area_group:get_sn_group(Log#flower_log.sn, GroupList) of
            false -> [];
            true ->
                [Log]
        end
    end,
    SortList = sort_give_list(lists:flatmap(F, LogList)),
    case lists:keytake(Group, 1, GiveLogList) of
        false -> [{Group, SortList} | GiveLogList];
        {_, _, T} ->
            [{Group, SortList} | T]
    end.

%%送花排行
sort_give_list(LogList) ->
    F0 = fun(A, B) ->
        if
            A#flower_log.give > B#flower_log.give -> true;
            A#flower_log.give < B#flower_log.give -> false;
            true ->
                A#flower_log.give_change_time < B#flower_log.give_change_time
        end
    end,
    LogList1 = lists:sort(F0, [Log || Log <- LogList, Log#flower_log.give > 0]),
    F = fun(Log, {Rank0, L}) ->
        Rank = give_rank(Rank0, Log#flower_log.give),
        {Rank + 1, L ++ [Log#flower_log{give_rank = Rank}]} end,
    {_, RankList} = lists:foldl(F, {1, []}, LogList1),
    RankList.

%%
rank_get_list(LogList) ->
    LogSortList = sort_log_list_by_group(LogList),
    F = fun(Group) ->
        case lists:keyfind(Group, 1, LogSortList) of
            false -> {Group, []};
            {_, L} ->
                {Group, sort_get_list(L)}
        end
    end,
    lists:map(F, activity_area_group:get_sort_group_list(data_cross_flower, cross_flower)).

rank_get_list_by_group(LogList, GetLogList, Group) ->
    GroupList = activity_area_group:get_group_list(data_cross_flower, cross_flower),
    F = fun(Log) ->
        case Group == activity_area_group:get_sn_group(Log#flower_log.sn, GroupList) of
            false -> [];
            true ->
                [Log]
        end
    end,
    SortList = sort_get_list(lists:flatmap(F, LogList)),
    case lists:keytake(Group, 1, GetLogList) of
        false -> [{Group, SortList} | GetLogList];
        {_, _, T} ->
            [{Group, SortList} | T]
    end.

%%收花排行
sort_get_list(LogList) ->
    F0 = fun(A, B) ->
        if
            A#flower_log.get > B#flower_log.get -> true;
            A#flower_log.get < B#flower_log.get -> false;
            true ->
                A#flower_log.get_change_time < B#flower_log.get_change_time
        end
    end,
    LogList1 = lists:sort(F0, [Log || Log <- LogList, Log#flower_log.get > 0]),
    F = fun(Log, {Rank0, L}) ->
        Rank = get_rank(Rank0, Log#flower_log.get),
        {Rank + 1, L ++ [Log#flower_log{get_rank = Rank}]} end,
    {_, RankList} = lists:foldl(F, {1, []}, LogList1),
    RankList.

%%根据划分的服务器组分类
sort_log_list_by_group(LogList) ->
    GroupList = activity_area_group:get_group_list(data_cross_flower, cross_flower),
    F = fun(Log, L) ->
        Group = activity_area_group:get_sn_group(Log#flower_log.sn, GroupList),
        case lists:keytake(Group, 1, L) of
            false -> [{Group, [Log]} | L];
            {value, {_, L1}, T} ->
                [{Group, [Log | L1]} | T]
        end
    end,
    lists:foldl(F, [], LogList).

replace(Log) ->
    Sql = io_lib:format("replace into cross_flower set sn = ~p,pkey=~p,nickname='~s',give=~p,obtain=~p,sex = ~p,avatar='~s',give_change_time=~p,get_change_time=~p",
        [Log#flower_log.sn, Log#flower_log.pkey, Log#flower_log.nickname, Log#flower_log.give, Log#flower_log.get, Log#flower_log.sex, Log#flower_log.avatar, Log#flower_log.give_change_time, Log#flower_log.get_change_time]),
    db:execute(Sql).

dbget_cross_flower_achieve(Pkey) ->
    NewSt = #player_flower_log{
        pkey = Pkey,
        act_id = 0,
        give = 0,
        get = 0,
        give_list = [],
        get_list = []
    },
    Sql = io_lib:format("select give,give_list,act_id,obtain,obtain_list from cross_flower_achieve where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [] -> NewSt;
        [Give, GiveList, ActId, Get, GetList] ->
            #player_flower_log{
                pkey = Pkey,
                act_id = ActId,
                give = Give,
                get = Get,
                give_list = util:bitstring_to_term(GiveList),
                get_list = util:bitstring_to_term(GetList)
            }
    end.

dbupdate_cross_flower_achieve(St) ->
    Sql = io_lib:format("replace into cross_flower_achieve set pkey = ~p,act_id=~p,give=~p,give_list='~s',obtain=~p,obtain_list = '~s'",
        [St#player_flower_log.pkey, St#player_flower_log.act_id, St#player_flower_log.give, util:term_to_bitstring(St#player_flower_log.give_list), St#player_flower_log.get, util:term_to_bitstring(St#player_flower_log.get_list)]),
    db:execute(Sql).

clean() ->
    db:execute("truncate cross_flower "),
    db:execute("truncate cross_flower_achieve ").

get_rank(Rank, Get) when Rank =< 1 andalso Get >= 2000 -> 1;
get_rank(Rank, Get) when Rank =< 2 andalso Get >= 1800 -> 2;
get_rank(Rank, Get) when Rank =< 3 andalso Get >= 1500 -> 3;
get_rank(Rank, _Get) -> max(4, Rank).

give_rank(Rank, Give) when Rank =< 1 andalso Give >= 2000 -> 1;
give_rank(Rank, Give) when Rank =< 2 andalso Give >= 1800 -> 2;
give_rank(Rank, Give) when Rank =< 3 andalso Give >= 1500 -> 3;
give_rank(Rank, _Give) -> max(4, Rank).

get_rank_limit(1) -> 2000;
get_rank_limit(2) -> 2000;
get_rank_limit(3) -> 2000;
get_rank_limit(_) -> 0.

give_rank_limit(1) -> 2000;
give_rank_limit(2) -> 2000;
give_rank_limit(3) -> 2000;
give_rank_limit(_) -> 0.