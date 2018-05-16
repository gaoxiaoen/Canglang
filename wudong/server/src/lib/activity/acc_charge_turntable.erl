%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 五月 2016 上午11:32
%%%-------------------------------------------------------------------
-module(acc_charge_turntable).
-author("fengzhenlin").
-include("server.hrl").
-include("common.hrl").
-include("activity.hrl").

%%协议接口
-export([
    get_acc_charge_turntable_info/1,
    get_gift/2
]).

%% API
-export([
    init/1,
    update/1,
    add_charge_val/2,
    get_state/1
]).

-define(MUST_GET_LUCK_VAL, 10).  %%必得精品所需幸运值

init(Player) ->
    AccChargeTurntableSt = activity_load:dbget_acc_charge_turntable(Player),
    lib_dict:put(?PROC_STATUS_ACC_CHARGE_TURNTABLE, AccChargeTurntableSt),
    update(Player),
    Player.

update(Player) ->
    AccChargeTurntableSt = get_dict(Player),
    ActList = get_act(),
    NewAccChargeTurntableSt =
        case ActList of
            [] -> AccChargeTurntableSt;
            [Base | _] ->
                Now = util:unixtime(),
                #st_acc_charge_turntable{
                    update_time = UpdateTime,
                    act_id = ActId
                } = AccChargeTurntableSt,
                case Base#base_acc_charge_turntable.act_id == ActId of
                    true ->
                        case util:is_same_date(UpdateTime, Now) of
                            true -> AccChargeTurntableSt;
                            false -> %%不是同一天，清掉累充金额
                                AccChargeTurntableSt#st_acc_charge_turntable{
                                    acc_val = 0,
                                    times = 0,
                                    update_time = Now
                                }
                        end;
                    false ->
                        AccChargeTurntableSt#st_acc_charge_turntable{
                            act_id = Base#base_acc_charge_turntable.act_id,
                            acc_val = 0,
                            times = 0,
                            luck_val = 0,
                            update_time = Now
                        }

                end
        end,
    lib_dict:put(?PROC_STATUS_ACC_CHARGE_TURNTABLE, NewAccChargeTurntableSt),
    ok.

get_acc_charge_turntable_info(Player) ->
    AccChargeTurntableSt = get_dict(Player),
    #st_acc_charge_turntable{
        acc_val = AccVal
    } = AccChargeTurntableSt,
    case get_act() of
        [] -> skip;
        [Base | _] ->
            #base_acc_charge_turntable{
                open_info = OpenInfo,
                charge_val = ChargeVal,
                cost_gold = CostGold,
                gift_list = GiftList
            } = Base,
            LeaveTime = activity:calc_act_leave_time(OpenInfo),
            CanGetTimes = calc_leave_turn_times(Player),
            GoodsList = [[GoodsId, Num] || {GoodsId, Num, _Pro, _Luck, _LuckPro} <- GiftList],
            RecordList = get_log_record(),
            {ok, Bin} = pt_431:write(43131, {LeaveTime, AccVal, ChargeVal, CanGetTimes, CostGold, GoodsList, RecordList}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end.

do_get_gift(Player, _Base, 0, GoodsList) -> {Player, GoodsList};
do_get_gift(Player, Base, Times, GoodsList) ->
    #base_acc_charge_turntable{
        cost_gold = CostGold,
        gift_list = GiftList
    } = Base,
    AccChargeTurntableSt = get_dict(Player),
    #st_acc_charge_turntable{
        luck_val = LuckVal
    } = AccChargeTurntableSt,
    CanGetTimes = calc_leave_turn_times(Player),
    IsEnough = money:is_enough(Player, CostGold, gold),
    if
        not IsEnough ->
            do_get_gift(Player, Base, 0, GoodsList);
        CanGetTimes =< 0 ->
            do_get_gift(Player, Base, 0, GoodsList);
        true ->
            case LuckVal >= ?MUST_GET_LUCK_VAL of
                true -> %%必得精品
                    %%获取有幸运权重的物品
                    LuckList = [{{GoodsId, Num, Luck}, LuckPro} || {GoodsId, Num, _Pro, Luck, LuckPro} <- GiftList, LuckPro > 0],
                    case LuckList of
                        [] ->
                            {GetGoodsId, GetGoodsNum, _Pro, _Luck, _LuckPro} = hd(GiftList),
                            GetLuck = -10;
                        _ ->
                            {GetGoodsId, GetGoodsNum, GetLuck} = util:list_rand_ratio(LuckList)
                    end,
                    NewLuckVal = max(0, LuckVal + GetLuck);
                false ->
                    GiftList1 = [{{GoodsId, Num, Luck}, Pro} || {GoodsId, Num, Pro, Luck, _LuckPro} <- GiftList, Pro > 0],
                    {GetGoodsId, GetGoodsNum, GetLuck} = util:list_rand_ratio(GiftList1),
                    NewLuckVal = max(0, LuckVal + GetLuck)
            end,
            NewAccChargeTurntableSt = AccChargeTurntableSt#st_acc_charge_turntable{
                luck_val = NewLuckVal,
                times = AccChargeTurntableSt#st_acc_charge_turntable.times + 1
            },
            NewPlayer = money:add_no_bind_gold(Player, -CostGold, 147, GetGoodsId, GetGoodsNum),
            lib_dict:put(?PROC_STATUS_ACC_CHARGE_TURNTABLE, NewAccChargeTurntableSt),
            do_get_gift(NewPlayer, Base, Times - 1, [{GetGoodsId, GetGoodsNum} | GoodsList])
    end.

%%领取奖励
get_gift(Player, Times) ->
    case check_get_gift(Player, Times) of
        {false, Res} ->
            {false, Res};
        {ok, Base} ->
            {NewPlayer, GoodsList} = do_get_gift(Player, Base, Times, []),
            case GoodsList of
                [] -> {false, 0};
                _ ->
                    %%更新db
                    NewAccChargeTurntableSt = get_dict(Player),
                    activity_load:dbup_acc_charge_turntable(NewAccChargeTurntableSt),

                    F1 = fun({GoodsId, Num}, AccList) ->
                        case lists:keyfind(GoodsId, 1, AccList) of
                            false -> [{GoodsId, Num} | AccList];
                            {_, OldNum} -> [{GoodsId, Num + OldNum} | lists:keydelete(GoodsId, 1, AccList)]
                        end
                         end,
                    AccGoodsList = lists:foldl(F1, [], GoodsList),
                    GiveGoodsList = goods:make_give_goods_list(147, AccGoodsList),
                    {ok, NewPlayer1} = goods:give_goods(NewPlayer, GiveGoodsList),
                    log_acc_charge_turntable_record(Player#player.key, Player#player.nickname, GoodsList),
                    activity:get_notice(Player, [16], true),
                    F = fun({GiftId, Num}) ->
                        activity_log:log_get_gift(Player#player.key, Player#player.nickname, GiftId, Num, 147)
                        end,
                    lists:foreach(F, GoodsList),
                    del_log_record(),
                    {ok, NewPlayer1, goods:pack_goods(GoodsList)}
            end
    end.
check_get_gift(Player, Times) ->
    case get_act() of
        [] -> {false, 0};
        [Base | _] ->
            AccChargeTurntableSt = get_dict(Player),
            #st_acc_charge_turntable{
                act_id = ActId
            } = AccChargeTurntableSt,
            CanGetTimes = calc_leave_turn_times(Player),
            #base_acc_charge_turntable{
                act_id = BaseActId,
                cost_gold = CostGold
            } = Base,
            IsEnough = money:is_enough(Player, CostGold, gold),
            if
                ActId =/= BaseActId ->
                    update(Player),
                    {false, 0};
                Times =< 0 -> {false, 0};
                CanGetTimes =< 0 -> {false, 9};
                not IsEnough -> {false, 5};
                true ->
                    {ok, Base}
            end
    end.

calc_leave_turn_times(Player) ->
    AccChargeTurntableSt = get_dict(Player),
    #st_acc_charge_turntable{
        acc_val = AccVal,
        times = Times
    } = AccChargeTurntableSt,
    case get_act() of
        [] -> 0;
        [Base | _] ->
            #base_acc_charge_turntable{
                charge_val = ChargeVal
            } = Base,
            case ChargeVal =< 0 of
                true -> 100;
                false -> max(0, (AccVal div ChargeVal) - Times)
            end
    end.

add_charge_val(Player, AddChargeVal) ->
    case get_act() of
        [] -> ok;
        _ ->
            AccChargeTurntableSt = get_dict(Player),
            NewAccChargeTurntableSt = AccChargeTurntableSt#st_acc_charge_turntable{
                acc_val = AddChargeVal + AccChargeTurntableSt#st_acc_charge_turntable.acc_val
            },
            lib_dict:put(?PROC_STATUS_ACC_CHARGE_TURNTABLE, NewAccChargeTurntableSt),
            activity_load:dbup_acc_charge_turntable(NewAccChargeTurntableSt),
            ok
    end.

get_state(Player) ->
    case get_act() of
        [] -> -1;
        Base ->
            Args = activity:get_base_state(Base#base_acc_charge_turntable.act_info),
            case check_get_gift(Player, 1) of
                {false, _} -> {0, Args};
                _ -> {1, Args}
            end
    end.

log_acc_charge_turntable_record(Pkey, Name, GoodsList) ->
    activity_proc:get_act_pid() ! {add_acc_charge_return_record, Pkey, Name, GoodsList},
    Now = util:unixtime(),
    Sql = io_lib:format("insert into log_acc_charge_turntable (pkey,nickname,goods_id,goods_num,time) VALUES ", []),
    F = fun({GoodsId, Num}, AccStr) ->
        case AccStr == "" of
            true ->
                lists:concat([AccStr, io_lib:format("(~p,'~s',~p,~p,~p)", [Pkey, Name, GoodsId, Num, Now])]);
            false ->
                lists:concat([AccStr, io_lib:format(",(~p,'~s',~p,~p,~p)", [Pkey, Name, GoodsId, Num, Now])])
        end
        end,
    Sql1 = lists:foldl(F, "", GoodsList),
    Sql2 = lists:concat([Sql, Sql1]),
    log_proc:log(Sql2),
    ok.

get_log_record() ->
    Now = util:unixtime(),
    case get(get_acc_charge_turntable_record) of
        undefined ->
            Records = ?CALL(activity_proc:get_act_pid(), get_acc_charge_returntable_record),
            L = [[Pkey, Name, GoodsId, GoodsNum] || {Pkey, Name, GoodsId, GoodsNum} <- Records],
            put(get_acc_charge_turntable_record, {L, Now}),
            L;
        {ReList, Time} ->
            case Now - Time < 100 of
                true -> ReList;
                false ->
                    put(get_acc_charge_turntable_record, undefined),
                    get_log_record()
            end
    end.

del_log_record() ->
    put(get_acc_charge_turntable_record, undefined).

get_dict(Player) ->
    case lib_dict:get(?PROC_STATUS_ACC_CHARGE_TURNTABLE) of
        St when is_record(St, st_acc_charge_turntable) -> St;
        _ ->
            NewPlayer = init(Player),
            get_dict(NewPlayer)
    end.

get_act() ->
    activity:get_work_list_mutex(data_acc_charge_turntable).

