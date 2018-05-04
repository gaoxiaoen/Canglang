%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_138).
-export([pack/3, unpack/3]).

-ifdef(debug_proto).
-define(_(X, Y), (begin io:format("~p:~w CMD:~p ~s(~s)=~p\n", [?MODULE, ?LINE, _CMD, ??X, Y, X]), X end)).
-define(_CMD(X), (_CMD = X)).
-else.
-define(_(X, _Y), X).
-define(_CMD(X), X).
-endif.

-include("activity2.hrl").

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, ?_CMD(13800), {P0_activitylist, P0_sum, P0_sumlimit}) ->
    D_a_t_a = <<?_((length(P0_activitylist)), "16"):16, (list_to_binary([<<?_(P1_id, '8'):8, ?_(P1_num, '8'):8>> || {P1_id, P1_num} <- P0_activitylist]))/binary, ?_(P0_sum, '16'):16, ?_(P0_sumlimit, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13800:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13800), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13800:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13801), {P0_type, P0_time, P0_base, P0_num}) ->
    D_a_t_a = <<?_(P0_type, '8'):8, ?_(P0_time, '32'):32, ?_(P0_base, '32'):32, ?_(P0_num, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13801:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13801), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13801:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13802), {P0_flag, P0_type, P0_base, P0_num, P0_nexttype, P0_nextbase, P0_nextnum, P0_time}) ->
    D_a_t_a = <<?_(P0_flag, '8'):8, ?_(P0_type, '8'):8, ?_(P0_base, '32'):32, ?_(P0_num, '32'):32, ?_(P0_nexttype, '8'):8, ?_(P0_nextbase, '32'):32, ?_(P0_nextnum, '32'):32, ?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13802:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13802), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13802:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13803), {P0_task_ids}) ->
    D_a_t_a = <<?_((length(P0_task_ids)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32>> || P1_id <- P0_task_ids]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13803:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13803), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13803:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13804), {P0_activitylist}) ->
    D_a_t_a = <<?_((length(P0_activitylist)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32, ?_(P1_current, '32'):32, ?_(P1_status, '8'):8>> || #activity2_event{id = P1_id, current = P1_current, status = P1_status} <- P0_activitylist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13804:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13804), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13804:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13805), {P0_result, P0_msg, P0_id}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_((byte_size(P0_msg)), "16"):16, ?_(P0_msg, bin)/binary, ?_(P0_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13805:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13805), {P0_task_id}) ->
    D_a_t_a = <<?_(P0_task_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13805:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13806), {P0_id, P0_current, P0_status}) ->
    D_a_t_a = <<?_(P0_id, '32'):32, ?_(P0_current, '32'):32, ?_(P0_status, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13806:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13806), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13806:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13807), {P0_event_ids}) ->
    D_a_t_a = <<?_((length(P0_event_ids)), "16"):16, (list_to_binary([<<?_(P1_id, '32'):32>> || P1_id <- P0_event_ids]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13807:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13807), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13807:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13808), {P0_result, P0_msg}) ->
    D_a_t_a = <<?_(P0_result, '8'):8, ?_(P0_msg, '16'):16>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13808:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13808), {P0_event_id}) ->
    D_a_t_a = <<?_(P0_event_id, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13808:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13809), {P0_mail_id, P0_time}) ->
    D_a_t_a = <<?_(P0_mail_id, '8'):8, ?_(P0_time, '32'):32>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13809:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13809), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13809:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13810), {P0_result}) ->
    D_a_t_a = <<?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13810:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13810), {P0_mail_id}) ->
    D_a_t_a = <<?_(P0_mail_id, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13810:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13811), {P0_all_mail}) ->
    D_a_t_a = <<?_((length(P0_all_mail)), "16"):16, (list_to_binary([<<?_(P1_mail_id, '8'):8, ?_(P1_time, '32'):32>> || {P1_mail_id, P1_time} <- P0_all_mail]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13811:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13811), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13811:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13820), {P0_lasttime, P0_list}) ->
    D_a_t_a = <<?_(P0_lasttime, '32'):32, ?_((length(P0_list)), "16"):16, (list_to_binary([<<?_(P1_day, '8'):8, ?_(P1_double, '8'):8, ?_(P1_vip, '8'):8>> || {P1_day, P1_double, P1_vip} <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13820:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13820), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13820:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13821), {P0_result}) ->
    D_a_t_a = <<?_(P0_result, '8'):8>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13821:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13821), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13821:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(13822), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13822:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(13822), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 13822:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 13803, _B0) ->
    {ok, {}};
unpack(cli, 13803, _B0) ->
    {P0_task_ids, _B3} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_id, _B2}
    end),
    {ok, {P0_task_ids}};

unpack(srv, 13804, _B0) ->
    {ok, {}};
unpack(cli, 13804, _B0) ->
    {P0_activitylist, _B5} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_current, _B3} = lib_proto:read_uint32(_B2),
        {P1_status, _B4} = lib_proto:read_uint8(_B3),
        {[P1_id, P1_current, P1_status], _B4}
    end),
    {ok, {P0_activitylist}};

unpack(srv, 13805, _B0) ->
    {P0_task_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_task_id}};
unpack(cli, 13805, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_string(_B1),
    {P0_id, _B3} = lib_proto:read_uint32(_B2),
    {ok, {P0_result, P0_msg, P0_id}};

unpack(srv, 13806, _B0) ->
    {ok, {}};
unpack(cli, 13806, _B0) ->
    {P0_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_current, _B2} = lib_proto:read_uint32(_B1),
    {P0_status, _B3} = lib_proto:read_uint8(_B2),
    {ok, {P0_id, P0_current, P0_status}};

unpack(srv, 13807, _B0) ->
    {ok, {}};
unpack(cli, 13807, _B0) ->
    {P0_event_ids, _B3} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_id, _B2}
    end),
    {ok, {P0_event_ids}};

unpack(srv, 13808, _B0) ->
    {P0_event_id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {P0_event_id}};
unpack(cli, 13808, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {P0_msg, _B2} = lib_proto:read_uint16(_B1),
    {ok, {P0_result, P0_msg}};

unpack(srv, 13809, _B0) ->
    {ok, {}};
unpack(cli, 13809, _B0) ->
    {P0_mail_id, _B1} = lib_proto:read_uint8(_B0),
    {P0_time, _B2} = lib_proto:read_uint32(_B1),
    {ok, {P0_mail_id, P0_time}};

unpack(srv, 13810, _B0) ->
    {P0_mail_id, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_mail_id}};
unpack(cli, 13810, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_result}};

unpack(srv, 13811, _B0) ->
    {ok, {}};
unpack(cli, 13811, _B0) ->
    {P0_all_mail, _B4} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_mail_id, _B2} = lib_proto:read_uint8(_B1),
        {P1_time, _B3} = lib_proto:read_uint32(_B2),
        {[P1_mail_id, P1_time], _B3}
    end),
    {ok, {P0_all_mail}};

unpack(srv, 13820, _B0) ->
    {ok, {}};
unpack(cli, 13820, _B0) ->
    {P0_lasttime, _B1} = lib_proto:read_uint32(_B0),
    {P0_list, _B6} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_day, _B3} = lib_proto:read_uint8(_B2),
        {P1_double, _B4} = lib_proto:read_uint8(_B3),
        {P1_vip, _B5} = lib_proto:read_uint8(_B4),
        {[P1_day, P1_double, P1_vip], _B5}
    end),
    {ok, {P0_lasttime, P0_list}};

unpack(srv, 13821, _B0) ->
    {ok, {}};
unpack(cli, 13821, _B0) ->
    {P0_result, _B1} = lib_proto:read_uint8(_B0),
    {ok, {P0_result}};

unpack(srv, 13822, _B0) ->
    {ok, {}};
unpack(cli, 13822, _B0) ->
    {ok, {}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
