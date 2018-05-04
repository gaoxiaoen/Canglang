%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_198).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("combat.hrl").
-include("leisure.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(19800), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19800:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19800), {P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19800:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19801), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19801:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19801), {P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19801:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19802), {P0_rid, P0_srv_id, P0_name}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19802:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19802), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19802:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19803), {P0_name}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19803:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19803), {P0_rid, P0_srv_id, P0_name, P0_accept}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_accept, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19803:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19805), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19805:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19805), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19805:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19810), {P0_round, P0_combat_type, P0_enter_type, P0_is_observer, P0_fighter_list, P0_npc_list}) ->
    D_a_t_a = <<?_(P0_round, '16'):16, ?_(P0_combat_type, '8'):8, ?_(P0_enter_type, '8'):8, ?_(P0_is_observer, '8'):8, ?_((length(P0_fighter_list)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_(P1_group, '8'):8, ?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_sex, '8'):8, ?_(P1_career, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_hp, '32/signed'):32/signed, ?_(P1_mp, '32/signed'):32/signed, ?_(P1_hp_max, '32/signed'):32/signed, ?_(P1_mp_max, '32/signed'):32/signed, ?_(P1_is_die, '8'):8, ?_((length(P1_looks)), "16"):16, (list_to_binary([<<?_(P2_looks_type, '8'):8, ?_(P2_looks_id, '32'):32, ?_(P2_looks_value, '16'):16>> || {P2_looks_type, P2_looks_id, P2_looks_value} <- P1_looks]))/binary, ?_((length(P1_specials)), "16"):16, (list_to_binary([<<?_(P2_type, '8'):8, ?_(P2_val_int, '32'):32, ?_((byte_size(P2_val_str)), "16"):16, ?_(P2_val_str, bin)/binary>> || {P2_type, P2_val_int, P2_val_str} <- P1_specials]))/binary, ?_(P1_x, '16'):16, ?_(P1_y, '16'):16>> || #fighter_info{id = P1_id, group = P1_group, rid = P1_rid, srv_id = P1_srv_id, name = P1_name, sex = P1_sex, career = P1_career, lev = P1_lev, hp = P1_hp, mp = P1_mp, hp_max = P1_hp_max, mp_max = P1_mp_max, is_die = P1_is_die, looks = P1_looks, specials = P1_specials, x = P1_x, y = P1_y} <- P0_fighter_list]))/binary, ?_((length(P0_npc_list)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_(P1_group, '8'):8, ?_(P1_rid, '32'):32, ?_(P1_base_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '8'):8, ?_(P1_hp, '32/signed'):32/signed, ?_(P1_mp, '32/signed'):32/signed, ?_(P1_hp_max, '32/signed'):32/signed, ?_(P1_mp_max, '32/signed'):32/signed, ?_(P1_is_die, '8'):8, ?_((length(P1_looks)), "16"):16, (list_to_binary([<<?_(P2_looks_type, '8'):8, ?_(P2_looks_id, '32'):32, ?_(P2_looks_value, '16'):16>> || {P2_looks_type, P2_looks_id, P2_looks_value} <- P1_looks]))/binary, ?_((length(P1_specials)), "16"):16, (list_to_binary([<<?_(P2_type, '8'):8, ?_(P2_val_int, '32'):32, ?_((byte_size(P2_val_str)), "16"):16, ?_(P2_val_str, bin)/binary>> || {P2_type, P2_val_int, P2_val_str} <- P1_specials]))/binary, ?_(P1_x, '16'):16, ?_(P1_y, '16'):16>> || #fighter_info{id = P1_id, group = P1_group, rid = P1_rid, base_id = P1_base_id, name = P1_name, lev = P1_lev, hp = P1_hp, mp = P1_mp, hp_max = P1_hp_max, mp_max = P1_mp_max, is_die = P1_is_die, looks = P1_looks, specials = P1_specials, x = P1_x, y = P1_y} <- P0_npc_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19810:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19810), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19810:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19811), {P0_id, P0_val}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_(P0_val, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19811:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19811), {P0_val}) ->
    D_a_t_a = <<?_(P0_val, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19811:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19812), {P0_code}) ->
    D_a_t_a = <<?_(P0_code, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19812:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19812), {P0_auto}) ->
    D_a_t_a = <<?_(P0_auto, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19812:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19820), {P0_round, P0_role_action, P0_npc_action, P0_actions}) ->
    D_a_t_a = <<?_(P0_round, '16'):16, ?_(P0_role_action, '8'):8, ?_(P0_npc_action, '8'):8, ?_((length(P0_actions)), "16"):16, (list_to_binary([<<?_(P1_order, '8'):8, ?_(P1_sub_order, '8'):8, ?_(P1_action_type, '8'):8, ?_(P1_id, '8'):8, ?_(P1_skill_id, '32'):32, ?_(P1_is_hit, '8'):8, ?_(P1_is_crit, '8'):8, ?_(P1_hp, '32/signed'):32/signed, ?_(P1_hp_show_type, '8'):8, ?_(P1_mp, '32/signed'):32/signed, ?_(P1_mp_show_type, '8'):8, ?_(P1_power, '32/signed'):32/signed, ?_(P1_attack_type, '8'):8, ?_(P1_target_id, '8'):8, ?_(P1_target_hp, '32/signed'):32/signed, ?_(P1_target_mp, '32/signed'):32/signed, ?_(P1_is_self_die, '8'):8, ?_(P1_is_target_die, '8'):8, ?_((length(P1_show_passive_skills)), "16"):16, (list_to_binary([<<?_(P2_id, '8'):8, ?_(P2_skill_id, '32/signed'):32/signed, ?_(P2_type, '8'):8>> || {P2_id, P2_skill_id, P2_type} <- P1_show_passive_skills]))/binary>> || #skill_play{order = P1_order, sub_order = P1_sub_order, action_type = P1_action_type, id = P1_id, skill_id = P1_skill_id, is_hit = P1_is_hit, is_crit = P1_is_crit, hp = P1_hp, hp_show_type = P1_hp_show_type, mp = P1_mp, mp_show_type = P1_mp_show_type, power = P1_power, attack_type = P1_attack_type, target_id = P1_target_id, target_hp = P1_target_hp, target_mp = P1_target_mp, is_self_die = P1_is_self_die, is_target_die = P1_is_target_die, show_passive_skills = P1_show_passive_skills} <- P0_actions]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19820:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19820), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19820:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19821), {P0_round, P0_time, P0_flag, P0_role_energy, P0_npc_energy}) ->
    D_a_t_a = <<?_(P0_round, '16'):16, ?_(P0_time, '8'):8, ?_(P0_flag, '8'):8, ?_((length(P0_role_energy)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_power, '32/signed'):32/signed, ?_(P1_is_crit, '8'):8>> || #act{type = P1_type, power = P1_power, is_crit = P1_is_crit} <- P0_role_energy]))/binary, ?_((length(P0_npc_energy)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_power, '32/signed'):32/signed, ?_(P1_is_crit, '8'):8>> || #act{type = P1_type, power = P1_power, is_crit = P1_is_crit} <- P0_npc_energy]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19821:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19821), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19821:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19830), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19830:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19830), {P0_skill, P0_target}) ->
    D_a_t_a = <<?_(P0_skill, '32/signed'):32/signed, ?_(P0_target, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19830:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19831), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19831:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19831), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19831:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19890), {P0_result, P0_time, P0_team_gl}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_time, '32'):32, ?_((length(P0_team_gl)), "16"):16, (list_to_binary([<<?_(P1_fighter_id, '8'):8, ?_((length(P1_gain)), "16"):16, (list_to_binary([<<?_(P2_type, '8'):8, ?_(P2_item_id, '32/signed'):32/signed, ?_(P2_num, '32/signed'):32/signed, ?_(P2_flag, '8'):8>> || {P2_type, P2_item_id, P2_num, P2_flag} <- P1_gain]))/binary, ?_((length(P1_loss)), "16"):16, (list_to_binary([<<?_(P2_type, '8'):8, ?_(P2_item_id, '32/signed'):32/signed, ?_(P2_num, '32/signed'):32/signed, ?_(P2_flag, '8'):8>> || {P2_type, P2_item_id, P2_num, P2_flag} <- P1_loss]))/binary>> || {P1_fighter_id, P1_gain, P1_loss} <- P0_team_gl]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19890:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19890), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19890:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19891), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19891:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19891), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19891:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19892), {P0_map_id}) ->
    D_a_t_a = <<?_(P0_map_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19892:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19892), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19892:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(19893), {P0_result, P0_reach_goals, P0_star, P0_npc_hp, P0_npc_hp_goal, P0_role_hp, P0_role_hp_goal, P0_kill_npc, P0_kill_npc_goal, P0_coin, P0_exp, P0_stone, P0_attainment, P0_items}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_reach_goals, '8'):8, ?_(P0_star, '8'):8, ?_(P0_npc_hp, '8'):8, ?_(P0_npc_hp_goal, '8'):8, ?_(P0_role_hp, '8'):8, ?_(P0_role_hp_goal, '8'):8, ?_(P0_kill_npc, '8'):8, ?_(P0_kill_npc_goal, '8'):8, ?_(P0_coin, '32/signed'):32/signed, ?_(P0_exp, '32/signed'):32/signed, ?_(P0_stone, '32/signed'):32/signed, ?_(P0_attainment, '32/signed'):32/signed, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_quantity, '8'):8>> || {P1_base_id, P1_bind, P1_quantity} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19893:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(19893), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 19893:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 19800, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_rid, P0_srv_id}};
unpack(cli, 19800, _B0) ->
    {ok, {}};

unpack(srv, 19805, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 19805, _B0) ->
    {ok, {}};

unpack(srv, 19810, _B0) ->
    {ok, {}};
unpack(cli, 19810, _B0) ->
    {P0_round, _B1} = lib_proto:read_uint16(_B0),
    {P0_combat_type, _B2} = lib_proto:read_uint8(_B1),
    {P0_enter_type, _B3} = lib_proto:read_uint8(_B2),
    {P0_is_observer, _B4} = lib_proto:read_uint8(_B3),
    {P0_fighter_list, _B31} = lib_proto:read_array(_B4, fun(_B5) ->
        {P1_id, _B6} = lib_proto:read_uint8(_B5),
        {P1_group, _B7} = lib_proto:read_uint8(_B6),
        {P1_rid, _B8} = lib_proto:read_uint32(_B7),
        {P1_srv_id, _B9} = lib_proto:read_string(_B8),
        {P1_name, _B10} = lib_proto:read_string(_B9),
        {P1_sex, _B11} = lib_proto:read_uint8(_B10),
        {P1_career, _B12} = lib_proto:read_uint8(_B11),
        {P1_lev, _B13} = lib_proto:read_uint8(_B12),
        {P1_hp, _B14} = lib_proto:read_int32(_B13),
        {P1_mp, _B15} = lib_proto:read_int32(_B14),
        {P1_hp_max, _B16} = lib_proto:read_int32(_B15),
        {P1_mp_max, _B17} = lib_proto:read_int32(_B16),
        {P1_is_die, _B18} = lib_proto:read_uint8(_B17),
        {P1_looks, _B23} = lib_proto:read_array(_B18, fun(_B19) ->
            {P2_looks_type, _B20} = lib_proto:read_uint8(_B19),
            {P2_looks_id, _B21} = lib_proto:read_uint32(_B20),
            {P2_looks_value, _B22} = lib_proto:read_uint16(_B21),
            {[P2_looks_type, P2_looks_id, P2_looks_value], _B22}
        end),
        {P1_specials, _B28} = lib_proto:read_array(_B23, fun(_B24) ->
            {P2_type, _B25} = lib_proto:read_uint8(_B24),
            {P2_val_int, _B26} = lib_proto:read_uint32(_B25),
            {P2_val_str, _B27} = lib_proto:read_string(_B26),
            {[P2_type, P2_val_int, P2_val_str], _B27}
        end),
        {P1_x, _B29} = lib_proto:read_uint16(_B28),
        {P1_y, _B30} = lib_proto:read_uint16(_B29),
        {[P1_id, P1_group, P1_rid, P1_srv_id, P1_name, P1_sex, P1_career, P1_lev, P1_hp, P1_mp, P1_hp_max, P1_mp_max, P1_is_die, P1_looks, P1_specials, P1_x, P1_y], _B30}
    end),
    {P0_npc_list, _B56} = lib_proto:read_array(_B31, fun(_B32) ->
        {P1_id, _B33} = lib_proto:read_uint8(_B32),
        {P1_group, _B34} = lib_proto:read_uint8(_B33),
        {P1_rid, _B35} = lib_proto:read_uint32(_B34),
        {P1_base_id, _B36} = lib_proto:read_uint32(_B35),
        {P1_name, _B37} = lib_proto:read_string(_B36),
        {P1_lev, _B38} = lib_proto:read_uint8(_B37),
        {P1_hp, _B39} = lib_proto:read_int32(_B38),
        {P1_mp, _B40} = lib_proto:read_int32(_B39),
        {P1_hp_max, _B41} = lib_proto:read_int32(_B40),
        {P1_mp_max, _B42} = lib_proto:read_int32(_B41),
        {P1_is_die, _B43} = lib_proto:read_uint8(_B42),
        {P1_looks, _B48} = lib_proto:read_array(_B43, fun(_B44) ->
            {P2_looks_type, _B45} = lib_proto:read_uint8(_B44),
            {P2_looks_id, _B46} = lib_proto:read_uint32(_B45),
            {P2_looks_value, _B47} = lib_proto:read_uint16(_B46),
            {[P2_looks_type, P2_looks_id, P2_looks_value], _B47}
        end),
        {P1_specials, _B53} = lib_proto:read_array(_B48, fun(_B49) ->
            {P2_type, _B50} = lib_proto:read_uint8(_B49),
            {P2_val_int, _B51} = lib_proto:read_uint32(_B50),
            {P2_val_str, _B52} = lib_proto:read_string(_B51),
            {[P2_type, P2_val_int, P2_val_str], _B52}
        end),
        {P1_x, _B54} = lib_proto:read_uint16(_B53),
        {P1_y, _B55} = lib_proto:read_uint16(_B54),
        {[P1_id, P1_group, P1_rid, P1_base_id, P1_name, P1_lev, P1_hp, P1_mp, P1_hp_max, P1_mp_max, P1_is_die, P1_looks, P1_specials, P1_x, P1_y], _B55}
    end),
    {ok, {P0_round, P0_combat_type, P0_enter_type, P0_is_observer, P0_fighter_list, P0_npc_list}};

unpack(srv, 19811, _B0) ->
    {P0_val, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_val}};
unpack(cli, 19811, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint8(_B0),
    {P0_val, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_id, P0_val}};

unpack(srv, 19812, _B0) ->
    {P0_auto, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_auto}};
unpack(cli, 19812, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_code}};

unpack(srv, 19820, _B0) ->
    {ok, {}};
unpack(cli, 19820, _B0) ->
    {P0_round, _B1} = lib_proto:read_uint16(_B0),
    {P0_role_action, _B2} = lib_proto:read_uint8(_B1),
    {P0_npc_action, _B3} = lib_proto:read_uint8(_B2),
    {P0_actions, _B28} = lib_proto:read_array(_B3, fun(_B4) ->
        {P1_order, _B5} = lib_proto:read_uint8(_B4),
        {P1_sub_order, _B6} = lib_proto:read_uint8(_B5),
        {P1_action_type, _B7} = lib_proto:read_uint8(_B6),
        {P1_id, _B8} = lib_proto:read_uint8(_B7),
        {P1_skill_id, _B9} = lib_proto:read_uint32(_B8),
        {P1_is_hit, _B10} = lib_proto:read_uint8(_B9),
        {P1_is_crit, _B11} = lib_proto:read_uint8(_B10),
        {P1_hp, _B12} = lib_proto:read_int32(_B11),
        {P1_hp_show_type, _B13} = lib_proto:read_uint8(_B12),
        {P1_mp, _B14} = lib_proto:read_int32(_B13),
        {P1_mp_show_type, _B15} = lib_proto:read_uint8(_B14),
        {P1_power, _B16} = lib_proto:read_int32(_B15),
        {P1_attack_type, _B17} = lib_proto:read_uint8(_B16),
        {P1_target_id, _B18} = lib_proto:read_uint8(_B17),
        {P1_target_hp, _B19} = lib_proto:read_int32(_B18),
        {P1_target_mp, _B20} = lib_proto:read_int32(_B19),
        {P1_is_self_die, _B21} = lib_proto:read_uint8(_B20),
        {P1_is_target_die, _B22} = lib_proto:read_uint8(_B21),
        {P1_show_passive_skills, _B27} = lib_proto:read_array(_B22, fun(_B23) ->
            {P2_id, _B24} = lib_proto:read_uint8(_B23),
            {P2_skill_id, _B25} = lib_proto:read_int32(_B24),
            {P2_type, _B26} = lib_proto:read_uint8(_B25),
            {[P2_id, P2_skill_id, P2_type], _B26}
        end),
        {[P1_order, P1_sub_order, P1_action_type, P1_id, P1_skill_id, P1_is_hit, P1_is_crit, P1_hp, P1_hp_show_type, P1_mp, P1_mp_show_type, P1_power, P1_attack_type, P1_target_id, P1_target_hp, P1_target_mp, P1_is_self_die, P1_is_target_die, P1_show_passive_skills], _B27}
    end),
    {ok, {P0_round, P0_role_action, P0_npc_action, P0_actions}};

unpack(srv, 19821, _B0) ->
    {ok, {}};
unpack(cli, 19821, _B0) ->
    {P0_round, _B1} = lib_proto:read_uint16(_B0),
    {P0_time, _B2} = lib_proto:read_uint8(_B1),
    {P0_flag, _B3} = lib_proto:read_uint8(_B2),
    {P0_role_energy, _B8} = lib_proto:read_array(_B3, fun(_B4) ->
        {P1_type, _B5} = lib_proto:read_uint8(_B4),
        {P1_power, _B6} = lib_proto:read_int32(_B5),
        {P1_is_crit, _B7} = lib_proto:read_uint8(_B6),
        {[P1_type, P1_power, P1_is_crit], _B7}
    end),
    {P0_npc_energy, _B13} = lib_proto:read_array(_B8, fun(_B9) ->
        {P1_type, _B10} = lib_proto:read_uint8(_B9),
        {P1_power, _B11} = lib_proto:read_int32(_B10),
        {P1_is_crit, _B12} = lib_proto:read_uint8(_B11),
        {[P1_type, P1_power, P1_is_crit], _B12}
    end),
    {ok, {P0_round, P0_time, P0_flag, P0_role_energy, P0_npc_energy}};

unpack(srv, 19830, _B0) ->
    {P0_skill, _B1} = lib_proto:read_int32(_B0),
    {P0_target, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_skill, P0_target}};
unpack(cli, 19830, _B0) ->
    {ok, {}};

unpack(srv, 19831, _B0) ->
    {ok, {}};
unpack(cli, 19831, _B0) ->
    {ok, {}};

unpack(srv, 19890, _B0) ->
    {ok, {}};
unpack(cli, 19890, _B0) ->
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

unpack(srv, 19891, _B0) ->
    {ok, {}};
unpack(cli, 19891, _B0) ->
    {ok, {}};

unpack(srv, 19893, _B0) ->
    {ok, {}};
unpack(cli, 19893, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_reach_goals, _B2} = lib_proto:read_uint8(_B1),
    {P0_star, _B3} = lib_proto:read_uint8(_B2),
    {P0_npc_hp, _B4} = lib_proto:read_uint8(_B3),
    {P0_npc_hp_goal, _B5} = lib_proto:read_uint8(_B4),
    {P0_role_hp, _B6} = lib_proto:read_uint8(_B5),
    {P0_role_hp_goal, _B7} = lib_proto:read_uint8(_B6),
    {P0_kill_npc, _B8} = lib_proto:read_uint8(_B7),
    {P0_kill_npc_goal, _B9} = lib_proto:read_uint8(_B8),
    {P0_coin, _B10} = lib_proto:read_int32(_B9),
    {P0_exp, _B11} = lib_proto:read_int32(_B10),
    {P0_stone, _B12} = lib_proto:read_int32(_B11),
    {P0_attainment, _B13} = lib_proto:read_int32(_B12),
    {P0_items, _B18} = lib_proto:read_array(_B13, fun(_B14) ->
        {P1_base_id, _B15} = lib_proto:read_uint32(_B14),
        {P1_bind, _B16} = lib_proto:read_uint8(_B15),
        {P1_quantity, _B17} = lib_proto:read_uint8(_B16),
        {[P1_base_id, P1_bind, P1_quantity], _B17}
    end),
    {ok, {P0_result, P0_reach_goals, P0_star, P0_npc_hp, P0_npc_hp_goal, P0_role_hp, P0_role_hp_goal, P0_kill_npc, P0_kill_npc_goal, P0_coin, P0_exp, P0_stone, P0_attainment, P0_items}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
