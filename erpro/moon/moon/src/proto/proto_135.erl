%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_135).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("dungeon.hrl").
-include("change.hrl").
-include("arena_career.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(13500), {P0_id, P0_param_list}) ->
    D_a_t_a = <<?_(P0_id, '16'):16, ?_((length(P0_param_list)), "16"):16, (list_to_binary([<<?_(P1_param, '32'):32>> || P1_param <- P0_param_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13500:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13500), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13500:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13501), {P0_map_list, P0_normal_list, P0_hard_list}) ->
    D_a_t_a = <<?_((length(P0_map_list)), "16"):16, (list_to_binary([<<?_(P1_id, '16'):16, ?_(P1_blue_is_taken, '8'):8, ?_(P1_purple_is_taken, '8'):8, ?_(P1_opened_count, '8'):8>> || {P1_id, P1_blue_is_taken, P1_purple_is_taken, P1_opened_count} <- P0_map_list]))/binary, ?_((length(P0_normal_list)), "16"):16, (list_to_binary([<<?_(P1_id, '16'):16, ?_(P1_star, '8'):8, ?_(P1_reach_goals, '8'):8>> || {P1_id, P1_star, P1_reach_goals} <- P0_normal_list]))/binary, ?_((length(P0_hard_list)), "16"):16, (list_to_binary([<<?_(P1_id, '16'):16, ?_(P1_star, '8'):8, ?_(P1_reach_goals, '8'):8, ?_(P1_left_count, '8'):8, ?_(P1_paid_count, '8'):8>> || {P1_id, P1_star, P1_reach_goals, P1_left_count, P1_paid_count} <- P0_hard_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13501:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13501), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13501:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13502), {P0_id, P0_star, P0_reach_goals, P0_left_count, P0_paid_count}) ->
    D_a_t_a = <<?_(P0_id, '16'):16, ?_(P0_star, '8'):8, ?_(P0_reach_goals, '8'):8, ?_(P0_left_count, '8'):8, ?_(P0_paid_count, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13502:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13502), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13502:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13503), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13503:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13503), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13503:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13504), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13504:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13504), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13504:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13506), {P0_map_id}) ->
    D_a_t_a = <<?_(P0_map_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13506:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13506), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13506:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13507), {P0_is_bag}) ->
    D_a_t_a = <<?_(P0_is_bag, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13507:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13507), {P0_map_id}) ->
    D_a_t_a = <<?_(P0_map_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13507:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13508), {P0_is_bag}) ->
    D_a_t_a = <<?_(P0_is_bag, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13508:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13508), {P0_map_id}) ->
    D_a_t_a = <<?_(P0_map_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13508:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13510), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13510:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13510), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13510:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13511), {P0_is_bag, P0_rewards}) ->
    D_a_t_a = <<?_(P0_is_bag, '8'):8, ?_((length(P0_rewards)), "16"):16, (list_to_binary([<<?_(P1_exp, '32'):32, ?_(P1_coin, '32'):32, ?_(P1_point, '32'):32, ?_(P1_pet_exp, '32'):32, ?_((length(P1_items)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_(P2_count, '32'):32>> || {P2_id, P2_count} <- P1_items]))/binary>> || {P1_exp, P1_coin, P1_point, P1_pet_exp, P1_items} <- P0_rewards]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13511:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13511), {P0_dungeon_id, P0_count}) ->
    D_a_t_a = <<?_(P0_dungeon_id, '16'):16, ?_(P0_count, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13511:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13514), {P0_star, P0_reach_goals, P0_item_list}) ->
    D_a_t_a = <<?_(P0_star, '8'):8, ?_(P0_reach_goals, '8'):8, ?_((length(P0_item_list)), "16"):16, (list_to_binary([<<?_(P1_base_id, '32'):32, ?_(P1_count, '8'):8>> || {P1_base_id, P1_count} <- P0_item_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13514:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13514), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13514:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13515), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13515:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13515), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13515:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13516), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13516:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13516), {P0_pos}) ->
    D_a_t_a = <<?_(P0_pos, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13516:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13517), {P0_type, P0_cards}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_((length(P0_cards)), "16"):16, (list_to_binary([<<?_(P1_pos, '8'):8, ?_(P1_item_id, '32'):32, ?_(P1_num, '8'):8, ?_(P1_bind, '8'):8, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary>> || {P1_pos, P1_item_id, P1_num, P1_bind, P1_name} <- P0_cards]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13517:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13517), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13517:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13571), {P0_times, P0_buy_times, P0_buy_limit, P0_buy_price}) ->
    D_a_t_a = <<?_(P0_times, '8'):8, ?_(P0_buy_times, '8'):8, ?_(P0_buy_limit, '8'):8, ?_(P0_buy_price, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13571:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13571), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13571:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13572), {P0_code}) ->
    D_a_t_a = <<?_(P0_code, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13572:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13572), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13572:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13573), {P0_code, P0_roles}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((length(P0_roles)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_sex, '8'):8, ?_(P1_lev, '8'):8, ?_(P1_face, '16'):16, ?_(P1_fight_capacity, '32'):32, ?_(P1_career, '8'):8, ?_(P1_rank, '32'):32, ?_((length(P1_looks)), "16"):16, (list_to_binary([<<?_(P2_looks_type, '8'):8, ?_(P2_looks_id, '32'):32, ?_(P2_looks_value, '16'):16>> || {P2_looks_type, P2_looks_id, P2_looks_value} <- P1_looks]))/binary>> || #arena_career_role{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, sex = P1_sex, lev = P1_lev, face = P1_face, fight_capacity = P1_fight_capacity, career = P1_career, rank = P1_rank, looks = P1_looks} <- P0_roles]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13573:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13573), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13573:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13574), {P0_code}) ->
    D_a_t_a = <<?_(P0_code, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13574:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13574), {P0_id}) ->
    D_a_t_a = <<?_(P0_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13574:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13580), {P0_enter_count, P0_cooperation}) ->
    D_a_t_a = <<?_(P0_enter_count, '8'):8, ?_(P0_cooperation, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13580:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13580), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13580:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13581), {P0_items}) ->
    D_a_t_a = <<?_((length(P0_items)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_(P1_count, '8'):8, ?_(P1_base_id, '32'):32, ?_(P1_price, '16'):16>> || #change_item{id = P1_id, count = P1_count, base_id = P1_base_id, price = P1_price} <- P0_items]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13581:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13581), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13581:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13582), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13582:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13582), {P0_id, P0_num}) ->
    D_a_t_a = <<?_(P0_id, '8'):8, ?_(P0_num, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13582:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13585), {P0_left_times, P0_left_time, P0_rewards}) ->
    D_a_t_a = <<?_(P0_left_times, '8'):8, ?_(P0_left_time, '32'):32, ?_((length(P0_rewards)), "16"):16, (list_to_binary([<<?_(P1_exp, '32'):32, ?_(P1_coin, '32'):32, ?_(P1_point, '32'):32, ?_(P1_pet_exp, '32'):32, ?_((length(P1_items)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_(P2_count, '32'):32>> || {P2_id, P2_count} <- P1_items]))/binary>> || {P1_exp, P1_coin, P1_point, P1_pet_exp, P1_items} <- P0_rewards]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13585:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13585), {P0_dungeon_id, P0_count, P0_is_immediate}) ->
    D_a_t_a = <<?_(P0_dungeon_id, '16'):16, ?_(P0_count, '8'):8, ?_(P0_is_immediate, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13585:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13586), {P0_left_times, P0_left_time, P0_rewards}) ->
    D_a_t_a = <<?_(P0_left_times, '8'):8, ?_(P0_left_time, '32'):32, ?_((length(P0_rewards)), "16"):16, (list_to_binary([<<?_(P1_exp, '32'):32, ?_(P1_coin, '32'):32, ?_(P1_point, '32'):32, ?_(P1_pet_exp, '32'):32, ?_((length(P1_items)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_(P2_count, '32'):32>> || {P2_id, P2_count} <- P1_items]))/binary>> || {P1_exp, P1_coin, P1_point, P1_pet_exp, P1_items} <- P0_rewards]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13586:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13586), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13586:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13587), {P0_gains}) ->
    D_a_t_a = <<?_((length(P0_gains)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_base_id, '32'):32, ?_(P1_num, '32'):32>> || {P1_type, P1_base_id, P1_num} <- P0_gains]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13587:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13587), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13587:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13588), {P0_code}) ->
    D_a_t_a = <<?_(P0_code, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13588:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13588), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13588:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13589), {P0_left_times, P0_left_time, P0_rewards}) ->
    D_a_t_a = <<?_(P0_left_times, '8'):8, ?_(P0_left_time, '32'):32, ?_((length(P0_rewards)), "16"):16, (list_to_binary([<<?_(P1_exp, '32'):32, ?_(P1_coin, '32'):32, ?_(P1_point, '32'):32, ?_(P1_pet_exp, '32'):32, ?_((length(P1_items)), "16"):16, (list_to_binary([<<?_(P2_id, '32'):32, ?_(P2_count, '32'):32>> || {P2_id, P2_count} <- P1_items]))/binary>> || {P1_exp, P1_coin, P1_point, P1_pet_exp, P1_items} <- P0_rewards]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13589:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13589), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13589:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13590), {P0_dungeon_id, P0_count}) ->
    D_a_t_a = <<?_(P0_dungeon_id, '16'):16, ?_(P0_count, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13590:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13590), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13590:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 13500, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_id}};
unpack(cli, 13500, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint16(_B0),
    {P0_param_list, _B4} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_param, _B3} = lib_proto:read_uint32(_B2),
        {P1_param, _B3}
    end),
    {ok, {P0_id, P0_param_list}};

unpack(srv, 13501, _B0) ->
    {ok, {}};
unpack(cli, 13501, _B0) ->
    {P0_map_list, _B6} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint16(_B1),
        {P1_blue_is_taken, _B3} = lib_proto:read_uint8(_B2),
        {P1_purple_is_taken, _B4} = lib_proto:read_uint8(_B3),
        {P1_opened_count, _B5} = lib_proto:read_uint8(_B4),
        {[P1_id, P1_blue_is_taken, P1_purple_is_taken, P1_opened_count], _B5}
    end),
    {P0_normal_list, _B11} = lib_proto:read_array(_B6, fun(_B7) ->
        {P1_id, _B8} = lib_proto:read_uint16(_B7),
        {P1_star, _B9} = lib_proto:read_uint8(_B8),
        {P1_reach_goals, _B10} = lib_proto:read_uint8(_B9),
        {[P1_id, P1_star, P1_reach_goals], _B10}
    end),
    {P0_hard_list, _B18} = lib_proto:read_array(_B11, fun(_B12) ->
        {P1_id, _B13} = lib_proto:read_uint16(_B12),
        {P1_star, _B14} = lib_proto:read_uint8(_B13),
        {P1_reach_goals, _B15} = lib_proto:read_uint8(_B14),
        {P1_left_count, _B16} = lib_proto:read_uint8(_B15),
        {P1_paid_count, _B17} = lib_proto:read_uint8(_B16),
        {[P1_id, P1_star, P1_reach_goals, P1_left_count, P1_paid_count], _B17}
    end),
    {ok, {P0_map_list, P0_normal_list, P0_hard_list}};

unpack(srv, 13502, _B0) ->
    {ok, {}};
unpack(cli, 13502, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint16(_B0),
    {P0_star, _B2} = lib_proto:read_uint8(_B1),
    {P0_reach_goals, _B3} = lib_proto:read_uint8(_B2),
    {P0_left_count, _B4} = lib_proto:read_uint8(_B3),
    {P0_paid_count, _B5} = lib_proto:read_uint8(_B4),
    {ok, {P0_id, P0_star, P0_reach_goals, P0_left_count, P0_paid_count}};

unpack(srv, 13503, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_id}};
unpack(cli, 13503, _B0) ->
    {ok, {}};

unpack(srv, 13504, _B0) ->
    {ok, {}};
unpack(cli, 13504, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_id}};

unpack(srv, 13506, _B0) ->
    {ok, {}};
unpack(cli, 13506, _B0) ->
    {P0_map_id, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_map_id}};

unpack(srv, 13507, _B0) ->
    {P0_map_id, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_map_id}};
unpack(cli, 13507, _B0) ->
    {P0_is_bag, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_is_bag}};

unpack(srv, 13508, _B0) ->
    {P0_map_id, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_map_id}};
unpack(cli, 13508, _B0) ->
    {P0_is_bag, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_is_bag}};

unpack(srv, 13510, _B0) ->
    {ok, {}};
unpack(cli, 13510, _B0) ->
    {ok, {}};

unpack(srv, 13514, _B0) ->
    {ok, {}};
unpack(cli, 13514, _B0) ->
    {P0_star, _B1} = lib_proto:read_uint8(_B0),
    {P0_reach_goals, _B2} = lib_proto:read_uint8(_B1),
    {P0_item_list, _B6} = lib_proto:read_array(_B2, fun(_B3) ->
        {P1_base_id, _B4} = lib_proto:read_uint32(_B3),
        {P1_count, _B5} = lib_proto:read_uint8(_B4),
        {[P1_base_id, P1_count], _B5}
    end),
    {ok, {P0_star, P0_reach_goals, P0_item_list}};

unpack(srv, 13515, _B0) ->
    {ok, {}};
unpack(cli, 13515, _B0) ->
    {ok, {}};

unpack(srv, 13516, _B0) ->
    {P0_pos, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_pos}};
unpack(cli, 13516, _B0) ->
    {ok, {}};

unpack(srv, 13517, _B0) ->
    {ok, {}};
unpack(cli, 13517, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_cards, _B8} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_pos, _B3} = lib_proto:read_uint8(_B2),
        {P1_item_id, _B4} = lib_proto:read_uint32(_B3),
        {P1_num, _B5} = lib_proto:read_uint8(_B4),
        {P1_bind, _B6} = lib_proto:read_uint8(_B5),
        {P1_name, _B7} = lib_proto:read_string(_B6),
        {[P1_pos, P1_item_id, P1_num, P1_bind, P1_name], _B7}
    end),
    {ok, {P0_type, P0_cards}};

unpack(srv, 13571, _B0) ->
    {ok, {}};
unpack(cli, 13571, _B0) ->
    {P0_times, _B1} = lib_proto:read_uint8(_B0),
    {P0_buy_times, _B2} = lib_proto:read_uint8(_B1),
    {P0_buy_limit, _B3} = lib_proto:read_uint8(_B2),
    {P0_buy_price, _B4} = lib_proto:read_uint8(_B3),
    {ok, {P0_times, P0_buy_times, P0_buy_limit, P0_buy_price}};

unpack(srv, 13572, _B0) ->
    {ok, {}};
unpack(cli, 13572, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_code}};

unpack(srv, 13573, _B0) ->
    {ok, {}};
unpack(cli, 13573, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {P0_roles, _B17} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_rid, _B3} = lib_proto:read_uint32(_B2),
        {P1_srv_id, _B4} = lib_proto:read_string(_B3),
        {P1_name, _B5} = lib_proto:read_string(_B4),
        {P1_sex, _B6} = lib_proto:read_uint8(_B5),
        {P1_lev, _B7} = lib_proto:read_uint8(_B6),
        {P1_face, _B8} = lib_proto:read_uint16(_B7),
        {P1_fight_capacity, _B9} = lib_proto:read_uint32(_B8),
        {P1_career, _B10} = lib_proto:read_uint8(_B9),
        {P1_rank, _B11} = lib_proto:read_uint32(_B10),
        {P1_looks, _B16} = lib_proto:read_array(_B11, fun(_B12) ->
            {P2_looks_type, _B13} = lib_proto:read_uint8(_B12),
            {P2_looks_id, _B14} = lib_proto:read_uint32(_B13),
            {P2_looks_value, _B15} = lib_proto:read_uint16(_B14),
            {[P2_looks_type, P2_looks_id, P2_looks_value], _B15}
        end),
        {[P1_rid, P1_srv_id, P1_name, P1_sex, P1_lev, P1_face, P1_fight_capacity, P1_career, P1_rank, P1_looks], _B16}
    end),
    {ok, {P0_code, P0_roles}};

unpack(srv, 13574, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_id}};
unpack(cli, 13574, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_code}};

unpack(srv, 13580, _B0) ->
    {ok, {}};
unpack(cli, 13580, _B0) ->
    {P0_enter_count, _B1} = lib_proto:read_uint8(_B0),
    {P0_cooperation, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_enter_count, P0_cooperation}};

unpack(srv, 13581, _B0) ->
    {ok, {}};
unpack(cli, 13581, _B0) ->
    {P0_items, _B6} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint8(_B1),
        {P1_count, _B3} = lib_proto:read_uint8(_B2),
        {P1_base_id, _B4} = lib_proto:read_uint32(_B3),
        {P1_price, _B5} = lib_proto:read_uint16(_B4),
        {[P1_id, P1_count, P1_base_id, P1_price], _B5}
    end),
    {ok, {P0_items}};

unpack(srv, 13582, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint8(_B0),
    {P0_num, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_id, P0_num}};
unpack(cli, 13582, _B0) ->
    {ok, {}};

unpack(srv, 13585, _B0) ->
    {P0_dungeon_id, _B1} = lib_proto:read_uint16(_B0),
    {P0_count, _B2} = lib_proto:read_uint8(_B1),
    {P0_is_immediate, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_dungeon_id, P0_count, P0_is_immediate}};
unpack(cli, 13585, _B0) ->
    {P0_left_times, _B1} = lib_proto:read_uint8(_B0),
    {P0_left_time, _B2} = lib_proto:read_uint32(_B1),
    {P0_rewards, _B12} = lib_proto:read_array(_B2, fun(_B3) ->
        {P1_exp, _B4} = lib_proto:read_uint32(_B3),
        {P1_coin, _B5} = lib_proto:read_uint32(_B4),
        {P1_point, _B6} = lib_proto:read_uint32(_B5),
        {P1_pet_exp, _B7} = lib_proto:read_uint32(_B6),
        {P1_items, _B11} = lib_proto:read_array(_B7, fun(_B8) ->
            {P2_id, _B9} = lib_proto:read_uint32(_B8),
            {P2_count, _B10} = lib_proto:read_uint32(_B9),
            {[P2_id, P2_count], _B10}
        end),
        {[P1_exp, P1_coin, P1_point, P1_pet_exp, P1_items], _B11}
    end),
    {ok, {P0_left_times, P0_left_time, P0_rewards}};

unpack(srv, 13587, _B0) ->
    {ok, {}};
unpack(cli, 13587, _B0) ->
    {P0_gains, _B5} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_type, _B2} = lib_proto:read_uint8(_B1),
        {P1_base_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_num, _B4} = lib_proto:read_uint32(_B3),
        {[P1_type, P1_base_id, P1_num], _B4}
    end),
    {ok, {P0_gains}};

unpack(srv, 13590, _B0) ->
    {ok, {}};
unpack(cli, 13590, _B0) ->
    {P0_dungeon_id, _B1} = lib_proto:read_uint16(_B0),
    {P0_count, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_dungeon_id, P0_count}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
