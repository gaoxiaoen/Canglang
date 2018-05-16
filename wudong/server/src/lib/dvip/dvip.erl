%%%-------------------------------------------------------------------
%%% @author lzx
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         钻石VIP
%%% @end
%%% Created : 11. 九月 2017 10:33
%%%-------------------------------------------------------------------
-module(dvip).
-author("lzx").
-include("common.hrl").
-include("server.hrl").
-include("player_mask.hrl").
-include("dvip.hrl").
-include("daily.hrl").
-include("goods.hrl").
-include("skill.hrl").


%% API
-export([
    init/1,
    send_d_info/1,
    get_f_vip/1,
    get_today_award/1,
    buy_dvip/1,
    charge/2,
    get_diamond_market_info/1,
    exchange_diamond_market/3,
    get_gold_exchange_info/1,
    exchange_gold/2,
    get_step_exchange_info/1,
    exchange_step_goods/3,
    dvip_time_out/1,
    calc_skill_cbp/1,
    check_get_gift_state/1,
    check_diamond_exchange_state/1
]).


%% 初始化
init(#player{} = Player) ->
    {VipType, EndTime} = player_mask:get(?PLAYER_DVIP_STATE, {0, 0}),
    DVip = #dvip{vip_type = VipType, time = EndTime},
    Player1 = Player#player{d_vip = DVip},
    NewPlayer = init_passive_skill(VipType, Player1),
    NewPlayer.

%% 发送
send_d_info(#player{d_vip = #dvip{vip_type = VipType, time = EndTime}, sid = Sid}) ->
    NowTime = util:unixtime(),
    #base_d_vip_config{gift = GoodsList} = data_d_vip:get(VipType),
    GoodsList2 = [[GoodsId, GoodsNum] || {GoodsId, GoodsNum} <- GoodsList],
    case GoodsList2 == [] of
        true ->
            IsGet = 0;
        _ ->
            GetTime = daily:get_count(?DAILY_DVIP_GET_GIFT_STATE, 0),
            IsGet =
                case GetTime of
                    0 -> 1; %%可领取
                    1 -> ?IF_ELSE(VipType == 1, 4, 3);
                    _ ->
                        2
                end
    end,
    LeftTime = max(EndTime - NowTime, 0),
    VipType2 = case VipType == 0 of
                   true ->
                       IsEven = player_mask:get(?PLAYER_EVER_DVIP_STATE, 0),
                       case IsEven > 0 of
                           true -> 3;
                           _ ->
                               0
                       end;
                   _ ->
                       VipType
               end,
    Data = {VipType2, ?DVIP_COST, ?DVIP_EFFECT_TIME, LeftTime, IsGet, GoodsList2},
    ?PRINT("40401 ----------- Data ~w", [Data]),
    {ok, BinData} = pt_404:write(40401, Data),
    server_send:send_to_sid(Sid, BinData).


%% 成为永久信息vip
get_f_vip(#player{sid = Sid} = _Player) ->
    {ChargeTime, ContineTime} = player_mask:get(?PLAYER_DIVIP_SIGN_UP_MASK, {0, 0}),
    NowTime = util:unixtime(),
    case util:is_same_date(NowTime, ChargeTime) of
        true ->
            NewContineTime = ContineTime,
            IsCharge = 1;
        _ ->
            case util:is_same_date(NowTime - ?ONE_DAY_SECONDS, ChargeTime) of
                true -> NewContineTime = ContineTime;
                _ ->
                    NewContineTime = 0
            end,
            IsCharge = 0
    end,
    ChargeList =
        lists:map(fun(DayId) ->
            if DayId =< NewContineTime ->
                [DayId, 1];
                true ->
                    [DayId, 0]
            end
        end, lists:seq(1, ?DVIP_CHARGE_DAY)),
    ChargeNum = player_mask:get(?PLAYER_DVIP_CHARGE, 0),
    Data = {IsCharge, ChargeList, ChargeNum, ?DVIP_CHARGE_TOTAL},
    {ok, BinData} = pt_404:write(40402, Data),
    server_send:send_to_sid(Sid, BinData).


%% 获取今日奖励
get_today_award(#player{d_vip = #dvip{vip_type = VipType}} = Player) ->
    case data_d_vip:get(VipType) of
        #base_d_vip_config{gift = GiftList} when GiftList /= [] ->
            IsGet = daily:get_count(?DAILY_DVIP_GET_GIFT_STATE, 0),
            case IsGet of
                0 -> ok;
                1 -> ?ASSERT_TRUE(VipType /= 2, {fail, 14});
                _ ->
                    throw({fail, 15})
            end,
            daily:set_count(?DAILY_DVIP_GET_GIFT_STATE, IsGet + 1),
            GiveGoodsList = goods:make_give_goods_list(532, GiftList),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            {ok, NewPlayer};
        _ ->
            {fail, 0}
    end.


%% 是否有尊贵礼包可领取
check_get_gift_state(#player{d_vip = #dvip{vip_type = VipType}}) ->
    case data_d_vip:get(VipType) of
        #base_d_vip_config{gift = GiftList} when GiftList /= [] ->
            IsGet = daily:get_count(?DAILY_DVIP_GET_GIFT_STATE, 0),
            case IsGet of
                0 -> 1;
                1 ->
                    case VipType of
                        2 -> 1;
                        _ ->
                            0
                    end;
                _ ->
                    0
            end;
        _ ->
            0
    end.


%% 钻石商城是否可以兑换
check_diamond_exchange_state(#player{d_vip = #dvip{vip_type = VipType}} = _Player) ->
    case data_d_vip:get(VipType) of
        #base_d_vip_config{market = MarketList} when MarketList /= [] ->
            {NewMarketList, _} = lists:mapfoldl(fun({GoodsId, GoodsNum, CostType, CostNum, LimitNum, IsOnece}, AccIn) ->
                {{AccIn, GoodsId, GoodsNum, CostType, CostNum, LimitNum, IsOnece}, AccIn + 1}
            end, 1, MarketList),
            DiaMond = daily:get_count(?DAILY_DVIP_DIAMOND, 0),
            PlayerMarket = player_mask:get(?PLAYER_DVIP_MARKET_GET, []),
            MarketExList = daily:get_count(?DAILY_DVIP_DIAMOND_EXCHANGE, []),
            Ret = lists:any(fun({AccIn, _GoodsId, _GoodsNum, CostType, CostNum, LimitNum, IsOnece}) ->
                ExList =
                    case IsOnece == 1 of
                        true -> PlayerMarket;
                        _ -> MarketExList
                    end,
                case lists:keyfind(AccIn, 1, ExList) of
                    {_, HasEx} -> ok;
                    _ -> HasEx = 0
                end,
                case HasEx >= LimitNum of
                    true -> false; %%兑换已满了
                    false ->
                        case CostType of
                            1 ->
                                false;
%%                                money:is_enough(Player, CostNum, coin);
                            2 ->
                                false;
%%                                money:is_enough(Player, CostNum, gold);
                            3 ->
                                false;
%%                                money:is_enough(Player, CostNum, bgold);
                            _ ->
                                DiaMond >= CostNum
                        end
                end
            end, NewMarketList),
            case Ret of
                true -> 1;
                _ -> 0
            end;
        _ ->
            0
    end.


%%购买钻石vip
buy_dvip(#player{d_vip = #dvip{vip_type = VipType} = DVip} = Player) ->
    ?ASSERT_TRUE(VipType /= 0, {fail, 3}),
    ?ASSERT(money:is_enough(Player, ?DVIP_COST, gold), {fail, 4}),
    NewPlayer = money:cost_money(Player, gold, -?DVIP_COST, 546, 0, 0),
    NowTime = util:unixtime(),
    EndTime = NowTime + ?DVIP_EFFECT_TIME,
    NewDVip = DVip#dvip{vip_type = 1, time = EndTime},
    player_mask:set(?PLAYER_DVIP_STATE, {1, EndTime}),
    player_mask:set(?PLAYER_EVER_DVIP_STATE, 1), %% 曾经是vip
    NewPlayer2 = NewPlayer#player{d_vip = NewDVip},
    notice_sys:add_notice(buy_d_vip, [Player]),
    case data_d_vip:get(1) of
        #base_d_vip_config{active_skill = SkillId} when SkillId > 0 ->
            PassiveSkillList = lists:keydelete(SkillId, 1, NewPlayer2#player.passive_skill),
            NewPlayer3 = NewPlayer2#player{passive_skill = [{SkillId, ?PASSIVE_SKILL_TYPE_DVIP} | PassiveSkillList]},
            scene_agent_dispatch:passive_skill(NewPlayer, NewPlayer#player.passive_skill);
        _ ->
            NewPlayer3 = NewPlayer2
    end,
    {ok, BinData} = pt_404:write(40411, {1}),
    server_send:send_to_sid(Player#player.sid, BinData),
    {ok, Bin11} = pt_240:write(24019, {Player#player.key, 1025002, 1}),
    server_send:send_to_sid(Player#player.sid, Bin11),
    %% 添加dvip log
    dvip_util:vip_update(NewPlayer3),
    NewPlayer4 = player_util:count_player_attribute(NewPlayer3, true),
    dvip_log:log_dvip(Player#player.key, 1),
    {ok, NewPlayer4}.


%% 充值增加钻石
charge_add_diamond(#player{d_vip = #dvip{vip_type = VipType}}, AddCharge) ->
    LeftGold = player_mask:get(?PLAYER_DVIP_CHARGE_GOLD, 0),
    ?PRINT("AddCharge ~w,LeftGold: ~w", [AddCharge, LeftGold]),
    AddDiamond = (AddCharge + LeftGold) div ?DVIP_GOLD_TO_DIAMOND,
    case VipType > 0 of
        true ->
            DiaMondNum = daily:get_count(?DAILY_DVIP_DIAMOND, 0),
            ?PRINT("AddDiamond ~w ============= ~w", [AddDiamond, DiaMondNum]),
            daily:set_count(?DAILY_DVIP_DIAMOND, DiaMondNum + AddDiamond),
            LfGold2 = LeftGold + AddCharge - AddDiamond * ?DVIP_GOLD_TO_DIAMOND,
            player_mask:set(?PLAYER_DVIP_CHARGE_GOLD, LfGold2);
        _ -> ok
    end.


%% 累计充值
charge(#player{d_vip = #dvip{vip_type = VipType} = Dvip} = Player, AddCharge) ->
    charge_add_diamond(Player, AddCharge),
    case VipType == 1 of
        true ->
            {LastTime, ContineTime} = player_mask:get(?PLAYER_DIVIP_SIGN_UP_MASK, {0, 0}),
            NowTime = util:unixtime(),
            case util:is_same_date(LastTime, NowTime) of
                true ->
                    NewC = ContineTime;
                false ->
                    case util:is_same_date(LastTime + ?ONE_DAY_SECONDS, NowTime) of
                        true ->
                            NewC = ContineTime + 1,
                            player_mask:set(?PLAYER_DIVIP_SIGN_UP_MASK, {NowTime, NewC});
                        _ ->
                            NewC = 1,
                            player_mask:set(?PLAYER_DIVIP_SIGN_UP_MASK, {NowTime, 1})
                    end
            end,
            ChargeVal = player_mask:get(?PLAYER_DVIP_CHARGE, 0),
            NewCharge = ChargeVal + AddCharge,
            player_mask:set(?PLAYER_DVIP_CHARGE, NewCharge),
            case NewCharge >= ?DVIP_CHARGE_TOTAL orelse (NewC >= ?DVIP_CHARGE_DAY andalso ?DVIP_CHARGE_DAY /= 0) of
                true ->
                    NewDVip = Dvip#dvip{vip_type = 2, time = util:unixtime() + ?DVIP_EFFECT_SP_TIME},
                    player_mask:set(?PLAYER_DVIP_STATE, {2, util:unixtime() + ?DVIP_EFFECT_SP_TIME}),
                    NewPlayer = Player#player{d_vip = NewDVip},
                    dvip_util:vip_update(NewPlayer),
                    {ok, BinData} = pt_404:write(40411, {2}),
                    server_send:send_to_sid(Player#player.sid, BinData),
                    dvip_log:log_dvip(Player#player.key, 2),
                    NewPlayer;
                _ ->
                    Player
            end;
        _ ->
            Player
    end.

%% 钻石商城信息
get_diamond_market_info(#player{d_vip = #dvip{vip_type = VipType}} = Player) ->
    case VipType > 0 of
        true ->
            Diamond = daily:get_count(?DAILY_DVIP_DIAMOND, 0),
            ExChangeList = daily:get_count(?DAILY_DVIP_DIAMOND_EXCHANGE, []),
            PlayerExList = player_mask:get(?PLAYER_DVIP_MARKET_GET, []),
            #base_d_vip_config{market = MarketList} = data_d_vip:get(VipType),
            MaxIndex = player_mask:get(?PLAYER_DVIP_MARKET_MAX_INDEX, 0),
            {MarketPackList, _} =
                lists:mapfoldl(fun({GoodsId, GoodsNum, ExType, ExCost, Limit, IsOnece}, {AccIn, IsOpen}) ->
                    case IsOnece == 1 of
                        true ->
                            NewIsOpen = true,
                            case lists:keyfind(AccIn, 1, PlayerExList) of
                                {_, ExNum} -> LeftLimit = max(Limit - ExNum, 0);
                                _ ->
                                    LeftLimit = Limit
                            end;
                        false ->
                            case lists:keyfind(AccIn, 1, ExChangeList) of
                                {_, ExNum} -> LeftLimit = max(Limit - ExNum, 0);
                                _ ->
                                    LeftLimit = Limit
                            end,
%%                            ?PRINT("LeftLimit ~w,Limit ~w",[LeftLimit,Limit]),
                            NewIsOpen = case LeftLimit == Limit of
                                            true -> false; %%下个id不显示
                                            false ->
                                                true
                                        end
                    end,
                    NextIsOpen = NewIsOpen andalso IsOpen,
                    GoodsId2 =
                        case IsOpen orelse MaxIndex + 1 >= AccIn of
                            true -> GoodsId;
                            false ->
                                0
                        end,
                    {[AccIn, GoodsId2, GoodsNum, ExType, ExCost, LeftLimit, IsOnece], {AccIn + 1, NextIsOpen}}
                end, {1, true}, MarketList),
            PackList = pack_market_list(MarketPackList, []),
            {ok, BinData} = pt_404:write(40405, {Diamond, PackList}),
            server_send:send_to_sid(Player#player.sid, BinData);
        _ ->
            skip
    end.

pack_market_list([], AccList) -> lists:reverse(AccList);
pack_market_list([[_, _GoodsId | _] = H | T], AccList) ->
    case _GoodsId == 0 of
        true ->
            lists:reverse([H | AccList]);
        false ->
            pack_market_list(T, [H | AccList])
    end.


%% 积分商城兑换
exchange_diamond_market(#player{d_vip = #dvip{vip_type = VipType}} = Player, _ExCellId, ExNum) ->
    ?ASSERT_TRUE(VipType =< 0, {fail, 5}),
    #base_d_vip_config{market = MarketList} = data_d_vip:get(VipType),
    ?ASSERT_TRUE(_ExCellId > length(MarketList), {fail, 12}),
    {GoodsId, GoodsNum, CostType, CostNum, LimitNum, IsOnece} = lists:nth(_ExCellId, MarketList),
    ExList =
        case IsOnece == 1 of
            true ->
                player_mask:get(?PLAYER_DVIP_MARKET_GET, []);
            _ ->
                daily:get_count(?DAILY_DVIP_DIAMOND_EXCHANGE, [])
        end,
    DiaMond = daily:get_count(?DAILY_DVIP_DIAMOND, 0),
    case lists:keyfind(_ExCellId, 1, ExList) of
        {_, HasEx} -> ok;
        _ -> HasEx = 0
    end,
    ?PRINT("ExList ~w ==============  ExNum ~w LimitNum: ~w", [ExNum, ExList, LimitNum]),
    ?ASSERT_TRUE(HasEx + ExNum > LimitNum, {fail, 7}), %%兑换已达到上限
    NeedCost = (ExNum * CostNum), %%总花费积分
    case CostType of
        1 ->
            ?ASSERT(money:is_enough(Player, NeedCost, coin), {fail, 8}),
            CostType2 = coin;
        2 ->
            ?ASSERT(money:is_enough(Player, NeedCost, gold), {fail, 9}),
            CostType2 = gold;
        3 ->
            ?ASSERT(money:is_enough(Player, NeedCost, bgold), {fail, 10}),
            CostType2 = bgold;
        _ ->
            ?ASSERT_TRUE(NeedCost > DiaMond, {fail, 11}),
            CostType2 = diamond
    end,
    ?PRINT("CostType2 ~w, NeedCost ~w", [CostType2, NeedCost]),
    case CostType2 of
        diamond ->
            daily:set_count(?DAILY_DVIP_DIAMOND, DiaMond - NeedCost),
            NewPlayer = Player;
        _ ->
            NewPlayer = money:cost_money(Player, CostType2, -NeedCost, 548, 0, 0)
    end,
    GiveGoodsNum = ExNum * GoodsNum,
    GiveGoodsList = goods:make_give_goods_list(548, [{GoodsId, GiveGoodsNum}]),
    {ok, NewPlayer2} = goods:give_goods(NewPlayer, GiveGoodsList),
    ExList2 = lists:keystore(_ExCellId, 1, ExList, {_ExCellId, ExNum + HasEx}),
    MaxIndex = player_mask:get(?PLAYER_DVIP_MARKET_MAX_INDEX, 0),
    MaxIndex2 = max(MaxIndex, _ExCellId),
    player_mask:set(?PLAYER_DVIP_MARKET_MAX_INDEX, MaxIndex2),
    case IsOnece > 0 of
        true ->
            player_mask:set(?PLAYER_DVIP_MARKET_GET, ExList2);
        false ->
            daily:set_count(?DAILY_DVIP_DIAMOND_EXCHANGE, ExList2)
    end,
    dvip_log:log_dvip_ex_market(Player#player.key, _ExCellId, ExNum, CostType, NeedCost, [{GoodsId, GiveGoodsNum}]),
    {ok, NewPlayer2}.


%% 获取钻石兑换信息
get_gold_exchange_info(#player{d_vip = #dvip{vip_type = VipType}, vip_lv = VipLv} = Player) ->
    case data_d_vip:get(VipType) of
        #base_d_vip_config{gold_exchange = GoldExChange} when GoldExChange /= [] ->
            {vip, ExVipLv, AddNum} = lists:keyfind(vip, 1, GoldExChange),
            {ex, BGold, Gold} = lists:keyfind(ex, 1, GoldExChange),
            {limit, MaxTime} = lists:keyfind(limit, 1, GoldExChange),
            MaxLimitTime = case VipLv >= ExVipLv of
                               true -> MaxTime + AddNum;
                               _ ->
                                   MaxTime
                           end,
            CurrentTime = daily:get_count(?DAILY_DVIP_GOLD_EXCHANGE, 0),
            LeftTime = max(MaxLimitTime - CurrentTime, 0),
            {ok, BinData} = pt_404:write(40407, {ExVipLv, AddNum, LeftTime, MaxLimitTime, BGold, Gold}),
            server_send:send_to_sid(Player#player.sid, BinData);
        _ ->
            skip
    end.


%% 兑换元宝
exchange_gold(#player{d_vip = #dvip{vip_type = VipType}, vip_lv = VipLv, bgold = BGold} = Player, _Time) ->
    case data_d_vip:get(VipType) of
        #base_d_vip_config{gold_exchange = GoldExChange} when GoldExChange /= [] ->
            {vip, ExVipLv, AddNum} = lists:keyfind(vip, 1, GoldExChange),
            {ex, ExBGold, Gold} = lists:keyfind(ex, 1, GoldExChange),
            {limit, MaxTime} = lists:keyfind(limit, 1, GoldExChange),
            CurrentTime = daily:get_count(?DAILY_DVIP_GOLD_EXCHANGE, 0),
            MaxLimitTime = case VipLv >= ExVipLv of
                               true -> MaxTime + AddNum;
                               _ ->
                                   MaxTime
                           end,
            ?ASSERT_TRUE(CurrentTime + _Time > MaxLimitTime, {fail, 6}),
            CostBGold = ExBGold * _Time, %% 消耗的钻石
            ?ASSERT_TRUE(CostBGold > BGold, {fail, 10}),
            AddGold = round(Gold * _Time),
            ?PRINT("CostGold ~w,ExGold ~w", [CostBGold, AddGold]),
            NewPlayer = money:cost_money(Player, bgold, -CostBGold, 547, 0, 0),
            NewPlayer2 = money:add_no_bind_gold(NewPlayer, AddGold, 547, 0, 0),
            daily:set_count(?DAILY_DVIP_GOLD_EXCHANGE, CurrentTime + _Time),
            dvip_log:log_dvip_ex_gold(Player#player.key, CostBGold, AddGold, _Time),
            {ok, NewPlayer2};
        _ ->
            {fail, 0}
    end.


%% 进阶丹兑换信息
get_step_exchange_info(#player{d_vip = #dvip{vip_type = VipType}, vip_lv = VipLv} = Player) ->
    case data_d_vip:get(VipType) of
        #base_d_vip_config{step_exchange = StepExpList} when StepExpList /= [] ->
            {vip, StepVipLv, AddNum} = lists:keyfind(vip, 1, StepExpList),
            {limit, MaxTime} = lists:keyfind(limit, 1, StepExpList),
            CurrentTime = daily:get_count(?DAILY_DVIP_STEP_EXCHANGE, 0),
            MaxTime2 = case VipLv >= StepVipLv of
                           true -> AddNum + MaxTime;
                           _ -> MaxTime
                       end,
            {ex, ExGoodsList} = lists:keyfind(ex, 1, StepExpList),
            {ExGoodsPackList, _} =
                lists:mapfoldl(fun({ExName, GoodsId, GoodsNum, CostGold, GoodsId2, GoodsNum2}, AccIn) ->
                    {[AccIn, ExName, GoodsId, GoodsNum, CostGold, GoodsId2, GoodsNum2], AccIn + 1}
                end, 1, ExGoodsList),
            LeftTime = max(MaxTime2 - CurrentTime, 0),
            Data = {StepVipLv, AddNum, LeftTime, MaxTime2, ExGoodsPackList},
%%            ?PRINT("Data ~w00 ",[Data]),
            {ok, BinData} = pt_404:write(40409, Data),
            server_send:send_to_sid(Player#player.sid, BinData);
        _ ->
            skip
    end.


%% 进阶丹兑换
exchange_step_goods(#player{d_vip = #dvip{vip_type = VipType}, vip_lv = VipLv} = Player, _Index, _Time) ->
    case data_d_vip:get(VipType) of
        #base_d_vip_config{step_exchange = StepExChangeList} when StepExChangeList /= [] ->
            {ex, ExGoodsList} = lists:keyfind(ex, 1, StepExChangeList),
            {vip, StepVipLv, AddNum} = lists:keyfind(vip, 1, StepExChangeList),
            {limit, MaxTime} = lists:keyfind(limit, 1, StepExChangeList),
            ?ASSERT_TRUE(_Index > length(ExGoodsList), {fail, 12}),
            CurrentTime = daily:get_count(?DAILY_DVIP_STEP_EXCHANGE, 0),
            MaxTime2 = case VipLv >= StepVipLv of
                           true -> AddNum + MaxTime;
                           _ -> MaxTime
                       end,
            ?ASSERT_TRUE(CurrentTime + _Time > MaxTime2, {fail, 6}),
            {_ExName, GoodsId, GoodsNum, CostGold, _GoodsId2, _GoodsNum2} = lists:nth(_Index, ExGoodsList),
            GoodsList = goods_util:get_type_list_by_expire_time(GoodsId),
            ExpireNum = lists:sum([Goods#goods.num || Goods <- GoodsList]),

            CostNum = GoodsNum * _Time,
            ?ASSERT_TRUE(CostNum > ExpireNum, {fail, 13}),
            NeedGold = CostGold * _Time,
            ?PRINT("ExpireNum:~w, CostNum: ~w,NeedGold ~w", [ExpireNum, CostNum, NeedGold]),
            ?ASSERT(money:is_enough(Player, NeedGold, gold), {fail, 9}),
            NewPlayer = money:cost_money(Player, gold, -NeedGold, 549, 0, 0),
            daily:set_count(?DAILY_DVIP_STEP_EXCHANGE, CurrentTime + _Time),
%%          删物品
            GoodsKeyList = get_del_goods_id(GoodsList, CostNum, []),
            ?PRINT("DelteGoodsKeyList ~w, NeedGold ~w", [GoodsKeyList, NeedGold]),
            goods:subtract_good_by_keys(GoodsKeyList),
%%          给物品
            GiveGoodsList = goods:make_give_goods_list(549, [{_GoodsId2, _GoodsNum2 * _Time}]),
            {ok, NewPlayer1} = goods:give_goods(NewPlayer, GiveGoodsList),
            dvip_log:log_dvip_ex_step(Player#player.key, _Index, _Time, NeedGold, GoodsKeyList, [{_GoodsId2, _GoodsNum2 * _Time}]),
            {ok, NewPlayer1};
        _ ->
            {fail, 8}
    end.


get_del_goods_id([], _, AccList) -> AccList;
get_del_goods_id([#goods{key = Gkey, num = Num} | T], LeftNum, AccList) ->
    case Num >= LeftNum of
        true ->
            [{Gkey, LeftNum} | AccList];
        false ->
            get_del_goods_id(T, LeftNum - Num, [{Gkey, Num} | AccList])
    end.

dvip_time_out(_Player) ->
    player_mask:set(?PLAYER_DVIP_STATE, {0, 0}),
    PassiveSkillList =
        case data_d_vip:get(1) of
            #base_d_vip_config{active_skill = SkillId} when SkillId > 0 ->
                case lists:keytake(SkillId, 1, _Player#player.passive_skill) of
                    false -> _Player#player.passive_skill;
                    {value, _, L} -> L
                end;
            _ ->
                _Player#player.passive_skill
        end,
    NewPlayer = _Player#player{d_vip = #dvip{}, passive_skill = PassiveSkillList},
    scene_agent_dispatch:passive_skill(NewPlayer, NewPlayer#player.passive_skill),
    NowTime = util:unixtime(),
    player_mask:set(?PLAYER_DVIP_TIME_OUT_PUSH, {NowTime, 1}),
    dvip_util:vip_update(NewPlayer),
    {ok, BinData} = pt_404:write(40411, {3}),
    server_send:send_to_sid(_Player#player.sid, BinData),
    NewPlayer1 = player_util:count_player_attribute(NewPlayer, true),
    activity:get_notice(NewPlayer1, [160], true),
    dvip_log:log_dvip(_Player#player.key, 0),
    player_mask:set(?PLAYER_DVIP_CHARGE, 0),
    NewPlayer1.


init_passive_skill(0, Player) ->
    Player;
init_passive_skill(_, Player) ->
    case data_d_vip:get(1) of
        #base_d_vip_config{active_skill = SkillId} when SkillId > 0 ->
            PassiveSkillList = Player#player.passive_skill,
            Player#player{passive_skill = [{SkillId, ?PASSIVE_SKILL_TYPE_DVIP} | PassiveSkillList]};
        _ ->
            Player
    end.


calc_skill_cbp(Dvip) ->
    if Dvip == 0 -> 0;
        true ->
            case data_d_vip:get(1) of
                #base_d_vip_config{active_skill = SkillId} when SkillId > 0 ->
                    case data_skill:get(SkillId) of
                        [] -> 0;
                        Skill ->
                            Skill#skill.skill_cbp
                    end
            end
    end.



