%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 招财进宝
%%% @end
%%% Created : 11. 七月 2017 10:15
%%%-------------------------------------------------------------------
-module(act_buy_money).
-author("luobq").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("daily.hrl").

-define(COIN_GOODSID, 10101). %% 银币物品id
-define(XINGHUN_GOODSID, 10400). %% 星魂物品id

-define(FREE_NUM, 4).
%% API
-export([
    init/1,
    midnight_refresh/1,
    logout/1,
    get_state/1,
    get_act_info/1,
    recv/3,
    get_coin_time/2,
    update_online_time/1
]).

init(#player{key = Pkey} = Player) ->
    StBuyMoney =
        case player_util:is_new_role(Player) of
            true -> #st_buy_money{pkey = Pkey};
            false ->
                activity_load:dbget_buy_money(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_BUY_MONEY, StBuyMoney),
    update_buy_money(),
    Player.

update_buy_money() ->
    StBuyMoney = lib_dict:get(?PROC_STATUS_BUY_MONEY),
    #st_buy_money{
        pkey = Pkey,
        last_login_time = LastLoginTime
    } = StBuyMoney,
    Now = util:unixtime(),
    Flag = util:is_same_date(Now, LastLoginTime),
    if
        Flag == false ->
            NewStBuyMoney = #st_buy_money{pkey = Pkey, last_login_time = Now};
        true ->
            NewStBuyMoney = StBuyMoney#st_buy_money{last_login_time = Now}
    end,
    lib_dict:put(?PROC_STATUS_BUY_MONEY, NewStBuyMoney).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_buy_money().

logout(Player) ->
    update_online_time(Player),
    StBuyCoin = lib_dict:get(?PROC_STATUS_BUY_MONEY),
    activity_load:dbup_buy_money(StBuyCoin).

get_state(Player) ->
    update_online_time(Player),
    StBuyCoin = lib_dict:get(?PROC_STATUS_BUY_MONEY),
    #st_buy_money{
        online_time = OnlineTime,
        coin_free_num = CoinFreeNum,
        xinghun_free_num = XinghunFreNum
    } = StBuyCoin,
    CoinCount = max(0, get_coin_time(Player, OnlineTime) - CoinFreeNum),
    XingHunCount = max(0, get_xinghun_time(Player, OnlineTime) - XinghunFreNum),
    if
        CoinCount > 0 -> 1;
        XingHunCount > 0 -> 1;
        true -> 0
    end.


get_act_info(Player) ->
    update_online_time(Player),
    StBuyMoney = lib_dict:get(?PROC_STATUS_BUY_MONEY),
    #st_buy_money{
        online_time = OnlineTime
        , coin_free_num = CoinFreeNum
        , coin_all_num = CoinAllNum
        , xinghun_free_num = XingHunFreeNum
        , xinghun_all_num = XingHunAllNum
    } = StBuyMoney,
    Dvip = ?IF_ELSE(Player#player.d_vip#dvip.vip_type > 0, 1, 0),
    NowTime = daily:get_count(?DAILY_DVIP_DRAW_ACT_BUY, 0),
    NowTime2 = daily:get_count(?DAILY_DVIP_DRAW_ACT_BUY_2, 0),
    CoinSum = daily:get_count(?DAILY_DVIP_DRAW_ACT_BUY_COIN_SUM, 0),
    CoinGet0 = data_buy_money_coin:get(CoinFreeNum + CoinAllNum + 1 + NowTime),
    Len = length(data_buy_money_coin:get_all()),
    if
        CoinGet0 == [] -> CoinGet = 0;
        CoinGet0#base_buy_money.id == Len andalso Dvip == 0 -> CoinGet = 0;
        true -> CoinGet = CoinGet0#base_buy_money.reward
    end,
    CoinRemainCount = max(0, length(data_buy_money_coin:get_all()) - CoinAllNum - ?FREE_NUM),
    CoinCost0 = data_buy_money_coin:get(CoinAllNum + 1),
    CoinCost = ?IF_ELSE(CoinCost0 == [], 0, CoinCost0#base_buy_money.cost),
    CoinCount = max(0, get_coin_time(Player, OnlineTime) - CoinFreeNum),
    CoinNextTime = max(0, data_buy_money_coin_online:get_next(OnlineTime div 60 + 1) * 60 - OnlineTime),
    {CoinRes, CoinTenCost,_, _} = check_coin_ten(Player),

    Ids = data_buy_money_coin:get_all(),
    RatioList =
        util:list_unique(lists:flatmap(fun(Id0) ->
            Base0 = data_buy_money_coin:get(Id0),
            [round(R*100) || {R, _} <- Base0#base_buy_money.luck_list]
        end, Ids)),

    XingHunGet0 = data_buy_money_xinghun:get(XingHunFreeNum + XingHunAllNum + 1 + NowTime2),
    if
        XingHunGet0 == [] -> XingHunGet = 0;
        XingHunGet0#base_buy_money.id == Len andalso Dvip == 0 -> XingHunGet = 0;
        true -> XingHunGet = XingHunGet0#base_buy_money.reward
    end,
    XingHunRemainCount = max(0, length(data_buy_money_xinghun:get_all()) - XingHunAllNum - ?FREE_NUM),
    XingHunCost0 = data_buy_money_xinghun:get(XingHunAllNum + 1),
    XingHunCost = ?IF_ELSE(XingHunCost0 == [], 0, XingHunCost0#base_buy_money.cost),
    XingHunCount = max(0, get_xinghun_time(Player, OnlineTime) - XingHunFreeNum),
    XingHunNextTime = max(0, data_buy_money_xinghun_online:get_next(OnlineTime div 60 + 1) * 60 - OnlineTime),
    XinghunSum = daily:get_count(?DAILY_DVIP_DRAW_ACT_BUY_XINGHUN_SUM, 0),
    {XingHunRes, XinghunTenCost,_, _} = check_xinghun_ten(Player),
    Ids1 = data_buy_money_coin:get_all(),
    RatioList1 =
        util:list_unique(lists:flatmap(fun(Id0) ->
            Base0 = data_buy_money_coin:get(Id0),
            [round(R * 100) || {R, _} <- Base0#base_buy_money.luck_list]
        end, Ids1)),
    ?DEBUG("CoinTenCost ~p~n", [CoinTenCost]),
    ?DEBUG("XinghunTenCost ~p~n", [XinghunTenCost]),
    {CoinGet, CoinRemainCount, CoinCost, ?IF_ELSE(CoinRes == 0, 0, CoinTenCost), CoinCount, CoinNextTime, CoinSum,
        XingHunGet, XingHunRemainCount, XingHunCost, ?IF_ELSE(XingHunRes == 0, 0, XinghunTenCost), XingHunCount, XingHunNextTime, XinghunSum, RatioList, RatioList1}.

%% 购买银币
recv(Player, 1, 1) ->
    update_online_time(Player),
    StBuyMoney = lib_dict:get(?PROC_STATUS_BUY_MONEY),
    #st_buy_money{
        coin_free_num = CoinFreeNum,
        coin_all_num = Num
    } = StBuyMoney,
    case check_coin(Player) of
        {fail, Res} ->
            {Res, Player, []};
        {true, dvip_free, Reward0, LuckList} ->
            Val = util:list_rand_ratio(LuckList),
            Reward = round(Reward0 * Val),
            dvip_util:add_act_buy_money(Player),
            NewPlayer = money:add_coin(Player, Reward, 291, 0, 0),
            act_hi_fan_tian:trigger_finish_api(Player, 16, 1),
            log_buy_money(Player#player.key, Player#player.nickname, 1, 0, Reward),
            daily:increment(?DAILY_DVIP_DRAW_ACT_BUY_COIN_SUM, Reward),
            activity:get_notice(NewPlayer, [132], true),
            {1, NewPlayer, [[?COIN_GOODSID, Reward, round(Val * 100)]]};
        {true, use_free_num, Reward0, LuckList} -> %% 使用免费次数
            Val = util:list_rand_ratio(LuckList),
            Reward = round(Reward0 * Val),
            NewStBuyMoney =
                StBuyMoney#st_buy_money{
                    coin_free_num = CoinFreeNum + 1
                },
            lib_dict:put(?PROC_STATUS_BUY_MONEY, NewStBuyMoney),
            activity_load:dbup_buy_money(NewStBuyMoney),
            NewPlayer = money:add_coin(Player, Reward, 291, 0, 0),
            act_hi_fan_tian:trigger_finish_api(Player, 16, 1),
            log_buy_money(Player#player.key, Player#player.nickname, 1, 0, Reward),
            daily:increment(?DAILY_DVIP_DRAW_ACT_BUY_COIN_SUM, Reward),
            activity:get_notice(NewPlayer, [132], true),
            {1, NewPlayer, [[?COIN_GOODSID, Reward, round(Val * 100)]]};
        {true, Cost, Reward0, LuckList} -> %% 扣除元宝
            Val = util:list_rand_ratio(LuckList),
            Reward = round(Reward0 * Val),
            NewStBuyMoney =
                StBuyMoney#st_buy_money{
                    coin_all_num = Num + 1
                },
            lib_dict:put(?PROC_STATUS_BUY_MONEY, NewStBuyMoney),
            activity_load:dbup_buy_money(NewStBuyMoney),
            NPlayer = money:add_no_bind_gold(Player, - Cost, 291, 0, 0),
            NewPlayer = money:add_coin(NPlayer, Reward, 291, 0, 0),
            log_buy_money(Player#player.key, Player#player.nickname, 1, Cost, Reward),
            act_hi_fan_tian:trigger_finish_api(Player, 16, 1),
            daily:increment(?DAILY_DVIP_DRAW_ACT_BUY_COIN_SUM, Reward),
            activity:get_notice(NewPlayer, [132], true),
            {1, NewPlayer, [[?COIN_GOODSID, Reward, round(Val * 100)]]}
    end;

%% 购买星魂
recv(Player, 1, 2) ->
    update_online_time(Player),
    StBuyMoney = lib_dict:get(?PROC_STATUS_BUY_MONEY),
    #st_buy_money{
        xinghun_free_num = XingHunFreeNum,
        xinghun_all_num = Num
    } = StBuyMoney,
    case check_xinghun(Player) of
        {fail, Res} ->
            {Res, Player, []};
        {true, dvip_free, Reward0, LuckList} ->
            Val = util:list_rand_ratio(LuckList),
            Reward = round(Reward0 * Val),
            dvip_util:add_act_buy_money2(Player),
            NewPlayer = money:add_xinghun(Player, Reward),
            log_buy_money(Player#player.key, Player#player.nickname, 2, 0, Reward),
            act_hi_fan_tian:trigger_finish_api(Player, 16, 1),
            activity:get_notice(NewPlayer, [132], true),
            daily:increment(?DAILY_DVIP_DRAW_ACT_BUY_XINGHUN_SUM, Reward),
            {1, NewPlayer, [[?XINGHUN_GOODSID, Reward, round(Val * 100)]]};
        {true, use_free_num, Reward0, LuckList} -> %% 使用免费次数
            Val = util:list_rand_ratio(LuckList),
            Reward = round(Reward0 * Val),
            NewStBuyMoney =
                StBuyMoney#st_buy_money{
                    xinghun_free_num = XingHunFreeNum + 1
                },
            lib_dict:put(?PROC_STATUS_BUY_MONEY, NewStBuyMoney),
            activity_load:dbup_buy_money(NewStBuyMoney),
            NewPlayer = money:add_xinghun(Player, Reward),
            log_buy_money(Player#player.key, Player#player.nickname, 2, 0, Reward),
            act_hi_fan_tian:trigger_finish_api(Player, 16, 1),
            activity:get_notice(NewPlayer, [132], true),
            daily:increment(?DAILY_DVIP_DRAW_ACT_BUY_XINGHUN_SUM, Reward),
            {1, NewPlayer, [[?XINGHUN_GOODSID, Reward, round(Val * 100)]]};
        {true, Cost, Reward0, LuckList} -> %% 扣除元宝
            Val = util:list_rand_ratio(LuckList),
            Reward = round(Reward0 * Val),
            NewStBuyMoney =
                StBuyMoney#st_buy_money{
                    xinghun_all_num = Num + 1
                },
            lib_dict:put(?PROC_STATUS_BUY_MONEY, NewStBuyMoney),
            activity_load:dbup_buy_money(NewStBuyMoney),
            NPlayer = money:add_no_bind_gold(Player, - Cost, 291, 0, 0),
            NewPlayer = money:add_xinghun(NPlayer, Reward),
            log_buy_money(Player#player.key, Player#player.nickname, 2, Cost, Reward),
            act_hi_fan_tian:trigger_finish_api(Player, 16, 1),
            activity:get_notice(NewPlayer, [132], true),
            daily:increment(?DAILY_DVIP_DRAW_ACT_BUY_XINGHUN_SUM, Reward),
            {1, NewPlayer, [[?XINGHUN_GOODSID, Reward, round(Val * 100)]]}
    end;

%% 银币十连抽
recv(Player, 2, 1) ->
    update_online_time(Player),
    StBuyMoney = lib_dict:get(?PROC_STATUS_BUY_MONEY),
    #st_buy_money{
        coin_all_num = Num
    } = StBuyMoney,
    {Res, _, Cost,RewardList} = check_coin_ten(Player),
    if
        Cost =< 0 ->
            {Res, Player, []};
        Res =/= 1 ->
            {Res, Player, []};
        true ->
            Len = length(RewardList),
            NewStBuyMoney =
                StBuyMoney#st_buy_money{
                    coin_all_num = Num + Len
                },
            lib_dict:put(?PROC_STATUS_BUY_MONEY, NewStBuyMoney),
            activity_load:dbup_buy_money(NewStBuyMoney),
            NPlayer = money:add_no_bind_gold(Player, - Cost, 291, 0, 0),
            Reward = lists:sum([round(Reward0 * Val0) || {Reward0, Val0} <- RewardList]),
            NewPlayer = money:add_coin(NPlayer, Reward, 291, 0, 0),
            log_buy_money(Player#player.key, Player#player.nickname, 1, Cost, Reward),
            act_hi_fan_tian:trigger_finish_api(Player, 16, Len),
            daily:increment(?DAILY_DVIP_DRAW_ACT_BUY_COIN_SUM, Reward),
            activity:get_notice(NewPlayer, [132], true),
            {1, NewPlayer, [[?COIN_GOODSID, round(Reward0 * Val0), round(Val0 * 100)] || {Reward0, Val0} <- RewardList]}
    end;

%% 灵气十连抽
recv(Player, 2, 2) ->
    update_online_time(Player),
    StBuyMoney = lib_dict:get(?PROC_STATUS_BUY_MONEY),
    #st_buy_money{
        xinghun_all_num = Num
    } = StBuyMoney,
    {Res, _,Cost, RewardList} = check_xinghun_ten(Player),
    if
        Cost =< 0 ->
            {Res, Player, []};
        Res =/= 1 ->
            {Res, Player, []};
        true ->
            Len = length(RewardList),
            NewStBuyMoney =
                StBuyMoney#st_buy_money{
                    xinghun_all_num = Num + Len
                },
            lib_dict:put(?PROC_STATUS_BUY_MONEY, NewStBuyMoney),
            activity_load:dbup_buy_money(NewStBuyMoney),
            NPlayer = money:add_no_bind_gold(Player, - Cost, 291, 0, 0),
            Reward = lists:sum([round(Reward0 * Val0) || {Reward0, Val0} <- RewardList]),
            NewPlayer = money:add_xinghun(NPlayer, Reward),
            log_buy_money(Player#player.key, Player#player.nickname, 2, Cost, Reward),
            act_hi_fan_tian:trigger_finish_api(Player, 16, Len),
            activity:get_notice(NewPlayer, [132], true),
            daily:increment(?DAILY_DVIP_DRAW_ACT_BUY_XINGHUN_SUM, Reward),
            {1, NewPlayer, [[?XINGHUN_GOODSID, round(Reward0 * Val0), round(Val0 * 100)] || {Reward0, Val0} <- RewardList]}
    end.


%% 购买银币 十连抽
check_coin_ten(Player) ->
    StBuyCoin = lib_dict:get(?PROC_STATUS_BUY_MONEY),
    #st_buy_money{
        coin_free_num = UseFreeNum,
        coin_all_num = Num
    } = StBuyCoin,
    NowTime = daily:get_count(?DAILY_DVIP_DRAW_ACT_BUY, 0),
    F = fun(Num0, {Res0,AllCost0, Cost0, RewardList}) ->
        case data_buy_money_coin:get(Num + Num0) of
            [] ->
                {19, AllCost0 ,Cost0, RewardList};
            #base_buy_money{cost = Cost, luck_list = LuckList} ->
                Base = data_buy_money_coin:get(Num + UseFreeNum + Num0 + NowTime),
                if
                    Base == [] ->{19,AllCost0 + Cost, Cost0, RewardList};
                    Cost == 0 ->{19,AllCost0 + Cost, Cost0, RewardList};
                    true ->
                        ?DEBUG("Cost + Cost0 ~p~n",[Cost + Cost0]),
                        case money:is_enough(Player, (Cost + Cost0), gold) of
                            false ->
                                {5, AllCost0 + Cost,Cost0, RewardList}; %% 元宝不足
                            true ->
                                Val = util:list_rand_ratio(LuckList),
                                {Res0,AllCost0 + Cost, Cost0 + Cost, [{Base#base_buy_money.reward, Val} | RewardList]}
                        end
                end

        end
    end,
    {Res, AllCost,Cost1, RewardList1} = lists:foldl(F, {1,0, 0, []}, lists:seq(1, 10)),
    ?DEBUG("{Res, Cost1, RewardList1} ~p~n",[{Res, Cost1, RewardList1}]),
    {Res,AllCost, Cost1, RewardList1}.


%% 购买星魂 十连抽
check_xinghun_ten(Player) ->
    StBuyCoin = lib_dict:get(?PROC_STATUS_BUY_MONEY),
    #st_buy_money{
        xinghun_free_num = UseFreeNum,
        xinghun_all_num = Num
    } = StBuyCoin,
    NowTime = daily:get_count(?DAILY_DVIP_DRAW_ACT_BUY, 0),

    F = fun(Num0, {Res0,AllCost0, Cost0, RewardList}) ->
        case data_buy_money_xinghun:get(Num + Num0) of
            [] ->
                {19,AllCost0, Cost0, RewardList};
            #base_buy_money{cost = Cost, luck_list = LuckList} ->
                Base = data_buy_money_xinghun:get(Num + UseFreeNum + Num0 + NowTime),
                if
                    Base == [] -> {19,AllCost0+ Cost, Cost0, RewardList};
                    Cost == 0 -> {19,AllCost0+ Cost, Cost0, RewardList};
                    true ->
                        case money:is_enough(Player, (Cost + Cost0), gold) of
                            false ->
                                {5,AllCost0+ Cost, Cost0, RewardList}; %% 元宝不足
                            true ->
                                Val = util:list_rand_ratio(LuckList),
                                {Res0, AllCost0+ Cost,Cost0 + Cost, [{Base#base_buy_money.reward, Val} | RewardList]}
                        end
                end

        end
    end,
    {Res,AllCost, Cost1, RewardList1} = lists:foldl(F, {1,0, 0, []}, lists:seq(1, 10)),
    {Res, AllCost,Cost1, RewardList1}.


%% 购买星魂
check_xinghun(Player) ->
    StBuyCoin = lib_dict:get(?PROC_STATUS_BUY_MONEY),
    #st_buy_money{
        online_time = OnlineTime,
        xinghun_free_num = UseFreeNum,
        xinghun_all_num = Num
    } = StBuyCoin,
    NowTime = daily:get_count(?DAILY_DVIP_DRAW_ACT_BUY_2, 0),
    case data_buy_money_xinghun:get(Num + 1) of
        [] ->
            {fail, 0}; %% 客户端发的数据有bug
        #base_buy_money{cost = Cost} ->
            Count = get_xinghun_time(Player, OnlineTime),
            Base = data_buy_money_xinghun:get(Num + UseFreeNum + 1 + NowTime),
            RemainFreeNum = max(0, Count - UseFreeNum),
            DvipFree = dvip_util:free_act_buy_money2(Player),
            if
                Base == [] -> {fail, 0};
                DvipFree ->
                    {true, dvip_free, Base#base_buy_money.reward, Base#base_buy_money.luck_list};
                RemainFreeNum > 0 ->
                    {true, use_free_num, Base#base_buy_money.reward, Base#base_buy_money.luck_list};
                true ->
                    case money:is_enough(Player, Cost, gold) of
                        false ->
                            {fail, 5};
                        true ->
                            {true, Cost, Base#base_buy_money.reward, Base#base_buy_money.luck_list}
                    end
            end
    end.

%% 购买银币
check_coin(Player) ->
    StBuyCoin = lib_dict:get(?PROC_STATUS_BUY_MONEY),
    #st_buy_money{
        online_time = OnlineTime,
        coin_free_num = UseFreeNum,
        coin_all_num = Num
    } = StBuyCoin,
    NowTime = daily:get_count(?DAILY_DVIP_DRAW_ACT_BUY, 0),

    case data_buy_money_coin:get(Num + 1) of
        [] ->
            {fail, 0}; %% 客户端发的数据有bug
        #base_buy_money{cost = Cost} ->
            Count = get_coin_time(Player, OnlineTime),
            Base = data_buy_money_coin:get(Num + UseFreeNum + 1 + NowTime),
            RemainFreeNum = max(0, Count - UseFreeNum),
            IsFree = dvip_util:free_act_buy_money(Player),
            if
                Base == [] -> {fail, 0};
                IsFree ->
                    {true, dvip_free, Base#base_buy_money.reward, Base#base_buy_money.luck_list};
                RemainFreeNum > 0 ->
                    {true, use_free_num, Base#base_buy_money.reward, Base#base_buy_money.luck_list};
                true ->
                    case money:is_enough(Player, Cost, gold) of
                        false ->
                            {fail, 5}; %% 元宝不足
                        true ->
                            {true, Cost, Base#base_buy_money.reward, Base#base_buy_money.luck_list}
                    end
            end
    end.

get_coin_time(Player, OnlineTime) ->
    Time = OnlineTime div 60,
    TimeList = data_buy_money_coin_online:get_all(),
    F = fun(Time0, {TimeMax, Max}) ->
        if
            Time0 =< Time andalso Time0 >= TimeMax ->
                {Time0, data_buy_money_coin_online:get(Time0)};
            true ->
                {TimeMax, Max}
        end
    end,
    {_, Count} = lists:foldl(F, {0, 0}, TimeList),
    Count + dvip_util:get_act_buy_money_free_time(Player).

get_xinghun_time(Player, OnlineTime) ->
    Time = OnlineTime div 60,
    TimeList = data_buy_money_xinghun_online:get_all(),
    F = fun(Time0, {TimeMax, Max}) ->
        if
            Time0 =< Time andalso Time0 >= TimeMax ->
                {Time0, data_buy_money_xinghun_online:get(Time0)};
            true ->
                {TimeMax, Max}
        end
    end,
    {_, Count} = lists:foldl(F, {0, 0}, TimeList),
    Count + dvip_util:get_act_buy_money_free_time2(Player).

update_online_time(Player) ->
    if
        Player#player.lv < 65 ->
            StBuyCoin = lib_dict:get(?PROC_STATUS_BUY_MONEY),
            Now = util:unixtime(),
            NewStBuyCoin = StBuyCoin#st_buy_money{online_time = 0, last_login_time = Now},
            lib_dict:put(?PROC_STATUS_BUY_MONEY, NewStBuyCoin);
%%             activity:get_notice(Player, [132], true);
        true ->
            Now = util:unixtime(),
            StBuyCoin = lib_dict:get(?PROC_STATUS_BUY_MONEY),
            Flag = util:is_same_date(Now, StBuyCoin#st_buy_money.last_login_time),
            #st_buy_money{
                online_time = OnlineTime,
                last_login_time = LastLoginTime
            } = StBuyCoin,
            if
                Flag == true ->
                    NewOnlineTime = OnlineTime + (Now - LastLoginTime),
                    NewStBuyMoney = StBuyCoin#st_buy_money{pkey = Player#player.key, last_login_time = Now, online_time = NewOnlineTime};
                true ->
                    NewStBuyMoney = #st_buy_money{pkey = Player#player.key, last_login_time = Now}
            end,
            NewStBuyCoin = NewStBuyMoney,
            lib_dict:put(?PROC_STATUS_BUY_MONEY, NewStBuyCoin)
%%             activity:get_notice(Player, [132], true)
    end.

%% log_buy_money(Pkey, Type,Cost,Get) ->
log_buy_money(Pkey, Nickname, Type, Cost, Get) ->
    Sql = io_lib:format("insert into  log_buy_money (pkey, nickname,buy_type,cost,val) VALUES(~p,'~s',~p,~p,~p)",
        [Pkey, Nickname, Type, Cost, Get]),
    log_proc:log(Sql),
    ok.

