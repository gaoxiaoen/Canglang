%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 天宫寻宝
%%% @end
%%% Created : 28. 八月 2017 19:51
%%%-------------------------------------------------------------------
-module(act_welkin_hunt).
-author("Administrator").
-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("goods.hrl").
%% API
-export([
    init/1,
    draw/3,
    update/1,
    init_ets/0,
    get_info/1,
    exchange/2,
    buy_goods/2,
    get_exchange_info/0,
    get_notice_state/1
]).

-define(COST_GOODS_ID, 30080).
-define(DRAW_COUNT, 10).

init(Player) ->
    St = activity_load:dbget_act_welkin_hunt(Player#player.key),
    put_dict(St),
    update(Player),
    Player.

update(Player) ->
    St = get_dict(),
    #st_act_welkin_hunt{
        act_id = ActId
    } = St,
    NewSt =
        case get_act() of
            [] -> St;
            Base ->
                #base_act_welkin_hunt{
                    act_id = BaseActId
                } = Base,
                case ActId == BaseActId of
                    false ->
                        #st_act_welkin_hunt{
                            act_id = BaseActId,
                            pkey = Player#player.key
                        };
                    true ->
                        St
                end
        end,
    put_dict(NewSt),
    ok.

get_info(Player) ->
    case get_act() of
        [] -> {0, 0, 0, 0, 0, 0, 0, [], [], [], []};
        Base ->
            St = get_dict(),
            RewardList = Base#base_act_welkin_hunt.reward_list,
            RewardList0 = hd(RewardList),
            RewardList1 = [[Id, GoodsId, GoodsNum] || {Id, GoodsId, GoodsNum, _} <- RewardList0#base_act_welkin_hunt_help.reward_list],
            ShopState = get_exchang_state(Player),
            {get_leave_time(),
                Base#base_act_welkin_hunt.goods_cost,
                St#st_act_welkin_hunt.score,
                ShopState,
                ?COST_GOODS_ID,
                1,
                ?DRAW_COUNT,
                RewardList0#base_act_welkin_hunt_help.sp_list,
                get_log(),
                St#st_act_welkin_hunt.log_list,
                RewardList1}
    end.

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
        Base ->
            IsEnough = money:is_enough(Player, Base#base_act_welkin_hunt.goods_cost, gold),
            if
                GoodsCount =< 0 andalso IsAuto == 0 -> {18, Player, []};
                GoodsCount =< 0 andalso IsAuto == 1 andalso not IsEnough -> {5, Player, []};
                true ->
                    if
                        GoodsCount > 0 ->
                            goods:subtract_good(Player, [{?COST_GOODS_ID, 1}], 541),
                            LogCost = 0,
                            NPlayer = Player;
                        true ->
                            LogCost = Base#base_act_welkin_hunt.goods_cost,
                            NPlayer = money:add_no_bind_gold(Player, -Base#base_act_welkin_hunt.goods_cost, 541, 0, 0)
                    end,
                    RewardList0 = Base#base_act_welkin_hunt.reward_list,
                    St = get_dict(),
                    {Count, GoodsId, GoodsNum} = draw_one_help(Player, St#st_act_welkin_hunt.count, RewardList0),
                    NewLog = [[Player#player.nickname, GoodsId, GoodsNum]] ++ St#st_act_welkin_hunt.log_list,
                    NewSt = St#st_act_welkin_hunt{count = Count, score = St#st_act_welkin_hunt.score + 1, log_list = lists:sublist(NewLog, 20)},
                    put_dict(NewSt),
                    log_act_welkin_hunt(Player#player.key, Player#player.nickname, Player#player.lv, LogCost, [{GoodsId, GoodsNum}]),
                    activity_load:dbup_act_welkin_hunt(NewSt),
                    GoodsType = data_goods:get(GoodsId),
                    if
                        GoodsType#goods_type.color >= 3 ->
                            insert(Base#base_act_welkin_hunt.act_id, NPlayer#player.nickname, [{GoodsId, GoodsNum}]);
                        true -> skip
                    end,
                    activity:get_notice(Player, [157], true),
                    {ok, NewPlayer} = goods:give_goods(NPlayer, goods:make_give_goods_list(541, [{GoodsId, GoodsNum}])),
                    {1, NewPlayer, [[GoodsId, GoodsNum]]}
            end
    end.

draw_one_help(Player, Count, RewardList0) ->
    F = fun(BaseHelp, List) ->
        if
            Count >= BaseHelp#base_act_welkin_hunt_help.up andalso Count =< BaseHelp#base_act_welkin_hunt_help.down ->
                [{BaseHelp#base_act_welkin_hunt_help.reward_list, BaseHelp#base_act_welkin_hunt_help.sp_list}];
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
                Content = io_lib:format(t_tv:get(261), [t_tv:pn(Player), t_tv:gn(GoodsId)]),
                notice:add_sys_notice(Content, 261),
                0
        end,
    {NewCount, GoodsId, GoodsNum}.

draw_ten(Player, IsAuto) ->
    GoodsCount = goods_util:get_goods_count(?COST_GOODS_ID),
    case get_act() of
        [] -> {0, Player, []};
        Base ->
            IsEnough = money:is_enough(Player, (Base#base_act_welkin_hunt.goods_cost * max(0, (10 - GoodsCount))), gold),
            if
                GoodsCount < 10 andalso IsAuto == 0 -> {18, Player, []};
                GoodsCount < 10 andalso IsAuto == 1 andalso not IsEnough -> {5, Player, []};
                true ->
                    if
                        GoodsCount >= 10 ->
                            goods:subtract_good(Player, [{?COST_GOODS_ID, 10}], 541),
                            LogCost = 0,
                            NPlayer = Player;
                        true ->
                            goods:subtract_good(Player, [{?COST_GOODS_ID, GoodsCount}], 541),
                            LogCost = Base#base_act_welkin_hunt.goods_cost * max(0, (10 - GoodsCount)),
                            NPlayer = money:add_no_bind_gold(Player, -(Base#base_act_welkin_hunt.goods_cost * max(0, (10 - GoodsCount))), 541, 0, 0)
                    end,
                    goods:subtract_good(Player, [{?COST_GOODS_ID, 10}], 541),
                    RewardList0 = Base#base_act_welkin_hunt.reward_list,
                    St = get_dict(),
                    F = fun(_, {Count, List}) ->
                        {Count0, GoodsId, GoodsNum} = draw_one_help(Player, Count, RewardList0),
                        GoodsType = data_goods:get(GoodsId),
                        if GoodsType#goods_type.color >= 3 ->
                            insert(Base#base_act_welkin_hunt.act_id, Player#player.nickname, [{GoodsId, GoodsNum}]);
                            true -> skip
                        end,
                        {Count0, [{GoodsId, GoodsNum} | List]}
                    end,
                    {NewCount, GoodsList} = lists:foldl(F, {St#st_act_welkin_hunt.count, []}, lists:seq(1, 10)),
                    NewLog = [[Player#player.nickname, GoodsId, GoodsNum] || {GoodsId, GoodsNum} <- GoodsList] ++ St#st_act_welkin_hunt.log_list,
                    NewSt = St#st_act_welkin_hunt{count = NewCount, score = St#st_act_welkin_hunt.score + 10, log_list = lists:sublist(NewLog, 20)},
                    put_dict(NewSt),
                    log_act_welkin_hunt(Player#player.key, Player#player.nickname, Player#player.lv, LogCost, GoodsList),
                    activity_load:dbup_act_welkin_hunt(NewSt),
                    insert(Base#base_act_welkin_hunt.act_id, Player#player.nickname, GoodsList),
                    activity:get_notice(Player, [157], true),
                    {ok, NewPlayer} = goods:give_goods(NPlayer, goods:make_give_goods_list(541, GoodsList)),
                    {1, NewPlayer, [tuple_to_list(X) || X <- GoodsList]}
            end
    end.


get_exchange_info() ->
    case get_act() of
        [] -> [];
        Base ->
            [tuple_to_list(X) || X <- Base#base_act_welkin_hunt.exchange_list]
    end.

exchange(Player, Id) ->
    case get_act() of
        [] -> {0, Player};
        Base ->
            St = get_dict(),
            case check_exchange(Player, Base, Id, St) of
                {false, Res} ->
                    {Res, Player};
                {ok, Score, GoodsId, GoodsNum} ->
                    NewSt = St#st_act_welkin_hunt{score = St#st_act_welkin_hunt.score - Score},
                    put_dict(NewSt),
                    activity_load:dbup_act_welkin_hunt(NewSt),
                    activity:get_notice(Player, [157], true),
                    {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(541, [{GoodsId, GoodsNum}])),
                    {1, NewPlayer}
            end
    end.

check_exchange(_Player, Base, Id, St) ->
    ExchangeList = Base#base_act_welkin_hunt.exchange_list,
    case lists:keyfind(Id, 1, ExchangeList) of
        false -> {false, 0};
        {Id, Score, GoodsId, GoodsNum} ->
            if
                St#st_act_welkin_hunt.score < Score -> {false, 19};
                true ->
                    {ok, Score, GoodsId, GoodsNum}
            end
    end.

buy_goods(Player, Num) ->
    case get_act() of
        [] -> {0, Player};
        Base ->
            case money:is_enough(Player, Base#base_act_welkin_hunt.goods_cost * Num, gold) of
                false ->
                    {5, Player};
                true ->
                    NewPlayer = money:add_no_bind_gold(Player, -Base#base_act_welkin_hunt.goods_cost * Num, 541, ?COST_GOODS_ID, Num),
                    activity:get_notice(Player, [157], true),
                    {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(541, [{?COST_GOODS_ID, Num}])),
                    {1, NewPlayer1}
            end
    end.

get_notice_state(Player) ->
    case get_act() of
        [] -> -1;
        #base_act_welkin_hunt{act_info = ActInfo} = _Base ->
            ExchangeState = get_exchang_state(Player),
            GoodsCount = goods_util:get_goods_count(?COST_GOODS_ID),
            Args = activity:get_base_state(ActInfo),
            if
                GoodsCount > 0 -> {1, Args};
                true ->
                    {ExchangeState, Args}
            end
    end.

get_exchang_state(Player) ->
    case get_act() of
        [] -> -1;
        Base ->
            ExchangeList = Base#base_act_welkin_hunt.exchange_list,
            Ids = [Id || {Id, _, _, _} <- ExchangeList],
            St = get_dict(),
            F = fun(Id) ->
                case check_exchange(Player, Base, Id, St) of
                    {false, _Res} -> false;
                    _ -> true
                end
            end,
            case lists:any(F, Ids) of
                true -> 1;
                _ -> 0
            end
    end.


get_act() ->
    case activity:get_work_list(data_act_welkin_hunt) of
        [] -> [];
        [Base | _] -> Base
    end.

get_leave_time() ->
    LeaveTime = activity:get_leave_time(data_act_welkin_hunt),
    ?IF_ELSE(LeaveTime < 0, 0, LeaveTime).

get_dict() ->
    lib_dict:get(?PROC_STATUS_WELKIN_HUNT).

put_dict(St) ->
    lib_dict:put(?PROC_STATUS_WELKIN_HUNT, St).


init_ets() ->
    ets:new(?ETS_ACT_WELKIN_HUNT, [{keypos, #act_welkin_hunt_log.act_id} | ?ETS_OPTIONS]),
    ok.

get_log() ->
    case get_act() of
        [] ->
            [];
        #base_act_welkin_hunt{act_id = BaseActId} ->
            Ets = look_up(BaseActId),
            LogList = Ets#act_welkin_hunt_log.log,
            lists:sublist(LogList, 15)
    end.

look_up(ActId) ->
    case ets:lookup(?ETS_ACT_WELKIN_HUNT, ActId) of
        [] ->
            ets:insert(?ETS_ACT_WELKIN_HUNT, #act_welkin_hunt_log{act_id = ActId}),
            #act_welkin_hunt_log{act_id = ActId};
        [Ets] ->
            Ets
    end.

insert(ActId, Nickname, GoodsList) ->
    Ets = look_up(ActId),
    NewLog = [[Nickname, GoodsId, GoodsNum] || {GoodsId, GoodsNum} <- GoodsList] ++ Ets#act_welkin_hunt_log.log,
    NewEts = Ets#act_welkin_hunt_log{log = NewLog},
    ets:insert(?ETS_ACT_WELKIN_HUNT, NewEts),
    ok.

log_act_welkin_hunt(Pkey, Nickname, Lv, LogCost, GoodsList) ->
    Sql = io_lib:format("insert into  log_act_welkin_hunt (pkey, nickname,lv,cost,goods_list,time) VALUES(~p,'~s',~p,~p,'~s',~p)",
        [Pkey, Nickname, Lv, LogCost, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql),
    ok.
