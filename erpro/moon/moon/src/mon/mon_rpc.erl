%%----------------------------------------------------
%% 监控服务器命令处理
%%
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(mon_rpc).
-export([handle/3]).
-include("common.hrl").
-include("mon.hrl").

%% 登录监控服
handle(login, {}, #mon{socket = Socket}) ->
    mon_proc:pack_send(Socket, 1010, {<<"monitor">>, <<"monitor">>, util:unixtime(), <<"abc">>}),
    {ok};

%% 处理登录结果
handle(1010, {Success, Msg}, #mon{account = Account, host = Host}) ->
    case Success of
        true->
            ?INFO("以帐号名 ~s 登录服务器 ~s 成功", [Account, Host]);
        false ->
            ?INFO("以帐号名 ~s 登录服务器 ~s 失败，服务器返回: ~s", [Account, Host, Msg]),
            mon_proc:disconnect(self())
    end,
    {ok};

%% 发送心跳包
handle(heartbeat, {}, #mon{socket = Socket}) ->
    mon_proc:pack_send(Socket, 1099, {0}),
    ?cmd(?MODULE, heartbeat, {}, 3000),
    {ok};

%% 心跳回应
handle(1099, {_Time, _SrvTime}, _Mon) ->
    %% ?DEBUG("收到心跳回应"),
    {ok};

handle(rpc, {FunStr}, #mon{socket = Socket}) ->
    mon_proc:pack_send(Socket, 8000, {FunStr}),
    {ok};

handle(8000, {Bin}, _Mon) ->
    _Rtn = binary_to_term(Bin),
    ?DEBUG("管理指令执行结果: ~p", [_Rtn]),
    {ok};

%% 未知命令
handle(_Cmd, _Data, _Mon) ->
    {error, unknow_command}.
