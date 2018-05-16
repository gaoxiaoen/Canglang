%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 九月 2017 21:50
%%%-------------------------------------------------------------------
-module(hotfix6).
-author("Administrator").
-include("common.hrl").
-include("server.hrl").

%% API
-export([back_goods/0]).

get_ids() ->
    [
        250600056,
        350800596,
        252600030,
        252500873,
        252601745,
        253301120,
        252600104,
        254200041,
        253000201,
        350800377,
        250601119,
        253002160,
        252500951,
        252500036,
        252900972,
        251700772,
        253300338,
        253300792,
        252901737,
        251202072,
        800300608,
        253000124,
        254101593,
        251803156,
        200100456,
        251900226,
        250601330,
        250102927,
        250101581,
        251202945,
        250301215,
        253301458,
        250103613,
        250103094,
        251700196,
        252501764,
        253302844,
        250500403,
        253302392,
        150300065,
        252600062,
        350100118,
        200101282,
        350100063,
        251701165,
        350101666,
        251400855,
        351001751,
        251601917,
        250103170
    ].

get_back_goods_id() -> [6602008,4103015,1015001,2014001,20340,8001054,2003000].




back_goods() ->
    Ids = get_ids(),
    SaveIds =
    lists:foldl(fun(PlayerId,AccList2) ->
        BackGoodsId = get_back_goods_id(),
        NewAccList2 =
            lists:foldl(fun(BackId, AccList) ->
                Sql = io_lib:format("SELECT goods_id,create_num FROM log_goods_use WHERE pkey = ~w AND goods_id = ~w AND `time` > 1505448000 AND `time` < 1505451600", [PlayerId, BackId]),
                case db:get_all(Sql) of
                    List when is_list(List) ->
                        BackList2 = [{GoodsId, GoodsNum} || [GoodsId, GoodsNum] <- List],
                        BackList22 = goods:merge_goods(BackList2),
                        BackList22 ++ AccList;
                    _ ->
                        AccList
                end
                        end, [], BackGoodsId),
        if NewAccList2 == [] -> AccList2;
            true -> [{PlayerId,NewAccList2}|AccList2]
        end
                  end, [],Ids),
    write_to_text(SaveIds).




write_to_text(SaveIds) ->
    ServerId = config:get_server_num(),
    FileName = io_lib:format("../server_~w.txt", [ServerId]),
    {ok, S} = file:open(FileName, write),
    lists:foreach(fun({Pkey,GoodsList}) ->
        io:format(S, "~w      ~w ~n", [Pkey,GoodsList])
                  end, SaveIds),
    file:close(S).

