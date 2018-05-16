%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 二月 2016 15:34
%%%-------------------------------------------------------------------
-module(grace_rpc).
-author("hxming").


-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
%% API
-export([handle/3]).

handle(63001, Player, {}) ->
    ?CAST(grace_proc:get_server_pid(), {check_state, Player#player.sid, util:unixtime()}),
    ok;



handle(63003, Player, {}) ->
    ?CAST(grace_proc:get_server_pid(), {get_target, Player#player.key, Player#player.sid, util:unixtime()}),
    ok;


handle(_cmd, _Player, _Data) ->
    ?ERR("grace bad cmd ~p~n", [_cmd]),
    ok.
