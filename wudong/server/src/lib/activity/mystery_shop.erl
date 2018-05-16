%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% %% 神秘商城
%%% @end
%%% Created : 28. 八月 2017 17:50
%%%-------------------------------------------------------------------
-module(mystery_shop).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    init/1,
    midnight_refresh/1,
    get_act/0,

    get_act_info/1,
    get_notice_state/1,
    refresh/2,
    buy_order/2,
    recv/2,
    gm/1
]).

gm(Time) ->
    StMysteryShop = lib_dict:get(?PROC_STATUS_MYSTERY_SHOP),
    #st_mystery_shop{
        refresh_time = RefreshTime
    } = StMysteryShop,
    NewSt = StMysteryShop#st_mystery_shop{refresh_time = RefreshTime - Time},
    lib_dict:put(?PROC_STATUS_MYSTERY_SHOP, NewSt).


init(#player{key = Pkey} = Player) ->
    StMysteryShop =
        case player_util:is_new_role(Player) of
            true -> #st_mystery_shop{pkey = Pkey};
            false -> activity_load:dbget_mystery_shop(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_MYSTERY_SHOP, StMysteryShop),
    update_mystery_shop(),
    Player.

update_mystery_shop() ->
    StMysteryShop = lib_dict:get(?PROC_STATUS_MYSTERY_SHOP),
    #st_mystery_shop{
        pkey = Pkey,
        act_id = ActId
    } = StMysteryShop,
    case get_act() of
        [] ->
            NewStMysteryShop = #st_mystery_shop{pkey = Pkey};
        #base_mystery_shop{act_id = BaseActId} ->
            if
                BaseActId =/= ActId ->
                    NewStMysteryShop = #st_mystery_shop{pkey = Pkey, act_id = BaseActId};
                true ->
                    NewStMysteryShop = StMysteryShop
            end
    end,
    lib_dict:put(?PROC_STATUS_MYSTERY_SHOP, NewStMysteryShop).


%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_mystery_shop().

get_act() ->
    case activity:get_work_list(data_mystery_shop) of
        [] -> [];
        [Base | _] -> Base
    end.

get_act_info(Player) ->
    case get_act() of
        [] ->
            {0, 0, 0, 0, [], [], []};
        #base_mystery_shop{
            open_info = OpenInfo,
            act_type = ActType,
            refresh_cost = RefreshCost,
            refresh_cd_time = RefreshCdTime,
            show_list = ShowList
        } ->
            update_first_refresh(Player),
            LTime = activity:calc_act_leave_time(OpenInfo),
            St = lib_dict:get(?PROC_STATUS_MYSTERY_SHOP),
            #st_mystery_shop{
                shop_info = ShopInfo,
                refresh_num = RefreshNum,
                refresh_time = RefreshTime,
                recv_refresh_reward = RecvRefreshRewardList
            } = St,
            ?DEBUG("refresh_time :~p", [RefreshTime]),
            FreeRefreshTime = max(0, RefreshCdTime + RefreshTime - util:unixtime()),
            NewShowList = util:list_tuple_to_list(ShowList),
            F = fun({Order, _OldOrderRefreshNum, OrderGoodsId, OrderGoodsNum, OrderPrice, OrderIsRarity, IsBuy}) ->
                [Order, OrderGoodsId, OrderGoodsNum, OrderPrice, OrderIsRarity, IsBuy]
                end,
            ProOrderList = lists:map(F, ShopInfo),
            TargetList = get_pro_target_list(Player, RecvRefreshRewardList, ActType, RefreshNum),
            ProTargetList = util:list_tuple_to_list(TargetList),
            {LTime, RefreshNum, RefreshCost, FreeRefreshTime, ProOrderList, ProTargetList, NewShowList}
    end.

get_pro_target_list(Player, RecvRefreshRewardList, ActType, RefreshNum) ->
    Ids = data_mystery_shop_refresh_reward:get_ids_by_act_type(ActType),
    F = fun(Id) ->
        {LvMin, LvMax, BaseRefreshNum, RewardList} = data_mystery_shop_refresh_reward:get(Id),
        if
            Player#player.lv < LvMin -> [];
            Player#player.lv > LvMax -> [];
            true ->
                {GoodsId, GoodsNum} = hd(RewardList),
                case lists:member(BaseRefreshNum, RecvRefreshRewardList) of
                    true ->
                        [{BaseRefreshNum, GoodsId, GoodsNum, 2}];
                    false ->
                        if
                            BaseRefreshNum =< RefreshNum ->
                                [{BaseRefreshNum, GoodsId, GoodsNum, 1}];
                            true ->
                                [{BaseRefreshNum, GoodsId, GoodsNum, 0}]
                        end
                end
        end
        end,
    lists:flatmap(F, Ids).

update_first_refresh(_Player) ->
    St = lib_dict:get(?PROC_STATUS_MYSTERY_SHOP),
    #st_mystery_shop{
        shop_info = ShopInfo,
        refresh_num = RefreshNum,
        refresh_time = RefreshTime
    } = St,
    case get_act() of
        [] -> ok;
        #base_mystery_shop{act_id = ActId, act_type = ActType, refresh_cd_time = RefreshCdTime} ->
            case RefreshTime + RefreshCdTime >= util:unixtime() of
                true ->
                    F = fun({_Order, _OldOrderRefreshNum, _OrderGoodsId, _OrderGoodsNum, _OrderPrice, _OrderIsRarity, IsBuy}) ->
                        IsBuy == 0
                        end,
                    case lists:filter(F, ShopInfo) of
                        [] -> %% 全部购买后，重新给刷新一次
                            NewShopInfo = refresh(ActType, RefreshNum + 1, ShopInfo),
                            NewSt =
                                St#st_mystery_shop{
                                    shop_info = NewShopInfo,
                                    act_id = ActId,
                                    op_time = util:unixtime(),
                                    refresh_num = St#st_mystery_shop.refresh_num + ?IF_ELSE(ShopInfo == [], 0, 1)
                                },
                            lib_dict:put(?PROC_STATUS_MYSTERY_SHOP, NewSt),
                            activity_load:dbup_mystery_shop(NewSt);
                        _ ->
                            skip
                    end;
                false ->
                    NewShopInfo = refresh(ActType, RefreshNum + 1, ShopInfo),
                    NewSt =
                        St#st_mystery_shop{
                            shop_info = NewShopInfo,
                            act_id = ActId,
                            refresh_time = util:unixtime(),
                            op_time = util:unixtime()
                        },
                    lib_dict:put(?PROC_STATUS_MYSTERY_SHOP, NewSt),
                    activity_load:dbup_mystery_shop(NewSt)
            end
    end.

%% {Code, Type, RefreshNum, Cost}
refresh(Player, Type) ->
    if
        Type /= 1 andalso Type /= 10 -> {Player, 0, Type, 0, 0, 0};
        true ->
            case get_act() of
                [] -> {Player, 0, Type, 0, 0, 0};
                #base_mystery_shop{refresh_cost = RefreshCost} = Base ->
                    NeedCost = Type * RefreshCost,
                    case money:is_enough(Player, NeedCost, gold) of
                        true ->
                            refresh1(Player, Type, Base);
                        false ->
                            {Player, 2, Type, 0, 0, 0}
                    end
            end
    end.
refresh1(Player, Type, Base) ->
    #base_mystery_shop{
        act_type = ActType,
        refresh_cost = RefreshCost
    } = Base,
    St = lib_dict:get(?PROC_STATUS_MYSTERY_SHOP),
    #st_mystery_shop{
        shop_info = ShopInfo,
        refresh_num = RefreshNum
    } = St,
    F = fun(_N, {AccFlag, AccCount, AccShopInfo}) ->
        if
            AccFlag == true ->
                {AccFlag, AccCount, AccShopInfo};
            true ->
                NewAccShopInfo = refresh(ActType, RefreshNum + AccCount + 1, AccShopInfo),
                case check_rarity(NewAccShopInfo) of
                    true -> {true, AccCount + 1, NewAccShopInfo};
                    false -> {false, AccCount + 1, NewAccShopInfo}
                end
        end
        end,
    {Flag, Count, NewShopInfo} = lists:foldl(F, {false, 0, ShopInfo}, lists:seq(1, Type)),
    IsRarity = ?IF_ELSE(Flag == true, 1, 0),
    NewSt =
        St#st_mystery_shop{
            shop_info = NewShopInfo,
            op_time = util:unixtime(),
            refresh_num = RefreshNum + Count
        },
    CostSum = Count * RefreshCost,
    NewPlayer = money:add_no_bind_gold(Player, -CostSum, 689, 0, 0),
    lib_dict:put(?PROC_STATUS_MYSTERY_SHOP, NewSt),
    activity_load:dbup_mystery_shop(NewSt),
    {NewPlayer, 1, Type, IsRarity, Count, CostSum}.

%% 刷新1次
refresh(ActType, RefreshNum, OrderInfoList) ->
    F = fun(Order) ->
        RewardType = data_mystery_shop_info:get_by_actType_order_refreshNum(ActType, Order, RefreshNum),
        OrderRefreshNum =
            case lists:keyfind(Order, 1, OrderInfoList) of
                false -> 0;
                {Order, OldOrderRefreshNum, _OrderGoodsId, _OrderGoodsNum, _OrderPrice, _OrderIsRarity, _IsBuy} ->
                    OldOrderRefreshNum
            end,
        RewardList = data_mystery_shop_reward_type:get_by_rewardType_refreshNum(RewardType, OrderRefreshNum + 1),
        F0 = fun({GoodsId, GoodsNum, Price, Power, IsRarity}) ->
            {{GoodsId, GoodsNum, Price, IsRarity}, Power}
             end,
        NewRewardList = lists:map(F0, RewardList),
        {OrderGoodsId, OrderGoodsNum, OrderPrice, OrderIsRarity} = util:list_rand_ratio(NewRewardList),
        if
            OrderIsRarity == 0 ->
                {Order, OrderRefreshNum + 1, OrderGoodsId, OrderGoodsNum, OrderPrice, OrderIsRarity, 0};
            true ->
                {Order, 0, OrderGoodsId, OrderGoodsNum, OrderPrice, OrderIsRarity, 0}
        end
        end,
    lists:map(F, lists:seq(1, ?MYSTERY_SHOP_ORDER_MAX)).

%% 全部购买
buy_order(Player, 0) ->
    case get_act() of
        [] ->
            {0, Player};
        Base ->
            St = lib_dict:get(?PROC_STATUS_MYSTERY_SHOP),
            #st_mystery_shop{
                shop_info = ShopInfo,
                buy_num = BuyNum
            } = St,
            F = fun({_Order, _OldOrderRefreshNum, _OrderGoodsId, _OrderGoodsNum, _OrderPrice, _OrderIsRarity, IsBuy}) ->
                IsBuy == 0
                end,
            NewShopInfo = lists:filter(F, ShopInfo),
            F2 = fun({_Order, _OldOrderRefreshNum, _OrderGoodsId, _OrderGoodsNum, OrderPrice, _OrderIsRarity, _IsBuy}) ->
                OrderPrice
                 end,
            CostSum = lists:sum(lists:map(F2, NewShopInfo)),
            case money:is_enough(Player, CostSum, gold) of
                false ->
                    {2, Player};
                true ->
                    NPlayer = money:add_no_bind_gold(Player, -CostSum, 690, 0, 0),
                    F3 = fun({_Order, _OldOrderRefreshNum, OrderGoodsId, OrderGoodsNum, _OrderPrice, _OrderIsRarity, _IsBuy}) ->
                        {OrderGoodsId, OrderGoodsNum}
                         end,
                    GoodsList = lists:map(F3, NewShopInfo),
                    GiveGoodsList = goods:make_give_goods_list(691, GoodsList),
                    {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList),
                    F4 = fun({_Order, _OldOrderRefreshNum, _OrderGoodsId, _OrderGoodsNum, _OrderPrice, _OrderIsRarity, _IsBuy}) ->
                        {_Order, _OldOrderRefreshNum, _OrderGoodsId, _OrderGoodsNum, _OrderPrice, _OrderIsRarity, 1}
                         end,
                    ShopInfo99 = lists:map(F4, ShopInfo),
                    NewSt =
                        St#st_mystery_shop{
                            shop_info = ShopInfo99,
                            op_time = util:unixtime(),
                            buy_num = BuyNum + length(NewShopInfo)
                        },
                    lib_dict:put(?PROC_STATUS_MYSTERY_SHOP, NewSt),
                    activity_load:dbup_mystery_shop(NewSt),
                    send_act_mail(Player, ShopInfo99, Base, NewSt#st_mystery_shop.buy_num),
                    {1, NewPlayer}
            end
    end;

buy_order(Player, Order) ->
    case get_act() of
        [] -> {0, Player};
        Base ->
            St = lib_dict:get(?PROC_STATUS_MYSTERY_SHOP),
            #st_mystery_shop{
                shop_info = ShopInfo,
                buy_num = BuyNum
            } = St,
            case lists:keytake(Order, 1, ShopInfo) of
                false -> {0, Player};
                {value, {_Order, _OldOrderRefreshNum, OrderGoodsId, OrderGoodsNum, OrderPrice, _OrderIsRarity, IsBuy}, Rest} ->
                    Flag = money:is_enough(Player, OrderPrice, gold),
                    if
                        IsBuy == 1 -> {4, Player};
                        Flag == false -> {2, Player};
                        true ->
                            NPlayer = money:add_no_bind_gold(Player, -OrderPrice, 690, 0, 0),
                            NewShopInfo = [{_Order, _OldOrderRefreshNum, OrderGoodsId, OrderGoodsNum, OrderPrice, _OrderIsRarity, 1} | Rest],
                            NewSt =
                                St#st_mystery_shop{
                                    shop_info = NewShopInfo,
                                    op_time = util:unixtime(),
                                    buy_num = BuyNum + 1
                                },
                            lib_dict:put(?PROC_STATUS_MYSTERY_SHOP, NewSt),
                            activity_load:dbup_mystery_shop(NewSt),
                            GiveGoodsList = goods:make_give_goods_list(691, [{OrderGoodsId, OrderGoodsNum}]),
                            {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList),
                            send_act_mail(Player, NewShopInfo, Base, NewSt#st_mystery_shop.buy_num),
                            {1, NewPlayer}
                    end
            end
    end.

send_act_mail(Player, ShopInfo, Base, BuyNum) ->
    F = fun({_Order, _OldOrderRefreshNum, _OrderGoodsId, _OrderGoodsNum, _OrderPrice, _OrderIsRarity, IsBuy}) ->
        IsBuy == 0
        end,
    case lists:filter(F, ShopInfo) of
        [] ->
            #base_mystery_shop{act_type = ActType} = Base,
            Reward = data_mystery_shop_all_buy_reward:get_by_actType_lv_allBuyNum(ActType, Player#player.lv, BuyNum),
            if
                Reward == [] -> skip;
                true ->
                    {Title, Content} = t_mail:mail_content(132),
                    mail:sys_send_mail([Player#player.key], Title, Content, Reward)
            end;
        _ ->
            skip
    end.

recv(Player, BaseRefreshNum) ->
    case get_act() of
        [] -> {0, Player};
        #base_mystery_shop{act_type = ActType} ->
            St = lib_dict:get(?PROC_STATUS_MYSTERY_SHOP),
            #st_mystery_shop{
                refresh_num = RefreshNum,
                recv_refresh_reward = RecvRefreshRewardList
            } = St,
            ProTargetList = get_pro_target_list(Player, RecvRefreshRewardList, ActType, RefreshNum),
            case lists:keyfind(BaseRefreshNum, 1, ProTargetList) of
                false ->
                    {0, Player};
                {BaseRefreshNum, GoodsId, GoodsNum, IsRecv} ->
                    Flag = lists:member(BaseRefreshNum, RecvRefreshRewardList),
                    if
                        IsRecv == 2 -> {5, Player};
                        IsRecv == 0 -> {3, Player};
                        Flag == true -> {5, Player};
                        true ->
                            NewSt =
                                St#st_mystery_shop{
                                    recv_refresh_reward = [BaseRefreshNum | RecvRefreshRewardList],
                                    op_time = util:unixtime()
                                },
                            lib_dict:put(?PROC_STATUS_MYSTERY_SHOP, NewSt),
                            activity_load:dbup_mystery_shop(NewSt),
                            GiveGoodsList = goods:make_give_goods_list(692, [{GoodsId, GoodsNum}]),
                            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                            {1, NewPlayer}
                    end
            end
    end.

check_rarity(OrderInfoList) ->
    F = fun({_Order, _OldOrderRefreshNum, _OrderGoodsId, _OrderGoodsNum, _OrderPrice, OrderIsRarity, _IsBuy}) ->
        OrderIsRarity == 1
        end,
    lists:any(F, OrderInfoList).

get_notice_state(Player) ->
    case get_act() of
        [] -> -1;
        #base_mystery_shop{act_type = ActType, act_info = ActInfo} ->
            St = lib_dict:get(?PROC_STATUS_MYSTERY_SHOP),
            #st_mystery_shop{
                refresh_num = RefreshNum,
                recv_refresh_reward = RecvRefreshRewardList
            } = St,
            ProTargetList = get_pro_target_list(Player, RecvRefreshRewardList, ActType, RefreshNum),
            F = fun({_BaseRefreshNum, _GoodsId, _GoodsNum, IsBuy}) ->
                IsBuy == 1
                end,
            L = lists:filter(F, ProTargetList),
            Args = activity:get_base_state(ActInfo),
            ?IF_ELSE(L == [], {0, Args}, {1, Args})
    end.