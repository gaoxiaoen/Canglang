%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_173).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("top_fight.hrl").
-include("item.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(17300), {P0_type, P0_time}) ->
    D_a_t_a = <<?_(P0_type, '8/signed'):8/signed, ?_(P0_time, '32/signed'):32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17300:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17300), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17300:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17301), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17301:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17301), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17301:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17302), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17302:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17302), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17302:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17303), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17303:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17303), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17303:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17304), {P0_type, P0_role_list}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_((length(P0_role_list)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '32'):32, ?_(P1_career, '8'):8, ?_(P1_kill, '32'):32, ?_(P1_death, '32'):32, ?_(P1_score, '32'):32>> || {P1_role_id, P1_srv_id, P1_name, P1_lev, P1_career, P1_kill, P1_death, P1_score} <- P0_role_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17304:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17304), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17304:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17306), {P0_lev, P0_group}) ->
    D_a_t_a = <<?_(P0_lev, '32'):32, ?_(P0_group, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17306:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17306), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17306:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17307), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17307:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17307), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17307:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17308), {P0_role_id, P0_srv_id, P0_name, P0_group, P0_score, P0_kill}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_group, '8'):8, ?_(P0_score, '32'):32, ?_(P0_kill, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17308:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17308), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17308:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17309), {P0_rank_list}) ->
    D_a_t_a = <<?_((length(P0_rank_list)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_group, '8'):8, ?_(P1_score, '32'):32, ?_(P1_kill, '32'):32>> || {P1_role_id, P1_srv_id, P1_name, P1_group, P1_score, P1_kill} <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17309:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17309), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17309:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17310), {P0_death, P0_group, P0_mask, P0_role_id, P0_srv_id, P0_name, P0_lev}) ->
    D_a_t_a = <<?_(P0_death, '32'):32, ?_(P0_group, '8'):8, ?_(P0_mask, '8'):8, ?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_lev, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17310:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17310), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17310:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17311), {P0_type, P0_time}) ->
    D_a_t_a = <<?_(P0_type, '32'):32, ?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17311:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17311), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17311:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17312), {P0_role_id, P0_srv_id, P0_name, P0_status, P0_has_buff}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_status, '8'):8, ?_(P0_has_buff, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17312:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17312), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17312:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17313), {P0_role_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17313:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17313), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17313:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17315), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17315:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17315), {P0_role_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17315:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17316), {P0_group_list}) ->
    D_a_t_a = <<?_((length(P0_group_list)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_status, '8'):8, ?_(P1_has_buff, '8'):8>> || {P1_role_id, P1_srv_id, P1_name, P1_status, P1_has_buff} <- P0_group_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17316:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17316), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17316:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17317), {P0_dragon, P0_tiger}) ->
    D_a_t_a = <<?_(P0_dragon, '32'):32, ?_(P0_tiger, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17317:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17317), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17317:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17318), {P0_score, P0_kill}) ->
    D_a_t_a = <<?_(P0_score, '32'):32, ?_(P0_kill, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17318:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17318), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17318:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17319), {P0_position}) ->
    D_a_t_a = <<?_(P0_position, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17319:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17319), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17319:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17320), {P0_msg}) ->
    D_a_t_a = <<?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17320:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17320), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17320:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17321), {P0_msg}) ->
    D_a_t_a = <<?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17321:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17321), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17321:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17322), {P0_status, P0_win_low, P0_win_middle, P0_win_hight, P0_win_super, P0_win_angle, P0_win_god}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_((byte_size(P0_win_low)), "16"):16, ?_(P0_win_low, bin)/binary, ?_((byte_size(P0_win_middle)), "16"):16, ?_(P0_win_middle, bin)/binary, ?_((byte_size(P0_win_hight)), "16"):16, ?_(P0_win_hight, bin)/binary, ?_((byte_size(P0_win_super)), "16"):16, ?_(P0_win_super, bin)/binary, ?_((byte_size(P0_win_angle)), "16"):16, ?_(P0_win_angle, bin)/binary, ?_((byte_size(P0_win_god)), "16"):16, ?_(P0_win_god, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17322:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17322), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17322:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17323), {P0_msg}) ->
    D_a_t_a = <<?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17323:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17323), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17323:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17324), {P0_arena_lev, P0_arena_seq, P0_group}) ->
    D_a_t_a = <<?_(P0_arena_lev, '8'):8, ?_(P0_arena_seq, '32'):32, ?_(P0_group, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17324:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17324), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17324:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17325), {P0_arena_num, P0_arena_winner, P0_hero_list}) ->
    D_a_t_a = <<?_(P0_arena_num, '32'):32, ?_(P0_arena_winner, '8'):8, ?_((length(P0_hero_list)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_lev, '32'):32, ?_(P1_group_id, '8'):8, ?_(P1_kill, '32'):32, ?_(P1_death, '32'):32, ?_(P1_score, '32'):32, ?_(P1_fight_capacity, '32'):32, ?_(P1_pet_fight_capacity, '32'):32>> || #top_fight_hero{role_id = P1_role_id, srv_id = P1_srv_id, name = P1_name, career = P1_career, lev = P1_lev, group_id = P1_group_id, kill = P1_kill, death = P1_death, score = P1_score, fight_capacity = P1_fight_capacity, pet_fight_capacity = P1_pet_fight_capacity} <- P0_hero_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17325:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17325), {P0_arena_seq}) ->
    D_a_t_a = <<?_(P0_arena_seq, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17325:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17326), {P0_hero_list}) ->
    D_a_t_a = <<?_((length(P0_hero_list)), "16"):16, (list_to_binary([<<?_(P1_arena_seq, '32'):32, ?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_lev, '32'):32, ?_(P1_group_id, '8'):8, ?_(P1_kill, '32'):32, ?_(P1_death, '32'):32, ?_(P1_score, '32'):32, ?_(P1_fight_capacity, '32'):32, ?_(P1_pet_fight_capacity, '32'):32>> || #top_fight_hero{arena_seq = P1_arena_seq, role_id = P1_role_id, srv_id = P1_srv_id, name = P1_name, career = P1_career, lev = P1_lev, group_id = P1_group_id, kill = P1_kill, death = P1_death, score = P1_score, fight_capacity = P1_fight_capacity, pet_fight_capacity = P1_pet_fight_capacity} <- P0_hero_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17326:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17326), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17326:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17327), {P0_result, P0_msg, P0_role_id, P0_srv_id, P0_name, P0_career, P0_lev, P0_fight_capacity, P0_pet_fight_capacity, P0_vip, P0_sex, P0_looks, P0_items}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_career, '8'):8, ?_(P0_lev, '32'):32, ?_(P0_fight_capacity, '32'):32, ?_(P0_pet_fight_capacity, '32'):32, ?_(P0_vip, '32'):32, ?_(P0_sex, '32'):32, ?_((length(P0_looks)), "16"):16, (list_to_binary([<<?_(P1_looks_type, '8'):8, ?_(P1_looks_id, '32'):32, ?_(P1_looks_value, '16'):16>> || {P1_looks_type, P1_looks_id, P1_looks_value} <- P0_looks]))/binary, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_upgrade, '8'):8, ?_(P1_enchant, '8/signed'):8/signed, ?_(P1_enchant_fail, '8'):8, ?_(P1_pos, '16'):16, ?_(P1_durability, '32/signed'):32/signed, ?_(P1_craft, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary, ?_((length(P1_extra)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32, ?_((byte_size(P2_str)), "16"):16, ?_(P2_str, bin)/binary>> || {P2_type, P2_value, P2_str} <- P1_extra]))/binary>> || #item{id = P1_id, base_id = P1_base_id, bind = P1_bind, upgrade = P1_upgrade, enchant = P1_enchant, enchant_fail = P1_enchant_fail, pos = P1_pos, durability = P1_durability, craft = P1_craft, attr = P1_attr, max_base_attr = P1_max_base_attr, extra = P1_extra} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17327:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17327), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17327:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
