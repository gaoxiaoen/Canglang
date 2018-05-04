%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_117).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("item.hrl").
-include("mail.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(11700), {P0_mails}) ->
    D_a_t_a = <<?_((length(P0_mails)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_send_time, '32'):32, ?_(P1_from_rid, '32'):32, ?_((byte_size(P1_from_srv_id)), "16"):16, ?_(P1_from_srv_id, bin)/binary, ?_((byte_size(P1_from_name)), "16"):16, ?_(P1_from_name, bin)/binary, ?_(P1_to_rid, '32'):32, ?_((byte_size(P1_to_srv_id)), "16"):16, ?_(P1_to_srv_id, bin)/binary, ?_((byte_size(P1_to_name)), "16"):16, ?_(P1_to_name, bin)/binary, ?_(P1_status, '8'):8, ?_((byte_size(P1_subject)), "16"):16, ?_(P1_subject, bin)/binary, ?_((byte_size(P1_content)), "16"):16, ?_(P1_content, bin)/binary, ?_(P1_mailtype, '8'):8, ?_(P1_isatt, '8'):8, ?_((length(P1_assets)), "16"):16, (list_to_binary([<<?_(P2_type, '32'):32, ?_(P2_val, '32'):32>> || {P2_type, P2_val} <- P1_assets]))/binary, ?_((length(P1_attachment)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_(P2_base_id, '32'):32, ?_(P2_bind, '8'):8, ?_(P2_upgrade, '8'):8, ?_(P2_enchant, '8/signed'):8/signed, ?_(P2_enchant_fail, '8'):8, ?_(P2_quantity, '8'):8, ?_(P2_status, '8'):8, ?_(P2_pos, '16'):16, ?_(P2_lasttime, '32'):32, ?_(P2_durability, '32/signed'):32/signed, ?_(P2_craft, '8'):8, ?_((length(P2_attr)), "16"):16, (list_to_binary([<<?_(P3_attr_name, '32'):32, ?_(P3_flag, '32'):32, ?_(P3_value, '32'):32>> || {P3_attr_name, P3_flag, P3_value} <- P2_attr]))/binary, ?_((length(P2_max_base_attr)), "16"):16, (list_to_binary([<<?_(P3_attr_name, '32'):32, ?_(P3_flag, '32'):32, ?_(P3_value, '32'):32>> || {P3_attr_name, P3_flag, P3_value} <- P2_max_base_attr]))/binary, ?_((length(P2_extra)), "16"):16, (list_to_binary([<<?_(P3_type, '16'):16, ?_(P3_value, '32'):32, ?_((byte_size(P3_str)), "16"):16, ?_(P3_str, bin)/binary>> || {P3_type, P3_value, P3_str} <- P2_extra]))/binary>> || #item{id = P2_id, base_id = P2_base_id, bind = P2_bind, upgrade = P2_upgrade, enchant = P2_enchant, enchant_fail = P2_enchant_fail, quantity = P2_quantity, status = P2_status, pos = P2_pos, lasttime = P2_lasttime, durability = P2_durability, craft = P2_craft, attr = P2_attr, max_base_attr = P2_max_base_attr, extra = P2_extra} <- P1_attachment]))/binary>> || #mail{id = P1_id, send_time = P1_send_time, from_rid = P1_from_rid, from_srv_id = P1_from_srv_id, from_name = P1_from_name, to_rid = P1_to_rid, to_srv_id = P1_to_srv_id, to_name = P1_to_name, status = P1_status, subject = P1_subject, content = P1_content, mailtype = P1_mailtype, isatt = P1_isatt, assets = P1_assets, attachment = P1_attachment} <- P0_mails]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11700:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11700), {P0_mailtype}) ->
    D_a_t_a = <<?_(P0_mailtype, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11700:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11701), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11701:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11701), {P0_to_name, P0_coin, P0_id, P0_subject, P0_content}) ->
    D_a_t_a = <<?_((byte_size(P0_to_name)), "16"):16, ?_(P0_to_name, bin)/binary, ?_(P0_coin, '32'):32, ?_(P0_id, '32/signed'):32/signed, ?_((byte_size(P0_subject)), "16"):16, ?_(P0_subject, bin)/binary, ?_((byte_size(P0_content)), "16"):16, ?_(P0_content, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11701:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11702), {P0_mails}) ->
    D_a_t_a = <<?_((length(P0_mails)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_send_time, '32'):32, ?_(P1_from_rid, '32'):32, ?_((byte_size(P1_from_srv_id)), "16"):16, ?_(P1_from_srv_id, bin)/binary, ?_((byte_size(P1_from_name)), "16"):16, ?_(P1_from_name, bin)/binary, ?_(P1_to_rid, '32'):32, ?_((byte_size(P1_to_srv_id)), "16"):16, ?_(P1_to_srv_id, bin)/binary, ?_((byte_size(P1_to_name)), "16"):16, ?_(P1_to_name, bin)/binary, ?_(P1_status, '8'):8, ?_((byte_size(P1_subject)), "16"):16, ?_(P1_subject, bin)/binary, ?_((byte_size(P1_content)), "16"):16, ?_(P1_content, bin)/binary, ?_(P1_mailtype, '8'):8, ?_(P1_isatt, '8'):8, ?_((length(P1_assets)), "16"):16, (list_to_binary([<<?_(P2_type, '32'):32, ?_(P2_val, '32'):32>> || {P2_type, P2_val} <- P1_assets]))/binary, ?_((length(P1_attachment)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_(P2_base_id, '32'):32, ?_(P2_bind, '8'):8, ?_(P2_upgrade, '8'):8, ?_(P2_enchant, '8/signed'):8/signed, ?_(P2_enchant_fail, '8'):8, ?_(P2_quantity, '8'):8, ?_(P2_status, '8'):8, ?_(P2_pos, '16'):16, ?_(P2_lasttime, '32'):32, ?_(P2_durability, '32/signed'):32/signed, ?_(P2_craft, '8'):8, ?_((length(P2_attr)), "16"):16, (list_to_binary([<<?_(P3_attr_name, '32'):32, ?_(P3_flag, '32'):32, ?_(P3_value, '32'):32>> || {P3_attr_name, P3_flag, P3_value} <- P2_attr]))/binary, ?_((length(P2_max_base_attr)), "16"):16, (list_to_binary([<<?_(P3_attr_name, '32'):32, ?_(P3_flag, '32'):32, ?_(P3_value, '32'):32>> || {P3_attr_name, P3_flag, P3_value} <- P2_max_base_attr]))/binary, ?_((length(P2_extra)), "16"):16, (list_to_binary([<<?_(P3_type, '16'):16, ?_(P3_value, '32'):32, ?_((byte_size(P3_str)), "16"):16, ?_(P3_str, bin)/binary>> || {P3_type, P3_value, P3_str} <- P2_extra]))/binary>> || #item{id = P2_id, base_id = P2_base_id, bind = P2_bind, upgrade = P2_upgrade, enchant = P2_enchant, enchant_fail = P2_enchant_fail, quantity = P2_quantity, status = P2_status, pos = P2_pos, lasttime = P2_lasttime, durability = P2_durability, craft = P2_craft, attr = P2_attr, max_base_attr = P2_max_base_attr, extra = P2_extra} <- P1_attachment]))/binary>> || #mail{id = P1_id, send_time = P1_send_time, from_rid = P1_from_rid, from_srv_id = P1_from_srv_id, from_name = P1_from_name, to_rid = P1_to_rid, to_srv_id = P1_to_srv_id, to_name = P1_to_name, status = P1_status, subject = P1_subject, content = P1_content, mailtype = P1_mailtype, isatt = P1_isatt, assets = P1_assets, attachment = P1_attachment} <- P0_mails]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11702:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11702), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11702:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11703), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11703:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11703), {P0_ids}) ->
    D_a_t_a = <<?_((length(P0_ids)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32>> || P1_id <- P0_ids]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11703:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11704), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11704:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11704), {P0_ids}) ->
    D_a_t_a = <<?_((length(P0_ids)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32>> || P1_id <- P0_ids]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11704:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11705), {P0_ids}) ->
    D_a_t_a = <<?_((length(P0_ids)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32>> || P1_id <- P0_ids]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11705:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11705), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11705:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11706), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11706:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11706), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11706:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11707), {P0_mails}) ->
    D_a_t_a = <<?_((length(P0_mails)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_send_time, '32'):32, ?_(P1_from_rid, '32'):32, ?_((byte_size(P1_from_srv_id)), "16"):16, ?_(P1_from_srv_id, bin)/binary, ?_((byte_size(P1_from_name)), "16"):16, ?_(P1_from_name, bin)/binary, ?_(P1_to_rid, '32'):32, ?_((byte_size(P1_to_srv_id)), "16"):16, ?_(P1_to_srv_id, bin)/binary, ?_((byte_size(P1_to_name)), "16"):16, ?_(P1_to_name, bin)/binary, ?_(P1_status, '8'):8, ?_((byte_size(P1_subject)), "16"):16, ?_(P1_subject, bin)/binary, ?_((byte_size(P1_content)), "16"):16, ?_(P1_content, bin)/binary, ?_(P1_mailtype, '8'):8, ?_(P1_isatt, '8'):8, ?_((length(P1_assets)), "16"):16, (list_to_binary([<<?_(P2_type, '32'):32, ?_(P2_val, '32'):32>> || {P2_type, P2_val} <- P1_assets]))/binary, ?_((length(P1_attachment)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_(P2_base_id, '32'):32, ?_(P2_bind, '8'):8, ?_(P2_upgrade, '8'):8, ?_(P2_enchant, '8/signed'):8/signed, ?_(P2_enchant_fail, '8'):8, ?_(P2_quantity, '8'):8, ?_(P2_status, '8'):8, ?_(P2_pos, '16'):16, ?_(P2_lasttime, '32'):32, ?_(P2_durability, '32/signed'):32/signed, ?_(P2_craft, '8'):8, ?_((length(P2_attr)), "16"):16, (list_to_binary([<<?_(P3_attr_name, '32'):32, ?_(P3_flag, '32'):32, ?_(P3_value, '32'):32>> || {P3_attr_name, P3_flag, P3_value} <- P2_attr]))/binary, ?_((length(P2_max_base_attr)), "16"):16, (list_to_binary([<<?_(P3_attr_name, '32'):32, ?_(P3_flag, '32'):32, ?_(P3_value, '32'):32>> || {P3_attr_name, P3_flag, P3_value} <- P2_max_base_attr]))/binary, ?_((length(P2_extra)), "16"):16, (list_to_binary([<<?_(P3_type, '16'):16, ?_(P3_value, '32'):32, ?_((byte_size(P3_str)), "16"):16, ?_(P3_str, bin)/binary>> || {P3_type, P3_value, P3_str} <- P2_extra]))/binary>> || #item{id = P2_id, base_id = P2_base_id, bind = P2_bind, upgrade = P2_upgrade, enchant = P2_enchant, enchant_fail = P2_enchant_fail, quantity = P2_quantity, status = P2_status, pos = P2_pos, lasttime = P2_lasttime, durability = P2_durability, craft = P2_craft, attr = P2_attr, max_base_attr = P2_max_base_attr, extra = P2_extra} <- P1_attachment]))/binary>> || #mail{id = P1_id, send_time = P1_send_time, from_rid = P1_from_rid, from_srv_id = P1_from_srv_id, from_name = P1_from_name, to_rid = P1_to_rid, to_srv_id = P1_to_srv_id, to_name = P1_to_name, status = P1_status, subject = P1_subject, content = P1_content, mailtype = P1_mailtype, isatt = P1_isatt, assets = P1_assets, attachment = P1_attachment} <- P0_mails]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11707:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11707), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11707:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11710), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11710:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11710), {P0_to_name, P0_content, P0_sign}) ->
    D_a_t_a = <<?_((byte_size(P0_to_name)), "16"):16, ?_(P0_to_name, bin)/binary, ?_((byte_size(P0_content)), "16"):16, ?_(P0_content, bin)/binary, ?_(P0_sign, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11710:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11711), {P0_mails}) ->
    D_a_t_a = <<?_((length(P0_mails)), "16"):16, (list_to_binary([<<?_((byte_size(P1_to_name)), "16"):16, ?_(P1_to_name, bin)/binary, ?_((byte_size(P1_content)), "16"):16, ?_(P1_content, bin)/binary, ?_(P1_send_time, '32'):32, ?_(P1_sign, '8'):8>> || [P1_to_name, P1_content, P1_send_time, P1_sign] <- P0_mails]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11711:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11711), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11711:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11712), {P0_count}) ->
    D_a_t_a = <<?_(P0_count, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11712:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11712), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11712:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 11700, _B0) ->
    {P0_mailtype, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_mailtype}};
unpack(cli, 11700, _B0) ->
    {P0_mails, _B48} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_send_time, _B3} = lib_proto:read_uint32(_B2),
        {P1_from_rid, _B4} = lib_proto:read_uint32(_B3),
        {P1_from_srv_id, _B5} = lib_proto:read_string(_B4),
        {P1_from_name, _B6} = lib_proto:read_string(_B5),
        {P1_to_rid, _B7} = lib_proto:read_uint32(_B6),
        {P1_to_srv_id, _B8} = lib_proto:read_string(_B7),
        {P1_to_name, _B9} = lib_proto:read_string(_B8),
        {P1_status, _B10} = lib_proto:read_uint8(_B9),
        {P1_subject, _B11} = lib_proto:read_string(_B10),
        {P1_content, _B12} = lib_proto:read_string(_B11),
        {P1_mailtype, _B13} = lib_proto:read_uint8(_B12),
        {P1_isatt, _B14} = lib_proto:read_uint8(_B13),
        {P1_assets, _B18} = lib_proto:read_array(_B14, fun(_B15) ->
            {P2_type, _B16} = lib_proto:read_uint32(_B15),
            {P2_val, _B17} = lib_proto:read_uint32(_B16),
            {[P2_type, P2_val], _B17}
        end),
        {P1_attachment, _B47} = lib_proto:read_array(_B18, fun(_B19) ->
            {P2_id, _B20} = lib_proto:read_uint32(_B19),
            {P2_base_id, _B21} = lib_proto:read_uint32(_B20),
            {P2_bind, _B22} = lib_proto:read_uint8(_B21),
            {P2_upgrade, _B23} = lib_proto:read_uint8(_B22),
            {P2_enchant, _B24} = lib_proto:read_int8(_B23),
            {P2_enchant_fail, _B25} = lib_proto:read_uint8(_B24),
            {P2_quantity, _B26} = lib_proto:read_uint8(_B25),
            {P2_status, _B27} = lib_proto:read_uint8(_B26),
            {P2_pos, _B28} = lib_proto:read_uint16(_B27),
            {P2_lasttime, _B29} = lib_proto:read_uint32(_B28),
            {P2_durability, _B30} = lib_proto:read_int32(_B29),
            {P2_craft, _B31} = lib_proto:read_uint8(_B30),
            {P2_attr, _B36} = lib_proto:read_array(_B31, fun(_B32) ->
                {P3_attr_name, _B33} = lib_proto:read_uint32(_B32),
                {P3_flag, _B34} = lib_proto:read_uint32(_B33),
                {P3_value, _B35} = lib_proto:read_uint32(_B34),
                {[P3_attr_name, P3_flag, P3_value], _B35}
            end),
            {P2_max_base_attr, _B41} = lib_proto:read_array(_B36, fun(_B37) ->
                {P3_attr_name, _B38} = lib_proto:read_uint32(_B37),
                {P3_flag, _B39} = lib_proto:read_uint32(_B38),
                {P3_value, _B40} = lib_proto:read_uint32(_B39),
                {[P3_attr_name, P3_flag, P3_value], _B40}
            end),
            {P2_extra, _B46} = lib_proto:read_array(_B41, fun(_B42) ->
                {P3_type, _B43} = lib_proto:read_uint16(_B42),
                {P3_value, _B44} = lib_proto:read_uint32(_B43),
                {P3_str, _B45} = lib_proto:read_string(_B44),
                {[P3_type, P3_value, P3_str], _B45}
            end),
            {[P2_id, P2_base_id, P2_bind, P2_upgrade, P2_enchant, P2_enchant_fail, P2_quantity, P2_status, P2_pos, P2_lasttime, P2_durability, P2_craft, P2_attr, P2_max_base_attr, P2_extra], _B46}
        end),
        {[P1_id, P1_send_time, P1_from_rid, P1_from_srv_id, P1_from_name, P1_to_rid, P1_to_srv_id, P1_to_name, P1_status, P1_subject, P1_content, P1_mailtype, P1_isatt, P1_assets, P1_attachment], _B47}
    end),
    {ok, {P0_mails}};

unpack(srv, 11701, _B0) ->
    {P0_to_name, _B1} = lib_proto:read_string(_B0),
    {P0_coin, _B2} = lib_proto:read_uint32(_B1),
    {P0_id, _B3} = lib_proto:read_int32(_B2),
    {P0_subject, _B4} = lib_proto:read_string(_B3),
    {P0_content, _B5} = lib_proto:read_string(_B4),
    {ok, {P0_to_name, P0_coin, P0_id, P0_subject, P0_content}};
unpack(cli, 11701, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_code, P0_msg}};

unpack(srv, 11702, _B0) ->
    {ok, {}};
unpack(cli, 11702, _B0) ->
    {P0_mails, _B48} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_send_time, _B3} = lib_proto:read_uint32(_B2),
        {P1_from_rid, _B4} = lib_proto:read_uint32(_B3),
        {P1_from_srv_id, _B5} = lib_proto:read_string(_B4),
        {P1_from_name, _B6} = lib_proto:read_string(_B5),
        {P1_to_rid, _B7} = lib_proto:read_uint32(_B6),
        {P1_to_srv_id, _B8} = lib_proto:read_string(_B7),
        {P1_to_name, _B9} = lib_proto:read_string(_B8),
        {P1_status, _B10} = lib_proto:read_uint8(_B9),
        {P1_subject, _B11} = lib_proto:read_string(_B10),
        {P1_content, _B12} = lib_proto:read_string(_B11),
        {P1_mailtype, _B13} = lib_proto:read_uint8(_B12),
        {P1_isatt, _B14} = lib_proto:read_uint8(_B13),
        {P1_assets, _B18} = lib_proto:read_array(_B14, fun(_B15) ->
            {P2_type, _B16} = lib_proto:read_uint32(_B15),
            {P2_val, _B17} = lib_proto:read_uint32(_B16),
            {[P2_type, P2_val], _B17}
        end),
        {P1_attachment, _B47} = lib_proto:read_array(_B18, fun(_B19) ->
            {P2_id, _B20} = lib_proto:read_uint32(_B19),
            {P2_base_id, _B21} = lib_proto:read_uint32(_B20),
            {P2_bind, _B22} = lib_proto:read_uint8(_B21),
            {P2_upgrade, _B23} = lib_proto:read_uint8(_B22),
            {P2_enchant, _B24} = lib_proto:read_int8(_B23),
            {P2_enchant_fail, _B25} = lib_proto:read_uint8(_B24),
            {P2_quantity, _B26} = lib_proto:read_uint8(_B25),
            {P2_status, _B27} = lib_proto:read_uint8(_B26),
            {P2_pos, _B28} = lib_proto:read_uint16(_B27),
            {P2_lasttime, _B29} = lib_proto:read_uint32(_B28),
            {P2_durability, _B30} = lib_proto:read_int32(_B29),
            {P2_craft, _B31} = lib_proto:read_uint8(_B30),
            {P2_attr, _B36} = lib_proto:read_array(_B31, fun(_B32) ->
                {P3_attr_name, _B33} = lib_proto:read_uint32(_B32),
                {P3_flag, _B34} = lib_proto:read_uint32(_B33),
                {P3_value, _B35} = lib_proto:read_uint32(_B34),
                {[P3_attr_name, P3_flag, P3_value], _B35}
            end),
            {P2_max_base_attr, _B41} = lib_proto:read_array(_B36, fun(_B37) ->
                {P3_attr_name, _B38} = lib_proto:read_uint32(_B37),
                {P3_flag, _B39} = lib_proto:read_uint32(_B38),
                {P3_value, _B40} = lib_proto:read_uint32(_B39),
                {[P3_attr_name, P3_flag, P3_value], _B40}
            end),
            {P2_extra, _B46} = lib_proto:read_array(_B41, fun(_B42) ->
                {P3_type, _B43} = lib_proto:read_uint16(_B42),
                {P3_value, _B44} = lib_proto:read_uint32(_B43),
                {P3_str, _B45} = lib_proto:read_string(_B44),
                {[P3_type, P3_value, P3_str], _B45}
            end),
            {[P2_id, P2_base_id, P2_bind, P2_upgrade, P2_enchant, P2_enchant_fail, P2_quantity, P2_status, P2_pos, P2_lasttime, P2_durability, P2_craft, P2_attr, P2_max_base_attr, P2_extra], _B46}
        end),
        {[P1_id, P1_send_time, P1_from_rid, P1_from_srv_id, P1_from_name, P1_to_rid, P1_to_srv_id, P1_to_name, P1_status, P1_subject, P1_content, P1_mailtype, P1_isatt, P1_assets, P1_attachment], _B47}
    end),
    {ok, {P0_mails}};

unpack(srv, 11703, _B0) ->
    {P0_ids, _B3} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_id, _B2}
    end),
    {ok, {P0_ids}};
unpack(cli, 11703, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_code, P0_msg}};

unpack(srv, 11704, _B0) ->
    {P0_ids, _B3} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_id, _B2}
    end),
    {ok, {P0_ids}};
unpack(cli, 11704, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_code, P0_msg}};

unpack(srv, 11705, _B0) ->
    {ok, {}};
unpack(cli, 11705, _B0) ->
    {P0_ids, _B3} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_id, _B2}
    end),
    {ok, {P0_ids}};

unpack(srv, 11706, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 11706, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_code, P0_msg}};

unpack(srv, 11707, _B0) ->
    {ok, {}};
unpack(cli, 11707, _B0) ->
    {P0_mails, _B48} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_send_time, _B3} = lib_proto:read_uint32(_B2),
        {P1_from_rid, _B4} = lib_proto:read_uint32(_B3),
        {P1_from_srv_id, _B5} = lib_proto:read_string(_B4),
        {P1_from_name, _B6} = lib_proto:read_string(_B5),
        {P1_to_rid, _B7} = lib_proto:read_uint32(_B6),
        {P1_to_srv_id, _B8} = lib_proto:read_string(_B7),
        {P1_to_name, _B9} = lib_proto:read_string(_B8),
        {P1_status, _B10} = lib_proto:read_uint8(_B9),
        {P1_subject, _B11} = lib_proto:read_string(_B10),
        {P1_content, _B12} = lib_proto:read_string(_B11),
        {P1_mailtype, _B13} = lib_proto:read_uint8(_B12),
        {P1_isatt, _B14} = lib_proto:read_uint8(_B13),
        {P1_assets, _B18} = lib_proto:read_array(_B14, fun(_B15) ->
            {P2_type, _B16} = lib_proto:read_uint32(_B15),
            {P2_val, _B17} = lib_proto:read_uint32(_B16),
            {[P2_type, P2_val], _B17}
        end),
        {P1_attachment, _B47} = lib_proto:read_array(_B18, fun(_B19) ->
            {P2_id, _B20} = lib_proto:read_uint32(_B19),
            {P2_base_id, _B21} = lib_proto:read_uint32(_B20),
            {P2_bind, _B22} = lib_proto:read_uint8(_B21),
            {P2_upgrade, _B23} = lib_proto:read_uint8(_B22),
            {P2_enchant, _B24} = lib_proto:read_int8(_B23),
            {P2_enchant_fail, _B25} = lib_proto:read_uint8(_B24),
            {P2_quantity, _B26} = lib_proto:read_uint8(_B25),
            {P2_status, _B27} = lib_proto:read_uint8(_B26),
            {P2_pos, _B28} = lib_proto:read_uint16(_B27),
            {P2_lasttime, _B29} = lib_proto:read_uint32(_B28),
            {P2_durability, _B30} = lib_proto:read_int32(_B29),
            {P2_craft, _B31} = lib_proto:read_uint8(_B30),
            {P2_attr, _B36} = lib_proto:read_array(_B31, fun(_B32) ->
                {P3_attr_name, _B33} = lib_proto:read_uint32(_B32),
                {P3_flag, _B34} = lib_proto:read_uint32(_B33),
                {P3_value, _B35} = lib_proto:read_uint32(_B34),
                {[P3_attr_name, P3_flag, P3_value], _B35}
            end),
            {P2_max_base_attr, _B41} = lib_proto:read_array(_B36, fun(_B37) ->
                {P3_attr_name, _B38} = lib_proto:read_uint32(_B37),
                {P3_flag, _B39} = lib_proto:read_uint32(_B38),
                {P3_value, _B40} = lib_proto:read_uint32(_B39),
                {[P3_attr_name, P3_flag, P3_value], _B40}
            end),
            {P2_extra, _B46} = lib_proto:read_array(_B41, fun(_B42) ->
                {P3_type, _B43} = lib_proto:read_uint16(_B42),
                {P3_value, _B44} = lib_proto:read_uint32(_B43),
                {P3_str, _B45} = lib_proto:read_string(_B44),
                {[P3_type, P3_value, P3_str], _B45}
            end),
            {[P2_id, P2_base_id, P2_bind, P2_upgrade, P2_enchant, P2_enchant_fail, P2_quantity, P2_status, P2_pos, P2_lasttime, P2_durability, P2_craft, P2_attr, P2_max_base_attr, P2_extra], _B46}
        end),
        {[P1_id, P1_send_time, P1_from_rid, P1_from_srv_id, P1_from_name, P1_to_rid, P1_to_srv_id, P1_to_name, P1_status, P1_subject, P1_content, P1_mailtype, P1_isatt, P1_assets, P1_attachment], _B47}
    end),
    {ok, {P0_mails}};

unpack(srv, 11710, _B0) ->
    {P0_to_name, _B1} = lib_proto:read_string(_B0),
    {P0_content, _B2} = lib_proto:read_string(_B1),
    {P0_sign, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_to_name, P0_content, P0_sign}};
unpack(cli, 11710, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_code, P0_msg}};

unpack(srv, 11711, _B0) ->
    {ok, {}};
unpack(cli, 11711, _B0) ->
    {P0_mails, _B6} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_to_name, _B2} = lib_proto:read_string(_B1),
        {P1_content, _B3} = lib_proto:read_string(_B2),
        {P1_send_time, _B4} = lib_proto:read_uint32(_B3),
        {P1_sign, _B5} = lib_proto:read_uint8(_B4),
        {[P1_to_name, P1_content, P1_send_time, P1_sign], _B5}
    end),
    {ok, {P0_mails}};

unpack(srv, 11712, _B0) ->
    {ok, {}};
unpack(cli, 11712, _B0) ->
    {P0_count, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_count}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
