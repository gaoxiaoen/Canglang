%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_158).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("campaign.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(15800), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15800:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15800), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15800:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15801), {P0_time}) ->
    D_a_t_a = <<?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15801:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15801), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15801:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15802), {P0_ret, P0_end_time, P0_add_charge, P0_charge, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_(P0_end_time, '32'):32, ?_(P0_add_charge, '32'):32, ?_(P0_charge, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15802:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15802), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15802:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15803), {P0_ret, P0_end_time, P0_add_charge, P0_charge, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_(P0_end_time, '32'):32, ?_(P0_add_charge, '32'):32, ?_(P0_charge, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15803:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15803), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15803:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15804), {P0_Idlist}) ->
    D_a_t_a = <<?_((length(P0_Idlist)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_(P1_type, '8'):8, ?_(P1_value, '32'):32>> || {P1_id, P1_type, P1_value} <- P0_Idlist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15804:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15804), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15804:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15805), {P0_id, P0_value, P0_base_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_value, '8'):8, ?_(P0_base_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15805:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15805), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15805:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15806), {P0_gold}) ->
    D_a_t_a = <<?_(P0_gold, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15806:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15806), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15806:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15807), {P0_time1, P0_time2, P0_Idlist}) ->
    D_a_t_a = <<?_(P0_time1, '32'):32, ?_(P0_time2, '32'):32, ?_((length(P0_Idlist)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8>> || P1_id <- P0_Idlist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15807:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15807), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15807:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15808), {P0_id, P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15808:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15808), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15808:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15810), {P0_campaign_task_list}) ->
    D_a_t_a = <<?_((length(P0_campaign_task_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_status, '8'):8, ?_(P1_count, '8'):8, ?_(P1_max_count, '8'):8, ?_(P1_value, '32'):32, ?_(P1_target_val, '32'):32, ?_((length(P1_items)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32, ?_(P2_bind, '8'):8, ?_(P2_num, '32'):32>> || {P2_base_id, P2_bind, P2_num} <- P1_items]))/binary>> || #campaign_task{id = P1_id, name = P1_name, status = P1_status, count = P1_count, max_count = P1_max_count, value = P1_value, target_val = P1_target_val, items = P1_items} <- P0_campaign_task_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15810:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15810), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15810:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15811), {P0_campaign_task_list}) ->
    D_a_t_a = <<?_((length(P0_campaign_task_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_status, '8'):8, ?_(P1_count, '8'):8, ?_(P1_max_count, '8'):8, ?_(P1_value, '32'):32, ?_(P1_target_val, '32'):32>> || #campaign_task{id = P1_id, name = P1_name, status = P1_status, count = P1_count, max_count = P1_max_count, value = P1_value, target_val = P1_target_val} <- P0_campaign_task_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15811:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15811), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15811:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15812), {P0_id, P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15812:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15812), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15812:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15813), {P0_flag, P0_status}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_(P0_status, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15813:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15813), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15813:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15814), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15814:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15814), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15814:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15815), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15815:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15815), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15815:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15816), {P0_label, P0_ctime, P0_flag, P0_gain_list}) ->
    D_a_t_a = <<?_(P0_label, '8'):8, ?_(P0_ctime, '32'):32, ?_(P0_flag, '8'):8, ?_((length(P0_gain_list)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_val, '32'):32, ?_(P1_num, '32'):32>> || {P1_type, P1_val, P1_num} <- P0_gain_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15816:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15816), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15816:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15817), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15817:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15817), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15817:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15820), {P0_camp_update_notice_list}) ->
    D_a_t_a = <<?_((length(P0_camp_update_notice_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_new_content)), "16"):16, ?_(P1_new_content, bin)/binary, ?_((byte_size(P1_update_content)), "16"):16, ?_(P1_update_content, bin)/binary, ?_((byte_size(P1_bug_content)), "16"):16, ?_(P1_bug_content, bin)/binary, ?_(P1_start_time, '32'):32, ?_(P1_end_time, '32'):32>> || #camp_update_notice{id = P1_id, new_content = P1_new_content, update_content = P1_update_content, bug_content = P1_bug_content, start_time = P1_start_time, end_time = P1_end_time} <- P0_camp_update_notice_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15820:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15820), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15820:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15830), {P0_name, P0_title, P0_camp_list}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_((byte_size(P0_title)), "16"):16, ?_(P0_title, bin)/binary, ?_((length(P0_camp_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_title)), "16"):16, ?_(P1_title, bin)/binary, ?_(P1_star, '8'):8, ?_((byte_size(P1_ico)), "16"):16, ?_(P1_ico, bin)/binary>> || #campaign_adm{id = P1_id, title = P1_title, star = P1_star, ico = P1_ico} <- P0_camp_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15830:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15830), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15830:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15831), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15831:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15831), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15831:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15833), {P0_id, P0_title, P0_publicity, P0_content, P0_start_time, P0_end_time, P0_msg, P0_curr, P0_target, P0_available, P0_cond_id, P0_coin, P0_gold, P0_gold_bind, P0_items, P0_cond_msg, P0_reward_msg}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_title)), "16"):16, ?_(P0_title, bin)/binary, ?_((byte_size(P0_publicity)), "16"):16, ?_(P0_publicity, bin)/binary, ?_((byte_size(P0_content)), "16"):16, ?_(P0_content, bin)/binary, ?_(P0_start_time, '32'):32, ?_(P0_end_time, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_curr, '16'):16, ?_(P0_target, '16'):16, ?_(P0_available, '8'):8, ?_(P0_cond_id, '32'):32, ?_(P0_coin, '32'):32, ?_(P0_gold, '32'):32, ?_(P0_gold_bind, '32'):32, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_num, '32'):32>> || {P1_base_id, P1_bind, P1_num} <- P0_items]))/binary, ?_((byte_size(P0_cond_msg)), "16"):16, ?_(P0_cond_msg, bin)/binary, ?_((byte_size(P0_reward_msg)), "16"):16, ?_(P0_reward_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15833:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15833), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15833:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15834), {P0_id, P0_title, P0_publicity, P0_content, P0_start_time, P0_end_time, P0_msg, P0_curr, P0_conds, P0_cond_id, P0_available, P0_coin, P0_gold, P0_gold_bind, P0_items, P0_cond_msg, P0_reward_msg}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_title)), "16"):16, ?_(P0_title, bin)/binary, ?_((byte_size(P0_publicity)), "16"):16, ?_(P0_publicity, bin)/binary, ?_((byte_size(P0_content)), "16"):16, ?_(P0_content, bin)/binary, ?_(P0_start_time, '32'):32, ?_(P0_end_time, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_curr, '16'):16, ?_((length(P0_conds)), "16"):16, (list_to_binary([<<?_(P1_target, '32'):32, ?_(P1_available, '8'):8>> || {P1_target, P1_available} <- P0_conds]))/binary, ?_(P0_cond_id, '32'):32, ?_(P0_available, '8'):8, ?_(P0_coin, '32'):32, ?_(P0_gold, '32'):32, ?_(P0_gold_bind, '32'):32, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_num, '32'):32>> || {P1_base_id, P1_bind, P1_num} <- P0_items]))/binary, ?_((byte_size(P0_cond_msg)), "16"):16, ?_(P0_cond_msg, bin)/binary, ?_((byte_size(P0_reward_msg)), "16"):16, ?_(P0_reward_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15834:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15834), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15834:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15835), {P0_id, P0_title, P0_publicity, P0_content, P0_start_time, P0_end_time, P0_msg, P0_curr, P0_conds}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_title)), "16"):16, ?_(P0_title, bin)/binary, ?_((byte_size(P0_publicity)), "16"):16, ?_(P0_publicity, bin)/binary, ?_((byte_size(P0_content)), "16"):16, ?_(P0_content, bin)/binary, ?_(P0_start_time, '32'):32, ?_(P0_end_time, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_((byte_size(P0_curr)), "16"):16, ?_(P0_curr, bin)/binary, ?_((length(P0_conds)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_available, '8'):8, ?_(P1_reward_num, '16'):16, ?_(P1_coin, '32'):32, ?_(P1_gold, '32'):32, ?_(P1_gold_bind, '32'):32, ?_((length(P1_items)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32, ?_(P2_bind, '8'):8, ?_(P2_num, '32'):32>> || {P2_base_id, P2_bind, P2_num} <- P1_items]))/binary, ?_((byte_size(P1_msg)), "16"):16, ?_(P1_msg, bin)/binary, ?_((byte_size(P1_reward_msg)), "16"):16, ?_(P1_reward_msg, bin)/binary>> || [P1_id, P1_available, P1_reward_num, P1_coin, P1_gold, P1_gold_bind, P1_items, P1_msg, P1_reward_msg] <- P0_conds]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15835:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15835), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15835:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15836), {P0_id, P0_title, P0_publicity, P0_content, P0_start_time, P0_end_time, P0_msg, P0_button_content, P0_button_bind}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_title)), "16"):16, ?_(P0_title, bin)/binary, ?_((byte_size(P0_publicity)), "16"):16, ?_(P0_publicity, bin)/binary, ?_((byte_size(P0_content)), "16"):16, ?_(P0_content, bin)/binary, ?_(P0_start_time, '32'):32, ?_(P0_end_time, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_((byte_size(P0_button_content)), "16"):16, ?_(P0_button_content, bin)/binary, ?_((byte_size(P0_button_bind)), "16"):16, ?_(P0_button_bind, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15836:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15836), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15836:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15837), {P0_id, P0_title, P0_publicity, P0_content, P0_start_time, P0_end_time, P0_msg, P0_cond_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_title)), "16"):16, ?_(P0_title, bin)/binary, ?_((byte_size(P0_publicity)), "16"):16, ?_(P0_publicity, bin)/binary, ?_((byte_size(P0_content)), "16"):16, ?_(P0_content, bin)/binary, ?_(P0_start_time, '32'):32, ?_(P0_end_time, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_cond_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15837:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15837), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15837:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15845), {P0_code}) ->
    D_a_t_a = <<?_(P0_code, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15845:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15845), {P0_camp_id, P0_conds_id}) ->
    D_a_t_a = <<?_(P0_camp_id, '32'):32, ?_(P0_conds_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15845:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15846), {P0_code}) ->
    D_a_t_a = <<?_(P0_code, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15846:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15846), {P0_camp_id, P0_cond_id, P0_card}) ->
    D_a_t_a = <<?_(P0_camp_id, '32'):32, ?_(P0_cond_id, '32'):32, ?_((byte_size(P0_card)), "16"):16, ?_(P0_card, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15846:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15850), {P0_campaign_total_list}) ->
    D_a_t_a = <<?_((length(P0_campaign_total_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_((byte_size(P1_title)), "16"):16, ?_(P1_title, bin)/binary, ?_((byte_size(P1_ico)), "16"):16, ?_(P1_ico, bin)/binary, ?_((byte_size(P1_alert)), "16"):16, ?_(P1_alert, bin)/binary, ?_((byte_size(P1_gif)), "16"):16, ?_(P1_gif, bin)/binary, ?_(P1_start_time, '32'):32, ?_(P1_end_time, '32'):32, ?_(P1_is_open, '32'):32>> || #campaign_total{id = P1_id, name = P1_name, title = P1_title, ico = P1_ico, alert = P1_alert, gif = P1_gif, start_time = P1_start_time, end_time = P1_end_time, is_open = P1_is_open} <- P0_campaign_total_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15850:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15850), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15850:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15851), {P0_id, P0_name, P0_title, P0_ico, P0_alert, P0_gif, P0_start_time, P0_end_time, P0_camp_list}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_((byte_size(P0_title)), "16"):16, ?_(P0_title, bin)/binary, ?_((byte_size(P0_ico)), "16"):16, ?_(P0_ico, bin)/binary, ?_((byte_size(P0_alert)), "16"):16, ?_(P0_alert, bin)/binary, ?_((byte_size(P0_gif)), "16"):16, ?_(P0_gif, bin)/binary, ?_(P0_start_time, '32'):32, ?_(P0_end_time, '32'):32, ?_((length(P0_camp_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_title)), "16"):16, ?_(P1_title, bin)/binary, ?_((byte_size(P1_ico)), "16"):16, ?_(P1_ico, bin)/binary, ?_(P1_star, '8'):8, ?_((byte_size(P1_alert)), "16"):16, ?_(P1_alert, bin)/binary, ?_((byte_size(P1_publicity)), "16"):16, ?_(P1_publicity, bin)/binary, ?_((byte_size(P1_content)), "16"):16, ?_(P1_content, bin)/binary, ?_(P1_start_time, '32'):32, ?_(P1_end_time, '32'):32, ?_(P1_is_show_time, '8'):8, ?_((byte_size(P1_msg)), "16"):16, ?_(P1_msg, bin)/binary, ?_((length(P1_conds)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_(P2_type, '8'):8, ?_(P2_sec_type, '32'):32, ?_(P2_button, '16'):16, ?_(P2_min_lev, '8'):8, ?_(P2_max_lev, '8'):8, ?_(P2_settlement_type, '8'):8, ?_(P2_reward_num, '16'):16, ?_(P2_coin, '32'):32, ?_(P2_coin_bind, '32'):32, ?_(P2_gold, '32'):32, ?_(P2_gold_bind, '32'):32, ?_((length(P2_items)), "16"):16, (list_to_binary([<<?_(P3_base_id, '32'):32, ?_(P3_bind, '8'):8, ?_(P3_num, '32'):32>> || {P3_base_id, P3_bind, P3_num} <- P2_items]))/binary, ?_((byte_size(P2_button_content)), "16"):16, ?_(P2_button_content, bin)/binary, ?_((byte_size(P2_button_bind)), "16"):16, ?_(P2_button_bind, bin)/binary, ?_(P2_is_button, '8'):8, ?_((byte_size(P2_msg)), "16"):16, ?_(P2_msg, bin)/binary, ?_((byte_size(P2_reward_msg)), "16"):16, ?_(P2_reward_msg, bin)/binary>> || #campaign_cond{id = P2_id, type = P2_type, sec_type = P2_sec_type, button = P2_button, min_lev = P2_min_lev, max_lev = P2_max_lev, settlement_type = P2_settlement_type, reward_num = P2_reward_num, coin = P2_coin, coin_bind = P2_coin_bind, gold = P2_gold, gold_bind = P2_gold_bind, items = P2_items, button_content = P2_button_content, button_bind = P2_button_bind, is_button = P2_is_button, msg = P2_msg, reward_msg = P2_reward_msg} <- P1_conds]))/binary>> || #campaign_adm{id = P1_id, title = P1_title, ico = P1_ico, star = P1_star, alert = P1_alert, publicity = P1_publicity, content = P1_content, start_time = P1_start_time, end_time = P1_end_time, is_show_time = P1_is_show_time, msg = P1_msg, conds = P1_conds} <- P0_camp_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15851:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15851), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15851:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15852), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15852:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15852), {P0_total_id, P0_camp_id, P0_conds_id, P0_card}) ->
    D_a_t_a = <<?_(P0_total_id, '32'):32, ?_(P0_camp_id, '32'):32, ?_(P0_conds_id, '32'):32, ?_((byte_size(P0_card)), "16"):16, ?_(P0_card, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15852:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15853), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15853:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15853), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15853:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15854), {P0_total_id, P0_camp_id, P0_cond_id, P0_type, P0_sec_type, P0_hf, P0_skin_type, P0_skin_id, P0_attr_msg, P0_say_msg, P0_items, P0_flash_items}) ->
    D_a_t_a = <<?_(P0_total_id, '32'):32, ?_(P0_camp_id, '32'):32, ?_(P0_cond_id, '32'):32, ?_(P0_type, '8'):8, ?_(P0_sec_type, '32'):32, ?_((byte_size(P0_hf)), "16"):16, ?_(P0_hf, bin)/binary, ?_(P0_skin_type, '8'):8, ?_(P0_skin_id, '32'):32, ?_((byte_size(P0_attr_msg)), "16"):16, ?_(P0_attr_msg, bin)/binary, ?_((byte_size(P0_say_msg)), "16"):16, ?_(P0_say_msg, bin)/binary, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_num, '32'):32>> || {P1_base_id, P1_bind, P1_num} <- P0_items]))/binary, ?_((length(P0_flash_items)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32>> || P1_base_id <- P0_flash_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15854:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15854), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15854:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15855), {P0_total_id, P0_id, P0_start_time, P0_end_time, P0_is_show_time, P0_conds}) ->
    D_a_t_a = <<?_(P0_total_id, '32'):32, ?_(P0_id, '32'):32, ?_(P0_start_time, '32'):32, ?_(P0_end_time, '32'):32, ?_(P0_is_show_time, '8'):8, ?_((length(P0_conds)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_sort_val, '32'):32, ?_(P1_type, '8'):8, ?_(P1_sec_type, '32'):32, ?_((byte_size(P1_msg)), "16"):16, ?_(P1_msg, bin)/binary, ?_(P1_need_gold, '32'):32, ?_(P1_pay_gold, '32'):32, ?_(P1_rewarded, '8'):8, ?_((length(P1_items)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32, ?_(P2_bind, '8'):8, ?_(P2_num, '32'):32>> || {P2_base_id, P2_bind, P2_num} <- P1_items]))/binary, ?_((length(P1_flash_items)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32>> || P2_base_id <- P1_flash_items]))/binary>> || {P1_id, P1_sort_val, P1_type, P1_sec_type, P1_msg, P1_need_gold, P1_pay_gold, P1_rewarded, P1_items, P1_flash_items} <- P0_conds]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15855:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15855), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15855:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15856), {P0_total_id, P0_id, P0_start_time, P0_end_time, P0_is_show_time, P0_loss_gold, P0_conds}) ->
    D_a_t_a = <<?_(P0_total_id, '32'):32, ?_(P0_id, '32'):32, ?_(P0_start_time, '32'):32, ?_(P0_end_time, '32'):32, ?_(P0_is_show_time, '8'):8, ?_(P0_loss_gold, '32'):32, ?_((length(P0_conds)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_sort_val, '32'):32, ?_(P1_type, '8'):8, ?_(P1_sec_type, '32'):32, ?_((byte_size(P1_msg)), "16"):16, ?_(P1_msg, bin)/binary, ?_(P1_need_gold, '32'):32, ?_(P1_rewarded, '8'):8, ?_((length(P1_items)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32, ?_(P2_bind, '8'):8, ?_(P2_num, '32'):32>> || {P2_base_id, P2_bind, P2_num} <- P1_items]))/binary, ?_((length(P1_flash_items)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32>> || P2_base_id <- P1_flash_items]))/binary>> || {P1_id, P1_sort_val, P1_type, P1_sec_type, P1_msg, P1_need_gold, P1_rewarded, P1_items, P1_flash_items} <- P0_conds]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15856:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15856), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15856:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15857), {P0_total_id, P0_id, P0_start_time, P0_end_time, P0_is_show_time, P0_conds}) ->
    D_a_t_a = <<?_(P0_total_id, '32'):32, ?_(P0_id, '32'):32, ?_(P0_start_time, '32'):32, ?_(P0_end_time, '32'):32, ?_(P0_is_show_time, '8'):8, ?_((length(P0_conds)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_sort_val, '32'):32, ?_(P1_type, '8'):8, ?_(P1_sec_type, '32'):32, ?_((byte_size(P1_msg)), "16"):16, ?_(P1_msg, bin)/binary, ?_(P1_need_gold, '32'):32, ?_(P1_pay_gold, '32'):32, ?_(P1_rewarded, '8'):8, ?_((length(P1_items)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32, ?_(P2_bind, '8'):8, ?_(P2_num, '32'):32>> || {P2_base_id, P2_bind, P2_num} <- P1_items]))/binary, ?_((length(P1_flash_items)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32>> || P2_base_id <- P1_flash_items]))/binary>> || {P1_id, P1_sort_val, P1_type, P1_sec_type, P1_msg, P1_need_gold, P1_pay_gold, P1_rewarded, P1_items, P1_flash_items} <- P0_conds]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15857:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15857), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15857:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15858), {P0_total_id, P0_id, P0_start_time, P0_end_time, P0_is_show_time, P0_pay_list, P0_loss_list, P0_exchange_list}) ->
    D_a_t_a = <<?_(P0_total_id, '32'):32, ?_(P0_id, '32'):32, ?_(P0_start_time, '32'):32, ?_(P0_end_time, '32'):32, ?_(P0_is_show_time, '8'):8, ?_((length(P0_pay_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_sort_val, '32'):32, ?_(P1_type, '8'):8, ?_(P1_sec_type, '32'):32, ?_((byte_size(P1_msg)), "16"):16, ?_(P1_msg, bin)/binary, ?_(P1_need_gold, '32'):32, ?_(P1_pay_gold, '32'):32, ?_(P1_rewarded, '8'):8, ?_((length(P1_item_list)), "16"):16, (list_to_binary([<<?_(P2_pos, '32'):32, ?_((length(P2_items)), "16"):16, (list_to_binary([<<?_(P3_base_id, '32'):32, ?_(P3_bind, '8'):8, ?_(P3_num, '32'):32>> || {P3_base_id, P3_bind, P3_num} <- P2_items]))/binary>> || {P2_pos, P2_items} <- P1_item_list]))/binary, ?_((length(P1_flash_items)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32>> || P2_base_id <- P1_flash_items]))/binary>> || {P1_id, P1_sort_val, P1_type, P1_sec_type, P1_msg, P1_need_gold, P1_pay_gold, P1_rewarded, P1_item_list, P1_flash_items} <- P0_pay_list]))/binary, ?_((length(P0_loss_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_sort_val, '32'):32, ?_(P1_type, '8'):8, ?_(P1_sec_type, '32'):32, ?_((byte_size(P1_msg)), "16"):16, ?_(P1_msg, bin)/binary, ?_(P1_need_gold, '32'):32, ?_(P1_had_gold, '32'):32, ?_(P1_rewarded, '8'):8, ?_((length(P1_items)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32, ?_(P2_bind, '8'):8, ?_(P2_num, '32'):32>> || {P2_base_id, P2_bind, P2_num} <- P1_items]))/binary, ?_((length(P1_flash_items)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32>> || P2_base_id <- P1_flash_items]))/binary>> || {P1_id, P1_sort_val, P1_type, P1_sec_type, P1_msg, P1_need_gold, P1_had_gold, P1_rewarded, P1_items, P1_flash_items} <- P0_loss_list]))/binary, ?_((length(P0_exchange_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_sort_val, '32'):32, ?_(P1_type, '8'):8, ?_(P1_sec_type, '32'):32, ?_((byte_size(P1_msg)), "16"):16, ?_(P1_msg, bin)/binary, ?_(P1_need_gold, '32'):32, ?_(P1_pay_gold, '32'):32, ?_((length(P1_loss_items)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32, ?_(P2_bind, '8'):8, ?_(P2_num, '32'):32>> || {P2_base_id, P2_bind, P2_num} <- P1_loss_items]))/binary, ?_((length(P1_gain_items)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32, ?_(P2_bind, '8'):8, ?_(P2_num, '32'):32>> || {P2_base_id, P2_bind, P2_num} <- P1_gain_items]))/binary, ?_((length(P1_preview_items)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32, ?_(P2_bind, '8'):8, ?_(P2_num, '32'):32>> || {P2_base_id, P2_bind, P2_num} <- P1_preview_items]))/binary, ?_((length(P1_flash_items)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32>> || P2_base_id <- P1_flash_items]))/binary>> || {P1_id, P1_sort_val, P1_type, P1_sec_type, P1_msg, P1_need_gold, P1_pay_gold, P1_loss_items, P1_gain_items, P1_preview_items, P1_flash_items} <- P0_exchange_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15858:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15858), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15858:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15859), {P0_days, P0_today_reward_time, P0_total_rewardable, P0_online_day_num, P0_today}) ->
    D_a_t_a = <<?_((length(P0_days)), "16"):16, (list_to_binary([<<?_(P1_year, '16'):16, ?_(P1_month, '8'):8, ?_(P1_day, '8'):8, ?_(P1_status, '8'):8>> || {P1_year, P1_month, P1_day, P1_status} <- P0_days]))/binary, ?_(P0_today_reward_time, '32'):32, ?_(P0_total_rewardable, '8'):8, ?_(P0_online_day_num, '32'):32, ?_(P0_today, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15859:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15859), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15859:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15860), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15860:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15860), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15860:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15861), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15861:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15861), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15861:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15862), {P0_loss_gold, P0_reward_loss_gold, P0_flag}) ->
    D_a_t_a = <<?_(P0_loss_gold, '32'):32, ?_(P0_reward_loss_gold, '32'):32, ?_(P0_flag, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15862:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15862), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15862:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15863), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15863:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15863), {P0_base_id, P0_real_name, P0_addr, P0_postcode, P0_phone, P0_picture, P0_sex, P0_sizes}) ->
    D_a_t_a = <<?_(P0_base_id, '32'):32, ?_((byte_size(P0_real_name)), "16"):16, ?_(P0_real_name, bin)/binary, ?_((byte_size(P0_addr)), "16"):16, ?_(P0_addr, bin)/binary, ?_((byte_size(P0_postcode)), "16"):16, ?_(P0_postcode, bin)/binary, ?_((byte_size(P0_phone)), "16"):16, ?_(P0_phone, bin)/binary, ?_((byte_size(P0_picture)), "16"):16, ?_(P0_picture, bin)/binary, ?_(P0_sex, '8'):8, ?_((byte_size(P0_sizes)), "16"):16, ?_(P0_sizes, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15863:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15864), {P0_days, P0_today}) ->
    D_a_t_a = <<?_((length(P0_days)), "16"):16, (list_to_binary([<<?_(P1_year, '16'):16, ?_(P1_month, '8'):8, ?_(P1_day, '8'):8, ?_(P1_num, '32'):32, ?_(P1_status, '8'):8>> || {P1_year, P1_month, P1_day, P1_num, P1_status} <- P0_days]))/binary, ?_(P0_today, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15864:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15864), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15864:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15865), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15865:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15865), {P0_year, P0_month, P0_day}) ->
    D_a_t_a = <<?_(P0_year, '16'):16, ?_(P0_month, '8'):8, ?_(P0_day, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15865:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15867), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15867:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15867), {P0_elem_id}) ->
    D_a_t_a = <<?_(P0_elem_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15867:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15868), {P0_owner, P0_type, P0_tree_timeout, P0_tree_water, P0_tree_max_water, P0_water_info, P0_name, P0_role_water, P0_role_max_water, P0_role_timeout}) ->
    D_a_t_a = <<?_(P0_owner, '8'):8, ?_(P0_type, '8'):8, ?_(P0_tree_timeout, '32'):32, ?_(P0_tree_water, '32'):32, ?_(P0_tree_max_water, '32'):32, ?_((length(P0_water_info)), "16"):16, (list_to_binary([<<?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_water_time, '32'):32>> || {P1_name, P1_water_time} <- P0_water_info]))/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_role_water, '32'):32, ?_(P0_role_max_water, '32'):32, ?_(P0_role_timeout, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15868:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15868), {P0_elem_id}) ->
    D_a_t_a = <<?_(P0_elem_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15868:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15869), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15869:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15869), {P0_role_id, P0_srv_id, P0_elem_id}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_elem_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15869:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15870), {P0_name, P0_map_id, P0_map_x, P0_map_y}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_map_id, '32'):32, ?_(P0_map_x, '32'):32, ?_(P0_map_y, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15870:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15870), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15870:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15871), {P0_elem_id}) ->
    D_a_t_a = <<?_(P0_elem_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15871:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15871), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15871:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15872), {P0_status, P0_consume_all, P0_consume_shop, P0_start_time, P0_end_time}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_consume_all, '32'):32, ?_(P0_consume_shop, '32'):32, ?_(P0_start_time, '32'):32, ?_(P0_end_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15872:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15872), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15872:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15873), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15873:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15873), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15873:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15874), {P0_target_step, P0_target_index, P0_charge, P0_start_time, P0_end_time, P0_gifts}) ->
    D_a_t_a = <<?_(P0_target_step, '8'):8, ?_(P0_target_index, '8'):8, ?_(P0_charge, '16'):16, ?_(P0_start_time, '32'):32, ?_(P0_end_time, '32'):32, ?_((length(P0_gifts)), "16"):16, (list_to_binary([<<?_(P1_step, '8'):8, ?_(P1_index, '8'):8, ?_(P1_status, '8'):8, ?_(P1_item_id, '32'):32>> || {P1_step, P1_index, P1_status, P1_item_id} <- P0_gifts]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15874:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15874), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15874:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15875), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15875:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15875), {P0_step, P0_index}) ->
    D_a_t_a = <<?_(P0_step, '8'):8, ?_(P0_index, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15875:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15876), {P0_status}) ->
    D_a_t_a = <<?_(P0_status, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15876:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15876), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15876:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15877), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15877:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15877), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15877:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15878), {P0_team_a, P0_team_b, P0_score_a, P0_score_b, P0_num_a, P0_num_b, P0_next_refresh, P0_my_rank, P0_my_team, P0_my_score, P0_my_active, P0_my_charge}) ->
    D_a_t_a = <<?_((length(P0_team_a)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '16'):16, ?_(P1_sex, '8'):8, ?_(P1_career, '8'):8, ?_(P1_vip, '8'):8, ?_(P1_score, '32'):32, ?_(P1_active, '32'):32, ?_(P1_charge, '32'):32>> || {P1_rid, P1_srv_id, P1_name, P1_lev, P1_sex, P1_career, P1_vip, P1_score, P1_active, P1_charge} <- P0_team_a]))/binary, ?_((length(P0_team_b)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '16'):16, ?_(P1_sex, '8'):8, ?_(P1_career, '8'):8, ?_(P1_vip, '8'):8, ?_(P1_score, '32'):32, ?_(P1_active, '32'):32, ?_(P1_charge, '32'):32>> || {P1_rid, P1_srv_id, P1_name, P1_lev, P1_sex, P1_career, P1_vip, P1_score, P1_active, P1_charge} <- P0_team_b]))/binary, ?_(P0_score_a, '32'):32, ?_(P0_score_b, '32'):32, ?_(P0_num_a, '32'):32, ?_(P0_num_b, '32'):32, ?_(P0_next_refresh, '32'):32, ?_(P0_my_rank, '32'):32, ?_(P0_my_team, '8'):8, ?_(P0_my_score, '32'):32, ?_(P0_my_active, '32'):32, ?_(P0_my_charge, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15878:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15878), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15878:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15879), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15879:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15879), {P0_team}) ->
    D_a_t_a = <<?_(P0_team, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15879:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15880), {P0_my_team, P0_my_score, P0_my_active, P0_my_charge}) ->
    D_a_t_a = <<?_(P0_my_team, '8'):8, ?_(P0_my_score, '32'):32, ?_(P0_my_active, '32'):32, ?_(P0_my_charge, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15880:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15880), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15880:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 15830, _B0) ->
    {ok, {}};
unpack(cli, 15830, _B0) ->
    {P0_name, _B1} = lib_proto:read_string(_B0),
    {P0_title, _B2} = lib_proto:read_string(_B1),
    {P0_camp_list, _B8} = lib_proto:read_array(_B2, fun(_B3) ->
        {P1_id, _B4} = lib_proto:read_uint32(_B3),
        {P1_title, _B5} = lib_proto:read_string(_B4),
        {P1_star, _B6} = lib_proto:read_uint8(_B5),
        {P1_ico, _B7} = lib_proto:read_string(_B6),
        {[P1_id, P1_title, P1_star, P1_ico], _B7}
    end),
    {ok, {P0_name, P0_title, P0_camp_list}};

unpack(srv, 15831, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 15831, _B0) ->
    {ok, {}};

unpack(srv, 15833, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 15833, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_title, _B2} = lib_proto:read_string(_B1),
    {P0_publicity, _B3} = lib_proto:read_string(_B2),
    {P0_content, _B4} = lib_proto:read_string(_B3),
    {P0_start_time, _B5} = lib_proto:read_uint32(_B4),
    {P0_end_time, _B6} = lib_proto:read_uint32(_B5),
    {P0_msg, _B7} = lib_proto:read_string(_B6),
    {P0_curr, _B8} = lib_proto:read_uint16(_B7),
    {P0_target, _B9} = lib_proto:read_uint16(_B8),
    {P0_available, _B10} = lib_proto:read_uint8(_B9),
    {P0_cond_id, _B11} = lib_proto:read_uint32(_B10),
    {P0_coin, _B12} = lib_proto:read_uint32(_B11),
    {P0_gold, _B13} = lib_proto:read_uint32(_B12),
    {P0_gold_bind, _B14} = lib_proto:read_uint32(_B13),
    {P0_items, _B19} = lib_proto:read_array(_B14, fun(_B15) ->
        {P1_base_id, _B16} = lib_proto:read_uint32(_B15),
        {P1_bind, _B17} = lib_proto:read_uint8(_B16),
        {P1_num, _B18} = lib_proto:read_uint32(_B17),
        {[P1_base_id, P1_bind, P1_num], _B18}
    end),
    {P0_cond_msg, _B20} = lib_proto:read_string(_B19),
    {P0_reward_msg, _B21} = lib_proto:read_string(_B20),
    {ok, {P0_id, P0_title, P0_publicity, P0_content, P0_start_time, P0_end_time, P0_msg, P0_curr, P0_target, P0_available, P0_cond_id, P0_coin, P0_gold, P0_gold_bind, P0_items, P0_cond_msg, P0_reward_msg}};

unpack(srv, 15834, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 15834, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_title, _B2} = lib_proto:read_string(_B1),
    {P0_publicity, _B3} = lib_proto:read_string(_B2),
    {P0_content, _B4} = lib_proto:read_string(_B3),
    {P0_start_time, _B5} = lib_proto:read_uint32(_B4),
    {P0_end_time, _B6} = lib_proto:read_uint32(_B5),
    {P0_msg, _B7} = lib_proto:read_string(_B6),
    {P0_curr, _B8} = lib_proto:read_uint16(_B7),
    {P0_conds, _B12} = lib_proto:read_array(_B8, fun(_B9) ->
        {P1_target, _B10} = lib_proto:read_uint32(_B9),
        {P1_available, _B11} = lib_proto:read_uint8(_B10),
        {[P1_target, P1_available], _B11}
    end),
    {P0_cond_id, _B13} = lib_proto:read_uint32(_B12),
    {P0_available, _B14} = lib_proto:read_uint8(_B13),
    {P0_coin, _B15} = lib_proto:read_uint32(_B14),
    {P0_gold, _B16} = lib_proto:read_uint32(_B15),
    {P0_gold_bind, _B17} = lib_proto:read_uint32(_B16),
    {P0_items, _B22} = lib_proto:read_array(_B17, fun(_B18) ->
        {P1_base_id, _B19} = lib_proto:read_uint32(_B18),
        {P1_bind, _B20} = lib_proto:read_uint8(_B19),
        {P1_num, _B21} = lib_proto:read_uint32(_B20),
        {[P1_base_id, P1_bind, P1_num], _B21}
    end),
    {P0_cond_msg, _B23} = lib_proto:read_string(_B22),
    {P0_reward_msg, _B24} = lib_proto:read_string(_B23),
    {ok, {P0_id, P0_title, P0_publicity, P0_content, P0_start_time, P0_end_time, P0_msg, P0_curr, P0_conds, P0_cond_id, P0_available, P0_coin, P0_gold, P0_gold_bind, P0_items, P0_cond_msg, P0_reward_msg}};

unpack(srv, 15835, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 15835, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_title, _B2} = lib_proto:read_string(_B1),
    {P0_publicity, _B3} = lib_proto:read_string(_B2),
    {P0_content, _B4} = lib_proto:read_string(_B3),
    {P0_start_time, _B5} = lib_proto:read_uint32(_B4),
    {P0_end_time, _B6} = lib_proto:read_uint32(_B5),
    {P0_msg, _B7} = lib_proto:read_string(_B6),
    {P0_curr, _B8} = lib_proto:read_string(_B7),
    {P0_conds, _B23} = lib_proto:read_array(_B8, fun(_B9) ->
        {P1_id, _B10} = lib_proto:read_uint32(_B9),
        {P1_available, _B11} = lib_proto:read_uint8(_B10),
        {P1_reward_num, _B12} = lib_proto:read_uint16(_B11),
        {P1_coin, _B13} = lib_proto:read_uint32(_B12),
        {P1_gold, _B14} = lib_proto:read_uint32(_B13),
        {P1_gold_bind, _B15} = lib_proto:read_uint32(_B14),
        {P1_items, _B20} = lib_proto:read_array(_B15, fun(_B16) ->
            {P2_base_id, _B17} = lib_proto:read_uint32(_B16),
            {P2_bind, _B18} = lib_proto:read_uint8(_B17),
            {P2_num, _B19} = lib_proto:read_uint32(_B18),
            {[P2_base_id, P2_bind, P2_num], _B19}
        end),
        {P1_msg, _B21} = lib_proto:read_string(_B20),
        {P1_reward_msg, _B22} = lib_proto:read_string(_B21),
        {[P1_id, P1_available, P1_reward_num, P1_coin, P1_gold, P1_gold_bind, P1_items, P1_msg, P1_reward_msg], _B22}
    end),
    {ok, {P0_id, P0_title, P0_publicity, P0_content, P0_start_time, P0_end_time, P0_msg, P0_curr, P0_conds}};

unpack(srv, 15836, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 15836, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_title, _B2} = lib_proto:read_string(_B1),
    {P0_publicity, _B3} = lib_proto:read_string(_B2),
    {P0_content, _B4} = lib_proto:read_string(_B3),
    {P0_start_time, _B5} = lib_proto:read_uint32(_B4),
    {P0_end_time, _B6} = lib_proto:read_uint32(_B5),
    {P0_msg, _B7} = lib_proto:read_string(_B6),
    {P0_button_content, _B8} = lib_proto:read_string(_B7),
    {P0_button_bind, _B9} = lib_proto:read_string(_B8),
    {ok, {P0_id, P0_title, P0_publicity, P0_content, P0_start_time, P0_end_time, P0_msg, P0_button_content, P0_button_bind}};

unpack(srv, 15837, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 15837, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_title, _B2} = lib_proto:read_string(_B1),
    {P0_publicity, _B3} = lib_proto:read_string(_B2),
    {P0_content, _B4} = lib_proto:read_string(_B3),
    {P0_start_time, _B5} = lib_proto:read_uint32(_B4),
    {P0_end_time, _B6} = lib_proto:read_uint32(_B5),
    {P0_msg, _B7} = lib_proto:read_string(_B6),
    {P0_cond_id, _B8} = lib_proto:read_uint32(_B7),
    {ok, {P0_id, P0_title, P0_publicity, P0_content, P0_start_time, P0_end_time, P0_msg, P0_cond_id}};

unpack(srv, 15845, _B0) ->
    {P0_camp_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_conds_id, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_camp_id, P0_conds_id}};
unpack(cli, 15845, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_code}};

unpack(srv, 15846, _B0) ->
    {P0_camp_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_cond_id, _B2} = lib_proto:read_uint32(_B1),
    {P0_card, _B3} = lib_proto:read_string(_B2),
    {ok, {P0_camp_id, P0_cond_id, P0_card}};
unpack(cli, 15846, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_code}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
