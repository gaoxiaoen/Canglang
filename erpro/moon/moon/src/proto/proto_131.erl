%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_131).
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

pack(srv, ?_CMD(13100), {P0_result, P0_msg, P0_quality, P0_times}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_quality, '8'):8, ?_(P0_times, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13100:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13100), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13100:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13101), {P0_result, P0_msg, P0_quality}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_quality, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13101:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13101), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13101:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13102), {P0_result, P0_msg, P0_map_id, P0_npc_id}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_map_id, '32'):32, ?_(P0_npc_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13102:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13102), {P0_type, P0_npc_id}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_npc_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13102:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13103), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13103:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13103), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13103:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13104), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13104:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13104), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13104:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13105), {P0_exp, P0_coin, P0_coin_bind}) ->
    D_a_t_a = <<?_(P0_exp, '32'):32, ?_(P0_coin, '32'):32, ?_(P0_coin_bind, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13105:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13105), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13105:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13106), {P0_status, P0_time}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13106:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13106), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13106:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13107), {P0_time}) ->
    D_a_t_a = <<?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13107:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13107), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13107:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13108), {P0_result, P0_msg, P0_quality, P0_times}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_quality, '8'):8, ?_(P0_times, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13108:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13108), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13108:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13109), {P0_result, P0_msg, P0_quality}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_quality, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13109:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13109), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13109:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13110), {P0_result, P0_msg, P0_map_id, P0_npc_id}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_map_id, '32'):32, ?_(P0_npc_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13110:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13110), {P0_type, P0_npc_id}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_npc_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13110:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13115), {P0_finger, P0_result}) ->
    D_a_t_a = <<?_(P0_finger, '8'):8, ?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13115:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13115), {P0_finger}) ->
    D_a_t_a = <<?_(P0_finger, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13115:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13116), {P0_id, P0_question, P0_answer_a, P0_answer_b}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_((byte_size(P0_question)), "16"):16, ?_(P0_question, bin)/binary, ?_((byte_size(P0_answer_a)), "16"):16, ?_(P0_answer_a, bin)/binary, ?_((byte_size(P0_answer_b)), "16"):16, ?_(P0_answer_b, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13116:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13116), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13116:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13117), {P0_id, P0_result}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13117:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13117), {P0_id, P0_answer}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_(P0_answer, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13117:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13118), {P0_point, P0_result}) ->
    D_a_t_a = <<?_(P0_point, '8'):8, ?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13118:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13118), {P0_point}) ->
    D_a_t_a = <<?_(P0_point, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13118:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
