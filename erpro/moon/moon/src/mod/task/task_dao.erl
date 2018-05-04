%%----------------------------------------------------
%% @doc task_dao
%%
%% <pre>
%% 已接任务信息表相关操作,role_task
%% </pre>
%% @author yqhuang(QQ:19123767)
%% @end 
%%----------------------------------------------------
-module(task_dao).

-include("task.hrl").
-include("common.hrl").

-export([
        get_task_list/2
        ,init_get_task_list/2
        ,save_task/3
        ,delete_task/3
        ,delete_expire_task/3
    ]
).

%% @get_task_list(Rid, SrvId) -> Rs
%% @doc
%% <pre>
%% Rid = integer() 角色Id
%% SrvId = string() 服务器标志服
%% Rs = list() 结果，两维数组
%% 获取角色所以已接任务
%% </pre>
get_task_list(Rid, SrvId) ->
    Sql = <<"select rid, srv_id, task_id, status, type, sec_type, owner, accept_time, finish_time, accept_num, progress, attr_list, item_base_id, item_num from role_task where rid = ~s and srv_id = ~s">>,
    case db:get_all(Sql, [Rid, SrvId]) of
        {ok, Data} ->
            Data;
        {error, _Msg} ->
            case db:get_all(Sql, [Rid, SrvId]) of
                {ok, Data} -> Data;
                {error, _Msg2} ->
                    catch ?INFO("获取角色所有已接任务失败[Rid:~w, SrvId:~s, Msg:~s]", [Rid, SrvId, _Msg2]),
                    []
            end
    end.

%% 角色进程启动 返回值改过
init_get_task_list(Rid, SrvId) ->
    Sql = <<"select rid, srv_id, task_id, status, type, sec_type, owner, accept_time, finish_time, accept_num, progress, attr_list, item_base_id, item_num from role_task where rid = ~s and srv_id = ~s">>,
    case db:get_all(Sql, [Rid, SrvId]) of
        {ok, Data} ->
            {ok, Data};
        {error, Msg} ->
            {error, Msg}
    end.

%% @save_task(Task, Rid, SrvId) -> AffectedRow
%% @doc
%% <pre>
%% Task = #task{} 任务信息
%% Rid = integer() 角色ID
%% SrvId = string() 服务器标志符
%% 保存已接任务信息
%% </pre>
save_task(#task{task_id = TaskId, status = Status, type = Type, sec_type = SecType, owner = Owner, accept_time = AcceptTime, finish_time = FinishTime, progress = Progress, accept_num = AcceptNum, attr_list = AttrList, item_base_id = ItemBaseId, item_num = ItemNum, quality = Quality}, Rid, SrvId) ->
    Sql = <<"replace into role_task (rid, srv_id, task_id, status, type, sec_type, owner, accept_time, finish_time, accept_num, progress, attr_list, item_base_id, item_num) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>,
    NewProg = task_util:records_to_lists(Progress),
    AttrList2 = case lists:keyfind(quality, 1, AttrList) of
        false -> [{quality, Quality} | AttrList];
        _ -> lists:keyreplace(quality, 1, AttrList, {quality, Quality})
    end,
    NewAttrList = util:term_to_bitstring(AttrList2),
    NewProg2 = util:term_to_bitstring(NewProg),
    db:execute(Sql, [Rid, SrvId, TaskId, Status, Type, SecType, Owner, AcceptTime, FinishTime, AcceptNum, NewProg2, NewAttrList, ItemBaseId, ItemNum]).

%% 删除已经接任务
delete_task(RoleId, SrvId, TaskId) ->
    Sql = <<"delete from role_task where rid = ~s and srv_id = ~s and task_id = ~s">>,
    db:execute(Sql, [RoleId, SrvId, TaskId]).

%% 删除过期任务
delete_expire_task(RoleId, SrvId, Time) ->
    Sql = <<"delete from role_task where rid = ~s and srv_id = ~s and accept_time < ~s">>,
    db:execute(Sql, [RoleId, SrvId, Time]).

