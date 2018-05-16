%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 飞仙寻宝
%%% @end
%%% Created : 12. 十月 2017 20:44
%%%-------------------------------------------------------------------
-module(xian_map).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("xian.hrl").
-include("goods.hrl").

%% API
-export([
    init/1,
    midnight_refresh/1,
    get_act_info/1,
    go_map/3,
    map/2
]).

init(#player{key = Pkey} = Player) ->
    StXianMap =
        case player_util:is_new_role(Player) of
            true -> #st_xian_map{pkey = Pkey};
            false -> xian_load:dbget_xian_map(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_XIAN_MAP, StXianMap),
    update_xian_map(),
    Player.

update_xian_map() ->
    StXianMap = lib_dict:get(?PROC_STATUS_XIAN_MAP),
    #st_xian_map{
        pkey = Pkey,
        op_time = OpTime,
        time2 = Time2,
        num2 = Num2
    } = StXianMap,
    Now = util:unixtime(),
    Flag = util:is_same_date(OpTime, Now),
    if
        Flag == false ->
            NewStXianMap =
                StXianMap#st_xian_map{
                    pkey = Pkey,
                    num1 = 0,
                    num2 = 0,
                    op_time = Now
                };
        true ->
            NewStXianMap =
                StXianMap#st_xian_map{
                    num2 = ?IF_ELSE(Now-Time2 >= ?ONE_DAY_SECONDS, 0, Num2)
                }
    end,
    lib_dict:put(?PROC_STATUS_XIAN_MAP, NewStXianMap).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_xian_map().

get_act_info(_Player) ->
    update_xian_map(),
    StXianMap = lib_dict:get(?PROC_STATUS_XIAN_MAP),
    #st_xian_map{
        time1 = Time1,
        num1 = Num1,
        time2 = Time2
    } = StXianMap,
    BaseNum1 = data_feixian_map_free:get_free_num(?XIAN_MAP_TYPE1),
    BaseNum2 = data_feixian_map_free:get_free_num(?XIAN_MAP_TYPE2),
    Cost1_1 = data_feixian_map_price:get_price(?XIAN_MAP_TYPE1, ?XIAN_MAP_TYPE_GO1),
    Cost1_10 = data_feixian_map_price:get_price(?XIAN_MAP_TYPE1, ?XIAN_MAP_TYPE_GO10),
    Cost2_1 = data_feixian_map_price:get_price(?XIAN_MAP_TYPE2, ?XIAN_MAP_TYPE_GO1),
    Cost2_10 = data_feixian_map_price:get_price(?XIAN_MAP_TYPE2, ?XIAN_MAP_TYPE_GO10),
    BaseTime1 = data_feixian_map_free:get_free_time(?XIAN_MAP_TYPE1),
    BaseTime2 = data_feixian_map_free:get_free_time(?XIAN_MAP_TYPE2),
    Now = util:unixtime(),
    RemainNum1 = max(0, BaseNum1 - Num1),
    RemainTime2 = max(0, Time2 + BaseTime2 - Now),
    [[1, Cost1_1, Cost1_10, RemainNum1, BaseNum1, ?IF_ELSE(RemainNum1 == 0, 0, max(0, Time1 + BaseTime1 - Now))],
        [2, Cost2_1, Cost2_10, ?IF_ELSE(RemainTime2 == 0, 1, 0), BaseNum2, RemainTime2]].

%% 地仙寻宝
go_map(Player, Type, ClientNum) when Type == ?XIAN_MAP_TYPE1 andalso (ClientNum == ?XIAN_MAP_TYPE_GO1 orelse ClientNum == ?XIAN_MAP_TYPE_GO10) ->
    StXianMap = lib_dict:get(?PROC_STATUS_XIAN_MAP),
    #st_xian_map{
        time1 = Time1,
        num1 = Num1,
        time2 = Time2,
        num2 = Num2
    } = StXianMap,
    Time = ?IF_ELSE(Type == ?XIAN_MAP_TYPE1, Time1, Time2),
    Num = ?IF_ELSE(Type == ?XIAN_MAP_TYPE1, Num1, Num2),
    case ClientNum of
        ?XIAN_MAP_TYPE_GO1 ->
            BaseFreeNum = data_feixian_map_free:get_free_num(Type),
            Now = util:unixtime(),
            BaseFreeTime = data_feixian_map_free:get_free_time(Type),
            Cost = data_feixian_map_price:get_price(Type, ?XIAN_MAP_TYPE_GO1),
            RewardList = data_feixian_map_price:get_reward_list(Type, ?XIAN_MAP_TYPE_GO1),
            if
                Num < BaseFreeNum andalso Time + BaseFreeTime < Now ->
                    NewStXianMap =
                        if
                            Type == ?XIAN_MAP_TYPE1 ->
                                StXianMap#st_xian_map{time1 = Now, num1 = Num + ClientNum, op_time = Now};
                            true ->
                                StXianMap#st_xian_map{time2 = Now, num2 = Num + ClientNum, op_time = Now}
                        end,
                    lib_dict:put(?PROC_STATUS_XIAN_MAP, NewStXianMap),
                    xian_load:dbup_xian_map(NewStXianMap),
                    GoMapRewardList = map(Type, ?XIAN_MAP_TYPE_GO1),
                    GiveGoodsList = goods:make_give_goods_list(713, RewardList),
                    GiveGoodsList2 = goods:make_give_goods_list(712, GoMapRewardList),
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList ++ GiveGoodsList2),
                    ProRewardList = util:list_tuple_to_list(RewardList),
                    ProGoMapRewardList = util:list_tuple_to_list(GoMapRewardList),
                    xian_log:go_map([Player#player.key, Type, 0, RewardList, GoMapRewardList]),
                    {1, ProGoMapRewardList, ProRewardList, NewPlayer};
                true ->
                    case money:is_enough(Player, Cost, bgold) of
                        false ->
                            {6, [], [], Player}; %% 元宝不足
                        true ->
                            NPlayer = money:add_gold(Player, -Cost, 717, 0, 0),
                            GoMapRewardList = map(Type, ?XIAN_MAP_TYPE_GO1),
                            GiveGoodsList = goods:make_give_goods_list(713, RewardList),
                            GiveGoodsList2 = goods:make_give_goods_list(712, GoMapRewardList),
                            {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList ++ GiveGoodsList2),
                            ProRewardList = util:list_tuple_to_list(RewardList),
                            ProGoMapRewardList = util:list_tuple_to_list(GoMapRewardList),
                            xian_log:go_map([Player#player.key, Type, Cost, RewardList, GoMapRewardList]),
                            {1, ProGoMapRewardList, ProRewardList, NewPlayer}
                    end
            end;
        ?XIAN_MAP_TYPE_GO10 ->
            Cost = data_feixian_map_price:get_price(Type, ?XIAN_MAP_TYPE_GO10),
            RewardList = data_feixian_map_price:get_reward_list(Type, ?XIAN_MAP_TYPE_GO10),
            case money:is_enough(Player, Cost, bgold) of
                false ->
                    {6, [], [], Player}; %% 元宝不足
                true ->
                    NPlayer = money:add_gold(Player, -Cost, 717, 0, 0),
                    GoMapRewardList = map(Type, ?XIAN_MAP_TYPE_GO10),
                    GiveGoodsList = goods:make_give_goods_list(713, RewardList),
                    GiveGoodsList2 = goods:make_give_goods_list(712, GoMapRewardList),
                    {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList ++ GiveGoodsList2),
                    ProRewardList = util:list_tuple_to_list(RewardList),
                    ProGoMapRewardList = util:list_tuple_to_list(GoMapRewardList),
                    xian_log:go_map([Player#player.key, Type, Cost, RewardList, GoMapRewardList]),
                    {1, ProGoMapRewardList, ProRewardList, NewPlayer}
            end
    end;

%% 鸿钧寻宝
go_map(Player, Type, ClientNum) when Type == ?XIAN_MAP_TYPE2 andalso (ClientNum == ?XIAN_MAP_TYPE_GO1 orelse ClientNum == ?XIAN_MAP_TYPE_GO10) ->
    StXianMap = lib_dict:get(?PROC_STATUS_XIAN_MAP),
    #st_xian_map{
        time1 = Time1,
        num1 = Num1,
        time2 = Time2,
        num2 = Num2
    } = StXianMap,
    Time = ?IF_ELSE(Type == ?XIAN_MAP_TYPE1, Time1, Time2),
    Num = ?IF_ELSE(Type == ?XIAN_MAP_TYPE1, Num1, Num2),
    case ClientNum of
        ?XIAN_MAP_TYPE_GO1 ->
            BaseFreeNum = data_feixian_map_free:get_free_num(Type),
            Now = util:unixtime(),
            BaseFreeTime = data_feixian_map_free:get_free_time(Type),
            Cost = data_feixian_map_price:get_price(Type, ?XIAN_MAP_TYPE_GO1),
            RewardList = data_feixian_map_price:get_reward_list(Type, ?XIAN_MAP_TYPE_GO1),
            if
                Num < BaseFreeNum andalso Time + BaseFreeTime < Now ->
                    NewStXianMap =
                        if
                            Type == ?XIAN_MAP_TYPE1 ->
                                StXianMap#st_xian_map{time1 = Now, num1 = Num + ClientNum, op_time = Now};
                            true ->
                                StXianMap#st_xian_map{time2 = Now, num2 = Num + ClientNum, op_time = Now}
                        end,
                    lib_dict:put(?PROC_STATUS_XIAN_MAP, NewStXianMap),
                    xian_load:dbup_xian_map(NewStXianMap),
                    GoMapRewardList = map(Type, ?XIAN_MAP_TYPE_GO1),
                    GiveGoodsList = goods:make_give_goods_list(713, RewardList),
                    GiveGoodsList2 = goods:make_give_goods_list(712, GoMapRewardList),
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList ++ GiveGoodsList2),
                    ProRewardList = util:list_tuple_to_list(RewardList),
                    ProGoMapRewardList = util:list_tuple_to_list(GoMapRewardList),
                    xian_log:go_map([Player#player.key, Type, 0, RewardList, GoMapRewardList]),
                    {1, ProGoMapRewardList, ProRewardList, NewPlayer};
                true ->
                    case money:is_enough(Player, Cost, gold) of
                        false ->
                            {6, [], [], Player}; %% 元宝不足
                        true ->
                            NPlayer = money:add_no_bind_gold(Player, -Cost, 714, 0, 0),
                            GoMapRewardList = map(Type, ?XIAN_MAP_TYPE_GO1),
                            GiveGoodsList = goods:make_give_goods_list(713, RewardList),
                            GiveGoodsList2 = goods:make_give_goods_list(712, GoMapRewardList),
                            {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList ++ GiveGoodsList2),
                            ProRewardList = util:list_tuple_to_list(RewardList),
                            ProGoMapRewardList = util:list_tuple_to_list(GoMapRewardList),
                            xian_log:go_map([Player#player.key, Type, Cost, RewardList, GoMapRewardList]),
                            {1, ProGoMapRewardList, ProRewardList, NewPlayer}
                    end
            end;
        ?XIAN_MAP_TYPE_GO10 ->
            Cost = data_feixian_map_price:get_price(Type, ?XIAN_MAP_TYPE_GO10),
            RewardList = data_feixian_map_price:get_reward_list(Type, ?XIAN_MAP_TYPE_GO10),
            case money:is_enough(Player, Cost, gold) of
                false ->
                    {6, [], [], Player}; %% 元宝不足
                true ->
                    NPlayer = money:add_no_bind_gold(Player, -Cost, 714, 0, 0),
                    GoMapRewardList = map(Type, ?XIAN_MAP_TYPE_GO10),
                    GiveGoodsList = goods:make_give_goods_list(713, RewardList),
                    GiveGoodsList2 = goods:make_give_goods_list(712, GoMapRewardList),
                    {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList ++ GiveGoodsList2),
                    ProRewardList = util:list_tuple_to_list(RewardList),
                    ProGoMapRewardList = util:list_tuple_to_list(GoMapRewardList),
                    xian_log:go_map([Player#player.key, Type, Cost, RewardList, GoMapRewardList]),
                    {1, ProGoMapRewardList, ProRewardList, NewPlayer}
            end
    end;

go_map(_Player, _Type, _Num) ->
    {0, [], [], _Player}.

map(Type, ?XIAN_MAP_TYPE_GO1) ->
    RandList = data_feixian_map:get_by_type(Type),
    Id = util:list_rand_ratio(RandList),
    #base_xian_map{
        goods_id = GoodsId,
        goods_num = GoodsNum
    } = data_feixian_map:get(Id),
    [{GoodsId, GoodsNum}];

map(Type, ?XIAN_MAP_TYPE_GO10) ->
    RandList2 = data_feixian_map:get_by_type(Type + 2),
    Id2 = util:list_rand_ratio(RandList2),
    F = fun(_N) ->
        RandList1 = data_feixian_map:get_by_type(Type),
        Id = util:list_rand_ratio(RandList1),
        Id
    end,
    Ids = lists:map(F, lists:seq(1, ?XIAN_MAP_TYPE_GO10 - 1)),
    F99 = fun(Id) ->
        #base_xian_map{
            goods_id = GoodsId,
            goods_num = GoodsNum
        } = data_feixian_map:get(Id),
        {GoodsId, GoodsNum}
    end,
    lists:map(F99, [Id2 | Ids]);

map(_Type, _Num) ->
    [].