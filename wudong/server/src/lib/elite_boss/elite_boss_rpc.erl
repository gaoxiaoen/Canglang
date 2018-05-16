%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 一月 2018 15:20
%%%-------------------------------------------------------------------
-module(elite_boss_rpc).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("elite_boss.hrl").

%% API
-export([handle/3]).

%% 读取精英boss面板信息
handle(44501, Player, _) ->
    elite_boss:get_act_into(Player),
    ok;

%% 检查进入游戏
handle(44502, Player, {SceneId}) ->
    elite_boss:enter_elite_boss(Player, SceneId),
    ok;

%% 退出游戏
handle(44503, Player, _) ->
    elite_boss:check_quit(Player#player.key, Player#player.scene),
    ok;

%% 读取精英boss伤害数据
handle(44504, Player, _) ->
    elite_boss:get_boss_data(Player#player.scene, Player#player.key, Player#player.sid),
    ok;

%% 领取每日令牌福利
handle(44505, Player, _) ->
    {Code, NewPlayer} = elite_boss:recv_daily(Player),
    {ok, Bin} = pt_445:write(44505, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取购买信息
handle(44507, Player, _) ->
    {BuyNum, Price} = elite_boss:get_buy_info(Player),
    {ok, Bin} = pt_445:write(44507, {BuyNum, Price}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 购买金令牌
handle(44508, Player, _) ->
    {Code, NewPlayer} = elite_boss:buy(Player, 1),
    {ok, Bin} = pt_445:write(44508, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(_Cmd, _Player, _Args) ->
    ?ERR("Cmd:~p", [_Cmd]),
    ok.
