%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%          神装副本任务
%%% @end
%%% Created : 11. 十月 2017 16:40
%%%-------------------------------------------------------------------
-module(task_equip).
-author("hxming").

-include("common.hrl").
-include("task.hrl").
-include("server.hrl").

%% API
-export([init/1,midnight_refresh/1]).

init(Player) ->
    case dungeon_equip:get_task_id(Player#player.lv) of
        [] -> ok;
        TaskId ->
            case task:in_trigger(TaskId) orelse task:in_finish(TaskId) of
                true -> ok;
                false ->
                    case task_init:task_data(TaskId, ?TASK_TYPE_EQUIP) of
                        [] -> ok;
                        Task ->
                            task:accept_special_task(Player#player.sid, Task, false)
                    end
            end
    end.


midnight_refresh(Player) ->
    case dungeon_equip:get_task_id(Player#player.lv) of
        [] -> ok;
        TaskId ->
            case task:in_trigger(TaskId) orelse task:in_finish(TaskId) of
                true -> ok;
                false ->
                    case task_init:task_data(TaskId, ?TASK_TYPE_EQUIP) of
                        [] -> ok;
                        Task ->
                            task:accept_special_task(Player#player.sid, Task, true)
                    end
            end
    end.
