%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 二月 2015 下午9:18
%%%-------------------------------------------------------------------
-module(rank_rpc).
-author("fancy").
-include("server.hrl").
-include("rank.hrl").
-include("common.hrl").

%% API
-export([handle/3]).



handle(48001,Player,{Type,Page}) ->
    ?CAST(rank_proc:get_rank_pid(), {get_rank, Type, Page, Player#player.key, Player#player.sid}),
    ok;

handle(48002,Player,{Type,Pkey}) ->
    ?CAST(rank_proc:get_rank_pid(), {rank_wp, Type, Pkey, Player#player.key, Player#player.sid, Player#player.pid}),
    ok;

handle(_cmd,_Player,_Data) ->
    ok.

