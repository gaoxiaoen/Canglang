%%----------------------------------------------------
%% @doc 角色任务日志
%%
%% <pre>
%% 角色任务日志
%% </pre>
%% @author yqhuang(QQ:19123767)
%%----------------------------------------------------
-module(task_dao_log).

-include("task.hrl").
-include("common.hrl").

-export([
        get_log/2
        ,init_get_log/2
        ,insert_log/6
        ,get_count_log/3
        
        ,delete_all_daily_log/0
        ,get_daily_log/2
        ,init_get_daily_log/2
        ,get_count_daily_log/3
        ,insert_daily_log/7
        ,insert_daily_log/8
        ,update_daily_log/5
        ,delete_daily_log/3
        
        %% ,get_week_log/3
        %% ,insert_week_log/8
        %% ,update_week_log/5
        %% ,delete_week_log/3
    ]
).

%%----------------------------------------------------
%% 对role_task_log表的操作
%%----------------------------------------------------

%% @insert(Task, RoleId) -> Num
%% @doc
%% <pre>
%% Task = #task{} 任务信息
%% RoleId = integer() 角色Id
%% 插入任务信息(非日常)
%% </pre>
insert_log(RoleId, SrvId, TaskId, Type, AccpTime, FinishTime) ->
    Sql = "insert into role_task_log(role_id, srv_id, task_id, type, accept_time, finish_time) values (~s, ~s, ~s, ~s, ~s, ~s)",
    db:execute(Sql, [RoleId, SrvId, TaskId, Type, AccpTime, FinishTime]).

%% @get(RoleId) -> Rs
%% @doc
%% <pre>
%% RoleId = integer{} 角色Id
%% Rs = list() 查询结果
%% 获取指定Id角色的任务信息 (非日常)
%% </pre>
get_log(RoleId, SrvId) ->
    Sql = "select role_id, srv_id, task_id, type, accept_time, finish_time from role_task_log where role_id = ~s and srv_id = ~s",
    case db:get_all(Sql, [RoleId, SrvId]) of
        {ok, Data} ->
            Data;
        {error, _Msg} ->
            case db:get_all(Sql, [RoleId, SrvId]) of
                {ok, Data} ->
                    Data;
                {error, _Msg2} -> 
                    catch ?INFO("获取角色所有已接任务失败[Rid:~w, SrvId:~s, Msg:~s]", [RoleId, SrvId, _Msg2]),
                    []
            end
    end.
init_get_log(RoleId, SrvId) ->
    Sql = "select role_id, srv_id, task_id, type, accept_time, finish_time from role_task_log where role_id = ~s and srv_id = ~s",
    case db:get_all(Sql, [RoleId, SrvId]) of
        {ok, Data} ->
            {ok, Data};
        {error, Msg} ->
            {error, Msg}
    end.

%% @get_count(RoleId, TaskId) -> Num
%% @doc
%% <pre>
%% RoleId = integer() 角色Id
%% TaskId = integer() 任务Id
%% Num = integer() 结果
%% 获取任务总数
%% </pre>
get_count_log(RoleId, SrvId, TaskId) ->
    Sql = "select count(*) from role_task_log where role_id = ~s and srv_id = ~s and task_id = ~s",
    case db:get_one(Sql, [RoleId, SrvId, TaskId]) of
        {ok, Num}-> Num;
        _ -> 0
    end.

%%----------------------------------------------------
%% 对role_task_daily_log表的操作
%%----------------------------------------------------

%% @spec delete_all() - RowNum
%% @doc
%% 清空所有日常任务数据
delete_all_daily_log() ->
    Sql = "delete from role_task_daily_log",
    db:execute(Sql).

%% @spec get(PRoleId) -> Rs
%% @doc
%% <pre>
%% PRoleId = integer() 角色Id
%% Rs = list() of list() of column_type 查询结果
%% 获取角色的全部任务信息
%% </pre>
get_daily_log(RoleId, SrvId) ->
    Sql = "select role_id, srv_id, task_id, type, sec_type, finish_num, accept_time, finish_time from role_task_daily_log where role_id = ~s and srv_id = ~s and finish_time > ~s",
    Today = util:unixtime({today, util:unixtime()}),
    case db:get_all(Sql, [RoleId, SrvId, Today]) of
        {ok, Data} ->
            Data;
        {error, _Msg} ->
            case db:get_all(Sql, [RoleId, SrvId, Today]) of
                {ok, Data} ->
                    Data;
                {error, _Msg2} ->
                    catch ?ELOG("获取任务历史信息出错了[RoleId:~w, SrvId:~s, Msg:~w]", [RoleId, SrvId, _Msg2]),
                    []
            end
    end.
init_get_daily_log(RoleId, SrvId) ->
    Sql = "select role_id, srv_id, task_id, type, sec_type, finish_num, accept_time, finish_time from role_task_daily_log where role_id = ~s and srv_id = ~s and finish_time > ~s",
    Today = util:unixtime({today, util:unixtime()}),
    case db:get_all(Sql, [RoleId, SrvId, Today]) of
        {ok, Data} ->
            {ok, Data};
        {error, Msg} ->
            {error, Msg}
    end.

%% @spec get_count(RoleId, TaskId) -> Num
%% @doc
%% <pre>
%% RoleId = integer() 角色Id
%% TaskId = integer() 任务Id
%% </pre>
get_count_daily_log(RoleId, SrvId, TaskId) ->
    Sql = "select count(*) from role_task_daily_log where role_id = ~s and srv_id = ~s and task_id = ~s",
    case db:get_one(Sql, [RoleId, SrvId, TaskId]) of
        {error, _Msg} -> 0;
        {ok, Num} -> Num
    end.

%% @spec insert(Task, RoleId) -> RowNum
%% @doc
%% <pre>
%% Task = #task{} 任务记录
%% RoleId = integer() 角色Id
%% RowNum = integer() 接受影响的记录数
%% 插入任务信息
%% </pre>
insert_daily_log(RoleId, SrvId, TaskId, Type, FinishNum, AccpTime, FinishTime) ->
    insert_daily_log(RoleId, SrvId, TaskId, Type, 0, FinishNum, AccpTime, FinishTime).

%% 日常任务，增加二级任务类型信息
insert_daily_log(RoleId, SrvId, TaskId, Type, SecType, FinishNum, AccpTime, FinishTime) ->
    Sql = <<"insert into role_task_daily_log(role_id, srv_id, task_id, type, sec_type, finish_num, accept_time, finish_time) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>,
    db:execute(Sql, [RoleId, SrvId, TaskId, Type, SecType, FinishNum, AccpTime, FinishTime]).

%% 更新日常任务日志
update_daily_log(RoleId, SrvId, TaskId, FinishNum, FinishTime) ->
    Sql = <<"update role_task_daily_log set finish_num = ~s, finish_time = ~s where role_id = ~s and srv_id = ~s and task_id = ~s">>,
    db:execute(Sql, [FinishNum, FinishTime, RoleId, SrvId, TaskId]).

%% 删除过期数据
delete_daily_log(RoleId, SrvId, Time) ->
    Sql = <<"delete from role_task_daily_log where role_id = ~s and srv_id = ~s and finish_time < ~s">>,
    db:execute(Sql, [RoleId, SrvId, Time]).

%%----------------------------------------------------
%% 对role_task_week_log表操作
%%----------------------------------------------------

%% %% 获取周日常日志信息
%% get_week_log(RoleId, SrvId, WeekNum) ->
%%     Sql = <<"select task_id, week_num, week_type, finish_num, accept_time, finish_time from role_task_week_log where role_id = ~s and srv_id = ~s and week_num = ~s">>,
%%     case db:get_all(Sql, [RoleId, SrvId, WeekNum]) of
%%         {ok, Data} ->
%%             Data;
%%         {error, _Msg} ->
%%             ?INFO("获取周日常信息出错了[Msg:~w]", [_Msg]),
%%             []
%%     end.
%% 
%% %% 插入周日常信息
%% insert_week_log(RoleId, SrvId, TaskId, WeekNum, WeekType, FinishNum, AcceptTime, FinishTime) ->
%%     Sql = <<"insert into role_task_week_log (role_id, srv_id, task_id, week_num, week_type, finish_num, accept_time, finish_time) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>,
%%     db:execute(Sql, [RoleId, SrvId, TaskId, WeekNum, WeekType, FinishNum, AcceptTime, FinishTime]).
%% 
%% %% 更新周日常完成次数
%% update_week_log(RoleId, SrvId, TaskId, WeekNum, FinishNum) ->
%%     Sql = <<"update role_task_week_log set finish_num = ~s where role_id = ~s and srv_id = ~s and task_id = ~s and week_num = ~s">>,
%%     db:execute(Sql, [FinishNum, RoleId, SrvId, TaskId, WeekNum]).
%% 
%% %% 删除过期数据
%% delete_week_log(RoleId, SrvId, WeekNum) ->
%%     Sql = <<"delete from role_task_week_log where role_id = ~s and srv_id = ~s and week_num < ~s">>,
%%     db:execute(Sql, [RoleId, SrvId, WeekNum]).
