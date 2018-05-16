%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十一月 2016 10:02
%%%-------------------------------------------------------------------
-module(achieve).
-author("hxming").

-include("common.hrl").
-include("achieve.hrl").

%% API
-export([
    achieve_view/0,
    achieve_general/0,
    achieve_type/1,
    get_lv_reward/2,
    get_achieve_reward/2,
    trigger_achieve/5,
    get_notice_player/1
]).
-export([achieve_view_other/0]).

-export([cmd_achieve/2, cmd_score/1]).


%%成就概略
achieve_view() ->
    StAch = lib_dict:get(?PROC_STATUS_ACHIEVE),
    ScoreLim = data_achieve_score:get(StAch#st_achieve.lv),
    F = fun(Achieve) -> Achieve#achieve.state == ?ACH_STATE_UNLOCK end,
    F1 = fun(Id) ->
        Lv = data_achieve_score_reward:get_lv(Id),
        case StAch#st_achieve.lv >= Lv of
            true ->
                case lists:member(Id, StAch#st_achieve.log) of
                    false -> true;
                    true -> false
                end;
            false ->
                false
        end
         end,
    RewardState =
        case lists:any(F, StAch#st_achieve.achieve_list) orelse lists:any(F1, data_achieve_score_reward:id_list()) of
            true -> 1;
            false ->
                0
        end,
    {StAch#st_achieve.lv, StAch#st_achieve.score, ScoreLim, RewardState, StAch#st_achieve.score_list}.

achieve_view_other() ->
    StAch = lib_dict:get(?PROC_STATUS_ACHIEVE),
    ScoreLim = data_achieve_score:get(StAch#st_achieve.lv),
    [StAch#st_achieve.lv, StAch#st_achieve.score, ScoreLim, StAch#st_achieve.score_list].


%%成就总览
achieve_general() ->
    StAch = lib_dict:get(?PROC_STATUS_ACHIEVE),
    ScoreLim = data_achieve_score:get(StAch#st_achieve.lv),
    F = fun(Id) ->
        Lv = data_achieve_score_reward:get_lv(Id),
        case StAch#st_achieve.lv >= Lv of
            true ->
                case lists:member(Id, StAch#st_achieve.log) of
                    false -> [Id, ?ACH_STATE_UNLOCK];
                    true -> [Id, ?ACH_STATE_FINISH]
                end;
            false ->
                [Id, ?ACH_STATE_LOCK]
        end
        end,
    LvRewardList = lists:map(F, data_achieve_score_reward:id_list()),
    AchStateList = check_achieve_unlock(StAch),
    {StAch#st_achieve.lv, StAch#st_achieve.score, ScoreLim, LvRewardList, AchStateList}.

%%查询成就子类是否有可领取
check_achieve_unlock(StAch) ->
    F = fun(Type) ->
        F1 = fun(AchId) ->
            case lists:keyfind(AchId, #achieve.ach_id, StAch#st_achieve.achieve_list) of
                false -> false;
                Ach -> Ach#achieve.state == ?ACH_STATE_UNLOCK
            end
             end,
        case lists:any(F1, data_achieve:get_type(Type)) of
            true -> [Type, ?ACH_STATE_UNLOCK];
            false -> [Type, ?ACH_STATE_LOCK]
        end
        end,
    lists:map(F, data_achieve:type_list()).

get_notice_player(_Player) ->
    {_lv, _Score, _ScoreLim, LvRewardList, AchStateList} = achieve_general(),
    L = lists:filter(fun([_Type, Flag]) -> Flag == ?ACH_STATE_UNLOCK end, LvRewardList ++ AchStateList),
    ?IF_ELSE(L == [], 0, 1).

%%成就子类
achieve_type(Type) ->
    StAch = lib_dict:get(?PROC_STATUS_ACHIEVE),
    F = fun(Subtype) ->
        AchieveIds = data_achieve:get_subtype(Type, Subtype),
        case check_achieve_subtype(AchieveIds, StAch#st_achieve.achieve_list) of
            [] -> [];
            AchieveInfo ->
                F1 = fun(AchId, Acc) ->
                    case lists:keyfind(AchId, #achieve.ach_id, StAch#st_achieve.achieve_list) of
                        false ->
                            Acc;
                        Achieve ->
                            ?IF_ELSE(Achieve#achieve.state >= ?ACH_STATE_UNLOCK, Acc + 1, Acc)
                    end
                     end,
                AccCount = lists:foldl(F1, 0, AchieveIds),
                [[Subtype, AccCount, length(AchieveIds)] ++ AchieveInfo]
        end
        end,
    lists:flatmap(F, data_achieve:subtype_list(Type)).


check_achieve_subtype(AchieveIds, AchieveList) ->
    case do_check_achieve_subtype(AchieveIds, AchieveList) of
        [] when AchieveIds /= [] ->
            AchId = lists:last(AchieveIds),
            case lists:keyfind(AchId, #achieve.ach_id, AchieveList) of
                false -> [];
                Achieve ->
                    {Val1, Val2} = Achieve#achieve.value,
                    [AchId, Val1, Val2, Achieve#achieve.state]
            end;
        Data -> Data
    end.
do_check_achieve_subtype([], _AchieveList) ->
    [];
do_check_achieve_subtype([AchId | T], AchieveList) ->
    Base = data_achieve:get(AchId),
    if Base#base_achieve.is_use == 0 ->
        do_check_achieve_subtype(T, AchieveList);
        true ->
            case lists:keyfind(AchId, #achieve.ach_id, AchieveList) of
                false ->
                    [AchId, 0, 0, ?ACH_STATE_LOCK];
                Achieve ->
                    if Achieve#achieve.state == ?ACH_STATE_FINISH ->
                        do_check_achieve_subtype(T, AchieveList);
                        true ->
                            {Val1, Val2} = Achieve#achieve.value,
                            [AchId, Val1, Val2, Achieve#achieve.state]
                    end
            end
    end.

%%获取等级奖励
get_lv_reward(Player, Id) ->
    StAch = lib_dict:get(?PROC_STATUS_ACHIEVE),
    case data_achieve_score_reward:get_lv(Id) of
        [] -> {2, Player};
        Lv ->
            if StAch#st_achieve.lv < Lv -> {3, Player};
                true ->
                    case lists:member(Id, StAch#st_achieve.log) of
                        true -> {4, Player};
                        false ->
                            Log = [Id | StAch#st_achieve.log],
                            NewStAch = StAch#st_achieve{log = Log, is_change = 1},
                            lib_dict:put(?PROC_STATUS_ACHIEVE, NewStAch),
                            RewardList = goods:make_give_goods_list(202, tuple_to_list(data_achieve_score_reward:get_goods(Id))),
                            {ok, NewPlayer} = goods:give_goods(Player, RewardList),
                            achieve_load:log_achieve(Player#player.key, Player#player.nickname, 2, Id),
                            player:apply_state(async, self(), {activity, sys_notice, [107]}),
                            {1, NewPlayer}
                    end
            end
    end.

%%成就奖励
get_achieve_reward(Player, AchId) ->
    case data_achieve:get(AchId) of
        [] -> {5, Player};
        Base ->
            StAch = lib_dict:get(?PROC_STATUS_ACHIEVE),
            case lists:keytake(AchId, #achieve.ach_id, StAch#st_achieve.achieve_list) of
                false -> {6, Player};
                {value, Achieve, T} ->
                    if Achieve#achieve.state == ?ACH_STATE_FINISH -> {7, Player};
                        Achieve#achieve.state == ?ACH_STATE_LOCK -> {6, Player};
                        true ->
                            NewAchieve = Achieve#achieve{state = ?ACH_STATE_FINISH},
                            {Lv, Score} = add_score(StAch#st_achieve.lv, StAch#st_achieve.score, Base#base_achieve.score),
                            RecLog = lists:sublist([AchId | StAch#st_achieve.rec_log], 3),
                            AchieveList = [NewAchieve | T],
                            ScoreList = achieve_init:calc_achieve_score(AchieveList),
                            NewStAch = StAch#st_achieve{lv = Lv, score = Score, achieve_list = AchieveList, score_list = ScoreList, rec_log = RecLog, is_change = 1},
                            lib_dict:put(?PROC_STATUS_ACHIEVE, NewStAch),
                            RewardList = goods:make_give_goods_list(202, tuple_to_list(Base#base_achieve.goods)),
                            {ok, NewPlayer} = goods:give_goods(Player, RewardList),
                            achieve_load:log_achieve(Player#player.key, Player#player.nickname, 1, AchId),
                            player:apply_state(async, self(), {activity, sys_notice, [107]}),
                            {1, NewPlayer#player{achieve_view = achieve_view_other()}}
                    end
            end
    end.

%%增加积分
add_score(Lv, Score, Add) ->
    case data_achieve_score:get(Lv) of
        [] -> {Lv - 1, 0};
        ScoreLim ->
            if Score + Add < ScoreLim -> {Lv, Score + Add};
                true ->
                    add_score(Lv + 1, Score + Add - ScoreLim, 0)
            end
    end.

notice_unlock(Player, AchId, NoticePlv) ->
    if Player#player.lv >= NoticePlv ->
        {ok, Bin} = pt_131:write(13105, {AchId}),
        server_send:send_to_sid(Player#player.sid, Bin),
        ok;
        true -> ok
    end.


%%触发成就
trigger_achieve(Pkey, Type, SubType, Value1, Value2) when is_integer(Pkey) ->
    case player_util:get_player_pid(Pkey) of
        false ->
            trigger_achieve_offline(Pkey, Type, SubType, Value1, Value2);
        Pid ->
            Pid ! {achieve, Type, SubType, Value1, Value2}
    end;
trigger_achieve(Player, Type, SubType, Value1, Value2) ->
%%    ?DEBUG("achieve type ~p  subtype ~p val1 ~p val2 ~p~n", [Type, SubType, Value1, Value2]),
    StAch = lib_dict:get(?PROC_STATUS_ACHIEVE),
    F = fun(AchId, L) ->
        Base = data_achieve:get(AchId),
        if Base#base_achieve.is_use == 0 -> L;
            true ->
                case lists:keytake(AchId, #achieve.ach_id, L) of
                    false ->
                        {NowValue, State} = update_target({0, 0}, {Value1, Value2}, Base#base_achieve.target_value, Base#base_achieve.target_type, Base#base_achieve.compare_type),
                        ?IF_ELSE(State == ?ACH_STATE_UNLOCK, notice_unlock(Player, AchId, Base#base_achieve.notice_lv), ok),
                        [#achieve{ach_id = AchId, value = NowValue, state = State} | L];
                    {value, Achieve, T} ->
                        if Achieve#achieve.state == ?ACH_STATE_UNLOCK orelse Achieve#achieve.state == ?ACH_STATE_FINISH ->
                            [Achieve | T];
                            true ->
                                {NowValue, State} = update_target(Achieve#achieve.value, {Value1, Value2}, Base#base_achieve.target_value, Base#base_achieve.target_type, Base#base_achieve.compare_type),
                                ?IF_ELSE(State == ?ACH_STATE_UNLOCK, notice_unlock(Player, AchId, Base#base_achieve.notice_lv), ok),
                                [Achieve#achieve{value = NowValue, state = State} | T]
                        end
                end
        end
        end,
    AchieveList = lists:foldl(F, StAch#st_achieve.achieve_list, data_achieve:get_subtype(Type, SubType)),
    if AchieveList /= StAch#st_achieve.achieve_list ->
        lib_dict:put(?PROC_STATUS_ACHIEVE, StAch#st_achieve{achieve_list = AchieveList, is_change = 1});
        true ->
            ok
    end.


trigger_achieve_offline(Pkey, Type, SubType, Value1, Value2) ->
    StAch = achieve_init:load(Pkey),
    F = fun(AchId, L) ->
        Base = data_achieve:get(AchId),
        case lists:keytake(AchId, #achieve.ach_id, L) of
            false ->
                {NowValue, State} = update_target({0, 0}, {Value1, Value2}, Base#base_achieve.target_value, Base#base_achieve.target_type, Base#base_achieve.compare_type),
                [#achieve{ach_id = AchId, value = NowValue, state = State} | L];
            {value, Achieve, T} ->
                if Achieve#achieve.state == ?ACH_STATE_UNLOCK orelse Achieve#achieve.state == ?ACH_STATE_FINISH ->
                    [Achieve | T];
                    true ->
                        {NowValue, State} = update_target(Achieve#achieve.value, {Value1, Value2}, Base#base_achieve.target_value, Base#base_achieve.target_type, Base#base_achieve.compare_type),
                        [Achieve#achieve{value = NowValue, state = State} | T]
                end
        end
        end,
    AchieveList = lists:foldl(F, StAch#st_achieve.achieve_list, data_achieve:get_subtype(Type, SubType)),
    if AchieveList /= StAch#st_achieve.achieve_list ->
        achieve_load:replace_achieve(StAch#st_achieve{achieve_list = AchieveList});
        true ->
            ok
    end.




update_target({_CurValue1, CurValue2}, {NewValue1, NewValue2}, {TargetValue1, TargetValue2}, TargetType, CompareType) ->
    if TargetValue1 == 0 ->
        case TargetType of
            1 ->
                %%累加
                if CurValue2 + NewValue2 >= TargetValue2 ->
                    {{TargetValue1, TargetValue2}, ?ACH_STATE_UNLOCK};
                    true ->
                        {{TargetValue1, CurValue2 + NewValue2}, ?ACH_STATE_LOCK}
                end;
            2 ->
                %%单次值
                if
                    CompareType == 1 ->
                        if NewValue2 =< TargetValue2 ->
                            {{TargetValue1, TargetValue2}, ?ACH_STATE_UNLOCK};
                            true ->
                                {{TargetValue1, NewValue2}, ?ACH_STATE_LOCK}
                        end;
                    NewValue2 >= TargetValue2 ->
                        {{TargetValue1, TargetValue2}, ?ACH_STATE_UNLOCK};
                    true ->
                        {{TargetValue1, NewValue2}, ?ACH_STATE_LOCK}
                end
        end;
    %%X值相同
        TargetValue1 == NewValue1 ->
            case TargetType of
                1 ->
                    %%累加
                    if CurValue2 + NewValue2 >= TargetValue2 ->
                        {{TargetValue1, TargetValue2}, ?ACH_STATE_UNLOCK};
                        true ->
                            {{TargetValue1, CurValue2 + NewValue2}, ?ACH_STATE_LOCK}
                    end;
                2 ->
                    %%单次值
                    if
                        CompareType == 1 ->
                            if NewValue2 =< TargetValue2 ->
                                {{TargetValue1, TargetValue2}, ?ACH_STATE_UNLOCK};
                                true ->
                                    {{TargetValue1, NewValue2}, ?ACH_STATE_LOCK}
                            end;
                        NewValue2 >= TargetValue2 ->
                            {{TargetValue1, TargetValue2}, ?ACH_STATE_UNLOCK};
                        true ->
                            {{TargetValue1, NewValue2}, ?ACH_STATE_LOCK}
                    end
            end;
        true ->
            {{TargetValue1, CurValue2}, ?ACH_STATE_LOCK}
    end.

%%完成指定成就
cmd_achieve(Player, AchId) ->
    StAch = lib_dict:get(?PROC_STATUS_ACHIEVE),
    case data_achieve:get(AchId) of
        [] -> ok;
        Base ->
            AchieveList = [#achieve{ach_id = AchId, value = Base#base_achieve.target_value, state = ?ACH_STATE_UNLOCK} | lists:keydelete(AchId, #achieve.ach_id, StAch#st_achieve.achieve_list)],
            NewSt = StAch#st_achieve{achieve_list = AchieveList, is_change = 1},
            lib_dict:put(?PROC_STATUS_ACHIEVE, NewSt),
            notice_unlock(Player, AchId, Base#base_achieve.notice_lv),
            ok
    end.

cmd_score(Score) ->
    StAch = lib_dict:get(?PROC_STATUS_ACHIEVE),
    {Lv, NewScore} = add_score(StAch#st_achieve.lv, StAch#st_achieve.score, Score),
    NewStAch = StAch#st_achieve{lv = Lv, score = NewScore, is_change = 1},
    lib_dict:put(?PROC_STATUS_ACHIEVE, NewStAch),
    ok.

