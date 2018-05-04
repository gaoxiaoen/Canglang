%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_174).
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
-include("soul_world.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(17400), {P0_rank_cross_pet_lev_list}) ->
    D_a_t_a = <<?_((length(P0_rank_cross_pet_lev_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_color, '8'):8, ?_((byte_size(P1_petname)), "16"):16, ?_(P1_petname, bin)/binary, ?_(P1_petlev, '8'):8, ?_(P1_aptitude, '8'):8, ?_(P1_growrate, '8'):8, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8, ?_(P1_petrb, '32'):32>> || #rank_cross_pet_lev{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, color = P1_color, petname = P1_petname, petlev = P1_petlev, aptitude = P1_aptitude, growrate = P1_growrate, vip = P1_vip, realm = P1_realm, petrb = P1_petrb} <- P0_rank_cross_pet_lev_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17400:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17400), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17400:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17401), {P0_rank_cross_pet_power_list}) ->
    D_a_t_a = <<?_((length(P0_rank_cross_pet_power_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_color, '8'):8, ?_((byte_size(P1_petname)), "16"):16, ?_(P1_petname, bin)/binary, ?_(P1_petlev, '8'):8, ?_(P1_power, '32'):32, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8, ?_(P1_petrb, '32'):32>> || #rank_cross_role_pet_power{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, color = P1_color, petname = P1_petname, petlev = P1_petlev, power = P1_power, vip = P1_vip, realm = P1_realm, petrb = P1_petrb} <- P0_rank_cross_pet_power_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17401:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17401), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17401:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17402), {P0_rank_cross_pet_grow_list}) ->
    D_a_t_a = <<?_((length(P0_rank_cross_pet_grow_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_color, '8'):8, ?_((byte_size(P1_petname)), "16"):16, ?_(P1_petname, bin)/binary, ?_(P1_petlev, '8'):8, ?_(P1_grow, '32'):32, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8, ?_(P1_petrb, '32'):32>> || #rank_cross_pet_grow{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, color = P1_color, petname = P1_petname, petlev = P1_petlev, grow = P1_grow, vip = P1_vip, realm = P1_realm, petrb = P1_petrb} <- P0_rank_cross_pet_grow_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17402:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17402), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17402:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17403), {P0_rank_cross_pet_potential_list}) ->
    D_a_t_a = <<?_((length(P0_rank_cross_pet_potential_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_color, '8'):8, ?_((byte_size(P1_petname)), "16"):16, ?_(P1_petname, bin)/binary, ?_(P1_petlev, '8'):8, ?_(P1_potential, '32'):32, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8, ?_(P1_petrb, '32'):32>> || #rank_cross_pet_potential{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, color = P1_color, petname = P1_petname, petlev = P1_petlev, potential = P1_potential, vip = P1_vip, realm = P1_realm, petrb = P1_petrb} <- P0_rank_cross_pet_potential_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17403:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17403), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17403:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17404), {P0_rank_cross_role_power_list}) ->
    D_a_t_a = <<?_((length(P0_rank_cross_role_power_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_ascend, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_power, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8>> || #rank_cross_role_power{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, ascend = P1_ascend, sex = P1_sex, guild = P1_guild, power = P1_power, lev = P1_lev, vip = P1_vip, realm = P1_realm} <- P0_rank_cross_role_power_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17404:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17404), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17404:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17405), {P0_rank_cross_role_lev_list}) ->
    D_a_t_a = <<?_((length(P0_rank_cross_role_lev_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8>> || #rank_cross_role_lev{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, guild = P1_guild, lev = P1_lev, vip = P1_vip, realm = P1_realm} <- P0_rank_cross_role_lev_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17405:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17405), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17405:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17406), {P0_rank_cross_role_coin_list}) ->
    D_a_t_a = <<?_((length(P0_rank_cross_role_coin_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_coin, '32'):32, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8>> || #rank_cross_role_coin{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, guild = P1_guild, coin = P1_coin, vip = P1_vip, realm = P1_realm} <- P0_rank_cross_role_coin_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17406:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17406), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17406:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17407), {P0_rank_cross_role_skill_list}) ->
    D_a_t_a = <<?_((length(P0_rank_cross_role_skill_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_skill, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8>> || #rank_cross_role_skill{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, guild = P1_guild, skill = P1_skill, lev = P1_lev, vip = P1_vip, realm = P1_realm} <- P0_rank_cross_role_skill_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17407:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17407), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17407:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17408), {P0_rank_cross_role_achieve_list}) ->
    D_a_t_a = <<?_((length(P0_rank_cross_role_achieve_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_achieve, '32'):32, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8>> || #rank_cross_role_achieve{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, guild = P1_guild, achieve = P1_achieve, vip = P1_vip, realm = P1_realm} <- P0_rank_cross_role_achieve_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17408:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17408), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17408:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17409), {P0_rank_cross_role_soul_list}) ->
    D_a_t_a = <<?_((length(P0_rank_cross_role_soul_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_soul, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8>> || #rank_cross_role_soul{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, guild = P1_guild, soul = P1_soul, lev = P1_lev, vip = P1_vip, realm = P1_realm} <- P0_rank_cross_role_soul_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17409:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17409), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17409:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17411), {P0_rank_cross_mount_power_list}) ->
    D_a_t_a = <<?_((length(P0_rank_cross_mount_power_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_((byte_size(P1_mount)), "16"):16, ?_(P1_mount, bin)/binary, ?_(P1_step, '32'):32, ?_(P1_mount_lev, '32'):32, ?_(P1_quality, '8'):8, ?_(P1_power, '32'):32, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8>> || #rank_cross_mount_power{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, guild = P1_guild, mount = P1_mount, step = P1_step, mount_lev = P1_mount_lev, quality = P1_quality, power = P1_power, vip = P1_vip, realm = P1_realm} <- P0_rank_cross_mount_power_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17411:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17411), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17411:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17412), {P0_rank_cross_mount_power_list}) ->
    D_a_t_a = <<?_((length(P0_rank_cross_mount_power_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_((byte_size(P1_mount)), "16"):16, ?_(P1_mount, bin)/binary, ?_(P1_step, '32'):32, ?_(P1_mount_lev, '32'):32, ?_(P1_quality, '8'):8, ?_(P1_vip, '8'):8, ?_(P1_realm, '8'):8>> || #rank_cross_mount_lev{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, guild = P1_guild, mount = P1_mount, step = P1_step, mount_lev = P1_mount_lev, quality = P1_quality, vip = P1_vip, realm = P1_realm} <- P0_rank_cross_mount_power_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17412:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17412), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17412:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17413), {P0_rank_cross_eqm_arms_list}) ->
    D_a_t_a = <<?_((length(P0_rank_cross_eqm_arms_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_((byte_size(P1_arms)), "16"):16, ?_(P1_arms, bin)/binary, ?_(P1_score, '32'):32, ?_(P1_vip, '8'):8, ?_(P1_quality, '8'):8, ?_(P1_realm, '8'):8>> || #rank_cross_equip_arms{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, guild = P1_guild, arms = P1_arms, score = P1_score, vip = P1_vip, quality = P1_quality, realm = P1_realm} <- P0_rank_cross_eqm_arms_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17413:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17413), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17413:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17414), {P0_rank_cross_eqm_armor_list}) ->
    D_a_t_a = <<?_((length(P0_rank_cross_eqm_armor_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_((byte_size(P1_armor)), "16"):16, ?_(P1_armor, bin)/binary, ?_(P1_score, '32'):32, ?_(P1_vip, '8'):8, ?_(P1_type, '8'):8, ?_(P1_quality, '8'):8, ?_(P1_realm, '8'):8>> || #rank_cross_equip_armor{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, guild = P1_guild, armor = P1_armor, score = P1_score, vip = P1_vip, type = P1_type, quality = P1_quality, realm = P1_realm} <- P0_rank_cross_eqm_armor_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17414:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17414), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17414:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17415), {P0_rank_cross_guild_lev_list}) ->
    D_a_t_a = <<?_((length(P0_rank_cross_guild_lev_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_icon, '32'):32, ?_((byte_size(P1_cName)), "16"):16, ?_(P1_cName, bin)/binary, ?_(P1_lev, '8'):8, ?_(P1_fund, '32'):32, ?_(P1_num, '8'):8, ?_((byte_size(P1_chief_srv_id)), "16"):16, ?_(P1_chief_srv_id, bin)/binary, ?_(P1_chief_rid, '32'):32, ?_(P1_realm, '8'):8>> || #rank_cross_guild_lev{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, icon = P1_icon, cName = P1_cName, lev = P1_lev, fund = P1_fund, num = P1_num, chief_srv_id = P1_chief_srv_id, chief_rid = P1_chief_rid, realm = P1_realm} <- P0_rank_cross_guild_lev_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17415:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17415), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17415:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17416), {P0_rank_cross_arena_kill_list}) ->
    D_a_t_a = <<?_((length(P0_rank_cross_arena_kill_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_kill, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_realm, '8'):8>> || #rank_cross_vie_kill{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, kill = P1_kill, lev = P1_lev, vip = P1_vip, guild = P1_guild, realm = P1_realm} <- P0_rank_cross_arena_kill_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17416:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17416), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17416:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17417), {P0_rank_cross_world_compete_win_list}) ->
    D_a_t_a = <<?_((length(P0_rank_cross_world_compete_win_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_win_count, '32'):32, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_realm, '8'):8>> || #rank_cross_world_compete_win{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, lev = P1_lev, win_count = P1_win_count, vip = P1_vip, guild = P1_guild, realm = P1_realm} <- P0_rank_cross_world_compete_win_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17417:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17417), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17417:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17418), {P0_rank_cross_soul_world_list}) ->
    D_a_t_a = <<?_((length(P0_rank_cross_soul_world_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_power, '32'):32, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_realm, '8'):8>> || #rank_cross_soul_world{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, power = P1_power, vip = P1_vip, guild = P1_guild, realm = P1_realm} <- P0_rank_cross_soul_world_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17418:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17418), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17418:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17419), {P0_rank_cross_soul_world_array_list}) ->
    D_a_t_a = <<?_((length(P0_rank_cross_soul_world_array_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_lev, '32'):32, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_realm, '8'):8>> || #rank_cross_soul_world_array{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, lev = P1_lev, vip = P1_vip, guild = P1_guild, realm = P1_realm} <- P0_rank_cross_soul_world_array_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17419:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17419), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17419:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17420), {P0_rank_cross_soul_world_spirit_list}) ->
    D_a_t_a = <<?_((length(P0_rank_cross_soul_world_spirit_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_rid, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((byte_size(P1_spirit_name)), "16"):16, ?_(P1_spirit_name, bin)/binary, ?_(P1_spirit_lev, '32'):32, ?_(P1_quality, '8'):8, ?_(P1_power, '32'):32, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_realm, '8'):8>> || #rank_cross_soul_world_spirit{srv_id = P1_srv_id, rid = P1_rid, name = P1_name, career = P1_career, sex = P1_sex, spirit_name = P1_spirit_name, spirit_lev = P1_spirit_lev, quality = P1_quality, power = P1_power, vip = P1_vip, guild = P1_guild, realm = P1_realm} <- P0_rank_cross_soul_world_spirit_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17420:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17420), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17420:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17491), {P0_type, P0_name, P0_id, P0_spirit_name, P0_spirit_lev, P0_quality, P0_fc, P0_array_id, P0_magics}) ->
    D_a_t_a = <<?_(P0_type, '32'):32, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_id, '32'):32, ?_((byte_size(P0_spirit_name)), "16"):16, ?_(P0_spirit_name, bin)/binary, ?_(P0_spirit_lev, '32'):32, ?_(P0_quality, '8'):8, ?_(P0_fc, '32'):32, ?_(P0_array_id, '8'):8, ?_((length(P0_magics)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_lev, '32'):32, ?_(P1_fc, '32'):32, ?_(P1_addition, '32'):32>> || #soul_world_spirit_magic{type = P1_type, lev = P1_lev, fc = P1_fc, addition = P1_addition} <- P0_magics]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17491:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17491), {P0_rid, P0_srv_id, P0_type}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_type, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17491:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17492), {P0_type, P0_name, P0_array_lev, P0_arrays}) ->
    D_a_t_a = <<?_(P0_type, '32'):32, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_array_lev, '32'):32, ?_((length(P0_arrays)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_lev, '32'):32, ?_(P1_fc, '32'):32, ?_(P1_attr, '32'):32, ?_(P1_spirit_id, '32'):32>> || #soul_world_array{id = P1_id, lev = P1_lev, fc = P1_fc, attr = P1_attr, spirit_id = P1_spirit_id} <- P0_arrays]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17492:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17492), {P0_rid, P0_srv_id, P0_type}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_type, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17492:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17493), {P0_type, P0_name, P0_power, P0_arrays, P0_spirits}) ->
    D_a_t_a = <<?_(P0_type, '32'):32, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_power, '32'):32, ?_((length(P0_arrays)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_lev, '32'):32, ?_(P1_fc, '32'):32, ?_(P1_attr, '32'):32, ?_(P1_spirit_id, '32'):32>> || #soul_world_array{id = P1_id, lev = P1_lev, fc = P1_fc, attr = P1_attr, spirit_id = P1_spirit_id} <- P0_arrays]))/binary, ?_((length(P0_spirits)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '32'):32, ?_(P1_quality, '8'):8, ?_(P1_fc, '32'):32, ?_(P1_array_id, '8'):8, ?_((length(P1_magics)), "16"):16, (list_to_binary([<<?_(P2_type, '8'):8, ?_(P2_lev, '32'):32, ?_(P2_fc, '32'):32, ?_(P2_addition, '32'):32>> || #soul_world_spirit_magic{type = P2_type, lev = P2_lev, fc = P2_fc, addition = P2_addition} <- P1_magics]))/binary>> || #soul_world_spirit{id = P1_id, name = P1_name, lev = P1_lev, quality = P1_quality, fc = P1_fc, array_id = P1_array_id, magics = P1_magics} <- P0_spirits]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17493:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17493), {P0_rid, P0_srv_id, P0_type}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_type, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17493:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17494), {P0_name, P0_power, P0_items}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_power, '32'):32, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_upgrade, '8'):8, ?_(P1_enchant, '8/signed'):8/signed, ?_(P1_enchant_fail, '8'):8, ?_(P1_pos, '16'):16, ?_(P1_lasttime, '32'):32, ?_(P1_durability, '32/signed'):32/signed, ?_(P1_craft, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary, ?_((length(P1_extra)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32, ?_((byte_size(P2_str)), "16"):16, ?_(P2_str, bin)/binary>> || {P2_type, P2_value, P2_str} <- P1_extra]))/binary>> || #item{id = P1_id, base_id = P1_base_id, bind = P1_bind, upgrade = P1_upgrade, enchant = P1_enchant, enchant_fail = P1_enchant_fail, pos = P1_pos, lasttime = P1_lasttime, durability = P1_durability, craft = P1_craft, attr = P1_attr, max_base_attr = P1_max_base_attr, extra = P1_extra} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17494:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17494), {P0_rid, P0_srv_id, P0_type}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_type, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17494:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17495), {P0_base_id, P0_bind, P0_upgrade, P0_enchant, P0_enchant_fail, P0_durability, P0_craft, P0_attr, P0_max_base_attr, P0_extra}) ->
    D_a_t_a = <<?_(P0_base_id, '32'):32, ?_(P0_bind, '8'):8, ?_(P0_upgrade, '8'):8, ?_(P0_enchant, '8/signed'):8/signed, ?_(P0_enchant_fail, '8'):8, ?_(P0_durability, '32/signed'):32/signed, ?_(P0_craft, '8'):8, ?_((length(P0_attr)), "16"):16, (list_to_binary([<<?_(P1_attr_name, '32'):32, ?_(P1_flag, '32'):32, ?_(P1_value, '32'):32>> || {P1_attr_name, P1_flag, P1_value} <- P0_attr]))/binary, ?_((length(P0_max_base_attr)), "16"):16, (list_to_binary([<<?_(P1_attr_name, '32'):32, ?_(P1_flag, '32'):32, ?_(P1_value, '32'):32>> || {P1_attr_name, P1_flag, P1_value} <- P0_max_base_attr]))/binary, ?_((length(P0_extra)), "16"):16, (list_to_binary([<<?_(P1_type, '16'):16, ?_(P1_value, '32'):32, ?_((byte_size(P1_str)), "16"):16, ?_(P1_str, bin)/binary>> || {P1_type, P1_value, P1_str} <- P0_extra]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17495:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17495), {P0_rid, P0_srv_id, P0_type, P0_eqm_type}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_type, '32'):32, ?_(P0_eqm_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17495:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17496), {P0_career, P0_sex, P0_lev, P0_items, P0_looks}) ->
    D_a_t_a = <<?_(P0_career, '8'):8, ?_(P0_sex, '8'):8, ?_(P0_lev, '8'):8, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_upgrade, '8'):8, ?_(P1_enchant, '8/signed'):8/signed, ?_(P1_enchant_fail, '8'):8, ?_(P1_pos, '16'):16, ?_(P1_lasttime, '32'):32, ?_(P1_durability, '32/signed'):32/signed, ?_(P1_craft, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary, ?_((length(P1_extra)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32, ?_((byte_size(P2_str)), "16"):16, ?_(P2_str, bin)/binary>> || {P2_type, P2_value, P2_str} <- P1_extra]))/binary>> || #item{id = P1_id, base_id = P1_base_id, bind = P1_bind, upgrade = P1_upgrade, enchant = P1_enchant, enchant_fail = P1_enchant_fail, pos = P1_pos, lasttime = P1_lasttime, durability = P1_durability, craft = P1_craft, attr = P1_attr, max_base_attr = P1_max_base_attr, extra = P1_extra} <- P0_items]))/binary, ?_((length(P0_looks)), "16"):16, (list_to_binary([<<?_(P1_looks_type, '8'):8, ?_(P1_looks_id, '32'):32, ?_(P1_looks_value, '16'):16>> || {P1_looks_type, P1_looks_id, P1_looks_value} <- P0_looks]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17496:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17496), {P0_rid, P0_srv_id, P0_type}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_type, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17496:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17497), {P0_rid, P0_srv_id, P0_name, P0_pet_list}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_((length(P0_pet_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_type, '8'):8, ?_(P1_base_id, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_mod, '8'):8, ?_(P1_grow_val, '16'):16, ?_(P1_happy_val, '8'):8, ?_(P1_exp, '32'):32, ?_(P1_need_exp, '32'):32, ?_(P1_xl, '16'):16, ?_(P1_tz, '16'):16, ?_(P1_js, '16'):16, ?_(P1_lq, '16'):16, ?_(P1_xl_val, '16'):16, ?_(P1_tz_val, '16'):16, ?_(P1_js_val, '16'):16, ?_(P1_lq_val, '16'):16, ?_(P1_xl_per, '8'):8, ?_(P1_tz_per, '8'):8, ?_(P1_js_per, '8'):8, ?_(P1_lq_per, '8'):8, ?_(P1_skill_num, '8'):8, ?_((length(P1_skill_list)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_(P2_exp, '16'):16, ?_((length(P2_skill_args)), "16"):16, (list_to_binary([<<?_(P3_type, '8'):8, ?_(P3_val, '16'):16>> || {P3_type, P3_val} <- P2_skill_args]))/binary>> || {P2_id, P2_exp, P2_skill_args} <- P1_skill_list]))/binary, ?_(P1_dmg, '32'):32, ?_(P1_critrate, '16'):16, ?_(P1_hp_max, '32'):32, ?_(P1_mp_max, '32'):32, ?_(P1_defence, '16'):16, ?_(P1_tenacity, '16'):16, ?_(P1_hitrate, '16'):16, ?_(P1_evasion, '16'):16, ?_(P1_power, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_change_type, '8'):8, ?_(P1_wish_val, '16'):16, ?_(P1_eqm_num, '16'):16, ?_(P1_dmg_magic, '32'):32, ?_(P1_anti_js, '32'):32, ?_(P1_anti_attack, '32'):32, ?_(P1_anti_seal, '32'):32, ?_(P1_anti_stone, '32'):32, ?_(P1_anti_stun, '32'):32, ?_(P1_anti_sleep, '32'):32, ?_(P1_anti_taunt, '32'):32, ?_(P1_anti_silent, '32'):32, ?_(P1_anti_poison, '32'):32, ?_(P1_blood, '32'):32, ?_(P1_rebound, '32'):32, ?_(P1_resist_metal, '32'):32, ?_(P1_resist_wood, '32'):32, ?_(P1_resist_water, '32'):32, ?_(P1_resist_fire, '32'):32, ?_(P1_resist_earth, '32'):32, ?_(P1_xl_max, '16'):16, ?_(P1_tz_max, '16'):16, ?_(P1_js_max, '16'):16, ?_(P1_lq_max, '16'):16>> || {P1_id, P1_name, P1_type, P1_base_id, P1_lev, P1_mod, P1_grow_val, P1_happy_val, P1_exp, P1_need_exp, P1_xl, P1_tz, P1_js, P1_lq, P1_xl_val, P1_tz_val, P1_js_val, P1_lq_val, P1_xl_per, P1_tz_per, P1_js_per, P1_lq_per, P1_skill_num, P1_skill_list, P1_dmg, P1_critrate, P1_hp_max, P1_mp_max, P1_defence, P1_tenacity, P1_hitrate, P1_evasion, P1_power, P1_bind, P1_change_type, P1_wish_val, P1_eqm_num, P1_dmg_magic, P1_anti_js, P1_anti_attack, P1_anti_seal, P1_anti_stone, P1_anti_stun, P1_anti_sleep, P1_anti_taunt, P1_anti_silent, P1_anti_poison, P1_blood, P1_rebound, P1_resist_metal, P1_resist_wood, P1_resist_water, P1_resist_fire, P1_resist_earth, P1_xl_max, P1_tz_max, P1_js_max, P1_lq_max} <- P0_pet_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17497:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17497), {P0_rid, P0_srv_id, P0_type}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_type, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17497:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
