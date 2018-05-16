%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% 每日抽奖
%%% @end
%%% Created : 11. 一月 2016 下午6:34
%%%-------------------------------------------------------------------
-module(daily_charge).
-author("fengzhenlin").
-include("server.hrl").
-include("activity.hrl").
-include("common.hrl").

%%协议接口
-export([
    get_daily_charge_info/1,
    get_gift/1,
    exchange/1
]).

%% API
-export([
    init/1,
    update_charge/0,
    log_daily_charge/3,
    get_state/0,
    get_leave_time/0
]).

init(Player) ->
    DailyChargeSt = activity_load:dbget_daily_charge(Player),
    lib_dict:put(?PROC_STATUS_DAILY_CHARGE, DailyChargeSt),
    Player.

%%获取每日充值信息
get_daily_charge_info(Player) ->
    ActList = activity:get_work_list(data_daily_charge),
    if
        ActList == [] -> {false, 0};
        true ->
            Act = hd(ActList),
            State = get_gift_state(),
            #base_daily_charge{
                goods_list = GoodsList,
                get_exchange = {GetExGoodId, GetExGoodsNum},
                exchage_goods = {ExGoodsId, ExGoodsNum, NeedNum}
            } = Act,
            GoodsIdNumList = [[GoodsId, Num] || {GoodsId, Num, _Pro} <- GoodsList],
            Records = get_daily_charge_record(),
            LeaveTime = get_leave_time(),
            {ok, Bin} = pt_430:write(43021, {LeaveTime, State, GoodsIdNumList, GetExGoodId, GetExGoodsNum, ExGoodsId, ExGoodsNum, NeedNum, Records}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end.

get_leave_time() ->
    ActList = activity:get_work_list(data_daily_charge),
    if
        ActList == [] -> -1;
        true ->
            Act = hd(ActList),
            #base_daily_charge{
                open_info = OpenInfo
            } = Act,
            activity:calc_act_leave_time(OpenInfo)
    end.

%%抽奖
get_gift(Player) ->
    case check_get_gift(Player) of
        {false, Res} ->
            {false, Res};
        {ok, Base} ->
            #base_daily_charge{
                goods_list = GoodsList,
                get_exchange = {GetExGoodsId, GetExGoodsNum}
            } = Base,
            %%给抽到的物品和额外给的兑换物品
            ProList = [{{GoodsId, Num}, Pro} || {GoodsId, Num, Pro} <- GoodsList],
            {Gid, Gnum} = util:list_rand_ratio(ProList),
            GiveGoodsList = goods:make_give_goods_list(113, [{Gid, Gnum}, {GetExGoodsId, GetExGoodsNum}]),
            case goods:give_goods(Player, GiveGoodsList) of
                {ok, NewPlayer} ->
                    DailyChargeSt = lib_dict:get(?PROC_STATUS_DAILY_CHARGE),
                    Now = util:unixtime(),
                    NewDailyChargeSt = DailyChargeSt#st_daily_charge{
                        get_list = DailyChargeSt#st_daily_charge.get_list ++ [Now]
                    },
                    lib_dict:put(?PROC_STATUS_DAILY_CHARGE, NewDailyChargeSt),
                    activity_load:dbup_daily_charge(NewDailyChargeSt),
                    add_daily_charge_record(Player, Gid),
                    activity_log:log_get_gift(Player#player.key, Player#player.nickname, Gid, Gnum, 113),
                    activity:get_notice(Player, [3], true),
                    del_log_record(),
                    {ok, NewPlayer, Gid, Gnum};
                _Err ->
                    ?ERR("daily_charge get_gift give goods err ~p~n", [_Err]),
                    {false, 0}
            end
    end.
check_get_gift(_Player) ->
    State = get_gift_state(),
    ActList = activity:get_work_list(data_daily_charge),
    if
        ActList == [] -> {false, 0};
        State =/= 1 -> {false, 7};
        true ->
            Act = hd(ActList),
            {ok, Act}
    end.

%%兑换
exchange(Player) ->
    case check_exchange(Player) of
        {false, Res} ->
            {false, Res};
        {ok, Base} ->
            #base_daily_charge{
                get_exchange = {GetExGoodsId, _GetExGoodsNum},
                exchage_goods = {ExGoodsId, ExGoodsNum, NeedNum}
            } = Base,
            case goods:subtract_good(Player, [{GetExGoodsId, NeedNum}], 114) of
                {false, _} ->
                    {false, 0};
                _ ->
                    GiveGoodsList = goods:make_give_goods_list(114, [{ExGoodsId, ExGoodsNum}]),
                    case goods:give_goods(Player, GiveGoodsList) of
                        {ok, NewPlayer} ->
                            activity_log:log_get_gift(Player#player.key, Player#player.nickname, ExGoodsId, ExGoodsNum, 114),
                            {ok, NewPlayer};
                        _Err ->
                            ?ERR("daily_charge exchange give goods err ~p~n", [_Err]),
                            {false, 0}
                    end
            end
    end.
check_exchange(_Player) ->
    ActList = activity:get_work_list(data_daily_charge),
    if
        ActList == [] -> {false, 0};
        true ->
            Act = hd(ActList),
            #base_daily_charge{
                get_exchange = {GetExGoodsId, _GetExGoodsNum},
                exchage_goods = {_ExGoodsId, _ExGoodsNum, NeedNum}
            } = Act,
            Count = goods_util:get_goods_count(GetExGoodsId),
            if
                Count < NeedNum -> {false, 8};
                true ->
                    {ok, Act}
            end
    end.

%%获取抽奖状态
get_gift_state() ->
    DailyChargeSt = lib_dict:get(?PROC_STATUS_DAILY_CHARGE),
    Now = util:unixtime(),
    #st_daily_charge{
        get_list = GetList,
        last_charge_time = LastChargeTime
    } = DailyChargeSt,
    LastGetTime =
        case lists:sort(GetList) of
            [] -> 0;
            SortL -> lists:last(SortL)
        end,
    State =
        case LastChargeTime == 0 of
            true -> 0;
            false ->
                case util:is_same_date(Now, LastGetTime) of
                    true -> 2;
                    false ->
                        case util:is_same_date(Now, LastChargeTime) of
                            true -> 1;
                            false -> 0
                        end
                end
        end,
    State.

%%充值更新
update_charge() ->
    DailyChargeSt = lib_dict:get(?PROC_STATUS_DAILY_CHARGE),
    Now = util:unixtime(),
    NewDailyChargeSt = DailyChargeSt#st_daily_charge{
        last_charge_time = Now
    },
    lib_dict:put(?PROC_STATUS_DAILY_CHARGE, NewDailyChargeSt),
    ok.

%%增加抽奖记录
add_daily_charge_record(Player, GoodsId) ->
    Pid = activity_proc:get_act_pid(),
    Pid ! {add_daily_charge_record, Player#player.key, Player#player.nickname, GoodsId},
    daily_charge:log_daily_charge(Player#player.key, Player#player.nickname, GoodsId),
    ok.

%%获取抽奖记录
get_daily_charge_record() ->
    Now = util:unixtime(),
    case get(get_daily_charge_record) of
        undefined ->
            Pid = activity_proc:get_act_pid(),
            case ?CALL(Pid, get_daily_charge_record) of
                [] -> [];
                Records ->
                    L = [[Pkey, Name, GoodsId] || {Pkey, Name, GoodsId} <- Records],
                    put(get_daily_charge_record, {L, Now}),
                    L
            end;
        {L, Time} ->
            case Now - Time > 100 of
                true ->
                    put(get_daily_charge_record, undefined),
                    get_daily_charge_record();
                false ->
                    L
            end
    end.

del_log_record() ->
    put(get_daily_charge_record, undefined).

%%获取可领取状态
get_state() ->
    GetGiftState = get_gift_state(),
    ActList = activity:get_work_list(data_daily_charge),
    if
        ActList == [] -> -1;
        true ->
            [Base | _] = ActList,
            #base_daily_charge{act_info = ActInfo} = Base,
            Args = activity:get_base_state(ActInfo),
            case GetGiftState == 1 of
                true -> {1, Args};
                false -> {0, Args}
            end
    end.


%%log抽奖
log_daily_charge(Pkey, Name, GoodsId) ->
    Sql = io_lib:format("insert into log_daily_charge set pkey=~p,nickname='~s',goods_id=~p,time=~p",
        [Pkey, Name, GoodsId, util:unixtime()]),
    log_proc:log(Sql),
    ok.