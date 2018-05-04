%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_130).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("achievement.hrl").
-include("item.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(13000), {P0_val, P0_target_list}) ->
    D_a_t_a = <<?_(P0_val, '32'):32, ?_((length(P0_target_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_status, '8'):8, ?_(P1_value, '32'):32>> || {P1_id, P1_status, P1_value} <- P0_target_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13000:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13000), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13000:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13001), {P0_use_list, P0_name_list}) ->
    D_a_t_a = <<?_((length(P0_use_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32>> || P1_id <- P0_use_list]))/binary, ?_((length(P0_name_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_time, '32'):32>> || {P1_id, P1_name, P1_time} <- P0_name_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13001:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13001), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13001:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13002), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13002:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13002), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13002:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13003), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13003:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13003), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13003:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13004), {P0_id, P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13004:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13004), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13004:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13005), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13005:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13005), {P0_id, P0_name}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13005:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13011), {P0_val, P0_id, P0_status, P0_value}) ->
    D_a_t_a = <<?_(P0_val, '32'):32, ?_(P0_id, '32'):32, ?_(P0_status, '8'):8, ?_(P0_value, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13011:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13011), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13011:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13012), {P0_target_list}) ->
    D_a_t_a = <<?_((length(P0_target_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_status, '8'):8, ?_(P1_value, '32'):32>> || {P1_id, P1_status, P1_value} <- P0_target_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13012:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13012), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13012:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13020), {P0_target_list}) ->
    D_a_t_a = <<?_((length(P0_target_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_status, '8'):8>> || {P1_id, P1_status} <- P0_target_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13020:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13020), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13020:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13021), {P0_id, P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13021:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13021), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13021:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13022), {P0_id, P0_status}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_status, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13022:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13022), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13022:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13050), {P0_rewarded, P0_target_list}) ->
    D_a_t_a = <<?_(P0_rewarded, '8'):8, ?_((length(P0_target_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_status, '8'):8>> || {P1_id, P1_status} <- P0_target_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13050:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13050), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13050:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13051), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13051:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13051), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13051:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13052), {P0_id, P0_status}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_status, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13052:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13052), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13052:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13053), {P0_target_list}) ->
    D_a_t_a = <<?_((length(P0_target_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_status, '8'):8, ?_(P1_expire, '32'):32>> || {P1_id, P1_status, P1_expire} <- P0_target_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13053:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13053), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13053:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13054), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13054:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13054), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13054:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13060), {P0_cur_medal_id, P0_cur_rep, P0_need_rep, P0_gain, P0_page_index, P0_cond}) ->
    D_a_t_a = <<?_(P0_cur_medal_id, '32'):32, ?_(P0_cur_rep, '16'):16, ?_(P0_need_rep, '16'):16, ?_((length(P0_gain)), "16"):16, (list_to_binary([<<?_(P1_cur_medal_id, '32'):32>> || P1_cur_medal_id <- P0_gain]))/binary, ?_(P0_page_index, '8'):8, ?_((length(P0_cond)), "16"):16, (list_to_binary([<<?_(P1_status, '8'):8, ?_(P1_progress, '16/signed'):16/signed>> || {P1_status, P1_progress} <- P0_cond]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13060:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13060), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13060:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13061), {P0_attr}) ->
    D_a_t_a = <<?_((length(P0_attr)), "16"):16, (list_to_binary([<<?_(P1_label, '8'):8, ?_(P1_value, '16'):16>> || {P1_label, P1_value} <- P0_attr]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13061:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13061), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13061:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13062), {P0_code, P0_cond}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((length(P0_cond)), "16"):16, (list_to_binary([<<?_(P1_status, '8'):8>> || P1_status <- P0_cond]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13062:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13062), {P0_cur_medal_id, P0_page_index}) ->
    D_a_t_a = <<?_(P0_cur_medal_id, '32'):32, ?_(P0_page_index, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13062:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13063), {P0_cur_medal_id}) ->
    D_a_t_a = <<?_(P0_cur_medal_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13063:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13063), {P0_nth}) ->
    D_a_t_a = <<?_(P0_nth, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13063:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13064), {P0_nth}) ->
    D_a_t_a = <<?_(P0_nth, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13064:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13064), {P0_nth}) ->
    D_a_t_a = <<?_(P0_nth, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13064:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13065), {P0_nth, P0_num}) ->
    D_a_t_a = <<?_(P0_nth, '8'):8, ?_(P0_num, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13065:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13065), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13065:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13066), {P0_trials, P0_trials_pass, P0_info}) ->
    D_a_t_a = <<?_((length(P0_trials)), "16"):16, (list_to_binary([<<?_(P1_trial_id, '32'):32>> || P1_trial_id <- P0_trials]))/binary, ?_((length(P0_trials_pass)), "16"):16, (list_to_binary([<<?_(P1_trial_id, '32'):32, ?_(P1_available, '8'):8, ?_(P1_time, '32'):32>> || {P1_trial_id, P1_available, P1_time} <- P0_trials_pass]))/binary, ?_((length(P0_info)), "16"):16, (list_to_binary([<<?_(P1_trial_id, '32'):32, ?_(P1_pass, '32'):32, ?_(P1_fail, '32'):32, ?_(P1_succ_rate, '8'):8, ?_(P1_avg_fc, '32'):32>> || {P1_trial_id, P1_pass, P1_fail, P1_succ_rate, P1_avg_fc} <- P0_info]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13066:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13066), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13066:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13067), {P0_top5list}) ->
    D_a_t_a = <<?_((length(P0_top5list)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_medal_id, '32'):32, ?_(P1_role_power, '32'):32, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8, ?_((length(P1_looks)), "16"):16, (list_to_binary([<<?_(P2_looks_type, '8'):8, ?_(P2_looks_id, '32'):32, ?_(P2_looks_value, '16'):16>> || {P2_looks_type, P2_looks_id, P2_looks_value} <- P1_looks]))/binary>> || {P1_rid, P1_srv_id, P1_name, P1_medal_id, P1_role_power, P1_career, P1_sex, P1_looks} <- P0_top5list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13067:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13067), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13067:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13068), {P0_trial_id, P0_time}) ->
    D_a_t_a = <<?_(P0_trial_id, '32'):32, ?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13068:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13068), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13068:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13069), {P0_nth, P0_cur_value}) ->
    D_a_t_a = <<?_(P0_nth, '8'):8, ?_(P0_cur_value, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13069:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13069), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13069:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13070), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13070:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13070), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13070:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13071), {P0_code}) ->
    D_a_t_a = <<?_(P0_code, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13071:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13071), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13071:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13072), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13072:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13072), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13072:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13080), {P0_wear_id, P0_honor, P0_medals, P0_honors, P0_win_times, P0_die_times}) ->
    D_a_t_a = <<?_(P0_wear_id, '32'):32, ?_(P0_honor, '32'):32, ?_((length(P0_medals)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32>> || P1_id <- P0_medals]))/binary, ?_((length(P0_honors)), "16"):16, (list_to_binary([<<?_(P1_honor_id, '32'):32, ?_(P1_days, '8'):8>> || {P1_honor_id, P1_days} <- P0_honors]))/binary, ?_(P0_win_times, '32'):32, ?_(P0_die_times, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13080:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13080), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13080:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13081), {P0_honor_id}) ->
    D_a_t_a = <<?_(P0_honor_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13081:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13081), {P0_honor_id}) ->
    D_a_t_a = <<?_(P0_honor_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13081:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13082), {P0_honor_id}) ->
    D_a_t_a = <<?_(P0_honor_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13082:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13082), {P0_honor_id}) ->
    D_a_t_a = <<?_(P0_honor_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13082:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13083), {P0_honor, P0_win_times, P0_die_times}) ->
    D_a_t_a = <<?_(P0_honor, '32'):32, ?_(P0_win_times, '32'):32, ?_(P0_die_times, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13083:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13083), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13083:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13084), {P0_honor_id}) ->
    D_a_t_a = <<?_(P0_honor_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13084:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13084), {P0_honor_id}) ->
    D_a_t_a = <<?_(P0_honor_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13084:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 13060, _B0) ->
    {ok, {}};
unpack(cli, 13060, _B0) ->
    {P0_cur_medal_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_cur_rep, _B2} = lib_proto:read_uint16(_B1),
    {P0_need_rep, _B3} = lib_proto:read_uint16(_B2),
    {P0_gain, _B6} = lib_proto:read_array(_B3, fun(_B4) ->
        {P1_cur_medal_id, _B5} = lib_proto:read_uint32(_B4),
        {P1_cur_medal_id, _B5}
    end),
    {P0_page_index, _B7} = lib_proto:read_uint8(_B6),
    {P0_cond, _B11} = lib_proto:read_array(_B7, fun(_B8) ->
        {P1_status, _B9} = lib_proto:read_uint8(_B8),
        {P1_progress, _B10} = lib_proto:read_int16(_B9),
        {[P1_status, P1_progress], _B10}
    end),
    {ok, {P0_cur_medal_id, P0_cur_rep, P0_need_rep, P0_gain, P0_page_index, P0_cond}};

unpack(srv, 13062, _B0) ->
    {P0_cur_medal_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_page_index, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_cur_medal_id, P0_page_index}};
unpack(cli, 13062, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {P0_cond, _B4} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_status, _B3} = lib_proto:read_uint8(_B2),
        {P1_status, _B3}
    end),
    {ok, {P0_code, P0_cond}};

unpack(srv, 13064, _B0) ->
    {P0_nth, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_nth}};
unpack(cli, 13064, _B0) ->
    {P0_nth, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_nth}};

unpack(srv, 13065, _B0) ->
    {ok, {}};
unpack(cli, 13065, _B0) ->
    {P0_nth, _B1} = lib_proto:read_uint8(_B0),
    {P0_num, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_nth, P0_num}};

unpack(srv, 13066, _B0) ->
    {ok, {}};
unpack(cli, 13066, _B0) ->
    {P0_trials, _B3} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_trial_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_trial_id, _B2}
    end),
    {P0_trials_pass, _B8} = lib_proto:read_array(_B3, fun(_B4) ->
        {P1_trial_id, _B5} = lib_proto:read_uint32(_B4),
        {P1_available, _B6} = lib_proto:read_uint8(_B5),
        {P1_time, _B7} = lib_proto:read_uint32(_B6),
        {[P1_trial_id, P1_available, P1_time], _B7}
    end),
    {P0_info, _B15} = lib_proto:read_array(_B8, fun(_B9) ->
        {P1_trial_id, _B10} = lib_proto:read_uint32(_B9),
        {P1_pass, _B11} = lib_proto:read_uint32(_B10),
        {P1_fail, _B12} = lib_proto:read_uint32(_B11),
        {P1_succ_rate, _B13} = lib_proto:read_uint8(_B12),
        {P1_avg_fc, _B14} = lib_proto:read_uint32(_B13),
        {[P1_trial_id, P1_pass, P1_fail, P1_succ_rate, P1_avg_fc], _B14}
    end),
    {ok, {P0_trials, P0_trials_pass, P0_info}};

unpack(srv, 13067, _B0) ->
    {ok, {}};
unpack(cli, 13067, _B0) ->
    {P0_top5list, _B14} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_rid, _B2} = lib_proto:read_uint32(_B1),
        {P1_srv_id, _B3} = lib_proto:read_string(_B2),
        {P1_name, _B4} = lib_proto:read_string(_B3),
        {P1_medal_id, _B5} = lib_proto:read_uint32(_B4),
        {P1_role_power, _B6} = lib_proto:read_uint32(_B5),
        {P1_career, _B7} = lib_proto:read_uint8(_B6),
        {P1_sex, _B8} = lib_proto:read_uint8(_B7),
        {P1_looks, _B13} = lib_proto:read_array(_B8, fun(_B9) ->
            {P2_looks_type, _B10} = lib_proto:read_uint8(_B9),
            {P2_looks_id, _B11} = lib_proto:read_uint32(_B10),
            {P2_looks_value, _B12} = lib_proto:read_uint16(_B11),
            {[P2_looks_type, P2_looks_id, P2_looks_value], _B12}
        end),
        {[P1_rid, P1_srv_id, P1_name, P1_medal_id, P1_role_power, P1_career, P1_sex, P1_looks], _B13}
    end),
    {ok, {P0_top5list}};

unpack(srv, 13068, _B0) ->
    {ok, {}};
unpack(cli, 13068, _B0) ->
    {P0_trial_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_time, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_trial_id, P0_time}};

unpack(srv, 13069, _B0) ->
    {ok, {}};
unpack(cli, 13069, _B0) ->
    {P0_nth, _B1} = lib_proto:read_uint8(_B0),
    {P0_cur_value, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_nth, P0_cur_value}};

unpack(srv, 13070, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_id}};
unpack(cli, 13070, _B0) ->
    {ok, {}};

unpack(srv, 13071, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_id}};
unpack(cli, 13071, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_code}};

unpack(srv, 13072, _B0) ->
    {ok, {}};
unpack(cli, 13072, _B0) ->
    {ok, {}};

unpack(srv, 13080, _B0) ->
    {ok, {}};
unpack(cli, 13080, _B0) ->
    {P0_wear_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_honor, _B2} = lib_proto:read_uint32(_B1),
    {P0_medals, _B5} = lib_proto:read_array(_B2, fun(_B3) ->
        {P1_id, _B4} = lib_proto:read_uint32(_B3),
        {P1_id, _B4}
    end),
    {P0_honors, _B9} = lib_proto:read_array(_B5, fun(_B6) ->
        {P1_honor_id, _B7} = lib_proto:read_uint32(_B6),
        {P1_days, _B8} = lib_proto:read_uint8(_B7),
        {[P1_honor_id, P1_days], _B8}
    end),
    {P0_win_times, _B10} = lib_proto:read_uint32(_B9),
    {P0_die_times, _B11} = lib_proto:read_uint32(_B10),
    {ok, {P0_wear_id, P0_honor, P0_medals, P0_honors, P0_win_times, P0_die_times}};

unpack(srv, 13081, _B0) ->
    {P0_honor_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_honor_id}};
unpack(cli, 13081, _B0) ->
    {P0_honor_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_honor_id}};

unpack(srv, 13082, _B0) ->
    {P0_honor_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_honor_id}};
unpack(cli, 13082, _B0) ->
    {P0_honor_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_honor_id}};

unpack(srv, 13083, _B0) ->
    {ok, {}};
unpack(cli, 13083, _B0) ->
    {P0_honor, _B1} = lib_proto:read_uint32(_B0),
    {P0_win_times, _B2} = lib_proto:read_uint32(_B1),
    {P0_die_times, _B3} = lib_proto:read_uint32(_B2),
    {ok, {P0_honor, P0_win_times, P0_die_times}};

unpack(srv, 13084, _B0) ->
    {P0_honor_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_honor_id}};
unpack(cli, 13084, _B0) ->
    {P0_honor_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_honor_id}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
