%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_180).
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

pack(srv, ?_CMD(18000), {P0_flag, P0_flag_1, P0_flag_2, P0_time}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((length(P0_flag_1)), "16"):16, (list_to_binary([<<?_(P1_luck_1, '8'):8, ?_(P1_luck_2, '8'):8>> || [P1_luck_1, P1_luck_2] <- P0_flag_1]))/binary, ?_((length(P0_flag_2)), "16"):16, (list_to_binary([<<?_(P1_luck_3, '8'):8, ?_(P1_luck_4, '8'):8>> || [P1_luck_3, P1_luck_4] <- P0_flag_2]))/binary, ?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18000:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18000), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18000:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
