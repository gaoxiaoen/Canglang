%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_160).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("center.hrl").
-include("item.hrl").
-include("attr.hrl").
-include("rank.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(16000), {P0_can_open, P0_status}) ->
    D_a_t_a = <<?_(P0_can_open, '8'):8, ?_(P0_status, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16000:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16000), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16000:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16001), {P0_type, P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16001:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16001), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16001:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16002), {P0_oper, P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_oper, '8'):8, ?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16002:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16002), {P0_oper}) ->
    D_a_t_a = <<?_(P0_oper, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16002:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16003), {P0_prepare_time, P0_teammates, P0_opponents, P0_gain_lilian, P0_gain_section_mark, P0_lineup_list, P0_cur_lineup_id, P0_total_power, P0_more_power, P0_group, P0_group_msg}) ->
    D_a_t_a = <<?_(P0_prepare_time, '32'):32, ?_((length(P0_teammates)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_role_power, '32'):32, ?_(P1_pet_power, '32'):32, ?_(P1_section_lev, '16'):16, ?_(P1_section_mark, '32'):32>> || {P1_id, P1_srv_id, P1_name, P1_career, P1_role_power, P1_pet_power, P1_section_lev, P1_section_mark} <- P0_teammates]))/binary, ?_((length(P0_opponents)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_role_power, '32'):32, ?_(P1_pet_power, '32'):32, ?_(P1_section_lev, '16'):16, ?_(P1_section_mark, '32'):32>> || {P1_id, P1_srv_id, P1_name, P1_career, P1_role_power, P1_pet_power, P1_section_lev, P1_section_mark} <- P0_opponents]))/binary, ?_((length(P0_gain_lilian)), "16"):16, (list_to_binary([<<?_(P1_combat_result, '8'):8, ?_(P1_lilian, '32'):32, ?_(P1_addt_lilian, '32'):32>> || {P1_combat_result, P1_lilian, P1_addt_lilian} <- P0_gain_lilian]))/binary, ?_((length(P0_gain_section_mark)), "16"):16, (list_to_binary([<<?_(P1_combat_result, '8'):8, ?_(P1_mark, '32/signed'):32/signed>> || {P1_combat_result, P1_mark} <- P0_gain_section_mark]))/binary, ?_((length(P0_lineup_list)), "16"):16, (list_to_binary([<<?_(P1_lineup_id, '32'):32>> || P1_lineup_id <- P0_lineup_list]))/binary, ?_(P0_cur_lineup_id, '32'):32, ?_(P0_total_power, '32'):32, ?_(P0_more_power, '32'):32, ?_(P0_group, '8'):8, ?_((byte_size(P0_group_msg)), "16"):16, ?_(P0_group_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16003:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16003), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16003:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16004), {P0_result, P0_rewards, P0_waiting_time}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((length(P0_rewards)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_item_id, '32/signed'):32/signed, ?_(P1_num, '32/signed'):32/signed>> || {P1_type, P1_item_id, P1_num} <- P0_rewards]))/binary, ?_(P0_waiting_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16004:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16004), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16004:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16005), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16005:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16005), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16005:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16006), {P0_signup_counts}) ->
    D_a_t_a = <<?_((length(P0_signup_counts)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_count, '8'):8>> || {P1_type, P1_count} <- P0_signup_counts]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16006:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16006), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16006:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16010), {P0_medal_lev, P0_join_cnt, P0_win_cnt, P0_loss_cnt, P0_ko_cnt, P0_win_rate, P0_win_c_cnt, P0_lilian, P0_group, P0_win_top_power, P0_section_lev, P0_section_mark, P0_section_mark_next, P0_day_lilian, P0_day_attainment, P0_day_reward_flag}) ->
    D_a_t_a = <<?_(P0_medal_lev, '16'):16, ?_(P0_join_cnt, '32'):32, ?_(P0_win_cnt, '32'):32, ?_(P0_loss_cnt, '32'):32, ?_(P0_ko_cnt, '32'):32, ?_(P0_win_rate, '16'):16, ?_(P0_win_c_cnt, '16'):16, ?_(P0_lilian, '32'):32, ?_(P0_group, '8'):8, ?_(P0_win_top_power, '32'):32, ?_(P0_section_lev, '16'):16, ?_(P0_section_mark, '32'):32, ?_(P0_section_mark_next, '32'):32, ?_(P0_day_lilian, '32'):32, ?_(P0_day_attainment, '32'):32, ?_(P0_day_reward_flag, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16010:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16010), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16010:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16011), {P0_id, P0_srv_id, P0_medal_lev, P0_join_cnt, P0_win_cnt, P0_loss_cnt, P0_ko_cnt, P0_win_rate, P0_win_c_cnt, P0_lilian, P0_group, P0_win_top_power, P0_section_lev, P0_section_mark, P0_section_mark_next}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_medal_lev, '16'):16, ?_(P0_join_cnt, '32'):32, ?_(P0_win_cnt, '32'):32, ?_(P0_loss_cnt, '32'):32, ?_(P0_ko_cnt, '32'):32, ?_(P0_win_rate, '16'):16, ?_(P0_win_c_cnt, '16'):16, ?_(P0_lilian, '32'):32, ?_(P0_group, '8'):8, ?_(P0_win_top_power, '32'):32, ?_(P0_section_lev, '16'):16, ?_(P0_section_mark, '32'):32, ?_(P0_section_mark_next, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16011:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16011), {P0_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16011:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16012), {P0_mark_today, P0_mvp_today, P0_mvp_yesterday}) ->
    D_a_t_a = <<?_((length(P0_mark_today)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_win_count, '32'):32, ?_(P1_role_power, '32'):32, ?_(P1_pet_power, '32'):32>> || #rank_world_compete_win_day{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, win_count = P1_win_count, role_power = P1_role_power, pet_power = P1_pet_power} <- P0_mark_today]))/binary, ?_((length(P0_mvp_today)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_win_count, '32'):32, ?_(P1_role_power, '32'):32, ?_(P1_pet_power, '32'):32, ?_((length(P1_eqm)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_(P2_base_id, '32'):32, ?_(P2_bind, '8'):8, ?_(P2_upgrade, '8'):8, ?_(P2_enchant, '8/signed'):8/signed, ?_(P2_enchant_fail, '8'):8, ?_(P2_pos, '16'):16, ?_(P2_lasttime, '32'):32, ?_(P2_durability, '32/signed'):32/signed, ?_(P2_craft, '8'):8, ?_((length(P2_attr)), "16"):16, (list_to_binary([<<?_(P3_attr_name, '32'):32, ?_(P3_flag, '32'):32, ?_(P3_value, '32'):32>> || {P3_attr_name, P3_flag, P3_value} <- P2_attr]))/binary, ?_((length(P2_max_base_attr)), "16"):16, (list_to_binary([<<?_(P3_attr_name, '32'):32, ?_(P3_flag, '32'):32, ?_(P3_value, '32'):32>> || {P3_attr_name, P3_flag, P3_value} <- P2_max_base_attr]))/binary, ?_((length(P2_extra)), "16"):16, (list_to_binary([<<?_(P3_type, '16'):16, ?_(P3_value, '32'):32, ?_((byte_size(P3_str)), "16"):16, ?_(P3_str, bin)/binary>> || {P3_type, P3_value, P3_str} <- P2_extra]))/binary>> || #item{id = P2_id, base_id = P2_base_id, bind = P2_bind, upgrade = P2_upgrade, enchant = P2_enchant, enchant_fail = P2_enchant_fail, pos = P2_pos, lasttime = P2_lasttime, durability = P2_durability, craft = P2_craft, attr = P2_attr, max_base_attr = P2_max_base_attr, extra = P2_extra} <- P1_eqm]))/binary, ?_((length(P1_looks)), "16"):16, (list_to_binary([<<?_(P2_looks_type, '8'):8, ?_(P2_looks_id, '32'):32, ?_(P2_looks_value, '16'):16>> || {P2_looks_type, P2_looks_id, P2_looks_value} <- P1_looks]))/binary>> || #rank_world_compete_win_day{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, career = P1_career, sex = P1_sex, lev = P1_lev, win_count = P1_win_count, role_power = P1_role_power, pet_power = P1_pet_power, eqm = P1_eqm, looks = P1_looks} <- P0_mvp_today]))/binary, ?_((length(P0_mvp_yesterday)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_win_count, '32'):32, ?_(P1_role_power, '32'):32, ?_(P1_pet_power, '32'):32, ?_((length(P1_eqm)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_(P2_base_id, '32'):32, ?_(P2_bind, '8'):8, ?_(P2_upgrade, '8'):8, ?_(P2_enchant, '8/signed'):8/signed, ?_(P2_enchant_fail, '8'):8, ?_(P2_pos, '16'):16, ?_(P2_lasttime, '32'):32, ?_(P2_durability, '32/signed'):32/signed, ?_(P2_craft, '8'):8, ?_((length(P2_attr)), "16"):16, (list_to_binary([<<?_(P3_attr_name, '32'):32, ?_(P3_flag, '32'):32, ?_(P3_value, '32'):32>> || {P3_attr_name, P3_flag, P3_value} <- P2_attr]))/binary, ?_((length(P2_max_base_attr)), "16"):16, (list_to_binary([<<?_(P3_attr_name, '32'):32, ?_(P3_flag, '32'):32, ?_(P3_value, '32'):32>> || {P3_attr_name, P3_flag, P3_value} <- P2_max_base_attr]))/binary, ?_((length(P2_extra)), "16"):16, (list_to_binary([<<?_(P3_type, '16'):16, ?_(P3_value, '32'):32, ?_((byte_size(P3_str)), "16"):16, ?_(P3_str, bin)/binary>> || {P3_type, P3_value, P3_str} <- P2_extra]))/binary>> || #item{id = P2_id, base_id = P2_base_id, bind = P2_bind, upgrade = P2_upgrade, enchant = P2_enchant, enchant_fail = P2_enchant_fail, pos = P2_pos, lasttime = P2_lasttime, durability = P2_durability, craft = P2_craft, attr = P2_attr, max_base_attr = P2_max_base_attr, extra = P2_extra} <- P1_eqm]))/binary, ?_((length(P1_looks)), "16"):16, (list_to_binary([<<?_(P2_looks_type, '8'):8, ?_(P2_looks_id, '32'):32, ?_(P2_looks_value, '16'):16>> || {P2_looks_type, P2_looks_id, P2_looks_value} <- P1_looks]))/binary>> || #rank_world_compete_win_day{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, career = P1_career, sex = P1_sex, lev = P1_lev, win_count = P1_win_count, role_power = P1_role_power, pet_power = P1_pet_power, eqm = P1_eqm, looks = P1_looks} <- P0_mvp_yesterday]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16012:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16012), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16012:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16013), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16013:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16013), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16013:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16014), {P0_flag, P0_msg, P0_lineup}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_lineup, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16014:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16014), {P0_lineup}) ->
    D_a_t_a = <<?_(P0_lineup, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16014:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16015), {P0_day_reward_flag}) ->
    D_a_t_a = <<?_(P0_day_reward_flag, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16015:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16015), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16015:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
