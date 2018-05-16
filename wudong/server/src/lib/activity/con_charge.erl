%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 六月 2016 下午8:52
%%%-------------------------------------------------------------------
-module(con_charge).
-author("fengzhenlin").

-include("server.hrl").
-include("activity.hrl").
-include("common.hrl").

%%协议接口
-export([
    get_con_charge_info/1,
    get_gift/2
]).

%% API
-export([
    init/1,
    update/1,
    add_charge/2,
    get_state/1
]).

init(Player) ->
    StConCharge = activity_load:dbget_con_charge(Player),
    put_dict(StConCharge),
    update(Player),
    Player.

update(_Player) ->
    StConCharge = get_dict(),
    #st_con_charge{
        act_id = ActId
    } = StConCharge,
    NewStConCharge =
        case get_act() of
            [] -> StConCharge;
            Base ->
                #base_con_charge{
                    act_id = BaseActId,
                    goods_list = GoodsList
                } = Base,
                Now = util:unixtime(),
                case ActId == BaseActId of
                    true ->
                        %%充值没达标的清掉
                        F = fun({ChargeVal, Time}, Day) ->
                            NewDay = Day + 1,
                            case Day > length(GoodsList) of
                                true -> {[], NewDay};
                                false ->
                                    {NeedChargeVal, _GiftId} = lists:nth(Day, GoodsList),
                                    case util:is_same_date(Time, Now) of
                                        true -> {[{ChargeVal, Time}], NewDay};
                                        false ->
                                            case ChargeVal >= NeedChargeVal of
                                                true -> {[{ChargeVal, Time}], NewDay};
                                                false -> {[], NewDay}
                                            end
                                    end
                            end
                            end,
                        {ChargeList0, _} = lists:mapfoldl(F, 1, StConCharge#st_con_charge.charge_list),
                        ChargeList = lists:flatten(ChargeList0),
                        StConCharge#st_con_charge{charge_list = ChargeList};
                    false ->
                        StConCharge#st_con_charge{
                            act_id = BaseActId,
                            charge_list = [],
                            get_list = [],
                            update_time = Now,
                            get_gift_time = 0
                        }
                end
        end,
    put_dict(NewStConCharge),
    ok.

get_con_charge_info(Player) ->
    case get_act() of
        [] -> skip;
        Base ->
            StConCharge = get_dict(),
            #st_con_charge{
                charge_list = ChargeList,
                get_list = GetList,
                get_gift_time = GetGiftTime
            } = StConCharge,
            #base_con_charge{
                open_info = OpenInfo,
                goods_list = GoodsList,
                last_gift_id = LastGiftId
            } = Base,
            Now = util:unixtime(),
            CurDay =
                case GetList of
                    [] -> 1;
                    _ ->
                        {Day, GetTime} = lists:last(lists:keysort(2, GetList)),
                        case util:is_same_date(Now, GetTime) of
                            true -> Day;
                            false -> min(Day + 1, length(GoodsList))
                        end
                end,
            LeaveTime = activity:calc_act_leave_time(OpenInfo),
            InfoList = get_state_list(),
            LastGiftState =
                case length(ChargeList) >= length(GoodsList) of
                    true ->
                        case GetGiftTime > 0 of
                            true -> 2;
                            false -> 1
                        end;
                    false -> 0
                end,
            {ok, Bin} = pt_431:write(43171, {LeaveTime, CurDay, InfoList, LastGiftId, LastGiftState}),
            server_send:send_to_sid(Player#player.sid, Bin)
    end.

get_gift(Player, Day) ->
    case check_get_gift(Player, Day) of
        {false, Res} ->
            {false, Res};
        {ok, GiftId} ->
            Now = util:unixtime(),
            StConCharge = get_dict(),
            NewStConCharge =
                case Day of
                    0 -> %%终极礼包
                        StConCharge#st_con_charge{
                            get_gift_time = Now
                        };
                    _ -> %%普通礼包
                        StConCharge#st_con_charge{
                            get_list = StConCharge#st_con_charge.get_list ++ [{Day, Now}]
                        }
                end,
            NewStConCharge1 = NewStConCharge#st_con_charge{
                update_time = Now
            },
            put_dict(NewStConCharge1),
            activity_load:dbup_con_charge(NewStConCharge1),
            GiveGoodsList = goods:make_give_goods_list(166, [{GiftId, 1}]),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            activity_log:log_get_gift(Player#player.key, Player#player.nickname, GiftId, 1, 166),
            activity:get_notice(Player, [21], true),
            {ok, NewPlayer}
    end.
check_get_gift(_Player, Day) ->
    case get_act() of
        [] -> {false, 0};
        Base ->
            StConCharge = get_dict(),
            #st_con_charge{
                get_gift_time = GetLastGiftTime
            } = StConCharge,
            #base_con_charge{
                goods_list = GoodsList,
                last_gift_id = LastGiftId
            } = Base,
            StateList = get_state_list(),
            StateList1 = [list_to_tuple(Info) || Info <- StateList],
            case lists:keyfind(Day, 1, StateList1) of
                false ->
                    case Day == 0 of
                        true -> %%终极礼包
                            if
                                GetLastGiftTime > 0 -> {false, 3};
                                true ->
                                    F = fun(StateInfo) ->
                                        State = lists:last(StateInfo),
                                        case State =/= 0 of
                                            true -> [State];
                                            false -> []
                                        end
                                        end,
                                    GetStateList = lists:flatmap(F, StateList),
                                    case length(GetStateList) >= length(GoodsList) of
                                        true -> {ok, LastGiftId};
                                        false -> {false, 2}
                                    end
                            end;
                        false ->
                            {false, 0}
                    end;
                {Day, _ChargeVal, _NeedChargeVal, GiftId, State} ->
                    if
                        State == 0 -> {false, 2};
                        State == 2 -> {false, 3};
                        true ->
                            {ok, GiftId}
                    end
            end
    end.

get_state_list() ->
    Base = get_act(),
    StConCharge = get_dict(),
    #st_con_charge{
        charge_list = ChargeList,
        get_list = GetList
    } = StConCharge,
    #base_con_charge{
        goods_list = GoodsList
    } = Base,
    SortChargeList = lists:keysort(2, ChargeList),
    ChargeDays = length(ChargeList),
    F = fun(Day) ->
        ChargeVal =
            case Day > ChargeDays of
                true -> 0;
                false ->
                    {HaveChargeVal, _Time} = lists:nth(Day, SortChargeList),
                    HaveChargeVal
            end,
        {NeedChargeVal, GiftId} = lists:nth(Day, GoodsList),
        State =
            case lists:keyfind(Day, 1, GetList) of
                false ->
                    case ChargeVal >= NeedChargeVal of
                        true -> 1;
                        false -> 0
                    end;
                _ ->
                    2
            end,
        [Day, ChargeVal, NeedChargeVal, GiftId, State]
        end,
    lists:map(F, lists:seq(1, length(GoodsList))).

get_dict() ->
    lib_dict:get(?PROC_STATUS_CON_CHARGE).

put_dict(StConCharge) ->
    lib_dict:put(?PROC_STATUS_CON_CHARGE, StConCharge).

get_act() ->
    case activity:get_work_list(data_con_charge) of
        [] -> [];
        [Base | _] -> Base
    end.

add_charge(_Player, ChargeVal) ->
    case get_act() of
        [] -> skip;
        _Base ->
            StConCharge = get_dict(),
            #st_con_charge{
                charge_list = ChargeList
            } = StConCharge,
            Now = util:unixtime(),
            NewChargeList =
                case ChargeList of
                    [] ->
                        [{ChargeVal, Now}];
                    _ ->
                        SortList = lists:reverse(lists:keysort(2, ChargeList)),
                        [{LastChargeVal, LastTime} | Tail] = SortList,
                        case util:is_same_date(LastTime, Now) of
                            true ->
                                lists:reverse([{LastChargeVal + ChargeVal, Now} | Tail]);
                            false ->
                                ChargeList ++ [{ChargeVal, Now}]
                        end
                end,
            NewStConCharge = StConCharge#st_con_charge{
                charge_list = NewChargeList
            },
            put_dict(NewStConCharge),
            activity_load:dbup_con_charge(NewStConCharge),
            ok
    end.

get_state(_Player) ->
    case get_act() of
        [] -> -1;
        Base ->
            StateList = get_state_list(),
            F = fun(StateInfo) ->
                State = lists:last(StateInfo),
                case State == 1 of
                    true -> [State];
                    false -> []
                end
                end,
            StateList1 = lists:flatmap(F, StateList),
            StConCharge = get_dict(),
            #st_con_charge{
                charge_list = ChargeList,
                get_gift_time = GetGiftTime
            } = StConCharge,
            #base_con_charge{
                act_info = ActInfo,
                goods_list = GoodsList
            } = Base,
            LastGiftState =
                case length(ChargeList) >= length(GoodsList) of
                    true ->
                        case GetGiftTime > 0 of
                            true -> [];
                            false -> [1]
                        end;
                    false -> []
                end,
            StateList2 = StateList1 ++ LastGiftState,
            Args = activity:get_base_state(ActInfo),
            case StateList2 == [] of
                true -> {0, Args};
                false -> {1, Args}
            end
    end.