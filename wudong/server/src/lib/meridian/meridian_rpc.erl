%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 十一月 2016 13:43
%%%-------------------------------------------------------------------
-module(meridian_rpc).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
%% API
-export([handle/3]).

%%获取经脉信息列表
handle(42001, Player, {Type}) ->
    Data = meridian:get_meridian_list(Player, Type),
    {ok, Bin} = pt_420:write(42001, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%经脉激活
handle(42002, Player, {Type}) ->
    {Ret, NewPlayer} = meridian:activate(Player, Type),
    {ok, Bin} = pt_420:write(42002, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

handle(42003, Player, {Type}) ->
    {Ret, NewPlayer} = meridian:upgrade(Player, Type),
    {ok, Bin} = pt_420:write(42003, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            {ok, NewPlayer}
    end;


handle(42004, Player, {Type, IsAuto}) ->
    {Ret, NewPlayer} = meridian:break(Player, Type, IsAuto),
    {ok, Bin} = pt_420:write(42004, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            {ok, NewPlayer}
    end;


%%清CD
handle(42005, Player, {Type}) ->
    {Ret, NewPlayer} = meridian:clean_cd(Player, Type),
    {ok, Bin} = pt_420:write(42005, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(_cmd, _Player, _Data) ->
    ?ERR("meridian_rpc cmd ~p~n", [_cmd]),
    ok.
