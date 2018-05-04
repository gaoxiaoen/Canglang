%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_126).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("pet.hrl").
-include("item.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(12600), {P0_rename_num, P0_name, P0_type, P0_base_id, P0_lev, P0_exp, P0_need_exp, P0_xl, P0_tz, P0_js, P0_lq, P0_xl_val, P0_tz_val, P0_js_val, P0_lq_val, P0_step, P0_xl_per, P0_tz_per, P0_js_per, P0_lq_per, P0_skill_num, P0_skill_list, P0_dmg, P0_critrate, P0_hp_max, P0_mp_max, P0_defence, P0_tenacity, P0_hitrate, P0_evasion, P0_power, P0_eqm_num, P0_xl_max, P0_tz_max, P0_js_max, P0_lq_max}) ->
    D_a_t_a = <<?_(P0_rename_num, '16'):16, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_type, '8'):8, ?_(P0_base_id, '32'):32, ?_(P0_lev, '8'):8, ?_(P0_exp, '32'):32, ?_(P0_need_exp, '32'):32, ?_(P0_xl, '16'):16, ?_(P0_tz, '16'):16, ?_(P0_js, '16'):16, ?_(P0_lq, '16'):16, ?_(P0_xl_val, '16'):16, ?_(P0_tz_val, '16'):16, ?_(P0_js_val, '16'):16, ?_(P0_lq_val, '16'):16, ?_(P0_step, '8/signed'):8/signed, ?_(P0_xl_per, '8'):8, ?_(P0_tz_per, '8'):8, ?_(P0_js_per, '8'):8, ?_(P0_lq_per, '8'):8, ?_(P0_skill_num, '8'):8, ?_((length(P0_skill_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_exp, '16'):16, ?_(P1_skill_loc, '8'):8, ?_((length(P1_skill_args)), "16"):16, (list_to_binary([<<?_(P2_type, '8'):8, ?_(P2_val, '16'):16>> || {P2_type, P2_val} <- P1_skill_args]))/binary>> || {P1_id, P1_exp, P1_skill_loc, P1_skill_args} <- P0_skill_list]))/binary, ?_(P0_dmg, '32'):32, ?_(P0_critrate, '16'):16, ?_(P0_hp_max, '32'):32, ?_(P0_mp_max, '32'):32, ?_(P0_defence, '16'):16, ?_(P0_tenacity, '16'):16, ?_(P0_hitrate, '16'):16, ?_(P0_evasion, '16'):16, ?_(P0_power, '32'):32, ?_(P0_eqm_num, '16'):16, ?_(P0_xl_max, '16'):16, ?_(P0_tz_max, '16'):16, ?_(P0_js_max, '16'):16, ?_(P0_lq_max, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12600:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12600), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12600:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12601), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12601:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12601), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12601:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12602), {P0_id, P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12602:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12602), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12602:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12603), {P0_id, P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12603:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12603), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12603:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12604), {P0_code}) ->
    D_a_t_a = <<?_(P0_code, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12604:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12604), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12604:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12605), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12605:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12605), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12605:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12606), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12606:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12606), {P0_name}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12606:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12607), {P0_code}) ->
    D_a_t_a = <<?_(P0_code, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12607:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12607), {P0_base_id, P0_name}) ->
    D_a_t_a = <<?_(P0_base_id, '16'):16, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12607:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12608), {P0_code}) ->
    D_a_t_a = <<?_(P0_code, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12608:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12608), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12608:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12609), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12609:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12609), {P0_main_id, P0_second_id, P0_select_baseid}) ->
    D_a_t_a = <<?_(P0_main_id, '32'):32, ?_(P0_second_id, '32'):32, ?_(P0_select_baseid, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12609:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12610), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12610:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12610), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12610:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12611), {P0_skill_id}) ->
    D_a_t_a = <<?_(P0_skill_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12611:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12611), {P0_skill_id}) ->
    D_a_t_a = <<?_(P0_skill_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12611:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12612), {P0_id, P0_exp}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_exp, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12612:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12612), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12612:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12613), {P0_skill_list}) ->
    D_a_t_a = <<?_((length(P0_skill_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_exp, '16'):16, ?_(P1_skill_loc, '8'):8, ?_((length(P1_skill_args)), "16"):16, (list_to_binary([<<?_(P2_type, '8'):8, ?_(P2_val, '16'):16>> || {P2_type, P2_val} <- P1_skill_args]))/binary>> || {P1_id, P1_exp, P1_skill_loc, P1_skill_args} <- P0_skill_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12613:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12613), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12613:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12614), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12614:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12614), {P0_item_id, P0_refesh_type, P0_is_batch}) ->
    D_a_t_a = <<?_(P0_item_id, '32'):32, ?_(P0_refesh_type, '8/signed'):8/signed, ?_(P0_is_batch, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12614:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12615), {P0_type, P0_val, P0_step, P0_avg}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_val, '16/signed'):16/signed, ?_(P0_step, '8/signed'):8/signed, ?_(P0_avg, '32/signed'):32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12615:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12615), {P0_type, P0_is_auto}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_is_auto, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12615:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12616), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12616:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12616), {P0_auto}) ->
    D_a_t_a = <<?_(P0_auto, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12616:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12617), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12617:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12617), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12617:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12618), {P0_lev, P0_exp, P0_need_exp, P0_avg}) ->
    D_a_t_a = <<?_(P0_lev, '8'):8, ?_(P0_exp, '32'):32, ?_(P0_need_exp, '32'):32, ?_(P0_avg, '32/signed'):32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12618:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12618), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12618:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12619), {P0_main_id, P0_second_id, P0_code, P0_msg, P0_pet_list}) ->
    D_a_t_a = <<?_(P0_main_id, '32'):32, ?_(P0_second_id, '32'):32, ?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_((length(P0_pet_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_type, '8'):8, ?_(P1_base_id, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_mod, '8'):8, ?_(P1_grow_val, '16'):16, ?_(P1_happy_val, '8'):8, ?_(P1_exp, '32'):32, ?_(P1_need_exp, '32'):32, ?_(P1_xl, '16'):16, ?_(P1_tz, '16'):16, ?_(P1_js, '16'):16, ?_(P1_lq, '16'):16, ?_(P1_xl_val, '16'):16, ?_(P1_tz_val, '16'):16, ?_(P1_js_val, '16'):16, ?_(P1_lq_val, '16'):16, ?_(P1_xl_per, '8'):8, ?_(P1_tz_per, '8'):8, ?_(P1_js_per, '8'):8, ?_(P1_lq_per, '8'):8, ?_(P1_skill_num, '8'):8, ?_((length(P1_skill_list)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_(P2_exp, '16'):16, ?_((length(P2_skill_args)), "16"):16, (list_to_binary([<<?_(P3_type, '8'):8, ?_(P3_val, '16'):16>> || {P3_type, P3_val} <- P2_skill_args]))/binary>> || {P2_id, P2_exp, P2_skill_args} <- P1_skill_list]))/binary, ?_(P1_dmg, '32'):32, ?_(P1_critrate, '16'):16, ?_(P1_hp_max, '32'):32, ?_(P1_mp_max, '32'):32, ?_(P1_defence, '16'):16, ?_(P1_tenacity, '16'):16, ?_(P1_hitrate, '16'):16, ?_(P1_evasion, '16'):16, ?_(P1_power, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_change_type, '8'):8, ?_(P1_wish_val, '16'):16, ?_(P1_eqm_num, '16'):16, ?_(P1_dmg_magic, '32'):32, ?_(P1_anti_js, '32'):32, ?_(P1_anti_attack, '32'):32, ?_(P1_anti_seal, '32'):32, ?_(P1_anti_stone, '32'):32, ?_(P1_anti_stun, '32'):32, ?_(P1_anti_sleep, '32'):32, ?_(P1_anti_taunt, '32'):32, ?_(P1_anti_silent, '32'):32, ?_(P1_anti_poison, '32'):32, ?_(P1_blood, '32'):32, ?_(P1_rebound, '32'):32, ?_(P1_resist_metal, '32'):32, ?_(P1_resist_wood, '32'):32, ?_(P1_resist_water, '32'):32, ?_(P1_resist_fire, '32'):32, ?_(P1_resist_earth, '32'):32, ?_(P1_xl_max, '16'):16, ?_(P1_tz_max, '16'):16, ?_(P1_js_max, '16'):16, ?_(P1_lq_max, '16'):16, ?_((length(P1_resist_list)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32, ?_(P2_num, '16'):16>> || {P2_base_id, P2_num} <- P1_resist_list]))/binary, ?_(P1_ascended, '8'):8, ?_(P1_ascend_num, '8'):8, ?_((length(P1_ascend_attr)), "16"):16, (list_to_binary([<<?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_flag, P2_value} <- P1_ascend_attr]))/binary, ?_((length(P1_next_ascend_attr)), "16"):16, (list_to_binary([<<?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_flag, P2_value} <- P1_next_ascend_attr]))/binary>> || {P1_id, P1_name, P1_type, P1_base_id, P1_lev, P1_mod, P1_grow_val, P1_happy_val, P1_exp, P1_need_exp, P1_xl, P1_tz, P1_js, P1_lq, P1_xl_val, P1_tz_val, P1_js_val, P1_lq_val, P1_xl_per, P1_tz_per, P1_js_per, P1_lq_per, P1_skill_num, P1_skill_list, P1_dmg, P1_critrate, P1_hp_max, P1_mp_max, P1_defence, P1_tenacity, P1_hitrate, P1_evasion, P1_power, P1_bind, P1_change_type, P1_wish_val, P1_eqm_num, P1_dmg_magic, P1_anti_js, P1_anti_attack, P1_anti_seal, P1_anti_stone, P1_anti_stun, P1_anti_sleep, P1_anti_taunt, P1_anti_silent, P1_anti_poison, P1_blood, P1_rebound, P1_resist_metal, P1_resist_wood, P1_resist_water, P1_resist_fire, P1_resist_earth, P1_xl_max, P1_tz_max, P1_js_max, P1_lq_max, P1_resist_list, P1_ascended, P1_ascend_num, P1_ascend_attr, P1_next_ascend_attr} <- P0_pet_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12619:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12619), {P0_main_id, P0_second_id}) ->
    D_a_t_a = <<?_(P0_main_id, '32'):32, ?_(P0_second_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12619:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12620), {P0_wash_list}) ->
    D_a_t_a = <<?_((length(P0_wash_list)), "16"):16, (list_to_binary([<<?_(P1_code, '8'):8, ?_(P1_xl, '16'):16, ?_(P1_tz, '16'):16, ?_(P1_js, '16'):16, ?_(P1_lq, '16'):16, ?_(P1_xl_per, '8'):8, ?_(P1_tz_per, '8'):8, ?_(P1_js_per, '8'):8, ?_(P1_lq_per, '8'):8>> || {P1_code, P1_xl, P1_tz, P1_js, P1_lq, P1_xl_per, P1_tz_per, P1_js_per, P1_lq_per} <- P0_wash_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12620:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12620), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12620:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12621), {P0_wash_list}) ->
    D_a_t_a = <<?_((length(P0_wash_list)), "16"):16, (list_to_binary([<<?_(P1_code, '8'):8, ?_(P1_xl, '16'):16, ?_(P1_tz, '16'):16, ?_(P1_js, '16'):16, ?_(P1_lq, '16'):16, ?_(P1_xl_per, '8'):8, ?_(P1_tz_per, '8'):8, ?_(P1_js_per, '8'):8, ?_(P1_lq_per, '8'):8>> || {P1_code, P1_xl, P1_tz, P1_js, P1_lq, P1_xl_per, P1_tz_per, P1_js_per, P1_lq_per} <- P0_wash_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12621:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12621), {P0_auto}) ->
    D_a_t_a = <<?_(P0_auto, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12621:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12622), {P0_code}) ->
    D_a_t_a = <<?_(P0_code, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12622:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12622), {P0_code}) ->
    D_a_t_a = <<?_(P0_code, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12622:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12623), {P0_free_times}) ->
    D_a_t_a = <<?_(P0_free_times, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12623:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12623), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12623:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12624), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12624:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12624), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12624:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12625), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12625:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12625), {P0_item_id, P0_id}) ->
    D_a_t_a = <<?_(P0_item_id, '32'):32, ?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12625:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12626), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12626:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12626), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12626:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12627), {P0_xl, P0_tz, P0_js, P0_lq, P0_grow_xl, P0_grow_tz, P0_grow_js, P0_grow_lq, P0_next_xl, P0_next_tz, P0_next_js, P0_next_lq, P0_next_grow_xl, P0_next_grow_tz, P0_next_grow_js, P0_next_grow_lq}) ->
    D_a_t_a = <<?_(P0_xl, '16'):16, ?_(P0_tz, '16'):16, ?_(P0_js, '16'):16, ?_(P0_lq, '16'):16, ?_(P0_grow_xl, '16'):16, ?_(P0_grow_tz, '16'):16, ?_(P0_grow_js, '16'):16, ?_(P0_grow_lq, '16'):16, ?_(P0_next_xl, '16'):16, ?_(P0_next_tz, '16'):16, ?_(P0_next_js, '16'):16, ?_(P0_next_lq, '16'):16, ?_(P0_next_grow_xl, '16'):16, ?_(P0_next_grow_tz, '16'):16, ?_(P0_next_grow_js, '16'):16, ?_(P0_next_grow_lq, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12627:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12627), {P0_lev, P0_grow_val, P0_xl_per, P0_tz_per, P0_js_per, P0_lq_per}) ->
    D_a_t_a = <<?_(P0_lev, '8'):8, ?_(P0_grow_val, '16'):16, ?_(P0_xl_per, '8'):8, ?_(P0_tz_per, '8'):8, ?_(P0_js_per, '8'):8, ?_(P0_lq_per, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12627:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12628), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12628:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12628), {P0_id, P0_grow_val}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_grow_val, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12628:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12629), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12629:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12629), {P0_type, P0_id}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12629:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12630), {P0_xl, P0_tz, P0_js, P0_lq, P0_xl_per, P0_tz_per, P0_js_per, P0_lq_per, P0_dmg, P0_critrate, P0_hp_max, P0_mp_max, P0_defence, P0_tenacity, P0_hitrate, P0_evasion, P0_power}) ->
    D_a_t_a = <<?_(P0_xl, '16'):16, ?_(P0_tz, '16'):16, ?_(P0_js, '16'):16, ?_(P0_lq, '16'):16, ?_(P0_xl_per, '8'):8, ?_(P0_tz_per, '8'):8, ?_(P0_js_per, '8'):8, ?_(P0_lq_per, '8'):8, ?_(P0_dmg, '32'):32, ?_(P0_critrate, '16'):16, ?_(P0_hp_max, '32'):32, ?_(P0_mp_max, '32'):32, ?_(P0_defence, '16'):16, ?_(P0_tenacity, '16'):16, ?_(P0_hitrate, '16'):16, ?_(P0_evasion, '16'):16, ?_(P0_power, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12630:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12630), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12630:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12631), {P0_pet_list}) ->
    D_a_t_a = <<?_((length(P0_pet_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_type, '8'):8, ?_(P1_base_id, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_mod, '8'):8, ?_(P1_grow_val, '16'):16, ?_(P1_happy_val, '8'):8, ?_(P1_exp, '32'):32, ?_(P1_need_exp, '32'):32, ?_(P1_xl, '16'):16, ?_(P1_tz, '16'):16, ?_(P1_js, '16'):16, ?_(P1_lq, '16'):16, ?_(P1_xl_val, '16'):16, ?_(P1_tz_val, '16'):16, ?_(P1_js_val, '16'):16, ?_(P1_lq_val, '16'):16, ?_(P1_xl_per, '8'):8, ?_(P1_tz_per, '8'):8, ?_(P1_js_per, '8'):8, ?_(P1_lq_per, '8'):8, ?_(P1_skill_num, '8'):8, ?_((length(P1_skill_list)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_(P2_exp, '16'):16, ?_((length(P2_skill_args)), "16"):16, (list_to_binary([<<?_(P3_type, '8'):8, ?_(P3_val, '16'):16>> || {P3_type, P3_val} <- P2_skill_args]))/binary>> || {P2_id, P2_exp, P2_skill_args} <- P1_skill_list]))/binary, ?_(P1_dmg, '32'):32, ?_(P1_critrate, '16'):16, ?_(P1_hp_max, '32'):32, ?_(P1_mp_max, '32'):32, ?_(P1_defence, '16'):16, ?_(P1_tenacity, '16'):16, ?_(P1_hitrate, '16'):16, ?_(P1_evasion, '16'):16, ?_(P1_power, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_change_type, '8'):8, ?_(P1_wish_val, '16'):16, ?_(P1_eqm_num, '16'):16, ?_(P1_dmg_magic, '32'):32, ?_(P1_anti_js, '32'):32, ?_(P1_anti_attack, '32'):32, ?_(P1_anti_seal, '32'):32, ?_(P1_anti_stone, '32'):32, ?_(P1_anti_stun, '32'):32, ?_(P1_anti_sleep, '32'):32, ?_(P1_anti_taunt, '32'):32, ?_(P1_anti_silent, '32'):32, ?_(P1_anti_poison, '32'):32, ?_(P1_blood, '32'):32, ?_(P1_rebound, '32'):32, ?_(P1_resist_metal, '32'):32, ?_(P1_resist_wood, '32'):32, ?_(P1_resist_water, '32'):32, ?_(P1_resist_fire, '32'):32, ?_(P1_resist_earth, '32'):32, ?_(P1_xl_max, '16'):16, ?_(P1_tz_max, '16'):16, ?_(P1_js_max, '16'):16, ?_(P1_lq_max, '16'):16, ?_((length(P1_resist_list)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32, ?_(P2_num, '16'):16>> || {P2_base_id, P2_num} <- P1_resist_list]))/binary, ?_(P1_ascended, '8'):8, ?_(P1_ascend_num, '8'):8, ?_((length(P1_ascend_attr)), "16"):16, (list_to_binary([<<?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_flag, P2_value} <- P1_ascend_attr]))/binary, ?_((length(P1_next_ascend_attr)), "16"):16, (list_to_binary([<<?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_flag, P2_value} <- P1_next_ascend_attr]))/binary>> || {P1_id, P1_name, P1_type, P1_base_id, P1_lev, P1_mod, P1_grow_val, P1_happy_val, P1_exp, P1_need_exp, P1_xl, P1_tz, P1_js, P1_lq, P1_xl_val, P1_tz_val, P1_js_val, P1_lq_val, P1_xl_per, P1_tz_per, P1_js_per, P1_lq_per, P1_skill_num, P1_skill_list, P1_dmg, P1_critrate, P1_hp_max, P1_mp_max, P1_defence, P1_tenacity, P1_hitrate, P1_evasion, P1_power, P1_bind, P1_change_type, P1_wish_val, P1_eqm_num, P1_dmg_magic, P1_anti_js, P1_anti_attack, P1_anti_seal, P1_anti_stone, P1_anti_stun, P1_anti_sleep, P1_anti_taunt, P1_anti_silent, P1_anti_poison, P1_blood, P1_rebound, P1_resist_metal, P1_resist_wood, P1_resist_water, P1_resist_fire, P1_resist_earth, P1_xl_max, P1_tz_max, P1_js_max, P1_lq_max, P1_resist_list, P1_ascended, P1_ascend_num, P1_ascend_attr, P1_next_ascend_attr} <- P0_pet_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12631:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12631), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12631:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12632), {P0_pet_list}) ->
    D_a_t_a = <<?_((length(P0_pet_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32>> || P1_id <- P0_pet_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12632:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12632), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12632:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12633), {P0_id, P0_name, P0_happy_val, P0_skill_num, P0_exp, P0_mod, P0_bind}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_happy_val, '8'):8, ?_(P0_skill_num, '8'):8, ?_(P0_exp, '32'):32, ?_(P0_mod, '8'):8, ?_(P0_bind, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12633:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12633), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12633:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12634), {P0_pet_list}) ->
    D_a_t_a = <<?_((length(P0_pet_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_type, '8'):8, ?_(P1_base_id, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_mod, '8'):8, ?_(P1_grow_val, '16'):16, ?_(P1_happy_val, '8'):8, ?_(P1_exp, '32'):32, ?_(P1_need_exp, '32'):32, ?_(P1_xl, '16'):16, ?_(P1_tz, '16'):16, ?_(P1_js, '16'):16, ?_(P1_lq, '16'):16, ?_(P1_xl_val, '16'):16, ?_(P1_tz_val, '16'):16, ?_(P1_js_val, '16'):16, ?_(P1_lq_val, '16'):16, ?_(P1_xl_per, '8'):8, ?_(P1_tz_per, '8'):8, ?_(P1_js_per, '8'):8, ?_(P1_lq_per, '8'):8, ?_(P1_skill_num, '8'):8, ?_((length(P1_skill_list)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_(P2_exp, '16'):16, ?_((length(P2_skill_args)), "16"):16, (list_to_binary([<<?_(P3_type, '8'):8, ?_(P3_val, '16'):16>> || {P3_type, P3_val} <- P2_skill_args]))/binary>> || {P2_id, P2_exp, P2_skill_args} <- P1_skill_list]))/binary, ?_(P1_dmg, '32'):32, ?_(P1_critrate, '16'):16, ?_(P1_hp_max, '32'):32, ?_(P1_mp_max, '32'):32, ?_(P1_defence, '16'):16, ?_(P1_tenacity, '16'):16, ?_(P1_hitrate, '16'):16, ?_(P1_evasion, '16'):16, ?_(P1_power, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_change_type, '8'):8, ?_(P1_wish_val, '16'):16, ?_(P1_eqm_num, '16'):16, ?_(P1_dmg_magic, '32'):32, ?_(P1_anti_js, '32'):32, ?_(P1_anti_attack, '32'):32, ?_(P1_anti_seal, '32'):32, ?_(P1_anti_stone, '32'):32, ?_(P1_anti_stun, '32'):32, ?_(P1_anti_sleep, '32'):32, ?_(P1_anti_taunt, '32'):32, ?_(P1_anti_silent, '32'):32, ?_(P1_anti_poison, '32'):32, ?_(P1_blood, '32'):32, ?_(P1_rebound, '32'):32, ?_(P1_resist_metal, '32'):32, ?_(P1_resist_wood, '32'):32, ?_(P1_resist_water, '32'):32, ?_(P1_resist_fire, '32'):32, ?_(P1_resist_earth, '32'):32, ?_(P1_xl_max, '16'):16, ?_(P1_tz_max, '16'):16, ?_(P1_js_max, '16'):16, ?_(P1_lq_max, '16'):16, ?_((length(P1_resist_list)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32, ?_(P2_num, '16'):16>> || {P2_base_id, P2_num} <- P1_resist_list]))/binary, ?_(P1_ascended, '8'):8, ?_(P1_ascend_num, '8'):8, ?_((length(P1_ascend_attr)), "16"):16, (list_to_binary([<<?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_flag, P2_value} <- P1_ascend_attr]))/binary, ?_((length(P1_next_ascend_attr)), "16"):16, (list_to_binary([<<?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_flag, P2_value} <- P1_next_ascend_attr]))/binary>> || {P1_id, P1_name, P1_type, P1_base_id, P1_lev, P1_mod, P1_grow_val, P1_happy_val, P1_exp, P1_need_exp, P1_xl, P1_tz, P1_js, P1_lq, P1_xl_val, P1_tz_val, P1_js_val, P1_lq_val, P1_xl_per, P1_tz_per, P1_js_per, P1_lq_per, P1_skill_num, P1_skill_list, P1_dmg, P1_critrate, P1_hp_max, P1_mp_max, P1_defence, P1_tenacity, P1_hitrate, P1_evasion, P1_power, P1_bind, P1_change_type, P1_wish_val, P1_eqm_num, P1_dmg_magic, P1_anti_js, P1_anti_attack, P1_anti_seal, P1_anti_stone, P1_anti_stun, P1_anti_sleep, P1_anti_taunt, P1_anti_silent, P1_anti_poison, P1_blood, P1_rebound, P1_resist_metal, P1_resist_wood, P1_resist_water, P1_resist_fire, P1_resist_earth, P1_xl_max, P1_tz_max, P1_js_max, P1_lq_max, P1_resist_list, P1_ascended, P1_ascend_num, P1_ascend_attr, P1_next_ascend_attr} <- P0_pet_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12634:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12634), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12634:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12635), {P0_exp_time}) ->
    D_a_t_a = <<?_(P0_exp_time, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12635:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12635), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12635:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12636), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12636:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12636), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12636:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12637), {P0_id, P0_evolve, P0_base_type, P0_general, P0_immortal, P0_king, P0_god}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_evolve, '8'):8, ?_(P0_base_type, '8'):8, ?_(P0_general, '32'):32, ?_(P0_immortal, '32'):32, ?_(P0_king, '32'):32, ?_(P0_god, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12637:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12637), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12637:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12638), {P0_rid, P0_srv_id, P0_id, P0_type, P0_attr_val}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_id, '32'):32, ?_(P0_type, '8'):8, ?_((length(P0_attr_val)), "16"):16, (list_to_binary([<<?_(P1_val, '16'):16, ?_(P1_dmg, '32'):32, ?_(P1_critrate, '16'):16, ?_(P1_hp_max, '32'):32, ?_(P1_mp_max, '32'):32, ?_(P1_defence, '16'):16, ?_(P1_tenacity, '16'):16, ?_(P1_hitrate, '16'):16, ?_(P1_evasion, '16'):16>> || {P1_val, P1_dmg, P1_critrate, P1_hp_max, P1_mp_max, P1_defence, P1_tenacity, P1_hitrate, P1_evasion} <- P0_attr_val]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12638:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12638), {P0_rid, P0_srv_id, P0_id, P0_type, P0_attr_val}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_id, '32'):32, ?_(P0_type, '8'):8, ?_((length(P0_attr_val)), "16"):16, (list_to_binary([<<?_(P1_val, '16'):16>> || {P1_val} <- P0_attr_val]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12638:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12639), {P0_flag, P0_skin_id, P0_grade, P0_time, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_(P0_skin_id, '32'):32, ?_(P0_grade, '8'):8, ?_(P0_time, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12639:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12639), {P0_skin_id, P0_grade}) ->
    D_a_t_a = <<?_(P0_skin_id, '32'):32, ?_(P0_grade, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12639:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12640), {P0_time, P0_skin_id, P0_grade, P0_skins}) ->
    D_a_t_a = <<?_(P0_time, '32'):32, ?_(P0_skin_id, '32'):32, ?_(P0_grade, '8'):8, ?_((length(P0_skins)), "16"):16, (list_to_binary([<<?_(P1_skinId, '32'):32>> || P1_skinId <- P0_skins]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12640:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12640), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12640:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12641), {P0_flag, P0_time, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_(P0_time, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12641:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12641), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12641:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12642), {P0_code, P0_msg, P0_id, P0_enable, P0_useid, P0_cooldown, P0_attr_list}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_id, '32'):32, ?_(P0_enable, '8'):8, ?_(P0_useid, '8'):8, ?_(P0_cooldown, '32'):32, ?_((length(P0_attr_list)), "16"):16, (list_to_binary([<<?_(P1_code, '8'):8, ?_(P1_xl, '16'):16, ?_(P1_tz, '16'):16, ?_(P1_js, '16'):16, ?_(P1_lq, '16'):16, ?_(P1_xl_per, '8'):8, ?_(P1_tz_per, '8'):8, ?_(P1_js_per, '8'):8, ?_(P1_lq_per, '8'):8>> || {P1_code, P1_xl, P1_tz, P1_js, P1_lq, P1_xl_per, P1_tz_per, P1_js_per, P1_lq_per} <- P0_attr_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12642:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12642), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12642:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12643), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12643:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12643), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12643:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12644), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12644:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12644), {P0_id, P0_useid}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_useid, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12644:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12645), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12645:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12645), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12645:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12646), {P0_diag_list}) ->
    D_a_t_a = <<?_((length(P0_diag_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_content)), "16"):16, ?_(P1_content, bin)/binary>> || {P1_id, P1_content} <- P0_diag_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12646:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12646), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12646:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12647), {P0_code, P0_msg, P0_id, P0_content}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_id, '32'):32, ?_((byte_size(P0_content)), "16"):16, ?_(P0_content, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12647:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12647), {P0_id, P0_content}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_content)), "16"):16, ?_(P0_content, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12647:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12648), {P0_code, P0_msg, P0_id, P0_content}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_id, '32'):32, ?_((byte_size(P0_content)), "16"):16, ?_(P0_content, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12648:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12648), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12648:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12649), {P0_flag, P0_rid, P0_srv_id, P0_talk_id}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_talk_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12649:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12649), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12649:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12650), {P0_flag, P0_rid, P0_srv_id, P0_content}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_content)), "16"):16, ?_(P0_content, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12650:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12650), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12650:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12651), {P0_buffs}) ->
    D_a_t_a = <<?_((length(P0_buffs)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_baseid, '16'):16, ?_(P1_icon, '32'):32, ?_(P1_endtime, '32/signed'):32/signed>> || {P1_id, P1_baseid, P1_icon, P1_endtime} <- P0_buffs]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12651:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12651), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12651:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12652), {P0_rid, P0_srv_id, P0_lev, P0_exp}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_lev, '8'):8, ?_(P0_exp, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12652:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12652), {P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12652:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12660), {P0_npc_list, P0_free_num, P0_item_list}) ->
    D_a_t_a = <<?_((length(P0_npc_list)), "16"):16, (list_to_binary([<<?_(P1_npc_id, '16'):16>> || P1_npc_id <- P0_npc_list]))/binary, ?_(P0_free_num, '16'):16, ?_((length(P0_item_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_price, '32'):32>> || {P1_id, P1_base_id, P1_price} <- P0_item_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12660:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12660), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12660:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12661), {P0_code, P0_msg, P0_npc_list, P0_item_list}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_((length(P0_npc_list)), "16"):16, (list_to_binary([<<?_(P1_npc_id, '16'):16>> || P1_npc_id <- P0_npc_list]))/binary, ?_((length(P0_item_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_price, '32'):32>> || {P1_id, P1_base_id, P1_price} <- P0_item_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12661:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12661), {P0_npc_id}) ->
    D_a_t_a = <<?_(P0_npc_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12661:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12662), {P0_code, P0_msg, P0_npc_list, P0_free_num, P0_item_list}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_((length(P0_npc_list)), "16"):16, (list_to_binary([<<?_(P1_npc_id, '16'):16>> || P1_npc_id <- P0_npc_list]))/binary, ?_(P0_free_num, '16'):16, ?_((length(P0_item_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_price, '32'):32>> || {P1_id, P1_base_id, P1_price} <- P0_item_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12662:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12662), {P0_npc_id}) ->
    D_a_t_a = <<?_(P0_npc_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12662:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12663), {P0_type, P0_code, P0_msg, P0_id}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12663:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12663), {P0_id, P0_type}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12663:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12664), {P0_volume, P0_items}) ->
    D_a_t_a = <<?_(P0_volume, '32'):32, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_upgrade, '8'):8, ?_(P1_enchant, '8/signed'):8/signed, ?_(P1_enchant_fail, '8'):8, ?_(P1_quantity, '8'):8, ?_(P1_status, '8'):8, ?_(P1_pos, '16'):16, ?_(P1_lasttime, '32'):32, ?_(P1_durability, '32/signed'):32/signed, ?_(P1_craft, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary, ?_((length(P1_extra)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32, ?_((byte_size(P2_str)), "16"):16, ?_(P2_str, bin)/binary>> || {P2_type, P2_value, P2_str} <- P1_extra]))/binary>> || #item{id = P1_id, base_id = P1_base_id, bind = P1_bind, upgrade = P1_upgrade, enchant = P1_enchant, enchant_fail = P1_enchant_fail, quantity = P1_quantity, status = P1_status, pos = P1_pos, lasttime = P1_lasttime, durability = P1_durability, craft = P1_craft, attr = P1_attr, max_base_attr = P1_max_base_attr, extra = P1_extra} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12664:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12664), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12664:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12665), {P0_code, P0_msg, P0_volume}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_volume, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12665:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12665), {P0_num}) ->
    D_a_t_a = <<?_(P0_num, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12665:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12666), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12666:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12666), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12666:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12667), {P0_items}) ->
    D_a_t_a = <<?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_special)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32>> || {P2_type, P2_value} <- P1_special]))/binary>> || #item{base_id = P1_base_id, attr = P1_attr, special = P1_special} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12667:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12667), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12667:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12668), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12668:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12668), {P0_base_id}) ->
    D_a_t_a = <<?_(P0_base_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12668:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12669), {P0_pet_id, P0_type, P0_items}) ->
    D_a_t_a = <<?_(P0_pet_id, '32'):32, ?_(P0_type, '8'):8, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_upgrade, '8'):8, ?_(P1_enchant, '8/signed'):8/signed, ?_(P1_enchant_fail, '8'):8, ?_(P1_quantity, '8'):8, ?_(P1_status, '8'):8, ?_(P1_pos, '16'):16, ?_(P1_lasttime, '32'):32, ?_(P1_durability, '32/signed'):32/signed, ?_(P1_craft, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary, ?_((length(P1_extra)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32, ?_((byte_size(P2_str)), "16"):16, ?_(P2_str, bin)/binary>> || {P2_type, P2_value, P2_str} <- P1_extra]))/binary>> || #item{id = P1_id, base_id = P1_base_id, bind = P1_bind, upgrade = P1_upgrade, enchant = P1_enchant, enchant_fail = P1_enchant_fail, quantity = P1_quantity, status = P1_status, pos = P1_pos, lasttime = P1_lasttime, durability = P1_durability, craft = P1_craft, attr = P1_attr, max_base_attr = P1_max_base_attr, extra = P1_extra} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12669:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12669), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12669:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12670), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12670:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12670), {P0_id, P0_storagetype, P0_petid, P0_lock1, P0_lock2, P0_lock3, P0_lock4, P0_lock5}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_storagetype, '8'):8, ?_(P0_petid, '32'):32, ?_(P0_lock1, '8'):8, ?_(P0_lock2, '8'):8, ?_(P0_lock3, '8'):8, ?_(P0_lock4, '8'):8, ?_(P0_lock5, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12670:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12671), {P0_flag, P0_msg, P0_petid, P0_polishlist}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_petid, '32'):32, ?_((length(P0_polishlist)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary>> || {P1_id, P1_attr} <- P0_polishlist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12671:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12671), {P0_mode, P0_id, P0_storagetype, P0_petid, P0_lock1, P0_lock2, P0_lock3, P0_lock4, P0_lock5}) ->
    D_a_t_a = <<?_(P0_mode, '8'):8, ?_(P0_id, '32'):32, ?_(P0_storagetype, '8'):8, ?_(P0_petid, '32'):32, ?_(P0_lock1, '8'):8, ?_(P0_lock2, '8'):8, ?_(P0_lock3, '8'):8, ?_(P0_lock4, '8'):8, ?_(P0_lock5, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12671:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12672), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12672:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12672), {P0_id, P0_storagetype, P0_polish_id, P0_petid}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_storagetype, '8'):8, ?_(P0_polish_id, '8'):8, ?_(P0_petid, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12672:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12673), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12673:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12673), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12673:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12674), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12674:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12674), {P0_item_id, P0_storagetype, P0_petid, P0_bind}) ->
    D_a_t_a = <<?_(P0_item_id, '32'):32, ?_(P0_storagetype, '8'):8, ?_(P0_petid, '32'):32, ?_(P0_bind, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12674:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12675), {P0_exchange_list}) ->
    D_a_t_a = <<?_((length(P0_exchange_list)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_(P1_num, '16'):16>> || {P1_base_id, P1_num} <- P0_exchange_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12675:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12675), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12675:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12676), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12676:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12676), {P0_base_id}) ->
    D_a_t_a = <<?_(P0_base_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12676:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12680), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12680:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12680), {P0_name, P0_type}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_type, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12680:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12681), {P0_rid, P0_srv_id, P0_name, P0_type}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_type, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12681:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12681), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12681:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12682), {P0_pet_rb_lists}) ->
    D_a_t_a = <<?_((length(P0_pet_rb_lists)), "16"):16, (list_to_binary([<<?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_id, '32'):32, ?_(P1_type, '8'):8, ?_(P1_value, '32'):32, ?_(P1_status, '8'):8, ?_(P1_image, '32'):32, ?_((byte_size(P1_desc)), "16"):16, ?_(P1_desc, bin)/binary, ?_(P1_card, '32'):32, ?_((length(P1_material)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_(P2_num, '32'):32>> || {P2_id, P2_num} <- P1_material]))/binary, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_label, '32'):32, ?_(P2_value, '32'):32>> || {P2_label, P2_value} <- P1_attr]))/binary>> || {P1_name, P1_id, P1_type, P1_value, P1_status, P1_image, P1_desc, P1_card, P1_material, P1_attr} <- P0_pet_rb_lists]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12682:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12682), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12682:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12683), {P0_value, P0_attr}) ->
    D_a_t_a = <<?_(P0_value, '32'):32, ?_((length(P0_attr)), "16"):16, (list_to_binary([<<?_(P1_label, '32'):32, ?_(P1_value, '32'):32>> || {P1_label, P1_value} <- P0_attr]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12683:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12683), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12683:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12684), {P0_id, P0_status}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_status, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12684:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12684), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12684:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12685), {P0_status, P0_msg}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12685:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12685), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12685:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12686), {P0_id, P0_img, P0_cards, P0_attr_cur, P0_attr_next, P0_attr_max}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_img, '32'):32, ?_((length(P0_cards)), "16"):16, (list_to_binary([<<?_(P1_baseid, '32'):32, ?_(P1_status, '8'):8, ?_(P1_img, '32'):32>> || {P1_baseid, P1_status, P1_img} <- P0_cards]))/binary, ?_((length(P0_attr_cur)), "16"):16, (list_to_binary([<<?_(P1_label, '32'):32, ?_(P1_value, '32'):32>> || {P1_label, P1_value} <- P0_attr_cur]))/binary, ?_((length(P0_attr_next)), "16"):16, (list_to_binary([<<?_(P1_label, '32'):32, ?_(P1_value, '32'):32>> || {P1_label, P1_value} <- P0_attr_next]))/binary, ?_((length(P0_attr_max)), "16"):16, (list_to_binary([<<?_(P1_label, '32'):32, ?_(P1_value, '32'):32>> || {P1_label, P1_value} <- P0_attr_max]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12686:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12686), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12686:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12687), {P0_history}) ->
    D_a_t_a = <<?_((length(P0_history)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_item_id, '32'):32, ?_((byte_size(P1_item_name)), "16"):16, ?_(P1_item_name, bin)/binary>> || {P1_rid, P1_srv_id, P1_name, P1_item_id, P1_item_name} <- P0_history]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12687:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12687), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12687:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12690), {P0_name, P0_base_id, P0_lev, P0_exp, P0_need_exp, P0_step, P0_xl, P0_tz, P0_js, P0_lq, P0_xl_val, P0_tz_val, P0_js_val, P0_lq_val, P0_xl_per, P0_tz_per, P0_js_per, P0_lq_per, P0_skill_num, P0_skill_list, P0_dmg, P0_critrate, P0_hp_max, P0_mp_max, P0_defence, P0_tenacity, P0_hitrate, P0_evasion, P0_power, P0_eqm_num, P0_eqms}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_base_id, '32'):32, ?_(P0_lev, '8'):8, ?_(P0_exp, '32'):32, ?_(P0_need_exp, '32'):32, ?_(P0_step, '8'):8, ?_(P0_xl, '16'):16, ?_(P0_tz, '16'):16, ?_(P0_js, '16'):16, ?_(P0_lq, '16'):16, ?_(P0_xl_val, '16'):16, ?_(P0_tz_val, '16'):16, ?_(P0_js_val, '16'):16, ?_(P0_lq_val, '16'):16, ?_(P0_xl_per, '8'):8, ?_(P0_tz_per, '8'):8, ?_(P0_js_per, '8'):8, ?_(P0_lq_per, '8'):8, ?_(P0_skill_num, '8'):8, ?_((length(P0_skill_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_exp, '16'):16, ?_(P1_skill_loc, '8'):8, ?_((length(P1_skill_args)), "16"):16, (list_to_binary([<<?_(P2_type, '8'):8, ?_(P2_val, '16'):16>> || {P2_type, P2_val} <- P1_skill_args]))/binary>> || {P1_id, P1_exp, P1_skill_loc, P1_skill_args} <- P0_skill_list]))/binary, ?_(P0_dmg, '32'):32, ?_(P0_critrate, '16'):16, ?_(P0_hp_max, '32'):32, ?_(P0_mp_max, '32'):32, ?_(P0_defence, '16'):16, ?_(P0_tenacity, '16'):16, ?_(P0_hitrate, '16'):16, ?_(P0_evasion, '16'):16, ?_(P0_power, '32'):32, ?_(P0_eqm_num, '16'):16, ?_((length(P0_eqms)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary>> || #item{base_id = P1_base_id, attr = P1_attr} <- P0_eqms]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12690:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12690), {P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12690:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12691), {P0_rid, P0_srv_id, P0_code, P0_msg, P0_rname, P0_petrb, P0_pet_list}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_code, '16'):16, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_((byte_size(P0_rname)), "16"):16, ?_(P0_rname, bin)/binary, ?_(P0_petrb, '32'):32, ?_((length(P0_pet_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_type, '8'):8, ?_(P1_base_id, '32'):32, ?_(P1_lev, '8'):8, ?_(P1_mod, '8'):8, ?_(P1_grow_val, '16'):16, ?_(P1_happy_val, '8'):8, ?_(P1_exp, '32'):32, ?_(P1_need_exp, '32'):32, ?_(P1_xl, '16'):16, ?_(P1_tz, '16'):16, ?_(P1_js, '16'):16, ?_(P1_lq, '16'):16, ?_(P1_xl_val, '16'):16, ?_(P1_tz_val, '16'):16, ?_(P1_js_val, '16'):16, ?_(P1_lq_val, '16'):16, ?_(P1_xl_per, '8'):8, ?_(P1_tz_per, '8'):8, ?_(P1_js_per, '8'):8, ?_(P1_lq_per, '8'):8, ?_(P1_skill_num, '8'):8, ?_((length(P1_skill_list)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_(P2_exp, '16'):16, ?_((length(P2_skill_args)), "16"):16, (list_to_binary([<<?_(P3_type, '8'):8, ?_(P3_val, '16'):16>> || {P3_type, P3_val} <- P2_skill_args]))/binary>> || {P2_id, P2_exp, P2_skill_args} <- P1_skill_list]))/binary, ?_(P1_dmg, '32'):32, ?_(P1_critrate, '16'):16, ?_(P1_hp_max, '32'):32, ?_(P1_mp_max, '32'):32, ?_(P1_defence, '16'):16, ?_(P1_tenacity, '16'):16, ?_(P1_hitrate, '16'):16, ?_(P1_evasion, '16'):16, ?_(P1_power, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_change_type, '8'):8, ?_(P1_wish_val, '16'):16, ?_(P1_eqm_num, '16'):16, ?_(P1_dmg_magic, '32'):32, ?_(P1_anti_js, '32'):32, ?_(P1_anti_attack, '32'):32, ?_(P1_anti_seal, '32'):32, ?_(P1_anti_stone, '32'):32, ?_(P1_anti_stun, '32'):32, ?_(P1_anti_sleep, '32'):32, ?_(P1_anti_taunt, '32'):32, ?_(P1_anti_silent, '32'):32, ?_(P1_anti_poison, '32'):32, ?_(P1_blood, '32'):32, ?_(P1_rebound, '32'):32, ?_(P1_resist_metal, '32'):32, ?_(P1_resist_wood, '32'):32, ?_(P1_resist_water, '32'):32, ?_(P1_resist_fire, '32'):32, ?_(P1_resist_earth, '32'):32, ?_(P1_xl_max, '16'):16, ?_(P1_tz_max, '16'):16, ?_(P1_js_max, '16'):16, ?_(P1_lq_max, '16'):16, ?_((length(P1_items)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_(P2_base_id, '32'):32, ?_(P2_bind, '8'):8, ?_(P2_upgrade, '8'):8, ?_(P2_enchant, '8/signed'):8/signed, ?_(P2_enchant_fail, '8'):8, ?_(P2_quantity, '8'):8, ?_(P2_status, '8'):8, ?_(P2_pos, '16'):16, ?_(P2_lasttime, '32'):32, ?_(P2_durability, '32/signed'):32/signed, ?_(P2_craft, '8'):8, ?_((length(P2_attr)), "16"):16, (list_to_binary([<<?_(P3_attr_name, '32'):32, ?_(P3_flag, '32'):32, ?_(P3_value, '32'):32>> || {P3_attr_name, P3_flag, P3_value} <- P2_attr]))/binary, ?_((length(P2_max_base_attr)), "16"):16, (list_to_binary([<<?_(P3_attr_name, '32'):32, ?_(P3_flag, '32'):32, ?_(P3_value, '32'):32>> || {P3_attr_name, P3_flag, P3_value} <- P2_max_base_attr]))/binary, ?_((length(P2_extra)), "16"):16, (list_to_binary([<<?_(P3_type, '16'):16, ?_(P3_value, '32'):32, ?_((byte_size(P3_str)), "16"):16, ?_(P3_str, bin)/binary>> || {P3_type, P3_value, P3_str} <- P2_extra]))/binary>> || #item{id = P2_id, base_id = P2_base_id, bind = P2_bind, upgrade = P2_upgrade, enchant = P2_enchant, enchant_fail = P2_enchant_fail, quantity = P2_quantity, status = P2_status, pos = P2_pos, lasttime = P2_lasttime, durability = P2_durability, craft = P2_craft, attr = P2_attr, max_base_attr = P2_max_base_attr, extra = P2_extra} <- P1_items]))/binary, ?_((length(P1_resist_list)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32, ?_(P2_num, '16'):16>> || {P2_base_id, P2_num} <- P1_resist_list]))/binary, ?_(P1_ascended, '8'):8, ?_(P1_ascend_num, '8'):8, ?_((length(P1_ascend_attr)), "16"):16, (list_to_binary([<<?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_flag, P2_value} <- P1_ascend_attr]))/binary, ?_((length(P1_next_ascend_attr)), "16"):16, (list_to_binary([<<?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_flag, P2_value} <- P1_next_ascend_attr]))/binary>> || {P1_id, P1_name, P1_type, P1_base_id, P1_lev, P1_mod, P1_grow_val, P1_happy_val, P1_exp, P1_need_exp, P1_xl, P1_tz, P1_js, P1_lq, P1_xl_val, P1_tz_val, P1_js_val, P1_lq_val, P1_xl_per, P1_tz_per, P1_js_per, P1_lq_per, P1_skill_num, P1_skill_list, P1_dmg, P1_critrate, P1_hp_max, P1_mp_max, P1_defence, P1_tenacity, P1_hitrate, P1_evasion, P1_power, P1_bind, P1_change_type, P1_wish_val, P1_eqm_num, P1_dmg_magic, P1_anti_js, P1_anti_attack, P1_anti_seal, P1_anti_stone, P1_anti_stun, P1_anti_sleep, P1_anti_taunt, P1_anti_silent, P1_anti_poison, P1_blood, P1_rebound, P1_resist_metal, P1_resist_wood, P1_resist_water, P1_resist_fire, P1_resist_earth, P1_xl_max, P1_tz_max, P1_js_max, P1_lq_max, P1_items, P1_resist_list, P1_ascended, P1_ascend_num, P1_ascend_attr, P1_next_ascend_attr} <- P0_pet_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12691:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12691), {P0_rid, P0_srv_id, P0_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12691:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12692), {P0_lucky, P0_devout, P0_explore_once, P0_explore_list, P0_lucky_list}) ->
    D_a_t_a = <<?_(P0_lucky, '32'):32, ?_(P0_devout, '32'):32, ?_(P0_explore_once, '32'):32, ?_((length(P0_explore_list)), "16"):16, (list_to_binary([<<?_(P1_item_id, '32'):32>> || P1_item_id <- P0_explore_list]))/binary, ?_((length(P0_lucky_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_role_name)), "16"):16, ?_(P1_role_name, bin)/binary, ?_((byte_size(P1_item_name)), "16"):16, ?_(P1_item_name, bin)/binary>> || {P1_role_name, P1_item_name} <- P0_lucky_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12692:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12692), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12692:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12693), {P0_explore_once}) ->
    D_a_t_a = <<?_(P0_explore_once, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12693:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12693), {P0_bind}) ->
    D_a_t_a = <<?_(P0_bind, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12693:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12694), {P0_explore_list}) ->
    D_a_t_a = <<?_((length(P0_explore_list)), "16"):16, (list_to_binary([<<?_(P1_item_id, '32'):32>> || P1_item_id <- P0_explore_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12694:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12694), {P0_bind}) ->
    D_a_t_a = <<?_(P0_bind, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12694:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12695), {P0_devout}) ->
    D_a_t_a = <<?_(P0_devout, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12695:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12695), {P0_item_id}) ->
    D_a_t_a = <<?_(P0_item_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12695:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12696), {P0_id, P0_exp, P0_skill_loc, P0_skill_args}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_exp, '16'):16, ?_(P0_skill_loc, '8'):8, ?_((length(P0_skill_args)), "16"):16, (list_to_binary([<<>> || [] <- P0_skill_args]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12696:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12696), {P0_skill_id, P0_id}) ->
    D_a_t_a = <<?_(P0_skill_id, '32'):32, ?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12696:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12697), {P0_item_list}) ->
    D_a_t_a = <<?_((length(P0_item_list)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32>> || P1_base_id <- P0_item_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12697:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12697), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12697:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12698), {P0_base_id}) ->
    D_a_t_a = <<?_(P0_base_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12698:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12698), {P0_base_id}) ->
    D_a_t_a = <<?_(P0_base_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12698:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 12600, _B0) ->
    {ok, {}};
unpack(cli, 12600, _B0) ->
    {P0_rename_num, _B1} = lib_proto:read_uint16(_B0),
    {P0_name, _B2} = lib_proto:read_string(_B1),
    {P0_type, _B3} = lib_proto:read_uint8(_B2),
    {P0_base_id, _B4} = lib_proto:read_uint32(_B3),
    {P0_lev, _B5} = lib_proto:read_uint8(_B4),
    {P0_exp, _B6} = lib_proto:read_uint32(_B5),
    {P0_need_exp, _B7} = lib_proto:read_uint32(_B6),
    {P0_xl, _B8} = lib_proto:read_uint16(_B7),
    {P0_tz, _B9} = lib_proto:read_uint16(_B8),
    {P0_js, _B10} = lib_proto:read_uint16(_B9),
    {P0_lq, _B11} = lib_proto:read_uint16(_B10),
    {P0_xl_val, _B12} = lib_proto:read_uint16(_B11),
    {P0_tz_val, _B13} = lib_proto:read_uint16(_B12),
    {P0_js_val, _B14} = lib_proto:read_uint16(_B13),
    {P0_lq_val, _B15} = lib_proto:read_uint16(_B14),
    {P0_step, _B16} = lib_proto:read_int8(_B15),
    {P0_xl_per, _B17} = lib_proto:read_uint8(_B16),
    {P0_tz_per, _B18} = lib_proto:read_uint8(_B17),
    {P0_js_per, _B19} = lib_proto:read_uint8(_B18),
    {P0_lq_per, _B20} = lib_proto:read_uint8(_B19),
    {P0_skill_num, _B21} = lib_proto:read_uint8(_B20),
    {P0_skill_list, _B30} = lib_proto:read_array(_B21, fun(_B22) ->
        {P1_id, _B23} = lib_proto:read_uint32(_B22),
        {P1_exp, _B24} = lib_proto:read_uint16(_B23),
        {P1_skill_loc, _B25} = lib_proto:read_uint8(_B24),
        {P1_skill_args, _B29} = lib_proto:read_array(_B25, fun(_B26) ->
            {P2_type, _B27} = lib_proto:read_uint8(_B26),
            {P2_val, _B28} = lib_proto:read_uint16(_B27),
            {[P2_type, P2_val], _B28}
        end),
        {[P1_id, P1_exp, P1_skill_loc, P1_skill_args], _B29}
    end),
    {P0_dmg, _B31} = lib_proto:read_uint32(_B30),
    {P0_critrate, _B32} = lib_proto:read_uint16(_B31),
    {P0_hp_max, _B33} = lib_proto:read_uint32(_B32),
    {P0_mp_max, _B34} = lib_proto:read_uint32(_B33),
    {P0_defence, _B35} = lib_proto:read_uint16(_B34),
    {P0_tenacity, _B36} = lib_proto:read_uint16(_B35),
    {P0_hitrate, _B37} = lib_proto:read_uint16(_B36),
    {P0_evasion, _B38} = lib_proto:read_uint16(_B37),
    {P0_power, _B39} = lib_proto:read_uint32(_B38),
    {P0_eqm_num, _B40} = lib_proto:read_uint16(_B39),
    {P0_xl_max, _B41} = lib_proto:read_uint16(_B40),
    {P0_tz_max, _B42} = lib_proto:read_uint16(_B41),
    {P0_js_max, _B43} = lib_proto:read_uint16(_B42),
    {P0_lq_max, _B44} = lib_proto:read_uint16(_B43),
    {ok, {P0_rename_num, P0_name, P0_type, P0_base_id, P0_lev, P0_exp, P0_need_exp, P0_xl, P0_tz, P0_js, P0_lq, P0_xl_val, P0_tz_val, P0_js_val, P0_lq_val, P0_step, P0_xl_per, P0_tz_per, P0_js_per, P0_lq_per, P0_skill_num, P0_skill_list, P0_dmg, P0_critrate, P0_hp_max, P0_mp_max, P0_defence, P0_tenacity, P0_hitrate, P0_evasion, P0_power, P0_eqm_num, P0_xl_max, P0_tz_max, P0_js_max, P0_lq_max}};

unpack(srv, 12604, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 12604, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_code}};

unpack(srv, 12606, _B0) ->
    {P0_name, _B1} = lib_proto:read_string(_B0),
    {ok, {P0_name}};
unpack(cli, 12606, _B0) ->
    {ok, {}};

unpack(srv, 12607, _B0) ->
    {P0_base_id, _B1} = lib_proto:read_uint16(_B0),
    {P0_name, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_base_id, P0_name}};
unpack(cli, 12607, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_code}};

unpack(srv, 12608, _B0) ->
    {ok, {}};
unpack(cli, 12608, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_code}};

unpack(srv, 12611, _B0) ->
    {P0_skill_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_skill_id}};
unpack(cli, 12611, _B0) ->
    {P0_skill_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_skill_id}};

unpack(srv, 12612, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 12612, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_exp, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_id, P0_exp}};

unpack(srv, 12613, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 12613, _B0) ->
    {P0_skill_list, _B9} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_exp, _B3} = lib_proto:read_uint16(_B2),
        {P1_skill_loc, _B4} = lib_proto:read_uint8(_B3),
        {P1_skill_args, _B8} = lib_proto:read_array(_B4, fun(_B5) ->
            {P2_type, _B6} = lib_proto:read_uint8(_B5),
            {P2_val, _B7} = lib_proto:read_uint16(_B6),
            {[P2_type, P2_val], _B7}
        end),
        {[P1_id, P1_exp, P1_skill_loc, P1_skill_args], _B8}
    end),
    {ok, {P0_skill_list}};

unpack(srv, 12615, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_is_auto, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_type, P0_is_auto}};
unpack(cli, 12615, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_val, _B2} = lib_proto:read_int16(_B1),
    {P0_step, _B3} = lib_proto:read_int8(_B2),
    {P0_avg, _B4} = lib_proto:read_int32(_B3),
    {ok, {P0_type, P0_val, P0_step, P0_avg}};

unpack(srv, 12616, _B0) ->
    {P0_auto, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_auto}};
unpack(cli, 12616, _B0) ->
    {ok, {}};

unpack(srv, 12618, _B0) ->
    {ok, {}};
unpack(cli, 12618, _B0) ->
    {P0_lev, _B1} = lib_proto:read_uint8(_B0),
    {P0_exp, _B2} = lib_proto:read_uint32(_B1),
    {P0_need_exp, _B3} = lib_proto:read_uint32(_B2),
    {P0_avg, _B4} = lib_proto:read_int32(_B3),
    {ok, {P0_lev, P0_exp, P0_need_exp, P0_avg}};

unpack(srv, 12620, _B0) ->
    {ok, {}};
unpack(cli, 12620, _B0) ->
    {P0_wash_list, _B11} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_code, _B2} = lib_proto:read_uint8(_B1),
        {P1_xl, _B3} = lib_proto:read_uint16(_B2),
        {P1_tz, _B4} = lib_proto:read_uint16(_B3),
        {P1_js, _B5} = lib_proto:read_uint16(_B4),
        {P1_lq, _B6} = lib_proto:read_uint16(_B5),
        {P1_xl_per, _B7} = lib_proto:read_uint8(_B6),
        {P1_tz_per, _B8} = lib_proto:read_uint8(_B7),
        {P1_js_per, _B9} = lib_proto:read_uint8(_B8),
        {P1_lq_per, _B10} = lib_proto:read_uint8(_B9),
        {[P1_code, P1_xl, P1_tz, P1_js, P1_lq, P1_xl_per, P1_tz_per, P1_js_per, P1_lq_per], _B10}
    end),
    {ok, {P0_wash_list}};

unpack(srv, 12621, _B0) ->
    {P0_auto, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_auto}};
unpack(cli, 12621, _B0) ->
    {P0_wash_list, _B11} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_code, _B2} = lib_proto:read_uint8(_B1),
        {P1_xl, _B3} = lib_proto:read_uint16(_B2),
        {P1_tz, _B4} = lib_proto:read_uint16(_B3),
        {P1_js, _B5} = lib_proto:read_uint16(_B4),
        {P1_lq, _B6} = lib_proto:read_uint16(_B5),
        {P1_xl_per, _B7} = lib_proto:read_uint8(_B6),
        {P1_tz_per, _B8} = lib_proto:read_uint8(_B7),
        {P1_js_per, _B9} = lib_proto:read_uint8(_B8),
        {P1_lq_per, _B10} = lib_proto:read_uint8(_B9),
        {[P1_code, P1_xl, P1_tz, P1_js, P1_lq, P1_xl_per, P1_tz_per, P1_js_per, P1_lq_per], _B10}
    end),
    {ok, {P0_wash_list}};

unpack(srv, 12622, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_code}};
unpack(cli, 12622, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_code}};

unpack(srv, 12630, _B0) ->
    {ok, {}};
unpack(cli, 12630, _B0) ->
    {P0_xl, _B1} = lib_proto:read_uint16(_B0),
    {P0_tz, _B2} = lib_proto:read_uint16(_B1),
    {P0_js, _B3} = lib_proto:read_uint16(_B2),
    {P0_lq, _B4} = lib_proto:read_uint16(_B3),
    {P0_xl_per, _B5} = lib_proto:read_uint8(_B4),
    {P0_tz_per, _B6} = lib_proto:read_uint8(_B5),
    {P0_js_per, _B7} = lib_proto:read_uint8(_B6),
    {P0_lq_per, _B8} = lib_proto:read_uint8(_B7),
    {P0_dmg, _B9} = lib_proto:read_uint32(_B8),
    {P0_critrate, _B10} = lib_proto:read_uint16(_B9),
    {P0_hp_max, _B11} = lib_proto:read_uint32(_B10),
    {P0_mp_max, _B12} = lib_proto:read_uint32(_B11),
    {P0_defence, _B13} = lib_proto:read_uint16(_B12),
    {P0_tenacity, _B14} = lib_proto:read_uint16(_B13),
    {P0_hitrate, _B15} = lib_proto:read_uint16(_B14),
    {P0_evasion, _B16} = lib_proto:read_uint16(_B15),
    {P0_power, _B17} = lib_proto:read_uint32(_B16),
    {ok, {P0_xl, P0_tz, P0_js, P0_lq, P0_xl_per, P0_tz_per, P0_js_per, P0_lq_per, P0_dmg, P0_critrate, P0_hp_max, P0_mp_max, P0_defence, P0_tenacity, P0_hitrate, P0_evasion, P0_power}};

unpack(srv, 12666, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 12666, _B0) ->
    {ok, {}};

unpack(srv, 12667, _B0) ->
    {ok, {}};
unpack(cli, 12667, _B0) ->
    {P0_items, _B12} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_base_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_attr, _B7} = lib_proto:read_array(_B2, fun(_B3) ->
            {P2_attr_name, _B4} = lib_proto:read_uint32(_B3),
            {P2_flag, _B5} = lib_proto:read_uint32(_B4),
            {P2_value, _B6} = lib_proto:read_uint32(_B5),
            {[P2_attr_name, P2_flag, P2_value], _B6}
        end),
        {P1_special, _B11} = lib_proto:read_array(_B7, fun(_B8) ->
            {P2_type, _B9} = lib_proto:read_uint16(_B8),
            {P2_value, _B10} = lib_proto:read_uint32(_B9),
            {[P2_type, P2_value], _B10}
        end),
        {[P1_base_id, P1_attr, P1_special], _B11}
    end),
    {ok, {P0_items}};

unpack(srv, 12668, _B0) ->
    {P0_base_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_base_id}};
unpack(cli, 12668, _B0) ->
    {ok, {}};

unpack(srv, 12690, _B0) ->
    {P0_rid, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_rid, P0_srv_id}};
unpack(cli, 12690, _B0) ->
    {P0_name, _B1} = lib_proto:read_string(_B0),
    {P0_base_id, _B2} = lib_proto:read_uint32(_B1),
    {P0_lev, _B3} = lib_proto:read_uint8(_B2),
    {P0_exp, _B4} = lib_proto:read_uint32(_B3),
    {P0_need_exp, _B5} = lib_proto:read_uint32(_B4),
    {P0_step, _B6} = lib_proto:read_uint8(_B5),
    {P0_xl, _B7} = lib_proto:read_uint16(_B6),
    {P0_tz, _B8} = lib_proto:read_uint16(_B7),
    {P0_js, _B9} = lib_proto:read_uint16(_B8),
    {P0_lq, _B10} = lib_proto:read_uint16(_B9),
    {P0_xl_val, _B11} = lib_proto:read_uint16(_B10),
    {P0_tz_val, _B12} = lib_proto:read_uint16(_B11),
    {P0_js_val, _B13} = lib_proto:read_uint16(_B12),
    {P0_lq_val, _B14} = lib_proto:read_uint16(_B13),
    {P0_xl_per, _B15} = lib_proto:read_uint8(_B14),
    {P0_tz_per, _B16} = lib_proto:read_uint8(_B15),
    {P0_js_per, _B17} = lib_proto:read_uint8(_B16),
    {P0_lq_per, _B18} = lib_proto:read_uint8(_B17),
    {P0_skill_num, _B19} = lib_proto:read_uint8(_B18),
    {P0_skill_list, _B28} = lib_proto:read_array(_B19, fun(_B20) ->
        {P1_id, _B21} = lib_proto:read_uint32(_B20),
        {P1_exp, _B22} = lib_proto:read_uint16(_B21),
        {P1_skill_loc, _B23} = lib_proto:read_uint8(_B22),
        {P1_skill_args, _B27} = lib_proto:read_array(_B23, fun(_B24) ->
            {P2_type, _B25} = lib_proto:read_uint8(_B24),
            {P2_val, _B26} = lib_proto:read_uint16(_B25),
            {[P2_type, P2_val], _B26}
        end),
        {[P1_id, P1_exp, P1_skill_loc, P1_skill_args], _B27}
    end),
    {P0_dmg, _B29} = lib_proto:read_uint32(_B28),
    {P0_critrate, _B30} = lib_proto:read_uint16(_B29),
    {P0_hp_max, _B31} = lib_proto:read_uint32(_B30),
    {P0_mp_max, _B32} = lib_proto:read_uint32(_B31),
    {P0_defence, _B33} = lib_proto:read_uint16(_B32),
    {P0_tenacity, _B34} = lib_proto:read_uint16(_B33),
    {P0_hitrate, _B35} = lib_proto:read_uint16(_B34),
    {P0_evasion, _B36} = lib_proto:read_uint16(_B35),
    {P0_power, _B37} = lib_proto:read_uint32(_B36),
    {P0_eqm_num, _B38} = lib_proto:read_uint16(_B37),
    {P0_eqms, _B46} = lib_proto:read_array(_B38, fun(_B39) ->
        {P1_base_id, _B40} = lib_proto:read_uint32(_B39),
        {P1_attr, _B45} = lib_proto:read_array(_B40, fun(_B41) ->
            {P2_attr_name, _B42} = lib_proto:read_uint32(_B41),
            {P2_flag, _B43} = lib_proto:read_uint32(_B42),
            {P2_value, _B44} = lib_proto:read_uint32(_B43),
            {[P2_attr_name, P2_flag, P2_value], _B44}
        end),
        {[P1_base_id, P1_attr], _B45}
    end),
    {ok, {P0_name, P0_base_id, P0_lev, P0_exp, P0_need_exp, P0_step, P0_xl, P0_tz, P0_js, P0_lq, P0_xl_val, P0_tz_val, P0_js_val, P0_lq_val, P0_xl_per, P0_tz_per, P0_js_per, P0_lq_per, P0_skill_num, P0_skill_list, P0_dmg, P0_critrate, P0_hp_max, P0_mp_max, P0_defence, P0_tenacity, P0_hitrate, P0_evasion, P0_power, P0_eqm_num, P0_eqms}};

unpack(srv, 12692, _B0) ->
    {ok, {}};
unpack(cli, 12692, _B0) ->
    {P0_lucky, _B1} = lib_proto:read_uint32(_B0),
    {P0_devout, _B2} = lib_proto:read_uint32(_B1),
    {P0_explore_once, _B3} = lib_proto:read_uint32(_B2),
    {P0_explore_list, _B6} = lib_proto:read_array(_B3, fun(_B4) ->
        {P1_item_id, _B5} = lib_proto:read_uint32(_B4),
        {P1_item_id, _B5}
    end),
    {P0_lucky_list, _B10} = lib_proto:read_array(_B6, fun(_B7) ->
        {P1_role_name, _B8} = lib_proto:read_string(_B7),
        {P1_item_name, _B9} = lib_proto:read_string(_B8),
        {[P1_role_name, P1_item_name], _B9}
    end),
    {ok, {P0_lucky, P0_devout, P0_explore_once, P0_explore_list, P0_lucky_list}};

unpack(srv, 12693, _B0) ->
    {P0_bind, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_bind}};
unpack(cli, 12693, _B0) ->
    {P0_explore_once, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_explore_once}};

unpack(srv, 12694, _B0) ->
    {P0_bind, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_bind}};
unpack(cli, 12694, _B0) ->
    {P0_explore_list, _B3} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_item_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_item_id, _B2}
    end),
    {ok, {P0_explore_list}};

unpack(srv, 12695, _B0) ->
    {P0_item_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_item_id}};
unpack(cli, 12695, _B0) ->
    {P0_devout, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_devout}};

unpack(srv, 12696, _B0) ->
    {P0_skill_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_id, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_skill_id, P0_id}};
unpack(cli, 12696, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_exp, _B2} = lib_proto:read_uint16(_B1),
    {P0_skill_loc, _B3} = lib_proto:read_uint8(_B2),
    {P0_skill_args, _B5} = lib_proto:read_array(_B3, fun(_B4) ->
        {[], _B4}
    end),
    {ok, {P0_id, P0_exp, P0_skill_loc, P0_skill_args}};

unpack(srv, 12697, _B0) ->
    {ok, {}};
unpack(cli, 12697, _B0) ->
    {P0_item_list, _B3} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_base_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_base_id, _B2}
    end),
    {ok, {P0_item_list}};

unpack(srv, 12698, _B0) ->
    {P0_base_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_base_id}};
unpack(cli, 12698, _B0) ->
    {P0_base_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_base_id}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
