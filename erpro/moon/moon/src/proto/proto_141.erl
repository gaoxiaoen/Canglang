%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_141).
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

pack(srv, ?_CMD(14100), {P0_looks, P0_is_lock, P0_locked, P0_question1, P0_question2}) ->
    D_a_t_a = <<?_((length(P0_looks)), "16"):16, (list_to_binary([<<?_(P1_key, '8'):8, ?_(P1_value, '8'):8>> || {P1_key, P1_value} <- P0_looks]))/binary, ?_(P0_is_lock, '8'):8, ?_(P0_locked, '8'):8, ?_((byte_size(P0_question1)), "16"):16, ?_(P0_question1, bin)/binary, ?_((byte_size(P0_question2)), "16"):16, ?_(P0_question2, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14100:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14100), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14100:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14101), {P0_looks, P0_msg}) ->
    D_a_t_a = <<?_((length(P0_looks)), "16"):16, (list_to_binary([<<?_(P1_key, '8'):8, ?_(P1_value, '8'):8>> || {P1_key, P1_value} <- P0_looks]))/binary, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14101:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14101), {P0_looks}) ->
    D_a_t_a = <<?_((length(P0_looks)), "16"):16, (list_to_binary([<<?_(P1_key, '8'):8, ?_(P1_value, '8'):8>> || {P1_key, P1_value} <- P0_looks]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14101:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14105), {P0_ret, P0_msg, P0_question1, P0_question2}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_((byte_size(P0_question1)), "16"):16, ?_(P0_question1, bin)/binary, ?_((byte_size(P0_question2)), "16"):16, ?_(P0_question2, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14105:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14105), {P0_password, P0_question1, P0_question2, P0_answer1, P0_answer2}) ->
    D_a_t_a = <<?_((byte_size(P0_password)), "16"):16, ?_(P0_password, bin)/binary, ?_((byte_size(P0_question1)), "16"):16, ?_(P0_question1, bin)/binary, ?_((byte_size(P0_question2)), "16"):16, ?_(P0_question2, bin)/binary, ?_((byte_size(P0_answer1)), "16"):16, ?_(P0_answer1, bin)/binary, ?_((byte_size(P0_answer2)), "16"):16, ?_(P0_answer2, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14105:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14106), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14106:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14106), {P0_password, P0_answer1, P0_answer2}) ->
    D_a_t_a = <<?_((byte_size(P0_password)), "16"):16, ?_(P0_password, bin)/binary, ?_((byte_size(P0_answer1)), "16"):16, ?_(P0_answer1, bin)/binary, ?_((byte_size(P0_answer2)), "16"):16, ?_(P0_answer2, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14106:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14107), {P0_inform}) ->
    D_a_t_a = <<?_(P0_inform, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14107:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14107), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14107:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14108), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14108:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14108), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14108:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14109), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14109:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14109), {P0_password}) ->
    D_a_t_a = <<?_((byte_size(P0_password)), "16"):16, ?_(P0_password, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14109:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14110), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14110:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14110), {P0_old_pass, P0_new_pass}) ->
    D_a_t_a = <<?_((byte_size(P0_old_pass)), "16"):16, ?_(P0_old_pass, bin)/binary, ?_((byte_size(P0_new_pass)), "16"):16, ?_(P0_new_pass, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14110:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14111), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14111:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14111), {P0_answer1, P0_answer2, P0_new_pass}) ->
    D_a_t_a = <<?_((byte_size(P0_answer1)), "16"):16, ?_(P0_answer1, bin)/binary, ?_((byte_size(P0_answer2)), "16"):16, ?_(P0_answer2, bin)/binary, ?_((byte_size(P0_new_pass)), "16"):16, ?_(P0_new_pass, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14111:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14112), {P0_cfg}) ->
    D_a_t_a = <<?_((length(P0_cfg)), "16"):16, (list_to_binary([<<?_(P1_key, '8'):8, ?_(P1_value, '8'):8>> || {P1_key, P1_value} <- P0_cfg]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14112:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14112), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14112:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14113), {P0_LotCount, P0_PetCount, P0_StoreCount, P0_VipCount, P0_FosterCount, P0_AlReadyCount, P0_AllBossCount, P0_GuildExpSwitch, P0_GuildExpCount, P0_XXTaskCount, P0_SLTaskCount, P0_LevDunCount, P0_LevDunFinCount, P0_ArenaCareer, P0_moneyTreeCount, P0_activityAwardCount, P0_activityTotalAward, P0_SecretCount}) ->
    D_a_t_a = <<?_(P0_LotCount, '8'):8, ?_(P0_PetCount, '8'):8, ?_(P0_StoreCount, '8'):8, ?_(P0_VipCount, '8'):8, ?_(P0_FosterCount, '8'):8, ?_(P0_AlReadyCount, '8'):8, ?_(P0_AllBossCount, '8'):8, ?_(P0_GuildExpSwitch, '8'):8, ?_(P0_GuildExpCount, '32'):32, ?_(P0_XXTaskCount, '32'):32, ?_(P0_SLTaskCount, '8'):8, ?_(P0_LevDunCount, '8'):8, ?_(P0_LevDunFinCount, '8'):8, ?_(P0_ArenaCareer, '8'):8, ?_(P0_moneyTreeCount, '8'):8, ?_(P0_activityAwardCount, '8'):8, ?_(P0_activityTotalAward, '8'):8, ?_(P0_SecretCount, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14113:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14113), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14113:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14115), {P0_index_1, P0_index_2, P0_index_3, P0_index_4, P0_index_5, P0_index_6, P0_index_7, P0_index_8, P0_index_9, P0_index_10, P0_lock}) ->
    D_a_t_a = <<?_(P0_index_1, '32'):32, ?_(P0_index_2, '32'):32, ?_(P0_index_3, '32'):32, ?_(P0_index_4, '32'):32, ?_(P0_index_5, '32'):32, ?_(P0_index_6, '32'):32, ?_(P0_index_7, '32'):32, ?_(P0_index_8, '32'):32, ?_(P0_index_9, '32'):32, ?_(P0_index_10, '32'):32, ?_(P0_lock, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14115:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14115), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14115:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14116), {P0_result}) ->
    D_a_t_a = <<?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14116:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14116), {P0_index_1, P0_index_2, P0_index_3, P0_index_4, P0_index_5, P0_index_6, P0_index_7, P0_index_8, P0_index_9, P0_index_10, P0_lock}) ->
    D_a_t_a = <<?_(P0_index_1, '32'):32, ?_(P0_index_2, '32'):32, ?_(P0_index_3, '32'):32, ?_(P0_index_4, '32'):32, ?_(P0_index_5, '32'):32, ?_(P0_index_6, '32'):32, ?_(P0_index_7, '32'):32, ?_(P0_index_8, '32'):32, ?_(P0_index_9, '32'):32, ?_(P0_index_10, '32'):32, ?_(P0_lock, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14116:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14117), {P0_result, P0_msg, P0_status, P0_top, P0_exp, P0_next_top, P0_next_coin}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_status, '8'):8, ?_(P0_top, '32'):32, ?_(P0_exp, '32'):32, ?_(P0_next_top, '32'):32, ?_(P0_next_coin, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14117:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14117), {P0_opt}) ->
    D_a_t_a = <<?_(P0_opt, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14117:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14120), {P0_result}) ->
    D_a_t_a = <<?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14120:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14120), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14120:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14121), {P0_result}) ->
    D_a_t_a = <<?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14121:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14121), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14121:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 14100, _B0) ->
    {ok, {}};
unpack(cli, 14100, _B0) ->
    {P0_looks, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_key, _B2} = lib_proto:read_uint8(_B1),
        {P1_value, _B3} = lib_proto:read_uint8(_B2),
        {[P1_key, P1_value], _B3}
    end),
    {P0_is_lock, _B5} = lib_proto:read_uint8(_B4),
    {P0_locked, _B6} = lib_proto:read_uint8(_B5),
    {P0_question1, _B7} = lib_proto:read_string(_B6),
    {P0_question2, _B8} = lib_proto:read_string(_B7),
    {ok, {P0_looks, P0_is_lock, P0_locked, P0_question1, P0_question2}};

unpack(srv, 14101, _B0) ->
    {P0_looks, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_key, _B2} = lib_proto:read_uint8(_B1),
        {P1_value, _B3} = lib_proto:read_uint8(_B2),
        {[P1_key, P1_value], _B3}
    end),
    {ok, {P0_looks}};
unpack(cli, 14101, _B0) ->
    {P0_looks, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_key, _B2} = lib_proto:read_uint8(_B1),
        {P1_value, _B3} = lib_proto:read_uint8(_B2),
        {[P1_key, P1_value], _B3}
    end),
    {P0_msg, _B5} = lib_proto:read_string(_B4),
    {ok, {P0_looks, P0_msg}};

unpack(srv, 14105, _B0) ->
    {P0_password, _B1} = lib_proto:read_string(_B0),
    {P0_question1, _B2} = lib_proto:read_string(_B1),
    {P0_question2, _B3} = lib_proto:read_string(_B2),
    {P0_answer1, _B4} = lib_proto:read_string(_B3),
    {P0_answer2, _B5} = lib_proto:read_string(_B4),
    {ok, {P0_password, P0_question1, P0_question2, P0_answer1, P0_answer2}};
unpack(cli, 14105, _B0) ->
    {P0_ret, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {P0_question1, _B3} = lib_proto:read_string(_B2),
    {P0_question2, _B4} = lib_proto:read_string(_B3),
    {ok, {P0_ret, P0_msg, P0_question1, P0_question2}};

unpack(srv, 14106, _B0) ->
    {P0_password, _B1} = lib_proto:read_string(_B0),
    {P0_answer1, _B2} = lib_proto:read_string(_B1),
    {P0_answer2, _B3} = lib_proto:read_string(_B2),
    {ok, {P0_password, P0_answer1, P0_answer2}};
unpack(cli, 14106, _B0) ->
    {P0_ret, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_ret, P0_msg}};

unpack(srv, 14107, _B0) ->
    {ok, {}};
unpack(cli, 14107, _B0) ->
    {P0_inform, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_inform}};

unpack(srv, 14108, _B0) ->
    {ok, {}};
unpack(cli, 14108, _B0) ->
    {P0_ret, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_ret, P0_msg}};

unpack(srv, 14109, _B0) ->
    {P0_password, _B1} = lib_proto:read_string(_B0),
    {ok, {P0_password}};
unpack(cli, 14109, _B0) ->
    {P0_ret, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_ret, P0_msg}};

unpack(srv, 14110, _B0) ->
    {P0_old_pass, _B1} = lib_proto:read_string(_B0),
    {P0_new_pass, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_old_pass, P0_new_pass}};
unpack(cli, 14110, _B0) ->
    {P0_ret, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_ret, P0_msg}};

unpack(srv, 14111, _B0) ->
    {P0_answer1, _B1} = lib_proto:read_string(_B0),
    {P0_answer2, _B2} = lib_proto:read_string(_B1),
    {P0_new_pass, _B3} = lib_proto:read_string(_B2),
    {ok, {P0_answer1, P0_answer2, P0_new_pass}};
unpack(cli, 14111, _B0) ->
    {P0_ret, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_ret, P0_msg}};

unpack(srv, 14112, _B0) ->
    {ok, {}};
unpack(cli, 14112, _B0) ->
    {P0_cfg, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_key, _B2} = lib_proto:read_uint8(_B1),
        {P1_value, _B3} = lib_proto:read_uint8(_B2),
        {[P1_key, P1_value], _B3}
    end),
    {ok, {P0_cfg}};

unpack(srv, 14113, _B0) ->
    {ok, {}};
unpack(cli, 14113, _B0) ->
    {P0_LotCount, _B1} = lib_proto:read_uint8(_B0),
    {P0_PetCount, _B2} = lib_proto:read_uint8(_B1),
    {P0_StoreCount, _B3} = lib_proto:read_uint8(_B2),
    {P0_VipCount, _B4} = lib_proto:read_uint8(_B3),
    {P0_FosterCount, _B5} = lib_proto:read_uint8(_B4),
    {P0_AlReadyCount, _B6} = lib_proto:read_uint8(_B5),
    {P0_AllBossCount, _B7} = lib_proto:read_uint8(_B6),
    {P0_GuildExpSwitch, _B8} = lib_proto:read_uint8(_B7),
    {P0_GuildExpCount, _B9} = lib_proto:read_uint32(_B8),
    {P0_XXTaskCount, _B10} = lib_proto:read_uint32(_B9),
    {P0_SLTaskCount, _B11} = lib_proto:read_uint8(_B10),
    {P0_LevDunCount, _B12} = lib_proto:read_uint8(_B11),
    {P0_LevDunFinCount, _B13} = lib_proto:read_uint8(_B12),
    {P0_ArenaCareer, _B14} = lib_proto:read_uint8(_B13),
    {P0_moneyTreeCount, _B15} = lib_proto:read_uint8(_B14),
    {P0_activityAwardCount, _B16} = lib_proto:read_uint8(_B15),
    {P0_activityTotalAward, _B17} = lib_proto:read_uint8(_B16),
    {P0_SecretCount, _B18} = lib_proto:read_uint8(_B17),
    {ok, {P0_LotCount, P0_PetCount, P0_StoreCount, P0_VipCount, P0_FosterCount, P0_AlReadyCount, P0_AllBossCount, P0_GuildExpSwitch, P0_GuildExpCount, P0_XXTaskCount, P0_SLTaskCount, P0_LevDunCount, P0_LevDunFinCount, P0_ArenaCareer, P0_moneyTreeCount, P0_activityAwardCount, P0_activityTotalAward, P0_SecretCount}};

unpack(srv, 14115, _B0) ->
    {ok, {}};
unpack(cli, 14115, _B0) ->
    {P0_index_1, _B1} = lib_proto:read_uint32(_B0),
    {P0_index_2, _B2} = lib_proto:read_uint32(_B1),
    {P0_index_3, _B3} = lib_proto:read_uint32(_B2),
    {P0_index_4, _B4} = lib_proto:read_uint32(_B3),
    {P0_index_5, _B5} = lib_proto:read_uint32(_B4),
    {P0_index_6, _B6} = lib_proto:read_uint32(_B5),
    {P0_index_7, _B7} = lib_proto:read_uint32(_B6),
    {P0_index_8, _B8} = lib_proto:read_uint32(_B7),
    {P0_index_9, _B9} = lib_proto:read_uint32(_B8),
    {P0_index_10, _B10} = lib_proto:read_uint32(_B9),
    {P0_lock, _B11} = lib_proto:read_uint8(_B10),
    {ok, {P0_index_1, P0_index_2, P0_index_3, P0_index_4, P0_index_5, P0_index_6, P0_index_7, P0_index_8, P0_index_9, P0_index_10, P0_lock}};

unpack(srv, 14116, _B0) ->
    {P0_index_1, _B1} = lib_proto:read_uint32(_B0),
    {P0_index_2, _B2} = lib_proto:read_uint32(_B1),
    {P0_index_3, _B3} = lib_proto:read_uint32(_B2),
    {P0_index_4, _B4} = lib_proto:read_uint32(_B3),
    {P0_index_5, _B5} = lib_proto:read_uint32(_B4),
    {P0_index_6, _B6} = lib_proto:read_uint32(_B5),
    {P0_index_7, _B7} = lib_proto:read_uint32(_B6),
    {P0_index_8, _B8} = lib_proto:read_uint32(_B7),
    {P0_index_9, _B9} = lib_proto:read_uint32(_B8),
    {P0_index_10, _B10} = lib_proto:read_uint32(_B9),
    {P0_lock, _B11} = lib_proto:read_uint8(_B10),
    {ok, {P0_index_1, P0_index_2, P0_index_3, P0_index_4, P0_index_5, P0_index_6, P0_index_7, P0_index_8, P0_index_9, P0_index_10, P0_lock}};
unpack(cli, 14116, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_result}};

unpack(srv, 14117, _B0) ->
    {P0_opt, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_opt}};
unpack(cli, 14117, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {P0_status, _B3} = lib_proto:read_uint8(_B2),
    {P0_top, _B4} = lib_proto:read_uint32(_B3),
    {P0_exp, _B5} = lib_proto:read_uint32(_B4),
    {P0_next_top, _B6} = lib_proto:read_uint32(_B5),
    {P0_next_coin, _B7} = lib_proto:read_uint32(_B6),
    {ok, {P0_result, P0_msg, P0_status, P0_top, P0_exp, P0_next_top, P0_next_coin}};

unpack(srv, 14120, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_type}};
unpack(cli, 14120, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_result}};

unpack(srv, 14121, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_type}};
unpack(cli, 14121, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_result}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
