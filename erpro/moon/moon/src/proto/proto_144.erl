%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_144).
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

pack(srv, ?_CMD(14400), {P0_role_num, P0_count}) ->
    D_a_t_a = <<?_(P0_role_num, '32'):32, ?_(P0_count, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14400:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14400), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14400:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14401), {P0_ver, P0_state, P0_next_state, P0_time}) ->
    D_a_t_a = <<?_(P0_ver, '8'):8, ?_(P0_state, '8'):8, ?_(P0_next_state, '8'):8, ?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14401:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14401), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14401:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14402), {P0_num}) ->
    D_a_t_a = <<?_(P0_num, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14402:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14402), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14402:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14405), {P0_state, P0_msg}) ->
    D_a_t_a = <<?_(P0_state, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14405:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14405), {P0_num}) ->
    D_a_t_a = <<?_(P0_num, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14405:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14406), {P0_state, P0_next_state, P0_time}) ->
    D_a_t_a = <<?_(P0_state, '8'):8, ?_(P0_next_state, '8'):8, ?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14406:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14406), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14406:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14407), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14407:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14407), {P0_fly_type}) ->
    D_a_t_a = <<?_(P0_fly_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14407:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14408), {P0_state, P0_msg}) ->
    D_a_t_a = <<?_(P0_state, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14408:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14408), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14408:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14409), {P0_state, P0_next_state, P0_time}) ->
    D_a_t_a = <<?_(P0_state, '8'):8, ?_(P0_next_state, '8'):8, ?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14409:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14409), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14409:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14410), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14410:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14410), {P0_fly_type}) ->
    D_a_t_a = <<?_(P0_fly_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14410:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14411), {P0_count}) ->
    D_a_t_a = <<?_(P0_count, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14411:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14411), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14411:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14420), {P0_luck_list, P0_my_list}) ->
    D_a_t_a = <<?_((length(P0_luck_list)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_type, '8'):8, ?_(P1_to_rid, '32'):32, ?_((byte_size(P1_to_srv_id)), "16"):16, ?_(P1_to_srv_id, bin)/binary, ?_((byte_size(P1_to_name)), "16"):16, ?_(P1_to_name, bin)/binary, ?_((byte_size(P1_nickname)), "16"):16, ?_(P1_nickname, bin)/binary, ?_((byte_size(P1_content)), "16"):16, ?_(P1_content, bin)/binary, ?_(P1_ctime, '32'):32>> || {P1_rid, P1_srv_id, P1_name, P1_type, P1_to_rid, P1_to_srv_id, P1_to_name, P1_nickname, P1_content, P1_ctime} <- P0_luck_list]))/binary, ?_((length(P0_my_list)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_type, '8'):8, ?_(P1_to_rid, '32'):32, ?_((byte_size(P1_to_srv_id)), "16"):16, ?_(P1_to_srv_id, bin)/binary, ?_((byte_size(P1_to_name)), "16"):16, ?_(P1_to_name, bin)/binary, ?_((byte_size(P1_nickname)), "16"):16, ?_(P1_nickname, bin)/binary, ?_((byte_size(P1_content)), "16"):16, ?_(P1_content, bin)/binary, ?_(P1_ctime, '32'):32>> || {P1_rid, P1_srv_id, P1_name, P1_type, P1_to_rid, P1_to_srv_id, P1_to_name, P1_nickname, P1_content, P1_ctime} <- P0_my_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14420:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14420), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14420:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14421), {P0_list}) ->
    D_a_t_a = <<?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_type, '8'):8, ?_(P1_to_rid, '32'):32, ?_((byte_size(P1_to_srv_id)), "16"):16, ?_(P1_to_srv_id, bin)/binary, ?_((byte_size(P1_to_name)), "16"):16, ?_(P1_to_name, bin)/binary, ?_((byte_size(P1_nickname)), "16"):16, ?_(P1_nickname, bin)/binary, ?_((byte_size(P1_content)), "16"):16, ?_(P1_content, bin)/binary, ?_(P1_ctime, '32'):32>> || {P1_rid, P1_srv_id, P1_name, P1_type, P1_to_rid, P1_to_srv_id, P1_to_name, P1_nickname, P1_content, P1_ctime} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14421:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14421), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14421:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14422), {P0_ret, P0_type, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_(P0_type, '8'):8, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14422:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14422), {P0_type, P0_rid, P0_srv_id, P0_name, P0_nickname, P0_content}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_((byte_size(P0_nickname)), "16"):16, ?_(P0_nickname, bin)/binary, ?_((byte_size(P0_content)), "16"):16, ?_(P0_content, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14422:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14423), {P0_type, P0_rid, P0_srv_id, P0_name, P0_nickname, P0_content}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_((byte_size(P0_nickname)), "16"):16, ?_(P0_nickname, bin)/binary, ?_((byte_size(P0_content)), "16"):16, ?_(P0_content, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14423:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14423), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14423:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14430), {P0_show, P0_wait_time, P0_nth, P0_n, P0_right, P0_wrong, P0_coin, P0_exp, P0_flower, P0_egg, P0_firework, P0_guide}) ->
    D_a_t_a = <<?_(P0_show, '8'):8, ?_(P0_wait_time, '32'):32, ?_(P0_nth, '8'):8, ?_(P0_n, '8'):8, ?_(P0_right, '8'):8, ?_(P0_wrong, '8'):8, ?_(P0_coin, '32'):32, ?_(P0_exp, '32'):32, ?_(P0_flower, '8'):8, ?_(P0_egg, '8'):8, ?_(P0_firework, '8'):8, ?_(P0_guide, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14430:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14430), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14430:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14431), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14431:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14431), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14431:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14432), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14432:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14432), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14432:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14433), {P0_finish}) ->
    D_a_t_a = <<?_(P0_finish, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14433:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14433), {P0_nth, P0_answer}) ->
    D_a_t_a = <<?_(P0_nth, '8'):8, ?_(P0_answer, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14433:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14434), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14434:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14434), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14434:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14435), {P0_name}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14435:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14435), {P0_cele_id}) ->
    D_a_t_a = <<?_(P0_cele_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14435:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14436), {P0_nth, P0_n, P0_name}) ->
    D_a_t_a = <<?_(P0_nth, '8'):8, ?_(P0_n, '8'):8, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14436:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14436), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14436:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14437), {P0_type, P0_code}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_code, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14437:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14437), {P0_type, P0_x1, P0_y1, P0_x2}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_x1, '16'):16, ?_(P0_y1, '16'):16, ?_(P0_x2, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14437:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14438), {P0_rid, P0_type, P0_x1, P0_y1, P0_x2}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_(P0_type, '8'):8, ?_(P0_x1, '16'):16, ?_(P0_y1, '16'):16, ?_(P0_x2, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14438:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14438), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14438:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14439), {P0_list}) ->
    D_a_t_a = <<?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_avail, '8'):8, ?_(P1_type, '8'):8, ?_(P1_sec, '32'):32>> || {P1_avail, P1_type, P1_sec} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14439:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14439), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14439:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14440), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14440:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14440), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14440:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 14430, _B0) ->
    {ok, {}};
unpack(cli, 14430, _B0) ->
    {P0_show, _B1} = lib_proto:read_uint8(_B0),
    {P0_wait_time, _B2} = lib_proto:read_uint32(_B1),
    {P0_nth, _B3} = lib_proto:read_uint8(_B2),
    {P0_n, _B4} = lib_proto:read_uint8(_B3),
    {P0_right, _B5} = lib_proto:read_uint8(_B4),
    {P0_wrong, _B6} = lib_proto:read_uint8(_B5),
    {P0_coin, _B7} = lib_proto:read_uint32(_B6),
    {P0_exp, _B8} = lib_proto:read_uint32(_B7),
    {P0_flower, _B9} = lib_proto:read_uint8(_B8),
    {P0_egg, _B10} = lib_proto:read_uint8(_B9),
    {P0_firework, _B11} = lib_proto:read_uint8(_B10),
    {P0_guide, _B12} = lib_proto:read_uint8(_B11),
    {ok, {P0_show, P0_wait_time, P0_nth, P0_n, P0_right, P0_wrong, P0_coin, P0_exp, P0_flower, P0_egg, P0_firework, P0_guide}};

unpack(srv, 14431, _B0) ->
    {ok, {}};
unpack(cli, 14431, _B0) ->
    {ok, {}};

unpack(srv, 14432, _B0) ->
    {ok, {}};
unpack(cli, 14432, _B0) ->
    {ok, {}};

unpack(srv, 14433, _B0) ->
    {P0_nth, _B1} = lib_proto:read_uint8(_B0),
    {P0_answer, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_nth, P0_answer}};
unpack(cli, 14433, _B0) ->
    {P0_finish, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_finish}};

unpack(srv, 14434, _B0) ->
    {ok, {}};
unpack(cli, 14434, _B0) ->
    {ok, {}};

unpack(srv, 14435, _B0) ->
    {P0_cele_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_cele_id}};
unpack(cli, 14435, _B0) ->
    {P0_name, _B1} = lib_proto:read_string(_B0),
    {ok, {P0_name}};

unpack(srv, 14436, _B0) ->
    {ok, {}};
unpack(cli, 14436, _B0) ->
    {P0_nth, _B1} = lib_proto:read_uint8(_B0),
    {P0_n, _B2} = lib_proto:read_uint8(_B1),
    {P0_name, _B3} = lib_proto:read_string(_B2),
    {ok, {P0_nth, P0_n, P0_name}};

unpack(srv, 14437, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_x1, _B2} = lib_proto:read_uint16(_B1),
    {P0_y1, _B3} = lib_proto:read_uint16(_B2),
    {P0_x2, _B4} = lib_proto:read_uint16(_B3),
    {ok, {P0_type, P0_x1, P0_y1, P0_x2}};
unpack(cli, 14437, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_code, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_type, P0_code}};

unpack(srv, 14438, _B0) ->
    {ok, {}};
unpack(cli, 14438, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_type, _B2} = lib_proto:read_uint8(_B1),
    {P0_x1, _B3} = lib_proto:read_uint16(_B2),
    {P0_y1, _B4} = lib_proto:read_uint16(_B3),
    {P0_x2, _B5} = lib_proto:read_uint16(_B4),
    {ok, {P0_rid, P0_type, P0_x1, P0_y1, P0_x2}};

unpack(srv, 14439, _B0) ->
    {ok, {}};
unpack(cli, 14439, _B0) ->
    {P0_list, _B5} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_avail, _B2} = lib_proto:read_uint8(_B1),
        {P1_type, _B3} = lib_proto:read_uint8(_B2),
        {P1_sec, _B4} = lib_proto:read_uint32(_B3),
        {[P1_avail, P1_type, P1_sec], _B4}
    end),
    {ok, {P0_list}};

unpack(srv, 14440, _B0) ->
    {ok, {}};
unpack(cli, 14440, _B0) ->
    {ok, {}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
