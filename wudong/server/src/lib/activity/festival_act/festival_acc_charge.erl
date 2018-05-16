%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 节日活动之累积充值
%%% @end
%%% Created : 22. 九月 2017 19:43
%%%-------------------------------------------------------------------
-module(festival_acc_charge).
-author("li").

-include("server.hrl").
-include("common.hrl").
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
    StFestivalActAccCharge =
        case player_util:is_new_role(Player) of
            true -> #st_festival_act_acc_charge{pkey = Pkey};
            false -> activity_load:dbget_festival_act_acc_charge(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_FESTIVAL_ACC_CHARGE, StFestivalActAccCharge),
    update_festival_act_acc_charge(),
    Player.

update_festival_act_acc_charge() ->
    StFestivalActAccCharge = lib_dict:get(?PROC_STATUS_FESTIVAL_ACC_CHARGE),
    #st_festival_act_acc_charge{
        pkey = Pkey,
        act_id = ActId,
        op_time = OpTime
    } = StFestivalActAccCharge,
    case get_act() of
        [] ->
            NewStFestivalActAccCharge = #st_festival_act_acc_charge{pkey = Pkey};
        #base_festival_acc_charge{act_id = BaseActId} ->
            Now = util:unixtime(),
            Flag = util:is_same_date(Now, OpTime),
            if
                BaseActId =/= ActId ->
                    NewStFestivalActAccCharge = #st_festival_act_acc_charge{pkey = Pkey, act_id = BaseActId, op_time = Now, acc_charge_gold = act_charge:get_charge_gold()};
                Flag == false ->
                    NewStFestivalActAccCharge = #st_festival_act_acc_charge{pkey = Pkey, act_id = BaseActId, op_time = Now, acc_charge_gold = act_charge:get_charge_gold()};
                true ->
                    NewStFestivalActAccCharge = StFestivalActAccCharge#st_festival_act_acc_charge{acc_charge_gold = act_charge:get_charge_gold()}
            end
    end,
    lib_dict:put(?PROC_STATUS_FESTIVAL_ACC_CHARGE, NewStFestivalActAccCharge).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_festival_act_acc_charge().

get_act_info(_Player) ->
    update_festival_act_acc_charge(),
    StFestivalActAccCharge = lib_dict:get(?PROC_STATUS_FESTIVAL_ACC_CHARGE),
    #st_festival_act_acc_charge{
        recv_list = RecvList,
        acc_charge_gold = AccChargeGold
    } = StFestivalActAccCharge,
    case get_act() of
        [] ->
            {0, 0, []};
        #base_festival_acc_charge{
            charge_list = BaseChargeList,
            open_info = OpenInfo
        } ->
            LTime = activity:calc_act_leave_time(OpenInfo),
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
    update_festival_act_acc_charge(),
    StFestivalActAccCharge = lib_dict:get(?PROC_STATUS_FESTIVAL_ACC_CHARGE),
    #st_festival_act_acc_charge{
        recv_list = RecvList,
        acc_charge_gold = AccChargeGold
    } = StFestivalActAccCharge,
    case get_act() of
        [] ->
            {0, Player};
        #base_festival_acc_charge{charge_list = BaseChargeList} ->
            Flag = lists:member(BaseChargeGold, RecvList),
            case lists:keyfind(BaseChargeGold, 1, BaseChargeList) of
                false ->
                    {0, Player};
                {_BaseChargeGold, RewardList} ->
                    if
                        Flag == true -> {5, Player}; %% 已经领取
                        AccChargeGold < BaseChargeGold -> {7, Player}; %% 累充金额不达标，还不能领取
                        true ->
                            GiveGoodsList = goods:make_give_goods_list(697,RewardList),
                            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                            NewStFestivalActAccCharge =
                                StFestivalActAccCharge#st_festival_act_acc_charge{
                                    recv_list = [BaseChargeGold | RecvList],
                                    op_time = util:unixtime()
                                },
                            lib_dict:put(?PROC_STATUS_FESTIVAL_ACC_CHARGE, NewStFestivalActAccCharge),
                            activity_load:dbup_festival_act_acc_charge(NewStFestivalActAccCharge),
                            Sql = io_lib:format("replace  into log_festival_acc_charge set pkey=~p,recv_list='~s',recv_charge_gold=~p,time=~p",
                                [Player#player.key, util:term_to_bitstring(RewardList), BaseChargeGold, util:unixtime()]),
                            log_proc:log(Sql),
                            {1, NewPlayer}
                    end
            end
    end.

get_state(_Player) ->
    StFestivalActAccCharge = lib_dict:get(?PROC_STATUS_FESTIVAL_ACC_CHARGE),
    #st_festival_act_acc_charge{
        recv_list = RecvList,
        acc_charge_gold = AccChargeGold
    } = StFestivalActAccCharge,
    case get_act() of
        [] ->
            -1;
        #base_festival_acc_charge{
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

add_charge(_Player, _ChargeGold) ->
    StFestivalActAccCharge = lib_dict:get(?PROC_STATUS_FESTIVAL_ACC_CHARGE),
    case get_act() of
        [] ->
            skip;
        _ ->
            NewStFestivalActAccCharge =
                StFestivalActAccCharge#st_festival_act_acc_charge{acc_charge_gold = act_charge:get_charge_gold()},
            lib_dict:put(?PROC_STATUS_FESTIVAL_ACC_CHARGE, NewStFestivalActAccCharge),
            activity_load:dbup_festival_act_acc_charge(NewStFestivalActAccCharge)
    end.

get_act() ->
    case activity:get_work_list(data_festival_acc_charge) of
        [] -> [];
        [Base | _] -> Base
    end.