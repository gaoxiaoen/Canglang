%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, junhai
%%% @doc
%%%
%%% @end
%%% Created : 10. 三月 2015 14:53
%%%-------------------------------------------------------------------
-module(g_daily_init).
-author("fzl").
-include("g_daily.hrl").
-include("common.hrl").

%% API
-export([
    init/0
]).

init() ->
    Data = g_daily_load:get_all(),
    Date = util:unixdate(),
    F = fun([Type, Count, Time]) ->
        if Time == Date ->
            ets:insert(?G_DAILY_ETS, #g_daily{type = Type, count = Count, time = Time});
            true -> skip
        end
        end,
    lists:foreach(F, Data).
