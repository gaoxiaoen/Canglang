%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_148).
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

pack(srv, ?_CMD(14800), {P0_floor, P0_life, P0_left_time, P0_status, P0_boss_list}) ->
    D_a_t_a = <<?_(P0_floor, '16'):16, ?_(P0_life, '8'):8, ?_(P0_left_time, '16'):16, ?_(P0_status, '8'):8, ?_((length(P0_boss_list)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32>> || P1_base_id <- P0_boss_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14800:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14800), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14800:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14801), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14801:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14801), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14801:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14802), {P0_boss_list}) ->
    D_a_t_a = <<?_((length(P0_boss_list)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32>> || P1_base_id <- P0_boss_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14802:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14802), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14802:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14803), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14803:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14803), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14803:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14804), {P0_result}) ->
    D_a_t_a = <<?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14804:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14804), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14804:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14805), {P0_floor}) ->
    D_a_t_a = <<?_(P0_floor, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14805:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14805), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14805:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14808), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14808:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14808), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14808:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14809), {P0_result, P0_left_time, P0_award_life, P0_award_left_time, P0_exp, P0_stone, P0_item_list}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_left_time, '16'):16, ?_(P0_award_life, '8'):8, ?_(P0_award_left_time, '16'):16, ?_(P0_exp, '32'):32, ?_(P0_stone, '32'):32, ?_((length(P0_item_list)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32/signed'):32/signed, ?_(P1_count, '8/signed'):8/signed, ?_(P1_bind, '8/signed'):8/signed>> || {P1_base_id, P1_count, P1_bind} <- P0_item_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14809:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14809), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14809:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14810), {P0_left_count}) ->
    D_a_t_a = <<?_(P0_left_count, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14810:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14810), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14810:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14811), {P0_floor}) ->
    D_a_t_a = <<?_(P0_floor, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14811:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14811), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14811:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14812), {P0_best_floor, P0_anti_status}) ->
    D_a_t_a = <<?_(P0_best_floor, '16'):16, ?_(P0_anti_status, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14812:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14812), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14812:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14813), {P0_anti_status}) ->
    D_a_t_a = <<?_(P0_anti_status, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14813:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14813), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14813:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 14800, _B0) ->
    {ok, {}};
unpack(cli, 14800, _B0) ->
    {P0_floor, _B1} = lib_proto:read_uint16(_B0),
    {P0_life, _B2} = lib_proto:read_uint8(_B1),
    {P0_left_time, _B3} = lib_proto:read_uint16(_B2),
    {P0_status, _B4} = lib_proto:read_uint8(_B3),
    {P0_boss_list, _B7} = lib_proto:read_array(_B4, fun(_B5) ->
        {P1_base_id, _B6} = lib_proto:read_uint32(_B5),
        {P1_base_id, _B6}
    end),
    {ok, {P0_floor, P0_life, P0_left_time, P0_status, P0_boss_list}};

unpack(srv, 14801, _B0) ->
    {ok, {}};
unpack(cli, 14801, _B0) ->
    {ok, {}};

unpack(srv, 14802, _B0) ->
    {ok, {}};
unpack(cli, 14802, _B0) ->
    {P0_boss_list, _B3} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_base_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_base_id, _B2}
    end),
    {ok, {P0_boss_list}};

unpack(srv, 14803, _B0) ->
    {ok, {}};
unpack(cli, 14803, _B0) ->
    {ok, {}};

unpack(srv, 14804, _B0) ->
    {ok, {}};
unpack(cli, 14804, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_result}};

unpack(srv, 14805, _B0) ->
    {ok, {}};
unpack(cli, 14805, _B0) ->
    {P0_floor, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_floor}};

unpack(srv, 14808, _B0) ->
    {ok, {}};
unpack(cli, 14808, _B0) ->
    {ok, {}};

unpack(srv, 14809, _B0) ->
    {ok, {}};
unpack(cli, 14809, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_left_time, _B2} = lib_proto:read_uint16(_B1),
    {P0_award_life, _B3} = lib_proto:read_uint8(_B2),
    {P0_award_left_time, _B4} = lib_proto:read_uint16(_B3),
    {P0_exp, _B5} = lib_proto:read_uint32(_B4),
    {P0_stone, _B6} = lib_proto:read_uint32(_B5),
    {P0_item_list, _B11} = lib_proto:read_array(_B6, fun(_B7) ->
        {P1_base_id, _B8} = lib_proto:read_int32(_B7),
        {P1_count, _B9} = lib_proto:read_int8(_B8),
        {P1_bind, _B10} = lib_proto:read_int8(_B9),
        {[P1_base_id, P1_count, P1_bind], _B10}
    end),
    {ok, {P0_result, P0_left_time, P0_award_life, P0_award_left_time, P0_exp, P0_stone, P0_item_list}};

unpack(srv, 14810, _B0) ->
    {ok, {}};
unpack(cli, 14810, _B0) ->
    {P0_left_count, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_left_count}};

unpack(srv, 14811, _B0) ->
    {ok, {}};
unpack(cli, 14811, _B0) ->
    {P0_floor, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_floor}};

unpack(srv, 14812, _B0) ->
    {ok, {}};
unpack(cli, 14812, _B0) ->
    {P0_best_floor, _B1} = lib_proto:read_uint16(_B0),
    {P0_anti_status, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_best_floor, P0_anti_status}};

unpack(srv, 14813, _B0) ->
    {ok, {}};
unpack(cli, 14813, _B0) ->
    {P0_anti_status, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_anti_status}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
