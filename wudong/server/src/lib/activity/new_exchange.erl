%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 神秘兑换
%%% @end
%%% Created : 15. 五月 2017 18:14
%%%-------------------------------------------------------------------
-module(new_exchange).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    init/1,
    midnight_refresh/1,

    get_act_info/1,
    exchange/2,
    get_state/1,
    get_act/0
]).

init(#player{key = Pkey} = Player) ->
    StNewExchange =
        case player_util:is_new_role(Player) of
            true -> #st_new_exchange{pkey = Pkey};
            false -> activity_load:dbget_new_exchange(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_NEW_EXCHANGE, StNewExchange),
    update_new_exchange(),
    Player.

update_new_exchange() ->
    StNewExchange = lib_dict:get(?PROC_STATUS_NEW_EXCHANGE),
    #st_new_exchange{
        pkey = Pkey,
        act_id = ActId
    } = StNewExchange,
    case get_act() of
        [] ->
            NewStNewExchange = #st_new_exchange{pkey = Pkey};
        #base_new_exchange{act_id = BaseActId} ->
            Now = util:unixtime(),
            if
                BaseActId =/= ActId ->
                    NewStNewExchange = #st_new_exchange{pkey = Pkey, act_id = BaseActId, op_time = Now};
                true ->
                    NewStNewExchange = StNewExchange
            end
    end,
    lib_dict:put(?PROC_STATUS_NEW_EXCHANGE, NewStNewExchange).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_new_exchange().

get_act_info(_Player) ->
    case get_act() of
        [] ->
            {0, 0, []};
        #base_new_exchange{list = BaseList, open_info = OpenInfo} ->
            StNewExchange = lib_dict:get(?PROC_STATUS_NEW_EXCHANGE),
            #st_new_exchange{exchange_list = ExchangeList} = StNewExchange,
            F = fun(#base_new_exchange_sub{
                id = Id,
                exchange_cost = ExchangeCostList,
                exchange_get = ExchangeGetList,
                exchange_num = BaseExchangeNum}) ->
                ExchangeCostList2 = lists:map(fun({GoodsId, GoodsNum}) -> [GoodsId, GoodsNum] end, ExchangeCostList),
                ExchangeGetList2 = lists:map(fun({GoodsId, GoodsNum}) -> [GoodsId, GoodsNum] end, ExchangeGetList),
                RemainExchangeNum =
                    case lists:keyfind(Id, 1, ExchangeList) of
                        false -> BaseExchangeNum;
                        {Id, Num} -> max(0, BaseExchangeNum - Num)
                    end,
                [Id, RemainExchangeNum, ExchangeCostList2, ExchangeGetList2]
                end,
            L = lists:map(F, BaseList),
            ActLeaveTime = activity:calc_act_leave_time(OpenInfo),
            EndTime = max(0, util:unixtime() + ActLeaveTime - 1),
            {util:unixdate(), EndTime, L}
    end.

check_exchange(Player, Id, Base) ->
    #base_new_exchange{list = BaseList} = Base,
    case lists:keyfind(Id, #base_new_exchange_sub.id, BaseList) of
        false ->
            {fail, 0}; %% 客户端数据发错
        #base_new_exchange_sub{exchange_cost = ExchangeCostList, exchange_num = BaseExchangeNum, exchange_get = ExchangeGetList} ->
            StNewExchange = lib_dict:get(?PROC_STATUS_NEW_EXCHANGE),
            #st_new_exchange{exchange_list = ExchangeList} = StNewExchange,
            RemainExchangeNum =
                case lists:keyfind(Id, 1, ExchangeList) of
                    false -> BaseExchangeNum;
                    {Id, Num} -> max(0, BaseExchangeNum - Num)
                end,
            if
                RemainExchangeNum =< 0 ->
                    {false, 15}; %% 兑换次数不足
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
                        true -> {false, 16}; %% 材料不足
                        false -> {true, ExchangeCostList, ExchangeGetList, StNewExchange}
                    end
            end
    end.

exchange(Player, Id) ->
    case get_act() of
        [] ->
            {fail, 0};
        Base ->
            case check_exchange(Player, Id, Base) of
                {false, Code} ->
                    {Code, Player};
                {true, ExchangeCostList, ExchangeGetList, StNewExchange} ->
                    #st_new_exchange{exchange_list = ExChangeList} = StNewExchange,
                    NewExchangeList =
                        case lists:keytake(Id, 1, ExChangeList) of
                            false ->
                                [{Id, 1} | ExChangeList];
                            {value, {_Id, Num}, Ret} ->
                                [{Id, Num + 1} | Ret]
                        end,
                    NewStNewExchange = StNewExchange#st_new_exchange{exchange_list = NewExchangeList},
                    lib_dict:put(?PROC_STATUS_NEW_EXCHANGE, NewStNewExchange),
                    activity_load:dbup_new_exchange(NewStNewExchange),
                    %% 先扣除物品
                    {NPlayer, NewExchangeCostList} = consume(Player, ExchangeCostList),
                    goods:subtract_good(Player, NewExchangeCostList, 626),
                    GiveGoodsList = goods:make_give_goods_list(627, ExchangeGetList),
                    {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList),
                    activity:get_notice(Player, [40, 119], true),
                    {1, NewPlayer}
            end
    end.

consume(Player, ExchangeCostList) ->
    consume(Player, ExchangeCostList, []).

consume(Player, [], AccList) ->
    {Player, AccList};

consume(Player, [H | T], AccList) ->
    case H of
        {10101, Num} ->
            NewPlayer = money:add_coin(Player, -Num, 630, 0, 0),
            consume(NewPlayer, T, AccList);
        {10106, Num} ->
            NewPlayer = money:add_gold(Player, -Num, 631, 0, 0),
            consume(NewPlayer, T, AccList);
        {10199, Num} ->
            NewPlayer = money:add_no_bind_gold(Player, -Num, 632, 0, 0),
            consume(NewPlayer, T, AccList);
        _ ->
            consume(Player, T, [H | AccList])
    end.


get_state(_Player) ->
    case get_act() of
        [] ->
            -1;
        #base_new_exchange{list = BaseList, act_info = ActInfo} = Base ->
            F = fun(#base_new_exchange_sub{id = Id}) ->
                case check_exchange(_Player, Id, Base) of
                    {false, _Code} ->
                        false;
                    _ ->
                        true
                end
                end,
            Bool = lists:any(F, BaseList),
            Args = activity:get_base_state(ActInfo),
            ?IF_ELSE(Bool == true, {1, Args}, {0, Args})
    end.

get_act() ->
    case activity:get_work_list(data_new_exchange) of
        [] -> [];
        [Base | _] -> Base
    end.