%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_151).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("guild_practise.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(15100), {P0_luck, P0_refresh_time, P0_status, P0_help_others, P0_refresh_self, P0_quality, P0_task_id, P0_attr, P0_exp, P0_psychic, P0_value, P0_target_val}) ->
    D_a_t_a = <<?_(P0_luck, '8'):8, ?_(P0_refresh_time, '32'):32, ?_(P0_status, '8'):8, ?_(P0_help_others, '8'):8, ?_(P0_refresh_self, '8'):8, ?_(P0_quality, '8'):8, ?_(P0_task_id, '32'):32, ?_((length(P0_attr)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_quality, '8'):8>> || {P1_rid, P1_srv_id, P1_name, P1_quality} <- P0_attr]))/binary, ?_(P0_exp, '32'):32, ?_(P0_psychic, '32'):32, ?_(P0_value, '32'):32, ?_(P0_target_val, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15100:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15100), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15100:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15101), {P0_guild_practise_list}) ->
    D_a_t_a = <<?_((length(P0_guild_practise_list)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_luck, '8'):8, ?_(P1_status, '8'):8, ?_(P1_help_others, '8'):8, ?_(P1_refresh_self, '8'):8, ?_(P1_quality, '8'):8, ?_(P1_task_id, '32'):32, ?_(P1_online, '8'):8>> || #guild_practise_role{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, luck = P1_luck, status = P1_status, help_others = P1_help_others, refresh_self = P1_refresh_self, quality = P1_quality, task_id = P1_task_id, online = P1_online} <- P0_guild_practise_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15101:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15101), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15101:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15102), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15102:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15102), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15102:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15103), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15103:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15103), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15103:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15104), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15104:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15104), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15104:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15105), {P0_code, P0_msg, P0_task_id, P0_refresh_time}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_task_id, '32'):32, ?_(P0_refresh_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15105:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15105), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15105:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15106), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15106:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15106), {P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15106:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15107), {P0_rid, P0_srv_id, P0_name}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15107:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15107), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15107:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15108), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15108:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15108), {P0_rid, P0_srv_id, P0_type}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15108:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15109), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15109:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15109), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15109:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15150), {P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15150:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15150), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15150:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15151), {P0_guild_practise_add_list}) ->
    D_a_t_a = <<?_((length(P0_guild_practise_add_list)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_luck, '8'):8, ?_(P1_status, '8'):8, ?_(P1_help_others, '8'):8, ?_(P1_refresh_self, '8'):8, ?_(P1_quality, '8'):8, ?_(P1_task_id, '32'):32, ?_(P1_online, '8'):8>> || #guild_practise_role{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, luck = P1_luck, status = P1_status, help_others = P1_help_others, refresh_self = P1_refresh_self, quality = P1_quality, task_id = P1_task_id, online = P1_online} <- P0_guild_practise_add_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15151:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15151), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15151:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15152), {P0_guild_practise_update_list}) ->
    D_a_t_a = <<?_((length(P0_guild_practise_update_list)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_luck, '8'):8, ?_(P1_status, '8'):8, ?_(P1_help_others, '8'):8, ?_(P1_refresh_self, '8'):8, ?_(P1_quality, '8'):8, ?_(P1_task_id, '32'):32, ?_(P1_online, '8'):8>> || #guild_practise_role{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, luck = P1_luck, status = P1_status, help_others = P1_help_others, refresh_self = P1_refresh_self, quality = P1_quality, task_id = P1_task_id, online = P1_online} <- P0_guild_practise_update_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15152:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15152), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15152:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15153), {P0_rid, P0_srv_id, P0_name, P0_quality}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_quality, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15153:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15153), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15153:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15154), {P0_exp, P0_psychic}) ->
    D_a_t_a = <<?_(P0_exp, '32'):32, ?_(P0_psychic, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15154:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15154), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15154:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(15155), {P0_value, P0_target_val}) ->
    D_a_t_a = <<?_(P0_value, '32'):32, ?_(P0_target_val, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15155:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(15155), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 15155:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
