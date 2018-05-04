%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_139).
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

pack(srv, ?_CMD(13900), {P0_type, P0_keepday, P0_id}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_keepday, '8'):8, ?_(P0_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13900:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13900), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13900:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13901), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13901:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13901), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13901:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13902), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13902:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13902), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13902:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13903), {P0_exp, P0_time}) ->
    D_a_t_a = <<?_(P0_exp, '32'):32, ?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13903:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13903), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13903:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13904), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13904:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13904), {P0_type, P0_hour}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_hour, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13904:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13910), {P0_flag, P0_surplus, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_(P0_surplus, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13910:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13910), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13910:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13911), {P0_total, P0_surplus}) ->
    D_a_t_a = <<?_(P0_total, '8'):8, ?_(P0_surplus, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13911:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13911), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13911:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13912), {P0_flag}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13912:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13912), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13912:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13913), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13913:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13913), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13913:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13914), {P0_day, P0_flag}) ->
    D_a_t_a = <<?_(P0_day, '8'):8, ?_(P0_flag, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13914:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13914), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13914:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13915), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13915:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13915), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13915:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 13900, _B0) ->
    {ok, {}};
unpack(cli, 13900, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_keepday, _B2} = lib_proto:read_uint8(_B1),
    {P0_id, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_type, P0_keepday, P0_id}};

unpack(srv, 13901, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_type}};
unpack(cli, 13901, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 13902, _B0) ->
    {ok, {}};
unpack(cli, 13902, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 13903, _B0) ->
    {ok, {}};
unpack(cli, 13903, _B0) ->
    {P0_exp, _B1} = lib_proto:read_uint32(_B0),
    {P0_time, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_exp, P0_time}};

unpack(srv, 13904, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_hour, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_type, P0_hour}};
unpack(cli, 13904, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 13910, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_type}};
unpack(cli, 13910, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_surplus, _B2} = lib_proto:read_uint8(_B1),
    {P0_msg, _B3} = lib_proto:read_string(_B2),
    {ok, {P0_flag, P0_surplus, P0_msg}};

unpack(srv, 13911, _B0) ->
    {ok, {}};
unpack(cli, 13911, _B0) ->
    {P0_total, _B1} = lib_proto:read_uint8(_B0),
    {P0_surplus, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_total, P0_surplus}};

unpack(srv, 13912, _B0) ->
    {ok, {}};
unpack(cli, 13912, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_flag}};

unpack(srv, 13913, _B0) ->
    {ok, {}};
unpack(cli, 13913, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 13914, _B0) ->
    {ok, {}};
unpack(cli, 13914, _B0) ->
    {P0_day, _B1} = lib_proto:read_uint8(_B0),
    {P0_flag, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_day, P0_flag}};

unpack(srv, 13915, _B0) ->
    {ok, {}};
unpack(cli, 13915, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
