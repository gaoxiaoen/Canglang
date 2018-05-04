%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_150).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("wanted.hrl").
-include("item.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(15000), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15000:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15000), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15000:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15001), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15001:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15001), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15001:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15002), {P0_steal_coin, P0_steal_stone}) ->
    D_a_t_a = <<?_(P0_steal_coin, '16'):16, ?_(P0_steal_stone, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15002:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15002), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15002:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15003), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15003:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15003), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15003:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15004), {P0_exp, P0_coin, P0_stone}) ->
    D_a_t_a = <<?_(P0_exp, '32'):32, ?_(P0_coin, '16'):16, ?_(P0_stone, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15004:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15004), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15004:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15005), {P0_status, P0_cd_time}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_cd_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15005:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15005), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15005:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15006), {P0_status}) ->
    D_a_t_a = <<?_(P0_status, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15006:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15006), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15006:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15010), {P0_count, P0_killed_count, P0_need_count, P0_left_time, P0_npc_list}) ->
    D_a_t_a = <<?_(P0_count, '8'):8, ?_(P0_killed_count, '16'):16, ?_(P0_need_count, '16'):16, ?_(P0_left_time, '32'):32, ?_((length(P0_npc_list)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_(P1_base_id, '32'):32, ?_(P1_coin, '32'):32, ?_(P1_stone, '32'):32, ?_(P1_kill_count, '32'):32, ?_(P1_killed_count, '32'):32, ?_(P1_status, '8'):8>> || #wanted_npc{id = P1_id, base_id = P1_base_id, coin = P1_coin, stone = P1_stone, kill_count = P1_kill_count, killed_count = P1_killed_count, status = P1_status} <- P0_npc_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15010:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15010), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15010:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15011), {P0_count, P0_killed_count, P0_need_count, P0_left_time, P0_alive_left_time, P0_npc_list}) ->
    D_a_t_a = <<?_(P0_count, '8'):8, ?_(P0_killed_count, '16'):16, ?_(P0_need_count, '16'):16, ?_(P0_left_time, '32'):32, ?_(P0_alive_left_time, '32'):32, ?_((length(P0_npc_list)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_(P1_base_id, '32'):32, ?_(P1_coin, '32'):32, ?_(P1_stone, '32'):32, ?_(P1_kill_count, '32'):32, ?_(P1_killed_count, '32'):32, ?_((byte_size(P1_benefit_name)), "16"):16, ?_(P1_benefit_name, bin)/binary, ?_((byte_size(P1_next_name)), "16"):16, ?_(P1_next_name, bin)/binary>> || #wanted_npc{id = P1_id, base_id = P1_base_id, coin = P1_coin, stone = P1_stone, kill_count = P1_kill_count, killed_count = P1_killed_count, benefit_name = P1_benefit_name, next_name = P1_next_name} <- P0_npc_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15011:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15011), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15011:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15012), {P0_count, P0_killed_count, P0_need_count, P0_left_time, P0_alive_left_time, P0_role_list}) ->
    D_a_t_a = <<?_(P0_count, '8'):8, ?_(P0_killed_count, '16'):16, ?_(P0_need_count, '16'):16, ?_(P0_left_time, '32'):32, ?_(P0_alive_left_time, '32'):32, ?_((length(P0_role_list)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '16'):16, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_coin, '32'):32, ?_(P1_stone, '32'):32, ?_(P1_kill_count, '32'):32, ?_(P1_killed_count, '32'):32, ?_(P1_status, '8'):8, ?_((length(P1_looks)), "16"):16, (list_to_binary([<<?_(P2_looks_type, '8'):8, ?_(P2_looks_id, '32'):32, ?_(P2_looks_value, '16'):16>> || {P2_looks_type, P2_looks_id, P2_looks_value} <- P1_looks]))/binary>> || #wanted_role{id = P1_id, name = P1_name, lev = P1_lev, career = P1_career, sex = P1_sex, coin = P1_coin, stone = P1_stone, kill_count = P1_kill_count, killed_count = P1_killed_count, status = P1_status, looks = P1_looks} <- P0_role_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15012:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15012), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15012:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15013), {P0_count, P0_killed_count, P0_need_count, P0_left_time, P0_alive_left_time, P0_role_list}) ->
    D_a_t_a = <<?_(P0_count, '8'):8, ?_(P0_killed_count, '16'):16, ?_(P0_need_count, '16'):16, ?_(P0_left_time, '32'):32, ?_(P0_alive_left_time, '32'):32, ?_((length(P0_role_list)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '16'):16, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_coin, '32'):32, ?_(P1_stone, '32'):32, ?_(P1_kill_count, '32'):32, ?_(P1_killed_count, '32'):32, ?_((byte_size(P1_benefit_name)), "16"):16, ?_(P1_benefit_name, bin)/binary, ?_((length(P1_looks)), "16"):16, (list_to_binary([<<?_(P2_looks_type, '8'):8, ?_(P2_looks_id, '32'):32, ?_(P2_looks_value, '16'):16>> || {P2_looks_type, P2_looks_id, P2_looks_value} <- P1_looks]))/binary>> || #wanted_role{id = P1_id, name = P1_name, lev = P1_lev, career = P1_career, sex = P1_sex, coin = P1_coin, stone = P1_stone, kill_count = P1_kill_count, killed_count = P1_killed_count, benefit_name = P1_benefit_name, looks = P1_looks} <- P0_role_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15013:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15013), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15013:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15014), {P0_count, P0_killed_count, P0_need_count, P0_left_time}) ->
    D_a_t_a = <<?_(P0_count, '8'):8, ?_(P0_killed_count, '16'):16, ?_(P0_need_count, '16'):16, ?_(P0_left_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15014:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15014), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15014:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 15000, _B0) ->
    {ok, {}};
unpack(cli, 15000, _B0) ->
    {ok, {}};

unpack(srv, 15001, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_id}};
unpack(cli, 15001, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_id}};

unpack(srv, 15002, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_id}};
unpack(cli, 15002, _B0) ->
    {P0_steal_coin, _B1} = lib_proto:read_uint16(_B0),
    {P0_steal_stone, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_steal_coin, P0_steal_stone}};

unpack(srv, 15003, _B0) ->
    {ok, {}};
unpack(cli, 15003, _B0) ->
    {ok, {}};

unpack(srv, 15004, _B0) ->
    {ok, {}};
unpack(cli, 15004, _B0) ->
    {P0_exp, _B1} = lib_proto:read_uint32(_B0),
    {P0_coin, _B2} = lib_proto:read_uint16(_B1),
    {P0_stone, _B3} = lib_proto:read_uint16(_B2),
    {ok, {P0_exp, P0_coin, P0_stone}};

unpack(srv, 15005, _B0) ->
    {ok, {}};
unpack(cli, 15005, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_cd_time, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_status, P0_cd_time}};

unpack(srv, 15006, _B0) ->
    {ok, {}};
unpack(cli, 15006, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_status}};

unpack(srv, 15010, _B0) ->
    {ok, {}};
unpack(cli, 15010, _B0) ->
    {P0_count, _B1} = lib_proto:read_uint8(_B0),
    {P0_killed_count, _B2} = lib_proto:read_uint16(_B1),
    {P0_need_count, _B3} = lib_proto:read_uint16(_B2),
    {P0_left_time, _B4} = lib_proto:read_uint32(_B3),
    {P0_npc_list, _B13} = lib_proto:read_array(_B4, fun(_B5) ->
        {P1_id, _B6} = lib_proto:read_uint8(_B5),
        {P1_base_id, _B7} = lib_proto:read_uint32(_B6),
        {P1_coin, _B8} = lib_proto:read_uint32(_B7),
        {P1_stone, _B9} = lib_proto:read_uint32(_B8),
        {P1_kill_count, _B10} = lib_proto:read_uint32(_B9),
        {P1_killed_count, _B11} = lib_proto:read_uint32(_B10),
        {P1_status, _B12} = lib_proto:read_uint8(_B11),
        {[P1_id, P1_base_id, P1_coin, P1_stone, P1_kill_count, P1_killed_count, P1_status], _B12}
    end),
    {ok, {P0_count, P0_killed_count, P0_need_count, P0_left_time, P0_npc_list}};

unpack(srv, 15011, _B0) ->
    {ok, {}};
unpack(cli, 15011, _B0) ->
    {P0_count, _B1} = lib_proto:read_uint8(_B0),
    {P0_killed_count, _B2} = lib_proto:read_uint16(_B1),
    {P0_need_count, _B3} = lib_proto:read_uint16(_B2),
    {P0_left_time, _B4} = lib_proto:read_uint32(_B3),
    {P0_alive_left_time, _B5} = lib_proto:read_uint32(_B4),
    {P0_npc_list, _B15} = lib_proto:read_array(_B5, fun(_B6) ->
        {P1_id, _B7} = lib_proto:read_uint8(_B6),
        {P1_base_id, _B8} = lib_proto:read_uint32(_B7),
        {P1_coin, _B9} = lib_proto:read_uint32(_B8),
        {P1_stone, _B10} = lib_proto:read_uint32(_B9),
        {P1_kill_count, _B11} = lib_proto:read_uint32(_B10),
        {P1_killed_count, _B12} = lib_proto:read_uint32(_B11),
        {P1_benefit_name, _B13} = lib_proto:read_string(_B12),
        {P1_next_name, _B14} = lib_proto:read_string(_B13),
        {[P1_id, P1_base_id, P1_coin, P1_stone, P1_kill_count, P1_killed_count, P1_benefit_name, P1_next_name], _B14}
    end),
    {ok, {P0_count, P0_killed_count, P0_need_count, P0_left_time, P0_alive_left_time, P0_npc_list}};

unpack(srv, 15012, _B0) ->
    {ok, {}};
unpack(cli, 15012, _B0) ->
    {P0_count, _B1} = lib_proto:read_uint8(_B0),
    {P0_killed_count, _B2} = lib_proto:read_uint16(_B1),
    {P0_need_count, _B3} = lib_proto:read_uint16(_B2),
    {P0_left_time, _B4} = lib_proto:read_uint32(_B3),
    {P0_alive_left_time, _B5} = lib_proto:read_uint32(_B4),
    {P0_role_list, _B22} = lib_proto:read_array(_B5, fun(_B6) ->
        {P1_id, _B7} = lib_proto:read_uint8(_B6),
        {P1_name, _B8} = lib_proto:read_string(_B7),
        {P1_lev, _B9} = lib_proto:read_uint16(_B8),
        {P1_career, _B10} = lib_proto:read_uint8(_B9),
        {P1_sex, _B11} = lib_proto:read_uint8(_B10),
        {P1_coin, _B12} = lib_proto:read_uint32(_B11),
        {P1_stone, _B13} = lib_proto:read_uint32(_B12),
        {P1_kill_count, _B14} = lib_proto:read_uint32(_B13),
        {P1_killed_count, _B15} = lib_proto:read_uint32(_B14),
        {P1_status, _B16} = lib_proto:read_uint8(_B15),
        {P1_looks, _B21} = lib_proto:read_array(_B16, fun(_B17) ->
            {P2_looks_type, _B18} = lib_proto:read_uint8(_B17),
            {P2_looks_id, _B19} = lib_proto:read_uint32(_B18),
            {P2_looks_value, _B20} = lib_proto:read_uint16(_B19),
            {[P2_looks_type, P2_looks_id, P2_looks_value], _B20}
        end),
        {[P1_id, P1_name, P1_lev, P1_career, P1_sex, P1_coin, P1_stone, P1_kill_count, P1_killed_count, P1_status, P1_looks], _B21}
    end),
    {ok, {P0_count, P0_killed_count, P0_need_count, P0_left_time, P0_alive_left_time, P0_role_list}};

unpack(srv, 15013, _B0) ->
    {ok, {}};
unpack(cli, 15013, _B0) ->
    {P0_count, _B1} = lib_proto:read_uint8(_B0),
    {P0_killed_count, _B2} = lib_proto:read_uint16(_B1),
    {P0_need_count, _B3} = lib_proto:read_uint16(_B2),
    {P0_left_time, _B4} = lib_proto:read_uint32(_B3),
    {P0_alive_left_time, _B5} = lib_proto:read_uint32(_B4),
    {P0_role_list, _B22} = lib_proto:read_array(_B5, fun(_B6) ->
        {P1_id, _B7} = lib_proto:read_uint8(_B6),
        {P1_name, _B8} = lib_proto:read_string(_B7),
        {P1_lev, _B9} = lib_proto:read_uint16(_B8),
        {P1_career, _B10} = lib_proto:read_uint8(_B9),
        {P1_sex, _B11} = lib_proto:read_uint8(_B10),
        {P1_coin, _B12} = lib_proto:read_uint32(_B11),
        {P1_stone, _B13} = lib_proto:read_uint32(_B12),
        {P1_kill_count, _B14} = lib_proto:read_uint32(_B13),
        {P1_killed_count, _B15} = lib_proto:read_uint32(_B14),
        {P1_benefit_name, _B16} = lib_proto:read_string(_B15),
        {P1_looks, _B21} = lib_proto:read_array(_B16, fun(_B17) ->
            {P2_looks_type, _B18} = lib_proto:read_uint8(_B17),
            {P2_looks_id, _B19} = lib_proto:read_uint32(_B18),
            {P2_looks_value, _B20} = lib_proto:read_uint16(_B19),
            {[P2_looks_type, P2_looks_id, P2_looks_value], _B20}
        end),
        {[P1_id, P1_name, P1_lev, P1_career, P1_sex, P1_coin, P1_stone, P1_kill_count, P1_killed_count, P1_benefit_name, P1_looks], _B21}
    end),
    {ok, {P0_count, P0_killed_count, P0_need_count, P0_left_time, P0_alive_left_time, P0_role_list}};

unpack(srv, 15014, _B0) ->
    {ok, {}};
unpack(cli, 15014, _B0) ->
    {P0_count, _B1} = lib_proto:read_uint8(_B0),
    {P0_killed_count, _B2} = lib_proto:read_uint16(_B1),
    {P0_need_count, _B3} = lib_proto:read_uint16(_B2),
    {P0_left_time, _B4} = lib_proto:read_uint32(_B3),
    {ok, {P0_count, P0_killed_count, P0_need_count, P0_left_time}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
