%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 金银塔
%%% @end
%%% Created : 20. 六月 2017 上午10:21
%%%-------------------------------------------------------------------
-module(gold_silver_tower).
-author("fengzhenlin").

-include("server.hrl").
-include("activity.hrl").
-include("common.hrl").
-include("daily.hrl").

%%协议接口
-export([
    get_info/0,
    lucky_draw/2
]).

%% API
-export([
    init/1,
    update/1,
    ets_to_db/0,
    get_state/0,
    init_ets/0
]).

-define(LIMIT_LEN, 50).
-define(MAXFLOOR, 6).

init_ets() ->
    spawn(fun() -> init_data() end),
    ok.

init_data() ->
    case get_act() of
        [] ->
            ok;
        #base_gold_silver_tower{act_id = BaseActId} ->
            Ets = activity_load:dbget_gold_silver_tower_ets(BaseActId),
            ets:insert(?ETS_GOLD_SILVER_TOWER, Ets)
    end.
init(Player) ->
    StTower = activity_load:dbget_gold_silver_tower(Player),
    put_dict(StTower),
    update(Player),
    Player.

update(_Player) ->
    StTower = get_dict(),
    #st_gold_silver_tower{
        act_id = ActId
    } = StTower,
    NewStTower =
        case get_act() of
            [] -> StTower;
            Base ->
                #base_gold_silver_tower{
                    act_id = BaseActId
                } = Base,
                case ActId == BaseActId of
                    true ->
                        StTower;
                    false ->
                        StTower#st_gold_silver_tower{
                            act_id = BaseActId
                            , count_list = []
                            , index_floor = 1
                        }
                end
        end,
    put_dict(NewStTower),
    ok.

get_info() ->
    case get_act() of
        [] -> {0, 0, 0, 0, 0, 0, 0, [], []};
        Base ->
            #base_gold_silver_tower{
                cost_one = CostOne
                , cost_ten = CostTen
                , cost_fifty = CostFifty
                , reward_list = RewardList0
                , fashion_id = FashionId
                , act_id = ActId
            } = Base,

            LeaveTime = activity:get_leave_time(data_gold_silver_tower),
            RewardList = make_goods(RewardList0),
            #st_gold_silver_tower{index_floor = Index} = get_dict(),
            GeneralInfo = get_general_info(),
            Count = daily:get_count(?DAILY_PLANT_GOLD_SILVER_TOWER),
            St = get_dict(),
            put_dict(St#st_gold_silver_tower{act_id = ActId}),
            activity_load:dbup_gold_silver_tower(St#st_gold_silver_tower{act_id = ActId}),
            {LeaveTime, FashionId, Count, Index, CostOne, CostTen, CostFifty, RewardList, GeneralInfo}
    end.

make_goods(RewardList) ->
    F = fun(Base, List) ->
        [[Base#base_gold_silver_tower_goods.floor,
            Base#base_gold_silver_tower_goods.reset_id,
            [[Id, GoodsId, GoodsNum] || {Id, GoodsId, GoodsNum, _} <- Base#base_gold_silver_tower_goods.goods_list]] | List]
    end,
    lists:foldl(F, [], RewardList).

get_general_info() ->
    case get_act() of
        [] -> [];
        #base_gold_silver_tower{act_id = ActId} ->
            Ets = look_up(ActId),
            lists:sublist([[Nickname, GoodsId, GoodsNum] || {Nickname, GoodsId, GoodsNum} <- Ets#ets_gold_silver_tower.buy_list], ?LIMIT_LEN)
    end.

get_dict() ->
    lib_dict:get(?PROC_STATUS_GOLD_SILVER_TOWER).

put_dict(StConCharge) ->
    lib_dict:put(?PROC_STATUS_GOLD_SILVER_TOWER, StConCharge).

get_act() ->
    case activity:get_work_list(data_gold_silver_tower) of
        [] -> [];
        [Base | _] -> Base
    end.

lucky_draw(Player, Type) ->
    case Type of
        1 -> draw_one(Player);   %% 单次
        2 -> draw_ten(Player);   %% 十次
        3 -> draw_fifty(Player)  %% 五十次
    end.

draw_one(Player) ->
    case check_one(Player) of
        {false, Res} ->
            {false, Res};
        {ok, Floor, CountList, IsFree, OneCost, ActId} ->
            NewPlayer = ?IF_ELSE(IsFree, Player, money:add_no_bind_gold(Player, -OneCost, 277, 0, 0)),
            daily:increment(?DAILY_PLANT_GOLD_SILVER_TOWER, 1),
            {NewFloor, NewCountList, GoodsId, GoodsNum, LuckId} = draw(Player, Floor, CountList),
            insert_ets(Player#player.nickname, GoodsId, GoodsNum, ActId),
            St = get_dict(),
            NewSt = St#st_gold_silver_tower{count_list = NewCountList, index_floor = NewFloor},
            activity_load:dbup_gold_silver_tower(NewSt),
            put_dict(NewSt),
            activity:get_notice(Player, [124], true),
            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(277, [{GoodsId, GoodsNum, 0}])),
            {ok, NewPlayer1, Floor, NewFloor, LuckId, [[1, [[GoodsId, GoodsNum]]]]}
    end.

check_one(Player) ->
    case get_act() of
        [] ->
            {false, 0};
        #base_gold_silver_tower{cost_one = OneCost, act_id = ActId} ->
            IsEnough = money:is_enough(Player, OneCost, gold),
            IsFree = ?IF_ELSE(daily:get_count(?DAILY_PLANT_GOLD_SILVER_TOWER) == 0, true, false),
            case IsEnough orelse IsFree of
                false ->
                    {false, 5};
                true ->
                    St = get_dict(),
                    #st_gold_silver_tower{
                        count_list = CountList,
                        index_floor = Floor
                    } = St,
                    {ok, Floor, CountList, IsFree, OneCost, ActId}
            end
    end.

draw_ten(Player) ->
    case check_ten(Player) of
        {false, Res} -> {false, Res};
        {ok, Floor, CountList, TenCost, ActId} ->
            NewPlayer = money:add_no_bind_gold(Player, -TenCost, 277, 0, 0),
            F = fun(_, {Floor0, CountList0, List}) ->
                {NewFloor0, NewCountList0, GoodsId, GoodsNum, _LuckId} = draw(Player, Floor0, CountList0),
                insert_ets(Player#player.nickname, GoodsId, GoodsNum, ActId),
                {NewFloor0, NewCountList0, [{Floor0, GoodsId, GoodsNum} | List]}
            end,
            {NewFloor, NewCountList, GoodsList0} = lists:foldl(F, {Floor, CountList, []}, lists:seq(1, 10)),
            GoodsList = [{GoodsId0, GoodsNum, 0} || {_Floor0, GoodsId0, GoodsNum} <- GoodsList0],
            NewGoodsList = merge_goods(GoodsList0),
            St = get_dict(),
            NewSt = St#st_gold_silver_tower{count_list = NewCountList, index_floor = NewFloor},
            activity_load:dbup_gold_silver_tower(NewSt),
            put_dict(NewSt),
            activity:get_notice(Player, [124], true),
            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(277, GoodsList)),
            {ok, NewPlayer1, Floor, NewFloor, 0, NewGoodsList}
    end.

check_ten(Player) ->
    case get_act() of
        [] ->
            {false, 0};
        #base_gold_silver_tower{cost_ten = TenCost, act_id = ActId} ->
            IsEnough = money:is_enough(Player, TenCost, gold),
            case IsEnough of
                false ->
                    {false, 5};
                true ->
                    St = get_dict(),
                    #st_gold_silver_tower{
                        count_list = CountList,
                        index_floor = Floor
                    } = St,
                    {ok, Floor, CountList, TenCost, ActId}
            end
    end.

draw_fifty(Player) ->
    case check_fifty(Player) of
        {false, Res} -> {false, Res};
        {ok, Floor, CountList, FiftyCost, ActId} ->
            NewPlayer = money:add_no_bind_gold(Player, -FiftyCost, 277, 0, 0),
            F = fun(_, {Floor0, CountList0, List}) ->
                {NewFloor0, NewCountList0, GoodsId, GoodsNum, _LuckId} = draw(Player, Floor0, CountList0),
                insert_ets(Player#player.nickname, GoodsId, GoodsNum, ActId),
                {NewFloor0, NewCountList0, [{Floor0, GoodsId, GoodsNum} | List]}
            end,
            {NewFloor, NewCountList, GoodsList0} = lists:foldl(F, {Floor, CountList, []}, lists:seq(1, 50)),
            GoodsList = [{GoodsId0, GoodsNum, 0} || {_Floor0, GoodsId0, GoodsNum} <- GoodsList0],
            NewGoodsList = merge_goods(GoodsList0),
            St = get_dict(),
            NewSt = St#st_gold_silver_tower{count_list = NewCountList, index_floor = NewFloor},
            activity_load:dbup_gold_silver_tower(NewSt),
            put_dict(NewSt),
            activity:get_notice(Player, [124], true),
            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(277, GoodsList)),
            {ok, NewPlayer1, Floor, NewFloor, 0, NewGoodsList}
    end.

check_fifty(Player) ->
    case get_act() of
        [] ->
            {false, 0};
        #base_gold_silver_tower{cost_fifty = FiftyCost, act_id = ActId} ->
            IsEnough = money:is_enough(Player, FiftyCost, gold),
            case IsEnough of
                false ->
                    {false, 5};
                true ->
                    St = get_dict(),
                    #st_gold_silver_tower{
                        count_list = CountList,
                        index_floor = Floor
                    } = St,
                    {ok, Floor, CountList, FiftyCost, ActId}
            end
    end.

%% 合并物品
merge_goods(GoodsList) ->
    NewGoodsList = merge_goods_help(GoodsList, []),
    F = fun({Floor, GoodsList0}, List) ->
        [[Floor, [[GoodsId, GoodsNum] || {GoodsId, GoodsNum} <- GoodsList0]] | List]
    end,
    lists:foldl(F, [], NewGoodsList).

merge_goods_help([], List) -> List;
merge_goods_help([{Floor, GoodsId, GoodsNum} | T], List) ->
    case lists:keytake(Floor, 1, List) of
        false ->
            merge_goods_help(T, [{Floor, [{GoodsId, GoodsNum}]} | List]);
        {value, {Floor, List0}, List1} ->
            case lists:keytake(GoodsId, 1, List0) of
                false ->
                    merge_goods_help(T, [{Floor, [{GoodsId, GoodsNum} | List0]} | List1]);
                {value, {GoodsId, Num}, List2} ->
                    merge_goods_help(T, [{Floor, [{GoodsId, GoodsNum + Num} | List2]} | List1])
            end
    end.

draw(Player, Floor, CountList) ->
    {Count, List} =
        case lists:keytake(Floor, 1, CountList) of
            false -> {0, CountList};
            {value, {Floor, Count0}, List0} ->
                {Count0, List0}
        end,
    #base_gold_silver_tower{reward_list = RewardList} = get_act(),
    Base = lists:keyfind(Floor, #base_gold_silver_tower_goods.floor, RewardList),
    #base_gold_silver_tower_goods{
        lower = Lower
        , up = Up
        , reset_id = ResetId
        , goods_list = GoodsList
    } = Base,
    if
        Count < Lower ->
            RatioList = [{Id, R} || {Id, _GoodsId0, _GoodsNum, R} <- GoodsList, Id =/= ResetId],
            LuckId = util:list_rand_ratio(RatioList),
            {_, GoodsId, GoodsNum, _} = lists:keyfind(LuckId, 1, GoodsList),
            NewFloor = ?IF_ELSE(Floor == 1, 1, Floor - 1),
            {NewFloor, [{Floor, Count + 1} | List], GoodsId, GoodsNum, LuckId};
        Count >= Up ->
            {_, GoodsId, GoodsNum, _} = lists:keyfind(ResetId, 1, GoodsList),
            Max = ?MAXFLOOR,
            if
                Floor >= Max ->
                    Content = io_lib:format(t_tv:get(262), [t_tv:pn(Player), t_tv:gn(GoodsId)]),
                    notice:add_sys_notice(Content, 262),
                    {1, [], GoodsId, GoodsNum, ResetId};
                true ->
                    {Floor + 1, [{Floor, Count + 1} | List], GoodsId, GoodsNum, ResetId}
            end;
        true ->
            RatioList = [{Id, R} || {Id, _GoodsId0, _GoodsNum, R} <- GoodsList],
            LuckId = util:list_rand_ratio(RatioList),
            {_, GoodsId, GoodsNum, _} = lists:keyfind(LuckId, 1, GoodsList),
            if
                LuckId == ResetId ->
                    Max = ?MAXFLOOR,
                    if
                        Floor >= Max ->
                            Content = io_lib:format(t_tv:get(262), [t_tv:pn(Player), t_tv:gn(GoodsId)]),
                            notice:add_sys_notice(Content, 262),
                            {1, [], GoodsId, GoodsNum, ResetId};
                        true ->
                            {Floor + 1, [{Floor, Count + 1} | List], GoodsId, GoodsNum, ResetId}
                    end;
                true ->
                    NewFloor = ?IF_ELSE(Floor == 1, 1, Floor - 1),
                    {NewFloor, [{Floor, Count + 1} | List], GoodsId, GoodsNum, LuckId}
            end
    end.

insert_ets(Nickname, GoodsId, GoodsNum, ActId) ->
    Ets = look_up(ActId),
    BuyList = [{Nickname, GoodsId, GoodsNum} | Ets#ets_gold_silver_tower.buy_list],
    NewEts = Ets#ets_gold_silver_tower{
        buy_list = lists:sublist(BuyList, ?LIMIT_LEN),
        db_flag = 1
    },
    ets:insert(?ETS_GOLD_SILVER_TOWER, NewEts),
    ok.

look_up(ActId) ->
    case ets:lookup(?ETS_GOLD_SILVER_TOWER, ActId) of
        [] ->
            ets:insert(?ETS_GOLD_SILVER_TOWER, #ets_gold_silver_tower{act_id = ActId}),
            #ets_gold_silver_tower{act_id = ActId};
        [Ets] ->
            Ets
    end.

ets_to_db() ->
    case get_act() of
        [] ->
            ok;
        #base_gold_silver_tower{act_id = BaseActId} ->
            Ets = look_up(BaseActId),
            if
                Ets#ets_gold_silver_tower.db_flag == 1 ->
                    activity_load:dbup_gold_silver_tower_ets(Ets),
                    ets:insert(?ETS_GOLD_SILVER_TOWER, Ets#ets_gold_silver_tower{db_flag = 0});
                true ->
                    ok
            end
    end.

get_state() ->
    case get_act() of
        [] ->
            -1;
        Base ->
            Args = activity:get_base_state(Base#base_gold_silver_tower.act_info),
            ?IF_ELSE(daily:get_count(?DAILY_PLANT_GOLD_SILVER_TOWER) == 0, {1, Args}, {0, Args})
    end.

