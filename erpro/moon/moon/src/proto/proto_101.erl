%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_101).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("map.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(10100), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10100:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10100), {P0_id, P0_status}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_status, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10100:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10101), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10101:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10101), {P0_map_id}) ->
    D_a_t_a = <<?_(P0_map_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10101:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10102), {P0_map_id}) ->
    D_a_t_a = <<?_(P0_map_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10102:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10102), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10102:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10110), {P0_base_id, P0_x, P0_y}) ->
    D_a_t_a = <<?_(P0_base_id, '32'):32, ?_(P0_x, '16'):16, ?_(P0_y, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10110:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10110), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10110:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10111), {P0_elem_list, P0_npc_list, P0_role_list}) ->
    D_a_t_a = <<?_((length(P0_elem_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_type, '8'):8, ?_(P1_status, '32'):32, ?_(P1_x, '16'):16, ?_(P1_y, '16'):16>> || #map_elem{id = P1_id, base_id = P1_base_id, type = P1_type, status = P1_status, x = P1_x, y = P1_y} <- P0_elem_list]))/binary, ?_((length(P0_npc_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_status, '8'):8, ?_(P1_base_id, '32'):32, ?_(P1_speed, '16'):16, ?_(P1_x, '16'):16, ?_(P1_y, '16'):16>> || #map_npc{id = P1_id, status = P1_status, base_id = P1_base_id, speed = P1_speed, x = P1_x, y = P1_y} <- P0_npc_list]))/binary, ?_((length(P0_role_list)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_speed, '16'):16, ?_(P1_dir, '8/signed'):8/signed, ?_(P1_x, '16'):16, ?_(P1_y, '16'):16, ?_(P1_dest_x, '16'):16, ?_(P1_dest_y, '16'):16, ?_(P1_status, '8'):8, ?_(P1_action, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_career, '8'):8, ?_(P1_vip_type, '8'):8, ?_((length(P1_looks)), "16"):16, (list_to_binary([<<?_(P2_looks_type, '8'):8, ?_(P2_looks_id, '32'):32, ?_(P2_looks_value, '16'):16>> || {P2_looks_type, P2_looks_id, P2_looks_value} <- P1_looks]))/binary, ?_((length(P1_special)), "16"):16, (list_to_binary([<<?_(P2_type, '8'):8, ?_(P2_val_int, '32'):32, ?_((byte_size(P2_val_str)), "16"):16, ?_(P2_val_str, bin)/binary>> || {P2_type, P2_val_int, P2_val_str} <- P1_special]))/binary>> || #map_role{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, speed = P1_speed, dir = P1_dir, x = P1_x, y = P1_y, dest_x = P1_dest_x, dest_y = P1_dest_y, status = P1_status, action = P1_action, sex = P1_sex, career = P1_career, vip_type = P1_vip_type, looks = P1_looks, special = P1_special} <- P0_role_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10111:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10111), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10111:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10112), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10112:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10112), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10112:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10113), {P0_rid, P0_srv_id, P0_name, P0_move_speed, P0_dir, P0_x, P0_y, P0_dest_x, P0_dest_y, P0_status, P0_action, P0_sex, P0_career, P0_vip_type, P0_looks, P0_special}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_move_speed, '16'):16, ?_(P0_dir, '8/signed'):8/signed, ?_(P0_x, '16'):16, ?_(P0_y, '16'):16, ?_(P0_dest_x, '16'):16, ?_(P0_dest_y, '16'):16, ?_(P0_status, '8'):8, ?_(P0_action, '8'):8, ?_(P0_sex, '8'):8, ?_(P0_career, '8'):8, ?_(P0_vip_type, '8'):8, ?_((length(P0_looks)), "16"):16, (list_to_binary([<<?_(P1_looks_type, '8'):8, ?_(P1_looks_id, '32'):32, ?_(P1_looks_value, '16'):16>> || {P1_looks_type, P1_looks_id, P1_looks_value} <- P0_looks]))/binary, ?_((length(P0_special)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_val_int, '32'):32, ?_((byte_size(P1_val_str)), "16"):16, ?_(P1_val_str, bin)/binary>> || {P1_type, P1_val_int, P1_val_str} <- P0_special]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10113:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10113), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10113:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10114), {P0_role_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10114:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10114), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10114:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10115), {P0_role_id, P0_srv_id, P0_x, P0_y}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_x, '16'):16, ?_(P0_y, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10115:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10115), {P0_x, P0_y, P0_dir}) ->
    D_a_t_a = <<?_(P0_x, '16'):16, ?_(P0_y, '16'):16, ?_(P0_dir, '8/signed'):8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10115:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10116), {P0_role_list, P0_del_list}) ->
    D_a_t_a = <<?_((length(P0_role_list)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_speed, '16'):16, ?_(P1_dir, '8/signed'):8/signed, ?_(P1_x, '16'):16, ?_(P1_y, '16'):16, ?_(P1_dest_x, '16'):16, ?_(P1_dest_y, '16'):16, ?_(P1_status, '8'):8, ?_(P1_action, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_career, '8'):8, ?_(P1_vip_type, '8'):8, ?_((length(P1_looks)), "16"):16, (list_to_binary([<<?_(P2_looks_type, '8'):8, ?_(P2_looks_id, '32'):32, ?_(P2_looks_value, '16'):16>> || {P2_looks_type, P2_looks_id, P2_looks_value} <- P1_looks]))/binary, ?_((length(P1_special)), "16"):16, (list_to_binary([<<?_(P2_type, '8'):8, ?_(P2_val_int, '32'):32, ?_((byte_size(P2_val_str)), "16"):16, ?_(P2_val_str, bin)/binary>> || {P2_type, P2_val_int, P2_val_str} <- P1_special]))/binary>> || #map_role{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, speed = P1_speed, dir = P1_dir, x = P1_x, y = P1_y, dest_x = P1_dest_x, dest_y = P1_dest_y, status = P1_status, action = P1_action, sex = P1_sex, career = P1_career, vip_type = P1_vip_type, looks = P1_looks, special = P1_special} <- P0_role_list]))/binary, ?_((length(P0_del_list)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary>> || #map_role{rid = P1_rid, srv_id = P1_srv_id} <- P0_del_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10116:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10116), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10116:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10117), {P0_rid, P0_srv_id, P0_move_speed, P0_dir, P0_status, P0_action, P0_sex, P0_career, P0_vip_type, P0_looks, P0_special}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_move_speed, '16'):16, ?_(P0_dir, '8/signed'):8/signed, ?_(P0_status, '8'):8, ?_(P0_action, '8'):8, ?_(P0_sex, '8'):8, ?_(P0_career, '8'):8, ?_(P0_vip_type, '8'):8, ?_((length(P0_looks)), "16"):16, (list_to_binary([<<?_(P1_looks_type, '8'):8, ?_(P1_looks_id, '32'):32, ?_(P1_looks_value, '16'):16>> || {P1_looks_type, P1_looks_id, P1_looks_value} <- P0_looks]))/binary, ?_((length(P0_special)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_val_int, '32'):32, ?_((byte_size(P1_val_str)), "16"):16, ?_(P1_val_str, bin)/binary>> || {P1_type, P1_val_int, P1_val_str} <- P0_special]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10117:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10117), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10117:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10118), {P0_x, P0_y}) ->
    D_a_t_a = <<?_(P0_x, '16'):16, ?_(P0_y, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10118:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10118), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10118:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10119), {P0_rid, P0_srv_id, P0_special}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((length(P0_special)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_val_int, '32'):32, ?_((byte_size(P1_val_str)), "16"):16, ?_(P1_val_str, bin)/binary>> || {P1_type, P1_val_int, P1_val_str} <- P0_special]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10119:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10119), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10119:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10120), {P0_id, P0_status, P0_base_id, P0_move_speed, P0_x, P0_y}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_status, '8'):8, ?_(P0_base_id, '32'):32, ?_(P0_move_speed, '16'):16, ?_(P0_x, '16'):16, ?_(P0_y, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10120:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10120), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10120:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10121), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10121:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10121), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10121:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10122), {P0_id, P0_x, P0_y}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_x, '16'):16, ?_(P0_y, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10122:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10122), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10122:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10123), {P0_flag, P0_id, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_(P0_id, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10123:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10123), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10123:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10124), {P0_special_npc}) ->
    D_a_t_a = <<?_((length(P0_special_npc)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_sex, '8'):8, ?_(P1_career, '8'):8, ?_((length(P1_looks)), "16"):16, (list_to_binary([<<?_(P2_looks_type, '8'):8, ?_(P2_looks_id, '32'):32, ?_(P2_looks_value, '16'):16>> || {P2_looks_type, P2_looks_id, P2_looks_value} <- P1_looks]))/binary>> || {P1_base_id, P1_name, P1_sex, P1_career, P1_looks} <- P0_special_npc]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10124:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10124), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10124:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10130), {P0_id, P0_base_id, P0_type, P0_status, P0_x, P0_y}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_base_id, '32'):32, ?_(P0_type, '8'):8, ?_(P0_status, '32'):32, ?_(P0_x, '16'):16, ?_(P0_y, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10130:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10130), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10130:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10131), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10131:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10131), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10131:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10132), {P0_id, P0_status}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_status, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10132:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10132), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10132:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10140), {P0_type, P0_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10140:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10140), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10140:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10150), {P0_item_list}) ->
    D_a_t_a = <<?_((length(P0_item_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_count, '8'):8>> || {P1_id, P1_bind, P1_count} <- P0_item_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10150:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10150), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10150:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10160), {P0_id, P0_list}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_(P1_status, '8'):8>> || {P1_id, P1_status} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10160:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10160), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10160:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10161), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10161:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10161), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10161:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10162), {P0_code}) ->
    D_a_t_a = <<?_(P0_code, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10162:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10162), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10162:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10163), {P0_scene_id}) ->
    D_a_t_a = <<?_(P0_scene_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10163:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10163), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10163:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10164), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10164:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10164), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10164:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10166), {P0_id, P0_status}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_(P0_status, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10166:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10166), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10166:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 10100, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_status, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_id, P0_status}};
unpack(cli, 10100, _B0) ->
    {ok, {}};

unpack(srv, 10101, _B0) ->
    {P0_map_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_map_id}};
unpack(cli, 10101, _B0) ->
    {ok, {}};

unpack(srv, 10102, _B0) ->
    {ok, {}};
unpack(cli, 10102, _B0) ->
    {P0_map_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_map_id}};

unpack(srv, 10110, _B0) ->
    {ok, {}};
unpack(cli, 10110, _B0) ->
    {P0_base_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_x, _B2} = lib_proto:read_uint16(_B1),
    {P0_y, _B3} = lib_proto:read_uint16(_B2),
    {ok, {P0_base_id, P0_x, P0_y}};

unpack(srv, 10111, _B0) ->
    {ok, {}};
unpack(cli, 10111, _B0) ->
    {P0_elem_list, _B8} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_base_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_type, _B4} = lib_proto:read_uint8(_B3),
        {P1_status, _B5} = lib_proto:read_uint32(_B4),
        {P1_x, _B6} = lib_proto:read_uint16(_B5),
        {P1_y, _B7} = lib_proto:read_uint16(_B6),
        {[P1_id, P1_base_id, P1_type, P1_status, P1_x, P1_y], _B7}
    end),
    {P0_npc_list, _B16} = lib_proto:read_array(_B8, fun(_B9) ->
        {P1_id, _B10} = lib_proto:read_uint32(_B9),
        {P1_status, _B11} = lib_proto:read_uint8(_B10),
        {P1_base_id, _B12} = lib_proto:read_uint32(_B11),
        {P1_move_speed, _B13} = lib_proto:read_uint16(_B12),
        {P1_x, _B14} = lib_proto:read_uint16(_B13),
        {P1_y, _B15} = lib_proto:read_uint16(_B14),
        {[P1_id, P1_status, P1_base_id, P1_move_speed, P1_x, P1_y], _B15}
    end),
    {P0_role_list, _B42} = lib_proto:read_array(_B16, fun(_B17) ->
        {P1_rid, _B18} = lib_proto:read_uint32(_B17),
        {P1_srv_id, _B19} = lib_proto:read_string(_B18),
        {P1_name, _B20} = lib_proto:read_string(_B19),
        {P1_move_speed, _B21} = lib_proto:read_uint16(_B20),
        {P1_dir, _B22} = lib_proto:read_int8(_B21),
        {P1_x, _B23} = lib_proto:read_uint16(_B22),
        {P1_y, _B24} = lib_proto:read_uint16(_B23),
        {P1_dest_x, _B25} = lib_proto:read_uint16(_B24),
        {P1_dest_y, _B26} = lib_proto:read_uint16(_B25),
        {P1_status, _B27} = lib_proto:read_uint8(_B26),
        {P1_action, _B28} = lib_proto:read_uint8(_B27),
        {P1_sex, _B29} = lib_proto:read_uint8(_B28),
        {P1_career, _B30} = lib_proto:read_uint8(_B29),
        {P1_vip_type, _B31} = lib_proto:read_uint8(_B30),
        {P1_looks, _B36} = lib_proto:read_array(_B31, fun(_B32) ->
            {P2_looks_type, _B33} = lib_proto:read_uint8(_B32),
            {P2_looks_id, _B34} = lib_proto:read_uint32(_B33),
            {P2_looks_value, _B35} = lib_proto:read_uint16(_B34),
            {[P2_looks_type, P2_looks_id, P2_looks_value], _B35}
        end),
        {P1_special, _B41} = lib_proto:read_array(_B36, fun(_B37) ->
            {P2_type, _B38} = lib_proto:read_uint8(_B37),
            {P2_val_int, _B39} = lib_proto:read_uint32(_B38),
            {P2_val_str, _B40} = lib_proto:read_string(_B39),
            {[P2_type, P2_val_int, P2_val_str], _B40}
        end),
        {[P1_rid, P1_srv_id, P1_name, P1_move_speed, P1_dir, P1_x, P1_y, P1_dest_x, P1_dest_y, P1_status, P1_action, P1_sex, P1_career, P1_vip_type, P1_looks, P1_special], _B41}
    end),
    {ok, {P0_elem_list, P0_npc_list, P0_role_list}};

unpack(srv, 10112, _B0) ->
    {ok, {}};
unpack(cli, 10112, _B0) ->
    {ok, {}};

unpack(srv, 10113, _B0) ->
    {ok, {}};
unpack(cli, 10113, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_name, _B3} = lib_proto:read_string(_B2),
    {P0_move_speed, _B4} = lib_proto:read_uint16(_B3),
    {P0_dir, _B5} = lib_proto:read_int8(_B4),
    {P0_x, _B6} = lib_proto:read_uint16(_B5),
    {P0_y, _B7} = lib_proto:read_uint16(_B6),
    {P0_dest_x, _B8} = lib_proto:read_uint16(_B7),
    {P0_dest_y, _B9} = lib_proto:read_uint16(_B8),
    {P0_status, _B10} = lib_proto:read_uint8(_B9),
    {P0_action, _B11} = lib_proto:read_uint8(_B10),
    {P0_sex, _B12} = lib_proto:read_uint8(_B11),
    {P0_career, _B13} = lib_proto:read_uint8(_B12),
    {P0_vip_type, _B14} = lib_proto:read_uint8(_B13),
    {P0_looks, _B19} = lib_proto:read_array(_B14, fun(_B15) ->
        {P1_looks_type, _B16} = lib_proto:read_uint8(_B15),
        {P1_looks_id, _B17} = lib_proto:read_uint32(_B16),
        {P1_looks_value, _B18} = lib_proto:read_uint16(_B17),
        {[P1_looks_type, P1_looks_id, P1_looks_value], _B18}
    end),
    {P0_special, _B24} = lib_proto:read_array(_B19, fun(_B20) ->
        {P1_type, _B21} = lib_proto:read_uint8(_B20),
        {P1_val_int, _B22} = lib_proto:read_uint32(_B21),
        {P1_val_str, _B23} = lib_proto:read_string(_B22),
        {[P1_type, P1_val_int, P1_val_str], _B23}
    end),
    {ok, {P0_rid, P0_srv_id, P0_name, P0_move_speed, P0_dir, P0_x, P0_y, P0_dest_x, P0_dest_y, P0_status, P0_action, P0_sex, P0_career, P0_vip_type, P0_looks, P0_special}};

unpack(srv, 10114, _B0) ->
    {ok, {}};
unpack(cli, 10114, _B0) ->
    {P0_role_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_role_id, P0_srv_id}};

unpack(srv, 10115, _B0) ->
    {P0_x, _B1} = lib_proto:read_uint16(_B0),
    {P0_y, _B2} = lib_proto:read_uint16(_B1),
    {P0_dir, _B3} = lib_proto:read_int8(_B2),
    {ok, {P0_x, P0_y, P0_dir}};
unpack(cli, 10115, _B0) ->
    {P0_role_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_x, _B3} = lib_proto:read_uint16(_B2),
    {P0_y, _B4} = lib_proto:read_uint16(_B3),
    {ok, {P0_role_id, P0_srv_id, P0_x, P0_y}};

unpack(srv, 10116, _B0) ->
    {ok, {}};
unpack(cli, 10116, _B0) ->
    {P0_role_list, _B26} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_rid, _B2} = lib_proto:read_uint32(_B1),
        {P1_srv_id, _B3} = lib_proto:read_string(_B2),
        {P1_name, _B4} = lib_proto:read_string(_B3),
        {P1_move_speed, _B5} = lib_proto:read_uint16(_B4),
        {P1_dir, _B6} = lib_proto:read_int8(_B5),
        {P1_x, _B7} = lib_proto:read_uint16(_B6),
        {P1_y, _B8} = lib_proto:read_uint16(_B7),
        {P1_dest_x, _B9} = lib_proto:read_uint16(_B8),
        {P1_dest_y, _B10} = lib_proto:read_uint16(_B9),
        {P1_status, _B11} = lib_proto:read_uint8(_B10),
        {P1_action, _B12} = lib_proto:read_uint8(_B11),
        {P1_sex, _B13} = lib_proto:read_uint8(_B12),
        {P1_career, _B14} = lib_proto:read_uint8(_B13),
        {P1_vip_type, _B15} = lib_proto:read_uint8(_B14),
        {P1_looks, _B20} = lib_proto:read_array(_B15, fun(_B16) ->
            {P2_looks_type, _B17} = lib_proto:read_uint8(_B16),
            {P2_looks_id, _B18} = lib_proto:read_uint32(_B17),
            {P2_looks_value, _B19} = lib_proto:read_uint16(_B18),
            {[P2_looks_type, P2_looks_id, P2_looks_value], _B19}
        end),
        {P1_special, _B25} = lib_proto:read_array(_B20, fun(_B21) ->
            {P2_type, _B22} = lib_proto:read_uint8(_B21),
            {P2_val_int, _B23} = lib_proto:read_uint32(_B22),
            {P2_val_str, _B24} = lib_proto:read_string(_B23),
            {[P2_type, P2_val_int, P2_val_str], _B24}
        end),
        {[P1_rid, P1_srv_id, P1_name, P1_move_speed, P1_dir, P1_x, P1_y, P1_dest_x, P1_dest_y, P1_status, P1_action, P1_sex, P1_career, P1_vip_type, P1_looks, P1_special], _B25}
    end),
    {P0_del_list, _B30} = lib_proto:read_array(_B26, fun(_B27) ->
        {P1_rid, _B28} = lib_proto:read_uint32(_B27),
        {P1_srv_id, _B29} = lib_proto:read_string(_B28),
        {[P1_rid, P1_srv_id], _B29}
    end),
    {ok, {P0_role_list, P0_del_list}};

unpack(srv, 10117, _B0) ->
    {ok, {}};
unpack(cli, 10117, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_move_speed, _B3} = lib_proto:read_uint16(_B2),
    {P0_dir, _B4} = lib_proto:read_int8(_B3),
    {P0_status, _B5} = lib_proto:read_uint8(_B4),
    {P0_action, _B6} = lib_proto:read_uint8(_B5),
    {P0_sex, _B7} = lib_proto:read_uint8(_B6),
    {P0_career, _B8} = lib_proto:read_uint8(_B7),
    {P0_vip_type, _B9} = lib_proto:read_uint8(_B8),
    {P0_looks, _B14} = lib_proto:read_array(_B9, fun(_B10) ->
        {P1_looks_type, _B11} = lib_proto:read_uint8(_B10),
        {P1_looks_id, _B12} = lib_proto:read_uint32(_B11),
        {P1_looks_value, _B13} = lib_proto:read_uint16(_B12),
        {[P1_looks_type, P1_looks_id, P1_looks_value], _B13}
    end),
    {P0_special, _B19} = lib_proto:read_array(_B14, fun(_B15) ->
        {P1_type, _B16} = lib_proto:read_uint8(_B15),
        {P1_val_int, _B17} = lib_proto:read_uint32(_B16),
        {P1_val_str, _B18} = lib_proto:read_string(_B17),
        {[P1_type, P1_val_int, P1_val_str], _B18}
    end),
    {ok, {P0_rid, P0_srv_id, P0_move_speed, P0_dir, P0_status, P0_action, P0_sex, P0_career, P0_vip_type, P0_looks, P0_special}};

unpack(srv, 10118, _B0) ->
    {ok, {}};
unpack(cli, 10118, _B0) ->
    {P0_x, _B1} = lib_proto:read_uint16(_B0),
    {P0_y, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_x, P0_y}};

unpack(srv, 10119, _B0) ->
    {ok, {}};
unpack(cli, 10119, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_special, _B7} = lib_proto:read_array(_B2, fun(_B3) ->
        {P1_type, _B4} = lib_proto:read_uint8(_B3),
        {P1_val_int, _B5} = lib_proto:read_uint32(_B4),
        {P1_val_str, _B6} = lib_proto:read_string(_B5),
        {[P1_type, P1_val_int, P1_val_str], _B6}
    end),
    {ok, {P0_rid, P0_srv_id, P0_special}};

unpack(srv, 10120, _B0) ->
    {ok, {}};
unpack(cli, 10120, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_status, _B2} = lib_proto:read_uint8(_B1),
    {P0_base_id, _B3} = lib_proto:read_uint32(_B2),
    {P0_move_speed, _B4} = lib_proto:read_uint16(_B3),
    {P0_x, _B5} = lib_proto:read_uint16(_B4),
    {P0_y, _B6} = lib_proto:read_uint16(_B5),
    {ok, {P0_id, P0_status, P0_base_id, P0_move_speed, P0_x, P0_y}};

unpack(srv, 10121, _B0) ->
    {ok, {}};
unpack(cli, 10121, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};

unpack(srv, 10122, _B0) ->
    {ok, {}};
unpack(cli, 10122, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_x, _B2} = lib_proto:read_uint16(_B1),
    {P0_y, _B3} = lib_proto:read_uint16(_B2),
    {ok, {P0_id, P0_x, P0_y}};

unpack(srv, 10123, _B0) ->
    {ok, {}};
unpack(cli, 10123, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_id, _B2} = lib_proto:read_uint32(_B1),
    {P0_msg, _B3} = lib_proto:read_string(_B2),
    {ok, {P0_flag, P0_id, P0_msg}};

unpack(srv, 10124, _B0) ->
    {ok, {}};
unpack(cli, 10124, _B0) ->
    {P0_special_npc, _B11} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_base_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_name, _B3} = lib_proto:read_string(_B2),
        {P1_sex, _B4} = lib_proto:read_uint8(_B3),
        {P1_career, _B5} = lib_proto:read_uint8(_B4),
        {P1_looks, _B10} = lib_proto:read_array(_B5, fun(_B6) ->
            {P2_looks_type, _B7} = lib_proto:read_uint8(_B6),
            {P2_looks_id, _B8} = lib_proto:read_uint32(_B7),
            {P2_looks_value, _B9} = lib_proto:read_uint16(_B8),
            {[P2_looks_type, P2_looks_id, P2_looks_value], _B9}
        end),
        {[P1_base_id, P1_name, P1_sex, P1_career, P1_looks], _B10}
    end),
    {ok, {P0_special_npc}};

unpack(srv, 10130, _B0) ->
    {ok, {}};
unpack(cli, 10130, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_base_id, _B2} = lib_proto:read_uint32(_B1),
    {P0_type, _B3} = lib_proto:read_uint8(_B2),
    {P0_status, _B4} = lib_proto:read_uint32(_B3),
    {P0_x, _B5} = lib_proto:read_uint16(_B4),
    {P0_y, _B6} = lib_proto:read_uint16(_B5),
    {ok, {P0_id, P0_base_id, P0_type, P0_status, P0_x, P0_y}};

unpack(srv, 10131, _B0) ->
    {ok, {}};
unpack(cli, 10131, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};

unpack(srv, 10132, _B0) ->
    {ok, {}};
unpack(cli, 10132, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_status, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_id, P0_status}};

unpack(srv, 10140, _B0) ->
    {ok, {}};
unpack(cli, 10140, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_id, _B2} = lib_proto:read_uint32(_B1),
    {P0_srv_id, _B3} = lib_proto:read_string(_B2),
    {ok, {P0_type, P0_id, P0_srv_id}};

unpack(srv, 10150, _B0) ->
    {ok, {}};
unpack(cli, 10150, _B0) ->
    {P0_item_list, _B5} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_bind, _B3} = lib_proto:read_uint8(_B2),
        {P1_count, _B4} = lib_proto:read_uint8(_B3),
        {[P1_id, P1_bind, P1_count], _B4}
    end),
    {ok, {P0_item_list}};

unpack(srv, 10160, _B0) ->
    {ok, {}};
unpack(cli, 10160, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint8(_B0),
    {P0_list, _B5} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_id, _B3} = lib_proto:read_uint8(_B2),
        {P1_status, _B4} = lib_proto:read_uint8(_B3),
        {[P1_id, P1_status], _B4}
    end),
    {ok, {P0_id, P0_list}};

unpack(srv, 10161, _B0) ->
    {ok, {}};
unpack(cli, 10161, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_id}};

unpack(srv, 10162, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_id}};
unpack(cli, 10162, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_code}};

unpack(srv, 10163, _B0) ->
    {ok, {}};
unpack(cli, 10163, _B0) ->
    {P0_scene_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_scene_id}};

unpack(srv, 10164, _B0) ->
    {ok, {}};
unpack(cli, 10164, _B0) ->
    {ok, {}};

unpack(srv, 10166, _B0) ->
    {ok, {}};
unpack(cli, 10166, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint8(_B0),
    {P0_status, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_id, P0_status}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
