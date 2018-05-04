%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_183).
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

pack(srv, ?_CMD(18301), {P0_platform_list}) ->
    D_a_t_a = <<?_((length(P0_platform_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_platform_name)), "16"):16, ?_(P1_platform_name, bin)/binary>> || {P1_platform_name} <- P0_platform_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18301:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18301), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18301:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18302), {P0_srv_list}) ->
    D_a_t_a = <<?_((length(P0_srv_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary>> || {P1_srv_id} <- P0_srv_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18302:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18302), {P0_platform_name}) ->
    D_a_t_a = <<?_((byte_size(P0_platform_name)), "16"):16, ?_(P0_platform_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18302:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18303), {P0_cur_num, P0_max_num}) ->
    D_a_t_a = <<?_(P0_cur_num, '32'):32, ?_(P0_max_num, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18303:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18303), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18303:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18304), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18304:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18304), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18304:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18305), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18305:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18305), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18305:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18306), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18306:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18306), {P0_platform_name, P0_srv_id, P0_use_num}) ->
    D_a_t_a = <<?_((byte_size(P0_platform_name)), "16"):16, ?_(P0_platform_name, bin)/binary, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_use_num, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18306:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18307), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18307:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18307), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18307:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
