%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_181).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("cross_warlord.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(18100), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18100:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18100), {P0_room_id}) ->
    D_a_t_a = <<?_(P0_room_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18100:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18101), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18101:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18101), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18101:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18102), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18102:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18102), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18102:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18103), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18103:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18103), {P0_msg}) ->
    D_a_t_a = <<?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18103:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18104), {P0_type, P0_time, P0_team_info, P0_ready_list, P0_point}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_time, '32'):32, ?_((length(P0_team_info)), "16"):16, (list_to_binary([<<?_(P1_team_code, '32'):32, ?_((byte_size(P1_team_name)), "16"):16, ?_(P1_team_name, bin)/binary, ?_(P1_lineup_id, '32'):32, ?_((length(P1_lineup_list)), "16"):16, (list_to_binary([<<?_(P2_lineup_id, '32'):32>> || P2_lineup_id <- P1_lineup_list]))/binary, ?_((length(P1_team_member)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_((byte_size(P2_srv_id)), "16"):16, ?_(P2_srv_id, bin)/binary, ?_((byte_size(P2_name)), "16"):16, ?_(P2_name, bin)/binary, ?_(P2_career, '8'):8, ?_(P2_fight_capacity, '32'):32, ?_(P2_pet_fight, '32'):32>> || {P2_id, P2_srv_id, P2_name, P2_career, P2_fight_capacity, P2_pet_fight} <- P1_team_member]))/binary>> || {P1_team_code, P1_team_name, P1_lineup_id, P1_lineup_list, P1_team_member} <- P0_team_info]))/binary, ?_((length(P0_ready_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary>> || {P1_id, P1_srv_id} <- P0_ready_list]))/binary, ?_((length(P0_point)), "16"):16, (list_to_binary([<<?_(P1_team_code, '32'):32, ?_(P1_value, '8'):8>> || {P1_team_code, P1_value} <- P0_point]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18104:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18104), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18104:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18105), {P0_team_info, P0_team_code, P0_team_name, P0_team_srv_id, P0_team_member}) ->
    D_a_t_a = <<?_((length(P0_team_info)), "16"):16, (list_to_binary([<<?_(P1_team_code, '32'):32, ?_(P1_team_trial_code, '32'):32, ?_((byte_size(P1_team_name)), "16"):16, ?_(P1_team_name, bin)/binary, ?_((byte_size(P1_team_srv_id)), "16"):16, ?_(P1_team_srv_id, bin)/binary, ?_(P1_team_quality, '16'):16>> || {P1_team_code, P1_team_trial_code, P1_team_name, P1_team_srv_id, P1_team_quality} <- P0_team_info]))/binary, ?_(P0_team_code, '32'):32, ?_((byte_size(P0_team_name)), "16"):16, ?_(P0_team_name, bin)/binary, ?_((byte_size(P0_team_srv_id)), "16"):16, ?_(P0_team_srv_id, bin)/binary, ?_((length(P0_team_member)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_face_id, '32'):32>> || {P1_id, P1_srv_id, P1_name, P1_face_id} <- P0_team_member]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18105:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18105), {P0_zone_seq, P0_label}) ->
    D_a_t_a = <<?_(P0_zone_seq, '16'):16, ?_(P0_label, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18105:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18106), {P0_zone_seq, P0_label}) ->
    D_a_t_a = <<?_(P0_zone_seq, '16'):16, ?_(P0_label, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18106:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18106), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18106:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18107), {P0_team_name, P0_team_member}) ->
    D_a_t_a = <<?_((byte_size(P0_team_name)), "16"):16, ?_(P0_team_name, bin)/binary, ?_((length(P0_team_member)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_lev, '16'):16, ?_(P1_vip, '8'):8, ?_(P1_fight_capacity, '32'):32, ?_(P1_pet_fight, '32'):32, ?_((length(P1_looks)), "16"):16, (list_to_binary([<<?_(P2_looks_type, '8'):8, ?_(P2_looks_id, '32'):32, ?_(P2_looks_value, '16'):16>> || {P2_looks_type, P2_looks_id, P2_looks_value} <- P1_looks]))/binary>> || {P1_id, P1_srv_id, P1_name, P1_career, P1_sex, P1_lev, P1_vip, P1_fight_capacity, P1_pet_fight, P1_looks} <- P0_team_member]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18107:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18107), {P0_team_code}) ->
    D_a_t_a = <<?_(P0_team_code, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18107:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18108), {P0_state_lev, P0_flag, P0_last_team_name, P0_last_team_srv_id, P0_team_info, P0_team_code, P0_team_name, P0_team_srv_id, P0_team_member}) ->
    D_a_t_a = <<?_(P0_state_lev, '16'):16, ?_(P0_flag, '8'):8, ?_((byte_size(P0_last_team_name)), "16"):16, ?_(P0_last_team_name, bin)/binary, ?_((byte_size(P0_last_team_srv_id)), "16"):16, ?_(P0_last_team_srv_id, bin)/binary, ?_((length(P0_team_info)), "16"):16, (list_to_binary([<<?_(P1_team_code, '32'):32, ?_(P1_team_32code, '16'):16, ?_((byte_size(P1_team_name)), "16"):16, ?_(P1_team_name, bin)/binary, ?_((byte_size(P1_team_srv_id)), "16"):16, ?_(P1_team_srv_id, bin)/binary, ?_(P1_team_quality, '16'):16>> || {P1_team_code, P1_team_32code, P1_team_name, P1_team_srv_id, P1_team_quality} <- P0_team_info]))/binary, ?_(P0_team_code, '32'):32, ?_((byte_size(P0_team_name)), "16"):16, ?_(P0_team_name, bin)/binary, ?_((byte_size(P0_team_srv_id)), "16"):16, ?_(P0_team_srv_id, bin)/binary, ?_((length(P0_team_member)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_face_id, '32'):32>> || {P1_id, P1_srv_id, P1_name, P1_face_id} <- P0_team_member]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18108:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18108), {P0_label}) ->
    D_a_t_a = <<?_(P0_label, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18108:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18109), {P0_team_name, P0_team_member}) ->
    D_a_t_a = <<?_((byte_size(P0_team_name)), "16"):16, ?_(P0_team_name, bin)/binary, ?_((length(P0_team_member)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_(P1_lev, '16'):16, ?_(P1_vip, '8'):8, ?_(P1_fight_capacity, '32'):32, ?_(P1_pet_fight, '32'):32, ?_((length(P1_looks)), "16"):16, (list_to_binary([<<?_(P2_looks_type, '8'):8, ?_(P2_looks_id, '32'):32, ?_(P2_looks_value, '16'):16>> || {P2_looks_type, P2_looks_id, P2_looks_value} <- P1_looks]))/binary>> || {P1_id, P1_srv_id, P1_name, P1_career, P1_sex, P1_lev, P1_vip, P1_fight_capacity, P1_pet_fight, P1_looks} <- P0_team_member]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18109:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18109), {P0_label}) ->
    D_a_t_a = <<?_(P0_label, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18109:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18110), {P0_type, P0_time}) ->
    D_a_t_a = <<?_(P0_type, '16'):16, ?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18110:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18110), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18110:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18111), {P0_time, P0_team_info, P0_point}) ->
    D_a_t_a = <<?_(P0_time, '32'):32, ?_((length(P0_team_info)), "16"):16, (list_to_binary([<<?_(P1_flag, '32'):32, ?_(P1_team_code, '32'):32, ?_((byte_size(P1_team_name)), "16"):16, ?_(P1_team_name, bin)/binary, ?_((length(P1_team_member)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_((byte_size(P2_srv_id)), "16"):16, ?_(P2_srv_id, bin)/binary>> || {P2_id, P2_srv_id} <- P1_team_member]))/binary>> || {P1_flag, P1_team_code, P1_team_name, P1_team_member} <- P0_team_info]))/binary, ?_((length(P0_point)), "16"):16, (list_to_binary([<<?_(P1_team_code, '32'):32, ?_(P1_value, '8'):8>> || {P1_team_code, P1_value} <- P0_point]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18111:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18111), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18111:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18112), {P0_flag, P0_type1, P0_time1, P0_type2, P0_time2}) ->
    D_a_t_a = <<?_(P0_flag, '16'):16, ?_(P0_type1, '16'):16, ?_(P0_time1, '32'):32, ?_(P0_type2, '16'):16, ?_(P0_time2, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18112:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18112), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18112:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18113), {P0_room}) ->
    D_a_t_a = <<?_((length(P0_room)), "16"):16, (list_to_binary([<<?_(P1_team_code, '32'):32, ?_(P1_value, '8'):8>> || {P1_team_code, P1_value} <- P0_room]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18113:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18113), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18113:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18114), {P0_logs}) ->
    D_a_t_a = <<?_((length(P0_logs)), "16"):16, (list_to_binary([<<?_(P1_war_quality, '16'):16, ?_(P1_ctime, '32'):32, ?_((length(P1_rival)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_((byte_size(P2_srv_id)), "16"):16, ?_(P2_srv_id, bin)/binary, ?_((byte_size(P2_name)), "16"):16, ?_(P2_name, bin)/binary>> || {P2_id, P2_srv_id, P2_name} <- P1_rival]))/binary, ?_(P1_point, '8'):8, ?_(P1_rival_point, '8'):8>> || #cross_warlord_log{war_quality = P1_war_quality, ctime = P1_ctime, rival = P1_rival, point = P1_point, rival_point = P1_rival_point} <- P0_logs]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18114:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18114), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18114:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18115), {P0_flag, P0_rank, P0_team_name, P0_team_info}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_(P0_rank, '16'):16, ?_((byte_size(P0_team_name)), "16"):16, ?_(P0_team_name, bin)/binary, ?_((length(P0_team_info)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '16'):16, ?_(P1_career, '8'):8, ?_(P1_fight_capacity, '32'):32, ?_(P1_pet_fight, '32'):32>> || {P1_id, P1_srv_id, P1_name, P1_lev, P1_career, P1_fight_capacity, P1_pet_fight} <- P0_team_info]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18115:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18115), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18115:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18116), {P0_page_idx, P0_total_page, P0_all_rank}) ->
    D_a_t_a = <<?_(P0_page_idx, '32'):32, ?_(P0_total_page, '32'):32, ?_((length(P0_all_rank)), "16"):16, (list_to_binary([<<?_((byte_size(P1_team_name)), "16"):16, ?_(P1_team_name, bin)/binary, ?_(P1_team_rank, '32'):32, ?_((length(P1_team_member)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_((byte_size(P2_srv_id)), "16"):16, ?_(P2_srv_id, bin)/binary, ?_((byte_size(P2_name)), "16"):16, ?_(P2_name, bin)/binary>> || {P2_id, P2_srv_id, P2_name} <- P1_team_member]))/binary>> || #cross_warlord_rank{team_name = P1_team_name, team_rank = P1_team_rank, team_member = P1_team_member} <- P0_all_rank]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18116:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18116), {P0_flag}) ->
    D_a_t_a = <<?_(P0_flag, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18116:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18117), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18117:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18117), {P0_label, P0_seq, P0_team_code, P0_coin}) ->
    D_a_t_a = <<?_(P0_label, '8'):8, ?_(P0_seq, '8'):8, ?_(P0_team_code, '32'):32, ?_(P0_coin, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18117:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18118), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18118:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18118), {P0_label, P0_team_code1, P0_team_code2, P0_team_code3, P0_coin}) ->
    D_a_t_a = <<?_(P0_label, '8'):8, ?_(P0_team_code1, '32'):32, ?_(P0_team_code2, '32'):32, ?_(P0_team_code3, '32'):32, ?_(P0_coin, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18118:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18119), {P0_bets}) ->
    D_a_t_a = <<?_((length(P0_bets)), "16"):16, (list_to_binary([<<?_(P1_quality, '8'):8, ?_(P1_seq, '8'):8, ?_(P1_team_code1, '32'):32, ?_((byte_size(P1_team_name1)), "16"):16, ?_(P1_team_name1, bin)/binary, ?_(P1_team_rate1, '16'):16, ?_((length(P1_team_info1)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_((byte_size(P2_srv_id)), "16"):16, ?_(P2_srv_id, bin)/binary, ?_((byte_size(P2_name)), "16"):16, ?_(P2_name, bin)/binary, ?_(P2_career, '8'):8, ?_(P2_fightcapacity, '32'):32, ?_(P2_petfight, '32'):32>> || {P2_id, P2_srv_id, P2_name, P2_career, P2_fightcapacity, P2_petfight} <- P1_team_info1]))/binary, ?_(P1_team_code2, '32'):32, ?_((byte_size(P1_team_name2)), "16"):16, ?_(P1_team_name2, bin)/binary, ?_(P1_team_rate2, '16'):16, ?_((length(P1_team_info2)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_((byte_size(P2_srv_id)), "16"):16, ?_(P2_srv_id, bin)/binary, ?_((byte_size(P2_name)), "16"):16, ?_(P2_name, bin)/binary, ?_(P2_career, '8'):8, ?_(P2_fightcapacity, '32'):32, ?_(P2_petfight, '32'):32>> || {P2_id, P2_srv_id, P2_name, P2_career, P2_fightcapacity, P2_petfight} <- P1_team_info2]))/binary>> || {P1_quality, P1_seq, P1_team_code1, P1_team_name1, P1_team_rate1, P1_team_info1, P1_team_code2, P1_team_name2, P1_team_rate2, P1_team_info2} <- P0_bets]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18119:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18119), {P0_label}) ->
    D_a_t_a = <<?_(P0_label, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18119:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18120), {P0_teamlist}) ->
    D_a_t_a = <<?_((length(P0_teamlist)), "16"):16, (list_to_binary([<<?_(P1_team_code, '32'):32, ?_((byte_size(P1_team_name)), "16"):16, ?_(P1_team_name, bin)/binary>> || {P1_team_code, P1_team_name} <- P0_teamlist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18120:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18120), {P0_label}) ->
    D_a_t_a = <<?_(P0_label, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18120:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18121), {P0_bets1, P0_bets2, P0_bets3}) ->
    D_a_t_a = <<?_((length(P0_bets1)), "16"):16, (list_to_binary([<<?_(P1_label, '8'):8, ?_(P1_team_code1, '32'):32, ?_((byte_size(P1_team_name1)), "16"):16, ?_(P1_team_name1, bin)/binary, ?_(P1_team_code2, '32'):32, ?_((byte_size(P1_team_name2)), "16"):16, ?_(P1_team_name2, bin)/binary, ?_(P1_team_code3, '32'):32, ?_((byte_size(P1_team_name3)), "16"):16, ?_(P1_team_name3, bin)/binary, ?_(P1_coin, '32'):32, ?_(P1_wincoin, '32'):32>> || {P1_label, P1_team_code1, P1_team_name1, P1_team_code2, P1_team_name2, P1_team_code3, P1_team_name3, P1_coin, P1_wincoin} <- P0_bets1]))/binary, ?_((length(P0_bets2)), "16"):16, (list_to_binary([<<?_(P1_quality, '8'):8, ?_(P1_label, '8'):8, ?_(P1_seq, '8'):8, ?_((byte_size(P1_team_name1)), "16"):16, ?_(P1_team_name1, bin)/binary, ?_((byte_size(P1_team_name2)), "16"):16, ?_(P1_team_name2, bin)/binary, ?_(P1_team_code, '32'):32, ?_((byte_size(P1_team_name3)), "16"):16, ?_(P1_team_name3, bin)/binary, ?_(P1_coin, '32'):32, ?_(P1_rate, '16'):16, ?_(P1_wincoin, '32'):32>> || {P1_quality, P1_label, P1_seq, P1_team_name1, P1_team_name2, P1_team_code, P1_team_name3, P1_coin, P1_rate, P1_wincoin} <- P0_bets2]))/binary, ?_((length(P0_bets3)), "16"):16, (list_to_binary([<<?_(P1_label, '8'):8, ?_((length(P1_bet_teams)), "16"):16, (list_to_binary([<<?_(P2_seq, '8'):8, ?_(P2_team_code, '32'):32, ?_((byte_size(P2_team_name)), "16"):16, ?_(P2_team_name, bin)/binary>> || {P2_seq, P2_team_code, P2_team_name} <- P1_bet_teams]))/binary, ?_(P1_coin, '32'):32, ?_(P1_wincoin, '32'):32>> || {P1_label, P1_bet_teams, P1_coin, P1_wincoin} <- P0_bets3]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18121:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18121), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18121:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18122), {P0_bet_switch}) ->
    D_a_t_a = <<?_(P0_bet_switch, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18122:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18122), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18122:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18123), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18123:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18123), {P0_ready}) ->
    D_a_t_a = <<?_(P0_ready, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18123:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18124), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18124:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18124), {P0_lineup}) ->
    D_a_t_a = <<?_(P0_lineup, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18124:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18125), {P0_bets}) ->
    D_a_t_a = <<?_((length(P0_bets)), "16"):16, (list_to_binary([<<?_(P1_seq, '8'):8, ?_(P1_team_code1, '32'):32, ?_((byte_size(P1_team_name1)), "16"):16, ?_(P1_team_name1, bin)/binary, ?_(P1_team_code2, '32'):32, ?_((byte_size(P1_team_name2)), "16"):16, ?_(P1_team_name2, bin)/binary>> || {P1_seq, P1_team_code1, P1_team_name1, P1_team_code2, P1_team_name2} <- P0_bets]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18125:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18125), {P0_label}) ->
    D_a_t_a = <<?_(P0_label, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18125:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18126), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18126:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18126), {P0_label, P0_team_code1, P0_team_code2, P0_team_code3, P0_team_code4, P0_team_code5, P0_team_code6, P0_team_code7, P0_team_code8, P0_team_code9, P0_team_code10, P0_team_code11, P0_team_code12, P0_team_code13, P0_team_code14, P0_team_code15, P0_team_code16, P0_coin}) ->
    D_a_t_a = <<?_(P0_label, '8'):8, ?_(P0_team_code1, '32'):32, ?_(P0_team_code2, '32'):32, ?_(P0_team_code3, '32'):32, ?_(P0_team_code4, '32'):32, ?_(P0_team_code5, '32'):32, ?_(P0_team_code6, '32'):32, ?_(P0_team_code7, '32'):32, ?_(P0_team_code8, '32'):32, ?_(P0_team_code9, '32'):32, ?_(P0_team_code10, '32'):32, ?_(P0_team_code11, '32'):32, ?_(P0_team_code12, '32'):32, ?_(P0_team_code13, '32'):32, ?_(P0_team_code14, '32'):32, ?_(P0_team_code15, '32'):32, ?_(P0_team_code16, '32'):32, ?_(P0_coin, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18126:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18127), {P0_bets}) ->
    D_a_t_a = <<?_((length(P0_bets)), "16"):16, (list_to_binary([<<?_(P1_quality, '8'):8, ?_(P1_seq, '8'):8>> || {P1_quality, P1_seq} <- P0_bets]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18127:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18127), {P0_label}) ->
    D_a_t_a = <<?_(P0_label, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18127:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(18128), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18128:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(18128), {P0_label, P0_quality, P0_seq}) ->
    D_a_t_a = <<?_(P0_label, '8'):8, ?_(P0_quality, '8'):8, ?_(P0_seq, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 18128:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
