%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_156).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("npc.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(15600), {P0_npc_base_id, P0_npc_name, P0_quality, P0_career, P0_fight_capacity, P0_impression, P0_impression_lev, P0_is_employee, P0_employ_left_time}) ->
    D_a_t_a = <<?_(P0_npc_base_id, '32'):32, ?_((byte_size(P0_npc_name)), "16"):16, ?_(P0_npc_name, bin)/binary, ?_(P0_quality, '32'):32, ?_(P0_career, '8'):8, ?_(P0_fight_capacity, '32'):32, ?_(P0_impression, '32'):32, ?_(P0_impression_lev, '8'):8, ?_(P0_is_employee, '8'):8, ?_(P0_employ_left_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15600:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15600), {P0_npc_base_id}) ->
    D_a_t_a = <<?_(P0_npc_base_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15600:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15601), {P0_npc_impressions, P0_gold_brick_price}) ->
    D_a_t_a = <<?_((length(P0_npc_impressions)), "16"):16, (list_to_binary([<<?_(P1_npc_base_id, '32'):32, ?_((byte_size(P1_npc_name)), "16"):16, ?_(P1_npc_name, bin)/binary, ?_(P1_quality, '8'):8, ?_(P1_career, '8'):8, ?_(P1_impression, '32'):32, ?_(P1_impression_lev, '8'):8>> || {P1_npc_base_id, P1_npc_name, P1_quality, P1_career, P1_impression, P1_impression_lev} <- P0_npc_impressions]))/binary, ?_(P0_gold_brick_price, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15601:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15601), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15601:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15602), {P0_npc_base_id}) ->
    D_a_t_a = <<?_(P0_npc_base_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15602:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15602), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15602:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15609), {P0_impression_up_list}) ->
    D_a_t_a = <<?_((length(P0_impression_up_list)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_val, '32'):32>> || {P1_type, P1_val} <- P0_impression_up_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15609:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15609), {P0_npc_base_id, P0_gifts}) ->
    D_a_t_a = <<?_(P0_npc_base_id, '32'):32, ?_((length(P0_gifts)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_val1, '32'):32, ?_(P1_val2, '32'):32, ?_(P1_val3, '32'):32>> || {P1_type, P1_val1, P1_val2, P1_val3} <- P0_gifts]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15609:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15610), {P0_result, P0_msg, P0_val}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_val, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15610:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15610), {P0_npc_base_id, P0_gifts}) ->
    D_a_t_a = <<?_(P0_npc_base_id, '32'):32, ?_((length(P0_gifts)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_val1, '32'):32, ?_(P1_val2, '32'):32, ?_(P1_val3, '32'):32>> || {P1_type, P1_val1, P1_val2, P1_val3} <- P0_gifts]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15610:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15611), {P0_result, P0_msg, P0_npc_base_id, P0_employ_left_time}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_npc_base_id, '32'):32, ?_(P0_employ_left_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15611:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15611), {P0_npc_base_id, P0_hours}) ->
    D_a_t_a = <<?_(P0_npc_base_id, '32'):32, ?_(P0_hours, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15611:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15612), {P0_result, P0_msg, P0_npc_base_id}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_npc_base_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15612:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15612), {P0_npc_base_id}) ->
    D_a_t_a = <<?_(P0_npc_base_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15612:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
