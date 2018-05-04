%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_134).
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

pack(srv, ?_CMD(13400), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13400:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13400), {P0_sfz, P0_name}) ->
    D_a_t_a = <<?_((byte_size(P0_sfz)), "16"):16, ?_(P0_sfz, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13400:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13401), {P0_version, P0_acc_time, P0_is_auth, P0_msg}) ->
    D_a_t_a = <<?_(P0_version, '8'):8, ?_(P0_acc_time, '32'):32, ?_(P0_is_auth, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13401:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13401), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13401:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13410), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13410:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13410), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13410:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13430), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13430:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13430), {P0_md5, P0_system, P0_browser, P0_fp_version, P0_client_version, P0_error_code, P0_msg}) ->
    D_a_t_a = <<?_((byte_size(P0_md5)), "16"):16, ?_(P0_md5, bin)/binary, ?_((byte_size(P0_system)), "16"):16, ?_(P0_system, bin)/binary, ?_((byte_size(P0_browser)), "16"):16, ?_(P0_browser, bin)/binary, ?_((byte_size(P0_fp_version)), "16"):16, ?_(P0_fp_version, bin)/binary, ?_((byte_size(P0_client_version)), "16"):16, ?_(P0_client_version, bin)/binary, ?_(P0_error_code, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13430:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13495), {P0_cmd, P0_img}) ->
    D_a_t_a = <<?_(P0_cmd, '32'):32, ?_((byte_size(P0_img)), "16"):16, ?_(P0_img, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13495:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13495), {P0_cmd}) ->
    D_a_t_a = <<?_(P0_cmd, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13495:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13496), {P0_code, P0_msg, P0_cmd, P0_img}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_cmd, '32'):32, ?_((byte_size(P0_img)), "16"):16, ?_(P0_img, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13496:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13496), {P0_cmd, P0_code}) ->
    D_a_t_a = <<?_(P0_cmd, '32'):32, ?_(P0_code, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13496:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 13400, _B0) ->
    {P0_sfz, _B1} = lib_proto:read_string(_B0),
    {P0_name, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_sfz, P0_name}};
unpack(cli, 13400, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_code, P0_msg}};

unpack(srv, 13401, _B0) ->
    {ok, {}};
unpack(cli, 13401, _B0) ->
    {P0_version, _B1} = lib_proto:read_uint8(_B0),
    {P0_acc_time, _B2} = lib_proto:read_uint32(_B1),
    {P0_is_auth, _B3} = lib_proto:read_uint8(_B2),
    {P0_msg, _B4} = lib_proto:read_string(_B3),
    {ok, {P0_version, P0_acc_time, P0_is_auth, P0_msg}};

unpack(srv, 13410, _B0) ->
    {ok, {}};
unpack(cli, 13410, _B0) ->
    {ok, {}};

unpack(srv, 13430, _B0) ->
    {P0_md5, _B1} = lib_proto:read_string(_B0),
    {P0_system, _B2} = lib_proto:read_string(_B1),
    {P0_browser, _B3} = lib_proto:read_string(_B2),
    {P0_fp_version, _B4} = lib_proto:read_string(_B3),
    {P0_client_version, _B5} = lib_proto:read_string(_B4),
    {P0_error_code, _B6} = lib_proto:read_uint32(_B5),
    {P0_msg, _B7} = lib_proto:read_string(_B6),
    {ok, {P0_md5, P0_system, P0_browser, P0_fp_version, P0_client_version, P0_error_code, P0_msg}};
unpack(cli, 13430, _B0) ->
    {ok, {}};

unpack(srv, 13495, _B0) ->
    {P0_cmd, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_cmd}};
unpack(cli, 13495, _B0) ->
    {P0_cmd, _B1} = lib_proto:read_uint32(_B0),
    {P0_img, _B2} = lib_proto:read_bytes(_B1),
    {ok, {P0_cmd, P0_img}};

unpack(srv, 13496, _B0) ->
    {P0_cmd, _B1} = lib_proto:read_uint32(_B0),
    {P0_code, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_cmd, P0_code}};
unpack(cli, 13496, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {P0_cmd, _B3} = lib_proto:read_uint32(_B2),
    {P0_img, _B4} = lib_proto:read_bytes(_B3),
    {ok, {P0_code, P0_msg, P0_cmd, P0_img}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
