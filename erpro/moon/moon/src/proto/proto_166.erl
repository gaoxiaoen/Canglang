%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_166).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.


%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(16601), {P0_type, P0_time}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16601:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16601), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16601:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16602), {P0_wave, P0_team}) ->
    D_a_t_a = <<?_(P0_wave, '8'):8, ?_((length(P0_team)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_sex, '8'):8, ?_((byte_size(P1_guild_name)), "16"):16, ?_(P1_guild_name, bin)/binary, ?_(P1_lev, '8'):8, ?_(P1_career, '8'):8, ?_(P1_vip, '8'):8, ?_((length(P1_looks)), "16"):16, (list_to_binary([<<?_(P2_looks_type, '8'):8, ?_(P2_looks_id, '32'):32, ?_(P2_looks_value, '16'):16>> || {P2_looks_type, P2_looks_id, P2_looks_value} <- P1_looks]))/binary>> || {P1_role_id, P1_srv_id, P1_name, P1_sex, P1_guild_name, P1_lev, P1_career, P1_vip, P1_looks} <- P0_team]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16602:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16602), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16602:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16603), {P0_total_page, P0_cur_page, P0_list}) ->
    D_a_t_a = <<?_(P0_total_page, '32'):32, ?_(P0_cur_page, '32'):32, ?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_score, '32'):32, ?_(P1_rank, '32'):32, ?_((length(P1_team)), "16"):16, (list_to_binary([<<?_(P2_role_id, '32'):32, ?_((byte_size(P2_srv_id)), "16"):16, ?_(P2_srv_id, bin)/binary, ?_((byte_size(P2_name)), "16"):16, ?_(P2_name, bin)/binary, ?_(P2_sex, '8'):8, ?_((byte_size(P2_guild_name)), "16"):16, ?_(P2_guild_name, bin)/binary, ?_(P2_lev, '8'):8, ?_(P2_career, '8'):8, ?_(P2_vip, '8'):8>> || {P2_role_id, P2_srv_id, P2_name, P2_sex, P2_guild_name, P2_lev, P2_career, P2_vip} <- P1_team]))/binary>> || {P1_score, P1_rank, P1_team} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16603:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16603), {P0_page_size, P0_page_no}) ->
    D_a_t_a = <<?_(P0_page_size, '32'):32, ?_(P0_page_no, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16603:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16604), {P0_left_count, P0_total_count}) ->
    D_a_t_a = <<?_(P0_left_count, '8'):8, ?_(P0_total_count, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16604:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16604), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16604:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16605), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16605:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16605), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16605:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16611), {P0_wave, P0_bind_coin, P0_exp}) ->
    D_a_t_a = <<?_(P0_wave, '8'):8, ?_(P0_bind_coin, '32'):32, ?_(P0_exp, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16611:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16611), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16611:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16612), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16612:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16612), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16612:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16613), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16613:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16613), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16613:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
