%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         悬赏任务
%%% @end
%%% Created : 04. 五月 2017 17:10
%%%-------------------------------------------------------------------
-module(task_reward).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("task.hrl").
-include("daily.hrl").
%% API
-export([refresh_task/2, midnight_refresh/1, finish_task/1, finish_now/1]).


%%刷新任务
refresh_task(Player, IsNotice) ->
    case task_cycle:is_finish() of
        true ->
            case task:get_task_by_type(?TASK_TYPE_REWARD) of
                [] ->
                    Cycle = daily:get_count(?DAILY_TASK_REWARD),
                    MaxRound = data_task_reward_conf:max_round(),
                    case Cycle < MaxRound of
                        true ->
                            case data_task_reward_conf:get(Player#player.lv, Cycle + 1) of
                                0 -> ok;
                                TaskId ->
                                    case task_init:task_data(TaskId, ?TASK_TYPE_REWARD) of
                                        [] -> ok;
                                        Task ->
                                            task:accept_reward_task(Player#player.sid, Task#task{times = Cycle + 1, times_lim = MaxRound}, IsNotice)
                                    end
                            end;
                        false -> ok
                    end;
                _ -> ok
            end;
        false ->
            if IsNotice ->
                task:del_task_by_type(?TASK_TYPE_REWARD, Player#player.sid);
                true ->
                    task:del_task_by_type(?TASK_TYPE_REWARD)
            end,
            ok
    end.

%%零点刷新,删除任务
midnight_refresh(Player) ->
    task:del_task_by_type(?TASK_TYPE_REWARD, Player#player.sid).

%%完成任务,刷新
finish_task(Player) ->
    daily:increment(?DAILY_TASK_REWARD, 1),
    refresh_task(Player, true),
    %%资源找回
    findback_src:fb_trigger_src(Player, 25, 1),
    Player.

%%立即完成
%%finish_now(Player, _TaskId) ->
%%    case task_init:task_data(TaskId, ?TASK_TYPE_REWARD) of
%%        [] -> {18, Player};
%%        BaseTask ->
%%            case task:get_task(TaskId) of
%%                [] -> {7, Player};
%%                Task ->
%%                    case money:is_enough(Player, BaseTask#task.finish_price, gold) of
%%                        false -> {39, Player};
%%                        true ->
%%                            task:del_task_by_type(?TASK_TYPE_REWARD, Player#player.sid),
%%                            Player1 = money:add_no_bind_gold(Player, -BaseTask#task.finish_price, 242, 0, 0),
%%                            {ok, NewPlayer} = goods:give_goods(Player1, task:trans_task_goods_list(Player1, TaskId, Task#task.goods)),
%%                            daily:increment(?DAILY_TASK_REWARD, 1),
%%                            refresh_task(NewPlayer, true),
%%                            %%资源找回
%%                            act_hi_fan_tian:trigger_finish_api(Player, 6, 1),
%%                            findback_src:fb_trigger_src(Player, 25, 1),
%%                            {1, NewPlayer}
%%                    end
%%            end
%%    end.

finish_now(Player) ->
    Cycle = daily:get_count(?DAILY_TASK_REWARD),
    MaxRound = data_task_reward_conf:max_round(),
    if Cycle >= MaxRound -> {42,Player};
        true ->
            case get_unfinish_task_list(Player#player.lv, Cycle, MaxRound) of
                [] -> {42,Player};
                TaskList ->
                    Price = lists:sum([Task#task.finish_price || Task <- TaskList]),
                    case money:is_enough(Player, Price, gold) of
                        false -> {39, Player};
                        true ->
                            task:del_task_by_type(?TASK_TYPE_REWARD, Player#player.sid),
                            Player1 = money:add_no_bind_gold(Player, -Price, 242, 0, 0),
                            GoodsList = lists:flatmap(fun(Task) -> Task#task.goods end, TaskList),
                            {ok, NewPlayer} = goods:give_goods(Player1, task:trans_task_goods_list(Player1, 0, GoodsList)),
                            daily:set_count(?DAILY_TASK_REWARD, MaxRound),
                            %%资源找回
                            act_hi_fan_tian:trigger_finish_api(Player, 6, MaxRound - Cycle),
                            findback_src:fb_trigger_src(Player, 25, MaxRound - Cycle),
                            {1, NewPlayer}
                    end
            end
    end.

%%获取未完成的任务列表
get_unfinish_task_list(Plv, Cycle, MaxRound) ->
    MaxRound = data_task_reward_conf:max_round(),
    F = fun(Round) ->
        case data_task_reward_conf:get(Plv, Round) of
            0 -> [];
            Tid ->
                case task_init:task_data(Tid, ?TASK_TYPE_REWARD) of
                    [] -> [];
                    Task ->
                        [Task]
                end

        end
        end,
    lists:flatmap(F, lists:seq(Cycle + 1, MaxRound)).
