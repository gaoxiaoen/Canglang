%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_129).
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

pack(srv, ?_CMD(12900), {P0_cd, P0_souls}) ->
    D_a_t_a = <<?_(P0_cd, '32'):32, ?_((length(P0_souls)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_state, '8'):8>> || {P1_id, P1_lev, P1_state} <- P0_souls]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12900:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12900), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12900:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12901), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12901:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12901), {P0_soul_id}) ->
    D_a_t_a = <<?_(P0_soul_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12901:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12902), {P0_soul_id, P0_lev, P0_cd}) ->
    D_a_t_a = <<?_(P0_soul_id, '8'):8, ?_(P0_lev, '8'):8, ?_(P0_cd, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12902:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12902), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12902:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12903), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12903:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12903), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12903:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12904), {P0_status, P0_msg, P0_soul_id, P0_lev}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16, ?_(P0_soul_id, '8'):8, ?_(P0_lev, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12904:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12904), {P0_soul_id, P0_is_protect, P0_auto_buy}) ->
    D_a_t_a = <<?_(P0_soul_id, '8'):8, ?_(P0_is_protect, '8'):8, ?_(P0_auto_buy, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12904:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12910), {P0_souls}) ->
    D_a_t_a = <<?_((length(P0_souls)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_state, '16'):16, ?_(P1_attr_val, '16'):16, ?_(P1_next_attr_val, '16'):16, ?_(P1_cond_spirit, '32'):32, ?_(P1_cond_lev, '8'):8, ?_(P1_before_id, '8'):8, ?_(P1_before_lev, '8'):8>> || {P1_id, P1_lev, P1_state, P1_attr_val, P1_next_attr_val, P1_cond_spirit, P1_cond_lev, P1_before_id, P1_before_lev} <- P0_souls]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12910:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12910), {P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12910:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12911), {P0_msg, P0_to_lev, P0_need_gold}) ->
    D_a_t_a = <<?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_to_lev, '16'):16, ?_(P0_need_gold, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12911:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12911), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12911:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12912), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12912:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12912), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12912:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12930), {P0_lilian, P0_bamens}) ->
    D_a_t_a = <<?_(P0_lilian, '32'):32, ?_((length(P0_bamens)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_state, '16'):16, ?_(P1_attr_val, '16'):16, ?_(P1_next_attr_val, '16'):16, ?_(P1_cond_spirit, '32'):32, ?_(P1_cond_lev, '8'):8, ?_(P1_before_id, '8'):8, ?_(P1_before_lev, '8'):8>> || {P1_id, P1_lev, P1_state, P1_attr_val, P1_next_attr_val, P1_cond_spirit, P1_cond_lev, P1_before_id, P1_before_lev} <- P0_bamens]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12930:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12930), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12930:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12931), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12931:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12931), {P0_bamen_id}) ->
    D_a_t_a = <<?_(P0_bamen_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12931:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12932), {P0_lilian, P0_id, P0_lev, P0_state, P0_attr_val, P0_next_attr_val, P0_cond_spirit, P0_cond_lev, P0_before_id, P0_before_lev}) ->
    D_a_t_a = <<?_(P0_lilian, '32'):32, ?_(P0_id, '8'):8, ?_(P0_lev, '8'):8, ?_(P0_state, '16'):16, ?_(P0_attr_val, '16'):16, ?_(P0_next_attr_val, '16'):16, ?_(P0_cond_spirit, '32'):32, ?_(P0_cond_lev, '8'):8, ?_(P0_before_id, '8'):8, ?_(P0_before_lev, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12932:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12932), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12932:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12935), {P0_bamens}) ->
    D_a_t_a = <<?_((length(P0_bamens)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_state, '16'):16, ?_(P1_attr_val, '16'):16, ?_(P1_next_attr_val, '16'):16, ?_(P1_cond_spirit, '32'):32, ?_(P1_cond_lev, '8'):8, ?_(P1_before_id, '8'):8, ?_(P1_before_lev, '8'):8>> || {P1_id, P1_lev, P1_state, P1_attr_val, P1_next_attr_val, P1_cond_spirit, P1_cond_lev, P1_before_id, P1_before_lev} <- P0_bamens]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12935:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12935), {P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12935:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12936), {P0_id, P0_state, P0_attr_val, P0_next_attr_val, P0_msg}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_(P0_state, '16'):16, ?_(P0_attr_val, '16'):16, ?_(P0_next_attr_val, '16'):16, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12936:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12936), {P0_bamen_id, P0_is_protect}) ->
    D_a_t_a = <<?_(P0_bamen_id, '8'):8, ?_(P0_is_protect, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12936:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 12900, _B0) ->
    {ok, {}};
unpack(cli, 12900, _B0) ->
    {P0_cd, _B1} = lib_proto:read_uint32(_B0),
    {P0_souls, _B6} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_id, _B3} = lib_proto:read_uint8(_B2),
        {P1_lev, _B4} = lib_proto:read_uint8(_B3),
        {P1_state, _B5} = lib_proto:read_uint8(_B4),
        {[P1_id, P1_lev, P1_state], _B5}
    end),
    {ok, {P0_cd, P0_souls}};

unpack(srv, 12901, _B0) ->
    {P0_soul_id, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_soul_id}};
unpack(cli, 12901, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 12902, _B0) ->
    {ok, {}};
unpack(cli, 12902, _B0) ->
    {P0_soul_id, _B1} = lib_proto:read_uint8(_B0),
    {P0_lev, _B2} = lib_proto:read_uint8(_B1),
    {P0_cd, _B3} = lib_proto:read_uint32(_B2),
    {ok, {P0_soul_id, P0_lev, P0_cd}};

unpack(srv, 12903, _B0) ->
    {ok, {}};
unpack(cli, 12903, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 12904, _B0) ->
    {P0_soul_id, _B1} = lib_proto:read_uint8(_B0),
    {P0_is_protect, _B2} = lib_proto:read_uint8(_B1),
    {P0_auto_buy, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_soul_id, P0_is_protect, P0_auto_buy}};
unpack(cli, 12904, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {P0_soul_id, _B3} = lib_proto:read_uint8(_B2),
    {P0_lev, _B4} = lib_proto:read_uint8(_B3),
    {ok, {P0_status, P0_msg, P0_soul_id, P0_lev}};

unpack(srv, 12910, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_rid, P0_srv_id}};
unpack(cli, 12910, _B0) ->
    {P0_souls, _B11} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint8(_B1),
        {P1_lev, _B3} = lib_proto:read_uint8(_B2),
        {P1_state, _B4} = lib_proto:read_uint16(_B3),
        {P1_attr_val, _B5} = lib_proto:read_uint16(_B4),
        {P1_next_attr_val, _B6} = lib_proto:read_uint16(_B5),
        {P1_cond_spirit, _B7} = lib_proto:read_uint32(_B6),
        {P1_cond_lev, _B8} = lib_proto:read_uint8(_B7),
        {P1_before_id, _B9} = lib_proto:read_uint8(_B8),
        {P1_before_lev, _B10} = lib_proto:read_uint8(_B9),
        {[P1_id, P1_lev, P1_state, P1_attr_val, P1_next_attr_val, P1_cond_spirit, P1_cond_lev, P1_before_id, P1_before_lev], _B10}
    end),
    {ok, {P0_souls}};

unpack(srv, 12911, _B0) ->
    {ok, {}};
unpack(cli, 12911, _B0) ->
    {P0_msg, _B1} = lib_proto:read_string(_B0),
    {P0_to_lev, _B2} = lib_proto:read_uint16(_B1),
    {P0_need_gold, _B3} = lib_proto:read_uint32(_B2),
    {ok, {P0_msg, P0_to_lev, P0_need_gold}};

unpack(srv, 12912, _B0) ->
    {ok, {}};
unpack(cli, 12912, _B0) ->
    {P0_ret, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_ret, P0_msg}};

unpack(srv, 12930, _B0) ->
    {ok, {}};
unpack(cli, 12930, _B0) ->
    {P0_lilian, _B1} = lib_proto:read_uint32(_B0),
    {P0_bamens, _B12} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_id, _B3} = lib_proto:read_uint8(_B2),
        {P1_lev, _B4} = lib_proto:read_uint8(_B3),
        {P1_state, _B5} = lib_proto:read_uint16(_B4),
        {P1_attr_val, _B6} = lib_proto:read_uint16(_B5),
        {P1_next_attr_val, _B7} = lib_proto:read_uint16(_B6),
        {P1_cond_spirit, _B8} = lib_proto:read_uint32(_B7),
        {P1_cond_lev, _B9} = lib_proto:read_uint8(_B8),
        {P1_before_id, _B10} = lib_proto:read_uint8(_B9),
        {P1_before_lev, _B11} = lib_proto:read_uint8(_B10),
        {[P1_id, P1_lev, P1_state, P1_attr_val, P1_next_attr_val, P1_cond_spirit, P1_cond_lev, P1_before_id, P1_before_lev], _B11}
    end),
    {ok, {P0_lilian, P0_bamens}};

unpack(srv, 12931, _B0) ->
    {P0_bamen_id, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_bamen_id}};
unpack(cli, 12931, _B0) ->
    {P0_ret, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_ret, P0_msg}};

unpack(srv, 12932, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_id}};
unpack(cli, 12932, _B0) ->
    {P0_lilian, _B1} = lib_proto:read_uint32(_B0),
    {P0_id, _B2} = lib_proto:read_uint8(_B1),
    {P0_lev, _B3} = lib_proto:read_uint8(_B2),
    {P0_state, _B4} = lib_proto:read_uint16(_B3),
    {P0_attr_val, _B5} = lib_proto:read_uint16(_B4),
    {P0_next_attr_val, _B6} = lib_proto:read_uint16(_B5),
    {P0_cond_spirit, _B7} = lib_proto:read_uint32(_B6),
    {P0_cond_lev, _B8} = lib_proto:read_uint8(_B7),
    {P0_before_id, _B9} = lib_proto:read_uint8(_B8),
    {P0_before_lev, _B10} = lib_proto:read_uint8(_B9),
    {ok, {P0_lilian, P0_id, P0_lev, P0_state, P0_attr_val, P0_next_attr_val, P0_cond_spirit, P0_cond_lev, P0_before_id, P0_before_lev}};

unpack(srv, 12935, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_rid, P0_srv_id}};
unpack(cli, 12935, _B0) ->
    {P0_bamens, _B11} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint8(_B1),
        {P1_lev, _B3} = lib_proto:read_uint8(_B2),
        {P1_state, _B4} = lib_proto:read_uint16(_B3),
        {P1_attr_val, _B5} = lib_proto:read_uint16(_B4),
        {P1_next_attr_val, _B6} = lib_proto:read_uint16(_B5),
        {P1_cond_spirit, _B7} = lib_proto:read_uint32(_B6),
        {P1_cond_lev, _B8} = lib_proto:read_uint8(_B7),
        {P1_before_id, _B9} = lib_proto:read_uint8(_B8),
        {P1_before_lev, _B10} = lib_proto:read_uint8(_B9),
        {[P1_id, P1_lev, P1_state, P1_attr_val, P1_next_attr_val, P1_cond_spirit, P1_cond_lev, P1_before_id, P1_before_lev], _B10}
    end),
    {ok, {P0_bamens}};

unpack(srv, 12936, _B0) ->
    {P0_bamen_id, _B1} = lib_proto:read_uint8(_B0),
    {P0_is_protect, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_bamen_id, P0_is_protect}};
unpack(cli, 12936, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint8(_B0),
    {P0_state, _B2} = lib_proto:read_uint16(_B1),
    {P0_attr_val, _B3} = lib_proto:read_uint16(_B2),
    {P0_next_attr_val, _B4} = lib_proto:read_uint16(_B3),
    {P0_msg, _B5} = lib_proto:read_string(_B4),
    {ok, {P0_id, P0_state, P0_attr_val, P0_next_attr_val, P0_msg}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
