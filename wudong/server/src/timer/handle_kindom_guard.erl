%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 二月 2017 下午3:18
%%%-------------------------------------------------------------------
-module(handle_kindom_guard).
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
    spawn(fun() -> kindom_guard:check_open_time(Time) end),
    {ok, State}.
