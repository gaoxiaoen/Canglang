%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 八月 2017 10:35
%%%-------------------------------------------------------------------
-module(fairy_soul_rpc).
-author("Administrator").
-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("fairy_soul.hrl").

%% API
-export([handle/3]).

%% 获取玩家系统信息
handle(64100, Player, _) ->
    Data = fairy_soul:get_my_fairy_soul_info(Player),
    {ok, Bin} = pt_641:write(64100, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 镶嵌仙魂
handle(64101, Player, {GoodsKey, Pos}) ->
    {Code, NewPlayer} = fairy_soul:put_on_fairl_soul(Player, GoodsKey, Pos),
    {ok, Bin} = pt_641:write(64101, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 升级仙魂
handle(64102, Player, {GoodsKey}) ->
    {Code, NewPlayer} = fairy_soul:upgrade(Player, GoodsKey),
    {ok, Bin} = pt_641:write(64102, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 分解仙魂
handle(64103, Player, {GoodsKeyList}) ->
    {Code, NewPlayer, AccExp} = fairy_soul:resolved_fairy_soul(Player, GoodsKeyList),
    {ok, Bin} = pt_641:write(64103, {Code, AccExp}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 兑换仙魂
handle(64104, Player, {GoodsId}) ->
    {Code, NewPlayer} = fairy_soul:exchange(Player, GoodsId),
    {ok, Bin} = pt_641:write(64104, {Code,GoodsId}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 卸下仙魂
handle(64105, Player, {Pos}) ->
    {Code, NewPlayer} = fairy_soul:put_down_fairl_soul(Player, Pos),
    {ok, Bin} = pt_641:write(64105, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取猎魂信息
handle(64106, Player, {}) ->
    Data = fairy_soul:get_draw_info(Player),
    {ok, Bin} = pt_641:write(64106, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 猎取仙魂
handle(64107, Player, {Color}) ->
    {Code, NewPlayer, GoodsId, IsResolved} = fairy_soul:draw(Player, Color),
    {ok, Bin} = pt_641:write(64107, {Code, GoodsId, IsResolved}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 付费开启
handle(64108, Player, {}) ->
    {Code, NewPlayer} = fairy_soul:open_draw(Player),
    {ok, Bin} = pt_641:write(64108, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 一键获取
handle(64109, Player, {}) ->
    {Code, NewPlayer} = fairy_soul:get_draw(Player),
    {ok, Bin} = pt_641:write(64109, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 一键猎魂
handle(64110, Player, {Color}) ->
    {Code, NewPlayer, List1, List2, List3} = fairy_soul:quick_get_draw(Player, Color),
    {ok, Bin} = pt_641:write(64110, {Code, List1, List2, List3}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取仙魂
handle(64111, Player, {GoodsId}) ->
    {Code, NewPlayer} = fairy_soul:get_fairy_soul(Player, GoodsId),
    {ok, Bin} = pt_641:write(64111, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


handle(_Cmd, _Player, _) ->
    ok.
