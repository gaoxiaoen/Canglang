%%----------------------------------------------------
%% @doc 任务模块
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(task_parse).
-export([
        do/2
    ]
).

-include("common.hrl").
-include("task.hrl").

%% @spec do(RecordName::atom(), InitData::tuple()) -> {ok, Data::tuple()} | {false, Reason::bitstring()}
%% @doc #sns{}记录版本转换
do(task_role, {task_role, 1, XxFreeNum, XxFreshTime, XxList}) ->
    do(task_role, {task_role, 2, XxFreeNum, XxFreshTime, XxList, {0, 0}});

do(task_role, {task_role, 2, XxFreeNum, XxFreshTime, XxList, OrangeNum}) ->
    do(task_role, {task_role, 3, XxFreeNum, XxFreshTime, XxList, OrangeNum, 2});

do(task_role, {task_role, 3, XxFreeNum, XxFreshTime, XxList, OrangeNum, _XxType}) ->
    TaskXxElem = #task_xx_elem{type = 9, fresh_time = XxFreshTime, list = XxList},
    do(task_role, {task_role, 4, XxFreeNum, OrangeNum, [TaskXxElem]});

do(task_role, {task_role, 4, V1, V2, V3, V4, Daily}) ->
    {_Label, D1, D2, D3, D4, D5, D6, D7} = Daily,
    do(task_role, {task_role, 5, V1, V2, V3, V4, {daily_info, D1, D2, D3, D4, D5, D6, D7, []}});

do(task_role, TaskRole) ->
    Ver = element(2, TaskRole),
    case Ver =:= ?task_role_ver andalso is_record(TaskRole, task_role) of
        true -> {ok, TaskRole};
        false -> {false, ?L(<<"角色TaskRole扩展数据解析时发生异常">>)}
    end.
