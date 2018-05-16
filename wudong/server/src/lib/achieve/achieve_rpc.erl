%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十一月 2016 10:02
%%%-------------------------------------------------------------------
-module(achieve_rpc).
-author("hxming").

-include("common.hrl").
-include("server.hrl").

%% API
-export([handle/3]).


%%成就概略
handle(13100,Player,{})->
    Data = achieve:achieve_view(),
    {ok, Bin} = pt_131:write(13100, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%成就总览
handle(13101, Player, {}) ->
    Data = achieve:achieve_general(),
    {ok, Bin} = pt_131:write(13101, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%成就子类
handle(13102, Player, {Type}) ->
    Data = achieve:achieve_type(Type),
    {ok, Bin} = pt_131:write(13102, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%领取等级奖励
handle(13103, Player, {Id}) ->
    {Ret, NewPlayer} = achieve:get_lv_reward(Player, Id),
    {ok, Bin} = pt_131:write(13103, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%成就奖励
handle(13104, Player, {AchId}) ->
    {Ret, NewPlayer} = achieve:get_achieve_reward(Player, AchId),
    {ok, Bin} = pt_131:write(13104, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


handle(_cmd, _Player, _Data) ->
    ok.

