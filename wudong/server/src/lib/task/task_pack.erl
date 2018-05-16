%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 九月 2015 下午5:22
%%%-------------------------------------------------------------------
-module(task_pack).
-author("fancy").
-include("common.hrl").
-include("task.hrl").

%% API
-export([trans30001/1, pack_state_data/1]).

%%转换任务列表数据
trans30001(TaskList) ->
    F = fun(Task) ->
        [Task#task.taskid, Task#task.state, Task#task.act, Task#task.times, Task#task.times_lim, pack_state_data(Task#task.state_data)]
        end,
    lists:map(F, TaskList).

pack_state_data(TaskState) ->
    F = fun({_ActType, TypeID, TarNum, CurNum}) ->
        [TypeID, TarNum, CurNum]
        end,
    lists:map(F, TaskState).


