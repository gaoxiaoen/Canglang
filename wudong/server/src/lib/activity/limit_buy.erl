%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% %% 限时抢购
%%% @end
%%% Created : 04. 五月 2017 15:43
%%%-------------------------------------------------------------------
-module(limit_buy).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("goods.hrl").

%% API
-export([
    init/1,
    init_ets/0,
    midnight_refresh/1,
    sys_midnight_refresh/0,
    ets_to_db/0,
    get_state/1,
    get_act_info/1,
    buy/2,
    recv/2,
    get_log/0,
    logout/0,
    get_act/0
]).

init_ets() ->
    ets:new(?ETS_LIMIT_BUY, [{keypos, #ets_limit_buy.act_id} | ?ETS_OPTIONS]),
    spawn(fun() -> init_data() end),
    ok.

init_data() ->
    case get_act() of
        [] ->
            ok;
        #base_limit_buy{act_id = BaseActId} ->
            Ets = activity_load:dbget_all_limit_buy(BaseActId),
            ets:insert(?ETS_LIMIT_BUY, Ets)
    end.

init(#player{key = Pkey} = Player) ->
    StLimitBuy =
        case player_util:is_new_role(Player) of
            true -> #st_limit_buy{pkey = Pkey};
            false -> activity_load:dbget_limit_buy(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_LIMIT_BUY, StLimitBuy),
    update_limit_buy(),
    Player.

update_limit_buy() ->
    StLimitBuy = lib_dict:get(?PROC_STATUS_LIMIT_BUY),
    #st_limit_buy{
        pkey = Pkey,
        act_id = ActId,
        op_time = OpTime
    } = StLimitBuy,
    case get_act() of
        [] ->
            NewStLimitBuy = #st_limit_buy{pkey = Pkey};
        #base_limit_buy{act_id = BaseActId} ->
            Now = util:unixtime(),
            Flag = util:is_same_date(Now, OpTime),
            if
                BaseActId =/= ActId ->
                    NewStLimitBuy = #st_limit_buy{pkey = Pkey, act_id = BaseActId, op_time = Now};
                Flag == false ->
                    NewStLimitBuy = #st_limit_buy{pkey = Pkey, act_id = BaseActId, op_time = Now};
                true ->
                    NewStLimitBuy = StLimitBuy
            end
    end,
    lib_dict:put(?PROC_STATUS_LIMIT_BUY, NewStLimitBuy).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_limit_buy().

%% 系统重置
sys_midnight_refresh() ->
    ets:delete_all_objects(?ETS_LIMIT_BUY).

%%每分钟更新1次库
ets_to_db() ->
    case get_act() of
        [] ->
            ok;
        #base_limit_buy{act_id = BaseActId} ->
            Ets = look_up(BaseActId),
            if
                Ets#ets_limit_buy.db_flag == 1 ->
                    activity_load:dbup_all_limit_buy(Ets),
                    ets:insert(?ETS_LIMIT_BUY, Ets#ets_limit_buy{db_flag = 0});
                true ->
                    ok
            end
    end.

logout() ->
    case get_act() of
        [] ->
            ok;
        #base_limit_buy{act_id = BaseActId} ->
            Ets = look_up(BaseActId),
            activity_load:dbup_all_limit_buy(Ets)
    end.

get_state(_Player) ->
    case get_act() of
        [] ->
            -1;
        #base_limit_buy{type = BaseType, act_info = ActInfo} = Base -> %% 暂时这么写
            Ids = data_limit_buy_shop:get_ids_by_type(BaseType),
            F = fun(Id) ->
                case check_buy(_Player, Id, true, Base) of
                    {false, _Code} ->
                        false;
                    _ -> true
                end
            end,
            Flag = lists:any(F, Ids),
            Args = activity:get_base_state(ActInfo),
            ?IF_ELSE(Flag == true, {1, Args}, {0, Args})
    end.

get_act_info(_Player) ->
    StLimitBuy = lib_dict:get(?PROC_STATUS_LIMIT_BUY),
    #st_limit_buy{
        buy_list = BuyList,
        recv_list = RecvList
    } = StLimitBuy,
    case get_act() of
        [] ->
            {0, 0, 0, 0, [], []};
        #base_limit_buy{open_info = OpenInfo, type = Type, reward_list = RewardList, act_id = BaseActId} ->
            ActLeaveTime = activity:calc_act_leave_time(OpenInfo),
            {{_Y, _M, _D}, {H, _Min, _S}} = erlang:localtime(),
            TimeList = data_limit_buy_shop:get_time_by_type(Type),
            F1 = fun(Time) -> H < Time end,
            L1 = lists:filter(F1, TimeList),
            LeaveTime = ?IF_ELSE(L1 == [], 0, util:unixdate() + hd(L1) * ?ONE_HOUR_SECONDS - util:unixtime()),
            F1_1 = fun(Time) -> H >= Time end,
            L1_1 = lists:filter(F1_1, TimeList),
            OpenHour = ?IF_ELSE(L1_1 == [], 0, lists:max(L1_1)),
            TotalBuyNum = lists:sum(lists:map(fun({_ShopId, GoodsNum}) -> GoodsNum end, BuyList)),
            F2 = fun({BaseBuyNum, RewardGiftId}) ->
                case lists:member(BaseBuyNum, RecvList) of
                    true ->
                        [2, BaseBuyNum, util:list_tuple_to_list(RewardGiftId)];
                    false ->
                        ?IF_ELSE(TotalBuyNum >= BaseBuyNum, [1, BaseBuyNum, util:list_tuple_to_list(RewardGiftId)], [0, BaseBuyNum, util:list_tuple_to_list(RewardGiftId)])
                end
                 end,
            List1 = lists:map(F2, RewardList),
            ShopIds = data_limit_buy_shop:get_ids_by_type(Type),
            Ets = look_up(BaseActId),
            SysBuyList = Ets#ets_limit_buy.buy_list,
            F3 = fun(ShopId) ->
                #base_limit_buy_shop{
                    time = Time,
                    goods_id = GoodsId,
                    goods_num = GoodsNum,
                    buy_num = BaseBuyNum,
                    sys_buy_num = BaseSysBunNum,
                    price1 = Price1,
                    price2 = Price2
                } = data_limit_buy_shop:get(ShopId),
                case lists:keyfind(ShopId, 1, BuyList) of
                    false ->
                        BuyNum = 0;
                    {_, BuyNum0} ->
                        BuyNum = BuyNum0
                end,
                case lists:keyfind(ShopId, 1, SysBuyList) of
                    false ->
                        SysBuyNum = 0;
                    {_, BuyNum1} ->
                        SysBuyNum = BuyNum1
                end,
                [ShopId, Time, GoodsId, GoodsNum, Price1, Price2, BaseBuyNum, BuyNum, BaseSysBunNum, SysBuyNum]
                 end,
            List2 = lists:map(F3, ShopIds),
            {ActLeaveTime, LeaveTime, TotalBuyNum, OpenHour, List1, List2}
    end.

buy(Player, ShopId) ->
    StLimitBuy = lib_dict:get(?PROC_STATUS_LIMIT_BUY),
    #st_limit_buy{buy_list = BuyList} = StLimitBuy,
    case get_act() of
        [] -> {0, Player};
        Base ->
            case check_buy(Player, ShopId, false, Base) of
                {false, Code} ->
                    {Code, Player};
                {true, BaseActId, Time, GoodsId, GoodsNum, Price2, OldBuyNum, OldSysBuyNum} ->
                    BuyNum = OldBuyNum + 1,
                    SysBuyNum = OldSysBuyNum + 1,
                    log(Player, BaseActId, Time, ShopId, SysBuyNum, GoodsId, GoodsNum),
                    NPlayer = money:add_no_bind_gold(Player, - Price2, 618, GoodsId, GoodsNum),
                    GiveGoodsList = goods:make_give_goods_list(619, [{GoodsId, GoodsNum}]),
                    {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList),
                    case lists:keytake(ShopId, 1, BuyList) of
                        false ->
                            NewBuyList = [{ShopId, BuyNum} | BuyList];
                        {value, {_ShopId, OldBuyNum0}, Rest} ->
                            NewBuyList = [{ShopId, OldBuyNum0 + 1} | Rest]
                    end,
                    NewStLimitBuy = StLimitBuy#st_limit_buy{buy_list = NewBuyList},
                    lib_dict:put(?PROC_STATUS_LIMIT_BUY, NewStLimitBuy),
                    activity_load:dbup_limit_buy(NewStLimitBuy),
                    activity:get_notice(Player, [37], true),
                    {1, NewPlayer}
            end
    end.

log(Player, ActId, Time, ShopId, SysBuyNum, GoodsId, GoodsNum) ->
    Ets = look_up(ActId),
    SysBuyList = Ets#ets_limit_buy.buy_list,
    case lists:keytake(ShopId, 1, SysBuyList) of
        false ->
            NewBuyList = [{ShopId, SysBuyNum} | SysBuyList];
        {value, _, Rest} ->
            NewBuyList = [{ShopId, SysBuyNum} | Rest]
    end,
    Log = [Player#player.nickname, Time, GoodsId, GoodsNum],
    NLogList = [Log | Ets#ets_limit_buy.log],
    NewLogList = ?IF_ELSE(length(NLogList) > 40, lists:sublist(NLogList, 15), NLogList),
    NewEts = Ets#ets_limit_buy{
        buy_list = NewBuyList,
        log = NewLogList,
        db_flag = 1
    },
    ets:insert(?ETS_LIMIT_BUY, NewEts),
    ok.

check_buy(Player, ShopId, IsMoney, Base) ->
    StLimitBuy = lib_dict:get(?PROC_STATUS_LIMIT_BUY),
    #st_limit_buy{buy_list = BuyList} = StLimitBuy,
    #base_limit_buy{act_id = BaseActId, type = Type} = Base,
    {{_Y, _M, _D}, {H, _Min, _S}} = erlang:localtime(),
    F1_1 = fun(Time) -> H >= Time end,
    L1_1 = lists:filter(F1_1, data_limit_buy_shop:get_time_by_type(Type)),
    OpenHour = ?IF_ELSE(L1_1 == [], 0, lists:max(L1_1)),
    case data_limit_buy_shop:get(ShopId) of
        [] ->
            {false, 0};
        #base_limit_buy_shop{
            time = Time,
            price2 = Price2,
            goods_id = GoodsId,
            goods_num = GoodsNum,
            buy_num = BaseBuyNum,
            sys_buy_num = BaseSysBuyNum
        } ->
            case H >= Time of
                false ->
                    {false, 9}; %% 未开始
                true ->
                    case OpenHour > Time of
                        true ->
                            {false, 12}; %% 已经结束
                        false ->
                            case IsMoney == true orelse money:is_enough(Player, Price2, gold) of
                                false ->
                                    {false, 5}; %% 元宝不足
                                true ->
                                    Ets = look_up(BaseActId),
                                    SysBuyList = Ets#ets_limit_buy.buy_list,
                                    case lists:keyfind(ShopId, 1, BuyList) of
                                        false ->
                                            case lists:keyfind(ShopId, 1, SysBuyList) of
                                                false ->
                                                    %% 系统内首次购买
                                                    {true, BaseActId, Time, GoodsId, GoodsNum, Price2, 0, 0};
                                                {_, SysBuyNum} ->
                                                    if
                                                        SysBuyNum >= BaseSysBuyNum -> %% 检查系统购买
                                                            {false, 10}; %%系统购买次数不足
                                                        true ->
                                                            {true, BaseActId, Time, GoodsId, GoodsNum, Price2, 0, SysBuyNum}
                                                    end
                                            end;
                                        {_, BuyNum} ->
                                            if
                                                BuyNum >= BaseBuyNum -> %% 检查玩家购买次数限制
                                                    {false, 11}; %%玩家限购次数
                                                true ->
                                                    case lists:keyfind(ShopId, 1, SysBuyList) of
                                                        false ->
                                                            {true, BaseActId, Time, GoodsId, GoodsNum, Price2, BuyNum, BuyNum};
                                                        {_, SysBuyNum} ->
                                                            if
                                                                SysBuyNum >= BaseSysBuyNum -> %% 检查系统购买
                                                                    {false, 10}; %%系统限购次数
                                                                true ->
                                                                    {true, BaseActId, Time, GoodsId, GoodsNum, Price2, BuyNum, SysBuyNum}
                                                            end
                                                    end
                                            end
                                    end
                            end
                    end
            end
    end.

recv(Player, N) ->
    StLimitBuy = lib_dict:get(?PROC_STATUS_LIMIT_BUY),
    #st_limit_buy{
        buy_list = BuyList,
        recv_list = RecvList
    } = StLimitBuy,
    case get_act() of
        [] ->
            {0, Player};
        #base_limit_buy{reward_list = RewardList} ->
            case lists:member(N, RecvList) of
                true ->
                    {3, Player}; %% 已经领取
                false ->
                    TotalBuyNum = lists:sum(lists:map(fun({_ShopId, GoodsNum}) -> GoodsNum end, BuyList)),
                    if
                        TotalBuyNum < N ->
                            {11, Player}; %% 未达成
                        true ->
                            case lists:keyfind(N, 1, RewardList) of
                                false -> {0, Player};
                                {_, GiftId} ->
                                    NewStLimitBuy = StLimitBuy#st_limit_buy{recv_list = [N | RecvList]},
                                    lib_dict:put(?PROC_STATUS_LIMIT_BUY, NewStLimitBuy),
                                    activity_load:dbup_limit_buy(NewStLimitBuy),
                                    GiveGoodsList = goods:make_give_goods_list(620, GiftId),
                                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

get_log() ->
    case get_act() of
        [] ->
            [];
        #base_limit_buy{act_id = BaseActId} ->
            Ets = look_up(BaseActId),
            LogList = Ets#ets_limit_buy.log,
            lists:sublist(LogList, 15)
    end.

look_up(ActId) ->
    case ets:lookup(?ETS_LIMIT_BUY, ActId) of
        [] ->
            ets:insert(?ETS_LIMIT_BUY, #ets_limit_buy{act_id = ActId}),
            #ets_limit_buy{act_id = ActId};
        [Ets] ->
            Ets
    end.

get_act() ->
    case activity:get_work_list(data_limit_buy) of
        [] -> [];
        [Base | _] -> Base
    end.
