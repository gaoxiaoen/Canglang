%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 七月 2017 10:54
%%%-------------------------------------------------------------------
-module(handle_marry).
-author("hxming").


-include("common.hrl").
-include("server.hrl").

%% API
-export([
    init/0,
    handle/2
]).

init() ->
    {ok, ok}.

handle(State, Time) ->
        catch marry_proc:get_server_pid() ! {cruise_timer,Time},
    {ok, State}.
