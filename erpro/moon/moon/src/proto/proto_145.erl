%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_145).
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

pack(srv, ?_CMD(14501), {P0_result}) ->
    D_a_t_a = <<?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14501:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14501), {P0_type, P0_phone, P0_qq, P0_content}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_((byte_size(P0_phone)), "16"):16, ?_(P0_phone, bin)/binary, ?_((byte_size(P0_qq)), "16"):16, ?_(P0_qq, bin)/binary, ?_((byte_size(P0_content)), "16"):16, ?_(P0_content, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14501:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14502), {P0_result, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14502:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14502), {P0_role_id, P0_srv_id, P0_reason}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14502:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14503), {P0_result, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14503:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14503), {P0_role_id, P0_srv_id, P0_time, P0_flag, P0_reason}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_time, '32'):32, ?_(P0_flag, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14503:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14504), {P0_result, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14504:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14504), {P0_role_id, P0_srv_id, P0_time, P0_reason}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_time, '32'):32, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14504:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14505), {P0_result, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14505:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14505), {P0_role_id, P0_srv_id, P0_reason}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14505:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14506), {P0_result}) ->
    D_a_t_a = <<?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14506:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14506), {P0_msg}) ->
    D_a_t_a = <<?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14506:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14507), {P0_msg}) ->
    D_a_t_a = <<?_((length(P0_msg)), "16"):16, (list_to_binary([<<?_(P1_time, '32'):32, ?_((byte_size(P1_msg)), "16"):16, ?_(P1_msg, bin)/binary>> || [P1_time, P1_msg] <- P0_msg]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14507:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14507), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14507:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 14501, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_phone, _B2} = lib_proto:read_string(_B1),
    {P0_qq, _B3} = lib_proto:read_string(_B2),
    {P0_content, _B4} = lib_proto:read_string(_B3),
    {ok, {P0_type, P0_phone, P0_qq, P0_content}};
unpack(cli, 14501, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_result}};

unpack(srv, 14502, _B0) ->
    {P0_role_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_reason, _B3} = lib_proto:read_string(_B2),
    {ok, {P0_role_id, P0_srv_id, P0_reason}};
unpack(cli, 14502, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_reason, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_result, P0_reason}};

unpack(srv, 14503, _B0) ->
    {P0_role_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_time, _B3} = lib_proto:read_uint32(_B2),
    {P0_flag, _B4} = lib_proto:read_uint8(_B3),
    {P0_reason, _B5} = lib_proto:read_string(_B4),
    {ok, {P0_role_id, P0_srv_id, P0_time, P0_flag, P0_reason}};
unpack(cli, 14503, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_reason, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_result, P0_reason}};

unpack(srv, 14504, _B0) ->
    {P0_role_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_time, _B3} = lib_proto:read_uint32(_B2),
    {P0_reason, _B4} = lib_proto:read_string(_B3),
    {ok, {P0_role_id, P0_srv_id, P0_time, P0_reason}};
unpack(cli, 14504, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_reason, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_result, P0_reason}};

unpack(srv, 14505, _B0) ->
    {P0_role_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_reason, _B3} = lib_proto:read_string(_B2),
    {ok, {P0_role_id, P0_srv_id, P0_reason}};
unpack(cli, 14505, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_reason, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_result, P0_reason}};

unpack(srv, 14506, _B0) ->
    {P0_msg, _B1} = lib_proto:read_string(_B0),
    {ok, {P0_msg}};
unpack(cli, 14506, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_result}};

unpack(srv, 14507, _B0) ->
    {ok, {}};
unpack(cli, 14507, _B0) ->
    {P0_msg, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_time, _B2} = lib_proto:read_uint32(_B1),
        {P1_msg, _B3} = lib_proto:read_string(_B2),
        {[P1_time, P1_msg], _B3}
    end),
    {ok, {P0_msg}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
