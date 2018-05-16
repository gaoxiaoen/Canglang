%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 六月 2016 10:24
%%%-------------------------------------------------------------------
-module(cross_eliminate_load).
-author("hxming").

-include("cross_eliminate.hrl").
-include("common.hrl").
%% API
-compile(export_all).


load_player_eliminate(Pkey) ->
    Sql = io_lib:format("select wins,winning_streak,losing_streak,times,time from player_eliminate where pkey=~p ", [Pkey]),
    db:get_row(Sql).

replace_player_eliminate(Eliminate) ->
    Sql = io_lib:format("replace into player_eliminate set pkey=~p,wins=~p,winning_streak=~p,losing_streak=~p,times=~p,time=~p ",
        [Eliminate#player_eliminate.pkey,
            Eliminate#player_eliminate.wins,
            Eliminate#player_eliminate.winning_streak,
            Eliminate#player_eliminate.losing_streak,
            Eliminate#player_eliminate.times,
            Eliminate#player_eliminate.time]),
    db:execute(Sql).




init() ->
    case db:get_all("select sn,pkey,nickname,wins from cross_eliminate") of
        [] -> [];
        Data ->
            F = fun([Sn, Pkey, NickName, Wins]) ->
                #eliminate_log{sn = Sn, pkey = Pkey, nickname = NickName, wins = Wins}
                end,
            lists:map(F, Data)
    end.

rank_list(LogList) ->
    LogList1 = lists:reverse(lists:keysort(#eliminate_log.wins, LogList)),
    F = fun(Log, {Rank, L}) -> {Rank + 1, L ++ [Log#eliminate_log{rank = Rank}]} end,
    {_, RankList} = lists:foldl(F, {1, []}, LogList1),
    RankList.


clean() ->
    db:execute("truncate cross_eliminate "),
    db:execute("truncate cross_eliminate_reward ").

update(Log, LogList) ->
    if Log#eliminate_log.wins > 0 ->
        case lists:keytake(Log#eliminate_log.pkey, #eliminate_log.pkey, LogList) of
            false ->
                case get_wins(Log#eliminate_log.pkey) of
                    null ->
                        replace(Log),
                        [Log | LogList];
                    Wins ->
                        NewLog = Log#eliminate_log{wins = Log#eliminate_log.wins + Wins},
                        replace(NewLog),
                        [NewLog | LogList]
                end;
            {value, Old, T} ->
                NewLog = Log#eliminate_log{wins = Log#eliminate_log.wins + Old#eliminate_log.wins},
                replace(NewLog),
                [NewLog | T]
        end;
        true -> LogList
    end.

get_wins(Pkey) ->
    db:get_one(io_lib:format("select wins from cross_eliminate where pkey = ~p", [Pkey])).

replace(Log) ->
    Sql = io_lib:format("replace into cross_eliminate set sn = ~p,pkey=~p,nickname='~s',wins=~p",
        [Log#eliminate_log.sn, Log#eliminate_log.pkey, Log#eliminate_log.nickname, Log#eliminate_log.wins]),
    db:execute(Sql).


load_reward() ->
    Sql = "select pkey,rank,time from cross_eliminate_reward",
    Data = db:get_all(Sql),
    F = fun([Pkey, Rank, Time]) ->
        #elimination_reward{pkey = Pkey, rank = Rank, time = Time}
        end,
    lists:map(F, Data).

insert_reward(RewardList) ->
    F = fun(Reward) ->
        Sql = io_lib:format("replace into cross_eliminate_reward set pkey =~p,rank=~p,time=~p ",
            [Reward#elimination_reward.pkey, Reward#elimination_reward.rank, Reward#elimination_reward.time]),
        db:execute(Sql)
        end,
    lists:foreach(F, RewardList).

del_reward(Pkey) ->
    Sql = io_lib:format("delete from cross_eliminate_reward where pkey=~p", [Pkey]),
    db:execute(Sql).