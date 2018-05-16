%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 剑道寻宝
%%% @end
%%% Created : 08. 五月 2017 18:00
%%%-------------------------------------------------------------------
-module(jiandao_map).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
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
    StJiandaoMap =
        case player_util:is_new_role(Player) of
            true -> #st_jiandao_map{pkey = Pkey};
            false -> activity_load:dbget_jiandao_map(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_JIANDAO_MAP, StJiandaoMap),
    update_jiandao_map(),
    Player.

update_jiandao_map() ->
    StJiandaoMap = lib_dict:get(?PROC_STATUS_JIANDAO_MAP),
    #st_jiandao_map{
        pkey = Pkey,
        act_id = ActId,
        op_time = OpTime
    } = StJiandaoMap,
    case get_act() of
        [] ->
            NewStJiandaoMap = #st_jiandao_map{pkey = Pkey};
        #base_jiandao_map{act_id = BaseActId, list = BaseList} ->
            Now = util:unixtime(),
            if
                BaseActId =/= ActId ->
                    NStJiandaoMap = #st_jiandao_map{pkey = Pkey, act_id = BaseActId, op_time = Now};
                true ->
                    NStJiandaoMap = StJiandaoMap
            end,
            #st_jiandao_map{jiandao_bag_id = JiandaoBagId0} = NStJiandaoMap,
            if
                JiandaoBagId0 == 0 ->
                    %% {符文库ID,概率,幸运值下限,幸运值上限,[{道具ID,道具数量,权重,是否珍惜}]}
                    {BaseBagId, _BaseP, _BaseLuckMin, _BaseLuckMax, _BaseSubList} = hd(BaseList),
                    JiandaoBagId = BaseBagId;
                true ->
                    JiandaoBagId = JiandaoBagId0
            end,
            NewStJiandaoMap =
                case util:is_same_date(OpTime, Now) of
                    true ->
                        NStJiandaoMap#st_jiandao_map{jiandao_bag_id = JiandaoBagId};
                    false ->
                        NStJiandaoMap#st_jiandao_map{jiandao_bag_id = 0, luck_value = 0}
                end
    end,
    lib_dict:put(?PROC_STATUS_JIANDAO_MAP, NewStJiandaoMap).


%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_jiandao_map().

get_act_info(_Player) ->
    case get_act() of
        [] ->
            {0, 0, 0, 0, []};
        #base_jiandao_map{cd_time = CdTime, one_cost = OneCost, ten_cost = TenCost, list = BaseList} ->
            StJiandaoMap = lib_dict:get(?PROC_STATUS_JIANDAO_MAP),
            #st_jiandao_map{last_free_time = LastFreeTime} = StJiandaoMap,
            RemainTime = max(0, LastFreeTime + CdTime - util:unixtime()),
%%             ShowJiandaoList = lists:seq(?GOODS_SUBTYPE_JIANDAO_1, ?GOODS_SUBTYPE_JIANDAO_16),
            {_BaseBagId, _BaseP, _BaseLuckMin, _BaseLuckMax, BaseSubList} = hd(BaseList),
            F = fun({GId, GNum, _Power, Is}) -> [GId, GNum, Is] end,
            ShowJiandaoList = lists:map(F, BaseSubList),
            Discount = jiandao_map_discount:get_discount(),
            {RemainTime, OneCost, TenCost, Discount, ShowJiandaoList}
    end.

get_bag_info(LuckValue, BaseList, JiandaoBagId, GoodsId) ->
    #goods_type{color = Color} = data_goods:get(GoodsId),
    NewJiandaoBagId0 = max(1, min(JiandaoBagId, 10)),
    {_BaseBagId, P, LuckMin, LuckMax, _BaseSubList} = lists:keyfind(NewJiandaoBagId0, 1, BaseList),
    F = fun({BaseBagId0, _BaseP0, _BaseLuckMin0, _BaseLuckMax0, _BaseSubList0}) -> BaseBagId0 end,
%%     ?DEBUG("BaseList:~p", [BaseList]),
    JiandaoBagIds = lists:map(F, BaseList),
    {NewLuckValue, NewJiandaoBagId} =
        if
            Color == 5 -> %% 抽到红色
                {0, 0};
            LuckValue < LuckMin ->
                {LuckValue, JiandaoBagId};
            LuckValue >= LuckMax ->
                {0, JiandaoBagId + 1};
            true ->
                Rand = util:rand(1, 10000),
                ?IF_ELSE(Rand > P, {LuckValue, JiandaoBagId}, {0, JiandaoBagId + 1})
        end,
    MaxJiandaoBagId = lists:max(JiandaoBagIds),
    if
        NewJiandaoBagId == 0 ->
            {lists:min(JiandaoBagIds), NewLuckValue};
        NewJiandaoBagId > MaxJiandaoBagId -> %%
            {lists:min(JiandaoBagIds), 0};
        true ->
            {NewJiandaoBagId, NewLuckValue}
    end.

go_map(Player, 1) ->
    StJiandaoMap = lib_dict:get(?PROC_STATUS_JIANDAO_MAP),
    #st_jiandao_map{
        luck_value = LuckValueOld,
        jiandao_bag_id = JiandaoBagId,
        last_free_time = LastFreeTime
    } = StJiandaoMap,
    case get_act() of
        [] ->
            {0, 0, Player, []};
        #base_jiandao_map{list = BaseList, cd_time = CdTime, chip_min = ChipMin, chip_max = ChipMax, one_cost = OneCost0, ten_cost = TenCost0} ->
            Discount = jiandao_map_discount:get_discount(),
            OneCost = max(0, round(OneCost0*Discount/100)),
            TenCost = max(0, round(TenCost0*Discount/100)),
            Now = util:unixtime(),
            NewJiandaoBagId = max(1, min(JiandaoBagId, 10)),
            RewardList0 =
                case lists:keyfind(NewJiandaoBagId, 1, BaseList) of
                    false -> [];
                    {_BaseBagId, _BaseP, _BaseLuckMin, _BaseLuckMax, BaseSubList} ->
                        BaseSubList
                end,
            RewardList = lists:map(fun({GId, GNum, Power, _Is}) -> {{GId, GNum}, Power} end, RewardList0),
            if
                LastFreeTime + CdTime < Now ->
                    Chips = util:rand(ChipMin, ChipMax),
                    {GoodsId, GoodsNum} = util:list_rand_ratio(RewardList),
                    GiveGoodsList = goods:make_give_goods_list(779, [{GoodsId, GoodsNum}]),
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                    {NewJiandaoBagId, NewLuckValue} = get_bag_info(LuckValueOld + 1, BaseList, JiandaoBagId, GoodsId),
                    NewStJiandaoMap =
                        StJiandaoMap#st_jiandao_map{
                            jiandao_bag_id = NewJiandaoBagId,
                            luck_value = NewLuckValue,
                            last_free_time = Now
                        },
                    lib_dict:put(?PROC_STATUS_JIANDAO_MAP, NewStJiandaoMap),
                    activity_load:dbup_jiandao_map(NewStJiandaoMap),
                    {1, Chips, NewPlayer, [[GoodsId, GoodsNum]]};
                true ->
                    case check_go_map(Player, 1, OneCost, TenCost) of
                        false ->
                            {5, 0, Player, []}; %% 元宝不足
                        true ->
                            {GoodsId, GoodsNum} = util:list_rand_ratio(RewardList),
                            Chips = util:rand(ChipMin, ChipMax),
                            NPlayer = money:add_no_bind_gold(Player, - OneCost, 778, GoodsId, GoodsNum),
                            GiveGoodsList = goods:make_give_goods_list(779, [{GoodsId, 1}]),
                            {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList),
                            {NewJiandaoBagId, NewLuckValue} = get_bag_info(LuckValueOld + 1, BaseList, JiandaoBagId, GoodsId),
                            NewStJiandaoMap =
                                StJiandaoMap#st_jiandao_map{
                                    jiandao_bag_id = NewJiandaoBagId,
                                    luck_value = NewLuckValue
                                },
                            lib_dict:put(?PROC_STATUS_JIANDAO_MAP, NewStJiandaoMap),
                            activity_load:dbup_jiandao_map(NewStJiandaoMap),
                            {1, Chips, NewPlayer, [[GoodsId, GoodsNum]]}
                    end
            end
    end;

go_map(Player, 10) ->
    case get_act() of
        [] ->
            {0, 0, Player, []};
        #base_jiandao_map{list = BaseList, chip_min = ChipMin, chip_max = ChipMax, ten_cost = TenCost0, one_cost = OneCost0} ->
            Discount = jiandao_map_discount:get_discount(),
            OneCost = max(0, round(OneCost0*Discount/100)),
            TenCost = max(0, round(TenCost0*Discount/100)),
            case check_go_map(Player, 10, OneCost, TenCost) of
                false ->
                    {5, 0, Player, []}; %% 元宝不足
                true ->
                    StJiandaoMap = lib_dict:get(?PROC_STATUS_JIANDAO_MAP),
                    #st_jiandao_map{
                        luck_value = LuckValue,
                        jiandao_bag_id = JiandaoBagId
                    } = StJiandaoMap,
                    F = fun(_N, {AccChips, AccGiveGoodsList, AccJiandaoBagId, AccLuckValue}) ->
                        NewJiandaoBagId99 = max(1, min(JiandaoBagId, 10)),
                        RewardList0 =
                            case lists:keyfind(NewJiandaoBagId99, 1, BaseList) of
                                false -> [];
                                {_BaseBagId, _BaseP, _BaseLuckMin, _BaseLuckMax, BaseSubList} ->
                                    BaseSubList
                            end,
                        RewardList = lists:map(fun({GId, GNum, Power, _Is}) -> {{GId, GNum}, Power} end, RewardList0),
                        Chips = util:rand(ChipMin, ChipMax),
                        {GoodsId, GoodsNum} = util:list_rand_ratio(RewardList),
                        GiveGoodsList = [#give_goods{goods_id = GoodsId, num = GoodsNum, from = 779}],
                        {NewJiandaoBagId, NewLuckValue} = get_bag_info(AccLuckValue + 1, BaseList, AccJiandaoBagId, GoodsId),
%%                         ?DEBUG("NewJiandaoBagId:~p, NewLuckValue:~p~n", [NewJiandaoBagId, NewLuckValue]),
                        {AccChips + Chips, AccGiveGoodsList ++ GiveGoodsList, NewJiandaoBagId, NewLuckValue}
                    end,
                    {SumChips, SumGiveGoodsList, SumJiandaoBagId, SumLuckValue} = lists:foldl(F, {0, [], JiandaoBagId, LuckValue}, lists:seq(1, 10)),
                    NewStJiandaoMap =
                        StJiandaoMap#st_jiandao_map{
                            luck_value = SumLuckValue,
                            jiandao_bag_id = SumJiandaoBagId
                        },
                    lib_dict:put(?PROC_STATUS_JIANDAO_MAP, NewStJiandaoMap),
                    activity_load:dbup_jiandao_map(NewStJiandaoMap),
                    NPlayer = money:add_no_bind_gold(Player, - TenCost, 778, 0, 0),
                    {ok, NewPlayer} = goods:give_goods(NPlayer, SumGiveGoodsList),
%%                     ListData = total(SumGiveGoodsList),
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
        #base_jiandao_map{cd_time = CdTime} = Base -> %% 暂时这么写
            StJiandaoMap = lib_dict:get(?PROC_STATUS_JIANDAO_MAP),
            #st_jiandao_map{
                last_free_time = LastFreeTime
            } = StJiandaoMap,
            Now = util:unixtime(),
            Args = activity:get_base_state(Base#base_jiandao_map.act_info),
            case jiandao_map_discount:get_state(_Player) of
                -1 ->
                    ?IF_ELSE(LastFreeTime + CdTime < Now, {1, Args}, {0, Args});
                {_State, Args2} ->
                    ?IF_ELSE(LastFreeTime + CdTime < Now, {1, Args++Args2}, {0, Args++Args2})
            end
    end.

get_act() ->
    case activity:get_work_list(data_jiandao_map) of
        [] -> [];
        [Base | _] -> Base
    end.