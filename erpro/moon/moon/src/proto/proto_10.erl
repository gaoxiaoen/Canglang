%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_10).
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

pack(srv, ?_CMD(1010), {P0_result, P0_msg_id, P0_time, P0_code, P0_gm_cmd}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_msg_id, '16'):16, ?_(P0_time, '32'):32, ?_((byte_size(P0_code)), "16"):16, ?_(P0_code, bin)/binary, ?_(P0_gm_cmd, '8/signed'):8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 1010:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(1010), {P0_platform, P0_acc_name, P0_srv_id, P0_timestamp, P0_ticket, P0_device_id}) ->
    D_a_t_a = <<?_((byte_size(P0_platform)), "16"):16, ?_(P0_platform, bin)/binary, ?_((byte_size(P0_acc_name)), "16"):16, ?_(P0_acc_name, bin)/binary, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_timestamp, '32'):32, ?_((byte_size(P0_ticket)), "16"):16, ?_(P0_ticket, bin)/binary, ?_((byte_size(P0_device_id)), "16"):16, ?_(P0_device_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 1010:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(1020), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 1020:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(1020), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 1020:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(1021), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 1021:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(1021), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 1021:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(1024), {P0_reason, P0_msg}) ->
    D_a_t_a = <<?_(P0_reason, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 1024:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(1024), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 1024:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(1044), {P0_time}) ->
    D_a_t_a = <<?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 1044:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(1044), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 1044:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(1099), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 1099:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(1099), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 1099:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 1010, _B0) ->
    {P0_platform, _B1} = lib_proto:read_string(_B0),
    {P0_acc_name, _B2} = lib_proto:read_string(_B1),
    {P0_srv_id, _B3} = lib_proto:read_string(_B2),
    {P0_timestamp, _B4} = lib_proto:read_uint32(_B3),
    {P0_ticket, _B5} = lib_proto:read_string(_B4),
    {P0_device_id, _B6} = lib_proto:read_string(_B5),
    {ok, {P0_platform, P0_acc_name, P0_srv_id, P0_timestamp, P0_ticket, P0_device_id}};
unpack(cli, 1010, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {P0_time, _B3} = lib_proto:read_uint32(_B2),
    {P0_code, _B4} = lib_proto:read_string(_B3),
    {P0_gm_cmd, _B5} = lib_proto:read_int8(_B4),
    {ok, {P0_result, P0_msg_id, P0_time, P0_code, P0_gm_cmd}};

unpack(srv, 1020, _B0) ->
    {ok, {}};
unpack(cli, 1020, _B0) ->
    {ok, {}};

unpack(srv, 1021, _B0) ->
    {ok, {}};
unpack(cli, 1021, _B0) ->
    {ok, {}};

unpack(srv, 1024, _B0) ->
    {ok, {}};
unpack(cli, 1024, _B0) ->
    {P0_reason, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_reason, P0_msg}};

unpack(srv, 1044, _B0) ->
    {ok, {}};
unpack(cli, 1044, _B0) ->
    {P0_time, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_time}};

unpack(srv, 1099, _B0) ->
    {ok, {}};
unpack(cli, 1099, _B0) ->
    {ok, {}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
