%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 六月 2016 10:46
%%%-------------------------------------------------------------------
-module(cross_arena_proc).
-author("hxming").


%% API
-behaviour(gen_server).

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
    , get_server_pid/0
    , reward/0
    , get_score_reward_list/3
    , score_reward/4
    , arena_log/3
    , new_arena_data/1
    , arena_rank/4
]).

%%创建
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

reward() ->
    get_server_pid() ! {arena_daily_reward, util:unixtime()}.

%%积分奖励列表
get_score_reward_list(Node, Pkey, Sid) ->
    ?CAST(get_server_pid(), {get_score_reward_list, Node, Pkey, Sid}),
    ok.

%%领取积分奖励
score_reward(Node, Pkey, Pid, Score) ->
    ?CAST(get_server_pid(), {score_reward, Node, Pkey, Pid, Score}),
    ok.

arena_log(Node, Pkey, Sid) ->
    ?CAST(get_server_pid(), {arena_log, Node, Pkey, Sid}),
    ok.

%%排行榜
arena_rank(Node, Key, Sid, Page) ->
    ?CAST(get_server_pid(), {arena_rank, Node, Key, Sid, Page}),
    ok.


%%新的竞技场玩家数据
new_arena_data(Arena) ->
    ?CAST(get_server_pid(), {new_arena_data, Arena}).

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


init([]) ->
    process_flag(trap_exit, true),
    erlang:send_after(500, self(), load_cross_arena),
    {ok, ?MODULE}.



handle_call(Request, From, State) ->
    case catch cross_arena_handle:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("cross arena handle_call ~p/~p~n", [Request, Reason]),
            {reply, error, State}
    end.


handle_cast(Request, State) ->
    case catch cross_arena_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross arena handle_cast ~p/ ~p~n", [Request, Reason]),
            {noreply, State}
    end.

handle_info(Request, State) ->
    case catch cross_arena_handle:handle_info(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross arena handle_info ~p/~p~n", [Request, Reason]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
