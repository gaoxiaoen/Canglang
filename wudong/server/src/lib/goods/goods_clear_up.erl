%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%     整理背包
%%% @end
%%% Created : 03. 五月 2018 11:12
%%%-------------------------------------------------------------------
-module(goods_clear_up).
-author("hxming").

-include("goods.hrl").
-include("common.hrl").

%% API
-export([clear_up_bag/2]).


%%整理背包
clear_up_bag(Player, Location) when Location == 2 ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    FilterDict = dict:filter(fun(_, [Goods]) ->
        Goods#goods.location == Location end, GoodsSt#st_goods.dict),
    GoodsList = [Goods || {_, [Goods]} <- dict:to_list(FilterDict)],
    NewGoodsList = clear_up_loop(GoodsList, []),
    GoodsDict = goods_dict:update_goods(NewGoodsList, GoodsSt#st_goods.dict),
    ChangeList = lists:filter(fun(Goods) -> Goods#goods.is_change == 1 end, NewGoodsList),
    goods_load:dbup_goods_num(ChangeList),
    LeftoverCellNum = goods_init:bag_left_cell_num(GoodsSt#st_goods.max_cell, GoodsDict),
    WareHouse_leftover_cell_num = goods_init:warehouse_left_cell_num(GoodsSt#st_goods.warehouse_max_cell, GoodsDict),
    LeftFuwenCellNum = goods_init:fuwen_left_cell_num(GoodsSt#st_goods.maxfuwen_cell_num, GoodsDict),
    LeftXianCellNum = goods_init:xian_left_cell_num(GoodsSt#st_goods.maxxian_cell_num, GoodsDict),
    LeftFairySoulCellNum = goods_init:fairy_soul_left_cell_num(GoodsSt#st_goods.max_fairy_cell_num, GoodsDict),
    LeftGodSoulCellNum = goods_init:god_soul_left_cell_num(GoodsSt#st_goods.maxgod_soul_cell_num, GoodsDict),
    NewGoodsSt = GoodsSt#st_goods{
        dict = GoodsDict
        , leftover_cell_num = LeftoverCellNum
        , warehouse_leftover_cell_num = WareHouse_leftover_cell_num
        , leftfuwen_cell_num = LeftFuwenCellNum
        , leftxian_cell_num = LeftXianCellNum
        , left_fairy_soul_cell_num = LeftFairySoulCellNum
        , leftgod_soul_cell_num = LeftGodSoulCellNum
    },
    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
    goods_rpc:handle(15001, Player, {}),
    ok;
clear_up_bag(_, _) -> ok.

clear_up_loop([], GoodsList) ->
    GoodsList;
clear_up_loop([Goods | T], GoodsList) ->
    F = fun(Goods1, {FilterList, LeftList}) ->
        if Goods#goods.goods_id == Goods1#goods.goods_id andalso Goods#goods.bind == Goods1#goods.bind andalso Goods#goods.expire_time == Goods1#goods.expire_time ->
            {FilterList ++ [Goods1], LeftList};
            true ->
                {FilterList, LeftList ++ [Goods1]}
        end
        end,
    {MergeGoodsList, T1} = lists:foldl(F, {[Goods], []}, T),
    GoodsType = data_goods:get(Goods#goods.goods_id),
    NewMergeGoodsList = merge_goods(MergeGoodsList, GoodsType#goods_type.max_overlap),
    clear_up_loop(T1, GoodsList ++ NewMergeGoodsList).

merge_goods(GoodsList, MaxNum) ->
    Acc = lists:sum([Goods#goods.num || Goods <- GoodsList]),
    NewGoodsList = change_goods_num(Acc, MaxNum, [Goods#goods{num = 0} || Goods <- GoodsList], []),
    F = fun(Goods) ->
        OldGoods = lists:keyfind(Goods#goods.key, #goods.key, GoodsList),
        if OldGoods#goods.num =/= Goods#goods.num -> Goods#goods{is_change = 1};
            true ->
                Goods
        end
        end,
    lists:map(F, NewGoodsList).



change_goods_num(0, _MaxNum, OldGoodsList, NewGoodsList) -> OldGoodsList ++ NewGoodsList;
change_goods_num(Acc, MaxNum, [Goods | T], NewGoodsList) ->
    if Acc < MaxNum ->
        NewGoodsList ++ [Goods#goods{num = Acc} | T];
        true ->
            change_goods_num(Acc - MaxNum, MaxNum, T, [Goods#goods{num = MaxNum} | NewGoodsList])
    end.