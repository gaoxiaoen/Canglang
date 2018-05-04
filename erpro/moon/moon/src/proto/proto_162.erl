%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_162).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("change.hrl").
-include("compete.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(16200), {P0_status}) ->
    D_a_t_a = <<?_(P0_status, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16200:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16200), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16200:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16201), {P0_status, P0_enter_count, P0_today_honor, P0_buff_count}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_enter_count, '8'):8, ?_(P0_today_honor, '16'):16, ?_(P0_buff_count, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16201:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16201), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16201:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16203), {P0_result}) ->
    D_a_t_a = <<?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16203:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16203), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16203:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16204), {P0_result}) ->
    D_a_t_a = <<?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16204:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16204), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16204:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16205), {P0_result, P0_honor, P0_badge}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_honor, '32'):32, ?_(P0_badge, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16205:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16205), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16205:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16210), {P0_result, P0_enter_count, P0_today_honor, P0_buff_count}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_enter_count, '8'):8, ?_(P0_today_honor, '16'):16, ?_(P0_buff_count, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16210:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16210), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16210:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16220), {P0_items}) ->
    D_a_t_a = <<?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_(P1_count, '8'):8, ?_(P1_base_id, '32'):32, ?_(P1_price, '16'):16, ?_(P1_limit, '32'):32>> || #change_item{id = P1_id, count = P1_count, base_id = P1_base_id, price = P1_price, limit = P1_limit} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16220:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16220), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16220:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16221), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16221:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16221), {P0_id, P0_num}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_(P0_num, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16221:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16225), {P0_rank_list}) ->
    D_a_t_a = <<?_((length(P0_rank_list)), "16"):16, (list_to_binary([<<?_(P1_rank, '16'):16, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_total_power, '32'):32, ?_(P1_honor, '32'):32, ?_(P1_trend, '8'):8>> || #compete_rank{rank = P1_rank, name = P1_name, total_power = P1_total_power, honor = P1_honor, trend = P1_trend} <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16225:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16225), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16225:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 16200, _B0) ->
    {ok, {}};
unpack(cli, 16200, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_status}};

unpack(srv, 16201, _B0) ->
    {ok, {}};
unpack(cli, 16201, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_enter_count, _B2} = lib_proto:read_uint8(_B1),
    {P0_today_honor, _B3} = lib_proto:read_uint16(_B2),
    {P0_buff_count, _B4} = lib_proto:read_uint8(_B3),
    {ok, {P0_status, P0_enter_count, P0_today_honor, P0_buff_count}};

unpack(srv, 16203, _B0) ->
    {ok, {}};
unpack(cli, 16203, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_result}};

unpack(srv, 16204, _B0) ->
    {ok, {}};
unpack(cli, 16204, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_result}};

unpack(srv, 16205, _B0) ->
    {ok, {}};
unpack(cli, 16205, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_honor, _B2} = lib_proto:read_uint32(_B1),
    {P0_badge, _B3} = lib_proto:read_uint32(_B2),
    {ok, {P0_result, P0_honor, P0_badge}};

unpack(srv, 16210, _B0) ->
    {ok, {}};
unpack(cli, 16210, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_enter_count, _B2} = lib_proto:read_uint8(_B1),
    {P0_today_honor, _B3} = lib_proto:read_uint16(_B2),
    {P0_buff_count, _B4} = lib_proto:read_uint8(_B3),
    {ok, {P0_result, P0_enter_count, P0_today_honor, P0_buff_count}};

unpack(srv, 16220, _B0) ->
    {ok, {}};
unpack(cli, 16220, _B0) ->
    {P0_items, _B7} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint8(_B1),
        {P1_count, _B3} = lib_proto:read_uint8(_B2),
        {P1_base_id, _B4} = lib_proto:read_uint32(_B3),
        {P1_price, _B5} = lib_proto:read_uint16(_B4),
        {P1_limit, _B6} = lib_proto:read_uint32(_B5),
        {[P1_id, P1_count, P1_base_id, P1_price, P1_limit], _B6}
    end),
    {ok, {P0_items}};

unpack(srv, 16221, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint8(_B0),
    {P0_num, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_id, P0_num}};
unpack(cli, 16221, _B0) ->
    {ok, {}};

unpack(srv, 16225, _B0) ->
    {ok, {}};
unpack(cli, 16225, _B0) ->
    {P0_rank_list, _B7} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_rank, _B2} = lib_proto:read_uint16(_B1),
        {P1_name, _B3} = lib_proto:read_string(_B2),
        {P1_total_power, _B4} = lib_proto:read_uint32(_B3),
        {P1_honor, _B5} = lib_proto:read_uint32(_B4),
        {P1_trend, _B6} = lib_proto:read_uint8(_B5),
        {[P1_rank, P1_name, P1_total_power, P1_honor, P1_trend], _B6}
    end),
    {ok, {P0_rank_list}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
