%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_107).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("combat.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(10700), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10700:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10700), {P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10700:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10701), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10701:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10701), {P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10701:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10702), {P0_rid, P0_srv_id, P0_name}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10702:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10702), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10702:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10703), {P0_name}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10703:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10703), {P0_rid, P0_srv_id, P0_name, P0_accept}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_accept, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10703:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10704), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10704:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10704), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10704:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10705), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10705:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10705), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10705:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10706), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10706:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10706), {P0_id, P0_side}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_side, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10706:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10707), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10707:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10707), {P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10707:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10708), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10708:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10708), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10708:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10710), {P0_round, P0_time, P0_combat_type, P0_enter_type, P0_is_observer, P0_fighter_list, P0_pet_list, P0_npc_list, P0_action_order_list}) ->
    D_a_t_a = <<?_(P0_round, '16'):16, ?_(P0_time, '8'):8, ?_(P0_combat_type, '8'):8, ?_(P0_enter_type, '8'):8, ?_(P0_is_observer, '8'):8, ?_((length(P0_fighter_list)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_(P1_group, '8'):8, ?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_hp, '32/signed'):32/signed, ?_(P1_mp, '32/signed'):32/signed, ?_(P1_hp_max, '32/signed'):32/signed, ?_(P1_mp_max, '32/signed'):32/signed, ?_(P1_is_die, '8'):8, ?_((length(P1_specials)), "16"):16, (list_to_binary([<<?_(P2_type, '8'):8, ?_(P2_val_int, '32'):32, ?_((byte_size(P2_val_str)), "16"):16, ?_(P2_val_str, bin)/binary>> || {P2_type, P2_val_int, P2_val_str} <- P1_specials]))/binary, ?_(P1_x, '16'):16, ?_(P1_y, '16'):16>> || #fighter_info{id = P1_id, group = P1_group, rid = P1_rid, srv_id = P1_srv_id, hp = P1_hp, mp = P1_mp, hp_max = P1_hp_max, mp_max = P1_mp_max, is_die = P1_is_die, specials = P1_specials, x = P1_x, y = P1_y} <- P0_fighter_list]))/binary, ?_((length(P0_pet_list)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_(P1_base_id, '32'):32, ?_(P1_fight_capacity, '32'):32, ?_(P1_hp, '32/signed'):32/signed, ?_(P1_mp, '32/signed'):32/signed, ?_(P1_hp_max, '32/signed'):32/signed, ?_(P1_mp_max, '32/signed'):32/signed, ?_(P1_is_die, '8'):8, ?_(P1_master_id, '8'):8>> || #fighter_info{id = P1_id, base_id = P1_base_id, fight_capacity = P1_fight_capacity, hp = P1_hp, mp = P1_mp, hp_max = P1_hp_max, mp_max = P1_mp_max, is_die = P1_is_die, master_id = P1_master_id} <- P0_pet_list]))/binary, ?_((length(P0_npc_list)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_(P1_group, '8'):8, ?_(P1_rid, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_hp, '32/signed'):32/signed, ?_(P1_mp, '32/signed'):32/signed, ?_(P1_hp_max, '32/signed'):32/signed, ?_(P1_mp_max, '32/signed'):32/signed, ?_(P1_is_die, '8'):8, ?_((length(P1_specials)), "16"):16, (list_to_binary([<<?_(P2_type, '8'):8, ?_(P2_val_int, '32'):32, ?_((byte_size(P2_val_str)), "16"):16, ?_(P2_val_str, bin)/binary>> || {P2_type, P2_val_int, P2_val_str} <- P1_specials]))/binary, ?_(P1_x, '16'):16, ?_(P1_y, '16'):16>> || #fighter_info{id = P1_id, group = P1_group, rid = P1_rid, base_id = P1_base_id, hp = P1_hp, mp = P1_mp, hp_max = P1_hp_max, mp_max = P1_mp_max, is_die = P1_is_die, specials = P1_specials, x = P1_x, y = P1_y} <- P0_npc_list]))/binary, ?_((length(P0_action_order_list)), "16"):16, (list_to_binary([<<?_(P1_fighter_id, '8'):8>> || P1_fighter_id <- P0_action_order_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10710:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10710), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10710:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10711), {P0_id, P0_val}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_(P0_val, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10711:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10711), {P0_val}) ->
    D_a_t_a = <<?_(P0_val, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10711:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10712), {P0_fighter_list, P0_pet_list, P0_npc_list}) ->
    D_a_t_a = <<?_((length(P0_fighter_list)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_(P1_group, '8'):8, ?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_hp, '32/signed'):32/signed, ?_(P1_mp, '32/signed'):32/signed, ?_(P1_hp_max, '32/signed'):32/signed, ?_(P1_mp_max, '32/signed'):32/signed, ?_(P1_is_die, '8'):8, ?_((length(P1_specials)), "16"):16, (list_to_binary([<<?_(P2_type, '8'):8, ?_(P2_val_int, '32'):32, ?_((byte_size(P2_val_str)), "16"):16, ?_(P2_val_str, bin)/binary>> || {P2_type, P2_val_int, P2_val_str} <- P1_specials]))/binary, ?_(P1_x, '16'):16, ?_(P1_y, '16'):16>> || #fighter_info{id = P1_id, group = P1_group, rid = P1_rid, srv_id = P1_srv_id, hp = P1_hp, mp = P1_mp, hp_max = P1_hp_max, mp_max = P1_mp_max, is_die = P1_is_die, specials = P1_specials, x = P1_x, y = P1_y} <- P0_fighter_list]))/binary, ?_((length(P0_pet_list)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_(P1_base_id, '32'):32, ?_(P1_fight_capacity, '32'):32, ?_(P1_hp, '32/signed'):32/signed, ?_(P1_mp, '32/signed'):32/signed, ?_(P1_hp_max, '32/signed'):32/signed, ?_(P1_mp_max, '32/signed'):32/signed, ?_(P1_is_die, '8'):8, ?_(P1_master_id, '8'):8>> || #fighter_info{id = P1_id, base_id = P1_base_id, fight_capacity = P1_fight_capacity, hp = P1_hp, mp = P1_mp, hp_max = P1_hp_max, mp_max = P1_mp_max, is_die = P1_is_die, master_id = P1_master_id} <- P0_pet_list]))/binary, ?_((length(P0_npc_list)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_(P1_group, '8'):8, ?_(P1_rid, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_hp, '32/signed'):32/signed, ?_(P1_mp, '32/signed'):32/signed, ?_(P1_hp_max, '32/signed'):32/signed, ?_(P1_mp_max, '32/signed'):32/signed, ?_(P1_is_die, '8'):8, ?_((length(P1_specials)), "16"):16, (list_to_binary([<<?_(P2_type, '8'):8, ?_(P2_val_int, '32'):32, ?_((byte_size(P2_val_str)), "16"):16, ?_(P2_val_str, bin)/binary>> || {P2_type, P2_val_int, P2_val_str} <- P1_specials]))/binary, ?_(P1_x, '16'):16, ?_(P1_y, '16'):16>> || #fighter_info{id = P1_id, group = P1_group, rid = P1_rid, base_id = P1_base_id, hp = P1_hp, mp = P1_mp, hp_max = P1_hp_max, mp_max = P1_mp_max, is_die = P1_is_die, specials = P1_specials, x = P1_x, y = P1_y} <- P0_npc_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10712:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10712), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10712:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10720), {P0_round, P0_actions, P0_buffs, P0_summons, P0_action_order_list}) ->
    D_a_t_a = <<?_(P0_round, '16'):16, ?_((length(P0_actions)), "16"):16, (list_to_binary([<<?_(P1_order, '8'):8, ?_(P1_sub_order, '8'):8, ?_(P1_action_type, '8'):8, ?_(P1_id, '8'):8, ?_(P1_skill_id, '32'):32, ?_(P1_is_hit, '8'):8, ?_(P1_is_crit, '8'):8, ?_(P1_hp, '32/signed'):32/signed, ?_(P1_hp_show_type, '8'):8, ?_(P1_mp, '32/signed'):32/signed, ?_(P1_mp_show_type, '8'):8, ?_(P1_attack_type, '8'):8, ?_(P1_target_id, '8'):8, ?_(P1_target_hp, '32/signed'):32/signed, ?_(P1_target_mp, '32/signed'):32/signed, ?_(P1_is_self_die, '8'):8, ?_(P1_is_target_die, '8'):8, ?_((byte_size(P1_talk)), "16"):16, ?_(P1_talk, bin)/binary, ?_((length(P1_show_passive_skills)), "16"):16, (list_to_binary([<<?_(P2_id, '8'):8, ?_(P2_skill_id, '32/signed'):32/signed, ?_(P2_type, '8'):8>> || {P2_id, P2_skill_id, P2_type} <- P1_show_passive_skills]))/binary>> || #skill_play{order = P1_order, sub_order = P1_sub_order, action_type = P1_action_type, id = P1_id, skill_id = P1_skill_id, is_hit = P1_is_hit, is_crit = P1_is_crit, hp = P1_hp, hp_show_type = P1_hp_show_type, mp = P1_mp, mp_show_type = P1_mp_show_type, attack_type = P1_attack_type, target_id = P1_target_id, target_hp = P1_target_hp, target_mp = P1_target_mp, is_self_die = P1_is_self_die, is_target_die = P1_is_target_die, talk = P1_talk, show_passive_skills = P1_show_passive_skills} <- P0_actions]))/binary, ?_((length(P0_buffs)), "16"):16, (list_to_binary([<<?_(P1_order, '8'):8, ?_(P1_sub_order, '8'):8, ?_(P1_buff_id, '32'):32, ?_(P1_duration, '8'):8, ?_(P1_is_hit, '8'):8, ?_(P1_target_id, '8'):8, ?_(P1_target_hp, '32/signed'):32/signed, ?_(P1_target_mp, '32/signed'):32/signed, ?_(P1_is_target_die, '8'):8>> || #buff_play{order = P1_order, sub_order = P1_sub_order, buff_id = P1_buff_id, duration = P1_duration, is_hit = P1_is_hit, target_id = P1_target_id, target_hp = P1_target_hp, target_mp = P1_target_mp, is_target_die = P1_is_target_die} <- P0_buffs]))/binary, ?_((length(P0_summons)), "16"):16, (list_to_binary([<<?_(P1_order, '8'):8, ?_(P1_sub_order, '8'):8, ?_(P1_summoner_id, '8'):8, ?_(P1_summons_id, '8'):8, ?_(P1_summons_base_id, '32'):32, ?_(P1_type, '8'):8, ?_(P1_hp, '32/signed'):32/signed, ?_(P1_mp, '32/signed'):32/signed, ?_(P1_hp_max, '32/signed'):32/signed, ?_(P1_mp_max, '32/signed'):32/signed, ?_(P1_x, '16'):16, ?_(P1_y, '16'):16>> || #summon_play{order = P1_order, sub_order = P1_sub_order, summoner_id = P1_summoner_id, summons_id = P1_summons_id, summons_base_id = P1_summons_base_id, type = P1_type, hp = P1_hp, mp = P1_mp, hp_max = P1_hp_max, mp_max = P1_mp_max, x = P1_x, y = P1_y} <- P0_summons]))/binary, ?_((length(P0_action_order_list)), "16"):16, (list_to_binary([<<?_(P1_fighter_id, '8'):8>> || P1_fighter_id <- P0_action_order_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10720:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10720), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10720:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10721), {P0_round, P0_time, P0_flag, P0_buffs, P0_summons, P0_action_order_list, P0_skill_cd, P0_special}) ->
    D_a_t_a = <<?_(P0_round, '16'):16, ?_(P0_time, '8'):8, ?_(P0_flag, '8'):8, ?_((length(P0_buffs)), "16"):16, (list_to_binary([<<?_(P1_order, '8'):8, ?_(P1_sub_order, '8'):8, ?_(P1_buff_id, '32'):32, ?_(P1_duration, '8'):8, ?_(P1_is_hit, '8'):8, ?_(P1_target_id, '8'):8, ?_(P1_target_hp, '32/signed'):32/signed, ?_(P1_target_mp, '32/signed'):32/signed, ?_(P1_is_target_die, '8'):8>> || #buff_play{order = P1_order, sub_order = P1_sub_order, buff_id = P1_buff_id, duration = P1_duration, is_hit = P1_is_hit, target_id = P1_target_id, target_hp = P1_target_hp, target_mp = P1_target_mp, is_target_die = P1_is_target_die} <- P0_buffs]))/binary, ?_((length(P0_summons)), "16"):16, (list_to_binary([<<?_(P1_summons_id, '8'):8, ?_(P1_summons_base_id, '32'):32, ?_(P1_group, '8'):8, ?_(P1_type, '8'):8, ?_(P1_hp, '32/signed'):32/signed, ?_(P1_mp, '32/signed'):32/signed, ?_(P1_hp_max, '32/signed'):32/signed, ?_(P1_mp_max, '32/signed'):32/signed, ?_(P1_x, '16'):16, ?_(P1_y, '16'):16>> || #summon_play{summons_id = P1_summons_id, summons_base_id = P1_summons_base_id, group = P1_group, type = P1_type, hp = P1_hp, mp = P1_mp, hp_max = P1_hp_max, mp_max = P1_mp_max, x = P1_x, y = P1_y} <- P0_summons]))/binary, ?_((length(P0_action_order_list)), "16"):16, (list_to_binary([<<?_(P1_fighter_id, '8'):8>> || P1_fighter_id <- P0_action_order_list]))/binary, ?_((length(P0_skill_cd)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_last_use, '8'):8>> || {P1_id, P1_last_use} <- P0_skill_cd]))/binary, ?_((length(P0_special)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_val, '32/signed'):32/signed>> || {P1_type, P1_val} <- P0_special]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10721:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10721), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10721:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10722), {P0_id, P0_skill_id}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_(P0_skill_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10722:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10722), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10722:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10728), {P0_result, P0_skill_id}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_skill_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10728:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10728), {P0_skill_id}) ->
    D_a_t_a = <<?_(P0_skill_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10728:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10729), {P0_val, P0_skill_id}) ->
    D_a_t_a = <<?_(P0_val, '8'):8, ?_(P0_skill_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10729:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10729), {P0_skill_id, P0_val}) ->
    D_a_t_a = <<?_(P0_skill_id, '32'):32, ?_(P0_val, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10729:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10730), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10730:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10730), {P0_skill, P0_target, P0_special}) ->
    D_a_t_a = <<?_(P0_skill, '32/signed'):32/signed, ?_(P0_target, '8'):8, ?_((length(P0_special)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_val, '32/signed'):32/signed>> || {P1_type, P1_val} <- P0_special]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10730:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10731), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10731:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10731), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10731:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10740), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10740:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10740), {P0_replay_id}) ->
    D_a_t_a = <<?_((byte_size(P0_replay_id)), "16"):16, ?_(P0_replay_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10740:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10790), {P0_result, P0_time, P0_team_gl}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_time, '32'):32, ?_((length(P0_team_gl)), "16"):16, (list_to_binary([<<?_(P1_fighter_id, '8'):8, ?_((length(P1_gain)), "16"):16, (list_to_binary([<<?_(P2_type, '8'):8, ?_(P2_item_id, '32/signed'):32/signed, ?_(P2_num, '32/signed'):32/signed, ?_(P2_flag, '8'):8>> || {P2_type, P2_item_id, P2_num, P2_flag} <- P1_gain]))/binary, ?_((length(P1_loss)), "16"):16, (list_to_binary([<<?_(P2_type, '8'):8, ?_(P2_item_id, '32/signed'):32/signed, ?_(P2_num, '32/signed'):32/signed, ?_(P2_flag, '8'):8>> || {P2_type, P2_item_id, P2_num, P2_flag} <- P1_loss]))/binary>> || {P1_fighter_id, P1_gain, P1_loss} <- P0_team_gl]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10790:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10790), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10790:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10791), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10791:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10791), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10791:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10792), {P0_map_id}) ->
    D_a_t_a = <<?_(P0_map_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10792:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10792), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10792:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 10700, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_rid, P0_srv_id}};
unpack(cli, 10700, _B0) ->
    {ok, {}};

unpack(srv, 10704, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 10704, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_result, P0_msg}};

unpack(srv, 10705, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 10705, _B0) ->
    {ok, {}};

unpack(srv, 10706, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_side, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_id, P0_side}};
unpack(cli, 10706, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_result, P0_msg}};

unpack(srv, 10707, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_rid, P0_srv_id}};
unpack(cli, 10707, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_result, P0_msg}};

unpack(srv, 10708, _B0) ->
    {ok, {}};
unpack(cli, 10708, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_result, P0_msg}};

unpack(srv, 10710, _B0) ->
    {ok, {}};
unpack(cli, 10710, _B0) ->
    {P0_round, _B1} = lib_proto:read_uint16(_B0),
    {P0_time, _B2} = lib_proto:read_uint8(_B1),
    {P0_combat_type, _B3} = lib_proto:read_uint8(_B2),
    {P0_enter_type, _B4} = lib_proto:read_uint8(_B3),
    {P0_is_observer, _B5} = lib_proto:read_uint8(_B4),
    {P0_fighter_list, _B23} = lib_proto:read_array(_B5, fun(_B6) ->
        {P1_id, _B7} = lib_proto:read_uint8(_B6),
        {P1_group, _B8} = lib_proto:read_uint8(_B7),
        {P1_rid, _B9} = lib_proto:read_uint32(_B8),
        {P1_srv_id, _B10} = lib_proto:read_string(_B9),
        {P1_hp, _B11} = lib_proto:read_int32(_B10),
        {P1_mp, _B12} = lib_proto:read_int32(_B11),
        {P1_hp_max, _B13} = lib_proto:read_int32(_B12),
        {P1_mp_max, _B14} = lib_proto:read_int32(_B13),
        {P1_is_die, _B15} = lib_proto:read_uint8(_B14),
        {P1_specials, _B20} = lib_proto:read_array(_B15, fun(_B16) ->
            {P2_type, _B17} = lib_proto:read_uint8(_B16),
            {P2_val_int, _B18} = lib_proto:read_uint32(_B17),
            {P2_val_str, _B19} = lib_proto:read_string(_B18),
            {[P2_type, P2_val_int, P2_val_str], _B19}
        end),
        {P1_x, _B21} = lib_proto:read_uint16(_B20),
        {P1_y, _B22} = lib_proto:read_uint16(_B21),
        {[P1_id, P1_group, P1_rid, P1_srv_id, P1_hp, P1_mp, P1_hp_max, P1_mp_max, P1_is_die, P1_specials, P1_x, P1_y], _B22}
    end),
    {P0_pet_list, _B34} = lib_proto:read_array(_B23, fun(_B24) ->
        {P1_id, _B25} = lib_proto:read_uint8(_B24),
        {P1_base_id, _B26} = lib_proto:read_uint32(_B25),
        {P1_fight_capacity, _B27} = lib_proto:read_uint32(_B26),
        {P1_hp, _B28} = lib_proto:read_int32(_B27),
        {P1_mp, _B29} = lib_proto:read_int32(_B28),
        {P1_hp_max, _B30} = lib_proto:read_int32(_B29),
        {P1_mp_max, _B31} = lib_proto:read_int32(_B30),
        {P1_is_die, _B32} = lib_proto:read_uint8(_B31),
        {P1_master_id, _B33} = lib_proto:read_uint8(_B32),
        {[P1_id, P1_base_id, P1_fight_capacity, P1_hp, P1_mp, P1_hp_max, P1_mp_max, P1_is_die, P1_master_id], _B33}
    end),
    {P0_npc_list, _B52} = lib_proto:read_array(_B34, fun(_B35) ->
        {P1_id, _B36} = lib_proto:read_uint8(_B35),
        {P1_group, _B37} = lib_proto:read_uint8(_B36),
        {P1_rid, _B38} = lib_proto:read_uint32(_B37),
        {P1_base_id, _B39} = lib_proto:read_uint32(_B38),
        {P1_hp, _B40} = lib_proto:read_int32(_B39),
        {P1_mp, _B41} = lib_proto:read_int32(_B40),
        {P1_hp_max, _B42} = lib_proto:read_int32(_B41),
        {P1_mp_max, _B43} = lib_proto:read_int32(_B42),
        {P1_is_die, _B44} = lib_proto:read_uint8(_B43),
        {P1_specials, _B49} = lib_proto:read_array(_B44, fun(_B45) ->
            {P2_type, _B46} = lib_proto:read_uint8(_B45),
            {P2_val_int, _B47} = lib_proto:read_uint32(_B46),
            {P2_val_str, _B48} = lib_proto:read_string(_B47),
            {[P2_type, P2_val_int, P2_val_str], _B48}
        end),
        {P1_x, _B50} = lib_proto:read_uint16(_B49),
        {P1_y, _B51} = lib_proto:read_uint16(_B50),
        {[P1_id, P1_group, P1_rid, P1_base_id, P1_hp, P1_mp, P1_hp_max, P1_mp_max, P1_is_die, P1_specials, P1_x, P1_y], _B51}
    end),
    {P0_action_order_list, _B55} = lib_proto:read_array(_B52, fun(_B53) ->
        {P1_fighter_id, _B54} = lib_proto:read_uint8(_B53),
        {P1_fighter_id, _B54}
    end),
    {ok, {P0_round, P0_time, P0_combat_type, P0_enter_type, P0_is_observer, P0_fighter_list, P0_pet_list, P0_npc_list, P0_action_order_list}};

unpack(srv, 10711, _B0) ->
    {P0_val, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_val}};
unpack(cli, 10711, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint8(_B0),
    {P0_val, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_id, P0_val}};

unpack(srv, 10712, _B0) ->
    {ok, {}};
unpack(cli, 10712, _B0) ->
    {P0_fighter_list, _B18} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint8(_B1),
        {P1_group, _B3} = lib_proto:read_uint8(_B2),
        {P1_rid, _B4} = lib_proto:read_uint32(_B3),
        {P1_srv_id, _B5} = lib_proto:read_string(_B4),
        {P1_hp, _B6} = lib_proto:read_int32(_B5),
        {P1_mp, _B7} = lib_proto:read_int32(_B6),
        {P1_hp_max, _B8} = lib_proto:read_int32(_B7),
        {P1_mp_max, _B9} = lib_proto:read_int32(_B8),
        {P1_is_die, _B10} = lib_proto:read_uint8(_B9),
        {P1_specials, _B15} = lib_proto:read_array(_B10, fun(_B11) ->
            {P2_type, _B12} = lib_proto:read_uint8(_B11),
            {P2_val_int, _B13} = lib_proto:read_uint32(_B12),
            {P2_val_str, _B14} = lib_proto:read_string(_B13),
            {[P2_type, P2_val_int, P2_val_str], _B14}
        end),
        {P1_x, _B16} = lib_proto:read_uint16(_B15),
        {P1_y, _B17} = lib_proto:read_uint16(_B16),
        {[P1_id, P1_group, P1_rid, P1_srv_id, P1_hp, P1_mp, P1_hp_max, P1_mp_max, P1_is_die, P1_specials, P1_x, P1_y], _B17}
    end),
    {P0_pet_list, _B29} = lib_proto:read_array(_B18, fun(_B19) ->
        {P1_id, _B20} = lib_proto:read_uint8(_B19),
        {P1_base_id, _B21} = lib_proto:read_uint32(_B20),
        {P1_fight_capacity, _B22} = lib_proto:read_uint32(_B21),
        {P1_hp, _B23} = lib_proto:read_int32(_B22),
        {P1_mp, _B24} = lib_proto:read_int32(_B23),
        {P1_hp_max, _B25} = lib_proto:read_int32(_B24),
        {P1_mp_max, _B26} = lib_proto:read_int32(_B25),
        {P1_is_die, _B27} = lib_proto:read_uint8(_B26),
        {P1_master_id, _B28} = lib_proto:read_uint8(_B27),
        {[P1_id, P1_base_id, P1_fight_capacity, P1_hp, P1_mp, P1_hp_max, P1_mp_max, P1_is_die, P1_master_id], _B28}
    end),
    {P0_npc_list, _B47} = lib_proto:read_array(_B29, fun(_B30) ->
        {P1_id, _B31} = lib_proto:read_uint8(_B30),
        {P1_group, _B32} = lib_proto:read_uint8(_B31),
        {P1_rid, _B33} = lib_proto:read_uint32(_B32),
        {P1_base_id, _B34} = lib_proto:read_uint32(_B33),
        {P1_hp, _B35} = lib_proto:read_int32(_B34),
        {P1_mp, _B36} = lib_proto:read_int32(_B35),
        {P1_hp_max, _B37} = lib_proto:read_int32(_B36),
        {P1_mp_max, _B38} = lib_proto:read_int32(_B37),
        {P1_is_die, _B39} = lib_proto:read_uint8(_B38),
        {P1_specials, _B44} = lib_proto:read_array(_B39, fun(_B40) ->
            {P2_type, _B41} = lib_proto:read_uint8(_B40),
            {P2_val_int, _B42} = lib_proto:read_uint32(_B41),
            {P2_val_str, _B43} = lib_proto:read_string(_B42),
            {[P2_type, P2_val_int, P2_val_str], _B43}
        end),
        {P1_x, _B45} = lib_proto:read_uint16(_B44),
        {P1_y, _B46} = lib_proto:read_uint16(_B45),
        {[P1_id, P1_group, P1_rid, P1_base_id, P1_hp, P1_mp, P1_hp_max, P1_mp_max, P1_is_die, P1_specials, P1_x, P1_y], _B46}
    end),
    {ok, {P0_fighter_list, P0_pet_list, P0_npc_list}};

unpack(srv, 10720, _B0) ->
    {ok, {}};
unpack(cli, 10720, _B0) ->
    {P0_round, _B1} = lib_proto:read_uint16(_B0),
    {P0_actions, _B26} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_order, _B3} = lib_proto:read_uint8(_B2),
        {P1_sub_order, _B4} = lib_proto:read_uint8(_B3),
        {P1_action_type, _B5} = lib_proto:read_uint8(_B4),
        {P1_id, _B6} = lib_proto:read_uint8(_B5),
        {P1_skill_id, _B7} = lib_proto:read_uint32(_B6),
        {P1_is_hit, _B8} = lib_proto:read_uint8(_B7),
        {P1_is_crit, _B9} = lib_proto:read_uint8(_B8),
        {P1_hp, _B10} = lib_proto:read_int32(_B9),
        {P1_hp_show_type, _B11} = lib_proto:read_uint8(_B10),
        {P1_mp, _B12} = lib_proto:read_int32(_B11),
        {P1_mp_show_type, _B13} = lib_proto:read_uint8(_B12),
        {P1_attack_type, _B14} = lib_proto:read_uint8(_B13),
        {P1_target_id, _B15} = lib_proto:read_uint8(_B14),
        {P1_target_hp, _B16} = lib_proto:read_int32(_B15),
        {P1_target_mp, _B17} = lib_proto:read_int32(_B16),
        {P1_is_self_die, _B18} = lib_proto:read_uint8(_B17),
        {P1_is_target_die, _B19} = lib_proto:read_uint8(_B18),
        {P1_talk, _B20} = lib_proto:read_string(_B19),
        {P1_show_passive_skills, _B25} = lib_proto:read_array(_B20, fun(_B21) ->
            {P2_id, _B22} = lib_proto:read_uint8(_B21),
            {P2_skill_id, _B23} = lib_proto:read_int32(_B22),
            {P2_type, _B24} = lib_proto:read_uint8(_B23),
            {[P2_id, P2_skill_id, P2_type], _B24}
        end),
        {[P1_order, P1_sub_order, P1_action_type, P1_id, P1_skill_id, P1_is_hit, P1_is_crit, P1_hp, P1_hp_show_type, P1_mp, P1_mp_show_type, P1_attack_type, P1_target_id, P1_target_hp, P1_target_mp, P1_is_self_die, P1_is_target_die, P1_talk, P1_show_passive_skills], _B25}
    end),
    {P0_buffs, _B37} = lib_proto:read_array(_B26, fun(_B27) ->
        {P1_order, _B28} = lib_proto:read_uint8(_B27),
        {P1_sub_order, _B29} = lib_proto:read_uint8(_B28),
        {P1_buff_id, _B30} = lib_proto:read_uint32(_B29),
        {P1_duration, _B31} = lib_proto:read_uint8(_B30),
        {P1_is_hit, _B32} = lib_proto:read_uint8(_B31),
        {P1_target_id, _B33} = lib_proto:read_uint8(_B32),
        {P1_target_hp, _B34} = lib_proto:read_int32(_B33),
        {P1_target_mp, _B35} = lib_proto:read_int32(_B34),
        {P1_is_target_die, _B36} = lib_proto:read_uint8(_B35),
        {[P1_order, P1_sub_order, P1_buff_id, P1_duration, P1_is_hit, P1_target_id, P1_target_hp, P1_target_mp, P1_is_target_die], _B36}
    end),
    {P0_summons, _B51} = lib_proto:read_array(_B37, fun(_B38) ->
        {P1_order, _B39} = lib_proto:read_uint8(_B38),
        {P1_sub_order, _B40} = lib_proto:read_uint8(_B39),
        {P1_summoner_id, _B41} = lib_proto:read_uint8(_B40),
        {P1_id, _B42} = lib_proto:read_uint8(_B41),
        {P1_base_id, _B43} = lib_proto:read_uint32(_B42),
        {P1_type, _B44} = lib_proto:read_uint8(_B43),
        {P1_hp, _B45} = lib_proto:read_int32(_B44),
        {P1_mp, _B46} = lib_proto:read_int32(_B45),
        {P1_hp_max, _B47} = lib_proto:read_int32(_B46),
        {P1_mp_max, _B48} = lib_proto:read_int32(_B47),
        {P1_x, _B49} = lib_proto:read_uint16(_B48),
        {P1_y, _B50} = lib_proto:read_uint16(_B49),
        {[P1_order, P1_sub_order, P1_summoner_id, P1_id, P1_base_id, P1_type, P1_hp, P1_mp, P1_hp_max, P1_mp_max, P1_x, P1_y], _B50}
    end),
    {P0_action_order_list, _B54} = lib_proto:read_array(_B51, fun(_B52) ->
        {P1_fighter_id, _B53} = lib_proto:read_uint8(_B52),
        {P1_fighter_id, _B53}
    end),
    {ok, {P0_round, P0_actions, P0_buffs, P0_summons, P0_action_order_list}};

unpack(srv, 10721, _B0) ->
    {ok, {}};
unpack(cli, 10721, _B0) ->
    {P0_round, _B1} = lib_proto:read_uint16(_B0),
    {P0_time, _B2} = lib_proto:read_uint8(_B1),
    {P0_flag, _B3} = lib_proto:read_uint8(_B2),
    {P0_buffs, _B14} = lib_proto:read_array(_B3, fun(_B4) ->
        {P1_order, _B5} = lib_proto:read_uint8(_B4),
        {P1_sub_order, _B6} = lib_proto:read_uint8(_B5),
        {P1_buff_id, _B7} = lib_proto:read_uint32(_B6),
        {P1_duration, _B8} = lib_proto:read_uint8(_B7),
        {P1_is_hit, _B9} = lib_proto:read_uint8(_B8),
        {P1_target_id, _B10} = lib_proto:read_uint8(_B9),
        {P1_target_hp, _B11} = lib_proto:read_int32(_B10),
        {P1_target_mp, _B12} = lib_proto:read_int32(_B11),
        {P1_is_target_die, _B13} = lib_proto:read_uint8(_B12),
        {[P1_order, P1_sub_order, P1_buff_id, P1_duration, P1_is_hit, P1_target_id, P1_target_hp, P1_target_mp, P1_is_target_die], _B13}
    end),
    {P0_summons, _B26} = lib_proto:read_array(_B14, fun(_B15) ->
        {P1_id, _B16} = lib_proto:read_uint8(_B15),
        {P1_base_id, _B17} = lib_proto:read_uint32(_B16),
        {P1_group, _B18} = lib_proto:read_uint8(_B17),
        {P1_type, _B19} = lib_proto:read_uint8(_B18),
        {P1_hp, _B20} = lib_proto:read_int32(_B19),
        {P1_mp, _B21} = lib_proto:read_int32(_B20),
        {P1_hp_max, _B22} = lib_proto:read_int32(_B21),
        {P1_mp_max, _B23} = lib_proto:read_int32(_B22),
        {P1_x, _B24} = lib_proto:read_uint16(_B23),
        {P1_y, _B25} = lib_proto:read_uint16(_B24),
        {[P1_id, P1_base_id, P1_group, P1_type, P1_hp, P1_mp, P1_hp_max, P1_mp_max, P1_x, P1_y], _B25}
    end),
    {P0_action_order_list, _B29} = lib_proto:read_array(_B26, fun(_B27) ->
        {P1_fighter_id, _B28} = lib_proto:read_uint8(_B27),
        {P1_fighter_id, _B28}
    end),
    {P0_skill_cd, _B33} = lib_proto:read_array(_B29, fun(_B30) ->
        {P1_id, _B31} = lib_proto:read_uint32(_B30),
        {P1_last_use, _B32} = lib_proto:read_uint8(_B31),
        {[P1_id, P1_last_use], _B32}
    end),
    {P0_special, _B37} = lib_proto:read_array(_B33, fun(_B34) ->
        {P1_type, _B35} = lib_proto:read_uint8(_B34),
        {P1_val, _B36} = lib_proto:read_int32(_B35),
        {[P1_type, P1_val], _B36}
    end),
    {ok, {P0_round, P0_time, P0_flag, P0_buffs, P0_summons, P0_action_order_list, P0_skill_cd, P0_special}};

unpack(srv, 10722, _B0) ->
    {ok, {}};
unpack(cli, 10722, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint8(_B0),
    {P0_skill_id, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_id, P0_skill_id}};

unpack(srv, 10728, _B0) ->
    {P0_skill_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_skill_id}};
unpack(cli, 10728, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_skill_id, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_result, P0_skill_id}};

unpack(srv, 10729, _B0) ->
    {P0_skill_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_val, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_skill_id, P0_val}};
unpack(cli, 10729, _B0) ->
    {P0_val, _B1} = lib_proto:read_uint8(_B0),
    {P0_skill_id, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_val, P0_skill_id}};

unpack(srv, 10730, _B0) ->
    {P0_skill, _B1} = lib_proto:read_int32(_B0),
    {P0_target, _B2} = lib_proto:read_uint8(_B1),
    {P0_special, _B6} = lib_proto:read_array(_B2, fun(_B3) ->
        {P1_type, _B4} = lib_proto:read_uint8(_B3),
        {P1_val, _B5} = lib_proto:read_int32(_B4),
        {[P1_type, P1_val], _B5}
    end),
    {ok, {P0_skill, P0_target, P0_special}};
unpack(cli, 10730, _B0) ->
    {ok, {}};

unpack(srv, 10731, _B0) ->
    {ok, {}};
unpack(cli, 10731, _B0) ->
    {ok, {}};

unpack(srv, 10740, _B0) ->
    {P0_replay_id, _B1} = lib_proto:read_string(_B0),
    {ok, {P0_replay_id}};
unpack(cli, 10740, _B0) ->
    {ok, {}};

unpack(srv, 10790, _B0) ->
    {ok, {}};
unpack(cli, 10790, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_time, _B2} = lib_proto:read_uint32(_B1),
    {P0_team_gl, _B17} = lib_proto:read_array(_B2, fun(_B3) ->
        {P1_fighter_id, _B4} = lib_proto:read_uint8(_B3),
        {P1_gain, _B10} = lib_proto:read_array(_B4, fun(_B5) ->
            {P2_type, _B6} = lib_proto:read_uint8(_B5),
            {P2_item_id, _B7} = lib_proto:read_int32(_B6),
            {P2_num, _B8} = lib_proto:read_int32(_B7),
            {P2_flag, _B9} = lib_proto:read_uint8(_B8),
            {[P2_type, P2_item_id, P2_num, P2_flag], _B9}
        end),
        {P1_loss, _B16} = lib_proto:read_array(_B10, fun(_B11) ->
            {P2_type, _B12} = lib_proto:read_uint8(_B11),
            {P2_item_id, _B13} = lib_proto:read_int32(_B12),
            {P2_num, _B14} = lib_proto:read_int32(_B13),
            {P2_flag, _B15} = lib_proto:read_uint8(_B14),
            {[P2_type, P2_item_id, P2_num, P2_flag], _B15}
        end),
        {[P1_fighter_id, P1_gain, P1_loss], _B16}
    end),
    {ok, {P0_result, P0_time, P0_team_gl}};

unpack(srv, 10791, _B0) ->
    {ok, {}};
unpack(cli, 10791, _B0) ->
    {ok, {}};

unpack(srv, 10792, _B0) ->
    {ok, {}};
unpack(cli, 10792, _B0) ->
    {P0_map_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_map_id}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
