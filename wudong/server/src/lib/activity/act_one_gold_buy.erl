%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 九月 2017 14:40
%%%-------------------------------------------------------------------
-module(act_one_gold_buy).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("goods.hrl").

%% API
-export([
    init_ets/0,
    init_data/0,
    init/1,
    midnight_refresh/1,
    sys_midnight_refresh/0,
    sys_midnight_refresh_cast/1,
    get_act/0,
    get_status/0, %%当前状态
    get_timer_list/0, %% 计算时间
    timer/0, %% 定时更新
    update_timer/1, %% 更新定时器
    timer_cacl/2, %% 结算
    back2/4, %% 返还
    to_client2/4, %% 中奖
    sys_logout/0,
    get_buy_num/2,
    get_state/1
]).

-export([
    get_act_info/1,
    get_act_info_center/4,
    get_act_info_center_cast/5,
    get_leave_time/0,
    buy/3,
    buy_center/9,
    buy_center_cast/2,
    recv_num_reward/2,
    read_log/2,
    read_log_center/3,
    update_all/0,
    update_all_0/0
]).

-export([
    gm_sys_midnight_refresh/0,
    gm_cacl/0,
    gm_cacl_center/0
]).

gm_sys_midnight_refresh() ->
    case config:is_center_node() of
        true ->
            sys_midnight_refresh();
        false ->
            cross_all:apply(?MODULE, sys_midnight_refresh, [])
    end.

gm_cacl() ->
    case config:is_center_node() of
        true ->
            gm_cacl_center();
        false ->
            cross_all:apply(?MODULE, gm_cacl_center, [])
    end.

gm_cacl_center() ->
    {_Status, ActNum, _ActStartTime, _ActEndTime} = get_status(),
    activity_proc:get_act_pid() ! {act_one_gold_buy, timer_cacl, ActNum}.

sys_logout() ->
    case config:is_center_node() of
        false ->
            skip;
        true ->
            EtsList = ets:tab2list(?ETS_ONE_GOLD_GOODS),
            F = fun(Ets) ->
                activity_load:dbup_ets_one_gold_buy(Ets)
                end,
            lists:map(F, EtsList)
    end.

init_ets() ->
    ets:new(?ETS_ONE_GOLD_GOODS, [{keypos, #ets_one_gold_goods.key} | ?ETS_OPTIONS]).

init_data() ->
    case get_act() of
        [] -> ok;
        #base_act_one_gold_buy{act_id = ActId} ->
            case config:is_center_node() of
                false -> skip;
                true ->
                    SelfNode = node(),
                    AllEtsList = activity_load:dbget_all_one_gold_buy(SelfNode, ActId),
                    if
                        AllEtsList /= [] ->
                            sys_midnight_refresh(),
                            F = fun(Ets) ->
                                ets:insert(?ETS_ONE_GOLD_GOODS, Ets)
                                end,
                            lists:map(F, AllEtsList);
                        true ->
                            sys_midnight_refresh()
                    end
            end
    end.

sys_midnight_refresh() ->
    case config:is_center_node() of
        false -> skip;
        true ->
            ets:delete_all_objects(?ETS_ONE_GOLD_GOODS),
            case get_act() of
                [] ->
                    ok;
                #base_act_one_gold_buy{act_id = ActId, act_type = ActType} ->
                    AllIds = data_one_gold_buy:get_ids_by_actType(ActType),
                    F = fun(Id) ->
                        #base_one_gold_goods{
                            act_num = ActNum,
                            goods_id = GoodsId,
                            goods_num = GoodsNum,
                            order_id = OrderId
                        } = data_one_gold_buy:get(Id),
                        Ets =
                            #ets_one_gold_goods{
                                key = {ActId, ActType, ActNum, OrderId},
                                act_id = ActId,
                                act_type = ActType,
                                act_num = ActNum,
                                order_id = OrderId,
                                goods_id = GoodsId,
                                goods_num = GoodsNum,
                                op_time = util:unixtime()
                            },
                        ets:insert(?ETS_ONE_GOLD_GOODS, Ets)
                        end,
                    lists:map(F, AllIds)
            end,
            ?CAST(activity_proc:get_act_pid(), {act_one_gold_buy, sys_midnight_refresh})
    end.

sys_midnight_refresh_cast(State) ->
    #state{act_one_gold_ref = Ref} = State,
    util:cancel_ref([Ref]),
    State#state{
        act_one_gold_ref = null,
        act_one_gold_log = []
    }.

get_timer_list() ->
    case get_act() of
        [] -> [];
        #base_act_one_gold_buy{act_type = ActType} ->
            Ids = data_one_gold_buy:get_ids_by_actType(ActType),
            F = fun(Id) ->
                #base_one_gold_goods{
                    act_num = ActNum,
                    act_time = ActTime,
                    act_start_time = ActStartTimeInfo
                } = data_one_gold_buy:get(Id),
                {H, M, S} = ActStartTimeInfo,
                ActStartTime = H * 3600 + M * 60 + S,
                {ActNum, ActStartTime, ActStartTime + ActTime}
                end,
            TimeList = lists:sort(util:list_filter_repeat(lists:map(F, Ids))),
            TimeList
    end.

get_status() ->
    Now = util:get_seconds_from_midnight(),
    TimeList = get_timer_list(),
    F = fun({BaseActNum, BaseActStartTime, BaseActEndTime}) ->
        if
            Now >= BaseActEndTime -> [];
            true -> [{BaseActNum, BaseActStartTime, BaseActEndTime}]
        end
        end,
    List = lists:flatmap(F, TimeList),
    if
        List == [] ->
            {ActNum, ActStartTime, ActEndTime} = hd(lists:reverse(TimeList)),
            {?ONE_GOLD_BUY_END, ActNum, round(ActStartTime), round(ActEndTime)};
        true ->
            {ActNum, ActStartTime, ActEndTime} = hd(List),
            if
                Now < ActStartTime -> {?ONE_GOLD_BUY_READY, ActNum, round(ActStartTime), round(ActEndTime)};
                Now < ActEndTime -> {?ONE_GOLD_BUY_START, ActNum, round(ActStartTime), round(ActEndTime)};
                true -> {?ONE_GOLD_BUY_END, ActNum, round(ActStartTime), round(ActEndTime)}
            end
    end.

timer() ->
    case get_act() of
        [] -> skip;
        #base_act_one_gold_buy{act_id = ActId, act_type = ActType} ->
            AllIds = data_one_gold_buy:get_ids_by_actType(ActType),
            case config:is_center_node() of
                false ->
                    skip;
                true ->
                    NowSec = util:get_seconds_from_midnight(),
                    if
                        NowSec > 60 -> %% 处理中途更新活动
                            Size = ets:info(?ETS_ONE_GOLD_GOODS, size),
                            if
                                Size == 0 -> sys_midnight_refresh();
                                Size == length(AllIds) -> skip;
                                true -> %% 活动中途增加轮数
                                    F = fun(Id) ->
                                        #base_one_gold_goods{
                                            act_num = ActNum,
                                            goods_id = GoodsId,
                                            goods_num = GoodsNum,
                                            order_id = OrderId
                                        } = data_one_gold_buy:get(Id),
                                        Key = {ActId, ActType, ActNum, OrderId},
                                        case ets:lookup(?ETS_ONE_GOLD_GOODS, Key) of
                                            [] ->
                                                Ets =
                                                    #ets_one_gold_goods{
                                                        key = Key,
                                                        act_id = ActId,
                                                        act_type = ActType,
                                                        act_num = ActNum,
                                                        order_id = OrderId,
                                                        goods_id = GoodsId,
                                                        goods_num = GoodsNum,
                                                        op_time = util:unixtime()
                                                    },
                                                ets:insert(?ETS_ONE_GOLD_GOODS, Ets);
                                            _ -> skip
                                        end
                                        end,
                                    lists:map(F, AllIds)
                            end;
                        true -> skip
                    end,
                    ?CAST(activity_proc:get_act_pid(), {act_one_gold_buy, update_timer})
            end
    end.


update_timer(State) ->
    #state{act_one_gold_ref = Ref} = State,
    {Status, ActNum, ActStartTime, ActEndTime} = get_status(),
    NowSec = util:get_seconds_from_midnight(),
    if
        NowSec - ActStartTime < 10 ->
            State; %% 确保前一轮正常结算
        ActEndTime - NowSec < 10 ->
            State; %% 提前2min不更新定时器
        Status == ?ONE_GOLD_BUY_START ->
            util:cancel_ref([Ref]),
            NewRef = erlang:send_after(max(0, (ActEndTime - NowSec)) * 1000, self(), {act_one_gold_buy, timer_cacl, ActNum}),
            State#state{act_one_gold_ref = NewRef};
        true ->
            State
    end.

timer_cacl(State, ActNum) ->
    AllEtsList = ets:tab2list(?ETS_ONE_GOLD_GOODS),
    %% 过滤数据
    F = fun(Ets) ->
        Ets#ets_one_gold_goods.act_num == ActNum
        end,
    %% 结算奖励
    NewEtsList = lists:filter(F, AllEtsList),
    F2 = fun(Ets) ->
        #ets_one_gold_goods{
            order_id = OrderId,
            act_type = ActType,
            buy_list = BuyList,
            total_num = TotalNum
        } = Ets,
        #base_one_gold_goods{
            goods_id = GoodsId,
            goods_num = GoodsNum,
            total_num = BaseTotalNum
        } = data_one_gold_buy:get_by_actType_actNum_orderId(ActType, ActNum, OrderId),
        if
            TotalNum < BaseTotalNum -> %% 购买总次数不足，返还元宝
                spawn(fun() -> back(BuyList, GoodsId, GoodsNum, ActNum) end),
                [];
            true ->
                {Pkey, Sn, Nickname, Buynum} = rand(BuyList),
                Node = center:get_node_by_sn(Sn),
                to_client(Pkey, Node, ActNum, GoodsId, GoodsNum),
                Log = [{Pkey, Sn, Nickname, Buynum}],
                NewEts = Ets#ets_one_gold_goods{log = Log},
                ets:insert(?ETS_ONE_GOLD_GOODS, NewEts),
                [{Pkey, Sn, Nickname, Buynum, ActNum, GoodsId, GoodsNum}]
        end
         end,
%%     spawn(fun() -> update_all() end),
    LogList = lists:flatmap(F2, NewEtsList),
    #state{act_one_gold_log = OldLogList} = State,
    State#state{
        act_one_gold_log = lists:sublist(LogList ++ OldLogList, 20)
    }.

update_all() ->
    AllNode = center:get_all_nodes(),
    F = fun(Node) ->
        center:apply(Node, ?MODULE, update_all_0, [])
        end,
    lists:map(F, AllNode).

update_all_0() ->
    EtsList = ets:tab2list(?ETS_ONLINE),
    F = fun(#ets_online{pid = Pid}) ->
        Pid ! {act_one_gold_buy, notice}
        end,
    lists:map(F, EtsList).

rand(BuyList) ->
    F = fun({Pkey, Sn, Nickname, Buynum}) ->
        {{Pkey, Sn, Nickname}, Buynum}
        end,
    NewBuyList = lists:map(F, BuyList),
    {RandPkey, _RandSn, _RandNickname} = util:list_rand_ratio(NewBuyList),
    lists:keyfind(RandPkey, 1, BuyList).

to_client(Pkey, Node, ActNum, GoodsId, GoodsNum) ->
    center:apply(Node, ?MODULE, to_client2, [Pkey, ActNum, GoodsId, GoodsNum]).

to_client2(Pkey, ActNum, GoodsId, GoodsNum) ->
    {{_Y, _M, _D}, {_H, _Min, _S}} = erlang:localtime(),
    {Title, Content0} = t_mail:mail_content(134),
    TimeStr = util:unixtime_to_time_string4(util:unixtime()),
    case version:get_lan_config() of
        vietnam ->
            Content = io_lib:format(Content0, [TimeStr, ActNum]);
        _ ->
            Content = io_lib:format(Content0, [_Y, _M, _D, ActNum])
    end,
    mail:sys_send_mail([Pkey], Title, Content, [{GoodsId, GoodsNum}]),
    activity_log:log_one_gold_buy_goods(Pkey, ActNum, GoodsId, GoodsNum),
    ok.

%% 活动返还
back(BuyList, GoodsId, _GoodsNum, ActNum) ->
    case get_act() of
        [] ->
            ok;
        #base_act_one_gold_buy{price_list = PriceList} ->
            {BaseBuyNum, Price} = hd(PriceList),
            F = fun({Pkey, Sn, _Nickname, Buynum}) ->
                Node = center:get_node_by_sn(Sn),
                center:apply(Node, ?MODULE, back2, [Pkey, ActNum, GoodsId, round(Buynum * Price div BaseBuyNum)])
                end,
            lists:map(F, BuyList)
    end.

back2(Pkey, ActNum, GoodsId, BackGoldNum) ->
    {{_Y, _M, _D}, {_H, _Min, _S}} = erlang:localtime(),
    {Title, Content0} = t_mail:mail_content(133),
    TimeStr = util:unixtime_to_time_string4(util:unixtime()),
    #goods_type{goods_name = GoodsName} = data_goods:get(GoodsId),
    case version:get_lan_config() of
        vietnam ->
            Content = io_lib:format(Content0, [TimeStr, ActNum, GoodsName]);
        _ ->
            Content = io_lib:format(Content0, [_Y, _M, _D, ActNum, GoodsName])
    end,
    mail:sys_send_mail([Pkey], Title, Content, [{10199, BackGoldNum}]),
    activity_log:log_one_gold_buy_back(Pkey, ActNum, GoodsId, BackGoldNum),
    ok.


init(#player{key = Pkey} = Player) ->
    StOneGoldBuy =
        case player_util:is_new_role(Player) of
            true -> #st_one_gold_buy{pkey = Pkey};
            false -> activity_load:dbget_one_gold_buy(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_ONE_GOLD_BUY, StOneGoldBuy),
    update_one_gold_buy(),
    Player.

update_one_gold_buy() ->
    StOneGoldBuy = lib_dict:get(?PROC_STATUS_ONE_GOLD_BUY),
    #st_one_gold_buy{
        pkey = Pkey,
        act_id = ActId
    } = StOneGoldBuy,
    case get_act() of
        [] ->
            NewStOneGoldBuy = #st_one_gold_buy{pkey = Pkey};
        #base_act_one_gold_buy{act_id = BaseActId} ->
            if
                BaseActId =/= ActId ->
                    NewStOneGoldBuy = #st_one_gold_buy{pkey = Pkey, act_id = BaseActId};
                true ->
                    NewStOneGoldBuy = StOneGoldBuy
            end
    end,
    lib_dict:put(?PROC_STATUS_ONE_GOLD_BUY, NewStOneGoldBuy).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_one_gold_buy().

get_act() ->
    case activity:get_work_list(data_act_one_gold_buy) of
        [] -> [];
        [Base | _] -> Base
    end.

get_leave_time() ->
    case get_act() of
        [] -> {2, 0};
        _ ->
            {Status, _ActNum, ActStartTime, ActEndTime} = get_status(),
            Now = util:get_seconds_from_midnight(),
            RemainTime =
                if
                    Status == ?ONE_GOLD_BUY_READY -> max(0, ActStartTime - Now);
                    Status == ?ONE_GOLD_BUY_START -> max(0, ActEndTime - Now);
                    true -> 0
                end,
            {Status, RemainTime}
    end.

get_act_info(Player) ->
    case get_act() of
        [] -> ok;
        _ ->
            St = lib_dict:get(?PROC_STATUS_ONE_GOLD_BUY),
            #st_one_gold_buy{
                buy_num = BuyNum,
                recv_list = RecvList
            } = St,
            cross_all:apply(?MODULE, get_act_info_center, [Player#player.lv, BuyNum, RecvList, Player#player.sid])
    end,
    ok.

get_act_info_center(PlayerLv, BuyNum, RecvList, Sid) ->
    ?CAST(activity_proc:get_act_pid(), {get_act_info_center, PlayerLv, BuyNum, RecvList, Sid}),
    ok.
get_act_info_center_cast(State, PlayerLv, BuyNum, RecvList, Sid) ->
    #state{
        act_one_gold_log = LogList
    } = State,
    #base_act_one_gold_buy{
        act_id = ActId,
        act_type = BaseActType,
        price_list = PriceList
    } = get_act(),
    RewardList = get_reward_list(PlayerLv),
    {Status, ActNum, ActStartTime, ActEndTime} = get_status(),
    Now = util:get_seconds_from_midnight(),
    RemainTime =
        if
            Status == ?ONE_GOLD_BUY_READY -> max(0, ActStartTime - Now);
            Status == ?ONE_GOLD_BUY_START -> max(0, ActEndTime - Now);
            true -> 0
        end,
    F = fun({_Pkey, Sn, Nickname, _Buynum, LogActNum, GoodsId, GoodsNum}) ->
        [LogActNum, Nickname, GoodsId, GoodsNum, Sn]
        end,
    ProLogList = lists:map(F, LogList),
    F1 = fun({BaseNum, Gid, Gnum}) ->
        case lists:member(BaseNum, RecvList) of
            true ->
                [2, BaseNum, Gid, Gnum];
            false ->
                if
                    BuyNum >= BaseNum ->
                        [1, BaseNum, Gid, Gnum];
                    true ->
                        [0, BaseNum, Gid, Gnum]
                end
        end
         end,
    ProRecvList = lists:map(F1, RewardList),
    ProPriceList = util:list_tuple_to_list(PriceList),
    F2 = fun(EtsKey) ->
        case ets:lookup(?ETS_ONE_GOLD_GOODS, EtsKey) of
            [] -> [];
            [Ets] ->
                #ets_one_gold_goods{
                    order_id = OrderId,
                    total_num = TotalNum,
                    act_type = ActType,
                    act_num = EtsActNum
                } = Ets,
                case EtsActNum == ActNum of
                    true ->
                        #base_one_gold_goods{
                            total_num = BaseTotalNum,
                            goods_id = GoodsId,
                            goods_num = GoodsNum
                        } = data_one_gold_buy:get_by_actType_actNum_orderId(ActType, EtsActNum, OrderId),
                        [[OrderId, BaseTotalNum, min(BaseTotalNum, TotalNum), GoodsId, GoodsNum]];
                    false -> []
                end
        end
         end,
    Now99 = util:unixtime(),
    ProGoodsList =
        case get({act_one_gold_buy, pro_goods_list}) of
            {Time, List} when Now99 - Time < 1 ->
                List;
            _ ->
                EtsKeyList = get_ets_key_list(ActId, BaseActType, ActNum),
                List = lists:flatmap(F2, EtsKeyList),
                put({act_one_gold_buy, pro_goods_list}, {Now99, List}),
                List
        end,
    {ok, Bin} = pt_439:write(43909, {Status, RemainTime + 1, ActNum, BuyNum, ProLogList, ProRecvList, ProPriceList, ProGoodsList}),
    server_send:send_to_sid(Sid, Bin),
    ok.

get_ets_key_list(ActId, ActType, ActNum) ->
    Ids = data_one_gold_buy:get_ids_by_actType(ActType),
    F = fun(Id) ->
        #base_one_gold_goods{act_num = BaseActNum, order_id = OrderId} = data_one_gold_buy:get(Id),
        if
            ActNum /= BaseActNum -> [];
            true -> [{ActId, ActType, ActNum, OrderId}]
        end
        end,
    lists:flatmap(F, Ids).

buy(OrderId, BuyNum, Player) ->
    case check_buy(OrderId, BuyNum, Player) of
        {fail, Code} ->
            {Code, Player};
        {true, ActId, NewBuyNum, ActType, ActNum, CostGold} ->
            case cross_all:apply_call(?MODULE, buy_center, [Player#player.key, Player#player.sn_cur, Player#player.node, Player#player.nickname, ActId, ActType, ActNum, OrderId, NewBuyNum]) of
                true ->
                    St = lib_dict:get(?PROC_STATUS_ONE_GOLD_BUY),
                    NewSt = St#st_one_gold_buy{buy_num = St#st_one_gold_buy.buy_num + NewBuyNum, op_time = util:unixtime()},
                    lib_dict:put(?PROC_STATUS_ONE_GOLD_BUY, NewSt),
                    activity_load:dbup_one_gold_buy(NewSt),
                    NewPlayer = money:add_no_bind_gold(Player, -CostGold, 695, 0, 0),
                    #base_one_gold_goods{goods_id = GoodsId} = data_one_gold_buy:get_by_actType_actNum_orderId(ActType, ActNum, OrderId),
                    activity_log:log_one_gold_buy(Player#player.key, ActNum, GoodsId, NewBuyNum, CostGold, util:unixtime()),
                    activity:get_notice(NewPlayer, [152], true),
                    {1, NewPlayer};
                _ ->
                    {11, Player}
            end
    end.

buy_center(PKey, Sn, Node, Nickname, ActId, ActType, ActNum, OrderId, BuyNum) ->
    ?CALL(activity_proc:get_act_pid(), {one_gold_buy, buy_center, {PKey, Sn, Node, Nickname, ActId, ActType, ActNum, OrderId, BuyNum}}).

buy_center_cast(_State, {PKey, Sn, _Node, Nickname, ActId, ActType, ActNum, OrderId, BuyNum}) ->
    EtsKey = {ActId, ActType, ActNum, OrderId},
    case ets:lookup(?ETS_ONE_GOLD_GOODS, EtsKey) of
        [] ->
            false;
        [Ets] ->
            #base_one_gold_goods{total_num = BaseTotalNum} = data_one_gold_buy:get_by_actType_actNum_orderId(ActType, ActNum, OrderId),
            #ets_one_gold_goods{
                order_id = OrderId,
                act_type = ActType,
                act_num = ActNum,
                total_num = OldTotalNum,
                buy_list = BuyList
            } = Ets,
            if
                BaseTotalNum =< OldTotalNum -> false;
                true ->
                    NewBuyList =
                        case lists:keytake(PKey, 1, BuyList) of
                            false ->
                                [{PKey, Sn, Nickname, BuyNum} | BuyList];
                            {value, {PKey, _OldSn, _OldNickname, OldBuyNum}, Rest} ->
                                [{PKey, Sn, Nickname, OldBuyNum + BuyNum} | Rest]
                        end,
                    NewEts = Ets#ets_one_gold_goods{total_num = OldTotalNum + BuyNum, buy_list = NewBuyList},
                    ets:insert(?ETS_ONE_GOLD_GOODS, NewEts),
                    activity_load:dbup_ets_one_gold_buy(NewEts),
                    true
            end
    end.

check_buy(OrderId, BuyNum, Player) ->
    case get_act() of
        [] ->
            {fail, 8}; %% 活动过期
        #base_act_one_gold_buy{act_id = ActId, act_type = ActType, price_list = PriceList} ->
            case get_status() of
                {Status, ActNum, _ActStartTime, ActEndTime} ->
                    NowSec = util:get_seconds_from_midnight(),
                    if
                        Status == ?ONE_GOLD_BUY_READY -> {fail, 9}; %% 准备区间
                        Status == ?ONE_GOLD_BUY_END -> {fail, 10}; %% 结束
                        ActEndTime - NowSec =< 2 -> {fail, 10}; %% 提前两秒结束
                        true ->
                            case cross_all:apply_call(?MODULE, get_buy_num, [{ActId, ActType, ActNum, OrderId}, BuyNum]) of
                                {true, NewBuyNum} ->
                                    {N, P} = hd(PriceList),
                                    Cost = round(NewBuyNum * P div N),
                                    case money:is_enough(Player, Cost, gold) of
                                        false ->
                                            {fail, 2}; %% 元宝不足
                                        true ->
                                            {true, ActId, NewBuyNum, ActType, ActNum, Cost}
                                    end;
                                _ ->
                                    {fail, 11} %% 抢购次数不足
                            end
                    end
            end
    end.

get_buy_num(EtsKey, BuyNum) ->
    case ets:lookup(?ETS_ONE_GOLD_GOODS, EtsKey) of
        [] -> false;
        [Ets] ->
            #ets_one_gold_goods{
                order_id = OrderId,
                act_type = ActType,
                act_num = ActNum,
                total_num = TotalNum
            } = Ets,
            #base_one_gold_goods{total_num = BaseTotalNum} = data_one_gold_buy:get_by_actType_actNum_orderId(ActType, ActNum, OrderId),
            if
                BaseTotalNum =< TotalNum ->
                    false;
                true ->
                    {true, min(BuyNum, BaseTotalNum - TotalNum)}
            end
    end.

get_state(Player) ->
    Code =
        case get_act() of
            [] -> -1;
            #base_act_one_gold_buy{act_info = ActInfo} ->

                BaseRewardList = get_reward_list(Player#player.lv),
                St = lib_dict:get(?PROC_STATUS_ONE_GOLD_BUY),
                #st_one_gold_buy{
                    recv_list = RecvList,
                    buy_num = BuyNum
                } = St,
                F = fun({BaseNum, _Gid, _Gnum}) ->
                    if
                        BaseNum > BuyNum -> [];
                        true ->
                            ?IF_ELSE(lists:member(BaseNum, RecvList) == true, [], [1])
                    end
                    end,
                LL = lists:flatmap(F, BaseRewardList),
                Args = activity:get_base_state(ActInfo),
                ?IF_ELSE(LL == [], {0, Args}, {1, Args})
        end,
    Code.

%% 次数奖励领取
recv_num_reward(BaseBuyNum, Player) ->
    St = lib_dict:get(?PROC_STATUS_ONE_GOLD_BUY),
    #st_one_gold_buy{
        recv_list = RecvList,
        buy_num = BuyNum
    } = St,
    case get_act() of
        [] ->
            {8, Player};
        _ ->
            RewardList = get_reward_list(Player#player.lv),
            case lists:member(BaseBuyNum, RecvList) of
                true -> {5, Player};
                false ->
                    if
                        BaseBuyNum > BuyNum -> {7, Player};
                        true ->
                            case lists:keyfind(BaseBuyNum, 1, RewardList) of
                                false -> {0, Player};
                                {_, GoodsId, GoodsNum} ->
                                    NewSt = St#st_one_gold_buy{
                                        recv_list = [BaseBuyNum | RecvList],
                                        op_time = util:unixtime()
                                    },
                                    lib_dict:put(?PROC_STATUS_ONE_GOLD_BUY, NewSt),
                                    activity_load:dbup_one_gold_buy(NewSt),
                                    GiveGoodsList = goods:make_give_goods_list(696, [{GoodsId, GoodsNum}]),
                                    {ok, NewPlayer99} = goods:give_goods(Player, GiveGoodsList),
                                    activity:get_notice(NewPlayer99, [152], true),
                                    {1, NewPlayer99}
                            end
                    end
            end
    end.

read_log(Player, ActNum) ->
    case get_act() of
        [] ->
            skip;
        _ ->
            cross_all:apply(?MODULE, read_log_center, [Player#player.key, ActNum, Player#player.sid])
    end.

read_log_center(Pkey, ActNum, Sid) ->
    {ActStatus, NowActNum, _T, _T2} = get_status(),
    EtsList = ets:tab2list(?ETS_ONE_GOLD_GOODS),
    F = fun(Ets) ->
        #ets_one_gold_goods{
            order_id = OrderId,
            act_num = EtsActNum,
            log = Log,
            goods_id = GoodsId,
            goods_num = GoodsNum
        } = Ets,
        if
            ActNum /= EtsActNum -> [];
            Log == [] ->
                [[ActNum, OrderId, GoodsId, GoodsNum, <<>>, 0, 0]];
            true ->
                {_Pkey, Sn, Nickname, Buynum} = hd(Log),
                [[ActNum, OrderId, GoodsId, GoodsNum, Nickname, Buynum, Sn]]
        end
        end,
    SysLogList = lists:flatmap(F, EtsList),
    F2 = fun(Ets) ->
        #ets_one_gold_goods{
            act_num = EtsActNum,
            order_id = OrderId,
            log = Log,
            buy_list = BuyList,
            goods_id = GoodsId,
            goods_num = GoodsNum
        } = Ets,
        if
            Log == [] ->
                case lists:keyfind(Pkey, 1, BuyList) of
                    false -> [];
                    {_EtsPkey, _sn, _Nickname, Buynum} ->
                        if
                            EtsActNum < NowActNum ->
                                [[EtsActNum, OrderId, GoodsId, GoodsNum, Buynum, 0]];
                            EtsActNum == NowActNum andalso ActStatus == ?ONE_GOLD_BUY_START ->
                                [[EtsActNum, OrderId, GoodsId, GoodsNum, Buynum, 2]];
                            EtsActNum == NowActNum andalso ActStatus == ?ONE_GOLD_BUY_CLOSE ->
                                [[EtsActNum, OrderId, GoodsId, GoodsNum, Buynum, 0]];
                            true ->
                                [[EtsActNum, OrderId, GoodsId, GoodsNum, Buynum, 2]]
                        end
                end;
            true ->
                {EtsPkey, _Sn, _Nickname, Buynum} = hd(Log),
                if
                    EtsPkey == Pkey -> [[EtsActNum, OrderId, GoodsId, GoodsNum, Buynum, 1]];
                    true ->
                        case lists:keyfind(Pkey, 1, BuyList) of
                            false -> [];
                            {_EtsPkey0, _sn0, _Nickname0, Buynum99} ->
                                if
                                    EtsActNum < NowActNum ->
                                        [[EtsActNum, OrderId, GoodsId, GoodsNum, Buynum99, 0]];
                                    EtsActNum == NowActNum andalso ActStatus == ?ONE_GOLD_BUY_START ->
                                        [[EtsActNum, OrderId, GoodsId, GoodsNum, Buynum99, 2]];
                                    EtsActNum == NowActNum andalso ActStatus == ?ONE_GOLD_BUY_CLOSE ->
                                        [[EtsActNum, OrderId, GoodsId, GoodsNum, Buynum99, 0]];
                                    true ->
                                        [[EtsActNum, OrderId, GoodsId, GoodsNum, Buynum99, 2]]
                                end
                        end
                end
        end
         end,
    MyLogList = lists:flatmap(F2, EtsList),
    {ok, Bin} = pt_439:write(43912, {SysLogList, MyLogList}),
    server_send:send_to_sid(Sid, Bin),
    ok.

get_reward_list(Lv) ->
    Ids = data_one_gold_buy_reward:get_all(),
    F = fun(Id) ->
        {LvMin, LvMax, BuyNum, GoodsId, GoodsNum} = data_one_gold_buy_reward:get(Id),
        if
            Lv < LvMin orelse Lv > LvMax -> [];
            true -> [{BuyNum, GoodsId, GoodsNum}]
        end
        end,
    lists:flatmap(F, Ids).