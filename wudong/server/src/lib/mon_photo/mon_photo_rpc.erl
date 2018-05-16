%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 一月 2017 15:19
%%%-------------------------------------------------------------------
-module(mon_photo_rpc).
-author("hxming").

-include("server.hrl").
-include("common.hrl").
%% API
-export([handle/3]).

%%图鉴总览
handle(20101, Player, {}) ->
    Data = mon_photo:mon_photo_info(),
    {ok, Bin} = pt_201:write(20101, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%场景怪物信息
handle(20102, Player, {SceneId}) ->
    Data = mon_photo:get_mon_photo(SceneId),
    {ok, Bin} = pt_201:write(20102, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(20103, Player, {Mid}) ->
    {Ret, NewPlayer} = mon_photo:upgrade(Player, Mid),
    {ok, Bin} = pt_201:write(20103, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, attr, NewPlayer};

handle(_cmd, _player, _data) ->
    ok.
