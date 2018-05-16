%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         跨服挂机任务
%%% @end
%%% Created : 26. 七月 2017 10:05
%%%-------------------------------------------------------------------
-module(task_dark).
-author("hxming").

-include("task.hrl").
-include("server.hrl").
-include("common.hrl").

%% API
-export([
    refresh_task/2
    , in_finish/0
    , midnight_refresh/1
    , upgrade_lv/1
    , finish_task/1
]).

refresh_task(Player, IsNotice) ->
    NowSec = util:get_seconds_from_midnight(),
    if NowSec < 120 -> Player;
        true ->
            case in_finish() of
                true -> ok;
                false ->
                    case task:get_task_by_type(?TASK_TYPE_DARK) of
                        [] ->
                            accept_task(Player, IsNotice);
                        [Task | _] ->
                            Now = util:unixtime(),
                            case util:is_same_date(Now, Task#task.accept_time) of
                                true -> ok;
                                false ->
                                    if IsNotice ->
                                        task:del_task_by_type(?TASK_TYPE_DARK, Player#player.sid);
                                        true ->
                                            task:del_task_by_type(?TASK_TYPE_DARK)
                                    end,
                                    accept_task(Player, IsNotice)
                            end
                    end
            end
    end.

accept_task(Player, IsNotice) ->
    case get_task(Player#player.lv) of
        [] -> ok;
        Task ->
            task:accept_special_task(Player#player.sid, Task, IsNotice)
    end.

%%零点刷新
midnight_refresh(Player) ->
    task:del_task_by_type(?TASK_TYPE_DARK, Player#player.sid),
    refresh_task(Player, true),
    ok.

%%升级,刷新
upgrade_lv(Player) ->
    refresh_task(Player, true).


%%是否已完成
in_finish() ->
    StTask = task_init:get_task_st(),
    F = fun(TaskId) ->
        lists:member(TaskId, StTask#st_task.loglist_cl)
        end,
    lists:any(F, data_task_dark:task_ids()).


get_task(Plv) ->
    Scene = cross_dark_bribe:get_max_enter_scene(Plv),
    case data_cross_dark_scene_lv:get_task(Scene) of
        [] -> [];
        TaskId ->
            task_init:task_data(TaskId, ?TASK_TYPE_DARK)
    end.

%% 完成任务后就可以开始接个人任务
finish_task(Player) ->
    cross_dark_bribe:trigger_person_task(Player),
    Player.