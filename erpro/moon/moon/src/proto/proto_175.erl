%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_175).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("guild_boss.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(17500), {P0_boss_list}) ->
    D_a_t_a = <<?_((length(P0_boss_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_type, '8'):8, ?_(P1_exp, '32'):32, ?_(P1_lev, '32'):32>> || #guild_boss_npc{id = P1_id, type = P1_type, exp = P1_exp, lev = P1_lev} <- P0_boss_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17500:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17500), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17500:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17501), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17501:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17501), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17501:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17502), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17502:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17502), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17502:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17503), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17503:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17503), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17503:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17504), {P0_id, P0_type, P0_exp, P0_lev}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_type, '8'):8, ?_(P0_exp, '32'):32, ?_(P0_lev, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17504:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17504), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17504:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17505), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17505:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17505), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17505:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17506), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17506:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17506), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17506:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17507), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17507:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17507), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17507:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
