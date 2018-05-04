%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_80).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.


%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(8000), {P0_result}) ->
    D_a_t_a = <<?_((byte_size(P0_result)), "16"):16, ?_(P0_result, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 8000:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(8000), {P0_fun}) ->
    D_a_t_a = <<?_((byte_size(P0_fun)), "16"):16, ?_(P0_fun, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 8000:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 8000, _B0) ->
    {P0_fun, _B1} = lib_proto:read_string(_B0),
    {ok, {P0_fun}};
unpack(cli, 8000, _B0) ->
    {P0_result, _B1} = lib_proto:read_string(_B0),
    {ok, {P0_result}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
