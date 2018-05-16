%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 返利抢购
%%% @end
%%% Created : 19. 六月 2017 17:59
%%%-------------------------------------------------------------------
-module(merge_act_back_buy).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    init/1,
    init/0,
    init_ets/0,
    midnight_refresh/1,
    sys_midnight_refresh/0,
    update_act_back_buy_cast/2,

    get_act_info/1,
    buy/2,
    get_state/1
]).

init_ets() ->
    ets:new(?ETS_MERGE_BACK_BUY, [{keypos, #ets_merge_back_buy.key} | ?ETS_OPTIONS]).

init() ->
    case get_act() of
        [] ->
            ok;
        #base_merge_act_back_buy{act_id = ActId} ->
            SysList = activity_load:dbget_all_merge_back_buy(ActId),
            F = fun([OrderId, TotalNum]) ->
                Ets = #ets_merge_back_buy{key = {ActId, OrderId}, act_id = ActId, order_id = OrderId, total_num = TotalNum},
                ets:insert(?ETS_MERGE_BACK_BUY, Ets)
            end,
            lists:map(F, SysList),
            ok
    end.

init(#player{key = Pkey} = Player) ->
    StMergeActBackBuy =
        case player_util:is_new_role(Player) of
            true -> #st_merge_back_buy{pkey = Pkey};
            false -> activity_load:dbget_merge_act_back_buy(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_MERGE_ACT_BACK_BUY, StMergeActBackBuy),
    update_merge_act_back_buy(),
    Player.

update_merge_act_back_buy() ->
    StMergeActBackBuy = lib_dict:get(?PROC_STATUS_MERGE_ACT_BACK_BUY),
    #st_merge_back_buy{
        pkey = Pkey,
        act_id = ActId
    } = StMergeActBackBuy,
    case get_act() of
        [] ->
            NewStMergeActBackBuy = #st_merge_back_buy{pkey = Pkey};
        #base_merge_act_back_buy{act_id = BaseActId} ->
            Now = util:unixtime(),
            if
                BaseActId =/= ActId ->
                    NewStMergeActBackBuy = #st_merge_back_buy{pkey = Pkey, act_id = BaseActId, op_time = Now};
                true ->
                    NewStMergeActBackBuy = StMergeActBackBuy
            end
    end,
    lib_dict:put(?PROC_STATUS_MERGE_ACT_BACK_BUY, NewStMergeActBackBuy).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_merge_act_back_buy().

%% 系统晚上12点刷新
sys_midnight_refresh() ->
    case get_act() of
        [] ->
            ets:delete_all_objects(?ETS_MERGE_BACK_BUY);
        #base_merge_act_back_buy{act_id = BaseActId} ->
            List = ets:tab2list(?ETS_MERGE_BACK_BUY),
            if
                List == [] -> skip;
                true ->
                    Ets = hd(List),
                    if
                        Ets#ets_merge_back_buy.act_id =:= BaseActId -> skip;
                        true -> ets:delete_all_objects(?ETS_MERGE_BACK_BUY)
                    end
            end
    end.


get_act_info(_Player) ->
    update_merge_act_back_buy(),
    case get_act() of
        [] ->
            {0, []};
        #base_merge_act_back_buy{act_id = _ActId, act_type = ActType, open_info = OpenInfo} ->
            Ids = data_merge_back_buy:get_ids_by_actType(ActType),
            StMergeActBackBuy = lib_dict:get(?PROC_STATUS_MERGE_ACT_BACK_BUY),
            #st_merge_back_buy{
                buy_list = BuyList
            } = StMergeActBackBuy,
            F = fun(Id) ->
                #base_act_back_buy{
                    order_id = OrderId,
                    discount = Discount,
                    base_price = BasePrice,
                    price = Price,
                    hour = Hour,
                    goods_id = GoodsId,
                    goods_num = GoodsNum,
                    limit_num = LimitNum
                } = data_merge_back_buy:get(Id),
                IsHour = ?IF_ELSE(Hour == 0, 0, 1),
                case lists:keyfind(OrderId,1,BuyList) of
                    false ->
                        [OrderId, 1, Discount, BasePrice, Price, IsHour, GoodsId, GoodsNum, LimitNum];
                    {_, UseNum} ->
                        RemainNum = max(0, LimitNum-UseNum),
                        State = ?IF_ELSE(RemainNum == 0, 2, 1),
                        [OrderId, State, Discount, BasePrice, Price, IsHour, GoodsId, GoodsNum, RemainNum]
                end
            end,
            LL = lists:map(F, Ids),
            LeaveTime = activity:calc_act_leave_time(OpenInfo),
            {LeaveTime, LL}
    end.

buy(Player, OrderId) ->
    update_merge_act_back_buy(),
    case get_act() of
        [] ->
            {0, Player};
        #base_merge_act_back_buy{act_id = ActId, act_type = ActType} ->
            StMergeActBackBuy = lib_dict:get(?PROC_STATUS_MERGE_ACT_BACK_BUY),
            #st_merge_back_buy{
                act_id = ActId
            } = StMergeActBackBuy,
            case check(Player, OrderId, ActId, ActType, StMergeActBackBuy) of
                {fail, Code} ->
                    {Code, Player};
                {true, Base, NewBuyList} ->
                    NewStMergeActBackBuy = StMergeActBackBuy#st_merge_back_buy{buy_list = NewBuyList},
                    activity_load:dbup_merge_act_back_buy(NewStMergeActBackBuy),
                    lib_dict:put(?PROC_STATUS_MERGE_ACT_BACK_BUY, NewStMergeActBackBuy),
                    #base_act_back_buy{price = Price, goods_num = GoodsNum, goods_id = GoodsId, hour = Hour} = Base,
                    NewPlayer0 = money:add_no_bind_gold(Player, -Price, 658, GoodsId, GoodsNum),
                    GiveGoodsList =
                        if
                            Hour == 0 ->
                                goods:make_give_goods_list(659, [{GoodsId, GoodsNum}]);
                            true ->
                                goods:make_give_goods_list(659, [{GoodsId, GoodsNum, 0, util:unixtime() + Hour * ?ONE_HOUR_SECONDS}])
                        end,
                    {ok, NewPlayer} = goods:give_goods(NewPlayer0, GiveGoodsList),
                    ?CAST(activity_proc:get_act_pid(), {update_merge_act_back_buy, ActId, OrderId}),
                    {1, NewPlayer}
            end
    end.

update_act_back_buy_cast(ActId, OrderId) ->
    Ets = lookup(ActId, OrderId),
    NewEts = Ets#ets_merge_back_buy{total_num = Ets#ets_merge_back_buy.total_num + 1},
    ets:insert(?ETS_MERGE_BACK_BUY, NewEts),
    activity_load:dbup_all_merge_back_buy(NewEts),
    ok.

check(Player, OrderId, ActId, ActType, StMergeActBackBuy) ->
    case data_merge_back_buy:get_by_actType_orderId(ActType, OrderId) of
        [] ->
            {fail, 0};
        #base_act_back_buy{price = Price, limit_num = LimitNum, sys_limit_num = SysLimitNum} = Base ->
            case money:is_enough(Player, Price, gold) of
                false ->
                    {fail, 5}; %% 元宝不足
                true ->
                    #st_merge_back_buy{
                        buy_list = BuyList
                    } = StMergeActBackBuy,
                    case lists:keytake(OrderId, 1, BuyList) of
                        false ->
                            {true, Base, [{OrderId, 1} | BuyList]};
                        {value, {_OrderId, Num}, Rest} ->
                            Ets = lookup(ActId, OrderId),
                            if
                                LimitNum =< Num ->
                                    {fail, 11}; %% 个人抢购次数不足
                                SysLimitNum =< Ets#ets_merge_back_buy.total_num ->
                                    {fail, 10}; %% 系统抢购次数不足
                                true ->
                                    {true, Base, [{OrderId, Num + 1} | Rest]}
                            end
                    end
            end
    end.

lookup(ActId, OrderId) ->
    Key = {ActId, OrderId},
    case ets:lookup(?ETS_MERGE_BACK_BUY, Key) of
        [Ets] ->
            Ets;
        _ ->
            Ets = #ets_merge_back_buy{key = Key, act_id = ActId, order_id = OrderId},
            ets:insert(?ETS_MERGE_BACK_BUY, Ets),
            Ets
    end.

get_act() ->
    case activity:get_work_list(data_merge_act_back_buy) of
        [] -> [];
        [Base | _] -> Base
    end.

get_state(_Player) ->
    case get_act() of
        [] -> -1;
        _ ->
            case get(merge_act_back_buy) of
                1 ->
                    0;
                _ ->
                    put(merge_act_back_buy, 1),
                    1
            end
    end.