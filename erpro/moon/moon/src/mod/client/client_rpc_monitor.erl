%%----------------------------------------------------
%% 监控客户端RPC处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(client_rpc_monitor).
-export([handle/3]).
-include("common.hrl").
-include("conn.hrl").

handle(1200, {}, #conn{type = monitor}) ->
    {reply, {}};

handle(_Cmd, _Data, _Connector) ->
    {error, unknow_command}.

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------
