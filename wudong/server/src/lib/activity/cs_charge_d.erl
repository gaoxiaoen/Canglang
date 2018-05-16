%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 财神单笔充值
%%% @end
%%% Created : 06. 十一月 2017 11:47
%%%-------------------------------------------------------------------
-module(cs_charge_d).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("goods.hrl").

%% API
-export([
    init/1,
    midnight_refresh/1,
    get_act/0,
    add_charge/2,
    get_act_info/1,
    recv/1,
    get_notice_state/1,
    sys_cacl/0,
    repair/1
]).

init(#player{key = Pkey} = Player) ->
    StCsCharge =
        case player_util:is_new_role(Player) of
            true -> #st_cs_charge_d{pkey = Pkey};
            false -> activity_load:dbget_cs_charge_d(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_CS_CHARGE, StCsCharge),
    update_cs_charge(Player),
%%     repair(Player),
    Player.

update_cs_charge(Player) ->
    StCsCharge = lib_dict:get(?PROC_STATUS_CS_CHARGE),
    #st_cs_charge_d{
        pkey = Pkey,
        act_id = ActId,
        op_time = OpTime
    } = StCsCharge,
    case get_act(util:to_atom(Player#player.login_flag)) of
        [] ->
            NewStCsCharge = #st_cs_charge_d{pkey = Pkey};
        {#base_cs_charge_d{act_id = BaseActId}, #base_cs_charge_d_sub{charge_gold = BaseChargeGold}} ->
            ChargeGoldList = act_charge:get_charge_list(),
            F = fun(ChargeGold) ->
                ChargeGold == BaseChargeGold
                end,
            NewChargeGoldList = lists:filter(F, ChargeGoldList),
            Now = util:unixtime(),
            Flag = util:is_same_date(OpTime, Now),
            if
                BaseActId =/= ActId ->
                    NewStCsCharge =
                        #st_cs_charge_d{
                            pkey = Pkey,
                            act_id = BaseActId,
                            charge_list = NewChargeGoldList,
                            buy_num = length(NewChargeGoldList),
                            op_time = Now
                        };
                Flag == false ->
                    NewStCsCharge =
                        #st_cs_charge_d{
                            pkey = Pkey,
                            act_id = BaseActId,
                            charge_list = NewChargeGoldList,
                            buy_num = length(NewChargeGoldList),
                            op_time = Now
                        };
                true ->
                    NewStCsCharge =
                        StCsCharge#st_cs_charge_d{
                            charge_list = NewChargeGoldList,
                            buy_num = length(NewChargeGoldList),
                            op_time = Now
                        }
            end
    end,
    lib_dict:put(?PROC_STATUS_CS_CHARGE, NewStCsCharge).

%% 凌晨重置不操作数据库
midnight_refresh(Player) ->
    update_cs_charge(Player).

get_act() ->
    case activity:get_work_list(data_cs_charge_d) of
        [] -> [];
        [Base | _] -> Base
    end.

get_act(LoginFlag) ->
    case get_act() of
        [] -> [];
        #base_cs_charge_d{list = BaseList} = BaseR ->
            case lists:keyfind(LoginFlag, #base_cs_charge_d_sub.login_flag, BaseList) of
                false ->
                    case lists:keyfind(all, #base_cs_charge_d_sub.login_flag, BaseList) of
                        false -> [];
                        BaseSubR -> {BaseR, BaseSubR}
                    end;
                BaseSubR -> {BaseR, BaseSubR}
            end
    end.

add_charge(Player, ChargeVal) ->
    case get_act(util:to_atom(Player#player.login_flag)) of
        [] ->
            skip;
        {_BaseR, #base_cs_charge_d_sub{charge_gold = BaseChargeGold}} ->
            St = lib_dict:get(?PROC_STATUS_CS_CHARGE),
            #st_cs_charge_d{
                charge_list = ChargeList,
                buy_num = BuyNum
            } = St,
            if
                ChargeVal == BaseChargeGold ->
                    NewSt =
                        St#st_cs_charge_d{
                            charge_list = [ChargeVal | ChargeList],
                            buy_num = BuyNum + 1,
                            op_time = util:unixtime()
                        },
                    lib_dict:put(?PROC_STATUS_CS_CHARGE, NewSt),
                    activity_load:dbup_cs_charge_d(NewSt);
                true ->
                    ok
            end
    end.

get_act_info(Player) ->
    case get_act(util:to_atom(Player#player.login_flag)) of
        [] ->
            {0, 0, 0, 0, 0, []};
        {#base_cs_charge_d{open_info = OpenInfo}, #base_cs_charge_d_sub{charge_gold = BaseChargeGold, reward_list = RewardList, num = BaseLimitBuyNum}} ->
            St = lib_dict:get(?PROC_STATUS_CS_CHARGE),
            #st_cs_charge_d{
                buy_num = BuyNum,
                recv_list = RecvList
            } = St,
            LTime = activity:calc_act_leave_time(OpenInfo),
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
    case get_act(util:to_atom(Player#player.login_flag)) of
        [] ->
            {0, Player};
        {_BaseR, #base_cs_charge_d_sub{charge_gold = BaseChargeGold, reward_list = RewardList, num = BaseLimitBuyNum}} ->
            St = lib_dict:get(?PROC_STATUS_CS_CHARGE),
            #st_cs_charge_d{
                buy_num = BuyNum,
                recv_list = RecvList
            } = St,
            if
                BuyNum == 0 -> {7, Player}; %% 未达成
                length(RecvList) >= BaseLimitBuyNum -> {5, Player}; %% 已经领取
                length(RecvList) >= BuyNum -> {5, Player}; %% 已经领取
                true ->
                    NewSt =
                        St#st_cs_charge_d{
                            recv_list = [BaseChargeGold | RecvList],
                            op_time = util:unixtime()
                        },
                    lib_dict:put(?PROC_STATUS_CS_CHARGE, NewSt),
                    activity_load:dbup_cs_charge_d(NewSt),
                    GiveGoodsList = goods:make_give_goods_list(729, RewardList),
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                    activity:get_notice(NewPlayer, [168], true),
                    {GoodsId, _GoodsNum} = hd(RewardList),
                    #goods_type{goods_name = GoodsName} = data_goods:get(GoodsId),
                    notice_sys:add_notice(act_cs_charge_d, [Player#player.nickname, GoodsName]),
                    Sql = io_lib:format("insert into log_cs_charge_d set pkey=~p, recv_list='~s', `time`=~p",
                        [Player#player.key, util:term_to_bitstring(RewardList), util:unixtime()]),
                    log_proc:log(Sql),
                    {1, NewPlayer}
            end
    end.

get_notice_state(Player) ->
    case get_act(util:to_atom(Player#player.login_flag)) of
        [] -> -1;
        {#base_cs_charge_d{act_info = ActInfo}, _R} ->
            {_LTime, _BaseLimitBuyNum, _BuyNum, _Rmb, IsRecv, _RewardList} = get_act_info(Player),
            Args = activity:get_base_state(ActInfo),
            ?IF_ELSE(IsRecv == 1, {1, Args}, {0, Args})
    end.

sys_cacl() ->
    case config:is_debug() of
        true ->
            StartTime = util:unixdate(),
            EndTime = util:unixdate() + ?ONE_DAY_SECONDS;
        false ->
            StartTime = util:unixdate() - ?ONE_DAY_SECONDS,
            EndTime = util:unixdate()
    end,
    Sql = io_lib:format("select pkey, act_id, charge_list, recv_list from player_cs_charge_d where op_time >=~p and op_time < ~p", [StartTime, EndTime]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            F = fun([Pkey, ActId, ChargeListBin, RecvListBin]) ->
                #base_cs_charge_d{list = BaseList} = data_cs_charge_d:get(ActId),
                #base_cs_charge_d_sub{num = BaseLimitBuyNum, reward_list = RewardList} = hd(BaseList),
                ChargeList = util:bitstring_to_term(ChargeListBin),
                RecvList = util:bitstring_to_term(RecvListBin),
                if
                    length(ChargeList) == length(RecvList) -> skip;
                    length(RecvList) >= BaseLimitBuyNum -> skip;
                    true ->
                        {Title, Content} = t_mail:mail_content(146),
                        mail:sys_send_mail([Pkey], Title, Content, RewardList),
                        ok
                end
                end,
            lists:map(F, Rows);
        _ ->
            skip
    end.

repair(Player) ->
    case util:unixtime() < 1510588799 of %% 先屏蔽
        false -> skip;
        true ->
            case util:to_atom(Player#player.login_flag) == ios of
                true -> skip;
                false ->
                    case cache:get({cs_charge_d, Player#player.key}) of
                        Flag when is_integer(Flag) -> skip;
                        _ ->
                            cache:set({cs_charge_d, Player#player.key}, 1, ?ONE_DAY_SECONDS),
                            case config:is_debug() of
                                true ->
                                    Sql = io_lib:format("select total_fee from recharge where app_role_id=~p", [Player#player.key]);
                                false ->
                                    Sql = io_lib:format("select total_fee from recharge where `time` > 1510502400 and `time` < 1510543800 and app_role_id=~p", [Player#player.key])
                            end,
                            case db:get_all(Sql) of
                                Rows when is_list(Rows) ->
                                    F = fun(ChargeGold) ->
                                        ChargeGold >= 1280
                                    end,
                                    IsFlag = lists:any(F, Rows),
                                    if
                                        IsFlag == false -> skip;
                                        true ->
                                            ?DEBUG("Pkey:~p, Rows:~p", [Player#player.key, Rows]),
                                            Title = ?T("13日财神天降奖励补发"),
                                            Content = ?T("亲爱的玩家您好，据统计您在13日0:00-11:30期间有单笔充值＞128元，以下是您应获得的财神天降活动奖励，请您于邮件附件查收，感谢您的支持和谅解，祝您游戏愉快。"),
                                            mail:sys_send_mail([Player#player.key], Title, Content, [{11601,1},{6609019,1},{1015001,10},{8002404,3}]),
                                            ok
                                    end;
                                _ -> ok
                            end
                    end
            end
    end.