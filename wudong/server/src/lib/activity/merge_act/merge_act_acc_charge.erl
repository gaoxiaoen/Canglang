%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% %% 累充奖励
%%% @end
%%% Created : 27. 二月 2017 17:28
%%%-------------------------------------------------------------------
-module(merge_act_acc_charge).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    init/1,
    midnight_refresh/1,
    add_charge/2,

    get_act_info/1,
    recv/2,
    get_state/1,
    get_act/0
]).

init(#player{key = Pkey} = Player) ->
    StMergeActAccCharge =
        case player_util:is_new_role(Player) of
            true -> #st_merge_act_acc_charge{pkey = Pkey};
            false -> activity_load:dbget_merge_act_acc_charge(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_MERGE_ACC_CHARGE, StMergeActAccCharge),
    update_merge_act_acc_charge(),
    Player.

update_merge_act_acc_charge() ->
    StMergeActAccCharge = lib_dict:get(?PROC_STATUS_MERGE_ACC_CHARGE),
    #st_merge_act_acc_charge{
        pkey = Pkey,
        act_id = ActId
    } = StMergeActAccCharge,
    case get_act() of
        [] ->
            NewStMergeActAccCharge = #st_merge_act_acc_charge{pkey = Pkey};
        #base_merge_acc_charge{act_id = BaseActId} ->
            Now = util:unixtime(),
            if
                BaseActId =/= ActId ->
                    NewStMergeActAccCharge = #st_merge_act_acc_charge{pkey = Pkey, act_id = BaseActId, op_time = Now, acc_charge_gold = act_charge:get_charge_gold()};
                true ->
                    NewStMergeActAccCharge = StMergeActAccCharge#st_merge_act_acc_charge{acc_charge_gold = act_charge:get_charge_gold()}
            end
    end,
    lib_dict:put(?PROC_STATUS_MERGE_ACC_CHARGE, NewStMergeActAccCharge).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_merge_act_acc_charge().

get_act_info(_Player) ->
    update_merge_act_acc_charge(),
    StMergeActAccCharge = lib_dict:get(?PROC_STATUS_MERGE_ACC_CHARGE),
    #st_merge_act_acc_charge{
        recv_list = RecvList,
        acc_charge_gold = AccChargeGold
    } = StMergeActAccCharge,
    case get_act() of
        [] ->
            {0, 0, []};
        #base_merge_acc_charge{
            charge_list = BaseChargeList,
            open_info = OpenInfo
        } ->
            LTime = activity:calc_act_leave_time(OpenInfo),
            F = fun({BaseAccChargeGold, GiftId}) ->
                case lists:member(BaseAccChargeGold, RecvList) of
                    false ->
                        Status = ?IF_ELSE(AccChargeGold >= BaseAccChargeGold, 1, 0),
                        [BaseAccChargeGold, GiftId, Status];
                    _ ->
                        [BaseAccChargeGold, GiftId, 2]
                end
            end,
            List = lists:map(F, BaseChargeList),
            {LTime, AccChargeGold, List}
    end.

recv(Player, BaseChargeGold) ->
    update_merge_act_acc_charge(),
    StMergeActAccCharge = lib_dict:get(?PROC_STATUS_MERGE_ACC_CHARGE),
    #st_merge_act_acc_charge{
        recv_list = RecvList,
        acc_charge_gold = AccChargeGold
    } = StMergeActAccCharge,
    case get_act() of
        [] ->
            {4, Player};
        #base_merge_acc_charge{charge_list = BaseChargeList} ->
            Flag = lists:member(BaseChargeGold, RecvList),
            case lists:keyfind(BaseChargeGold, 1, BaseChargeList) of
                false ->
                    {0, Player};
                {_BaseChargeGold, GiftId} ->
                    if
                        Flag == true -> {3, Player}; %% 已经领取
                        AccChargeGold < BaseChargeGold -> {2, Player}; %% 累充金额不达标，还不能领取
                        true ->
                            GiveGoodsList = goods:make_give_goods_list(655,[{GiftId,1}]),
                            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                            NewStMergeActAccCharge =
                                StMergeActAccCharge#st_merge_act_acc_charge{
                                    recv_list = [BaseChargeGold | RecvList],
                                    op_time = util:unixtime()
                                },
                            lib_dict:put(?PROC_STATUS_MERGE_ACC_CHARGE, NewStMergeActAccCharge),
                            activity_load:dbup_merge_act_acc_charge(NewStMergeActAccCharge),
                            activity:get_notice(Player, [46], true),
                            {1, NewPlayer}
                    end
            end
    end.

get_state(_Player) ->
    StMergeActAccCharge = lib_dict:get(?PROC_STATUS_MERGE_ACC_CHARGE),
    #st_merge_act_acc_charge{
        recv_list = RecvList,
        acc_charge_gold = AccChargeGold
    } = StMergeActAccCharge,
    case get_act() of
        [] ->
            -1;
        #base_merge_acc_charge{
            charge_list = BaseChargeList
        } ->
            F = fun({BaseAccChargeGold, _GiftId}) ->
                case lists:member(BaseAccChargeGold, RecvList) of
                    false ->
                        ?IF_ELSE(AccChargeGold >= BaseAccChargeGold, [1], []);
                    _ ->
                        []
                end
            end,
            List = lists:flatmap(F, BaseChargeList),
            ?IF_ELSE(List == [], 0, 1)
    end.

add_charge(_Player, ChargeGold) ->
    StMergeActAccCharge = lib_dict:get(?PROC_STATUS_MERGE_ACC_CHARGE),
    #st_merge_act_acc_charge{acc_charge_gold = AccChargeGold} = StMergeActAccCharge,
    case get_act() of
        [] ->
            skip;
        _ ->
            NewStMergeActAccCharge = StMergeActAccCharge#st_merge_act_acc_charge{acc_charge_gold = AccChargeGold+ChargeGold},
            lib_dict:put(?PROC_STATUS_MERGE_ACC_CHARGE, NewStMergeActAccCharge),
            activity_load:dbup_merge_act_acc_charge(NewStMergeActAccCharge)
    end.

get_act() ->
    case activity:get_work_list(data_merge_acc_charge) of
        [] -> [];
        [Base | _] -> Base
    end.