%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_172).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("demon.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(17200), {P0_active, P0_step, P0_exp, P0_exp_need, P0_bag}) ->
    D_a_t_a = <<?_(P0_active, '8'):8, ?_(P0_step, '8'):8, ?_(P0_exp, '32'):32, ?_(P0_exp_need, '32'):32, ?_((length(P0_bag)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_craft, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_a_type, '8'):8, ?_(P2_a_craft, '8'):8, ?_(P2_val, '32'):32, ?_(P2_lock, '8'):8>> || {P2_a_type, P2_a_craft, P2_val, P2_lock} <- P1_attr]))/binary, ?_((length(P1_skills)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_(P2_step, '8'):8, ?_(P2_exp, '16'):16>> || {P2_id, P2_step, P2_exp} <- P1_skills]))/binary, ?_(P1_intimacy, '32'):32, ?_(P1_shape_lev, '16'):16, ?_(P1_shape_luck, '32'):32>> || #demon{id = P1_id, name = P1_name, craft = P1_craft, attr = P1_attr, skills = P1_skills, intimacy = P1_intimacy, shape_lev = P1_shape_lev, shape_luck = P1_shape_luck} <- P0_bag]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17200:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17200), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17200:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17201), {P0_id, P0_name, P0_craft, P0_attr, P0_skills, P0_intimacy, P0_shape_lev, P0_shape_luck}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_craft, '8'):8, ?_((length(P0_attr)), "16"):16, (list_to_binary([<<?_(P1_a_type, '8'):8, ?_(P1_a_craft, '8'):8, ?_(P1_val, '32'):32, ?_(P1_lock, '8'):8>> || {P1_a_type, P1_a_craft, P1_val, P1_lock} <- P0_attr]))/binary, ?_((length(P0_skills)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_step, '8'):8, ?_(P1_exp, '16'):16>> || {P1_id, P1_step, P1_exp} <- P0_skills]))/binary, ?_(P0_intimacy, '32'):32, ?_(P0_shape_lev, '16'):16, ?_(P0_shape_luck, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17201:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17201), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17201:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17202), {P0_active, P0_step, P0_exp, P0_exp_need}) ->
    D_a_t_a = <<?_(P0_active, '8'):8, ?_(P0_step, '8'):8, ?_(P0_exp, '32'):32, ?_(P0_exp_need, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17202:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17202), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17202:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17205), {P0_step, P0_exp, P0_exp_need, P0_bag}) ->
    D_a_t_a = <<?_(P0_step, '8'):8, ?_(P0_exp, '32'):32, ?_(P0_exp_need, '32'):32, ?_((length(P0_bag)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_craft, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_a_type, '8'):8, ?_(P2_a_craft, '8'):8, ?_(P2_val, '32'):32, ?_(P2_lock, '8'):8>> || {P2_a_type, P2_a_craft, P2_val, P2_lock} <- P1_attr]))/binary, ?_((length(P1_skills)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_(P2_step, '8'):8, ?_(P2_exp, '16'):16>> || {P2_id, P2_step, P2_exp} <- P1_skills]))/binary, ?_(P1_intimacy, '32'):32, ?_(P1_shape_lev, '16'):16, ?_(P1_shape_luck, '32'):32>> || #demon{id = P1_id, name = P1_name, craft = P1_craft, attr = P1_attr, skills = P1_skills, intimacy = P1_intimacy, shape_lev = P1_shape_lev, shape_luck = P1_shape_luck} <- P0_bag]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17205:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17205), {P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17205:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17210), {P0_id, P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17210:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17210), {P0_type, P0_id}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17210:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17211), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17211:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17211), {P0_id, P0_skill_id}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_(P0_skill_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17211:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17212), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17212:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17212), {P0_id, P0_locks}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_((length(P0_locks)), "16"):16, (list_to_binary([<<?_(P1_a_type, '8'):8>> || P1_a_type <- P0_locks]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17212:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17213), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17213:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17213), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17213:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17214), {P0_ret, P0_msg, P0_id, P0_intimacy}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_id, '8'):8, ?_(P0_intimacy, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17214:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17214), {P0_id, P0_items}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_item_id, '32'):32, ?_(P1_num, '8'):8>> || [P1_item_id, P1_num] <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17214:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17215), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17215:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17215), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17215:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17216), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17216:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17216), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17216:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17220), {P0_ret, P0_msg, P0_attrs}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_((length(P0_attrs)), "16"):16, (list_to_binary([<<?_(P1_polish_id, '8'):8, ?_(P1_polish_craft, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_a_type, '8'):8, ?_(P2_a_craft, '8'):8, ?_(P2_val, '32'):32, ?_(P2_lock, '8'):8>> || {P2_a_type, P2_a_craft, P2_val, P2_lock} <- P1_attr]))/binary>> || {P1_polish_id, P1_polish_craft, P1_attr} <- P0_attrs]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17220:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17220), {P0_mode, P0_id, P0_locks}) ->
    D_a_t_a = <<?_(P0_mode, '8'):8, ?_(P0_id, '8'):8, ?_((length(P0_locks)), "16"):16, (list_to_binary([<<?_(P1_a_type, '8'):8>> || P1_a_type <- P0_locks]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17220:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17221), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17221:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17221), {P0_id, P0_polish_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_polish_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17221:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17225), {P0_ret, P0_msg, P0_luck_coin, P0_luck_gold, P0_skills}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_luck_coin, '16'):16, ?_(P0_luck_gold, '16'):16, ?_((length(P0_skills)), "16"):16, (list_to_binary([<<?_(P1_polish_id, '8'):8, ?_(P1_skill_id, '32'):32>> || {P1_polish_id, P1_skill_id} <- P0_skills]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17225:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17225), {P0_mode}) ->
    D_a_t_a = <<?_(P0_mode, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17225:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17226), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17226:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17226), {P0_mode, P0_polish_id, P0_id}) ->
    D_a_t_a = <<?_(P0_mode, '8'):8, ?_(P0_polish_id, '32'):32, ?_(P0_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17226:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17227), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17227:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17227), {P0_id, P0_skill_id}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_(P0_skill_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17227:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17228), {P0_skills}) ->
    D_a_t_a = <<?_((length(P0_skills)), "16"):16, (list_to_binary([<<?_(P1_select_id, '32'):32, ?_(P1_skill_id, '32'):32>> || {P1_select_id, P1_skill_id} <- P0_skills]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17228:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17228), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17228:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17229), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17229:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17229), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17229:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17235), {P0_demon_list, P0_demons}) ->
    D_a_t_a = <<?_((length(P0_demon_list)), "16"):16, (list_to_binary([<<?_(P1_id, '16'):16, ?_(P1_base_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_mod, '8'):8, ?_(P1_craft, '8'):8, ?_(P1_debris, '32'):32, ?_(P1_lev, '32'):32, ?_(P1_exp, '32'):32, ?_(P1_grow, '32'):32, ?_(P1_bless, '32'):32, ?_(P1_grow_max, '32'):32, ?_(P1_devour_id1, '32'):32, ?_(P1_devour_id2, '32'):32, ?_(P1_dmg, '32'):32, ?_(P1_critrate, '32'):32, ?_(P1_hp_max, '32'):32, ?_(P1_mp_max, '32'):32, ?_(P1_defence, '32'):32, ?_(P1_tenacity, '32'):32, ?_(P1_evasion, '32'):32, ?_(P1_hitrate, '32'):32, ?_(P1_dmg_max, '32'):32, ?_((length(P1_skills)), "16"):16, (list_to_binary([<<?_(P2_skill_id, '32'):32>> || P2_skill_id <- P1_skills]))/binary>> || {P1_id, P1_base_id, P1_name, P1_mod, P1_craft, P1_debris, P1_lev, P1_exp, P1_grow, P1_bless, P1_grow_max, P1_devour_id1, P1_devour_id2, P1_dmg, P1_critrate, P1_hp_max, P1_mp_max, P1_defence, P1_tenacity, P1_evasion, P1_hitrate, P1_dmg_max, P1_skills} <- P0_demon_list]))/binary, ?_((length(P0_demons)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32>> || P1_base_id <- P0_demons]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17235:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17235), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17235:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17236), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17236:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17236), {P0_base_id}) ->
    D_a_t_a = <<?_(P0_base_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17236:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17237), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17237:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17237), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17237:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17238), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17238:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17238), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17238:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17239), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17239:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17239), {P0_id, P0_parms}) ->
    D_a_t_a = <<?_(P0_id, '16'):16, ?_((length(P0_parms)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_num, '32'):32>> || {P1_id, P1_num} <- P0_parms]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17239:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17240), {P0_debris}) ->
    D_a_t_a = <<?_((length(P0_debris)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_(P1_num, '32'):32>> || {P1_base_id, P1_num} <- P0_debris]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17240:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17240), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17240:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17241), {P0_id, P0_base_id, P0_name, P0_mod, P0_craft, P0_debris, P0_lev, P0_exp, P0_grow, P0_bless, P0_grow_max, P0_devour_id1, P0_devour_id2, P0_dmg, P0_critrate, P0_hp_max, P0_mp_max, P0_defence, P0_tenacity, P0_evasion, P0_hitrate, P0_dmg_max, P0_skills}) ->
    D_a_t_a = <<?_(P0_id, '16'):16, ?_(P0_base_id, '32'):32, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_mod, '8'):8, ?_(P0_craft, '8'):8, ?_(P0_debris, '32'):32, ?_(P0_lev, '32'):32, ?_(P0_exp, '32'):32, ?_(P0_grow, '32'):32, ?_(P0_bless, '32'):32, ?_(P0_grow_max, '32'):32, ?_(P0_devour_id1, '32'):32, ?_(P0_devour_id2, '32'):32, ?_(P0_dmg, '32'):32, ?_(P0_critrate, '32'):32, ?_(P0_hp_max, '32'):32, ?_(P0_mp_max, '32'):32, ?_(P0_defence, '32'):32, ?_(P0_tenacity, '32'):32, ?_(P0_evasion, '32'):32, ?_(P0_hitrate, '32'):32, ?_(P0_dmg_max, '32'):32, ?_((length(P0_skills)), "16"):16, (list_to_binary([<<?_(P1_skill_id, '32'):32>> || P1_skill_id <- P0_skills]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17241:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17241), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17241:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17242), {P0_grab_times, P0_buy_times, P0_grab_list}) ->
    D_a_t_a = <<?_(P0_grab_times, '8'):8, ?_(P0_buy_times, '8'):8, ?_((length(P0_grab_list)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '8'):8, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_power, '32'):32>> || {P1_type, P1_rid, P1_srv_id, P1_name, P1_lev, P1_career, P1_sex, P1_power} <- P0_grab_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17242:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17242), {P0_base_id}) ->
    D_a_t_a = <<?_(P0_base_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17242:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17243), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17243:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17243), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17243:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17244), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17244:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17244), {P0_id, P0_is_auto}) ->
    D_a_t_a = <<?_(P0_id, '16'):16, ?_(P0_is_auto, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17244:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17245), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17245:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17245), {P0_id, P0_is_auto}) ->
    D_a_t_a = <<?_(P0_id, '16'):16, ?_(P0_is_auto, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17245:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17246), {P0_status}) ->
    D_a_t_a = <<?_(P0_status, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17246:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17246), {P0_main_id, P0_slave_id}) ->
    D_a_t_a = <<?_(P0_main_id, '16'):16, ?_(P0_slave_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17246:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17247), {P0_status}) ->
    D_a_t_a = <<?_(P0_status, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17247:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17247), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17247:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17250), {P0_status}) ->
    D_a_t_a = <<?_(P0_status, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17250:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17250), {P0_type, P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17250:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17251), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17251:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17251), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17251:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17252), {P0_status}) ->
    D_a_t_a = <<?_(P0_status, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17252:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17252), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17252:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 17235, _B0) ->
    {ok, {}};
unpack(cli, 17235, _B0) ->
    {P0_demon_list, _B27} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint16(_B1),
        {P1_base_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_name, _B4} = lib_proto:read_string(_B3),
        {P1_mod, _B5} = lib_proto:read_uint8(_B4),
        {P1_craft, _B6} = lib_proto:read_uint8(_B5),
        {P1_debris, _B7} = lib_proto:read_uint32(_B6),
        {P1_lev, _B8} = lib_proto:read_uint32(_B7),
        {P1_exp, _B9} = lib_proto:read_uint32(_B8),
        {P1_grow, _B10} = lib_proto:read_uint32(_B9),
        {P1_bless, _B11} = lib_proto:read_uint32(_B10),
        {P1_grow_max, _B12} = lib_proto:read_uint32(_B11),
        {P1_devour_id1, _B13} = lib_proto:read_uint32(_B12),
        {P1_devour_id2, _B14} = lib_proto:read_uint32(_B13),
        {P1_dmg, _B15} = lib_proto:read_uint32(_B14),
        {P1_critrate, _B16} = lib_proto:read_uint32(_B15),
        {P1_hp_max, _B17} = lib_proto:read_uint32(_B16),
        {P1_mp_max, _B18} = lib_proto:read_uint32(_B17),
        {P1_defence, _B19} = lib_proto:read_uint32(_B18),
        {P1_tenacity, _B20} = lib_proto:read_uint32(_B19),
        {P1_evasion, _B21} = lib_proto:read_uint32(_B20),
        {P1_hitrate, _B22} = lib_proto:read_uint32(_B21),
        {P1_dmg_max, _B23} = lib_proto:read_uint32(_B22),
        {P1_skills, _B26} = lib_proto:read_array(_B23, fun(_B24) ->
            {P2_skill_id, _B25} = lib_proto:read_uint32(_B24),
            {P2_skill_id, _B25}
        end),
        {[P1_id, P1_base_id, P1_name, P1_mod, P1_craft, P1_debris, P1_lev, P1_exp, P1_grow, P1_bless, P1_grow_max, P1_devour_id1, P1_devour_id2, P1_dmg, P1_critrate, P1_hp_max, P1_mp_max, P1_defence, P1_tenacity, P1_evasion, P1_hitrate, P1_dmg_max, P1_skills], _B26}
    end),
    {P0_demons, _B30} = lib_proto:read_array(_B27, fun(_B28) ->
        {P1_base_id, _B29} = lib_proto:read_uint32(_B28),
        {P1_base_id, _B29}
    end),
    {ok, {P0_demon_list, P0_demons}};

unpack(srv, 17236, _B0) ->
    {P0_base_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_base_id}};
unpack(cli, 17236, _B0) ->
    {ok, {}};

unpack(srv, 17237, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_id}};
unpack(cli, 17237, _B0) ->
    {ok, {}};

unpack(srv, 17238, _B0) ->
    {ok, {}};
unpack(cli, 17238, _B0) ->
    {ok, {}};

unpack(srv, 17240, _B0) ->
    {ok, {}};
unpack(cli, 17240, _B0) ->
    {P0_debris, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_base_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_num, _B3} = lib_proto:read_uint32(_B2),
        {[P1_base_id, P1_num], _B3}
    end),
    {ok, {P0_debris}};

unpack(srv, 17241, _B0) ->
    {ok, {}};
unpack(cli, 17241, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint16(_B0),
    {P0_base_id, _B2} = lib_proto:read_uint32(_B1),
    {P0_name, _B3} = lib_proto:read_string(_B2),
    {P0_mod, _B4} = lib_proto:read_uint8(_B3),
    {P0_craft, _B5} = lib_proto:read_uint8(_B4),
    {P0_debris, _B6} = lib_proto:read_uint32(_B5),
    {P0_lev, _B7} = lib_proto:read_uint32(_B6),
    {P0_exp, _B8} = lib_proto:read_uint32(_B7),
    {P0_grow, _B9} = lib_proto:read_uint32(_B8),
    {P0_bless, _B10} = lib_proto:read_uint32(_B9),
    {P0_grow_max, _B11} = lib_proto:read_uint32(_B10),
    {P0_devour_id1, _B12} = lib_proto:read_uint32(_B11),
    {P0_devour_id2, _B13} = lib_proto:read_uint32(_B12),
    {P0_dmg, _B14} = lib_proto:read_uint32(_B13),
    {P0_critrate, _B15} = lib_proto:read_uint32(_B14),
    {P0_hp_max, _B16} = lib_proto:read_uint32(_B15),
    {P0_mp_max, _B17} = lib_proto:read_uint32(_B16),
    {P0_defence, _B18} = lib_proto:read_uint32(_B17),
    {P0_tenacity, _B19} = lib_proto:read_uint32(_B18),
    {P0_evasion, _B20} = lib_proto:read_uint32(_B19),
    {P0_hitrate, _B21} = lib_proto:read_uint32(_B20),
    {P0_dmg_max, _B22} = lib_proto:read_uint32(_B21),
    {P0_skills, _B25} = lib_proto:read_array(_B22, fun(_B23) ->
        {P1_skill_id, _B24} = lib_proto:read_uint32(_B23),
        {P1_skill_id, _B24}
    end),
    {ok, {P0_id, P0_base_id, P0_name, P0_mod, P0_craft, P0_debris, P0_lev, P0_exp, P0_grow, P0_bless, P0_grow_max, P0_devour_id1, P0_devour_id2, P0_dmg, P0_critrate, P0_hp_max, P0_mp_max, P0_defence, P0_tenacity, P0_evasion, P0_hitrate, P0_dmg_max, P0_skills}};

unpack(srv, 17242, _B0) ->
    {P0_base_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_base_id}};
unpack(cli, 17242, _B0) ->
    {P0_grab_times, _B1} = lib_proto:read_uint8(_B0),
    {P0_buy_times, _B2} = lib_proto:read_uint8(_B1),
    {P0_grab_list, _B12} = lib_proto:read_array(_B2, fun(_B3) ->
        {P1_type, _B4} = lib_proto:read_uint8(_B3),
        {P1_rid, _B5} = lib_proto:read_uint32(_B4),
        {P1_srv_id, _B6} = lib_proto:read_string(_B5),
        {P1_name, _B7} = lib_proto:read_string(_B6),
        {P1_lev, _B8} = lib_proto:read_uint8(_B7),
        {P1_career, _B9} = lib_proto:read_uint8(_B8),
        {P1_sex, _B10} = lib_proto:read_uint8(_B9),
        {P1_power, _B11} = lib_proto:read_uint32(_B10),
        {[P1_type, P1_rid, P1_srv_id, P1_name, P1_lev, P1_career, P1_sex, P1_power], _B11}
    end),
    {ok, {P0_grab_times, P0_buy_times, P0_grab_list}};

unpack(srv, 17243, _B0) ->
    {ok, {}};
unpack(cli, 17243, _B0) ->
    {ok, {}};

unpack(srv, 17244, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint16(_B0),
    {P0_is_auto, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_id, P0_is_auto}};
unpack(cli, 17244, _B0) ->
    {ok, {}};

unpack(srv, 17245, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint16(_B0),
    {P0_is_auto, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_id, P0_is_auto}};
unpack(cli, 17245, _B0) ->
    {ok, {}};

unpack(srv, 17246, _B0) ->
    {P0_main_id, _B1} = lib_proto:read_uint16(_B0),
    {P0_slave_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_main_id, P0_slave_id}};
unpack(cli, 17246, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_status}};

unpack(srv, 17247, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_id}};
unpack(cli, 17247, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_status}};

unpack(srv, 17250, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_rid, _B2} = lib_proto:read_uint32(_B1),
    {P0_srv_id, _B3} = lib_proto:read_string(_B2),
    {ok, {P0_type, P0_rid, P0_srv_id}};
unpack(cli, 17250, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_status}};

unpack(srv, 17251, _B0) ->
    {ok, {}};
unpack(cli, 17251, _B0) ->
    {ok, {}};

unpack(srv, 17252, _B0) ->
    {ok, {}};
unpack(cli, 17252, _B0) ->
    {P0_status, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_status}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
