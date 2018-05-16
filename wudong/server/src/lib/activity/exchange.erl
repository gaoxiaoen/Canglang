%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 三月 2016 下午8:25
%%%-------------------------------------------------------------------
-module(exchange).
-author("fengzhenlin").
-include("server.hrl").
-include("activity.hrl").
-include("common.hrl").

%%协议接口
-export([
    get_exchange_info/1,
    get_gift/2
]).

%% API
-export([
    init/1,
    update/0,
    get_state/1,
    get_leave_time/0
]).

-define(EXCHANGE_GOODS_ID, 29090).  %%兑换水晶id

init(Player) ->
    ExchangeSt = activity_load:dbget_exchange(Player),
    lib_dict:put(?PROC_STATUS_EXCHANGE, ExchangeSt),
    update(),
    Player.

update() ->
    ExchangeSt = lib_dict:get(?PROC_STATUS_EXCHANGE),
    #st_exchange{
        act_id = ActId
    } = ExchangeSt,
    NewExchangeSt =
        case activity:get_work_list(data_exchange) of
            [] -> ExchangeSt;
            [Base | _] ->
                #base_exchange{
                    act_id = BaseActId
                } = Base,
                case BaseActId =/= ActId of
                    true -> %%新活动
                        ExchangeSt#st_exchange{
                            act_id = BaseActId,
                            get_list = []
                        };
                    false ->
                        ExchangeSt
                end
        end,
    lib_dict:put(?PROC_STATUS_EXCHANGE, NewExchangeSt),
    ok.

get_exchange_info(Player) ->
    {LeaveTime, GoodsCount, GiftInfoList} = get_exchange_info_list(Player),
    {ok, Bin} = pt_431:write(43101, {LeaveTime, GoodsCount, GiftInfoList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

get_exchange_info_list(_Player) ->
    GoodsCount = goods_util:get_goods_count(?EXCHANGE_GOODS_ID),
    ExchangeSt = lib_dict:get(?PROC_STATUS_EXCHANGE),
    #st_exchange{
        get_list = GetList
    } = ExchangeSt,
    ActList = activity:get_work_list(data_exchange),
    if
        ActList == [] -> {0, GoodsCount, []};
        true ->
            Base = hd(ActList),
            #base_exchange{
                open_info = OpenInfo,
                gift_list = GiftList
            } = Base,
            F = fun({NeedNum, GiftId}, AccId) ->
                State =
                    case lists:member(NeedNum, GetList) of
                        true -> 2;
                        false ->
                            case NeedNum > GoodsCount of
                                true -> 0;
                                false -> 1
                            end
                    end,
                {[AccId, NeedNum, GiftId, State], AccId + 1}
                end,
            LeaveTime = activity:calc_act_leave_time(OpenInfo),
            {GiftInfoList, _} = lists:mapfoldl(F, 1, GiftList),
            {LeaveTime, GoodsCount, GiftInfoList}
    end.

get_gift(Player, ExchangeId) ->
    case check_get_gift(Player, ExchangeId) of
        {false, Res} ->
            {false, Res};
        {ok, GiftId, CostNum} ->
            case goods:subtract_good(Player, [{?EXCHANGE_GOODS_ID, CostNum}], 135) of
                {false, _} -> {false, 0};
                _ ->
                    ExchangeSt = lib_dict:get(?PROC_STATUS_EXCHANGE),
%%                     #st_exchange{
%%                         get_list = GetList
%%                     } = ExchangeSt,
%%                     NewGetList = GetList ++ [ExchangeNum],
                    NewExchangeSt = ExchangeSt#st_exchange{
                        get_list = []
                    },
                    lib_dict:put(?PROC_STATUS_EXCHANGE, NewExchangeSt),
                    activity_load:dbup_exchange(NewExchangeSt),
                    GiveGoodsList = goods:make_give_goods_list(135, [{GiftId, 1}]),
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                    activity:get_notice(Player, [10], true),
                    {ok, NewPlayer}
            end
    end.
check_get_gift(_Player, ExchangeId) ->
    GoodsCount = goods_util:get_goods_count(?EXCHANGE_GOODS_ID),
    ExchangeSt = lib_dict:get(?PROC_STATUS_EXCHANGE),
    #st_exchange{
        act_id = ActId
    } = ExchangeSt,
    ActList = activity:get_work_list(data_exchange),
    if
        ActList == [] -> {false, 0};
        true ->
            Base = hd(ActList),
            #base_exchange{
                act_id = BaseActId,
                gift_list = GiftList
            } = Base,
            if
                ActId =/= BaseActId -> update(), {false, 0};
                true ->
                    case ExchangeId > length(GiftList) orelse ExchangeId =< 0 of
                        true -> {false, 0};
                        false ->
                            {ExchangeNum, GiftId} = lists:nth(ExchangeId, GiftList),
                            if
                                GoodsCount < ExchangeNum -> {false, 7};
                                true ->
                                    {ok, GiftId, ExchangeNum}
                            end
                    end
            end
    end.

get_state(Player) ->
    case activity:get_work_list(data_exchange) of
        [] -> -1;
        [Base | _] ->
            {_LeaveTime, _GoodsCount, StateList} = get_exchange_info_list(Player),
            F = fun(L) ->
                case lists:last(L) == 1 of
                    true -> 1;
                    false -> 0
                end
                end,
            Args = activity:get_base_state(Base#base_exchange.act_info),
            case lists:sum(lists:map(F, StateList)) > 0 of
                true -> {1, Args};
                false -> {0, Args}
            end
    end.

get_leave_time() ->
    ActList = activity:get_work_list(data_exchange),
    if
        ActList == [] -> -1;
        true ->
            Base = hd(ActList),
            #base_exchange{
                open_info = OpenInfo
            } = Base,
            activity:calc_act_leave_time(OpenInfo)
    end.