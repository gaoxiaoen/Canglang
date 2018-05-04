%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_110).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("rank.hrl").
-include("item.hrl").
-include("world_compete.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(11000), {P0_total_page, P0_i_lev_list}) ->
    D_a_t_a = <<?_(P0_total_page, '8'):8, ?_((length(P0_i_lev_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8>> || #rank_role_lev{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, guild = P1_guild, lev = P1_lev, vip = P1_vip, realm = P1_realm} <- P0_i_lev_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11000:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11000), {P0_page_index}) ->
    D_a_t_a = <<?_(P0_page_index, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11000:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11001), {P0_i_coin_list}) ->
    D_a_t_a = <<?_((length(P0_i_coin_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_coin, '32'):32, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8>> || #rank_role_coin{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, guild = P1_guild, coin = P1_coin, vip = P1_vip, realm = P1_realm} <- P0_i_coin_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11001:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11001), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11001:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11004), {P0_i_pet_list}) ->
    D_a_t_a = <<?_((length(P0_i_pet_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_color, '8'):8, ?_((byte_size(P1_petname)), "16"):16, ?_(P1_petname, bin)/binary, ?_(P1_petlev, '8'):8, ?_(P1_aptitude, '8'):8, ?_(P1_growrate, '8'):8, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8, ?_(P1_petrb, '32'):32>> || #rank_role_pet{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, color = P1_color, petname = P1_petname, petlev = P1_petlev, aptitude = P1_aptitude, growrate = P1_growrate, vip = P1_vip, realm = P1_realm, petrb = P1_petrb} <- P0_i_pet_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11004:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11004), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11004:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11005), {P0_i_achieve_list}) ->
    D_a_t_a = <<?_((length(P0_i_achieve_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_achieve, '32'):32, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8>> || #rank_role_achieve{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, guild = P1_guild, achieve = P1_achieve, vip = P1_vip, realm = P1_realm} <- P0_i_achieve_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11005:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11005), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11005:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11006), {P0_total_page, P0_i_power_list}) ->
    D_a_t_a = <<?_(P0_total_page, '8'):8, ?_((length(P0_i_power_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_power, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8>> || #rank_role_power{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, guild = P1_guild, power = P1_power, lev = P1_lev, vip = P1_vip, realm = P1_realm} <- P0_i_power_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11006:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11006), {P0_page_index}) ->
    D_a_t_a = <<?_(P0_page_index, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11006:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11007), {P0_i_soul_list}) ->
    D_a_t_a = <<?_((length(P0_i_soul_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_soul, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8>> || #rank_role_soul{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, guild = P1_guild, soul = P1_soul, lev = P1_lev, vip = P1_vip, realm = P1_realm} <- P0_i_soul_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11007:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11007), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11007:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11008), {P0_i_skill_list}) ->
    D_a_t_a = <<?_((length(P0_i_skill_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_skill, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8>> || #rank_role_skill{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, guild = P1_guild, skill = P1_skill, lev = P1_lev, vip = P1_vip, realm = P1_realm} <- P0_i_skill_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11008:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11008), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11008:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11009), {P0_total_page, P0_i_pet_list}) ->
    D_a_t_a = <<?_(P0_total_page, '8'):8, ?_((length(P0_i_pet_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_color, '8'):8, ?_((byte_size(P1_petname)), "16"):16, ?_(P1_petname, bin)/binary, ?_(P1_petlev, '8'):8, ?_(P1_power, '32'):32, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8, ?_(P1_petrb, '32'):32>> || #rank_role_pet_power{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, color = P1_color, petname = P1_petname, petlev = P1_petlev, power = P1_power, guild = P1_guild, vip = P1_vip, realm = P1_realm, petrb = P1_petrb} <- P0_i_pet_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11009:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11009), {P0_page_index}) ->
    D_a_t_a = <<?_(P0_page_index, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11009:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11010), {P0_i_pet_list}) ->
    D_a_t_a = <<?_((length(P0_i_pet_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_color, '8'):8, ?_((byte_size(P1_petname)), "16"):16, ?_(P1_petname, bin)/binary, ?_(P1_petlev, '8'):8, ?_(P1_power, '32'):32, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8>> || #rank_cross_role_pet_power{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, color = P1_color, petname = P1_petname, petlev = P1_petlev, power = P1_power, vip = P1_vip, realm = P1_realm} <- P0_i_pet_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11010:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11010), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11010:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11011), {P0_total_page, P0_e_arms_list}) ->
    D_a_t_a = <<?_(P0_total_page, '8'):8, ?_((length(P0_e_arms_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_((byte_size(P1_arms)), "16"):16, ?_(P1_arms, bin)/binary, ?_(P1_score, '32'):32, ?_(P1_vip, '8'):8, ?_(P1_quality, '8'):8, ?_(P1_realm, '8'):8>> || #rank_equip_arms{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, guild = P1_guild, arms = P1_arms, score = P1_score, vip = P1_vip, quality = P1_quality, realm = P1_realm} <- P0_e_arms_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11011:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11011), {P0_page_index}) ->
    D_a_t_a = <<?_(P0_page_index, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11011:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11012), {P0_total_page, P0_e_armor_list}) ->
    D_a_t_a = <<?_(P0_total_page, '8'):8, ?_((length(P0_e_armor_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_((byte_size(P1_armor)), "16"):16, ?_(P1_armor, bin)/binary, ?_(P1_score, '32'):32, ?_(P1_vip, '8'):8, ?_(P1_quality, '8'):8, ?_(P1_realm, '8'):8>> || {P1_srv_id, P1_rid, P1_name, P1_career, P1_sex, P1_guild, P1_armor, P1_score, P1_vip, P1_quality, P1_realm} <- P0_e_armor_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11012:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11012), {P0_page_index}) ->
    D_a_t_a = <<?_(P0_page_index, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11012:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11013), {P0_mount_power_list}) ->
    D_a_t_a = <<?_((length(P0_mount_power_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_((byte_size(P1_mount)), "16"):16, ?_(P1_mount, bin)/binary, ?_(P1_step, '32'):32, ?_(P1_mount_lev, '32'):32, ?_(P1_quality, '8'):8, ?_(P1_power, '32'):32, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8>> || #rank_mount_power{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, guild = P1_guild, mount = P1_mount, step = P1_step, mount_lev = P1_mount_lev, quality = P1_quality, power = P1_power, vip = P1_vip, realm = P1_realm} <- P0_mount_power_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11013:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11013), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11013:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11014), {P0_mount_power_list}) ->
    D_a_t_a = <<?_((length(P0_mount_power_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_((byte_size(P1_mount)), "16"):16, ?_(P1_mount, bin)/binary, ?_(P1_step, '32'):32, ?_(P1_mount_lev, '32'):32, ?_(P1_quality, '8'):8, ?_(P1_power, '32'):32, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8>> || #rank_cross_mount_power{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, guild = P1_guild, mount = P1_mount, step = P1_step, mount_lev = P1_mount_lev, quality = P1_quality, power = P1_power, vip = P1_vip, realm = P1_realm} <- P0_mount_power_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11014:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11014), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11014:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11015), {P0_my_score, P0_rank_practice}) ->
    D_a_t_a = <<?_(P0_my_score, '32'):32, ?_((length(P0_rank_practice)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_lev, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_score, '32'):32, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8>> || #rank_practice{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, lev = P1_lev, guild = P1_guild, score = P1_score, vip = P1_vip, realm = P1_realm} <- P0_rank_practice]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11015:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11015), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11015:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11018), {P0_type, P0_page_index}) ->
    D_a_t_a = <<?_(P0_type, '16'):16, ?_(P0_page_index, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11018:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11018), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11018:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11019), {P0_page_index}) ->
    D_a_t_a = <<?_(P0_page_index, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11019:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11019), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11019:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11020), {P0_total_page, P0_g_lev_list}) ->
    D_a_t_a = <<?_(P0_total_page, '8'):8, ?_((length(P0_g_lev_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_icon, '32'):32, ?_((byte_size(P1_cName)), "16"):16, ?_(P1_cName, bin)/binary, ?_(P1_lev, '8'):8, ?_(P1_fund, '32'):32, ?_(P1_num, '8'):8, ?_((byte_size(P1_chief_srv_id)), "16"):16, ?_(P1_chief_srv_id, bin)/binary, ?_(P1_chief_rid, '32'):32, ?_(P1_realm, '8'):8>> || #rank_guild_lev{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, icon = P1_icon, cName = P1_cName, lev = P1_lev, fund = P1_fund, num = P1_num, chief_srv_id = P1_chief_srv_id, chief_rid = P1_chief_rid, realm = P1_realm} <- P0_g_lev_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11020:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11020), {P0_page_index}) ->
    D_a_t_a = <<?_(P0_page_index, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11020:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11021), {P0_g_combat_list}) ->
    D_a_t_a = <<?_((length(P0_g_combat_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_((byte_size(P1_cName)), "16"):16, ?_(P1_cName, bin)/binary, ?_(P1_icon, '32'):32, ?_(P1_accScore, '32'):32, ?_(P1_score, '32'):32, ?_(P1_lev, '8'):8>> || #rank_guild_combat{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, cName = P1_cName, icon = P1_icon, accScore = P1_accScore, score = P1_score, lev = P1_lev} <- P0_g_combat_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11021:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11021), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11021:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11022), {P0_g_last_list}) ->
    D_a_t_a = <<?_((length(P0_g_last_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_((byte_size(P1_cName)), "16"):16, ?_(P1_cName, bin)/binary, ?_(P1_icon, '32'):32, ?_(P1_score, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_num, '8'):8>> || #rank_guild_last{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, cName = P1_cName, icon = P1_icon, score = P1_score, lev = P1_lev, num = P1_num} <- P0_g_last_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11022:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11022), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11022:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11023), {P0_g_exploits_list}) ->
    D_a_t_a = <<?_((length(P0_g_exploits_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_score, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_(P1_kill, '8'):8, ?_(P1_die, '8'):8, ?_(P1_ssan, '8'):8>> || #rank_guild_exploits{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, guild = P1_guild, career = P1_career, score = P1_score, lev = P1_lev, vip = P1_vip, kill = P1_kill, die = P1_die, ssan = P1_ssan} <- P0_g_exploits_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11023:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11023), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11023:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11024), {P0_rank_soul_world_list}) ->
    D_a_t_a = <<?_((length(P0_rank_soul_world_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_power, '32'):32, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_realm, '8'):8>> || #rank_soul_world{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, power = P1_power, vip = P1_vip, guild = P1_guild, realm = P1_realm} <- P0_rank_soul_world_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11024:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11024), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11024:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11025), {P0_rank_soul_world_array_list}) ->
    D_a_t_a = <<?_((length(P0_rank_soul_world_array_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_lev, '32'):32, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_realm, '8'):8>> || #rank_soul_world_array{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, lev = P1_lev, vip = P1_vip, guild = P1_guild, realm = P1_realm} <- P0_rank_soul_world_array_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11025:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11025), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11025:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11026), {P0_rank_soul_world_spirit_list}) ->
    D_a_t_a = <<?_((length(P0_rank_soul_world_spirit_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_spirit_name)), "16"):16, ?_(P1_spirit_name, bin)/binary, ?_(P1_spirit_lev, '32'):32, ?_(P1_quality, '8'):8, ?_(P1_power, '32'):32, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_realm, '8'):8>> || #rank_soul_world_spirit{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, spirit_name = P1_spirit_name, spirit_lev = P1_spirit_lev, quality = P1_quality, power = P1_power, vip = P1_vip, guild = P1_guild, realm = P1_realm} <- P0_rank_soul_world_spirit_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11026:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11026), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11026:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11027), {P0_total_page, P0_g_lev_list}) ->
    D_a_t_a = <<?_(P0_total_page, '8'):8, ?_((length(P0_g_lev_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_icon, '32'):32, ?_((byte_size(P1_cName)), "16"):16, ?_(P1_cName, bin)/binary, ?_(P1_lev, '8'):8, ?_(P1_power, '32'):32, ?_(P1_fund, '32'):32, ?_(P1_num, '8'):8, ?_((byte_size(P1_chief_srv_id)), "16"):16, ?_(P1_chief_srv_id, bin)/binary, ?_(P1_chief_rid, '32'):32, ?_(P1_realm, '8'):8>> || #rank_guild_power{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, icon = P1_icon, cName = P1_cName, lev = P1_lev, power = P1_power, fund = P1_fund, num = P1_num, chief_srv_id = P1_chief_srv_id, chief_rid = P1_chief_rid, realm = P1_realm} <- P0_g_lev_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11027:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11027), {P0_page_index}) ->
    D_a_t_a = <<?_(P0_page_index, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11027:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11030), {P0_v_acc_list}) ->
    D_a_t_a = <<?_((length(P0_v_acc_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_score, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_realm, '8'):8>> || #rank_vie_acc{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, score = P1_score, lev = P1_lev, vip = P1_vip, guild = P1_guild, realm = P1_realm} <- P0_v_acc_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11030:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11030), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11030:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11031), {P0_v_last_list}) ->
    D_a_t_a = <<?_((length(P0_v_last_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_score, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary>> || #rank_vie_last{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, score = P1_score, lev = P1_lev, vip = P1_vip, guild = P1_guild} <- P0_v_last_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11031:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11031), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11031:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11032), {P0_v_cross_list}) ->
    D_a_t_a = <<?_((length(P0_v_cross_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_win, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8>> || #rank_vie_cross{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, win = P1_win, lev = P1_lev, vip = P1_vip} <- P0_v_cross_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11032:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11032), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11032:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11033), {P0_v_kill_list}) ->
    D_a_t_a = <<?_((length(P0_v_kill_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_kill, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_realm, '8'):8>> || #rank_vie_kill{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, kill = P1_kill, lev = P1_lev, vip = P1_vip, guild = P1_guild, realm = P1_realm} <- P0_v_kill_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11033:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11033), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11033:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11034), {P0_v_last_kill_list}) ->
    D_a_t_a = <<?_((length(P0_v_last_kill_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_kill, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary>> || #rank_vie_last_kill{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, kill = P1_kill, lev = P1_lev, vip = P1_vip, guild = P1_guild} <- P0_v_last_kill_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11034:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11034), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11034:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11040), {P0_w_acc_list}) ->
    D_a_t_a = <<?_((length(P0_w_acc_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_score, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8>> || #rank_wit_acc{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, guild = P1_guild, score = P1_score, lev = P1_lev, vip = P1_vip, realm = P1_realm} <- P0_w_acc_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11040:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11040), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11040:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11041), {P0_w_last_list}) ->
    D_a_t_a = <<?_((length(P0_w_last_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_score, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8>> || #rank_wit_last{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, guild = P1_guild, score = P1_score, lev = P1_lev, vip = P1_vip} <- P0_w_last_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11041:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11041), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11041:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11050), {P0_f_acc_list}) ->
    D_a_t_a = <<?_((length(P0_f_acc_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_flower, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_realm, '8'):8>> || #rank_flower_acc{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, flower = P1_flower, lev = P1_lev, vip = P1_vip, guild = P1_guild, realm = P1_realm} <- P0_f_acc_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11050:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11050), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11050:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11051), {P0_f_day_list}) ->
    D_a_t_a = <<?_((length(P0_f_day_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_flower, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_realm, '8'):8, ?_(P1_face, '8'):8>> || #rank_flower_day{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, flower = P1_flower, lev = P1_lev, vip = P1_vip, guild = P1_guild, realm = P1_realm, face = P1_face} <- P0_f_day_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11051:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11051), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11051:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11052), {P0_f_cross_list}) ->
    D_a_t_a = <<?_((length(P0_f_cross_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_flower, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_realm, '8'):8, ?_(P1_face, '8'):8>> || #rank_cross_flower{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, flower = P1_flower, lev = P1_lev, vip = P1_vip, guild = P1_guild, realm = P1_realm, face = P1_face} <- P0_f_cross_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11052:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11052), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11052:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11060), {P0_m_acc_list}) ->
    D_a_t_a = <<?_((length(P0_m_acc_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_glamor, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_realm, '8'):8>> || #rank_glamor_acc{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, glamor = P1_glamor, lev = P1_lev, vip = P1_vip, guild = P1_guild, realm = P1_realm} <- P0_m_acc_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11060:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11060), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11060:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11061), {P0_m_day_list}) ->
    D_a_t_a = <<?_((length(P0_m_day_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_glamor, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_realm, '8'):8, ?_(P1_face, '8'):8>> || #rank_glamor_day{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, glamor = P1_glamor, lev = P1_lev, vip = P1_vip, guild = P1_guild, realm = P1_realm, face = P1_face} <- P0_m_day_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11061:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11061), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11061:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11062), {P0_m_cross_list}) ->
    D_a_t_a = <<?_((length(P0_m_cross_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_glamor, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_realm, '8'):8, ?_(P1_face, '8'):8>> || #rank_cross_glamor{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, glamor = P1_glamor, lev = P1_lev, vip = P1_vip, guild = P1_guild, realm = P1_realm, face = P1_face} <- P0_m_cross_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11062:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11062), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11062:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11070), {P0_p_acc_list}) ->
    D_a_t_a = <<?_((length(P0_p_acc_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_popu, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary>> || #rank_popu_acc{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, popu = P1_popu, lev = P1_lev, vip = P1_vip, guild = P1_guild} <- P0_p_acc_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11070:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11070), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11070:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11071), {P0_p_last_list}) ->
    D_a_t_a = <<?_((length(P0_p_last_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_popu, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary>> || #rank_popu_last{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, popu = P1_popu, lev = P1_lev, vip = P1_vip, guild = P1_guild} <- P0_p_last_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11071:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11071), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11071:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11072), {P0_rank_list}) ->
    D_a_t_a = <<?_((length(P0_rank_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_val, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_realm, '8'):8>> || #rank_darren_coin{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, val = P1_val, lev = P1_lev, vip = P1_vip, guild = P1_guild, realm = P1_realm} <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11072:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11072), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11072:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11073), {P0_rank_list}) ->
    D_a_t_a = <<?_((length(P0_rank_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_val, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_realm, '8'):8>> || #rank_darren_casino{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, val = P1_val, lev = P1_lev, vip = P1_vip, guild = P1_guild, realm = P1_realm} <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11073:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11073), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11073:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11074), {P0_rank_list}) ->
    D_a_t_a = <<?_((length(P0_rank_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_val, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_realm, '8'):8>> || #rank_darren_exp{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, val = P1_val, lev = P1_lev, vip = P1_vip, guild = P1_guild, realm = P1_realm} <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11074:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11074), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11074:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11075), {P0_rank_list}) ->
    D_a_t_a = <<?_((length(P0_rank_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_val, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_realm, '8'):8>> || #rank_darren_attainment{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, val = P1_val, lev = P1_lev, vip = P1_vip, guild = P1_guild, realm = P1_realm} <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11075:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11075), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11075:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11080), {P0_type, P0_top_harm, P0_total_hurt, P0_combat_round, P0_dun_score, P0_score_grade, P0_p_dungeon_list}) ->
    D_a_t_a = <<?_(P0_type, '32'):32, ?_(P0_top_harm, '32'):32, ?_(P0_total_hurt, '32'):32, ?_(P0_combat_round, '8'):8, ?_(P0_dun_score, '32'):32, ?_(P0_score_grade, '32'):32, ?_((length(P0_p_dungeon_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_top_harm, '32'):32, ?_(P1_total_hurt, '32'):32, ?_(P1_combat_round, '8'):8, ?_(P1_dun_score, '32'):32, ?_(P1_score_grade, '32'):32>> || #rank_dungeon{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, top_harm = P1_top_harm, total_hurt = P1_total_hurt, combat_round = P1_combat_round, dun_score = P1_dun_score, score_grade = P1_score_grade} <- P0_p_dungeon_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11080:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11080), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11080:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11081), {P0_p_last_list}) ->
    D_a_t_a = <<?_((length(P0_p_last_list)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_rank, '8'):8, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_item_type, '8'):8>> || {P1_type, P1_rank, P1_srv_id, P1_rid, P1_name, P1_item_type} <- P0_p_last_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11081:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11081), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11081:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11082), {P0_type, P0_rank_total_power_list}) ->
    D_a_t_a = <<?_(P0_type, '32'):32, ?_((length(P0_rank_total_power_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_lev, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_role_power, '32'):32, ?_(P1_pet_power, '32'):32, ?_(P1_total_power, '32'):32, ?_(P1_realm, '8'):8, ?_(P1_wc_lev, '16'):16, ?_(P1_vip, '8'):8>> || {P1_srv_id, P1_rid, P1_name, P1_career, P1_sex, P1_lev, P1_guild, P1_role_power, P1_pet_power, P1_total_power, P1_realm, P1_wc_lev, P1_vip} <- P0_rank_total_power_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11082:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11082), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11082:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11083), {P0_type, P0_i_pet_list}) ->
    D_a_t_a = <<?_(P0_type, '32'):32, ?_((length(P0_i_pet_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_color, '8'):8, ?_((byte_size(P1_petname)), "16"):16, ?_(P1_petname, bin)/binary, ?_(P1_petlev, '8'):8, ?_(P1_power, '32'):32, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8, ?_(P1_petrb, '32'):32>> || {P1_srv_id, P1_rid, P1_name, P1_career, P1_sex, P1_color, P1_petname, P1_petlev, P1_power, P1_vip, P1_realm, P1_petrb} <- P0_i_pet_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11083:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11083), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11083:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11084), {P0_type, P0_career, P0_sex, P0_lev, P0_items, P0_looks}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_career, '8'):8, ?_(P0_sex, '8'):8, ?_(P0_lev, '8'):8, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_upgrade, '8'):8, ?_(P1_enchant, '8/signed'):8/signed, ?_(P1_enchant_fail, '8'):8, ?_(P1_pos, '16'):16, ?_(P1_lasttime, '32'):32, ?_(P1_durability, '32/signed'):32/signed, ?_(P1_craft, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary, ?_((length(P1_extra)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32, ?_((byte_size(P2_str)), "16"):16, ?_(P2_str, bin)/binary>> || {P2_type, P2_value, P2_str} <- P1_extra]))/binary>> || #item{id = P1_id, base_id = P1_base_id, bind = P1_bind, upgrade = P1_upgrade, enchant = P1_enchant, enchant_fail = P1_enchant_fail, pos = P1_pos, lasttime = P1_lasttime, durability = P1_durability, craft = P1_craft, attr = P1_attr, max_base_attr = P1_max_base_attr, extra = P1_extra} <- P0_items]))/binary, ?_((length(P0_looks)), "16"):16, (list_to_binary([<<?_(P1_looks_type, '8'):8, ?_(P1_looks_id, '32'):32, ?_(P1_looks_value, '16'):16>> || {P1_looks_type, P1_looks_id, P1_looks_value} <- P0_looks]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11084:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11084), {P0_rid, P0_srv_id, P0_type}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11084:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11085), {P0_name, P0_base_id, P0_lev, P0_exp, P0_need_exp, P0_step, P0_xl, P0_tz, P0_js, P0_lq, P0_xl_val, P0_tz_val, P0_js_val, P0_lq_val, P0_xl_per, P0_tz_per, P0_js_per, P0_lq_per, P0_skill_num, P0_skill_list, P0_dmg, P0_critrate, P0_hp_max, P0_mp_max, P0_defence, P0_tenacity, P0_hitrate, P0_evasion, P0_power, P0_eqm_num, P0_eqms}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_base_id, '32'):32, ?_(P0_lev, '8'):8, ?_(P0_exp, '32'):32, ?_(P0_need_exp, '32'):32, ?_(P0_step, '8'):8, ?_(P0_xl, '16'):16, ?_(P0_tz, '16'):16, ?_(P0_js, '16'):16, ?_(P0_lq, '16'):16, ?_(P0_xl_val, '16'):16, ?_(P0_tz_val, '16'):16, ?_(P0_js_val, '16'):16, ?_(P0_lq_val, '16'):16, ?_(P0_xl_per, '8'):8, ?_(P0_tz_per, '8'):8, ?_(P0_js_per, '8'):8, ?_(P0_lq_per, '8'):8, ?_(P0_skill_num, '8'):8, ?_((length(P0_skill_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_exp, '16'):16, ?_(P1_skill_loc, '8'):8, ?_((length(P1_skill_args)), "16"):16, (list_to_binary([<<?_(P2_type, '8'):8, ?_(P2_val, '16'):16>> || {P2_type, P2_val} <- P1_skill_args]))/binary>> || {P1_id, P1_exp, P1_skill_loc, P1_skill_args} <- P0_skill_list]))/binary, ?_(P0_dmg, '32'):32, ?_(P0_critrate, '16'):16, ?_(P0_hp_max, '32'):32, ?_(P0_mp_max, '32'):32, ?_(P0_defence, '16'):16, ?_(P0_tenacity, '16'):16, ?_(P0_hitrate, '16'):16, ?_(P0_evasion, '16'):16, ?_(P0_power, '32'):32, ?_(P0_eqm_num, '16'):16, ?_((length(P0_eqms)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary>> || #item{base_id = P1_base_id, attr = P1_attr} <- P0_eqms]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11085:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11085), {P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11085:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11086), {P0_type, P0_mount_list}) ->
    D_a_t_a = <<?_(P0_type, '32'):32, ?_((length(P0_mount_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_((byte_size(P1_mount)), "16"):16, ?_(P1_mount, bin)/binary, ?_(P1_step, '32'):32, ?_(P1_mount_lev, '32'):32, ?_(P1_quality, '8'):8, ?_(P1_power, '32'):32, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8>> || {P1_srv_id, P1_rid, P1_name, P1_career, P1_sex, P1_guild, P1_mount, P1_step, P1_mount_lev, P1_quality, P1_power, P1_vip, P1_realm} <- P0_mount_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11086:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11086), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11086:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11087), {P0_type, P0_p_wc_winrate_list}) ->
    D_a_t_a = <<?_(P0_type, '32'):32, ?_((length(P0_p_wc_winrate_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_win_rate, '32'):32, ?_(P1_wc_lev, '16'):16>> || #rank_world_compete{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, lev = P1_lev, sex = P1_sex, win_rate = P1_win_rate, wc_lev = P1_wc_lev} <- P0_p_wc_winrate_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11087:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11087), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11087:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11088), {P0_type, P0_p_wc_lilian_list}) ->
    D_a_t_a = <<?_(P0_type, '32'):32, ?_((length(P0_p_wc_lilian_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_lilian, '32'):32, ?_(P1_wc_lev, '16'):16>> || #rank_world_compete{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, lev = P1_lev, sex = P1_sex, lilian = P1_lilian, wc_lev = P1_wc_lev} <- P0_p_wc_lilian_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11088:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11088), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11088:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11089), {P0_type, P0_p_wc_lilian_list}) ->
    D_a_t_a = <<?_(P0_type, '32'):32, ?_((length(P0_p_wc_lilian_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_section_mark, '32'):32, ?_(P1_section_lev, '16'):16>> || #rank_world_compete{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, lev = P1_lev, sex = P1_sex, section_mark = P1_section_mark, section_lev = P1_section_lev} <- P0_p_wc_lilian_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11089:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11089), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11089:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11090), {P0_total_page, P0_fi_acc_list}) ->
    D_a_t_a = <<?_(P0_total_page, '8'):8, ?_((length(P0_fi_acc_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_date, '32'):32, ?_((length(P1_r_list)), "16"):16, (list_to_binary([<<?_(P2_rid, '32'):32, ?_((byte_size(P2_srv_id)), "16"):16, ?_(P2_srv_id, bin)/binary, ?_((byte_size(P2_name)), "16"):16, ?_(P2_name, bin)/binary, ?_(P2_career, '8'):8, ?_(P2_sex, '8'):8, ?_((length(P2_looks)), "16"):16, (list_to_binary([<<?_(P3_looks_type, '8'):8, ?_(P3_looks_id, '32'):32, ?_(P3_looks_value, '16'):16>> || {P3_looks_type, P3_looks_id, P3_looks_value} <- P2_looks]))/binary>> || #rank_celebrity_role{rid = P2_rid, srv_id = P2_srv_id, name = P2_name, career = P2_career, sex = P2_sex, looks = P2_looks} <- P1_r_list]))/binary>> || #rank_global_celebrity{id = P1_id, date = P1_date, r_list = P1_r_list} <- P0_fi_acc_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11090:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11090), {P0_id, P0_page_index}) ->
    D_a_t_a = <<?_(P0_id, '16'):16, ?_(P0_page_index, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11090:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11091), {P0_base_id, P0_bind, P0_upgrade, P0_enchant, P0_enchant_fail, P0_durability, P0_craft, P0_attr, P0_max_base_attr, P0_extra}) ->
    D_a_t_a = <<?_(P0_base_id, '32'):32, ?_(P0_bind, '8'):8, ?_(P0_upgrade, '8'):8, ?_(P0_enchant, '8/signed'):8/signed, ?_(P0_enchant_fail, '8'):8, ?_(P0_durability, '32/signed'):32/signed, ?_(P0_craft, '8'):8, ?_((length(P0_attr)), "16"):16, (list_to_binary([<<?_(P1_attr_name, '32'):32, ?_(P1_flag, '32'):32, ?_(P1_value, '32'):32>> || {P1_attr_name, P1_flag, P1_value} <- P0_attr]))/binary, ?_((length(P0_max_base_attr)), "16"):16, (list_to_binary([<<?_(P1_attr_name, '32'):32, ?_(P1_flag, '32'):32, ?_(P1_value, '32'):32>> || {P1_attr_name, P1_flag, P1_value} <- P0_max_base_attr]))/binary, ?_((length(P0_extra)), "16"):16, (list_to_binary([<<?_(P1_type, '16'):16, ?_(P1_value, '32'):32, ?_((byte_size(P1_str)), "16"):16, ?_(P1_str, bin)/binary>> || {P1_type, P1_value, P1_str} <- P0_extra]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11091:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11091), {P0_rid, P0_srv_id, P0_type}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11091:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11092), {P0_career, P0_sex, P0_lev, P0_items, P0_looks}) ->
    D_a_t_a = <<?_(P0_career, '8'):8, ?_(P0_sex, '8'):8, ?_(P0_lev, '8'):8, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_upgrade, '8'):8, ?_(P1_enchant, '8/signed'):8/signed, ?_(P1_enchant_fail, '8'):8, ?_(P1_pos, '16'):16, ?_(P1_lasttime, '32'):32, ?_(P1_durability, '32/signed'):32/signed, ?_(P1_craft, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary, ?_((length(P1_extra)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32, ?_((byte_size(P2_str)), "16"):16, ?_(P2_str, bin)/binary>> || {P2_type, P2_value, P2_str} <- P1_extra]))/binary>> || #item{id = P1_id, base_id = P1_base_id, bind = P1_bind, upgrade = P1_upgrade, enchant = P1_enchant, enchant_fail = P1_enchant_fail, pos = P1_pos, lasttime = P1_lasttime, durability = P1_durability, craft = P1_craft, attr = P1_attr, max_base_attr = P1_max_base_attr, extra = P1_extra} <- P0_items]))/binary, ?_((length(P0_looks)), "16"):16, (list_to_binary([<<?_(P1_looks_type, '8'):8, ?_(P1_looks_id, '32'):32, ?_(P1_looks_value, '16'):16>> || {P1_looks_type, P1_looks_id, P1_looks_value} <- P0_looks]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11092:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11092), {P0_rid, P0_srv_id, P0_type}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11092:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11093), {P0_id, P0_name, P0_type, P0_base_id, P0_lev, P0_mod, P0_grow_val, P0_happy_val, P0_exp, P0_need_exp, P0_xl, P0_tz, P0_js, P0_lq, P0_xl_val, P0_tz_val, P0_js_val, P0_lq_val, P0_xl_per, P0_tz_per, P0_js_per, P0_lq_per, P0_skill_num, P0_skill_list}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_type, '8'):8, ?_(P0_base_id, '32'):32, ?_(P0_lev, '8'):8, ?_(P0_mod, '8'):8, ?_(P0_grow_val, '16'):16, ?_(P0_happy_val, '8'):8, ?_(P0_exp, '32'):32, ?_(P0_need_exp, '32'):32, ?_(P0_xl, '16'):16, ?_(P0_tz, '16'):16, ?_(P0_js, '16'):16, ?_(P0_lq, '16'):16, ?_(P0_xl_val, '16'):16, ?_(P0_tz_val, '16'):16, ?_(P0_js_val, '16'):16, ?_(P0_lq_val, '16'):16, ?_(P0_xl_per, '8'):8, ?_(P0_tz_per, '8'):8, ?_(P0_js_per, '8'):8, ?_(P0_lq_per, '8'):8, ?_(P0_skill_num, '8'):8, ?_((length(P0_skill_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_exp, '16'):16, ?_((length(P1_skill_args)), "16"):16, (list_to_binary([<<?_(P2_type, '8'):8, ?_(P2_val, '16'):16>> || {P2_type, P2_val} <- P1_skill_args]))/binary>> || {P1_id, P1_exp, P1_skill_args} <- P0_skill_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11093:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11093), {P0_rid, P0_srv_id, P0_type}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11093:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11094), {P0_type, P0_num}) ->
    D_a_t_a = <<?_(P0_type, '32'):32, ?_(P0_num, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11094:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11094), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11094:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11095), {P0_married_list}) ->
    D_a_t_a = <<?_((length(P0_married_list)), "16"):16, (list_to_binary([<<?_(P1_rid1, '32'):32, ?_((byte_size(P1_srv_id1)), "16"):16, ?_(P1_srv_id1, bin)/binary, ?_(P1_rid2, '32'):32, ?_((byte_size(P1_srv_id2)), "16"):16, ?_(P1_srv_id2, bin)/binary, ?_((byte_size(P1_name1)), "16"):16, ?_(P1_name1, bin)/binary, ?_((byte_size(P1_name2)), "16"):16, ?_(P1_name2, bin)/binary, ?_(P1_type, '8'):8, ?_(P1_ring_lev, '8'):8, ?_(P1_intimacy, '32'):32, ?_(P1_index, '32'):32, ?_(P1_time, '32'):32>> || {P1_rid1, P1_srv_id1, P1_rid2, P1_srv_id2, P1_name1, P1_name2, P1_type, P1_ring_lev, P1_intimacy, P1_index, P1_time} <- P0_married_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11095:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11095), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11095:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11096), {P0_rank_list}) ->
    D_a_t_a = <<?_((length(P0_rank_list)), "16"):16, (list_to_binary([<<?_(P1_type, '32'):32, ?_(P1_index, '8'):8, ?_(P1_top_harm, '32'):32, ?_(P1_total_hurt, '32'):32, ?_(P1_combat_round, '8'):8, ?_(P1_dun_score, '32'):32, ?_(P1_score_grade, '32'):32>> || {P1_type, P1_index, P1_top_harm, P1_total_hurt, P1_combat_round, P1_dun_score, P1_score_grade} <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11096:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11096), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11096:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11098), {P0_rank_total_power}) ->
    D_a_t_a = <<?_((length(P0_rank_total_power)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_ascend, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_role_power, '32'):32, ?_(P1_pet_power, '32'):32, ?_(P1_total_power, '32'):32, ?_(P1_realm, '8'):8, ?_(P1_vip, '8'):8>> || #rank_total_power{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, ascend = P1_ascend, sex = P1_sex, guild = P1_guild, role_power = P1_role_power, pet_power = P1_pet_power, total_power = P1_total_power, realm = P1_realm, vip = P1_vip} <- P0_rank_total_power]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11098:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11098), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11098:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11099), {P0_rank_cross_total_power}) ->
    D_a_t_a = <<?_((length(P0_rank_cross_total_power)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_ascend, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_role_power, '32'):32, ?_(P1_pet_power, '32'):32, ?_(P1_total_power, '32'):32, ?_(P1_realm, '8'):8, ?_(P1_vip, '8'):8>> || #rank_cross_total_power{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, ascend = P1_ascend, sex = P1_sex, guild = P1_guild, role_power = P1_role_power, pet_power = P1_pet_power, total_power = P1_total_power, realm = P1_realm, vip = P1_vip} <- P0_rank_cross_total_power]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11099:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11099), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11099:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 11000, _B0) ->
    {P0_page_index, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_page_index}};
unpack(cli, 11000, _B0) ->
    {P0_total_page, _B1} = lib_proto:read_uint8(_B0),
    {P0_i_lev_list, _B12} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_srv_id, _B3} = lib_proto:read_string(_B2),
        {P1_rid, _B4} = lib_proto:read_uint32(_B3),
        {P1_name, _B5} = lib_proto:read_string(_B4),
        {P1_career, _B6} = lib_proto:read_uint8(_B5),
        {P1_sex, _B7} = lib_proto:read_uint8(_B6),
        {P1_guild, _B8} = lib_proto:read_string(_B7),
        {P1_lev, _B9} = lib_proto:read_uint8(_B8),
        {P1_vip, _B10} = lib_proto:read_uint8(_B9),
        {P1_realm, _B11} = lib_proto:read_uint8(_B10),
        {[P1_srv_id, P1_rid, P1_name, P1_career, P1_sex, P1_guild, P1_lev, P1_vip, P1_realm], _B11}
    end),
    {ok, {P0_total_page, P0_i_lev_list}};

unpack(srv, 11006, _B0) ->
    {P0_page_index, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_page_index}};
unpack(cli, 11006, _B0) ->
    {P0_total_page, _B1} = lib_proto:read_uint8(_B0),
    {P0_i_power_list, _B13} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_srv_id, _B3} = lib_proto:read_string(_B2),
        {P1_rid, _B4} = lib_proto:read_uint32(_B3),
        {P1_name, _B5} = lib_proto:read_string(_B4),
        {P1_career, _B6} = lib_proto:read_uint8(_B5),
        {P1_sex, _B7} = lib_proto:read_uint8(_B6),
        {P1_guild, _B8} = lib_proto:read_string(_B7),
        {P1_power, _B9} = lib_proto:read_uint32(_B8),
        {P1_lev, _B10} = lib_proto:read_uint8(_B9),
        {P1_vip, _B11} = lib_proto:read_uint8(_B10),
        {P1_realm, _B12} = lib_proto:read_uint8(_B11),
        {[P1_srv_id, P1_rid, P1_name, P1_career, P1_sex, P1_guild, P1_power, P1_lev, P1_vip, P1_realm], _B12}
    end),
    {ok, {P0_total_page, P0_i_power_list}};

unpack(srv, 11009, _B0) ->
    {P0_page_index, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_page_index}};
unpack(cli, 11009, _B0) ->
    {P0_total_page, _B1} = lib_proto:read_uint8(_B0),
    {P0_i_pet_list, _B16} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_srv_id, _B3} = lib_proto:read_string(_B2),
        {P1_rid, _B4} = lib_proto:read_uint32(_B3),
        {P1_name, _B5} = lib_proto:read_string(_B4),
        {P1_career, _B6} = lib_proto:read_uint8(_B5),
        {P1_sex, _B7} = lib_proto:read_uint8(_B6),
        {P1_color, _B8} = lib_proto:read_uint8(_B7),
        {P1_petname, _B9} = lib_proto:read_string(_B8),
        {P1_petlev, _B10} = lib_proto:read_uint8(_B9),
        {P1_power, _B11} = lib_proto:read_uint32(_B10),
        {P1_guild, _B12} = lib_proto:read_string(_B11),
        {P1_vip, _B13} = lib_proto:read_uint8(_B12),
        {P1_realm, _B14} = lib_proto:read_uint8(_B13),
        {P1_petrb, _B15} = lib_proto:read_uint32(_B14),
        {[P1_srv_id, P1_rid, P1_name, P1_career, P1_sex, P1_color, P1_petname, P1_petlev, P1_power, P1_guild, P1_vip, P1_realm, P1_petrb], _B15}
    end),
    {ok, {P0_total_page, P0_i_pet_list}};

unpack(srv, 11011, _B0) ->
    {P0_page_index, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_page_index}};
unpack(cli, 11011, _B0) ->
    {P0_total_page, _B1} = lib_proto:read_uint8(_B0),
    {P0_e_arms_list, _B14} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_srv_id, _B3} = lib_proto:read_string(_B2),
        {P1_rid, _B4} = lib_proto:read_uint32(_B3),
        {P1_name, _B5} = lib_proto:read_string(_B4),
        {P1_career, _B6} = lib_proto:read_uint8(_B5),
        {P1_sex, _B7} = lib_proto:read_uint8(_B6),
        {P1_guild, _B8} = lib_proto:read_string(_B7),
        {P1_arms, _B9} = lib_proto:read_string(_B8),
        {P1_score, _B10} = lib_proto:read_uint32(_B9),
        {P1_vip, _B11} = lib_proto:read_uint8(_B10),
        {P1_quality, _B12} = lib_proto:read_uint8(_B11),
        {P1_realm, _B13} = lib_proto:read_uint8(_B12),
        {[P1_srv_id, P1_rid, P1_name, P1_career, P1_sex, P1_guild, P1_arms, P1_score, P1_vip, P1_quality, P1_realm], _B13}
    end),
    {ok, {P0_total_page, P0_e_arms_list}};

unpack(srv, 11012, _B0) ->
    {P0_page_index, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_page_index}};
unpack(cli, 11012, _B0) ->
    {P0_total_page, _B1} = lib_proto:read_uint8(_B0),
    {P0_e_armor_list, _B14} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_srv_id, _B3} = lib_proto:read_string(_B2),
        {P1_rid, _B4} = lib_proto:read_uint32(_B3),
        {P1_name, _B5} = lib_proto:read_string(_B4),
        {P1_career, _B6} = lib_proto:read_uint8(_B5),
        {P1_sex, _B7} = lib_proto:read_uint8(_B6),
        {P1_guild, _B8} = lib_proto:read_string(_B7),
        {P1_armor, _B9} = lib_proto:read_string(_B8),
        {P1_score, _B10} = lib_proto:read_uint32(_B9),
        {P1_vip, _B11} = lib_proto:read_uint8(_B10),
        {P1_quality, _B12} = lib_proto:read_uint8(_B11),
        {P1_realm, _B13} = lib_proto:read_uint8(_B12),
        {[P1_srv_id, P1_rid, P1_name, P1_career, P1_sex, P1_guild, P1_armor, P1_score, P1_vip, P1_quality, P1_realm], _B13}
    end),
    {ok, {P0_total_page, P0_e_armor_list}};

unpack(srv, 11018, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_type}};
unpack(cli, 11018, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint16(_B0),
    {P0_page_index, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_type, P0_page_index}};

unpack(srv, 11019, _B0) ->
    {ok, {}};
unpack(cli, 11019, _B0) ->
    {P0_page_index, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_page_index}};

unpack(srv, 11027, _B0) ->
    {P0_page_index, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_page_index}};
unpack(cli, 11027, _B0) ->
    {P0_total_page, _B1} = lib_proto:read_uint8(_B0),
    {P0_g_lev_list, _B15} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_srv_id, _B3} = lib_proto:read_string(_B2),
        {P1_rid, _B4} = lib_proto:read_uint32(_B3),
        {P1_name, _B5} = lib_proto:read_string(_B4),
        {P1_icon, _B6} = lib_proto:read_uint32(_B5),
        {P1_cName, _B7} = lib_proto:read_string(_B6),
        {P1_lev, _B8} = lib_proto:read_uint8(_B7),
        {P1_power, _B9} = lib_proto:read_uint32(_B8),
        {P1_fund, _B10} = lib_proto:read_uint32(_B9),
        {P1_num, _B11} = lib_proto:read_uint8(_B10),
        {P1_chief_srv_id, _B12} = lib_proto:read_string(_B11),
        {P1_chief_rid, _B13} = lib_proto:read_uint32(_B12),
        {P1_realm, _B14} = lib_proto:read_uint8(_B13),
        {[P1_srv_id, P1_rid, P1_name, P1_icon, P1_cName, P1_lev, P1_power, P1_fund, P1_num, P1_chief_srv_id, P1_chief_rid, P1_realm], _B14}
    end),
    {ok, {P0_total_page, P0_g_lev_list}};

unpack(srv, 11083, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_type}};
unpack(cli, 11083, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint32(_B0),
    {P0_i_pet_list, _B15} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_srv_id, _B3} = lib_proto:read_string(_B2),
        {P1_rid, _B4} = lib_proto:read_uint32(_B3),
        {P1_name, _B5} = lib_proto:read_string(_B4),
        {P1_career, _B6} = lib_proto:read_uint8(_B5),
        {P1_sex, _B7} = lib_proto:read_uint8(_B6),
        {P1_color, _B8} = lib_proto:read_uint8(_B7),
        {P1_petname, _B9} = lib_proto:read_string(_B8),
        {P1_petlev, _B10} = lib_proto:read_uint8(_B9),
        {P1_power, _B11} = lib_proto:read_uint32(_B10),
        {P1_vip, _B12} = lib_proto:read_uint8(_B11),
        {P1_realm, _B13} = lib_proto:read_uint8(_B12),
        {P1_petrb, _B14} = lib_proto:read_uint32(_B13),
        {[P1_srv_id, P1_rid, P1_name, P1_career, P1_sex, P1_color, P1_petname, P1_petlev, P1_power, P1_vip, P1_realm, P1_petrb], _B14}
    end),
    {ok, {P0_type, P0_i_pet_list}};

unpack(srv, 11084, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_type, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_rid, P0_srv_id, P0_type}};
unpack(cli, 11084, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_career, _B2} = lib_proto:read_uint8(_B1),
    {P0_sex, _B3} = lib_proto:read_uint8(_B2),
    {P0_lev, _B4} = lib_proto:read_uint8(_B3),
    {P0_items, _B31} = lib_proto:read_array(_B4, fun(_B5) ->
        {P1_id, _B6} = lib_proto:read_uint32(_B5),
        {P1_base_id, _B7} = lib_proto:read_uint32(_B6),
        {P1_bind, _B8} = lib_proto:read_uint8(_B7),
        {P1_upgrade, _B9} = lib_proto:read_uint8(_B8),
        {P1_enchant, _B10} = lib_proto:read_int8(_B9),
        {P1_enchant_fail, _B11} = lib_proto:read_uint8(_B10),
        {P1_pos, _B12} = lib_proto:read_uint16(_B11),
        {P1_lasttime, _B13} = lib_proto:read_uint32(_B12),
        {P1_durability, _B14} = lib_proto:read_int32(_B13),
        {P1_craft, _B15} = lib_proto:read_uint8(_B14),
        {P1_attr, _B20} = lib_proto:read_array(_B15, fun(_B16) ->
            {P2_attr_name, _B17} = lib_proto:read_uint32(_B16),
            {P2_flag, _B18} = lib_proto:read_uint32(_B17),
            {P2_value, _B19} = lib_proto:read_uint32(_B18),
            {[P2_attr_name, P2_flag, P2_value], _B19}
        end),
        {P1_max_base_attr, _B25} = lib_proto:read_array(_B20, fun(_B21) ->
            {P2_attr_name, _B22} = lib_proto:read_uint32(_B21),
            {P2_flag, _B23} = lib_proto:read_uint32(_B22),
            {P2_value, _B24} = lib_proto:read_uint32(_B23),
            {[P2_attr_name, P2_flag, P2_value], _B24}
        end),
        {P1_extra, _B30} = lib_proto:read_array(_B25, fun(_B26) ->
            {P2_type, _B27} = lib_proto:read_uint16(_B26),
            {P2_value, _B28} = lib_proto:read_uint32(_B27),
            {P2_str, _B29} = lib_proto:read_string(_B28),
            {[P2_type, P2_value, P2_str], _B29}
        end),
        {[P1_id, P1_base_id, P1_bind, P1_upgrade, P1_enchant, P1_enchant_fail, P1_pos, P1_lasttime, P1_durability, P1_craft, P1_attr, P1_max_base_attr, P1_extra], _B30}
    end),
    {P0_looks, _B36} = lib_proto:read_array(_B31, fun(_B32) ->
        {P1_looks_type, _B33} = lib_proto:read_uint8(_B32),
        {P1_looks_id, _B34} = lib_proto:read_uint32(_B33),
        {P1_looks_value, _B35} = lib_proto:read_uint16(_B34),
        {[P1_looks_type, P1_looks_id, P1_looks_value], _B35}
    end),
    {ok, {P0_type, P0_career, P0_sex, P0_lev, P0_items, P0_looks}};

unpack(srv, 11085, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_rid, P0_srv_id}};
unpack(cli, 11085, _B0) ->
    {P0_name, _B1} = lib_proto:read_string(_B0),
    {P0_base_id, _B2} = lib_proto:read_uint32(_B1),
    {P0_lev, _B3} = lib_proto:read_uint8(_B2),
    {P0_exp, _B4} = lib_proto:read_uint32(_B3),
    {P0_need_exp, _B5} = lib_proto:read_uint32(_B4),
    {P0_step, _B6} = lib_proto:read_uint8(_B5),
    {P0_xl, _B7} = lib_proto:read_uint16(_B6),
    {P0_tz, _B8} = lib_proto:read_uint16(_B7),
    {P0_js, _B9} = lib_proto:read_uint16(_B8),
    {P0_lq, _B10} = lib_proto:read_uint16(_B9),
    {P0_xl_val, _B11} = lib_proto:read_uint16(_B10),
    {P0_tz_val, _B12} = lib_proto:read_uint16(_B11),
    {P0_js_val, _B13} = lib_proto:read_uint16(_B12),
    {P0_lq_val, _B14} = lib_proto:read_uint16(_B13),
    {P0_xl_per, _B15} = lib_proto:read_uint8(_B14),
    {P0_tz_per, _B16} = lib_proto:read_uint8(_B15),
    {P0_js_per, _B17} = lib_proto:read_uint8(_B16),
    {P0_lq_per, _B18} = lib_proto:read_uint8(_B17),
    {P0_skill_num, _B19} = lib_proto:read_uint8(_B18),
    {P0_skill_list, _B28} = lib_proto:read_array(_B19, fun(_B20) ->
        {P1_id, _B21} = lib_proto:read_uint32(_B20),
        {P1_exp, _B22} = lib_proto:read_uint16(_B21),
        {P1_skill_loc, _B23} = lib_proto:read_uint8(_B22),
        {P1_skill_args, _B27} = lib_proto:read_array(_B23, fun(_B24) ->
            {P2_type, _B25} = lib_proto:read_uint8(_B24),
            {P2_val, _B26} = lib_proto:read_uint16(_B25),
            {[P2_type, P2_val], _B26}
        end),
        {[P1_id, P1_exp, P1_skill_loc, P1_skill_args], _B27}
    end),
    {P0_dmg, _B29} = lib_proto:read_uint32(_B28),
    {P0_critrate, _B30} = lib_proto:read_uint16(_B29),
    {P0_hp_max, _B31} = lib_proto:read_uint32(_B30),
    {P0_mp_max, _B32} = lib_proto:read_uint32(_B31),
    {P0_defence, _B33} = lib_proto:read_uint16(_B32),
    {P0_tenacity, _B34} = lib_proto:read_uint16(_B33),
    {P0_hitrate, _B35} = lib_proto:read_uint16(_B34),
    {P0_evasion, _B36} = lib_proto:read_uint16(_B35),
    {P0_power, _B37} = lib_proto:read_uint32(_B36),
    {P0_eqm_num, _B38} = lib_proto:read_uint16(_B37),
    {P0_eqms, _B46} = lib_proto:read_array(_B38, fun(_B39) ->
        {P1_base_id, _B40} = lib_proto:read_uint32(_B39),
        {P1_attr, _B45} = lib_proto:read_array(_B40, fun(_B41) ->
            {P2_attr_name, _B42} = lib_proto:read_uint32(_B41),
            {P2_flag, _B43} = lib_proto:read_uint32(_B42),
            {P2_value, _B44} = lib_proto:read_uint32(_B43),
            {[P2_attr_name, P2_flag, P2_value], _B44}
        end),
        {[P1_base_id, P1_attr], _B45}
    end),
    {ok, {P0_name, P0_base_id, P0_lev, P0_exp, P0_need_exp, P0_step, P0_xl, P0_tz, P0_js, P0_lq, P0_xl_val, P0_tz_val, P0_js_val, P0_lq_val, P0_xl_per, P0_tz_per, P0_js_per, P0_lq_per, P0_skill_num, P0_skill_list, P0_dmg, P0_critrate, P0_hp_max, P0_mp_max, P0_defence, P0_tenacity, P0_hitrate, P0_evasion, P0_power, P0_eqm_num, P0_eqms}};

unpack(srv, 11090, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint16(_B0),
    {P0_page_index, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_id, P0_page_index}};
unpack(cli, 11090, _B0) ->
    {P0_total_page, _B1} = lib_proto:read_uint8(_B0),
    {P0_fi_acc_list, _B17} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_date, _B4} = lib_proto:read_uint32(_B3),
        {P1_r_list, _B16} = lib_proto:read_array(_B4, fun(_B5) ->
            {P2_rid, _B6} = lib_proto:read_uint32(_B5),
            {P2_srv_id, _B7} = lib_proto:read_string(_B6),
            {P2_name, _B8} = lib_proto:read_string(_B7),
            {P2_career, _B9} = lib_proto:read_uint8(_B8),
            {P2_sex, _B10} = lib_proto:read_uint8(_B9),
            {P2_looks, _B15} = lib_proto:read_array(_B10, fun(_B11) ->
                {P3_looks_type, _B12} = lib_proto:read_uint8(_B11),
                {P3_looks_id, _B13} = lib_proto:read_uint32(_B12),
                {P3_looks_value, _B14} = lib_proto:read_uint16(_B13),
                {[P3_looks_type, P3_looks_id, P3_looks_value], _B14}
            end),
            {[P2_rid, P2_srv_id, P2_name, P2_career, P2_sex, P2_looks], _B15}
        end),
        {[P1_id, P1_date, P1_r_list], _B16}
    end),
    {ok, {P0_total_page, P0_fi_acc_list}};

unpack(srv, 11091, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_type, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_rid, P0_srv_id, P0_type}};
unpack(cli, 11091, _B0) ->
    {P0_base_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_bind, _B2} = lib_proto:read_uint8(_B1),
    {P0_upgrade, _B3} = lib_proto:read_uint8(_B2),
    {P0_enchant, _B4} = lib_proto:read_int8(_B3),
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

unpack(srv, 11092, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_type, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_rid, P0_srv_id, P0_type}};
unpack(cli, 11092, _B0) ->
    {P0_career, _B1} = lib_proto:read_uint8(_B0),
    {P0_sex, _B2} = lib_proto:read_uint8(_B1),
    {P0_lev, _B3} = lib_proto:read_uint8(_B2),
    {P0_items, _B30} = lib_proto:read_array(_B3, fun(_B4) ->
        {P1_id, _B5} = lib_proto:read_uint32(_B4),
        {P1_base_id, _B6} = lib_proto:read_uint32(_B5),
        {P1_bind, _B7} = lib_proto:read_uint8(_B6),
        {P1_upgrade, _B8} = lib_proto:read_uint8(_B7),
        {P1_enchant, _B9} = lib_proto:read_int8(_B8),
        {P1_enchant_fail, _B10} = lib_proto:read_uint8(_B9),
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
        {[P1_id, P1_base_id, P1_bind, P1_upgrade, P1_enchant, P1_enchant_fail, P1_pos, P1_lasttime, P1_durability, P1_craft, P1_attr, P1_max_base_attr, P1_extra], _B29}
    end),
    {P0_looks, _B35} = lib_proto:read_array(_B30, fun(_B31) ->
        {P1_looks_type, _B32} = lib_proto:read_uint8(_B31),
        {P1_looks_id, _B33} = lib_proto:read_uint32(_B32),
        {P1_looks_value, _B34} = lib_proto:read_uint16(_B33),
        {[P1_looks_type, P1_looks_id, P1_looks_value], _B34}
    end),
    {ok, {P0_career, P0_sex, P0_lev, P0_items, P0_looks}};

unpack(srv, 11093, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_type, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_rid, P0_srv_id, P0_type}};
unpack(cli, 11093, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_name, _B2} = lib_proto:read_string(_B1),
    {P0_type, _B3} = lib_proto:read_uint8(_B2),
    {P0_base_id, _B4} = lib_proto:read_uint32(_B3),
    {P0_lev, _B5} = lib_proto:read_uint8(_B4),
    {P0_mod, _B6} = lib_proto:read_uint8(_B5),
    {P0_grow_val, _B7} = lib_proto:read_uint16(_B6),
    {P0_happy_val, _B8} = lib_proto:read_uint8(_B7),
    {P0_exp, _B9} = lib_proto:read_uint32(_B8),
    {P0_need_exp, _B10} = lib_proto:read_uint32(_B9),
    {P0_xl, _B11} = lib_proto:read_uint16(_B10),
    {P0_tz, _B12} = lib_proto:read_uint16(_B11),
    {P0_js, _B13} = lib_proto:read_uint16(_B12),
    {P0_lq, _B14} = lib_proto:read_uint16(_B13),
    {P0_xl_val, _B15} = lib_proto:read_uint16(_B14),
    {P0_tz_val, _B16} = lib_proto:read_uint16(_B15),
    {P0_js_val, _B17} = lib_proto:read_uint16(_B16),
    {P0_lq_val, _B18} = lib_proto:read_uint16(_B17),
    {P0_xl_per, _B19} = lib_proto:read_uint8(_B18),
    {P0_tz_per, _B20} = lib_proto:read_uint8(_B19),
    {P0_js_per, _B21} = lib_proto:read_uint8(_B20),
    {P0_lq_per, _B22} = lib_proto:read_uint8(_B21),
    {P0_skill_num, _B23} = lib_proto:read_uint8(_B22),
    {P0_skill_list, _B31} = lib_proto:read_array(_B23, fun(_B24) ->
        {P1_id, _B25} = lib_proto:read_uint32(_B24),
        {P1_exp, _B26} = lib_proto:read_uint16(_B25),
        {P1_skill_args, _B30} = lib_proto:read_array(_B26, fun(_B27) ->
            {P2_type, _B28} = lib_proto:read_uint8(_B27),
            {P2_val, _B29} = lib_proto:read_uint16(_B28),
            {[P2_type, P2_val], _B29}
        end),
        {[P1_id, P1_exp, P1_skill_args], _B30}
    end),
    {ok, {P0_id, P0_name, P0_type, P0_base_id, P0_lev, P0_mod, P0_grow_val, P0_happy_val, P0_exp, P0_need_exp, P0_xl, P0_tz, P0_js, P0_lq, P0_xl_val, P0_tz_val, P0_js_val, P0_lq_val, P0_xl_per, P0_tz_per, P0_js_per, P0_lq_per, P0_skill_num, P0_skill_list}};

unpack(srv, 11094, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_type}};
unpack(cli, 11094, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint32(_B0),
    {P0_num, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_type, P0_num}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
