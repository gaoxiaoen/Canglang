%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 六月 2017 14:45
%%%-------------------------------------------------------------------
-module(consume_back_charge).
-author("li").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("activity.hrl").

%% API
-export([
    init/1,
    midnight_refresh/1,
    get_act/0,
    get_state/1,
    add_consume/2,
    get_reward/2,
    get_back_percent/1,

    get_act_info/1,
    get_reward_player_list/1,
    read_consume_back_charge_log/2,
    update_consume_back_charge_log/2,
    get_today_list/1,
    get_today_log_list/1,
    draw/1,
    log_out/0
]).

init(#player{key = Pkey} = Player) ->
    StConsumeBackCharge =
        case player_util:is_new_role(Player) of
            true ->
                #st_consume_back_charge{pkey = Pkey};
            false ->
                activity_load:dbget_consume_back_charge(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_CONSUME_BACK_CHARGE, StConsumeBackCharge),
    update_consume_back_charge(),
    repair(Player),
    Player.

update_consume_back_charge() ->
    StConsumeBackCharge = lib_dict:get(?PROC_STATUS_CONSUME_BACK_CHARGE),
    #st_consume_back_charge{
        pkey = Pkey,
        act_id = ActId,
        log = Log,
        op_time = OpTime
    } = StConsumeBackCharge,
    case get_act() of
        [] ->
            NewStConsumeBackCharge = #st_consume_back_charge{pkey = Pkey};
        #base_act_consume_back_charge{act_id = BaseActId} ->
            Now = util:unixtime(),
            Flag = util:is_same_date(Now, OpTime),
            if
                BaseActId =/= ActId ->
                    NewStConsumeBackCharge = #st_consume_back_charge{pkey = Pkey, act_id = BaseActId, op_time = Now, log = clear_log(Log)};
                Flag == false ->
                    NewStConsumeBackCharge = #st_consume_back_charge{pkey = Pkey, act_id = BaseActId, op_time = Now, log = clear_log(Log)};
                true ->
                    NewStConsumeBackCharge = StConsumeBackCharge
            end
    end,
    lib_dict:put(?PROC_STATUS_CONSUME_BACK_CHARGE, NewStConsumeBackCharge).

clear_log(Log) ->
    Now = util:unixtime(),
    F = fun({_ChargeGold, _Percent, _IsUse, OutTime}) ->
        if
            Now - OutTime < 48 * ?ONE_HOUR_SECONDS -> true;
            true -> false
        end
        end,
    lists:filter(F, Log).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_consume_back_charge().

%% 获取面板信息
get_act_info(Player) ->
    case get_act(util:to_atom(Player#player.login_flag)) of
        [] ->
            {0, 0, 0, [], []};
        {ActType, BaseList} ->
            LeaveTime = util:unixdate() + ?ONE_DAY_SECONDS - util:unixtime(),
            StConsumeBackCharge = lib_dict:get(?PROC_STATUS_CONSUME_BACK_CHARGE),
            #st_consume_back_charge{
                consume_gold = ConsumeGold,
                back_list = BackList,
                back_num = BackNum
            } = StConsumeBackCharge,
            UseBackNum = length(BackList) + BackNum,
            RemainConsumeGold = cacl(ConsumeGold, BaseList, min(UseBackNum + 1, ?CONSUME_BACK_CHARGE_MAX_NUM)),
            RemainBackNum = max(0, BackNum),
            F = fun({ChargeGold, Percent, IsUse}) -> [ChargeGold, Percent, IsUse] end,
            List1 = lists:map(F, BackList),
            List2 = get_base_list(ActType, min(length(BackList) + 1, ?CONSUME_BACK_CHARGE_MAX_NUM)),
            List3 = lists:flatmap(fun({BasePercent, _Power}) ->
                [BasePercent] end, data_consume_back_charge_val:get_by_actType_chargeGold(ActType, hd(List2))),
            {LeaveTime, RemainConsumeGold, RemainBackNum, List1, List2, List3}
    end.

cacl(ConsumeGold, BaseList, BackNum) ->
    case lists:keyfind(BackNum, 1, BaseList) of
        false ->
            99999;
        {_BackNum, BaseConsume} ->
            max(0, BaseConsume - ConsumeGold)
    end.

get_base_list(ActType, BaseBackNum) ->
    Ids = data_consume_back_charge:get_ids_by_actType_backNum(ActType, BaseBackNum),
    F = fun(Id) ->
        #base_consume_back_charge{charge_gold = ChargeGold} = data_consume_back_charge:get(Id),
        [ChargeGold]
        end,
    lists:flatmap(F, Ids).

get_reward_player_list(Player) ->
    ?CAST(activity_proc:get_act_pid(), {read_consume_back_charge_log, Player#player.key}).

%% 读取日志
read_consume_back_charge_log(Pkey, LogList) ->
    List = lists:sublist(LogList, 20),
    L = lists:map(fun({Nickname, ChargeGold, Percent}) -> [Nickname, ChargeGold, Percent] end, List),
    {ok, Bin} = pt_433:write(43381, {L}),
    server_send:send_to_key(Pkey, Bin),
    ok.

update_consume_back_charge_log(State, {Nickname, ChargeGold, Percent}) ->
    OldList = State#state.consume_back_charge_log_list,
    OldList2 = ?IF_ELSE(length(OldList) > 40, lists:sublist(OldList, 19), OldList),
    NewState = State#state{consume_back_charge_log_list = [{Nickname, ChargeGold, Percent} | OldList2]},
    NewState.

%% 读取今日的奖励列表
get_today_list(_Player) ->
    case get_act() of
        [] ->
            [];
        _ ->
            StConsumeBackCharge = lib_dict:get(?PROC_STATUS_CONSUME_BACK_CHARGE),
            #st_consume_back_charge{back_list = BackList} = StConsumeBackCharge,
            lists:map(fun({ChargeGold, Percent, IsUse}) -> [ChargeGold, Percent, IsUse] end, BackList)
    end.

%% 查看今日奖励
get_today_log_list(_Player) ->
    case get_act() of
        [] ->
            [];
        _ ->
            StConsumeBackCharge = lib_dict:get(?PROC_STATUS_CONSUME_BACK_CHARGE),
            #st_consume_back_charge{log = LogList, back_gold = TotalBackGold} = StConsumeBackCharge,
            L = lists:map(fun({ChargeGold, Percent, IsUse, OutTime}) ->
                [ChargeGold, Percent, IsUse, OutTime] end, LogList),
            {TotalBackGold, L}
    end.

%% 抽奖
draw(Player) ->
    case get_act(util:to_atom(Player#player.login_flag)) of
        [] ->
            {4, 0, 0, Player};
        {ActType, _BaseList} ->
            StConsumeBackCharge = lib_dict:get(?PROC_STATUS_CONSUME_BACK_CHARGE),
            #st_consume_back_charge{back_num = BackNum, back_list = BackList, log = Log} = StConsumeBackCharge,
            if
                BackNum < 1 ->
                    {19, 0, 0, Player}; %% 没有了抽奖次数
                true ->
                    UseBackNum = BackNum + length(BackList),
                    {ChargeGold, Percent} = op_draw(ActType, min(UseBackNum + 1, ?CONSUME_BACK_CHARGE_MAX_NUM), Player),
                    NewBackNum = BackNum - 1,
                    NewBackList = [{ChargeGold, Percent, 0} | BackList],
                    NewLog = [{ChargeGold, Percent, 0, util:unixdate() + ?ONE_DAY_SECONDS - 1} | Log],
                    NewStConsumeBackCharge =
                        StConsumeBackCharge#st_consume_back_charge{
                            back_num = NewBackNum,
                            back_list = NewBackList,
                            log = NewLog
                        },
                    activity_load:dbup_consume_back_charge(NewStConsumeBackCharge),
                    lib_dict:put(?PROC_STATUS_CONSUME_BACK_CHARGE, NewStConsumeBackCharge),
                    ?CAST(activity_proc:get_act_pid(), {update_consume_back_charge_log, Player#player.nickname, ChargeGold, Percent}),
                    activity:get_notice(Player, [44], true),
                    Sql = io_lib:format("replace into log_consume_back_charge_draw set pkey=~p,charge_gold=~p,percent=~p,time=~p",[Player#player.key,ChargeGold,Percent,util:unixtime()]),
                    log_proc:log(Sql),
                    {1, ChargeGold, Percent, Player}
            end
    end.

log_out() ->
    case get_act() of
        [] ->
            ok;
        _ ->
            StConsumeBackCharge = lib_dict:get(?PROC_STATUS_CONSUME_BACK_CHARGE),
            if
                StConsumeBackCharge#st_consume_back_charge.is_db == 0 -> skip;
                true -> activity_load:dbup_consume_back_charge(StConsumeBackCharge)
            end
    end.

op_draw(ActType, UseBackNum, Player) ->
    Ids = data_consume_back_charge:get_ids_by_actType_backNum(ActType, UseBackNum),
    F = fun(Id) ->
        #base_consume_back_charge{
            charge_gold = BaseChargeGold0,
            power = Power
        } = data_consume_back_charge:get(Id),
        AddPower = data_consume_back_charge_vip:get_by_actType_vip_chargeGold(ActType, Player#player.vip_lv, BaseChargeGold0),
        {BaseChargeGold0, Power + AddPower}
        end,
    L = lists:map(F, Ids),
    BaseChargeGold = util:list_rand_ratio(L),
    Percent = util:list_rand_ratio(data_consume_back_charge_val:get_by_actType_chargeGold(ActType, BaseChargeGold)),
    {BaseChargeGold, Percent}.

get_state(Player) ->
    case get_act(util:to_atom(Player#player.login_flag)) of
        [] ->
            -1;
        _ ->
            StConsumeBackCharge = lib_dict:get(?PROC_STATUS_CONSUME_BACK_CHARGE),
            if
                StConsumeBackCharge#st_consume_back_charge.back_num > 0 -> 1;
                true -> 0
            end
    end.

get_act() ->
    case activity:get_work_list(data_act_consume_back_charge) of
        [] -> [];
        [Base | _] -> Base
    end.

get_act(LoginFlag) ->
    case activity:get_work_list(data_act_consume_back_charge) of
        [] -> [];
        [Base | _] ->
            #base_act_consume_back_charge{act_type_info = ActTypeInfo, list = BaseList} = Base,
            case lists:keyfind(LoginFlag, 1, ActTypeInfo) of
                false ->
                    case lists:keyfind(all, 1, ActTypeInfo) of
                        false ->
                            [];
                        {_, ActType} ->
                            F = fun({Flag, _N1, _N2}) ->
                                ?IF_ELSE(Flag == all, [{_N1, _N2}], [])
                                end,
                            NewBaseList = lists:flatmap(F, BaseList),
                            {ActType, NewBaseList}
                    end;
                {LoginFlag, ActType} ->
                    F = fun({Flag, _N1, _N2}) ->
                        ?IF_ELSE(Flag == LoginFlag, [{_N1, _N2}], [])
                        end,
                    NewBaseList = lists:flatmap(F, BaseList),
                    {ActType, NewBaseList}
            end
    end.

%% 触发活动
add_consume(CostGold, Player) ->
    case get_act(util:to_atom(Player#player.login_flag)) of
        [] ->
            ok;
        {_ActType, BaseList} ->
            StConsumeBackCharge = lib_dict:get(?PROC_STATUS_CONSUME_BACK_CHARGE),
            #st_consume_back_charge{
                back_num = BackNum,
                back_list = BackList,
                consume_gold = ConsumeGold
            } = StConsumeBackCharge,
            TotalConsumeGold = ConsumeGold + CostGold,
            TodayBackNum = length(BackList) + BackNum,
            case lists:keyfind(min(?CONSUME_BACK_CHARGE_MAX_NUM, TodayBackNum + 1), 1, BaseList) of
                false ->
                    ok;
                {_BaseBackNum, BaseConsumeGold} ->
                    if
                        TotalConsumeGold >= BaseConsumeGold ->
                            NewConsumeGold = TotalConsumeGold - BaseConsumeGold,
                            NewBackNum = BackNum + 1;
                        true ->
                            NewConsumeGold = TotalConsumeGold,
                            NewBackNum = BackNum
                    end,
                    NewStConsumeBackCharge =
                        StConsumeBackCharge#st_consume_back_charge{
                            back_num = NewBackNum,
                            consume_gold = NewConsumeGold,
                            is_db = 1
                        },
                    lib_dict:put(?PROC_STATUS_CONSUME_BACK_CHARGE, NewStConsumeBackCharge),
                    activity:get_notice(Player, [44], true),
                    if
                        NewBackNum == BackNum ->
                            ok;
                        true ->
                            add_consume(0, Player)
                    end
            end
    end.

%% 充值后触发接口
get_reward(Player, ChargeGold) ->
    case get_act() of
        [] ->
            ok;
        _ ->
            StConsumeBackCharge = lib_dict:get(?PROC_STATUS_CONSUME_BACK_CHARGE),
            #st_consume_back_charge{
                back_list = BackList,
                back_gold = OldTotalBackGold,
                log = OldLog
            } = StConsumeBackCharge,
            F = fun({BaseChargeGold, _Percent, IsUse}) ->
                IsUse == 0 andalso BaseChargeGold == ChargeGold
                end,
            L1 = lists:filter(F, BackList),
            if
                L1 == [] ->
                    ok;
                true ->
                    TotalPercent = lists:sum(lists:map(fun({_BaseChargeGold, Percent, _IsUse}) -> Percent end, L1)),
                    NewBackList =
                        lists:map(fun({BaseChargeGold, Percent, _IsUse}) ->
                            if
                                BaseChargeGold == ChargeGold ->
                                    {BaseChargeGold, Percent, 1};
                                true ->
                                    {BaseChargeGold, Percent, _IsUse}
                            end
                                  end, BackList),
                    Now = util:unixtime(),
                    NewOldLog =
                        lists:map(fun({BaseChargeGold, Percent, IsUse, OutTime}) ->
                            if
                                OutTime > Now andalso ChargeGold == BaseChargeGold ->
                                    {BaseChargeGold, Percent, 1, OutTime};
                                true ->
                                    {BaseChargeGold, Percent, IsUse, OutTime}
                            end
                                  end, OldLog),
                    BackGold = ChargeGold * TotalPercent div 100,
                    {Title, Content0} = t_mail:mail_content(88),
                    NewChargeGold =
                        case version:get_lan_config() of
                            chn ->
                                ChargeGold div 10;
                            _ ->
                                ChargeGold
                        end,
                    RewardGoodsId =
                        case version:get_lan_config() of
                            vietnam -> 10106;
                            _ -> 10199
                        end,
                    Content = io_lib:format(Content0, [NewChargeGold, TotalPercent, BackGold]),
                    mail:sys_send_mail([Player#player.key], Title, Content, [{RewardGoodsId, BackGold}]),
                    NewTotalBackGold = OldTotalBackGold + BackGold,
                    NewStConsumeBackCharge =
                        StConsumeBackCharge#st_consume_back_charge{
                            back_list = NewBackList,
                            back_gold = NewTotalBackGold,
                            is_db = 1,
                            log = NewOldLog
                        },
                    activity_load:dbup_consume_back_charge(NewStConsumeBackCharge),
                    Sql = io_lib:format("replace into log_consume_back_charge set pkey=~p,charge_gold=~p,percent=~p,time=~p",[Player#player.key,ChargeGold,TotalPercent,util:unixtime()]),
                    log_proc:log(Sql),
                    lib_dict:put(?PROC_STATUS_CONSUME_BACK_CHARGE, NewStConsumeBackCharge)
            end
    end.

get_back_percent(ChargeGold) ->
    StConsumeBackCharge = lib_dict:get(?PROC_STATUS_CONSUME_BACK_CHARGE),
    #st_consume_back_charge{back_list = BackList} = StConsumeBackCharge,
    F = fun({BaseChargeGold, _Percent, IsUse}) ->
        IsUse == 0 andalso BaseChargeGold == ChargeGold
        end,
    L1 = lists:filter(F, BackList),
    L2 = lists:map(fun({_BaseChargeGold, Percent, _IsUse}) -> Percent end, L1),
    ?IF_ELSE(L2 == [], 0, lists:sum(L2)).

repair(Player) ->
    Now = util:unixtime(),
    case Now > 1519401599 of
        true -> skip;
        false ->
            case cache:get({repair_consume_back_recharge, Player#player.key}) of
                Flag when is_integer(Flag) -> skip;
                _ ->
                    cache:set({repair_consume_back_recharge, Player#player.key}, 1, ?ONE_DAY_SECONDS),
                    Sql = io_lib:format("SELECT SUM(oldgold)-SUM(newgold) from log_gold where pkey = ~p and addgold < 0 AND `time` > 1519228800 AND `time` < 1519371000;", [Player#player.key]),
                    case db:get_row(Sql) of
                        [SumGold] when is_integer(SumGold) ->
                            add_consume(SumGold, Player);
                        _ ->
                            ok
                    end
            end
    end.