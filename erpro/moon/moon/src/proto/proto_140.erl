%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_140).
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

pack(srv, ?_CMD(14001), {P0_awards}) ->
    D_a_t_a = <<?_((length(P0_awards)), "16"):16, (list_to_binary([<<?_(P1_award_id, '32'):32, ?_(P1_base_id, '32'):32, ?_((byte_size(P1_title)), "16"):16, ?_(P1_title, bin)/binary, ?_((length(P1_list)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32, ?_(P2_num, '32'):32>> || [P2_base_id, P2_num] <- P1_list]))/binary>> || [P1_award_id, P1_base_id, P1_title, P1_list] <- P0_awards]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14001:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14001), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14001:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14002), {P0_award_id, P0_remain}) ->
    D_a_t_a = <<?_(P0_award_id, '32'):32, ?_(P0_remain, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14002:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14002), {P0_award_id}) ->
    D_a_t_a = <<?_(P0_award_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14002:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14003), {P0_awards, P0_del}) ->
    D_a_t_a = <<?_((length(P0_awards)), "16"):16, (list_to_binary([<<?_(P1_award_id, '32'):32, ?_(P1_base_id, '32'):32, ?_((byte_size(P1_title)), "16"):16, ?_(P1_title, bin)/binary, ?_((length(P1_list)), "16"):16, (list_to_binary([<<?_(P2_base_id, '32'):32, ?_(P2_num, '32'):32>> || [P2_base_id, P2_num] <- P1_list]))/binary>> || [P1_award_id, P1_base_id, P1_title, P1_list] <- P0_awards]))/binary, ?_((length(P0_del)), "16"):16, (list_to_binary([<<?_(P1_award_id, '32'):32>> || P1_award_id <- P0_del]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14003:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14003), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14003:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14004), {P0_num}) ->
    D_a_t_a = <<?_(P0_num, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14004:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14004), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14004:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14010), {P0_list}) ->
    D_a_t_a = <<?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_event_id, '32'):32, ?_(P1_expire, '32'):32>> || {P1_id, P1_event_id, P1_expire} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14010:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14010), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14010:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14011), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14011:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14011), {P0_id, P0_event_id}) ->
    D_a_t_a = <<?_(P0_id, '16'):16, ?_(P0_event_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14011:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14012), {P0_id, P0_event_id, P0_expire}) ->
    D_a_t_a = <<?_(P0_id, '16'):16, ?_(P0_event_id, '32'):32, ?_(P0_expire, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14012:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14012), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14012:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14013), {P0_num, P0_gain}) ->
    D_a_t_a = <<?_(P0_num, '16'):16, ?_((length(P0_gain)), "16"):16, (list_to_binary([<<?_(P1_eccount_id, '16'):16, ?_(P1_eccount_type, '16'):16, ?_(P1_eccount_mode, '16'):16, ?_(P1_type, '8'):8, ?_(P1_item_id, '32/signed'):32/signed, ?_(P1_num, '32/signed'):32/signed>> || {P1_eccount_id, P1_eccount_type, P1_eccount_mode, P1_type, P1_item_id, P1_num} <- P0_gain]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14013:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14013), {P0_id, P0_event_id}) ->
    D_a_t_a = <<?_(P0_id, '16'):16, ?_(P0_event_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14013:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(14014), {P0_code}) ->
    D_a_t_a = <<?_(P0_code, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14014:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(14014), {P0_id, P0_eccount_id}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_eccount_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 14014:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 14001, _B0) ->
    {ok, {}};
unpack(cli, 14001, _B0) ->
    {P0_awards, _B9} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_award_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_base_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_title, _B4} = lib_proto:read_string(_B3),
        {P1_list, _B8} = lib_proto:read_array(_B4, fun(_B5) ->
            {P2_base_id, _B6} = lib_proto:read_uint32(_B5),
            {P2_num, _B7} = lib_proto:read_uint32(_B6),
            {[P2_base_id, P2_num], _B7}
        end),
        {[P1_award_id, P1_base_id, P1_title, P1_list], _B8}
    end),
    {ok, {P0_awards}};

unpack(srv, 14002, _B0) ->
    {P0_award_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_award_id}};
unpack(cli, 14002, _B0) ->
    {P0_award_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_remain, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_award_id, P0_remain}};

unpack(srv, 14003, _B0) ->
    {ok, {}};
unpack(cli, 14003, _B0) ->
    {P0_awards, _B9} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_award_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_base_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_title, _B4} = lib_proto:read_string(_B3),
        {P1_list, _B8} = lib_proto:read_array(_B4, fun(_B5) ->
            {P2_base_id, _B6} = lib_proto:read_uint32(_B5),
            {P2_num, _B7} = lib_proto:read_uint32(_B6),
            {[P2_base_id, P2_num], _B7}
        end),
        {[P1_award_id, P1_base_id, P1_title, P1_list], _B8}
    end),
    {P0_del, _B12} = lib_proto:read_array(_B9, fun(_B10) ->
        {P1_award_id, _B11} = lib_proto:read_uint32(_B10),
        {P1_award_id, _B11}
    end),
    {ok, {P0_awards, P0_del}};

unpack(srv, 14004, _B0) ->
    {ok, {}};
unpack(cli, 14004, _B0) ->
    {P0_num, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_num}};

unpack(srv, 14010, _B0) ->
    {ok, {}};
unpack(cli, 14010, _B0) ->
    {P0_list, _B5} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_event_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_expire, _B4} = lib_proto:read_uint32(_B3),
        {[P1_id, P1_event_id, P1_expire], _B4}
    end),
    {ok, {P0_list}};

unpack(srv, 14012, _B0) ->
    {ok, {}};
unpack(cli, 14012, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint16(_B0),
    {P0_event_id, _B2} = lib_proto:read_uint32(_B1),
    {P0_expire, _B3} = lib_proto:read_uint32(_B2),
    {ok, {P0_id, P0_event_id, P0_expire}};

unpack(srv, 14013, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint16(_B0),
    {P0_event_id, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_id, P0_event_id}};
unpack(cli, 14013, _B0) ->
    {P0_num, _B1} = lib_proto:read_uint16(_B0),
    {P0_gain, _B9} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_eccount_id, _B3} = lib_proto:read_uint16(_B2),
        {P1_eccount_type, _B4} = lib_proto:read_uint16(_B3),
        {P1_eccount_mode, _B5} = lib_proto:read_uint16(_B4),
        {P1_type, _B6} = lib_proto:read_uint8(_B5),
        {P1_item_id, _B7} = lib_proto:read_int32(_B6),
        {P1_num, _B8} = lib_proto:read_int32(_B7),
        {[P1_eccount_id, P1_eccount_type, P1_eccount_mode, P1_type, P1_item_id, P1_num], _B8}
    end),
    {ok, {P0_num, P0_gain}};

unpack(srv, 14014, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_eccount_id, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_id, P0_eccount_id}};
unpack(cli, 14014, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_code}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
