%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% %% 进阶宝箱
%%% @end
%%% Created : 07. 三月 2017 16:22
%%%-------------------------------------------------------------------
-module(uplv_box).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    init_ets/0,
    init/1,
    midnight_refresh/1,
    get_act/0,
    logout/1,

    get_state/1,
    get_act_info/1,
    recv/2,
    reset_box/1,
    get_log/1
]).

init_ets() ->
    ets:new(?ETS_UPLV_BOX_LOG, [{keypos, #ets_uplv_box_log.pkey} | ?ETS_OPTIONS]),
    ok.

init(#player{key = Pkey} = Player) ->
    StUplvBox =
        case player_util:is_new_role(Player) of
            true -> #st_uplv_box{pkey = Pkey};
            false -> activity_load:dbget_uplv_box(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_UPLV_BOX, StUplvBox),
    update_uplv_box(),
    Player.

update_uplv_box() ->
    StUplvBox = lib_dict:get(?PROC_STATUS_UPLV_BOX),
    #st_uplv_box{
        pkey = Pkey,
        open_day = OpenDay
    } = StUplvBox,
    SysOpenDay = config:get_open_days(),
    if
        SysOpenDay =/= OpenDay ->
            NewStUplvBox = #st_uplv_box{pkey = Pkey, open_day = SysOpenDay};
        true ->
            NewStUplvBox = StUplvBox
    end,
    lib_dict:put(?PROC_STATUS_UPLV_BOX, NewStUplvBox).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_uplv_box().

logout(Player) ->
    update_online_time(Player),
    Now = util:unixtime(),
    %% 上线30秒钟时间不给予保存
    case Now - Player#player.last_login_time > ?UPLV_BOX_ONLINE_TIME of
        false ->
            ok;
        true ->
            case get_act() of
                false ->
                    ok;
                _ ->
                    StUplvBox = lib_dict:get(?PROC_STATUS_UPLV_BOX),
                    activity_load:dbup_uplv_box(StUplvBox)
            end
    end.

get_state(Player) ->
    update_online_time(Player),
    StUplvBox = lib_dict:get(?PROC_STATUS_UPLV_BOX),
    #st_uplv_box{
        online_time = OnlineTime,
        use_free_num = UseFreeNum
    } = StUplvBox,
    case get_act() of
        false ->
            -1;
        Base ->
            Args = activity:get_base_state(Base#base_uplv_box.act_info),
            %% 每日上限3次
            SumFreeTime = min(?UPLV_BOX_MAX_FREE_TIME, OnlineTime div ?UPLV_BOX_CD_TIME),
            ?IF_ELSE(SumFreeTime > UseFreeNum, {1, Args}, {0, Args})
    end.

get_act_info(Player) ->
    update_online_time(Player),
    case get_act() of
        false ->
            {0, 0, 0, 0, 0, [], []};
        RewardType ->
            BaseGoodsList = get_show_goods_list(RewardType),
            StUplvBox = lib_dict:get(?PROC_STATUS_UPLV_BOX),
            #st_uplv_box{
                online_time = OnlineTime
                , recv_list = RecvList
                , use_free_num = UseFreeNum
            } = StUplvBox,
            RemainResetTime = ?ONE_DAY_SECONDS - (util:unixtime() - util:unixdate()),
            RemainFreeNum = max(0, min(?UPLV_BOX_MAX_FREE_TIME, OnlineTime div ?UPLV_BOX_CD_TIME) - UseFreeNum),
            RemainTime = ?UPLV_BOX_CD_TIME - OnlineTime rem ?UPLV_BOX_CD_TIME,
            ResetCostGold = ?UPLV_BOX_RESET_COST,
            OpenCostGold = ?UPLV_BOX_OPEN_COST,
            Ids = data_uplv_box_reward:get_ids_by_reward_type(RewardType),
            F = fun(Id) ->
                #base_uplv_box_reward{type = Type, order_id = OrderId} = data_uplv_box_reward:get(Id),
                IsOpen = ?IF_ELSE(lists:member(OrderId, RecvList), 1, 0),
                [OrderId, Type, IsOpen]
                end,
            List = lists:map(F, Ids),
            ClientBaseGoodsList = lists:map(fun({GId, GNum}) -> [GId, GNum] end, BaseGoodsList),
            {RemainResetTime, RemainTime, RemainFreeNum, ResetCostGold, OpenCostGold, ClientBaseGoodsList, List}
    end.

%% 开启宝箱
recv(Player, OrderId) ->
    update_online_time(Player),
    StUplvBox = lib_dict:get(?PROC_STATUS_UPLV_BOX),
    #st_uplv_box{
        recv_list = RecvList,
        use_free_num = UseFreeNum
    } = StUplvBox,
    case get_act() of
        false ->
            {0, Player};
        RewardType ->
            case check_recv(Player, OrderId, RewardType) of
                {fail, Res} ->
                    {Res, Player};
                {true, use_free_num} -> %% 使用免费次数
                    NewStUplvBox =
                        StUplvBox#st_uplv_box{
                            recv_list = [OrderId | RecvList],
                            use_free_num = UseFreeNum + 1,
                            op_time = util:unixtime()
                        },
                    #base_uplv_box_reward{goods_id = GoodsType, range_num = [Min, Max], type = Type} = data_uplv_box_reward:get_by_order_id_reward_type(OrderId, RewardType),
                    GoodsNum = util:rand(Min, Max),
                    GiveGoodsList = goods:make_give_goods_list(614, [{GoodsType, GoodsNum}]),
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                    lib_dict:put(?PROC_STATUS_UPLV_BOX, NewStUplvBox),
                    activity_load:dbup_uplv_box(NewStUplvBox),
                    act_hi_fan_tian:trigger_finish_api(Player, 15, 1),
                    log(Player, GoodsType, GoodsNum, Type),
                    activity:get_notice(NewPlayer, [35], true),
                    {1, NewPlayer};
                true -> %% 扣除元宝
                    NewStUplvBox =
                        StUplvBox#st_uplv_box{
                            recv_list = [OrderId | RecvList],
                            op_time = util:unixtime()
                        },
                    #base_uplv_box_reward{goods_id = GoodsType, range_num = [Min, Max], type = Type} = data_uplv_box_reward:get_by_order_id_reward_type(OrderId, RewardType),
                    GoodsNum = util:rand(Min, Max),
                    NPlayer = money:add_no_bind_gold(Player, - ?UPLV_BOX_OPEN_COST, 613, GoodsType, GoodsNum),
                    GiveGoodsList = goods:make_give_goods_list(614, [{GoodsType, GoodsNum}]),
                    {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList),
                    lib_dict:put(?PROC_STATUS_UPLV_BOX, NewStUplvBox),
                    activity_load:dbup_uplv_box(NewStUplvBox),
                    log(NewPlayer, GoodsType, GoodsNum, Type),
                    act_hi_fan_tian:trigger_finish_api(Player, 15, 1),
                    activity:get_notice(NewPlayer, [35], true),
                    {1, NewPlayer}
            end
    end.

log(Player, GoodsType, GoodsNum, Type) ->
    case ets:lookup(?ETS_UPLV_BOX_LOG, Player#player.key) of
        [] ->
            Ets = #ets_uplv_box_log{pkey = Player#player.key};
        [Ets0] ->
            Ets = Ets0
    end,
    NewEts = Ets#ets_uplv_box_log{log_list = [[util:unixtime(), GoodsType, GoodsNum, Type] | Ets#ets_uplv_box_log.log_list]},
    ets:insert(?ETS_UPLV_BOX_LOG, NewEts).

check_recv(_Player, OrderId, _RewardType) when OrderId > 16 ->
    {fail, 13};

check_recv(Player, OrderId, RewardType) ->
    StUplvBox = lib_dict:get(?PROC_STATUS_UPLV_BOX),
    #st_uplv_box{
        recv_list = RecvList,
        online_time = OnlineTime,
        use_free_num = UseFreeNum
    } = StUplvBox,
    case data_uplv_box_reward:get_by_order_id_reward_type(OrderId, RewardType) of
        [] ->
            {fail, 0}; %% 客户端发的数据有bug
        _ ->
            case lists:member(OrderId, RecvList) of
                true ->
                    {fail, 7}; %% 宝箱已经开启过了
                false ->
                    RemainFreeNum = max(0, min(?UPLV_BOX_MAX_FREE_TIME, OnlineTime div ?UPLV_BOX_CD_TIME) - UseFreeNum),
                    if
                        RemainFreeNum > 0 ->
                            {true, use_free_num};
                        true ->
                            case money:is_enough(Player, ?UPLV_BOX_OPEN_COST, gold) of
                                false ->
                                    {fail, 5}; %% 元宝不足
                                true ->
                                    true
                            end
                    end
            end
    end.

reset_box(Player) ->
    update_online_time(Player),
    case get_act() of
        [] ->
            {0, Player};
        _ ->
            case money:is_enough(Player, ?UPLV_BOX_RESET_COST, gold) of
                false ->
                    {5, Player}; %% 元宝不足
                true ->
                    NewPlayer = money:add_no_bind_gold(Player, - ?UPLV_BOX_RESET_COST, 642, 0, 0),
                    StUplvBox = lib_dict:get(?PROC_STATUS_UPLV_BOX),
                    NewStUpLvBox = StUplvBox#st_uplv_box{recv_list = []},
                    lib_dict:put(?PROC_STATUS_UPLV_BOX, NewStUpLvBox),
                    activity_load:dbup_uplv_box(NewStUpLvBox),
                    {1, NewPlayer}
            end
    end.

get_log(Player) ->
    case ets:lookup(?ETS_UPLV_BOX_LOG, Player#player.key) of
        [] ->
            [];
        [Ets] ->
            LogList = Ets#ets_uplv_box_log.log_list,
            LogList
    end.

update_online_time(Player) ->
    case get_act() of
        false ->
            skip;
        _ ->
            Now = util:unixtime(),
            Flag = util:is_same_date(Now, Player#player.last_login_time),
            StUplvBox = lib_dict:get(?PROC_STATUS_UPLV_BOX),
            #st_uplv_box{
                online_time = OnlineTime,
                last_login_time = LastLoginTime
            } = StUplvBox,
            if
                Flag == true ->
                    NewOnlineTime = OnlineTime + (Now - LastLoginTime);
                true ->
                    NewOnlineTime = Now - Player#player.last_login_time
            end,
            NewStUpLvBox = StUplvBox#st_uplv_box{online_time = NewOnlineTime, last_login_time = Now},
            lib_dict:put(?PROC_STATUS_UPLV_BOX, NewStUpLvBox)
    end.

get_act() ->
    OpenDay = config:get_open_days(),
    get_act(OpenDay).
get_act(OpenDay) ->
    case ets:lookup(?ETS_ACT_OPEN_INFO, OpenDay) of
        [] -> false;
        [#ets_act_info{act_info = ActInfo}] ->
            case lists:keyfind(?ACT_UPLV_BOX, 1, ActInfo) of
                false -> false;
                {_Act, ActType} -> ActType
            end
    end.

get_show_goods_list(RewardType) ->
    Ids = data_uplv_box_reward:get_ids_by_reward_type(RewardType),
    #base_uplv_box_reward{show_goods_list = ShowGoodsList} = data_uplv_box_reward:get(hd(Ids)),
    ShowGoodsList.