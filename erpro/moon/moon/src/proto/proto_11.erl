%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_11).
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

pack(srv, ?_CMD(1100), {P0_msg, P0_ck0, P0_ck1, P0_xj0, P0_xj1, P0_qs0, P0_qs1, P0_role_list}) ->
    D_a_t_a = <<?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_ck0, '32'):32, ?_(P0_ck1, '32'):32, ?_(P0_xj0, '32'):32, ?_(P0_xj1, '32'):32, ?_(P0_qs0, '32'):32, ?_(P0_qs1, '32'):32, ?_((length(P0_role_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_status, '8'):8, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_sex, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_career, '8'):8>> || [P1_id, P1_srv_id, P1_status, P1_name, P1_sex, P1_lev, P1_career] <- P0_role_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 1100:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(1100), {P0_srv_id}) ->
    D_a_t_a = <<?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 1100:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(1105), {P0_rid, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 1105:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(1105), {P0_name, P0_sex, P0_career, P0_srvid, P0_code}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_sex, '8'):8, ?_(P0_career, '8'):8, ?_((byte_size(P0_srvid)), "16"):16, ?_(P0_srvid, bin)/binary, ?_((byte_size(P0_code)), "16"):16, ?_(P0_code, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 1105:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(1110), {P0_result, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 1110:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(1110), {P0_role_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 1110:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(1120), {P0_result, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 1120:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(1120), {P0_role_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 1120:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 1100, _B0) ->
    {P0_srv_id, _B1} = lib_proto:read_string(_B0),
    {ok, {P0_srv_id}};
unpack(cli, 1100, _B0) ->
    {P0_msg, _B1} = lib_proto:read_string(_B0),
    {P0_ck0, _B2} = lib_proto:read_uint32(_B1),
    {P0_ck1, _B3} = lib_proto:read_uint32(_B2),
    {P0_xj0, _B4} = lib_proto:read_uint32(_B3),
    {P0_xj1, _B5} = lib_proto:read_uint32(_B4),
    {P0_qs0, _B6} = lib_proto:read_uint32(_B5),
    {P0_qs1, _B7} = lib_proto:read_uint32(_B6),
    {P0_role_list, _B16} = lib_proto:read_array(_B7, fun(_B8) ->
        {P1_id, _B9} = lib_proto:read_uint32(_B8),
        {P1_srv_id, _B10} = lib_proto:read_string(_B9),
        {P1_status, _B11} = lib_proto:read_uint8(_B10),
        {P1_name, _B12} = lib_proto:read_string(_B11),
        {P1_sex, _B13} = lib_proto:read_uint8(_B12),
        {P1_lev, _B14} = lib_proto:read_uint8(_B13),
        {P1_career, _B15} = lib_proto:read_uint8(_B14),
        {[P1_id, P1_srv_id, P1_status, P1_name, P1_sex, P1_lev, P1_career], _B15}
    end),
    {ok, {P0_msg, P0_ck0, P0_ck1, P0_xj0, P0_xj1, P0_qs0, P0_qs1, P0_role_list}};

unpack(srv, 1105, _B0) ->
    {P0_name, _B1} = lib_proto:read_string(_B0),
    {P0_sex, _B2} = lib_proto:read_uint8(_B1),
    {P0_career, _B3} = lib_proto:read_uint8(_B2),
    {P0_srvid, _B4} = lib_proto:read_string(_B3),
    {P0_code, _B5} = lib_proto:read_string(_B4),
    {ok, {P0_name, P0_sex, P0_career, P0_srvid, P0_code}};
unpack(cli, 1105, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_rid, P0_msg_id}};

unpack(srv, 1110, _B0) ->
    {P0_role_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_role_id, P0_srv_id}};
unpack(cli, 1110, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_result, P0_msg_id}};

unpack(srv, 1120, _B0) ->
    {P0_role_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_role_id, P0_srv_id}};
unpack(cli, 1120, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_result, P0_msg_id}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
