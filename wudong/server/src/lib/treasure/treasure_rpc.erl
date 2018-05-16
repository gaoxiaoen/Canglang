%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 十一月 2015 11:19
%%%-------------------------------------------------------------------
-module(treasure_rpc).
-author("hxming").
-include("server.hrl").
-include("common.hrl").
%% API
-export([handle/3]).

%%获取藏宝图信息
handle(15101,Player,{MapId})->
    Data = treasure:treasure_info(Player,MapId),
    {ok,Bin} = pt_151:write(15101,Data),
    server_send:send_to_sid(Player#player.sid,Bin),
    ok;

%%藏宝图传送
handle(15102,Player,{MapId})->
    {Ret,NewPlayer} = treasure:treasure_transport(Player,MapId),
    {ok,Bin} = pt_151:write(15102,{Ret}),
    server_send:send_to_sid(Player#player.sid,Bin),
    {ok,NewPlayer};

%%挖宝
handle(15103,Player,{MapId})->
    {Ret,NewPlayer,GoodsList} = treasure:treasure_hunt(Player,MapId),
    {ok,Bin} = pt_151:write(15103,{Ret,GoodsList}),
    server_send:send_to_sid(Player#player.sid,Bin),
    {ok,NewPlayer};

handle(_, _Player, _) ->
    ok.

