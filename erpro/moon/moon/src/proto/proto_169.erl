%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_169).
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

pack(srv, ?_CMD(16901), {P0_type, P0_time}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16901:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16901), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16901:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16902), {P0_room_list}) ->
    D_a_t_a = <<?_((length(P0_room_list)), "16"):16, (list_to_binary([<<?_(P1_id, '16'):16, ?_(P1_num, '32'):32, ?_(P1_max_num, '32'):32>> || {P1_id, P1_num, P1_max_num} <- P0_room_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16902:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16902), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16902:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16903), {P0_page, P0_record_total, P0_page_total, P0_role_list}) ->
    D_a_t_a = <<?_(P0_page, '8'):8, ?_(P0_record_total, '16'):16, ?_(P0_page_total, '8'):8, ?_((length(P0_role_list)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_sex, '8'):8, ?_(P1_career, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_vip, '8'):8, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_fight_capacity, '32'):32, ?_(P1_team, '8'):8, ?_(P1_status, '8'):8>> || {P1_rid, P1_srv_id, P1_name, P1_sex, P1_career, P1_lev, P1_vip, P1_guild, P1_fight_capacity, P1_team, P1_status} <- P0_role_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16903:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16903), {P0_page}) ->
    D_a_t_a = <<?_(P0_page, '8/signed'):8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16903:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16904), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16904:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16904), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16904:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16905), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16905:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16905), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16905:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16910), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16910:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16910), {P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16910:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16911), {P0_rid, P0_srv_id, P0_name}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16911:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16911), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16911:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16912), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16912:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16912), {P0_ret, P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16912:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16913), {P0_ret, P0_rid, P0_srv_id, P0_name, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16913:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16913), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16913:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16914), {P0_time, P0_rid, P0_srv_id, P0_name, P0_career, P0_fight, P0_pet_fight}) ->
    D_a_t_a = <<?_(P0_time, '32'):32, ?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_career, '8'):8, ?_(P0_fight, '32'):32, ?_(P0_pet_fight, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16914:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16914), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16914:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16915), {P0_result}) ->
    D_a_t_a = <<?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16915:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16915), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16915:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
