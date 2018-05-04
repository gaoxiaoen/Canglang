%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_124).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("vip.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(12400), {P0_type, P0_expire, P0_portrait_id, P0_special_time, P0_buff_time, P0_is_buff, P0_is_special, P0_hearsay, P0_fly_sign, P0_reward_list, P0_is_try}) ->
    D_a_t_a = <<?_(P0_type, '16'):16, ?_(P0_expire, '32'):32, ?_(P0_portrait_id, '16'):16, ?_(P0_special_time, '32'):32, ?_(P0_buff_time, '32'):32, ?_(P0_is_buff, '8'):8, ?_(P0_is_special, '8'):8, ?_(P0_hearsay, '8/signed'):8/signed, ?_(P0_fly_sign, '8/signed'):8/signed, ?_((length(P0_reward_list)), "16"):16, (list_to_binary([<<?_(P1_type, '8'):8, ?_(P1_status, '8'):8, ?_(P1_get_time, '32'):32>> || {P1_type, P1_status, P1_get_time} <- P0_reward_list]))/binary, ?_(P0_is_try, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12400:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12400), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12400:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12401), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12401:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12401), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12401:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12402), {P0_portrait_id, P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_portrait_id, '16'):16, ?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12402:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12402), {P0_portrait_id}) ->
    D_a_t_a = <<?_(P0_portrait_id, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12402:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12403), {P0_hearsay, P0_fly_sign}) ->
    D_a_t_a = <<?_(P0_hearsay, '8/signed'):8/signed, ?_(P0_fly_sign, '8/signed'):8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12403:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12403), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12403:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12404), {P0_code, P0_msg}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12404:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12404), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12404:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12405), {P0_code, P0_msg, P0_type}) ->
    D_a_t_a = <<?_(P0_code, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_type, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12405:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12405), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12405:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12406), {P0_face_list}) ->
    D_a_t_a = <<?_((length(P0_face_list)), "16"):16, (list_to_binary([<<?_(P1_face_id, '16'):16>> || P1_face_id <- P0_face_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12406:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12406), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12406:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12410), {P0_type}) ->
    D_a_t_a = <<?_(P0_type, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12410:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12410), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12410:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12411), {P0_lev, P0_all_gold, P0_gift_lev, P0_contract_id, P0_time}) ->
    D_a_t_a = <<?_(P0_lev, '8'):8, ?_(P0_all_gold, '32'):32, ?_((length(P0_gift_lev)), "16"):16, (list_to_binary([<<?_(P1_g_lev, '8'):8>> || P1_g_lev <- P0_gift_lev]))/binary, ?_(P0_contract_id, '8'):8, ?_(P0_time, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12411:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12411), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12411:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12412), {P0_code}) ->
    D_a_t_a = <<?_(P0_code, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12412:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12412), {P0_lev}) ->
    D_a_t_a = <<?_(P0_lev, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12412:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12413), {P0_code}) ->
    D_a_t_a = <<?_(P0_code, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12413:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12413), {P0_contract_id}) ->
    D_a_t_a = <<?_(P0_contract_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12413:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12414), {P0_has_charge, P0_has_enter}) ->
    D_a_t_a = <<?_(P0_has_charge, '8'):8, ?_(P0_has_enter, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12414:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12414), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12414:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12415), {P0_mail_id}) ->
    D_a_t_a = <<?_(P0_mail_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12415:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12415), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12415:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12416), {P0_result}) ->
    D_a_t_a = <<?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12416:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12416), {P0_mail_id}) ->
    D_a_t_a = <<?_(P0_mail_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12416:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(12417), {P0_all_mail}) ->
    D_a_t_a = <<?_((length(P0_all_mail)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8>> || P1_id <- P0_all_mail]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12417:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(12417), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 12417:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 12410, _B0) ->
    {ok, {}};
unpack(cli, 12410, _B0) ->
    {P0_type, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_type}};

unpack(srv, 12411, _B0) ->
    {ok, {}};
unpack(cli, 12411, _B0) ->
    {P0_lev, _B1} = lib_proto:read_uint8(_B0),
    {P0_all_gold, _B2} = lib_proto:read_uint32(_B1),
    {P0_gift_lev, _B5} = lib_proto:read_array(_B2, fun(_B3) ->
        {P1_g_lev, _B4} = lib_proto:read_uint8(_B3),
        {P1_g_lev, _B4}
    end),
    {P0_contract_id, _B6} = lib_proto:read_uint8(_B5),
    {P0_time, _B7} = lib_proto:read_uint8(_B6),
    {ok, {P0_lev, P0_all_gold, P0_gift_lev, P0_contract_id, P0_time}};

unpack(srv, 12412, _B0) ->
    {P0_lev, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_lev}};
unpack(cli, 12412, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_code}};

unpack(srv, 12413, _B0) ->
    {P0_contract_id, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_contract_id}};
unpack(cli, 12413, _B0) ->
    {P0_code, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_code}};

unpack(srv, 12414, _B0) ->
    {ok, {}};
unpack(cli, 12414, _B0) ->
    {P0_has_charge, _B1} = lib_proto:read_uint8(_B0),
    {P0_has_enter, _B2} = lib_proto:read_uint8(_B1),
    {ok, {P0_has_charge, P0_has_enter}};

unpack(srv, 12415, _B0) ->
    {ok, {}};
unpack(cli, 12415, _B0) ->
    {P0_mail_id, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_mail_id}};

unpack(srv, 12416, _B0) ->
    {P0_mail_id, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_mail_id}};
unpack(cli, 12416, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_result}};

unpack(srv, 12417, _B0) ->
    {ok, {}};
unpack(cli, 12417, _B0) ->
    {P0_all_mail, _B3} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint8(_B1),
        {P1_id, _B2}
    end),
    {ok, {P0_all_mail}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
