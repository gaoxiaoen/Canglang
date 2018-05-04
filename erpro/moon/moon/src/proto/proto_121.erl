%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_121).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("sns.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(12100), {P0_can_give_num, P0_give_cnt, P0_recv_cnt, P0_total, P0_friend_list}) ->
    D_a_t_a = <<?_(P0_can_give_num, '16'):16, ?_(P0_give_cnt, '8'):8, ?_(P0_recv_cnt, '8'):8, ?_(P0_total, '8'):8, ?_((length(P0_friend_list)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_group_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_sex, '8'):8, ?_(P1_career, '8'):8, ?_(P1_lev, '16'):16, ?_(P1_intimacy, '32'):32, ?_(P1_online_late, '32'):32, ?_(P1_map_id, '32'):32, ?_(P1_face_id, '32'):32, ?_(P1_vip_type, '8'):8, ?_((byte_size(P1_signature)), "16"):16, ?_(P1_signature, bin)/binary, ?_(P1_prestige, '32'):32, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_online, '8'):8, ?_(P1_fight, '32'):32, ?_(P1_give_flag, '8'):8, ?_(P1_recv_flag, '8'):8>> || #friend{type = P1_type, role_id = P1_role_id, srv_id = P1_srv_id, group_id = P1_group_id, name = P1_name, sex = P1_sex, career = P1_career, lev = P1_lev, intimacy = P1_intimacy, online_late = P1_online_late, map_id = P1_map_id, face_id = P1_face_id, vip_type = P1_vip_type, signature = P1_signature, prestige = P1_prestige, guild = P1_guild, online = P1_online, fight = P1_fight, give_flag = P1_give_flag, recv_flag = P1_recv_flag} <- P0_friend_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12100:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12100), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12100:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12102), {P0_friend_list}) ->
    D_a_t_a = <<?_((length(P0_friend_list)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_group_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_sex, '8'):8, ?_(P1_career, '8'):8, ?_(P1_lev, '16'):16, ?_(P1_intimacy, '32'):32, ?_(P1_online_late, '32'):32, ?_(P1_map_id, '32'):32, ?_(P1_face_id, '32'):32, ?_(P1_vip_type, '8'):8, ?_((byte_size(P1_signature)), "16"):16, ?_(P1_signature, bin)/binary, ?_(P1_prestige, '32'):32, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_online, '8'):8, ?_(P1_fight, '32'):32>> || #friend{type = P1_type, role_id = P1_role_id, srv_id = P1_srv_id, group_id = P1_group_id, name = P1_name, sex = P1_sex, career = P1_career, lev = P1_lev, intimacy = P1_intimacy, online_late = P1_online_late, map_id = P1_map_id, face_id = P1_face_id, vip_type = P1_vip_type, signature = P1_signature, prestige = P1_prestige, guild = P1_guild, online = P1_online, fight = P1_fight} <- P0_friend_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12102:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12102), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12102:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12105), {P0_type, P0_role_id, P0_srv_id, P0_group_id, P0_name, P0_sex, P0_career, P0_lev, P0_intimacy, P0_online_late, P0_map_id, P0_face_id, P0_vip_type, P0_signature, P0_prestige, P0_guild, P0_online, P0_fight}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_group_id, '32'):32, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_sex, '8'):8, ?_(P0_career, '8'):8, ?_(P0_lev, '16'):16, ?_(P0_intimacy, '32'):32, ?_(P0_online_late, '32'):32, ?_(P0_map_id, '32'):32, ?_(P0_face_id, '32'):32, ?_(P0_vip_type, '8'):8, ?_((byte_size(P0_signature)), "16"):16, ?_(P0_signature, bin)/binary, ?_(P0_prestige, '32'):32, ?_((byte_size(P0_guild)), "16"):16, ?_(P0_guild, bin)/binary, ?_(P0_online, '8'):8, ?_(P0_fight, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12105:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12105), {P0_role_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12105:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12106), {P0_type, P0_role_id, P0_srv_id, P0_group_id, P0_name, P0_sex, P0_career, P0_lev, P0_intimacy, P0_online_late, P0_map_id, P0_face_id, P0_vip_type, P0_signature, P0_prestige, P0_guild, P0_online, P0_fight}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_group_id, '32'):32, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_sex, '8'):8, ?_(P0_career, '8'):8, ?_(P0_lev, '16'):16, ?_(P0_intimacy, '32'):32, ?_(P0_online_late, '32'):32, ?_(P0_map_id, '32'):32, ?_(P0_face_id, '32'):32, ?_(P0_vip_type, '8'):8, ?_((byte_size(P0_signature)), "16"):16, ?_(P0_signature, bin)/binary, ?_(P0_prestige, '32'):32, ?_((byte_size(P0_guild)), "16"):16, ?_(P0_guild, bin)/binary, ?_(P0_online, '8'):8, ?_(P0_fight, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12106:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12106), {P0_role_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12106:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12108), {P0_ret}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12108:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12108), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12108:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12109), {P0_ret}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12109:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12109), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12109:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12110), {P0_role_id, P0_srv_id, P0_type}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12110:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12110), {P0_type, P0_role_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12110:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12115), {P0_result, P0_role_id, P0_srv_id, P0_type}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12115:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12115), {P0_type, P0_fri_name}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_((byte_size(P0_fri_name)), "16"):16, ?_(P0_fri_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12115:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12120), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12120:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12120), {P0_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12120:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12125), {P0_result, P0_msg, P0_type, P0_role_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_type, '8'):8, ?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12125:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12125), {P0_type, P0_role_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12125:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12130), {P0_role_id}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12130:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12130), {P0_result, P0_role_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12130:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12131), {P0_result, P0_applyers}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((length(P0_applyers)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32/signed'):32/signed>> || P1_role_id <- P0_applyers]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12131:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12131), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12131:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12135), {P0_apply_list}) ->
    D_a_t_a = <<?_((length(P0_apply_list)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32'):32, ?_(P1_vip_type, '8'):8, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_face_id, '32'):32, ?_(P1_lev, '16'):16, ?_(P1_sex, '8'):8>> || {P1_role_id, P1_vip_type, P1_srv_id, P1_name, P1_career, P1_face_id, P1_lev, P1_sex} <- P0_apply_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12135:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12135), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12135:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12136), {P0_result}) ->
    D_a_t_a = <<?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12136:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12136), {P0_apply_id}) ->
    D_a_t_a = <<?_(P0_apply_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12136:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12137), {P0_result}) ->
    D_a_t_a = <<?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12137:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12137), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12137:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12138), {P0_result}) ->
    D_a_t_a = <<?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12138:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12138), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12138:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12139), {P0_role_id}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12139:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12139), {P0_role_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12139:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12140), {P0_role_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12140:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12140), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12140:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12145), {P0_role_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12145:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12145), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12145:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12146), {P0_friend_list}) ->
    D_a_t_a = <<?_((length(P0_friend_list)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_group_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_sex, '8'):8, ?_(P1_career, '8'):8, ?_(P1_lev, '16'):16, ?_(P1_intimacy, '32'):32, ?_(P1_online_late, '32'):32, ?_(P1_map_id, '32'):32, ?_(P1_face_id, '32'):32, ?_(P1_vip_type, '8'):8, ?_((byte_size(P1_signature)), "16"):16, ?_(P1_signature, bin)/binary, ?_(P1_prestige, '32'):32, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_online, '8'):8, ?_(P1_fight, '32'):32, ?_(P1_give_flag, '8'):8, ?_(P1_recv_flag, '8'):8>> || #friend{type = P1_type, role_id = P1_role_id, srv_id = P1_srv_id, group_id = P1_group_id, name = P1_name, sex = P1_sex, career = P1_career, lev = P1_lev, intimacy = P1_intimacy, online_late = P1_online_late, map_id = P1_map_id, face_id = P1_face_id, vip_type = P1_vip_type, signature = P1_signature, prestige = P1_prestige, guild = P1_guild, online = P1_online, fight = P1_fight, give_flag = P1_give_flag, recv_flag = P1_recv_flag} <- P0_friend_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12146:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12146), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12146:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12147), {P0_role_id, P0_srv_id, P0_type, P0_fri_name}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_type, '8'):8, ?_((byte_size(P0_fri_name)), "16"):16, ?_(P0_fri_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12147:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12147), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12147:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12148), {P0_role_id, P0_srv_id, P0_type, P0_fri_name}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_type, '8'):8, ?_((byte_size(P0_fri_name)), "16"):16, ?_(P0_fri_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12148:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12148), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12148:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12152), {P0_result, P0_msg, P0_friend_group_id, P0_friend_group_name}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_friend_group_id, '32'):32, ?_((byte_size(P0_friend_group_name)), "16"):16, ?_(P0_friend_group_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12152:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12152), {P0_friend_group_name}) ->
    D_a_t_a = <<?_((byte_size(P0_friend_group_name)), "16"):16, ?_(P0_friend_group_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12152:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12153), {P0_result, P0_msg, P0_friend_group_id}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_friend_group_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12153:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12153), {P0_friend_group_id}) ->
    D_a_t_a = <<?_(P0_friend_group_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12153:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12154), {P0_result, P0_msg, P0_friend_group_id, P0_friend_group_name}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_friend_group_id, '32'):32, ?_((byte_size(P0_friend_group_name)), "16"):16, ?_(P0_friend_group_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12154:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12154), {P0_friend_group_id, P0_friend_group_name}) ->
    D_a_t_a = <<?_(P0_friend_group_id, '32'):32, ?_((byte_size(P0_friend_group_name)), "16"):16, ?_(P0_friend_group_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12154:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12155), {P0_friend_group_list}) ->
    D_a_t_a = <<?_((length(P0_friend_group_list)), "16"):16, (list_to_binary([<<?_(P1_friend_group_id, '32'):32, ?_((byte_size(P1_friend_group_name)), "16"):16, ?_(P1_friend_group_name, bin)/binary>> || {P1_friend_group_id, P1_friend_group_name} <- P0_friend_group_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12155:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12155), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12155:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12156), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12156:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12156), {P0_friend_group_id, P0_friend_list}) ->
    D_a_t_a = <<?_(P0_friend_group_id, '32'):32, ?_((length(P0_friend_list)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary>> || {P1_role_id, P1_srv_id} <- P0_friend_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12156:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12157), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12157:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12157), {P0_friend_list}) ->
    D_a_t_a = <<?_((length(P0_friend_list)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary>> || {P1_role_id, P1_srv_id} <- P0_friend_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12157:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12158), {P0_friend_list}) ->
    D_a_t_a = <<?_((length(P0_friend_list)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_friend_group_id, '32'):32>> || {P1_role_id, P1_srv_id, P1_friend_group_id} <- P0_friend_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12158:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12158), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12158:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12159), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12159:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12159), {P0_signature}) ->
    D_a_t_a = <<?_((byte_size(P0_signature)), "16"):16, ?_(P0_signature, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12159:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12160), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12160:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12160), {P0_name, P0_name_code, P0_type}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_name_code, '8'):8, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12160:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12161), {P0_msg}) ->
    D_a_t_a = <<?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12161:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12161), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12161:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12162), {P0_role_id, P0_srv_id, P0_name, P0_name_code, P0_type}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_name_code, '8'):8, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12162:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12162), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12162:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12163), {P0_role_id, P0_srv_id, P0_intimacy}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_intimacy, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12163:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12163), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12163:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12164), {P0_role_id, P0_srv_id, P0_name, P0_lev, P0_career, P0_sex, P0_face_id}) ->
    D_a_t_a = <<?_(P0_role_id, '32/signed'):32/signed, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_lev, '16'):16, ?_(P0_career, '8'):8, ?_(P0_sex, '8'):8, ?_(P0_face_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12164:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12164), {P0_name}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12164:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12165), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12165:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12165), {P0_role_id, P0_srv_id, P0_name_code, P0_type}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_name_code, '8'):8, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12165:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12170), {P0_role_id, P0_srv_id, P0_name, P0_lev, P0_exp, P0_wish_num}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_lev, '16'):16, ?_(P0_exp, '32'):32, ?_(P0_wish_num, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12170:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12170), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12170:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12171), {P0_result, P0_reason, P0_name, P0_exp, P0_wish_num}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_exp, '32'):32, ?_(P0_wish_num, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12171:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12171), {P0_type, P0_role_id, P0_srv_id, P0_lev}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_lev, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12171:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12172), {P0_role_id, P0_srv_id, P0_name, P0_exp, P0_type}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_exp, '32'):32, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12172:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12172), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12172:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12173), {P0_role_list}) ->
    D_a_t_a = <<?_((length(P0_role_list)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_lev, '32'):32>> || {P1_role_id, P1_srv_id, P1_name, P1_career, P1_sex, P1_lev} <- P0_role_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12173:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12173), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12173:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12174), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12174:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12174), {P0_friend_list, P0_type}) ->
    D_a_t_a = <<?_((length(P0_friend_list)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary>> || {P1_role_id, P1_srv_id} <- P0_friend_list]))/binary, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12174:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12175), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12175:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12175), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12175:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12176), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12176:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12176), {P0_name}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12176:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12177), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12177:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12177), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12177:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12178), {P0_role_id, P0_srv_id, P0_name, P0_name_code, P0_intimacy, P0_forever}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_name_code, '8'):8, ?_(P0_intimacy, '32'):32, ?_(P0_forever, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12178:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12178), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12178:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12179), {P0_total_page, P0_list}) ->
    D_a_t_a = <<?_(P0_total_page, '8'):8, ?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '16'):16, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_face_id, '32'):32, ?_(P1_fight, '32'):32>> || {P1_role_id, P1_srv_id, P1_name, P1_lev, P1_career, P1_sex, P1_face_id, P1_fight} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12179:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12179), {P0_page_index}) ->
    D_a_t_a = <<?_(P0_page_index, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12179:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12180), {P0_friend_list}) ->
    D_a_t_a = <<?_((length(P0_friend_list)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_group_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_sex, '8'):8, ?_(P1_career, '8'):8, ?_(P1_lev, '16'):16, ?_(P1_intimacy, '32'):32, ?_(P1_online_late, '32'):32, ?_(P1_map_id, '32'):32, ?_(P1_face_id, '32'):32, ?_(P1_vip_type, '8'):8, ?_((byte_size(P1_signature)), "16"):16, ?_(P1_signature, bin)/binary, ?_(P1_prestige, '32'):32, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_online, '8'):8, ?_(P1_fight, '32'):32>> || #friend{type = P1_type, role_id = P1_role_id, srv_id = P1_srv_id, group_id = P1_group_id, name = P1_name, sex = P1_sex, career = P1_career, lev = P1_lev, intimacy = P1_intimacy, online_late = P1_online_late, map_id = P1_map_id, face_id = P1_face_id, vip_type = P1_vip_type, signature = P1_signature, prestige = P1_prestige, guild = P1_guild, online = P1_online, fight = P1_fight} <- P0_friend_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12180:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12180), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12180:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12181), {P0_result, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12181:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12181), {P0_role_id, P0_srv_id, P0_type}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_type, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12181:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12182), {P0_recv_cnt, P0_result, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_recv_cnt, '8'):8, ?_(P0_result, '8'):8, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12182:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12182), {P0_role_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12182:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12183), {P0_list}) ->
    D_a_t_a = <<?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_give_flag, '8'):8, ?_(P1_recv_flag, '8'):8>> || {P1_role_id, P1_srv_id, P1_give_flag, P1_recv_flag} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12183:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12183), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12183:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12184), {P0_recv_cnt}) ->
    D_a_t_a = <<?_(P0_recv_cnt, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12184:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12184), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12184:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12185), {P0_result, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12185:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12185), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12185:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12186), {P0_apply_num, P0_recv_num}) ->
    D_a_t_a = <<?_(P0_apply_num, '8'):8, ?_(P0_recv_num, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12186:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12186), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12186:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12190), {P0_code, P0_recruit, P0_awards}) ->
    D_a_t_a = <<?_((byte_size(P0_code)), "16"):16, ?_(P0_code, bin)/binary, ?_(P0_recruit, '8'):8, ?_((length(P0_awards)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_gift_id, '32'):32, ?_(P1_status, '8'):8, ?_(P1_need, '8'):8>> || {P1_id, P1_gift_id, P1_status, P1_need} <- P0_awards]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12190:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12190), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12190:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12191), {P0_result}) ->
    D_a_t_a = <<?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12191:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12191), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12191:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 12100, _B0) ->
    {ok, {}};
unpack(cli, 12100, _B0) ->
    {P0_can_give_num, _B1} = lib_proto:read_uint16(_B0),
    {P0_give_cnt, _B2} = lib_proto:read_uint8(_B1),
    {P0_recv_cnt, _B3} = lib_proto:read_uint8(_B2),
    {P0_total, _B4} = lib_proto:read_uint8(_B3),
    {P0_friend_list, _B26} = lib_proto:read_array(_B4, fun(_B5) ->
        {P1_type, _B6} = lib_proto:read_uint8(_B5),
        {P1_role_id, _B7} = lib_proto:read_uint32(_B6),
        {P1_srv_id, _B8} = lib_proto:read_string(_B7),
        {P1_group_id, _B9} = lib_proto:read_uint32(_B8),
        {P1_name, _B10} = lib_proto:read_string(_B9),
        {P1_sex, _B11} = lib_proto:read_uint8(_B10),
        {P1_career, _B12} = lib_proto:read_uint8(_B11),
        {P1_lev, _B13} = lib_proto:read_uint16(_B12),
        {P1_intimacy, _B14} = lib_proto:read_uint32(_B13),
        {P1_online_late, _B15} = lib_proto:read_uint32(_B14),
        {P1_map_id, _B16} = lib_proto:read_uint32(_B15),
        {P1_face_id, _B17} = lib_proto:read_uint32(_B16),
        {P1_vip_type, _B18} = lib_proto:read_uint8(_B17),
        {P1_signature, _B19} = lib_proto:read_string(_B18),
        {P1_prestige, _B20} = lib_proto:read_uint32(_B19),
        {P1_guild, _B21} = lib_proto:read_string(_B20),
        {P1_online, _B22} = lib_proto:read_uint8(_B21),
        {P1_fight, _B23} = lib_proto:read_uint32(_B22),
        {P1_give_flag, _B24} = lib_proto:read_uint8(_B23),
        {P1_recv_flag, _B25} = lib_proto:read_uint8(_B24),
        {[P1_type, P1_role_id, P1_srv_id, P1_group_id, P1_name, P1_sex, P1_career, P1_lev, P1_intimacy, P1_online_late, P1_map_id, P1_face_id, P1_vip_type, P1_signature, P1_prestige, P1_guild, P1_online, P1_fight, P1_give_flag, P1_recv_flag], _B25}
    end),
    {ok, {P0_can_give_num, P0_give_cnt, P0_recv_cnt, P0_total, P0_friend_list}};

unpack(srv, 12105, _B0) ->
    {P0_role_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_role_id, P0_srv_id}};
unpack(cli, 12105, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_role_id, _B2} = lib_proto:read_uint32(_B1),
    {P0_srv_id, _B3} = lib_proto:read_string(_B2),
    {P0_group_id, _B4} = lib_proto:read_uint32(_B3),
    {P0_name, _B5} = lib_proto:read_string(_B4),
    {P0_sex, _B6} = lib_proto:read_uint8(_B5),
    {P0_career, _B7} = lib_proto:read_uint8(_B6),
    {P0_lev, _B8} = lib_proto:read_uint16(_B7),
    {P0_intimacy, _B9} = lib_proto:read_uint32(_B8),
    {P0_online_late, _B10} = lib_proto:read_uint32(_B9),
    {P0_map_id, _B11} = lib_proto:read_uint32(_B10),
    {P0_face_id, _B12} = lib_proto:read_uint32(_B11),
    {P0_vip_type, _B13} = lib_proto:read_uint8(_B12),
    {P0_signature, _B14} = lib_proto:read_string(_B13),
    {P0_prestige, _B15} = lib_proto:read_uint32(_B14),
    {P0_guild, _B16} = lib_proto:read_string(_B15),
    {P0_online, _B17} = lib_proto:read_uint8(_B16),
    {P0_fight, _B18} = lib_proto:read_uint32(_B17),
    {ok, {P0_type, P0_role_id, P0_srv_id, P0_group_id, P0_name, P0_sex, P0_career, P0_lev, P0_intimacy, P0_online_late, P0_map_id, P0_face_id, P0_vip_type, P0_signature, P0_prestige, P0_guild, P0_online, P0_fight}};

unpack(srv, 12110, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_role_id, _B2} = lib_proto:read_uint32(_B1),
    {P0_srv_id, _B3} = lib_proto:read_string(_B2),
    {ok, {P0_type, P0_role_id, P0_srv_id}};
unpack(cli, 12110, _B0) ->
    {P0_role_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_type, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_role_id, P0_srv_id, P0_type}};

unpack(srv, 12115, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_fri_name, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_type, P0_fri_name}};
unpack(cli, 12115, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_role_id, _B2} = lib_proto:read_uint32(_B1),
    {P0_srv_id, _B3} = lib_proto:read_string(_B2),
    {P0_type, _B4} = lib_proto:read_uint8(_B3),
    {ok, {P0_result, P0_role_id, P0_srv_id, P0_type}};

unpack(srv, 12120, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_id, P0_srv_id}};
unpack(cli, 12120, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};

unpack(srv, 12130, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_role_id, _B2} = lib_proto:read_uint32(_B1),
    {P0_srv_id, _B3} = lib_proto:read_string(_B2),
    {ok, {P0_result, P0_role_id, P0_srv_id}};
unpack(cli, 12130, _B0) ->
    {P0_role_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_role_id}};

unpack(srv, 12131, _B0) ->
    {ok, {}};
unpack(cli, 12131, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_applyers, _B4} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_role_id, _B3} = lib_proto:read_int32(_B2),
        {P1_role_id, _B3}
    end),
    {ok, {P0_result, P0_applyers}};

unpack(srv, 12135, _B0) ->
    {ok, {}};
unpack(cli, 12135, _B0) ->
    {P0_apply_list, _B10} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_role_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_vip_type, _B3} = lib_proto:read_uint8(_B2),
        {P1_srv_id, _B4} = lib_proto:read_string(_B3),
        {P1_name, _B5} = lib_proto:read_string(_B4),
        {P1_career, _B6} = lib_proto:read_uint8(_B5),
        {P1_face_id, _B7} = lib_proto:read_uint32(_B6),
        {P1_lev, _B8} = lib_proto:read_uint16(_B7),
        {P1_sex, _B9} = lib_proto:read_uint8(_B8),
        {[P1_role_id, P1_vip_type, P1_srv_id, P1_name, P1_career, P1_face_id, P1_lev, P1_sex], _B9}
    end),
    {ok, {P0_apply_list}};

unpack(srv, 12136, _B0) ->
    {P0_apply_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_apply_id}};
unpack(cli, 12136, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_result}};

unpack(srv, 12137, _B0) ->
    {ok, {}};
unpack(cli, 12137, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_result}};

unpack(srv, 12138, _B0) ->
    {ok, {}};
unpack(cli, 12138, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_result}};

unpack(srv, 12139, _B0) ->
    {P0_role_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_role_id, P0_srv_id}};
unpack(cli, 12139, _B0) ->
    {P0_role_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_role_id}};

unpack(srv, 12140, _B0) ->
    {ok, {}};
unpack(cli, 12140, _B0) ->
    {P0_role_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_role_id, P0_srv_id}};

unpack(srv, 12145, _B0) ->
    {ok, {}};
unpack(cli, 12145, _B0) ->
    {P0_role_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_role_id, P0_srv_id}};

unpack(srv, 12146, _B0) ->
    {ok, {}};
unpack(cli, 12146, _B0) ->
    {P0_friend_list, _B22} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_type, _B2} = lib_proto:read_uint8(_B1),
        {P1_role_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_srv_id, _B4} = lib_proto:read_string(_B3),
        {P1_group_id, _B5} = lib_proto:read_uint32(_B4),
        {P1_name, _B6} = lib_proto:read_string(_B5),
        {P1_sex, _B7} = lib_proto:read_uint8(_B6),
        {P1_career, _B8} = lib_proto:read_uint8(_B7),
        {P1_lev, _B9} = lib_proto:read_uint16(_B8),
        {P1_intimacy, _B10} = lib_proto:read_uint32(_B9),
        {P1_online_late, _B11} = lib_proto:read_uint32(_B10),
        {P1_map_id, _B12} = lib_proto:read_uint32(_B11),
        {P1_face_id, _B13} = lib_proto:read_uint32(_B12),
        {P1_vip_type, _B14} = lib_proto:read_uint8(_B13),
        {P1_signature, _B15} = lib_proto:read_string(_B14),
        {P1_prestige, _B16} = lib_proto:read_uint32(_B15),
        {P1_guild, _B17} = lib_proto:read_string(_B16),
        {P1_online, _B18} = lib_proto:read_uint8(_B17),
        {P1_fight, _B19} = lib_proto:read_uint32(_B18),
        {P1_give_flag, _B20} = lib_proto:read_uint8(_B19),
        {P1_recv_flag, _B21} = lib_proto:read_uint8(_B20),
        {[P1_type, P1_role_id, P1_srv_id, P1_group_id, P1_name, P1_sex, P1_career, P1_lev, P1_intimacy, P1_online_late, P1_map_id, P1_face_id, P1_vip_type, P1_signature, P1_prestige, P1_guild, P1_online, P1_fight, P1_give_flag, P1_recv_flag], _B21}
    end),
    {ok, {P0_friend_list}};

unpack(srv, 12148, _B0) ->
    {ok, {}};
unpack(cli, 12148, _B0) ->
    {P0_role_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_type, _B3} = lib_proto:read_uint8(_B2),
    {P0_fri_name, _B4} = lib_proto:read_string(_B3),
    {ok, {P0_role_id, P0_srv_id, P0_type, P0_fri_name}};

unpack(srv, 12157, _B0) ->
    {P0_friend_list, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_role_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_srv_id, _B3} = lib_proto:read_string(_B2),
        {[P1_role_id, P1_srv_id], _B3}
    end),
    {ok, {P0_friend_list}};
unpack(cli, 12157, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_result, P0_msg}};

unpack(srv, 12164, _B0) ->
    {P0_name, _B1} = lib_proto:read_string(_B0),
    {ok, {P0_name}};
unpack(cli, 12164, _B0) ->
    {P0_role_id, _B1} = lib_proto:read_int32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_name, _B3} = lib_proto:read_string(_B2),
    {P0_lev, _B4} = lib_proto:read_uint16(_B3),
    {P0_career, _B5} = lib_proto:read_uint8(_B4),
    {P0_sex, _B6} = lib_proto:read_uint8(_B5),
    {P0_face_id, _B7} = lib_proto:read_uint32(_B6),
    {ok, {P0_role_id, P0_srv_id, P0_name, P0_lev, P0_career, P0_sex, P0_face_id}};

unpack(srv, 12179, _B0) ->
    {P0_page_index, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_page_index}};
unpack(cli, 12179, _B0) ->
    {P0_total_page, _B1} = lib_proto:read_uint8(_B0),
    {P0_list, _B11} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_role_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_srv_id, _B4} = lib_proto:read_string(_B3),
        {P1_name, _B5} = lib_proto:read_string(_B4),
        {P1_lev, _B6} = lib_proto:read_uint16(_B5),
        {P1_career, _B7} = lib_proto:read_uint8(_B6),
        {P1_sex, _B8} = lib_proto:read_uint8(_B7),
        {P1_face_id, _B9} = lib_proto:read_uint32(_B8),
        {P1_fight, _B10} = lib_proto:read_uint32(_B9),
        {[P1_role_id, P1_srv_id, P1_name, P1_lev, P1_career, P1_sex, P1_face_id, P1_fight], _B10}
    end),
    {ok, {P0_total_page, P0_list}};

unpack(srv, 12180, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_type}};
unpack(cli, 12180, _B0) ->
    {P0_friend_list, _B20} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_type, _B2} = lib_proto:read_uint8(_B1),
        {P1_role_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_srv_id, _B4} = lib_proto:read_string(_B3),
        {P1_group_id, _B5} = lib_proto:read_uint32(_B4),
        {P1_name, _B6} = lib_proto:read_string(_B5),
        {P1_sex, _B7} = lib_proto:read_uint8(_B6),
        {P1_career, _B8} = lib_proto:read_uint8(_B7),
        {P1_lev, _B9} = lib_proto:read_uint16(_B8),
        {P1_intimacy, _B10} = lib_proto:read_uint32(_B9),
        {P1_online_late, _B11} = lib_proto:read_uint32(_B10),
        {P1_map_id, _B12} = lib_proto:read_uint32(_B11),
        {P1_face_id, _B13} = lib_proto:read_uint32(_B12),
        {P1_vip_type, _B14} = lib_proto:read_uint8(_B13),
        {P1_signature, _B15} = lib_proto:read_string(_B14),
        {P1_prestige, _B16} = lib_proto:read_uint32(_B15),
        {P1_guild, _B17} = lib_proto:read_string(_B16),
        {P1_online, _B18} = lib_proto:read_uint8(_B17),
        {P1_fight, _B19} = lib_proto:read_uint32(_B18),
        {[P1_type, P1_role_id, P1_srv_id, P1_group_id, P1_name, P1_sex, P1_career, P1_lev, P1_intimacy, P1_online_late, P1_map_id, P1_face_id, P1_vip_type, P1_signature, P1_prestige, P1_guild, P1_online, P1_fight], _B19}
    end),
    {ok, {P0_friend_list}};

unpack(srv, 12181, _B0) ->
    {P0_role_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_type, _B3} = lib_proto:read_uint32(_B2),
    {ok, {P0_role_id, P0_srv_id, P0_type}};
unpack(cli, 12181, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_result, P0_msg_id}};

unpack(srv, 12182, _B0) ->
    {P0_role_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_role_id, P0_srv_id}};
unpack(cli, 12182, _B0) ->
    {P0_recv_cnt, _B1} = lib_proto:read_uint8(_B0),
    {P0_result, _B2} = lib_proto:read_uint8(_B1),
    {P0_msg_id, _B3} = lib_proto:read_uint16(_B2),
    {ok, {P0_recv_cnt, P0_result, P0_msg_id}};

unpack(srv, 12183, _B0) ->
    {ok, {}};
unpack(cli, 12183, _B0) ->
    {P0_list, _B6} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_role_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_srv_id, _B3} = lib_proto:read_string(_B2),
        {P1_give_flag, _B4} = lib_proto:read_uint8(_B3),
        {P1_recv_flag, _B5} = lib_proto:read_uint8(_B4),
        {[P1_role_id, P1_srv_id, P1_give_flag, P1_recv_flag], _B5}
    end),
    {ok, {P0_list}};

unpack(srv, 12184, _B0) ->
    {ok, {}};
unpack(cli, 12184, _B0) ->
    {P0_recv_cnt, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_recv_cnt}};

unpack(srv, 12185, _B0) ->
    {ok, {}};
unpack(cli, 12185, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_result, P0_msg_id}};

unpack(srv, 12186, _B0) ->
    {ok, {}};
unpack(cli, 12186, _B0) ->
    {P0_apply_num, _B1} = lib_proto:read_uint8(_B0),
    {P0_recv_num, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_apply_num, P0_recv_num}};

unpack(srv, 12190, _B0) ->
    {ok, {}};
unpack(cli, 12190, _B0) ->
    {P0_code, _B1} = lib_proto:read_string(_B0),
    {P0_recruit, _B2} = lib_proto:read_uint8(_B1),
    {P0_awards, _B8} = lib_proto:read_array(_B2, fun(_B3) ->
        {P1_id, _B4} = lib_proto:read_uint32(_B3),
        {P1_gift_id, _B5} = lib_proto:read_uint32(_B4),
        {P1_status, _B6} = lib_proto:read_uint8(_B5),
        {P1_need, _B7} = lib_proto:read_uint8(_B6),
        {[P1_id, P1_gift_id, P1_status, P1_need], _B7}
    end),
    {ok, {P0_code, P0_recruit, P0_awards}};

unpack(srv, 12191, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 12191, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_result}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
