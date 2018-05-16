%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% 玩家元宝统计 (个人)
%%% @end
%%% Created : 13. 一月 2016 下午6:02
%%%-------------------------------------------------------------------
-module(gold_count).
-author("fengzhenlin").
-include("server.hrl").
-include("common.hrl").

%% API
-export([
    init/1,
    add_gold/1,
    add_coin/1,
    logout/1,
    night_refresh/0,
    player_night_refresh/0
]).

-record(gcount,{
    pkey = 0,
    gold = 0,
    coin = 0,
    time = 0
}).

init(Player) ->
    NewSt = #gcount{
        pkey = Player#player.key
    },
    GCount =
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select sum_gold,sum_coin,`time` from cron_player_money where pkey = ~p",[Player#player.key]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [Gold,Coin,Time] ->
                    #gcount{
                        pkey = Player#player.key,
                        gold = Gold,
                        coin = Coin,
                        time = Time
                    }
            end
    end,
    lib_dict:put(?PROC_STATUS_GOLD_COUNT,GCount),
    Player.

add_gold(AddGold) ->
    Now = util:unixtime(),
    case lib_dict:get(?PROC_STATUS_GOLD_COUNT) of
        GCount when is_record(GCount,gcount) ->
            #gcount{
%%                pkey = Pkey,
                gold = Gold
            } = GCount,
            NewGold = Gold+AddGold,
            NewGCount = GCount#gcount{
                            gold = NewGold,
                            time = Now
                        },
            lib_dict:put(?PROC_STATUS_GOLD_COUNT,NewGCount),
%%            GoodsId = 10199,
            case NewGold > 100000 of
                true -> %%报警
                    %role_goods_count:http_post(Pkey,GoodsId,NewGold,1);
                    skip;
                false ->
                    skip
            end,
            ok;
        _ ->
            skip
    end.

add_coin(AddCoin) ->
    Now = util:unixtime(),
    case lib_dict:get(?PROC_STATUS_GOLD_COUNT) of
        GCount when is_record(GCount,gcount) ->
            #gcount{
%%                pkey = Pkey,
                coin = Coin
            } = GCount,
            NewCoin = Coin+AddCoin,
            NewGCount = GCount#gcount{
                coin = NewCoin,
                time = Now
            },
            lib_dict:put(?PROC_STATUS_GOLD_COUNT,NewGCount),
%%            GoodsId = 10107,
            case NewCoin > 100000 of
                true -> %%报警
                    %role_goods_count:http_post(Pkey,GoodsId,NewCoin,1);
                    skip;
                false ->
                    skip
            end,
            ok;
        _ ->
            skip
    end.

logout(_Player) ->
    GCount = lib_dict:get(?PROC_STATUS_GOLD_COUNT),
    #gcount{
        pkey = Pkey,
        gold = Gold,
        coin = Coin,
        time = Time
    } = GCount,
    Sql = io_lib:format("replace into cron_player_money set pkey=~p,sum_gold=~p,sum_coin=~p,`time`=~p",
        [Pkey,Gold,Coin,Time]),
    db:execute(Sql),
    ok.

%%晚上清数据
night_refresh() ->
    Sql = io_lib:format("truncate cron_player_money",[]),
    db:execute(Sql),
    ok.

%%晚上清数据 个人
player_night_refresh() ->
    GCount = lib_dict:get(?PROC_STATUS_GOLD_COUNT),
    NewGCount = GCount#gcount{
        gold = 0,
        coin = 0,
        time = util:unixtime()
    },
    lib_dict:put(?PROC_STATUS_GOLD_COUNT,NewGCount),
    ok.