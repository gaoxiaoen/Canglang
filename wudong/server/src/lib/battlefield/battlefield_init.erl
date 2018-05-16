%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 三月 2016 14:14
%%%-------------------------------------------------------------------
-module(battlefield_init).
-author("hxming").

-include("battlefield.hrl").

-include("common.hrl").
-include("server.hrl").

%% API
-compile(export_all).

init(Player) ->
    History =
        case player_util:is_new_role(Player) of
            true ->
                #battlefield{pkey = Player#player.key, is_change = 1};
            false ->
                Sql = io_lib:format(<<"select score,rank,honor,time from battlefield where pkey = ~p">>, [Player#player.key]),
                case db:get_row(Sql) of
                    [] ->
                        #battlefield{pkey = Player#player.key};
                    [Score, Rank, Honor, Time] ->
                        #battlefield{pkey = Player#player.key, score = Score, rank = Rank, honor = Honor, time = Time}
                end
        end,
    set_battlefield(History),
    Player.


set_battlefield(BF) ->
    lib_dict:put(?PROC_STATUS_BATTLEFIELD, BF).
get_battlefield() ->
    lib_dict:get(?PROC_STATUS_BATTLEFIELD).

%%定时器更新
timer_update() ->
    BF = get_battlefield(),
    if BF#battlefield.is_change == 1 ->
        set_battlefield(BF#battlefield{is_change = 0}),
        replace(BF);
        true -> skip
    end.

is_new(Score) ->
    Bf = get_battlefield(),
    ?IF_ELSE(Bf#battlefield.score < Score, 1, 0).

refresh(Score, Rank, Honor) ->
    Bf = get_battlefield(),
    NewBf = Bf#battlefield{score = Score, rank = Rank, honor = Honor, time = util:unixtime(), is_change = 1},
    set_battlefield(NewBf).

%%离线处理
logout() ->
    BF = get_battlefield(),
    if BF#battlefield.is_change == 1 ->
        replace(BF);
        true -> ok
    end.

replace(BF) ->
    Sql = io_lib:format(<<"replace into battlefield set pkey = ~p,score = ~p,rank =~p,honor=~p,time =~p">>,
        [BF#battlefield.pkey, BF#battlefield.score, BF#battlefield.rank, BF#battlefield.honor, BF#battlefield.time]),
    db:execute(Sql).