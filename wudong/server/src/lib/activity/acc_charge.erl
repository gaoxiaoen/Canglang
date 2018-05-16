%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% 每日累充
%%% @end
%%% Created : 12. 一月 2016 下午4:17
%%%-------------------------------------------------------------------
-module(acc_charge).
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
    midnight_refresh/1,
    get_state/1,
    add_charge_val/2,  %%增加累计充值额度
    get_act/0
]).

init(Player) ->
    AccChargeSt = activity_load:dbget_acc_charge_info(Player),
    lib_dict:put(?PROC_STATUS_ACC_CHARGE, AccChargeSt),
    update_acc_charge(),
    Player.

%%更新活动信息
update_acc_charge() ->
    AccChargeSt = lib_dict:get(?PROC_STATUS_ACC_CHARGE),
    #st_acc_charge{
        pkey = Pkey,
        time = OpTime,
        act_id = ActId
    } = AccChargeSt,
    case get_act() of %%判断是否新活动
        [] ->
            NewAccChargeSt = #st_acc_charge{pkey = Pkey};
        #base_acc_charge{act_id = BaseActId} ->
            Now = util:unixtime(),
            Flag = util:is_same_date(Now, OpTime),
            if
                BaseActId =/= ActId ->
                    NewAccChargeSt = #st_acc_charge{pkey = Pkey, act_id = BaseActId, time = Now, acc_val = act_charge:get_charge_gold()};
                Flag == false ->
                    NewAccChargeSt = #st_acc_charge{pkey = Pkey, act_id = BaseActId, time = Now, acc_val = act_charge:get_charge_gold()};
                true ->
                    NewAccChargeSt = AccChargeSt#st_acc_charge{acc_val = act_charge:get_charge_gold()}
            end
    end,
    lib_dict:put(?PROC_STATUS_ACC_CHARGE, NewAccChargeSt).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_acc_charge().

%%获取累计充值信息
get_acc_charge_info(Player) ->
    #player{
        sid = Sid
    } = Player,
    {InfoList, LeaveTime, AccVal} = get_act_info(Player),
%%     ?DEBUG("InfoList::~p, LeaveTime:~p, AccVal:~p~n ", [InfoList, LeaveTime, AccVal]),
    {ok, Bin} = pt_430:write(43031, {LeaveTime, AccVal, InfoList}),
    server_send:send_to_sid(Sid, Bin),
    ok.

%%领取礼包
get_gift(Player, Id) ->
    update_acc_charge(),
    case check_get_gift(Player, Id) of
        {false, Res} ->
            {false, Res};
        {ok, RewardList} ->
            AccChargeSt = lib_dict:get(?PROC_STATUS_ACC_CHARGE),
            #st_acc_charge{
                get_acc_ids = GetAccIds
            } = AccChargeSt,
            case catch goods:give_goods(Player, goods:make_give_goods_list(115, RewardList)) of
                {ok, NewPlayer} ->
                    NewGetAccIds = GetAccIds ++ [Id],
                    NewAccChargeSt = AccChargeSt#st_acc_charge{
                        get_acc_ids = NewGetAccIds,
                        time = util:unixtime()
                    },
                    lib_dict:put(?PROC_STATUS_ACC_CHARGE, NewAccChargeSt),
                    activity_load:dbup_acc_charge_info(NewAccChargeSt),
                    activity:get_notice(Player, [4], true),
                    {ok, NewPlayer};
                _ ->
                    {false, 0}
            end
    end.
check_get_gift(_Player, Id) ->
    AccChargeSt = lib_dict:get(?PROC_STATUS_ACC_CHARGE),
    #st_acc_charge{
        get_acc_ids = GetAccIds,
        act_id = ActId,
        acc_val = AccVal
    } = AccChargeSt,
    case get_act() of
        [] -> {false, 0};
        Base ->
            #base_acc_charge{
                act_id = BaseActId,
                gift_list = GiftList
            } = Base,
            IsGet = lists:member(Id, GetAccIds),
            Len = length(GiftList),
            ?DEBUG("IsGet:~p Len:~p, BaseActId:~p ActId:~p", [IsGet, Len, BaseActId, ActId]),
            if
                BaseActId =/= ActId -> {false, 0}; %% 活动过期
                IsGet -> {false, 3}; %% 已经领取
                Id > Len -> {false, 0}; %% 客户端数据有问题
                true ->
                    {NeedChargeVal, GiftId} = lists:nth(Id, GiftList),
                    if
                        AccVal < NeedChargeVal -> {false, 2}; %% 充值额度不足
                        true -> {ok, GiftId}
                    end
            end
    end.

%%获取活动状态
get_act_info(_Player) ->
    AccChargeSt = lib_dict:get(?PROC_STATUS_ACC_CHARGE),
    #st_acc_charge{
        acc_val = AccVal,
        get_acc_ids = GetAccIds
    } = AccChargeSt,
    case get_act() of
        [] -> {[], 0, AccVal};  %%没有活动
        #base_acc_charge{gift_list = GiftList, open_info = OpenInfo} ->
            %%计算活动剩余时间
            LeaveTime = activity:calc_act_leave_time(OpenInfo),
            %%活动礼包信息
            F = fun({ChargeGold, RewardList}, OrderId) ->
                GetState =
                    case lists:member(OrderId, GetAccIds) of
                        true -> 2;
                        false ->
                            case AccVal >= ChargeGold of
                                true -> 1;
                                false -> 0
                            end
                    end,
                L = lists:map(fun({GId, GNum}) -> [GId, GNum] end, RewardList),
                {[OrderId, ChargeGold, GetState, L], OrderId + 1}
                end,
            {InfoList, _} = lists:mapfoldl(F, 1, GiftList),
            {InfoList, LeaveTime, AccVal}
    end.

%%获取活动领取状态
get_state(_Player) ->
    case get_act() of
        [] ->
            -1;
        #base_acc_charge{act_info = ActInfo, gift_list = GiftList} ->
            AccChargeSt = lib_dict:get(?PROC_STATUS_ACC_CHARGE),
            #st_acc_charge{
                acc_val = AccVal,
                get_acc_ids = GetAccIds
            } = AccChargeSt,
            F0 = fun({ChargeGold, RewardList}, OrderId) ->
                GetState =
                    case lists:member(OrderId, GetAccIds) of
                        true -> 2;
                        false ->
                            case AccVal >= ChargeGold of
                                true -> 1;
                                false -> 0
                            end
                    end,
                L = lists:map(fun({GId, GNum}) -> [GId, GNum] end, RewardList),
                {[OrderId, ChargeGold, GetState, L], OrderId + 1}
            end,
            {InfoList, _} = lists:mapfoldl(F0, 1, GiftList),
            F = fun([_OrderId, _ChargeGold, GetState, _GiftId]) ->
                case GetState == 1 of
                    true -> 1;
                    false -> 0
                end
                end,
            Args = activity:get_base_state(ActInfo),
            case lists:sum(lists:map(F, InfoList)) > 0 of
                true -> {1, Args};
                false -> {0, Args}
            end
    end.

%%增加充值额度
add_charge_val(_Player, _AddExp) ->
    case get_act() of
        [] -> ok;
        _ ->
            AccChargeSt = lib_dict:get(?PROC_STATUS_ACC_CHARGE),
            NewAccChargeSt = AccChargeSt#st_acc_charge{
                acc_val = act_charge:get_charge_gold(),
                time = util:unixtime()
            },
            lib_dict:put(?PROC_STATUS_ACC_CHARGE, NewAccChargeSt),
            activity_load:dbup_acc_charge_info(NewAccChargeSt),
            ok
    end.

get_act() ->
    case activity:get_work_list(data_acc_charge) of
        [] -> [];
        [Base | _] -> Base
    end.