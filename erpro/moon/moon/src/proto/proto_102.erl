%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_102).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("role.hrl").
-include("task.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(10200), {P0_task_list}) ->
    D_a_t_a = <<?_((length(P0_task_list)), "16"):16, (list_to_binary([<<?_(P1_task_id, '32'):32, ?_(P1_status, '8'):8, ?_(P1_accept_num, '32'):32, ?_(P1_item_base_id, '32'):32, ?_(P1_item_num, '32'):32, ?_((length(P1_progress)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_(P2_code, '8'):8, ?_(P2_target, '32'):32, ?_(P2_target_value, '32'):32, ?_(P2_value, '32'):32, ?_(P2_status, '8'):8, ?_(P2_map_id, '32'):32>> || #task_progress{id = P2_id, code = P2_code, target = P2_target, target_value = P2_target_value, value = P2_value, status = P2_status, map_id = P2_map_id} <- P1_progress]))/binary>> || #task{task_id = P1_task_id, status = P1_status, accept_num = P1_accept_num, item_base_id = P1_item_base_id, item_num = P1_item_num, progress = P1_progress} <- P0_task_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10200:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10200), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10200:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10201), {P0_task_list}) ->
    D_a_t_a = <<?_((length(P0_task_list)), "16"):16, (list_to_binary([<<?_(P1_task_id, '32'):32, ?_(P1_accept_num, '32'):32>> || {P1_task_id, P1_accept_num} <- P0_task_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10201:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10201), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10201:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10202), {P0_task_id, P0_status, P0_accept_num, P0_item_base_id, P0_item_num, P0_progress}) ->
    D_a_t_a = <<?_(P0_task_id, '32'):32, ?_(P0_status, '8'):8, ?_(P0_accept_num, '32'):32, ?_(P0_item_base_id, '32'):32, ?_(P0_item_num, '32'):32, ?_((length(P0_progress)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_code, '8'):8, ?_(P1_target, '32'):32, ?_(P1_target_value, '32'):32, ?_(P1_value, '32'):32, ?_(P1_status, '8'):8, ?_(P1_map_id, '32'):32>> || #task_progress{id = P1_id, code = P1_code, target = P1_target, target_value = P1_target_value, value = P1_value, status = P1_status, map_id = P1_map_id} <- P0_progress]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10202:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10202), {P0_task_id}) ->
    D_a_t_a = <<?_(P0_task_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10202:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10203), {P0_task_id, P0_accept_num}) ->
    D_a_t_a = <<?_(P0_task_id, '32'):32, ?_(P0_accept_num, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10203:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10203), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10203:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10204), {P0_task_id}) ->
    D_a_t_a = <<?_(P0_task_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10204:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10204), {P0_task_id}) ->
    D_a_t_a = <<?_(P0_task_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10204:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10205), {P0_task_id, P0_status, P0_accept_num, P0_item_base_id, P0_item_num, P0_quality, P0_progress}) ->
    D_a_t_a = <<?_(P0_task_id, '32'):32, ?_(P0_status, '8'):8, ?_(P0_accept_num, '32'):32, ?_(P0_item_base_id, '32'):32, ?_(P0_item_num, '32'):32, ?_(P0_quality, '8'):8, ?_((length(P0_progress)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_code, '8'):8, ?_(P1_target, '32'):32, ?_(P1_target_value, '32'):32, ?_(P1_value, '32'):32, ?_(P1_status, '8'):8, ?_(P1_map_id, '32'):32>> || #task_progress{id = P1_id, code = P1_code, target = P1_target, target_value = P1_target_value, value = P1_value, status = P1_status, map_id = P1_map_id} <- P0_progress]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10205:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10205), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10205:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10206), {P0_task_id}) ->
    D_a_t_a = <<?_(P0_task_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10206:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10206), {P0_task_id}) ->
    D_a_t_a = <<?_(P0_task_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10206:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10207), {P0_success, P0_task_id}) ->
    D_a_t_a = <<?_(P0_success, '8'):8, ?_(P0_task_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10207:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10207), {P0_task_id, P0_npc_id}) ->
    D_a_t_a = <<?_(P0_task_id, '32'):32, ?_(P0_npc_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10207:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10208), {P0_success, P0_task_id}) ->
    D_a_t_a = <<?_(P0_success, '8'):8, ?_(P0_task_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10208:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10208), {P0_task_id, P0_npc_id}) ->
    D_a_t_a = <<?_(P0_task_id, '32'):32, ?_(P0_npc_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10208:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10209), {P0_success, P0_task_id}) ->
    D_a_t_a = <<?_(P0_success, '8'):8, ?_(P0_task_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10209:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10209), {P0_task_id}) ->
    D_a_t_a = <<?_(P0_task_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10209:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10211), {P0_npc_status}) ->
    D_a_t_a = <<?_((length(P0_npc_status)), "16"):16, (list_to_binary([<<?_(P1_npc_id, '32'):32, ?_(P1_task_id, '32'):32, ?_(P1_status, '8'):8>> || {P1_npc_id, P1_task_id, P1_status} <- P0_npc_status]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10211:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10211), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10211:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10212), {P0_task_list}) ->
    D_a_t_a = <<?_((length(P0_task_list)), "16"):16, (list_to_binary([<<?_(P1_task_id, '32'):32, ?_(P1_accept_num, '32'):32>> || {P1_task_id, P1_accept_num} <- P0_task_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10212:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10212), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10212:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10213), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10213:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10213), {P0_map_elem_base_id}) ->
    D_a_t_a = <<?_(P0_map_elem_base_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10213:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10214), {P0_task_list}) ->
    D_a_t_a = <<?_((length(P0_task_list)), "16"):16, (list_to_binary([<<?_(P1_task_id, '32'):32>> || P1_task_id <- P0_task_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10214:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10214), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10214:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10215), {P0_success, P0_msg}) ->
    D_a_t_a = <<?_(P0_success, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10215:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10215), {P0_task_id, P0_npc_id, P0_item_id, P0_num}) ->
    D_a_t_a = <<?_(P0_task_id, '32'):32, ?_(P0_npc_id, '32'):32, ?_(P0_item_id, '32'):32, ?_(P0_num, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10215:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10216), {P0_result, P0_task_id, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_task_id, '32'):32, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10216:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10216), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10216:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10217), {P0_result, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10217:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10217), {P0_task_id}) ->
    D_a_t_a = <<?_(P0_task_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10217:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10218), {P0_num}) ->
    D_a_t_a = <<?_(P0_num, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10218:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10218), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10218:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10219), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10219:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10219), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10219:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10220), {P0_result, P0_reason, P0_xx_free_time, P0_xx_fresh_time, P0_xx_type, P0_xx_list}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary, ?_(P0_xx_free_time, '32'):32, ?_(P0_xx_fresh_time, '32'):32, ?_(P0_xx_type, '8'):8, ?_((length(P0_xx_list)), "16"):16, (list_to_binary([<<?_(P1_task_id, '32'):32, ?_(P1_quality, '32'):32, ?_(P1_status, '8'):8>> || {P1_task_id, P1_quality, P1_status} <- P0_xx_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10220:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10220), {P0_xx_type}) ->
    D_a_t_a = <<?_(P0_xx_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10220:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10221), {P0_result, P0_reason, P0_xx_free_time, P0_xx_fresh_time, P0_xx_type, P0_xx_list}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary, ?_(P0_xx_free_time, '32'):32, ?_(P0_xx_fresh_time, '32'):32, ?_(P0_xx_type, '8'):8, ?_((length(P0_xx_list)), "16"):16, (list_to_binary([<<?_(P1_task_id, '32'):32, ?_(P1_quality, '32'):32, ?_(P1_status, '8'):8>> || {P1_task_id, P1_quality, P1_status} <- P0_xx_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10221:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10221), {P0_type, P0_xx_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_xx_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10221:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10222), {P0_success, P0_msg}) ->
    D_a_t_a = <<?_(P0_success, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10222:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10222), {P0_task_id, P0_quality}) ->
    D_a_t_a = <<?_(P0_task_id, '32'):32, ?_(P0_quality, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10222:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10223), {P0_page, P0_total, P0_list}) ->
    D_a_t_a = <<?_(P0_page, '32'):32, ?_(P0_total, '32'):32, ?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_type, '8'):8, ?_(P1_npc_id, '32'):32, ?_(P1_map_id, '32'):32, ?_(P1_x, '32'):32, ?_(P1_y, '32'):32, ?_(P1_reward, '32'):32, ?_(P1_status, '8'):8, ?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_expire, '32'):32>> || {P1_id, P1_type, P1_npc_id, P1_map_id, P1_x, P1_y, P1_reward, P1_status, P1_rid, P1_srv_id, P1_name, P1_expire} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10223:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10223), {P0_page}) ->
    D_a_t_a = <<?_(P0_page, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10223:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10224), {P0_success, P0_msg}) ->
    D_a_t_a = <<?_(P0_success, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10224:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10224), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10224:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10225), {P0_has_task}) ->
    D_a_t_a = <<?_(P0_has_task, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10225:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10225), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10225:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10226), {P0_mode, P0_refresh_cnt, P0_accept_cnt, P0_acceptable_task_list}) ->
    D_a_t_a = <<?_(P0_mode, '8'):8, ?_(P0_refresh_cnt, '8'):8, ?_(P0_accept_cnt, '8'):8, ?_((length(P0_acceptable_task_list)), "16"):16, (list_to_binary([<<?_(P1_task_id, '32'):32, ?_(P1_is_opened, '8'):8>> || {P1_task_id, P1_is_opened} <- P0_acceptable_task_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10226:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10226), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10226:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10227), {P0_res, P0_msgid, P0_id}) ->
    D_a_t_a = <<?_(P0_res, '8'):8, ?_(P0_msgid, '16'):16, ?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10227:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10227), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10227:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10228), {P0_res, P0_msgid, P0_old_id, P0_new_id}) ->
    D_a_t_a = <<?_(P0_res, '8'):8, ?_(P0_msgid, '16'):16, ?_(P0_old_id, '32'):32, ?_(P0_new_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10228:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10228), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10228:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10229), {P0_mode, P0_my_delegate_tasks}) ->
    D_a_t_a = <<?_(P0_mode, '8'):8, ?_((length(P0_my_delegate_tasks)), "16"):16, (list_to_binary([<<?_(P1_task_id, '32'):32, ?_(P1_delegate_time, '32'):32>> || {P1_task_id, P1_delegate_time} <- P0_my_delegate_tasks]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10229:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10229), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10229:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10230), {P0_res, P0_msgid, P0_id}) ->
    D_a_t_a = <<?_(P0_res, '8'):8, ?_(P0_msgid, '16'):16, ?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10230:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10230), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10230:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10231), {P0_res, P0_msgid, P0_task_id}) ->
    D_a_t_a = <<?_(P0_res, '8'):8, ?_(P0_msgid, '16'):16, ?_(P0_task_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10231:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10231), {P0_task_id}) ->
    D_a_t_a = <<?_(P0_task_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10231:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10232), {P0_res, P0_msgid}) ->
    D_a_t_a = <<?_(P0_res, '8'):8, ?_(P0_msgid, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10232:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10232), {P0_mode}) ->
    D_a_t_a = <<?_(P0_mode, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10232:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10233), {P0_res, P0_msgid, P0_id}) ->
    D_a_t_a = <<?_(P0_res, '8'):8, ?_(P0_msgid, '16'):16, ?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10233:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10233), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10233:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10234), {P0_tasks, P0_refresh_time}) ->
    D_a_t_a = <<?_((length(P0_tasks)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_(P1_task_id, '32'):32>> || {P1_role_id, P1_srv_id, P1_task_id} <- P0_tasks]))/binary, ?_(P0_refresh_time, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10234:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10234), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10234:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10235), {P0_msgid}) ->
    D_a_t_a = <<?_(P0_msgid, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10235:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10235), {P0_event_id, P0_target_val}) ->
    D_a_t_a = <<?_(P0_event_id, '32'):32, ?_(P0_target_val, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10235:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10236), {P0_res, P0_msgid, P0_id}) ->
    D_a_t_a = <<?_(P0_res, '8'):8, ?_(P0_msgid, '16'):16, ?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10236:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10236), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10236:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10237), {P0_status, P0_time}) ->
    D_a_t_a = <<?_(P0_status, '32'):32, ?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10237:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10237), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10237:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10238), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10238:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10238), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10238:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 10200, _B0) ->
    {ok, {}};
unpack(cli, 10200, _B0) ->
    {P0_task_list, _B16} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_task_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_status, _B3} = lib_proto:read_uint8(_B2),
        {P1_accept_num, _B4} = lib_proto:read_uint32(_B3),
        {P1_item_base_id, _B5} = lib_proto:read_uint32(_B4),
        {P1_item_num, _B6} = lib_proto:read_uint32(_B5),
        {P1_progress, _B15} = lib_proto:read_array(_B6, fun(_B7) ->
            {P2_id, _B8} = lib_proto:read_uint32(_B7),
            {P2_code, _B9} = lib_proto:read_uint8(_B8),
            {P2_target, _B10} = lib_proto:read_uint32(_B9),
            {P2_target_value, _B11} = lib_proto:read_uint32(_B10),
            {P2_value, _B12} = lib_proto:read_uint32(_B11),
            {P2_status, _B13} = lib_proto:read_uint8(_B12),
            {P2_map_id, _B14} = lib_proto:read_uint32(_B13),
            {[P2_id, P2_code, P2_target, P2_target_value, P2_value, P2_status, P2_map_id], _B14}
        end),
        {[P1_task_id, P1_status, P1_accept_num, P1_item_base_id, P1_item_num, P1_progress], _B15}
    end),
    {ok, {P0_task_list}};

unpack(srv, 10201, _B0) ->
    {ok, {}};
unpack(cli, 10201, _B0) ->
    {P0_task_list, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_task_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_accept_num, _B3} = lib_proto:read_uint32(_B2),
        {[P1_task_id, P1_accept_num], _B3}
    end),
    {ok, {P0_task_list}};

unpack(srv, 10202, _B0) ->
    {P0_task_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_task_id}};
unpack(cli, 10202, _B0) ->
    {P0_task_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_status, _B2} = lib_proto:read_uint8(_B1),
    {P0_accept_num, _B3} = lib_proto:read_uint32(_B2),
    {P0_item_base_id, _B4} = lib_proto:read_uint32(_B3),
    {P0_item_num, _B5} = lib_proto:read_uint32(_B4),
    {P0_progress, _B14} = lib_proto:read_array(_B5, fun(_B6) ->
        {P1_id, _B7} = lib_proto:read_uint32(_B6),
        {P1_code, _B8} = lib_proto:read_uint8(_B7),
        {P1_target, _B9} = lib_proto:read_uint32(_B8),
        {P1_target_value, _B10} = lib_proto:read_uint32(_B9),
        {P1_value, _B11} = lib_proto:read_uint32(_B10),
        {P1_status, _B12} = lib_proto:read_uint8(_B11),
        {P1_map_id, _B13} = lib_proto:read_uint32(_B12),
        {[P1_id, P1_code, P1_target, P1_target_value, P1_value, P1_status, P1_map_id], _B13}
    end),
    {ok, {P0_task_id, P0_status, P0_accept_num, P0_item_base_id, P0_item_num, P0_progress}};

unpack(srv, 10203, _B0) ->
    {ok, {}};
unpack(cli, 10203, _B0) ->
    {P0_task_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_accept_num, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_task_id, P0_accept_num}};

unpack(srv, 10204, _B0) ->
    {P0_task_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_task_id}};
unpack(cli, 10204, _B0) ->
    {P0_task_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_task_id}};

unpack(srv, 10205, _B0) ->
    {ok, {}};
unpack(cli, 10205, _B0) ->
    {P0_task_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_status, _B2} = lib_proto:read_uint8(_B1),
    {P0_accept_num, _B3} = lib_proto:read_uint32(_B2),
    {P0_item_base_id, _B4} = lib_proto:read_uint32(_B3),
    {P0_item_num, _B5} = lib_proto:read_uint32(_B4),
    {P0_quality, _B6} = lib_proto:read_uint8(_B5),
    {P0_progress, _B15} = lib_proto:read_array(_B6, fun(_B7) ->
        {P1_id, _B8} = lib_proto:read_uint32(_B7),
        {P1_code, _B9} = lib_proto:read_uint8(_B8),
        {P1_target, _B10} = lib_proto:read_uint32(_B9),
        {P1_target_value, _B11} = lib_proto:read_uint32(_B10),
        {P1_value, _B12} = lib_proto:read_uint32(_B11),
        {P1_status, _B13} = lib_proto:read_uint8(_B12),
        {P1_map_id, _B14} = lib_proto:read_uint32(_B13),
        {[P1_id, P1_code, P1_target, P1_target_value, P1_value, P1_status, P1_map_id], _B14}
    end),
    {ok, {P0_task_id, P0_status, P0_accept_num, P0_item_base_id, P0_item_num, P0_quality, P0_progress}};

unpack(srv, 10206, _B0) ->
    {P0_task_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_task_id}};
unpack(cli, 10206, _B0) ->
    {P0_task_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_task_id}};

unpack(srv, 10207, _B0) ->
    {P0_task_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_npc_id, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_task_id, P0_npc_id}};
unpack(cli, 10207, _B0) ->
    {P0_success, _B1} = lib_proto:read_uint8(_B0),
    {P0_task_id, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_success, P0_task_id}};

unpack(srv, 10208, _B0) ->
    {P0_task_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_npc_id, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_task_id, P0_npc_id}};
unpack(cli, 10208, _B0) ->
    {P0_success, _B1} = lib_proto:read_uint8(_B0),
    {P0_task_id, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_success, P0_task_id}};

unpack(srv, 10209, _B0) ->
    {P0_task_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_task_id}};
unpack(cli, 10209, _B0) ->
    {P0_success, _B1} = lib_proto:read_uint8(_B0),
    {P0_task_id, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_success, P0_task_id}};

unpack(srv, 10211, _B0) ->
    {ok, {}};
unpack(cli, 10211, _B0) ->
    {P0_npc_status, _B5} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_npc_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_task_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_status, _B4} = lib_proto:read_uint8(_B3),
        {[P1_npc_id, P1_task_id, P1_status], _B4}
    end),
    {ok, {P0_npc_status}};

unpack(srv, 10212, _B0) ->
    {ok, {}};
unpack(cli, 10212, _B0) ->
    {P0_task_list, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_task_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_accept_num, _B3} = lib_proto:read_uint32(_B2),
        {[P1_task_id, P1_accept_num], _B3}
    end),
    {ok, {P0_task_list}};

unpack(srv, 10213, _B0) ->
    {P0_map_elem_base_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_map_elem_base_id}};
unpack(cli, 10213, _B0) ->
    {ok, {}};

unpack(srv, 10214, _B0) ->
    {ok, {}};
unpack(cli, 10214, _B0) ->
    {P0_task_list, _B3} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_task_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_task_id, _B2}
    end),
    {ok, {P0_task_list}};

unpack(srv, 10215, _B0) ->
    {P0_task_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_npc_id, _B2} = lib_proto:read_uint32(_B1),
    {P0_item_id, _B3} = lib_proto:read_uint32(_B2),
    {P0_num, _B4} = lib_proto:read_uint32(_B3),
    {ok, {P0_task_id, P0_npc_id, P0_item_id, P0_num}};
unpack(cli, 10215, _B0) ->
    {P0_success, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_success, P0_msg}};

unpack(srv, 10226, _B0) ->
    {ok, {}};
unpack(cli, 10226, _B0) ->
    {P0_mode, _B1} = lib_proto:read_uint8(_B0),
    {P0_refresh_cnt, _B2} = lib_proto:read_uint8(_B1),
    {P0_accept_cnt, _B3} = lib_proto:read_uint8(_B2),
    {P0_acceptable_task_list, _B7} = lib_proto:read_array(_B3, fun(_B4) ->
        {P1_task_id, _B5} = lib_proto:read_uint32(_B4),
        {P1_is_opened, _B6} = lib_proto:read_uint8(_B5),
        {[P1_task_id, P1_is_opened], _B6}
    end),
    {ok, {P0_mode, P0_refresh_cnt, P0_accept_cnt, P0_acceptable_task_list}};

unpack(srv, 10235, _B0) ->
    {P0_event_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_target_val, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_event_id, P0_target_val}};
unpack(cli, 10235, _B0) ->
    {P0_msgid, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_msgid}};

unpack(srv, 10238, _B0) ->
    {ok, {}};
unpack(cli, 10238, _B0) ->
    {ok, {}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
