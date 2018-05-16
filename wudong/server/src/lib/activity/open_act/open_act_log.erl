%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 九月 2017 23:44
%%%-------------------------------------------------------------------
-module(open_act_log).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    log/2
]).

log(_Type, _Args) ->
    ok.
