%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 日志批量写入进程
%%% @end
%%% Created : 04. 一月 2015 下午4:27
%%%-------------------------------------------------------------------
-module(log_proc).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% ====================================================================
%% API functions
%% ====================================================================
-export([
    start_link/0,
    log/1,
    log_list/1
]).
-export([flush/0]).

-include("common.hrl").
-define(FLUSH_NUM, 100).
-define(FLUSH_TIME, 600000).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

log(SQL) ->
    case config:is_debug() of
        false ->
            ?CAST(?MODULE, {sql, SQL});
        true ->
            db:execute(SQL)
    end.

log_list(SQLList) ->
    case config:is_debug() of
        false ->
            ?CAST(?MODULE, {sql_list, SQLList});
        true ->
            [db:execute(SQL) || SQL <- SQLList]
    end.

flush() ->
    ?MODULE ! flush.
%% ====================================================================
%% Behavioural functions
%% ====================================================================
-record(state, {n = 0, queue = [], self = none}).

init([]) ->
    process_flag(trap_exit, true),
    Self = self(),
    erlang:send_after(?FLUSH_TIME, Self, timer),
    {ok, #state{self = Self}}.


%% handle_call/3
%% ====================================================================
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.


%% handle_cast/2
%% ====================================================================
handle_cast({sql, Sql}, State) ->
    N = State#state.n + 1,
    Queue = [Sql | State#state.queue],
    if
        N >= ?FLUSH_NUM ->
            handle_info(flush, State#state{n = N, queue = Queue});
        true ->
            {noreply, State#state{n = N, queue = Queue}}
    end;

handle_cast({sql_list, SqlList}, State) ->
    N = State#state.n + length(SqlList),
    Queue = State#state.queue ++ SqlList,
    if
        N >= ?FLUSH_NUM ->
            handle_info(flush, State#state{n = N, queue = Queue});
        true ->
            {noreply, State#state{n = N, queue = Queue}}
    end;

handle_cast(_Msg, State) ->
    {noreply, State}.


%% handle_info/2
%% ====================================================================
handle_info(timer, State) ->
    erlang:send_after(?FLUSH_TIME, State#state.self, timer),
    handle_info(flush, State);

handle_info(flush, State) ->
    SqlList = string:join(State#state.queue, ";"),
    ?DO_IF(SqlList /= [], catch db:execute(SqlList)),
    {noreply, State#state{n = 0, queue = []}};

handle_info(_Info, State) ->
    {noreply, State}.


%% terminate/2
terminate(_Reason, State) ->
    SqlList = string:join(State#state.queue, ";"),
    ?DO_IF(SqlList /= [], catch db:execute(SqlList)),
    ok.


%% code_change/3
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%% ====================================================================
%% Internal functions
%% ====================================================================

