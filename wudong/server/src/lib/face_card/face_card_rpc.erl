%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 二月 2018 16:46
%%%-------------------------------------------------------------------
-module(face_card_rpc).
-author("li").

-include("common.hrl").
-include("server.hrl").

%% API
-export([handle/3]).

%% 读取vip表情数据
handle(44601, Player, _) ->
    Data = vip_face:get_vip_face_info(Player),
    {ok, Bin} = pt_446:write(44601, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 发送魔法表情数据
handle(44602, Player, {Id, Pkey, IsAuto}) ->
    {Code, NewPlayer} = magic_face:send_face(Player, Id, Pkey, IsAuto),
    {ok, Bin} = pt_446:write(44602, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(Cmd, _Player, _Args) ->
    ?ERR("Cmd:~p Args:~p", [Cmd, _Args]),
    ok.
