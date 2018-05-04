%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_100).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("assets.hrl").
-include("item.hrl").
-include("channel.hrl").
-include("manor.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(10000), {P0_role_id, P0_srv_id, P0_name, P0_lev, P0_career, P0_portrait, P0_sex, P0_mod, P0_vip_type, P0_guild_name, P0_exp, P0_exp_need, P0_hp, P0_mp, P0_hp_max, P0_mp_max, P0_dmg_min, P0_dmg_max, P0_dmg_magic, P0_defence, P0_evasion, P0_hitrate, P0_critrate, P0_tenacity, P0_js, P0_aspd, P0_resist, P0_fight_capacity, P0_move_speed, P0_dir, P0_x, P0_y, P0_looks, P0_special}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_lev, '8'):8, ?_(P0_career, '8'):8, ?_(P0_portrait, '16'):16, ?_(P0_sex, '8'):8, ?_(P0_mod, '8'):8, ?_(P0_vip_type, '8'):8, ?_((byte_size(P0_guild_name)), "16"):16, ?_(P0_guild_name, bin)/binary, ?_(P0_exp, '32'):32, ?_(P0_exp_need, '32'):32, ?_(P0_hp, '32'):32, ?_(P0_mp, '32'):32, ?_(P0_hp_max, '32'):32, ?_(P0_mp_max, '32'):32, ?_(P0_dmg_min, '32'):32, ?_(P0_dmg_max, '32'):32, ?_(P0_dmg_magic, '32'):32, ?_(P0_defence, '32'):32, ?_(P0_evasion, '16'):16, ?_(P0_hitrate, '16'):16, ?_(P0_critrate, '16'):16, ?_(P0_tenacity, '16'):16, ?_(P0_js, '16'):16, ?_(P0_aspd, '16'):16, ?_(P0_resist, '32'):32, ?_(P0_fight_capacity, '32'):32, ?_(P0_move_speed, '16'):16, ?_(P0_dir, '8'):8, ?_(P0_x, '16'):16, ?_(P0_y, '16'):16, ?_((length(P0_looks)), "16"):16, (list_to_binary([<<?_(P1_looks_type, '8'):8, ?_(P1_looks_id, '32'):32, ?_(P1_looks_value, '16'):16>> || {P1_looks_type, P1_looks_id, P1_looks_value} <- P0_looks]))/binary, ?_((length(P0_special)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_val_int, '32'):32, ?_((byte_size(P1_val_str)), "16"):16, ?_(P1_val_str, bin)/binary>> || {P1_type, P1_val_int, P1_val_str} <- P0_special]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10000:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10000), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10000:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10002), {P0_lev, P0_exp_need, P0_exp, P0_gold_bind, P0_coin, P0_gold, P0_energy, P0_attainment, P0_stone, P0_badge, P0_honor}) ->
    D_a_t_a = <<?_(P0_lev, '16'):16, ?_(P0_exp_need, '32'):32, ?_(P0_exp, '32'):32, ?_(P0_gold_bind, '32'):32, ?_(P0_coin, '32'):32, ?_(P0_gold, '32'):32, ?_(P0_energy, '32'):32, ?_(P0_attainment, '32'):32, ?_(P0_stone, '32'):32, ?_(P0_badge, '32'):32, ?_(P0_honor, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10002:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10002), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10002:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10003), {P0_hp, P0_mp, P0_hp_max, P0_mp_max, P0_dmg_min, P0_dmg_max, P0_defence, P0_evasion, P0_hitrate, P0_critrate, P0_js, P0_aspd, P0_resist, P0_fight_capacity}) ->
    D_a_t_a = <<?_(P0_hp, '32'):32, ?_(P0_mp, '32'):32, ?_(P0_hp_max, '32'):32, ?_(P0_mp_max, '32'):32, ?_(P0_dmg_min, '32'):32, ?_(P0_dmg_max, '32'):32, ?_(P0_defence, '32'):32, ?_(P0_evasion, '16'):16, ?_(P0_hitrate, '16'):16, ?_(P0_critrate, '16'):16, ?_(P0_js, '16'):16, ?_(P0_aspd, '16'):16, ?_(P0_resist, '32'):32, ?_(P0_fight_capacity, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10003:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10003), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10003:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10004), {P0_id, P0_srv_id, P0_name, P0_sex, P0_face_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_sex, '16'):16, ?_(P0_face_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10004:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10004), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10004:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10005), {P0_map_val, P0_attrs}) ->
    D_a_t_a = <<?_(P0_map_val, '32'):32, ?_((length(P0_attrs)), "16"):16, (list_to_binary([<<?_(P1_value, '32'):32>> || P1_value <- P0_attrs]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10005:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10005), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10005:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10006), {P0_attrs}) ->
    D_a_t_a = <<?_((length(P0_attrs)), "16"):16, (list_to_binary([<<?_(P1_key, '8'):8, ?_(P1_value, '32'):32>> || {P1_key, P1_value} <- P0_attrs]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10006:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10006), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10006:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10007), {P0_id, P0_srv_id, P0_info_id, P0_msg}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_info_id, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10007:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10007), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10007:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10010), {P0_id, P0_srv_id, P0_name, P0_lev, P0_career, P0_portrait, P0_sex, P0_attainment, P0_activity, P0_activity_max, P0_vip_type, P0_guild_name, P0_hp, P0_mp, P0_hp_max, P0_mp_max, P0_dmg_min, P0_dmg_max, P0_dmg_magic, P0_defence, P0_evasion, P0_hitrate, P0_critrate, P0_tenacity, P0_js, P0_aspd, P0_resist, P0_fight_capacity, P0_pet_fight_capacity, P0_souls, P0_items, P0_moyao, P0_looks}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_lev, '8'):8, ?_(P0_career, '8'):8, ?_(P0_portrait, '16'):16, ?_(P0_sex, '8'):8, ?_(P0_attainment, '32'):32, ?_(P0_activity, '32'):32, ?_(P0_activity_max, '32'):32, ?_(P0_vip_type, '8'):8, ?_((byte_size(P0_guild_name)), "16"):16, ?_(P0_guild_name, bin)/binary, ?_(P0_hp, '32'):32, ?_(P0_mp, '32'):32, ?_(P0_hp_max, '32'):32, ?_(P0_mp_max, '32'):32, ?_(P0_dmg_min, '32'):32, ?_(P0_dmg_max, '32'):32, ?_(P0_dmg_magic, '32'):32, ?_(P0_defence, '32'):32, ?_(P0_evasion, '16'):16, ?_(P0_hitrate, '16'):16, ?_(P0_critrate, '16'):16, ?_(P0_tenacity, '16'):16, ?_(P0_js, '16'):16, ?_(P0_aspd, '16'):16, ?_(P0_resist, '32'):32, ?_(P0_fight_capacity, '32'):32, ?_(P0_pet_fight_capacity, '32'):32, ?_((length(P0_souls)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_state, '8'):8>> || #role_channel{id = P1_id, lev = P1_lev, state = P1_state} <- P0_souls]))/binary, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_enchant, '8/signed'):8/signed, ?_(P1_pos, '16'):16, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary, ?_((length(P1_extra)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32, ?_((byte_size(P2_str)), "16"):16, ?_(P2_str, bin)/binary>> || {P2_type, P2_value, P2_str} <- P1_extra]))/binary, ?_((length(P1_special)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32>> || {P2_type, P2_value} <- P1_special]))/binary>> || #item{id = P1_id, base_id = P1_base_id, bind = P1_bind, enchant = P1_enchant, pos = P1_pos, attr = P1_attr, max_base_attr = P1_max_base_attr, extra = P1_extra, special = P1_special} <- P0_items]))/binary, ?_((length(P0_moyao)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_num, '16'):16>> || #has_eat_yao{id = P1_id, num = P1_num} <- P0_moyao]))/binary, ?_((length(P0_looks)), "16"):16, (list_to_binary([<<?_(P1_looks_type, '8'):8, ?_(P1_looks_id, '32'):32, ?_(P1_looks_value, '16'):16>> || {P1_looks_type, P1_looks_id, P1_looks_value} <- P0_looks]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10010:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10010), {P0_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10010:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10011), {P0_id, P0_srv_id, P0_status, P0_status_action, P0_status_ride, P0_status_huodong, P0_status_jiaoyi}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_status, '8'):8, ?_(P0_status_action, '8'):8, ?_(P0_status_ride, '8'):8, ?_(P0_status_huodong, '8'):8, ?_(P0_status_jiaoyi, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10011:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10011), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10011:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10015), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10015:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10015), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10015:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10016), {P0_ret, P0_mod, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_(P0_mod, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10016:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10016), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10016:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10017), {P0_mod, P0_msg}) ->
    D_a_t_a = <<?_(P0_mod, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10017:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10017), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10017:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10018), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10018:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10018), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10018:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10019), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10019:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10019), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10019:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10020), {P0_result, P0_msg, P0_career, P0_portrait}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_career, '8'):8, ?_(P0_portrait, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10020:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10020), {P0_career}) ->
    D_a_t_a = <<?_(P0_career, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10020:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10021), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10021:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10021), {P0_type, P0_map, P0_x, P0_y}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_map, '32'):32, ?_(P0_x, '16'):16, ?_(P0_y, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10021:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10022), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10022:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10022), {P0_name}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10022:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10023), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10023:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10023), {P0_notice_1, P0_notice_2}) ->
    D_a_t_a = <<?_(P0_notice_1, '8'):8, ?_(P0_notice_2, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10023:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10024), {P0_list}) ->
    D_a_t_a = <<?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_(P1_to_base_id, '32'):32>> || {P1_base_id, P1_to_base_id} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10024:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10024), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10024:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10025), {P0_result, P0_realm, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_realm, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10025:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10025), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10025:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10026), {P0_realm_a_cnt, P0_realm_b_cnt, P0_cnt}) ->
    D_a_t_a = <<?_(P0_realm_a_cnt, '16'):16, ?_(P0_realm_b_cnt, '16'):16, ?_(P0_cnt, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10026:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10026), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10026:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10030), {P0_lev_rank, P0_fight_rank, P0_channel_score, P0_foster_o, P0_farm_o}) ->
    D_a_t_a = <<?_(P0_lev_rank, '32'):32, ?_(P0_fight_rank, '32'):32, ?_(P0_channel_score, '32'):32, ?_(P0_foster_o, '8'):8, ?_(P0_farm_o, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10030:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10030), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10030:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10031), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10031:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10031), {P0_name}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10031:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10032), {P0_page, P0_total_page, P0_list}) ->
    D_a_t_a = <<?_(P0_page, '32'):32, ?_(P0_total_page, '32'):32, ?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name_used)), "16"):16, ?_(P1_name_used, bin)/binary, ?_((byte_size(P1_new_name)), "16"):16, ?_(P1_new_name, bin)/binary, ?_(P1_sex, '8'):8, ?_(P1_career, '8'):8, ?_(P1_realm, '8'):8, ?_(P1_vip, '8'):8, ?_(P1_ctime, '32'):32>> || {P1_rid, P1_srv_id, P1_name_used, P1_new_name, P1_sex, P1_career, P1_realm, P1_vip, P1_ctime} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10032:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10032), {P0_page}) ->
    D_a_t_a = <<?_(P0_page, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10032:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 10000, _B0) ->
    {ok, {}};
unpack(cli, 10000, _B0) ->
    {P0_role_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_name, _B3} = lib_proto:read_string(_B2),
    {P0_lev, _B4} = lib_proto:read_uint8(_B3),
    {P0_career, _B5} = lib_proto:read_uint8(_B4),
    {P0_portrait, _B6} = lib_proto:read_uint16(_B5),
    {P0_sex, _B7} = lib_proto:read_uint8(_B6),
    {P0_mod, _B8} = lib_proto:read_uint8(_B7),
    {P0_vip_type, _B9} = lib_proto:read_uint8(_B8),
    {P0_guild_name, _B10} = lib_proto:read_string(_B9),
    {P0_exp, _B11} = lib_proto:read_uint32(_B10),
    {P0_exp_need, _B12} = lib_proto:read_uint32(_B11),
    {P0_hp, _B13} = lib_proto:read_uint32(_B12),
    {P0_mp, _B14} = lib_proto:read_uint32(_B13),
    {P0_hp_max, _B15} = lib_proto:read_uint32(_B14),
    {P0_mp_max, _B16} = lib_proto:read_uint32(_B15),
    {P0_dmg_min, _B17} = lib_proto:read_uint32(_B16),
    {P0_dmg_max, _B18} = lib_proto:read_uint32(_B17),
    {P0_dmg_magic, _B19} = lib_proto:read_uint32(_B18),
    {P0_defence, _B20} = lib_proto:read_uint32(_B19),
    {P0_evasion, _B21} = lib_proto:read_uint16(_B20),
    {P0_hitrate, _B22} = lib_proto:read_uint16(_B21),
    {P0_critrate, _B23} = lib_proto:read_uint16(_B22),
    {P0_tenacity, _B24} = lib_proto:read_uint16(_B23),
    {P0_js, _B25} = lib_proto:read_uint16(_B24),
    {P0_aspd, _B26} = lib_proto:read_uint16(_B25),
    {P0_resist, _B27} = lib_proto:read_uint32(_B26),
    {P0_fight_capacity, _B28} = lib_proto:read_uint32(_B27),
    {P0_move_speed, _B29} = lib_proto:read_uint16(_B28),
    {P0_dir, _B30} = lib_proto:read_uint8(_B29),
    {P0_x, _B31} = lib_proto:read_uint16(_B30),
    {P0_y, _B32} = lib_proto:read_uint16(_B31),
    {P0_looks, _B37} = lib_proto:read_array(_B32, fun(_B33) ->
        {P1_looks_type, _B34} = lib_proto:read_uint8(_B33),
        {P1_looks_id, _B35} = lib_proto:read_uint32(_B34),
        {P1_looks_value, _B36} = lib_proto:read_uint16(_B35),
        {[P1_looks_type, P1_looks_id, P1_looks_value], _B36}
    end),
    {P0_special, _B42} = lib_proto:read_array(_B37, fun(_B38) ->
        {P1_type, _B39} = lib_proto:read_uint8(_B38),
        {P1_val_int, _B40} = lib_proto:read_uint32(_B39),
        {P1_val_str, _B41} = lib_proto:read_string(_B40),
        {[P1_type, P1_val_int, P1_val_str], _B41}
    end),
    {ok, {P0_role_id, P0_srv_id, P0_name, P0_lev, P0_career, P0_portrait, P0_sex, P0_mod, P0_vip_type, P0_guild_name, P0_exp, P0_exp_need, P0_hp, P0_mp, P0_hp_max, P0_mp_max, P0_dmg_min, P0_dmg_max, P0_dmg_magic, P0_defence, P0_evasion, P0_hitrate, P0_critrate, P0_tenacity, P0_js, P0_aspd, P0_resist, P0_fight_capacity, P0_move_speed, P0_dir, P0_x, P0_y, P0_looks, P0_special}};

unpack(srv, 10002, _B0) ->
    {ok, {}};
unpack(cli, 10002, _B0) ->
    {P0_lev, _B1} = lib_proto:read_uint16(_B0),
    {P0_exp_need, _B2} = lib_proto:read_uint32(_B1),
    {P0_exp, _B3} = lib_proto:read_uint32(_B2),
    {P0_gold_bind, _B4} = lib_proto:read_uint32(_B3),
    {P0_coin, _B5} = lib_proto:read_uint32(_B4),
    {P0_gold, _B6} = lib_proto:read_uint32(_B5),
    {P0_energy, _B7} = lib_proto:read_uint32(_B6),
    {P0_attainment, _B8} = lib_proto:read_uint32(_B7),
    {P0_stone, _B9} = lib_proto:read_uint32(_B8),
    {P0_badge, _B10} = lib_proto:read_uint32(_B9),
    {P0_honor, _B11} = lib_proto:read_uint32(_B10),
    {ok, {P0_lev, P0_exp_need, P0_exp, P0_gold_bind, P0_coin, P0_gold, P0_energy, P0_attainment, P0_stone, P0_badge, P0_honor}};

unpack(srv, 10003, _B0) ->
    {ok, {}};
unpack(cli, 10003, _B0) ->
    {P0_hp, _B1} = lib_proto:read_uint32(_B0),
    {P0_mp, _B2} = lib_proto:read_uint32(_B1),
    {P0_hp_max, _B3} = lib_proto:read_uint32(_B2),
    {P0_mp_max, _B4} = lib_proto:read_uint32(_B3),
    {P0_dmg_min, _B5} = lib_proto:read_uint32(_B4),
    {P0_dmg_max, _B6} = lib_proto:read_uint32(_B5),
    {P0_defence, _B7} = lib_proto:read_uint32(_B6),
    {P0_evasion, _B8} = lib_proto:read_uint16(_B7),
    {P0_hitrate, _B9} = lib_proto:read_uint16(_B8),
    {P0_critrate, _B10} = lib_proto:read_uint16(_B9),
    {P0_js, _B11} = lib_proto:read_uint16(_B10),
    {P0_aspd, _B12} = lib_proto:read_uint16(_B11),
    {P0_resist, _B13} = lib_proto:read_uint32(_B12),
    {P0_fight_capacity, _B14} = lib_proto:read_uint32(_B13),
    {ok, {P0_hp, P0_mp, P0_hp_max, P0_mp_max, P0_dmg_min, P0_dmg_max, P0_defence, P0_evasion, P0_hitrate, P0_critrate, P0_js, P0_aspd, P0_resist, P0_fight_capacity}};

unpack(srv, 10004, _B0) ->
    {ok, {}};
unpack(cli, 10004, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_name, _B3} = lib_proto:read_string(_B2),
    {P0_sex, _B4} = lib_proto:read_uint16(_B3),
    {P0_face_id, _B5} = lib_proto:read_uint16(_B4),
    {ok, {P0_id, P0_srv_id, P0_name, P0_sex, P0_face_id}};

unpack(srv, 10005, _B0) ->
    {ok, {}};
unpack(cli, 10005, _B0) ->
    {P0_map_val, _B1} = lib_proto:read_uint32(_B0),
    {P0_attrs, _B4} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_value, _B3} = lib_proto:read_uint32(_B2),
        {P1_value, _B3}
    end),
    {ok, {P0_map_val, P0_attrs}};

unpack(srv, 10006, _B0) ->
    {ok, {}};
unpack(cli, 10006, _B0) ->
    {P0_attrs, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_key, _B2} = lib_proto:read_uint8(_B1),
        {P1_value, _B3} = lib_proto:read_uint32(_B2),
        {[P1_key, P1_value], _B3}
    end),
    {ok, {P0_attrs}};

unpack(srv, 10007, _B0) ->
    {ok, {}};
unpack(cli, 10007, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_info_id, _B3} = lib_proto:read_uint8(_B2),
    {P0_msg, _B4} = lib_proto:read_string(_B3),
    {ok, {P0_id, P0_srv_id, P0_info_id, P0_msg}};

unpack(srv, 10010, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_id, P0_srv_id}};
unpack(cli, 10010, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_name, _B3} = lib_proto:read_string(_B2),
    {P0_lev, _B4} = lib_proto:read_uint8(_B3),
    {P0_career, _B5} = lib_proto:read_uint8(_B4),
    {P0_portrait, _B6} = lib_proto:read_uint16(_B5),
    {P0_sex, _B7} = lib_proto:read_uint8(_B6),
    {P0_attainment, _B8} = lib_proto:read_uint32(_B7),
    {P0_activity, _B9} = lib_proto:read_uint32(_B8),
    {P0_activity_max, _B10} = lib_proto:read_uint32(_B9),
    {P0_vip_type, _B11} = lib_proto:read_uint8(_B10),
    {P0_guild_name, _B12} = lib_proto:read_string(_B11),
    {P0_hp, _B13} = lib_proto:read_uint32(_B12),
    {P0_mp, _B14} = lib_proto:read_uint32(_B13),
    {P0_hp_max, _B15} = lib_proto:read_uint32(_B14),
    {P0_mp_max, _B16} = lib_proto:read_uint32(_B15),
    {P0_dmg_min, _B17} = lib_proto:read_uint32(_B16),
    {P0_dmg_max, _B18} = lib_proto:read_uint32(_B17),
    {P0_dmg_magic, _B19} = lib_proto:read_uint32(_B18),
    {P0_defence, _B20} = lib_proto:read_uint32(_B19),
    {P0_evasion, _B21} = lib_proto:read_uint16(_B20),
    {P0_hitrate, _B22} = lib_proto:read_uint16(_B21),
    {P0_critrate, _B23} = lib_proto:read_uint16(_B22),
    {P0_tenacity, _B24} = lib_proto:read_uint16(_B23),
    {P0_js, _B25} = lib_proto:read_uint16(_B24),
    {P0_aspd, _B26} = lib_proto:read_uint16(_B25),
    {P0_resist, _B27} = lib_proto:read_uint32(_B26),
    {P0_fight_capacity, _B28} = lib_proto:read_uint32(_B27),
    {P0_pet_fight_capacity, _B29} = lib_proto:read_uint32(_B28),
    {P0_souls, _B34} = lib_proto:read_array(_B29, fun(_B30) ->
        {P1_id, _B31} = lib_proto:read_uint8(_B30),
        {P1_lev, _B32} = lib_proto:read_uint8(_B31),
        {P1_state, _B33} = lib_proto:read_uint8(_B32),
        {[P1_id, P1_lev, P1_state], _B33}
    end),
    {P0_items, _B60} = lib_proto:read_array(_B34, fun(_B35) ->
        {P1_id, _B36} = lib_proto:read_uint32(_B35),
        {P1_base_id, _B37} = lib_proto:read_uint32(_B36),
        {P1_bind, _B38} = lib_proto:read_uint8(_B37),
        {P1_enchant, _B39} = lib_proto:read_int8(_B38),
        {P1_pos, _B40} = lib_proto:read_uint16(_B39),
        {P1_attr, _B45} = lib_proto:read_array(_B40, fun(_B41) ->
            {P2_attr_name, _B42} = lib_proto:read_uint32(_B41),
            {P2_flag, _B43} = lib_proto:read_uint32(_B42),
            {P2_value, _B44} = lib_proto:read_uint32(_B43),
            {[P2_attr_name, P2_flag, P2_value], _B44}
        end),
        {P1_max_base_attr, _B50} = lib_proto:read_array(_B45, fun(_B46) ->
            {P2_attr_name, _B47} = lib_proto:read_uint32(_B46),
            {P2_flag, _B48} = lib_proto:read_uint32(_B47),
            {P2_value, _B49} = lib_proto:read_uint32(_B48),
            {[P2_attr_name, P2_flag, P2_value], _B49}
        end),
        {P1_extra, _B55} = lib_proto:read_array(_B50, fun(_B51) ->
            {P2_type, _B52} = lib_proto:read_uint16(_B51),
            {P2_value, _B53} = lib_proto:read_uint32(_B52),
            {P2_str, _B54} = lib_proto:read_string(_B53),
            {[P2_type, P2_value, P2_str], _B54}
        end),
        {P1_special, _B59} = lib_proto:read_array(_B55, fun(_B56) ->
            {P2_type, _B57} = lib_proto:read_uint16(_B56),
            {P2_value, _B58} = lib_proto:read_uint32(_B57),
            {[P2_type, P2_value], _B58}
        end),
        {[P1_id, P1_base_id, P1_bind, P1_enchant, P1_pos, P1_attr, P1_max_base_attr, P1_extra, P1_special], _B59}
    end),
    {P0_moyao, _B64} = lib_proto:read_array(_B60, fun(_B61) ->
        {P1_id, _B62} = lib_proto:read_uint32(_B61),
        {P1_num, _B63} = lib_proto:read_uint16(_B62),
        {[P1_id, P1_num], _B63}
    end),
    {P0_looks, _B69} = lib_proto:read_array(_B64, fun(_B65) ->
        {P1_looks_type, _B66} = lib_proto:read_uint8(_B65),
        {P1_looks_id, _B67} = lib_proto:read_uint32(_B66),
        {P1_looks_value, _B68} = lib_proto:read_uint16(_B67),
        {[P1_looks_type, P1_looks_id, P1_looks_value], _B68}
    end),
    {ok, {P0_id, P0_srv_id, P0_name, P0_lev, P0_career, P0_portrait, P0_sex, P0_attainment, P0_activity, P0_activity_max, P0_vip_type, P0_guild_name, P0_hp, P0_mp, P0_hp_max, P0_mp_max, P0_dmg_min, P0_dmg_max, P0_dmg_magic, P0_defence, P0_evasion, P0_hitrate, P0_critrate, P0_tenacity, P0_js, P0_aspd, P0_resist, P0_fight_capacity, P0_pet_fight_capacity, P0_souls, P0_items, P0_moyao, P0_looks}};

unpack(srv, 10011, _B0) ->
    {ok, {}};
unpack(cli, 10011, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_status, _B3} = lib_proto:read_uint8(_B2),
    {P0_status_action, _B4} = lib_proto:read_uint8(_B3),
    {P0_status_ride, _B5} = lib_proto:read_uint8(_B4),
    {P0_status_huodong, _B6} = lib_proto:read_uint8(_B5),
    {P0_status_jiaoyi, _B7} = lib_proto:read_uint8(_B6),
    {ok, {P0_id, P0_srv_id, P0_status, P0_status_action, P0_status_ride, P0_status_huodong, P0_status_jiaoyi}};

unpack(srv, 10018, _B0) ->
    {ok, {}};
unpack(cli, 10018, _B0) ->
    {ok, {}};

unpack(srv, 10019, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_type}};
unpack(cli, 10019, _B0) ->
    {ok, {}};

unpack(srv, 10020, _B0) ->
    {P0_career, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_career}};
unpack(cli, 10020, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {P0_career, _B3} = lib_proto:read_uint8(_B2),
    {P0_portrait, _B4} = lib_proto:read_uint16(_B3),
    {ok, {P0_result, P0_msg, P0_career, P0_portrait}};

unpack(srv, 10022, _B0) ->
    {P0_name, _B1} = lib_proto:read_string(_B0),
    {ok, {P0_name}};
unpack(cli, 10022, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_result, P0_msg}};

unpack(srv, 10024, _B0) ->
    {ok, {}};
unpack(cli, 10024, _B0) ->
    {P0_list, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_base_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_to_base_id, _B3} = lib_proto:read_uint32(_B2),
        {[P1_base_id, P1_to_base_id], _B3}
    end),
    {ok, {P0_list}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
