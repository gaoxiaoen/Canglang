%%----------------------------------------------------
%% 敏感词过滤服务
%% 
%% @author qingxuan
%%----------------------------------------------------
-module(forbid_name).
-behaviour(gen_server).
-export([
        start_link/1
        ,workers/0
]).
-export([
        check/1
]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-define(HEAP_SIZE, 200000).

-record(state, {
        unsched = []
        ,pids = [] %% 进程组[pid()]
}).

%% @spec check(binary())-> true | false
%% true = 有敏感词, false = 没有
check(String) ->
    gen_server:call({global, ?MODULE}, {check, String}).

workers() ->
    gen_server:call({global, ?MODULE}, get_pids).

start_link(N) ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [N], []).

init([N]) ->
    process_flag(trap_exit, true),
    Pids = start_psrs(N),
    {ok, #state{pids=Pids, unsched=Pids}}.

handle_call({check, String}, From, State) ->
    case State#state.unsched of
        [Pid] ->
            Pid ! {check, String, From},
            {noreply, State#state{unsched=State#state.pids}};
        [Pid|Pids] ->
            Pid ! {check, String, From},
            {noreply, State#state{unsched=Pids}};
        _ ->
            {reply, error, State}
    end;

handle_call(get_pids, _From, State) ->
    {reply, State#state.pids, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

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
    case gen_server:start_link(forbid_name_psr, [], [{spawn_opt, [{min_heap_size, ?HEAP_SIZE}]}]) of
        {ok, Pid} -> start_psrs(N-1, [ Pid | Pids ]);
        _Error ->
            ?ERR("error: ~p", [_Error]),
            start_psrs(N-1, Pids)
    end.
