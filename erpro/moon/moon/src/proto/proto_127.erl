%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_127).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("guild.hrl").
-include("item.hrl").
-include("pet.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(12700), {P0_gid, P0_srv_id, P0_position, P0_devote, P0_donation, P0_salary, P0_is_claim, P0_today_donation, P0_fund, P0_coin, P0_gold, P0_name, P0_gvip, P0_chief, P0_rvip, P0_lev, P0_num, P0_maxnum, P0_bulletin, P0_exp, P0_skill_list, P0_qq, P0_yy, P0_stove_lev, P0_wish_lev, P0_shop_lev}) ->
    D_a_t_a = <<?_(P0_gid, '16'):16, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_position, '8'):8, ?_(P0_devote, '32'):32, ?_(P0_donation, '32'):32, ?_(P0_salary, '32'):32, ?_(P0_is_claim, '8'):8, ?_(P0_today_donation, '32'):32, ?_(P0_fund, '32'):32, ?_(P0_coin, '32'):32, ?_(P0_gold, '32'):32, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_gvip, '8'):8, ?_((byte_size(P0_chief)), "16"):16, ?_(P0_chief, bin)/binary, ?_(P0_rvip, '8'):8, ?_(P0_lev, '8'):8, ?_(P0_num, '16'):16, ?_(P0_maxnum, '16'):16, ?_((byte_size(P0_bulletin)), "16"):16, ?_(P0_bulletin, bin)/binary, ?_(P0_exp, '32/signed'):32/signed, ?_((length(P0_skill_list)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_lev, '8'):8>> || {P1_type, P1_lev} <- P0_skill_list]))/binary, ?_((byte_size(P0_qq)), "16"):16, ?_(P0_qq, bin)/binary, ?_((byte_size(P0_yy)), "16"):16, ?_(P0_yy, bin)/binary, ?_(P0_stove_lev, '8'):8, ?_(P0_wish_lev, '8'):8, ?_(P0_shop_lev, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12700:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12700), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12700:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12701), {P0_allpage, P0_curpage, P0_guild_list, P0_role_applyed_list}) ->
    D_a_t_a = <<?_(P0_allpage, '8'):8, ?_(P0_curpage, '8'):8, ?_((length(P0_guild_list)), "16"):16, (list_to_binary([<<?_(P1_gid, '16'):16, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_gvip, '8'):8, ?_((byte_size(P1_chief)), "16"):16, ?_(P1_chief, bin)/binary, ?_(P1_rvip, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_num, '16'):16, ?_(P1_maxnum, '16'):16, ?_(P1_realm, '8'):8>> || #guild_pic{gid = P1_gid, srv_id = P1_srv_id, name = P1_name, gvip = P1_gvip, chief = P1_chief, rvip = P1_rvip, lev = P1_lev, num = P1_num, maxnum = P1_maxnum, realm = P1_realm} <- P0_guild_list]))/binary, ?_((length(P0_role_applyed_list)), "16"):16, (list_to_binary([<<?_(P1_id, '16'):16, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary>> || {P1_id, P1_srv_id} <- P0_role_applyed_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12701:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12701), {P0_page}) ->
    D_a_t_a = <<?_(P0_page, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12701:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12702), {P0_name, P0_gvip, P0_chief, P0_rvip, P0_rid, P0_rsrvid, P0_lev, P0_num, P0_maxnum, P0_bulletin, P0_fund, P0_exp, P0_skill_list}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_gvip, '8'):8, ?_((byte_size(P0_chief)), "16"):16, ?_(P0_chief, bin)/binary, ?_(P0_rvip, '8'):8, ?_(P0_rid, '32'):32, ?_((byte_size(P0_rsrvid)), "16"):16, ?_(P0_rsrvid, bin)/binary, ?_(P0_lev, '8'):8, ?_(P0_num, '16'):16, ?_(P0_maxnum, '16'):16, ?_((byte_size(P0_bulletin)), "16"):16, ?_(P0_bulletin, bin)/binary, ?_(P0_fund, '32/signed'):32/signed, ?_(P0_exp, '32/signed'):32/signed, ?_((length(P0_skill_list)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_lev, '8'):8>> || {P1_type, P1_lev} <- P0_skill_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12702:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12702), {P0_gid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_gid, '16'):16, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12702:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12703), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12703:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12703), {P0_way, P0_name, P0_bulletin}) ->
    D_a_t_a = <<?_(P0_way, '8'):8, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_((byte_size(P0_bulletin)), "16"):16, ?_(P0_bulletin, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12703:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12704), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12704:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12704), {P0_name}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12704:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12705), {P0_status, P0_msg, P0_gid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16, ?_(P0_gid, '16'):16, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12705:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12705), {P0_gid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_gid, '16'):16, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12705:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12706), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12706:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12706), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12706:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12707), {P0_name, P0_gvip, P0_chief, P0_rvip, P0_lev, P0_num, P0_maxnum, P0_fund, P0_day_fund, P0_bulletin, P0_qq, P0_yy}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_gvip, '8'):8, ?_((byte_size(P0_chief)), "16"):16, ?_(P0_chief, bin)/binary, ?_(P0_rvip, '8'):8, ?_(P0_lev, '8'):8, ?_(P0_num, '16'):16, ?_(P0_maxnum, '16'):16, ?_(P0_fund, '32/signed'):32/signed, ?_(P0_day_fund, '32/signed'):32/signed, ?_((byte_size(P0_bulletin)), "16"):16, ?_(P0_bulletin, bin)/binary, ?_((byte_size(P0_qq)), "16"):16, ?_(P0_qq, bin)/binary, ?_((byte_size(P0_yy)), "16"):16, ?_(P0_yy, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12707:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12707), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12707:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12708), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12708:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12708), {P0_rid, P0_srv_id, P0_result}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12708:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12709), {P0_apply_list}) ->
    D_a_t_a = <<?_((length(P0_apply_list)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '8'):8, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_fight, '32'):32, ?_(P1_vip, '8'):8>> || #apply_list{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, lev = P1_lev, career = P1_career, sex = P1_sex, fight = P1_fight, vip = P1_vip} <- P0_apply_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12709:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12709), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12709:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12710), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12710:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12710), {P0_bulletin, P0_qq, P0_yy}) ->
    D_a_t_a = <<?_((byte_size(P0_bulletin)), "16"):16, ?_(P0_bulletin, bin)/binary, ?_((byte_size(P0_qq)), "16"):16, ?_(P0_qq, bin)/binary, ?_((byte_size(P0_yy)), "16"):16, ?_(P0_yy, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12710:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12711), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12711:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12711), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12711:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12712), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12712:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12712), {P0_coin, P0_gold}) ->
    D_a_t_a = <<?_(P0_coin, '32'):32, ?_(P0_gold, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12712:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12713), {P0_msg_list}) ->
    D_a_t_a = <<?_((length(P0_msg_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_vip, '8'):8, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_((byte_size(P1_msg)), "16"):16, ?_(P1_msg, bin)/binary, ?_(P1_date, '32'):32>> || {P1_id, P1_vip, P1_name, P1_msg, P1_date} <- P0_msg_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12713:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12713), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12713:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12714), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12714:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12714), {P0_msg}) ->
    D_a_t_a = <<?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12714:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12715), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12715:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12715), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12715:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12716), {P0_invited_guild}) ->
    D_a_t_a = <<?_((length(P0_invited_guild)), "16"):16, (list_to_binary([<<?_(P1_gid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_((byte_size(P1_inviter)), "16"):16, ?_(P1_inviter, bin)/binary>> || {P1_gid, P1_srv_id, P1_name, P1_inviter} <- P0_invited_guild]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12716:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12716), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12716:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12717), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12717:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12717), {P0_gid, P0_srv_id, P0_status}) ->
    D_a_t_a = <<?_(P0_gid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_status, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12717:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12718), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12718:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12718), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12718:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12719), {P0_members}) ->
    D_a_t_a = <<?_((length(P0_members)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '8'):8, ?_(P1_position, '8'):8, ?_(P1_fight, '32'):32, ?_(P1_vip, '8'):8, ?_(P1_gravatar, '32'):32, ?_(P1_donation, '32'):32, ?_(P1_date, '32'):32, ?_(P1_pid, '8'):8, ?_(P1_pet_fight, '32'):32, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8>> || #guild_member{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, lev = P1_lev, position = P1_position, fight = P1_fight, vip = P1_vip, gravatar = P1_gravatar, donation = P1_donation, date = P1_date, pid = P1_pid, pet_fight = P1_pet_fight, career = P1_career, sex = P1_sex} <- P0_members]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12719:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12719), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12719:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12720), {P0_status, P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12720:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12720), {P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12720:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12721), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12721:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12721), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12721:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12722), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12722:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12722), {P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12722:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12723), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12723:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12723), {P0_rid, P0_srv_id, P0_pre_position, P0_position}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_pre_position, '8'):8, ?_(P0_position, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12723:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12724), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12724:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12724), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12724:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12725), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12725:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12725), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12725:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12726), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12726:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12726), {P0_lev, P0_zdl}) ->
    D_a_t_a = <<?_(P0_lev, '8'):8, ?_(P0_zdl, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12726:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12727), {P0_lev_limit, P0_zdl_limit}) ->
    D_a_t_a = <<?_(P0_lev_limit, '16'):16, ?_(P0_zdl_limit, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12727:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12727), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12727:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12729), {P0_status, P0_msg, P0_id}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16, ?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12729:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12729), {P0_id, P0_pos}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_pos, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12729:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12730), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12730:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12730), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12730:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12731), {P0_status, P0_msg, P0_id}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12731:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12731), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12731:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12732), {P0_items}) ->
    D_a_t_a = <<?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_date, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_type, '8'):8, ?_((byte_size(P1_item)), "16"):16, ?_(P1_item, bin)/binary, ?_(P1_num, '8'):8>> || #store_log{date = P1_date, name = P1_name, type = P1_type, item = P1_item, num = P1_num} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12732:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12732), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12732:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12733), {P0_items}) ->
    D_a_t_a = <<?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_upgrade, '8'):8, ?_(P1_enchant, '8/signed'):8/signed, ?_(P1_enchant_fail, '8'):8, ?_(P1_quantity, '8'):8, ?_(P1_status, '8'):8, ?_(P1_pos, '16'):16, ?_(P1_lasttime, '32'):32, ?_(P1_durability, '32/signed'):32/signed, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary>> || #item{id = P1_id, base_id = P1_base_id, bind = P1_bind, upgrade = P1_upgrade, enchant = P1_enchant, enchant_fail = P1_enchant_fail, quantity = P1_quantity, status = P1_status, pos = P1_pos, lasttime = P1_lasttime, durability = P1_durability, attr = P1_attr} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12733:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12733), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12733:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12734), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12734:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12734), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12734:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12735), {P0_donation_list}) ->
    D_a_t_a = <<?_((length(P0_donation_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_vip, '8'):8, ?_(P1_position, '8'):8, ?_(P1_gold, '32'):32, ?_(P1_coin, '32'):32, ?_(P1_fight, '32'):32, ?_(P1_donation, '32'):32>> || #guild_member{name = P1_name, vip = P1_vip, position = P1_position, gold = P1_gold, coin = P1_coin, fight = P1_fight, donation = P1_donation} <- P0_donation_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12735:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12735), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12735:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12736), {P0_devote_log}) ->
    D_a_t_a = <<?_((length(P0_devote_log)), "16"):16, (list_to_binary([<<?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_date, '32'):32>> || {P1_name, P1_date} <- P0_devote_log]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12736:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12736), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12736:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12737), {P0_skill_list, P0_skilled}) ->
    D_a_t_a = <<?_((length(P0_skill_list)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_lev, '8'):8>> || {P1_type, P1_lev} <- P0_skill_list]))/binary, ?_((length(P0_skilled)), "16"):16, (list_to_binary([<<?_(P1_typed, '8'):8>> || P1_typed <- P0_skilled]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12737:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12737), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12737:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12738), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12738:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12738), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12738:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12739), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12739:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12739), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12739:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12740), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12740:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12740), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12740:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12741), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12741:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12741), {P0_type, P0_lev}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_lev, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12741:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12742), {P0_g_lev, P0_g_fund, P0_w_lev, P0_w_glev, P0_w_fund, P0_s_lev, P0_s_glev, P0_s_fund}) ->
    D_a_t_a = <<?_(P0_g_lev, '8'):8, ?_(P0_g_fund, '32'):32, ?_(P0_w_lev, '8'):8, ?_(P0_w_glev, '8'):8, ?_(P0_w_fund, '32'):32, ?_(P0_s_lev, '8'):8, ?_(P0_s_glev, '8'):8, ?_(P0_s_fund, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12742:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12742), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12742:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12743), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12743:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12743), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12743:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12744), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12744:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12744), {P0_msg}) ->
    D_a_t_a = <<?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12744:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12745), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12745:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12745), {P0_skill, P0_stove, P0_store}) ->
    D_a_t_a = <<?_(P0_skill, '32'):32, ?_(P0_stove, '32'):32, ?_(P0_store, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12745:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12746), {P0_skill, P0_stove, P0_store}) ->
    D_a_t_a = <<?_(P0_skill, '32'):32, ?_(P0_stove, '32'):32, ?_(P0_store, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12746:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12746), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12746:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12747), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12747:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12747), {P0_devote}) ->
    D_a_t_a = <<?_(P0_devote, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12747:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12748), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12748:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12748), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12748:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12749), {P0_rem}) ->
    D_a_t_a = <<?_(P0_rem, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12749:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12749), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12749:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12750), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12750:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12750), {P0_petid, P0_time}) ->
    D_a_t_a = <<?_(P0_petid, '32'):32, ?_(P0_time, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12750:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12751), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12751:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12751), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12751:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12752), {P0_guild}) ->
    D_a_t_a = <<?_((byte_size(P0_guild)), "16"):16, ?_(P0_guild, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12752:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12752), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12752:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12753), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12753:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12753), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12753:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12754), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12754:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12754), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12754:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12755), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12755:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12755), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12755:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12758), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12758:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12758), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12758:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12759), {P0_exp, P0_spirit}) ->
    D_a_t_a = <<?_(P0_exp, '32'):32, ?_(P0_spirit, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12759:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12759), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12759:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12760), {P0_name}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12760:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12760), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12760:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12761), {P0_task_info}) ->
    D_a_t_a = <<?_((length(P0_task_info)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_finish_val, '32'):32, ?_(P1_cur_val, '32'):32, ?_(P1_status, '32'):32>> || {P1_id, P1_finish_val, P1_cur_val, P1_status} <- P0_task_info]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12761:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12761), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12761:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12762), {P0_msg}) ->
    D_a_t_a = <<?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12762:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12762), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12762:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12763), {P0_column, P0_type}) ->
    D_a_t_a = <<?_(P0_column, '8'):8, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12763:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12763), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12763:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12764), {P0_column, P0_type}) ->
    D_a_t_a = <<?_(P0_column, '8'):8, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12764:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12764), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12764:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12765), {P0_aims}) ->
    D_a_t_a = <<?_((length(P0_aims)), "16"):16, (list_to_binary([<<?_(P1_column, '8'):8, ?_(P1_type, '8'):8, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_fund, '32'):32, ?_((length(P1_items)), "16"):16, (list_to_binary([<<?_(P2_base_id, '16'):16, ?_(P2_bind, '8'):8, ?_(P2_num, '8'):8>> || {P2_base_id, P2_bind, P2_num} <- P1_items]))/binary>> || {P1_column, P1_type, P1_name, P1_fund, P1_items} <- P0_aims]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12765:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12765), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12765:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12766), {P0_status, P0_msg, P0_gid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_gid, '16'):16, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12766:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12766), {P0_gid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_gid, '16'):16, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12766:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12767), {P0_times, P0_cost}) ->
    D_a_t_a = <<?_(P0_times, '8'):8, ?_(P0_cost, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12767:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12767), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12767:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12768), {P0_msg}) ->
    D_a_t_a = <<?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12768:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12768), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12768:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12769), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12769:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12769), {P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12769:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12770), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12770:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12770), {P0_minute}) ->
    D_a_t_a = <<?_(P0_minute, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12770:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12771), {P0_type, P0_treasures, P0_credits}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_((length(P0_treasures)), "16"):16, (list_to_binary([<<?_(P1_id, '16'):16, ?_(P1_value, '16'):16, ?_(P1_baseid, '16'):16, ?_(P1_bind, '8'):8, ?_(P1_num, '16'):16>> || {P1_id, P1_value, P1_baseid, P1_bind, P1_num} <- P0_treasures]))/binary, ?_((length(P0_credits)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '8'):8, ?_(P1_credit, '16'):16>> || {P1_rid, P1_srv_id, P1_name, P1_lev, P1_credit} <- P0_credits]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12771:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12771), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12771:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12772), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12772:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12772), {P0_type, P0_id, P0_srv_id, P0_item_id, P0_quantity}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_item_id, '32'):32, ?_(P0_quantity, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12772:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12773), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12773:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12773), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12773:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12774), {P0_credit_compete, P0_credit_sword, P0_credit, P0_credits}) ->
    D_a_t_a = <<?_(P0_credit_compete, '16'):16, ?_(P0_credit_sword, '16'):16, ?_(P0_credit, '16'):16, ?_((length(P0_credits)), "16"):16, (list_to_binary([<<?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_combat, '16'):16, ?_(P1_stone, '16'):16, ?_(P1_compete, '16'):16, ?_(P1_sword, '16'):16, ?_(P1_credit, '16'):16>> || {P1_name, P1_combat, P1_stone, P1_compete, P1_sword, P1_credit} <- P0_credits]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12774:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12774), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12774:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12775), {P0_type, P0_item_id, P0_quantity}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_item_id, '32'):32, ?_(P0_quantity, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12775:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12775), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12775:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12776), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12776:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12776), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12776:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12777), {P0_war_log, P0_arena_log, P0_boss_log}) ->
    D_a_t_a = <<?_((length(P0_war_log)), "16"):16, (list_to_binary([<<?_((byte_size(P1_gainer)), "16"):16, ?_(P1_gainer, bin)/binary, ?_((byte_size(P1_item)), "16"):16, ?_(P1_item, bin)/binary, ?_(P1_credit, '16'):16, ?_((byte_size(P1_mode)), "16"):16, ?_(P1_mode, bin)/binary, ?_(P1_time, '32'):32>> || {P1_gainer, P1_item, P1_credit, P1_mode, P1_time} <- P0_war_log]))/binary, ?_((length(P0_arena_log)), "16"):16, (list_to_binary([<<?_((byte_size(P1_gainer)), "16"):16, ?_(P1_gainer, bin)/binary, ?_((byte_size(P1_item)), "16"):16, ?_(P1_item, bin)/binary, ?_(P1_credit, '16'):16, ?_((byte_size(P1_mode)), "16"):16, ?_(P1_mode, bin)/binary, ?_(P1_time, '32'):32>> || {P1_gainer, P1_item, P1_credit, P1_mode, P1_time} <- P0_arena_log]))/binary, ?_((length(P0_boss_log)), "16"):16, (list_to_binary([<<?_((byte_size(P1_gainer)), "16"):16, ?_(P1_gainer, bin)/binary, ?_((byte_size(P1_item)), "16"):16, ?_(P1_item, bin)/binary, ?_(P1_dmg, '32'):32, ?_((byte_size(P1_mode)), "16"):16, ?_(P1_mode, bin)/binary, ?_(P1_time, '32'):32>> || {P1_gainer, P1_item, P1_dmg, P1_mode, P1_time} <- P0_boss_log]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12777:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12777), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12777:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12778), {P0_status, P0_time, P0_name, P0_ctime}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_time, '32'):32, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_ctime, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12778:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12778), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12778:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12779), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12779:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12779), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12779:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12780), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12780:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12780), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12780:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12781), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12781:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12781), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12781:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12782), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12782:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12782), {P0_name}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12782:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12783), {P0_first, P0_second, P0_third, P0_total, P0_credits}) ->
    D_a_t_a = <<?_(P0_first, '32'):32, ?_(P0_second, '32'):32, ?_(P0_third, '32'):32, ?_(P0_total, '32'):32, ?_((length(P0_credits)), "16"):16, (list_to_binary([<<?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '8'):8, ?_(P1_fc, '32'):32, ?_(P1_combat, '16'):16, ?_(P1_credit, '16'):16>> || {P1_name, P1_lev, P1_fc, P1_combat, P1_credit} <- P0_credits]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12783:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12783), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12783:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12784), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12784:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12784), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12784:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12785), {P0_code, P0_msg, P0_guild_list}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_((length(P0_guild_list)), "16"):16, (list_to_binary([<<?_(P1_gid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_guild_name)), "16"):16, ?_(P1_guild_name, bin)/binary>> || {P1_gid, P1_srv_id, P1_guild_name} <- P0_guild_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12785:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12785), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12785:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12786), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12786:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12786), {P0_gid1, P0_srv_id1, P0_guild_name1, P0_gid2, P0_srv_id2, P0_guild_name2}) ->
    D_a_t_a = <<?_(P0_gid1, '32'):32, ?_((byte_size(P0_srv_id1)), "16"):16, ?_(P0_srv_id1, bin)/binary, ?_((byte_size(P0_guild_name1)), "16"):16, ?_(P0_guild_name1, bin)/binary, ?_(P0_gid2, '32'):32, ?_((byte_size(P0_srv_id2)), "16"):16, ?_(P0_srv_id2, bin)/binary, ?_((byte_size(P0_guild_name2)), "16"):16, ?_(P0_guild_name2, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12786:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12787), {P0_rid, P0_srv_id, P0_name, P0_gid1, P0_gsrv_id1, P0_guild_name1, P0_gid2, P0_gsrv_id2, P0_guild_name2}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_gid1, '32'):32, ?_((byte_size(P0_gsrv_id1)), "16"):16, ?_(P0_gsrv_id1, bin)/binary, ?_((byte_size(P0_guild_name1)), "16"):16, ?_(P0_guild_name1, bin)/binary, ?_(P0_gid2, '32'):32, ?_((byte_size(P0_gsrv_id2)), "16"):16, ?_(P0_gsrv_id2, bin)/binary, ?_((byte_size(P0_guild_name2)), "16"):16, ?_(P0_guild_name2, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12787:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12787), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12787:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12788), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12788:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12788), {P0_gid1, P0_gsrv_id1, P0_gid2, P0_gsrv_id2, P0_flag}) ->
    D_a_t_a = <<?_(P0_gid1, '32'):32, ?_((byte_size(P0_gsrv_id1)), "16"):16, ?_(P0_gsrv_id1, bin)/binary, ?_(P0_gid2, '32'):32, ?_((byte_size(P0_gsrv_id2)), "16"):16, ?_(P0_gsrv_id2, bin)/binary, ?_(P0_flag, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12788:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12789), {P0_rid, P0_srv_id, P0_name, P0_lev, P0_career, P0_face}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_lev, '8'):8, ?_(P0_career, '8'):8, ?_(P0_face, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12789:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12789), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12789:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12790), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12790:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12790), {P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12790:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12791), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12791:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12791), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12791:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12792), {P0_times, P0_type, P0_val}) ->
    D_a_t_a = <<?_(P0_times, '32'):32, ?_(P0_type, '32'):32, ?_(P0_val, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12792:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12792), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12792:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12793), {P0_msg, P0_thing_type, P0_val, P0_num}) ->
    D_a_t_a = <<?_(P0_msg, '16'):16, ?_(P0_thing_type, '32'):32, ?_(P0_val, '32'):32, ?_(P0_num, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12793:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12793), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12793:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12794), {P0_msg}) ->
    D_a_t_a = <<?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12794:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12794), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12794:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12795), {P0_wish_item_log}) ->
    D_a_t_a = <<?_((length(P0_wish_item_log)), "16"):16, (list_to_binary([<<?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_item, '32'):32, ?_(P1_date, '32'):32>> || {P1_name, P1_item, P1_date} <- P0_wish_item_log]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12795:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12795), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12795:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12796), {P0_buy_times}) ->
    D_a_t_a = <<?_(P0_buy_times, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12796:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12796), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12796:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12797), {P0_msgid}) ->
    D_a_t_a = <<?_(P0_msgid, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12797:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12797), {P0_item_id, P0_item_num}) ->
    D_a_t_a = <<?_(P0_item_id, '32'):32, ?_(P0_item_num, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12797:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12798), {P0_members}) ->
    D_a_t_a = <<?_((length(P0_members)), "16"):16, (list_to_binary([<<?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '8'):8, ?_(P1_position, '8'):8, ?_(P1_fight, '32'):32>> || {P1_name, P1_lev, P1_position, P1_fight} <- P0_members]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12798:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12798), {P0_gid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_gid, '16'):16, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12798:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12799), {P0_res, P0_msg, P0_members}) ->
    D_a_t_a = <<?_(P0_res, '8'):8, ?_(P0_msg, '16'):16, ?_((length(P0_members)), "16"):16, (list_to_binary([<<?_(P1_gid, '16'):16, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary>> || {P1_gid, P1_srv_id} <- P0_members]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12799:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12799), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12799:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 12700, _B0) ->
    {ok, {}};
unpack(cli, 12700, _B0) ->
    {P0_gid, _B1} = lib_proto:read_uint16(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_position, _B3} = lib_proto:read_uint8(_B2),
    {P0_devote, _B4} = lib_proto:read_uint32(_B3),
    {P0_donation, _B5} = lib_proto:read_uint32(_B4),
    {P0_salary, _B6} = lib_proto:read_uint32(_B5),
    {P0_is_claim, _B7} = lib_proto:read_uint8(_B6),
    {P0_today_donation, _B8} = lib_proto:read_uint32(_B7),
    {P0_fund, _B9} = lib_proto:read_uint32(_B8),
    {P0_coin, _B10} = lib_proto:read_uint32(_B9),
    {P0_gold, _B11} = lib_proto:read_uint32(_B10),
    {P0_name, _B12} = lib_proto:read_string(_B11),
    {P0_gvip, _B13} = lib_proto:read_uint8(_B12),
    {P0_chief, _B14} = lib_proto:read_string(_B13),
    {P0_rvip, _B15} = lib_proto:read_uint8(_B14),
    {P0_lev, _B16} = lib_proto:read_uint8(_B15),
    {P0_num, _B17} = lib_proto:read_uint16(_B16),
    {P0_maxnum, _B18} = lib_proto:read_uint16(_B17),
    {P0_bulletin, _B19} = lib_proto:read_string(_B18),
    {P0_exp, _B20} = lib_proto:read_int32(_B19),
    {P0_skill_list, _B24} = lib_proto:read_array(_B20, fun(_B21) ->
        {P1_type, _B22} = lib_proto:read_uint8(_B21),
        {P1_lev, _B23} = lib_proto:read_uint8(_B22),
        {[P1_type, P1_lev], _B23}
    end),
    {P0_qq, _B25} = lib_proto:read_string(_B24),
    {P0_yy, _B26} = lib_proto:read_string(_B25),
    {P0_stove_lev, _B27} = lib_proto:read_uint8(_B26),
    {P0_wish_lev, _B28} = lib_proto:read_uint8(_B27),
    {P0_shop_lev, _B29} = lib_proto:read_uint8(_B28),
    {ok, {P0_gid, P0_srv_id, P0_position, P0_devote, P0_donation, P0_salary, P0_is_claim, P0_today_donation, P0_fund, P0_coin, P0_gold, P0_name, P0_gvip, P0_chief, P0_rvip, P0_lev, P0_num, P0_maxnum, P0_bulletin, P0_exp, P0_skill_list, P0_qq, P0_yy, P0_stove_lev, P0_wish_lev, P0_shop_lev}};

unpack(srv, 12701, _B0) ->
    {P0_page, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_page}};
unpack(cli, 12701, _B0) ->
    {P0_allpage, _B1} = lib_proto:read_uint8(_B0),
    {P0_curpage, _B2} = lib_proto:read_uint8(_B1),
    {P0_guild_list, _B14} = lib_proto:read_array(_B2, fun(_B3) ->
        {P1_gid, _B4} = lib_proto:read_uint16(_B3),
        {P1_srv_id, _B5} = lib_proto:read_string(_B4),
        {P1_name, _B6} = lib_proto:read_string(_B5),
        {P1_gvip, _B7} = lib_proto:read_uint8(_B6),
        {P1_chief, _B8} = lib_proto:read_string(_B7),
        {P1_rvip, _B9} = lib_proto:read_uint8(_B8),
        {P1_lev, _B10} = lib_proto:read_uint8(_B9),
        {P1_num, _B11} = lib_proto:read_uint16(_B10),
        {P1_maxnum, _B12} = lib_proto:read_uint16(_B11),
        {P1_realm, _B13} = lib_proto:read_uint8(_B12),
        {[P1_gid, P1_srv_id, P1_name, P1_gvip, P1_chief, P1_rvip, P1_lev, P1_num, P1_maxnum, P1_realm], _B13}
    end),
    {P0_role_applyed_list, _B18} = lib_proto:read_array(_B14, fun(_B15) ->
        {P1_id, _B16} = lib_proto:read_uint16(_B15),
        {P1_srv_id, _B17} = lib_proto:read_string(_B16),
        {[P1_id, P1_srv_id], _B17}
    end),
    {ok, {P0_allpage, P0_curpage, P0_guild_list, P0_role_applyed_list}};

unpack(srv, 12702, _B0) ->
    {P0_gid, _B1} = lib_proto:read_uint16(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_gid, P0_srv_id}};
unpack(cli, 12702, _B0) ->
    {P0_name, _B1} = lib_proto:read_string(_B0),
    {P0_gvip, _B2} = lib_proto:read_uint8(_B1),
    {P0_chief, _B3} = lib_proto:read_string(_B2),
    {P0_rvip, _B4} = lib_proto:read_uint8(_B3),
    {P0_rid, _B5} = lib_proto:read_uint32(_B4),
    {P0_rsrvid, _B6} = lib_proto:read_string(_B5),
    {P0_lev, _B7} = lib_proto:read_uint8(_B6),
    {P0_num, _B8} = lib_proto:read_uint16(_B7),
    {P0_maxnum, _B9} = lib_proto:read_uint16(_B8),
    {P0_bulletin, _B10} = lib_proto:read_string(_B9),
    {P0_fund, _B11} = lib_proto:read_int32(_B10),
    {P0_exp, _B12} = lib_proto:read_int32(_B11),
    {P0_skill_list, _B16} = lib_proto:read_array(_B12, fun(_B13) ->
        {P1_type, _B14} = lib_proto:read_uint8(_B13),
        {P1_lev, _B15} = lib_proto:read_uint8(_B14),
        {[P1_type, P1_lev], _B15}
    end),
    {ok, {P0_name, P0_gvip, P0_chief, P0_rvip, P0_rid, P0_rsrvid, P0_lev, P0_num, P0_maxnum, P0_bulletin, P0_fund, P0_exp, P0_skill_list}};

unpack(srv, 12703, _B0) ->
    {P0_way, _B1} = lib_proto:read_uint8(_B0),
    {P0_name, _B2} = lib_proto:read_string(_B1),
    {P0_bulletin, _B3} = lib_proto:read_string(_B2),
    {ok, {P0_way, P0_name, P0_bulletin}};
unpack(cli, 12703, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 12704, _B0) ->
    {P0_name, _B1} = lib_proto:read_string(_B0),
    {ok, {P0_name}};
unpack(cli, 12704, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 12705, _B0) ->
    {P0_gid, _B1} = lib_proto:read_uint16(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_gid, P0_srv_id}};
unpack(cli, 12705, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {P0_gid, _B3} = lib_proto:read_uint16(_B2),
    {P0_srv_id, _B4} = lib_proto:read_string(_B3),
    {ok, {P0_status, P0_msg, P0_gid, P0_srv_id}};

unpack(srv, 12706, _B0) ->
    {ok, {}};
unpack(cli, 12706, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 12707, _B0) ->
    {ok, {}};
unpack(cli, 12707, _B0) ->
    {P0_name, _B1} = lib_proto:read_string(_B0),
    {P0_gvip, _B2} = lib_proto:read_uint8(_B1),
    {P0_chief, _B3} = lib_proto:read_string(_B2),
    {P0_rvip, _B4} = lib_proto:read_uint8(_B3),
    {P0_lev, _B5} = lib_proto:read_uint8(_B4),
    {P0_num, _B6} = lib_proto:read_uint16(_B5),
    {P0_maxnum, _B7} = lib_proto:read_uint16(_B6),
    {P0_fund, _B8} = lib_proto:read_int32(_B7),
    {P0_day_fund, _B9} = lib_proto:read_int32(_B8),
    {P0_bulletin, _B10} = lib_proto:read_string(_B9),
    {P0_qq, _B11} = lib_proto:read_string(_B10),
    {P0_yy, _B12} = lib_proto:read_string(_B11),
    {ok, {P0_name, P0_gvip, P0_chief, P0_rvip, P0_lev, P0_num, P0_maxnum, P0_fund, P0_day_fund, P0_bulletin, P0_qq, P0_yy}};

unpack(srv, 12708, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_result, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_rid, P0_srv_id, P0_result}};
unpack(cli, 12708, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 12709, _B0) ->
    {ok, {}};
unpack(cli, 12709, _B0) ->
    {P0_apply_list, _B10} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_rid, _B2} = lib_proto:read_uint32(_B1),
        {P1_srv_id, _B3} = lib_proto:read_string(_B2),
        {P1_name, _B4} = lib_proto:read_string(_B3),
        {P1_lev, _B5} = lib_proto:read_uint8(_B4),
        {P1_career, _B6} = lib_proto:read_uint8(_B5),
        {P1_sex, _B7} = lib_proto:read_uint8(_B6),
        {P1_fight, _B8} = lib_proto:read_uint32(_B7),
        {P1_vip, _B9} = lib_proto:read_uint8(_B8),
        {[P1_rid, P1_srv_id, P1_name, P1_lev, P1_career, P1_sex, P1_fight, P1_vip], _B9}
    end),
    {ok, {P0_apply_list}};

unpack(srv, 12710, _B0) ->
    {P0_bulletin, _B1} = lib_proto:read_string(_B0),
    {P0_qq, _B2} = lib_proto:read_string(_B1),
    {P0_yy, _B3} = lib_proto:read_string(_B2),
    {ok, {P0_bulletin, P0_qq, P0_yy}};
unpack(cli, 12710, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 12711, _B0) ->
    {ok, {}};
unpack(cli, 12711, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 12712, _B0) ->
    {P0_coin, _B1} = lib_proto:read_uint32(_B0),
    {P0_gold, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_coin, P0_gold}};
unpack(cli, 12712, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 12713, _B0) ->
    {ok, {}};
unpack(cli, 12713, _B0) ->
    {P0_msg_list, _B7} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_vip, _B3} = lib_proto:read_uint8(_B2),
        {P1_name, _B4} = lib_proto:read_string(_B3),
        {P1_msg, _B5} = lib_proto:read_string(_B4),
        {P1_date, _B6} = lib_proto:read_uint32(_B5),
        {[P1_id, P1_vip, P1_name, P1_msg, P1_date], _B6}
    end),
    {ok, {P0_msg_list}};

unpack(srv, 12714, _B0) ->
    {P0_msg, _B1} = lib_proto:read_string(_B0),
    {ok, {P0_msg}};
unpack(cli, 12714, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 12715, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 12715, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 12716, _B0) ->
    {ok, {}};
unpack(cli, 12716, _B0) ->
    {P0_invited_guild, _B6} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_gid, _B2} = lib_proto:read_uint32(_B1),
        {P1_srv_id, _B3} = lib_proto:read_string(_B2),
        {P1_name, _B4} = lib_proto:read_string(_B3),
        {P1_inviter, _B5} = lib_proto:read_string(_B4),
        {[P1_gid, P1_srv_id, P1_name, P1_inviter], _B5}
    end),
    {ok, {P0_invited_guild}};

unpack(srv, 12717, _B0) ->
    {P0_gid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_status, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_gid, P0_srv_id, P0_status}};
unpack(cli, 12717, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 12718, _B0) ->
    {ok, {}};
unpack(cli, 12718, _B0) ->
    {ok, {}};

unpack(srv, 12719, _B0) ->
    {ok, {}};
unpack(cli, 12719, _B0) ->
    {P0_members, _B16} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_rid, _B2} = lib_proto:read_uint32(_B1),
        {P1_srv_id, _B3} = lib_proto:read_string(_B2),
        {P1_name, _B4} = lib_proto:read_string(_B3),
        {P1_lev, _B5} = lib_proto:read_uint8(_B4),
        {P1_position, _B6} = lib_proto:read_uint8(_B5),
        {P1_fight, _B7} = lib_proto:read_uint32(_B6),
        {P1_vip, _B8} = lib_proto:read_uint8(_B7),
        {P1_gravatar, _B9} = lib_proto:read_uint32(_B8),
        {P1_donation, _B10} = lib_proto:read_uint32(_B9),
        {P1_date, _B11} = lib_proto:read_uint32(_B10),
        {P1_pid, _B12} = lib_proto:read_uint8(_B11),
        {P1_pet_fight, _B13} = lib_proto:read_uint32(_B12),
        {P1_career, _B14} = lib_proto:read_uint8(_B13),
        {P1_sex, _B15} = lib_proto:read_uint8(_B14),
        {[P1_rid, P1_srv_id, P1_name, P1_lev, P1_position, P1_fight, P1_vip, P1_gravatar, P1_donation, P1_date, P1_pid, P1_pet_fight, P1_career, P1_sex], _B15}
    end),
    {ok, {P0_members}};

unpack(srv, 12720, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_rid, P0_srv_id}};
unpack(cli, 12720, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_rid, _B2} = lib_proto:read_uint32(_B1),
    {P0_srv_id, _B3} = lib_proto:read_string(_B2),
    {ok, {P0_status, P0_rid, P0_srv_id}};

unpack(srv, 12721, _B0) ->
    {ok, {}};
unpack(cli, 12721, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 12722, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_rid, P0_srv_id}};
unpack(cli, 12722, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 12723, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_pre_position, _B3} = lib_proto:read_uint8(_B2),
    {P0_position, _B4} = lib_proto:read_uint8(_B3),
    {ok, {P0_rid, P0_srv_id, P0_pre_position, P0_position}};
unpack(cli, 12723, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 12724, _B0) ->
    {ok, {}};
unpack(cli, 12724, _B0) ->
    {ok, {}};

unpack(srv, 12725, _B0) ->
    {ok, {}};
unpack(cli, 12725, _B0) ->
    {ok, {}};

unpack(srv, 12726, _B0) ->
    {P0_lev, _B1} = lib_proto:read_uint8(_B0),
    {P0_zdl, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_lev, P0_zdl}};
unpack(cli, 12726, _B0) ->
    {ok, {}};

unpack(srv, 12727, _B0) ->
    {ok, {}};
unpack(cli, 12727, _B0) ->
    {P0_lev_limit, _B1} = lib_proto:read_uint16(_B0),
    {P0_zdl_limit, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_lev_limit, P0_zdl_limit}};

unpack(srv, 12734, _B0) ->
    {ok, {}};
unpack(cli, 12734, _B0) ->
    {ok, {}};

unpack(srv, 12735, _B0) ->
    {ok, {}};
unpack(cli, 12735, _B0) ->
    {P0_donation_list, _B9} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_name, _B2} = lib_proto:read_string(_B1),
        {P1_vip, _B3} = lib_proto:read_uint8(_B2),
        {P1_position, _B4} = lib_proto:read_uint8(_B3),
        {P1_gold, _B5} = lib_proto:read_uint32(_B4),
        {P1_coin, _B6} = lib_proto:read_uint32(_B5),
        {P1_fight, _B7} = lib_proto:read_uint32(_B6),
        {P1_donation, _B8} = lib_proto:read_uint32(_B7),
        {[P1_name, P1_vip, P1_position, P1_gold, P1_coin, P1_fight, P1_donation], _B8}
    end),
    {ok, {P0_donation_list}};

unpack(srv, 12736, _B0) ->
    {ok, {}};
unpack(cli, 12736, _B0) ->
    {P0_devote_log, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_name, _B2} = lib_proto:read_string(_B1),
        {P1_date, _B3} = lib_proto:read_uint32(_B2),
        {[P1_name, P1_date], _B3}
    end),
    {ok, {P0_devote_log}};

unpack(srv, 12737, _B0) ->
    {ok, {}};
unpack(cli, 12737, _B0) ->
    {P0_skill_list, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_type, _B2} = lib_proto:read_uint8(_B1),
        {P1_lev, _B3} = lib_proto:read_uint8(_B2),
        {[P1_type, P1_lev], _B3}
    end),
    {P0_skilled, _B7} = lib_proto:read_array(_B4, fun(_B5) ->
        {P1_typed, _B6} = lib_proto:read_uint8(_B5),
        {P1_typed, _B6}
    end),
    {ok, {P0_skill_list, P0_skilled}};

unpack(srv, 12738, _B0) ->
    {ok, {}};
unpack(cli, 12738, _B0) ->
    {ok, {}};

unpack(srv, 12739, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_type}};
unpack(cli, 12739, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 12740, _B0) ->
    {ok, {}};
unpack(cli, 12740, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 12741, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_lev, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_type, P0_lev}};
unpack(cli, 12741, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 12742, _B0) ->
    {ok, {}};
unpack(cli, 12742, _B0) ->
    {P0_g_lev, _B1} = lib_proto:read_uint8(_B0),
    {P0_g_fund, _B2} = lib_proto:read_uint32(_B1),
    {P0_w_lev, _B3} = lib_proto:read_uint8(_B2),
    {P0_w_glev, _B4} = lib_proto:read_uint8(_B3),
    {P0_w_fund, _B5} = lib_proto:read_uint32(_B4),
    {P0_s_lev, _B6} = lib_proto:read_uint8(_B5),
    {P0_s_glev, _B7} = lib_proto:read_uint8(_B6),
    {P0_s_fund, _B8} = lib_proto:read_uint32(_B7),
    {ok, {P0_g_lev, P0_g_fund, P0_w_lev, P0_w_glev, P0_w_fund, P0_s_lev, P0_s_glev, P0_s_fund}};

unpack(srv, 12743, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_type}};
unpack(cli, 12743, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 12744, _B0) ->
    {P0_msg, _B1} = lib_proto:read_string(_B0),
    {ok, {P0_msg}};
unpack(cli, 12744, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 12745, _B0) ->
    {P0_skill, _B1} = lib_proto:read_uint32(_B0),
    {P0_stove, _B2} = lib_proto:read_uint32(_B1),
    {P0_store, _B3} = lib_proto:read_uint32(_B2),
    {ok, {P0_skill, P0_stove, P0_store}};
unpack(cli, 12745, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 12746, _B0) ->
    {ok, {}};
unpack(cli, 12746, _B0) ->
    {P0_skill, _B1} = lib_proto:read_uint32(_B0),
    {P0_stove, _B2} = lib_proto:read_uint32(_B1),
    {P0_store, _B3} = lib_proto:read_uint32(_B2),
    {ok, {P0_skill, P0_stove, P0_store}};

unpack(srv, 12752, _B0) ->
    {ok, {}};
unpack(cli, 12752, _B0) ->
    {P0_guild, _B1} = lib_proto:read_string(_B0),
    {ok, {P0_guild}};

unpack(srv, 12760, _B0) ->
    {ok, {}};
unpack(cli, 12760, _B0) ->
    {P0_name, _B1} = lib_proto:read_string(_B0),
    {ok, {P0_name}};

unpack(srv, 12761, _B0) ->
    {ok, {}};
unpack(cli, 12761, _B0) ->
    {P0_task_info, _B6} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_finish_val, _B3} = lib_proto:read_uint32(_B2),
        {P1_cur_val, _B4} = lib_proto:read_uint32(_B3),
        {P1_status, _B5} = lib_proto:read_uint32(_B4),
        {[P1_id, P1_finish_val, P1_cur_val, P1_status], _B5}
    end),
    {ok, {P0_task_info}};

unpack(srv, 12762, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_type}};
unpack(cli, 12762, _B0) ->
    {P0_msg, _B1} = lib_proto:read_string(_B0),
    {ok, {P0_msg}};

unpack(srv, 12763, _B0) ->
    {ok, {}};
unpack(cli, 12763, _B0) ->
    {P0_column, _B1} = lib_proto:read_uint8(_B0),
    {P0_type, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_column, P0_type}};

unpack(srv, 12764, _B0) ->
    {ok, {}};
unpack(cli, 12764, _B0) ->
    {P0_column, _B1} = lib_proto:read_uint8(_B0),
    {P0_type, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_column, P0_type}};

unpack(srv, 12765, _B0) ->
    {ok, {}};
unpack(cli, 12765, _B0) ->
    {P0_aims, _B11} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_column, _B2} = lib_proto:read_uint8(_B1),
        {P1_type, _B3} = lib_proto:read_uint8(_B2),
        {P1_name, _B4} = lib_proto:read_string(_B3),
        {P1_fund, _B5} = lib_proto:read_uint32(_B4),
        {P1_items, _B10} = lib_proto:read_array(_B5, fun(_B6) ->
            {P2_base_id, _B7} = lib_proto:read_uint16(_B6),
            {P2_bind, _B8} = lib_proto:read_uint8(_B7),
            {P2_num, _B9} = lib_proto:read_uint8(_B8),
            {[P2_base_id, P2_bind, P2_num], _B9}
        end),
        {[P1_column, P1_type, P1_name, P1_fund, P1_items], _B10}
    end),
    {ok, {P0_aims}};

unpack(srv, 12766, _B0) ->
    {P0_gid, _B1} = lib_proto:read_uint16(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_gid, P0_srv_id}};
unpack(cli, 12766, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {P0_gid, _B3} = lib_proto:read_uint16(_B2),
    {P0_srv_id, _B4} = lib_proto:read_string(_B3),
    {ok, {P0_status, P0_msg, P0_gid, P0_srv_id}};

unpack(srv, 12769, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_rid, P0_srv_id}};
unpack(cli, 12769, _B0) ->
    {ok, {}};

unpack(srv, 12782, _B0) ->
    {P0_name, _B1} = lib_proto:read_string(_B0),
    {ok, {P0_name}};
unpack(cli, 12782, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 12789, _B0) ->
    {ok, {}};
unpack(cli, 12789, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_name, _B3} = lib_proto:read_string(_B2),
    {P0_lev, _B4} = lib_proto:read_uint8(_B3),
    {P0_career, _B5} = lib_proto:read_uint8(_B4),
    {P0_face, _B6} = lib_proto:read_uint16(_B5),
    {ok, {P0_rid, P0_srv_id, P0_name, P0_lev, P0_career, P0_face}};

unpack(srv, 12790, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_rid, P0_srv_id}};
unpack(cli, 12790, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_code, P0_msg}};

unpack(srv, 12791, _B0) ->
    {ok, {}};
unpack(cli, 12791, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 12792, _B0) ->
    {ok, {}};
unpack(cli, 12792, _B0) ->
    {P0_times, _B1} = lib_proto:read_uint32(_B0),
    {P0_type, _B2} = lib_proto:read_uint32(_B1),
    {P0_val, _B3} = lib_proto:read_uint32(_B2),
    {ok, {P0_times, P0_type, P0_val}};

unpack(srv, 12793, _B0) ->
    {ok, {}};
unpack(cli, 12793, _B0) ->
    {P0_msg, _B1} = lib_proto:read_uint16(_B0),
    {P0_thing_type, _B2} = lib_proto:read_uint32(_B1),
    {P0_val, _B3} = lib_proto:read_uint32(_B2),
    {P0_num, _B4} = lib_proto:read_uint32(_B3),
    {ok, {P0_msg, P0_thing_type, P0_val, P0_num}};

unpack(srv, 12794, _B0) ->
    {ok, {}};
unpack(cli, 12794, _B0) ->
    {P0_msg, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_msg}};

unpack(srv, 12795, _B0) ->
    {ok, {}};
unpack(cli, 12795, _B0) ->
    {P0_wish_item_log, _B5} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_name, _B2} = lib_proto:read_string(_B1),
        {P1_item, _B3} = lib_proto:read_uint32(_B2),
        {P1_date, _B4} = lib_proto:read_uint32(_B3),
        {[P1_name, P1_item, P1_date], _B4}
    end),
    {ok, {P0_wish_item_log}};

unpack(srv, 12796, _B0) ->
    {ok, {}};
unpack(cli, 12796, _B0) ->
    {P0_buy_times, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_buy_times}};

unpack(srv, 12797, _B0) ->
    {P0_item_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_item_num, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_item_id, P0_item_num}};
unpack(cli, 12797, _B0) ->
    {P0_msgid, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_msgid}};

unpack(srv, 12798, _B0) ->
    {P0_gid, _B1} = lib_proto:read_uint16(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_gid, P0_srv_id}};
unpack(cli, 12798, _B0) ->
    {P0_members, _B6} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_name, _B2} = lib_proto:read_string(_B1),
        {P1_lev, _B3} = lib_proto:read_uint8(_B2),
        {P1_position, _B4} = lib_proto:read_uint8(_B3),
        {P1_fight, _B5} = lib_proto:read_uint32(_B4),
        {[P1_name, P1_lev, P1_position, P1_fight], _B5}
    end),
    {ok, {P0_members}};

unpack(srv, 12799, _B0) ->
    {ok, {}};
unpack(cli, 12799, _B0) ->
    {P0_res, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {P0_members, _B6} = lib_proto:read_array(_B2, fun(_B3) ->
        {P1_gid, _B4} = lib_proto:read_uint16(_B3),
        {P1_srv_id, _B5} = lib_proto:read_string(_B4),
        {[P1_gid, P1_srv_id], _B5}
    end),
    {ok, {P0_res, P0_msg, P0_members}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
