%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 九月 2017 10:57
%%%-------------------------------------------------------------------
-module(hotfix2).
-author("Administrator").
-include("common.hrl").

%% API
-export([del_goods/0, del_player_goods/2]).


del_goods() ->
    case db:get_all("SELECT pkey,goods FROM log_act_lucky_turn WHERE opera = 3 AND `time` >= 1505404800 order by `time`") of
        List when is_list(List) ->
            lists:foreach(fun([Pkey, Goods]) ->
                GoodsList = util:bitstring_to_term(Goods),
                case get(Pkey) of
                    undefined ->
                        put(Pkey, 1),
                        skip;
                    _ ->
                        [{GoodsId, GoodsNum} | _] = GoodsList,
                        case misc:get_player_process(Pkey) of
                            Pid when is_pid(Pid) ->
                                if GoodsId == 10101 ->
                                    Pid ! {add_coin, -GoodsNum, 536};
                                    true ->
                                        player:apply_state(async, Pid, {?MODULE, del_player_goods, GoodsList})
                                end;
                            _ ->
                                util:sleep(200),
                                del_goods_out_line(Pkey, GoodsId, GoodsNum)
                        end
                end
                          end, List);
        _ ->
            ok
    end.

%% 删除物品
del_player_goods(GoodsList, Player) ->
    ?PRINT("GoodsList ~w", [GoodsList]),
    goods:subtract_good(Player, GoodsList, 536),
    ok.


%% 离线删玩家数据
del_goods_out_line(_, _, 0) ->ok;
del_goods_out_line(Pkey, 10101, DelGoodsNum) ->
    Sql = io_lib:format("select coin from player_state where pkey = ~p", [Pkey]),
    case db:get_one(Sql) of
        null -> ok;
        0 -> ok;
        Coin ->
            NewCoin = max(0, Coin - DelGoodsNum),
            Sql1 = io_lib:format("update player_state set coin = ~p where pkey=~p ", [NewCoin, Pkey]),
            db:execute(Sql1)
    end;
del_goods_out_line(Pkey, GoodsId, DelGoodsNum) ->
    ?PRINT("GoodsId =========~w, GoodsNum ~w", [GoodsId, DelGoodsNum]),
    Sql = io_lib:format("select gkey,goods_id,num from goods where pkey = ~w  and goods_id = ~w", [Pkey, GoodsId]),
    Data = db:get_all(Sql),
    loop_del(DelGoodsNum, Data, Pkey).

loop_del(0, _, _) -> ok;
loop_del(_, [], _) -> ok;
loop_del(DelGoodsNum, [[Gkey, _GoodsId, GoodsNum2] | T], Pkey) ->
    case DelGoodsNum >= GoodsNum2 of
        true ->
            DeleteSql = io_lib:format("delete from goods where gkey = ~w limit 1", [Gkey]),
            db:execute(DeleteSql),
            loop_del(DelGoodsNum - GoodsNum2, T, Pkey);
        _ ->
            LeftGoods = GoodsNum2 - DelGoodsNum,
            Sql2 = io_lib:format("update goods set num = ~p where gkey = ~w", [LeftGoods, Gkey]),
            db:execute(Sql2)
    end.

