%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_115).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("skill.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(11500), {P0_skill_all}) ->
    D_a_t_a = <<?_((length(P0_skill_all)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32>> || {P1_id} <- P0_skill_all]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11500:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11500), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11500:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11501), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11501:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11501), {P0_now_id}) ->
    D_a_t_a = <<?_(P0_now_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11501:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11503), {P0_id_list}) ->
    D_a_t_a = <<?_((length(P0_id_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32>> || P1_id <- P0_id_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11503:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11503), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11503:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11504), {P0_skill_append}) ->
    D_a_t_a = <<?_((length(P0_skill_append)), "16"):16, (list_to_binary([<<?_(P1_id_type, '32'):32, ?_(P1_num, '8'):8>> || {P1_id_type, P1_num} <- P0_skill_append]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11504:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11504), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11504:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11505), {P0_skilled_list}) ->
    D_a_t_a = <<?_((length(P0_skilled_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_skilled, '16'):16>> || {P1_id, P1_skilled} <- P0_skilled_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11505:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11505), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11505:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11506), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11506:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11506), {P0_id, P0_val}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_val, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11506:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11510), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11510:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11510), {P0_lineup_id}) ->
    D_a_t_a = <<?_(P0_lineup_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11510:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11511), {P0_lineup_id}) ->
    D_a_t_a = <<?_(P0_lineup_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11511:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11511), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11511:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11540), {P0_index_1, P0_index_2, P0_index_3, P0_index_4, P0_index_5, P0_index_6, P0_index_7, P0_index_8, P0_index_9, P0_index_10}) ->
    D_a_t_a = <<?_(P0_index_1, '32'):32, ?_(P0_index_2, '32'):32, ?_(P0_index_3, '32'):32, ?_(P0_index_4, '32'):32, ?_(P0_index_5, '32'):32, ?_(P0_index_6, '32'):32, ?_(P0_index_7, '32'):32, ?_(P0_index_8, '32'):32, ?_(P0_index_9, '32'):32, ?_(P0_index_10, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11540:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11540), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11540:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11541), {P0_result}) ->
    D_a_t_a = <<?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11541:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11541), {P0_index, P0_skill_id}) ->
    D_a_t_a = <<?_(P0_index, '8'):8, ?_(P0_skill_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11541:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11542), {P0_result}) ->
    D_a_t_a = <<?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11542:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11542), {P0_index_one, P0_index_two}) ->
    D_a_t_a = <<?_(P0_index_one, '8'):8, ?_(P0_index_two, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11542:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11550), {P0_rid, P0_srv_id, P0_intimacy}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_intimacy, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11550:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11550), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11550:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11560), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11560:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11560), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11560:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11561), {P0_AscendType, P0_ctime}) ->
    D_a_t_a = <<?_(P0_AscendType, '8'):8, ?_(P0_ctime, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11561:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11561), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11561:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(11562), {P0_break_out}) ->
    D_a_t_a = <<?_((length(P0_break_out)), "16"):16, (list_to_binary([<<?_(P1_id_type, '32'):32, ?_(P1_num, '8'):8>> || {P1_id_type, P1_num} <- P0_break_out]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11562:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(11562), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 11562:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 11500, _B0) ->
    {ok, {}};
unpack(cli, 11500, _B0) ->
    {P0_skill_all, _B3} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_id, _B2}
    end),
    {ok, {P0_skill_all}};

unpack(srv, 11501, _B0) ->
    {P0_now_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_now_id}};
unpack(cli, 11501, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
