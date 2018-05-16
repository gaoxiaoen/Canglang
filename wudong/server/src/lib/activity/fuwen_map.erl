%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 符文寻宝
%%% @end
%%% Created : 08. 五月 2017 18:00
%%%-------------------------------------------------------------------
-module(fuwen_map).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("fuwen.hrl").
-include("goods.hrl").
-include("dungeon.hrl").

%% API
-export([
    init/1,
    midnight_refresh/1,
    get_state/1,
    get_act_info/1,
    go_map/2,
    get_act/0
]).

init(#player{key = Pkey} = Player) ->
    StFuwenMap =
        case player_util:is_new_role(Player) of
            true -> #st_fuwen_map{pkey = Pkey};
            false -> activity_load:dbget_fuwen_map(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_FUWEN_MAP, StFuwenMap),
    update_fuwen_map(),
    Player.

update_fuwen_map() ->
    StFuwenMap = lib_dict:get(?PROC_STATUS_FUWEN_MAP),
    #st_fuwen_map{
        pkey = Pkey,
        act_id = ActId,
        op_time = OpTime
    } = StFuwenMap,
    case get_act() of
        [] ->
            NewStFuwenMap = #st_fuwen_map{pkey = Pkey};
        #base_fuwen_map{act_id = BaseActId, list = BaseList} ->
            Now = util:unixtime(),
            if
                BaseActId =/= ActId ->
                    NStFuwenMap = #st_fuwen_map{pkey = Pkey, act_id = BaseActId, op_time = Now};
                true ->
                    NStFuwenMap = StFuwenMap
            end,
            #st_fuwen_map{fuwen_bag_id = FuwenBagId0} = NStFuwenMap,
            if
                FuwenBagId0 == 0 ->
                    {BaseBagId, _BaseP, _BaseLuckMin, _BaseLuckMax, _BaseSubList} = hd(BaseList),
                    FuwenBagId = BaseBagId;
                true ->
                    FuwenBagId = FuwenBagId0
            end,
            NewStFuwenMap =
                case util:is_same_date(OpTime, Now) of
                    true ->
                        NStFuwenMap#st_fuwen_map{fuwen_bag_id = FuwenBagId};
                    false ->
                        NStFuwenMap#st_fuwen_map{fuwen_bag_id = 0, luck_value = 0}
                end
    end,
    lib_dict:put(?PROC_STATUS_FUWEN_MAP, NewStFuwenMap).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_fuwen_map().

get_act_info(_Player) ->
    case get_act() of
        [] ->
            {0, 0, 0, 0, []};
        #base_fuwen_map{cd_time = CdTime, one_cost = OneCost, ten_cost = TenCost, list = BaseList} ->
            StFuwenMap = lib_dict:get(?PROC_STATUS_FUWEN_MAP),
            #st_fuwen_map{last_free_time = LastFreeTime} = StFuwenMap,
            RemainTime = max(0, LastFreeTime + CdTime - util:unixtime()),
            {_BaseBagId, _BaseP, _BaseLuckMin, _BaseLuckMax, BaseSubList} = hd(BaseList),
            F = fun({GId, GNum, _Power, Is}) -> [GId, GNum, Is] end,
            ShowFuwenList = lists:map(F, BaseSubList),
            DisCount = fuwen_map_discount:get_discount(),
            {RemainTime, OneCost, TenCost, DisCount, ShowFuwenList}
    end.

get_bag_info(LuckValue, BaseList, FuwenBagId, GoodsId) ->
    #goods_type{color = Color} = data_goods:get(GoodsId),
    NewFuwenBagId0 = max(1, min(FuwenBagId, 10)),
    {_BaseBagId, P, LuckMin, LuckMax, _BaseSubList} = lists:keyfind(NewFuwenBagId0, 1, BaseList),
    F = fun({BaseBagId0, _BaseP0, _BaseLuckMin0, _BaseLuckMax0, _BaseSubList0}) -> BaseBagId0 end,
%%     ?DEBUG("BaseList:~p", [BaseList]),
    FuwenBagIds = lists:map(F, BaseList),
    {NewLuckValue, NewFuwenBagId} =
        if
            Color == 5 -> %% 抽到红色
                {0, 0};
            LuckValue < LuckMin ->
                {LuckValue, FuwenBagId};
            LuckValue >= LuckMax ->
                {0, FuwenBagId + 1};
            true ->
                Rand = util:rand(1, 10000),
                ?IF_ELSE(Rand > P, {LuckValue, FuwenBagId}, {0, FuwenBagId + 1})
        end,
    MaxFuwenBagId = lists:max(FuwenBagIds),
    if
        NewFuwenBagId == 0 ->
            {lists:min(FuwenBagIds), NewLuckValue};
        NewFuwenBagId > MaxFuwenBagId -> %%
            {lists:min(FuwenBagIds), 0};
        true ->
            {NewFuwenBagId, NewLuckValue}
    end.

go_map(Player, 1) ->
    StFuwenMap = lib_dict:get(?PROC_STATUS_FUWEN_MAP),
    #st_fuwen_map{
        luck_value = LuckValueOld,
        fuwen_bag_id = FuwenBagId,
        last_free_time = LastFreeTime
    } = StFuwenMap,
    case get_act() of
        [] ->
            {0, 0, Player, []};
        #base_fuwen_map{cd_time = CdTime, chip_min = ChipMin, chip_max = ChipMax, one_cost = OneCost0, ten_cost = TenCost0, list = BaseList} ->
            Discount = fuwen_map_discount:get_discount(),
            OneCost = max(0, round(OneCost0*Discount/100)),
            TenCost = max(0, round(TenCost0*Discount/100)),
            Now = util:unixtime(),
            NewFuwenBagId = max(1, min(FuwenBagId, 10)),
            RewardList0 =
                case lists:keyfind(NewFuwenBagId, 1, BaseList) of
                    false -> [];
                    {_BaseBagId, _BaseP, _BaseLuckMin, _BaseLuckMax, BaseSubList} ->
                        BaseSubList
                end,
            RewardList = lists:map(fun({GId, GNum, Power, _Is}) -> {{GId, GNum}, Power} end, RewardList0),
            if
                LastFreeTime + CdTime < Now ->
                    Chips = util:rand(ChipMin, ChipMax),
                    {GoodsId, GoodsNum} = util:list_rand_ratio(RewardList),
                    GiveGoodsList = goods:make_give_goods_list(622, [{GoodsId, GoodsNum}]),
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                    {NewFuwenBagId, NewLuckValue} = get_bag_info(LuckValueOld + 1, BaseList, FuwenBagId, GoodsId),
                    NewStFuwenMap =
                        StFuwenMap#st_fuwen_map{
                            fuwen_bag_id = NewFuwenBagId,
                            luck_value = NewLuckValue,
                            last_free_time = Now
                        },
                    lib_dict:put(?PROC_STATUS_FUWEN_MAP, NewStFuwenMap),
                    activity_load:dbup_fuwen_map(NewStFuwenMap),
                    fuwen:goods_add_chip(Chips),
                    act_hi_fan_tian:trigger_finish_api(Player, 14, 1),
                    {1, Chips, NewPlayer, [[GoodsId, GoodsNum]]};
                true ->
                    case check_go_map(Player, 1, OneCost, TenCost) of
                        false ->
                            {5, 0, Player, []}; %% 元宝不足
                        true ->
                            {GoodsId, GoodsNum} = util:list_rand_ratio(RewardList),
                            Chips = util:rand(ChipMin, ChipMax),
                            NPlayer = money:add_no_bind_gold(Player, - OneCost, 621, GoodsId, 1),
                            GiveGoodsList = goods:make_give_goods_list(622, [{GoodsId, 1, ?GOODS_LOCATION_FUWEN, ?BIND, []}]),
                            {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList),
                            {NewFuwenBagId, NewLuckValue} = get_bag_info(LuckValueOld + 1, BaseList, FuwenBagId, GoodsId),
                            NewStFuwenMap =
                                StFuwenMap#st_fuwen_map{
                                    fuwen_bag_id = NewFuwenBagId,
                                    luck_value = NewLuckValue
                                },
                            lib_dict:put(?PROC_STATUS_FUWEN_MAP, NewStFuwenMap),
                            activity_load:dbup_fuwen_map(NewStFuwenMap),
                            fuwen:goods_add_chip(Chips),
                            act_hi_fan_tian:trigger_finish_api(Player, 14, 1),
                            {1, Chips, NewPlayer, [[GoodsId, GoodsNum]]}
                    end
            end
    end;

go_map(Player, 10) ->
    case get_act() of
        [] ->
            {0, 0, Player, []};
        #base_fuwen_map{chip_min = ChipMin, chip_max = ChipMax, one_cost = OneCost0, ten_cost = TenCost0, list = BaseList} ->
            Discount = fuwen_map_discount:get_discount(),
            OneCost = max(0, round(OneCost0*Discount/100)),
            TenCost = max(0, round(TenCost0*Discount/100)),
            case check_go_map(Player, 10, OneCost, TenCost) of
                false ->
                    {5, 0, Player, []}; %% 元宝不足
                true ->
                    StFuwenMap = lib_dict:get(?PROC_STATUS_FUWEN_MAP),
                    #st_fuwen_map{
                        luck_value = LuckValue,
                        fuwen_bag_id = FuwenBagId
                    } = StFuwenMap,
                    F = fun(_N, {AccChips, AccGiveGoodsList, AccFuwenBagId, AccLuckValue}) ->
                        NewFuwenBagId99 = max(1, min(FuwenBagId, 10)),
                        RewardList0 =
                            case lists:keyfind(NewFuwenBagId99, 1, BaseList) of
                                false -> [];
                                {_BaseBagId, _BaseP, _BaseLuckMin, _BaseLuckMax, BaseSubList} ->
                                    BaseSubList
                            end,
                        RewardList = lists:map(fun({GId, GNum, Power, _Is}) -> {{GId, GNum}, Power} end, RewardList0),
                        Chips = util:rand(ChipMin, ChipMax),
                        {GoodsId, GoodsNum} = util:list_rand_ratio(RewardList),
                        GiveGoodsList = [#give_goods{goods_id = GoodsId, num = GoodsNum, from = 622}],
                        {NewFuwenBagId, NewLuckValue} = get_bag_info(AccLuckValue + 1, BaseList, AccFuwenBagId, GoodsId),
                        {AccChips + Chips, AccGiveGoodsList ++ GiveGoodsList, NewFuwenBagId, NewLuckValue}
                    end,
                    {SumChips, SumGiveGoodsList, SumFuwenBagId, SumLuckValue} = lists:foldl(F, {0, [], max(1, min(FuwenBagId,10)), LuckValue}, lists:seq(1, 10)),
                    NewStFuwenMap =
                        StFuwenMap#st_fuwen_map{
                            luck_value = SumLuckValue,
                            fuwen_bag_id = SumFuwenBagId
                        },
                    lib_dict:put(?PROC_STATUS_FUWEN_MAP, NewStFuwenMap),
                    activity_load:dbup_fuwen_map(NewStFuwenMap),
                    NPlayer = money:add_no_bind_gold(Player, - TenCost, 621, 0, 0),
                    {ok, NewPlayer} = goods:give_goods(NPlayer, SumGiveGoodsList),
                    fuwen:goods_add_chip(SumChips),
                    act_hi_fan_tian:trigger_finish_api(Player, 14, 10),
                    F99 = fun(#give_goods{goods_id = GoodsId, num = GoodsNum}) -> [GoodsId, GoodsNum] end,
                    ListData = lists:map(F99, SumGiveGoodsList),
                    {1, SumChips, NewPlayer, ListData}
            end
    end.

check_go_map(Player, GoNum, OneCost, TenCost) ->
    Cost = ?IF_ELSE(GoNum == 1, OneCost, TenCost),
    money:is_enough(Player, Cost, gold).

get_state(_Player) ->
    case get_act() of
        [] ->
            -1;
        #base_fuwen_map{cd_time = CdTime} = Base -> %% 暂时这么写
            StFuwenMap = lib_dict:get(?PROC_STATUS_FUWEN_MAP),
            #st_fuwen_map{
                last_free_time = LastFreeTime
            } = StFuwenMap,
            Now = util:unixtime(),
            Args = activity:get_base_state(Base#base_fuwen_map.act_info),
            case fuwen_map_discount:get_state(_Player) of
                -1 ->
                    ?IF_ELSE(LastFreeTime + CdTime < Now, {1, Args}, {0, Args});
                {_State, Args2} ->
                    ?IF_ELSE(LastFreeTime + CdTime < Now, {1, Args++Args2}, {0, Args++Args2})
            end
    end.

get_act() ->
    case activity:get_work_list(data_fuwen_map) of
        [] -> [];
        [Base | _] -> Base
    end.