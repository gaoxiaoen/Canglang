%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 四月 2016 下午5:41
%%%-------------------------------------------------------------------
-module(daily_acc_charge).
-author("fengzhenlin").

-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    get_acc_charge_info/1,
    get_gift/2
]).

-export([
    init/1,
    update_daily_acc_charge/1,
    get_state/1,
    add_charge_val/2,  %%增加累计充值额度
    get_leave_time/0
]).


init(Player) ->
    AccChargeSt = activity_load:dbget_daily_acc_charge_info(Player),
    lib_dict:put(?PROC_STATUS_DAILY_ACC_CHARGE, AccChargeSt),
    update_daily_acc_charge(Player),
    Player.

%%更新活动信息
update_daily_acc_charge(_Player) ->
    DailyAccChargeSt = lib_dict:get(?PROC_STATUS_DAILY_ACC_CHARGE),
    ActList = activity:get_work_list(data_daily_acc_charge),
    NewDailyAccChargeSt =
        case ActList == [] of %%判断是否新活动
            true -> DailyAccChargeSt;
            false ->
                Base = hd(ActList),
                case Base#base_daily_acc_charge.act_id == DailyAccChargeSt#st_daily_acc_charge.act_id of
                    true -> DailyAccChargeSt;
                    false ->
                        DailyAccChargeSt#st_daily_acc_charge{
                            acc_val = 0,
                            get_acc_ids = [],
                            act_id = Base#base_daily_acc_charge.act_id
                        }
                end
        end,
    lib_dict:put(?PROC_STATUS_DAILY_ACC_CHARGE, NewDailyAccChargeSt),
    ok.

%%获取累计充值信息
get_acc_charge_info(Player) ->
    #player{
        sid = Sid
    } = Player,
    {InfoList, LeaveTime, AccVal} = get_act_info(Player),
    {ok, Bin} = pt_431:write(43121, {LeaveTime, AccVal, InfoList}),
    server_send:send_to_sid(Sid, Bin),
    ok.

%%领取礼包
get_gift(Player, Id) ->
    case check_get_gift(Player, Id) of
        {false, Res} ->
            {false, Res};
        {ok, GiftId} ->
            DailyAccChargeSt = lib_dict:get(?PROC_STATUS_DAILY_ACC_CHARGE),
            #st_daily_acc_charge{
                get_acc_ids = GetAccIds
            } = DailyAccChargeSt,
            GiveGoodsList = goods:make_give_goods_list(141, [{GiftId, 1}]),
            case catch goods:give_goods(Player, GiveGoodsList) of
                {ok, NewPlayer} ->
                    NewGetAccIds = GetAccIds ++ [Id],
                    NewDailyAccChargeSt = DailyAccChargeSt#st_daily_acc_charge{
                        get_acc_ids = NewGetAccIds,
                        time = util:unixtime()
                    },
                    lib_dict:put(?PROC_STATUS_DAILY_ACC_CHARGE, NewDailyAccChargeSt),
                    activity_load:dbup_daily_acc_charge_info(NewDailyAccChargeSt),
                    activity_log:log_get_gift(Player#player.key, Player#player.nickname, GiftId, 1, 115),
                    activity:get_notice(Player, [13], true),
                    {ok, NewPlayer};
                _ ->
                    {false, 0}
            end
    end.
check_get_gift(Player, Id) ->
    DailyAccChargeSt = lib_dict:get(?PROC_STATUS_DAILY_ACC_CHARGE),
    #st_daily_acc_charge{
        get_acc_ids = GetAccIds,
        act_id = ActId,
        acc_val = AccVal
    } = DailyAccChargeSt,
    ActList = activity:get_work_list(data_daily_acc_charge),
    if
        ActList == [] -> {false, 0};
        true ->
            Base = hd(ActList),
            #base_daily_acc_charge{
                act_id = BaseActId,
                gift_list = GiftList
            } = Base,
            IsGet = lists:member(Id, GetAccIds),
            Len = length(GiftList),
            if
                BaseActId =/= ActId ->
                    update_daily_acc_charge(Player),  %%避免活动文件没动态编译好
                    {false, 0};
                IsGet -> {false, 3};
                Id > Len -> {false, 0};
                true ->
                    {NeedChargeVal, GiftId} = lists:nth(Id, GiftList),
                    if
                        AccVal < NeedChargeVal -> {false, 2};
                        true ->
                            {ok, GiftId}
                    end
            end
    end.

%%获取活动状态
get_act_info(_Player) ->
    DailyAccChargeSt = lib_dict:get(?PROC_STATUS_DAILY_ACC_CHARGE),
    ActList = activity:get_work_list(data_daily_acc_charge),
    #st_daily_acc_charge{
        acc_val = AccVal,
        get_acc_ids = GetAccIds
    } = DailyAccChargeSt,
    case ActList of
        [] -> {[], 0, AccVal};  %%没有活动
        [Base | _] ->
            #base_daily_acc_charge{
                gift_list = GiftList
            } = Base,
            LeaveTime = get_leave_time(),
            %%活动礼包信息
            F = fun({ChargeGold, GiftId}, OrderId) ->
                GetState =
                    case lists:member(OrderId, GetAccIds) of
                        true -> 2;
                        false ->
                            case AccVal >= ChargeGold of
                                true -> 1;
                                false -> 0
                            end
                    end,
                {[OrderId, ChargeGold, GiftId, GetState], OrderId + 1}
                end,
            {InfoList, _} = lists:mapfoldl(F, 1, GiftList),
            {InfoList, LeaveTime, AccVal}
    end.

%%获取活动领取状态
get_state(Player) ->
    case activity:get_work_list(data_daily_acc_charge) of
        [] -> -1;
        [Base | _] ->
            {InfoList, LeaveTime, _AccVal} = get_act_info(Player),
            Args = activity:get_base_state(Base#base_daily_acc_charge.act_info),
            if
                LeaveTime == 0 -> {0, Args};
                true ->
                    F = fun([_OrderId, _ChargeGold, _GiftId, GetState]) ->
                        case GetState == 1 of
                            true -> 1;
                            false -> 0
                        end
                        end,
                    case lists:sum(lists:map(F, InfoList)) > 0 of
                        true -> {1, Args};
                        false -> {0, Args}
                    end
            end
    end.

%%增加充值额度
add_charge_val(Player, AddExp) ->
    case get_leave_time() of
        0 ->
            ok;
        true ->
            update_daily_acc_charge(Player),
            DailyAccChargeSt = lib_dict:get(?PROC_STATUS_DAILY_ACC_CHARGE),
            NewDailyAccChargeSt = DailyAccChargeSt#st_daily_acc_charge{
                acc_val = DailyAccChargeSt#st_daily_acc_charge.acc_val + AddExp
            },
            lib_dict:put(?PROC_STATUS_DAILY_ACC_CHARGE, NewDailyAccChargeSt),
            activity_load:dbup_daily_acc_charge_info(NewDailyAccChargeSt),
            ok
    end.

get_leave_time() ->
    ActList = activity:get_work_list(data_daily_acc_charge),
    case ActList of
        [] -> 0;  %%没有活动
        [Base | _] ->
            #base_daily_acc_charge{
                open_info = OpenInfo
            } = Base,
            activity:calc_act_leave_time(OpenInfo)
    end.
