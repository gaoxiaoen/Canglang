%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 连续充值
%%% @end
%%% Created : 16. 六月 2016 上午11:00
%%%-------------------------------------------------------------------
-module(act_con_charge).
-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("daily.hrl").

-define(INF_INF, 99999999). %% 防止配置错误，最大领取限制

%% API
-export([
    get_acc_charge_info/1,
    get_cum_award/2,
    get_daily_award/2,
    gm_reset/0
]).

-export([
    init/1,
    midnight_refresh/1,
    get_state/1,
    add_charge_val/2,  %%增加累计充值额度
    get_act/0
]).

init(Player) ->
    AccChargeSt = activity_load:dbget_act_con_charge(Player),
    lib_dict:put(?PROC_STATUS_ACT_CON_CHARGE, AccChargeSt),
    update(),
    Player.

gm_reset() ->
    lib_dict:put(?PROC_STATUS_ACT_CON_CHARGE, []).

%%更新活动信息
update() ->
    AccChargeSt = lib_dict:get(?PROC_STATUS_ACT_CON_CHARGE),
    #st_con_recharge{
        pkey = Pkey
        , act_id = ActId
    } = AccChargeSt,
    case get_act() of %%判断是否新活动
        [] ->
            NewAccChargeSt = #st_con_recharge{pkey = Pkey};
        #base_act_con_recharge{act_id = BaseActId} ->
            if
                BaseActId =/= ActId ->
                    NewAccChargeSt = #st_con_recharge{pkey = Pkey, act_id = BaseActId};
                true ->
                    NewAccChargeSt = AccChargeSt
            end
    end,
    lib_dict:put(?PROC_STATUS_ACT_CON_CHARGE, NewAccChargeSt).

%% 凌晨重置不操作数据库
midnight_refresh(_Player) ->
    St = lib_dict:get(?PROC_STATUS_ACT_CON_CHARGE),
    #st_con_recharge{
        pkey = Pkey
        , act_id = ActId
    } = St,
    case get_act() of %%判断是否新活动
        [] ->
            NewAccChargeSt = #st_con_recharge{pkey = Pkey};
        #base_act_con_recharge{act_id = BaseActId} ->
            if
                BaseActId =/= ActId ->
                    NewAccChargeSt = #st_con_recharge{pkey = Pkey, act_id = BaseActId};
                true ->
                    NewAccChargeSt = St#st_con_recharge{daily_list = []}
            end
    end,
    lib_dict:put(?PROC_STATUS_ACT_CON_CHARGE, NewAccChargeSt).


%%获取累计充值信息
get_acc_charge_info(Player) ->
    Data = get_act_info(Player),
    {ok, Bin} = pt_432:write(43288, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.


%%获取活动状态
get_act_info(Player) ->
    St = lib_dict:get(?PROC_STATUS_ACT_CON_CHARGE),
    case St of
        [] ->
            init(Player),
            get_act_info(Player);
        _ ->
            case get_act() of
                [] -> {0, 0, [], []};  %%没有活动
                Base0 ->
                    BaseDailyList0 = Base0#base_act_con_recharge.daily_list,
                    CumList= Base0#base_act_con_recharge.cum_list,
                    GoldList= Base0#base_act_con_recharge.gold_list,
                    CumRecharge= Base0#base_act_con_recharge.cum_recharge,

                    %%计算活动剩余时间
                    LeaveTime = activity:get_leave_time(data_act_con_charge),
                    Val = get_today_charge(),
                    Day = activity:get_start_day(data_act_con_charge),
                    BaseDailyList =
                        case lists:keyfind(Day, #base_con_recharge_award.day, BaseDailyList0) of
                            false -> [X || X <- BaseDailyList0, X#base_con_recharge_award.day == 1];
                            _ ->
                                [X || X <- BaseDailyList0, X#base_con_recharge_award.day == Day]
                        end,
                    %%活动每日奖励信息
                    F = fun(Base, List) ->
                        DailyState = check_daily(Base0, Base#base_con_recharge_award.id),
                        [[
                            Base#base_con_recharge_award.id,
                            DailyState,
                            Base#base_con_recharge_award.gold,
                            [tuple_to_list(X) || X <- Base#base_con_recharge_award.award]
                        ] | List]
                    end,
                    NewDailyList = lists:foldl(F, [], BaseDailyList),

                    %%活动累计奖励信息
                    F0 = fun(Base, List) ->
                        CumState = check_cum(Base0, Base#base_con_recharge_award.id),
                        [[
                            Base#base_con_recharge_award.day,
                            Base#base_con_recharge_award.id,
                            CumState,
                            Base#base_con_recharge_award.gold,
                            [tuple_to_list(X) || X <- Base#base_con_recharge_award.award]
                        ] | List]
                    end,
                    NewCumList0 = lists:foldl(F0, [], CumList),
                    NewCumList = make_cum_list(NewCumList0, GoldList, CumRecharge),
                    {LeaveTime, Val, NewDailyList, NewCumList}
            end
    end.

get_today_charge() ->
    Day = activity:get_start_day(data_act_con_charge),
    AccChargeSt = lib_dict:get(?PROC_STATUS_ACT_CON_CHARGE),
    #st_con_recharge{
        recharge_list = RechargeList
    } = AccChargeSt,
    case lists:keytake(Day, 1, RechargeList) of
        false ->
            0;
        {value, {Day, Val}, _List} ->
            Val
    end.

check_daily(Base, Id) ->
    case check_daily_award(Base, Id) of
        {false, 3} -> 1; %% 已领取
        {false, _} -> 0; %% 不可领取
        {ok, _} -> 2 %% 可领取
    end.

check_cum(Base, Id) ->
    case check_cum_award(Base, Id) of
        {false, 3} -> 1; %% 已领取
        {false, _} -> 0; %% 不可领取
        {ok, _} -> 2 %% 可领取
    end.

make_cum_list(List, GoldList, CumRecharge) ->
    AccChargeSt = lib_dict:get(?PROC_STATUS_ACT_CON_CHARGE),
    #st_con_recharge{
        act_list = ActList,
        recharge_list = RechargeList
    } = AccChargeSt,
    F = fun(Gold, List0) ->
        List1 = [[Id, State, Day, get_cum_days(Gold, Day, RechargeList), Award] || [Day, Id, State, Gold0, Award] <- List, Gold0 == Gold],
        ActState =
            case lists:keyfind(Gold, 2, ActList) of
                false -> 0;
                {_, _, State0} ->
                    State0
            end,
        case lists:keyfind(Gold, 2, CumRecharge) of
            false ->
                [[Gold, ActState, 0, List1] | List0];
            {_Id, Gold, NeedGold} ->
                [[Gold, ActState, NeedGold, List1] | List0]
        end
    end,
    lists:foldl(F, [], GoldList).

get_cum_days(Gold, _Days, RechargeList) ->
    F0 = fun({_, Val}, Sum) ->
        ?IF_ELSE(Val >= Gold, Sum + 1, Sum)
    end,
    lists:foldl(F0, 0, RechargeList).


%%获取活动领取状态
get_state(Player) ->
    St = lib_dict:get(?PROC_STATUS_ACT_CON_CHARGE),
    Day = activity:get_start_day(data_act_con_charge),
    case St of
        [] ->
            init(Player),
            get_state(Player);
        _ ->
            case get_act() of
                [] -> -1;
                Base0 ->
                    BaseDailyList = Base0#base_act_con_recharge.daily_list,
                    CumList = Base0#base_act_con_recharge.cum_list,
                    ActInfo = Base0#base_act_con_recharge.act_info,
                    LeaveTime = activity:get_leave_time(data_act_con_charge),
                    if
                        LeaveTime =< 0 -> -1;
                        true ->
                            NewBaseDailyList0 = [X || X <- BaseDailyList, X#base_con_recharge_award.day == Day],
                            NewBaseDailyList = ?IF_ELSE(NewBaseDailyList0 == [], [X || X <- BaseDailyList, X#base_con_recharge_award.day == 1], NewBaseDailyList0),
                            %%活动每日奖励信息
                            F = fun(Base, Flag) ->
                                case Flag of
                                    true -> true;
                                    false ->
                                        DailyState = check_daily(Base0, Base#base_con_recharge_award.id),
                                        ?IF_ELSE(DailyState == 2, true, false)
                                end
                            end,
                            State0 = lists:foldl(F, false, NewBaseDailyList),
                            %%活动累计奖励信息
                            F0 = fun(Base, Flag) ->
                                case Flag of
                                    true -> true;
                                    false ->
                                        CumState = check_cum(Base0, Base#base_con_recharge_award.id),
                                        ?IF_ELSE(CumState == 2, true, false)
                                end
                            end,
                            State1 = lists:foldl(F0, false, CumList),
                            Args = activity:get_base_state(ActInfo),
                            if
                                State0 == true -> {1, Args};
                                State1 == true -> {1, Args};
                                true -> {0, Args}
                            end
                    end
            end
    end.


%%增加充值额度
add_charge_val(_Player, AddExp) ->
    AccChargeSt = lib_dict:get(?PROC_STATUS_ACT_CON_CHARGE),
    #st_con_recharge{
        act_list = ActList,
        recharge_list = RechargeList
    } = AccChargeSt,
    Day = activity:get_start_day(data_act_con_charge),
    NewRechargeList =
        case lists:keytake(Day, 1, RechargeList) of
            false ->
                [{Day, AddExp} | RechargeList];
            {value, {Day, Val}, List} ->
                [{Day, AddExp + Val} | List]
        end,

    NewActList =
        case get_act() of
            [] -> ActList;
            Base ->
                case lists:keyfind(Day, 1, NewRechargeList) of
                    false -> ActList; %% 充值不足
                    {Day, TodayValue} ->
                        F = fun({Id, Gold, NeedGold}, List) ->
                            case lists:keytake(Id, 1, List) of
                                false ->
                                    if TodayValue >= NeedGold ->
                                        [{Id, Gold, 1} | List];
                                        true -> List
                                    end;
                                {value, {Id, Gold, State}, List0} ->
                                    if TodayValue >= NeedGold ->
                                        [{Id, Gold, 1} | List0];
                                        true -> [{Id, Gold, State} | List0]
                                    end
                            end
                        end,
                        lists:foldl(F, ActList, Base#base_act_con_recharge.cum_recharge)
                end
        end,
    NewAccChargeSt = AccChargeSt#st_con_recharge{recharge_list = NewRechargeList, act_list = NewActList, change_time = util:unixtime()},
    lib_dict:put(?PROC_STATUS_ACT_CON_CHARGE, NewAccChargeSt),
    activity_load:dbup_act_con_charge(NewAccChargeSt),
    ok.

get_act() ->
    case activity:get_work_list(data_act_con_charge) of
        [] -> [];
        [Base | _] -> Base
    end.

get_cum_award(Player, Id) ->
    case get_act() of
        [] -> {fale, 0};
        Base0 ->
            case check_cum_award(Base0, Id) of
                {false, Res} -> {false, Res};
                {ok, Base} ->
                    Base#base_con_recharge_award.award,
                    AccChargeSt = lib_dict:get(?PROC_STATUS_ACT_CON_CHARGE),
                    #st_con_recharge{
                        award_list = AwardList
                    } = AccChargeSt,
                    lib_dict:put(?PROC_STATUS_ACT_CON_CHARGE, AccChargeSt#st_con_recharge{award_list = [Id | AwardList]}),
                    GoodsList = goods:make_give_goods_list(275, Base#base_con_recharge_award.award),
                    activity:get_notice(Player, [123], true),
                    log_act_con_charge(Player#player.key, Player#player.nickname, Player#player.lv, 1, Id),
                    activity_load:dbup_act_con_charge(AccChargeSt#st_con_recharge{award_list = [Id | AwardList], change_time = util:unixtime()}),
                    {ok, NewPlayer} = goods:give_goods(Player, GoodsList),
                    {ok, NewPlayer}
            end
    end.

check_cum_award(Base, Id) ->
    AccChargeSt = lib_dict:get(?PROC_STATUS_ACT_CON_CHARGE),
    #st_con_recharge{
        recharge_list = RechargeList,
        award_list = AwardList
    } = AccChargeSt,
    if
        Base == [] -> {false, 0};
        true ->
            case lists:member(Id, AwardList) of
                true -> {false, 3};
                _ ->
                    F = fun({_Day1, Val1}, {_Day2, Val2}) ->
                        Val1 > Val2
                    end,
                    List = lists:sort(F, RechargeList),
                    CumList = Base#base_act_con_recharge.cum_list,
                    Len = length(List),
                    case lists:keyfind(Id, #base_con_recharge_award.id, CumList) of
                        false -> {false, 3};
                        BaseAward ->
                            TodayCharge = get_today_charge(),
                            Days = BaseAward#base_con_recharge_award.day,
                            Gold = BaseAward#base_con_recharge_award.gold,
                            NeedGold =
                                case lists:keyfind(Gold, 2, Base#base_act_con_recharge.cum_recharge) of
                                    false -> ?INF_INF;
                                    {_, Gold, NeedGold0} -> NeedGold0
                                end,
                            if
                                TodayCharge >= NeedGold -> {ok, BaseAward};
                                Len < Days andalso TodayCharge < NeedGold -> {false, 16};
                                true ->
                                    NewList = lists:sublist(List, Days),
                                    Predicate = fun({_, Val}) -> Val >= Gold end,
                                    case lists:all(Predicate, NewList) of
                                        true -> {ok, BaseAward};
                                        false -> {false, 16}
                                    end
                            end
                    end
            end
    end.

get_daily_award(Player, Id) ->
    case get_act() of
        [] -> {false, 0};
        Base0 ->
            case check_daily_award(Base0, Id) of
                {false, Res} -> {false, Res};
                {ok, Base} ->
                    AccChargeSt = lib_dict:get(?PROC_STATUS_ACT_CON_CHARGE),
                    #st_con_recharge{
                        daily_list = DailyList
                    } = AccChargeSt,
                    lib_dict:put(?PROC_STATUS_ACT_CON_CHARGE, AccChargeSt#st_con_recharge{daily_list = [Id | DailyList]}),
                    GoodsList = goods:make_give_goods_list(275, Base#base_con_recharge_award.award),
                    activity:get_notice(Player, [123], true),
                    log_act_con_charge(Player#player.key, Player#player.nickname, Player#player.lv, 0, Id),
                    activity_load:dbup_act_con_charge(AccChargeSt#st_con_recharge{daily_list = [Id | DailyList], change_time = util:unixtime()}),
                    {ok, NewPlayer} = goods:give_goods(Player, GoodsList),
                    {ok, NewPlayer}
            end
    end.

check_daily_award(Base, Id) ->
    AccChargeSt = lib_dict:get(?PROC_STATUS_ACT_CON_CHARGE),
    #st_con_recharge{
        recharge_list = RechargeList,
        daily_list = DailyList
    } = AccChargeSt,
    Day = activity:get_start_day(data_act_con_charge),
    if
        Base == [] -> {false, 0};
        true ->
            case lists:member(Id, DailyList) of
                true -> {false, 3};
                _ ->
                    BaseDailyList = Base#base_act_con_recharge.daily_list,
                    case lists:keyfind(Id, #base_con_recharge_award.id, BaseDailyList) of
                        false -> {false, 3};
                        BaseAward ->
                            case lists:keyfind(Day, 1, RechargeList) of
                                false -> {false, 17}; %% 充值不足
                                {Day, Value} ->
                                    if
                                        Value < BaseAward#base_con_recharge_award.gold -> {false, 17}; %% 充值不足
                                        true ->
                                            {ok, BaseAward}
                                    end
                            end
                    end
            end
    end.

log_act_con_charge(Pkey, Nickname, Lv, Type, Id) ->
    Sql = io_lib:format("insert into  log_act_con_charge (pkey, nickname,lv,type,n_id,time) VALUES(~p,'~s',~p,~p,~p,~p)",
        [Pkey, Nickname, Lv, Type, Id, util:unixtime()]),
    log_proc:log(Sql),
    ok.
