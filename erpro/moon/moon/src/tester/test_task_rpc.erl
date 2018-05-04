%%----------------------------------------------------
%% Author: yqhuang(QQ:19123767)
%% Created: 2011-8-5
%% Description: 测试任务系统 
%%----------------------------------------------------
-module(test_task_rpc).

-export([handle/3]).
-include("common.hrl").
-include("tester.hrl").

handle(test_all, {}, _Tester) ->
    %% tester:cmd(test_task_rpc, send10200, {}), %% 获取已接任务列表
    %% tester:cmd(test_task_rpc, send10207, {10002}), %% 接收任务
    %% tester:cmd(test_task_rpc, send10200, {}), %% 获取已接任务列表
    %% tester:cmd(test_task_rpc, send10201, {}), %% 获取可接任务列表
    %% tester:cmd(test_task_rpc, send10202, {10001}), %% 修改某个任务
    %% tester:cmd(test_task_rpc, send10203, {}), %% 增加可接任务
    %% tester:cmd(test_task_rpc, send10205, {}), %% 增加可接任务
    %% tester:cmd(test_task_rpc, send10208, {10002}), %% 提交任务
    %% tester:cmd(test_task_rpc, send10206, {10002}), %% 删除已接任务
    %% tester:cmd(test_task_rpc, send10209, {10002}), %% 放弃任务
    %% tester:cmd(test_task_rpc, send10211, {}), %% 刷新单个任务状态

    tester:cmd(test_task_rpc, send10200, {}), %% 获取已接任务列表
    tester:cmd(test_task_rpc, send10201, {}), %% 获取可接任务列表
    tester:cmd(test_task_rpc, send10207, {10001}), %% 接收任务
    tester:cmd(test_task_rpc, send10208, {10001}), %% 提交任务

    tester:cmd(test_task_rpc, send10207, {10002}), %% 接收任务
    tester:cmd(test_task_rpc, send10207, {10003}), %% 接收任务
    tester:cmd(test_task_rpc, send10208, {10002}), %% 提交任务


    tester:cmd(test_task_rpc, send10207, {10003}), %% 接收任务
    tester:cmd(test_task_rpc, send10208, {10003}), %% 提交任务

    %%     tester:cmd(test_task_rpc, send10207, {10005}), %% 接收任务
    %%     tester:cmd(test_task_rpc, send10209, {10005}), %% 放弃任务

    tester:cmd(test_task_rpc, send10207, {10004}), %% 接收任务
    tester:cmd(test_task_rpc, send10211, {}), %% 刷新单个任务状态
    {ok};

%% 获取已接任务列表
handle(send10200, {}, _Tester) ->
    ?DEBUG("请求已接任务列表"),
    tester:pack_send(10200, {}),
    {ok};

handle(10200, {_P0_task_list}, _Tester) ->
    ?DEBUG("接收已接任务列表:~w个[List:~w]", [length(_P0_task_list), _P0_task_list]),
    {ok};

%% 获取可接任务列表
handle(send10201, {}, _Tester) ->
    ?DEBUG("请求可接任务列表"),
    tester:pack_send(10201, {}),
    {ok};
handle(10201, {_P0_task_list}, _Tester) ->
    ?DEBUG("接收可接任务列表:~w", [_P0_task_list]),
    {ok};

handle(send10202, {TaskId}, _Tester) ->
    ?DEBUG("发送更新指定任务请求:~w", [TaskId]),
    tester:pack_send(10202, {TaskId}),
    {ok};

handle(10202, {_P0_task_id, _P0_status, _P0_progress}, _Tester) ->
    ?DEBUG("接收任务变更:~w", [{_P0_task_id, _P0_status, _P0_progress}]),
    {ok};

handle(send10203, {}, _Tester) ->
    ?DEBUG("发送增加可接任务请求"),
    tester:pack_send(10203, {}),
    {ok};
handle(10203, {_P0_task_id}, _Tester) ->
    ?DEBUG("接收增加可接任务:~w", [{_P0_task_id}]),
    {ok};

handle(send10205, {}, _Tester) ->
    ?DEBUG("发送增加已接任务请求"),
    tester:pack_send(10205, {}),
    {ok};
handle(10205, {_P0_task_id, _P0_status, _P0_progress}, _Tester) ->
    ?DEBUG("接收增加已接任务:~w", [{_P0_task_id, _P0_status, _P0_progress}]),
    {ok};

handle(send10206, {TaskId}, _Tester) ->
    ?DEBUG("发送删除已接任务请求"),
    tester:pack_send(10206, {TaskId}),
    {ok};
handle(10206, {_TaskId}, _Tester) ->
    ?DEBUG("接收删除已接任务:~w", [{_TaskId}]),
    {ok};

handle(send10207, {TaskId}, _Tester) ->
    ?DEBUG("发送接受任务请求"),
    tester:pack_send(10207, {TaskId}),
    {ok};
handle(10207, {Success, _Msg}, _Tester) ->
    case Success of
        1 ->
            ?DEBUG("接收任务成功:~w", [_Msg]);
        0 ->
            ?DEBUG("接收任务失败:~s", [_Msg])
    end,
    {ok};

handle(send10208, {TaskId}, _Tester) ->
    ?DEBUG("发送完成任务请求"),
    tester:pack_send(10208, {TaskId}),
    {ok};
handle(10208, {Success, _Msg}, _Tester) ->
    case Success of
        1 ->
            ?DEBUG("完成任务成功:~w", [_Msg]);
        0 ->
            ?DEBUG("完成任务失败:~s", [_Msg])
    end,
    {ok};

handle(send10209, {TaskId}, _Tester) ->
    ?DEBUG("发送放弃任务请求"),
    tester:pack_send(10209, {TaskId}),
    {ok};
handle(10209, {Success, _Msg}, _Tester) ->
    case Success of
        1 ->
            ?DEBUG("放弃任务成功:~w", [_Msg]);
        0 ->
            ?DEBUG("放弃任务失败:~s", [_Msg])
    end,
    {ok};

handle(send10211, {}, _Tester) ->
    ?DEBUG("发送刷新单个任务状态请求"),
    tester:pack_send(10211, {}),
    {ok};
handle(10211, {_NpcStatus}, _Tester) ->
    ?DEBUG("获得刷NPC任务状态:~w", [_NpcStatus]),
    {ok};

handle(10204, {_TaskId}, _Tester) ->
    ?DEBUG("删除可接任务:~w", [_TaskId]),
    {ok};

handle(finish_task, {TaskId}, _Tester) ->
    tester:pack_send(9910, {erlang:list_to_bitstring(io_lib:format("提交任务 ~p", [TaskId]))}),
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
