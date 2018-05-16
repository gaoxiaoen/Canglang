%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 五月 2017 11:34
%%%-------------------------------------------------------------------
-module(act_draw_turntable).
-author("luobq").
-include("common.hrl").
-include("activity.hrl").
-include("server.hrl").
-include("daily.hrl").

-export([
    get_goods_exchange_info/1,
    exchange_goods/3,
    is_activity/0,
    get_state/1,
    draw_lottery/2,
    refresh/1
]).

%% API
-export([
    init/1,
    update/1
]).

init(Player) ->
    StLotteryTurn = activity_load:dbget_draw_turntable(Player),
    put_dict(StLotteryTurn),
    update(Player),
    Player.

update(Player) ->
    StLotteryTurn = get_dict(Player),
    #st_draw_turntable{
        act_id = ActId
    } = StLotteryTurn,
    NewStLotteryTurn =
        case activity:get_work_list(data_draw_turntable) of
            [] -> StLotteryTurn;
            [Base | _] ->
                case Base#base_draw_turntable.act_id == ActId of
                    false ->
                        TurntableId = random_id(Base#base_draw_turntable.turntable_list),
                        StLotteryTurn#st_draw_turntable{
                            act_id = Base#base_draw_turntable.act_id,
                            score = 0,
                            exchange_list = [],
                            turntable_id = TurntableId
                        };
                    true ->
                        StLotteryTurn
                end
        end,
    put_dict(NewStLotteryTurn),
    ok.

%%获取转盘信息
get_goods_exchange_info(Player) ->
    case activity:get_work_list(data_draw_turntable) of
        [] ->
            {0, 0, 0, 0, 0, 0, 0, [], [], []};
        [Base | _] ->
            StLotteryTurn = get_dict(Player),
            #st_draw_turntable{
                exchange_list = MyExchangeList,
                turntable_id = Index,
                score = Score,
                location = Location,
                count = Count
            } = StLotteryTurn,
            #base_draw_turntable{
                refresh_cost = RefreshCost,
                one_cost = OneCost,
                ten_cost = TenCost,
                exchange_list = ExchangeList,
                turntable_list = TurntableList
            } = Base,
            LeaveTime = activity:get_leave_time(data_draw_turntable),
            MyTurnstuple = data_draw_turntable_info:get(Index, Count),
            MyTurnsList = [tuple_to_list(X) || X <- MyTurnstuple#base_draw_turntable_goods.goods_list],
            F = fun({Id, GoodsId, GoodsNum, Limit, Cost}, List) ->
                case lists:keyfind(Id, 1, MyExchangeList) of
                    false -> [[Id, GoodsId, GoodsNum, 0, Limit, Cost] | List];
                    {_, Count0} ->
                        [[Id, GoodsId, GoodsNum, Count0, Limit, Cost] | List]
                end
            end,
            NewExchangeList = lists:foldl(F, [], ExchangeList),
            CountDaily = daily:get_count(?DAILY_DRAW_TURNTABLE),
            F0 = fun(Id, List) ->
                Base0 = data_draw_turntable_info:get(Id, 0),
                [[Id, [[Loc, GoodsId0, GoodsNum0] || {Loc, GoodsId0, GoodsNum0, _} <- Base0#base_draw_turntable_goods.goods_list]] | List]
            end,
            TurntableList0 = lists:foldl(F0, [], TurntableList),
            {LeaveTime, Score, CountDaily, Location, RefreshCost, OneCost, TenCost, MyTurnsList, NewExchangeList, TurntableList0}
    end.


%%抽奖
draw_lottery(Player, Type) ->
    case Type of
        1 -> %% 抽1次
            draw_lottery_one(Player);
        2 -> %% 抽10次
            draw_lottery_ten(Player);
        _ ->
            {false, 0}
    end.

%% 抽1次
draw_lottery_one(Player) ->
    case check_draw_lottery_one(Player) of
        {false, Res} ->
            {false, Res};
        {ok, BaseGoods, IsFree, OneCost} ->
            StLotteryTurn = get_dict(Player),
            #st_draw_turntable{
                count = Count,
                score = Score
            } = StLotteryTurn,
            #base_draw_turntable_goods{
                goods_list = BaseGoodsList,
                reset_id = ResetId
            } = BaseGoods,
            Player1 =
                case IsFree of
                    true ->
                        BaseGoodsList1 = lists:sublist(lists:reverse(lists:keysort(4, BaseGoodsList)), 4),
                        RanList = [{Id, Ratio} || {Id, _GoodsId, _Num, Ratio} <- BaseGoodsList1],
                        LuckId = util:list_rand_ratio(RanList),
                        {_, GoodsId, GoodsNum, _} = lists:keyfind(LuckId, 1, BaseGoodsList),
                        log_act_draw_turntable(Player#player.key, Player#player.nickname, Player#player.lv, 0, [{GoodsId, GoodsNum}]),
                        Player;
                    _ ->
                        RanList = [{Id, Ratio} || {Id, _GoodsId, _Num, Ratio} <- BaseGoodsList],
                        LuckId = util:list_rand_ratio(RanList),
                        {_, GoodsId, GoodsNum, _} = lists:keyfind(LuckId, 1, BaseGoodsList),
                        log_act_draw_turntable(Player#player.key, Player#player.nickname, Player#player.lv, OneCost, [{GoodsId, GoodsNum}]),
                        money:add_no_bind_gold(Player, -OneCost, 253, GoodsId, GoodsNum)
                end,
            NewCount0 = ?IF_ELSE(IsFree, Count, Count + 1), %% 免费不加次数
            if
                GoodsId == ResetId ->
                    Content = io_lib:format(t_tv:get(263), [t_tv:pn(Player), t_tv:gn(GoodsId)]),
                    notice:add_sys_notice(Content, 263),
                    NewCount = 0;
                true ->
                    NewCount = NewCount0
            end,
            GiveGoodsList = goods:make_give_goods_list(253, [{GoodsId, GoodsNum, 0}]),
            NewStLotteryTurn = StLotteryTurn#st_draw_turntable{score = Score + 1, location = LuckId, count = NewCount},
            put_dict(NewStLotteryTurn),
            activity_load:dbup_player_draw_turntable(NewStLotteryTurn),
            daily:increment(?DAILY_DRAW_TURNTABLE, 1),
            {ok, Player2} = goods:give_goods(Player1, GiveGoodsList),
            {ok, Player2, LuckId, [[GoodsId, GoodsNum]]}
    end.

check_draw_lottery_one(Player) ->
    case activity:get_work_list(data_draw_turntable) of
        [] ->
            {false, 0};
        [Base | _] ->
            #base_draw_turntable{
                one_cost = OneCost
            } = Base,
            IsEnough = money:is_enough(Player, OneCost, gold),
            IsFree = ?IF_ELSE(daily:get_count(?DAILY_DRAW_TURNTABLE) == 0, true, false),
            case IsEnough orelse IsFree of
                false ->
                    {false, 5};
                true ->
                    StLotteryTurn = get_dict(Player),
                    #st_draw_turntable{
                        turntable_id = Index,
                        count = Count
                    } = StLotteryTurn,
                    case data_draw_turntable_info:get(Index, Count) of
                        [] -> {false, 0};
                        BaseGoods -> {ok, BaseGoods, IsFree, OneCost}
                    end
            end
    end.

%% 抽10次
draw_lottery_ten(Player) ->
    case check_draw_lottery_ten(Player) of
        {false, Res} ->
            {false, Res};
        {ok, Index, TenCost} ->
            StLotteryTurn = get_dict(Player),
            #st_draw_turntable{
                score = Score,
                count = Count
            } = StLotteryTurn,
            F = fun(_, {List, Count0}) ->
                BaseGoods = data_draw_turntable_info:get(Index, Count0),
                BaseGoodsList = BaseGoods#base_draw_turntable_goods.goods_list,
                ResetId = BaseGoods#base_draw_turntable_goods.reset_id,
                RanList = [{Id, Ratio} || {Id, _GoodsId, _Num, Ratio} <- BaseGoodsList],
                LuckId = util:list_rand_ratio(RanList),
                {_, GoodsId, GoodsNum, _} = lists:keyfind(LuckId, 1, BaseGoodsList),
                if
                    GoodsId == ResetId ->
                        Content = io_lib:format(t_tv:get(263), [t_tv:pn(Player), t_tv:gn(GoodsId)]),
                        notice:add_sys_notice(Content, 263),
                        NewCount = 0;
                    true ->
                        NewCount = Count0 + 1
                end,
                {[{GoodsId, GoodsNum, 0} | List], NewCount}
            end,
            {GiveGoodsList0, NewCount0} = lists:foldl(F, {[], Count}, lists:seq(1, 10)),
            Player1 = money:add_no_bind_gold(Player, -TenCost, 253, 0, 0),
            GiveGoodsList = goods:make_give_goods_list(253, GiveGoodsList0),
            NewStLotteryTurn = StLotteryTurn#st_draw_turntable{score = Score + 10, location = 0, count = NewCount0},
            put_dict(NewStLotteryTurn),
            log_act_draw_turntable(Player#player.key, Player#player.nickname, Player#player.lv, TenCost, GiveGoodsList0),
            activity_load:dbup_player_draw_turntable(NewStLotteryTurn),
            {ok, Player2} = goods:give_goods(Player1, GiveGoodsList),
            {ok, Player2, util:rand(1, 9), goods:pack_goods(GiveGoodsList)}
    end.

check_draw_lottery_ten(Player) ->
    case activity:get_work_list(data_draw_turntable) of
        [] ->
            {false, 0};
        [Base | _] ->
            #base_draw_turntable{
                ten_cost = TenCost
            } = Base,
            case money:is_enough(Player, TenCost, gold) of
                false ->
                    {false, 5};
                true ->
                    StLotteryTurn = get_dict(Player),
                    #st_draw_turntable{
                        turntable_id = Index,
                        count = Count
                    } = StLotteryTurn,
                    case data_draw_turntable_info:get(Index, Count) of
                        [] ->
                            {false, 0};
                        _BaseGoods ->
                            {ok, Index, TenCost}
                    end
            end
    end.

%%兑换物品
exchange_goods(Player, Id, Num) ->
    case check_exchange_goods(Player, Id, Num) of
        {false, Res} ->
            StLotteryTurn = get_dict(Player),
            #st_draw_turntable{
                score = Score
            } = StLotteryTurn,
            {false, Res, Score};
        {ok, GoodsId, Cost, GoodsNum} ->
            StLotteryTurn = get_dict(Player),
            #st_draw_turntable{
                score = Score,
                exchange_list = MyExchangeList
            } = StLotteryTurn,

            NewMyExchangeList =
                case lists:keyfind(Id, 1, MyExchangeList) of
                    false ->
                        [{Id, Num} | MyExchangeList];
                    {Id, Count} ->
                        lists:keystore(Id, 1, MyExchangeList, {Id, Count + Num})
                end,
            NewStLotteryTurn =
                StLotteryTurn#st_draw_turntable{
                    score = Score - Cost * Num,
                    exchange_list = NewMyExchangeList
                },
            put_dict(NewStLotteryTurn),
            GiveGoodsList = goods:make_give_goods_list(254, [{GoodsId, Num * GoodsNum, 0}]),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            activity_load:dbup_player_draw_turntable(NewStLotteryTurn),
            log_act_draw_turntable_exchange(Player#player.key, Player#player.nickname, Player#player.lv, Cost * Num, GoodsId, GoodsNum * Num),
            activity:get_notice(Player, [111], true),
            activity_log:log_get_gift(Player#player.key, Player#player.nickname, GoodsId, Num * GoodsNum, 999),
            {ok, NewPlayer, Score - Cost * Num}
    end.

check_exchange_goods(Player, Id, Num) ->
    StLotteryTurn = get_dict(Player),
    #st_draw_turntable{
        score = Score,
        act_id = Actid,
        exchange_list = MyExchangeList
    } = StLotteryTurn,
    case activity:get_work_list(data_draw_turntable) of
        [] -> {false, 0};
        [Base | _] ->
            #base_draw_turntable{
                act_id = BaseActid,
                exchange_list = ExchangeList
            } = Base,
            if
                Actid =/= BaseActid ->
                    init(Player),
                    {false, 0};
                true ->
                    case lists:keyfind(Id, 1, ExchangeList) of
                        false -> {false, 0};
                        {Id, GoodsId, GoodsNum, Lim, Cost} ->
                            Count = case lists:keyfind(Id, 1, MyExchangeList) of
                                        false -> 0;
                                        {_Id, Count0} ->
                                            Count0
                                    end,
                            if
                                Count + Num > Lim ->
                                    {false, 10}; %% 兑换次数不足
                                Score < Cost * Num ->
                                    {false, 15}; %% 积分不足
                                true ->
                                    {ok, GoodsId, Cost, GoodsNum}
                            end
                    end
            end
    end.

%% 刷新
refresh(Player) ->
    case check_refresh(Player) of
        {false, Res} ->
            {false, Res};
        {ok, RefreshCost, TurntableList} ->
            NewPlayer = money:add_no_bind_gold(Player, -RefreshCost, 255, 0, 0),
            StLotteryTurn = get_dict(Player),
            #st_draw_turntable{
                turntable_id = TurnId
            } = StLotteryTurn,
            List = lists:delete(TurnId, TurntableList),
            Len = length(List),
            if
                Len == 0 -> NewTurnId = TurnId;
                true -> NewTurnId = random_id(List)
            end,
            NewStLotteryTurn = StLotteryTurn#st_draw_turntable{turntable_id = NewTurnId},
            put_dict(NewStLotteryTurn),
            activity_load:dbup_player_draw_turntable(NewStLotteryTurn),
            {ok, NewPlayer}
    end.

random_id(List) ->
    Index = random:uniform(length(List)),
    random_id_help(List, Index).
random_id_help([H | T], Index) ->
    if
        Index == 1 -> H;
        true -> random_id_help(T, Index - 1)
    end.

check_refresh(Player) ->
    case activity:get_work_list(data_draw_turntable) of
        [] -> {false, 0};
        [Base | _] ->
            #base_draw_turntable{
                refresh_cost = RefreshCost,
                turntable_list = TurntableList
            } = Base,
            Len = data_draw_turntable_info:get_max(),
            case money:is_enough(Player, RefreshCost, gold) of
                false -> {false, 5};
                true ->
                    if
                        Len =< 1 -> {false, 13}; %% 无法刷新
                        true ->
                            {ok, RefreshCost, TurntableList}
                    end
            end
    end.

get_dict(Player) ->
    case lib_dict:get(?PROC_STATUS_DRAW_TURN) of
        St when is_record(St, st_draw_turntable) ->
            St;
        _ ->
            init(Player),
            get_dict(Player)
    end.

put_dict(StLotteryTurn) ->
    lib_dict:put(?PROC_STATUS_DRAW_TURN, StLotteryTurn).

%%是否活动中
is_activity() ->
    case activity:get_work_list(data_draw_turntable) of
        [] -> false;
        _ -> true
    end.

%%获取领取状态
get_state(Player) ->
    case activity:get_work_list(data_draw_turntable) of
        [] -> -1;
        [Base | _] ->
            F = fun(Id) ->
                case check_exchange_goods(Player, Id, 1) of
                    {false, _} -> false;
                    _ -> true
                end
            end,
            Args = activity:get_base_state(Base#base_draw_turntable.act_info),
            case lists:any(F, lists:seq(1, length(Base#base_draw_turntable.exchange_list))) of
                true -> {1, Args};
                false -> {0, Args}
            end
    end.

log_act_draw_turntable(Pkey, Nickname, Lv, Gold, GoodsList) ->
    Sql = io_lib:format("insert into  log_act_draw_turntable (pkey, nickname,lv,gold,goods_list,time) VALUES(~p,'~s',~p,~p,'~s',~p)",
        [Pkey, Nickname, Lv, Gold, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql),
    ok.

log_act_draw_turntable_exchange(Pkey, Nickname, Lv, Score, GoodsId, GoodsNum) ->
    Sql = io_lib:format("insert into  log_act_draw_turntable_exchange (pkey, nickname,lv,score,goods_id,goods_num,time) VALUES(~p,'~s',~p,~p,~p,~p,~p)",
        [Pkey, Nickname, Lv, Score, GoodsId, GoodsNum, util:unixtime()]),
    log_proc:log(Sql),
    ok.

