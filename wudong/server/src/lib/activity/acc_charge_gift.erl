%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% 累充礼包-500钻领奖
%%% @end
%%% Created : 12. 五月 2016 下午2:19
%%%-------------------------------------------------------------------
-module(acc_charge_gift).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% 协议
-export([
    get_acc_charge_info/1,
    get_gift/2
]).

%% API
-export([
    init/1,
    update/0,
    add_charge_val/2,
    get_state/1
]).

init(Player) ->
    AccChargeGiftSt = activity_load:dbget_acc_charge_gift(Player),
    lib_dict:put(?PROC_STATUS_ACC_CHARGE_GIFT, AccChargeGiftSt),
    update(),
    Player.

update() ->
    AccChargeGfitSt = lib_dict:get(?PROC_STATUS_ACC_CHARGE_GIFT),
    #st_acc_charge_gift{
        act_id = ActId
    } = AccChargeGfitSt,
    NewAccChargeGfitSt =
        case activity:get_work_list(data_acc_charge_gift) of
            [] -> AccChargeGfitSt;
            [Base | _] ->
                #base_acc_charge_gift{
                    act_id = BaseActId
                } = Base,
                case BaseActId =/= ActId of
                    true ->
                        AccChargeGfitSt#st_acc_charge_gift{
                            act_id = BaseActId,
                            acc_val = 0,
                            times = 0
                        };
                    false ->
                        AccChargeGfitSt
                end
        end,
    lib_dict:put(?PROC_STATUS_ACC_CHARGE_GIFT, NewAccChargeGfitSt),
    ok.

get_acc_charge_info(Player) ->
    AccChargeGiftSt = lib_dict:get(?PROC_STATUS_ACC_CHARGE_GIFT),
    #st_acc_charge_gift{
        acc_val = AccVal
    } = AccChargeGiftSt,
    case activity:get_work_list(data_acc_charge_gift) of
        [] -> skip;
        [Base | _] ->
            #base_acc_charge_gift{
                open_info = OpenInfo,
                charge_val = ChargeVal,
                gift_id = GiftId
            } = Base,
            LeaveTime = activity:calc_act_leave_time(OpenInfo),
            CanGetTimes = calc_leave_gift_times(),
            {ok, Bin} = pt_431:write(43141, {LeaveTime, AccVal, ChargeVal, CanGetTimes, GiftId}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end.

calc_leave_gift_times() ->
    AccChargeGiftSt = lib_dict:get(?PROC_STATUS_ACC_CHARGE_GIFT),
    #st_acc_charge_gift{
        acc_val = AccVal,
        times = Times
    } = AccChargeGiftSt,
    case activity:get_work_list(data_acc_charge_gift) of
        [] -> 0;
        [Base | _] ->
            #base_acc_charge_gift{
                charge_val = ChargeVal
            } = Base,
            max(0, (AccVal div ChargeVal) - Times)
    end.

%%领取奖励
get_gift(Player, Times) ->
    case check_get_gift(Player, Times) of
        {false, Res} ->
            {false, Res};
        {ok, Base} ->
            AccChargeGiftSt = lib_dict:get(?PROC_STATUS_ACC_CHARGE_GIFT),
            NewAccChargeGiftSt = AccChargeGiftSt#st_acc_charge_gift{
                times = AccChargeGiftSt#st_acc_charge_gift.times + Times
            },
            lib_dict:put(?PROC_STATUS_ACC_CHARGE_GIFT, NewAccChargeGiftSt),
            activity_load:dbup_acc_charge_gift(NewAccChargeGiftSt),

            #base_acc_charge_gift{
                gift_id = GiftId
            } = Base,
            GiveGoodsList = goods:make_give_goods_list(149, [{GiftId, Times}]),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            activity:get_notice(Player, [18], true),
            activity_log:log_get_gift(Player#player.key, Player#player.nickname, GiftId, Times, 149),
            {ok, NewPlayer}
    end.
check_get_gift(_Player, Times) ->
    case activity:get_work_list(data_acc_charge_gift) of
        [] -> {false, 0};
        [Base | _] ->
            AccChargeGiftSt = lib_dict:get(?PROC_STATUS_ACC_CHARGE_GIFT),
            #st_acc_charge_gift{
                act_id = ActId
            } = AccChargeGiftSt,
            CanGetTimes = calc_leave_gift_times(),
            if
                ActId =/= Base#base_acc_charge_gift.act_id ->
                    update(),
                    {false, 0};
                Times =< 0 -> {false, 0};
                CanGetTimes =< 0 -> {false, 9};
                CanGetTimes < Times -> {false, 10};
                true ->
                    {ok, Base}
            end
    end.

add_charge_val(Player, AddChargeVal) ->
    case get_state(Player) of
        -1 -> ok;
        _ ->
            AccChargeGiftSt = lib_dict:get(?PROC_STATUS_ACC_CHARGE_GIFT),
            NewAccChargeGiftSt = AccChargeGiftSt#st_acc_charge_gift{
                acc_val = AddChargeVal + AccChargeGiftSt#st_acc_charge_gift.acc_val
            },
            lib_dict:put(?PROC_STATUS_ACC_CHARGE_GIFT, NewAccChargeGiftSt),
            activity_load:dbup_acc_charge_gift(NewAccChargeGiftSt),
            ok
    end.

get_state(Player) ->
    case activity:get_work_list(data_acc_charge_gift) of
        [] -> -1;
        [Base | _] ->
            #base_acc_charge_gift{
                act_info = ActInfo
            } = Base,
            Args = activity:get_base_state(ActInfo),
            case check_get_gift(Player, 1) of
                {false, _Res} ->
                    {0, Args};
                _ ->
                    {1, Args}
            end
    end.