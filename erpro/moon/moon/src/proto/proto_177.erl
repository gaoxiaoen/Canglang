%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_177).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("fate.hrl").
-include("item.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(17700), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17700:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17700), {P0_city}) ->
    D_a_t_a = <<?_((byte_size(P0_city)), "16"):16, ?_(P0_city, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17700:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17701), {P0_province, P0_city, P0_charm, P0_num}) ->
    D_a_t_a = <<?_((byte_size(P0_province)), "16"):16, ?_(P0_province, bin)/binary, ?_((byte_size(P0_city)), "16"):16, ?_(P0_city, bin)/binary, ?_(P0_charm, '32'):32, ?_(P0_num, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17701:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17701), {P0_city}) ->
    D_a_t_a = <<?_((byte_size(P0_city)), "16"):16, ?_(P0_city, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17701:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17702), {P0_name, P0_sex, P0_age, P0_star, P0_msg, P0_province, P0_city}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_sex, '8'):8, ?_(P0_age, '8'):8, ?_(P0_star, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_((byte_size(P0_province)), "16"):16, ?_(P0_province, bin)/binary, ?_((byte_size(P0_city)), "16"):16, ?_(P0_city, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17702:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17702), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17702:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17703), {P0_province, P0_city, P0_code, P0_msg}) ->
    D_a_t_a = <<?_((byte_size(P0_province)), "16"):16, ?_(P0_province, bin)/binary, ?_((byte_size(P0_city)), "16"):16, ?_(P0_city, bin)/binary, ?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17703:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17703), {P0_name, P0_sex, P0_age, P0_star, P0_msg, P0_province, P0_city}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_sex, '8'):8, ?_(P0_age, '8'):8, ?_(P0_star, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_((byte_size(P0_province)), "16"):16, ?_(P0_province, bin)/binary, ?_((byte_size(P0_city)), "16"):16, ?_(P0_city, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17703:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17704), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17704:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17704), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17704:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17705), {P0_rid, P0_srv_id, P0_name, P0_sex, P0_age, P0_vip, P0_hi, P0_charm, P0_career, P0_lev, P0_face, P0_power, P0_province, P0_city, P0_msg, P0_looks, P0_items}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_sex, '8'):8, ?_(P0_age, '8'):8, ?_(P0_vip, '8'):8, ?_(P0_hi, '32'):32, ?_(P0_charm, '32'):32, ?_(P0_career, '8'):8, ?_(P0_lev, '16'):16, ?_(P0_face, '32'):32, ?_(P0_power, '32'):32, ?_((byte_size(P0_province)), "16"):16, ?_(P0_province, bin)/binary, ?_((byte_size(P0_city)), "16"):16, ?_(P0_city, bin)/binary, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_((length(P0_looks)), "16"):16, (list_to_binary([<<?_(P1_looks_type, '8'):8, ?_(P1_looks_id, '32'):32, ?_(P1_looks_value, '16'):16>> || {P1_looks_type, P1_looks_id, P1_looks_value} <- P0_looks]))/binary, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_upgrade, '8'):8, ?_(P1_enchant, '8/signed'):8/signed, ?_(P1_enchant_fail, '8'):8, ?_(P1_pos, '16'):16, ?_(P1_lasttime, '32'):32, ?_(P1_durability, '32/signed'):32/signed, ?_(P1_craft, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary, ?_((length(P1_extra)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32, ?_((byte_size(P2_str)), "16"):16, ?_(P2_str, bin)/binary>> || {P2_type, P2_value, P2_str} <- P1_extra]))/binary>> || #item{id = P1_id, base_id = P1_base_id, bind = P1_bind, upgrade = P1_upgrade, enchant = P1_enchant, enchant_fail = P1_enchant_fail, pos = P1_pos, lasttime = P1_lasttime, durability = P1_durability, craft = P1_craft, attr = P1_attr, max_base_attr = P1_max_base_attr, extra = P1_extra} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17705:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17705), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17705:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17706), {P0_fate_list}) ->
    D_a_t_a = <<?_((length(P0_fate_list)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_sex, '8'):8, ?_(P1_age, '8'):8, ?_(P1_vip, '8'):8, ?_(P1_hi, '32'):32, ?_(P1_charm, '32'):32, ?_(P1_career, '8'):8, ?_(P1_lev, '16'):16, ?_(P1_face, '32'):32, ?_(P1_power, '32'):32, ?_((byte_size(P1_province)), "16"):16, ?_(P1_province, bin)/binary, ?_((byte_size(P1_city)), "16"):16, ?_(P1_city, bin)/binary, ?_((byte_size(P1_msg)), "16"):16, ?_(P1_msg, bin)/binary, ?_((length(P1_looks)), "16"):16, (list_to_binary([<<?_(P2_looks_type, '8'):8, ?_(P2_looks_id, '32'):32, ?_(P2_looks_value, '16'):16>> || {P2_looks_type, P2_looks_id, P2_looks_value} <- P1_looks]))/binary, ?_((length(P1_items)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_(P2_base_id, '32'):32, ?_(P2_bind, '8'):8, ?_(P2_upgrade, '8'):8, ?_(P2_enchant, '8/signed'):8/signed, ?_(P2_enchant_fail, '8'):8, ?_(P2_pos, '16'):16, ?_(P2_lasttime, '32'):32, ?_(P2_durability, '32/signed'):32/signed, ?_(P2_craft, '8'):8, ?_((length(P2_attr)), "16"):16, (list_to_binary([<<?_(P3_attr_name, '32'):32, ?_(P3_flag, '32'):32, ?_(P3_value, '32'):32>> || {P3_attr_name, P3_flag, P3_value} <- P2_attr]))/binary, ?_((length(P2_max_base_attr)), "16"):16, (list_to_binary([<<?_(P3_attr_name, '32'):32, ?_(P3_flag, '32'):32, ?_(P3_value, '32'):32>> || {P3_attr_name, P3_flag, P3_value} <- P2_max_base_attr]))/binary, ?_((length(P2_extra)), "16"):16, (list_to_binary([<<?_(P3_type, '16'):16, ?_(P3_value, '32'):32, ?_((byte_size(P3_str)), "16"):16, ?_(P3_str, bin)/binary>> || {P3_type, P3_value, P3_str} <- P2_extra]))/binary>> || #item{id = P2_id, base_id = P2_base_id, bind = P2_bind, upgrade = P2_upgrade, enchant = P2_enchant, enchant_fail = P2_enchant_fail, pos = P2_pos, lasttime = P2_lasttime, durability = P2_durability, craft = P2_craft, attr = P2_attr, max_base_attr = P2_max_base_attr, extra = P2_extra} <- P1_items]))/binary>> || {P1_rid, P1_srv_id, P1_name, P1_sex, P1_age, P1_vip, P1_hi, P1_charm, P1_career, P1_lev, P1_face, P1_power, P1_province, P1_city, P1_msg, P1_looks, P1_items} <- P0_fate_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17706:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17706), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17706:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17707), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17707:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17707), {P0_rid, P0_srv_id, P0_msg}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17707:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17708), {P0_rid, P0_srv_id, P0_name, P0_msg}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17708:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17708), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17708:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17709), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17709:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17709), {P0_rid, P0_srv_id, P0_agree_type}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_agree_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17709:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17710), {P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17710:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17710), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17710:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17711), {P0_online_type, P0_praise_num, P0_flower_num, P0_charm, P0_rid, P0_srv_id, P0_name, P0_sex, P0_career, P0_lev, P0_guild, P0_icon, P0_vip, P0_sign, P0_my_province, P0_my_city, P0_age, P0_star, P0_msg, P0_province, P0_city}) ->
    D_a_t_a = <<?_(P0_online_type, '8'):8, ?_(P0_praise_num, '16'):16, ?_(P0_flower_num, '16'):16, ?_(P0_charm, '32'):32, ?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_sex, '8'):8, ?_(P0_career, '8'):8, ?_(P0_lev, '8'):8, ?_((byte_size(P0_guild)), "16"):16, ?_(P0_guild, bin)/binary, ?_(P0_icon, '32'):32, ?_(P0_vip, '8'):8, ?_((byte_size(P0_sign)), "16"):16, ?_(P0_sign, bin)/binary, ?_((byte_size(P0_my_province)), "16"):16, ?_(P0_my_province, bin)/binary, ?_((byte_size(P0_my_city)), "16"):16, ?_(P0_my_city, bin)/binary, ?_(P0_age, '8'):8, ?_(P0_star, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_((byte_size(P0_province)), "16"):16, ?_(P0_province, bin)/binary, ?_((byte_size(P0_city)), "16"):16, ?_(P0_city, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17711:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17711), {P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17711:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17712), {P0_rid, P0_srv_id, P0_name, P0_sex, P0_vip, P0_realm, P0_special, P0_msg}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_sex, '8'):8, ?_(P0_vip, '8'):8, ?_(P0_realm, '8'):8, ?_((length(P0_special)), "16"):16, (list_to_binary([<<?_(P1_label, '32'):32>> || P1_label <- P0_special]))/binary, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17712:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17712), {P0_rid, P0_srv_id, P0_msg}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17712:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17713), {P0_type, P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17713:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17713), {P0_rid, P0_srv_id, P0_type}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17713:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17714), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17714:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17714), {P0_rid, P0_srv_id, P0_type}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17714:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17715), {P0_rid, P0_srv_id, P0_name, P0_type}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17715:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17715), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17715:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17716), {P0_rid, P0_srv_id, P0_type, P0_time, P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_type, '8'):8, ?_(P0_time, '32'):32, ?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17716:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17716), {P0_rid, P0_srv_id, P0_type, P0_agree_type}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_type, '8'):8, ?_(P0_agree_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17716:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17717), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17717:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17717), {P0_type, P0_val}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_val, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17717:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17718), {P0_type, P0_val1, P0_val2, P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_val1, '8'):8, ?_(P0_val2, '8'):8, ?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17718:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17718), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17718:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17719), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17719:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17719), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17719:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17720), {P0_val1, P0_val2}) ->
    D_a_t_a = <<?_(P0_val1, '8'):8, ?_(P0_val2, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17720:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17720), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17720:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
