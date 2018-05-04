%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_179).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("soul_world.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(17900), {P0_orange_luck, P0_purple_luck, P0_free_time, P0_spirits, P0_calleds}) ->
    D_a_t_a = <<?_(P0_orange_luck, '32'):32, ?_(P0_purple_luck, '32'):32, ?_(P0_free_time, '8'):8, ?_((length(P0_spirits)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '32'):32, ?_(P1_quality, '8'):8, ?_(P1_fc, '32'):32, ?_(P1_exp, '32'):32, ?_(P1_max_exp, '32'):32, ?_(P1_generation, '32'):32, ?_(P1_array_id, '8'):8, ?_((length(P1_magics)), "16"):16, (list_to_binary([<<?_(P2_type, '8'):8, ?_(P2_lev, '32'):32, ?_(P2_fc, '32'):32, ?_(P2_addition, '32'):32, ?_(P2_luck, '32'):32, ?_(P2_max_luck, '32'):32>> || #soul_world_spirit_magic{type = P2_type, lev = P2_lev, fc = P2_fc, addition = P2_addition, luck = P2_luck, max_luck = P2_max_luck} <- P1_magics]))/binary>> || #soul_world_spirit{id = P1_id, name = P1_name, lev = P1_lev, quality = P1_quality, fc = P1_fc, exp = P1_exp, max_exp = P1_max_exp, generation = P1_generation, array_id = P1_array_id, magics = P1_magics} <- P0_spirits]))/binary, ?_((length(P0_calleds)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '32'):32, ?_(P1_quality, '8'):8, ?_(P1_fc, '32'):32, ?_(P1_exp, '32'):32, ?_(P1_generation, '32'):32, ?_(P1_called, '8'):8>> || #soul_world_spirit{id = P1_id, name = P1_name, lev = P1_lev, quality = P1_quality, fc = P1_fc, exp = P1_exp, generation = P1_generation, called = P1_called} <- P0_calleds]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17900:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17900), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17900:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17901), {P0_flag, P0_msg, P0_is_batch, P0_orange_luck, P0_purple_luck, P0_free_time, P0_calleds}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_is_batch, '8'):8, ?_(P0_orange_luck, '32'):32, ?_(P0_purple_luck, '32'):32, ?_(P0_free_time, '8'):8, ?_((length(P0_calleds)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '32'):32, ?_(P1_quality, '8'):8, ?_(P1_fc, '32'):32, ?_(P1_exp, '32'):32, ?_(P1_generation, '32'):32, ?_(P1_called, '8'):8>> || #soul_world_spirit{id = P1_id, name = P1_name, lev = P1_lev, quality = P1_quality, fc = P1_fc, exp = P1_exp, generation = P1_generation, called = P1_called} <- P0_calleds]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17901:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17901), {P0_type, P0_is_batch}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_is_batch, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17901:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17902), {P0_flag, P0_msg, P0_id}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17902:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17902), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17902:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17903), {P0_flag, P0_AddExp, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_(P0_AddExp, '32'):32, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17903:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17903), {P0_id, P0_itemlist}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((length(P0_itemlist)), "16"):16, (list_to_binary([<<?_(P1_item_id, '32'):32, ?_(P1_quantity, '8'):8>> || [P1_item_id, P1_quantity] <- P0_itemlist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17903:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17904), {P0_id, P0_name, P0_lev, P0_quality, P0_fc, P0_exp, P0_max_exp, P0_generation, P0_array_id, P0_magics}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_lev, '32'):32, ?_(P0_quality, '8'):8, ?_(P0_fc, '32'):32, ?_(P0_exp, '32'):32, ?_(P0_max_exp, '32'):32, ?_(P0_generation, '32'):32, ?_(P0_array_id, '8'):8, ?_((length(P0_magics)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_lev, '32'):32, ?_(P1_fc, '32'):32, ?_(P1_addition, '32'):32, ?_(P1_luck, '32'):32, ?_(P1_max_luck, '32'):32>> || #soul_world_spirit_magic{type = P1_type, lev = P1_lev, fc = P1_fc, addition = P1_addition, luck = P1_luck, max_luck = P1_max_luck} <- P0_magics]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17904:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17904), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17904:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17905), {P0_arrays, P0_add_fc}) ->
    D_a_t_a = <<?_((length(P0_arrays)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_lev, '32'):32, ?_(P1_fc, '32'):32, ?_(P1_attr, '32'):32, ?_(P1_spirit_id, '32'):32, ?_(P1_upgrade_finish, '32'):32>> || #soul_world_array{id = P1_id, lev = P1_lev, fc = P1_fc, attr = P1_attr, spirit_id = P1_spirit_id, upgrade_finish = P1_upgrade_finish} <- P0_arrays]))/binary, ?_(P0_add_fc, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17905:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17905), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17905:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17906), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17906:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17906), {P0_spirit_id, P0_array_id}) ->
    D_a_t_a = <<?_(P0_spirit_id, '32'):32, ?_(P0_array_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17906:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17907), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17907:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17907), {P0_spirit_id}) ->
    D_a_t_a = <<?_(P0_spirit_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17907:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17908), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17908:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17908), {P0_array_id}) ->
    D_a_t_a = <<?_(P0_array_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17908:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17909), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17909:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17909), {P0_array_id, P0_reduce}) ->
    D_a_t_a = <<?_(P0_array_id, '8'):8, ?_(P0_reduce, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17909:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17910), {P0_type, P0_role_list}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_((length(P0_role_list)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_sex, '8'):8, ?_(P1_array_lev, '16'):16>> || {P1_role_id, P1_srv_id, P1_name, P1_sex, P1_array_lev} <- P0_role_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17910:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17910), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17910:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17911), {P0_role_id, P0_srv_id, P0_name, P0_career, P0_face_id, P0_spirits, P0_arrays, P0_add_fc, P0_pet_arrays, P0_pet_add_fc}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_career, '8'):8, ?_(P0_face_id, '32'):32, ?_((length(P0_spirits)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '32'):32, ?_(P1_quality, '8'):8, ?_(P1_fc, '32'):32, ?_(P1_exp, '32'):32, ?_(P1_max_exp, '32'):32, ?_(P1_generation, '32'):32, ?_(P1_array_id, '8'):8, ?_((length(P1_magics)), "16"):16, (list_to_binary([<<?_(P2_type, '8'):8, ?_(P2_lev, '32'):32, ?_(P2_fc, '32'):32, ?_(P2_addition, '32'):32, ?_(P2_luck, '32'):32, ?_(P2_max_luck, '32'):32>> || #soul_world_spirit_magic{type = P2_type, lev = P2_lev, fc = P2_fc, addition = P2_addition, luck = P2_luck, max_luck = P2_max_luck} <- P1_magics]))/binary>> || #soul_world_spirit{id = P1_id, name = P1_name, lev = P1_lev, quality = P1_quality, fc = P1_fc, exp = P1_exp, max_exp = P1_max_exp, generation = P1_generation, array_id = P1_array_id, magics = P1_magics} <- P0_spirits]))/binary, ?_((length(P0_arrays)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_lev, '32'):32, ?_(P1_fc, '32'):32, ?_(P1_attr, '32'):32, ?_(P1_spirit_id, '32'):32, ?_(P1_upgrade_finish, '32'):32>> || #soul_world_array{id = P1_id, lev = P1_lev, fc = P1_fc, attr = P1_attr, spirit_id = P1_spirit_id, upgrade_finish = P1_upgrade_finish} <- P0_arrays]))/binary, ?_(P0_add_fc, '32'):32, ?_((length(P0_pet_arrays)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_lev, '32'):32, ?_(P1_fc, '32'):32, ?_(P1_attr, '32'):32, ?_(P1_spirit_id, '32'):32, ?_(P1_upgrade_finish, '32'):32>> || #soul_world_array{id = P1_id, lev = P1_lev, fc = P1_fc, attr = P1_attr, spirit_id = P1_spirit_id, upgrade_finish = P1_upgrade_finish} <- P0_pet_arrays]))/binary, ?_(P0_pet_add_fc, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17911:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17911), {P0_role_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17911:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17912), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17912:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17912), {P0_spirit_id, P0_type}) ->
    D_a_t_a = <<?_(P0_spirit_id, '32'):32, ?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17912:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17913), {P0_arrays}) ->
    D_a_t_a = <<?_((length(P0_arrays)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_id, '32'):32, ?_(P1_price, '32'):32>> || {P1_type, P1_id, P1_price} <- P0_arrays]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17913:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17913), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17913:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17914), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17914:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17914), {P0_type, P0_id}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17914:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17915), {P0_id, P0_name, P0_lev, P0_quality, P0_fc, P0_exp, P0_max_exp, P0_generation, P0_array_id, P0_magics}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_((byte_size(P0_name)), "16"):16, ?_(P0_name, bin)/binary, ?_(P0_lev, '32'):32, ?_(P0_quality, '8'):8, ?_(P0_fc, '32'):32, ?_(P0_exp, '32'):32, ?_(P0_max_exp, '32'):32, ?_(P0_generation, '32'):32, ?_(P0_array_id, '8'):8, ?_((length(P0_magics)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_lev, '32'):32, ?_(P1_fc, '32'):32, ?_(P1_addition, '32'):32, ?_(P1_luck, '32'):32, ?_(P1_max_luck, '32'):32>> || #soul_world_spirit_magic{type = P1_type, lev = P1_lev, fc = P1_fc, addition = P1_addition, luck = P1_luck, max_luck = P1_max_luck} <- P0_magics]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17915:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17915), {P0_master_id, P0_slave_id}) ->
    D_a_t_a = <<?_(P0_master_id, '32'):32, ?_(P0_slave_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17915:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17916), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17916:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17916), {P0_master_id, P0_slave_id}) ->
    D_a_t_a = <<?_(P0_master_id, '32'):32, ?_(P0_slave_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17916:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17917), {P0_arrays, P0_add_fc}) ->
    D_a_t_a = <<?_((length(P0_arrays)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_lev, '32'):32, ?_(P1_fc, '32'):32, ?_(P1_attr, '32'):32, ?_(P1_spirit_id, '32'):32, ?_(P1_upgrade_finish, '32'):32>> || #soul_world_array{id = P1_id, lev = P1_lev, fc = P1_fc, attr = P1_attr, spirit_id = P1_spirit_id, upgrade_finish = P1_upgrade_finish} <- P0_arrays]))/binary, ?_(P0_add_fc, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17917:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17917), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17917:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17918), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17918:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17918), {P0_type, P0_lev}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_lev, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17918:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17919), {P0_workshop_base, P0_workshop}) ->
    D_a_t_a = <<?_((length(P0_workshop_base)), "16"):16, (list_to_binary([<<?_(P1_item_id, '32'):32, ?_(P1_unlock_fc, '32'):32, ?_(P1_unlock_coin, '32'):32, ?_(P1_unlock_gold, '32'):32, ?_(P1_produce_coin, '32'):32, ?_(P1_produce_gold, '32'):32, ?_(P1_produce_time, '32'):32>> || #soul_world_workshop_base{item_id = P1_item_id, unlock_fc = P1_unlock_fc, unlock_coin = P1_unlock_coin, unlock_gold = P1_unlock_gold, produce_coin = P1_produce_coin, produce_gold = P1_produce_gold, produce_time = P1_produce_time} <- P0_workshop_base]))/binary, ?_((length(P0_workshop)), "16"):16, (list_to_binary([<<?_(P1_item_id, '32'):32>> || #soul_world_workshop{item_id = P1_item_id} <- P0_workshop]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17919:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17919), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17919:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17920), {P0_workshop}) ->
    D_a_t_a = <<?_((length(P0_workshop)), "16"):16, (list_to_binary([<<?_(P1_item_id, '32'):32>> || #soul_world_workshop{item_id = P1_item_id} <- P0_workshop]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17920:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17920), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17920:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17921), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17921:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17921), {P0_item_id}) ->
    D_a_t_a = <<?_(P0_item_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17921:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17922), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17922:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17922), {P0_item_id, P0_num}) ->
    D_a_t_a = <<?_(P0_item_id, '32'):32, ?_(P0_num, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17922:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17923), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17923:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17923), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17923:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17924), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17924:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17924), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17924:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17925), {P0_workshop, P0_product_line}) ->
    D_a_t_a = <<?_((length(P0_workshop)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_item_id, '32'):32, ?_(P1_num, '32'):32, ?_(P1_produce_time, '32'):32>> || #soul_world_workshop{id = P1_id, item_id = P1_item_id, num = P1_num, produce_time = P1_produce_time} <- P0_workshop]))/binary, ?_(P0_product_line, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17925:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17925), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17925:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17926), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17926:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17926), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17926:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17927), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17927:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17927), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17927:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(17928), {P0_flag, P0_msg}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17928:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(17928), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 17928:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
