%%----------------------------------------------------
%% 监控服务器命令处理
%%
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(monitor_rpc).
-export([handle/3]).
-include("common.hrl").
-include("conn.hrl").

handle(8000, {FunStr}, C) ->
    Reply = try
        F = util:build_fun(binary_to_list(FunStr)),
        term_to_binary(F(C))
    catch
        T:X ->
            term_to_binary({error, {T, X}})
    end,
    {reply, {Reply}};

handle(_Cmd, _Data, _C) ->
    {error, unknow_command}.
