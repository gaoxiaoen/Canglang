%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2017 14:54
%%%-------------------------------------------------------------------
-module(flower_rank_load).
-author("Administrator").
-include("activity.hrl").
-include("common.hrl").
-include("server.hrl").

%% API
-export([
    init/0,
    rank_give_list/1,
    rank_get_list/1,
    replace/1,
    dbget_flower_rank_achieve/1,
    dbupdate_flower_rank_achieve/1,
    clean/0
]).

init() ->
    case db:get_all("select pkey,nickname,give,obtain,sex,avatar,give_change_time,get_change_time from flower_rank ") of
        [] ->
            [];
        Data ->
            F = fun([Pkey, NickName, Give, Get, Sex, Avatar, GiveTime, GetTime]) ->
                #flower_rank_log{pkey = Pkey, nickname = util:to_list(NickName), give = Give, get = Get, sex = Sex, avatar = util:to_list(Avatar), give_change_time = GiveTime, get_change_time = GetTime}
            end,
            lists:map(F, Data)
    end.

%% 送花排行
rank_give_list(LogList) ->
    F0 = fun(A, B) ->
        if
            A#flower_rank_log.give > B#flower_rank_log.give -> true;
            A#flower_rank_log.give < B#flower_rank_log.give -> false;
            true ->
                A#flower_rank_log.give_change_time < B#flower_rank_log.give_change_time
        end
    end,
    LogList1 = lists:sort(F0, [Log || Log <- LogList, Log#flower_rank_log.give > 0]),
    F = fun(Log, {Rank0, L}) ->
        Rank = give_rank(Rank0, Log#flower_rank_log.give),
        {Rank + 1, L ++ [Log#flower_rank_log{give_rank = Rank}]} end,
    {_, RankList} = lists:foldl(F, {1, []}, LogList1),
    RankList.

%%收花排行
rank_get_list(LogList) ->
    F0 = fun(A, B) ->
        if
            A#flower_rank_log.get > B#flower_rank_log.get -> true;
            A#flower_rank_log.get < B#flower_rank_log.get -> false;
            true ->
                A#flower_rank_log.get_change_time < B#flower_rank_log.get_change_time
        end
    end,
    LogList1 = lists:sort(F0, [Log || Log <- LogList, Log#flower_rank_log.get > 0]),
    F = fun(Log, {Rank0, L}) ->
        Rank = get_rank(Rank0, Log#flower_rank_log.get),
        {Rank + 1, L ++ [Log#flower_rank_log{get_rank = Rank}]} end,
    {_, RankList} = lists:foldl(F, {1, []}, LogList1),
    RankList.

replace(Log) ->
    Sql = io_lib:format("replace into flower_rank set pkey=~p,nickname='~s',give=~p,obtain=~p,sex = ~p,avatar='~s',give_change_time=~p,get_change_time=~p",
        [Log#flower_rank_log.pkey, Log#flower_rank_log.nickname, Log#flower_rank_log.give, Log#flower_rank_log.get, Log#flower_rank_log.sex, Log#flower_rank_log.avatar, Log#flower_rank_log.give_change_time, Log#flower_rank_log.get_change_time]),
    db:execute(Sql).

dbget_flower_rank_achieve(Pkey) ->
    NewSt = #player_flower_rank_log{
        pkey = Pkey,
        act_id = 0,
        give = 0,
        get = 0,
        give_list = [],
        get_list = []
    },
    Sql = io_lib:format("select give,give_list,act_id,obtain,obtain_list from flower_rank_achieve where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [] -> NewSt;
        [Give, GiveList, ActId, Get, GetList] ->
            #player_flower_rank_log{
                pkey = Pkey,
                act_id = ActId,
                give = Give,
                get = Get,
                give_list = util:bitstring_to_term(GiveList),
                get_list = util:bitstring_to_term(GetList)
            }
    end.

dbupdate_flower_rank_achieve(St) ->
    Sql = io_lib:format("replace into flower_rank_achieve set pkey = ~p,act_id=~p,give=~p,give_list='~s',obtain=~p,obtain_list = '~s'",
        [St#player_flower_rank_log.pkey, St#player_flower_rank_log.act_id, St#player_flower_rank_log.give, util:term_to_bitstring(St#player_flower_rank_log.give_list), St#player_flower_rank_log.get, util:term_to_bitstring(St#player_flower_rank_log.get_list)]),
    db:execute(Sql).

clean() ->
    db:execute("truncate flower_rank "),
    db:execute("truncate flower_rank_achieve ").


get_rank(Rank, Get) when Rank =< 1 andalso Get >= 2000 -> 1;
get_rank(Rank, Get) when Rank =< 2 andalso Get >= 1800 -> 2;
get_rank(Rank, Get) when Rank =< 3 andalso Get >= 1500 -> 3;
get_rank(Rank, _Get) -> max(4, Rank).

give_rank(Rank, Give) when Rank =< 1 andalso Give >= 2000 -> 1;
give_rank(Rank, Give) when Rank =< 2 andalso Give >= 1800 -> 2;
give_rank(Rank, Give) when Rank =< 3 andalso Give >= 1500 -> 3;
give_rank(Rank, _Give) -> max(4, Rank).
