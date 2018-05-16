%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 二月 2017 下午2:26
%%%-------------------------------------------------------------------
-module(handle_hot_well).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").

%% API
-export([
    init/0,
    handle/2
]).

init() ->
    {ok,ok}.

handle(State, Time) ->
    case config:is_center_node() of
        false ->
            skip;
        true ->
            spawn(fun() -> hot_well:check_open_time(Time) end)
    end,
    {ok, State}.
