%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 七月 2016 下午1:47
%%%-------------------------------------------------------------------
-module(merge_sign_in).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%%协议接口
-export([
    get_info/1,
    get_gift/3
]).

%% API
-export([
    init/1,
    update/1,
    add_charge/2,
    get_state/1
]).

-define(SIGN_IN_DAY, 5).

init(Player) ->
    St = activity_load:dbget_merge_sign_in(Player),
    put_dict(St),
    update(Player),
    Player.

update(_Player) ->
    St = get_dict(),
    #st_merge_sign_in{
        act_id = ActId,
        get_list = GetList,
        charge_list = ChargeList,
        update_time = UpdateTime
    } = St,
    NewSt =
        case get_act() of
            [] -> St;
            Base ->
                Now = util:unixtime(),
                #base_merge_sign_in{
                    act_id = BaseActId,
                    charge_goods_list = ChargeGoodsList
                } = Base,
                case ActId =/= BaseActId of
                    true ->
                        St#st_merge_sign_in{
                            act_id = BaseActId,
                            get_list = [{1, 0, 1}],
                            get_gift_time = 0,
                            charge_list = [],
                            charge_get_list = [],
                            charge_gift_time = 0,
                            update_time = Now
                        };
                    false ->
                        case util:is_same_date(Now, UpdateTime) of
                            true -> St;
                            false ->
                                %%普通签到处理
                                NewGetList =
                                    case update_1(GetList, Now, 1) of
                                        [] -> GetList;
                                        Day -> GetList ++ [{Day, 0, 1}]
                                    end,
                                %%至尊签到处理 充值没达标的清掉
                                F = fun({ChargeVal, Time}, Day) ->
                                    NewDay = Day + 1,
                                    case Day > length(ChargeGoodsList) of
                                        true -> {[], NewDay};
                                        false ->
                                            {NeedChargeVal, _GiftId} = lists:nth(Day, ChargeGoodsList),
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
                                {ChargeList0, _} = lists:mapfoldl(F, 1, ChargeList),
                                NewChargeList = lists:flatten(ChargeList0),
                                St#st_merge_sign_in{
                                    get_list = NewGetList,
                                    charge_list = NewChargeList
                                }
                        end
                end
        end,
    put_dict(NewSt),
    ok.

update_1(_GetList, _Now, ?SIGN_IN_DAY + 1) -> [];
update_1(GetList, Now, Day) ->
    case lists:keyfind(Day, 1, GetList) of
        false -> Day;
        _ -> update_1(GetList, Now, Day + 1)
    end.

get_info(Player) ->
    case get_act() of
        [] -> skip;
        Base ->
            #base_merge_sign_in{
                goods_list = GoodsList,
                last_gift_id = LastGiftId,
                charge_goods_list = ChargeGoodsList,
                charge_last_gift_id = ChargeLastGiftId
            } = Base,
            St = get_dict(),
            #st_merge_sign_in{
                get_list = GetList,
                get_gift_time = GetGiftTime,
                charge_list = ChargeList,
                charge_get_list = ChargeGetList
            } = St,
            LeaveTime = activity:calc_act_leave_time(Base#base_merge_sign_in.open_info),
            %%普通签到
            CurDay = length(GetList),
            SignInList = get_state_list(),
            LastGiftState =
                case GetGiftTime > 0 of
                    true -> 2;
                    false -> ?IF_ELSE(length(GetList) >= ?SIGN_IN_DAY, 1, 0)
                end,

            %%至尊签到
            Now = util:unixtime(),
            ZZCurDay =
                case ChargeGetList of
                    [] -> 1;
                    _ ->
                        {Day, GetTime} = lists:last(lists:keysort(2, ChargeGetList)),
                        case util:is_same_date(Now, GetTime) of
                            true -> Day;
                            false -> min(Day + 1, length(ChargeGoodsList))
                        end
                end,
            ZZSignInList = get_charge_state_list(),
            ZZLastGiftState =
                case length(ChargeList) >= length(GoodsList) of
                    true ->
                        case GetGiftTime > 0 of
                            true -> 2;
                            false -> 1
                        end;
                    false -> 0
                end,
            Data = {LeaveTime, CurDay, SignInList, LastGiftId, LastGiftState, ZZCurDay, ZZSignInList, ChargeLastGiftId, ZZLastGiftState},
            {ok, Bin} = pt_432:write(43201, Data),
            server_send:send_to_sid(Player#player.sid, Bin)
    end.

get_state_list() ->
    Base = get_act(),
    St = get_dict(),
    #base_merge_sign_in{
        goods_list = GoodsList
    } = Base,
    St = get_dict(),
    #st_merge_sign_in{
        get_list = GetList
    } = St,
    F = fun(Day) ->
        GiftId = lists:nth(Day, GoodsList),
        case lists:keyfind(Day, 1, GetList) of
            false -> [Day, GiftId, 0];
            {Day, _Time, State} -> [Day, GiftId, State]
        end
        end,
    lists:map(F, lists:seq(1, ?SIGN_IN_DAY)).

get_charge_state_list() ->
    Base = get_act(),
    St = get_dict(),
    #st_merge_sign_in{
        charge_list = ChargeList,
        charge_get_list = ChargeGetList
    } = St,
    #base_merge_sign_in{
        charge_goods_list = GoodsList
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
            case lists:keyfind(Day, 1, ChargeGetList) of
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

get_gift(Player, Type, Day) ->
    case check_get_gift(Player, Type, Day) of
        {false, Res} ->
            {false, Res};
        {ok, GiftId} ->
            St = get_dict(),
            #st_merge_sign_in{
                get_list = GetList,
                charge_get_list = ChargeGetList
            } = St,
            Now = util:unixtime(),
            case Type of
                1 -> %%普通签到
                    NewSt0 =
                        case Day of
                            0 -> %%终极礼包
                                St#st_merge_sign_in{
                                    get_gift_time = Now
                                };
                            _ ->
                                St#st_merge_sign_in{
                                    get_list = lists:keysort(1, lists:keydelete(Day, 1, GetList) ++ [{Day, Now, 2}])
                                }
                        end,
                    NewSt = NewSt0#st_merge_sign_in{update_time = Now},
                    put_dict(NewSt),
                    activity_load:dbup_merge_sign_in(NewSt),
                    GiveGoodsList = goods:make_give_goods_list(173, [{GiftId, 1}]),
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                    activity_log:log_get_gift(Player#player.key, Player#player.nickname, GiftId, 1, 173),
                    activity:get_notice(Player, [23], true),
                    {ok, NewPlayer};
                _ -> %%至尊签到
                    NewSt0 =
                        case Day of
                            0 -> %%终极礼包
                                St#st_merge_sign_in{
                                    charge_gift_time = Now
                                };
                            _ ->
                                St#st_merge_sign_in{
                                    charge_get_list = lists:keysort(1, lists:keydelete(Day, 1, ChargeGetList) ++ [{Day, Now}])
                                }
                        end,
                    NewSt = NewSt0#st_merge_sign_in{update_time = Now},
                    put_dict(NewSt),
                    activity_load:dbup_merge_sign_in(NewSt),
                    GiveGoodsList = goods:make_give_goods_list(173, [{GiftId, 1}]),
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                    activity_log:log_get_gift(Player#player.key, Player#player.nickname, GiftId, 1, 173),
                    activity:get_notice(Player, [23], true),
                    {ok, NewPlayer}
            end
    end.

check_get_gift(_Player, Type, Day) ->
    case get_act() of
        [] -> {false, 0};
        Base ->
            #base_merge_sign_in{
                goods_list = GoodsList,
                last_gift_id = LastGiftId,
                charge_goods_list = ChargeGoodsList,
                charge_last_gift_id = ChargeLastGiftId
            } = Base,
            St = get_dict(),
            #st_merge_sign_in{
                get_list = GetList,
                get_gift_time = GetGiftTime,
                charge_list = ChargeList,
                charge_gift_time = ChargeGfitTime
            } = St,
            case Type of
                1 -> %%普通签到
                    case Day of
                        0 -> %%终极礼包
                            case GetGiftTime > 0 of
                                true -> {false, 3};
                                false ->
                                    case length(GetList) >= ?SIGN_IN_DAY of
                                        true -> {ok, LastGiftId};
                                        false -> {false, 2}
                                    end
                            end;
                        _ ->
                            case lists:keyfind(Day, 1, GetList) of
                                false -> {false, 2};
                                {Day, _Time, State} ->
                                    case State of
                                        2 -> {false, 3};
                                        _ ->
                                            GiftId = lists:nth(Day, GoodsList),
                                            {ok, GiftId}
                                    end
                            end
                    end;
                _ -> %%至尊签到
                    case Day of
                        0 -> %%终极礼包
                            case ChargeGfitTime > 0 of
                                true -> {false, 3};
                                false ->
                                    case length(ChargeList) >= length(ChargeGoodsList) of
                                        true -> {ok, ChargeLastGiftId};
                                        false -> {false, 2}
                                    end
                            end;
                        _ ->
                            StateList = get_charge_state_list(),
                            StateList1 = [list_to_tuple(Info) || Info <- StateList],
                            case lists:keyfind(Day, 1, StateList1) of
                                false -> {false, 0};
                                {Day, _ChargeVal, _NeedChargeVal, GiftId, State} ->
                                    if
                                        State == 0 -> {false, 2};
                                        State == 2 -> {false, 3};
                                        true ->
                                            {ok, GiftId}
                                    end
                            end
                    end
            end
    end.

get_dict() ->
    lib_dict:get(?PROC_STATUS_MERGE_SIGN_IN).

put_dict(St) ->
    lib_dict:put(?PROC_STATUS_MERGE_SIGN_IN, St).

get_act() ->
    case activity:get_work_list(data_merge_sign_in) of
        [] -> [];
        [Base | _] ->
            Base
    end.

add_charge(_Player, ChargeVal) ->
    case get_act() of
        [] -> skip;
        _Base ->
            St = get_dict(),
            #st_merge_sign_in{
                charge_list = ChargeList
            } = St,
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
            NewSt = St#st_merge_sign_in{
                charge_list = NewChargeList
            },
            put_dict(NewSt),
            activity_load:dbup_merge_sign_in(NewSt),
            ok
    end.

get_state(_Player) ->
    case get_act() of
        [] -> -1;
        _Base ->
            StateList = get_state_list(),
            F = fun(L) ->
                case lists:last(L) of
                    1 -> 1;
                    _ -> 0
                end
                end,
            Args = activity:get_base_state(_Base#base_merge_sign_in.act_info),
            case lists:sum(lists:map(F, StateList)) > 0 of
                true -> {1, Args};
                false ->
                    StateList1 = get_charge_state_list(),
                    case lists:sum(lists:map(F, StateList1)) > 0 of
                        true -> {1, Args};
                        false -> {0, Args}
                    end
            end
    end.