%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 返利抢购
%%% @end
%%% Created : 19. 六月 2017 17:59
%%%-------------------------------------------------------------------
-module(open_act_back_buy).
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
    get_state/1,
    get_act/0
]).

init_ets() ->
    ets:new(?ETS_OPEN_BACK_BUY, [{keypos, #ets_open_back_buy.key} | ?ETS_OPTIONS]).

init() ->
    case get_act() of
        false ->
            ok;
        _ ->
            OpenDay = config:get_open_days(),
            SysList = activity_load:dbget_all_back_buy(OpenDay),
            F = fun([OrderId, TotalNum]) ->
                Ets = #ets_open_back_buy{key = {OpenDay, OrderId}, open_day = OpenDay, order_id = OrderId, total_num = TotalNum},
                ets:insert(?ETS_OPEN_BACK_BUY, Ets)
            end,
            lists:map(F, SysList),
            ok
    end.

init(#player{key = Pkey} = Player) ->
    StOpenActBackBuy =
        case player_util:is_new_role(Player) of
            true -> #st_act_back_buy{pkey = Pkey};
            false -> activity_load:dbget_open_act_back_buy(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_OPEN_ACT_BACK_BUY, StOpenActBackBuy),
    update_open_act_back_buy(),
    Player.

update_open_act_back_buy() ->
    StOpenActBackBuy = lib_dict:get(?PROC_STATUS_OPEN_ACT_BACK_BUY),
    #st_act_back_buy{
        pkey = Pkey,
        open_day = OpenDay
    } = StOpenActBackBuy,
    SysOpenDay = config:get_open_days(),
    if
        SysOpenDay =/= OpenDay ->
            NewStOpenActBackBuy = #st_act_back_buy{pkey = Pkey, open_day = SysOpenDay};
        true ->
            NewStOpenActBackBuy = StOpenActBackBuy
    end,
    lib_dict:put(?PROC_STATUS_OPEN_ACT_BACK_BUY, NewStOpenActBackBuy).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_open_act_back_buy().

%% 系统晚上12点刷新
sys_midnight_refresh() ->
    ets:delete_all_objects(?ETS_OPEN_BACK_BUY).


get_act_info(_Player) ->
    update_open_act_back_buy(),
    case get_act() of
        false ->
            {0, []};
        ActType ->
            Ids = data_open_back_buy:get_ids_by_actType(ActType),
            StOpenActBackBuy = lib_dict:get(?PROC_STATUS_OPEN_ACT_BACK_BUY),
            #st_act_back_buy{
                buy_list = BuyList
            } = StOpenActBackBuy,
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
                } = data_open_back_buy:get(Id),
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
            LTime = util:unixdate()+?ONE_DAY_SECONDS - util:unixtime(),
            {LTime, LL}
    end.

buy(Player, OrderId) ->
    update_open_act_back_buy(),
    case get_act() of
        false ->
            {0, Player};
        ActType ->
            StOpenActBackBuy = lib_dict:get(?PROC_STATUS_OPEN_ACT_BACK_BUY),
            OpenDay = config:get_open_days(),
            case check(Player, OrderId, OpenDay, ActType, StOpenActBackBuy) of
                {fail, Code} ->
                    {Code, Player};
                {true, Base, NewBuyList} ->
                    NewStOpenActBackBuy = StOpenActBackBuy#st_act_back_buy{buy_list = NewBuyList},
                    activity_load:dbup_open_act_back_buy(NewStOpenActBackBuy),
                    lib_dict:put(?PROC_STATUS_OPEN_ACT_BACK_BUY, NewStOpenActBackBuy),
                    #base_act_back_buy{price = Price, goods_num = GoodsNum, goods_id = GoodsId, hour = Hour} = Base,
                    NewPlayer0 = money:add_no_bind_gold(Player, -Price, 640, GoodsId, GoodsNum),
                    GiveGoodsList =
                        if
                            Hour == 0 ->
                                goods:make_give_goods_list(641, [{GoodsId, GoodsNum}]);
                            true ->
                                goods:make_give_goods_list(641, [{GoodsId, GoodsNum, 0, util:unixtime() + Hour * ?ONE_HOUR_SECONDS}])
                        end,
                    {ok, NewPlayer} = goods:give_goods(NewPlayer0, GiveGoodsList),
                    ?CAST(activity_proc:get_act_pid(), {update_act_back_buy, OpenDay, OrderId}),
                    {1, NewPlayer}
            end
    end.

update_act_back_buy_cast(OpenDay, OrderId) ->
    Ets = lookup(OpenDay, OrderId),
    NewEts = Ets#ets_open_back_buy{total_num = Ets#ets_open_back_buy.total_num + 1},
    ets:insert(?ETS_OPEN_BACK_BUY, NewEts),
    activity_load:dbup_all_back_buy(NewEts),
    ok.

check(Player, OrderId, OpenDay, ActType, StOpenActBackBuy) ->
    case data_open_back_buy:get_by_actType_orderId(ActType, OrderId) of
        [] ->
            {fail, 0};
        #base_act_back_buy{price = Price, limit_num = LimitNum, sys_limit_num = SysLimitNum} = Base ->
            case money:is_enough(Player, Price, gold) of
                false ->
                    {fail, 5}; %% 元宝不足
                true ->
                    #st_act_back_buy{
                        buy_list = BuyList
                    } = StOpenActBackBuy,
                    case lists:keytake(OrderId, 1, BuyList) of
                        false ->
                            {true, Base, [{OrderId, 1} | BuyList]};
                        {value, {_OrderId, Num}, Rest} ->
                            Ets = lookup(OpenDay, OrderId),
                            if
                                LimitNum =< Num ->
                                    {fail, 11}; %% 个人抢购次数不足
                                SysLimitNum =< Ets#ets_open_back_buy.total_num ->
                                    {fail, 10}; %% 系统抢购次数不足
                                true ->
                                    {true, Base, [{OrderId, Num + 1} | Rest]}
                            end
                    end
            end
    end.

lookup(OpenDay, OrderId) ->
    Key = {OpenDay, OrderId},
    case ets:lookup(?ETS_OPEN_BACK_BUY, Key) of
        [Ets] ->
            Ets;
        _ ->
            Ets = #ets_open_back_buy{key = Key, order_id = OrderId, open_day = OpenDay},
            ets:insert(?ETS_OPEN_BACK_BUY, Ets),
            Ets
    end.

get_act() ->
    OpenDay = config:get_open_days(),
    get_act(OpenDay).
get_act(OpenDay) ->
    case ets:lookup(?ETS_ACT_OPEN_INFO, OpenDay) of
        [] -> false;
        [#ets_act_info{act_info = ActInfo}] ->
            case lists:keyfind(?ACT_BACK_BUY, 1, ActInfo) of
                false -> false;
                {_Act, ActType} -> ActType
            end
    end.

get_state(_Player) ->
    case get_act() of
        false -> -1;
        _ ->
            case get(open_act_back_buy) of
                1 ->
                    0;
                _ ->
                    put(open_act_back_buy, 1),
                    1
            end
    end.