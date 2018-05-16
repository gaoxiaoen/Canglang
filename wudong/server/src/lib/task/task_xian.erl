%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 十月 2017 16:46
%%%-------------------------------------------------------------------
-module(task_xian).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("xian.hrl").
-include("task.hrl").

%% API
-export([
    refresh_task/2
    , in_finish/0
    , finish_task/2
    , upgrade_lv/1
]).

refresh_task(Player, IsNotice) ->
    NowSec = util:get_seconds_from_midnight(),
    if NowSec < 120 -> Player;
        true ->
            case in_finish() of
                true -> ok;
                false ->
                    case task:get_task_by_type(?TASK_TYPE_XIAN) of
                        [] ->
                            accept_task(Player, IsNotice);
                        _ ->
                            if
                                IsNotice ->
                                    task:del_task_by_type(?TASK_TYPE_XIAN, Player#player.sid);
                                true ->
                                    task:del_task_by_type(?TASK_TYPE_XIAN)
                            end,
                            accept_task(Player, IsNotice)
                    end
            end
    end.

%%是否已完成
in_finish() ->
    StTask = task_init:get_task_st(),
    F = fun(TaskId) ->
        lists:member(TaskId, StTask#st_task.loglist)
    end,
    lists:any(F, data_task_xian:task_ids()).

%% 自动接受任务
accept_task(Player, IsNotice) ->
    case xian_upgrade:get_task_id() of
        [] -> ok;
        TaskId ->
            LimitOpenLv = data_menu_open:get(71),
            case Player#player.lv < LimitOpenLv of
                true -> ok;
                false ->
                    case get_task(TaskId) of
                        [] -> ok;
                        Task ->
                            task:accept_special_task(Player#player.sid, Task, IsNotice),
                            xian_upgrade:init_task_info(Task)
                    end
            end
    end.

%% 完成任务后开始接受个人任务
finish_task(Player, TaskId) ->
    NTaskId = (TaskId rem 100) rem 3,
    NewTaskId = ?IF_ELSE(NTaskId == 0, 3, NTaskId),
    xian_upgrade:commit_task(Player, NewTaskId),
    ?IF_ELSE(TaskId == 3, skip, refresh_task(Player, true)),
    ok.

%%第一次升级90,刷新
upgrade_lv(Player) ->
    case data_menu_open:get(71) of
        LimitLv when Player#player.lv == LimitLv ->
            refresh_task(Player, true);
        _ ->
            skip
    end.

get_task(TaskId) ->
    task_init:task_data(TaskId, ?TASK_TYPE_XIAN).
