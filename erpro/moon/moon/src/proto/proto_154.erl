%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_154).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("item.hrl").
-include("guard.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(15400), {P0_flag, P0_lev, P0_hp, P0_time}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_(P0_lev, '8'):8, ?_(P0_hp, '8'):8, ?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15400:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15400), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15400:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15401), {P0_role_id, P0_srv_id, P0_name, P0_career, P0_lev, P0_sex, P0_guild_name, P0_looks, P0_items}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_career, '8'):8, ?_(P0_lev, '8'):8, ?_(P0_sex, '8'):8, ?_((byte_size(P0_guild_name)), "16"):16, ?_(P0_guild_name, bin)/binary, ?_((length(P0_looks)), "16"):16, (list_to_binary([<<?_(P1_looks_type, '8'):8, ?_(P1_looks_id, '32'):32, ?_(P1_looks_value, '16'):16>> || {P1_looks_type, P1_looks_id, P1_looks_value} <- P0_looks]))/binary, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_upgrade, '8'):8, ?_(P1_enchant, '8/signed'):8/signed, ?_(P1_enchant_fail, '8'):8, ?_(P1_pos, '16'):16, ?_(P1_durability, '32/signed'):32/signed, ?_(P1_craft, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary, ?_((length(P1_extra)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32, ?_((byte_size(P2_str)), "16"):16, ?_(P2_str, bin)/binary>> || {P2_type, P2_value, P2_str} <- P1_extra]))/binary>> || #item{id = P1_id, base_id = P1_base_id, bind = P1_bind, upgrade = P1_upgrade, enchant = P1_enchant, enchant_fail = P1_enchant_fail, pos = P1_pos, durability = P1_durability, craft = P1_craft, attr = P1_attr, max_base_attr = P1_max_base_attr, extra = P1_extra} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15401:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15401), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15401:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15402), {P0_last_rank, P0_page_idx, P0_total_page}) ->
    D_a_t_a = <<?_((length(P0_last_rank)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_point, '32'):32, ?_(P1_kill_npc, '32'):32, ?_(P1_kill_boss, '32'):32>> || #role_guard{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, career = P1_career, lev = P1_lev, point = P1_point, kill_npc = P1_kill_npc, kill_boss = P1_kill_boss} <- P0_last_rank]))/binary, ?_(P0_page_idx, '32'):32, ?_(P0_total_page, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15402:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15402), {P0_page_idx}) ->
    D_a_t_a = <<?_(P0_page_idx, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15402:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15403), {P0_all_rank, P0_page_idx, P0_total_page}) ->
    D_a_t_a = <<?_((length(P0_all_rank)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_all_point, '32'):32>> || #role_guard{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, career = P1_career, lev = P1_lev, all_point = P1_all_point} <- P0_all_rank]))/binary, ?_(P0_page_idx, '32'):32, ?_(P0_total_page, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15403:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15403), {P0_page_idx}) ->
    D_a_t_a = <<?_(P0_page_idx, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15403:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15404), {P0_rank, P0_last_rank, P0_page_idx, P0_total_page}) ->
    D_a_t_a = <<?_(P0_rank, '32'):32, ?_((length(P0_last_rank)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_point, '32'):32, ?_(P1_kill_npc, '32'):32, ?_(P1_kill_boss, '32'):32>> || #role_guard{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, career = P1_career, lev = P1_lev, point = P1_point, kill_npc = P1_kill_npc, kill_boss = P1_kill_boss} <- P0_last_rank]))/binary, ?_(P0_page_idx, '32'):32, ?_(P0_total_page, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15404:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15404), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15404:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15405), {P0_rank, P0_all_rank, P0_page_idx, P0_total_page}) ->
    D_a_t_a = <<?_(P0_rank, '32'):32, ?_((length(P0_all_rank)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_all_point, '32'):32>> || #role_guard{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, career = P1_career, lev = P1_lev, all_point = P1_all_point} <- P0_all_rank]))/binary, ?_(P0_page_idx, '32'):32, ?_(P0_total_page, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15405:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15405), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15405:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15406), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15406:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15406), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15406:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15407), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15407:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15407), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15407:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15408), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15408:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15408), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15408:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15409), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15409:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15409), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15409:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15410), {P0_status, P0_hp, P0_hp_max}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_hp, '32'):32, ?_(P0_hp_max, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15410:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15410), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15410:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15411), {P0_guard_counter_rank}) ->
    D_a_t_a = <<?_((length(P0_guard_counter_rank)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_point, '32'):32>> || #guard_counter_role{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, point = P1_point} <- P0_guard_counter_rank]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15411:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15411), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15411:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15412), {P0_status, P0_times}) ->
    D_a_t_a = <<?_(P0_status, '8'):8, ?_(P0_times, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15412:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15412), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15412:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15413), {P0_last_rank, P0_page_idx, P0_total_page}) ->
    D_a_t_a = <<?_((length(P0_last_rank)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_point, '32'):32, ?_(P1_kill_npc, '32'):32>> || #guard_counter_role{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, career = P1_career, lev = P1_lev, point = P1_point, kill_npc = P1_kill_npc} <- P0_last_rank]))/binary, ?_(P0_page_idx, '32'):32, ?_(P0_total_page, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15413:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15413), {P0_page_idx}) ->
    D_a_t_a = <<?_(P0_page_idx, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15413:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15414), {P0_all_rank, P0_page_idx, P0_total_page}) ->
    D_a_t_a = <<?_((length(P0_all_rank)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_all_point, '32'):32>> || #guard_counter_role{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, career = P1_career, lev = P1_lev, all_point = P1_all_point} <- P0_all_rank]))/binary, ?_(P0_page_idx, '32'):32, ?_(P0_total_page, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15414:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15414), {P0_page_idx}) ->
    D_a_t_a = <<?_(P0_page_idx, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15414:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15415), {P0_role_id, P0_srv_id, P0_name, P0_career, P0_lev, P0_sex, P0_guild_name, P0_looks, P0_items}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_career, '8'):8, ?_(P0_lev, '8'):8, ?_(P0_sex, '8'):8, ?_((byte_size(P0_guild_name)), "16"):16, ?_(P0_guild_name, bin)/binary, ?_((length(P0_looks)), "16"):16, (list_to_binary([<<?_(P1_looks_type, '8'):8, ?_(P1_looks_id, '32'):32, ?_(P1_looks_value, '16'):16>> || {P1_looks_type, P1_looks_id, P1_looks_value} <- P0_looks]))/binary, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_upgrade, '8'):8, ?_(P1_enchant, '8/signed'):8/signed, ?_(P1_enchant_fail, '8'):8, ?_(P1_pos, '16'):16, ?_(P1_durability, '32/signed'):32/signed, ?_(P1_craft, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary, ?_((length(P1_extra)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32, ?_((byte_size(P2_str)), "16"):16, ?_(P2_str, bin)/binary>> || {P2_type, P2_value, P2_str} <- P1_extra]))/binary>> || #item{id = P1_id, base_id = P1_base_id, bind = P1_bind, upgrade = P1_upgrade, enchant = P1_enchant, enchant_fail = P1_enchant_fail, pos = P1_pos, durability = P1_durability, craft = P1_craft, attr = P1_attr, max_base_attr = P1_max_base_attr, extra = P1_extra} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15415:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15415), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15415:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15416), {P0_last_mode, P0_next_mode}) ->
    D_a_t_a = <<?_(P0_last_mode, '8'):8, ?_(P0_next_mode, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15416:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15416), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15416:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15417), {P0_rank, P0_last_rank, P0_page_idx, P0_total_page}) ->
    D_a_t_a = <<?_(P0_rank, '32'):32, ?_((length(P0_last_rank)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_point, '32'):32, ?_(P1_kill_npc, '32'):32>> || #guard_counter_role{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, career = P1_career, lev = P1_lev, point = P1_point, kill_npc = P1_kill_npc} <- P0_last_rank]))/binary, ?_(P0_page_idx, '32'):32, ?_(P0_total_page, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15417:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15417), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15417:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15418), {P0_rank, P0_all_rank, P0_page_idx, P0_total_page}) ->
    D_a_t_a = <<?_(P0_rank, '32'):32, ?_((length(P0_all_rank)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_all_point, '32'):32>> || #guard_counter_role{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, career = P1_career, lev = P1_lev, all_point = P1_all_point} <- P0_all_rank]))/binary, ?_(P0_page_idx, '32'):32, ?_(P0_total_page, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15418:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15418), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15418:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15419), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15419:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15419), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15419:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
