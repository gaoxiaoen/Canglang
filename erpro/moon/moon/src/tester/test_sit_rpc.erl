%% *********************
%% 打坐双修测试模块
%% wpf  wprehard@qq.com
%% *********************

-module(test_sit_rpc).
-export([
        handle/3
    ]).

-include("common.hrl").
-include("tester.hrl").

%% 打坐
handle(sit, {}, _Tester) ->
    tester:pack_send(11601, {}),
    {ok};
handle(11601, _Data, _Tester) ->
    ?DEBUG("打坐返回：~w", [_Data]),
    {ok};

%% 获取附近玩家列表
handle(get_list, {}, _Tester) ->
    tester:pack_send(11610, {}),
    {ok};
handle(11610, {_List}, _Tester) ->
    ?DEBUG("获取附近玩家列表：~w", [_List]),
    {ok};

%% 邀请玩家双修
handle(invite, {Id, SrvId}, _Tester) ->
    tester:pack_send(11611, {Id, SrvId}),
    {ok};
handle(11611, {_Result, _Msg}, _Tester) ->
    ?DEBUG("邀请返回：~w, ~w", [_Result, _Msg]),
    {ok};

%% 邀请玩家双修
handle(11612, _Msg, _Tester) ->
    ?DEBUG("邀请通知：~w", [_Msg]),
    {ok};

%% 邀请处理
handle(deal_invite, {Result, Id, SrvId}, _Tester) ->
    tester:pack_send(11613, {Result, Id, SrvId}),
    {ok};
handle(11613, {_Result, _Msg}, _Tester) ->
    ?DEBUG("邀请处理返回：~w, ~w", [_Result, _Msg]),
    {ok};

%% 双修确认
handle(sure, {Id, SrvId}, _Tester) ->
    tester:pack_send(11615, {Id, SrvId}),
    {ok};
handle(11615, {_Ret, _Type, _, _}, _Tester) ->
    ?DEBUG("角色双修确认通知：~w", [{_Ret, _Type}]),
    tester:pack_send(11601, {}),
    {ok};

%% 收到打坐双修状态的场景广播
handle(11620, _Data, _Tester) ->
    ?DEBUG("双修状态通知：~w", [_Data]),
    {ok};

%% 收到打坐状态的场景广播
handle(11621, _Data, _Tester) ->
    ?DEBUG("打坐状态通知:~w", [_Data]),
    {ok};

%% 收到取消双修状态的场景广播
handle(11622, _Data, _Tester) ->
    ?DEBUG("取消双修状态通知：~w", [_Data]),
    {ok};

%% 收到取消打坐状态的场景广播
handle(11623, _Data, _Tester) ->
    ?DEBUG("取消打坐状态通知:~w", [_Data]),
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
