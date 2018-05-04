%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_170).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("cross_king.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(17000), {P0_type, P0_time}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17000:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17000), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17000:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17001), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17001:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17001), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17001:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17002), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17002:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17002), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17002:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17003), {P0_seq, P0_type, P0_score, P0_death_time}) ->
    D_a_t_a = <<?_(P0_seq, '32'):32, ?_(P0_type, '8'):8, ?_(P0_score, '32'):32, ?_(P0_death_time, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17003:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17003), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17003:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17004), {P0_group_list1, P0_group_list2}) ->
    D_a_t_a = <<?_((length(P0_group_list1)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_fight, '32'):32, ?_(P1_pet_fight, '32'):32, ?_(P1_kill, '32'):32>> || {P1_rid, P1_srv_id, P1_name, P1_career, P1_fight, P1_pet_fight, P1_kill} <- P0_group_list1]))/binary, ?_((length(P0_group_list2)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_fight, '32'):32, ?_(P1_pet_fight, '32'):32, ?_(P1_scrore, '32'):32>> || {P1_rid, P1_srv_id, P1_name, P1_career, P1_fight, P1_pet_fight, P1_scrore} <- P0_group_list2]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17004:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17004), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17004:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17005), {P0_type, P0_group_list1, P0_group_list2}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_((length(P0_group_list1)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_fight, '32'):32, ?_(P1_pet_fight, '32'):32, ?_(P1_death_time, '8'):8, ?_(P1_kill, '32'):32>> || {P1_rid, P1_srv_id, P1_name, P1_career, P1_lev, P1_fight, P1_pet_fight, P1_death_time, P1_kill} <- P0_group_list1]))/binary, ?_((length(P0_group_list2)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_fight, '32'):32, ?_(P1_pet_fight, '32'):32, ?_(P1_death_time, '8'):8, ?_(P1_scrore, '32'):32>> || {P1_rid, P1_srv_id, P1_name, P1_career, P1_lev, P1_fight, P1_pet_fight, P1_death_time, P1_scrore} <- P0_group_list2]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17005:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17005), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17005:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17006), {P0_type, P0_score1, P0_score2, P0_death_time}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_score1, '32'):32, ?_(P0_score2, '32'):32, ?_(P0_death_time, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17006:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17006), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17006:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17008), {P0_page_idx, P0_total_page, P0_gfs_list}) ->
    D_a_t_a = <<?_(P0_page_idx, '32'):32, ?_(P0_total_page, '32'):32, ?_((length(P0_gfs_list)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_sex, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_(P1_fight_capacity, '32'):32, ?_(P1_pet_fight, '32'):32, ?_(P1_career, '8'):8, ?_(P1_score, '32'):32, ?_((length(P1_looks)), "16"):16, (list_to_binary([<<?_(P2_looks_type, '8'):8, ?_(P2_looks_id, '32'):32, ?_(P2_looks_value, '16'):16>> || {P2_looks_type, P2_looks_id, P2_looks_value} <- P1_looks]))/binary>> || #cross_king_rank{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, sex = P1_sex, lev = P1_lev, vip = P1_vip, fight_capacity = P1_fight_capacity, pet_fight = P1_pet_fight, career = P1_career, score = P1_score, looks = P1_looks} <- P0_gfs_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17008:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17008), {P0_page}) ->
    D_a_t_a = <<?_(P0_page, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17008:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17009), {P0_page_idx, P0_total_page, P0_ds_list}) ->
    D_a_t_a = <<?_(P0_page_idx, '32'):32, ?_(P0_total_page, '32'):32, ?_((length(P0_ds_list)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_sex, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_(P1_fight_capacity, '32'):32, ?_(P1_pet_fight, '32'):32, ?_(P1_career, '8'):8, ?_(P1_score, '32'):32>> || #cross_king_rank{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, sex = P1_sex, lev = P1_lev, vip = P1_vip, fight_capacity = P1_fight_capacity, pet_fight = P1_pet_fight, career = P1_career, score = P1_score} <- P0_ds_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17009:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17009), {P0_page}) ->
    D_a_t_a = <<?_(P0_page, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17009:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
