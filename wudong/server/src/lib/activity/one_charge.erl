%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% 单笔壕礼
%%% @end
%%% Created : 13. 一月 2016 上午11:29
%%%-------------------------------------------------------------------
-module(one_charge).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    get_one_charge_info/1,
    get_gift/2
]).

-export([
    init/1,
    update_one_charge/1,
    get_state/1,
    add_charge_val/2,  %%增加累计充值额度
    get_leave_time/0
]).

init(Player) ->
    OneChargeSt = activity_load:dbget_one_charge_info(Player),
    lib_dict:put(?PROC_STATUS_ONE_CHARGE, OneChargeSt),
    update_one_charge(Player),
    Player.

%%更新活动信息
update_one_charge(_Player) ->
    OneChargeSt = lib_dict:get(?PROC_STATUS_ONE_CHARGE),
    ActList = activity:get_work_list(data_one_charge),
    NewOneChargeSt =
        case ActList == [] of %%判断是否新活动
            true -> OneChargeSt;
            false ->
                Base = hd(ActList),
                case Base#base_one_charge.act_id == OneChargeSt#st_one_charge.act_id of
                    true -> OneChargeSt;
                    false ->
                        OneChargeSt#st_one_charge{
                            charge_list = [],
                            get_acc_ids = [],
                            act_id = Base#base_one_charge.act_id
                        }
                end
        end,
    lib_dict:put(?PROC_STATUS_ONE_CHARGE, NewOneChargeSt),
    ok.

%%获取单笔充值信息
get_one_charge_info(Player) ->
    #player{
        sid = Sid
    } = Player,
    {InfoList, LeaveTime, MaxCharge} = get_act_info(Player),
    {ok, Bin} = pt_430:write(43051, {LeaveTime, MaxCharge, InfoList}),
    server_send:send_to_sid(Sid, Bin),
    ok.

%%领取礼包
get_gift(Player, Id) ->
    case check_get_gift(Player, Id) of
        {false, Res} ->
            {false, Res};
        {ok, GiftId} ->
            OneChargeSt = lib_dict:get(?PROC_STATUS_ONE_CHARGE),
            #st_one_charge{
                get_acc_ids = GetAccIds
            } = OneChargeSt,
            GiveGoodsList = goods:make_give_goods_list(117, [{GiftId, 1}]),
            case goods:give_goods(Player, GiveGoodsList) of
                {ok, NewPlayer} ->
                    NewGetAccIds = GetAccIds ++ [Id],
                    NewOneChargeSt = OneChargeSt#st_one_charge{
                        get_acc_ids = NewGetAccIds,
                        time = util:unixtime()
                    },
                    lib_dict:put(?PROC_STATUS_ONE_CHARGE, NewOneChargeSt),
                    activity_load:dbup_one_charge_info(NewOneChargeSt),
                    activity_log:log_get_gift(Player#player.key, Player#player.nickname, GiftId, 1, 117),
                    activity:get_notice(Player, [6], true),
                    {ok, NewPlayer};
                _ ->
                    {false, 0}
            end
    end.
check_get_gift(Player, Id) ->
    OneChargeSt = lib_dict:get(?PROC_STATUS_ONE_CHARGE),
    #st_one_charge{
        get_acc_ids = GetAccIds,
        act_id = ActId,
        charge_list = ChargeList
    } = OneChargeSt,
    ActList = activity:get_work_list(data_one_charge),
    if
        ActList == [] -> {false, 0};
%%         GetAccIds =/= [] -> {false, 9};
        true ->
            Base = hd(ActList),
            #base_one_charge{
                act_id = BaseActId,
                gift_list = GiftList
            } = Base,
            IsGet = lists:member(Id, GetAccIds),
            Len = length(GiftList),
            if
                BaseActId =/= ActId ->
                    update_one_charge(Player),  %%避免活动文件没动态编译好
                    {false, 0};
                IsGet -> {false, 3};
                Id > Len -> {false, 0};
                true ->
                    {NeedChargeVal, GiftId} = lists:nth(Id, GiftList),
                    IsMem = lists:member(NeedChargeVal, ChargeList),
                    if
                        not IsMem -> {false, 2};
                        true ->
                            {ok, GiftId}
                    end
            end
    end.

%%获取活动状态
get_act_info(_Player) ->
    OneChargeSt = lib_dict:get(?PROC_STATUS_ONE_CHARGE),
    ActList = activity:get_work_list(data_one_charge),
    #st_one_charge{
        charge_list = ChargeList,
        get_acc_ids = GetAccIds
    } = OneChargeSt,
    MaxCharge =
        case lists:sort(ChargeList) of
            [] -> 0;
            SortList -> lists:last(SortList)
        end,
    case ActList of
        [] -> {[], 0, MaxCharge};  %%没有活动
        [Base | _] ->
            #base_one_charge{
                gift_list = GiftList
            } = Base,
            %%计算活动剩余时间
            LeaveTime = get_leave_time(),
            %%活动礼包信息
            F = fun({ChargeGold, GiftId}, OrderId) ->
                GetState =
                    case lists:member(OrderId, GetAccIds) of
                        true -> 2;
                        false ->
                            case lists:member(ChargeGold, ChargeList) of
                                true -> 1;
                                false -> 0
                            end
                    end,
                {[OrderId, ChargeGold, GiftId, GetState], OrderId + 1}
                end,
            {InfoList, _} = lists:mapfoldl(F, 1, GiftList),
            {InfoList, LeaveTime, MaxCharge}
    end.

%%获取活动领取状态
get_state(Player) ->
    case get_act() of
        [] -> -1;
        #base_one_charge{act_info = ActInfo} ->
            {InfoList, LeaveTime, _MaxCharge} = get_act_info(Player),
            Args = activity:get_base_state(ActInfo),
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


get_act() ->
    case activity:get_work_list(data_one_charge) of
        [] -> [];
        [Base | _] -> Base
    end.

%%增加充值额度
add_charge_val(Player, ChargeVal) ->
    case get_leave_time() of
        -1 ->
            ok;
        true ->
            update_one_charge(Player),
            OneChargeSt = lib_dict:get(?PROC_STATUS_ONE_CHARGE),
            NewOneChargeSt = OneChargeSt#st_one_charge{
                charge_list = lists:delete(ChargeVal, OneChargeSt#st_one_charge.charge_list) ++ [ChargeVal]
            },
            lib_dict:put(?PROC_STATUS_ONE_CHARGE, NewOneChargeSt),
            activity_load:dbup_one_charge_info(NewOneChargeSt),
            ok
    end.

get_leave_time() ->
    ActList = activity:get_work_list(data_one_charge),
    case ActList of
        [] -> -1;
        [Base | _] ->
            activity:calc_act_leave_time(Base#base_one_charge.open_info)
    end.