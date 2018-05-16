%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 节日活动之返利抢购
%%% @end
%%% Created : 22. 九月 2017 20:35
%%%-------------------------------------------------------------------
-module(festival_back_buy).
-author("li").

-include("server.hrl").
-include("common.hrl").
-include("activity.hrl").

%% API
-export([
    init/1,
    init/0,
    init_ets/0,
    midnight_refresh/1,
    sys_midnight_refresh/0,
    update_festival_back_buy_cast/2,

    get_act_info/1,
    buy/2,
    get_state/1,
    get_act/0
]).

init_ets() ->
    ets:new(?ETS_FESTIVAL_BACK_BUY, [{keypos, #ets_festival_back_buy.key} | ?ETS_OPTIONS]).

init() ->
    case get_act() of
        [] ->
            ok;
        _ ->
            OpenDay = config:get_open_days(),
            SysList = activity_load:dbget_all_festival_back_buy(OpenDay),
            F = fun([OrderId, TotalNum]) ->
                Ets = #ets_festival_back_buy{key = {OpenDay, OrderId}, open_day = OpenDay, order_id = OrderId, total_num = TotalNum},
                ets:insert(?ETS_FESTIVAL_BACK_BUY, Ets)
            end,
            lists:map(F, SysList),
            ok
    end.

init(#player{key = Pkey} = Player) ->
    StFestivalActBackBuy =
        case player_util:is_new_role(Player) of
            true -> #st_festival_back_buy{pkey = Pkey};
            false -> activity_load:dbget_festival_act_back_buy(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_FESTIVAL_BACK_BUY, StFestivalActBackBuy),
    update_festival_act_back_buy(),
    Player.

update_festival_act_back_buy() ->
    StFestivalActBackBuy = lib_dict:get(?PROC_STATUS_FESTIVAL_BACK_BUY),
    #st_festival_back_buy{
        pkey = Pkey,
        open_day = OpenDay
    } = StFestivalActBackBuy,
    SysOpenDay = config:get_open_days(),
    if
        SysOpenDay =/= OpenDay ->
            NewStFestivalActBackBuy = #st_festival_back_buy{pkey = Pkey, open_day = SysOpenDay};
        true ->
            NewStFestivalActBackBuy = StFestivalActBackBuy
    end,
    lib_dict:put(?PROC_STATUS_FESTIVAL_BACK_BUY, NewStFestivalActBackBuy).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_festival_act_back_buy().

%% 系统晚上12点刷新
sys_midnight_refresh() ->
    ets:delete_all_objects(?ETS_FESTIVAL_BACK_BUY).


get_act_info(_Player) ->
    update_festival_act_back_buy(),
    case get_act() of
        [] ->
            {0, []};
        #base_festival_act_back_buy{act_type = ActType} ->
            Ids = data_festival_back_buy:get_ids_by_actType(ActType),
            StFestivalActBackBuy = lib_dict:get(?PROC_STATUS_FESTIVAL_BACK_BUY),
            #st_festival_back_buy{
                buy_list = BuyList
            } = StFestivalActBackBuy,
            F = fun(Id) ->
                #base_festival_back_buy{
                    order_id = OrderId,
                    discount = Discount,
                    base_price = BasePrice,
                    price = Price,
                    hour = Hour,
                    goods_id = GoodsId,
                    goods_num = GoodsNum,
                    limit_num = LimitNum
                } = data_festival_back_buy:get(Id),
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
    update_festival_act_back_buy(),
    case get_act() of
        false ->
            {0, Player};
        #base_festival_act_back_buy{act_type = ActType} ->
            StFestivalActBackBuy = lib_dict:get(?PROC_STATUS_FESTIVAL_BACK_BUY),
            OpenDay = config:get_open_days(),
            case check(Player, OrderId, OpenDay, ActType, StFestivalActBackBuy) of
                {fail, Code} ->
                    {Code, Player};
                {true, Base, NewBuyList} ->
                    NewStFestivalActBackBuy = StFestivalActBackBuy#st_festival_back_buy{buy_list = NewBuyList},
                    activity_load:dbup_festival_act_back_buy(NewStFestivalActBackBuy),
                    lib_dict:put(?PROC_STATUS_FESTIVAL_BACK_BUY, NewStFestivalActBackBuy),
                    #base_festival_back_buy{price = Price, goods_num = GoodsNum, goods_id = GoodsId, hour = Hour} = Base,
                    NewPlayer0 = money:add_no_bind_gold(Player, -Price, 698, GoodsId, GoodsNum),
                    GiveGoodsList =
                        if
                            Hour == 0 ->
                                goods:make_give_goods_list(699, [{GoodsId, GoodsNum}]);
                            true ->
                                goods:make_give_goods_list(699, [{GoodsId, GoodsNum, 0, util:unixtime() + Hour * ?ONE_HOUR_SECONDS}])
                        end,
                    {ok, NewPlayer} = goods:give_goods(NewPlayer0, GiveGoodsList),
                    ?CAST(activity_proc:get_act_pid(), {update_festival_back_buy, OpenDay, OrderId}),
                    Sql = io_lib:format("replace into log_festival_back_buy set pkey=~p, goods_id=~p, goods_num=~p, cost_gold=~p, time=~p",
                        [Player#player.key, GoodsId, GoodsNum, Price, util:unixtime()]),
                    log_proc:log(Sql),
                    {1, NewPlayer}
            end
    end.

update_festival_back_buy_cast(OpenDay, OrderId) ->
    Ets = lookup(OpenDay, OrderId),
    NewEts = Ets#ets_festival_back_buy{total_num = Ets#ets_festival_back_buy.total_num + 1},
    ets:insert(?ETS_FESTIVAL_BACK_BUY, NewEts),
    activity_load:dbup_all_festival_back_buy(NewEts),
    ok.

check(Player, OrderId, OpenDay, ActType, StFestivalActBackBuy) ->
    case data_festival_back_buy:get_by_actType_orderId(ActType, OrderId) of
        [] ->
            {fail, 0};
        #base_festival_back_buy{price = Price, limit_num = LimitNum, sys_limit_num = SysLimitNum} = Base ->
            case money:is_enough(Player, Price, gold) of
                false ->
                    {fail, 2}; %% 元宝不足
                true ->
                    #st_festival_back_buy{
                        buy_list = BuyList
                    } = StFestivalActBackBuy,
                    case lists:keytake(OrderId, 1, BuyList) of
                        false ->
                            {true, Base, [{OrderId, 1} | BuyList]};
                        {value, {_OrderId, Num}, Rest} ->
                            Ets = lookup(OpenDay, OrderId),
                            if
                                LimitNum =< Num ->
                                    {fail, 11}; %% 个人抢购次数不足
                                SysLimitNum =< Ets#ets_festival_back_buy.total_num ->
                                    {fail, 13}; %% 系统抢购次数不足
                                true ->
                                    {true, Base, [{OrderId, Num + 1} | Rest]}
                            end
                    end
            end
    end.

lookup(OpenDay, OrderId) ->
    Key = {OpenDay, OrderId},
    case ets:lookup(?ETS_FESTIVAL_BACK_BUY, Key) of
        [Ets] ->
            Ets;
        _ ->
            Ets = #ets_festival_back_buy{key = Key, order_id = OrderId, open_day = OpenDay},
            ets:insert(?ETS_FESTIVAL_BACK_BUY, Ets),
            Ets
    end.

get_act() ->
    case activity:get_work_list(data_festival_act_back_buy) of
        [] -> [];
        [Base | _] -> Base
    end.

get_state(_Player) ->
    case get_act() of
        [] -> -1;
        _ ->
            0
%%             case get(festival_back_buy) of
%%                 1 ->
%%                     0;
%%                 _ ->
%%                     put(festival_back_buy, 1),
%%                     1
%%             end
    end.