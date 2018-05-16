%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 二月 2017 10:46
%%%-------------------------------------------------------------------
-module(hqg_daily_charge).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("goods.hrl").

%% API
-export([
    init/1,
    get_act/0,
    midnight_refresh/1,
    add_charge/2,
    get_state/1,
    get_act_info/1,
    recv/2,
    notice/2,
    logout/0
]).

logout() ->
    case get_act() of
        [] ->
            ok;
        _ ->
            StHqgDailyCharge = lib_dict:get(?PROC_STATUS_HQG_DAILY_CHARGE),
            activity_load:dbup_hqg_daily_charge(StHqgDailyCharge),
            ok
    end.

notice(Player, Lv) ->
    if
        Lv == 10 ->
            activity:get_notice(Player, [32], true),
            case get_act() of
                [] ->
                    ok;
                _ ->
                    {ok, Bin} = pt_432:write(43264, {1}),
                    server_send:send_to_sid(Player#player.sid, Bin)
            end;
        true ->
            ok
    end.

init(#player{key = Pkey} = Player) ->
    StHqgDailyCharge =
        case player_util:is_new_role(Player) of
            true -> #st_hqg_daily_charge{pkey = Pkey};
            false -> activity_load:dbget_hqg_daily_charge(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_HQG_DAILY_CHARGE, StHqgDailyCharge),
    update_hqg_daily_charge(),
    Player.

update_hqg_daily_charge() ->
    StHqgDailyCharge = lib_dict:get(?PROC_STATUS_HQG_DAILY_CHARGE),
    #st_hqg_daily_charge{
        act_id = ActId,
        pkey = Pkey,
        op_time = OpTime,
        recv_first_list = RecvFirstList
    } = StHqgDailyCharge,
    case get_act() of
        [] ->
            NewStHqgDailyCharge = #st_hqg_daily_charge{pkey = Pkey, recv_first_list = RecvFirstList};
        #base_hqg_daily_charge{act_id = BaseActId} ->
            Now = util:unixtime(),
            IsSameDay = util:is_same_date(Now, OpTime),
            if
                IsSameDay == false ->
                    back(StHqgDailyCharge),
                    StHqgDailyCharge99 = lib_dict:get(?PROC_STATUS_HQG_DAILY_CHARGE),
                    NewStHqgDailyCharge = #st_hqg_daily_charge{pkey = Pkey, act_id = BaseActId, op_time = Now, recv_first_list = StHqgDailyCharge99#st_hqg_daily_charge.recv_first_list, acc_charge = act_charge:get_charge_gold()};
                BaseActId =/= ActId -> %% 不是同一个活动
                    NewStHqgDailyCharge = #st_hqg_daily_charge{pkey = Pkey, act_id = BaseActId, op_time = Now, recv_first_list = RecvFirstList, acc_charge = act_charge:get_charge_gold()};
                true ->
                    NewStHqgDailyCharge = StHqgDailyCharge#st_hqg_daily_charge{acc_charge = act_charge:get_charge_gold()}
            end
    end,
    NewStHqgDailyCharge99 = hotfix(NewStHqgDailyCharge),
    lib_dict:put(?PROC_STATUS_HQG_DAILY_CHARGE, NewStHqgDailyCharge99).

hotfix(StHqgDailyCharge) ->
    #st_hqg_daily_charge{
        recv_acc = RecvAcc,
        recv_first_list = RecvFirstList
    } = StHqgDailyCharge,
    F = fun(ChargeGold) ->
        if
            ChargeGold == 10 -> 1;
            ChargeGold == 99 -> 2;
            ChargeGold == 880 -> 3;
            ChargeGold == 120 -> 2;
            ChargeGold == 720 -> 3;
            true -> ChargeGold
        end
        end,
    NewRecvAcc = lists:map(F, RecvAcc),
    F2 = fun({ChargeGold, Time}) ->
        NewChargeGold =
            if
                ChargeGold == 10 -> 1;
                ChargeGold == 99 -> 2;
                ChargeGold == 880 -> 3;
                ChargeGold == 120 -> 2;
                ChargeGold == 720 -> 3;
                true -> ChargeGold
            end,
        {NewChargeGold, Time}
         end,
    NewRecvFirstList99 = lists:map(F2, RecvFirstList),
    StHqgDailyCharge#st_hqg_daily_charge{
        recv_acc = NewRecvAcc,
        recv_first_list = NewRecvFirstList99
    }.

%% 返还
back(StHqgDailyCharge) ->
    #st_hqg_daily_charge{
        act_id = ActId,
        pkey = Pkey,
        acc_charge = ChargeGold,
        recv_acc = RecvAcc,
        recv_first_list = RecvFirstList
    } = StHqgDailyCharge,
    if
        ChargeGold == 0 ->
            ok;
        length(RecvAcc) >= 3 ->
            ok;
        true ->
            #base_hqg_daily_charge{acc_charge_list = BaseAccChargeList} = data_hqg_daily_charge:get(ActId),
            F = fun({Type, BaseChargeGold, BaseGiftId, BaseFirstGiftId}) ->
                Flag0 = lists:keyfind(Type, 1, RecvFirstList),
                Flag1 = lists:member(Type, RecvAcc),
                if
                    ChargeGold < BaseChargeGold -> [];
                    Flag1 == true -> [];
                    Flag0 == false -> [{BaseFirstGiftId, 1}];
                    true -> [{BaseGiftId, 1}]
                end
                end,
            RewardList = lists:flatmap(F, BaseAccChargeList),

            F1 = fun({Type, BaseChargeGold, _BaseGiftId, _BaseFirstGiftId}) ->
                if
                    ChargeGold < BaseChargeGold -> [];
                    true -> [Type]
                end
                 end,
            List1 = lists:flatmap(F1, BaseAccChargeList),

            F2 = fun({Type, BaseChargeGold, _BaseGiftId, _BaseFirstGiftId}) ->
                if
                    ChargeGold < BaseChargeGold -> [];
                    true -> [{Type, util:unixtime() - ?ONE_DAY_SECONDS}]
                end
                 end,
            List2 = lists:flatmap(F2, BaseAccChargeList),

            NewStHqgDailyCharge =
                StHqgDailyCharge#st_hqg_daily_charge{
                    recv_acc = RecvAcc ++ List1,
                    recv_first_list = fix(RecvFirstList ++ List2)
                },
            activity_load:dbup_hqg_daily_charge(NewStHqgDailyCharge),
            lib_dict:put(?PROC_STATUS_HQG_DAILY_CHARGE, NewStHqgDailyCharge),
            {Title, Content} = t_mail:mail_content(79),
%%             ?DEBUG("#######hqg daily charge ActId:~p RewardList2:~p~n", [ActId, RewardList2]),
            LogF = fun({LogGoodsId, LogGoodsNum}) ->
                activity_log:log_hqg_daily_charge(Pkey, LogGoodsId, LogGoodsNum)
                   end,
            lists:map(LogF, RewardList),
            ?IF_ELSE(RewardList == [], skip, mail:sys_send_mail([Pkey], Title, Content, RewardList))
    end.

fix(List) ->
    F = fun({R, T}, AccList) ->
        case lists:keyfind(R, 1, AccList) of
            false -> [{R, T} | AccList];
            _ -> AccList
        end
        end,
    lists:foldl(F, [], List).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_hqg_daily_charge().

add_charge(_Player, _ChargeGold) ->
    case lib_dict:get(?PROC_STATUS_HQG_DAILY_CHARGE) of
        [] -> ?ERR("no data~n", []);
        #st_hqg_daily_charge{} = StHqgDailyCharge ->
            NewStHqgDailyCharge =
                StHqgDailyCharge#st_hqg_daily_charge{
                    acc_charge = act_charge:get_charge_gold(),
                    op_time = util:unixtime()
                },
            lib_dict:put(?PROC_STATUS_HQG_DAILY_CHARGE, NewStHqgDailyCharge),
            activity_load:dbup_hqg_daily_charge(NewStHqgDailyCharge),
            activity_rpc:handle(43265, _Player, {})
    end.

get_act_info(_Player) ->
    update_hqg_daily_charge(),
    StHqgDailyCharge = lib_dict:get(?PROC_STATUS_HQG_DAILY_CHARGE),
    #st_hqg_daily_charge{
        acc_charge = ChargeGold,
        recv_acc = RecvAcc,
        recv_first_list = RecvFirstList
    } = StHqgDailyCharge,
    case get_act() of
        [] ->
            {0, 0, []};
        #base_hqg_daily_charge{
            open_info = OpenInfo,
            acc_charge_list = BaseAccChargeList
        } ->
            LTime = activity:calc_act_leave_time(OpenInfo),
            F = fun({BaseType, BaseChargeGold, BaseGiftId, BaseFirstGiftId}) ->
                IsRecv =
                    if
                        BaseChargeGold > ChargeGold -> 0;
                        true -> ?IF_ELSE(lists:member(BaseType, RecvAcc) == true, 2, 1)
                    end,
                {ProGiftId, IsAcc} =
                    case lists:keyfind(BaseType, 1, RecvFirstList) of
                        false ->
                            {BaseFirstGiftId, 1};
                        {_, Time} ->
                            if
                                Time == 0 ->
                                    {BaseFirstGiftId, 1};
                                true ->
                                    case util:is_same_date(Time, util:unixtime()) of
                                        true -> {BaseFirstGiftId, 1};
                                        false -> {BaseGiftId, 0}
                                    end
                            end
                    end,
                [BaseChargeGold, ProGiftId, IsRecv, IsAcc]
                end,
            ProList = lists:map(F, BaseAccChargeList),
            {LTime, ChargeGold, ProList}
    end.

recv(Player, RecvChargeGold) ->
    update_hqg_daily_charge(),
    case get_act() of
        [] ->
            {0, Player};
        #base_hqg_daily_charge{acc_charge_list = AccChargeList} ->
            StHqgDailyCharge = lib_dict:get(?PROC_STATUS_HQG_DAILY_CHARGE),
            #st_hqg_daily_charge{
                acc_charge = AccCharge,
                recv_acc = RecvAcc,
                recv_first_list = RecvFirstList
            } = StHqgDailyCharge,
            {_LTime, _ChargeGold00, ProList} = get_act_info(Player),
            F = fun([BaseChargeGold, _ProGiftId, _IsRecv, _IsAcc]) ->
                BaseChargeGold == RecvChargeGold
                end,
            LL = lists:filter(F, ProList),
            {Type, _ChargeGold01, _GiftId, _FirstGiftId} = lists:keyfind(RecvChargeGold, 2, AccChargeList),
            Flag = ?IF_ELSE(lists:member(Type, RecvAcc), true, false),
            if
                length(RecvAcc) >= 3 ->
                    {3, Player};
                Flag == true ->
                    {3, Player}; %% 已经领取
                AccCharge < RecvChargeGold ->
                    {2, Player}; %% 充值额度未达标
                LL == [] ->
                    {0, Player};
                true ->
                    [_BaseChargeGold, ProGiftId, _IsRecv, _IsAcc] = hd(LL),
                    GiveGoodsList = goods:make_give_goods_list(603, [{ProGiftId, 1}]),
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                    Now = util:unixtime(),
                    NewRecvFirstList =
                        case lists:keyfind(Type, 1, RecvFirstList) of
                            false -> [{Type, Now} | RecvFirstList];
                            _ -> RecvFirstList
                        end,
                    NewStHqgDailyCharge =
                        StHqgDailyCharge#st_hqg_daily_charge{
                            recv_acc = [Type | RecvAcc],
                            op_time = Now,
                            recv_first_list = NewRecvFirstList
                        },
                    lib_dict:put(?PROC_STATUS_HQG_DAILY_CHARGE, NewStHqgDailyCharge),
                    activity_load:dbup_hqg_daily_charge(NewStHqgDailyCharge),
                    activity:get_notice(NewPlayer, [32], true),
                    activity_log:log_hqg_daily_charge(Player#player.key, ProGiftId, 1),
                    {1, NewPlayer}
            end
    end.

get_state(_Player) ->
    Code =
        case get_act() of
            [] ->
                -1;
            #base_hqg_daily_charge{acc_charge_list = BaseAccChargeList, act_info = ActInfo} ->
                StHqgDailyCharge = lib_dict:get(?PROC_STATUS_HQG_DAILY_CHARGE),
                #st_hqg_daily_charge{
                    acc_charge = AccCharge,
                    recv_acc = RecvAcc
                } = StHqgDailyCharge,
                F = fun({Type, BaseChargeGold, _GiftId1, _GiftId2}) ->
                    if
                        AccCharge >= BaseChargeGold ->
                            [Type];
                        true ->
                            []
                    end
                    end,
                List = lists:flatmap(F, BaseAccChargeList),
                L = List -- RecvAcc,
                Args = activity:get_base_state(ActInfo),
                if
                    L /= [] -> {1, Args}; %% 当前有可以领取的
                    length(RecvAcc) == length(BaseAccChargeList) -> -1; %% 全部领取完了，入口关闭
                    true -> {0, Args} %%
                end
        end,
    Code.

get_act() ->
    case activity:get_work_list(data_hqg_daily_charge) of
        [] ->
            [];
        [Base | _] ->
            Base
    end.
