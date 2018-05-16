%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 十一月 2015 10:23
%%%-------------------------------------------------------------------
-module(guild).
-author("hxming").

%% API
-behaviour(gen_server).

-include("guild.hrl").
-include("common.hrl").

%% gen_server callbacks
-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-define(SERVER, ?MODULE).

%% API
-export([start_link/0, apply_call/3, apply_cast/3, apply_info/3]).
-export([sys_guild_timer/0, cmd_timer_update/0]).

sys_guild_timer() ->
    ?MODULE ! sys_guild_timer.

cmd_timer_update() ->
    ?MODULE ! timer_update.

%%创建
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

apply_cast(Module, Function, Args) ->
    ?CAST(?MODULE, {apply, {Module, Function, Args}}).

apply_info(Module, Function, Args) ->
    ?MODULE ! {apply, {Module, Function, Args}}.

apply_call(Module, Function, Args) ->
    ?CALL(?MODULE, {apply, {Module, Function, Args}}).

init([]) ->
    process_flag(trap_exit, true),
    ets:new(?ETS_GUILD_HISTORY, [{keypos, #g_history.pkey} | ?ETS_OPTIONS]),
    guild_init:init_guild_data(),
    Ref1 = erlang:send_after(?GUILD_SYS_GUILD_TIME * 1000, self(), sys_guild_timer),
    Ref2 = erlang:send_after(5 * 1000, self(), timer_update),
    {ok, #guild_state{sys_guild_ref = Ref1, timer_update_ref = Ref2}}.



handle_call(Request, From, State) ->
    case catch guild_handle:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("guild handle_call ~p~n", [Reason]),
            {reply, error, State}
    end.


handle_cast(Request, State) ->
    case catch guild_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("guild handle_cast ~p~n", [Reason]),
            {noreply, State}
    end.

handle_info(Request, State) ->
    case catch guild_handle:handle_info(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("guild handle_info ~p~n", [Reason]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    guild_init:close_update(),
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
