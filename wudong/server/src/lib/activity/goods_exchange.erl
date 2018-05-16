%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 五月 2016 下午12:02
%%%-------------------------------------------------------------------
-module(goods_exchange).
-author("fengzhenlin").
-include("common.hrl").
-include("activity.hrl").
-include("server.hrl").

-export([
    get_goods_exchange_info/1,
    exchange_goods/2,
    is_activity/0,
    get_state/1
]).

%% API
-export([
    init/1,
    update/1
]).

init(Player) ->
    StGoodsExchange = activity_load:dbget_goods_exchange(Player),
    put_dict(StGoodsExchange),
    update(Player),
    Player.

update(Player) ->
    GoodsExchangeSt = get_dict(Player),
    #st_goods_exchange{
        act_id = ActId,
        get_time = GetTime
    } = GoodsExchangeSt,
    NewGoodsExchangeSt =
        case activity:get_work_list(data_goods_exchange) of
            [] -> GoodsExchangeSt;
            [Base | _] ->
                Now = util:unixtime(),
                case Base#base_goods_exchange.act_id == ActId of
                    false ->
                        GoodsExchangeSt#st_goods_exchange{
                            act_id = Base#base_goods_exchange.act_id,
                            get_time = Now,
                            get_list = []
                        };
                    true ->
                        case util:is_same_date(Now, GetTime) of
                            true -> GoodsExchangeSt;
                            false ->
                                GoodsExchangeSt#st_goods_exchange{
                                    get_list = [],
                                    get_time = Now
                                }
                        end
                end
        end,
    put_dict(NewGoodsExchangeSt),
    ok.

%%获取兑换物品活动信息
get_goods_exchange_info(Player) ->
    case activity:get_work_list(data_goods_exchange) of
        [] ->
            skip;
        [Base | _] ->
            GoodsExchangeSt = get_dict(Player),
            #st_goods_exchange{
                get_list = GetList
            } = GoodsExchangeSt,
            LeaveTime = activity:get_leave_time(data_goods_exchange),
            #base_goods_exchange{
                exchange_list = GoodsList
            } = Base,
            F = fun(BaseEG) ->
                #base_ge{
                    id = Id,
                    name = Name,
                    get_goods = {GetGoodsId, GetGoodsNum},
                    max_times = MaxTime,
                    cost_goods = CostGoodsList
                } = BaseEG,
                ExchangeTimes =
                    case lists:keyfind(Id, 1, GetList) of
                        false -> 0;
                        {_, Times} -> Times
                    end,
                Fg = fun({GId, Num}, AccState) ->
                    case AccState of
                        false -> false;
                        true ->
                            case ExchangeTimes >= MaxTime of  %%次数已达上限
                                true -> false;
                                false ->
                                    GC = goods_util:get_goods_count(GId),
                                    GC >= Num
                            end
                    end
                     end,
                State0 = lists:foldl(Fg, true, CostGoodsList),
                State = ?IF_ELSE(State0, 1, 0),
                CostGoodsList1 = [tuple_to_list(Info) || Info <- CostGoodsList],
                [Id, Name, GetGoodsId, GetGoodsNum, ExchangeTimes, MaxTime, State, CostGoodsList1]
                end,
            ExchangeList = lists:map(F, GoodsList),
            Data = {LeaveTime, ExchangeList},
            {ok, Bin} = pt_431:write(43151, Data),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end.

%%兑换物品
exchange_goods(Player, Id) ->
    case check_exchange_goods(Player, Id) of
        {false, Res} ->
            {false, Res};
        {ok, BaseEG} ->
            #base_ge{
                get_goods = {GetGoodsId, GetGoodsNum},
                cost_goods = CostGoodsList
            } = BaseEG,
            %%先扣物品
            case goods:subtract_good(Player, CostGoodsList, 158) of
                {false, _} -> {false, 0};
                {ok, _NewGoodsStatus} ->
                    GiveGoodsList = goods:make_give_goods_list(158, [{GetGoodsId, GetGoodsNum}]),
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                    GoodsExchangeSt = get_dict(Player),
                    #st_goods_exchange{
                        get_list = GetList
                    } = GoodsExchangeSt,
                    NewGetList =
                        case lists:keyfind(Id, 1, GetList) of
                            false -> [{Id, 1} | GetList];
                            {_, OldTimes} -> [{Id, OldTimes + 1} | lists:keydelete(Id, 1, GetList)]
                        end,
                    Now = util:unixtime(),
                    NewGoodsExchangeSt = GoodsExchangeSt#st_goods_exchange{
                        get_list = NewGetList,
                        get_time = Now
                    },
                    put_dict(NewGoodsExchangeSt),
                    activity_load:dbup_goods_exchange(NewGoodsExchangeSt),
                    activity:get_notice(Player, [19], true),
                    activity_log:log_get_gift(Player#player.key, Player#player.nickname, GetGoodsId, GetGoodsNum, 158),
                    {ok, NewPlayer}

            end
    end.

check_exchange_goods(Player, Id) ->
    GoodsExchangeSt = get_dict(Player),
    #st_goods_exchange{
        act_id = Actid,
        get_list = GetList
    } = GoodsExchangeSt,
    case activity:get_work_list(data_goods_exchange) of
        [] -> {false, 0};
        [Base | _] ->
            #base_goods_exchange{
                act_id = BaseActid,
                exchange_list = ExchangeList
            } = Base,
            if
                Actid =/= BaseActid ->
                    init(Player),
                    {false, 0};
                true ->
                    case lists:keyfind(Id, #base_ge.id, ExchangeList) of
                        false -> {false, 0};
                        BaseEG ->
                            #base_ge{
                                max_times = MaxTimes,
                                cost_goods = CostGoodsList
                            } = BaseEG,
                            ExchangeTimes =
                                case lists:keyfind(Id, 1, GetList) of
                                    false -> 0;
                                    {_, Times} -> Times
                                end,
                            if
                                ExchangeTimes >= MaxTimes -> {false, 11};
                                true ->
                                    %%检查物品
                                    case check_exchange_goods_1(CostGoodsList) of
                                        false -> {false, 12};
                                        true ->
                                            {ok, BaseEG}
                                    end
                            end
                    end
            end
    end.
check_exchange_goods_1([]) -> true;
check_exchange_goods_1([{GoodsId, Num} | Tail]) ->
    GoodsCount = goods_util:get_goods_count(GoodsId),
    case GoodsCount >= Num of
        true -> check_exchange_goods_1(Tail);
        false -> false
    end.

get_dict(Player) ->
    case lib_dict:get(?PROC_STATUS_GOODS_EXCHANGE) of
        St when is_record(St, st_goods_exchange) ->
            St;
        _ ->
            init(Player),
            get_dict(Player)
    end.

put_dict(StGoodsExchange) ->
    lib_dict:put(?PROC_STATUS_GOODS_EXCHANGE, StGoodsExchange).

%%是否活动中
is_activity() ->
    case activity:get_work_list(data_goods_exchange) of
        [] -> false;
        _ -> true
    end.

%%获取领取状态
get_state(Player) ->
    case activity:get_work_list(data_goods_exchange) of
        [] -> -1;
        [Base | _] ->
            F = fun(Id) ->
                case check_exchange_goods(Player, Id) of
                    {false, _} -> false;
                    _ -> true
                end
                end,
            Args = activity:get_base_state(Base#base_goods_exchange.act_info),
            case lists:any(F, lists:seq(1, length(Base#base_goods_exchange.exchange_list))) of
                true -> {1, Args};
                false -> {0, Args}
            end
    end.