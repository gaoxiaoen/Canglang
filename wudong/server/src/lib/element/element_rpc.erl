%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 三月 2018 11:13
%%%-------------------------------------------------------------------
-module(element_rpc).
-author("li").

-include("server.hrl").
-include("common.hrl").
-include("element.hrl").

%% API
-export([handle/3]).

%% 读取剑道数据
handle(44801, Player, _) ->
    Data = element:get_jiandao_info(Player),
    {ok, Bin} = pt_448:write(44801, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 剑道升级
handle(44802, Player, _) ->
    {Code, NewPlayer} = element:jiandao_up_lv(Player),
    {ok, Bin} = pt_448:write(44802, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 剑道升阶
handle(44803, Player, _) ->
    {Code, NewPlayer} = element:jiandao_up_stage(Player),
    {ok, Bin} = pt_448:write(44803, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 读取元素列表
handle(44804, Player, _) ->
    Data = element:get_element_list(Player),
    {ok, Bin} = pt_448:write(44804, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 元素升级/激活
handle(44805, Player, {Race}) ->
    {Code, NewPlayer} = element:element_up_lv(Player, Race),
    {ok, Bin} = pt_448:write(44805, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 元素属性升级
handle(44806, Player, {Race}) ->
    {Code, NewPlayer} = element:element_up_e_lv(Player, Race),
    {ok, Bin} = pt_448:write(44806, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 元素升阶
handle(44807, Player, {Race}) ->
    {Code, NewPlayer} = element:element_up_stage(Player, Race),
    {ok, Bin} = pt_448:write(44807, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 元素装备
handle(44808, Player, {Race, Pos}) ->
    {Code, NewPlayer} = element:wear_element(Player, Race, Pos),
    {ok, Bin} = pt_448:write(44808, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 元素卸下
handle(44809, Player, {Race, Pos}) ->
    {Code, NewPlayer} = element:off_element(Player, Race, Pos),
    {ok, Bin} = pt_448:write(44809, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(Cmd, _Player, Args) ->
    ?ERR("Cmd:~p Args:~p", [Cmd, Args]),
    ok.

