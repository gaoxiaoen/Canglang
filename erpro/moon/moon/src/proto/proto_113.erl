%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_113).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("market.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(11300), {P0_total_page, P0_sales}) ->
    D_a_t_a = <<?_(P0_total_page, '32'):32, ?_((length(P0_sales)), "16"):16, (list_to_binary([<<?_(P1_sale_id, '32'):32, ?_(P1_item_id, '32'):32, ?_(P1_item_base_id, '32'):32, ?_((byte_size(P1_item_name)), "16"):16, ?_(P1_item_name, bin)/binary, ?_(P1_type, '8/signed'):8/signed, ?_(P1_begin_time, '32/signed'):32/signed, ?_(P1_end_time, '32/signed'):32/signed, ?_(P1_assets_type, '8/signed'):8/signed, ?_(P1_price, '32/signed'):32/signed, ?_(P1_price_tax, '32/signed'):32/signed, ?_(P1_lev, '8'):8, ?_(P1_career, '8'):8, ?_(P1_bind, '8'):8, ?_(P1_quality, '8'):8, ?_(P1_upgrade, '8'):8, ?_(P1_enchant, '8/signed'):8/signed, ?_(P1_enchant_fail, '8'):8, ?_(P1_quantity, '32'):32, ?_(P1_lasttime, '32'):32, ?_(P1_durability, '32/signed'):32/signed, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary>> || #market_sale{sale_id = P1_sale_id, item_id = P1_item_id, item_base_id = P1_item_base_id, item_name = P1_item_name, type = P1_type, begin_time = P1_begin_time, end_time = P1_end_time, assets_type = P1_assets_type, price = P1_price, price_tax = P1_price_tax, lev = P1_lev, career = P1_career, bind = P1_bind, quality = P1_quality, upgrade = P1_upgrade, enchant = P1_enchant, enchant_fail = P1_enchant_fail, quantity = P1_quantity, lasttime = P1_lasttime, durability = P1_durability, attr = P1_attr, max_base_attr = P1_max_base_attr} <- P0_sales]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11300:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11300), {P0_type, P0_item_name, P0_min_lev, P0_max_lev, P0_quality, P0_career, P0_page_index, P0_sort_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_((byte_size(P0_item_name)), "16"):16, ?_(P0_item_name, bin)/binary, ?_(P0_min_lev, '8'):8, ?_(P0_max_lev, '8'):8, ?_(P0_quality, '8'):8, ?_(P0_career, '8'):8, ?_(P0_page_index, '8'):8, ?_(P0_sort_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11300:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11301), {P0_sales}) ->
    D_a_t_a = <<?_((length(P0_sales)), "16"):16, (list_to_binary([<<?_(P1_sale_id, '32'):32, ?_(P1_item_id, '32'):32, ?_(P1_item_base_id, '32'):32, ?_((byte_size(P1_item_name)), "16"):16, ?_(P1_item_name, bin)/binary, ?_(P1_type, '8/signed'):8/signed, ?_(P1_begin_time, '32/signed'):32/signed, ?_(P1_end_time, '32/signed'):32/signed, ?_(P1_assets_type, '8/signed'):8/signed, ?_(P1_price, '32/signed'):32/signed, ?_(P1_price_tax, '32/signed'):32/signed, ?_(P1_lev, '8'):8, ?_(P1_career, '8'):8, ?_(P1_bind, '8'):8, ?_(P1_quality, '8'):8, ?_(P1_upgrade, '8'):8, ?_(P1_enchant, '8/signed'):8/signed, ?_(P1_enchant_fail, '8'):8, ?_(P1_quantity, '32'):32, ?_(P1_lasttime, '32'):32, ?_(P1_durability, '32/signed'):32/signed, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary>> || #market_sale{sale_id = P1_sale_id, item_id = P1_item_id, item_base_id = P1_item_base_id, item_name = P1_item_name, type = P1_type, begin_time = P1_begin_time, end_time = P1_end_time, assets_type = P1_assets_type, price = P1_price, price_tax = P1_price_tax, lev = P1_lev, career = P1_career, bind = P1_bind, quality = P1_quality, upgrade = P1_upgrade, enchant = P1_enchant, enchant_fail = P1_enchant_fail, quantity = P1_quantity, lasttime = P1_lasttime, durability = P1_durability, attr = P1_attr, max_base_attr = P1_max_base_attr} <- P0_sales]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11301:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11301), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11301:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11302), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11302:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11302), {P0_item_id, P0_assets_type, P0_price, P0_time, P0_notice}) ->
    D_a_t_a = <<?_(P0_item_id, '32'):32, ?_(P0_assets_type, '8'):8, ?_(P0_price, '32'):32, ?_(P0_time, '32'):32, ?_(P0_notice, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11302:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11303), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11303:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11303), {P0_sale_id}) ->
    D_a_t_a = <<?_(P0_sale_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11303:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11304), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11304:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11304), {P0_gold_num, P0_assets_type, P0_price, P0_time, P0_notice}) ->
    D_a_t_a = <<?_(P0_gold_num, '32'):32, ?_(P0_assets_type, '32'):32, ?_(P0_price, '32'):32, ?_(P0_time, '32'):32, ?_(P0_notice, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11304:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11305), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11305:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11305), {P0_coin_num, P0_assets_type, P0_price, P0_time, P0_notice}) ->
    D_a_t_a = <<?_(P0_coin_num, '32'):32, ?_(P0_assets_type, '32'):32, ?_(P0_price, '32'):32, ?_(P0_time, '32'):32, ?_(P0_notice, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11305:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11306), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11306:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11306), {P0_sale_id}) ->
    D_a_t_a = <<?_(P0_sale_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11306:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11307), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11307:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11307), {P0_sale_id}) ->
    D_a_t_a = <<?_(P0_sale_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11307:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11330), {P0_total_page, P0_buy_items}) ->
    D_a_t_a = <<?_(P0_total_page, '32'):32, ?_((length(P0_buy_items)), "16"):16, (list_to_binary([<<?_(P1_buy_id, '32'):32, ?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_role_name)), "16"):16, ?_(P1_role_name, bin)/binary, ?_(P1_begin_time, '32'):32, ?_(P1_end_time, '32'):32, ?_(P1_assets_type, '8/signed'):8/signed, ?_(P1_unit_price, '32'):32, ?_(P1_quantity, '32'):32, ?_(P1_item_base_id, '32'):32, ?_((byte_size(P1_item_name)), "16"):16, ?_(P1_item_name, bin)/binary, ?_(P1_type, '8'):8, ?_(P1_quality, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_career, '8'):8>> || #market_buy{buy_id = P1_buy_id, role_id = P1_role_id, srv_id = P1_srv_id, role_name = P1_role_name, begin_time = P1_begin_time, end_time = P1_end_time, assets_type = P1_assets_type, unit_price = P1_unit_price, quantity = P1_quantity, item_base_id = P1_item_base_id, item_name = P1_item_name, type = P1_type, quality = P1_quality, lev = P1_lev, career = P1_career} <- P0_buy_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11330:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11330), {P0_type, P0_item_name, P0_min_lev, P0_max_lev, P0_quality, P0_career, P0_page_index}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_((byte_size(P0_item_name)), "16"):16, ?_(P0_item_name, bin)/binary, ?_(P0_min_lev, '8'):8, ?_(P0_max_lev, '8'):8, ?_(P0_quality, '8'):8, ?_(P0_career, '8'):8, ?_(P0_page_index, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11330:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11331), {P0_buy_items}) ->
    D_a_t_a = <<?_((length(P0_buy_items)), "16"):16, (list_to_binary([<<?_(P1_buy_id, '32'):32, ?_((byte_size(P1_role_name)), "16"):16, ?_(P1_role_name, bin)/binary, ?_(P1_begin_time, '32'):32, ?_(P1_end_time, '32'):32, ?_(P1_assets_type, '8/signed'):8/signed, ?_(P1_unit_price, '32'):32, ?_(P1_quantity, '32'):32, ?_(P1_item_base_id, '32'):32, ?_((byte_size(P1_item_name)), "16"):16, ?_(P1_item_name, bin)/binary, ?_(P1_type, '8'):8, ?_(P1_quality, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_career, '8'):8>> || #market_buy{buy_id = P1_buy_id, role_name = P1_role_name, begin_time = P1_begin_time, end_time = P1_end_time, assets_type = P1_assets_type, unit_price = P1_unit_price, quantity = P1_quantity, item_base_id = P1_item_base_id, item_name = P1_item_name, type = P1_type, quality = P1_quality, lev = P1_lev, career = P1_career} <- P0_buy_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11331:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11331), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11331:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11332), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11332:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11332), {P0_item_base_id, P0_assets_type, P0_unit_price, P0_quantity, P0_time, P0_notice}) ->
    D_a_t_a = <<?_(P0_item_base_id, '32'):32, ?_(P0_assets_type, '8'):8, ?_(P0_unit_price, '32'):32, ?_(P0_quantity, '32'):32, ?_(P0_time, '32'):32, ?_(P0_notice, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11332:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11333), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11333:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11333), {P0_buy_id}) ->
    D_a_t_a = <<?_(P0_buy_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11333:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11334), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11334:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11334), {P0_buy_id, P0_item_id, P0_quantity}) ->
    D_a_t_a = <<?_(P0_buy_id, '32'):32, ?_(P0_item_id, '32'):32, ?_(P0_quantity, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11334:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11335), {P0_coin_price, P0_gold_price}) ->
    D_a_t_a = <<?_(P0_coin_price, '32'):32, ?_(P0_gold_price, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11335:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11335), {P0_item_base_id}) ->
    D_a_t_a = <<?_(P0_item_base_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11335:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11336), {P0_total_page, P0_sales}) ->
    D_a_t_a = <<?_(P0_total_page, '32'):32, ?_((length(P0_sales)), "16"):16, (list_to_binary([<<?_(P1_sale_id, '32'):32, ?_(P1_item_id, '32'):32, ?_(P1_item_base_id, '32'):32, ?_((byte_size(P1_item_name)), "16"):16, ?_(P1_item_name, bin)/binary, ?_(P1_type, '8/signed'):8/signed, ?_(P1_begin_time, '32/signed'):32/signed, ?_(P1_end_time, '32/signed'):32/signed, ?_(P1_assets_type, '8/signed'):8/signed, ?_(P1_price, '32/signed'):32/signed, ?_(P1_price_tax, '32/signed'):32/signed, ?_(P1_lev, '8'):8, ?_(P1_career, '8'):8, ?_(P1_bind, '8'):8, ?_(P1_quality, '8'):8, ?_(P1_upgrade, '8'):8, ?_(P1_enchant, '8/signed'):8/signed, ?_(P1_enchant_fail, '8'):8, ?_(P1_quantity, '32'):32, ?_(P1_lasttime, '32'):32, ?_(P1_durability, '32/signed'):32/signed, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary>> || #market_sale{sale_id = P1_sale_id, item_id = P1_item_id, item_base_id = P1_item_base_id, item_name = P1_item_name, type = P1_type, begin_time = P1_begin_time, end_time = P1_end_time, assets_type = P1_assets_type, price = P1_price, price_tax = P1_price_tax, lev = P1_lev, career = P1_career, bind = P1_bind, quality = P1_quality, upgrade = P1_upgrade, enchant = P1_enchant, enchant_fail = P1_enchant_fail, quantity = P1_quantity, lasttime = P1_lasttime, durability = P1_durability, attr = P1_attr, max_base_attr = P1_max_base_attr} <- P0_sales]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11336:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11336), {P0_type, P0_item_name}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_((byte_size(P0_item_name)), "16"):16, ?_(P0_item_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11336:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11340), {P0_is_full, P0_sales}) ->
    D_a_t_a = <<?_(P0_is_full, '8'):8, ?_((length(P0_sales)), "16"):16, (list_to_binary([<<?_(P1_sale_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_quantity, '16'):16, ?_(P1_price, '32'):32, ?_(P1_type, '8'):8>> || {P1_sale_id, P1_base_id, P1_quantity, P1_price, P1_type} <- P0_sales]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11340:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11340), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11340:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11341), {P0_sale_id, P0_id, P0_quantity, P0_is_full}) ->
    D_a_t_a = <<?_(P0_sale_id, '32'):32, ?_(P0_id, '32'):32, ?_(P0_quantity, '16'):16, ?_(P0_is_full, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11341:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11341), {P0_id, P0_price, P0_quantity, P0_notice}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_price, '32'):32, ?_(P0_quantity, '16'):16, ?_(P0_notice, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11341:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11342), {P0_total_page, P0_sales}) ->
    D_a_t_a = <<?_(P0_total_page, '32'):32, ?_((length(P0_sales)), "16"):16, (list_to_binary([<<?_(P1_sale_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_quantity, '16'):16, ?_(P1_price, '32'):32, ?_(P1_type, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_career, '8'):8>> || {P1_sale_id, P1_base_id, P1_quantity, P1_price, P1_type, P1_lev, P1_career} <- P0_sales]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11342:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11342), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11342:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11343), {P0_total_page, P0_sales}) ->
    D_a_t_a = <<?_(P0_total_page, '32'):32, ?_((length(P0_sales)), "16"):16, (list_to_binary([<<?_(P1_sale_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_quantity, '16'):16, ?_(P1_price, '32'):32, ?_(P1_type, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_career, '8'):8>> || {P1_sale_id, P1_base_id, P1_quantity, P1_price, P1_type, P1_lev, P1_career} <- P0_sales]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11343:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11343), {P0_type, P0_page_index}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_page_index, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11343:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11344), {P0_sale_id}) ->
    D_a_t_a = <<?_(P0_sale_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11344:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11344), {P0_sale_id}) ->
    D_a_t_a = <<?_(P0_sale_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11344:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11345), {P0_sale_id}) ->
    D_a_t_a = <<?_(P0_sale_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11345:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11345), {P0_sale_id}) ->
    D_a_t_a = <<?_(P0_sale_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11345:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11346), {P0_total_page, P0_sales}) ->
    D_a_t_a = <<?_(P0_total_page, '32'):32, ?_((length(P0_sales)), "16"):16, (list_to_binary([<<?_(P1_sale_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_quantity, '16'):16, ?_(P1_price, '32'):32, ?_(P1_type, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_career, '8'):8>> || {P1_sale_id, P1_base_id, P1_quantity, P1_price, P1_type, P1_lev, P1_career} <- P0_sales]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11346:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11346), {P0_base_id, P0_page_index}) ->
    D_a_t_a = <<?_(P0_base_id, '32'):32, ?_(P0_page_index, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11346:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 11340, _B0) ->
    {ok, {}};
unpack(cli, 11340, _B0) ->
    {P0_is_full, _B1} = lib_proto:read_uint8(_B0),
    {P0_sales, _B8} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_sale_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_base_id, _B4} = lib_proto:read_uint32(_B3),
        {P1_quantity, _B5} = lib_proto:read_uint16(_B4),
        {P1_price, _B6} = lib_proto:read_uint32(_B5),
        {P1_type, _B7} = lib_proto:read_uint8(_B6),
        {[P1_sale_id, P1_base_id, P1_quantity, P1_price, P1_type], _B7}
    end),
    {ok, {P0_is_full, P0_sales}};

unpack(srv, 11341, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_price, _B2} = lib_proto:read_uint32(_B1),
    {P0_quantity, _B3} = lib_proto:read_uint16(_B2),
    {P0_notice, _B4} = lib_proto:read_uint8(_B3),
    {ok, {P0_id, P0_price, P0_quantity, P0_notice}};
unpack(cli, 11341, _B0) ->
    {P0_sale_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_id, _B2} = lib_proto:read_uint32(_B1),
    {P0_quantity, _B3} = lib_proto:read_uint16(_B2),
    {P0_is_full, _B4} = lib_proto:read_uint8(_B3),
    {ok, {P0_sale_id, P0_id, P0_quantity, P0_is_full}};

unpack(srv, 11342, _B0) ->
    {ok, {}};
unpack(cli, 11342, _B0) ->
    {P0_total_page, _B1} = lib_proto:read_uint32(_B0),
    {P0_sales, _B10} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_sale_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_base_id, _B4} = lib_proto:read_uint32(_B3),
        {P1_quantity, _B5} = lib_proto:read_uint16(_B4),
        {P1_price, _B6} = lib_proto:read_uint32(_B5),
        {P1_type, _B7} = lib_proto:read_uint8(_B6),
        {P1_lev, _B8} = lib_proto:read_uint8(_B7),
        {P1_career, _B9} = lib_proto:read_uint8(_B8),
        {[P1_sale_id, P1_base_id, P1_quantity, P1_price, P1_type, P1_lev, P1_career], _B9}
    end),
    {ok, {P0_total_page, P0_sales}};

unpack(srv, 11343, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_page_index, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_type, P0_page_index}};
unpack(cli, 11343, _B0) ->
    {P0_total_page, _B1} = lib_proto:read_uint32(_B0),
    {P0_sales, _B10} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_sale_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_base_id, _B4} = lib_proto:read_uint32(_B3),
        {P1_quantity, _B5} = lib_proto:read_uint16(_B4),
        {P1_price, _B6} = lib_proto:read_uint32(_B5),
        {P1_type, _B7} = lib_proto:read_uint8(_B6),
        {P1_lev, _B8} = lib_proto:read_uint8(_B7),
        {P1_career, _B9} = lib_proto:read_uint8(_B8),
        {[P1_sale_id, P1_base_id, P1_quantity, P1_price, P1_type, P1_lev, P1_career], _B9}
    end),
    {ok, {P0_total_page, P0_sales}};

unpack(srv, 11344, _B0) ->
    {P0_sale_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_sale_id}};
unpack(cli, 11344, _B0) ->
    {P0_sale_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_sale_id}};

unpack(srv, 11345, _B0) ->
    {P0_sale_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_sale_id}};
unpack(cli, 11345, _B0) ->
    {P0_sale_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_sale_id}};

unpack(srv, 11346, _B0) ->
    {P0_base_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_page_index, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_base_id, P0_page_index}};
unpack(cli, 11346, _B0) ->
    {P0_total_page, _B1} = lib_proto:read_uint32(_B0),
    {P0_sales, _B10} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_sale_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_base_id, _B4} = lib_proto:read_uint32(_B3),
        {P1_quantity, _B5} = lib_proto:read_uint16(_B4),
        {P1_price, _B6} = lib_proto:read_uint32(_B5),
        {P1_type, _B7} = lib_proto:read_uint8(_B6),
        {P1_lev, _B8} = lib_proto:read_uint8(_B7),
        {P1_career, _B9} = lib_proto:read_uint8(_B8),
        {[P1_sale_id, P1_base_id, P1_quantity, P1_price, P1_type, P1_lev, P1_career], _B9}
    end),
    {ok, {P0_total_page, P0_sales}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
