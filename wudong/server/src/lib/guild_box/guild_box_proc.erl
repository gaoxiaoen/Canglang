%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 十二月 2017 10:32
%%%-------------------------------------------------------------------
-module(guild_box_proc).
-author("luobq").

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
    code_change/3,
    get_server_pid/0
]).

-define(SERVER, ?MODULE).

-record(state, {}).

%% API
-export([start_link/0, apply_call/3, apply_cast/3, apply_info/3]).
%% -export([sys_guild_timer/0, cmd_timer_update/0]).
%%
%% sys_guild_timer() ->
%%     ?MODULE ! sys_guild_timer.
%%
%% cmd_timer_update() ->
%%     ?MODULE ! timer_update.

get_server_pid() ->
    case get(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            case misc:whereis_name(local,?MODULE) of
                Pid when is_pid(Pid) ->
                    put(?MODULE,Pid),
                    Pid;
                _ ->
                    undefined
            end
    end.

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
%%     ets:new(?GUILD_BOX_ETS, [{keypos, #guild_box.pkey} | ?ETS_OPTIONS]),
    guild_box_init:init([]),
    {ok, #state{}}.


handle_call(Request, From, State) ->
    case catch guild_box_handle:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("guild box handle_call ~p~n", [Reason]),
            {reply, error, State}
    end.


handle_cast(Request, State) ->
    case catch guild_box_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("guild box handle_cast ~p~n", [Reason]),
            {noreply, State}
    end.


handle_info(Request, State) ->
    case catch guild_box_handle:handle_info(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("guild box handle_info ~p~n", [Reason]),
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
