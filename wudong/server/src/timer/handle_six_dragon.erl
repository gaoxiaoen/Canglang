%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 二月 2017 下午2:26
%%%-------------------------------------------------------------------
-module(handle_six_dragon).
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
    case center:is_center_area() of
        true -> spawn(fun() -> cross_six_dragon:check_open_time(Time) end);
        false -> skip
    end,
    {ok, State}.
