%%%%%-------------------------------------------------------------------
%%%%% @author Administrator
%%%%% @copyright (C) 2017, <COMPANY>
%%%%% @doc
%%%%%        神秘神树
%%%%% @end
%%%%% Created : 19. 十月 2017 10:49
%%%%%-------------------------------------------------------------------
-module(act_mystery_tree).
-author("lzx").
-include("server.hrl").
-include("common.hrl").
-include("activity.hrl").
-include("goods.hrl").
-include("daily.hrl").

%%
%%%% API
-export([
    get_info/1,
    draw/3,
    exchange/2,
    get_exchange_info/0,
    buy_goods/2,
    get_notice_state/1
]).

-define(COST_GOODS_ID, 30081).
-define(DRAW_COUNT, 10).
-define(ACT_PLAYER_MYSTERY_TREE(Pkey, ActId), {act_player_mystery_tree, Pkey, ActId}).
-define(ACT_MYSTERY_TREE_LOG(ActId), {act_mystery_tree_log, ActId}).


get_info(Player) ->
    case get_act() of
        [] -> {0, 0, 0, 0, 0, 0, 0, [], [], [], [], 0, 0};
        #base_act_mystery_tree{act_id = ActId, free_list = FreeList} = Base ->
            St = get_player_info(Player),
            {Index, FreeEndTime} = daily:get_count(?DAILY_ACT_MYSTERY_TREE_FREE, {1, 0}),
            IsFree = (Index == 1 andalso FreeEndTime == 0),
            NowTime = util:unixtime(),
            IsFree2 = (NowTime >= FreeEndTime andalso FreeEndTime /= 0),
            {FreeState, LeftTime} =
                case IsFree orelse IsFree2 of %% 本次免费的
                    true ->
                        {1, 0};
                    false ->
                        case Index > length(FreeList) of
                            true ->
                                {2, 0};
                            _ ->
                                {0, max(FreeEndTime - NowTime, 0)}
                        end
                end,
            RewardList = Base#base_act_mystery_tree.reward_list,
            RewardList0 = hd(RewardList),
            RewardList1 = [[Id, GoodsId, GoodsNum] || {Id, GoodsId, GoodsNum, _} <- RewardList0#base_act_mystery_tree_help.reward_list],
            ShopState = get_exchang_state(Player),
            ?PRINT("FreeState =========, LeftTime ============ ~w, ~w , Index ===== ~w, FreeEndTime :~w", [FreeState, LeftTime, Index, FreeEndTime]),
            SpGoods = lists:foldl(fun(GId, AccGoods) ->
                case lists:keyfind(GId, 1, RewardList0#base_act_mystery_tree_help.reward_list) of
                    {_ID, GoodsId2, GoodsNum2, _} ->
                        [[GoodsId2, GoodsNum2] | AccGoods];
                    _ ->
                        AccGoods
                end
                                  end, [], RewardList0#base_act_mystery_tree_help.sp_list),

            {get_leave_time(),
                Base#base_act_mystery_tree.goods_cost,
                St#st_act_mystery_tree.score,
                ShopState,
                ?COST_GOODS_ID,
                1,
                ?DRAW_COUNT,
                get_log(ActId),
                St#st_act_mystery_tree.log_list,
                RewardList1,
                lists:reverse(SpGoods),
                FreeState,
                LeftTime
            }
    end.


get_log(ActId) ->
    case ?GLOBAL_DATA_RAM:get(?ACT_MYSTERY_TREE_LOG(ActId), false) of
        false -> [];
        List -> List
    end.



get_act() ->
    case activity:get_work_list(data_act_mystery_tree) of
        [Base | _] -> Base;
        _ ->
            []
    end.


get_leave_time() ->
    LeaveTime = activity:get_leave_time(data_act_mystery_tree),
    ?IF_ELSE(LeaveTime < 0, 0, LeaveTime).


get_player_info(#player{key = Pkey}) ->
    #base_act_mystery_tree{act_id = ActId} = get_act(),
    case ?GLOBAL_DATA_RAM:get(?ACT_PLAYER_MYSTERY_TREE(Pkey, ActId), false) of
        false ->
            PlayerInfo = activity_load:dbget_act_mystery_tree(Pkey, ActId),
            ?GLOBAL_DATA_RAM:set(?ACT_PLAYER_MYSTERY_TREE(Pkey, ActId), PlayerInfo),
            PlayerInfo;
        PlayerInfo -> PlayerInfo
    end.


set_player_info(Pkey, #st_act_mystery_tree{act_id = ActId} = LuckySt) ->
    ?GLOBAL_DATA_RAM:set(?ACT_PLAYER_MYSTERY_TREE(Pkey, ActId), LuckySt),
    activity_load:dbup_act_mystery_tree(LuckySt).


draw(Player, Type, IsAuto) ->
    case Type of
        1 -> draw_one(Player, IsAuto);
        2 -> draw_ten(Player, IsAuto);
        _ ->
            ?ERR("err type :~p", [Type]),
            {0, Player, []}
    end.


draw_one(Player, IsAuto) ->
    GoodsCount = goods_util:get_goods_count(?COST_GOODS_ID),
    case get_act() of
        [] -> {0, Player, []};
        #base_act_mystery_tree{free_list = FreeList} = Base ->
            {Index, FreeEndTime} = daily:get_count(?DAILY_ACT_MYSTERY_TREE_FREE, {1, 0}),
            IsFree = (Index == 1 andalso FreeEndTime == 0),
            NowTime = util:unixtime(),
            IsFree2 = (NowTime >= FreeEndTime andalso FreeEndTime /= 0),
            case IsFree orelse IsFree2 of %% 本次免费的
                true ->
                    NewIndex = Index + 1,
                    {NewIndex2, NextFreeTime} =
                        case NewIndex > length(FreeList) of %% 下次刷新是第二天凌晨了
                            true ->
                                NextTime = util:unixdate() + ?ONE_DAY_SECONDS,
                                {NewIndex, NextTime};
                            false ->
                                NextTime = lists:nth(NewIndex, FreeList),
                                {NewIndex, NowTime + NextTime}
                        end,
                    daily:set_count(?DAILY_ACT_MYSTERY_TREE_FREE, {NewIndex2, NextFreeTime}),
                    do_draw_one(Base, Player, -1);
                false ->
                    IsEnough = money:is_enough(Player, Base#base_act_mystery_tree.goods_cost, gold),
                    if
                        GoodsCount =< 0 andalso IsAuto == 0 -> {18, Player, []};
                        GoodsCount =< 0 andalso IsAuto == 1 andalso not IsEnough -> {5, Player, []};
                        true ->
                            if
                                GoodsCount > 0 ->
                                    goods:subtract_good(Player, [{?COST_GOODS_ID, 1}], 570),
                                    LogCost = 0,
                                    NPlayer = Player;
                                true ->
                                    LogCost = Base#base_act_mystery_tree.goods_cost,
                                    NPlayer = money:add_no_bind_gold(Player, -Base#base_act_mystery_tree.goods_cost, 570, 0, 0)
                            end,
                            do_draw_one(Base, NPlayer, LogCost)
                    end

            end
    end.


do_draw_one(Base, Player, LogCost) ->
    RewardList0 = Base#base_act_mystery_tree.reward_list,
    St = get_player_info(Player),
    {Count, GoodsId, GoodsNum} = draw_one_help(Player, St#st_act_mystery_tree.count, RewardList0),
    NewLog = [[Player#player.nickname, GoodsId, GoodsNum]] ++ St#st_act_mystery_tree.log_list,
    NewSt = St#st_act_mystery_tree{count = Count, score = St#st_act_mystery_tree.score + 1, log_list = lists:sublist(NewLog, 20)},
    set_player_info(Player#player.key, NewSt),
    log_act_mystery_tree(Player#player.key, Player#player.nickname, Player#player.lv, LogCost, [{GoodsId, GoodsNum}]),
    GoodsType = data_goods:get(GoodsId),
    if
        GoodsType#goods_type.color >= 3 ->
            insert(Base#base_act_mystery_tree.act_id, Player#player.nickname, [{GoodsId, GoodsNum}]);
        true -> skip
    end,
    activity:get_notice(Player, [167], true),
    {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(570, [{GoodsId, GoodsNum}])),
    {1, NewPlayer, [[GoodsId, GoodsNum]]}.



draw_one_help(Player, Count, RewardList0) ->
    F = fun(BaseHelp, List) ->
        if
            Count >= BaseHelp#base_act_mystery_tree_help.up andalso Count =< BaseHelp#base_act_mystery_tree_help.down ->
                [{BaseHelp#base_act_mystery_tree_help.reward_list, BaseHelp#base_act_mystery_tree_help.sp_list}];
            true ->
                List
        end
        end,
    {RewardList, SpList} = hd(lists:foldl(F, [], RewardList0)),
    RatioList = [{{Id0, GoodsId0, GoodsNum0}, Ratio} || {Id0, GoodsId0, GoodsNum0, Ratio} <- RewardList],
    {Id, GoodsId, GoodsNum} = util:list_rand_ratio(RatioList),
    NewCount =
        case lists:member(Id, SpList) of
            false -> Count + 1;
            true ->
                Content = io_lib:format(t_tv:get(274), [t_tv:pn(Player), t_tv:gn(GoodsId)]),
                notice:add_sys_notice(Content, 274),
                0
        end,
    {NewCount, GoodsId, GoodsNum}.

draw_ten(Player, IsAuto) ->
    GoodsCount = goods_util:get_goods_count(?COST_GOODS_ID),
    case get_act() of
        [] -> {0, Player, []};
        Base ->
            IsEnough = money:is_enough(Player, (Base#base_act_mystery_tree.goods_cost * max(0, (10 - GoodsCount))), gold),
            if
                GoodsCount < 10 andalso IsAuto == 0 -> {18, Player, []};
                GoodsCount < 10 andalso IsAuto == 1 andalso not IsEnough -> {5, Player, []};
                true ->
                    if
                        GoodsCount >= 10 ->
                            goods:subtract_good(Player, [{?COST_GOODS_ID, 10}], 570),
                            LogCost = 0,
                            NPlayer = Player;
                        true ->
                            goods:subtract_good(Player, [{?COST_GOODS_ID, GoodsCount}], 570),
                            LogCost = Base#base_act_mystery_tree.goods_cost * max(0, (10 - GoodsCount)),
                            NPlayer = money:add_no_bind_gold(Player, -(Base#base_act_mystery_tree.goods_cost * max(0, (10 - GoodsCount))), 570, 0, 0)
                    end,
                    goods:subtract_good(Player, [{?COST_GOODS_ID, 10}], 570),
                    RewardList0 = Base#base_act_mystery_tree.reward_list,
                    St = get_player_info(Player),
                    F = fun(_, {Count, List}) ->
                        {Count0, GoodsId, GoodsNum} = draw_one_help(Player, Count, RewardList0),
                        GoodsType = data_goods:get(GoodsId),
                        if GoodsType#goods_type.color >= 3 ->
                            insert(Base#base_act_mystery_tree.act_id, Player#player.nickname, [{GoodsId, GoodsNum}]);
                            true -> skip
                        end,
                        {Count0, [{GoodsId, GoodsNum} | List]}
                        end,
                    {NewCount, GoodsList} = lists:foldl(F, {St#st_act_mystery_tree.count, []}, lists:seq(1, 10)),
                    NewLog = [[Player#player.nickname, GoodsId, GoodsNum] || {GoodsId, GoodsNum} <- GoodsList] ++ St#st_act_mystery_tree.log_list,
                    NewSt = St#st_act_mystery_tree{count = NewCount, score = St#st_act_mystery_tree.score + 10, log_list = lists:sublist(NewLog, 20)},
                    set_player_info(Player#player.key, NewSt),
                    log_act_mystery_tree(Player#player.key, Player#player.nickname, Player#player.lv, LogCost, GoodsList),
                    insert(Base#base_act_mystery_tree.act_id, Player#player.nickname, GoodsList),
                    activity:get_notice(Player, [167], true),
                    {ok, NewPlayer} = goods:give_goods(NPlayer, goods:make_give_goods_list(570, GoodsList)),
                    {1, NewPlayer, [tuple_to_list(X) || X <- GoodsList]}
            end
    end.


get_exchange_info() ->
    case get_act() of
        [] -> [];
        Base ->
            [tuple_to_list(X) || X <- Base#base_act_mystery_tree.exchange_list]
    end.

exchange(Player, Id) ->
    case check_exchange(Player, Id) of
        {false, Res} ->
            {Res, Player};
        {ok, Score, GoodsId, GoodsNum} ->
            St = get_player_info(Player),
            NewSt = St#st_act_mystery_tree{score = St#st_act_mystery_tree.score - Score},
            set_player_info(Player#player.key, NewSt),
            activity:get_notice(Player, [167], true),
            {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(570, [{GoodsId, GoodsNum}])),
            {1, NewPlayer}
    end.

check_exchange(_Player, Id) ->
    case get_act() of
        [] -> {false, 0};
        Base ->
            ExchangeList = Base#base_act_mystery_tree.exchange_list,
            case lists:keyfind(Id, 1, ExchangeList) of
                false -> {false, 0};
                {Id, Score, GoodsId, GoodsNum} ->
                    St = get_player_info(_Player),
                    if
                        St#st_act_mystery_tree.score < Score -> {false, 8};
                        true ->
                            {ok, Score, GoodsId, GoodsNum}
                    end
            end
    end.

buy_goods(Player, Num) ->
    case get_act() of
        [] -> {0, Player};
        Base ->
            case money:is_enough(Player, Base#base_act_mystery_tree.goods_cost * Num, gold) of
                false ->
                    {5, Player};
                true ->
                    NewPlayer = money:add_no_bind_gold(Player, -Base#base_act_mystery_tree.goods_cost * Num, 570, ?COST_GOODS_ID, Num),
                    activity:get_notice(Player, [167], true),
                    {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(570, [{?COST_GOODS_ID, Num}])),
                    {1, NewPlayer1}
            end
    end.

get_notice_state(Player) ->
    case get_act() of
        [] -> -1;
        #base_act_mystery_tree{act_info = ActInfo} ->
            ExchangeState = get_exchang_state(Player),
            GoodsCount = goods_util:get_goods_count(?COST_GOODS_ID),
            if
                GoodsCount > 0 -> 1;
                true ->
                    {Index, FreeEndTime} = daily:get_count(?DAILY_ACT_MYSTERY_TREE_FREE, {1, 0}),
                    IsFree = (Index == 1 andalso FreeEndTime == 0),
                    NowTime = util:unixtime(),
                    IsFree2 = (NowTime >= FreeEndTime andalso FreeEndTime /= 0),
                    IsFree3 = IsFree orelse IsFree2,
                    Args = activity:get_base_state(ActInfo),
                    case IsFree3 of
                        true -> {1, Args};
                        _ ->
                            {ExchangeState, Args}
                    end
            end
    end.

get_exchang_state(Player) ->
    case get_act() of
        [] -> -1;
        Base ->
            ExchangeList = Base#base_act_mystery_tree.exchange_list,
            Ids = [Id || {Id, _, _, _} <- ExchangeList],
            F = fun(Id) ->
                case check_exchange(Player, Id) of
                    {false, _Res} -> false;
                    _ -> true
                end
                end,
            case lists:any(F, Ids) of
                true -> 1;
                _ -> 0
            end
    end.


log_act_mystery_tree(Pkey, Nickname, Lv, LogCost, GoodsList) ->
    Sql = io_lib:format("insert into  log_act_mystery_tree (pkey, nickname,lv,cost,goods_list,time) VALUES(~p,'~s',~p,~p,'~s',~p)",
        [Pkey, Nickname, Lv, LogCost, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql),
    ok.



insert(ActId, Nickname, GoodsList) ->
    LogList = get_log(ActId),
    NewLog =
        lists:foldl(fun({GoodsId, GoodsNum}, AccLogList) ->
            [[Nickname, GoodsId, GoodsNum] | AccLogList]
                    end, LogList, GoodsList),
    ?GLOBAL_DATA_RAM:set(?ACT_MYSTERY_TREE_LOG(ActId), lists:sublist(NewLog, 50)),
    ok.










