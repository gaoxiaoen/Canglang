%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_142).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("item.hrl").
-include("casino.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(14200), {P0_volume, P0_items}) ->
    D_a_t_a = <<?_(P0_volume, '32'):32, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_upgrade, '8'):8, ?_(P1_enchant, '8/signed'):8/signed, ?_(P1_enchant_fail, '8'):8, ?_(P1_quantity, '8'):8, ?_(P1_status, '8'):8, ?_(P1_pos, '16'):16, ?_(P1_lasttime, '32'):32, ?_(P1_durability, '32/signed'):32/signed, ?_(P1_craft, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary, ?_((length(P1_extra)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32, ?_((byte_size(P2_str)), "16"):16, ?_(P2_str, bin)/binary>> || {P2_type, P2_value, P2_str} <- P1_extra]))/binary>> || #item{id = P1_id, base_id = P1_base_id, bind = P1_bind, upgrade = P1_upgrade, enchant = P1_enchant, enchant_fail = P1_enchant_fail, quantity = P1_quantity, status = P1_status, pos = P1_pos, lasttime = P1_lasttime, durability = P1_durability, craft = P1_craft, attr = P1_attr, max_base_attr = P1_max_base_attr, extra = P1_extra} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14200:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14200), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14200:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14201), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14201:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14201), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14201:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14202), {P0_id, P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14202:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14202), {P0_id, P0_Type, P0_Pos}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_Type, '32'):32, ?_(P0_Pos, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14202:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14203), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14203:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14203), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14203:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14205), {P0_code, P0_msg, P0_type, P0_items}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_type, '8'):8, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_num, '16'):16>> || {P1_base_id, P1_bind, P1_num} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14205:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14205), {P0_type, P0_n}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_n, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14205:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14206), {P0_type, P0_all_logs}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_((length(P0_all_logs)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_type, '8'):8, ?_(P1_base_id, '32'):32, ?_(P1_num, '16'):16, ?_(P1_bind, '8'):8, ?_(P1_get_time, '32'):32>> || #casino_log{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, type = P1_type, base_id = P1_base_id, num = P1_num, bind = P1_bind, get_time = P1_get_time} <- P0_all_logs]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14206:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14206), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14206:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14210), {P0_type, P0_all_logs}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_((length(P0_all_logs)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_type, '8'):8, ?_(P1_base_id, '32'):32, ?_(P1_num, '16'):16, ?_(P1_bind, '8'):8, ?_(P1_get_time, '32'):32>> || #casino_log{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, type = P1_type, base_id = P1_base_id, num = P1_num, bind = P1_bind, get_time = P1_get_time} <- P0_all_logs]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14210:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14210), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14210:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14228), {P0_bomb_num}) ->
    D_a_t_a = <<?_(P0_bomb_num, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14228:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14228), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14228:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14229), {P0_type, P0_items}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32>> || P1_base_id <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14229:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14229), {P0_type, P0_num, P0_bomb_num, P0_is_auto}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_num, '8'):8, ?_(P0_bomb_num, '8'):8, ?_(P0_is_auto, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14229:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14230), {P0_type, P0_items}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32>> || P1_base_id <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14230:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14230), {P0_type, P0_num, P0_is_auto}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_num, '8'):8, ?_(P0_is_auto, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14230:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14231), {P0_bag_items}) ->
    D_a_t_a = <<?_((length(P0_bag_items)), "16"):16, (list_to_binary([<<?_(P1_pos, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_num, '32'):32, ?_(P1_is_new, '8'):8>> || {P1_pos, P1_base_id, P1_num, P1_is_new} <- P0_bag_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14231:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14231), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14231:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14232), {P0_items}) ->
    D_a_t_a = <<?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32>> || P1_base_id <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14232:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14232), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14232:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14233), {P0_bag_items}) ->
    D_a_t_a = <<?_((length(P0_bag_items)), "16"):16, (list_to_binary([<<?_(P1_pos, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_num, '32'):32, ?_(P1_is_new, '8'):8>> || {P1_pos, P1_base_id, P1_num, P1_is_new} <- P0_bag_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14233:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14233), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14233:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14234), {P0_pos}) ->
    D_a_t_a = <<?_(P0_pos, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14234:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14234), {P0_pos}) ->
    D_a_t_a = <<?_(P0_pos, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14234:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14235), {P0_page}) ->
    D_a_t_a = <<?_(P0_page, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14235:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14235), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14235:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14236), {P0_bag_items}) ->
    D_a_t_a = <<?_((length(P0_bag_items)), "16"):16, (list_to_binary([<<?_(P1_pos, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_num, '32'):32, ?_(P1_is_new, '8'):8>> || {P1_pos, P1_base_id, P1_num, P1_is_new} <- P0_bag_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14236:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14236), {P0_action}) ->
    D_a_t_a = <<?_(P0_action, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14236:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14237), {P0_world_lucky_list}) ->
    D_a_t_a = <<?_((length(P0_world_lucky_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_role_name)), "16"):16, ?_(P1_role_name, bin)/binary, ?_((byte_size(P1_item_name)), "16"):16, ?_(P1_item_name, bin)/binary>> || {P1_role_name, P1_item_name} <- P0_world_lucky_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14237:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14237), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14237:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14238), {P0_item_list}) ->
    D_a_t_a = <<?_((length(P0_item_list)), "16"):16, (list_to_binary([<<?_(P1_pos, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_num, '16'):16>> || {P1_pos, P1_base_id, P1_num} <- P0_item_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14238:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14238), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14238:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14239), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14239:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14239), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14239:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 14229, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_num, _B2} = lib_proto:read_uint8(_B1),
    {P0_bomb_num, _B3} = lib_proto:read_uint8(_B2),
    {P0_is_auto, _B4} = lib_proto:read_uint8(_B3),
    {ok, {P0_type, P0_num, P0_bomb_num, P0_is_auto}};
unpack(cli, 14229, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_items, _B4} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_base_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_base_id, _B3}
    end),
    {ok, {P0_type, P0_items}};

unpack(srv, 14230, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_num, _B2} = lib_proto:read_uint8(_B1),
    {P0_is_auto, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_type, P0_num, P0_is_auto}};
unpack(cli, 14230, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_items, _B4} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_base_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_base_id, _B3}
    end),
    {ok, {P0_type, P0_items}};

unpack(srv, 14231, _B0) ->
    {ok, {}};
unpack(cli, 14231, _B0) ->
    {P0_bag_items, _B6} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_pos, _B2} = lib_proto:read_uint32(_B1),
        {P1_base_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_num, _B4} = lib_proto:read_uint32(_B3),
        {P1_is_new, _B5} = lib_proto:read_uint8(_B4),
        {[P1_pos, P1_base_id, P1_num, P1_is_new], _B5}
    end),
    {ok, {P0_bag_items}};

unpack(srv, 14233, _B0) ->
    {ok, {}};
unpack(cli, 14233, _B0) ->
    {P0_bag_items, _B6} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_pos, _B2} = lib_proto:read_uint32(_B1),
        {P1_base_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_num, _B4} = lib_proto:read_uint32(_B3),
        {P1_is_new, _B5} = lib_proto:read_uint8(_B4),
        {[P1_pos, P1_base_id, P1_num, P1_is_new], _B5}
    end),
    {ok, {P0_bag_items}};

unpack(srv, 14234, _B0) ->
    {P0_pos, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_pos}};
unpack(cli, 14234, _B0) ->
    {P0_pos, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_pos}};

unpack(srv, 14235, _B0) ->
    {ok, {}};
unpack(cli, 14235, _B0) ->
    {P0_page, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_page}};

unpack(srv, 14236, _B0) ->
    {P0_action, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_action}};
unpack(cli, 14236, _B0) ->
    {P0_bag_items, _B6} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_pos, _B2} = lib_proto:read_uint32(_B1),
        {P1_base_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_num, _B4} = lib_proto:read_uint32(_B3),
        {P1_is_new, _B5} = lib_proto:read_uint8(_B4),
        {[P1_pos, P1_base_id, P1_num, P1_is_new], _B5}
    end),
    {ok, {P0_bag_items}};

unpack(srv, 14237, _B0) ->
    {ok, {}};
unpack(cli, 14237, _B0) ->
    {P0_world_lucky_list, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_role_name, _B2} = lib_proto:read_string(_B1),
        {P1_item_name, _B3} = lib_proto:read_string(_B2),
        {[P1_role_name, P1_item_name], _B3}
    end),
    {ok, {P0_world_lucky_list}};

unpack(srv, 14239, _B0) ->
    {ok, {}};
unpack(cli, 14239, _B0) ->
    {ok, {}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
