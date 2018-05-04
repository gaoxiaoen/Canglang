%%----------------------------------------------------
%% 测试角色相关RPC调用
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(test_role_rpc).
-export([handle/3]).
-include("common.hrl").
-include("tester.hrl").

%% 角色属性
handle(init, {}, _Tester) ->
    tester:pack_send(10000, {}),
    {ok};
handle(10000, _Data, _TesterState) ->
    ?DEBUG("获取角色属性[RoleAttr:~w]", [_Data]),
    {ok};

%% 金钱资产
handle(get_assets, {}, _Tester) ->
    tester:pack_send(10002, {}),
    {ok};
handle(10002, _Data, _TesterState) ->
    ?DEBUG("获取角色金钱资产[Assets:~w]", [_Data]),
    {ok};

%% 属性
handle(get_attr, {}, _Tester) ->
    tester:pack_send(10003, {}),
    {ok};
handle(10003, _Data, _TesterState) ->
    ?DEBUG("获取角色属性[Attr:~w]", [_Data]),
    {ok};

%% 升级通知
handle(10007, {_Id, _SrvId, _InfoId, _Msg}, _TesterState) ->
    ?DEBUG("升级通知：[Lev:~w, Msg:~w]", [_InfoId, _Msg]),
    tester:cmd(test_role_rpc, get_attr, {}),
    {ok};

%% 查看其他角色属性
handle(get_other_attr, {ID, SrvId}, _Tester) ->
    tester:pack_send(10010, {ID, SrvId}),
    {ok};
handle(10010, _Data, _TesterState) ->
    ?DEBUG("获取其他角色属性[RoleAttr:~w]", [_Data]),
    {ok};

%% 获取广播数据
handle(10011, _Status, _TesterState) ->
    ?DEBUG("收到广播数据-状态变化[Msg:~w]", [_Status]),
    {ok};

%% 飞行
handle(fly, {}, _TesterState) ->
    tester:pack_send(10015, {}),
    {ok};
handle(10015, {_Ret, _Msg}, _TesterState) ->
    ?DEBUG("收到请求&取消飞行结果：[Result:~w, Msg:~s]", [_Ret, _Msg]),
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
