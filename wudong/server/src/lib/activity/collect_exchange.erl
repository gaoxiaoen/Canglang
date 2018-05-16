%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 集字活动
%%% @end
%%% Created : 08. 五月 2017 18:17
%%%-------------------------------------------------------------------
-module(collect_exchange).
-author("luobq").
-include("activity.hrl").
-include("server.hrl").
-include("common.hrl").
-include("daily.hrl").
-include("goods.hrl").
%% API
-export([
    get_collect_exchange_info/1
    , exchange_goods/2
    , get_state/0
]).

-define(COLLECT_DAILY_LIMIT, 2).


%% PROC_STATUS_COLLECT
%%获取集字活动信息
get_collect_exchange_info(Player) ->
    Count = daily:get_count(?DAILY_COLLECT_EXCHANGE),
    case get_act() of
        [] -> skip;
        BaseAct ->
            BaseList = BaseAct#base_act_collect_exchange.exchange_list,
            F = fun(BaseCE) ->
                #base_ce{
                    id = Id,
                    get_goods = {GetGoodsId, GetGoodsNum},
                    cost_goods = CostGoodsList
                } = BaseCE,
                Fg = fun({GId, Num}, AccState) ->
                    case AccState of
                        false -> false;
                        true ->
                            GC = goods_util:get_goods_count(GId),
                            GC >= Num
                    end
                end,
                State0 = lists:foldl(Fg, true, CostGoodsList),
                IsCan = case check_exchange_goods(BaseAct, Id) of
                            {ok, _} -> true;
                            _ -> false
                        end,
                State = ?IF_ELSE(State0 andalso IsCan, 1, 0),
                CostGoodsList1 = [tuple_to_list(Info) || Info <- CostGoodsList],
                [Id, GetGoodsId, GetGoodsNum, State, CostGoodsList1]
            end,
            ExchangeList = lists:map(F, BaseList),
            Data = {Count, ?COLLECT_DAILY_LIMIT, ExchangeList},
            {ok, Bin} = pt_432:write(43274, Data),
            server_send:send_to_sid(Player#player.sid, Bin)
    end,
    ok.


%%兑换物品
exchange_goods(Player, Id) ->
    case get_act() of
        [] -> {false, 0};
        Base ->
            case check_exchange_goods(Base, Id) of
                {false, Res} ->
                    {false, Res};
                {ok, BaseCE} ->
                    #base_ce{
                        get_goods = {GetGoodsId, GetGoodsNum},
                        cost_goods = CostGoodsList
                    } = BaseCE,
                    %%先扣物品
                    case goods:subtract_good(Player, CostGoodsList, 259) of
                        {false, _} -> {false, 0};
                        {ok, _NewGoodsStatus} ->
                            daily:increment(?DAILY_COLLECT_EXCHANGE, 1),
                            GiveGoodsList = goods:make_give_goods_list(259, [{GetGoodsId, GetGoodsNum}]),
                            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                            activity:get_notice(Player, [114], true),
                            activity_log:log_get_gift(Player#player.key, Player#player.nickname, GetGoodsId, GetGoodsNum, 259),
                            {ok, NewPlayer}
                    end
            end
    end.

check_exchange_goods(BaseAct, Id) ->
    case BaseAct of
        [] -> {false, 0};
        _ ->
            BaseList = BaseAct#base_act_collect_exchange.exchange_list,
            case lists:keyfind(Id, #base_ce.id, BaseList) of
                false -> {false, 0};
                BaseCE ->
                    CostGoodsList = BaseCE#base_ce.cost_goods,
                    LimitList = BaseCE#base_ce.limit_list,
                    RedId = BaseCE#base_ce.red_id,
                    Count = daily:get_count(?DAILY_COLLECT_EXCHANGE),
                    if
                        Count >= ?COLLECT_DAILY_LIMIT -> {false, 11};%% 每日兑换次数不足
                        true ->
                            case check_exchange_goods_1(CostGoodsList) of
                                false ->
                                    {false, 12};
                                true ->
                                    case check_limit_goods(LimitList) of
                                        false ->
                                            {false, 13};
                                        true ->
                                            case check_red(RedId) of
                                                false ->
                                                    {false, 13};
                                                true ->
                                                    {ok, BaseCE}
                                            end
                                    end
                            end
                    end
            end
    end.


check_exchange_goods_1([]) -> true;
check_exchange_goods_1([{GoodsId, Num} | Tail]) ->
    GoodsCount = goods_util:get_goods_count(GoodsId),
    case GoodsCount >= Num of
        true -> check_exchange_goods_1(Tail);
        false -> false
    end.

check_limit_goods([]) -> true;
check_limit_goods([GoodsId | Tail]) ->
    GoodsList = goods:get_goods_list(?GOODS_LOCATION_BODY),
    GoodsCount = goods_util:get_goods_count(GoodsId),
    if
        GoodsCount > 0 ->
            false;
        true ->
            case lists:keyfind(GoodsId, #goods.goods_id, GoodsList) of
                false ->
                    check_limit_goods(Tail);
                _ ->
                    false
            end
    end.


check_red(RedId) ->
    GoodsCount = goods_util:get_goods_count(RedId),
    if
        GoodsCount > 99 -> false;
        true -> true
    end.


get_state() ->
    case activity:get_work_list(data_collect_exchange) of
        [] -> -1;
        [Base | _] ->
            F =
                fun(Id, State) ->
                    if
                        State == true ->
                            true;
                        true ->
                            case check_exchange_goods(Base, Id) of
                                {false, _} -> false;
                                _ -> true
                            end
                    end
                end,
            Args = activity:get_base_state(Base#base_act_collect_exchange.act_info),
            case lists:foldl(F, false, data_collect_exchange:get_all()) of
                true -> {1, Args};
                _ -> {0, Args}
            end
    end.


get_act() ->
    case activity:get_work_list(data_collect_exchange) of
        [] -> [];
        [Base | _] ->
            Base
    end.