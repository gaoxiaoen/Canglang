%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_161).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("arena_career.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(16100), {P0_range_role}) ->
    D_a_t_a = <<?_((length(P0_range_role)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_sex, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_face, '16'):16, ?_(P1_fight_capacity, '32'):32, ?_(P1_career, '8'):8, ?_(P1_rank, '32'):32, ?_((length(P1_looks)), "16"):16, (list_to_binary([<<?_(P2_looks_type, '8'):8, ?_(P2_looks_id, '32'):32, ?_(P2_looks_value, '16'):16>> || {P2_looks_type, P2_looks_id, P2_looks_value} <- P1_looks]))/binary>> || #arena_career_role{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, sex = P1_sex, lev = P1_lev, face = P1_face, fight_capacity = P1_fight_capacity, career = P1_career, rank = P1_rank, looks = P1_looks} <- P0_range_role]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16100:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16100), {P0_force}) ->
    D_a_t_a = <<?_(P0_force, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16100:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16101), {P0_role_log}) ->
    D_a_t_a = <<?_((length(P0_role_log)), "16"):16, (list_to_binary([<<?_(P1_fight_rid, '32'):32, ?_((byte_size(P1_fight_srv_id)), "16"):16, ?_(P1_fight_srv_id, bin)/binary, ?_((byte_size(P1_fight_name)), "16"):16, ?_(P1_fight_name, bin)/binary, ?_(P1_result, '8'):8, ?_(P1_to_fight_rid, '32'):32, ?_((byte_size(P1_to_fight_srv_id)), "16"):16, ?_(P1_to_fight_srv_id, bin)/binary, ?_((byte_size(P1_to_fight_name)), "16"):16, ?_(P1_to_fight_name, bin)/binary, ?_(P1_up_or_down, '8'):8, ?_(P1_rank, '32'):32, ?_(P1_ctime, '32'):32>> || #arena_career_log{fight_rid = P1_fight_rid, fight_srv_id = P1_fight_srv_id, fight_name = P1_fight_name, result = P1_result, to_fight_rid = P1_to_fight_rid, to_fight_srv_id = P1_to_fight_srv_id, to_fight_name = P1_to_fight_name, up_or_down = P1_up_or_down, rank = P1_rank, ctime = P1_ctime} <- P0_role_log]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16101:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16101), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16101:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16102), {P0_fight_rid, P0_fight_srv_id, P0_fight_name, P0_to_fight_rid, P0_to_fight_srv_id, P0_to_fight_name}) ->
    D_a_t_a = <<?_(P0_fight_rid, '32'):32, ?_((byte_size(P0_fight_srv_id)), "16"):16, ?_(P0_fight_srv_id, bin)/binary, ?_((byte_size(P0_fight_name)), "16"):16, ?_(P0_fight_name, bin)/binary, ?_(P0_to_fight_rid, '32'):32, ?_((byte_size(P0_to_fight_srv_id)), "16"):16, ?_(P0_to_fight_srv_id, bin)/binary, ?_((byte_size(P0_to_fight_name)), "16"):16, ?_(P0_to_fight_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16102:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16102), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16102:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16103), {P0_count, P0_cd, P0_demon, P0_rank, P0_win_cnt, P0_has_award, P0_stone, P0_coin, P0_time, P0_award_rank, P0_buy_count}) ->
    D_a_t_a = <<?_(P0_count, '8'):8, ?_(P0_cd, '32'):32, ?_(P0_demon, '8'):8, ?_(P0_rank, '32'):32, ?_(P0_win_cnt, '16'):16, ?_(P0_has_award, '8'):8, ?_(P0_stone, '16'):16, ?_(P0_coin, '32'):32, ?_(P0_time, '32'):32, ?_(P0_award_rank, '16'):16, ?_(P0_buy_count, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16103:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16103), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16103:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16104), {P0_count}) ->
    D_a_t_a = <<?_(P0_count, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16104:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16104), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16104:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16105), {P0_cd}) ->
    D_a_t_a = <<?_(P0_cd, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16105:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16105), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16105:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16106), {P0_flag, P0_range_role}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((length(P0_range_role)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_sex, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_fight_capacity, '32'):32, ?_(P1_career, '8'):8, ?_(P1_rank, '32'):32>> || #arena_career_role{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, sex = P1_sex, lev = P1_lev, fight_capacity = P1_fight_capacity, career = P1_career, rank = P1_rank} <- P0_range_role]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16106:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16106), {P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16106:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16107), {P0_hero}) ->
    D_a_t_a = <<?_((length(P0_hero)), "16"):16, (list_to_binary([<<?_(P1_rank, '32'):32, ?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '8'):8, ?_(P1_fight_capacity, '32'):32, ?_(P1_career, '8'):8, ?_(P1_trend, '8'):8>> || {P1_rank, P1_rid, P1_srv_id, P1_name, P1_lev, P1_fight_capacity, P1_career, P1_trend} <- P0_hero]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16107:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16107), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16107:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16108), {P0_stone, P0_coin, P0_time}) ->
    D_a_t_a = <<?_(P0_stone, '16'):16, ?_(P0_coin, '32'):32, ?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16108:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16108), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16108:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16109), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16109:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16109), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16109:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16110), {P0_range_role}) ->
    D_a_t_a = <<?_((length(P0_range_role)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_sex, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_fight_capacity, '32'):32, ?_(P1_career, '8'):8, ?_(P1_rank, '32'):32, ?_((length(P1_looks)), "16"):16, (list_to_binary([<<?_(P2_looks_type, '8'):8, ?_(P2_looks_id, '32'):32, ?_(P2_looks_value, '16'):16>> || {P2_looks_type, P2_looks_id, P2_looks_value} <- P1_looks]))/binary>> || #c_arena_career_role{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, sex = P1_sex, lev = P1_lev, fight_capacity = P1_fight_capacity, career = P1_career, rank = P1_rank, looks = P1_looks} <- P0_range_role]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16110:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16110), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16110:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16111), {P0_role_log}) ->
    D_a_t_a = <<?_((length(P0_role_log)), "16"):16, (list_to_binary([<<?_(P1_fight_rid, '32'):32, ?_((byte_size(P1_fight_srv_id)), "16"):16, ?_(P1_fight_srv_id, bin)/binary, ?_((byte_size(P1_fight_name)), "16"):16, ?_(P1_fight_name, bin)/binary, ?_(P1_result, '8'):8, ?_(P1_to_fight_rid, '32'):32, ?_((byte_size(P1_to_fight_srv_id)), "16"):16, ?_(P1_to_fight_srv_id, bin)/binary, ?_((byte_size(P1_to_fight_name)), "16"):16, ?_(P1_to_fight_name, bin)/binary, ?_(P1_up_or_down, '8'):8, ?_(P1_rank, '32'):32, ?_(P1_ctime, '32'):32>> || #arena_career_log{fight_rid = P1_fight_rid, fight_srv_id = P1_fight_srv_id, fight_name = P1_fight_name, result = P1_result, to_fight_rid = P1_to_fight_rid, to_fight_srv_id = P1_to_fight_srv_id, to_fight_name = P1_to_fight_name, up_or_down = P1_up_or_down, rank = P1_rank, ctime = P1_ctime} <- P0_role_log]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16111:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16111), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16111:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16112), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16112:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16112), {P0_rid, P0_srv_id, P0_career}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_career, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16112:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16113), {P0_fight_rid, P0_fight_srv_id, P0_fight_name, P0_to_fight_rid, P0_to_fight_srv_id, P0_to_fight_name}) ->
    D_a_t_a = <<?_(P0_fight_rid, '32'):32, ?_((byte_size(P0_fight_srv_id)), "16"):16, ?_(P0_fight_srv_id, bin)/binary, ?_((byte_size(P0_fight_name)), "16"):16, ?_(P0_fight_name, bin)/binary, ?_(P0_to_fight_rid, '32'):32, ?_((byte_size(P0_to_fight_srv_id)), "16"):16, ?_(P0_to_fight_srv_id, bin)/binary, ?_((byte_size(P0_to_fight_name)), "16"):16, ?_(P0_to_fight_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16113:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16113), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16113:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16114), {P0_flag, P0_rank, P0_lev, P0_count, P0_cd, P0_day}) ->
    D_a_t_a = <<?_(P0_flag, '32'):32, ?_(P0_rank, '32'):32, ?_(P0_lev, '8'):8, ?_(P0_count, '32'):32, ?_(P0_cd, '32'):32, ?_(P0_day, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16114:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16114), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16114:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16115), {P0_hero}) ->
    D_a_t_a = <<?_((length(P0_hero)), "16"):16, (list_to_binary([<<?_(P1_rank, '32'):32, ?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '8'):8, ?_(P1_fight_capacity, '32'):32, ?_(P1_career, '8'):8>> || {P1_rank, P1_rid, P1_srv_id, P1_name, P1_lev, P1_fight_capacity, P1_career} <- P0_hero]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16115:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16115), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16115:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16116), {P0_flag}) ->
    D_a_t_a = <<?_(P0_flag, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16116:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16116), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16116:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16117), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16117:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16117), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16117:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16118), {P0_hero}) ->
    D_a_t_a = <<?_((length(P0_hero)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_rank, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_win_cnt, '32'):32, ?_(P1_career, '8'):8>> || {P1_rid, P1_srv_id, P1_name, P1_rank, P1_lev, P1_win_cnt, P1_career} <- P0_hero]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16118:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16118), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16118:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16119), {P0_rid, P0_srv_id, P0_name, P0_sex, P0_lev, P0_face, P0_fight_capacity, P0_career, P0_rank, P0_looks}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_sex, '8'):8, ?_(P0_lev, '8'):8, ?_(P0_face, '16'):16, ?_(P0_fight_capacity, '32'):32, ?_(P0_career, '8'):8, ?_(P0_rank, '32'):32, ?_((length(P0_looks)), "16"):16, (list_to_binary([<<?_(P1_looks_type, '8'):8, ?_(P1_looks_id, '32'):32, ?_(P1_looks_value, '16'):16>> || {P1_looks_type, P1_looks_id, P1_looks_value} <- P0_looks]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16119:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16119), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16119:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16121), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16121:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16121), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16121:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16122), {P0_count}) ->
    D_a_t_a = <<?_(P0_count, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16122:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16122), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16122:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 16100, _B0) ->
    {P0_force, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_force}};
unpack(cli, 16100, _B0) ->
    {P0_range_role, _B16} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_rid, _B2} = lib_proto:read_uint32(_B1),
        {P1_srv_id, _B3} = lib_proto:read_string(_B2),
        {P1_name, _B4} = lib_proto:read_string(_B3),
        {P1_sex, _B5} = lib_proto:read_uint8(_B4),
        {P1_lev, _B6} = lib_proto:read_uint8(_B5),
        {P1_face, _B7} = lib_proto:read_uint16(_B6),
        {P1_fight_capacity, _B8} = lib_proto:read_uint32(_B7),
        {P1_career, _B9} = lib_proto:read_uint8(_B8),
        {P1_rank, _B10} = lib_proto:read_uint32(_B9),
        {P1_looks, _B15} = lib_proto:read_array(_B10, fun(_B11) ->
            {P2_looks_type, _B12} = lib_proto:read_uint8(_B11),
            {P2_looks_id, _B13} = lib_proto:read_uint32(_B12),
            {P2_looks_value, _B14} = lib_proto:read_uint16(_B13),
            {[P2_looks_type, P2_looks_id, P2_looks_value], _B14}
        end),
        {[P1_rid, P1_srv_id, P1_name, P1_sex, P1_lev, P1_face, P1_fight_capacity, P1_career, P1_rank, P1_looks], _B15}
    end),
    {ok, {P0_range_role}};

unpack(srv, 16101, _B0) ->
    {ok, {}};
unpack(cli, 16101, _B0) ->
    {P0_role_log, _B12} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_fight_rid, _B2} = lib_proto:read_uint32(_B1),
        {P1_fight_srv_id, _B3} = lib_proto:read_string(_B2),
        {P1_fight_name, _B4} = lib_proto:read_string(_B3),
        {P1_result, _B5} = lib_proto:read_uint8(_B4),
        {P1_to_fight_rid, _B6} = lib_proto:read_uint32(_B5),
        {P1_to_fight_srv_id, _B7} = lib_proto:read_string(_B6),
        {P1_to_fight_name, _B8} = lib_proto:read_string(_B7),
        {P1_up_or_down, _B9} = lib_proto:read_uint8(_B8),
        {P1_rank, _B10} = lib_proto:read_uint32(_B9),
        {P1_ctime, _B11} = lib_proto:read_uint32(_B10),
        {[P1_fight_rid, P1_fight_srv_id, P1_fight_name, P1_result, P1_to_fight_rid, P1_to_fight_srv_id, P1_to_fight_name, P1_up_or_down, P1_rank, P1_ctime], _B11}
    end),
    {ok, {P0_role_log}};

unpack(srv, 16103, _B0) ->
    {ok, {}};
unpack(cli, 16103, _B0) ->
    {P0_count, _B1} = lib_proto:read_uint8(_B0),
    {P0_cd, _B2} = lib_proto:read_uint32(_B1),
    {P0_demon, _B3} = lib_proto:read_uint8(_B2),
    {P0_rank, _B4} = lib_proto:read_uint32(_B3),
    {P0_win_cnt, _B5} = lib_proto:read_uint16(_B4),
    {P0_has_award, _B6} = lib_proto:read_uint8(_B5),
    {P0_stone, _B7} = lib_proto:read_uint16(_B6),
    {P0_coin, _B8} = lib_proto:read_uint32(_B7),
    {P0_time, _B9} = lib_proto:read_uint32(_B8),
    {P0_award_rank, _B10} = lib_proto:read_uint16(_B9),
    {P0_buy_count, _B11} = lib_proto:read_uint8(_B10),
    {ok, {P0_count, P0_cd, P0_demon, P0_rank, P0_win_cnt, P0_has_award, P0_stone, P0_coin, P0_time, P0_award_rank, P0_buy_count}};

unpack(srv, 16104, _B0) ->
    {ok, {}};
unpack(cli, 16104, _B0) ->
    {P0_count, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_count}};

unpack(srv, 16105, _B0) ->
    {ok, {}};
unpack(cli, 16105, _B0) ->
    {P0_cd, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_cd}};

unpack(srv, 16106, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_rid, P0_srv_id}};
unpack(cli, 16106, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_range_role, _B11} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_rid, _B3} = lib_proto:read_uint32(_B2),
        {P1_srv_id, _B4} = lib_proto:read_string(_B3),
        {P1_name, _B5} = lib_proto:read_string(_B4),
        {P1_sex, _B6} = lib_proto:read_uint8(_B5),
        {P1_lev, _B7} = lib_proto:read_uint8(_B6),
        {P1_fight_capacity, _B8} = lib_proto:read_uint32(_B7),
        {P1_career, _B9} = lib_proto:read_uint8(_B8),
        {P1_rank, _B10} = lib_proto:read_uint32(_B9),
        {[P1_rid, P1_srv_id, P1_name, P1_sex, P1_lev, P1_fight_capacity, P1_career, P1_rank], _B10}
    end),
    {ok, {P0_flag, P0_range_role}};

unpack(srv, 16107, _B0) ->
    {ok, {}};
unpack(cli, 16107, _B0) ->
    {P0_hero, _B10} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_rank, _B2} = lib_proto:read_uint32(_B1),
        {P1_rid, _B3} = lib_proto:read_uint32(_B2),
        {P1_srv_id, _B4} = lib_proto:read_string(_B3),
        {P1_name, _B5} = lib_proto:read_string(_B4),
        {P1_lev, _B6} = lib_proto:read_uint8(_B5),
        {P1_fight_capacity, _B7} = lib_proto:read_uint32(_B6),
        {P1_career, _B8} = lib_proto:read_uint8(_B7),
        {P1_trend, _B9} = lib_proto:read_uint8(_B8),
        {[P1_rank, P1_rid, P1_srv_id, P1_name, P1_lev, P1_fight_capacity, P1_career, P1_trend], _B9}
    end),
    {ok, {P0_hero}};

unpack(srv, 16109, _B0) ->
    {ok, {}};
unpack(cli, 16109, _B0) ->
    {ok, {}};

unpack(srv, 16112, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_career, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_rid, P0_srv_id, P0_career}};
unpack(cli, 16112, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 16117, _B0) ->
    {ok, {}};
unpack(cli, 16117, _B0) ->
    {ok, {}};

unpack(srv, 16118, _B0) ->
    {ok, {}};
unpack(cli, 16118, _B0) ->
    {P0_hero, _B9} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_rid, _B2} = lib_proto:read_uint32(_B1),
        {P1_srv_id, _B3} = lib_proto:read_string(_B2),
        {P1_name, _B4} = lib_proto:read_string(_B3),
        {P1_rank, _B5} = lib_proto:read_uint32(_B4),
        {P1_lev, _B6} = lib_proto:read_uint8(_B5),
        {P1_win_cnt, _B7} = lib_proto:read_uint32(_B6),
        {P1_career, _B8} = lib_proto:read_uint8(_B7),
        {[P1_rid, P1_srv_id, P1_name, P1_rank, P1_lev, P1_win_cnt, P1_career], _B8}
    end),
    {ok, {P0_hero}};

unpack(srv, 16119, _B0) ->
    {ok, {}};
unpack(cli, 16119, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_name, _B3} = lib_proto:read_string(_B2),
    {P0_sex, _B4} = lib_proto:read_uint8(_B3),
    {P0_lev, _B5} = lib_proto:read_uint8(_B4),
    {P0_face, _B6} = lib_proto:read_uint16(_B5),
    {P0_fight_capacity, _B7} = lib_proto:read_uint32(_B6),
    {P0_career, _B8} = lib_proto:read_uint8(_B7),
    {P0_rank, _B9} = lib_proto:read_uint32(_B8),
    {P0_looks, _B14} = lib_proto:read_array(_B9, fun(_B10) ->
        {P1_looks_type, _B11} = lib_proto:read_uint8(_B10),
        {P1_looks_id, _B12} = lib_proto:read_uint32(_B11),
        {P1_looks_value, _B13} = lib_proto:read_uint16(_B12),
        {[P1_looks_type, P1_looks_id, P1_looks_value], _B13}
    end),
    {ok, {P0_rid, P0_srv_id, P0_name, P0_sex, P0_lev, P0_face, P0_fight_capacity, P0_career, P0_rank, P0_looks}};

unpack(srv, 16121, _B0) ->
    {ok, {}};
unpack(cli, 16121, _B0) ->
    {ok, {}};

unpack(srv, 16122, _B0) ->
    {ok, {}};
unpack(cli, 16122, _B0) ->
    {P0_count, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_count}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
