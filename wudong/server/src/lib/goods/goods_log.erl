%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 物品日记
%%% @end
%%% Created : 19. 一月 2015 16:55
%%%-------------------------------------------------------------------
-module(goods_log).
-include("common.hrl").

%% API
-export([
    log/0,
    log_write/2
]).


log() ->
    Sql = "select pkey,nickname,goods_id,create_num from log_goods_create where `from`=191",
    Data = db:get_all(Sql),
    F = fun([Pkey, Nickname, GoodsId, Num], L) ->
        case lists:keytake(Pkey, 1, L) of
            false ->
                [{Pkey, Nickname, [{GoodsId, Num}]} | L];
            {value, {_, _, GoodsList}, T} ->
                NewGoodsList =
                    case lists:keytake(GoodsId, 1, GoodsList) of
                        false ->
                            [{GoodsId, Num} | GoodsList];
                        {value, {_, Old}, GList} ->
                            [{GoodsId, Num + Old} | GList]
                    end,
                [{Pkey, Nickname, NewGoodsList} | T]
        end
        end,
    LogList = lists:foldl(F, [], Data),
%%    log_write(config:get_server_num(), LogList),
    cross_all:apply(goods_log, log_write, [config:get_server_num(), LogList]),
    ok.

log_write(Sn, Log) ->
    FileName = io_lib:format("../server_~w.txt", [Sn]),
    {ok, S} = file:open(FileName, write),
    lists:foreach(fun({Pkey, NickName, GoodsList}) ->
        io:format(S, "~w        ~s       ~w~n", [Pkey, bitstring_to_list(NickName), GoodsList])
                  end, Log),
    file:close(S).
