%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 十一月 2015 16:43
%%%-------------------------------------------------------------------
-module(arena_proc).
-author("hxming").


%% API
-behaviour(gen_server).

-include("arena.hrl").
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
-export([
    start_link/0
    , apply_call/3
    , apply_cast/3
    , apply_info/3
    , get_server_pid/0
    , reward/0
    , get_arena_for_rank/1
    , cmd_timer_update/0
    , career/2
    ,
    cmd_rank/2
]).

%%创建
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

apply_cast(Module, Function, Args) ->
    ?CAST(?MODULE, {apply, {Module, Function, Args}}).

apply_info(Module, Function, Args) ->
    ?MODULE ! {apply, {Module, Function, Args}}.

apply_call(Module, Function, Args) ->
    ?CALL(?MODULE, {apply, {Module, Function, Args}}).

reward() ->
    get_server_pid() ! {arena_daily_reward, util:unixtime()}.

%%修改职业
career(Pkey, Career) ->
    ?CAST(get_server_pid(), {career, Pkey, Career}),
    ok.


cmd_timer_update() ->
    get_server_pid() ! timer_update.


cmd_rank(Pkey, Rank) ->
    Rank1 = ?IF_ELSE(Rank > ?ROBOT_NUM, 0, Rank),
    get_server_pid() ! {cmd_rank, Pkey, Rank1}.


%%获取进程PID
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

get_arena_for_rank(Num) ->
    ?CALL(get_server_pid(), {get_arena_for_rank, Num}).

init([]) ->
    process_flag(trap_exit, true),
    arena_init:init(),
    Ref = erlang:send_after(300 * 1000, self(), timer_update),
    put(timer_update, Ref),
    {ok, ?MODULE}.



handle_call(Request, From, State) ->
    case catch arena_handle:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("arena handle_call ~p/~p~n", [Request, Reason]),
            {reply, error, State}
    end.


handle_cast(Request, State) ->
    case catch arena_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("arena handle_cast ~p/ ~p~n", [Request, Reason]),
            {noreply, State}
    end.

handle_info(Request, State) ->
    case catch arena_handle:handle_info(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("arena handle_info ~p/~p~n", [Request, Reason]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    arena_init:close_update(),
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
