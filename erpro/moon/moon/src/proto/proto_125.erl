%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_125).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("item.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(12500), {P0_result, P0_msg, P0_bless, P0_bless_max}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_bless, '16'):16, ?_(P0_bless_max, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12500:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12500), {P0_mount_id}) ->
    D_a_t_a = <<?_(P0_mount_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12500:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12501), {P0_base_id, P0_bind, P0_enchant, P0_enchant_fail, P0_bless, P0_bless_max, P0_item_one_id, P0_item_two_id, P0_item_one_num, P0_item_two_num, P0_attr, P0_max_base_attr}) ->
    D_a_t_a = <<?_(P0_base_id, '32'):32, ?_(P0_bind, '8'):8, ?_(P0_enchant, '8/signed'):8/signed, ?_(P0_enchant_fail, '8'):8, ?_(P0_bless, '16'):16, ?_(P0_bless_max, '16'):16, ?_(P0_item_one_id, '32'):32, ?_(P0_item_two_id, '32'):32, ?_(P0_item_one_num, '16'):16, ?_(P0_item_two_num, '16'):16, ?_((length(P0_attr)), "16"):16, (list_to_binary([<<?_(P1_attr_name, '32'):32, ?_(P1_flag, '32'):32, ?_(P1_value, '32'):32>> || {P1_attr_name, P1_flag, P1_value} <- P0_attr]))/binary, ?_((length(P0_max_base_attr)), "16"):16, (list_to_binary([<<?_(P1_attr_name, '32'):32, ?_(P1_flag, '32'):32, ?_(P1_value, '32'):32>> || {P1_attr_name, P1_flag, P1_value} <- P0_max_base_attr]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12501:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12501), {P0_mount_id}) ->
    D_a_t_a = <<?_(P0_mount_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12501:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12502), {P0_flag, P0_AddExp, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_(P0_AddExp, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12502:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12502), {P0_mount_id, P0_itemlist}) ->
    D_a_t_a = <<?_(P0_mount_id, '32'):32, ?_((length(P0_itemlist)), "16"):16, (list_to_binary([<<?_(P1_item_id, '32'):32, ?_(P1_quantity, '8'):8>> || [P1_item_id, P1_quantity] <- P0_itemlist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12502:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12503), {P0_items}) ->
    D_a_t_a = <<?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_base_id, '32'):32, ?_(P1_bind, '8'):8, ?_(P1_upgrade, '8'):8, ?_(P1_enchant, '8/signed'):8/signed, ?_(P1_enchant_fail, '8'):8, ?_(P1_quantity, '8'):8, ?_(P1_status, '8'):8, ?_(P1_pos, '16'):16, ?_(P1_lasttime, '32'):32, ?_(P1_durability, '32/signed'):32/signed, ?_(P1_craft, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary, ?_((length(P1_max_base_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_max_base_attr]))/binary, ?_((length(P1_extra)), "16"):16, (list_to_binary([<<?_(P2_type, '16'):16, ?_(P2_value, '32'):32, ?_((byte_size(P2_str)), "16"):16, ?_(P2_str, bin)/binary>> || {P2_type, P2_value, P2_str} <- P1_extra]))/binary>> || #item{id = P1_id, base_id = P1_base_id, bind = P1_bind, upgrade = P1_upgrade, enchant = P1_enchant, enchant_fail = P1_enchant_fail, quantity = P1_quantity, status = P1_status, pos = P1_pos, lasttime = P1_lasttime, durability = P1_durability, craft = P1_craft, attr = P1_attr, max_base_attr = P1_max_base_attr, extra = P1_extra} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12503:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12503), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12503:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12504), {P0_flag, P0_mount_id, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_(P0_mount_id, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12504:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12504), {P0_mount_id}) ->
    D_a_t_a = <<?_(P0_mount_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12504:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12505), {P0_flag, P0_mount_id, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_(P0_mount_id, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12505:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12505), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12505:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12506), {P0_flag, P0_skinId, P0_grade, P0_old_skinId, P0_old_grade, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_(P0_skinId, '32'):32, ?_(P0_grade, '8'):8, ?_(P0_old_skinId, '32'):32, ?_(P0_old_grade, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12506:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12506), {P0_skinId, P0_grade}) ->
    D_a_t_a = <<?_(P0_skinId, '32'):32, ?_(P0_grade, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12506:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12507), {P0_skins}) ->
    D_a_t_a = <<?_((length(P0_skins)), "16"):16, (list_to_binary([<<?_(P1_skinId, '32'):32, ?_(P1_flag, '8'):8>> || {P1_skinId, P1_flag} <- P0_skins]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12507:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12507), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12507:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12508), {P0_flag, P0_mount_id, P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_(P0_mount_id, '32'):32, ?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12508:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12508), {P0_mountId}) ->
    D_a_t_a = <<?_(P0_mountId, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12508:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12509), {P0_flag, P0_mount_id, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_(P0_mount_id, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12509:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12509), {P0_mount_id}) ->
    D_a_t_a = <<?_(P0_mount_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12509:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12510), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12510:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12510), {P0_mount_id}) ->
    D_a_t_a = <<?_(P0_mount_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12510:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12511), {P0_flag, P0_msg, P0_grade, P0_xisui_list}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_grade, '8'):8, ?_((length(P0_xisui_list)), "16"):16, (list_to_binary([<<?_(P1_index, '8'):8, ?_(P1_quality, '8'):8, ?_((length(P1_grow_list)), "16"):16, (list_to_binary([<<?_(P2_key, '8'):8, ?_(P2_val, '32'):32>> || {P2_key, P2_val} <- P1_grow_list]))/binary>> || {P1_index, P1_quality, P1_grow_list} <- P0_xisui_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12511:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12511), {P0_mount_id, P0_bind}) ->
    D_a_t_a = <<?_(P0_mount_id, '32'):32, ?_(P0_bind, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12511:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12512), {P0_grade, P0_xisui_list}) ->
    D_a_t_a = <<?_(P0_grade, '8'):8, ?_((length(P0_xisui_list)), "16"):16, (list_to_binary([<<?_(P1_index, '8'):8, ?_(P1_quality, '8'):8, ?_((length(P1_grow_list)), "16"):16, (list_to_binary([<<?_(P2_key, '8'):8, ?_(P2_val, '32'):32>> || {P2_key, P2_val} <- P1_grow_list]))/binary>> || {P1_index, P1_quality, P1_grow_list} <- P0_xisui_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12512:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12512), {P0_mount_id}) ->
    D_a_t_a = <<?_(P0_mount_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12512:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12513), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12513:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12513), {P0_mount_id, P0_index}) ->
    D_a_t_a = <<?_(P0_mount_id, '32'):32, ?_(P0_index, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12513:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
