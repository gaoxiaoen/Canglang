%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_103).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("item.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(10300), {P0_volume, P0_items}) ->
    D_a_t_a = <<?_(P0_volume, '32'):32, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_quantity, '16'):16, ?_(P1_pos, '16'):16, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary, ?_((length(P1_extra)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32, ?_((byte_size(P2_str)), "16"):16, ?_(P2_str, bin)/binary>> || {P2_type, P2_value, P2_str} <- P1_extra]))/binary, ?_((length(P1_special)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32>> || {P2_type, P2_value} <- P1_special]))/binary>> || #item{id = P1_id, base_id = P1_base_id, bind = P1_bind, quantity = P1_quantity, pos = P1_pos, attr = P1_attr, max_base_attr = P1_max_base_attr, extra = P1_extra, special = P1_special} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10300:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10300), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10300:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10301), {P0_items}) ->
    D_a_t_a = <<?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_quantity, '16'):16, ?_(P1_pos, '16'):16>> || #item{id = P1_id, base_id = P1_base_id, quantity = P1_quantity, pos = P1_pos} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10301:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10301), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10301:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10305), {P0_volume, P0_items}) ->
    D_a_t_a = <<?_(P0_volume, '32'):32, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_upgrade, '8'):8, ?_(P1_enchant, '16/signed'):16/signed, ?_(P1_enchant_fail, '8'):8, ?_(P1_quantity, '16'):16, ?_(P1_status, '8'):8, ?_(P1_pos, '16'):16, ?_(P1_lasttime, '32'):32, ?_(P1_durability, '32/signed'):32/signed, ?_(P1_craft, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary, ?_((length(P1_extra)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32, ?_((byte_size(P2_str)), "16"):16, ?_(P2_str, bin)/binary>> || {P2_type, P2_value, P2_str} <- P1_extra]))/binary>> || #item{id = P1_id, base_id = P1_base_id, bind = P1_bind, upgrade = P1_upgrade, enchant = P1_enchant, enchant_fail = P1_enchant_fail, quantity = P1_quantity, status = P1_status, pos = P1_pos, lasttime = P1_lasttime, durability = P1_durability, craft = P1_craft, attr = P1_attr, max_base_attr = P1_max_base_attr, extra = P1_extra} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10305:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10305), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10305:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10306), {P0_items}) ->
    D_a_t_a = <<?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_enchant, '16/signed'):16/signed, ?_(P1_pos, '16'):16, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary, ?_((length(P1_extra)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32, ?_((byte_size(P2_str)), "16"):16, ?_(P2_str, bin)/binary>> || {P2_type, P2_value, P2_str} <- P1_extra]))/binary, ?_((length(P1_special)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32>> || {P2_type, P2_value} <- P1_special]))/binary>> || #item{id = P1_id, base_id = P1_base_id, bind = P1_bind, enchant = P1_enchant, pos = P1_pos, attr = P1_attr, max_base_attr = P1_max_base_attr, extra = P1_extra, special = P1_special} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10306:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10306), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10306:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10307), {P0_items}) ->
    D_a_t_a = <<?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_upgrade, '8'):8, ?_(P1_enchant, '16/signed'):16/signed, ?_(P1_enchant_fail, '8'):8, ?_(P1_pos, '16'):16, ?_(P1_lasttime, '32'):32, ?_(P1_durability, '32/signed'):32/signed, ?_(P1_craft, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary, ?_((length(P1_extra)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32, ?_((byte_size(P2_str)), "16"):16, ?_(P2_str, bin)/binary>> || {P2_type, P2_value, P2_str} <- P1_extra]))/binary>> || #item{id = P1_id, base_id = P1_base_id, bind = P1_bind, upgrade = P1_upgrade, enchant = P1_enchant, enchant_fail = P1_enchant_fail, pos = P1_pos, lasttime = P1_lasttime, durability = P1_durability, craft = P1_craft, attr = P1_attr, max_base_attr = P1_max_base_attr, extra = P1_extra} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10307:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10307), {P0_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10307:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10308), {P0_looks}) ->
    D_a_t_a = <<?_((length(P0_looks)), "16"):16, (list_to_binary([<<?_(P1_looks_type, '8'):8, ?_(P1_looks_id, '32'):32, ?_(P1_looks_value, '16'):16>> || {P1_looks_type, P1_looks_id, P1_looks_value} <- P0_looks]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10308:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10308), {P0_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10308:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10310), {P0_storagetype, P0_id, P0_base_id, P0_bind, P0_upgrade, P0_enchant, P0_enchant_fail, P0_quantity, P0_status, P0_pos, P0_lasttime, P0_durability, P0_craft, P0_attr, P0_max_base_attr, P0_extra, P0_special}) ->
    D_a_t_a = <<?_(P0_storagetype, '8'):8, ?_(P0_id, '32'):32, ?_(P0_base_id, '32'):32, ?_(P0_bind, '8'):8, ?_(P0_upgrade, '8'):8, ?_(P0_enchant, '16/signed'):16/signed, ?_(P0_enchant_fail, '8'):8, ?_(P0_quantity, '16'):16, ?_(P0_status, '8'):8, ?_(P0_pos, '16'):16, ?_(P0_lasttime, '32'):32, ?_(P0_durability, '32/signed'):32/signed, ?_(P0_craft, '8'):8, ?_((length(P0_attr)), "16"):16, (list_to_binary([<<?_(P1_attr_name, '32'):32, ?_(P1_flag, '32'):32, ?_(P1_value, '32'):32>> || {P1_attr_name, P1_flag, P1_value} <- P0_attr]))/binary, ?_((length(P0_max_base_attr)), "16"):16, (list_to_binary([<<?_(P1_attr_name, '32'):32, ?_(P1_flag, '32'):32, ?_(P1_value, '32'):32>> || {P1_attr_name, P1_flag, P1_value} <- P0_max_base_attr]))/binary, ?_((length(P0_extra)), "16"):16, (list_to_binary([<<?_(P1_type, '16'):16, ?_(P1_value, '32'):32, ?_((byte_size(P1_str)), "16"):16, ?_(P1_str, bin)/binary>> || {P1_type, P1_value, P1_str} <- P0_extra]))/binary, ?_((length(P0_special)), "16"):16, (list_to_binary([<<?_(P1_type, '16'):16, ?_(P1_value, '32'):32>> || {P1_type, P1_value} <- P0_special]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10310:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10310), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10310:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10311), {P0_items}) ->
    D_a_t_a = <<?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_storagetype, '8'):8, ?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_upgrade, '8'):8, ?_(P1_enchant, '16/signed'):16/signed, ?_(P1_enchant_fail, '8'):8, ?_(P1_quantity, '16'):16, ?_(P1_status, '8'):8, ?_(P1_pos, '16'):16, ?_(P1_lasttime, '32'):32, ?_(P1_durability, '32/signed'):32/signed, ?_(P1_craft, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary, ?_((length(P1_extra)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32, ?_((byte_size(P2_str)), "16"):16, ?_(P2_str, bin)/binary>> || {P2_type, P2_value, P2_str} <- P1_extra]))/binary, ?_((length(P1_special)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32>> || {P2_type, P2_value} <- P1_special]))/binary>> || [P1_storagetype, P1_id, P1_base_id, P1_bind, P1_upgrade, P1_enchant, P1_enchant_fail, P1_quantity, P1_status, P1_pos, P1_lasttime, P1_durability, P1_craft, P1_attr, P1_max_base_attr, P1_extra, P1_special] <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10311:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10311), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10311:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10312), {P0_items}) ->
    D_a_t_a = <<?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_storagetype, '8'):8, ?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_upgrade, '8'):8, ?_(P1_enchant, '16/signed'):16/signed, ?_(P1_enchant_fail, '8'):8, ?_(P1_quantity, '16'):16, ?_(P1_status, '8'):8, ?_(P1_pos, '16'):16, ?_(P1_lasttime, '32'):32, ?_(P1_durability, '32/signed'):32/signed, ?_(P1_craft, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary, ?_((length(P1_extra)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32, ?_((byte_size(P2_str)), "16"):16, ?_(P2_str, bin)/binary>> || {P2_type, P2_value, P2_str} <- P1_extra]))/binary, ?_((length(P1_special)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32>> || {P2_type, P2_value} <- P1_special]))/binary>> || [P1_storagetype, P1_id, P1_base_id, P1_bind, P1_upgrade, P1_enchant, P1_enchant_fail, P1_quantity, P1_status, P1_pos, P1_lasttime, P1_durability, P1_craft, P1_attr, P1_max_base_attr, P1_extra, P1_special] <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10312:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10312), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10312:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10313), {P0_items}) ->
    D_a_t_a = <<?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_storage, '8'):8, ?_(P1_pos, '16'):16>> || [P1_id, P1_storage, P1_pos] <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10313:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10313), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10313:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10315), {P0_success, P0_msg}) ->
    D_a_t_a = <<?_(P0_success, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10315:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10315), {P0_id, P0_quantity}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_quantity, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10315:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10320), {P0_success, P0_msg}) ->
    D_a_t_a = <<?_(P0_success, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10320:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10320), {P0_id, P0_quantity}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_quantity, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10320:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10325), {P0_success, P0_id, P0_msg}) ->
    D_a_t_a = <<?_(P0_success, '8'):8, ?_(P0_id, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10325:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10325), {P0_id, P0_storage, P0_to_pos}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_storage, '8'):8, ?_(P0_to_pos, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10325:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10326), {P0_success, P0_id, P0_msg}) ->
    D_a_t_a = <<?_(P0_success, '8'):8, ?_(P0_id, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10326:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10326), {P0_id, P0_storage, P0_to_pos}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_storage, '8'):8, ?_(P0_to_pos, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10326:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10327), {P0_success, P0_id, P0_msg}) ->
    D_a_t_a = <<?_(P0_success, '8'):8, ?_(P0_id, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10327:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10327), {P0_id, P0_storage, P0_to_pos}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_storage, '8'):8, ?_(P0_to_pos, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10327:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10328), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10328:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10328), {P0_storagetype, P0_idlist}) ->
    D_a_t_a = <<?_(P0_storagetype, '8'):8, ?_((length(P0_idlist)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32>> || P1_id <- P0_idlist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10328:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10330), {P0_id, P0_storagetype, P0_success, P0_msg}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_storagetype, '8'):8, ?_(P0_success, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10330:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10330), {P0_id, P0_storage}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_storage, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10330:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10331), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10331:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10331), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10331:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10332), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10332:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10332), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10332:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10333), {P0_flag, P0_volume, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_(P0_volume, '32'):32, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10333:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10333), {P0_new_vol}) ->
    D_a_t_a = <<?_(P0_new_vol, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10333:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10340), {P0_result, P0_hp, P0_hp_max, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_hp, '32'):32, ?_(P0_hp_max, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10340:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10340), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10340:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10341), {P0_result, P0_mp, P0_mp_max, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_mp, '32'):32, ?_(P0_mp_max, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10341:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10341), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10341:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10342), {P0_dress}) ->
    D_a_t_a = <<?_((length(P0_dress)), "16"):16, (list_to_binary([<<?_(P1_flag, '8'):8, ?_(P1_base_id, '32'):32, ?_(P1_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_durability, '32/signed'):32/signed, ?_(P1_expire, '32/signed'):32/signed, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary>> || {P1_flag, P1_base_id, P1_id, P1_bind, P1_durability, P1_expire, P1_attr} <- P0_dress]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10342:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10342), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10342:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10343), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10343:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10343), {P0_dress}) ->
    D_a_t_a = <<?_((length(P0_dress)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32>> || P1_id <- P0_dress]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10343:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10344), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10344:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10344), {P0_base_id1, P0_base_id2}) ->
    D_a_t_a = <<?_(P0_base_id1, '32'):32, ?_(P0_base_id2, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10344:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10345), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10345:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10345), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10345:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10346), {P0_armor_lock, P0_armor_suit, P0_jewelry_lock, P0_jewelry_suit}) ->
    D_a_t_a = <<?_(P0_armor_lock, '8'):8, ?_(P0_armor_suit, '32'):32, ?_(P0_jewelry_lock, '8'):8, ?_(P0_jewelry_suit, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10346:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10346), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10346:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10347), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10347:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10347), {P0_mode, P0_type}) ->
    D_a_t_a = <<?_(P0_mode, '8'):8, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10347:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10348), {P0_flag, P0_type, P0_map, P0_x, P0_y}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_(P0_type, '8'):8, ?_(P0_map, '32'):32, ?_(P0_x, '16'):16, ?_(P0_y, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10348:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10348), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10348:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10349), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10349:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10349), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10349:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10350), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10350:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10350), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10350:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10351), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10351:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10351), {P0_type, P0_base_id}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_base_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10351:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10352), {P0_luck_val}) ->
    D_a_t_a = <<?_(P0_luck_val, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10352:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10352), {P0_base_id}) ->
    D_a_t_a = <<?_(P0_base_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10352:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10353), {P0_max_luck_val, P0_item_info, P0_best_item_info}) ->
    D_a_t_a = <<?_(P0_max_luck_val, '32'):32, ?_((length(P0_item_info)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_num, '32'):32>> || {P1_base_id, P1_bind, P1_num} <- P0_item_info]))/binary, ?_((length(P0_best_item_info)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_num, '32'):32>> || {P1_base_id, P1_bind, P1_num} <- P0_best_item_info]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10353:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10353), {P0_base_id}) ->
    D_a_t_a = <<?_(P0_base_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10353:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10354), {P0_itemIds}) ->
    D_a_t_a = <<?_((length(P0_itemIds)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_num, '32'):32>> || {P1_base_id, P1_bind, P1_num} <- P0_itemIds]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10354:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10354), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10354:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10355), {P0_success, P0_msg}) ->
    D_a_t_a = <<?_(P0_success, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10355:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10355), {P0_id, P0_item_num}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_item_num, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10355:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10356), {P0_success, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_success, '8'):8, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10356:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10356), {P0_id, P0_num}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_num, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10356:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10358), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10358:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10358), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10358:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10359), {P0_guagua_baseid, P0_id, P0_bind, P0_num}) ->
    D_a_t_a = <<?_(P0_guagua_baseid, '32'):32, ?_(P0_id, '32'):32, ?_(P0_bind, '8'):8, ?_(P0_num, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10359:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10359), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10359:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10360), {P0_success, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_success, '8'):8, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10360:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10360), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10360:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10361), {P0_success, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_success, '8'):8, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10361:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10361), {P0_num}) ->
    D_a_t_a = <<?_(P0_num, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10361:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 10300, _B0) ->
    {ok, {}};
unpack(cli, 10300, _B0) ->
    {P0_volume, _B1} = lib_proto:read_uint32(_B0),
    {P0_items, _B27} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_base_id, _B4} = lib_proto:read_uint32(_B3),
        {P1_bind, _B5} = lib_proto:read_uint8(_B4),
        {P1_quantity, _B6} = lib_proto:read_uint16(_B5),
        {P1_pos, _B7} = lib_proto:read_uint16(_B6),
        {P1_attr, _B12} = lib_proto:read_array(_B7, fun(_B8) ->
            {P2_attr_name, _B9} = lib_proto:read_uint32(_B8),
            {P2_flag, _B10} = lib_proto:read_uint32(_B9),
            {P2_value, _B11} = lib_proto:read_uint32(_B10),
            {[P2_attr_name, P2_flag, P2_value], _B11}
        end),
        {P1_max_base_attr, _B17} = lib_proto:read_array(_B12, fun(_B13) ->
            {P2_attr_name, _B14} = lib_proto:read_uint32(_B13),
            {P2_flag, _B15} = lib_proto:read_uint32(_B14),
            {P2_value, _B16} = lib_proto:read_uint32(_B15),
            {[P2_attr_name, P2_flag, P2_value], _B16}
        end),
        {P1_extra, _B22} = lib_proto:read_array(_B17, fun(_B18) ->
            {P2_type, _B19} = lib_proto:read_uint16(_B18),
            {P2_value, _B20} = lib_proto:read_uint32(_B19),
            {P2_str, _B21} = lib_proto:read_string(_B20),
            {[P2_type, P2_value, P2_str], _B21}
        end),
        {P1_special, _B26} = lib_proto:read_array(_B22, fun(_B23) ->
            {P2_type, _B24} = lib_proto:read_uint16(_B23),
            {P2_value, _B25} = lib_proto:read_uint32(_B24),
            {[P2_type, P2_value], _B25}
        end),
        {[P1_id, P1_base_id, P1_bind, P1_quantity, P1_pos, P1_attr, P1_max_base_attr, P1_extra, P1_special], _B26}
    end),
    {ok, {P0_volume, P0_items}};

unpack(srv, 10306, _B0) ->
    {ok, {}};
unpack(cli, 10306, _B0) ->
    {P0_items, _B26} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_base_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_bind, _B4} = lib_proto:read_uint8(_B3),
        {P1_enchant, _B5} = lib_proto:read_int16(_B4),
        {P1_pos, _B6} = lib_proto:read_uint16(_B5),
        {P1_attr, _B11} = lib_proto:read_array(_B6, fun(_B7) ->
            {P2_attr_name, _B8} = lib_proto:read_uint32(_B7),
            {P2_flag, _B9} = lib_proto:read_uint32(_B8),
            {P2_value, _B10} = lib_proto:read_uint32(_B9),
            {[P2_attr_name, P2_flag, P2_value], _B10}
        end),
        {P1_max_base_attr, _B16} = lib_proto:read_array(_B11, fun(_B12) ->
            {P2_attr_name, _B13} = lib_proto:read_uint32(_B12),
            {P2_flag, _B14} = lib_proto:read_uint32(_B13),
            {P2_value, _B15} = lib_proto:read_uint32(_B14),
            {[P2_attr_name, P2_flag, P2_value], _B15}
        end),
        {P1_extra, _B21} = lib_proto:read_array(_B16, fun(_B17) ->
            {P2_type, _B18} = lib_proto:read_uint16(_B17),
            {P2_value, _B19} = lib_proto:read_uint32(_B18),
            {P2_str, _B20} = lib_proto:read_string(_B19),
            {[P2_type, P2_value, P2_str], _B20}
        end),
        {P1_special, _B25} = lib_proto:read_array(_B21, fun(_B22) ->
            {P2_type, _B23} = lib_proto:read_uint16(_B22),
            {P2_value, _B24} = lib_proto:read_uint32(_B23),
            {[P2_type, P2_value], _B24}
        end),
        {[P1_id, P1_base_id, P1_bind, P1_enchant, P1_pos, P1_attr, P1_max_base_attr, P1_extra, P1_special], _B25}
    end),
    {ok, {P0_items}};

unpack(srv, 10307, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_id, P0_srv_id}};
unpack(cli, 10307, _B0) ->
    {P0_items, _B27} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_base_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_bind, _B4} = lib_proto:read_uint8(_B3),
        {P1_upgrade, _B5} = lib_proto:read_uint8(_B4),
        {P1_enchant, _B6} = lib_proto:read_int16(_B5),
        {P1_enchant_fail, _B7} = lib_proto:read_uint8(_B6),
        {P1_pos, _B8} = lib_proto:read_uint16(_B7),
        {P1_lasttime, _B9} = lib_proto:read_uint32(_B8),
        {P1_durability, _B10} = lib_proto:read_int32(_B9),
        {P1_craft, _B11} = lib_proto:read_uint8(_B10),
        {P1_attr, _B16} = lib_proto:read_array(_B11, fun(_B12) ->
            {P2_attr_name, _B13} = lib_proto:read_uint32(_B12),
            {P2_flag, _B14} = lib_proto:read_uint32(_B13),
            {P2_value, _B15} = lib_proto:read_uint32(_B14),
            {[P2_attr_name, P2_flag, P2_value], _B15}
        end),
        {P1_max_base_attr, _B21} = lib_proto:read_array(_B16, fun(_B17) ->
            {P2_attr_name, _B18} = lib_proto:read_uint32(_B17),
            {P2_flag, _B19} = lib_proto:read_uint32(_B18),
            {P2_value, _B20} = lib_proto:read_uint32(_B19),
            {[P2_attr_name, P2_flag, P2_value], _B20}
        end),
        {P1_extra, _B26} = lib_proto:read_array(_B21, fun(_B22) ->
            {P2_type, _B23} = lib_proto:read_uint16(_B22),
            {P2_value, _B24} = lib_proto:read_uint32(_B23),
            {P2_str, _B25} = lib_proto:read_string(_B24),
            {[P2_type, P2_value, P2_str], _B25}
        end),
        {[P1_id, P1_base_id, P1_bind, P1_upgrade, P1_enchant, P1_enchant_fail, P1_pos, P1_lasttime, P1_durability, P1_craft, P1_attr, P1_max_base_attr, P1_extra], _B26}
    end),
    {ok, {P0_items}};

unpack(srv, 10308, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_id, P0_srv_id}};
unpack(cli, 10308, _B0) ->
    {P0_looks, _B5} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_looks_type, _B2} = lib_proto:read_uint8(_B1),
        {P1_looks_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_looks_value, _B4} = lib_proto:read_uint16(_B3),
        {[P1_looks_type, P1_looks_id, P1_looks_value], _B4}
    end),
    {ok, {P0_looks}};

unpack(srv, 10310, _B0) ->
    {ok, {}};
unpack(cli, 10310, _B0) ->
    {P0_storagetype, _B1} = lib_proto:read_uint8(_B0),
    {P0_id, _B2} = lib_proto:read_uint32(_B1),
    {P0_base_id, _B3} = lib_proto:read_uint32(_B2),
    {P0_bind, _B4} = lib_proto:read_uint8(_B3),
    {P0_upgrade, _B5} = lib_proto:read_uint8(_B4),
    {P0_enchant, _B6} = lib_proto:read_int16(_B5),
    {P0_enchant_fail, _B7} = lib_proto:read_uint8(_B6),
    {P0_quantity, _B8} = lib_proto:read_uint16(_B7),
    {P0_status, _B9} = lib_proto:read_uint8(_B8),
    {P0_pos, _B10} = lib_proto:read_uint16(_B9),
    {P0_lasttime, _B11} = lib_proto:read_uint32(_B10),
    {P0_durability, _B12} = lib_proto:read_int32(_B11),
    {P0_craft, _B13} = lib_proto:read_uint8(_B12),
    {P0_attr, _B18} = lib_proto:read_array(_B13, fun(_B14) ->
        {P1_attr_name, _B15} = lib_proto:read_uint32(_B14),
        {P1_flag, _B16} = lib_proto:read_uint32(_B15),
        {P1_value, _B17} = lib_proto:read_uint32(_B16),
        {[P1_attr_name, P1_flag, P1_value], _B17}
    end),
    {P0_max_base_attr, _B23} = lib_proto:read_array(_B18, fun(_B19) ->
        {P1_attr_name, _B20} = lib_proto:read_uint32(_B19),
        {P1_flag, _B21} = lib_proto:read_uint32(_B20),
        {P1_value, _B22} = lib_proto:read_uint32(_B21),
        {[P1_attr_name, P1_flag, P1_value], _B22}
    end),
    {P0_extra, _B28} = lib_proto:read_array(_B23, fun(_B24) ->
        {P1_type, _B25} = lib_proto:read_uint16(_B24),
        {P1_value, _B26} = lib_proto:read_uint32(_B25),
        {P1_str, _B27} = lib_proto:read_string(_B26),
        {[P1_type, P1_value, P1_str], _B27}
    end),
    {P0_special, _B32} = lib_proto:read_array(_B28, fun(_B29) ->
        {P1_type, _B30} = lib_proto:read_uint16(_B29),
        {P1_value, _B31} = lib_proto:read_uint32(_B30),
        {[P1_type, P1_value], _B31}
    end),
    {ok, {P0_storagetype, P0_id, P0_base_id, P0_bind, P0_upgrade, P0_enchant, P0_enchant_fail, P0_quantity, P0_status, P0_pos, P0_lasttime, P0_durability, P0_craft, P0_attr, P0_max_base_attr, P0_extra, P0_special}};

unpack(srv, 10311, _B0) ->
    {ok, {}};
unpack(cli, 10311, _B0) ->
    {P0_items, _B34} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_storagetype, _B2} = lib_proto:read_uint8(_B1),
        {P1_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_base_id, _B4} = lib_proto:read_uint32(_B3),
        {P1_bind, _B5} = lib_proto:read_uint8(_B4),
        {P1_upgrade, _B6} = lib_proto:read_uint8(_B5),
        {P1_enchant, _B7} = lib_proto:read_int16(_B6),
        {P1_enchant_fail, _B8} = lib_proto:read_uint8(_B7),
        {P1_quantity, _B9} = lib_proto:read_uint16(_B8),
        {P1_status, _B10} = lib_proto:read_uint8(_B9),
        {P1_pos, _B11} = lib_proto:read_uint16(_B10),
        {P1_lasttime, _B12} = lib_proto:read_uint32(_B11),
        {P1_durability, _B13} = lib_proto:read_int32(_B12),
        {P1_craft, _B14} = lib_proto:read_uint8(_B13),
        {P1_attr, _B19} = lib_proto:read_array(_B14, fun(_B15) ->
            {P2_attr_name, _B16} = lib_proto:read_uint32(_B15),
            {P2_flag, _B17} = lib_proto:read_uint32(_B16),
            {P2_value, _B18} = lib_proto:read_uint32(_B17),
            {[P2_attr_name, P2_flag, P2_value], _B18}
        end),
        {P1_max_base_attr, _B24} = lib_proto:read_array(_B19, fun(_B20) ->
            {P2_attr_name, _B21} = lib_proto:read_uint32(_B20),
            {P2_flag, _B22} = lib_proto:read_uint32(_B21),
            {P2_value, _B23} = lib_proto:read_uint32(_B22),
            {[P2_attr_name, P2_flag, P2_value], _B23}
        end),
        {P1_extra, _B29} = lib_proto:read_array(_B24, fun(_B25) ->
            {P2_type, _B26} = lib_proto:read_uint16(_B25),
            {P2_value, _B27} = lib_proto:read_uint32(_B26),
            {P2_str, _B28} = lib_proto:read_string(_B27),
            {[P2_type, P2_value, P2_str], _B28}
        end),
        {P1_special, _B33} = lib_proto:read_array(_B29, fun(_B30) ->
            {P2_type, _B31} = lib_proto:read_uint16(_B30),
            {P2_value, _B32} = lib_proto:read_uint32(_B31),
            {[P2_type, P2_value], _B32}
        end),
        {[P1_storagetype, P1_id, P1_base_id, P1_bind, P1_upgrade, P1_enchant, P1_enchant_fail, P1_quantity, P1_status, P1_pos, P1_lasttime, P1_durability, P1_craft, P1_attr, P1_max_base_attr, P1_extra, P1_special], _B33}
    end),
    {ok, {P0_items}};

unpack(srv, 10312, _B0) ->
    {ok, {}};
unpack(cli, 10312, _B0) ->
    {P0_items, _B34} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_storagetype, _B2} = lib_proto:read_uint8(_B1),
        {P1_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_base_id, _B4} = lib_proto:read_uint32(_B3),
        {P1_bind, _B5} = lib_proto:read_uint8(_B4),
        {P1_upgrade, _B6} = lib_proto:read_uint8(_B5),
        {P1_enchant, _B7} = lib_proto:read_int16(_B6),
        {P1_enchant_fail, _B8} = lib_proto:read_uint8(_B7),
        {P1_quantity, _B9} = lib_proto:read_uint16(_B8),
        {P1_status, _B10} = lib_proto:read_uint8(_B9),
        {P1_pos, _B11} = lib_proto:read_uint16(_B10),
        {P1_lasttime, _B12} = lib_proto:read_uint32(_B11),
        {P1_durability, _B13} = lib_proto:read_int32(_B12),
        {P1_craft, _B14} = lib_proto:read_uint8(_B13),
        {P1_attr, _B19} = lib_proto:read_array(_B14, fun(_B15) ->
            {P2_attr_name, _B16} = lib_proto:read_uint32(_B15),
            {P2_flag, _B17} = lib_proto:read_uint32(_B16),
            {P2_value, _B18} = lib_proto:read_uint32(_B17),
            {[P2_attr_name, P2_flag, P2_value], _B18}
        end),
        {P1_max_base_attr, _B24} = lib_proto:read_array(_B19, fun(_B20) ->
            {P2_attr_name, _B21} = lib_proto:read_uint32(_B20),
            {P2_flag, _B22} = lib_proto:read_uint32(_B21),
            {P2_value, _B23} = lib_proto:read_uint32(_B22),
            {[P2_attr_name, P2_flag, P2_value], _B23}
        end),
        {P1_extra, _B29} = lib_proto:read_array(_B24, fun(_B25) ->
            {P2_type, _B26} = lib_proto:read_uint16(_B25),
            {P2_value, _B27} = lib_proto:read_uint32(_B26),
            {P2_str, _B28} = lib_proto:read_string(_B27),
            {[P2_type, P2_value, P2_str], _B28}
        end),
        {P1_special, _B33} = lib_proto:read_array(_B29, fun(_B30) ->
            {P2_type, _B31} = lib_proto:read_uint16(_B30),
            {P2_value, _B32} = lib_proto:read_uint32(_B31),
            {[P2_type, P2_value], _B32}
        end),
        {[P1_storagetype, P1_id, P1_base_id, P1_bind, P1_upgrade, P1_enchant, P1_enchant_fail, P1_quantity, P1_status, P1_pos, P1_lasttime, P1_durability, P1_craft, P1_attr, P1_max_base_attr, P1_extra, P1_special], _B33}
    end),
    {ok, {P0_items}};

unpack(srv, 10313, _B0) ->
    {ok, {}};
unpack(cli, 10313, _B0) ->
    {P0_items, _B5} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_storage, _B3} = lib_proto:read_uint8(_B2),
        {P1_pos, _B4} = lib_proto:read_uint16(_B3),
        {[P1_id, P1_storage, P1_pos], _B4}
    end),
    {ok, {P0_items}};

unpack(srv, 10315, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_quantity, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_id, P0_quantity}};
unpack(cli, 10315, _B0) ->
    {P0_success, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_success, P0_msg}};

unpack(srv, 10320, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_quantity, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_id, P0_quantity}};
unpack(cli, 10320, _B0) ->
    {P0_success, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_success, P0_msg}};

unpack(srv, 10325, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_storage, _B2} = lib_proto:read_uint8(_B1),
    {P0_to_pos, _B3} = lib_proto:read_uint16(_B2),
    {ok, {P0_id, P0_storage, P0_to_pos}};
unpack(cli, 10325, _B0) ->
    {P0_success, _B1} = lib_proto:read_uint8(_B0),
    {P0_id, _B2} = lib_proto:read_uint32(_B1),
    {P0_msg, _B3} = lib_proto:read_string(_B2),
    {ok, {P0_success, P0_id, P0_msg}};

unpack(srv, 10330, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_storage, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_id, P0_storage}};
unpack(cli, 10330, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_storagetype, _B2} = lib_proto:read_uint8(_B1),
    {P0_success, _B3} = lib_proto:read_uint8(_B2),
    {P0_msg, _B4} = lib_proto:read_string(_B3),
    {ok, {P0_id, P0_storagetype, P0_success, P0_msg}};

unpack(srv, 10331, _B0) ->
    {ok, {}};
unpack(cli, 10331, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 10332, _B0) ->
    {ok, {}};
unpack(cli, 10332, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 10333, _B0) ->
    {P0_new_vol, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_new_vol}};
unpack(cli, 10333, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_volume, _B2} = lib_proto:read_uint32(_B1),
    {P0_msg, _B3} = lib_proto:read_uint16(_B2),
    {ok, {P0_flag, P0_volume, P0_msg}};

unpack(srv, 10342, _B0) ->
    {ok, {}};
unpack(cli, 10342, _B0) ->
    {P0_dress, _B13} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_flag, _B2} = lib_proto:read_uint8(_B1),
        {P1_base_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_id, _B4} = lib_proto:read_uint32(_B3),
        {P1_bind, _B5} = lib_proto:read_uint8(_B4),
        {P1_durability, _B6} = lib_proto:read_int32(_B5),
        {P1_expire, _B7} = lib_proto:read_int32(_B6),
        {P1_attr, _B12} = lib_proto:read_array(_B7, fun(_B8) ->
            {P2_attr_name, _B9} = lib_proto:read_uint32(_B8),
            {P2_flag, _B10} = lib_proto:read_uint32(_B9),
            {P2_value, _B11} = lib_proto:read_uint32(_B10),
            {[P2_attr_name, P2_flag, P2_value], _B11}
        end),
        {[P1_flag, P1_base_id, P1_id, P1_bind, P1_durability, P1_expire, P1_attr], _B12}
    end),
    {ok, {P0_dress}};

unpack(srv, 10343, _B0) ->
    {P0_dress, _B3} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_id, _B2}
    end),
    {ok, {P0_dress}};
unpack(cli, 10343, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 10345, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 10345, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 10353, _B0) ->
    {P0_base_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_base_id}};
unpack(cli, 10353, _B0) ->
    {P0_max_luck_val, _B1} = lib_proto:read_uint32(_B0),
    {P0_item_info, _B6} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_base_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_bind, _B4} = lib_proto:read_uint8(_B3),
        {P1_num, _B5} = lib_proto:read_uint32(_B4),
        {[P1_base_id, P1_bind, P1_num], _B5}
    end),
    {P0_best_item_info, _B11} = lib_proto:read_array(_B6, fun(_B7) ->
        {P1_base_id, _B8} = lib_proto:read_uint32(_B7),
        {P1_bind, _B9} = lib_proto:read_uint8(_B8),
        {P1_num, _B10} = lib_proto:read_uint32(_B9),
        {[P1_base_id, P1_bind, P1_num], _B10}
    end),
    {ok, {P0_max_luck_val, P0_item_info, P0_best_item_info}};

unpack(srv, 10354, _B0) ->
    {ok, {}};
unpack(cli, 10354, _B0) ->
    {P0_itemIds, _B5} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_base_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_bind, _B3} = lib_proto:read_uint8(_B2),
        {P1_num, _B4} = lib_proto:read_uint32(_B3),
        {[P1_base_id, P1_bind, P1_num], _B4}
    end),
    {ok, {P0_itemIds}};

unpack(srv, 10355, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_item_num, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_id, P0_item_num}};
unpack(cli, 10355, _B0) ->
    {P0_success, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_success, P0_msg}};

unpack(srv, 10356, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_num, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_id, P0_num}};
unpack(cli, 10356, _B0) ->
    {P0_success, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_success, P0_msg_id}};

unpack(srv, 10358, _B0) ->
    {ok, {}};
unpack(cli, 10358, _B0) ->
    {ok, {}};

unpack(srv, 10359, _B0) ->
    {ok, {}};
unpack(cli, 10359, _B0) ->
    {P0_guagua_baseid, _B1} = lib_proto:read_uint32(_B0),
    {P0_id, _B2} = lib_proto:read_uint32(_B1),
    {P0_bind, _B3} = lib_proto:read_uint8(_B2),
    {P0_num, _B4} = lib_proto:read_uint16(_B3),
    {ok, {P0_guagua_baseid, P0_id, P0_bind, P0_num}};

unpack(srv, 10360, _B0) ->
    {ok, {}};
unpack(cli, 10360, _B0) ->
    {P0_success, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_success, P0_msg_id}};

unpack(srv, 10361, _B0) ->
    {P0_num, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_num}};
unpack(cli, 10361, _B0) ->
    {P0_success, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_success, P0_msg_id}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
