%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 六月 2017 11:03
%%%-------------------------------------------------------------------
-module(xj_map).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

-define(XJ_MAP_REPLACE_VALUE, data_version_different:get(4)).

%% API
-export([
    init/1,
    init_ets/0,
    midnight_refresh/1,
    get_act/0,
    get_state/1,

    get_act_info/1,
    reset/1,
    get_log/1,
    go_map/2
]).


init(#player{key = Pkey} = Player) ->
    StXjMap =
        case player_util:is_new_role(Player) of
            true -> #st_xj_map{pkey = Pkey};
            false -> activity_load:dbget_xj_map(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_XJ_MAP, StXjMap),
    update_xj_map(),
    Player.

init_ets() ->
    ets:new(?ETS_XJ_MAP, [{keypos, #ets_xj_map.pkey} | ?ETS_OPTIONS]).

update_xj_map() ->
    StXjMap = lib_dict:get(?PROC_STATUS_XJ_MAP),
    #st_xj_map{
        pkey = Pkey,
        act_id = ActId,
        op_time = OpTime
    } = StXjMap,
    case get_act() of
        [] ->
            NewStXjMap = #st_xj_map{pkey = Pkey};
        #base_xj_map{act_id = BaseActId} ->
            Now = util:unixtime(),
            Flag = util:is_same_date(OpTime, Now),
            if
                BaseActId =/= ActId ->
                    NewStXjMap = #st_xj_map{pkey = Pkey, act_id = BaseActId, op_time = Now};
                Flag == false ->
                    NewStXjMap = #st_xj_map{pkey = Pkey, act_id = BaseActId, op_time = Now};
                true ->
                    NewStXjMap = StXjMap
            end
    end,
    lib_dict:put(?PROC_STATUS_XJ_MAP, NewStXjMap).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_xj_map().

%% LeaveTime, Step, RemainFreeNum, OneGoCast, OneGoConsume, RemainResetNum, OneResetCast, List
get_act_info(_Player) ->
    case get_act() of
        [] ->
            {0, 0, 0, 0, 0, 0, 0, 0, [], []};
        #base_xj_map{
            act_type = ActType,
            open_info = OpenInfo,
            free_go_num = FreeGoNum,
            one_go_cast = OneGoCast,
            one_go_consume = OneGoConsume,
            reset_num = ResetNum,
            one_reset_cast = OneResetCast,
            reset_reward_list = ResetRewardList
        } ->
            LTime = activity:calc_act_leave_time(OpenInfo),
            LTime2 = act_double:get_xj_map_double_time(),
            StXjMap = lib_dict:get(?PROC_STATUS_XJ_MAP),
            #st_xj_map{
                step = Step,
                use_free_num = UseFreeNum,
                use_reset_num = UseResetNum
            } = StXjMap,
            RemainFreeNum = max(0, FreeGoNum - UseFreeNum),
            RemainResetNum = max(0, ResetNum - UseResetNum),
            Ids = data_xj_map_reward:get_ids_by_reward_type(ActType),
            F = fun(Id) ->
                case data_xj_map_reward:get(Id) of
                    [] ->
                        [];
                    #base_xj_map_reward{
                        order_id = OrderId,
                        goods_list = GoodsList
                    } ->
                        F2 = fun({GoodsId, GoodsNum, _Power}) -> [GoodsId, GoodsNum] end,
                        L = lists:map(F2, GoodsList),
                        [[OrderId, L]]
                end
            end,
            BaseList = lists:flatmap(F, Ids),
            BaseResetRewardList = lists:map(fun({GId, GNum}) -> [GId, GNum] end, ResetRewardList),
            {LTime, LTime2, Step, RemainFreeNum, OneGoCast, OneGoConsume, RemainResetNum, OneResetCast, BaseList, BaseResetRewardList}
    end.

%% 重置
reset(Player) ->
    case get_act() of
        [] ->
            {0, [], Player};
        #base_xj_map{one_reset_cast = OneRestCast, reset_reward_list = ResetRewardList, reset_num = BaseResetNum} ->
            IsEnough = money:is_enough(Player, OneRestCast, gold),
            StXjMap = lib_dict:get(?PROC_STATUS_XJ_MAP),
            #st_xj_map{
                use_reset_num = UseResetNum
            } = StXjMap,
            if
                UseResetNum >= BaseResetNum -> {19, [], Player}; %% 重置次数不足
                IsEnough == false ->
                    {5, [], Player};
                true ->
                    NPlayer = money:add_no_bind_gold(Player, -OneRestCast, 636, 0, 0),

                    NewStXjMap = StXjMap#st_xj_map{use_reset_num = UseResetNum + 1, step = 0, op_time = util:unixtime()},
                    activity_load:dbup_xj_map(NewStXjMap),
                    lib_dict:put(?PROC_STATUS_XJ_MAP, NewStXjMap),
                    GiveGoodsList = goods:make_give_goods_list(637, ResetRewardList),
                    {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList),
                    BaseResetRewardList = lists:map(fun({GId, GNum}) -> [GId, GNum] end, ResetRewardList),
                    {1, BaseResetRewardList, NewPlayer}
            end
    end.

get_log(Player) ->
    case ets:lookup(?ETS_XJ_MAP, Player#player.key) of
        [] ->
            [];
        [Ets] ->
            lists:sublist(Ets#ets_map_log.log_list, 15)
    end.

go_map(Player, Type) ->
    case get_act() of
        [] ->
            {0, 0, [], [], Player};
        #base_xj_map{
            saizi_list = SaiziList,
            act_type = ActType,
            one_go_cast = OneGoCast,
            one_go_consume = OneGoConsume
        } = BaseXjMap ->
            StXjMap = lib_dict:get(?PROC_STATUS_XJ_MAP),
            #st_xj_map{
                step = Step,
                use_free_num = UseFreeNum
            } = StXjMap,
            if
                Step == 24 ->
                    {8, 0, [], [], Player};
                true ->
                    RandStep0 = util:list_rand_ratio(SaiziList),
                    RandStep = min(RandStep0, 24 - Step),
                    Ids = data_xj_map_reward:get_ids_by_reward_type(ActType),
                    F = fun(BaseStep) ->
                        Id = lists:nth(BaseStep, Ids),
                        #base_xj_map_reward{goods_list = GoodsList, p = P} = data_xj_map_reward:get(Id),
                        LLL = lists:map(fun({GId, GNum, _Power}) -> {{GId, GNum}, _Power} end, GoodsList),
                        Rand = util:rand(1, 10000),
                        ?IF_ELSE(Rand < P, [{BaseStep, util:list_rand_ratio(LLL)}], [])
                    end,
                    RewardList0 = lists:flatmap(F, lists:seq(Step + 1, Step + RandStep)),
                    RewardList1 = lists:map(fun({_Step, GoodsInfo}) -> GoodsInfo end, RewardList0),
                    IsXjMapDouble = act_double:get_xj_map_mult(),
                    RewardList = lists:map(fun({GID, GNum}) -> {GID, GNum * IsXjMapDouble} end, RewardList1),
                    ProRewardList = lists:map(fun({ProStep, {ProGId, ProGNum}}) ->
                        [ProStep, ProGId, ProGNum * IsXjMapDouble] end, RewardList0),
                    case check_go_map(Player, StXjMap, BaseXjMap, Type) of
                        {false, Code} ->
                            {Code, 0, [], [], Player};
                        {true, free} -> %% 处理免费寻宝
                            NewStXjMap = StXjMap#st_xj_map{step = Step + RandStep, use_free_num = UseFreeNum + 1, op_time = util:unixtime()},
                            activity_load:dbup_xj_map(NewStXjMap),
                            lib_dict:put(?PROC_STATUS_XJ_MAP, NewStXjMap),
                            GiveGoodsList = goods:make_give_goods_list(638, RewardList),
                            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                            log(RewardList, Player#player.key),
                            LL = lists:map(fun({Gid, Gnum}) -> [Gid, Gnum] end, RewardList),
                            activity:get_notice(Player, [45], true),
                            act_hi_fan_tian:trigger_finish_api(NewPlayer, 17, 1),
                            {1, RandStep, LL, ProRewardList, NewPlayer};
                        {true, gold} -> %% 处理元宝寻宝
                            NPlayer = money:add_no_bind_gold(Player, -OneGoCast, 639, 0, 0),
                            NewStXjMap = StXjMap#st_xj_map{step = Step + RandStep, op_time = util:unixtime()},
                            activity_load:dbup_xj_map(NewStXjMap),
                            lib_dict:put(?PROC_STATUS_XJ_MAP, NewStXjMap),
                            GiveGoodsList = goods:make_give_goods_list(638, RewardList),
                            {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList),
                            log(RewardList, Player#player.key),
                            LL = lists:map(fun({Gid, Gnum}) -> [Gid, Gnum] end, RewardList),
                            act_hi_fan_tian:trigger_finish_api(NewPlayer, 17, 1),
                            activity:get_notice(Player, [45], true),
                            {1, RandStep, LL, ProRewardList, NewPlayer};
                        {true, xj_card} ->
                            case goods:subtract_good(Player, [{10501, max(1, OneGoConsume)}], 638) of
                                {ok, _} ->
                                    NewStXjMap = StXjMap#st_xj_map{step = Step + RandStep, op_time = util:unixtime()},
                                    activity_load:dbup_xj_map(NewStXjMap),
                                    lib_dict:put(?PROC_STATUS_XJ_MAP, NewStXjMap),
                                    GiveGoodsList = goods:make_give_goods_list(638, RewardList),
                                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                                    log(RewardList, Player#player.key),
                                    LL = lists:map(fun({Gid, Gnum}) -> [Gid, Gnum] end, RewardList),
                                    activity:get_notice(Player, [45], true),
                                    act_hi_fan_tian:trigger_finish_api(NewPlayer, 17, 1),
                                    {1, RandStep, LL, ProRewardList, NewPlayer};
                                _ ->
                                    {20, 0, [], [], Player}
                            end;
                        {true, xj_card, Consume, CostGold} ->
                            {ok, _} = goods:subtract_good(Player, [{10501, max(1, Consume)}], 638),
                            NPlayer = money:add_no_bind_gold(Player, -CostGold, 639, 0, 0),
                            NewStXjMap = StXjMap#st_xj_map{step = Step + RandStep, op_time = util:unixtime()},
                            activity_load:dbup_xj_map(NewStXjMap),
                            lib_dict:put(?PROC_STATUS_XJ_MAP, NewStXjMap),
                            GiveGoodsList = goods:make_give_goods_list(638, RewardList),
                            {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList),
                            log(RewardList, Player#player.key),
                            LL = lists:map(fun({Gid, Gnum}) -> [Gid, Gnum] end, RewardList),
                            activity:get_notice(Player, [45], true),
                            act_hi_fan_tian:trigger_finish_api(NewPlayer, 17, 1),
                            {1, RandStep, LL, ProRewardList, NewPlayer}
                    end
            end
    end.

log(RewardList, Pkey) ->
    F = fun({Gid, Gnum}) ->
        [Gid, Gnum]
    end,
    Log = lists:map(F, RewardList),
    NewEts =
        case ets:lookup(?ETS_XJ_MAP, Pkey) of
            [] ->
                #ets_map_log{pkey = Pkey, log_list = Log};
            [Ets] ->
                Ets#ets_map_log{log_list = Log ++ Ets#ets_map_log.log_list}
        end,
    ets:insert(?ETS_XJ_MAP, NewEts),
    ok.

check_go_map(_Player, StXjMap, BaseXjMap, 1) ->
    #st_xj_map{use_free_num = UseFreeNum} = StXjMap,
    #base_xj_map{free_go_num = FreeGoNum} = BaseXjMap,
    if
        FreeGoNum - UseFreeNum > 0 -> {true, free}; %% 免费次数足够
        true -> {false, 19}
    end;

check_go_map(Player, _StXjMap, BaseXjMap, 3) ->
    #base_xj_map{one_go_cast = OneGoCast} = BaseXjMap,
    IsEnough = money:is_enough(Player, OneGoCast, gold),
    if
        IsEnough == true -> {true, gold}; %% 元宝消耗足够
        true -> {false, 5}
    end;

check_go_map(Player, _StXjMap, BaseXjMap, 2) ->
    GoodsCount = goods_util:get_goods_count(10501),
    if
        GoodsCount >= BaseXjMap#base_xj_map.one_go_consume -> {true, xj_card};
        GoodsCount > 0 ->
            Cost = max(0, BaseXjMap#base_xj_map.one_go_consume - GoodsCount),
            IsEnough = money:is_enough(Player, Cost * ?XJ_MAP_REPLACE_VALUE, gold),
            if
                IsEnough == true -> {true, xj_card, GoodsCount, Cost * ?XJ_MAP_REPLACE_VALUE};
                true -> {false, 5}
            end;
        true -> {false, 20}
    end.

get_act() ->
    case activity:get_work_list(data_xj_map) of
        [] -> [];
        [Base | _] -> Base
    end.

get_state(_Player) ->
    case get_act() of
        [] ->
            -1;
        #base_xj_map{act_info = ActInfo} = BaseXjMap ->
            IsDouble = act_double:get_xj_map_mult(),
            StXjMap = lib_dict:get(?PROC_STATUS_XJ_MAP),
            Args = activity:get_base_state(ActInfo),
            if
                IsDouble == 1 ->
                    Code1 =
                        case check_go_map(_Player, StXjMap, BaseXjMap, 1) of
                            {true, _} -> 1;
                            _ -> 0
                        end,
                    Code2 =
                        case check_go_map(_Player, StXjMap, BaseXjMap, 2) of
                            {true, _} -> 1;
                            _ -> 0
                        end,
                    {max(Code1, Code2), Args};
                true ->
                    Code1 =
                        case check_go_map(_Player, StXjMap, BaseXjMap, 1) of
                            {true, _} -> 3;
                            _ -> 2
                        end,
                    Code2 =
                        case check_go_map(_Player, StXjMap, BaseXjMap, 2) of
                            {true, _} -> 3;
                            _ -> 2
                        end,
                    {max(Code1, Code2), Args}
            end
    end.