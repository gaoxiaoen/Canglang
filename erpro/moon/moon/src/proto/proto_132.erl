%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_132).
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

pack(srv, ?_CMD(13200), {P0_is_hook, P0_cnt}) ->
    D_a_t_a = <<?_(P0_is_hook, '8'):8, ?_(P0_cnt, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13200:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13200), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13200:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13201), {P0_ret, P0_cnt, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_(P0_cnt, '16'):16, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13201:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13201), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13201:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13205), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13205:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13205), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13205:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13206), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13206:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13206), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13206:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13230), {P0_data_list}) ->
    D_a_t_a = <<?_((length(P0_data_list)), "16"):16, (list_to_binary([<<?_(P1_key, '8'):8, ?_(P1_value, '32'):32>> || {P1_key, P1_value} <- P0_data_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13230:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13230), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13230:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 13230, _B0) ->
    {ok, {}};
unpack(cli, 13230, _B0) ->
    {P0_data_list, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_key, _B2} = lib_proto:read_uint8(_B1),
        {P1_value, _B3} = lib_proto:read_uint32(_B2),
        {[P1_key, P1_value], _B3}
    end),
    {ok, {P0_data_list}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
