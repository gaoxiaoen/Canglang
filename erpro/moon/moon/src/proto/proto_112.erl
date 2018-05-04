%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_112).
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

pack(srv, ?_CMD(11200), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11200:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11200), {P0_to_rid, P0_to_srv_id}) ->
    D_a_t_a = <<?_(P0_to_rid, '32'):32, ?_((byte_size(P0_to_srv_id)), "16"):16, ?_(P0_to_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11200:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11201), {P0_from_rid, P0_from_srv_id, P0_from_name}) ->
    D_a_t_a = <<?_(P0_from_rid, '32'):32, ?_((byte_size(P0_from_srv_id)), "16"):16, ?_(P0_from_srv_id, bin)/binary, ?_((byte_size(P0_from_name)), "16"):16, ?_(P0_from_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11201:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11201), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11201:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11205), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11205:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11205), {P0_from_rid, P0_from_srv_id}) ->
    D_a_t_a = <<?_(P0_from_rid, '32'):32, ?_((byte_size(P0_from_srv_id)), "16"):16, ?_(P0_from_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11205:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11206), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11206:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11206), {P0_from_rid, P0_from_srv_id}) ->
    D_a_t_a = <<?_(P0_from_rid, '32'):32, ?_((byte_size(P0_from_srv_id)), "16"):16, ?_(P0_from_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11206:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11207), {P0_name}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11207:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11207), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11207:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11210), {P0_from_lock, P0_from_rid, P0_from_srv_id, P0_from_name, P0_from_coin, P0_from_gold, P0_from_items, P0_to_lock, P0_to_rid, P0_to_srv_id, P0_to_name, P0_to_coin, P0_to_gold, P0_to_items}) ->
    D_a_t_a = <<?_(P0_from_lock, '8'):8, ?_(P0_from_rid, '32'):32, ?_((byte_size(P0_from_srv_id)), "16"):16, ?_(P0_from_srv_id, bin)/binary, ?_((byte_size(P0_from_name)), "16"):16, ?_(P0_from_name, bin)/binary, ?_(P0_from_coin, '32'):32, ?_(P0_from_gold, '32'):32, ?_((length(P0_from_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_upgrade, '8'):8, ?_(P1_enchant, '8/signed'):8/signed, ?_(P1_enchant_fail, '8'):8, ?_(P1_quantity, '8'):8, ?_(P1_lasttime, '32'):32, ?_(P1_durability, '32/signed'):32/signed, ?_(P1_craft, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary, ?_((length(P1_extra)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32, ?_((byte_size(P2_str)), "16"):16, ?_(P2_str, bin)/binary>> || {P2_type, P2_value, P2_str} <- P1_extra]))/binary>> || #item{id = P1_id, base_id = P1_base_id, bind = P1_bind, upgrade = P1_upgrade, enchant = P1_enchant, enchant_fail = P1_enchant_fail, quantity = P1_quantity, lasttime = P1_lasttime, durability = P1_durability, craft = P1_craft, attr = P1_attr, max_base_attr = P1_max_base_attr, extra = P1_extra} <- P0_from_items]))/binary, ?_(P0_to_lock, '8'):8, ?_(P0_to_rid, '32'):32, ?_((byte_size(P0_to_srv_id)), "16"):16, ?_(P0_to_srv_id, bin)/binary, ?_((byte_size(P0_to_name)), "16"):16, ?_(P0_to_name, bin)/binary, ?_(P0_to_coin, '32'):32, ?_(P0_to_gold, '32'):32, ?_((length(P0_to_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_upgrade, '8'):8, ?_(P1_enchant, '8/signed'):8/signed, ?_(P1_enchant_fail, '8'):8, ?_(P1_quantity, '8'):8, ?_(P1_lasttime, '32'):32, ?_(P1_durability, '32/signed'):32/signed, ?_(P1_craft, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary, ?_((length(P1_extra)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32, ?_((byte_size(P2_str)), "16"):16, ?_(P2_str, bin)/binary>> || {P2_type, P2_value, P2_str} <- P1_extra]))/binary>> || #item{id = P1_id, base_id = P1_base_id, bind = P1_bind, upgrade = P1_upgrade, enchant = P1_enchant, enchant_fail = P1_enchant_fail, quantity = P1_quantity, lasttime = P1_lasttime, durability = P1_durability, craft = P1_craft, attr = P1_attr, max_base_attr = P1_max_base_attr, extra = P1_extra} <- P0_to_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11210:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11210), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11210:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11220), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11220:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11220), {P0_num}) ->
    D_a_t_a = <<?_(P0_num, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11220:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11221), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11221:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11221), {P0_item_id}) ->
    D_a_t_a = <<?_(P0_item_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11221:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11222), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11222:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11222), {P0_item_id}) ->
    D_a_t_a = <<?_(P0_item_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11222:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11223), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11223:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11223), {P0_num}) ->
    D_a_t_a = <<?_(P0_num, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11223:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11230), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11230:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11230), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11230:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11231), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11231:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11231), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11231:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11232), {P0_name}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11232:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11232), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11232:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
