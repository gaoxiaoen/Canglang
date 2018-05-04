%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_194).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("looks.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(19400), {P0_looks}) ->
    D_a_t_a = <<?_((length(P0_looks)), "16"):16, (list_to_binary([<<?_(P1_looks_type, '32'):32, ?_(P1_looks_id, '32'):32, ?_(P1_looks_value, '32'):32>> || {P1_looks_type, P1_looks_id, P1_looks_value} <- P0_looks]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19400:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19400), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19400:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19401), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19401:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19401), {P0_looks}) ->
    D_a_t_a = <<?_((length(P0_looks)), "16"):16, (list_to_binary([<<?_(P1_type, '32'):32, ?_(P1_id, '32'):32, ?_(P1_enchant, '32'):32>> || {P1_type, P1_id, P1_enchant} <- P0_looks]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19401:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19450), {P0_suits}) ->
    D_a_t_a = <<?_((length(P0_suits)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_((length(P1_components)), "16"):16, (list_to_binary([<<?_(P2_item_id, '32'):32>> || P2_item_id <- P1_components]))/binary, ?_((length(P1_effects)), "16"):16, (list_to_binary([<<?_(P2_num, '8'):8, ?_((length(P2_attrs)), "16"):16, (list_to_binary([<<?_(P3_type, '32'):32, ?_(P3_value, '32'):32>> || {P3_type, P3_value} <- P2_attrs]))/binary>> || {P2_num, P2_attrs} <- P1_effects]))/binary>> || {P1_id, P1_name, P1_components, P1_effects} <- P0_suits]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19450:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19450), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19450:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19451), {P0_attrs}) ->
    D_a_t_a = <<?_((length(P0_attrs)), "16"):16, (list_to_binary([<<?_(P1_type, '32'):32, ?_(P1_value, '32'):32>> || {P1_type, P1_value} <- P0_attrs]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19451:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19451), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19451:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 19400, _B0) ->
    {ok, {}};
unpack(cli, 19400, _B0) ->
    {P0_looks, _B5} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_looks_type, _B2} = lib_proto:read_uint32(_B1),
        {P1_looks_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_looks_value, _B4} = lib_proto:read_uint32(_B3),
        {[P1_looks_type, P1_looks_id, P1_looks_value], _B4}
    end),
    {ok, {P0_looks}};

unpack(srv, 19401, _B0) ->
    {P0_looks, _B5} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_type, _B2} = lib_proto:read_uint32(_B1),
        {P1_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_enchant, _B4} = lib_proto:read_uint32(_B3),
        {[P1_type, P1_id, P1_enchant], _B4}
    end),
    {ok, {P0_looks}};
unpack(cli, 19401, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_status, P0_msg}};

unpack(srv, 19450, _B0) ->
    {ok, {}};
unpack(cli, 19450, _B0) ->
    {P0_suits, _B14} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_name, _B3} = lib_proto:read_string(_B2),
        {P1_components, _B6} = lib_proto:read_array(_B3, fun(_B4) ->
            {P2_item_id, _B5} = lib_proto:read_uint32(_B4),
            {P2_item_id, _B5}
        end),
        {P1_effects, _B13} = lib_proto:read_array(_B6, fun(_B7) ->
            {P2_num, _B8} = lib_proto:read_uint8(_B7),
            {P2_attrs, _B12} = lib_proto:read_array(_B8, fun(_B9) ->
                {P3_type, _B10} = lib_proto:read_uint32(_B9),
                {P3_value, _B11} = lib_proto:read_uint32(_B10),
                {[P3_type, P3_value], _B11}
            end),
            {[P2_num, P2_attrs], _B12}
        end),
        {[P1_id, P1_name, P1_components, P1_effects], _B13}
    end),
    {ok, {P0_suits}};

unpack(srv, 19451, _B0) ->
    {ok, {}};
unpack(cli, 19451, _B0) ->
    {P0_attrs, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_type, _B2} = lib_proto:read_uint32(_B1),
        {P1_value, _B3} = lib_proto:read_uint32(_B2),
        {[P1_type, P1_value], _B3}
    end),
    {ok, {P0_attrs}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
