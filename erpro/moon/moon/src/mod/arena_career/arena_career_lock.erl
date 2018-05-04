%% --------------------------------------------------------------------
%% 参赛者锁定，防止战斗中被其它人攻击
%% @author qingxuan
%% --------------------------------------------------------------------
-module(arena_career_lock).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-export([start_link/0]).
-export([
    lock/2
    ,unlock/2
    ,i/0
]).
-define(expire, 180).   %% 锁定超时为180秒
%% record
-record(state, {}).

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------
%% -> true | {false, From|Target}
lock(From, Target) ->
    case catch gen_server:call(?MODULE, {lock, From, Target}) of
        {'EXIT', _Reason} -> 
            ?ERR("~p", [_Reason]),
            {false, timeout};
        Ret -> Ret
    end.

%% -> any()
unlock(From, Target) ->
    gen_server:cast(?MODULE, {unlock, From, Target}).

i() ->
    process_info(whereis(?MODULE)).

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).


%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    {ok, #state{}}.

handle_call({lock, From, Target}, _From, State) ->
    Now = util:unixtime(),
    Reply = case {get(From), get(Target)} of
        {{_, Time}, _} when Time + ?expire > Now -> 
            {false, From};
        {_, {_, Time}} when Time + ?expire > Now -> 
            {false, Target};
        {_, _} -> 
            put(From, {Target, Now}),
            put(Target, {From, Now}),
            true
    end,
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast({unlock, From, Target}, State) ->
    case {get(From), get(Target)} of
        {{Target, _}, {From, _}} ->
            erase(Target),
            erase(From);
        _ -> 
            ignore
    end,
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ------------------------------------
%% 内部函数
%% ------------------------------------ 

