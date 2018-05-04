%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_137).
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

pack(srv, ?_CMD(13700), {P0_uint_type}) ->
    D_a_t_a = <<?_((length(P0_uint_type)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_value, '32'):32>> || {P1_type, P1_value} <- P0_uint_type]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13700:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13700), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13700:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13701), {P0_string_type}) ->
    D_a_t_a = <<?_((length(P0_string_type)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_((byte_size(P1_value)), "16"):16, ?_(P1_value, bin)/binary>> || {P1_type, P1_value} <- P0_string_type]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13701:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13701), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13701:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13702), {P0_gid, P0_srv_id, P0_name, P0_inviter}) ->
    D_a_t_a = <<?_(P0_gid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_((byte_size(P0_inviter)), "16"):16, ?_(P0_inviter, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13702:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13702), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13702:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13703), {P0_gid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_gid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13703:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13703), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13703:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13704), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13704:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13704), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13704:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13705), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13705:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13705), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13705:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13720), {P0_fund}) ->
    D_a_t_a = <<?_(P0_fund, '32/signed'):32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13720:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13720), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13720:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13721), {P0_uint_type}) ->
    D_a_t_a = <<?_((length(P0_uint_type)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_value, '32'):32>> || {P1_type, P1_value} <- P0_uint_type]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13721:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13721), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13721:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13722), {P0_string_type}) ->
    D_a_t_a = <<?_((length(P0_string_type)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_((byte_size(P1_value)), "16"):16, ?_(P1_value, bin)/binary>> || {P1_type, P1_value} <- P0_string_type]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13722:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13722), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13722:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13723), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13723:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13723), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13723:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13724), {P0_id, P0_vip, P0_name, P0_msg, P0_date}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_vip, '8'):8, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_date, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13724:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13724), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13724:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13725), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13725:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13725), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13725:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13726), {P0_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13726:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13726), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13726:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13727), {P0_rid, P0_srv_id, P0_name, P0_lev, P0_career, P0_sex, P0_fight, P0_vip}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_lev, '8'):8, ?_(P0_career, '8'):8, ?_(P0_sex, '8'):8, ?_(P0_fight, '32'):32, ?_(P0_vip, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13727:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13727), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13727:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13728), {P0_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13728:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13728), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13728:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13729), {P0_rid, P0_srv_id, P0_name, P0_lev, P0_position, P0_fight, P0_vip, P0_gravatar, P0_donation, P0_date, P0_pid, P0_pet_fight, P0_career, P0_sex}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_lev, '8'):8, ?_(P0_position, '8'):8, ?_(P0_fight, '32'):32, ?_(P0_vip, '8'):8, ?_(P0_gravatar, '32'):32, ?_(P0_donation, '32'):32, ?_(P0_date, '32'):32, ?_(P0_pid, '8'):8, ?_(P0_pet_fight, '32'):32, ?_(P0_career, '8'):8, ?_(P0_sex, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13729:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13729), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13729:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13730), {P0_name, P0_date}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_date, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13730:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13730), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13730:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13731), {P0_type, P0_lev}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_lev, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13731:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13731), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13731:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13732), {P0_notice}) ->
    D_a_t_a = <<?_((length(P0_notice)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_value, '16'):16>> || {P1_type, P1_value} <- P0_notice]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13732:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13732), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13732:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 13700, _B0) ->
    {ok, {}};
unpack(cli, 13700, _B0) ->
    {P0_uint_type, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_type, _B2} = lib_proto:read_uint8(_B1),
        {P1_value, _B3} = lib_proto:read_uint32(_B2),
        {[P1_type, P1_value], _B3}
    end),
    {ok, {P0_uint_type}};

unpack(srv, 13701, _B0) ->
    {ok, {}};
unpack(cli, 13701, _B0) ->
    {P0_string_type, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_type, _B2} = lib_proto:read_uint8(_B1),
        {P1_value, _B3} = lib_proto:read_string(_B2),
        {[P1_type, P1_value], _B3}
    end),
    {ok, {P0_string_type}};

unpack(srv, 13702, _B0) ->
    {ok, {}};
unpack(cli, 13702, _B0) ->
    {P0_gid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_name, _B3} = lib_proto:read_string(_B2),
    {P0_inviter, _B4} = lib_proto:read_string(_B3),
    {ok, {P0_gid, P0_srv_id, P0_name, P0_inviter}};

unpack(srv, 13703, _B0) ->
    {ok, {}};
unpack(cli, 13703, _B0) ->
    {P0_gid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_gid, P0_srv_id}};

unpack(srv, 13704, _B0) ->
    {ok, {}};
unpack(cli, 13704, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_type}};

unpack(srv, 13705, _B0) ->
    {ok, {}};
unpack(cli, 13705, _B0) ->
    {ok, {}};

unpack(srv, 13720, _B0) ->
    {ok, {}};
unpack(cli, 13720, _B0) ->
    {P0_fund, _B1} = lib_proto:read_int32(_B0),
    {ok, {P0_fund}};

unpack(srv, 13721, _B0) ->
    {ok, {}};
unpack(cli, 13721, _B0) ->
    {P0_uint_type, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_type, _B2} = lib_proto:read_uint8(_B1),
        {P1_value, _B3} = lib_proto:read_uint32(_B2),
        {[P1_type, P1_value], _B3}
    end),
    {ok, {P0_uint_type}};

unpack(srv, 13722, _B0) ->
    {ok, {}};
unpack(cli, 13722, _B0) ->
    {P0_string_type, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_type, _B2} = lib_proto:read_uint8(_B1),
        {P1_value, _B3} = lib_proto:read_string(_B2),
        {[P1_type, P1_value], _B3}
    end),
    {ok, {P0_string_type}};

unpack(srv, 13723, _B0) ->
    {ok, {}};
unpack(cli, 13723, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};

unpack(srv, 13724, _B0) ->
    {ok, {}};
unpack(cli, 13724, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_vip, _B2} = lib_proto:read_uint8(_B1),
    {P0_name, _B3} = lib_proto:read_string(_B2),
    {P0_msg, _B4} = lib_proto:read_string(_B3),
    {P0_date, _B5} = lib_proto:read_uint32(_B4),
    {ok, {P0_id, P0_vip, P0_name, P0_msg, P0_date}};

unpack(srv, 13725, _B0) ->
    {ok, {}};
unpack(cli, 13725, _B0) ->
    {ok, {}};

unpack(srv, 13726, _B0) ->
    {ok, {}};
unpack(cli, 13726, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_id, P0_srv_id}};

unpack(srv, 13727, _B0) ->
    {ok, {}};
unpack(cli, 13727, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_name, _B3} = lib_proto:read_string(_B2),
    {P0_lev, _B4} = lib_proto:read_uint8(_B3),
    {P0_career, _B5} = lib_proto:read_uint8(_B4),
    {P0_sex, _B6} = lib_proto:read_uint8(_B5),
    {P0_fight, _B7} = lib_proto:read_uint32(_B6),
    {P0_vip, _B8} = lib_proto:read_uint8(_B7),
    {ok, {P0_rid, P0_srv_id, P0_name, P0_lev, P0_career, P0_sex, P0_fight, P0_vip}};

unpack(srv, 13728, _B0) ->
    {ok, {}};
unpack(cli, 13728, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_id, P0_srv_id}};

unpack(srv, 13729, _B0) ->
    {ok, {}};
unpack(cli, 13729, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_name, _B3} = lib_proto:read_string(_B2),
    {P0_lev, _B4} = lib_proto:read_uint8(_B3),
    {P0_position, _B5} = lib_proto:read_uint8(_B4),
    {P0_fight, _B6} = lib_proto:read_uint32(_B5),
    {P0_vip, _B7} = lib_proto:read_uint8(_B6),
    {P0_gravatar, _B8} = lib_proto:read_uint32(_B7),
    {P0_donation, _B9} = lib_proto:read_uint32(_B8),
    {P0_date, _B10} = lib_proto:read_uint32(_B9),
    {P0_pid, _B11} = lib_proto:read_uint8(_B10),
    {P0_pet_fight, _B12} = lib_proto:read_uint32(_B11),
    {P0_career, _B13} = lib_proto:read_uint8(_B12),
    {P0_sex, _B14} = lib_proto:read_uint8(_B13),
    {ok, {P0_rid, P0_srv_id, P0_name, P0_lev, P0_position, P0_fight, P0_vip, P0_gravatar, P0_donation, P0_date, P0_pid, P0_pet_fight, P0_career, P0_sex}};

unpack(srv, 13730, _B0) ->
    {ok, {}};
unpack(cli, 13730, _B0) ->
    {P0_name, _B1} = lib_proto:read_string(_B0),
    {P0_date, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_name, P0_date}};

unpack(srv, 13731, _B0) ->
    {ok, {}};
unpack(cli, 13731, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_lev, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_type, P0_lev}};

unpack(srv, 13732, _B0) ->
    {ok, {}};
unpack(cli, 13732, _B0) ->
    {P0_notice, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_type, _B2} = lib_proto:read_uint8(_B1),
        {P1_value, _B3} = lib_proto:read_uint16(_B2),
        {[P1_type, P1_value], _B3}
    end),
    {ok, {P0_notice}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
