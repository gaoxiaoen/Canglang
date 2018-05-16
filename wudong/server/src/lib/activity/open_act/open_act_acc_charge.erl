%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% %% 累充奖励
%%% @end
%%% Created : 27. 二月 2017 17:28
%%%-------------------------------------------------------------------
-module(open_act_acc_charge).
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
    StOpenActAccCharge =
        case player_util:is_new_role(Player) of
            true -> #st_open_act_acc_charge{pkey = Pkey};
            false -> activity_load:dbget_open_act_acc_charge(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_OPEN_ACC_CHARGE, StOpenActAccCharge),
    update_open_act_acc_charge(),
    Player.

update_open_act_acc_charge() ->
    StOpenActAccCharge = lib_dict:get(?PROC_STATUS_OPEN_ACC_CHARGE),
    #st_open_act_acc_charge{
        pkey = Pkey,
        op_time = OpTime
    } = StOpenActAccCharge,
    case get_act() of
        [] ->
            NewStOpenActAccCharge = #st_open_act_acc_charge{pkey = Pkey};
        ActType ->
            Now = util:unixtime(),
            Flag = util:is_same_date(OpTime, Now),
            if
                Flag == true ->
                    NewStOpenActAccCharge =
                        StOpenActAccCharge#st_open_act_acc_charge{
                            act_id = ActType,
                            acc_charge_gold = act_charge:get_charge_gold()
                        };
                true ->
                    NewStOpenActAccCharge =
                        #st_open_act_acc_charge{
                            pkey = Pkey,
                            act_id = ActType,
                            op_time = Now,
                            acc_charge_gold = act_charge:get_charge_gold()
                        }
            end
    end,
    lib_dict:put(?PROC_STATUS_OPEN_ACC_CHARGE, NewStOpenActAccCharge).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_open_act_acc_charge().

get_act_info(_Player) ->
    update_open_act_acc_charge(),
    StOpenActAccCharge = lib_dict:get(?PROC_STATUS_OPEN_ACC_CHARGE),
    #st_open_act_acc_charge{
        recv_list = RecvList,
        acc_charge_gold = AccChargeGold
    } = StOpenActAccCharge,
    case get_act() of
        [] ->
            {0, 0, []};
        ActType ->
            Ids = data_open_new_acc_charge:get_ids_by_actType(ActType),
            F0 = fun(Id) ->
                data_open_new_acc_charge:get(Id)
            end,
            BaseChargeList = lists:map(F0, Ids),
            LTime = max(0, ?ONE_DAY_SECONDS - util:get_seconds_from_midnight()),
            F = fun({BaseAccChargeGold, RewardList}) ->
                case lists:member(BaseAccChargeGold, RecvList) of
                    false ->
                        Status = ?IF_ELSE(AccChargeGold >= BaseAccChargeGold, 1, 0),
                        [BaseAccChargeGold, Status, util:list_tuple_to_list(RewardList)];
                    _ ->
                        [BaseAccChargeGold, 2, util:list_tuple_to_list(RewardList)]
                end
            end,
            List = lists:map(F, BaseChargeList),
            {LTime, AccChargeGold, List}
    end.

recv(Player, BaseChargeGold) ->
    update_open_act_acc_charge(),
    StOpenActAccCharge = lib_dict:get(?PROC_STATUS_OPEN_ACC_CHARGE),
    #st_open_act_acc_charge{
        recv_list = RecvList,
        acc_charge_gold = AccChargeGold
    } = StOpenActAccCharge,
    case get_act() of
        [] ->
            {4, Player};
        ActType ->
            Ids = data_open_new_acc_charge:get_ids_by_actType(ActType),
            F0 = fun(Id) ->
                data_open_new_acc_charge:get(Id)
            end,
            BaseChargeList = lists:map(F0, Ids),
            Flag = lists:member(BaseChargeGold, RecvList),
            case lists:keyfind(BaseChargeGold, 1, BaseChargeList) of
                false ->
                    {0, Player};
                {_BaseChargeGold, RewardList} ->
                    if
                        Flag == true -> {3, Player}; %% 已经领取
                        AccChargeGold < BaseChargeGold -> {2, Player}; %% 累充金额不达标，还不能领取
                        true ->
                            GiveGoodsList = goods:make_give_goods_list(607, RewardList),
                            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                            NewStOpenActAccCharge =
                                StOpenActAccCharge#st_open_act_acc_charge{
                                    recv_list = [BaseChargeGold | RecvList],
                                    op_time = util:unixtime()
                                },
                            lib_dict:put(?PROC_STATUS_OPEN_ACC_CHARGE, NewStOpenActAccCharge),
                            activity_load:dbup_open_act_acc_charge(NewStOpenActAccCharge),
                            activity:get_notice(Player, [33], true),
                            {1, NewPlayer}
                    end
            end
    end.

get_state(_Player) ->
    StOpenActAccCharge = lib_dict:get(?PROC_STATUS_OPEN_ACC_CHARGE),
    #st_open_act_acc_charge{
        recv_list = RecvList,
        acc_charge_gold = AccChargeGold
    } = StOpenActAccCharge,
    case get_act() of
        false ->
            -1;
        ActType ->
            Ids = data_open_new_acc_charge:get_ids_by_actType(ActType),
            F0 = fun(Id) ->
                data_open_new_acc_charge:get(Id)
            end,
            BaseChargeList = lists:map(F0, Ids),
            F = fun({BaseAccChargeGold, _RewardList}) ->
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

add_charge(_Player, _ChargeGold) ->
    StOpenActAccCharge = lib_dict:get(?PROC_STATUS_OPEN_ACC_CHARGE),
    case get_act() of
        false ->
            skip;
        _ ->
            NewStOpenActAccCharge =
                StOpenActAccCharge#st_open_act_acc_charge{
                    acc_charge_gold = act_charge:get_charge_gold(),
                    op_time = util:unixtime()
                },
            lib_dict:put(?PROC_STATUS_OPEN_ACC_CHARGE, NewStOpenActAccCharge),
            activity_load:dbup_open_act_acc_charge(NewStOpenActAccCharge)
    end.

get_act() ->
    OpenDay = config:get_open_days(),
    get_act(OpenDay).
get_act(OpenDay) ->
    case ets:lookup(?ETS_ACT_OPEN_INFO, OpenDay) of
        [] -> false;
        [#ets_act_info{act_info = ActInfo}] ->
            case lists:keyfind(?ACT_ACC_CHARGE, 1, ActInfo) of
                false -> false;
                {_Act, ActType} -> ActType
            end
    end.