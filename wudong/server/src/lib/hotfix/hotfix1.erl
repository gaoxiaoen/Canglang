%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%             lzx
%%% @end
%%% Created : 09. 九月 2017 17:44
%%%-------------------------------------------------------------------
-module(hotfix1).
-include("common.hrl").
-include("activity.hrl").
-include("server.hrl").
-include("daily.hrl").

%% API
-export([fix_hi_fan_tian/0]).

%% gm 修复
fix_hi_fan_tian() ->
    ?ERR("fix_hi_fan_tian"),
    case db:get_all("SELECT pkey,SUM(addgold) FROM log_gold WHERE addreason = 121 AND `time` > 1504886400 GROUP BY pkey") of
        List when is_list(List) ->
            ?WARNING("fix_hi_fan_tian ------------ ~w", [List]),
            lists:foreach(fun([Pkey, ChargeVal]) ->
                case misc:get_player_process(Pkey) of
                    Pid when is_pid(Pid) ->
                        Player = #player{pid = Pid},
                        act_hi_fan_tian:trigger_charge_money(Player,ChargeVal),
                        act_hi_fan_tian:trigger_finish_api(Player,18,1);
                    _ -> %% 补不在线的
                        lists:foreach(fun(ActId) ->
                            case data_hi_config:get(ActId) of
                                #base_hi_config{} ->
                                    util:sleep(200),
                                    out_line_fix(Pkey, ActId, 1, [{charge, ChargeVal}]);
                                _ ->
                                    ok
                            end
                                      end, [19, 20, 21, 22, 23]),
                        out_line_fix(Pkey, 18, 1, [])
                end
                          end, List);
        _ ->
            ok
    end.



%% 离线修复
out_line_fix(Pkey,Hid,Time,Conds1) ->
    case data_hi_config:get(Hid) of
        #base_hi_config{val = Val, time_limit = TimeLimit, condition = Cond2} ->
            case Cond2 of
                [] ->
                    finish_count(Pkey, Hid, Time, Val, TimeLimit);
                Cond2List ->
                    case match_cond(Pkey, Hid, Conds1, Cond2List) of
                        true ->
                            finish_count(Pkey, Hid, Time, Val, TimeLimit);
                        _ ->
                            skip
                    end
            end;
        _ ->
            skip
    end.


match_cond(Pkey,Hid,Conds1,Cond2List) ->
    CondList = get_count_online(Pkey,?DAILY_HI_FAN_TIAN_GET_CON,[]),
    %%以达成条件列表
    case lists:keyfind(Hid, 1, CondList) of
        {_, Cons} -> ok;
        _ ->
            Cons = []
    end,
    %% 筛选符合配置的条件
    MatchList =
        lists:foldl(fun({Key, Val}, AccList) ->
            case lists:keyfind(Key, 1, Cond2List) of
                false ->
                    AccList;
                {_, _} ->
                    [{Key, Val} | AccList]
            end
                    end, [],Conds1),
    
    SumConList = sum_con_list(MatchList,Cons),
    %%比较下条件是否满足了
    case compare_con(Cond2List,SumConList,[]) of
        {ok,NewConList} -> %%满足条件了
            NewTimeList = lists:keystore(Hid,1,CondList,{Hid,NewConList}),
            daily:set_count_outline(Pkey,?DAILY_HI_FAN_TIAN_GET_CON,NewTimeList),
            true;
        _ ->
            NewTimeList = lists:keystore(Hid,1,CondList,{Hid,SumConList}),
            daily:set_count_outline(Pkey,?DAILY_HI_FAN_TIAN_GET_CON,NewTimeList),
            false
    end.

sum_con_list([],_Conds) -> _Conds;
sum_con_list([{Key,Val}|T],Cons) ->
    case lists:keytake(Key,1,Cons) of
        {value, {_,Val2}, ConsList} ->
            sum_con_list(T,[{Key,Val + Val2}|ConsList]);
        false ->
            sum_con_list(T,[{Key,Val}|Cons])
    end.

compare_con([],_,NewConList) -> {ok,NewConList};
compare_con([{Key,Val}|T],SumConList,NewConList) ->
    case lists:keytake(Key,1,SumConList) of
        {value, {_,Val2}, _ConsList} when Val2 >= Val ->
            compare_con(T,SumConList,[{Key,Val2 - Val}|NewConList]);
        _ ->
            false
    end.


get_count_online(Pkey,Type,Default) ->
    case daily:get_count_outline(Pkey,Type) of
        0 -> Default;
        [] -> Default;
        Count -> Count
    end.



finish_count(Pkey,Hid,Time,Val,TimeLimit) ->
    TimeCntList = get_count_online(Pkey,?DAILY_HI_FAN_TIAN_TIME,[]),
    TodayPoint = get_count_online(Pkey,?DAILY_HI_FAN_TIAN_POINT,0),
    case lists:keyfind(Hid,1,TimeCntList) of
        {_,CurTime} -> ok;
        _ ->
            CurTime = 0
    end,
    case CurTime >= TimeLimit of
        true -> skip;
        false ->
            NewTime = min(CurTime + Time,TimeLimit),
            NewPoint = (NewTime - CurTime) * Val + TodayPoint,
            NewTimeList = lists:keystore(Hid,1,TimeCntList,{Hid,NewTime}),
            daily:set_count_outline(Pkey,?DAILY_HI_FAN_TIAN_TIME,NewTimeList),
            daily:set_count_outline(Pkey,?DAILY_HI_FAN_TIAN_POINT,NewPoint)
    end.





