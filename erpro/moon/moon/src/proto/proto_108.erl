%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_108).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("team.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(10800), {P0_msg, P0_team_id, P0_leader_id, P0_leader_srvid, P0_members}) ->
    D_a_t_a = <<?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_team_id, '32'):32, ?_(P0_leader_id, '32'):32, ?_((byte_size(P0_leader_srvid)), "16"):16, ?_(P0_leader_srvid, bin)/binary, ?_((length(P0_members)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '8'):8, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_vip_type, '8'):8, ?_(P1_face_id, '16'):16, ?_(P1_team_status, '8'):8, ?_(P1_hp_max, '32'):32, ?_(P1_mp_max, '32'):32, ?_(P1_hp, '32'):32, ?_(P1_mp, '32'):32, ?_(P1_fight, '32'):32, ?_(P1_pet_fight, '32'):32>> || [P1_id, P1_srv_id, P1_name, P1_lev, P1_career, P1_sex, P1_vip_type, P1_face_id, P1_team_status, P1_hp_max, P1_mp_max, P1_hp, P1_mp, P1_fight, P1_pet_fight] <- P0_members]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10800:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10800), {P0_team_id}) ->
    D_a_t_a = <<?_(P0_team_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10800:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10801), {P0_direct_in}) ->
    D_a_t_a = <<?_(P0_direct_in, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10801:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10801), {P0_direct_in}) ->
    D_a_t_a = <<?_(P0_direct_in, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10801:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10803), {P0_id, P0_srvid, P0_looks}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_srvid)), "16"):16, ?_(P0_srvid, bin)/binary, ?_((length(P0_looks)), "16"):16, (list_to_binary([<<?_(P1_looks_type, '8'):8, ?_(P1_looks_id, '32'):32, ?_(P1_looks_value, '16'):16>> || {P1_looks_type, P1_looks_id, P1_looks_value} <- P0_looks]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10803:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10803), {P0_id, P0_srvid}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_srvid)), "16"):16, ?_(P0_srvid, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10803:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10805), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10805:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10805), {P0_id, P0_srv_id, P0_msg}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10805:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10806), {P0_id, P0_srv_id, P0_name, P0_msg}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10806:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10806), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10806:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10807), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10807:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10807), {P0_result, P0_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10807:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10810), {P0_type, P0_role_list}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_((length(P0_role_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '8'):8, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_fight, '32'):32>> || {P1_id, P1_srv_id, P1_name, P1_lev, P1_career, P1_sex, P1_fight} <- P0_role_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10810:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10810), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10810:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10811), {P0_team_list}) ->
    D_a_t_a = <<?_((length(P0_team_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_cnt, '8'):8>> || {P1_id, P1_srv_id, P1_name, P1_lev, P1_sex, P1_cnt} <- P0_team_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10811:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10811), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10811:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10812), {P0_role_list}) ->
    D_a_t_a = <<?_((length(P0_role_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_career, '8'):8, ?_(P1_fight, '32'):32, ?_(P1_fight_pet, '32'):32>> || {P1_id, P1_srv_id, P1_name, P1_lev, P1_sex, P1_career, P1_fight, P1_fight_pet} <- P0_role_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10812:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10812), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10812:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10815), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10815:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10815), {P0_member_id, P0_member_srv_id}) ->
    D_a_t_a = <<?_(P0_member_id, '32'):32, ?_((byte_size(P0_member_srv_id)), "16"):16, ?_(P0_member_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10815:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10817), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10817:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10817), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10817:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10818), {P0_team_id, P0_msg}) ->
    D_a_t_a = <<?_(P0_team_id, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10818:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10818), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10818:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10819), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10819:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10819), {P0_member_id, P0_member_srv_id}) ->
    D_a_t_a = <<?_(P0_member_id, '32'):32, ?_((byte_size(P0_member_srv_id)), "16"):16, ?_(P0_member_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10819:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10820), {P0_team_id, P0_msg}) ->
    D_a_t_a = <<?_(P0_team_id, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10820:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10820), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10820:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10831), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10831:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10831), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10831:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10832), {P0_result, P0_msg, P0_map_baseid, P0_x, P0_y}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_map_baseid, '32'):32, ?_(P0_x, '32'):32, ?_(P0_y, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10832:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10832), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10832:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10841), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10841:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10841), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10841:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10842), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10842:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10842), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10842:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10851), {P0_invite_list}) ->
    D_a_t_a = <<?_((length(P0_invite_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_((byte_size(P1_guild_name)), "16"):16, ?_(P1_guild_name, bin)/binary, ?_(P1_lev, '8'):8, ?_(P1_career, '8'):8, ?_(P1_face_id, '16'):16>> || [P1_id, P1_srv_id, P1_name, P1_guild_name, P1_lev, P1_career, P1_face_id] <- P0_invite_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10851:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10851), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10851:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10852), {P0_apply_list}) ->
    D_a_t_a = <<?_((length(P0_apply_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_((byte_size(P1_guild_name)), "16"):16, ?_(P1_guild_name, bin)/binary, ?_(P1_lev, '8'):8, ?_(P1_career, '8'):8, ?_(P1_face_id, '16'):16>> || [P1_id, P1_srv_id, P1_name, P1_guild_name, P1_lev, P1_career, P1_face_id] <- P0_apply_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10852:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10852), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10852:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10853), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10853:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10853), {P0_dung_id, P0_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_dung_id, '32'):32, ?_(P0_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10853:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10854), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10854:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10854), {P0_dung_id, P0_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_dung_id, '32'):32, ?_(P0_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10854:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10855), {P0_team_list}) ->
    D_a_t_a = <<?_((length(P0_team_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_fight, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_num, '8'):8, ?_(P1_count, '8'):8>> || {P1_id, P1_srv_id, P1_name, P1_fight, P1_lev, P1_sex, P1_num, P1_count} <- P0_team_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10855:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10855), {P0_dung_id}) ->
    D_a_t_a = <<?_(P0_dung_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10855:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10856), {P0_role_list}) ->
    D_a_t_a = <<?_((length(P0_role_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_fight, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_career, '8'):8, ?_(P1_count, '8'):8>> || {P1_id, P1_srv_id, P1_name, P1_fight, P1_lev, P1_sex, P1_career, P1_count} <- P0_role_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10856:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10856), {P0_dung_id}) ->
    D_a_t_a = <<?_(P0_dung_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10856:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10857), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10857:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10857), {P0_dung_id}) ->
    D_a_t_a = <<?_(P0_dung_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10857:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10858), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10858:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10858), {P0_dung_id}) ->
    D_a_t_a = <<?_(P0_dung_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10858:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
