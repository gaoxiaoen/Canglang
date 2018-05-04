%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_146).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.


%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(14601), {P0_result, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14601:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14601), {P0_union}) ->
    D_a_t_a = <<?_(P0_union, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14601:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14602), {P0_result, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14602:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14602), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14602:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14603), {P0_result, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14603:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14603), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14603:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14604), {P0_result}) ->
    D_a_t_a = <<?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14604:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14604), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14604:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14605), {P0_atk_guilds, P0_dfd_guilds}) ->
    D_a_t_a = <<?_((length(P0_atk_guilds)), "16"):16, (list_to_binary([<<?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_level, '32'):32, ?_((byte_size(P1_leader)), "16"):16, ?_(P1_leader, bin)/binary, ?_(P1_count, '32'):32, ?_(P1_realm, '8'):8>> || {P1_name, P1_level, P1_leader, P1_count, P1_realm} <- P0_atk_guilds]))/binary, ?_((length(P0_dfd_guilds)), "16"):16, (list_to_binary([<<?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_level, '32'):32, ?_((byte_size(P1_leader)), "16"):16, ?_(P1_leader, bin)/binary, ?_(P1_count, '32'):32, ?_(P1_realm, '8'):8>> || {P1_name, P1_level, P1_leader, P1_count, P1_realm} <- P0_dfd_guilds]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14605:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14605), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14605:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14606), {P0_result, P0_Reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_Reason)), "16"):16, ?_(P0_Reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14606:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14606), {P0_guild_name}) ->
    D_a_t_a = <<?_((byte_size(P0_guild_name)), "16"):16, ?_(P0_guild_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14606:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14607), {P0_type, P0_msg}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14607:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14607), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14607:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14608), {P0_name}) ->
    D_a_t_a = <<?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14608:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14608), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14608:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14610), {P0_result, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14610:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14610), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14610:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14611), {P0_time, P0_teams}) ->
    D_a_t_a = <<?_(P0_time, '32'):32, ?_((length(P0_teams)), "16"):16, (list_to_binary([<<?_(P1_team_no, '8'):8, ?_((length(P1_members)), "16"):16, (list_to_binary([<<?_((byte_size(P2_name)), "16"):16, ?_(P2_name, bin)/binary, ?_(P2_role_id, '32'):32, ?_((byte_size(P2_srv_id)), "16"):16, ?_(P2_srv_id, bin)/binary>> || [P2_name, P2_role_id, P2_srv_id] <- P1_members]))/binary, ?_(P1_fight_capacity, '32'):32>> || [P1_team_no, P1_members, P1_fight_capacity] <- P0_teams]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14611:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14611), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14611:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14612), {P0_result, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14612:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14612), {P0_team_no}) ->
    D_a_t_a = <<?_(P0_team_no, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14612:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14613), {P0_result, P0_reason}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14613:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14613), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14613:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14621), {P0_result, P0_reason, P0_total, P0_list}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary, ?_(P0_total, '32'):32, ?_((length(P0_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_((byte_size(P1_guild)), "16"):16, ?_(P1_guild, bin)/binary, ?_(P1_combat_creidt, '32'):32, ?_(P1_stone_credit, '32'):32, ?_(P1_compete_credit, '32'):32, ?_(P1_sword_credit, '32'):32, ?_(P1_total_credit, '32'):32, ?_(P1_union, '8'):8, ?_(P1_realm, '8'):8>> || {P1_name, P1_guild, P1_combat_creidt, P1_stone_credit, P1_compete_credit, P1_sword_credit, P1_total_credit, P1_union, P1_realm} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14621:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14621), {P0_type, P0_page}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_page, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14621:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14622), {P0_result, P0_reason, P0_total, P0_list}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary, ?_(P0_total, '32'):32, ?_((length(P0_list)), "16"):16, (list_to_binary([<<?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_role_count, '32'):32, ?_(P1_combat_creidt, '32'):32, ?_(P1_stone_credit, '32'):32, ?_(P1_compete_credit, '32'):32, ?_(P1_sword_credit, '32'):32, ?_(P1_total_credit, '32'):32, ?_(P1_union, '8'):8, ?_(P1_realm, '8'):8>> || {P1_name, P1_role_count, P1_combat_creidt, P1_stone_credit, P1_compete_credit, P1_sword_credit, P1_total_credit, P1_union, P1_realm} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14622:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14622), {P0_type, P0_page}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_page, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14622:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14623), {P0_result, P0_reason, P0_list}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_reason)), "16"):16, ?_(P0_reason, bin)/binary, ?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_union, '8'):8, ?_(P1_guild_count, '32'):32, ?_(P1_credit_combat, '32'):32, ?_(P1_compete_credit, '32'):32, ?_(P1_hold_time, '32'):32, ?_(P1_total_credit, '32'):32, ?_(P1_realm, '8'):8>> || {P1_union, P1_guild_count, P1_credit_combat, P1_compete_credit, P1_hold_time, P1_total_credit, P1_realm} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14623:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14623), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14623:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14624), {P0_my_credit, P0_my_combat, P0_list}) ->
    D_a_t_a = <<?_(P0_my_credit, '32'):32, ?_(P0_my_combat, '32'):32, ?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_union, '8'):8, ?_(P1_credit_combat, '32'):32, ?_(P1_hold_time, '32'):32, ?_(P1_total_credit, '32'):32>> || {P1_union, P1_credit_combat, P1_hold_time, P1_total_credit} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14624:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14624), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14624:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14631), {P0_type, P0_num}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_num, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14631:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14631), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14631:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14632), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14632:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14632), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14632:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
