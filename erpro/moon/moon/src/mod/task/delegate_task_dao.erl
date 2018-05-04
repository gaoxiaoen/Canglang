%%----------------------------------------------------
%% @doc delegate_task_dao
%%
%% <pre>
%% 日常任务信息表相关操作, delegate_task
%% </pre>
%%----------------------------------------------------
-module(delegate_task_dao).

-include("task.hrl").
-include("common.hrl").

-export([
        load_data/0
        ,save_task/6
        ,delete_task/3
    ]
).

%% 加载委托任务数据
load_data() ->
    Sql = <<"select id, time, role_id, srv_id, mail_id, mail_quality from delegate_task">>,
    case db:get_all(Sql, []) of
        {ok, Data} ->
            %%?DEBUG("===========>> 从日常任务数据库加载到数据:~p~n", [Data]),
            {ok, Data};
        {error, _Msg} ->
            case db:get_all(Sql, []) of
                {ok, Data} -> Data;
                {error, _Msg2} ->
                    catch ?INFO("获取角色所有委托日常任务失败[Rid:~w, SrvId:~s, Msg:~s]"),
                    []
            end
    end.

%% 委托一个任务
save_task(Id, Time, Rid, SrvId, TaskId, Quality) ->
    Sql = <<"insert into delegate_task values (~s, ~s, ~s, ~s, ~s, ~s) ">>,
    case db:execute(Sql, [Id, Time, Rid, SrvId, TaskId, Quality]) of
        {ok, _Result} ->
            ?DEBUG("保存委托任务成功  ~w", [_Result]),
            ok;
        Err ->
            ?ERR("保存委托任务失败 :原因:~w",[Rid, SrvId, Err])
    end.

%% 删除任务
delete_task(RoleId, SrvId, TaskId) ->
    Sql = <<"delete from delegate_task where role_id = ~s and srv_id = ~s and mail_id = ~s">>,
    ?DEBUG("  **** 参数 : ~w  **** ~s  *** ~s", [RoleId, SrvId, TaskId]),
    case db:execute(Sql, [RoleId, SrvId, TaskId]) of
        {ok, _Affected} ->
            ?DEBUG(" ***** 删除日常任务成功 :  ~w" , [_Affected]),
            {ok};
        {error, _Why}->
            ?DEBUG("*******  删除日常任务失败  原因  ~w", [_Why])
    end.

