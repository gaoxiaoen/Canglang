%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 小额单笔充值3档
%%% @end
%%% Created : 28. 十一月 2017 10:24
%%%-------------------------------------------------------------------
-module(small_charge_d).
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
    recv/2,
    get_notice_state/1,
    sys_cacl/0
]).

init(#player{key = Pkey} = Player) ->
    StCsCharge =
        case player_util:is_new_role(Player) of
            true -> #st_small_charge_d{pkey = Pkey};
            false -> activity_load:dbget_small_charge_d(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_SMALL_CHARGE_D, StCsCharge),
    update_small_charge(Player),
    Player.

update_small_charge(Player) ->
    StCsCharge = lib_dict:get(?PROC_STATUS_SMALL_CHARGE_D),
    #st_small_charge_d{
        pkey = Pkey,
        act_id = ActId,
        op_time = OpTime
    } = StCsCharge,
    case get_act(util:to_atom(Player#player.login_flag)) of
        [] ->
            NewStCsCharge = #st_small_charge_d{pkey = Pkey};
        {#base_small_charge_d{act_id = BaseActId}, BaseSubList} ->
            BaseChargeGoldList = lists:map(fun(#base_small_charge_d_sub{charge_gold = BaseChargeGold})-> BaseChargeGold end, BaseSubList),
            ChargeGoldList = act_charge:get_charge_list(),
            F = fun(ChargeGold) ->
                lists:member(ChargeGold, BaseChargeGoldList)
            end,
            NewChargeGoldList = lists:filter(F, ChargeGoldList),
            Now = util:unixtime(),
            Flag = util:is_same_date(OpTime, Now),
            if
                BaseActId =/= ActId ->
                    NewStCsCharge =
                        #st_small_charge_d{
                            pkey = Pkey,
                            act_id = BaseActId,
                            charge_list = NewChargeGoldList,
                            op_time = Now
                        };
                Flag == false ->
                    NewStCsCharge =
                        #st_small_charge_d{
                            pkey = Pkey,
                            act_id = BaseActId,
                            charge_list = NewChargeGoldList,
                            op_time = Now
                        };
                true ->
                    NewStCsCharge =
                        StCsCharge#st_small_charge_d{
                            charge_list = NewChargeGoldList,
                            op_time = Now
                        }
            end
    end,
    lib_dict:put(?PROC_STATUS_SMALL_CHARGE_D, NewStCsCharge).

%% 凌晨重置不操作数据库
midnight_refresh(Player) ->
    update_small_charge(Player).

get_act() ->
    case activity:get_work_list(data_small_charge_d) of
        [] -> [];
        [Base | _] -> Base
    end.

get_act(LoginFlag) ->
    case get_act() of
        [] -> [];
        #base_small_charge_d{list = BaseList} = BaseR ->
            case lists:keyfind(LoginFlag, #base_small_charge_d_sub.login_flag, BaseList) of
                false ->
                    case lists:keyfind(all, #base_small_charge_d_sub.login_flag, BaseList) of
                        false -> [];
                        _BaseSubR ->
                            F = fun(BaseSub) -> BaseSub#base_small_charge_d_sub.login_flag == all end,
                            BaseSubList = lists:filter(F, BaseList),
                            {BaseR, BaseSubList}
                    end;
                _BaseSubR ->
                    F = fun(BaseSub) -> BaseSub#base_small_charge_d_sub.login_flag == LoginFlag end,
                    BaseSubList = lists:filter(F, BaseList),
                    {BaseR, BaseSubList}
            end
    end.

add_charge(Player, ChargeVal) ->
    case get_act(util:to_atom(Player#player.login_flag)) of
        [] ->
            skip;
        {_BaseR, BaseSubList} ->
            case lists:keyfind(ChargeVal, #base_small_charge_d_sub.charge_gold, BaseSubList) of
                #base_small_charge_d_sub{charge_gold = BaseChargeGold} ->
                    St = lib_dict:get(?PROC_STATUS_SMALL_CHARGE_D),
                    #st_small_charge_d{
                        charge_list = ChargeList
                    } = St,
                    if
                        ChargeVal == BaseChargeGold ->
                            NewSt =
                                St#st_small_charge_d{
                                    charge_list = [ChargeVal | ChargeList],
                                    op_time = util:unixtime()
                                },
                            lib_dict:put(?PROC_STATUS_SMALL_CHARGE_D, NewSt),
                            activity_load:dbup_small_charge_d(NewSt);
                        true ->
                            ok
                    end;
                _ ->
                    ok
            end
    end.

get_act_info(Player) ->
    case get_act(util:to_atom(Player#player.login_flag)) of
        [] ->
            {0, []};
        {#base_small_charge_d{open_info = OpenInfo}, BaseSubList} ->
            St = lib_dict:get(?PROC_STATUS_SMALL_CHARGE_D),
            #st_small_charge_d{
                recv_list = RecvList,
                charge_list = ChargeList
            } = St,
            ?DEBUG("St:~p", [St]),
            LTime = activity:calc_act_leave_time(OpenInfo),
            F = fun(#base_small_charge_d_sub{num = BaseNum, charge_gold = BaseChargeGold, reward_list = RewardList}) ->
                case lists:member(BaseChargeGold, ChargeList) of
                    true ->
                        BuyNum = length(lists:filter(fun(ChargeGold) ->  ChargeGold == BaseChargeGold end, ChargeList)),
                        case lists:keyfind(BaseChargeGold, 1, RecvList) of
                            false ->
                                [BaseNum, min(BaseNum, BuyNum), BaseChargeGold, 1, util:list_tuple_to_list(RewardList)];
                            {BaseChargeGold, RecvNum} ->
                                if
                                    RecvNum >= BaseNum ->
                                        [BaseNum, min(BaseNum, BuyNum), BaseChargeGold, 2, util:list_tuple_to_list(RewardList)];
                                    true ->
                                        [BaseNum, min(BaseNum, BuyNum), BaseChargeGold, 1, util:list_tuple_to_list(RewardList)]
                                end
                        end;
                    false ->
                        [BaseNum, 0, BaseChargeGold, 0, util:list_tuple_to_list(RewardList)]
                end
            end,
            List = lists:map(F, BaseSubList),
            {LTime, List}
    end.

recv(Player, RecvGold) ->
    case get_act(util:to_atom(Player#player.login_flag)) of
        [] ->
            {0, Player};
        {_BaseR, BaseSubList} ->
            case lists:keyfind(RecvGold, #base_small_charge_d_sub.charge_gold, BaseSubList) of
                false -> {0, Player};
                #base_small_charge_d_sub{charge_gold = BaseChargeGold, reward_list = RewardList, num = BaseLimitBuyNum} ->
                    St = lib_dict:get(?PROC_STATUS_SMALL_CHARGE_D),
                    #st_small_charge_d{
                        recv_list = RecvList,
                        charge_list = ChargeList
                    } = St,
                    RecvNum =
                        case lists:keyfind(RecvGold, 1, RecvList) of
                            false -> 0;
                            {RecvGold, BuyNum0} -> BuyNum0
                        end,
                    BuyNum = min(BaseLimitBuyNum, length(lists:filter(fun(ChargeGold) -> RecvGold == ChargeGold end, ChargeList))),
                    if
                        BuyNum == 0 -> {7, Player}; %% 未达成
                        RecvNum >= BaseLimitBuyNum -> {5, Player}; %% 已经领取
                        RecvNum >= BuyNum -> {5, Player}; %% 已经领取
                        true ->
                            NewSt =
                                case lists:keytake(RecvGold, 1, RecvList) of
                                    false ->
                                        St#st_small_charge_d{
                                            recv_list = [{BaseChargeGold, 1} | RecvList],
                                            op_time = util:unixtime()
                                        };
                                    {value, {RecvGold, OldRecvNum}, Rest} ->
                                        St#st_small_charge_d{
                                            recv_list = [{BaseChargeGold, OldRecvNum + 1} | Rest],
                                            op_time = util:unixtime()
                                        }
                                end,
                            lib_dict:put(?PROC_STATUS_SMALL_CHARGE_D, NewSt),
                            activity_load:dbup_small_charge_d(NewSt),
                            GiveGoodsList = goods:make_give_goods_list(736, RewardList),
                            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                            activity:get_notice(NewPlayer, [175], true),
                            {GoodsId, _GoodsNum} = hd(RewardList),
                            #goods_type{goods_name = GoodsName} = data_goods:get(GoodsId),
                            notice_sys:add_notice(act_small_charge_d, [Player#player.nickname, GoodsName]),
                            Sql = io_lib:format("insert into log_small_charge_d set pkey=~p, recv_list='~s', `time`=~p",
                                [Player#player.key, util:term_to_bitstring(RewardList), util:unixtime()]),
                            log_proc:log(Sql),
                            {1, NewPlayer}
                    end
            end
    end.

get_notice_state(Player) ->
    case get_act(util:to_atom(Player#player.login_flag)) of
        [] -> -1;
        {#base_small_charge_d{act_info = ActInfo}, BaseSubList} ->
            St = lib_dict:get(?PROC_STATUS_SMALL_CHARGE_D),
            #st_small_charge_d{
                recv_list = RecvList,
                charge_list = ChargeList
            } = St,
            F = fun(#base_small_charge_d_sub{num = BaseNum, charge_gold = BaseChargeGold}) ->
                case lists:member(BaseChargeGold, ChargeList) of
                    true ->
                        case lists:keyfind(BaseChargeGold, 1, RecvList) of
                            false -> [1];
                            {BaseChargeGold, RecvNum} ->
                                ?IF_ELSE(RecvNum >= BaseNum, [], [1])
                        end;
                    false -> []
                end
            end,
            List = lists:flatmap(F, BaseSubList),
            IsRecv = ?IF_ELSE(List == [], 0, 1),
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
    Sql = io_lib:format("select pkey, act_id, charge_list, recv_list from player_small_charge_d where op_time >=~p and op_time < ~p", [StartTime, EndTime]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            F = fun([Pkey, ActId, ChargeListBin, RecvListBin]) ->
                #base_small_charge_d{list = BaseSubList} = data_small_charge_d:get(ActId),
                ChargeList = util:bitstring_to_term(ChargeListBin),
                RecvList = util:bitstring_to_term(RecvListBin),
                F = fun(#base_small_charge_d_sub{charge_gold = BaseChargeGold, reward_list = BaseRewardList}) ->
                    case lists:member(BaseChargeGold, ChargeList) of
                        false -> skip;
                        true ->
                            case lists:keyfind(BaseChargeGold, 1, RecvList) of
                                false ->
                                    {Title, Content0} = t_mail:mail_content(151),
                                    Content = io_lib:format(Content0, [BaseChargeGold]),
                                    mail:sys_send_mail([Pkey], Title, Content, BaseRewardList);
                                _ -> skip
                            end
                    end
                end,
                lists:map(F, BaseSubList)
            end,
            lists:map(F, Rows);
        _ ->
            skip
    end.
