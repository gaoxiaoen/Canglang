%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_178).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("ore.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(17800), {P0_status, P0_time}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17800:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17800), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17800:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17801), {P0_max_num, P0_area_list}) ->
    D_a_t_a = <<?_(P0_max_num, '16'):16, ?_((length(P0_area_list)), "16"):16, (list_to_binary([<<?_(P1_area_id, '8'):8, ?_(P1_num, '16'):16>> || {P1_area_id, P1_num} <- P0_area_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17801:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17801), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17801:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17802), {P0_room_id, P0_room_name, P0_room_lev, P0_role_list, P0_award_list, P0_next_time, P0_npc_list}) ->
    D_a_t_a = <<?_(P0_room_id, '16'):16, ?_((byte_size(P0_room_name)), "16"):16, ?_(P0_room_name, bin)/binary, ?_(P0_room_lev, '8'):8, ?_((length(P0_role_list)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary>> || {P1_rid, P1_srv_id, P1_name} <- P0_role_list]))/binary, ?_((length(P0_award_list)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_num, '32'):32>> || {P1_base_id, P1_bind, P1_num} <- P0_award_list]))/binary, ?_(P0_next_time, '32'):32, ?_((length(P0_npc_list)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '8'):8>> || {P1_base_id, P1_name, P1_lev} <- P0_npc_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17802:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17802), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17802:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17803), {P0_type_1, P0_type_2, P0_type_3, P0_type_4}) ->
    D_a_t_a = <<?_((length(P0_type_1)), "16"):16, (list_to_binary([<<?_((byte_size(P1_room_name)), "16"):16, ?_(P1_room_name, bin)/binary, ?_(P1_room_lev, '8'):8, ?_(P1_time, '32'):32>> || {P1_room_name, P1_room_lev, P1_time} <- P0_type_1]))/binary, ?_((length(P0_type_2)), "16"):16, (list_to_binary([<<?_((length(P1_items)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32, ?_(P2_bind, '8'):8, ?_(P2_num, '32'):32>> || {P2_base_id, P2_bind, P2_num} <- P1_items]))/binary, ?_(P1_time, '32'):32>> || {P1_items, P1_time} <- P0_type_2]))/binary, ?_((length(P0_type_3)), "16"):16, (list_to_binary([<<?_((length(P1_items)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32, ?_(P2_bind, '8'):8, ?_(P2_num, '32'):32>> || {P2_base_id, P2_bind, P2_num} <- P1_items]))/binary, ?_(P1_time, '32'):32>> || {P1_items, P1_time} <- P0_type_3]))/binary, ?_((length(P0_type_4)), "16"):16, (list_to_binary([<<?_(P1_result, '8'):8, ?_((length(P1_role_list)), "16"):16, (list_to_binary([<<?_(P2_rid, '32'):32, ?_((byte_size(P2_srv_id)), "16"):16, ?_(P2_srv_id, bin)/binary, ?_((byte_size(P2_name)), "16"):16, ?_(P2_name, bin)/binary>> || {P2_rid, P2_srv_id, P2_name} <- P1_role_list]))/binary, ?_((length(P1_items)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32, ?_(P2_bind, '8'):8, ?_(P2_num, '32'):32>> || {P2_base_id, P2_bind, P2_num} <- P1_items]))/binary, ?_(P1_time, '32'):32>> || {P1_result, P1_role_list, P1_items, P1_time} <- P0_type_4]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17803:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17803), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17803:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17804), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17804:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17804), {P0_area_id}) ->
    D_a_t_a = <<?_(P0_area_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17804:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17805), {P0_room_id, P0_room_name, P0_room_lev, P0_flag, P0_status, P0_role_list, P0_award_list, P0_npc_list}) ->
    D_a_t_a = <<?_(P0_room_id, '16'):16, ?_((byte_size(P0_room_name)), "16"):16, ?_(P0_room_name, bin)/binary, ?_(P0_room_lev, '8'):8, ?_(P0_flag, '8'):8, ?_(P0_status, '8'):8, ?_((length(P0_role_list)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary>> || {P1_rid, P1_srv_id, P1_name} <- P0_role_list]))/binary, ?_((length(P0_award_list)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_num, '32'):32>> || {P1_base_id, P1_bind, P1_num} <- P0_award_list]))/binary, ?_((length(P0_npc_list)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '8'):8>> || {P1_base_id, P1_name, P1_lev} <- P0_npc_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17805:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17805), {P0_room_id}) ->
    D_a_t_a = <<?_(P0_room_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17805:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17806), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17806:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17806), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17806:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17807), {P0_room_list}) ->
    D_a_t_a = <<?_((length(P0_room_list)), "16"):16, (list_to_binary([<<?_(P1_room_id, '16'):16, ?_((byte_size(P1_room_name)), "16"):16, ?_(P1_room_name, bin)/binary, ?_(P1_room_lev, '8'):8, ?_(P1_flag, '8'):8>> || {P1_room_id, P1_room_name, P1_room_lev, P1_flag} <- P0_room_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17807:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17807), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17807:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17810), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17810:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17810), {P0_room_id}) ->
    D_a_t_a = <<?_(P0_room_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17810:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17811), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17811:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17811), {P0_room_id}) ->
    D_a_t_a = <<?_(P0_room_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17811:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17815), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17815:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17815), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17815:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17816), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17816:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17816), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17816:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17817), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17817:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17817), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17817:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17818), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17818:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17818), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17818:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
