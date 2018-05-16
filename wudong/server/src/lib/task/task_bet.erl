%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%     点金任务
%%% @end
%%% Created : 08. 五月 2017 14:26
%%%-------------------------------------------------------------------
-module(task_bet).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("task.hrl").
%% API
-export([refresh_task/3, bet/1]).


%%刷新任务
refresh_task(Player, Now, IsNotice) ->
    case task:get_task_by_type(?TASK_TYPE_BET) of
        [] ->
            check_task(Player, IsNotice);
        [Task | _] ->
            case util:is_same_date(Now, Task#task.accept_time) of
                true -> ok;
                false ->
                    task:del_task_by_type(?TASK_TYPE_BET, Player#player.sid),
                    check_task(Player, IsNotice)
            end
    end.

check_task(Player, IsNotice) ->
    case check_task_accept(Player) of
        false -> ok;
        Task ->
            task:accept_special_task(Player#player.sid, Task, IsNotice)
    end.

check_task_accept(Player) ->
    StTask = task_init:get_task_st(),
    F = fun(TaskId) ->
        case lists:member(TaskId, StTask#st_task.loglist_cl) of
            true -> [];
            false ->
                Task = task_init:task_data(TaskId, ?TASK_TYPE_BET),
                case lists:keyfind(lv, 1, Task#task.accept) of
                    false -> [];
                    {lv, Lv} ->
                        if Player#player.lv < Lv -> [];
                            true ->
                                case lists:keyfind(lv_down, 1, Task#task.accept) of
                                    false -> [];
                                    {_, LvDown} ->
                                        if Player#player.lv > LvDown -> [];
                                            true ->
                                                case lists:keyfind(open_day, 1, Task#task.accept) of
                                                    false -> [];
                                                    {_, DayList} ->
                                                        OpenDay = config:get_open_days(),
                                                        case lists:member(OpenDay, DayList) of
                                                            false -> [];
                                                            true -> [Task]
                                                        end
                                                end
                                        end
                                end
                        end
                end
        end
        end,
    case lists:flatmap(F, data_task_bet:task_ids()) of
        [] -> false;
        [Task | _] -> Task
    end.

%%点金
bet(Player) ->
    case task:get_task_by_type(?TASK_TYPE_BET) of
        [] ->
            {7, 0, Player};
        [Task | _] ->
            if Task#task.state == ?TASK_ST_FINISH ->
                {50, 0, Player};
                true ->
                    Gold = base_gold(Task),
                    case money:is_enough(Player, Gold, gold) of
                        false -> {51, 0, Player};
                        true ->
                            Player1 = money:add_no_bind_gold(Player, -Gold, 257, 0, 0),
                            BGold = bet_mult() * Gold,
                            NewPlayer = money:add_bind_gold(Player1, BGold, 257, 0, 0),
%%                            task_event:event(?TASK_ACT_BET, {1}),
                            task:auto_finish(Player, Task#task.taskid),
                            {1, BGold, NewPlayer}
                    end
            end
    end.

bet_mult() ->
    RatioList = [{Id, data_task_bet_conf:get_ratio(Id)} || Id <- data_task_bet_conf:id_list()],
    Id = util:list_rand_ratio(RatioList),
    data_task_bet_conf:get_reward(Id).

base_gold(Task) ->
    case lists:keyfind(?TASK_ACT_BET, 1, Task#task.state_data) of
        false -> 0;
        {_, Gold, _, _} ->
            Gold
    end.