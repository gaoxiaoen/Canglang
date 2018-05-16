%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 十二月 2017 15:15
%%%-------------------------------------------------------------------
-module(godness_rpc).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("godness.hrl").
-include("goods.hrl").

%% API
-export([handle/3]).

%% 获取神祇列表
handle(44401, Player, _) ->
    GodnessList = godness:get_godness_list(Player),
%%     ?DEBUG("GodnessList:~p", [GodnessList]),
    {ok, Bin} = pt_444:write(44401, {GodnessList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 激活神祇
handle(44402, Player, {GodnessId}) ->
    {Code, NewPlayer} = godness:act_godness(Player, GodnessId),
    {ok, Bin} = pt_444:write(44402, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 升星
handle(44404, Player, {GodnessKey}) ->
    {Code, NewPlayer} = godness:up_star(Player, GodnessKey),
    {ok, Bin} = pt_444:write(44404, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 升级
handle(44405, Player, {GodnessKey, Consume}) ->
    {Code, NewPlayer} = godness:up_lv(Player, GodnessKey, Consume),
    {ok, Bin} = pt_444:write(44405, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 出战
handle(44406, Player, {GodnessKey}) ->
    {Code, NewPlayer} = godness:on_war(Player, GodnessKey),
    skill:get_skill_list(NewPlayer),
    {ok, Bin} = pt_444:write(44406, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 神祇通灵激活
handle(44407, Player, {GodnessKey}) ->
    {Code, NewPlayer} = godness:act_skill(Player, GodnessKey),
    skill:get_skill_list(NewPlayer),
    {ok, Bin} = pt_444:write(44407, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 神魂上阵/替换
handle(44408, Player, {Pos, GodnessKey, GoodsKey}) ->
    {Code, NewPlayer} = god_soul:put_on(Player, Pos, GodnessKey, GoodsKey),
    {ok, Bin} = pt_444:write(44408, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 神魂吞噬
handle(44409, Player, {GoodsKey, TunsiGoodsKeyList}) ->
    {Code, NewPlayer} = god_soul:tunsi(Player, GoodsKey, TunsiGoodsKeyList),
    {ok, Bin} = pt_444:write(44409, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(_Cmd, _Player, _) ->
    ?ERR("Cmd:~p", [_Cmd]),
    ok.