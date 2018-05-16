%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 三月 2016 上午10:52
%%%-------------------------------------------------------------------
-module(worship_init).
-author("fengzhenlin").
-include("worship.hrl").
-include("server.hrl").
-include("common.hrl").

%% API
-export([
    init/1
]).

init(Player) ->
    Player.
