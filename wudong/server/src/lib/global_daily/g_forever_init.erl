%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, junhai
%%% @doc
%%%
%%% @end
%%% Created : 10. 三月 2015 14:53
%%%-------------------------------------------------------------------
-module(g_forever_init).
-author("fzl").
-include("g_daily.hrl").
-include("common.hrl").

%% API
-export([
    init/0
]).

init() ->
    Data = g_forever_load:get_all(),
    F = fun([Type, Count, Time]) ->
        ets:insert(?G_FOREVER_ETS, #g_forever{type = Type, count = Count, time = Time})
        end,
    lists:foreach(F, Data).
