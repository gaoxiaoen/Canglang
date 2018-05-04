%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_133).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("arena.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(13300), {P0_time}) ->
    D_a_t_a = <<?_(P0_time, '32/signed'):32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13300:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13300), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13300:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13301), {P0_result, P0_msg_id}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_msg_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13301:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13301), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13301:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13302), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13302:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13302), {P0_mask}) ->
    D_a_t_a = <<?_(P0_mask, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13302:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13303), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13303:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13303), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13303:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13304), {P0_type, P0_role_list}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_((length(P0_role_list)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '32'):32, ?_(P1_career, '8'):8, ?_(P1_kill, '32'):32, ?_(P1_death, '32'):32, ?_(P1_score, '32'):32>> || {P1_role_id, P1_srv_id, P1_name, P1_lev, P1_career, P1_kill, P1_death, P1_score} <- P0_role_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13304:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13304), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13304:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13306), {P0_lev, P0_group}) ->
    D_a_t_a = <<?_(P0_lev, '32'):32, ?_(P0_group, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13306:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13306), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13306:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13307), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13307:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13307), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13307:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13308), {P0_role_id, P0_srv_id, P0_name, P0_group, P0_score, P0_kill}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_group, '8'):8, ?_(P0_score, '32'):32, ?_(P0_kill, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13308:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13308), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13308:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13309), {P0_rank_list}) ->
    D_a_t_a = <<?_((length(P0_rank_list)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_group, '8'):8, ?_(P1_score, '32'):32, ?_(P1_kill, '32'):32>> || {P1_role_id, P1_srv_id, P1_name, P1_group, P1_score, P1_kill} <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13309:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13309), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13309:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13310), {P0_death, P0_group, P0_mask, P0_role_id, P0_srv_id, P0_name, P0_lev}) ->
    D_a_t_a = <<?_(P0_death, '32'):32, ?_(P0_group, '8'):8, ?_(P0_mask, '8'):8, ?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_lev, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13310:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13310), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13310:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13311), {P0_type, P0_time}) ->
    D_a_t_a = <<?_(P0_type, '32'):32, ?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13311:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13311), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13311:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13312), {P0_role_id, P0_srv_id, P0_name, P0_status, P0_has_buff}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_status, '8'):8, ?_(P0_has_buff, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13312:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13312), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13312:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13313), {P0_role_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13313:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13313), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13313:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13315), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13315:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13315), {P0_role_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13315:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13316), {P0_group_list}) ->
    D_a_t_a = <<?_((length(P0_group_list)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_status, '8'):8, ?_(P1_has_buff, '8'):8>> || {P1_role_id, P1_srv_id, P1_name, P1_status, P1_has_buff} <- P0_group_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13316:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13316), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13316:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13317), {P0_dragon, P0_tiger}) ->
    D_a_t_a = <<?_(P0_dragon, '32'):32, ?_(P0_tiger, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13317:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13317), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13317:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13318), {P0_score, P0_kill}) ->
    D_a_t_a = <<?_(P0_score, '32'):32, ?_(P0_kill, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13318:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13318), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13318:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13319), {P0_position}) ->
    D_a_t_a = <<?_(P0_position, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13319:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13319), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13319:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13320), {P0_msg}) ->
    D_a_t_a = <<?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13320:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13320), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13320:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13321), {P0_msg}) ->
    D_a_t_a = <<?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13321:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13321), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13321:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13322), {P0_status, P0_win_low, P0_win_middle, P0_win_hight, P0_win_super, P0_win_angle, P0_win_god}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_((byte_size(P0_win_low)), "16"):16, ?_(P0_win_low, bin)/binary, ?_((byte_size(P0_win_middle)), "16"):16, ?_(P0_win_middle, bin)/binary, ?_((byte_size(P0_win_hight)), "16"):16, ?_(P0_win_hight, bin)/binary, ?_((byte_size(P0_win_super)), "16"):16, ?_(P0_win_super, bin)/binary, ?_((byte_size(P0_win_angle)), "16"):16, ?_(P0_win_angle, bin)/binary, ?_((byte_size(P0_win_god)), "16"):16, ?_(P0_win_god, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13322:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13322), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13322:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13323), {P0_msg}) ->
    D_a_t_a = <<?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13323:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13323), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13323:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13324), {P0_arena_lev, P0_arena_seq, P0_group}) ->
    D_a_t_a = <<?_(P0_arena_lev, '8'):8, ?_(P0_arena_seq, '32'):32, ?_(P0_group, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13324:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13324), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13324:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13325), {P0_arena_num, P0_arena_winner, P0_hero_list}) ->
    D_a_t_a = <<?_(P0_arena_num, '32'):32, ?_(P0_arena_winner, '8'):8, ?_((length(P0_hero_list)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_lev, '32'):32, ?_(P1_group_id, '8'):8, ?_(P1_kill, '32'):32, ?_(P1_death, '32'):32, ?_(P1_score, '32'):32>> || #arena_hero{role_id = P1_role_id, srv_id = P1_srv_id, name = P1_name, career = P1_career, lev = P1_lev, group_id = P1_group_id, kill = P1_kill, death = P1_death, score = P1_score} <- P0_hero_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13325:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13325), {P0_arena_lev, P0_arena_seq}) ->
    D_a_t_a = <<?_(P0_arena_lev, '32'):32, ?_(P0_arena_seq, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13325:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
