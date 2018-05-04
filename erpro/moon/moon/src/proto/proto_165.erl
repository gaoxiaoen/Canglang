%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_165).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("hall.hrl").
-include("sns.hrl").
-include("guild.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(16501), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16501:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16501), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16501:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16502), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16502:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16502), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16502:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16503), {P0_room_no}) ->
    D_a_t_a = <<?_(P0_room_no, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16503:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16503), {P0_type, P0_room_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_room_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16503:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16504), {P0_total_page, P0_rooms}) ->
    D_a_t_a = <<?_(P0_total_page, '16'):16, ?_((length(P0_rooms)), "16"):16, (list_to_binary([<<?_(P1_room_no, '32'):32, ?_(P1_room_type, '8'):8, ?_((length(P1_roles)), "16"):16, (list_to_binary([<<?_((byte_size(P2_name)), "16"):16, ?_(P2_name, bin)/binary, ?_(P2_fight_capacity, '32'):32, ?_(P2_career, '8'):8, ?_(P2_sex, '8'):8>> || #hall_role{name = P2_name, fight_capacity = P2_fight_capacity, career = P2_career, sex = P2_sex} <- P1_roles]))/binary>> || {P1_room_no, P1_room_type, P1_roles} <- P0_rooms]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16504:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16504), {P0_type, P0_page_index}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_page_index, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16504:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16511), {P0_room_no}) ->
    D_a_t_a = <<?_(P0_room_no, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16511:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16511), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16511:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16512), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16512:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16512), {P0_room_no}) ->
    D_a_t_a = <<?_(P0_room_no, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16512:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16513), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16513:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16513), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16513:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16514), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16514:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16514), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16514:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16515), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16515:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16515), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16515:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16516), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16516:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16516), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16516:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16517), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16517:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16517), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16517:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16518), {P0_room_no, P0_room_type, P0_members}) ->
    D_a_t_a = <<?_(P0_room_no, '16'):16, ?_(P0_room_type, '8'):8, ?_((length(P0_members)), "16"):16, (list_to_binary([<<?_(P1_identity, '8'):8, ?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_career, '8'):8, ?_(P1_fight_capacity, '32'):32, ?_(P1_sex, '8'):8, ?_(P1_status, '8'):8, ?_((length(P1_looks)), "16"):16, (list_to_binary([<<?_(P2_looks_type, '8'):8, ?_(P2_looks_id, '32'):32, ?_(P2_looks_value, '16'):16>> || {P2_looks_type, P2_looks_id, P2_looks_value} <- P1_looks]))/binary>> || {P1_identity, P1_role_id, P1_srv_id, P1_name, P1_career, P1_fight_capacity, P1_sex, P1_status, P1_looks} <- P0_members]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16518:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16518), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16518:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16519), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16519:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16519), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16519:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16520), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16520:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16520), {P0_role_id, P0_srv_id}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16520:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16521), {P0_role_id, P0_srv_id, P0_status}) ->
    D_a_t_a = <<?_(P0_role_id, '32'):32, ?_((byte_size(P0_srv_id)), "16"):16, ?_(P0_srv_id, bin)/binary, ?_(P0_status, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16521:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16521), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16521:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16525), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16525:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16525), {P0_invite_list}) ->
    D_a_t_a = <<?_((length(P0_invite_list)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary>> || {P1_role_id, P1_srv_id} <- P0_invite_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16525:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16526), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16526:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16526), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16526:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16528), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16528:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16528), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16528:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16530), {P0_roles}) ->
    D_a_t_a = <<?_((length(P0_roles)), "16"):16, (list_to_binary([<<?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '8'):8, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8>> || #hall_role{name = P1_name, lev = P1_lev, career = P1_career, sex = P1_sex} <- P0_roles]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16530:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16530), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16530:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16531), {P0_friend_list}) ->
    D_a_t_a = <<?_((length(P0_friend_list)), "16"):16, (list_to_binary([<<?_(P1_role_id, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_sex, '8'):8, ?_(P1_career, '8'):8, ?_(P1_lev, '16'):16, ?_(P1_fight, '32'):32>> || #friend{role_id = P1_role_id, srv_id = P1_srv_id, name = P1_name, sex = P1_sex, career = P1_career, lev = P1_lev, fight = P1_fight} <- P0_friend_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16531:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16531), {P0_room_type}) ->
    D_a_t_a = <<?_(P0_room_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16531:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(16532), {P0_members}) ->
    D_a_t_a = <<?_((length(P0_members)), "16"):16, (list_to_binary([<<?_(P1_rid, '32'):32, ?_((byte_size(P1_srv_id)), "16"):16, ?_(P1_srv_id, bin)/binary, ?_((byte_size(P1_name)), "16"):16, ?_(P1_name, bin)/binary, ?_(P1_lev, '8'):8, ?_(P1_fight, '32'):32, ?_(P1_career, '8'):8, ?_(P1_sex, '8'):8>> || #guild_member{rid = P1_rid, srv_id = P1_srv_id, name = P1_name, lev = P1_lev, fight = P1_fight, career = P1_career, sex = P1_sex} <- P0_members]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16532:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(16532), {P0_room_type}) ->
    D_a_t_a = <<?_(P0_room_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 16532:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 16501, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_type}};
unpack(cli, 16501, _B0) ->
    {ok, {}};

unpack(srv, 16502, _B0) ->
    {ok, {}};
unpack(cli, 16502, _B0) ->
    {ok, {}};

unpack(srv, 16503, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_room_type, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_type, P0_room_type}};
unpack(cli, 16503, _B0) ->
    {P0_room_no, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_room_no}};

unpack(srv, 16504, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {P0_page_index, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_type, P0_page_index}};
unpack(cli, 16504, _B0) ->
    {P0_total_page, _B1} = lib_proto:read_uint16(_B0),
    {P0_rooms, _B11} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_room_no, _B3} = lib_proto:read_uint32(_B2),
        {P1_room_type, _B4} = lib_proto:read_uint8(_B3),
        {P1_roles, _B10} = lib_proto:read_array(_B4, fun(_B5) ->
            {P2_name, _B6} = lib_proto:read_string(_B5),
            {P2_fight_capacity, _B7} = lib_proto:read_uint32(_B6),
            {P2_career, _B8} = lib_proto:read_uint8(_B7),
            {P2_sex, _B9} = lib_proto:read_uint8(_B8),
            {[P2_name, P2_fight_capacity, P2_career, P2_sex], _B9}
        end),
        {[P1_room_no, P1_room_type, P1_roles], _B10}
    end),
    {ok, {P0_total_page, P0_rooms}};

unpack(srv, 16511, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_type}};
unpack(cli, 16511, _B0) ->
    {P0_room_no, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_room_no}};

unpack(srv, 16512, _B0) ->
    {P0_room_no, _B1} = lib_proto:read_uint16(_B0),
    {ok, {P0_room_no}};
unpack(cli, 16512, _B0) ->
    {ok, {}};

unpack(srv, 16513, _B0) ->
    {ok, {}};
unpack(cli, 16513, _B0) ->
    {ok, {}};

unpack(srv, 16514, _B0) ->
    {ok, {}};
unpack(cli, 16514, _B0) ->
    {ok, {}};

unpack(srv, 16515, _B0) ->
    {ok, {}};
unpack(cli, 16515, _B0) ->
    {ok, {}};

unpack(srv, 16516, _B0) ->
    {ok, {}};
unpack(cli, 16516, _B0) ->
    {ok, {}};

unpack(srv, 16517, _B0) ->
    {ok, {}};
unpack(cli, 16517, _B0) ->
    {ok, {}};

unpack(srv, 16518, _B0) ->
    {ok, {}};
unpack(cli, 16518, _B0) ->
    {P0_room_no, _B1} = lib_proto:read_uint16(_B0),
    {P0_room_type, _B2} = lib_proto:read_uint8(_B1),
    {P0_members, _B17} = lib_proto:read_array(_B2, fun(_B3) ->
        {P1_identity, _B4} = lib_proto:read_uint8(_B3),
        {P1_role_id, _B5} = lib_proto:read_uint32(_B4),
        {P1_srv_id, _B6} = lib_proto:read_string(_B5),
        {P1_name, _B7} = lib_proto:read_string(_B6),
        {P1_career, _B8} = lib_proto:read_uint8(_B7),
        {P1_fight_capacity, _B9} = lib_proto:read_uint32(_B8),
        {P1_sex, _B10} = lib_proto:read_uint8(_B9),
        {P1_status, _B11} = lib_proto:read_uint8(_B10),
        {P1_looks, _B16} = lib_proto:read_array(_B11, fun(_B12) ->
            {P2_looks_type, _B13} = lib_proto:read_uint8(_B12),
            {P2_looks_id, _B14} = lib_proto:read_uint32(_B13),
            {P2_looks_value, _B15} = lib_proto:read_uint16(_B14),
            {[P2_looks_type, P2_looks_id, P2_looks_value], _B15}
        end),
        {[P1_identity, P1_role_id, P1_srv_id, P1_name, P1_career, P1_fight_capacity, P1_sex, P1_status, P1_looks], _B16}
    end),
    {ok, {P0_room_no, P0_room_type, P0_members}};

unpack(srv, 16519, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_type}};
unpack(cli, 16519, _B0) ->
    {ok, {}};

unpack(srv, 16520, _B0) ->
    {P0_role_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {ok, {P0_role_id, P0_srv_id}};
unpack(cli, 16520, _B0) ->
    {ok, {}};

unpack(srv, 16521, _B0) ->
    {ok, {}};
unpack(cli, 16521, _B0) ->
    {P0_role_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_srv_id, _B2} = lib_proto:read_string(_B1),
    {P0_status, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_role_id, P0_srv_id, P0_status}};

unpack(srv, 16525, _B0) ->
    {P0_invite_list, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_role_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_srv_id, _B3} = lib_proto:read_string(_B2),
        {[P1_role_id, P1_srv_id], _B3}
    end),
    {ok, {P0_invite_list}};
unpack(cli, 16525, _B0) ->
    {ok, {}};

unpack(srv, 16526, _B0) ->
    {ok, {}};
unpack(cli, 16526, _B0) ->
    {ok, {}};

unpack(srv, 16528, _B0) ->
    {ok, {}};
unpack(cli, 16528, _B0) ->
    {ok, {}};

unpack(srv, 16530, _B0) ->
    {ok, {}};
unpack(cli, 16530, _B0) ->
    {P0_roles, _B6} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_name, _B2} = lib_proto:read_string(_B1),
        {P1_lev, _B3} = lib_proto:read_uint8(_B2),
        {P1_career, _B4} = lib_proto:read_uint8(_B3),
        {P1_sex, _B5} = lib_proto:read_uint8(_B4),
        {[P1_name, P1_lev, P1_career, P1_sex], _B5}
    end),
    {ok, {P0_roles}};

unpack(srv, 16531, _B0) ->
    {P0_room_type, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_room_type}};
unpack(cli, 16531, _B0) ->
    {P0_friend_list, _B9} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_role_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_srv_id, _B3} = lib_proto:read_string(_B2),
        {P1_name, _B4} = lib_proto:read_string(_B3),
        {P1_sex, _B5} = lib_proto:read_uint8(_B4),
        {P1_career, _B6} = lib_proto:read_uint8(_B5),
        {P1_lev, _B7} = lib_proto:read_uint16(_B6),
        {P1_fight, _B8} = lib_proto:read_uint32(_B7),
        {[P1_role_id, P1_srv_id, P1_name, P1_sex, P1_career, P1_lev, P1_fight], _B8}
    end),
    {ok, {P0_friend_list}};

unpack(srv, 16532, _B0) ->
    {P0_room_type, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_room_type}};
unpack(cli, 16532, _B0) ->
    {P0_members, _B9} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_role_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_srv_id, _B3} = lib_proto:read_string(_B2),
        {P1_name, _B4} = lib_proto:read_string(_B3),
        {P1_lev, _B5} = lib_proto:read_uint8(_B4),
        {P1_fight, _B6} = lib_proto:read_uint32(_B5),
        {P1_career, _B7} = lib_proto:read_uint8(_B6),
        {P1_sex, _B8} = lib_proto:read_uint8(_B7),
        {[P1_role_id, P1_srv_id, P1_name, P1_lev, P1_fight, P1_career, P1_sex], _B8}
    end),
    {ok, {P0_members}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
