%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2017 13:49
%%%-------------------------------------------------------------------
-module(fuwen_rpc).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("fuwen.hrl").

%% API
-export([handle/3]).

%% 获取玩家系统信息
handle(43500, Player, _) ->
    {Exp, Chips, Pos, Layer, SubLayer, LockList} = fuwen:get_my_fuwen_info(Player),
    ?DEBUG("Exp:~p, Chips:~p, Pos:~p, Layer:~p, SubLayer:~p, LockList:~p",
        [Exp, Chips, Pos, Layer, SubLayer, LockList]),
    {ok, Bin} = pt_435:write(43500, {Exp, Chips, Pos, Layer, SubLayer, LockList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 镶嵌符文
handle(43501, Player, {GoodsKey, Pos}) ->
    {Code, NewPlayer} = fuwen:put_on_fuwen(Player, GoodsKey, Pos),
    {ok, Bin} = pt_435:write(43501, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 升级符文
handle(43502, Player, {GoodsKey}) ->
    {Code, NewPlayer} = fuwen:upgrade(Player, GoodsKey),
    {ok, Bin} = pt_435:write(43502, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 分解符文
handle(43503, Player, {GoodsKeyList}) ->
    {Code, NewPlayer} = fuwen:resolved_fuwen(Player, GoodsKeyList),
    {ok, Bin} = pt_435:write(43503, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%兑换符文
handle(43504, Player, {GoodsId}) ->
    {Code, NewPlayer} = fuwen:exchange(Player, GoodsId),
    {ok, Bin} = pt_435:write(43504, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%符文预览
handle(43505, Player, {GoodsKey1, GoodsKey2}) ->
    FuwenInfoList = fuwen:lookup(Player, GoodsKey1, GoodsKey2),
    {ok, Bin} = pt_435:write(43505, {FuwenInfoList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%符文预览提示
handle(43506, Player, _) ->
    List = fuwen:lookup_notice(Player),
    {ok, Bin} = pt_435:write(43506, {List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%符文合成
handle(43507, Player, {GoodsId,GoodsKeyList}) ->
    {Code, NewPlayer} = fuwen:compound(Player, GoodsKeyList, GoodsId),
    {ok, Bin} = pt_435:write(43507, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(_Cmd, _Player, _) ->
    ok.