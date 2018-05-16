%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 七月 2017 17:05
%%%-------------------------------------------------------------------
-module(handle_party).
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
        catch party_proc:get_server_pid() ! {party_timer,Time},
    {ok, State}.
