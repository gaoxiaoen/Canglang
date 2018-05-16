%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 四月 2016 下午3:13
%%%-------------------------------------------------------------------
-module(red_bag_rpc).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").

%% API
-export([
    handle/3
]).

handle(38201, Player, {Key}) ->
    red_bag:open_red_bag(Player, Key);

handle(38211, Player, {Key}) ->
    red_bag:open_red_bag_guild(Player, Key);

handle(38212, Player, {RedbagKey}) ->
    ?CAST(red_bag_proc:get_server_pid(), {get_guild_red_bag_info, RedbagKey, Player#player.key, Player#player.sid}),
    ok;


handle(38215, Player, {Key}) ->
    red_bag:open_red_bag_marry(Player, Key);

handle(38216, Player, {RedbagKey}) ->
    ?CAST(red_bag_proc:get_server_pid(), {get_marry_red_bag_info, RedbagKey, Player#player.key, Player#player.sid}),
    ok;

handle(_cmd,_Player,_Data) ->
    ?ERR("red_bag_rpc cmd ~p~n",[_cmd]),
    ok.