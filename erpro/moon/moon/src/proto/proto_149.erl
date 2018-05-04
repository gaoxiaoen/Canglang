%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_149).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("guild_td.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(14900), {P0_flag, P0_state, P0_wave, P0_hp, P0_time, P0_point}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_(P0_state, '8'):8, ?_(P0_wave, '32'):32, ?_(P0_hp, '32'):32, ?_(P0_time, '32'):32, ?_((length(P0_point)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_value, '32'):32>> || {P1_role_id, P1_name, P1_value} <- P0_point]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14900:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14900), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14900:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14901), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14901:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14901), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14901:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14902), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14902:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14902), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14902:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14903), {P0_wave, P0_hp, P0_time}) ->
    D_a_t_a = <<?_(P0_wave, '32'):32, ?_(P0_hp, '32'):32, ?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14903:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14903), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14903:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14904), {P0_point}) ->
    D_a_t_a = <<?_((length(P0_point)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_value, '32'):32>> || {P1_role_id, P1_name, P1_value} <- P0_point]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14904:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14904), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14904:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14905), {P0_value, P0_wave, P0_hp, P0_time}) ->
    D_a_t_a = <<?_(P0_value, '8'):8, ?_(P0_wave, '32'):32, ?_(P0_hp, '32'):32, ?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14905:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14905), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14905:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14906), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14906:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14906), {P0_mode, P0_lev}) ->
    D_a_t_a = <<?_(P0_mode, '8'):8, ?_(P0_lev, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14906:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14907), {P0_flag}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14907:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14907), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14907:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14908), {P0_day, P0_mode, P0_lev}) ->
    D_a_t_a = <<?_(P0_day, '8'):8, ?_(P0_mode, '8'):8, ?_(P0_lev, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14908:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14908), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14908:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14909), {P0_npc_flag}) ->
    D_a_t_a = <<?_(P0_npc_flag, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14909:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14909), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14909:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 14900, _B0) ->
    {ok, {}};
unpack(cli, 14900, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_state, _B2} = lib_proto:read_uint8(_B1),
    {P0_wave, _B3} = lib_proto:read_uint32(_B2),
    {P0_hp, _B4} = lib_proto:read_uint32(_B3),
    {P0_time, _B5} = lib_proto:read_uint32(_B4),
    {P0_point, _B10} = lib_proto:read_array(_B5, fun(_B6) ->
        {P1_role_id, _B7} = lib_proto:read_uint32(_B6),
        {P1_name, _B8} = lib_proto:read_string(_B7),
        {P1_value, _B9} = lib_proto:read_uint32(_B8),
        {[P1_role_id, P1_name, P1_value], _B9}
    end),
    {ok, {P0_flag, P0_state, P0_wave, P0_hp, P0_time, P0_point}};

unpack(srv, 14901, _B0) ->
    {ok, {}};
unpack(cli, 14901, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 14902, _B0) ->
    {ok, {}};
unpack(cli, 14902, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 14903, _B0) ->
    {ok, {}};
unpack(cli, 14903, _B0) ->
    {P0_wave, _B1} = lib_proto:read_uint32(_B0),
    {P0_hp, _B2} = lib_proto:read_uint32(_B1),
    {P0_time, _B3} = lib_proto:read_uint32(_B2),
    {ok, {P0_wave, P0_hp, P0_time}};

unpack(srv, 14904, _B0) ->
    {ok, {}};
unpack(cli, 14904, _B0) ->
    {P0_point, _B5} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_role_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_name, _B3} = lib_proto:read_string(_B2),
        {P1_value, _B4} = lib_proto:read_uint32(_B3),
        {[P1_role_id, P1_name, P1_value], _B4}
    end),
    {ok, {P0_point}};

unpack(srv, 14905, _B0) ->
    {ok, {}};
unpack(cli, 14905, _B0) ->
    {P0_value, _B1} = lib_proto:read_uint8(_B0),
    {P0_wave, _B2} = lib_proto:read_uint32(_B1),
    {P0_hp, _B3} = lib_proto:read_uint32(_B2),
    {P0_time, _B4} = lib_proto:read_uint32(_B3),
    {ok, {P0_value, P0_wave, P0_hp, P0_time}};

unpack(srv, 14906, _B0) ->
    {P0_mode, _B1} = lib_proto:read_uint8(_B0),
    {P0_lev, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_mode, P0_lev}};
unpack(cli, 14906, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 14907, _B0) ->
    {ok, {}};
unpack(cli, 14907, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_flag}};

unpack(srv, 14908, _B0) ->
    {ok, {}};
unpack(cli, 14908, _B0) ->
    {P0_day, _B1} = lib_proto:read_uint8(_B0),
    {P0_mode, _B2} = lib_proto:read_uint8(_B1),
    {P0_lev, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_day, P0_mode, P0_lev}};

unpack(srv, 14909, _B0) ->
    {ok, {}};
unpack(cli, 14909, _B0) ->
    {P0_npc_flag, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_npc_flag}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
