%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 排行榜
%%% @end
%%% Created : 05. 二月 2015 下午3:40
%%%-------------------------------------------------------------------
-module(rank_proc).
-author("fancy").

-behaviour(gen_server).

%% API
-export([start_link/0]).
-include("common.hrl").
-include("rank.hrl").
-include("goods.hrl").
-include("arena.hrl").


%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).


-export([
    rpc_reload_rank/0
]).

-export([get_rank_pid/0
]).

-define(SERVER, ?MODULE).

-define(TIMER_REFRESH, 3600000). %%1小时更新

%%%===================================================================
%%% API
%%%===================================================================
get_rank_pid() ->
    case get(?PROC_GLOBAL_RANK) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            case misc:whereis_name(local, ?MODULE) of
                Pid when is_pid(Pid) ->
                    put(?PROC_GLOBAL_RANK, Pid),
                    Pid;
                _ ->
                    undefined
            end
    end.

rpc_reload_rank() ->
    Pid = get_rank_pid(),
    Pid ! {refresh_rank}.

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init([]) ->
    process_flag(trap_exit, true),
    ets:new(?ETS_RANK, [{keypos, #a_rank.key} | ?ETS_OPTIONS]),
    ets:new(?ETS_RANK_WORSHIP, [{keypos, #rank_wp.pkey} | ?ETS_OPTIONS]),
    Ref = erlang:send_after(1000, self(), {refresh_rank}),
    Ref1 = erlang:send_after(?TIMER_UPDATE_DB*1000, self(), {timer_update}),
    self() ! {init},
    self() ! {clear_dict},
    {ok, #rank_st{refresh_ref = Ref, timer_update_ref = Ref1}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @end
%%--------------------------------------------------------------------
handle_call(Request, From, State) ->
    case catch rank_handle:handle_call(Request, From, State) of
        {reply,Reply,NewState}->
            {reply,Reply,NewState};
        Reason ->
            ?ERR("rank_handle handle_call ~p~n",[Reason]),
            {reply,error,State}
    end.

handle_cast(Request, State) ->
    case catch rank_handle:handle_cast(Request,State) of
        {noreply, NewState} ->
            {noreply,NewState};
        Reason ->
            ?ERR("rank_handle handle_cast ~p~n",[Reason]),
            {noreply,State}
    end.

handle_info(Info, State) ->
    case catch rank_handle:handle_info(Info,State) of
        {noreply, NewState} ->
            {noreply,NewState};
        Reason ->
            ?ERR("rank_handle handle_info ~p~n",[Reason]),
            {noreply,State}
    end.

terminate(_Reason, _State) ->
    rank_handle:rank_timer_update(),
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================




