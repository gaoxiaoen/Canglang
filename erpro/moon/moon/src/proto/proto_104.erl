%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_104).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("buff.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(10400), {P0_buffs}) ->
    D_a_t_a = <<?_((length(P0_buffs)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_baseid, '16'):16, ?_(P1_icon, '32'):32, ?_(P1_endtime, '32/signed'):32/signed>> || {P1_id, P1_baseid, P1_icon, P1_endtime} <- P0_buffs]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10400:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10400), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10400:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10401), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10401:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10401), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10401:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10402), {P0_ret, P0_time, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_(P0_time, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10402:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10402), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10402:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10403), {P0_shortcut}) ->
    D_a_t_a = <<?_((length(P0_shortcut)), "16"):16, (list_to_binary([<<?_(P1_type, '16'):16, ?_(P1_flag, '8'):8, ?_(P1_pool, '32/signed'):32/signed>> || {P1_type, P1_flag, P1_pool} <- P0_shortcut]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10403:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10403), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10403:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10404), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10404:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10404), {P0_type, P0_flag}) ->
    D_a_t_a = <<?_(P0_type, '16'):16, ?_(P0_flag, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10404:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10405), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10405:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10405), {P0_type, P0_num}) ->
    D_a_t_a = <<?_(P0_type, '16'):16, ?_(P0_num, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10405:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 10400, _B0) ->
    {ok, {}};
unpack(cli, 10400, _B0) ->
    {P0_buffs, _B6} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_baseid, _B3} = lib_proto:read_uint16(_B2),
        {P1_icon, _B4} = lib_proto:read_uint32(_B3),
        {P1_endtime, _B5} = lib_proto:read_int32(_B4),
        {[P1_id, P1_baseid, P1_icon, P1_endtime], _B5}
    end),
    {ok, {P0_buffs}};

unpack(srv, 10401, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 10401, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};

unpack(srv, 10402, _B0) ->
    {ok, {}};
unpack(cli, 10402, _B0) ->
    {P0_ret, _B1} = lib_proto:read_uint8(_B0),
    {P0_time, _B2} = lib_proto:read_uint32(_B1),
    {P0_msg, _B3} = lib_proto:read_string(_B2),
    {ok, {P0_ret, P0_time, P0_msg}};

unpack(srv, 10403, _B0) ->
    {ok, {}};
unpack(cli, 10403, _B0) ->
    {P0_shortcut, _B5} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_type, _B2} = lib_proto:read_uint16(_B1),
        {P1_flag, _B3} = lib_proto:read_uint8(_B2),
        {P1_pool, _B4} = lib_proto:read_int32(_B3),
        {[P1_type, P1_flag, P1_pool], _B4}
    end),
    {ok, {P0_shortcut}};

unpack(srv, 10404, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint16(_B0),
    {P0_flag, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_type, P0_flag}};
unpack(cli, 10404, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 10405, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint16(_B0),
    {P0_num, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_type, P0_num}};
unpack(cli, 10405, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
