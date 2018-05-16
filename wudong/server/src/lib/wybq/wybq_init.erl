%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 三月 2017 16:45
%%%-------------------------------------------------------------------
-module(wybq_init).
-author("li").

-include("server.hrl").
-include("common.hrl").
-include("wybq.hrl").

%% API
-export([init/0]).

init() ->
    ets:new(?ETS_SYS_WYBQ, [{keypos, #ets_sys_wybq.pkey} | ?ETS_OPTIONS]),
    Rand = util:rand(1000, 5000),
    spawn(fun() -> timer:sleep(2000+Rand), init_ets() end),
    ok.

init_ets() ->
    ?DEBUG("init_ets~n", []),
    wybq_load:get_all(),
    ok.
