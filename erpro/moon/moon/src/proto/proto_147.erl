%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_147).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("lottery.hrl").
-include("lottery_tree.hrl").
-include("lottery_camp.hrl").
-include("lottery_rich.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(14700), {P0_free, P0_bonus, P0_rid, P0_srv_id, P0_name, P0_award_num, P0_log}) ->
    D_a_t_a = <<?_(P0_free, '32'):32, ?_(P0_bonus, '32'):32, ?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_award_num, '32'):32, ?_((length(P0_log)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_award_id, '32'):32, ?_(P1_award_num, '32'):32>> || #lottery_log{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, award_id = P1_award_id, award_num = P1_award_num} <- P0_log]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14700:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14700), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14700:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14701), {P0_free, P0_tree_free, P0_secret}) ->
    D_a_t_a = <<?_(P0_free, '32'):32, ?_(P0_tree_free, '32'):32, ?_(P0_secret, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14701:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14701), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14701:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14705), {P0_ret, P0_msg, P0_free, P0_bonus, P0_award_id, P0_num, P0_is_secret}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_free, '8'):8, ?_(P0_bonus, '32'):32, ?_(P0_award_id, '32'):32, ?_(P0_num, '32'):32, ?_(P0_is_secret, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14705:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14705), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14705:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14706), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14706:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14706), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14706:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14707), {P0_free, P0_log}) ->
    D_a_t_a = <<?_(P0_free, '32'):32, ?_((length(P0_log)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_times, '32'):32, ?_(P1_money, '32'):32, ?_(P1_is_double, '32'):32>> || #money_tree_shaked{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, times = P1_times, money = P1_money, is_double = P1_is_double} <- P0_log]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14707:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14707), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14707:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14708), {P0_ret, P0_msg, P0_free, P0_coin, P0_is_double}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_free, '32'):32, ?_(P0_coin, '32'):32, ?_(P0_is_double, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14708:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14708), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14708:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14709), {P0_ret, P0_msg, P0_free, P0_coin}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_free, '32'):32, ?_(P0_coin, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14709:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14709), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14709:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14720), {P0_useId, P0_items, P0_log}) ->
    D_a_t_a = <<?_(P0_useId, '32'):32, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_award_id, '32'):32>> || P1_award_id <- P0_items]))/binary, ?_((length(P0_log)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_award_id, '32'):32>> || #lottery_camp_log{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, award_id = P1_award_id} <- P0_log]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14720:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14720), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14720:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14721), {P0_ret, P0_msg, P0_award_id}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_award_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14721:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14721), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14721:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14722), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14722:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14722), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14722:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14723), {P0_free, P0_times, P0_sum_exp, P0_last_exp, P0_exp, P0_gold}) ->
    D_a_t_a = <<?_(P0_free, '8'):8, ?_(P0_times, '16'):16, ?_(P0_sum_exp, '32'):32, ?_(P0_last_exp, '32'):32, ?_(P0_exp, '32'):32, ?_(P0_gold, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14723:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14723), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14723:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14724), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14724:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14724), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14724:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14725), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14725:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14725), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14725:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14730), {P0_useId, P0_pos, P0_items, P0_log}) ->
    D_a_t_a = <<?_(P0_useId, '32'):32, ?_(P0_pos, '32'):32, ?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_pos, '32'):32, ?_(P1_award_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_num, '16'):16>> || {P1_pos, P1_award_id, P1_bind, P1_num} <- P0_items]))/binary, ?_((length(P0_log)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_award_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_num, '16'):16>> || #lottery_rich_log{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, award_id = P1_award_id, bind = P1_bind, num = P1_num} <- P0_log]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14730:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14730), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14730:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14731), {P0_ret, P0_msg, P0_pos, P0_val}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_pos, '32'):32, ?_(P0_val, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14731:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14731), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14731:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14732), {P0_ret, P0_msg, P0_pos}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_pos, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14732:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14732), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14732:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14733), {P0_id, P0_log, P0_x, P0_y}) ->
    D_a_t_a = <<?_(P0_id, '16'):16, ?_((length(P0_log)), "16"):16, (list_to_binary([<<?_(P1_index, '8'):8>> || P1_index <- P0_log]))/binary, ?_(P0_x, '16'):16, ?_(P0_y, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14733:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14733), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14733:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14734), {P0_ret, P0_msg, P0_index, P0_x, P0_y}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_index, '8'):8, ?_(P0_x, '16'):16, ?_(P0_y, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14734:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14734), {P0_index}) ->
    D_a_t_a = <<?_(P0_index, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14734:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14735), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14735:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14735), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14735:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14736), {P0_log}) ->
    D_a_t_a = <<?_((length(P0_log)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_item_id, '32'):32>> || {P1_rid, P1_srv_id, P1_name, P1_item_id} <- P0_log]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14736:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14736), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14736:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14737), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14737:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14737), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14737:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14738), {P0_ring, P0_reward_list}) ->
    D_a_t_a = <<?_(P0_ring, '8'):8, ?_((length(P0_reward_list)), "16"):16, (list_to_binary([<<?_(P1_award_id, '32'):32>> || P1_award_id <- P0_reward_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14738:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14738), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14738:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14739), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14739:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14739), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14739:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14740), {P0_reward}) ->
    D_a_t_a = <<?_(P0_reward, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14740:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14740), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14740:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14741), {P0_ret, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14741:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14741), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14741:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
