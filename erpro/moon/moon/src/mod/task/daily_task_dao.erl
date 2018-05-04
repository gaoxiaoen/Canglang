%%----------------------------------------------------
%% @doc daily_task_dao
%%
%% <pre>
%% 已接任务信息表相关操作,role_task
%% </pre>
%% @author yqhuang(QQ:19123767)
%% @end 
%%----------------------------------------------------
-module(daily_task_dao).

-include("task.hrl").
-include("common.hrl").

-export([
        get_daily_task/2
        ,save_task/3
        ,delete_task/3
        ,delete_expire_task/3
    ]
).

%% @get_daily_task(Rid, SrvId) -> Rs
%% @doc
%% <pre>
%% Rid = integer() 角色Id
%% SrvId = string() 服务器标志服
%% Rs = list() 结果，两维数组
%% 获取角色所以已接任务
%% </pre>
get_daily_task(Rid, SrvId) ->
    Sql = <<"select rid, srv_id, id, task_id, is_open, accept_time from daily_task where rid = ~s and srv_id = ~s">>,
    case db:get_all(Sql, [Rid, SrvId]) of
        {ok, Data} ->
            Data;
        {error, _Msg} ->
            case db:get_all(Sql, [Rid, SrvId]) of
                {ok, Data} -> Data;
                {error, _Msg2} ->
                    catch ?INFO("获取角色所有日常任务失败[Rid:~w, SrvId:~s, Msg:~s]", [Rid, SrvId, _Msg2]),
                    []
            end
    end.

%% @save_task(Task, Rid, SrvId) -> AffectedRow
%% @doc
%% <pre>
%% Task = #task{} 任务信息
%% Rid = integer() 角色ID
%% SrvId = string() 服务器标志符
%% 保存日常任务信息
%% </pre>
save_task(#daily_task{id = Id, task_id = TaskId, is_open = IsOpen, accept_time = AcceptTime}, Rid, SrvId) ->
    Sql = <<"replace into daily_task (rid, srv_id, id, task_id, is_open, accept_time) values ( ~s, ~s, ~s, ~s, ~s, ~s)">>,
    %?DEBUG("最后准备保存的日常任务打开状态为~p~n", [IsOpen]),
    db:execute(Sql, [Rid, SrvId, Id, TaskId, IsOpen, AcceptTime]).

%% 删除已经接或已经委托出去的日常任务
delete_task(RoleId, SrvId, TaskId) ->
    Sql = <<"delete from daily_task where rid = ~s and srv_id = ~s and task_id = ~s">>,
    db:execute(Sql, [RoleId, SrvId, TaskId]).

%% 删除过期任务
delete_expire_task(RoleId, SrvId, Time) ->
    Sql = <<"delete from role_task where rid = ~s and srv_id = ~s and accept_time < ~s">>,
    db:execute(Sql, [RoleId, SrvId, Time]).

