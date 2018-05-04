%%----------------------------------------------------
%% 敏感词过滤服务
%% 
%% @author qingxuan
%%----------------------------------------------------
-module(forbid_word_filter).
-behaviour(gen_server).
-export([
        start_link/1
        ,workers/0
]).
-export([
        filter/1
]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-define(HEAP_SIZE, 200000).

-record(state, {
        unsched = []
        ,pids = [] %% 进程组[pid()]
}).

filter(String) ->
    gen_server:call({global, ?MODULE}, {filter, String}).

workers() ->
    gen_server:call({global, ?MODULE}, get_pids).

start_link(N) ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [N], []).

init([N]) ->
    process_flag(trap_exit, true),
    Pids = start_psrs(N),
    {ok, #state{pids=Pids, unsched=Pids}}.

handle_call({filter, String}, From, State) ->
    case State#state.unsched of
        [Pid] ->
            Pid ! {filter, String, From},
            {noreply, State#state{unsched=State#state.pids}};
        [Pid|Pids] ->
            Pid ! {filter, String, From},
            {noreply, State#state{unsched=Pids}};
        _ ->
            {reply, error, State}
    end;

%handle_call(add, _From, State) ->
%    case gen_server:start_link(srv_text_filter_psr, [], []) of
%        {ok, Pid} ->
%            Pids = [ Pid | State#state.pids ],
%            {reply, {ok, Pid}, State#state{pids=Pids}};
%        Else ->
%            {reply, Else, State}
%    end;
%
%handle_call(remove, _From, State) ->
%    case State#state.pids of
%        [] ->
%            {reply, {error, 0}, State};
%        [_Pid] -> 
%            {reply, {error, 1}, State};
%        [Pid|Pids] ->
%            unlink(Pid),
%            Pid ! destroy,
%            {reply, {ok, length(Pids)}, State#state{pids=Pids}};
%        _ ->
%            {reply, {error, length(State#state.pids)}, State}
%    end;

handle_call(get_pids, _From, State) ->
    {reply, State#state.pids, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

%handle_info({call, Msg, From}, State) ->
%    case State#state.pids of
%        [Pid|_] ->
%            Pid ! {call, Msg, From};
%        _ ->
%            ignore
%    end,
%    {noreply, State};

handle_info({'EXIT', Pid, _Why}, State) ->
    case State#state.pids of
        [_|_] ->
            Pids = lists:delete(Pid, State#state.pids),
            Unsched = lists:delete(Pid, State#state.unsched),
            {noreply, State#state{pids=Pids, unsched=Unsched}};
        _ ->
            {noreply, State}
    end;

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%% -------------------------------
start_psrs(0) ->
    [];
start_psrs(N) ->
    start_psrs(N, []).

start_psrs(0, Pids) ->
    Pids;
start_psrs(N, Pids) ->
    case gen_server:start_link(forbid_word_filter_psr, [], [{spawn_opt, [{min_heap_size, ?HEAP_SIZE}]}]) of
        {ok, Pid} -> start_psrs(N-1, [ Pid | Pids ]);
        _Error ->
            ?ERR("error : ~p", [_Error]),
            start_psrs(N-1, Pids)
    end.
