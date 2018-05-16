%%%-------------------------------------------------------------------
%%% @author and_me
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 六月 2016 11:49
%%%-------------------------------------------------------------------
-module(goods_warehouse).
-author("and_me").

-include("common.hrl").
-include("goods.hrl").
-include("server.hrl").

%% API
-export([store_goods/2,
    fetch_good/3,
    lv_up/1,
    lv_up/2,
    pack_send_goods_info/2]).


store_goods(Player, GoodsKeyList) ->
    GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
    GoodsList = [{goods_util:get_goods(Gkey), Num} || {Gkey, Num} <- GoodsKeyList],
    Fun = fun({Goods, Num}, Out) ->
        ?ASSERT(Goods#goods.num >= Num, {false, 29}),
        [#give_goods{bind = Goods#goods.bind, location = ?GOODS_LOCATION_WHOUSE, goods_id = Goods#goods.goods_id, num = Num, from = 172} | Out]
          end,
    AllInfoListAll = lists:foldl(Fun, [], GoodsList),
    FunAdd = fun(Info, {AccCL, AccNL, GoodsStatusAcc}) ->
        {NumChangGoodsList, NewGoodsList, NGoodsStatus} = do_add(Info, GoodsStatusAcc), %NumChangGoodsList 是物品数量发生变化格子GoodsInfo
        {NumChangGoodsList ++ AccCL, NewGoodsList ++ AccNL, NGoodsStatus}                %%NewGoodsList 当一个格子放不下时，需要另外启用新格子，NewGoodsList是新格子GoodsInfo
             end,
    {ChangeGoodsList, NewGoodsList, NewGoodsStatus} = lists:foldl(FunAdd, {[], [], GoodsStatus}, AllInfoListAll),
    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsStatus),
    goods_load:dbup_goods_num(ChangeGoodsList),
    goods_load:dbadd_goods(NewGoodsList),
    pack_send_goods_info(ChangeGoodsList ++ NewGoodsList, GoodsStatus#st_goods.sid),
    goods:subtract_good_by_keys(GoodsKeyList),
    {ok, Player}.


do_add(GiveGoods, GoodsStatus) ->
    GoodsTypeInfo = data_goods:get(GiveGoods#give_goods.goods_id),
    %%检查下背包空间是否足够，如果不够，直接抛异常
    case catch goods_util:check_enough_space(GoodsTypeInfo, GiveGoods#give_goods.bind, GiveGoods#give_goods.expire_time, GiveGoods#give_goods.num, GiveGoods#give_goods.location, GoodsStatus#st_goods.dict, GoodsStatus#st_goods.warehouse_leftover_cell_num) of
        newcell -> %%背包中没有该物品，而且格子数量是足够的，新加物品占用一个新格子
            ChangeGoodsList = [],
            NewGoodsList = goods_util:new_multi_goods(GoodsTypeInfo, GiveGoods#give_goods.num, GoodsStatus#st_goods.key, GiveGoods#give_goods.bind, GiveGoods#give_goods.expire_time, GiveGoods#give_goods.from, GiveGoods#give_goods.location, GiveGoods#give_goods.args);
        {enough, ExistGoods} -> %%背包已经该物品了，而且最大叠加数量没满，直接叠加在现有的物品之上
            NewGoods = ExistGoods#goods{num = ExistGoods#goods.num + GiveGoods#give_goods.num},
            ChangeGoodsList = [NewGoods],
            NewGoodsList = [];
        {overlap_and_newcell, ExistGoods, NewNum} -> %%背包已经该物品了，但是追加这个物品后，最大叠加数量已经满了，还需要使用新格子
            NewGoods = ExistGoods#goods{num = GoodsTypeInfo#goods_type.max_overlap},
            ChangeGoodsList = [NewGoods],
            NewGoodsList = goods_util:new_multi_goods(GoodsTypeInfo, NewNum, GoodsStatus#st_goods.key, GiveGoods#give_goods.bind, GiveGoods#give_goods.expire_time, GiveGoods#give_goods.from, GiveGoods#give_goods.location, GiveGoods#give_goods.args);
        {false, ErrorCode} ->
            ChangeGoodsList = [], NewGoodsList = [],
            throw({false, ?IF_ELSE(ErrorCode =:= ?ER_NOT_ENOUGH_CELL, 29, ErrorCode)});
        Error ->
            ?ERR("do_add Error ~p ~n", [Error]),
            ChangeGoodsList = [], NewGoodsList = [],
            throw({false, 444})
    end,
    NewGoodsDict = goods_dict:update_goods(ChangeGoodsList ++ NewGoodsList, GoodsStatus#st_goods.dict),
    NewGoodsStatus = GoodsStatus#st_goods{
        warehouse_leftover_cell_num = GoodsStatus#st_goods.warehouse_leftover_cell_num - length(NewGoodsList),
        dict = NewGoodsDict},
    {ChangeGoodsList, NewGoodsList, NewGoodsStatus}.


fetch_good(Player, Gkey, Num) ->
    GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
    GoodsDict = GoodsStatus#st_goods.dict,
    Goods = goods_util:get_goods(Gkey, GoodsDict),
    ?ASSERT(Goods#goods.num >= Num, {false, ?ER_NOT_ENOUGH_GOODS_NUM}),
    NewGoods = Goods#goods{num = Goods#goods.num - Num},
    NewLeftoverCellNum = ?IF_ELSE(NewGoods#goods.num =:= 0, GoodsStatus#st_goods.warehouse_leftover_cell_num + 1, GoodsStatus#st_goods.warehouse_leftover_cell_num),
    NewGoodsDict = goods_dict:update_goods([NewGoods], GoodsDict),
    NewGoodsStatus = GoodsStatus#st_goods{
        dict = NewGoodsDict,
        warehouse_leftover_cell_num = NewLeftoverCellNum},
    goods_load:dbup_goods_num(NewGoods),
    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsStatus),
    goods:give_goods_throw(Player, [#give_goods{goods_id = Goods#goods.goods_id, bind = Goods#goods.bind, num = Num, from = 171}]),
    pack_send_goods_info([NewGoods], GoodsStatus#st_goods.sid),
    {ok, Player}.



pack_send_goods_info([], _Sid) ->
    ok;
pack_send_goods_info(GoodsInfoList, Sid) ->
    GoodsList = goods_pack:pack_whouse_goods_list(GoodsInfoList),
    {ok, GoodsUpdateBin} = pt_150:write(15013, {GoodsList}),
    server_send:send_to_sid(Sid, GoodsUpdateBin).

lv_up(Player) ->
    lv_up(Player, true).
lv_up(Player, IsNotice) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case data_warehouse_cell:get_by_lv(Player#player.lv) of
        [] -> ok;
        Cell when Cell =< GoodsSt#st_goods.warehouse_max_cell -> ok;
        Cell ->
            NewGoodsSt = GoodsSt#st_goods{warehouse_max_cell = Cell,
                warehouse_leftover_cell_num = GoodsSt#st_goods.warehouse_leftover_cell_num + Cell - GoodsSt#st_goods.warehouse_max_cell},
            lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
            goods_load:dbup_bag_cell_num(NewGoodsSt),
            {ok, Bin} = pt_150:write(15017, {1, Cell}),
            ?DO_IF(IsNotice, server_send:send_to_sid(Player#player.sid, Bin)),
            ok
    end.