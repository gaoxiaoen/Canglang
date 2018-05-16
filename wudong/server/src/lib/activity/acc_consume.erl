%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 一月 2016 下午8:51
%%%-------------------------------------------------------------------
-module(acc_consume).
-author("fengzhenlin").
-include("server.hrl").
-include("common.hrl").
-include("activity.hrl").

%%协议接口
-export([
    get_acc_consume_info/1,
    get_gift/2
]).

%% API
-export([
    init/1,
    get_state/1,
    add_consume_val/1,
    update_acc_consume/0
]).

init(Player) ->
    AccConsumeSt = activity_load:dbget_acc_consume_info(Player),
    lib_dict:put(?PROC_STATUS_ACC_CONSUME, AccConsumeSt),
    update_acc_consume(),
    ok.

update_acc_consume() ->
    AccConsumeSt = lib_dict:get(?PROC_STATUS_ACC_CONSUME),
    ActList = activity:get_work_list(data_acc_consume),
    NewAccConsumeSt =
        case ActList of
            [] -> AccConsumeSt;
            [Base | _] ->
                case Base#base_acc_consume.act_id == AccConsumeSt#st_acc_consume.act_id of
                    true -> AccConsumeSt;
                    false ->
                        AccConsumeSt#st_acc_consume{
                            acc_val = 0,
                            get_acc_ids = [],
                            act_id = Base#base_acc_consume.act_id
                        }
                end
        end,
    lib_dict:put(?PROC_STATUS_ACC_CONSUME, NewAccConsumeSt),
    ok.

%%获取玩家累计消费信息
get_acc_consume_info(Player) ->
    {InfoList, LeaveTime, AccVal} = get_act_info(Player),
    {ok, Bin} = pt_430:write(43041, {LeaveTime, AccVal, InfoList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%领取奖励
get_gift(Player, Id) ->
    case check_get_gift(Player, Id) of
        {false, Res} ->
            {false, Res};
        {ok, GiftId} ->
            AccConsumeSt = lib_dict:get(?PROC_STATUS_ACC_CONSUME),
            #st_acc_consume{
                get_acc_ids = GetAccIds
            } = AccConsumeSt,
            GiveGoodsList = goods:make_give_goods_list(116, GiftId),
            case goods:give_goods(Player, GiveGoodsList) of
                {ok, NewPlayer} ->
                    NewGetAccIds = GetAccIds ++ [Id],
                    NewAccConsumeSt = AccConsumeSt#st_acc_consume{
                        get_acc_ids = NewGetAccIds,
                        time = util:unixtime()
                    },
                    lib_dict:put(?PROC_STATUS_ACC_CONSUME, NewAccConsumeSt),
                    activity_load:dbup_acc_consume_info(NewAccConsumeSt),
%%                     activity_log:log_get_gift(Player#player.key,Player#player.nickname,GiftId,1,116),
                    activity:get_notice(Player, [5, 119], true),
                    {ok, NewPlayer};
                _ ->
                    {false, 0}
            end
    end.
check_get_gift(_Player, Id) ->
    AccConsumeSt = lib_dict:get(?PROC_STATUS_ACC_CONSUME),
    #st_acc_consume{
        get_acc_ids = GetAccIds,
        act_id = ActId,
        acc_val = AccVal
    } = AccConsumeSt,
    ActList = activity:get_work_list(data_acc_consume),
    if
        ActList == [] -> {false, 0};
        true ->
            Base = hd(ActList),
            #base_acc_consume{
                act_id = BaseActId,
                gift_list = GiftList
            } = Base,
            IsGet = lists:member(Id, GetAccIds),
            Len = length(GiftList),
            if
                BaseActId =/= ActId ->
                    update_acc_consume(),  %%避免活动文件没动态编译好
                    {false, 0};
                IsGet -> {false, 3};
                Id > Len -> {false, 0};
                true ->
                    {NeedConsumeVal, GiftId} = lists:nth(Id, GiftList),
                    if
                        AccVal < NeedConsumeVal -> {false, 2};
                        true ->
                            {ok, GiftId}
                    end
            end
    end.


get_act_info(_Player) ->
    AccConsumeSt = lib_dict:get(?PROC_STATUS_ACC_CONSUME),
    ActList = activity:get_work_list(data_acc_consume),
    #st_acc_consume{
        acc_val = AccVal,
        get_acc_ids = GetAccIds
    } = AccConsumeSt,
    case ActList of
        [] -> {[], 0, AccVal};  %%没有活动
        [Base | _] ->
            #base_acc_consume{
                open_info = OpenInfo,
                gift_list = GiftList
            } = Base,
            %%计算活动剩余时间
            LeaveTime = activity:calc_act_leave_time(OpenInfo),
            %%活动礼包信息
            F = fun({ConsumeGold, GiftId}, OrderId) ->
                GetState =
                    case lists:member(OrderId, GetAccIds) of
                        true -> 2;
                        false ->
                            case AccVal >= ConsumeGold of
                                true -> 1;
                                false -> 0
                            end
                    end,
                {[OrderId, ConsumeGold, GetState, util:list_tuple_to_list(GiftId)], OrderId + 1}
                end,
            {InfoList, _} = lists:mapfoldl(F, 1, GiftList),
            {InfoList, LeaveTime, AccVal}
    end.

%%获取活动领取状态
get_state(_Player) ->
    case get_act() of
        [] -> -1;
        #base_acc_consume{act_info = ActInfo, gift_list = GiftList} ->
            AccConsumeSt = lib_dict:get(?PROC_STATUS_ACC_CONSUME),
            #st_acc_consume{
                acc_val = AccVal,
                get_acc_ids = GetAccIds
            } = AccConsumeSt,
            F0 = fun({ConsumeGold, GiftId}, OrderId) ->
                GetState =
                    case lists:member(OrderId, GetAccIds) of
                        true -> 2;
                        false ->
                            case AccVal >= ConsumeGold of
                                true -> 1;
                                false -> 0
                            end
                    end,
                {[OrderId, ConsumeGold, GetState, util:list_tuple_to_list(GiftId)], OrderId + 1}
            end,
            {InfoList, _} = lists:mapfoldl(F0, 1, GiftList),
            Args = activity:get_base_state(ActInfo),
            if
                InfoList == [] -> -1;
                true ->
                    F = fun([_OrderId, _ConsumeGold, GetState, _GiftId]) ->
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

%%增加消费额度
add_consume_val(AddExp) ->
    ActList = activity:get_work_list(data_acc_consume),
    case ActList of
        [] -> ok;
        _ ->
            AccConsumeSt = lib_dict:get(?PROC_STATUS_ACC_CONSUME),
            NewAccConsumeSt = AccConsumeSt#st_acc_consume{
                acc_val = AccConsumeSt#st_acc_consume.acc_val + AddExp
            },
            lib_dict:put(?PROC_STATUS_ACC_CONSUME, NewAccConsumeSt),
            activity_load:dbup_acc_consume_info(NewAccConsumeSt),
            ok
    end.

get_act() ->
    case activity:get_work_list(data_acc_consume) of
        [] -> [];
        [Base | _] -> Base
    end.