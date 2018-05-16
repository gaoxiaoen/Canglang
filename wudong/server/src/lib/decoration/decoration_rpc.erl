%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 七月 2017 11:59
%%%-------------------------------------------------------------------
-module(decoration_rpc).
-author("hxming").


-include("common.hrl").
-include("server.hrl").

-export([handle/3]).

%%获取时装列表
handle(33401, Player, _) ->
    Data = decoration:decoration_list(Player),
    {ok, Bin} = pt_334:write(33401, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%使用
handle(33402, Player, {Type, BubbleId}) ->
    ?PRINT("33402 =============="),
    {Ret, NewPlayer} =
        case Type of
            0 ->
                decoration:put_off_decoration(Player, BubbleId);
            _1 ->
                decoration:use_decoration(Player, BubbleId)
        end,
    {ok, Bin} = pt_334:write(33402, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%激活
handle(33403, Player, {BubbleId}) ->
    {Ret, NewPlayer} = decoration:activate_decoration(Player, BubbleId),
    {ok, Bin} = pt_334:write(33403, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true -> ok
    end;

%%升级
handle(33404, Player, {BubbleId}) ->
    {Ret, NewPlayer} = decoration:upgrade_decoration(Player, BubbleId),
    {ok, Bin} = pt_334:write(33404, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, attr, NewPlayer};

%%激活等级加成
handle(33406, Player, {FashionId}) ->
    {Ret, NewPlayer} = decoration:activation_stage_lv(Player, FashionId),
    {ok, Bin} = pt_334:write(33406, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(_cmd, _Player, _Data) ->
    ?PRINT("ErrorCode ~p ~p~n", [_cmd, _Data]),
    ok.
