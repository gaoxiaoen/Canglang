%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 神秘兑换
%%% @end
%%% Created : 15. 五月 2017 18:14
%%%-------------------------------------------------------------------
-module(merge_exchange).
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
            true -> #st_merge_exchange{pkey = Pkey};
            false -> activity_load:dbget_merge_exchange(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_MERGE_EXCHANGE, StNewExchange),
    update_merge_exchange(),
    Player.

update_merge_exchange() ->
    StNewExchange = lib_dict:get(?PROC_STATUS_MERGE_EXCHANGE),
    #st_merge_exchange{
        pkey = Pkey,
        act_id = ActId
    } = StNewExchange,
    case get_act() of
        [] ->
            NewStNewExchange = #st_merge_exchange{pkey = Pkey};
        #base_merge_exchange{act_id = BaseActId} ->
            Now = util:unixtime(),
            if
                BaseActId =/= ActId ->
                    NewStNewExchange = #st_merge_exchange{pkey = Pkey, act_id = BaseActId, op_time = Now};
                true ->
                    NewStNewExchange = StNewExchange
            end
    end,
    lib_dict:put(?PROC_STATUS_MERGE_EXCHANGE, NewStNewExchange).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_merge_exchange().

get_act_info(_Player) ->
    case get_act() of
        [] ->
            {0, []};
        #base_merge_exchange{list = BaseList, open_info = OpenInfo} ->
            StNewExchange = lib_dict:get(?PROC_STATUS_MERGE_EXCHANGE),
            #st_merge_exchange{exchange_list = ExchangeList} = StNewExchange,
            F = fun(#base_merge_exchange_sub{
                        id = Id,
                        exchange_cost = ExchangeCostList,
                        exchange_get = ExchangeGetList,
                        exchange_num = BaseExchangeNum}) ->
                ExchangeCostList2 = lists:map(fun({GoodsId, GoodsNum}) -> [GoodsId, GoodsNum] end, ExchangeCostList),
                ExchangeGetList2 = lists:map(fun({GoodsId, GoodsNum}) -> [GoodsId, GoodsNum] end, ExchangeGetList),
                RemainExchangeNum =
                    case lists:keyfind(Id, 1, ExchangeList) of
                        false -> BaseExchangeNum;
                        {Id, Num} -> max(0,BaseExchangeNum - Num)
                    end,
                [Id, RemainExchangeNum, ExchangeCostList2, ExchangeGetList2]
            end,
            L = lists:map(F, BaseList),
            ActLeaveTime = activity:calc_act_leave_time(OpenInfo),
            {ActLeaveTime, L}
    end.

check_exchange(Player, Id, Base) ->
    #base_merge_exchange{list = BaseList} = Base,
    case lists:keyfind(Id, #base_merge_exchange_sub.id, BaseList) of
        false ->
            {fail, 0}; %% 客户端数据发错
        #base_merge_exchange_sub{exchange_cost = ExchangeCostList, exchange_num = BaseExchangeNum, exchange_get = ExchangeGetList} ->
            StNewExchange = lib_dict:get(?PROC_STATUS_MERGE_EXCHANGE),
            #st_merge_exchange{exchange_list = ExchangeList} = StNewExchange,
            RemainExchangeNum =
                case lists:keyfind(Id, 1, ExchangeList) of
                    false -> BaseExchangeNum;
                    {Id, Num} -> max(0,BaseExchangeNum - Num)
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
                    #st_merge_exchange{exchange_list = ExChangeList} = StNewExchange,
                    NewExchangeList =
                        case lists:keytake(Id, 1, ExChangeList) of
                            false ->
                                [{Id, 1} | ExChangeList];
                            {value, {_Id, Num}, Ret} ->
                                [{Id, Num + 1} | Ret]
                        end,
                    NewStNewExchange = StNewExchange#st_merge_exchange{exchange_list = NewExchangeList},
                    lib_dict:put(?PROC_STATUS_MERGE_EXCHANGE, NewStNewExchange),
                    activity_load:dbup_merge_exchange(NewStNewExchange),
                    %% 先扣除物品
                    {NPlayer, NewExchangeCostList} = consume(Player, ExchangeCostList),
                    goods:subtract_good(Player, NewExchangeCostList, 663),
                    GiveGoodsList = goods:make_give_goods_list(664, ExchangeGetList),
                    {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList),
                    activity:get_notice(Player, [46], true),
                    {1, NewPlayer}
            end
    end.

consume(Player, ExchangeCostList) ->
    consume(Player, ExchangeCostList, []).

consume(Player, [], AccList) ->
    {Player, AccList};

consume(Player, [H|T], AccList) ->
    case H of
        {10101, Num} ->
            NewPlayer = money:add_coin(Player, -Num, 660, 0, 0),
            consume(NewPlayer, T, AccList);
        {10106, Num} ->
            NewPlayer = money:add_gold(Player, -Num, 661, 0, 0),
            consume(NewPlayer, T, AccList);
        {10199, Num} ->
            NewPlayer = money:add_no_bind_gold(Player, -Num, 662, 0, 0),
            consume(NewPlayer, T, AccList);
        _ ->
            consume(Player, T, [H | AccList])
    end.


get_state(_Player) ->
    case get_act() of
        [] ->
            -1;
        #base_merge_exchange{list = BaseList} = Base ->
            F = fun(#base_merge_exchange_sub{id = Id}) ->
                case check_exchange(_Player, Id, Base) of
                    {false, _Code} ->
                        false;
                    _ ->
                        true
                end
            end,
            Bool = lists:any(F, BaseList),
            ?IF_ELSE(Bool == true, 1, 0)
    end.

get_act() ->
    case activity:get_work_list(data_merge_exchange) of
        [] -> [];
        [Base | _] -> Base
    end.