%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_167).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("item.hrl").
-include("wing.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(16700), {P0_items}) ->
    D_a_t_a = <<?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_upgrade, '8'):8, ?_(P1_enchant, '8/signed'):8/signed, ?_(P1_enchant_fail, '8'):8, ?_(P1_quantity, '8'):8, ?_(P1_status, '8'):8, ?_(P1_pos, '16'):16, ?_(P1_lasttime, '32'):32, ?_(P1_durability, '32/signed'):32/signed, ?_(P1_craft, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary, ?_((length(P1_extra)), "16"):16, (list_to_binary([<<?_(P2_type, '32'):32, ?_(P2_value, '32'):32, ?_((byte_size(P2_str)), "16"):16, ?_(P2_str, bin)/binary>> || {P2_type, P2_value, P2_str} <- P1_extra]))/binary>> || #item{id = P1_id, base_id = P1_base_id, bind = P1_bind, upgrade = P1_upgrade, enchant = P1_enchant, enchant_fail = P1_enchant_fail, quantity = P1_quantity, status = P1_status, pos = P1_pos, lasttime = P1_lasttime, durability = P1_durability, craft = P1_craft, attr = P1_attr, max_base_attr = P1_max_base_attr, extra = P1_extra} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16700:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16700), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16700:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16701), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16701:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16701), {P0_wing_id}) ->
    D_a_t_a = <<?_(P0_wing_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16701:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16702), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16702:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16702), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16702:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16703), {P0_skinId, P0_grade, P0_skins}) ->
    D_a_t_a = <<?_(P0_skinId, '32'):32, ?_(P0_grade, '8'):8, ?_((length(P0_skins)), "16"):16, (list_to_binary([<<?_(P1_skinId, '32'):32>> || P1_skinId <- P0_skins]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16703:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16703), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16703:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16704), {P0_flag, P0_skinId, P0_grade, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_(P0_skinId, '32'):32, ?_(P0_grade, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16704:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16704), {P0_skinId, P0_grade}) ->
    D_a_t_a = <<?_(P0_skinId, '32'):32, ?_(P0_grade, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16704:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16705), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16705:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16705), {P0_wing_id}) ->
    D_a_t_a = <<?_(P0_wing_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16705:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16706), {P0_skill_list}) ->
    D_a_t_a = <<?_((length(P0_skill_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_skill_id, '32'):32>> || #eqm_skill{id = P1_id, skill_id = P1_skill_id} <- P0_skill_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16706:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16706), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16706:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16707), {P0_coin_luck, P0_gold_luck, P0_skill_list}) ->
    D_a_t_a = <<?_(P0_coin_luck, '32'):32, ?_(P0_gold_luck, '32'):32, ?_((length(P0_skill_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_skill_id, '32'):32>> || #eqm_skill{id = P1_id, skill_id = P1_skill_id} <- P0_skill_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16707:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16707), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16707:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16708), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16708:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16708), {P0_type, P0_is_batch}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_is_batch, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16708:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16709), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16709:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16709), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16709:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16710), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16710:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16710), {P0_id, P0_item_id, P0_pos}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_item_id, '32'):32, ?_(P0_pos, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16710:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16711), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16711:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16711), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16711:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16712), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16712:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16712), {P0_item_id, P0_pos}) ->
    D_a_t_a = <<?_(P0_item_id, '32'):32, ?_(P0_pos, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16712:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16713), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16713:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16713), {P0_item_id1, P0_item_id2}) ->
    D_a_t_a = <<?_(P0_item_id1, '32'):32, ?_(P0_item_id2, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16713:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 16700, _B0) ->
    {ok, {}};
unpack(cli, 16700, _B0) ->
    {P0_items, _B29} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_base_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_bind, _B4} = lib_proto:read_uint8(_B3),
        {P1_upgrade, _B5} = lib_proto:read_uint8(_B4),
        {P1_enchant, _B6} = lib_proto:read_int8(_B5),
        {P1_enchant_fail, _B7} = lib_proto:read_uint8(_B6),
        {P1_quantity, _B8} = lib_proto:read_uint8(_B7),
        {P1_status, _B9} = lib_proto:read_uint8(_B8),
        {P1_pos, _B10} = lib_proto:read_uint16(_B9),
        {P1_lasttime, _B11} = lib_proto:read_uint32(_B10),
        {P1_durability, _B12} = lib_proto:read_int32(_B11),
        {P1_craft, _B13} = lib_proto:read_uint8(_B12),
        {P1_attr, _B18} = lib_proto:read_array(_B13, fun(_B14) ->
            {P2_attr_name, _B15} = lib_proto:read_uint32(_B14),
            {P2_flag, _B16} = lib_proto:read_uint32(_B15),
            {P2_value, _B17} = lib_proto:read_uint32(_B16),
            {[P2_attr_name, P2_flag, P2_value], _B17}
        end),
        {P1_max_base_attr, _B23} = lib_proto:read_array(_B18, fun(_B19) ->
            {P2_attr_name, _B20} = lib_proto:read_uint32(_B19),
            {P2_flag, _B21} = lib_proto:read_uint32(_B20),
            {P2_value, _B22} = lib_proto:read_uint32(_B21),
            {[P2_attr_name, P2_flag, P2_value], _B22}
        end),
        {P1_extra, _B28} = lib_proto:read_array(_B23, fun(_B24) ->
            {P2_type, _B25} = lib_proto:read_uint32(_B24),
            {P2_value, _B26} = lib_proto:read_uint32(_B25),
            {P2_str, _B27} = lib_proto:read_string(_B26),
            {[P2_type, P2_value, P2_str], _B27}
        end),
        {[P1_id, P1_base_id, P1_bind, P1_upgrade, P1_enchant, P1_enchant_fail, P1_quantity, P1_status, P1_pos, P1_lasttime, P1_durability, P1_craft, P1_attr, P1_max_base_attr, P1_extra], _B28}
    end),
    {ok, {P0_items}};

unpack(srv, 16701, _B0) ->
    {P0_wing_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_wing_id}};
unpack(cli, 16701, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 16702, _B0) ->
    {ok, {}};
unpack(cli, 16702, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 16703, _B0) ->
    {ok, {}};
unpack(cli, 16703, _B0) ->
    {P0_skinId, _B1} = lib_proto:read_uint32(_B0),
    {P0_grade, _B2} = lib_proto:read_uint8(_B1),
    {P0_skins, _B5} = lib_proto:read_array(_B2, fun(_B3) ->
        {P1_skinId, _B4} = lib_proto:read_uint32(_B3),
        {P1_skinId, _B4}
    end),
    {ok, {P0_skinId, P0_grade, P0_skins}};

unpack(srv, 16704, _B0) ->
    {P0_skinId, _B1} = lib_proto:read_uint32(_B0),
    {P0_grade, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_skinId, P0_grade}};
unpack(cli, 16704, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_skinId, _B2} = lib_proto:read_uint32(_B1),
    {P0_grade, _B3} = lib_proto:read_uint8(_B2),
    {P0_msg, _B4} = lib_proto:read_string(_B3),
    {ok, {P0_flag, P0_skinId, P0_grade, P0_msg}};

unpack(srv, 16705, _B0) ->
    {P0_wing_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_wing_id}};
unpack(cli, 16705, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_code, P0_msg}};

unpack(srv, 16706, _B0) ->
    {ok, {}};
unpack(cli, 16706, _B0) ->
    {P0_skill_list, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_skill_id, _B3} = lib_proto:read_uint32(_B2),
        {[P1_id, P1_skill_id], _B3}
    end),
    {ok, {P0_skill_list}};

unpack(srv, 16707, _B0) ->
    {ok, {}};
unpack(cli, 16707, _B0) ->
    {P0_coin_luck, _B1} = lib_proto:read_uint32(_B0),
    {P0_gold_luck, _B2} = lib_proto:read_uint32(_B1),
    {P0_skill_list, _B6} = lib_proto:read_array(_B2, fun(_B3) ->
        {P1_id, _B4} = lib_proto:read_uint32(_B3),
        {P1_skill_id, _B5} = lib_proto:read_uint32(_B4),
        {[P1_id, P1_skill_id], _B5}
    end),
    {ok, {P0_coin_luck, P0_gold_luck, P0_skill_list}};

unpack(srv, 16708, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_is_batch, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_type, P0_is_batch}};
unpack(cli, 16708, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_code, P0_msg}};

unpack(srv, 16709, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 16709, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_code, P0_msg}};

unpack(srv, 16710, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_item_id, _B2} = lib_proto:read_uint32(_B1),
    {P0_pos, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_id, P0_item_id, P0_pos}};
unpack(cli, 16710, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_code, P0_msg}};

unpack(srv, 16711, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 16711, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_code, P0_msg}};

unpack(srv, 16712, _B0) ->
    {P0_item_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_pos, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_item_id, P0_pos}};
unpack(cli, 16712, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_code, P0_msg}};

unpack(srv, 16713, _B0) ->
    {P0_item_id1, _B1} = lib_proto:read_uint32(_B0),
    {P0_item_id2, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_item_id1, P0_item_id2}};
unpack(cli, 16713, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_code, P0_msg}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
