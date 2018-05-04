%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_163).
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

pack(srv, ?_CMD(16301), {P0_ret, P0_type, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_(P0_type, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16301:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16301), {P0_sworn_type}) ->
    D_a_t_a = <<?_(P0_sworn_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16301:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16302), {P0_ret, P0_num, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_(P0_num, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16302:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16302), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16302:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16303), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16303:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16303), {P0_first, P0_second}) ->
    D_a_t_a = <<?_((byte_size(P0_first)), "16"):16, ?_(P0_first, bin)/binary, ?_((byte_size(P0_second)), "16"):16, ?_(P0_second, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16303:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16304), {P0_ret, P0_name, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16304:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16304), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16304:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16305), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16305:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16305), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16305:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16306), {P0_ret, P0_name_list, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((length(P0_name_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary>> || {P1_name} <- P0_name_list]))/binary, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16306:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16306), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16306:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16307), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16307:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16307), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16307:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16308), {P0_time}) ->
    D_a_t_a = <<?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16308:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16308), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16308:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16309), {P0_coin, P0_gold}) ->
    D_a_t_a = <<?_(P0_coin, '32'):32, ?_(P0_gold, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16309:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16309), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16309:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
