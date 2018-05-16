%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 二月 2017 19:41
%%%-------------------------------------------------------------------
-module(bubble_rpc).
-author("hxming").


-include("common.hrl").
-include("server.hrl").

-export([handle/3]).

%%获取时装列表
handle(33201, Player, _) ->
    Data = bubble:bubble_list(Player),
    {ok, Bin} = pt_332:write(33201, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%使用
handle(33202, Player, {Type, BubbleId}) ->
    {Ret, NewPlayer} =
        case Type of
            0 ->
                bubble:put_off_bubble(Player, BubbleId);
            _1 ->
                bubble:use_bubble(Player, BubbleId)
        end,
    {ok, Bin} = pt_332:write(33202, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%激活
handle(33203, Player, {BubbleId}) ->
    {Ret, NewPlayer} = bubble:activate_bubble(Player, BubbleId),
    {ok, Bin} = pt_332:write(33203, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true -> ok
    end;

%%升级
handle(33204, Player, {BubbleId}) ->
    {Ret, NewPlayer} = bubble:upgrade_bubble(Player, BubbleId),
    {ok, Bin} = pt_332:write(33204, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, attr, NewPlayer};



%%激活等级加成
handle(33206, Player, {BubbleId}) ->
    {Ret, NewPlayer} = bubble:activation_stage_lv(Player, BubbleId),
    {ok, Bin} = pt_332:write(33206, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(_cmd, _Player, _Data) ->
    ?PRINT("ErrorCode ~p ~p~n", [_cmd, _Data]),
    ok.
