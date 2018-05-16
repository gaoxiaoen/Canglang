%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 五月 2017 上午11:01
%%%-------------------------------------------------------------------
-module(cross_fruit_rpc).
-author("fengzhenlin").
-include("server.hrl").

%% API
-export([handle/3]).

handle(58201, Player, _) ->
    cross_fruit:get_my_fruit_info(Player),
    ok;

handle(58202, Player, {Type}) ->
    cross_fruit:apply_match(Player, Type),
    ok;

handle(58204, Player, _) ->
    cross_all:apply(cross_fruit_proc, get_fight_info, [Player#player.key]),
    ok;

handle(58205, Player, {Type, Pos}) ->
    cross_all:apply(cross_fruit_proc, operate, [Player#player.key, Type, Pos]),
    ok;

handle(58207, Player, _) ->
    cross_all:apply(cross_fruit_proc, exit, [Player#player.key]),
    {ok, Bin} = pt_582:write(58207, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(58210, Player, _) ->
    cross_all:apply(cross_fruit_proc, get_week_rank_gift_info, [Player#player.key, Player#player.node, Player#player.sid]),
    ok;

handle(58211, Player, _) ->
    cross_all:apply(cross_fruit_proc, get_week_rank, [Player#player.key, Player#player.node, Player#player.sid]),
    ok;

handle(58220, Player, {PkeyList}) ->
    cross_fruit:invite(Player, PkeyList),
    ok;

handle(58222, Player, {Pkey, Res}) ->
    cross_fruit:invite_res(Player, Pkey, Res),
    ok;

handle(58223, Player, {Pkey}) ->
    cross_fruit:continue(Player, Pkey),
    ok;

handle(_cmd, _Player, _Data) ->
    ok.
