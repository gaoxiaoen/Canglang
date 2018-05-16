%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 飞仙兑换
%%% @end
%%% Created : 18. 十月 2017 17:30
%%%-------------------------------------------------------------------
-module(xian_exchange).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("xian.hrl").

%% API
-export([
    init/1,
    midnight_refresh/1,
    get_info/1,
    exchange/2
]).

init(#player{key = Pkey} = Player) ->
    StXianExchange =
        case player_util:is_new_role(Player) of
            true -> #st_xian_exchange{pkey = Pkey};
            false -> xian_load:dbget_xian_exchange(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_XIAN_EXCHANGE, StXianExchange),
    update_xian_exchange(),
    Player.

update_xian_exchange() ->
    StXianExchange = lib_dict:get(?PROC_STATUS_XIAN_EXCHANGE),
    #st_xian_exchange{
        pkey = Pkey,
        op_time = OpTime
    } = StXianExchange,
    Now = util:unixtime(),
    case util:is_same_date(OpTime, Now) of
        false ->
            NewStXianExchange = #st_xian_exchange{pkey = Pkey};
        true ->
            NewStXianExchange = StXianExchange
    end,
    lib_dict:put(?PROC_STATUS_XIAN_EXCHANGE, NewStXianExchange).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_xian_exchange().

get_info(_Player) ->
    Ids = data_feixian_exchange:get_all(),
    StXainExchange = lib_dict:get(?PROC_STATUS_XIAN_EXCHANGE),
    #st_xian_exchange{exchange_list = ExchangeList} = StXainExchange,
    F = fun(Id) ->
        #base_xian_exchange{
            id = Id,
            exchange_cost = ExchangeCostList,
            exchange_get = ExchangeGetList,
            exchange_num = BaseExchangeNum} = data_feixian_exchange:get(Id),
        ExchangeCostList2 = lists:map(fun({GoodsId, GoodsNum}) -> [GoodsId, GoodsNum] end, ExchangeCostList),
        ExchangeGetList2 = lists:map(fun({GoodsId, GoodsNum}) -> [GoodsId, GoodsNum] end, ExchangeGetList),
        RemainExchangeNum =
            case lists:keyfind(Id, 1, ExchangeList) of
                false -> BaseExchangeNum;
                {Id, Num} -> max(0, BaseExchangeNum - Num)
            end,
        [Id, RemainExchangeNum, BaseExchangeNum, ExchangeCostList2, ExchangeGetList2]
    end,
    lists:map(F, Ids).

check_exchange(Player, Id) ->
    Ids = data_feixian_exchange:get_all(),
    BaseList = lists:map(fun(BaseId) -> data_feixian_exchange:get(BaseId) end, Ids), 
    case lists:keyfind(Id, #base_xian_exchange.id, BaseList) of
        false ->
            {fail, 0}; %% 客户端数据发错
        #base_xian_exchange{exchange_cost = ExchangeCostList, exchange_num = BaseExchangeNum, exchange_get = ExchangeGetList} ->
            StXainExchange = lib_dict:get(?PROC_STATUS_XIAN_EXCHANGE),
            #st_xian_exchange{exchange_list = ExchangeList} = StXainExchange,
            RemainExchangeNum =
                case lists:keyfind(Id, 1, ExchangeList) of
                    false -> BaseExchangeNum;
                    {Id, Num} -> max(0,BaseExchangeNum - Num)
                end,
            if
                RemainExchangeNum =< 0 ->
                    {false, 13}; %% 兑换次数不足
                true ->
                    F = fun({GoodsId, GoodsNum}) ->
                        case GoodsId of
                            10101 ->
                                Player#player.coin < GoodsNum;
                            10106 ->
                                money:is_enough(Player, GoodsNum, bgold) == false;
                            10199 ->
                                money:is_enough(Player, GoodsNum, gold) == false;
                            _ ->
                                goods_util:get_goods_count(GoodsId) < GoodsNum
                        end
                    end,
                    case lists:any(F, ExchangeCostList) of
                        true -> {false, 5}; %% 材料不足
                        false -> {true, ExchangeCostList, ExchangeGetList, StXainExchange}
                    end
            end
    end.

exchange(Player, Id) ->
    case check_exchange(Player, Id) of
        {false, Code} ->
            {Code, Player};
        {true, ExchangeCostList, ExchangeGetList, StXainExchange} ->
            #st_xian_exchange{exchange_list = ExChangeList} = StXainExchange,
            NewExchangeList =
                case lists:keytake(Id, 1, ExChangeList) of
                    false ->
                        [{Id, 1} | ExChangeList];
                    {value, {_Id, Num}, Ret} ->
                        [{Id, Num + 1} | Ret]
                end,
            NewStXainExchange = StXainExchange#st_xian_exchange{exchange_list = NewExchangeList, op_time = util:unixtime()},
            lib_dict:put(?PROC_STATUS_XIAN_EXCHANGE, NewStXainExchange),
            xian_load:dbup_xian_exchange(NewStXainExchange),
            %% 先扣除物品
            {NPlayer, NewExchangeCostList} = consume(Player, ExchangeCostList),
            goods:subtract_good(Player, NewExchangeCostList, 722),
            GiveGoodsList = goods:make_give_goods_list(723, ExchangeGetList),
            {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList),
            {1, NewPlayer}
    end.

consume(Player, ExchangeCostList) ->
    consume(Player, ExchangeCostList, []).

consume(Player, [], AccList) ->
    {Player, AccList};

consume(Player, [H|T], AccList) ->
    case H of
        {10101, Num} ->
            NewPlayer = money:add_coin(Player, -Num, 719, 0, 0),
            consume(NewPlayer, T, AccList);
        {10106, Num} ->
            NewPlayer = money:add_gold(Player, -Num, 720, 0, 0),
            consume(NewPlayer, T, AccList);
        {10199, Num} ->
            NewPlayer = money:add_no_bind_gold(Player, -Num, 721, 0, 0),
            consume(NewPlayer, T, AccList);
        _ ->
            consume(Player, T, [H | AccList])
    end.