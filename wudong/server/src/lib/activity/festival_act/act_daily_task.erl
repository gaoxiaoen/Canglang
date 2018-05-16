%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 每日任务活动
%%% @end
%%% Created : 23. 九月 2017 11:08
%%%-------------------------------------------------------------------
-module(act_daily_task).
-author("Administrator").
-include("activity.hrl").
-include("server.hrl").
-include("common.hrl").
-include("daily.hrl").

%% API
-export([
    init/1,
    update/0,
    trigger_finish/3,
    log_out/0,
    get_info/1,
    get_reward/2,
    get_state/1,
    gm/0,
    gm1/0
]).

init(#player{key = Pkey} = Player) ->
    St =
        case player_util:is_new_role(Player) of
            true -> #st_act_daily_task{pkey = Pkey};
            false ->
                activity_load:dbget_act_daily_task(Pkey)
        end,
    put_dict(St),
    update(),
    Player.

update() ->
    St = get_dict(),
    #st_act_daily_task{
        pkey = Pkey,
        last_login_time = LastLoginTime
    } = St,
    Now = util:unixtime(),
    Flag = util:is_same_date(Now, LastLoginTime),
    if
        Flag == false ->
            NewSt = #st_act_daily_task{pkey = Pkey, last_login_time = Now};
        true ->
            NewSt = St#st_act_daily_task{last_login_time = Now}
    end,
    put_dict(NewSt).

is_open() ->
    case get_act() of
        [] -> false;
        _ -> true
    end.

get_act() ->
    case activity:get_work_list(data_act_daily_task) of
        [Base | _] -> Base;
        _ ->
            []
    end.

get_leave_time() ->
    activity:get_leave_time(data_act_daily_task).


%% Tid  1 幸运翻牌  2 挑战财神
trigger_finish(Player, Tid, Times) ->
    case is_open() of
        false -> skip;
        true ->
            St = get_dict(),
            #st_act_daily_task{
                trigger_list = TriggerList
            } = St,
            NewTriggerList =
                case lists:keytake(Tid, 1, TriggerList) of
                    false ->
                        [{Tid, Times} | TriggerList];
                    {value, {Tid, Val}, List} ->
                        [{Tid, Val + Times} | List]
                end,
            NewSt = St#st_act_daily_task{trigger_list = NewTriggerList},
            put_dict(NewSt),
            Data = act_daily_task:get_info(Player),
            {ok, Bin} = pt_438:write(43831, Data),
            server_send:send_to_sid(Player#player.sid, Bin)
    end,
    festival_state:send_all(Player),
    ok.

log_out() ->
    St = get_dict(),
    activity_load:dbup_act_daily_task(St),
    ok.

get_dict() ->
    lib_dict:get(?PROC_STATUS_ACT_DAILY_TASK).

put_dict(St) ->
    lib_dict:put(?PROC_STATUS_ACT_DAILY_TASK, St).

get_info(_Player) ->
    case get_act() of
        [] -> {0, []};
        Base ->
            St = get_dict(),
            AwardList = Base#base_daily_task.award_list,
            F = fun({Id, Type, Count, RewardList0}) ->
                RewardList = goods:pack_goods(RewardList0),
                case lists:member(Id, St#st_act_daily_task.get_list) of
                    true ->
                        [Id, Type, 2, Count, Count, RewardList];
                    false ->
                        case lists:keyfind(Type, 1, St#st_act_daily_task.trigger_list) of
                            {Type, NowCount} ->
                                if
                                    NowCount >= Count ->
                                        [Id, Type, 1, Count, Count, RewardList];
                                    true ->
                                        [Id, Type, 0, NowCount, Count, RewardList]
                                end;
                            false ->
                                [Id, Type, 0, 0, Count, RewardList]
                        end
                end
            end,
            ReAwardList = lists:map(F, AwardList),
            LeaveTime = get_leave_time(),
            {LeaveTime, ReAwardList}
    end.

get_reward(Player, Id) ->
    case get_act() of
        [] -> {false, 0};
        Base ->
            St = get_dict(),
            case check_get_reward(Player, Base, Id, St) of
                {false, Res} -> {Res, Player};
                {ok, GoodsList} ->
                    NewSt = St#st_act_daily_task{get_list = [Id | St#st_act_daily_task.get_list]},
                    put_dict(NewSt),
                    activity_load:dbup_act_daily_task(NewSt),
                    {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(304, GoodsList)),
                    festival_state:send_all(NewPlayer),
                    log_act_daily_task(Player#player.key, Player#player.nickname, GoodsList),
                    {1, NewPlayer}
            end
    end.

%%{id,类型,次数,[{物品ID,物品数量}]}
check_get_reward(_Player, Base, Id, St) ->
    case lists:keyfind(Id, 1, Base#base_daily_task.award_list) of
        false -> {false, 0};
        {Id, Type, NeedCount, GoodsList} ->
            case lists:member(Id, St#st_act_daily_task.get_list) of
                true -> {false, 10};
                false ->
                    case lists:keyfind(Type, 1, St#st_act_daily_task.trigger_list) of
                        false -> {false, 11};
                        {Type, NowCount} ->
                            if NowCount >= NeedCount -> {ok, GoodsList};
                                true -> {false, 11}
                            end
                    end
            end
    end.

gm() ->
    ?DEBUG("gmgm ~n"),
    St = get_dict(),
    put_dict(St#st_act_daily_task{trigger_list = [{1, 100}, {2, 100}]}),
    activity_load:dbup_act_daily_task(St#st_act_daily_task{trigger_list = [{1, 100}, {2, 100}]}),
    ok.
gm1() ->
    St = get_dict(),
    put_dict(St#st_act_daily_task{trigger_list = [{1, 0}, {2, 0}]}),
    activity_load:dbup_act_daily_task(St#st_act_daily_task{trigger_list = [{1, 0}, {2, 0}]}),
    ok.

get_state(Player) ->
    case get_act() of
        [] -> -1;
        Base ->
            St = get_dict(),
            F = fun({Id, _, _, _}) ->
                case check_get_reward(Player, Base, Id, St) of
                    {ok, _} -> true;
                    _ -> false
                end
            end,
            case lists:any(F, Base#base_daily_task.award_list) of
                false -> 0;
                true -> 1
            end
    end.

log_act_daily_task(Pkey, Nickname, GoodsList) ->
    Sql = io_lib:format("insert into log_act_daily_task set pkey=~p,nickname='~s',goods_list = '~s',time=~p", [Pkey, Nickname, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql),
    ok.
