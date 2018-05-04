%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_136).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("tree.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(13600), {P0_floor, P0_status, P0_exp, P0_coin, P0_material, P0_strange}) ->
    D_a_t_a = <<?_(P0_floor, '16'):16, ?_(P0_status, '8'):8, ?_(P0_exp, '32'):32, ?_(P0_coin, '32'):32, ?_(P0_material, '16'):16, ?_(P0_strange, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13600:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13600), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13600:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13601), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13601:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13601), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13601:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13602), {P0_status}) ->
    D_a_t_a = <<?_(P0_status, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13602:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13602), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13602:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13603), {P0_floor, P0_rewards}) ->
    D_a_t_a = <<?_(P0_floor, '16'):16, ?_((length(P0_rewards)), "16"):16, (list_to_binary([<<?_(P1_type, '32'):32, ?_(P1_count, '32'):32>> || {P1_type, P1_count} <- P0_rewards]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13603:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13603), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13603:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13604), {P0_status, P0_type, P0_id, P0_count}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_type, '8'):8, ?_(P0_id, '32'):32, ?_(P0_count, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13604:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13604), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13604:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13605), {P0_status, P0_is_bag, P0_win_is_bag, P0_gain}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_is_bag, '8'):8, ?_(P0_win_is_bag, '8'):8, ?_((length(P0_gain)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_item_id, '32/signed'):32/signed, ?_(P1_num, '32/signed'):32/signed>> || {P1_type, P1_item_id, P1_num} <- P0_gain]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13605:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13605), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13605:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13606), {P0_status, P0_is_bag}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_is_bag, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13606:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13606), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13606:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13607), {P0_boss_id}) ->
    D_a_t_a = <<?_(P0_boss_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13607:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13607), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13607:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13608), {P0_floor}) ->
    D_a_t_a = <<?_(P0_floor, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13608:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13608), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13608:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13609), {P0_status}) ->
    D_a_t_a = <<?_(P0_status, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13609:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13609), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13609:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13610), {P0_exp, P0_coin, P0_material, P0_strange}) ->
    D_a_t_a = <<?_(P0_exp, '32'):32, ?_(P0_coin, '32'):32, ?_(P0_material, '16'):16, ?_(P0_strange, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13610:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13610), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13610:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13611), {P0_is_buy}) ->
    D_a_t_a = <<?_(P0_is_buy, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13611:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13611), {P0_is_buy}) ->
    D_a_t_a = <<?_(P0_is_buy, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13611:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13612), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13612:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13612), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13612:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 13600, _B0) ->
    {ok, {}};
unpack(cli, 13600, _B0) ->
    {P0_floor, _B1} = lib_proto:read_uint16(_B0),
    {P0_status, _B2} = lib_proto:read_uint8(_B1),
    {P0_exp, _B3} = lib_proto:read_uint32(_B2),
    {P0_coin, _B4} = lib_proto:read_uint32(_B3),
    {P0_material, _B5} = lib_proto:read_uint16(_B4),
    {P0_strange, _B6} = lib_proto:read_uint16(_B5),
    {ok, {P0_floor, P0_status, P0_exp, P0_coin, P0_material, P0_strange}};

unpack(srv, 13601, _B0) ->
    {ok, {}};
unpack(cli, 13601, _B0) ->
    {ok, {}};

unpack(srv, 13602, _B0) ->
    {ok, {}};
unpack(cli, 13602, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_status}};

unpack(srv, 13603, _B0) ->
    {ok, {}};
unpack(cli, 13603, _B0) ->
    {P0_floor, _B1} = lib_proto:read_uint16(_B0),
    {P0_rewards, _B5} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_type, _B3} = lib_proto:read_uint32(_B2),
        {P1_count, _B4} = lib_proto:read_uint32(_B3),
        {[P1_type, P1_count], _B4}
    end),
    {ok, {P0_floor, P0_rewards}};

unpack(srv, 13604, _B0) ->
    {ok, {}};
unpack(cli, 13604, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_type, _B2} = lib_proto:read_uint8(_B1),
    {P0_id, _B3} = lib_proto:read_uint32(_B2),
    {P0_count, _B4} = lib_proto:read_uint32(_B3),
    {ok, {P0_status, P0_type, P0_id, P0_count}};

unpack(srv, 13605, _B0) ->
    {ok, {}};
unpack(cli, 13605, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_is_bag, _B2} = lib_proto:read_uint8(_B1),
    {P0_win_is_bag, _B3} = lib_proto:read_uint8(_B2),
    {P0_gain, _B8} = lib_proto:read_array(_B3, fun(_B4) ->
        {P1_type, _B5} = lib_proto:read_uint8(_B4),
        {P1_item_id, _B6} = lib_proto:read_int32(_B5),
        {P1_num, _B7} = lib_proto:read_int32(_B6),
        {[P1_type, P1_item_id, P1_num], _B7}
    end),
    {ok, {P0_status, P0_is_bag, P0_win_is_bag, P0_gain}};

unpack(srv, 13606, _B0) ->
    {ok, {}};
unpack(cli, 13606, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_is_bag, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_status, P0_is_bag}};

unpack(srv, 13607, _B0) ->
    {ok, {}};
unpack(cli, 13607, _B0) ->
    {P0_boss_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_boss_id}};

unpack(srv, 13608, _B0) ->
    {ok, {}};
unpack(cli, 13608, _B0) ->
    {P0_floor, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_floor}};

unpack(srv, 13609, _B0) ->
    {ok, {}};
unpack(cli, 13609, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_status}};

unpack(srv, 13610, _B0) ->
    {ok, {}};
unpack(cli, 13610, _B0) ->
    {P0_exp, _B1} = lib_proto:read_uint32(_B0),
    {P0_coin, _B2} = lib_proto:read_uint32(_B1),
    {P0_material, _B3} = lib_proto:read_uint16(_B2),
    {P0_strange, _B4} = lib_proto:read_uint16(_B3),
    {ok, {P0_exp, P0_coin, P0_material, P0_strange}};

unpack(srv, 13611, _B0) ->
    {P0_is_buy, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_is_buy}};
unpack(cli, 13611, _B0) ->
    {P0_is_buy, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_is_buy}};

unpack(srv, 13612, _B0) ->
    {ok, {}};
unpack(cli, 13612, _B0) ->
    {ok, {}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
