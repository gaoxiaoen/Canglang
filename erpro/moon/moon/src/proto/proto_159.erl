%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_159).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("guild_arena.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(15901), {P0_result, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15901:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15901), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15901:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15902), {P0_result, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15902:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15902), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15902:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15903), {P0_result, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15903:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15903), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15903:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15904), {P0_result, P0_reason, P0_page, P0_total, P0_list}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary, ?_(P0_page, '32'):32, ?_(P0_total, '32'):32, ?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_gid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_join_num, '32'):32, ?_(P1_sum_kill, '32'):32, ?_(P1_sum_score, '32'):32, ?_(P1_sum_stone, '32'):32, ?_(P1_lev, '32'):32, ?_(P1_die, '32'):32>> || {P1_gid, P1_srv_id, P1_name, P1_join_num, P1_sum_kill, P1_sum_score, P1_sum_stone, P1_lev, P1_die} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15904:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15904), {P0_page}) ->
    D_a_t_a = <<?_(P0_page, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15904:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15905), {P0_result, P0_reason, P0_page, P0_total, P0_list}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary, ?_(P0_page, '32'):32, ?_(P0_total, '32'):32, ?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_((byte_size(P1_guild_name)), "16"):16, ?_(P1_guild_name, bin)/binary, ?_(P1_sum_score, '32'):32, ?_(P1_sum_kill, '32'):32, ?_(P1_sum_stone, '32'):32, ?_(P1_fc, '32'):32>> || {P1_rid, P1_srv_id, P1_name, P1_guild_name, P1_sum_score, P1_sum_kill, P1_sum_stone, P1_fc} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15905:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15905), {P0_page}) ->
    D_a_t_a = <<?_(P0_page, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15905:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15906), {P0_id, P0_type, P0_num, P0_is_cross}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_type, '8'):8, ?_(P0_num, '32'):32, ?_(P0_is_cross, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15906:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15906), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15906:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15907), {P0_result, P0_reason, P0_page, P0_total, P0_list}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary, ?_(P0_page, '32'):32, ?_(P0_total, '32'):32, ?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_gid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_join_num, '32'):32, ?_(P1_kill, '32'):32, ?_(P1_score, '32'):32, ?_(P1_stone, '32'):32, ?_(P1_die, '32'):32>> || {P1_gid, P1_srv_id, P1_name, P1_join_num, P1_kill, P1_score, P1_stone, P1_die} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15907:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15907), {P0_page}) ->
    D_a_t_a = <<?_(P0_page, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15907:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15908), {P0_result, P0_reason, P0_page, P0_total, P0_list}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary, ?_(P0_page, '32'):32, ?_(P0_total, '32'):32, ?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_((byte_size(P1_guild_name)), "16"):16, ?_(P1_guild_name, bin)/binary, ?_(P1_score, '32'):32, ?_(P1_kill, '32'):32, ?_(P1_stone, '32'):32, ?_(P1_fc, '32'):32>> || {P1_rid, P1_srv_id, P1_name, P1_guild_name, P1_score, P1_kill, P1_stone, P1_fc} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15908:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15908), {P0_page}) ->
    D_a_t_a = <<?_(P0_page, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15908:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15909), {P0_result, P0_reason, P0_type, P0_name, P0_guild_name, P0_score, P0_kill, P0_stone, P0_round_score, P0_die, P0_enemy}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary, ?_(P0_type, '32'):32, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_((byte_size(P0_guild_name)), "16"):16, ?_(P0_guild_name, bin)/binary, ?_(P0_score, '32'):32, ?_(P0_kill, '32'):32, ?_(P0_stone, '32'):32, ?_(P0_round_score, '32'):32, ?_(P0_die, '32'):32, ?_((length(P0_enemy)), "16"):16, (list_to_binary([<<?_(P1_enemy_id, '32'):32, ?_((byte_size(P1_enemy_srv)), "16"):16, ?_(P1_enemy_srv, bin)/binary, ?_((byte_size(P1_enemy_name)), "16"):16, ?_(P1_enemy_name, bin)/binary>> || {P1_enemy_id, P1_enemy_srv, P1_enemy_name} <- P0_enemy]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15909:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15909), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15909:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15910), {P0_result}) ->
    D_a_t_a = <<?_(P0_result, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15910:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15910), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15910:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15911), {P0_result, P0_reason, P0_page, P0_total, P0_list}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary, ?_(P0_page, '32'):32, ?_(P0_total, '32'):32, ?_((length(P0_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_member_num, '32'):32, ?_((byte_size(P1_chief)), "16"):16, ?_(P1_chief, bin)/binary, ?_(P1_lev, '32'):32>> || #arena_guild{name = P1_name, member_num = P1_member_num, chief = P1_chief, lev = P1_lev} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15911:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15911), {P0_page}) ->
    D_a_t_a = <<?_(P0_page, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15911:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15912), {P0_type, P0_round, P0_msg, P0_mvp_name, P0_mvp_guild_name, P0_mvp_score, P0_mvp_kill, P0_mvp_stone}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_round, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_((byte_size(P0_mvp_name)), "16"):16, ?_(P0_mvp_name, bin)/binary, ?_((byte_size(P0_mvp_guild_name)), "16"):16, ?_(P0_mvp_guild_name, bin)/binary, ?_(P0_mvp_score, '32'):32, ?_(P0_mvp_kill, '32'):32, ?_(P0_mvp_stone, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15912:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15912), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15912:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15913), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15913:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15913), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15913:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15914), {P0_result, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15914:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15914), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15914:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15915), {P0_result, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15915:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15915), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15915:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15916), {P0_result, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15916:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15916), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15916:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15917), {P0_round, P0_area_id}) ->
    D_a_t_a = <<?_(P0_round, '8'):8, ?_(P0_area_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15917:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15917), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15917:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15918), {P0_result, P0_reason, P0_page, P0_total, P0_list}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary, ?_(P0_page, '32'):32, ?_(P0_total, '32'):32, ?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_gid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_join_num, '32'):32, ?_(P1_sum_kill, '32'):32, ?_(P1_sum_score, '32'):32, ?_(P1_sum_stone, '32'):32, ?_(P1_lev, '32'):32, ?_(P1_die, '32'):32>> || {P1_gid, P1_srv_id, P1_name, P1_join_num, P1_sum_kill, P1_sum_score, P1_sum_stone, P1_lev, P1_die} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15918:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15918), {P0_page}) ->
    D_a_t_a = <<?_(P0_page, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15918:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15919), {P0_result, P0_reason, P0_page, P0_total, P0_list}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary, ?_(P0_page, '32'):32, ?_(P0_total, '32'):32, ?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_((byte_size(P1_guild_name)), "16"):16, ?_(P1_guild_name, bin)/binary, ?_(P1_sum_score, '32'):32, ?_(P1_sum_kill, '32'):32, ?_(P1_sum_stone, '32'):32, ?_(P1_fc, '32'):32>> || {P1_rid, P1_srv_id, P1_name, P1_guild_name, P1_sum_score, P1_sum_kill, P1_sum_stone, P1_fc} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15919:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15919), {P0_page}) ->
    D_a_t_a = <<?_(P0_page, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15919:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15920), {P0_areas, P0_page, P0_total, P0_list}) ->
    D_a_t_a = <<?_((length(P0_areas)), "16"):16, (list_to_binary([<<?_(P1_area_id, '32'):32>> || P1_area_id <- P0_areas]))/binary, ?_(P0_page, '32'):32, ?_(P0_total, '32'):32, ?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_gid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_((byte_size(P1_chief)), "16"):16, ?_(P1_chief, bin)/binary, ?_(P1_member_num, '32'):32, ?_(P1_lev, '32'):32, ?_(P1_current_score, '32'):32, ?_(P1_round_score, '32'):32, ?_(P1_total_score, '32'):32>> || {P1_gid, P1_srv_id, P1_name, P1_chief, P1_member_num, P1_lev, P1_current_score, P1_round_score, P1_total_score} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15920:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15920), {P0_round_num, P0_area_id, P0_page}) ->
    D_a_t_a = <<?_(P0_round_num, '8'):8, ?_(P0_area_id, '32'):32, ?_(P0_page, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15920:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15921), {P0_areas, P0_page, P0_total, P0_list}) ->
    D_a_t_a = <<?_((length(P0_areas)), "16"):16, (list_to_binary([<<?_(P1_area_id, '32'):32>> || P1_area_id <- P0_areas]))/binary, ?_(P0_page, '32'):32, ?_(P0_total, '32'):32, ?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '32'):32, ?_(P1_career, '8'):8, ?_(P1_fc, '32'):32, ?_(P1_gid, '32'):32, ?_((byte_size(P1_gsrv_id)), "16"):16, ?_(P1_gsrv_id, bin)/binary, ?_((byte_size(P1_guild_name)), "16"):16, ?_(P1_guild_name, bin)/binary, ?_(P1_current_score, '32'):32, ?_(P1_round_score, '32'):32, ?_(P1_total_score, '32'):32>> || {P1_rid, P1_srv_id, P1_name, P1_lev, P1_career, P1_fc, P1_gid, P1_gsrv_id, P1_guild_name, P1_current_score, P1_round_score, P1_total_score} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15921:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15921), {P0_round_num, P0_area_id, P0_page}) ->
    D_a_t_a = <<?_(P0_round_num, '8'):8, ?_(P0_area_id, '32'):32, ?_(P0_page, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15921:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15922), {P0_page, P0_total, P0_list}) ->
    D_a_t_a = <<?_(P0_page, '32'):32, ?_(P0_total, '32'):32, ?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_gid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_((byte_size(P1_chief)), "16"):16, ?_(P1_chief, bin)/binary, ?_(P1_member_num, '32'):32, ?_(P1_lev, '32'):32, ?_(P1_current_score, '32'):32, ?_(P1_round_score, '32'):32, ?_(P1_total_score, '32'):32>> || {P1_gid, P1_srv_id, P1_name, P1_chief, P1_member_num, P1_lev, P1_current_score, P1_round_score, P1_total_score} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15922:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15922), {P0_page}) ->
    D_a_t_a = <<?_(P0_page, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15922:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15923), {P0_page, P0_total, P0_list}) ->
    D_a_t_a = <<?_(P0_page, '32'):32, ?_(P0_total, '32'):32, ?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '32'):32, ?_(P1_career, '8'):8, ?_(P1_fc, '32'):32, ?_(P1_gid, '32'):32, ?_((byte_size(P1_gsrv_id)), "16"):16, ?_(P1_gsrv_id, bin)/binary, ?_((byte_size(P1_guild_name)), "16"):16, ?_(P1_guild_name, bin)/binary, ?_(P1_current_score, '32'):32, ?_(P1_round_score, '32'):32, ?_(P1_total_score, '32'):32>> || {P1_rid, P1_srv_id, P1_name, P1_lev, P1_career, P1_fc, P1_gid, P1_gsrv_id, P1_guild_name, P1_current_score, P1_round_score, P1_total_score} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15923:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15923), {P0_page}) ->
    D_a_t_a = <<?_(P0_page, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15923:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15924), {P0_result, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15924:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15924), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15924:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15925), {P0_result, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15925:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15925), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15925:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15926), {P0_result, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15926:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15926), {P0_round_num}) ->
    D_a_t_a = <<?_(P0_round_num, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15926:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15927), {P0_result, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15927:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15927), {P0_round_num}) ->
    D_a_t_a = <<?_(P0_round_num, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15927:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15928), {P0_result, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15928:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15928), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15928:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15929), {P0_result, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15929:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15929), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15929:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
