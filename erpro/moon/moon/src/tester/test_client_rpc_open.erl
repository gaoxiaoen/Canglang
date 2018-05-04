%%----------------------------------------------------
%% 测试客户端开放RPC调用
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(test_client_rpc_open).
-export([handle/3]).
-include("common.hrl").
-include("tester.hrl").
-define(N, 10000).

%% 登录帐号
handle(acc_login, {Account, Ts, Ticket}, #tester{acc_name = AccName}) when AccName =:= <<>> ->
    %% ?DEBUG("正在登录帐号[~s]", [Account]),
    tester:pack_send(1010, {Account, Ts, Ticket}),
    {ok};

%% 帐号登录成功
handle(1010, {?true, _Msg}, Tester) ->
    AccName = erase(acc_name),
    %% ?DEBUG("帐号[~s]登录成功", [AccName]),
    tester:pack_send(1100, {}), %% 请求角色列表
    {ok, Tester#tester{acc_name = AccName}};
%% 帐号登录失败
handle(1010, {?false, _Msg}, _Tester) ->
    ?DEBUG("帐号登录失败:~w", [_Msg]),
    {ok};

%% 处理心跳包响应
handle(1099, {_Time, _SrvTime}, _Tester) ->
    %% ?DEBUG("收到1099处理结果:~w", [_Time]),
    %% erlang:send_after(5000, self(), {cmd, ?MODULE, heartbeat, {0}}),
    {ok};

%% 收到服务器时间
handle(1044, {_SrvTime}, _) ->
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
