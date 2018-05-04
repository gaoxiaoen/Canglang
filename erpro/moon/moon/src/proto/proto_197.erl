%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_197).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("activity2.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(19700), {P0_type, P0_awards}) ->
    D_a_t_a = <<?_(P0_type, '32'):32, ?_((length(P0_awards)), "16"):16, (list_to_binary([<<?_(P1_day, '8'):8, ?_(P1_status, '8'):8>> || {P1_day, P1_status} <- P0_awards]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19700:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19700), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19700:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19701), {P0_result, P0_id, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_id, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19701:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19701), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19701:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 19700, _B0) ->
    {ok, {}};
unpack(cli, 19700, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint32(_B0),
    {P0_awards, _B5} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_day, _B3} = lib_proto:read_uint8(_B2),
        {P1_status, _B4} = lib_proto:read_uint8(_B3),
        {[P1_day, P1_status], _B4}
    end),
    {ok, {P0_type, P0_awards}};

unpack(srv, 19701, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_id}};
unpack(cli, 19701, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_id, _B2} = lib_proto:read_uint8(_B1),
    {P0_msg, _B3} = lib_proto:read_string(_B2),
    {ok, {P0_result, P0_id, P0_msg}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
