%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_119).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("npc_store.hrl").
-include("store.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(11900), {P0_result, P0_msg, P0_store_items}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_((length(P0_store_items)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_(P1_price, '32'):32, ?_(P1_show_num, '32'):32>> || {P1_base_id, P1_price, P1_show_num} <- P0_store_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11900:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11900), {P0_npc_id, P0_is_remote}) ->
    D_a_t_a = <<?_(P0_npc_id, '32'):32, ?_(P0_is_remote, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11900:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11901), {P0_sale_items}) ->
    D_a_t_a = <<?_((length(P0_sale_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_pos, '16'):16, ?_(P1_base_id, '32'):32, ?_(P1_num, '16'):16, ?_(P1_price, '32'):32>> || {P1_id, P1_pos, P1_base_id, P1_num, P1_price} <- P0_sale_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11901:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11901), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11901:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11902), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11902:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11902), {P0_npc_id, P0_is_remote, P0_bindtype, P0_buy_items}) ->
    D_a_t_a = <<?_(P0_npc_id, '32'):32, ?_(P0_is_remote, '8'):8, ?_(P0_bindtype, '8'):8, ?_((length(P0_buy_items)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_(P1_num, '16'):16>> || {P1_base_id, P1_num} <- P0_buy_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11902:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11903), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11903:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11903), {P0_npc_id, P0_is_remote, P0_ids}) ->
    D_a_t_a = <<?_(P0_npc_id, '32'):32, ?_(P0_is_remote, '8'):8, ?_((length(P0_ids)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32>> || P1_id <- P0_ids]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11903:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11904), {P0_result, P0_msg, P0_type, P0_times, P0_count, P0_store_items}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_type, '8'):8, ?_(P0_times, '32'):32, ?_(P0_count, '32'):32, ?_((length(P0_store_items)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_(P1_price, '32'):32>> || {P1_base_id, P1_price} <- P0_store_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11904:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11904), {P0_npc_id, P0_type}) ->
    D_a_t_a = <<?_(P0_npc_id, '32'):32, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11904:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11905), {P0_type, P0_times, P0_count, P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_times, '32'):32, ?_(P0_count, '32'):32, ?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11905:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11905), {P0_npc_id, P0_type, P0_buy_items}) ->
    D_a_t_a = <<?_(P0_npc_id, '32'):32, ?_(P0_type, '8'):8, ?_((length(P0_buy_items)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_(P1_num, '16'):16>> || {P1_base_id, P1_num} <- P0_buy_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11905:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11906), {P0_result, P0_msg, P0_refresh_time, P0_sm_items, P0_sm_logs, P0_free_times, P0_total_times}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_refresh_time, '32'):32, ?_((length(P0_sm_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_price, '32'):32, ?_(P1_price_type, '8'):8, ?_(P1_num, '16'):16, ?_(P1_is_music, '8'):8>> || #npc_store_sm_item{id = P1_id, base_id = P1_base_id, price = P1_price, price_type = P1_price_type, num = P1_num, is_music = P1_is_music} <- P0_sm_items]))/binary, ?_((length(P0_sm_logs)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_base_id, '32'):32, ?_(P1_num, '16'):16, ?_(P1_buy_time, '32'):32>> || #npc_store_sm_log{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, base_id = P1_base_id, num = P1_num, buy_time = P1_buy_time} <- P0_sm_logs]))/binary, ?_(P0_free_times, '16'):16, ?_(P0_total_times, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11906:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11906), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11906:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11907), {P0_free_times, P0_cd, P0_charge_times, P0_items}) ->
    D_a_t_a = <<?_(P0_free_times, '8'):8, ?_(P0_cd, '32'):32, ?_(P0_charge_times, '16'):16, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_item_id, '16'):16>> || P1_item_id <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11907:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11907), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11907:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11908), {P0_new_id}) ->
    D_a_t_a = <<?_(P0_new_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11908:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11908), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11908:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11909), {P0_rid, P0_srv_id, P0_name, P0_base_id, P0_num, P0_buy_time}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_base_id, '32'):32, ?_(P0_num, '16'):16, ?_(P0_buy_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11909:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11909), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11909:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11910), {P0_free_times, P0_cd, P0_charge_times, P0_items, P0_lucky_list}) ->
    D_a_t_a = <<?_(P0_free_times, '8'):8, ?_(P0_cd, '32'):32, ?_(P0_charge_times, '16'):16, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_item_id, '16'):16>> || P1_item_id <- P0_items]))/binary, ?_((length(P0_lucky_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_role_name)), "16"):16, ?_(P1_role_name, bin)/binary, ?_((byte_size(P1_item_name)), "16"):16, ?_(P1_item_name, bin)/binary>> || {P1_role_name, P1_item_name} <- P0_lucky_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11910:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11910), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11910:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11911), {P0_cd, P0_free_times}) ->
    D_a_t_a = <<?_(P0_cd, '32'):32, ?_(P0_free_times, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11911:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11911), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11911:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11920), {P0_type, P0_refresh_time, P0_items}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_refresh_time, '32'):32, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_(P1_price, '32'):32>> || {P1_base_id, P1_price} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11920:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11920), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11920:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11921), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11921:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11921), {P0_type, P0_ids}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_((length(P0_ids)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32>> || P1_id <- P0_ids]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11921:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11930), {P0_result, P0_msg, P0_items, P0_logs}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_(P1_price, '32'):32, ?_(P1_price_type, '8'):8, ?_(P1_num, '16'):16>> || #store_item{base_id = P1_base_id, price = P1_price, price_type = P1_price_type, num = P1_num} <- P0_items]))/binary, ?_((length(P0_logs)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_base_id, '32'):32, ?_(P1_num, '16'):16, ?_(P1_buy_time, '32'):32>> || #npc_store_dung_log{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, base_id = P1_base_id, num = P1_num, buy_time = P1_buy_time} <- P0_logs]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11930:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11930), {P0_npc_id}) ->
    D_a_t_a = <<?_(P0_npc_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11930:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11931), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11931:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11931), {P0_npc_id, P0_buy_list}) ->
    D_a_t_a = <<?_(P0_npc_id, '32'):32, ?_((length(P0_buy_list)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_(P1_num, '8'):8>> || [P1_base_id, P1_num] <- P0_buy_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11931:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11940), {P0_item_id, P0_dantengdeid, P0_gold_single, P0_gold_batch, P0_list}) ->
    D_a_t_a = <<?_(P0_item_id, '32'):32, ?_(P0_dantengdeid, '32'):32, ?_(P0_gold_single, '16'):16, ?_(P0_gold_batch, '16'):16, ?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_(P1_num, '8'):8, ?_(P1_price, '16'):16>> || {P1_base_id, P1_num, P1_price} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11940:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11940), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11940:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11941), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11941:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11941), {P0_item_id, P0_dantengdeid, P0_polish_type}) ->
    D_a_t_a = <<?_(P0_item_id, '32'):32, ?_(P0_dantengdeid, '32'):32, ?_(P0_polish_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11941:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11942), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11942:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11942), {P0_item_id, P0_dantengdeid, P0_base_id}) ->
    D_a_t_a = <<?_(P0_item_id, '32'):32, ?_(P0_dantengdeid, '32'):32, ?_(P0_base_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11942:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 11907, _B0) ->
    {ok, {}};
unpack(cli, 11907, _B0) ->
    {P0_free_times, _B1} = lib_proto:read_uint8(_B0),
    {P0_cd, _B2} = lib_proto:read_uint32(_B1),
    {P0_charge_times, _B3} = lib_proto:read_uint16(_B2),
    {P0_items, _B6} = lib_proto:read_array(_B3, fun(_B4) ->
        {P1_item_id, _B5} = lib_proto:read_uint16(_B4),
        {P1_item_id, _B5}
    end),
    {ok, {P0_free_times, P0_cd, P0_charge_times, P0_items}};

unpack(srv, 11908, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_id}};
unpack(cli, 11908, _B0) ->
    {P0_new_id, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_new_id}};

unpack(srv, 11910, _B0) ->
    {ok, {}};
unpack(cli, 11910, _B0) ->
    {P0_free_times, _B1} = lib_proto:read_uint8(_B0),
    {P0_cd, _B2} = lib_proto:read_uint32(_B1),
    {P0_charge_times, _B3} = lib_proto:read_uint16(_B2),
    {P0_items, _B6} = lib_proto:read_array(_B3, fun(_B4) ->
        {P1_item_id, _B5} = lib_proto:read_uint16(_B4),
        {P1_item_id, _B5}
    end),
    {P0_lucky_list, _B10} = lib_proto:read_array(_B6, fun(_B7) ->
        {P1_role_name, _B8} = lib_proto:read_string(_B7),
        {P1_item_name, _B9} = lib_proto:read_string(_B8),
        {[P1_role_name, P1_item_name], _B9}
    end),
    {ok, {P0_free_times, P0_cd, P0_charge_times, P0_items, P0_lucky_list}};

unpack(srv, 11911, _B0) ->
    {ok, {}};
unpack(cli, 11911, _B0) ->
    {P0_cd, _B1} = lib_proto:read_uint32(_B0),
    {P0_free_times, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_cd, P0_free_times}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
