%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 十二月 2017 15:29
%%%-------------------------------------------------------------------
-module(re_exchange).
-author("Administrator").

%% API
-export([]).

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
    StReturnExchange =
        case player_util:is_new_role(Player) of
            true -> #st_return_exchange{pkey = Pkey};
            false -> activity_load:dbget_return_exchange(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_RETURN_EXCHANGE, StReturnExchange),
    update_return_exchange(),
    Player.

update_return_exchange() ->
    StReturnExchange = lib_dict:get(?PROC_STATUS_RETURN_EXCHANGE),
    #st_return_exchange{
        pkey = Pkey,
        act_id = ActId
    } = StReturnExchange,
    case get_act() of
        [] ->
            NewStReturnExchange = #st_return_exchange{pkey = Pkey};
        #base_return_exchange{act_id = BaseActId} ->
            Now = util:unixtime(),
            if
                BaseActId =/= ActId ->
                    NewStReturnExchange = #st_return_exchange{pkey = Pkey, act_id = BaseActId, op_time = Now};
                true ->
                    NewStReturnExchange = StReturnExchange
            end
    end,
    lib_dict:put(?PROC_STATUS_RETURN_EXCHANGE, NewStReturnExchange).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_return_exchange().

get_act_info(_Player) ->
    case get_act() of
        [] ->
            {0, 0, []};
        #base_return_exchange{list = BaseList, open_info = OpenInfo} ->
            StReturnExchange = lib_dict:get(?PROC_STATUS_RETURN_EXCHANGE),
            #st_return_exchange{exchange_list = ExchangeList} = StReturnExchange,
            F = fun(#base_return_exchange_sub{
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
            {ActLeaveTime, EndTime, L}
    end.

check_exchange(Player, Id, Base) ->
    #base_return_exchange{list = BaseList} = Base,
    case lists:keyfind(Id, #base_return_exchange_sub.id, BaseList) of
        false ->
            {fail, 0}; %% 客户端数据发错
        #base_return_exchange_sub{exchange_cost = ExchangeCostList, exchange_num = BaseExchangeNum, exchange_get = ExchangeGetList} ->
            StReturnExchange = lib_dict:get(?PROC_STATUS_RETURN_EXCHANGE),
            #st_return_exchange{exchange_list = ExchangeList} = StReturnExchange,
            RemainExchangeNum =
                case lists:keyfind(Id, 1, ExchangeList) of
                    false -> BaseExchangeNum;
                    {Id, Num} -> max(0, BaseExchangeNum - Num)
                end,
            if
                RemainExchangeNum =< 0 ->
                    {false, 16}; %% 兑换次数不足
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
                        true -> {false, 15}; %% 材料不足
                        false -> {true, ExchangeCostList, ExchangeGetList, StReturnExchange}
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
                {true, ExchangeCostList, ExchangeGetList, StReturnExchange} ->
                    #st_return_exchange{exchange_list = ExChangeList} = StReturnExchange,
                    NewExchangeList =
                        case lists:keytake(Id, 1, ExChangeList) of
                            false ->
                                [{Id, 1} | ExChangeList];
                            {value, {_Id, Num}, Ret} ->
                                [{Id, Num + 1} | Ret]
                        end,
                    NewStReturnExchange = StReturnExchange#st_return_exchange{exchange_list = NewExchangeList},
                    lib_dict:put(?PROC_STATUS_RETURN_EXCHANGE, NewStReturnExchange),
                    activity_load:dbup_return_exchange(NewStReturnExchange),
                    %% 先扣除物品
                    {NPlayer, NewExchangeCostList} = consume(Player, ExchangeCostList),
                    goods:subtract_good(Player, NewExchangeCostList, 576),
                    GiveGoodsList = goods:make_give_goods_list(577, ExchangeGetList),
                    {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList),
                    activity:get_notice(Player, [177], true),
%%                    Sql = io_lib:format("insert into log_return_exchange set pkey=~p,consume='~s',get_list='~s',time=~p",
%%                        [Player#player.key, util:term_to_bitstring(ExchangeCostList), util:term_to_bitstring(ExchangeGetList), util:unixtime()]),
%%                    log_proc:log(Sql),
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
            NewPlayer = money:add_coin(Player, -Num, 578, 0, 0),
            consume(NewPlayer, T, AccList);
        {10106, Num} ->
            NewPlayer = money:add_gold(Player, -Num, 579, 0, 0),
            consume(NewPlayer, T, AccList);
        {10199, Num} ->
            NewPlayer = money:add_no_bind_gold(Player, -Num, 580, 0, 0),
            consume(NewPlayer, T, AccList);
        _ ->
            consume(Player, T, [H | AccList])
    end.


get_state(_Player) ->
    case get_act() of
        [] ->
            -1;
        #base_return_exchange{list = BaseList} = Base ->
            F = fun(#base_return_exchange_sub{id = Id}) ->
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
    case activity:get_work_list(data_return_exchange) of
        [] -> [];
        [Base | _] -> Base
    end.