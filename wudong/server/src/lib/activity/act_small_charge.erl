%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 小额充值
%%% @end
%%% Created : 12. 九月 2017 14:18
%%%-------------------------------------------------------------------
-module(act_small_charge).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    init/1,
    midnight_refresh/1,
    get_act/0,
    add_charge/2,

    get_act_info/1,
    recv/1,
    get_state/1
]).

init(#player{key = Pkey} = Player) ->
    StSmallCharge =
        case player_util:is_new_role(Player) of
            true -> #st_act_small_charge{pkey = Pkey};
            false -> activity_load:dbget_small_charge(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_SMALL_CHARGE, StSmallCharge),
    update_small_charge(),
    Player.

update_small_charge() ->
    StSmallCharge = lib_dict:get(?PROC_STATUS_SMALL_CHARGE),
    #st_act_small_charge{
        pkey = Pkey,
        act_id = ActId
    } = StSmallCharge,
    case get_act() of
        [] ->
            NewStSmallCharge = #st_act_small_charge{pkey = Pkey};
        #base_act_small_charge{act_id = BaseActId} ->
            if
                BaseActId =/= ActId ->
                    NewStSmallCharge = #st_act_small_charge{pkey = Pkey, act_id = BaseActId};
                true ->
                    NewStSmallCharge = StSmallCharge
            end
    end,
    lib_dict:put(?PROC_STATUS_SMALL_CHARGE, NewStSmallCharge).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_small_charge().

get_act() ->
    case activity:get_work_list(data_act_small_charge) of
        [] -> [];
        [Base | _] -> Base
    end.

add_charge(_Player, ChargeVal) ->
    case get_act() of
        [] ->
            skip;
        #base_act_small_charge{list = BaseList} ->
            St = lib_dict:get(?PROC_STATUS_SMALL_CHARGE),
            #st_act_small_charge{
                charge_list = ChargeList,
                buy_num = BuyNum
            } = St,
            case lists:keyfind(ChargeVal, 1, BaseList) of
                false ->
                    skip;
                _ ->
                    NewSt =
                        St#st_act_small_charge{
                            charge_list = [ChargeVal | ChargeList],
                            buy_num = BuyNum + 1,
                            op_time = util:unixtime()
                        },
                    lib_dict:put(?PROC_STATUS_SMALL_CHARGE, NewSt),
                    activity_load:dbup_small_charge(NewSt)
            end
    end.

get_act_info(_Player) ->
    case get_act() of
        [] ->
            {0, 0, 0, 0, 0, []};
        #base_act_small_charge{open_info = OpenInfo, list = BaseList} ->
            St = lib_dict:get(?PROC_STATUS_SMALL_CHARGE),
            #st_act_small_charge{
                buy_num = BuyNum,
                recv_list = RecvList
            } = St,
            LTime = activity:calc_act_leave_time(OpenInfo),
            {BaseChargeGold, RewardList, BaseLimitBuyNum} = hd(BaseList),
            IsRecv =
                if
                    BuyNum == 0 -> 0; %% 未达成
                    length(RecvList) >= BaseLimitBuyNum -> 2; %% 已经领取
                    length(RecvList) >= BuyNum -> 2; %% 已经领取
                    true -> 1
                end,
            {LTime, BaseLimitBuyNum, min(BaseLimitBuyNum, BuyNum), BaseChargeGold, IsRecv, util:list_tuple_to_list(RewardList)}
    end.

recv(Player) ->
    case get_act() of
        [] ->
            {0, Player};
        #base_act_small_charge{list = BaseList} ->
            St = lib_dict:get(?PROC_STATUS_SMALL_CHARGE),
            #st_act_small_charge{
                buy_num = BuyNum,
                recv_list = RecvList
            } = St,
            {BaseChargeGold, RewardList, BaseLimitBuyNum} = hd(BaseList),
            if
                BuyNum == 0 -> {7, Player}; %% 未达成
                length(RecvList) >= BaseLimitBuyNum -> {5, Player}; %% 已经领取
                length(RecvList) >= BuyNum -> {5, Player}; %% 已经领取
                true ->
                    NewSt =
                        St#st_act_small_charge{
                            recv_list = [BaseChargeGold | RecvList],
                            op_time = util:unixtime()
                        },
                    lib_dict:put(?PROC_STATUS_SMALL_CHARGE, NewSt),
                    activity_load:dbup_small_charge(NewSt),
                    GiveGoodsList = goods:make_give_goods_list(693, RewardList),
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                    activity:get_notice(NewPlayer, [159], true),
                    {1, NewPlayer}
            end
    end.

get_state(Player) ->
    case get_act() of
        [] -> -1;
        #base_act_small_charge{act_info = ActInfo} ->
            {_LTime, _BaseLimitBuyNum, _BuyNum, _Rmb, IsRecv, _RewardList} = get_act_info(Player),
            Args = activity:get_base_state(ActInfo),
            ?IF_ELSE(IsRecv == 1, {1, Args}, {0, Args})
    end.