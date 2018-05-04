%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_99).
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

pack(srv, ?_CMD(9900), {P0_help}) ->
    D_a_t_a = <<?_((length(P0_help)), "16"):16, (list_to_binary([<<?_((byte_size(P1_cmd)), "16"):16, ?_(P1_cmd, bin)/binary, ?_((byte_size(P1_desc)), "16"):16, ?_(P1_desc, bin)/binary>> || {P1_cmd, P1_desc} <- P0_help]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 9900:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(9900), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 9900:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(9910), {P0_result}) ->
    D_a_t_a = <<?_((byte_size(P0_result)), "16"):16, ?_(P0_result, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 9910:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(9910), {P0_cmd}) ->
    D_a_t_a = <<?_((byte_size(P0_cmd)), "16"):16, ?_(P0_cmd, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 9910:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 9900, _B0) ->
    {ok, {}};
unpack(cli, 9900, _B0) ->
    {P0_help, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_cmd, _B2} = lib_proto:read_string(_B1),
        {P1_desc, _B3} = lib_proto:read_string(_B2),
        {[P1_cmd, P1_desc], _B3}
    end),
    {ok, {P0_help}};

unpack(srv, 9910, _B0) ->
    {P0_cmd, _B1} = lib_proto:read_string(_B0),
    {ok, {P0_cmd}};
unpack(cli, 9910, _B0) ->
    {P0_result, _B1} = lib_proto:read_string(_B0),
    {ok, {P0_result}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
