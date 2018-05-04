%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_116).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("map.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(11601), {P0_ret, P0_hp_regen, P0_mp_regen, P0_hp_max, P0_mp_max, P0_hp, P0_mp, P0_exp, P0_spirit, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_(P0_hp_regen, '16'):16, ?_(P0_mp_regen, '16'):16, ?_(P0_hp_max, '32'):32, ?_(P0_mp_max, '32'):32, ?_(P0_hp, '32'):32, ?_(P0_mp, '32'):32, ?_(P0_exp, '32'):32, ?_(P0_spirit, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11601:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11601), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11601:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11602), {P0_exp_heap, P0_spirit_heap}) ->
    D_a_t_a = <<?_(P0_exp_heap, '32'):32, ?_(P0_spirit_heap, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11602:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11602), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11602:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11611), {P0_msg, P0_x, P0_y}) ->
    D_a_t_a = <<?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_x, '32'):32, ?_(P0_y, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11611:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11611), {P0_id, P0_srv_id, P0_x, P0_y}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_x, '32'):32, ?_(P0_y, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11611:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11620), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11620:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11620), {P0_type, P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11620:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11621), {P0_type, P0_id, P0_srv_id, P0_name}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11621:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11621), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11621:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11622), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11622:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11622), {P0_ret, P0_type, P0_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_(P0_type, '8'):8, ?_(P0_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11622:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
