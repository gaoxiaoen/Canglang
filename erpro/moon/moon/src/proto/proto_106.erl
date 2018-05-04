%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_106).
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

pack(srv, ?_CMD(10600), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10600:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10600), {P0_story_id, P0_npc}) ->
    D_a_t_a = <<?_(P0_story_id, '32'):32, ?_((length(P0_npc)), "16"):16, (list_to_binary([<<?_(P1_section_id, '32'):32, ?_(P1_npc_base_id, '32'):32, ?_(P1_npc_id, '32'):32>> || {P1_section_id, P1_npc_base_id, P1_npc_id} <- P0_npc]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10600:16, D_a_t_a/binary>>};

pack(srv, ?_CMD(10601), {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10601:16, D_a_t_a/binary>>};
pack(cli, ?_CMD(10601), {P0_npc}) ->
    D_a_t_a = <<?_((length(P0_npc)), "16"):16, (list_to_binary([<<?_(P1_npc_base_id, '32'):32>> || {P1_npc_base_id} <- P0_npc]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 2):32, 10601:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 10600, _B0) ->
    {P0_story_id, _B1} = lib_proto:read_uint32(_B0),
    {P0_npc, _B6} = lib_proto:read_array(_B1, fun(_B2) ->
        {P1_section_id, _B3} = lib_proto:read_uint32(_B2),
        {P1_npc_base_id, _B4} = lib_proto:read_uint32(_B3),
        {P1_npc_id, _B5} = lib_proto:read_uint32(_B4),
        {[P1_section_id, P1_npc_base_id, P1_npc_id], _B5}
    end),
    {ok, {P0_story_id, P0_npc}};
unpack(cli, 10600, _B0) ->
    {ok, {}};

unpack(srv, 10601, _B0) ->
    {P0_npc, _B3} = lib_proto:read_array(_B0, fun(_B1) ->
        {P1_npc_base_id, _B2} = lib_proto:read_uint32(_B1),
        {P1_npc_base_id, _B2}
    end),
    {ok, {P0_npc}};
unpack(cli, 10601, _B0) ->
    {ok, {}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
