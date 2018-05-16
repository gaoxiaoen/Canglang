%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. 六月 2017 15:10
%%%-------------------------------------------------------------------
-module(acc_charge_d).
-author("li").

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
    AccChargeSt = activity_load:dbget_acc_charge_d_info(Player),
    lib_dict:put(?PROC_STATUS_ACC_CHARGE_D, AccChargeSt),
    update_acc_charge_d(),
    Player.

%%更新活动信息
update_acc_charge_d() ->
    AccChargeSt = lib_dict:get(?PROC_STATUS_ACC_CHARGE_D),
    #st_acc_charge_d{
        pkey = Pkey,
        act_id = ActId,
        acc_val = AccVal
    } = AccChargeSt,
    case get_act() of %%判断是否新活动
        [] ->
            NewAccChargeSt = #st_acc_charge_d{pkey = Pkey};
        #base_acc_charge_d{act_id = BaseActId} ->
            Now = util:unixtime(),
            ChargeVal = act_charge:get_charge_gold(),
            if
                BaseActId =/= ActId ->
                    NewAccChargeSt =
                        #st_acc_charge_d{
                            pkey = Pkey, act_id = BaseActId, acc_val = ChargeVal, time = Now
                        };
                true ->
                    if
                        AccVal >= ChargeVal ->
                            NewAccChargeSt = AccChargeSt;
                        true ->
                            NewAccChargeSt = AccChargeSt#st_acc_charge_d{acc_val = ChargeVal}
                    end
            end
    end,
    lib_dict:put(?PROC_STATUS_ACC_CHARGE_D, NewAccChargeSt).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_acc_charge_d().

%%获取累计充值信息
get_acc_charge_info(Player) ->
    #player{
        sid = Sid
    } = Player,
    {InfoList, LeaveTime, AccVal} = get_act_info(Player),
    {ok, Bin} = pt_433:write(43376, {LeaveTime, AccVal, InfoList}),
    server_send:send_to_sid(Sid, Bin),
    ok.

%%领取礼包
get_gift(Player, Id) ->
    case check_get_gift(Player, Id) of
        {false, Res} ->
            {false, Res};
        {ok, RewardList} ->
            AccChargeSt = lib_dict:get(?PROC_STATUS_ACC_CHARGE_D),
            #st_acc_charge_d{
                get_acc_ids = GetAccIds
            } = AccChargeSt,
            case catch goods:give_goods(Player, goods:make_give_goods_list(634, RewardList)) of
                {ok, NewPlayer} ->
                    NewGetAccIds = GetAccIds ++ [Id],
                    NewAccChargeSt = AccChargeSt#st_acc_charge_d{
                        get_acc_ids = NewGetAccIds,
                        time = util:unixtime()
                    },
                    lib_dict:put(?PROC_STATUS_ACC_CHARGE_D, NewAccChargeSt),
                    activity_load:dbup_acc_charge_d_info(NewAccChargeSt),
%%                     activity_log:log_get_gift(Player#player.key, Player#player.nickname, GiftId, 1, 115),
                    activity:get_notice(Player, [43], true),
                    {ok, NewPlayer};
                _ ->
                    {false, 0}
            end
    end.
check_get_gift(_Player, Id) ->
    AccChargeSt = lib_dict:get(?PROC_STATUS_ACC_CHARGE_D),
    #st_acc_charge_d{
        get_acc_ids = GetAccIds,
        act_id = ActId,
        acc_val = AccVal
    } = AccChargeSt,
    case get_act() of
        [] -> {false, 0};
        Base ->
            #base_acc_charge_d{
                act_id = BaseActId,
                gift_list = GiftList
            } = Base,
            IsGet = lists:member(Id, GetAccIds),
            Len = length(GiftList),
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
    AccChargeSt = lib_dict:get(?PROC_STATUS_ACC_CHARGE_D),
    #st_acc_charge_d{
        acc_val = AccVal,
        get_acc_ids = GetAccIds
    } = AccChargeSt,
    case get_act() of
        [] -> {[], 0, AccVal};  %%没有活动
        #base_acc_charge_d{gift_list = GiftList, open_info = OpenInfo} ->
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
get_state(Player) ->
    case get_act() of
        [] ->
            -1;
        #base_acc_charge_d{act_info = ActInfo} ->
            {InfoList, _LeaveTime, _AccVal} = get_act_info(Player),
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
add_charge_val(_Player, AddExp) ->
    case get_act() of
        [] ->
            ok;
        _ ->
            AccChargeSt = lib_dict:get(?PROC_STATUS_ACC_CHARGE_D),
            NewAccChargeSt = AccChargeSt#st_acc_charge_d{
                acc_val = AccChargeSt#st_acc_charge_d.acc_val + AddExp,
                time = util:unixtime()
            },
            lib_dict:put(?PROC_STATUS_ACC_CHARGE_D, NewAccChargeSt),
            activity_load:dbup_acc_charge_d_info(NewAccChargeSt),
            ok
    end.

get_act() ->
    case activity:get_work_list(data_acc_charge_d) of
        [] -> [];
        [Base | _] -> Base
    end.
