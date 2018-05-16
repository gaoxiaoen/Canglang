%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 合服活动累充团购
%%% @end
%%% Created : 18. 七月 2017 10:13
%%%-------------------------------------------------------------------
-module(merge_act_group_charge).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    init/1,
    init/0,
    init_ets/0,
    midnight_refresh/1,
    sys_midnight_refresh/0,
    add_charge/2,
    up_charge_ets/2,

    get_act_info/1,
    recv/3,
    get_state/1,
    get_act/0,
    gm/0
]).

init_ets() ->
    ets:new(?ETS_MERGE_GROUP_CHARGE, [{keypos, #ets_merge_group_charge.key} | ?ETS_OPTIONS]).

init() ->
    case get_act() of
        [] ->
            ok;
        #base_merge_group_charge{act_id = BaseActId, charge_list = BaseChargeList} ->
            ChargeList = activity_load:dbget_all_merge_act_group_charge(BaseActId),
            F = fun({BaseChargeNum, BaseChargeGold, _GiftId}) ->
                F0 = fun({_Pkey, ChargeGold}) ->
                    ChargeGold >= BaseChargeGold
                end,
                List = lists:filter(F0, ChargeList),
                EtsMergeGroupCharge =
                    #ets_merge_group_charge{
                        act_id = BaseActId,
                        base_charge_gold = BaseChargeGold,
                        base_charge_num = BaseChargeNum,
                        key = {BaseActId, BaseChargeGold, BaseChargeNum},
                        charge_num = length(List),
                        player_list = ChargeList
                    },
                ets:insert(?ETS_MERGE_GROUP_CHARGE, EtsMergeGroupCharge)
            end,
            lists:map(F, BaseChargeList)
    end,
    ok.

init(#player{key = Pkey} = Player) ->
    StMergeActGroupCharge =
        case player_util:is_new_role(Player) of
            true -> #st_merge_act_group_charge{pkey = Pkey};
            false -> activity_load:dbget_merge_act_group_charge(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_MERGE_ACT_GROUP_CHARGE, StMergeActGroupCharge),
    update_merge_act_group_charge(),
    Player.

update_merge_act_group_charge() ->
    StMergeActGroupCharge = lib_dict:get(?PROC_STATUS_MERGE_ACT_GROUP_CHARGE),
    #st_merge_act_group_charge{
        pkey = Pkey,
        act_id = ActId
    } = StMergeActGroupCharge,
    case get_act() of
        [] ->
            NewStMergeActGroupCharge = #st_merge_act_group_charge{pkey = Pkey};
        #base_merge_group_charge{act_id = BaseActId} ->
            Now = util:unixtime(),
            if
                BaseActId =/= ActId ->
                    NewStMergeActGroupCharge = #st_merge_act_group_charge{pkey = Pkey, act_id = BaseActId, op_time = Now};
                true ->
                    NewStMergeActGroupCharge = StMergeActGroupCharge
            end
    end,
    lib_dict:put(?PROC_STATUS_MERGE_ACT_GROUP_CHARGE, NewStMergeActGroupCharge).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_merge_act_group_charge().

%% 系统晚上12点刷新
sys_midnight_refresh() ->
    case get_act() of
        [] ->
            ets:delete_all_objects(?ETS_MERGE_GROUP_CHARGE);
        #base_merge_group_charge{act_id = BaseActId} ->
            List = ets:tab2list(?ETS_MERGE_GROUP_CHARGE),
            if
                List == [] -> skip;
                true ->
                    Ets = hd(List),
                    if
                        Ets#ets_merge_group_charge.act_id =:= BaseActId -> skip;
                        true -> ets:delete_all_objects(?ETS_MERGE_GROUP_CHARGE)
                    end
            end
    end.

add_charge(Player, ChargeGold) ->
    case get_act() of
        [] ->
            ok;
        _ ->
            StMergeActGroupCharge = lib_dict:get(?PROC_STATUS_MERGE_ACT_GROUP_CHARGE),
            #st_merge_act_group_charge{charge_list = ChargeList} = StMergeActGroupCharge,
            NewStMergeActGroupCharge = StMergeActGroupCharge#st_merge_act_group_charge{charge_list = [ChargeGold | ChargeList]},
            activity_load:dbup_merge_act_group_charge(NewStMergeActGroupCharge),
            lib_dict:put(?PROC_STATUS_MERGE_ACT_GROUP_CHARGE, NewStMergeActGroupCharge),
            ?CAST(activity_proc:get_act_pid(), {update_merge_act_group_charge, {Player#player.key, ChargeGold}})
    end.

gm()->
    spawn(fun() -> gm0() end),
    ok.

gm0() ->
    ets:delete_all_objects(?ETS_MERGE_GROUP_CHARGE),
    Sql = io_lib:format("select app_role_id, total_fee from recharge", []),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            F = fun([Pkey, TotalFee]) ->
                ?CAST(activity_proc:get_act_pid(), {update_merge_act_group_charge, {Pkey, TotalFee div 10}})
            end,
            lists:map(F, Rows),
            ok;
        _ ->
            ok
    end,
    ok.

up_charge_ets(Pkey, ChargeGold) ->
    case get_act() of
        [] ->
            skip;
        #base_merge_group_charge{act_id = BaseActId, charge_list = BaseChargeList} ->
            F = fun({BaseChargeNum, BaseChargeGold, _BaseGiftId}) ->
                Ets = lookup(BaseChargeNum, BaseChargeGold, BaseActId),
                #ets_merge_group_charge{charge_num = ChargeNum, player_list = PlayerList} = Ets,
                case lists:keyfind(Pkey, 1, PlayerList) of
                    false ->
                        if
                            ChargeGold >= BaseChargeGold ->
                                NewChargeNum = ChargeNum + 1;
                            true ->
                                NewChargeNum = ChargeNum
                        end,
                        NewPlayerList = [{Pkey, ChargeGold} | PlayerList];
                    {Pkey, OldChargeGold} ->
                        if
                            OldChargeGold >= BaseChargeGold ->
                                NewChargeNum = ChargeNum;
                            OldChargeGold + ChargeGold >= BaseChargeGold ->
                                NewChargeNum = ChargeNum + 1;
                            true ->
                                NewChargeNum = ChargeNum
                        end,
                        NewPlayerList = lists:keyreplace(Pkey, 1, PlayerList, {Pkey, OldChargeGold+ChargeGold})
                end,
                NewEts = Ets#ets_merge_group_charge{charge_num = NewChargeNum, player_list = NewPlayerList},
                ets:insert(?ETS_MERGE_GROUP_CHARGE, NewEts)
            end,
            lists:map(F, BaseChargeList)
    end.

get_act_info(_Player) ->
    update_merge_act_group_charge(),
    StMergeActGroupCharge = lib_dict:get(?PROC_STATUS_MERGE_ACT_GROUP_CHARGE),
    #st_merge_act_group_charge{
        charge_list = ChargeList,
        recv_list = RecvList
    } = StMergeActGroupCharge,
    ChargeSumGold = lists:sum(ChargeList),
    case get_act() of
        [] ->
            {0, []};
        #base_merge_group_charge{charge_list = BaseChargeList, act_id = BaseActId, open_info = OpenInfo} ->
            LTime = activity:calc_act_leave_time(OpenInfo),
            {BaseChargeNum0, BaseChargeGold0, _GiftId0} = hd(BaseChargeList),
            Ets0 = lookup(BaseChargeNum0, BaseChargeGold0, BaseActId),
            F = fun({BaseChargeNum, BaseChargeGold, GiftId}) ->
                Ets = lookup(BaseChargeNum, BaseChargeGold, BaseActId),
                #ets_merge_group_charge{
                    base_charge_gold = BaseChargeGold,
                    base_charge_num = BaseChargeNum,
                    charge_num = ChargeNum
                } = Ets,
                State = if
                            ChargeSumGold < BaseChargeGold ->
                                0; %% 充值钻石未达标准
                            ChargeNum < BaseChargeNum ->
                                0; %% 充值人数不足
                            true ->
                                case lists:member({BaseChargeNum, BaseChargeGold}, RecvList) of
                                    true ->
                                        2; %% 已经领取
                                    false ->
                                        1  %% 可以领取
                                end
                        end,
%%                 [BaseChargeNum, ChargeNum, BaseChargeGold, GiftId, State]
                [BaseChargeNum, Ets0#ets_merge_group_charge.charge_num, BaseChargeGold, GiftId, State]
            end,
            List = lists:map(F, BaseChargeList),
            {LTime, List}
    end.

lookup(BaseChargeNum, BaseChargeGold, BaseActId) ->
    Key = {BaseActId, BaseChargeGold, BaseChargeNum},
    case ets:lookup(?ETS_MERGE_GROUP_CHARGE, Key) of
        [] ->
            Ets =
                #ets_merge_group_charge{
                    key = Key,
                    base_charge_num = BaseChargeNum,
                    base_charge_gold = BaseChargeGold,
                    act_id = BaseActId
                },
            ets:insert(?ETS_MERGE_GROUP_CHARGE, Ets),
            Ets;
        [EtsRecord] ->
            EtsRecord
    end.

recv(Player, BaseChargeNum, BaseChargeGold) ->
    StMergeActGroupCharge = lib_dict:get(?PROC_STATUS_MERGE_ACT_GROUP_CHARGE),
    #st_merge_act_group_charge{
        charge_list = ChargeList,
        recv_list = RecvList,
        act_id = ActId
    } = StMergeActGroupCharge,
    case get_act() of
        [] ->
            {4, Player};
        #base_merge_group_charge{charge_list = BaseChargeList, act_id = BaseActId} ->
            ChargeSumGold = lists:sum(ChargeList),
            Flag = lists:member({BaseChargeNum, BaseChargeGold}, RecvList),
            F = fun({BaseChargeNum0, BaseChargeGold0, _BaseGiftId}) ->
                BaseChargeNum0 == BaseChargeNum andalso BaseChargeGold == BaseChargeGold0
            end,
            List = lists:filter(F, BaseChargeList),
            if
                ActId =/= BaseActId ->
                    {0, Player}; %% 非同一个活动
                Flag == true ->
                    {3, Player}; %% 已经领取
                ChargeSumGold < BaseChargeGold ->
                    {2, Player}; %% 充值金额不达标，还不能领取
                List == [] ->
                    {0, Player}; %% 客户端数据发错
                true ->
                    {BaseChargeNum, BaseChargeGold, BaseGiftId} = hd(List),
                    GiveGoodsList = goods:make_give_goods_list(657,[{BaseGiftId,1}]),
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                    NewStMergeActGroupCharge =
                        StMergeActGroupCharge#st_merge_act_group_charge{
                            recv_list = [{BaseChargeNum, BaseChargeGold} | StMergeActGroupCharge#st_merge_act_group_charge.recv_list],
                            op_time = util:unixtime()
                        },
                    lib_dict:put(?PROC_STATUS_MERGE_ACT_GROUP_CHARGE, NewStMergeActGroupCharge),
                    activity_load:dbup_merge_act_group_charge(NewStMergeActGroupCharge),
                    activity:get_notice(Player, [46], true),
                    {1, NewPlayer}
            end
    end.

get_state(_Player) ->
    StMergeActGroupCharge = lib_dict:get(?PROC_STATUS_MERGE_ACT_GROUP_CHARGE),
    #st_merge_act_group_charge{
        charge_list = ChargeList,
        recv_list = RecvList
    } = StMergeActGroupCharge,
    case get_act() of
        [] ->
            -1;
        #base_merge_group_charge{charge_list = BaseChargeList, act_id = BaseActId} ->
            F = fun({BaseChargeNum, BaseChargeGold, _GiftId}) ->
                Ets = lookup(BaseChargeNum, BaseChargeGold, BaseActId),
                #ets_merge_group_charge{
                    base_charge_gold = BaseChargeGold,
                    base_charge_num = BaseChargeNum,
                    charge_num = ChargeNum
                } = Ets,
                ChargeSumGold = lists:sum(ChargeList),
                if
                    ChargeSumGold < BaseChargeGold ->
                        []; %% 充值钻石未达标准
                    ChargeNum < BaseChargeNum ->
                        []; %% 充值人数不足
                    true ->
                        case lists:member({BaseChargeNum, BaseChargeGold}, RecvList) of
                            true ->
                                []; %% 已经领取
                            false ->
                                [1] %% 可以领取
                        end
                end
            end,
            List = lists:flatmap(F, BaseChargeList),
            if
                List == [] -> 0;
                true -> 1
            end
    end.

get_act() ->
    case activity:get_work_list(data_merge_group_charge) of
        [] -> [];
        [Base | _] -> Base
    end.