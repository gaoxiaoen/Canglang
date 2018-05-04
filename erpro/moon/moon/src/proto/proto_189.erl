%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_189).
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

pack(srv, ?_CMD(18900), {P0_status}) ->
    D_a_t_a = <<?_(P0_status, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18900:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18900), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18900:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18901), {P0_lev, P0_area, P0_msg, P0_fields}) ->
    D_a_t_a = <<?_(P0_lev, '16'):16, ?_(P0_area, '16'):16, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_((length(P0_fields)), "16"):16, (list_to_binary([<<?_(P1_lev, '16'):16, ?_(P1_area, '16'):16, ?_(P1_status, '8'):8>> || {P1_lev, P1_area, P1_status} <- P0_fields]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18901:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18901), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18901:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18902), {P0_train, P0_rob, P0_arrest, P0_fight}) ->
    D_a_t_a = <<?_(P0_train, '8'):8, ?_(P0_rob, '8'):8, ?_(P0_arrest, '8'):8, ?_(P0_fight, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18902:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18902), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18902:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18903), {P0_status, P0_time, P0_lev, P0_area}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_time, '16'):16, ?_(P0_lev, '16'):16, ?_(P0_area, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18903:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18903), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18903:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18904), {P0_lev, P0_area, P0_roles}) ->
    D_a_t_a = <<?_(P0_lev, '16'):16, ?_(P0_area, '16'):16, ?_((length(P0_roles)), "16"):16, (list_to_binary([<<?_(P1_x, '32'):32, ?_(P1_y, '32'):32, ?_(P1_rid, '32'):32, ?_((byte_size(P1_srvid)), "16"):16, ?_(P1_srvid, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_online, '8'):8, ?_(P1_robed, '8'):8, ?_(P1_fight, '32'):32, ?_(P1_time, '32'):32, ?_(P1_sex, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_quality, '8'):8, ?_(P1_career, '8'):8>> || {P1_x, P1_y, P1_rid, P1_srvid, P1_name, P1_online, P1_robed, P1_fight, P1_time, P1_sex, P1_lev, P1_quality, P1_career} <- P0_roles]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18904:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18904), {P0_lev, P0_area}) ->
    D_a_t_a = <<?_(P0_lev, '16'):16, ?_(P0_area, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18904:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18905), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18905:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18905), {P0_lev, P0_area, P0_quality}) ->
    D_a_t_a = <<?_(P0_lev, '16'):16, ?_(P0_area, '16'):16, ?_(P0_quality, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18905:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18906), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18906:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18906), {P0_lev, P0_area}) ->
    D_a_t_a = <<?_(P0_lev, '16'):16, ?_(P0_area, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18906:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18907), {P0_lev, P0_area, P0_roles}) ->
    D_a_t_a = <<?_(P0_lev, '16'):16, ?_(P0_area, '16'):16, ?_((length(P0_roles)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srvid)), "16"):16, ?_(P1_srvid, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_fight, '32'):32, ?_(P1_sex, '8'):8, ?_(P1_move_speed, '32'):32, ?_(P1_x, '32'):32, ?_(P1_y, '32'):32, ?_(P1_pos, '8'):8, ?_(P1_status, '8'):8, ?_(P1_hq, '32'):32, ?_(P1_career, '8'):8, ?_(P1_o_rid, '32'):32, ?_((byte_size(P1_o_srvid)), "16"):16, ?_(P1_o_srvid, bin)/binary>> || {P1_rid, P1_srvid, P1_name, P1_fight, P1_sex, P1_move_speed, P1_x, P1_y, P1_pos, P1_status, P1_hq, P1_career, P1_o_rid, P1_o_srvid} <- P0_roles]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18907:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18907), {P0_lev, P0_area}) ->
    D_a_t_a = <<?_(P0_lev, '16'):16, ?_(P0_area, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18907:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18908), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18908:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18908), {P0_lev, P0_area, P0_rid, P0_srvid}) ->
    D_a_t_a = <<?_(P0_lev, '16'):16, ?_(P0_area, '16'):16, ?_(P0_rid, '32'):32, ?_((byte_size(P0_srvid)), "16"):16, ?_(P0_srvid, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18908:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18909), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18909:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18909), {P0_lev, P0_area, P0_rid, P0_srvid}) ->
    D_a_t_a = <<?_(P0_lev, '16'):16, ?_(P0_area, '16'):16, ?_(P0_rid, '32'):32, ?_((byte_size(P0_srvid)), "16"):16, ?_(P0_srvid, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18909:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18910), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18910:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18910), {P0_lev, P0_area}) ->
    D_a_t_a = <<?_(P0_lev, '16'):16, ?_(P0_area, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18910:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18911), {P0_lev, P0_area, P0_status}) ->
    D_a_t_a = <<?_(P0_lev, '16'):16, ?_(P0_area, '16'):16, ?_(P0_status, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18911:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18911), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18911:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18912), {P0_lev, P0_area, P0_x, P0_y, P0_rid, P0_srvid, P0_name, P0_online, P0_robed, P0_fight, P0_time, P0_sex, P0_rlev, P0_quality, P0_career}) ->
    D_a_t_a = <<?_(P0_lev, '16'):16, ?_(P0_area, '16'):16, ?_(P0_x, '32'):32, ?_(P0_y, '32'):32, ?_(P0_rid, '32'):32, ?_((byte_size(P0_srvid)), "16"):16, ?_(P0_srvid, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_online, '8'):8, ?_(P0_robed, '8'):8, ?_(P0_fight, '32'):32, ?_(P0_time, '32'):32, ?_(P0_sex, '8'):8, ?_(P0_rlev, '8'):8, ?_(P0_quality, '8'):8, ?_(P0_career, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18912:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18912), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18912:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18913), {P0_lev, P0_area, P0_rid, P0_srvid, P0_name, P0_fight, P0_sex, P0_move_speed, P0_x, P0_y, P0_pos, P0_status, P0_hq, P0_career, P0_o_rid, P0_o_srvid}) ->
    D_a_t_a = <<?_(P0_lev, '16'):16, ?_(P0_area, '16'):16, ?_(P0_rid, '32'):32, ?_((byte_size(P0_srvid)), "16"):16, ?_(P0_srvid, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_fight, '32'):32, ?_(P0_sex, '8'):8, ?_(P0_move_speed, '32'):32, ?_(P0_x, '32'):32, ?_(P0_y, '32'):32, ?_(P0_pos, '8'):8, ?_(P0_status, '8'):8, ?_(P0_hq, '32'):32, ?_(P0_career, '8'):8, ?_(P0_o_rid, '32'):32, ?_((byte_size(P0_o_srvid)), "16"):16, ?_(P0_o_srvid, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18913:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18913), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18913:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18914), {P0_lev, P0_area, P0_rid, P0_srvid}) ->
    D_a_t_a = <<?_(P0_lev, '16'):16, ?_(P0_area, '16'):16, ?_(P0_rid, '32'):32, ?_((byte_size(P0_srvid)), "16"):16, ?_(P0_srvid, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18914:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18914), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18914:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18915), {P0_lev, P0_area, P0_rid, P0_srvid}) ->
    D_a_t_a = <<?_(P0_lev, '16'):16, ?_(P0_area, '16'):16, ?_(P0_rid, '32'):32, ?_((byte_size(P0_srvid)), "16"):16, ?_(P0_srvid, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18915:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18915), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18915:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18916), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18916:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18916), {P0_lev, P0_area}) ->
    D_a_t_a = <<?_(P0_lev, '16'):16, ?_(P0_area, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18916:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18917), {P0_msg}) ->
    D_a_t_a = <<?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18917:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18917), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18917:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
