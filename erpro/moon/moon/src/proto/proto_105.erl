%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_105).
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

pack(srv, ?_CMD(10500), {P0_lev, P0_psychic}) ->
    D_a_t_a = <<?_(P0_lev, '8'):8, ?_(P0_psychic, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10500:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10500), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10500:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10501), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10501:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10501), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10501:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10502), {P0_Sucrate, P0_FailAdd, P0_GuildAdd, P0_VipAdd, P0_ManorAdd}) ->
    D_a_t_a = <<?_(P0_Sucrate, '8'):8, ?_(P0_FailAdd, '8'):8, ?_(P0_GuildAdd, '8'):8, ?_(P0_VipAdd, '8'):8, ?_(P0_ManorAdd, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10502:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10502), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10502:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10503), {P0_msg, P0_flags}) ->
    D_a_t_a = <<?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_((length(P0_flags)), "16"):16, (list_to_binary([<<?_(P1_flag, '8'):8>> || P1_flag <- P0_flags]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10503:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10503), {P0_id, P0_is_auto_buy}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_is_auto_buy, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10503:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10505), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10505:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10505), {P0_id, P0_is_auto_buy}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_is_auto_buy, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10505:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10507), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10507:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10507), {P0_id, P0_paperid, P0_holepos}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_paperid, '32'):32, ?_(P0_holepos, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10507:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10508), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10508:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10508), {P0_id, P0_stoneid, P0_holepos}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_stoneid, '32'):32, ?_(P0_holepos, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10508:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10509), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10509:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10509), {P0_id, P0_stoneid, P0_holepos}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_stoneid, '32'):32, ?_(P0_holepos, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10509:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10510), {P0_flag, P0_msg, P0_polishlist}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_((length(P0_polishlist)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_(P1_bind, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary>> || {P1_id, P1_bind, P1_attr} <- P0_polishlist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10510:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10510), {P0_id, P0_mode, P0_auto_buy}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_mode, '8'):8, ?_(P0_auto_buy, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10510:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10511), {P0_baseid, P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_baseid, '32'):32, ?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10511:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10511), {P0_baseid, P0_type, P0_num, P0_mode}) ->
    D_a_t_a = <<?_(P0_baseid, '32'):32, ?_(P0_type, '8'):8, ?_(P0_num, '16'):16, ?_(P0_mode, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10511:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10512), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10512:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10512), {P0_stonelist, P0_paperid}) ->
    D_a_t_a = <<?_((length(P0_stonelist)), "16"):16, (list_to_binary([<<?_(P1_stoneid, '32'):32>> || P1_stoneid <- P0_stonelist]))/binary, ?_(P0_paperid, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10512:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10513), {P0_base_id, P0_bind, P0_upgrade, P0_enchant, P0_enchant_fail, P0_durability, P0_craft, P0_attr, P0_max_base_attr, P0_extra}) ->
    D_a_t_a = <<?_(P0_base_id, '32'):32, ?_(P0_bind, '8'):8, ?_(P0_upgrade, '8'):8, ?_(P0_enchant, '8/signed'):8/signed, ?_(P0_enchant_fail, '8'):8, ?_(P0_durability, '32/signed'):32/signed, ?_(P0_craft, '8'):8, ?_((length(P0_attr)), "16"):16, (list_to_binary([<<?_(P1_attr_name, '32'):32, ?_(P1_flag, '32'):32, ?_(P1_value, '32'):32>> || {P1_attr_name, P1_flag, P1_value} <- P0_attr]))/binary, ?_((length(P0_max_base_attr)), "16"):16, (list_to_binary([<<?_(P1_attr_name, '32'):32, ?_(P1_flag, '32'):32, ?_(P1_value, '32'):32>> || {P1_attr_name, P1_flag, P1_value} <- P0_max_base_attr]))/binary, ?_((length(P0_extra)), "16"):16, (list_to_binary([<<?_(P1_type, '16'):16, ?_(P1_value, '32'):32, ?_((byte_size(P1_str)), "16"):16, ?_(P1_str, bin)/binary>> || {P1_type, P1_value, P1_str} <- P0_extra]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10513:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10513), {P0_lowid, P0_lowstoragetype, P0_highid, P0_highstoragetype, P0_mode}) ->
    D_a_t_a = <<?_(P0_lowid, '32'):32, ?_(P0_lowstoragetype, '8'):8, ?_(P0_highid, '32'):32, ?_(P0_highstoragetype, '8'):8, ?_(P0_mode, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10513:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10514), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10514:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10514), {P0_lowid, P0_lowstoragetype, P0_highid, P0_highstoragetype, P0_mode}) ->
    D_a_t_a = <<?_(P0_lowid, '32'):32, ?_(P0_lowstoragetype, '8'):8, ?_(P0_highid, '32'):32, ?_(P0_highstoragetype, '8'):8, ?_(P0_mode, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10514:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10515), {P0_base_id, P0_bind, P0_upgrade, P0_enchant, P0_enchant_fail, P0_durability, P0_craft, P0_attr, P0_max_base_attr, P0_extra}) ->
    D_a_t_a = <<?_(P0_base_id, '32'):32, ?_(P0_bind, '8'):8, ?_(P0_upgrade, '8'):8, ?_(P0_enchant, '8/signed'):8/signed, ?_(P0_enchant_fail, '8'):8, ?_(P0_durability, '32/signed'):32/signed, ?_(P0_craft, '8'):8, ?_((length(P0_attr)), "16"):16, (list_to_binary([<<?_(P1_attr_name, '32'):32, ?_(P1_flag, '32'):32, ?_(P1_value, '32'):32>> || {P1_attr_name, P1_flag, P1_value} <- P0_attr]))/binary, ?_((length(P0_max_base_attr)), "16"):16, (list_to_binary([<<?_(P1_attr_name, '32'):32, ?_(P1_flag, '32'):32, ?_(P1_value, '32'):32>> || {P1_attr_name, P1_flag, P1_value} <- P0_max_base_attr]))/binary, ?_((length(P0_extra)), "16"):16, (list_to_binary([<<?_(P1_type, '16'):16, ?_(P1_value, '32'):32, ?_((byte_size(P1_str)), "16"):16, ?_(P1_str, bin)/binary>> || {P1_type, P1_value, P1_str} <- P0_extra]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10515:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10515), {P0_storagetype1, P0_id1, P0_storagetype2, P0_id2, P0_mode, P0_type}) ->
    D_a_t_a = <<?_(P0_storagetype1, '8'):8, ?_(P0_id1, '32'):32, ?_(P0_storagetype2, '8'):8, ?_(P0_id2, '32'):32, ?_(P0_mode, '8'):8, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10515:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10516), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10516:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10516), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10516:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10518), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10518:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10518), {P0_id, P0_stonepos}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_stonepos, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10518:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10519), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10519:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10519), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10519:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10520), {P0_base_id, P0_bind, P0_upgrade, P0_enchant, P0_enchant_fail, P0_durability, P0_craft, P0_attr, P0_max_base_attr, P0_extra}) ->
    D_a_t_a = <<?_(P0_base_id, '32'):32, ?_(P0_bind, '8'):8, ?_(P0_upgrade, '8'):8, ?_(P0_enchant, '8/signed'):8/signed, ?_(P0_enchant_fail, '8'):8, ?_(P0_durability, '32/signed'):32/signed, ?_(P0_craft, '8'):8, ?_((length(P0_attr)), "16"):16, (list_to_binary([<<?_(P1_attr_name, '32'):32, ?_(P1_flag, '32'):32, ?_(P1_value, '32'):32>> || {P1_attr_name, P1_flag, P1_value} <- P0_attr]))/binary, ?_((length(P0_max_base_attr)), "16"):16, (list_to_binary([<<?_(P1_attr_name, '32'):32, ?_(P1_flag, '32'):32, ?_(P1_value, '32'):32>> || {P1_attr_name, P1_flag, P1_value} <- P0_max_base_attr]))/binary, ?_((length(P0_extra)), "16"):16, (list_to_binary([<<?_(P1_type, '16'):16, ?_(P1_value, '32'):32, ?_((byte_size(P1_str)), "16"):16, ?_(P1_str, bin)/binary>> || {P1_type, P1_value, P1_str} <- P0_extra]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10520:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10520), {P0_id, P0_storagetype, P0_mode}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_storagetype, '8'):8, ?_(P0_mode, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10520:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10521), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10521:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10521), {P0_id, P0_storagetype, P0_mode}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_storagetype, '8'):8, ?_(P0_mode, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10521:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10522), {P0_flag, P0_msg, P0_polishlist}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_((length(P0_polishlist)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_(P1_bind, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary>> || {P1_id, P1_bind, P1_attr} <- P0_polishlist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10522:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10522), {P0_id, P0_mode, P0_auto_buy}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_mode, '8'):8, ?_(P0_auto_buy, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10522:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10523), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10523:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10523), {P0_id, P0_mode, P0_polish_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_mode, '8'):8, ?_(P0_polish_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10523:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10524), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10524:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10524), {P0_Idlist}) ->
    D_a_t_a = <<?_((length(P0_Idlist)), "16"):16, (list_to_binary([<<?_(P1_Id, '32'):32>> || P1_Id <- P0_Idlist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10524:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10525), {P0_enchant, P0_point}) ->
    D_a_t_a = <<?_(P0_enchant, '8'):8, ?_(P0_point, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10525:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10525), {P0_storagetype, P0_id}) ->
    D_a_t_a = <<?_(P0_storagetype, '8'):8, ?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10525:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10526), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10526:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10526), {P0_storagetype, P0_id}) ->
    D_a_t_a = <<?_(P0_storagetype, '8'):8, ?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10526:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10527), {P0_base_id, P0_bind, P0_upgrade, P0_enchant, P0_enchant_fail, P0_durability, P0_craft, P0_attr, P0_max_base_attr, P0_extra}) ->
    D_a_t_a = <<?_(P0_base_id, '32'):32, ?_(P0_bind, '8'):8, ?_(P0_upgrade, '8'):8, ?_(P0_enchant, '8/signed'):8/signed, ?_(P0_enchant_fail, '8'):8, ?_(P0_durability, '32/signed'):32/signed, ?_(P0_craft, '8'):8, ?_((length(P0_attr)), "16"):16, (list_to_binary([<<?_(P1_attr_name, '32'):32, ?_(P1_flag, '32'):32, ?_(P1_value, '32'):32>> || {P1_attr_name, P1_flag, P1_value} <- P0_attr]))/binary, ?_((length(P0_max_base_attr)), "16"):16, (list_to_binary([<<?_(P1_attr_name, '32'):32, ?_(P1_flag, '32'):32, ?_(P1_value, '32'):32>> || {P1_attr_name, P1_flag, P1_value} <- P0_max_base_attr]))/binary, ?_((length(P0_extra)), "16"):16, (list_to_binary([<<?_(P1_type, '16'):16, ?_(P1_value, '32'):32, ?_((byte_size(P1_str)), "16"):16, ?_(P1_str, bin)/binary>> || {P1_type, P1_value, P1_str} <- P0_extra]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10527:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10527), {P0_storagetype, P0_id}) ->
    D_a_t_a = <<?_(P0_storagetype, '8'):8, ?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10527:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10528), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10528:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10528), {P0_storagetype, P0_id, P0_mode}) ->
    D_a_t_a = <<?_(P0_storagetype, '8'):8, ?_(P0_id, '32'):32, ?_(P0_mode, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10528:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10529), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10529:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10529), {P0_embed_id, P0_quench_id, P0_quench_id_2}) ->
    D_a_t_a = <<?_(P0_embed_id, '32'):32, ?_(P0_quench_id, '32'):32, ?_(P0_quench_id_2, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10529:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10530), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10530:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10530), {P0_base_id, P0_round_num, P0_is_paper, P0_mode}) ->
    D_a_t_a = <<?_(P0_base_id, '32'):32, ?_(P0_round_num, '8'):8, ?_(P0_is_paper, '8'):8, ?_(P0_mode, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10530:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10531), {P0_base_id, P0_bind, P0_upgrade, P0_enchant, P0_enchant_fail, P0_durability, P0_craft, P0_attr, P0_extra}) ->
    D_a_t_a = <<?_(P0_base_id, '32'):32, ?_(P0_bind, '8'):8, ?_(P0_upgrade, '8'):8, ?_(P0_enchant, '8/signed'):8/signed, ?_(P0_enchant_fail, '8'):8, ?_(P0_durability, '32/signed'):32/signed, ?_(P0_craft, '8'):8, ?_((length(P0_attr)), "16"):16, (list_to_binary([<<?_(P1_attr_name, '32'):32, ?_(P1_flag, '32'):32, ?_(P1_value, '32'):32>> || {P1_attr_name, P1_flag, P1_value} <- P0_attr]))/binary, ?_((length(P0_extra)), "16"):16, (list_to_binary([<<?_(P1_type, '16'):16, ?_(P1_value, '32'):32, ?_((byte_size(P1_str)), "16"):16, ?_(P1_str, bin)/binary>> || {P1_type, P1_value, P1_str} <- P0_extra]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10531:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10531), {P0_storage_type, P0_eqm_id}) ->
    D_a_t_a = <<?_(P0_storage_type, '8'):8, ?_(P0_eqm_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10531:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10532), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10532:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10532), {P0_storage_type, P0_eqm_id}) ->
    D_a_t_a = <<?_(P0_storage_type, '8'):8, ?_(P0_eqm_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10532:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10533), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10533:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10533), {P0_storage_type, P0_eqm_id, P0_stone_id}) ->
    D_a_t_a = <<?_(P0_storage_type, '8'):8, ?_(P0_eqm_id, '32'):32, ?_(P0_stone_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10533:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10534), {P0_flag, P0_msg, P0_polishlist}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_((length(P0_polishlist)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_((length(P1_attr)), "16"):16, (list_to_binary([<<?_(P2_attr_name, '32'):32, ?_(P2_flag, '32'):32, ?_(P2_value, '32'):32>> || {P2_attr_name, P2_flag, P2_value} <- P1_attr]))/binary>> || {P1_id, P1_attr} <- P0_polishlist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10534:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10534), {P0_mode, P0_storage_type, P0_eqm_id}) ->
    D_a_t_a = <<?_(P0_mode, '8'):8, ?_(P0_storage_type, '8'):8, ?_(P0_eqm_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10534:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10535), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10535:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10535), {P0_storage_type, P0_eqm_id, P0_polish_id}) ->
    D_a_t_a = <<?_(P0_storage_type, '8'):8, ?_(P0_eqm_id, '32'):32, ?_(P0_polish_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10535:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10536), {P0_lev, P0_exp}) ->
    D_a_t_a = <<?_(P0_lev, '8'):8, ?_(P0_exp, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10536:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10536), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10536:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10537), {P0_lev, P0_exp}) ->
    D_a_t_a = <<?_(P0_lev, '8'):8, ?_(P0_exp, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10537:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10537), {P0_rid, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_rid, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10537:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10538), {P0_ret, P0_lev, P0_exp, P0_msg}) ->
    D_a_t_a = <<?_(P0_ret, '8'):8, ?_(P0_lev, '8'):8, ?_(P0_exp, '16'):16, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10538:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10538), {P0_num}) ->
    D_a_t_a = <<?_(P0_num, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10538:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10539), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10539:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10539), {P0_storage_type, P0_eqm_id}) ->
    D_a_t_a = <<?_(P0_storage_type, '8'):8, ?_(P0_eqm_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10539:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10540), {P0_base_id, P0_bind, P0_upgrade, P0_enchant, P0_enchant_fail, P0_durability, P0_craft, P0_attr, P0_extra}) ->
    D_a_t_a = <<?_(P0_base_id, '32'):32, ?_(P0_bind, '8'):8, ?_(P0_upgrade, '8'):8, ?_(P0_enchant, '8/signed'):8/signed, ?_(P0_enchant_fail, '8'):8, ?_(P0_durability, '32/signed'):32/signed, ?_(P0_craft, '8'):8, ?_((length(P0_attr)), "16"):16, (list_to_binary([<<?_(P1_attr_name, '32'):32, ?_(P1_flag, '32'):32, ?_(P1_value, '32'):32>> || {P1_attr_name, P1_flag, P1_value} <- P0_attr]))/binary, ?_((length(P0_extra)), "16"):16, (list_to_binary([<<?_(P1_type, '16'):16, ?_(P1_value, '32'):32, ?_((byte_size(P1_str)), "16"):16, ?_(P1_str, bin)/binary>> || {P1_type, P1_value, P1_str} <- P0_extra]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10540:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10540), {P0_storage_type, P0_eqm_id}) ->
    D_a_t_a = <<?_(P0_storage_type, '8'):8, ?_(P0_eqm_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10540:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10541), {P0_luck}) ->
    D_a_t_a = <<?_(P0_luck, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10541:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10541), {P0_storage_type, P0_eqm_id}) ->
    D_a_t_a = <<?_(P0_storage_type, '8'):8, ?_(P0_eqm_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10541:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10542), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10542:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10542), {P0_storagetype, P0_id, P0_signature, P0_color}) ->
    D_a_t_a = <<?_(P0_storagetype, '8'):8, ?_(P0_id, '32'):32, ?_((byte_size(P0_signature)), "16"):16, ?_(P0_signature, bin)/binary, ?_(P0_color, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10542:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10543), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10543:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10543), {P0_stone_1, P0_stone_2, P0_paperid}) ->
    D_a_t_a = <<?_(P0_stone_1, '32'):32, ?_(P0_stone_2, '32'):32, ?_(P0_paperid, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10543:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10544), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10544:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10544), {P0_id, P0_is_use}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_is_use, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10544:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10545), {P0_flag, P0_stone_id, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_(P0_stone_id, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10545:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10545), {P0_id, P0_hole_pos}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_hole_pos, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10545:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 10502, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 10502, _B0) ->
    {P0_Sucrate, _B1} = lib_proto:read_uint8(_B0),
    {P0_FailAdd, _B2} = lib_proto:read_uint8(_B1),
    {P0_GuildAdd, _B3} = lib_proto:read_uint8(_B2),
    {P0_VipAdd, _B4} = lib_proto:read_uint8(_B3),
    {P0_ManorAdd, _B5} = lib_proto:read_uint8(_B4),
    {ok, {P0_Sucrate, P0_FailAdd, P0_GuildAdd, P0_VipAdd, P0_ManorAdd}};

unpack(srv, 10503, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_is_auto_buy, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_id, P0_is_auto_buy}};
unpack(cli, 10503, _B0) ->
    {P0_msg, _B1} = lib_proto:read_string(_B0),
    {P0_flags, _B4} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_flag, _B3} = lib_proto:read_uint8(_B2),
        {P1_flag, _B3}
    end),
    {ok, {P0_msg, P0_flags}};

unpack(srv, 10505, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_is_auto_buy, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_id, P0_is_auto_buy}};
unpack(cli, 10505, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 10507, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_paperid, _B2} = lib_proto:read_uint32(_B1),
    {P0_holepos, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_id, P0_paperid, P0_holepos}};
unpack(cli, 10507, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 10508, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_stoneid, _B2} = lib_proto:read_uint32(_B1),
    {P0_holepos, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_id, P0_stoneid, P0_holepos}};
unpack(cli, 10508, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 10509, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_stoneid, _B2} = lib_proto:read_uint32(_B1),
    {P0_holepos, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_id, P0_stoneid, P0_holepos}};
unpack(cli, 10509, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 10510, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_mode, _B2} = lib_proto:read_uint8(_B1),
    {P0_auto_buy, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_id, P0_mode, P0_auto_buy}};
unpack(cli, 10510, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {P0_polishlist, _B11} = lib_proto:read_array(_B2, fun(_B3) ->
        {P1_id, _B4} = lib_proto:read_uint8(_B3),
        {P1_bind, _B5} = lib_proto:read_uint8(_B4),
        {P1_attr, _B10} = lib_proto:read_array(_B5, fun(_B6) ->
            {P2_attr_name, _B7} = lib_proto:read_uint32(_B6),
            {P2_flag, _B8} = lib_proto:read_uint32(_B7),
            {P2_value, _B9} = lib_proto:read_uint32(_B8),
            {[P2_attr_name, P2_flag, P2_value], _B9}
        end),
        {[P1_id, P1_bind, P1_attr], _B10}
    end),
    {ok, {P0_flag, P0_msg, P0_polishlist}};

unpack(srv, 10511, _B0) ->
    {P0_baseid, _B1} = lib_proto:read_uint32(_B0),
    {P0_type, _B2} = lib_proto:read_uint8(_B1),
    {P0_num, _B3} = lib_proto:read_uint16(_B2),
    {P0_mode, _B4} = lib_proto:read_uint8(_B3),
    {ok, {P0_baseid, P0_type, P0_num, P0_mode}};
unpack(cli, 10511, _B0) ->
    {P0_baseid, _B1} = lib_proto:read_uint32(_B0),
    {P0_flag, _B2} = lib_proto:read_uint8(_B1),
    {P0_msg, _B3} = lib_proto:read_string(_B2),
    {ok, {P0_baseid, P0_flag, P0_msg}};

unpack(srv, 10512, _B0) ->
    {P0_stonelist, _B3} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_stoneid, _B2} = lib_proto:read_uint32(_B1),
        {P1_stoneid, _B2}
    end),
    {P0_paperid, _B4} = lib_proto:read_uint32(_B3),
    {ok, {P0_stonelist, P0_paperid}};
unpack(cli, 10512, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 10515, _B0) ->
    {P0_storagetype1, _B1} = lib_proto:read_uint8(_B0),
    {P0_id1, _B2} = lib_proto:read_uint32(_B1),
    {P0_storagetype2, _B3} = lib_proto:read_uint8(_B2),
    {P0_id2, _B4} = lib_proto:read_uint32(_B3),
    {P0_mode, _B5} = lib_proto:read_uint8(_B4),
    {P0_type, _B6} = lib_proto:read_uint8(_B5),
    {ok, {P0_storagetype1, P0_id1, P0_storagetype2, P0_id2, P0_mode, P0_type}};
unpack(cli, 10515, _B0) ->
    {P0_base_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_bind, _B2} = lib_proto:read_uint8(_B1),
    {P0_upgrade, _B3} = lib_proto:read_uint8(_B2),
    {P0_enchant, _B4} = lib_proto:read_int8(_B3),
    {P0_enchant_fail, _B5} = lib_proto:read_uint8(_B4),
    {P0_durability, _B6} = lib_proto:read_int32(_B5),
    {P0_craft, _B7} = lib_proto:read_uint8(_B6),
    {P0_attr, _B12} = lib_proto:read_array(_B7, fun(_B8) ->
        {P1_attr_name, _B9} = lib_proto:read_uint32(_B8),
        {P1_flag, _B10} = lib_proto:read_uint32(_B9),
        {P1_value, _B11} = lib_proto:read_uint32(_B10),
        {[P1_attr_name, P1_flag, P1_value], _B11}
    end),
    {P0_max_base_attr, _B17} = lib_proto:read_array(_B12, fun(_B13) ->
        {P1_attr_name, _B14} = lib_proto:read_uint32(_B13),
        {P1_flag, _B15} = lib_proto:read_uint32(_B14),
        {P1_value, _B16} = lib_proto:read_uint32(_B15),
        {[P1_attr_name, P1_flag, P1_value], _B16}
    end),
    {P0_extra, _B22} = lib_proto:read_array(_B17, fun(_B18) ->
        {P1_type, _B19} = lib_proto:read_uint16(_B18),
        {P1_value, _B20} = lib_proto:read_uint32(_B19),
        {P1_str, _B21} = lib_proto:read_string(_B20),
        {[P1_type, P1_value, P1_str], _B21}
    end),
    {ok, {P0_base_id, P0_bind, P0_upgrade, P0_enchant, P0_enchant_fail, P0_durability, P0_craft, P0_attr, P0_max_base_attr, P0_extra}};

unpack(srv, 10516, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_id}};
unpack(cli, 10516, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 10518, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_stonepos, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_id, P0_stonepos}};
unpack(cli, 10518, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 10522, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_mode, _B2} = lib_proto:read_uint8(_B1),
    {P0_auto_buy, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_id, P0_mode, P0_auto_buy}};
unpack(cli, 10522, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {P0_polishlist, _B11} = lib_proto:read_array(_B2, fun(_B3) ->
        {P1_id, _B4} = lib_proto:read_uint8(_B3),
        {P1_bind, _B5} = lib_proto:read_uint8(_B4),
        {P1_attr, _B10} = lib_proto:read_array(_B5, fun(_B6) ->
            {P2_attr_name, _B7} = lib_proto:read_uint32(_B6),
            {P2_flag, _B8} = lib_proto:read_uint32(_B7),
            {P2_value, _B9} = lib_proto:read_uint32(_B8),
            {[P2_attr_name, P2_flag, P2_value], _B9}
        end),
        {[P1_id, P1_bind, P1_attr], _B10}
    end),
    {ok, {P0_flag, P0_msg, P0_polishlist}};

unpack(srv, 10523, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_mode, _B2} = lib_proto:read_uint8(_B1),
    {P0_polish_id, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_id, P0_mode, P0_polish_id}};
unpack(cli, 10523, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 10527, _B0) ->
    {P0_storagetype, _B1} = lib_proto:read_uint8(_B0),
    {P0_id, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_storagetype, P0_id}};
unpack(cli, 10527, _B0) ->
    {P0_base_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_bind, _B2} = lib_proto:read_uint8(_B1),
    {P0_upgrade, _B3} = lib_proto:read_uint8(_B2),
    {P0_enchant, _B4} = lib_proto:read_int8(_B3),
    {P0_enchant_fail, _B5} = lib_proto:read_uint8(_B4),
    {P0_durability, _B6} = lib_proto:read_int32(_B5),
    {P0_craft, _B7} = lib_proto:read_uint8(_B6),
    {P0_attr, _B12} = lib_proto:read_array(_B7, fun(_B8) ->
        {P1_attr_name, _B9} = lib_proto:read_uint32(_B8),
        {P1_flag, _B10} = lib_proto:read_uint32(_B9),
        {P1_value, _B11} = lib_proto:read_uint32(_B10),
        {[P1_attr_name, P1_flag, P1_value], _B11}
    end),
    {P0_max_base_attr, _B17} = lib_proto:read_array(_B12, fun(_B13) ->
        {P1_attr_name, _B14} = lib_proto:read_uint32(_B13),
        {P1_flag, _B15} = lib_proto:read_uint32(_B14),
        {P1_value, _B16} = lib_proto:read_uint32(_B15),
        {[P1_attr_name, P1_flag, P1_value], _B16}
    end),
    {P0_extra, _B22} = lib_proto:read_array(_B17, fun(_B18) ->
        {P1_type, _B19} = lib_proto:read_uint16(_B18),
        {P1_value, _B20} = lib_proto:read_uint32(_B19),
        {P1_str, _B21} = lib_proto:read_string(_B20),
        {[P1_type, P1_value, P1_str], _B21}
    end),
    {ok, {P0_base_id, P0_bind, P0_upgrade, P0_enchant, P0_enchant_fail, P0_durability, P0_craft, P0_attr, P0_max_base_attr, P0_extra}};

unpack(srv, 10528, _B0) ->
    {P0_storagetype, _B1} = lib_proto:read_uint8(_B0),
    {P0_id, _B2} = lib_proto:read_uint32(_B1),
    {P0_mode, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_storagetype, P0_id, P0_mode}};
unpack(cli, 10528, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 10543, _B0) ->
    {P0_stone_1, _B1} = lib_proto:read_uint32(_B0),
    {P0_stone_2, _B2} = lib_proto:read_uint32(_B1),
    {P0_paperid, _B3} = lib_proto:read_uint32(_B2),
    {ok, {P0_stone_1, P0_stone_2, P0_paperid}};
unpack(cli, 10543, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 10544, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_is_use, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_id, P0_is_use}};
unpack(cli, 10544, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_flag, P0_msg}};

unpack(srv, 10545, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_hole_pos, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_id, P0_hole_pos}};
unpack(cli, 10545, _B0) ->
    {P0_flag, _B1} = lib_proto:read_uint8(_B0),
    {P0_stone_id, _B2} = lib_proto:read_uint32(_B1),
    {P0_msg, _B3} = lib_proto:read_string(_B2),
    {ok, {P0_flag, P0_stone_id, P0_msg}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
