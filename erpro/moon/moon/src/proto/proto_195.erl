%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_195).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("manor.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(19500), {P0_cd_time, P0_hole_col}) ->
    D_a_t_a = <<?_(P0_cd_time, '16'):16, ?_((length(P0_hole_col)), "16"):16, (list_to_binary([<<?_(P1_pos, '8'):8, ?_(P1_item_id, '32'):32, ?_(P1_has_cd, '8'):8>> || {P1_pos, P1_item_id, P1_has_cd} <- P0_hole_col]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19500:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19500), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19500:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19501), {P0_mode, P0_cd_time, P0_pos, P0_item_id, P0_has_cd}) ->
    D_a_t_a = <<?_(P0_mode, '8'):8, ?_(P0_cd_time, '16'):16, ?_(P0_pos, '8'):8, ?_(P0_item_id, '32'):32, ?_(P0_has_cd, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19501:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19501), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19501:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19502), {P0_status, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19502:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19502), {P0_npc_id}) ->
    D_a_t_a = <<?_(P0_npc_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19502:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19503), {P0_status, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19503:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19503), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19503:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19504), {P0_status, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19504:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19504), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19504:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19505), {P0_cd_time, P0_hole_col, P0_material}) ->
    D_a_t_a = <<?_(P0_cd_time, '16'):16, ?_((length(P0_hole_col)), "16"):16, (list_to_binary([<<?_(P1_pos, '8'):8, ?_(P1_item_id, '32'):32, ?_(P1_has_cd, '8'):8>> || {P1_pos, P1_item_id, P1_has_cd} <- P0_hole_col]))/binary, ?_((length(P0_material)), "16"):16, (list_to_binary([<<?_(P1_npc_id, '32'):32, ?_(P1_item_id, '32'):32, ?_(P1_item_num, '32'):32>> || {P1_npc_id, P1_item_id, P1_item_num} <- P0_material]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19505:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19505), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19505:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19506), {P0_status, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19506:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19506), {P0_npc_id, P0_item_id}) ->
    D_a_t_a = <<?_(P0_npc_id, '32'):32, ?_(P0_item_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19506:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19507), {P0_status, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19507:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19507), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19507:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19508), {P0_status, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19508:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19508), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19508:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19509), {P0_status, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19509:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19509), {P0_npc_id, P0_recipe_id}) ->
    D_a_t_a = <<?_(P0_npc_id, '32'):32, ?_(P0_recipe_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19509:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19510), {P0_status, P0_msg_id, P0_yao_id}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg_id, '16'):16, ?_(P0_yao_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19510:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19510), {P0_yao_id}) ->
    D_a_t_a = <<?_(P0_yao_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19510:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19511), {P0_cd_time, P0_pos, P0_item_id, P0_has_cd}) ->
    D_a_t_a = <<?_(P0_cd_time, '16'):16, ?_(P0_pos, '8'):8, ?_(P0_item_id, '32'):32, ?_(P0_has_cd, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19511:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19511), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19511:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19512), {P0_material}) ->
    D_a_t_a = <<?_((length(P0_material)), "16"):16, (list_to_binary([<<?_(P1_npc_id, '32'):32, ?_(P1_item_id, '32'):32, ?_(P1_item_num, '32'):32>> || {P1_npc_id, P1_item_id, P1_item_num} <- P0_material]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19512:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19512), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19512:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19513), {P0_info}) ->
    D_a_t_a = <<?_((length(P0_info)), "16"):16, (list_to_binary([<<?_(P1_npc_id, '32'):32, ?_(P1_yao_id, '32'):32, ?_(P1_num, '32'):32>> || {P1_npc_id, P1_yao_id, P1_num} <- P0_info]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19513:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19513), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19513:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19514), {P0_cd_time, P0_coin, P0_npc_id}) ->
    D_a_t_a = <<?_(P0_cd_time, '16'):16, ?_(P0_coin, '32'):32, ?_(P0_npc_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19514:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19514), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19514:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19515), {P0_status, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19515:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19515), {P0_npc_id}) ->
    D_a_t_a = <<?_(P0_npc_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19515:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19516), {P0_status, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19516:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19516), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19516:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19517), {P0_status, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19517:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19517), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19517:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19518), {P0_npc_id, P0_cd}) ->
    D_a_t_a = <<?_(P0_npc_id, '32'):32, ?_(P0_cd, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19518:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19518), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19518:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19519), {P0_status, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19519:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19519), {P0_npc_id}) ->
    D_a_t_a = <<?_(P0_npc_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19519:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19520), {P0_status, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19520:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19520), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19520:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19521), {P0_new_npc, P0_info}) ->
    D_a_t_a = <<?_((length(P0_new_npc)), "16"):16, (list_to_binary([<<?_(P1_npc_id, '32'):32>> || P1_npc_id <- P0_new_npc]))/binary, ?_((length(P0_info)), "16"):16, (list_to_binary([<<?_(P1_time, '16'):16, ?_(P1_cnt, '16'):16>> || {P1_time, P1_cnt} <- P0_info]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19521:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19521), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19521:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19522), {P0_npc_id}) ->
    D_a_t_a = <<?_(P0_npc_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19522:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19522), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19522:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 19500, _B0) ->
    {ok, {}};
unpack(cli, 19500, _B0) ->
    {P0_cd_time, _B1} = lib_proto:read_uint16(_B0),
    {P0_hole_col, _B6} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_pos, _B3} = lib_proto:read_uint8(_B2),
        {P1_item_id, _B4} = lib_proto:read_uint32(_B3),
        {P1_has_cd, _B5} = lib_proto:read_uint8(_B4),
        {[P1_pos, P1_item_id, P1_has_cd], _B5}
    end),
    {ok, {P0_cd_time, P0_hole_col}};

unpack(srv, 19501, _B0) ->
    {ok, {}};
unpack(cli, 19501, _B0) ->
    {P0_mode, _B1} = lib_proto:read_uint8(_B0),
    {P0_cd_time, _B2} = lib_proto:read_uint16(_B1),
    {P0_pos, _B3} = lib_proto:read_uint8(_B2),
    {P0_item_id, _B4} = lib_proto:read_uint32(_B3),
    {P0_has_cd, _B5} = lib_proto:read_uint8(_B4),
    {ok, {P0_mode, P0_cd_time, P0_pos, P0_item_id, P0_has_cd}};

unpack(srv, 19502, _B0) ->
    {P0_npc_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_npc_id}};
unpack(cli, 19502, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg_id}};

unpack(srv, 19503, _B0) ->
    {ok, {}};
unpack(cli, 19503, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg_id}};

unpack(srv, 19504, _B0) ->
    {ok, {}};
unpack(cli, 19504, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg_id}};

unpack(srv, 19505, _B0) ->
    {ok, {}};
unpack(cli, 19505, _B0) ->
    {P0_cd_time, _B1} = lib_proto:read_uint16(_B0),
    {P0_hole_col, _B6} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_pos, _B3} = lib_proto:read_uint8(_B2),
        {P1_item_id, _B4} = lib_proto:read_uint32(_B3),
        {P1_has_cd, _B5} = lib_proto:read_uint8(_B4),
        {[P1_pos, P1_item_id, P1_has_cd], _B5}
    end),
    {P0_material, _B11} = lib_proto:read_array(_B6, fun(_B7) ->
        {P1_npc_id, _B8} = lib_proto:read_uint32(_B7),
        {P1_item_id, _B9} = lib_proto:read_uint32(_B8),
        {P1_item_num, _B10} = lib_proto:read_uint32(_B9),
        {[P1_npc_id, P1_item_id, P1_item_num], _B10}
    end),
    {ok, {P0_cd_time, P0_hole_col, P0_material}};

unpack(srv, 19506, _B0) ->
    {P0_npc_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_item_id, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_npc_id, P0_item_id}};
unpack(cli, 19506, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg_id}};

unpack(srv, 19507, _B0) ->
    {ok, {}};
unpack(cli, 19507, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg_id}};

unpack(srv, 19508, _B0) ->
    {ok, {}};
unpack(cli, 19508, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg_id}};

unpack(srv, 19509, _B0) ->
    {P0_npc_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_recipe_id, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_npc_id, P0_recipe_id}};
unpack(cli, 19509, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg_id}};

unpack(srv, 19510, _B0) ->
    {P0_yao_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_yao_id}};
unpack(cli, 19510, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {P0_yao_id, _B3} = lib_proto:read_uint32(_B2),
    {ok, {P0_status, P0_msg_id, P0_yao_id}};

unpack(srv, 19511, _B0) ->
    {ok, {}};
unpack(cli, 19511, _B0) ->
    {P0_cd_time, _B1} = lib_proto:read_uint16(_B0),
    {P0_pos, _B2} = lib_proto:read_uint8(_B1),
    {P0_item_id, _B3} = lib_proto:read_uint32(_B2),
    {P0_has_cd, _B4} = lib_proto:read_uint8(_B3),
    {ok, {P0_cd_time, P0_pos, P0_item_id, P0_has_cd}};

unpack(srv, 19512, _B0) ->
    {ok, {}};
unpack(cli, 19512, _B0) ->
    {P0_material, _B5} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_npc_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_item_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_item_num, _B4} = lib_proto:read_uint32(_B3),
        {[P1_npc_id, P1_item_id, P1_item_num], _B4}
    end),
    {ok, {P0_material}};

unpack(srv, 19513, _B0) ->
    {ok, {}};
unpack(cli, 19513, _B0) ->
    {P0_info, _B5} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_npc_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_yao_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_num, _B4} = lib_proto:read_uint32(_B3),
        {[P1_npc_id, P1_yao_id, P1_num], _B4}
    end),
    {ok, {P0_info}};

unpack(srv, 19514, _B0) ->
    {ok, {}};
unpack(cli, 19514, _B0) ->
    {P0_cd_time, _B1} = lib_proto:read_uint16(_B0),
    {P0_coin, _B2} = lib_proto:read_uint32(_B1),
    {P0_npc_id, _B3} = lib_proto:read_uint32(_B2),
    {ok, {P0_cd_time, P0_coin, P0_npc_id}};

unpack(srv, 19515, _B0) ->
    {P0_npc_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_npc_id}};
unpack(cli, 19515, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg_id}};

unpack(srv, 19516, _B0) ->
    {ok, {}};
unpack(cli, 19516, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg_id}};

unpack(srv, 19517, _B0) ->
    {ok, {}};
unpack(cli, 19517, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg_id}};

unpack(srv, 19518, _B0) ->
    {ok, {}};
unpack(cli, 19518, _B0) ->
    {P0_npc_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_cd, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_npc_id, P0_cd}};

unpack(srv, 19519, _B0) ->
    {P0_npc_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_npc_id}};
unpack(cli, 19519, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg_id}};

unpack(srv, 19520, _B0) ->
    {ok, {}};
unpack(cli, 19520, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg_id}};

unpack(srv, 19521, _B0) ->
    {ok, {}};
unpack(cli, 19521, _B0) ->
    {P0_new_npc, _B3} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_npc_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_npc_id, _B2}
    end),
    {P0_info, _B7} = lib_proto:read_array(_B3, fun(_B4) ->
        {P1_time, _B5} = lib_proto:read_uint16(_B4),
        {P1_cnt, _B6} = lib_proto:read_uint16(_B5),
        {[P1_time, P1_cnt], _B6}
    end),
    {ok, {P0_new_npc, P0_info}};

unpack(srv, 19522, _B0) ->
    {ok, {}};
unpack(cli, 19522, _B0) ->
    {P0_npc_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_npc_id}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
