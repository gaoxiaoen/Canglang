%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2017 10:18
%%%-------------------------------------------------------------------
-module(head_rpc).
-author("hxming").

%% API
-include("common.hrl").
-include("server.hrl").

-export([handle/3]).

%%获取头饰列表
handle(33301, Player, _) ->
    Data = head:head_list(Player),
    {ok, Bin} = pt_333:write(33301, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%使用头饰
handle(33302, Player, {Type, HeadId}) ->
    {Ret, NewPlayer} =
        case Type of
            0 ->
                head:put_off_head(Player, HeadId);
            _1 ->
                head:use_head(Player, HeadId)
        end,
    {ok, Bin} = pt_333:write(33302, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, fashion, NewPlayer};
        true -> ok
    end;

%%激活
handle(33303, Player, {HeadId}) ->
    {Ret, NewPlayer} = head:activate_head(Player, HeadId),
    {ok, Bin} = pt_333:write(33303, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, fashion, NewPlayer};
        true -> ok
    end;

%%升级
handle(33304, Player, {HeadId}) ->
    {Ret, NewPlayer} = head:upgrade_head(Player, HeadId),
    {ok, Bin} = pt_333:write(33304, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, attr, NewPlayer};

%%激活等级加成
handle(33306, Player, {HeadId}) ->
    {Ret, NewPlayer} = head:activation_stage_lv(Player, HeadId),
    {ok, Bin} = pt_333:write(33306, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(_cmd, _Player, _Data) ->
    ?PRINT("ErrorCode ~p ~p~n", [_cmd, _Data]),
    ok.
