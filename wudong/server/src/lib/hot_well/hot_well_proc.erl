%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 温泉
%%% @end
%%% Created : 15. 五月 2017 下午8:05
%%%-------------------------------------------------------------------
-module(hot_well_proc).
-author("fengzhenlin").

-behaviour(gen_server).

-include("common.hrl").
-include("hot_well.hrl").

%% API
-export([
    start_link/0,
    get_server_pid/0
]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-export([
    cmd_start/0,
    cmd_close/0
]).

-define(SERVER, ?MODULE).

cmd_start() ->
    hot_well_proc:get_server_pid() ! {open_hot_well, 1800}.
cmd_close() ->
    hot_well_proc:get_server_pid() ! end_hot_well,
    ok.


%%%===================================================================
%%% API
%%%===================================================================
get_server_pid() ->
    case get(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            case misc:whereis_name(local, ?MODULE) of
                Pid when is_pid(Pid) ->
                    put(?MODULE, Pid),
                    Pid;
                _ ->
                    undefined
            end
    end.

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link() ->
    {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
    ets:new(?ETS_HOT_WELL, [{keypos, #hot_well.pkey} | ?ETS_OPTIONS]),
    {ok, #hot_well_st{}}.

handle_call(Request, From, State) ->
    case catch hot_well_handle:handle_call(Request, From, State) of
        {reply, Res, NewState} ->
            {reply, Res, NewState};
        Reason ->
            ?ERR("hot_well_handle handle_call ~p~n", [Reason]),
            {noreply, State}
    end.

handle_cast(Request, State) ->
    case catch hot_well_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("hot_well_handle handle_cast ~p~n", [Reason]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch hot_well_handle:handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("hot_well_handle handle_info ~p~n", [Reason]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
