%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 红装兑换
%%% @end
%%% Created : 30. 六月 2017 15:51
%%%-------------------------------------------------------------------
-module(red_goods_exchange).
-author("Administrator").
-include("activity.hrl").
-include("goods.hrl").
%% API
-export([
    get_info/1
    , red_exchange/2
    , get_state/0
]).

-define(RED_GOODS_TICKET, 11601).
-define(RED_MIN_LIMIT, 3).

get_info(_Player) ->
    case get_act() of
        [] -> {?RED_GOODS_TICKET, []};
        BaseAct ->
            ExList = BaseAct#base_red_goods_exchange.exchange_list,
            F = fun(Base, List) ->
                #base_red_goods_exchange_list{
                    id = Id,
                    index = Index
                } = Base,
                case check(Index) of
                    {GoodsId, CostNum, 1} -> %% 可以兑换
                        [[Id, GoodsId, CostNum, 1, 1] | List];
                    {GoodsId, CostNum, 2} -> %%已达上限
                        [[Id, GoodsId, CostNum, 1, 2] | List];
                    {GoodsId, CostNum, 0} -> %% 不可兑换
                        [[Id, GoodsId, CostNum, 1, 0] | List]
                end
            end,
            Data = lists:foldl(F, [], ExList),
            ?DEBUG("data ~p~n", [Data]),
            {?RED_GOODS_TICKET, Data}
    end.


red_exchange(Player, Id) ->
    case get_act() of
        [] -> {false, 0};
        BaseAct ->
            ExList = BaseAct#base_red_goods_exchange.exchange_list,
            case lists:keyfind(Id, #base_red_goods_exchange_list.id, ExList) of
                false -> {false, 0};
                Base ->
                    #base_red_goods_exchange_list{
                        id = Id,
                        index = Index
                    } = Base,
                    case check(Index) of
                        {GoodsId, CostNum, 1} ->
                            goods:subtract_good(Player, [{?RED_GOODS_TICKET, CostNum}], 279),
                            {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(279, [{GoodsId, 1}])),
                            activity:get_notice(Player, [129], true),
                            {ok, NewPlayer};
                        {_GoodsId, _CostNum, 2} ->
                            {false, 21}; %%已达上限
                        _ ->
                            {false, 20} %% 材料不足
                    end
            end
    end.

check(Index) ->
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
            check_help(Index, ?RED_MIN_LIMIT);
        GoodsList1 ->
            Star = lists:max([Goods#goods.star || Goods <- GoodsList1]),
            check_help(Index, max(?RED_MIN_LIMIT, Star))
    end.

check_help(Index, Star) ->
    Limit = data_equip_upgrade:get_max(),
    if
        Star > Limit ->
            {GoodsId, CostNum} = data_red_goods_exchange_info:get(Index, Limit),
            {GoodsId, CostNum, 2};
        true ->
            {GoodsId, CostNum} = data_red_goods_exchange_info:get(Index, Star),
            Count = goods_util:get_goods_count(GoodsId),
            RedTicketCount = goods_util:get_goods_count(?RED_GOODS_TICKET),
            if
                Count > 0 ->
                    check_help(Index, Star + 1);
                true ->
                    if
                        RedTicketCount < CostNum ->
                            {GoodsId, CostNum, 0};
                        true ->
                            {GoodsId, CostNum, 1}
                    end
            end
    end.

get_act() ->
    case activity:get_work_list(data_red_goods_exchange) of
        [] -> [];
        [Base | _] ->
            Base
    end.

get_state() ->
    case get_act() of
        [] -> -1;
        BaseAct ->
            ActInfo = BaseAct#base_red_goods_exchange.act_info,
            ExList = BaseAct#base_red_goods_exchange.exchange_list,
            F = fun(Base) ->
                #base_red_goods_exchange_list{
                    index = Index
                } = Base,
                case check(Index) of
                    {_GoodsId, _CostNum, 1} ->
                        true;
                    _ ->
                        false
                end
            end,
            State = lists:any(F, ExList),
            Args = activity:get_base_state(ActInfo),
            ?IF_ELSE(State == true, {1, Args}, {0, Args})
    end.
