%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_111).
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

pack(srv, ?_CMD(11100), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11100:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11100), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11100:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11101), {P0_msg_id}) ->
    D_a_t_a = <<?_(P0_msg_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11101:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11101), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11101:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11102), {P0_msg_id}) ->
    D_a_t_a = <<?_(P0_msg_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11102:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11102), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11102:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11103), {P0_msg_id}) ->
    D_a_t_a = <<?_(P0_msg_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11103:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11103), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11103:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11111), {P0_msg}) ->
    D_a_t_a = <<?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11111:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11111), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11111:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11112), {P0_msg}) ->
    D_a_t_a = <<?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11112:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11112), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11112:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11113), {P0_msg}) ->
    D_a_t_a = <<?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11113:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11113), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11113:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11121), {P0_msg_id, P0_args}) ->
    D_a_t_a = <<?_(P0_msg_id, '16'):16, ?_((length(P0_args)), "16"):16, (list_to_binary([<<?_((byte_size(P1_arg)), "16"):16, ?_(P1_arg, bin)/binary>> || P1_arg <- P0_args]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11121:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11121), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11121:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11122), {P0_msg_id, P0_args}) ->
    D_a_t_a = <<?_(P0_msg_id, '16'):16, ?_((length(P0_args)), "16"):16, (list_to_binary([<<?_((byte_size(P1_arg)), "16"):16, ?_(P1_arg, bin)/binary>> || P1_arg <- P0_args]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11122:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11122), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11122:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11123), {P0_msg_id, P0_args}) ->
    D_a_t_a = <<?_(P0_msg_id, '16'):16, ?_((length(P0_args)), "16"):16, (list_to_binary([<<?_((byte_size(P1_arg)), "16"):16, ?_(P1_arg, bin)/binary>> || P1_arg <- P0_args]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11123:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11123), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11123:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11150), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11150:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11150), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11150:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11153), {P0_status}) ->
    D_a_t_a = <<?_(P0_status, '8/signed'):8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11153:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11153), {P0_type, P0_args}) ->
    D_a_t_a = <<?_(P0_type, '32'):32, ?_((length(P0_args)), "16"):16, (list_to_binary([<<?_(P1_arg, '32/signed'):32/signed>> || P1_arg <- P0_args]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11153:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11154), {P0_list}) ->
    D_a_t_a = <<?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_((byte_size(P1_msg)), "16"):16, ?_(P1_msg, bin)/binary, ?_((length(P1_args)), "16"):16, (list_to_binary([<<?_(P2_arg, '32/signed'):32/signed>> || P2_arg <- P1_args]))/binary>> || {P1_type, P1_msg, P1_args} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11154:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11154), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11154:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11160), {P0_msg_id}) ->
    D_a_t_a = <<?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11160:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11160), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11160:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11161), {P0_msg}) ->
    D_a_t_a = <<?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11161:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11161), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11161:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11170), {P0_list}) ->
    D_a_t_a = <<?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_key, '8'):8, ?_(P1_value, '32'):32>> || {P1_key, P1_value} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11170:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11170), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11170:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 11100, _B0) ->
    {ok, {}};
unpack(cli, 11100, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_code, P0_msg}};

unpack(srv, 11101, _B0) ->
    {ok, {}};
unpack(cli, 11101, _B0) ->
    {P0_msg_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_msg_id}};

unpack(srv, 11102, _B0) ->
    {ok, {}};
unpack(cli, 11102, _B0) ->
    {P0_msg_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_msg_id}};

unpack(srv, 11103, _B0) ->
    {ok, {}};
unpack(cli, 11103, _B0) ->
    {P0_msg_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_msg_id}};

unpack(srv, 11111, _B0) ->
    {ok, {}};
unpack(cli, 11111, _B0) ->
    {P0_msg, _B1} = lib_proto:read_string(_B0),
    {ok, {P0_msg}};

unpack(srv, 11112, _B0) ->
    {ok, {}};
unpack(cli, 11112, _B0) ->
    {P0_msg, _B1} = lib_proto:read_string(_B0),
    {ok, {P0_msg}};

unpack(srv, 11113, _B0) ->
    {ok, {}};
unpack(cli, 11113, _B0) ->
    {P0_msg, _B1} = lib_proto:read_string(_B0),
    {ok, {P0_msg}};

unpack(srv, 11121, _B0) ->
    {ok, {}};
unpack(cli, 11121, _B0) ->
    {P0_msg_id, _B1} = lib_proto:read_uint16(_B0),
    {P0_args, _B4} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_arg, _B3} = lib_proto:read_string(_B2),
        {P1_arg, _B3}
    end),
    {ok, {P0_msg_id, P0_args}};

unpack(srv, 11122, _B0) ->
    {ok, {}};
unpack(cli, 11122, _B0) ->
    {P0_msg_id, _B1} = lib_proto:read_uint16(_B0),
    {P0_args, _B4} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_arg, _B3} = lib_proto:read_string(_B2),
        {P1_arg, _B3}
    end),
    {ok, {P0_msg_id, P0_args}};

unpack(srv, 11123, _B0) ->
    {ok, {}};
unpack(cli, 11123, _B0) ->
    {P0_msg_id, _B1} = lib_proto:read_uint16(_B0),
    {P0_args, _B4} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_arg, _B3} = lib_proto:read_string(_B2),
        {P1_arg, _B3}
    end),
    {ok, {P0_msg_id, P0_args}};

unpack(srv, 11150, _B0) ->
    {ok, {}};
unpack(cli, 11150, _B0) ->
    {ok, {}};

unpack(srv, 11153, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint32(_B0),
    {P0_args, _B4} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_arg, _B3} = lib_proto:read_int32(_B2),
        {P1_arg, _B3}
    end),
    {ok, {P0_type, P0_args}};
unpack(cli, 11153, _B0) ->
    {P0_status, _B1} = lib_proto:read_int8(_B0),
    {ok, {P0_status}};

unpack(srv, 11154, _B0) ->
    {ok, {}};
unpack(cli, 11154, _B0) ->
    {P0_list, _B7} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_type, _B2} = lib_proto:read_uint8(_B1),
        {P1_msg, _B3} = lib_proto:read_string(_B2),
        {P1_args, _B6} = lib_proto:read_array(_B3, fun(_B4) ->
            {P2_arg, _B5} = lib_proto:read_int32(_B4),
            {P2_arg, _B5}
        end),
        {[P1_type, P1_msg, P1_args], _B6}
    end),
    {ok, {P0_list}};

unpack(srv, 11160, _B0) ->
    {ok, {}};
unpack(cli, 11160, _B0) ->
    {P0_msg_id, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_msg_id}};

unpack(srv, 11161, _B0) ->
    {ok, {}};
unpack(cli, 11161, _B0) ->
    {P0_msg, _B1} = lib_proto:read_string(_B0),
    {ok, {P0_msg}};

unpack(srv, 11170, _B0) ->
    {ok, {}};
unpack(cli, 11170, _B0) ->
    {P0_list, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_key, _B2} = lib_proto:read_uint8(_B1),
        {P1_value, _B3} = lib_proto:read_uint32(_B2),
        {[P1_key, P1_value], _B3}
    end),
    {ok, {P0_list}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
