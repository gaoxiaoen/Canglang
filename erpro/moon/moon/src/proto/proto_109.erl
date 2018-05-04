%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_109).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("item.hrl").
-include("notice.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(10901), {P0_srv_open_time, P0_is_after_eighth}) ->
    D_a_t_a = <<?_(P0_srv_open_time, '32'):32, ?_(P0_is_after_eighth, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10901:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10901), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10901:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10910), {P0_channel, P0_rid, P0_srv_id, P0_name, P0_sex, P0_vip, P0_special, P0_face_group, P0_msg}) ->
    D_a_t_a = <<?_(P0_channel, '8'):8, ?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_sex, '8'):8, ?_(P0_vip, '8'):8, ?_((length(P0_special)), "16"):16, (list_to_binary([<<?_(P1_label, '32'):32>> || P1_label <- P0_special]))/binary, ?_((length(P0_face_group)), "16"):16, (list_to_binary([<<?_(P1_group_id, '32'):32>> || P1_group_id <- P0_face_group]))/binary, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10910:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10910), {P0_channel, P0_msg}) ->
    D_a_t_a = <<?_(P0_channel, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10910:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10921), {P0_online, P0_circle, P0_rid, P0_srv_id, P0_name, P0_lev, P0_guild, P0_icon, P0_vip, P0_sign}) ->
    D_a_t_a = <<?_(P0_online, '8'):8, ?_(P0_circle, '8'):8, ?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_lev, '8'):8, ?_((byte_size(P0_guild)), "16"):16, ?_(P0_guild, bin)/binary, ?_(P0_icon, '32'):32, ?_(P0_vip, '8'):8, ?_((byte_size(P0_sign)), "16"):16, ?_(P0_sign, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10921:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10921), {P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10921:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10920), {P0_rid, P0_srv_id, P0_name, P0_sex, P0_special, P0_face_group, P0_msg}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_sex, '8'):8, ?_((length(P0_special)), "16"):16, (list_to_binary([<<?_(P1_label, '32'):32>> || P1_label <- P0_special]))/binary, ?_((length(P0_face_group)), "16"):16, (list_to_binary([<<?_(P1_group_id, '32'):32>> || P1_group_id <- P0_face_group]))/binary, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10920:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10920), {P0_rid, P0_srv_id, P0_msg}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10920:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10930), {P0_channel, P0_style, P0_rid, P0_srv_id, P0_name, P0_sex, P0_vip, P0_special, P0_msg}) ->
    D_a_t_a = <<?_(P0_channel, '8'):8, ?_(P0_style, '8'):8, ?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_sex, '8'):8, ?_(P0_vip, '8'):8, ?_((length(P0_special)), "16"):16, (list_to_binary([<<?_(P1_label, '32'):32>> || P1_label <- P0_special]))/binary, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10930:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10930), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10930:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10931), {P0_style, P0_msg, P0_maps}) ->
    D_a_t_a = <<?_(P0_style, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_((length(P0_maps)), "16"):16, (list_to_binary([<<?_(P1_map, '32'):32>> || P1_map <- P0_maps]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10931:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10931), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10931:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10932), {P0_channel, P0_style, P0_msg}) ->
    D_a_t_a = <<?_(P0_channel, '8'):8, ?_(P0_style, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10932:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10932), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10932:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10940), {P0_type, P0_msg}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10940:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10940), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10940:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10941), {P0_id, P0_type, P0_msg}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_(P0_type, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10941:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10941), {P0_id, P0_val}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_(P0_val, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10941:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10942), {P0_id, P0_type, P0_msg}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_(P0_type, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10942:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10942), {P0_id, P0_val}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_((byte_size(P0_val)), "16"):16, ?_(P0_val, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10942:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10943), {P0_base_id, P0_bind, P0_upgrade, P0_enchant, P0_enchant_fail, P0_durability, P0_craft, P0_attr, P0_max_base_attr, P0_extra}) ->
    D_a_t_a = <<?_(P0_base_id, '32'):32, ?_(P0_bind, '8'):8, ?_(P0_upgrade, '8'):8, ?_(P0_enchant, '16/signed'):16/signed, ?_(P0_enchant_fail, '8'):8, ?_(P0_durability, '32/signed'):32/signed, ?_(P0_craft, '8'):8, ?_((length(P0_attr)), "16"):16, (list_to_binary([<<?_(P1_attr_name, '32'):32, ?_(P1_flag, '32'):32, ?_(P1_value, '32'):32>> || {P1_attr_name, P1_flag, P1_value} <- P0_attr]))/binary, ?_((length(P0_max_base_attr)), "16"):16, (list_to_binary([<<?_(P1_attr_name, '32'):32, ?_(P1_flag, '32'):32, ?_(P1_value, '32'):32>> || {P1_attr_name, P1_flag, P1_value} <- P0_max_base_attr]))/binary, ?_((length(P0_extra)), "16"):16, (list_to_binary([<<?_(P1_type, '16'):16, ?_(P1_value, '32'):32, ?_((byte_size(P1_str)), "16"):16, ?_(P1_str, bin)/binary>> || {P1_type, P1_value, P1_str} <- P0_extra]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10943:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10943), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10943:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10944), {P0_flag, P0_base_id, P0_enchant, P0_cacheid}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_(P0_base_id, '32'):32, ?_(P0_enchant, '16/signed'):16/signed, ?_(P0_cacheid, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10944:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10944), {P0_storagetype, P0_id}) ->
    D_a_t_a = <<?_(P0_storagetype, '8'):8, ?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10944:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10945), {P0_ret, P0_map, P0_x, P0_y}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_(P0_map, '16'):16, ?_(P0_x, '16'):16, ?_(P0_y, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10945:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10945), {P0_map, P0_x, P0_y}) ->
    D_a_t_a = <<?_(P0_map, '16'):16, ?_(P0_x, '16'):16, ?_(P0_y, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10945:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10950), {P0_type, P0_gain, P0_loss}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_((length(P0_gain)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_item_id, '32/signed'):32/signed, ?_(P1_num, '32/signed'):32/signed>> || {P1_type, P1_item_id, P1_num} <- P0_gain]))/binary, ?_((length(P0_loss)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_item_id, '32/signed'):32/signed, ?_(P1_num, '32/signed'):32/signed>> || {P1_type, P1_item_id, P1_num} <- P0_loss]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10950:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10950), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10950:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10960), {P0_notice_board}) ->
    D_a_t_a = <<?_((length(P0_notice_board)), "16"):16, (list_to_binary([<<?_(P1_id, '16'):16, ?_(P1_time, '32'):32, ?_(P1_gold, '32'):32, ?_(P1_coin, '32'):32, ?_(P1_bind_gold, '32'):32, ?_(P1_bind_coin, '32'):32, ?_((byte_size(P1_subject)), "16"):16, ?_(P1_subject, bin)/binary, ?_((byte_size(P1_summary)), "16"):16, ?_(P1_summary, bin)/binary, ?_((byte_size(P1_text)), "16"):16, ?_(P1_text, bin)/binary, ?_((length(P1_items)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32, ?_(P2_bind, '8'):8, ?_(P2_num, '8'):8>> || {P2_base_id, P2_bind, P2_num} <- P1_items]))/binary>> || #notice_board{id = P1_id, time = P1_time, gold = P1_gold, coin = P1_coin, bind_gold = P1_bind_gold, bind_coin = P1_bind_coin, subject = P1_subject, summary = P1_summary, text = P1_text, items = P1_items} <- P0_notice_board]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10960:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10960), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10960:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10961), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10961:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10961), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10961:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10962), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10962:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10962), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10962:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10963), {P0_status, P0_msg, P0_id}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10963:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10963), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10963:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10964), {P0_id, P0_time, P0_gold, P0_coin, P0_bind_gold, P0_bind_coin, P0_subject, P0_text, P0_items}) ->
    D_a_t_a = <<?_(P0_id, '16'):16, ?_(P0_time, '32'):32, ?_(P0_gold, '32'):32, ?_(P0_coin, '32'):32, ?_(P0_bind_gold, '32'):32, ?_(P0_bind_coin, '32'):32, ?_((byte_size(P0_subject)), "16"):16, ?_(P0_subject, bin)/binary, ?_((byte_size(P0_text)), "16"):16, ?_(P0_text, bin)/binary, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_num, '8'):8>> || {P1_base_id, P1_bind, P1_num} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10964:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10964), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10964:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10965), {P0_ids}) ->
    D_a_t_a = <<?_((length(P0_ids)), "16"):16, (list_to_binary([<<?_(P1_id, '16'):16>> || {P1_id} <- P0_ids]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10965:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10965), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10965:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10966), {P0_op, P0_acc_name, P0_srv_id, P0_name1, P0_name2, P0_name3, P0_itemnames, P0_timestamp, P0_ticket}) ->
    D_a_t_a = <<?_(P0_op, '16'):16, ?_((byte_size(P0_acc_name)), "16"):16, ?_(P0_acc_name, bin)/binary, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name1)), "16"):16, ?_(P0_name1, bin)/binary, ?_((byte_size(P0_name2)), "16"):16, ?_(P0_name2, bin)/binary, ?_((byte_size(P0_name3)), "16"):16, ?_(P0_name3, bin)/binary, ?_((length(P0_itemnames)), "16"):16, (list_to_binary([<<?_((byte_size(P1_name4)), "16"):16, ?_(P1_name4, bin)/binary>> || P1_name4 <- P0_itemnames]))/binary, ?_(P0_timestamp, '32'):32, ?_((byte_size(P0_ticket)), "16"):16, ?_(P0_ticket, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10966:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10966), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10966:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10970), {P0_puiz_ids}) ->
    D_a_t_a = <<?_((length(P0_puiz_ids)), "16"):16, (list_to_binary([<<?_(P1_id, '16'):16>> || P1_id <- P0_puiz_ids]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10970:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10970), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10970:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10971), {P0_rid, P0_srv_id, P0_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10971:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10971), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10971:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10972), {P0_face_group}) ->
    D_a_t_a = <<?_((length(P0_face_group)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_is_persistent, '8'):8, ?_(P1_expire, '32'):32, ?_(P1_order, '32'):32>> || {P1_id, P1_is_persistent, P1_expire, P1_order} <- P0_face_group]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10972:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10972), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10972:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10973), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10973:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10973), {P0_new_orders}) ->
    D_a_t_a = <<?_((length(P0_new_orders)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_order, '32'):32>> || {P1_id, P1_order} <- P0_new_orders]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10973:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10999), {P0_type, P0_msg}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10999:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10999), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10999:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 10910, _B0) ->
    {P0_channel, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_channel, P0_msg}};
unpack(cli, 10910, _B0) ->
    {P0_channel, _B1} = lib_proto:read_uint8(_B0),
    {P0_rid, _B2} = lib_proto:read_uint32(_B1),
    {P0_srv_id, _B3} = lib_proto:read_string(_B2),
    {P0_name, _B4} = lib_proto:read_string(_B3),
    {P0_sex, _B5} = lib_proto:read_uint8(_B4),
    {P0_vip, _B6} = lib_proto:read_uint8(_B5),
    {P0_special, _B9} = lib_proto:read_array(_B6, fun(_B7) ->
        {P1_label, _B8} = lib_proto:read_uint32(_B7),
        {P1_label, _B8}
    end),
    {P0_face_group, _B12} = lib_proto:read_array(_B9, fun(_B10) ->
        {P1_group_id, _B11} = lib_proto:read_uint32(_B10),
        {P1_group_id, _B11}
    end),
    {P0_msg, _B13} = lib_proto:read_string(_B12),
    {ok, {P0_channel, P0_rid, P0_srv_id, P0_name, P0_sex, P0_vip, P0_special, P0_face_group, P0_msg}};

unpack(srv, 10921, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_rid, P0_srv_id}};
unpack(cli, 10921, _B0) ->
    {P0_online, _B1} = lib_proto:read_uint8(_B0),
    {P0_circle, _B2} = lib_proto:read_uint8(_B1),
    {P0_rid, _B3} = lib_proto:read_uint32(_B2),
    {P0_srv_id, _B4} = lib_proto:read_string(_B3),
    {P0_name, _B5} = lib_proto:read_string(_B4),
    {P0_lev, _B6} = lib_proto:read_uint8(_B5),
    {P0_guild, _B7} = lib_proto:read_string(_B6),
    {P0_icon, _B8} = lib_proto:read_uint32(_B7),
    {P0_vip, _B9} = lib_proto:read_uint8(_B8),
    {P0_sign, _B10} = lib_proto:read_string(_B9),
    {ok, {P0_online, P0_circle, P0_rid, P0_srv_id, P0_name, P0_lev, P0_guild, P0_icon, P0_vip, P0_sign}};

unpack(srv, 10920, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_msg, _B3} = lib_proto:read_string(_B2),
    {ok, {P0_rid, P0_srv_id, P0_msg}};
unpack(cli, 10920, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_name, _B3} = lib_proto:read_string(_B2),
    {P0_sex, _B4} = lib_proto:read_uint8(_B3),
    {P0_special, _B7} = lib_proto:read_array(_B4, fun(_B5) ->
        {P1_label, _B6} = lib_proto:read_uint32(_B5),
        {P1_label, _B6}
    end),
    {P0_face_group, _B10} = lib_proto:read_array(_B7, fun(_B8) ->
        {P1_group_id, _B9} = lib_proto:read_uint32(_B8),
        {P1_group_id, _B9}
    end),
    {P0_msg, _B11} = lib_proto:read_string(_B10),
    {ok, {P0_rid, P0_srv_id, P0_name, P0_sex, P0_special, P0_face_group, P0_msg}};

unpack(srv, 10930, _B0) ->
    {ok, {}};
unpack(cli, 10930, _B0) ->
    {P0_channel, _B1} = lib_proto:read_uint8(_B0),
    {P0_style, _B2} = lib_proto:read_uint8(_B1),
    {P0_rid, _B3} = lib_proto:read_uint32(_B2),
    {P0_srv_id, _B4} = lib_proto:read_string(_B3),
    {P0_name, _B5} = lib_proto:read_string(_B4),
    {P0_sex, _B6} = lib_proto:read_uint8(_B5),
    {P0_vip, _B7} = lib_proto:read_uint8(_B6),
    {P0_special, _B10} = lib_proto:read_array(_B7, fun(_B8) ->
        {P1_label, _B9} = lib_proto:read_uint32(_B8),
        {P1_label, _B9}
    end),
    {P0_msg, _B11} = lib_proto:read_string(_B10),
    {ok, {P0_channel, P0_style, P0_rid, P0_srv_id, P0_name, P0_sex, P0_vip, P0_special, P0_msg}};

unpack(srv, 10931, _B0) ->
    {ok, {}};
unpack(cli, 10931, _B0) ->
    {P0_style, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {P0_maps, _B5} = lib_proto:read_array(_B2, fun(_B3) ->
        {P1_map, _B4} = lib_proto:read_uint32(_B3),
        {P1_map, _B4}
    end),
    {ok, {P0_style, P0_msg, P0_maps}};

unpack(srv, 10932, _B0) ->
    {ok, {}};
unpack(cli, 10932, _B0) ->
    {P0_channel, _B1} = lib_proto:read_uint8(_B0),
    {P0_style, _B2} = lib_proto:read_uint8(_B1),
    {P0_msg, _B3} = lib_proto:read_string(_B2),
    {ok, {P0_channel, P0_style, P0_msg}};

unpack(srv, 10940, _B0) ->
    {ok, {}};
unpack(cli, 10940, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_type, P0_msg}};

unpack(srv, 10943, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 10943, _B0) ->
    {P0_base_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_bind, _B2} = lib_proto:read_uint8(_B1),
    {P0_upgrade, _B3} = lib_proto:read_uint8(_B2),
    {P0_enchant, _B4} = lib_proto:read_int16(_B3),
    {P0_enchant_fail, _B5} = lib_proto:read_uint8(_B4),
    {P0_durability, _B6} = lib_proto:read_int32(_B5),
    {P0_craft, _B7} = lib_proto:read_uint8(_B6),
    {P0_attr, _B12} = lib_proto:read_array(_B7, fun(_B8) ->
        {P1_attr_name, _B9} = lib_proto:read_uint32(_B8),
        {P1_flag, _B10} = lib_proto:read_uint32(_B9),
        {P1_value, _B11} = lib_proto:read_uint32(_B10),
        {[P1_attr_name, P1_flag, P1_value], _B11}
    end),
    {P0_max_base_attr, _B17} = lib_proto:read_array(_B12, fun(_B13) ->
        {P1_attr_name, _B14} = lib_proto:read_uint32(_B13),
        {P1_flag, _B15} = lib_proto:read_uint32(_B14),
        {P1_value, _B16} = lib_proto:read_uint32(_B15),
        {[P1_attr_name, P1_flag, P1_value], _B16}
    end),
    {P0_extra, _B22} = lib_proto:read_array(_B17, fun(_B18) ->
        {P1_type, _B19} = lib_proto:read_uint16(_B18),
        {P1_value, _B20} = lib_proto:read_uint32(_B19),
        {P1_str, _B21} = lib_proto:read_string(_B20),
        {[P1_type, P1_value, P1_str], _B21}
    end),
    {ok, {P0_base_id, P0_bind, P0_upgrade, P0_enchant, P0_enchant_fail, P0_durability, P0_craft, P0_attr, P0_max_base_attr, P0_extra}};

unpack(srv, 10944, _B0) ->
    {P0_storagetype, _B1} = lib_proto:read_uint8(_B0),
    {P0_id, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_storagetype, P0_id}};
unpack(cli, 10944, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_base_id, _B2} = lib_proto:read_uint32(_B1),
    {P0_enchant, _B3} = lib_proto:read_int16(_B2),
    {P0_cacheid, _B4} = lib_proto:read_uint32(_B3),
    {ok, {P0_flag, P0_base_id, P0_enchant, P0_cacheid}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
