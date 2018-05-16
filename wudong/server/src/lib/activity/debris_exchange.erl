%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 碎片兑换
%%% @end
%%% Created : 03. 七月 2017 10:30
%%%-------------------------------------------------------------------
-module(debris_exchange).
-author("Administrator").
-include("activity.hrl").
-include("goods.hrl").
-include("equip.hrl").
%% API
-export([
    get_info/1
    , red_exchange/3
    , get_state/0
]).

get_info(_Player) ->
    case get_act() of
        [] -> {0, []};
        BaseAct ->
            ExList = BaseAct#base_debris_exchange.exchange_list,
            CostId = BaseAct#base_debris_exchange.cost_id,
            Count = goods_util:get_goods_count(CostId),
            F = fun(Base, List) ->
                #base_debris_exchange_list{
                    id = Id,
                    index = Index,
                    cost_num = CostNum,
                    goods_id = GoodsId,
                    get_num = GetNum
                } = Base,
                case check(Index, CostNum, Count, 1) of
                    {true, LackCount} ->
                        [[Id, GoodsId, CostNum, GetNum, LackCount, 1] | List];
                    {false, LackCount} ->
                        [[Id, GoodsId, CostNum, GetNum, LackCount, 2] | List];
                    {false, 0, LackCount} ->
                        [[Id, GoodsId, CostNum, GetNum, LackCount, 0] | List]
                end
            end,
            Data = lists:foldl(F, [], ExList),
            {CostId, Data}
    end.

check(Index, CostNum, Count, Num) ->
    GoodsList = goods:get_goods_list(?GOODS_LOCATION_BODY),
    %% 判断该位置是否有装备
    F = fun(Goods) ->
        GoodsType = data_goods:get(Goods#goods.goods_id),
        if
            GoodsType#goods_type.subtype == Index ->
                true;
            true ->
                false
        end
    end,
    Tmp = lists:filter(F, GoodsList),
    case Tmp of
        [] ->
            if
                Count < CostNum * Num ->
                    Base = data_equip_upgrade:get(3, Index),
                    [_H | T] = Base#base_equip_upgrade.need_goods,
                    {GoodsId, GoodsNum} = hd(T),
                    Count0 = goods_util:get_goods_count(GoodsId),
                    {false, 0, max(0, Num * GoodsNum - Count0)};
                true ->
                    Base = data_equip_upgrade:get(3, Index),
                    [_H | T] = Base#base_equip_upgrade.need_goods,
                    {GoodsId, GoodsNum} = hd(T),
                    Count0 = goods_util:get_goods_count(GoodsId),
                    {true, max(0, Num * GoodsNum - Count0)}
            end;
        GoodsList1 ->
            Star = lists:max([Goods#goods.star || Goods <- GoodsList1]),
            Limit = data_equip_upgrade:get_max(),
            if
                Star > Limit ->
                    {false, 0};
                Count < CostNum * Num ->
                    Base = data_equip_upgrade:get(max(3, Star), Index),
                    [_H | T] = Base#base_equip_upgrade.need_goods,
                    {GoodsId, GoodsNum} = hd(T),
                    Count0 = goods_util:get_goods_count(GoodsId),
                    {false, 0, max(0, Num * GoodsNum - Count0)};
                true ->
                    Base = data_equip_upgrade:get(max(Star, 3), Index),
                    [_H | T] = Base#base_equip_upgrade.need_goods,
                    {GoodsId, GoodsNum} = hd(T),
                    Count0 = goods_util:get_goods_count(GoodsId),
                    {true, max(0, Num * GoodsNum - Count0)}
            end
    end.

red_exchange(Player, Id, Num) ->
    case get_act() of
        [] -> {false, 0};
        BaseAct ->
            ExList = BaseAct#base_debris_exchange.exchange_list,
            CostId = BaseAct#base_debris_exchange.cost_id,
            Count = goods_util:get_goods_count(CostId),
            case lists:keyfind(Id, #base_debris_exchange_list.id, ExList) of
                false -> {false, 0};
                BaseList ->
                    #base_debris_exchange_list{
                        id = Id,
                        index = Index,
                        cost_num = CostNum,
                        goods_id = GoodsId,
                        get_num = GetNum
                    } = BaseList,
                    case check(Index, CostNum, Count, Num) of
                        {true, _LackCount} ->
                            goods:subtract_good(Player, [{CostId, CostNum * Num}], 280),
                            {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(280, [{GoodsId, GetNum * Num}])),
                            activity:get_notice(Player, [130], true),
                            {ok, NewPlayer};
                        {false, _LackCount} ->
                            {false, 21}; %%已达上限
                        {false, 0, _LackCount} ->
                            {false, 20} %% 材料不足
                    end
            end
    end.

get_act() ->
    case activity:get_work_list(data_debris_exchange) of
        [] -> [];

        [Base | _] ->
            Base
    end.

get_state() ->
    case get_act() of
        [] -> -1;
        BaseAct ->
            ActInfo = BaseAct#base_debris_exchange.act_info,
            ExList = BaseAct#base_debris_exchange.exchange_list,
            CostId = BaseAct#base_debris_exchange.cost_id,
            Count = goods_util:get_goods_count(CostId),
            F = fun(Base) ->
                #base_debris_exchange_list{
                    index = Index,
                    cost_num = CostNum
                } = Base,
                case check(Index, CostNum, Count, 1) of
                    {true, _LackCount} ->
                        true;
                    _ ->
                        false
                end
            end,
            State = lists:any(F, ExList),
            Args = activity:get_base_state(ActInfo),
            ?IF_ELSE(State == true, {1, Args}, {0, Args})
    end.
