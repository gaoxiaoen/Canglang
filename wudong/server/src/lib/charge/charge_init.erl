%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2015 下午5:22
%%%-------------------------------------------------------------------
-module(charge_init).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("charge.hrl").

%% API
-export([
    init/1,
    update/0
]).

init(Player) ->
    ChargeSt = charge_load:dbget_charge_info(Player),
    lib_dict:put(?PROC_STATUS_CHARGE, ChargeSt),
    update(),
    Player.

%%更新充值
update() ->
    ChargeSt = lib_dict:get(?PROC_STATUS_CHARGE),
    List = dict:to_list(ChargeSt#st_charge.dict),
    NewDict = update_helper(ChargeSt#st_charge.pf, List, dict:new()),
    NewChargeSt = ChargeSt#st_charge{
        dict = NewDict
    },
    case NewDict == ChargeSt#st_charge.dict of
        true -> skip;
        false ->
            charge_load:dbup_charge_info(NewChargeSt)
    end,
    lib_dict:put(?PROC_STATUS_CHARGE, NewChargeSt).
update_helper(_Pf, [], Dict) -> Dict;
update_helper(Pf, [{Key, Charge} | Tail], Dict) ->
    #charge{
        id = Id
    } = Charge,
    case data_charge:get(Id, Pf) of
        [] ->
            update_helper(Pf, Tail, Dict);
        BaseCharge ->
            #base_charge{
                refresh_time = RefreshList
            } = BaseCharge,
            NewCharge = update_helper_1(RefreshList, Charge),
            NewDict = dict:store(Key, NewCharge, Dict),
            update_helper(Pf, Tail, NewDict)
    end.
update_helper_1([], Charge) -> Charge;
update_helper_1([Type | Tail], Charge) ->
    #charge{
        last_time = LastTime
    } = Charge,
    IsRefresh =
        case Type of
            all -> true;
            once -> false;
            {weekday, Day} -> %%每周几 0点
                Now = util:unixtime(),
                NowWeekDay = util:get_day_of_week(Now),
                case util:is_same_week(Now, LastTime) of
                    true -> %%同一周
                        LastWeekDay = util:get_day_of_week(LastTime),
                        case NowWeekDay >= Day andalso Day > LastWeekDay of
                            true -> true;
                            false -> false
                        end;
                    false -> %%跨周
                        case util:get_diff_days(Now, LastTime) >= 7 of
                            true -> true;
                            false ->
                                case NowWeekDay >= Day of
                                    true -> true;
                                    false -> false
                                end
                        end
                end;
            {monthday, Day} -> %%每月几号 0点
                Now = util:unixtime(),
                {{_LYear, LastMonth, LastDay}, _} = util:seconds_to_localtime(LastTime),
                {{_NYear, NowMonth, NowDay}, _} = util:seconds_to_localtime(Now),
                case LastMonth == NowMonth of
                    true -> %%同一个月
                        case NowDay >= Day andalso Day > LastDay of
                            true -> true;
                            false -> false
                        end;
                    false -> %%跨月
                        case util:get_diff_days(Now, LastTime) >= 30 of
                            true -> true;
                            false ->
                                case NowDay >= Day of
                                    true -> true;
                                    false -> false
                                end
                        end
                end;
            {openday, Day} -> %%开服第几天 0点
                Now = util:unixtime(),
                OpenDay = config:get_open_days(),
                DiffDay = util:get_diff_days(Now, LastTime),
                case OpenDay - DiffDay < Day andalso OpenDay >= Day of
                    true -> true;
                    false -> false
                end;
            {date, LocalTime} ->
                %%{{2018,02,16},{00,00,00}}
                ResetTime = util:get_today_midnight(util:localtime2unixtime(LocalTime)),
                TodayMidnight = util:get_today_midnight(),
                if TodayMidnight == ResetTime andalso LastTime < ResetTime -> true;
                    true ->
                        false
                end;
            _ ->
                false
        end,
    case IsRefresh of
        false -> update_helper_1(Tail, Charge);
        true ->
            Charge#charge{
                times = 0,
                last_time = 0
            }
    end.
