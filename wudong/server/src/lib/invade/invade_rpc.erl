%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 二月 2016 14:55
%%%-------------------------------------------------------------------
-module(invade_rpc).
-author("hxming").
-include("common.hrl").
-include("server.hrl").
%% API
-export([handle/3]).

handle(61001, Player, {}) ->
    ?CAST(invade_proc:get_server_pid(), {check_state, Player#player.sid, util:unixtime()}),
    ok;

handle(_cmd, _Player, _Data) ->
    ?ERR("invade bad cmd ~p~n", [_cmd]),
    ok.
