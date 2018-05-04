%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_196).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("activity2.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(19600), {P0_next_time, P0_buy_times}) ->
    D_a_t_a = <<?_(P0_next_time, '16'):16, ?_(P0_buy_times, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19600:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19600), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19600:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19601), {P0_have}) ->
    D_a_t_a = <<?_(P0_have, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19601:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19601), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19601:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19602), {P0_flag1, P0_flag2}) ->
    D_a_t_a = <<?_(P0_flag1, '32'):32, ?_(P0_flag2, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19602:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19602), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19602:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19603), {P0_result, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19603:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19603), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19603:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19604), {P0_result, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19604:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19604), {P0_opr}) ->
    D_a_t_a = <<?_(P0_opr, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19604:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19605), {P0_cnt, P0_cur_cnt, P0_gold}) ->
    D_a_t_a = <<?_(P0_cnt, '32'):32, ?_(P0_cur_cnt, '32'):32, ?_(P0_gold, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19605:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19605), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19605:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19606), {P0_online}) ->
    D_a_t_a = <<?_(P0_online, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19606:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19606), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19606:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 19600, _B0) ->
    {ok, {}};
unpack(cli, 19600, _B0) ->
    {P0_next_time, _B1} = lib_proto:read_uint16(_B0),
    {P0_buy_times, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_next_time, P0_buy_times}};

unpack(srv, 19601, _B0) ->
    {ok, {}};
unpack(cli, 19601, _B0) ->
    {P0_have, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_have}};

unpack(srv, 19602, _B0) ->
    {ok, {}};
unpack(cli, 19602, _B0) ->
    {P0_flag1, _B1} = lib_proto:read_uint32(_B0),
    {P0_flag2, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_flag1, P0_flag2}};

unpack(srv, 19603, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_id}};
unpack(cli, 19603, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_result, P0_msg_id}};

unpack(srv, 19604, _B0) ->
    {P0_opr, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_opr}};
unpack(cli, 19604, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_result, P0_msg_id}};

unpack(srv, 19605, _B0) ->
    {ok, {}};
unpack(cli, 19605, _B0) ->
    {P0_cnt, _B1} = lib_proto:read_uint32(_B0),
    {P0_cur_cnt, _B2} = lib_proto:read_uint32(_B1),
    {P0_gold, _B3} = lib_proto:read_uint32(_B2),
    {ok, {P0_cnt, P0_cur_cnt, P0_gold}};

unpack(srv, 19606, _B0) ->
    {ok, {}};
unpack(cli, 19606, _B0) ->
    {P0_online, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_online}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
