%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 三月 2016 下午1:36
%%%-------------------------------------------------------------------
-module(new_daily_charge).
-author("fengzhenlin").
-include("activity.hrl").
-include("common.hrl").
-include("server.hrl").

%%协议接口
-export([
    get_new_daily_charge_info/1,
    get_gift/1
]).

%% API
-export([
    init/1,
    update_charge/0,
    get_state/1,
    get_leave_time/0
]).

init(Player) ->
    NewDCSt = activity_load:dbget_new_daily_charge(Player),
    lib_dict:put(?PROC_STATUS_NEW_DAILY_CHARGE, NewDCSt),
    Player.

get_new_daily_charge_info(Player) ->
    State = get_act_state(),
    {GiftId, LeaveTime} =
        case activity:get_work_list(data_new_daily_charge) of
            [] -> {0, 0};
            [Base | _] ->
                LTime = activity:calc_act_leave_time(Base#base_new_daily_charge.open_info),
                {Base#base_new_daily_charge.gift_id, LTime}
        end,
    {ok, Bin} = pt_430:write(43081, {State, GiftId, LeaveTime}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

get_act_state() ->
    NewDCSt = lib_dict:get(?PROC_STATUS_NEW_DAILY_CHARGE),
    #st_new_daily_charge{
        get_time = GetTime,
        last_charge_time = LastChargeTime
    } = NewDCSt,
    case activity:get_work_list(data_new_daily_charge) of
        [] -> 0;
        [_Base | _] ->
            Now = util:unixtime(),
            case util:is_same_date(GetTime, Now) of
                true -> 2;
                false ->
                    case util:is_same_date(LastChargeTime, Now) of
                        true -> 1;
                        false -> 0
                    end
            end
    end.


get_gift(Player) ->
    case check_get_gift(Player) of
        {false, Res} ->
            {false, Res};
        {ok, GiftId} ->
            NewDCSt = lib_dict:get(?PROC_STATUS_NEW_DAILY_CHARGE),
            Now = util:unixtime(),
            NewDCSt1 = NewDCSt#st_new_daily_charge{
                get_time = Now
            },
            lib_dict:put(?PROC_STATUS_NEW_DAILY_CHARGE, NewDCSt1),
            activity_load:dbup_new_daily_charge(NewDCSt1),
            GiveGoodsList = goods:make_give_goods_list(132, [{GiftId, 1}]),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            activity_log:log_get_gift(Player#player.key, Player#player.nickname, GiftId, 1, 132),
            activity:get_notice(Player, [7], true),
            {ok, NewPlayer}
    end.
check_get_gift(_Player) ->
    State = get_act_state(),
    if
        State == 0 -> {false, 2};
        State == 2 -> {false, 3};
        State =/= 1 -> {false, 2};
        true ->
            case activity:get_work_list(data_new_daily_charge) of
                [] -> {false, 0};
                [Base | _] ->
                    {ok, Base#base_new_daily_charge.gift_id}
            end
    end.

%%充值更新
update_charge() ->
    NewDcSt = lib_dict:get(?PROC_STATUS_NEW_DAILY_CHARGE),
    Now = util:unixtime(),
    NewDcSt1 = NewDcSt#st_new_daily_charge{
        last_charge_time = Now
    },
    lib_dict:put(?PROC_STATUS_NEW_DAILY_CHARGE, NewDcSt1),
    ok.

get_state(_Player) ->
    case activity:get_work_list(data_new_daily_charge) of
        [] -> -1;
        [Base | _] ->
            Args = activity:get_base_state(Base#base_new_daily_charge.act_info),
            case get_act_state() of
                1 -> {1, Args};
                _ -> {0, Args}
            end
    end.

get_leave_time() ->
    case activity:get_work_list(data_new_daily_charge) of
        [] -> -1;
        [Base | _] ->
            activity:calc_act_leave_time(Base#base_new_daily_charge.open_info)
    end.