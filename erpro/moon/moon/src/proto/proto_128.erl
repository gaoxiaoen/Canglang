%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_128).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("boss.hrl").
-include("item.hrl").
-include("change.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(12800), {P0_npc_list}) ->
    D_a_t_a = <<?_((length(P0_npc_list)), "16"):16, (list_to_binary([<<?_(P1_npc_id, '32'):32, ?_((byte_size(P1_npc_name)), "16"):16, ?_(P1_npc_name, bin)/binary, ?_(P1_npc_lev, '32'):32, ?_(P1_status, '32'):32, ?_(P1_map_id, '32'):32, ?_((byte_size(P1_map_name)), "16"):16, ?_(P1_map_name, bin)/binary>> || #boss{npc_id = P1_npc_id, npc_name = P1_npc_name, npc_lev = P1_npc_lev, status = P1_status, map_id = P1_map_id, map_name = P1_map_name} <- P0_npc_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12800:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12800), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12800:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12801), {P0_npc_id, P0_status}) ->
    D_a_t_a = <<?_(P0_npc_id, '32'):32, ?_(P0_status, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12801:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12801), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12801:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12850), {P0_id, P0_left_time, P0_reward}) ->
    D_a_t_a = <<?_(P0_id, '16'):16, ?_(P0_left_time, '16'):16, ?_(P0_reward, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12850:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12850), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12850:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12851), {P0_reward, P0_exp, P0_coin}) ->
    D_a_t_a = <<?_(P0_reward, '32'):32, ?_(P0_exp, '32'):32, ?_(P0_coin, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12851:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12851), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12851:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12852), {P0_reward}) ->
    D_a_t_a = <<?_(P0_reward, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12852:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12852), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12852:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12853), {P0_left_time}) ->
    D_a_t_a = <<?_(P0_left_time, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12853:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12853), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12853:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12859), {P0_status, P0_left, P0_is_taken}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_left, '16'):16, ?_(P0_is_taken, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12859:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12859), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12859:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12860), {P0_status, P0_left}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_left, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12860:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12860), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12860:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12861), {P0_status}) ->
    D_a_t_a = <<?_(P0_status, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12861:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12861), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12861:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12862), {P0_hp, P0_hp_max}) ->
    D_a_t_a = <<?_(P0_hp, '32'):32, ?_(P0_hp_max, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12862:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12862), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12862:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12863), {P0_result}) ->
    D_a_t_a = <<?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12863:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12863), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12863:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12865), {P0_boss_list}) ->
    D_a_t_a = <<?_((length(P0_boss_list)), "16"):16, (list_to_binary([<<?_(P1_id, '16'):16, ?_(P1_hp, '32'):32, ?_(P1_hp_max, '32'):32, ?_(P1_invade_map_id, '16'):16>> || {P1_id, P1_hp, P1_hp_max, P1_invade_map_id} <- P0_boss_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12865:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12865), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12865:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12866), {P0_id, P0_invade_map_id, P0_kill_count, P0_last_name, P0_name, P0_lev, P0_career, P0_sex, P0_dmg, P0_looks, P0_recent_list}) ->
    D_a_t_a = <<?_(P0_id, '16'):16, ?_(P0_invade_map_id, '16'):16, ?_(P0_kill_count, '32'):32, ?_((byte_size(P0_last_name)), "16"):16, ?_(P0_last_name, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_lev, '8'):8, ?_(P0_career, '8'):8, ?_(P0_sex, '8'):8, ?_(P0_dmg, '32'):32, ?_((length(P0_looks)), "16"):16, (list_to_binary([<<?_(P1_looks_type, '8'):8, ?_(P1_looks_id, '32'):32, ?_(P1_looks_value, '16'):16>> || {P1_looks_type, P1_looks_id, P1_looks_value} <- P0_looks]))/binary, ?_((length(P0_recent_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary>> || P1_name <- P0_recent_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12866:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12866), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12866:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12870), {P0_total_page, P0_boss_rank_list}) ->
    D_a_t_a = <<?_(P0_total_page, '8'):8, ?_((length(P0_boss_rank_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_dmg, '32'):32>> || {P1_srv_id, P1_rid, P1_name, P1_career, P1_guild, P1_dmg} <- P0_boss_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12870:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12870), {P0_page_index}) ->
    D_a_t_a = <<?_(P0_page_index, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12870:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12871), {P0_boss_count, P0_killed_boss_count, P0_kill_count, P0_reward_count, P0_boss_info_list}) ->
    D_a_t_a = <<?_(P0_boss_count, '8'):8, ?_(P0_killed_boss_count, '8'):8, ?_(P0_kill_count, '32'):32, ?_(P0_reward_count, '32'):32, ?_((length(P0_boss_info_list)), "16"):16, (list_to_binary([<<?_(P1_id, '16'):16, ?_(P1_invade_map_id, '16'):16, ?_(P1_kill_count, '32'):32, ?_((length(P1_role_list)), "16"):16, (list_to_binary([<<?_((byte_size(P2_name)), "16"):16, ?_(P2_name, bin)/binary, ?_(P2_lev, '8'):8, ?_(P2_career, '8'):8, ?_(P2_sex, '8'):8, ?_((length(P2_looks)), "16"):16, (list_to_binary([<<?_(P3_looks_type, '8'):8, ?_(P3_looks_id, '32'):32, ?_(P3_looks_value, '16'):16>> || {P3_looks_type, P3_looks_id, P3_looks_value} <- P2_looks]))/binary>> || {P2_name, P2_lev, P2_career, P2_sex, P2_looks} <- P1_role_list]))/binary>> || {P1_id, P1_invade_map_id, P1_kill_count, P1_role_list} <- P0_boss_info_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12871:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12871), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12871:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12872), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12872:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12872), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12872:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12875), {P0_scale, P0_items}) ->
    D_a_t_a = <<?_(P0_scale, '32'):32, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_(P1_count, '8'):8, ?_(P1_base_id, '32'):32, ?_(P1_price, '16'):16>> || #change_item{id = P1_id, count = P1_count, base_id = P1_base_id, price = P1_price} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12875:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12875), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12875:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12876), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12876:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12876), {P0_id, P0_num}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_(P0_num, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12876:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 12850, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_id}};
unpack(cli, 12850, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint16(_B0),
    {P0_left_time, _B2} = lib_proto:read_uint16(_B1),
    {P0_reward, _B3} = lib_proto:read_uint16(_B2),
    {ok, {P0_id, P0_left_time, P0_reward}};

unpack(srv, 12851, _B0) ->
    {ok, {}};
unpack(cli, 12851, _B0) ->
    {P0_reward, _B1} = lib_proto:read_uint32(_B0),
    {P0_exp, _B2} = lib_proto:read_uint32(_B1),
    {P0_coin, _B3} = lib_proto:read_uint32(_B2),
    {ok, {P0_reward, P0_exp, P0_coin}};

unpack(srv, 12852, _B0) ->
    {ok, {}};
unpack(cli, 12852, _B0) ->
    {P0_reward, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_reward}};

unpack(srv, 12853, _B0) ->
    {ok, {}};
unpack(cli, 12853, _B0) ->
    {P0_left_time, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_left_time}};

unpack(srv, 12859, _B0) ->
    {ok, {}};
unpack(cli, 12859, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_left, _B2} = lib_proto:read_uint16(_B1),
    {P0_is_taken, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_status, P0_left, P0_is_taken}};

unpack(srv, 12860, _B0) ->
    {ok, {}};
unpack(cli, 12860, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_left, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_left}};

unpack(srv, 12861, _B0) ->
    {ok, {}};
unpack(cli, 12861, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_status}};

unpack(srv, 12862, _B0) ->
    {ok, {}};
unpack(cli, 12862, _B0) ->
    {P0_hp, _B1} = lib_proto:read_uint32(_B0),
    {P0_hp_max, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_hp, P0_hp_max}};

unpack(srv, 12863, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_type}};
unpack(cli, 12863, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_result}};

unpack(srv, 12865, _B0) ->
    {ok, {}};
unpack(cli, 12865, _B0) ->
    {P0_boss_list, _B6} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint16(_B1),
        {P1_hp, _B3} = lib_proto:read_uint32(_B2),
        {P1_hp_max, _B4} = lib_proto:read_uint32(_B3),
        {P1_invade_map_id, _B5} = lib_proto:read_uint16(_B4),
        {[P1_id, P1_hp, P1_hp_max, P1_invade_map_id], _B5}
    end),
    {ok, {P0_boss_list}};

unpack(srv, 12866, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 12866, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint16(_B0),
    {P0_invade_map_id, _B2} = lib_proto:read_uint16(_B1),
    {P0_kill_count, _B3} = lib_proto:read_uint32(_B2),
    {P0_last_name, _B4} = lib_proto:read_string(_B3),
    {P0_name, _B5} = lib_proto:read_string(_B4),
    {P0_lev, _B6} = lib_proto:read_uint8(_B5),
    {P0_career, _B7} = lib_proto:read_uint8(_B6),
    {P0_sex, _B8} = lib_proto:read_uint8(_B7),
    {P0_dmg, _B9} = lib_proto:read_uint32(_B8),
    {P0_looks, _B14} = lib_proto:read_array(_B9, fun(_B10) ->
        {P1_looks_type, _B11} = lib_proto:read_uint8(_B10),
        {P1_looks_id, _B12} = lib_proto:read_uint32(_B11),
        {P1_looks_value, _B13} = lib_proto:read_uint16(_B12),
        {[P1_looks_type, P1_looks_id, P1_looks_value], _B13}
    end),
    {P0_recent_list, _B17} = lib_proto:read_array(_B14, fun(_B15) ->
        {P1_name, _B16} = lib_proto:read_string(_B15),
        {P1_name, _B16}
    end),
    {ok, {P0_id, P0_invade_map_id, P0_kill_count, P0_last_name, P0_name, P0_lev, P0_career, P0_sex, P0_dmg, P0_looks, P0_recent_list}};

unpack(srv, 12870, _B0) ->
    {P0_page_index, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_page_index}};
unpack(cli, 12870, _B0) ->
    {P0_total_page, _B1} = lib_proto:read_uint8(_B0),
    {P0_boss_rank_list, _B9} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_srv_id, _B3} = lib_proto:read_string(_B2),
        {P1_rid, _B4} = lib_proto:read_uint32(_B3),
        {P1_name, _B5} = lib_proto:read_string(_B4),
        {P1_career, _B6} = lib_proto:read_uint8(_B5),
        {P1_guild, _B7} = lib_proto:read_string(_B6),
        {P1_dmg, _B8} = lib_proto:read_uint32(_B7),
        {[P1_srv_id, P1_rid, P1_name, P1_career, P1_guild, P1_dmg], _B8}
    end),
    {ok, {P0_total_page, P0_boss_rank_list}};

unpack(srv, 12871, _B0) ->
    {ok, {}};
unpack(cli, 12871, _B0) ->
    {P0_boss_count, _B1} = lib_proto:read_uint8(_B0),
    {P0_killed_boss_count, _B2} = lib_proto:read_uint8(_B1),
    {P0_kill_count, _B3} = lib_proto:read_uint32(_B2),
    {P0_reward_count, _B4} = lib_proto:read_uint32(_B3),
    {P0_boss_info_list, _B20} = lib_proto:read_array(_B4, fun(_B5) ->
        {P1_id, _B6} = lib_proto:read_uint16(_B5),
        {P1_invade_map_id, _B7} = lib_proto:read_uint16(_B6),
        {P1_kill_count, _B8} = lib_proto:read_uint32(_B7),
        {P1_role_list, _B19} = lib_proto:read_array(_B8, fun(_B9) ->
            {P2_name, _B10} = lib_proto:read_string(_B9),
            {P2_lev, _B11} = lib_proto:read_uint8(_B10),
            {P2_career, _B12} = lib_proto:read_uint8(_B11),
            {P2_sex, _B13} = lib_proto:read_uint8(_B12),
            {P2_looks, _B18} = lib_proto:read_array(_B13, fun(_B14) ->
                {P3_looks_type, _B15} = lib_proto:read_uint8(_B14),
                {P3_looks_id, _B16} = lib_proto:read_uint32(_B15),
                {P3_looks_value, _B17} = lib_proto:read_uint16(_B16),
                {[P3_looks_type, P3_looks_id, P3_looks_value], _B17}
            end),
            {[P2_name, P2_lev, P2_career, P2_sex, P2_looks], _B18}
        end),
        {[P1_id, P1_invade_map_id, P1_kill_count, P1_role_list], _B19}
    end),
    {ok, {P0_boss_count, P0_killed_boss_count, P0_kill_count, P0_reward_count, P0_boss_info_list}};

unpack(srv, 12872, _B0) ->
    {ok, {}};
unpack(cli, 12872, _B0) ->
    {ok, {}};

unpack(srv, 12875, _B0) ->
    {ok, {}};
unpack(cli, 12875, _B0) ->
    {P0_scale, _B1} = lib_proto:read_uint32(_B0),
    {P0_items, _B7} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_id, _B3} = lib_proto:read_uint8(_B2),
        {P1_count, _B4} = lib_proto:read_uint8(_B3),
        {P1_base_id, _B5} = lib_proto:read_uint32(_B4),
        {P1_price, _B6} = lib_proto:read_uint16(_B5),
        {[P1_id, P1_count, P1_base_id, P1_price], _B6}
    end),
    {ok, {P0_scale, P0_items}};

unpack(srv, 12876, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint8(_B0),
    {P0_num, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_id, P0_num}};
unpack(cli, 12876, _B0) ->
    {ok, {}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
