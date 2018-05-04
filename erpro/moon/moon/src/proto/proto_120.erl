%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_120).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("shop.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(12000), {P0_type, P0_items}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_price, '16'):16, ?_(P1_label, '8'):8, ?_((byte_size(P1_alias)), "16"):16, ?_(P1_alias, bin)/binary, ?_(P1_type, '8'):8>> || #shop_item{id = P1_id, base_id = P1_base_id, price = P1_price, label = P1_label, alias = P1_alias, type = P1_type} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12000:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12000), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12000:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12001), {P0_items}) ->
    D_a_t_a = <<?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_price, '16'):16, ?_(P1_label, '8'):8, ?_(P1_origin_price, '16'):16, ?_(P1_count, '16'):16, ?_(P1_type, '8'):8>> || #shop_item{id = P1_id, base_id = P1_base_id, price = P1_price, label = P1_label, origin_price = P1_origin_price, count = P1_count, type = P1_type} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12001:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12001), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12001:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12002), {P0_items}) ->
    D_a_t_a = <<?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_price, '16'):16, ?_(P1_label, '8'):8, ?_(P1_type, '8'):8>> || #shop_item{id = P1_id, base_id = P1_base_id, price = P1_price, label = P1_label, type = P1_type} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12002:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12002), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12002:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12010), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12010:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12010), {P0_id, P0_num, P0_type}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_num, '8'):8, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12010:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12011), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12011:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12011), {P0_id, P0_num, P0_type}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_num, '8'):8, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12011:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12012), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12012:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12012), {P0_id, P0_type}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12012:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12013), {P0_res}) ->
    D_a_t_a = <<?_(P0_res, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12013:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12013), {P0_opr_type, P0_id, P0_expire, P0_attr_idx, P0_discount_item_id}) ->
    D_a_t_a = <<?_(P0_opr_type, '8'):8, ?_(P0_id, '32'):32, ?_(P0_expire, '8'):8, ?_(P0_attr_idx, '8'):8, ?_(P0_discount_item_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12013:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12014), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12014:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12014), {P0_rid, P0_srv_id, P0_id, P0_expire_idx, P0_attr_idx}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_id, '32'):32, ?_(P0_expire_idx, '8'):8, ?_(P0_attr_idx, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12014:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12015), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12015:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12015), {P0_base_id, P0_num}) ->
    D_a_t_a = <<?_(P0_base_id, '32'):32, ?_(P0_num, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12015:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 12000, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_type}};
unpack(cli, 12000, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_items, _B9} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_base_id, _B4} = lib_proto:read_uint32(_B3),
        {P1_price, _B5} = lib_proto:read_uint16(_B4),
        {P1_label, _B6} = lib_proto:read_uint8(_B5),
        {P1_alias, _B7} = lib_proto:read_string(_B6),
        {P1_type, _B8} = lib_proto:read_uint8(_B7),
        {[P1_id, P1_base_id, P1_price, P1_label, P1_alias, P1_type], _B8}
    end),
    {ok, {P0_type, P0_items}};

unpack(srv, 12001, _B0) ->
    {ok, {}};
unpack(cli, 12001, _B0) ->
    {P0_items, _B9} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_base_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_price, _B4} = lib_proto:read_uint16(_B3),
        {P1_label, _B5} = lib_proto:read_uint8(_B4),
        {P1_origin_price, _B6} = lib_proto:read_uint16(_B5),
        {P1_count, _B7} = lib_proto:read_uint16(_B6),
        {P1_type, _B8} = lib_proto:read_uint8(_B7),
        {[P1_id, P1_base_id, P1_price, P1_label, P1_origin_price, P1_count, P1_type], _B8}
    end),
    {ok, {P0_items}};

unpack(srv, 12002, _B0) ->
    {ok, {}};
unpack(cli, 12002, _B0) ->
    {P0_items, _B7} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_base_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_price, _B4} = lib_proto:read_uint16(_B3),
        {P1_label, _B5} = lib_proto:read_uint8(_B4),
        {P1_type, _B6} = lib_proto:read_uint8(_B5),
        {[P1_id, P1_base_id, P1_price, P1_label, P1_type], _B6}
    end),
    {ok, {P0_items}};

unpack(srv, 12010, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_num, _B2} = lib_proto:read_uint8(_B1),
    {P0_type, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_id, P0_num, P0_type}};
unpack(cli, 12010, _B0) ->
    {ok, {}};

unpack(srv, 12011, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_num, _B2} = lib_proto:read_uint8(_B1),
    {P0_type, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_id, P0_num, P0_type}};
unpack(cli, 12011, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};

unpack(srv, 12012, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_type, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_id, P0_type}};
unpack(cli, 12012, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};

unpack(srv, 12013, _B0) ->
    {P0_opr_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_id, _B2} = lib_proto:read_uint32(_B1),
    {P0_expire, _B3} = lib_proto:read_uint8(_B2),
    {P0_attr_idx, _B4} = lib_proto:read_uint8(_B3),
    {P0_discount_item_id, _B5} = lib_proto:read_uint32(_B4),
    {ok, {P0_opr_type, P0_id, P0_expire, P0_attr_idx, P0_discount_item_id}};
unpack(cli, 12013, _B0) ->
    {P0_res, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_res}};

unpack(srv, 12015, _B0) ->
    {P0_base_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_num, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_base_id, P0_num}};
unpack(cli, 12015, _B0) ->
    {ok, {}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
