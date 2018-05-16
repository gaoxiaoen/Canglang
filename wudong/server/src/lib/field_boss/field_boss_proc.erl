%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 五月 2016 14:45
%%%-------------------------------------------------------------------
-module(field_boss_proc).
-author("hxming").
%% API
-behaviour(gen_server).

-include("field_boss.hrl").
-include("common.hrl").
-include("server.hrl").

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
    , cmd_refresh/0
    , rpc_get_week_rank/3
    , rpc_syc_node_rank/1
    , rpc_add_roll/4
    , rpc_start_roll/1
]).

%%创建
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).


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

cmd_refresh() ->
    get_server_pid() ! refresh_all,
    cross_area:apply(field_boss_proc, cmd_refresh, []),
    ok.

%%获取周排行榜
rpc_get_week_rank(Node, Sid, RankList) ->
    ?CAST(get_server_pid(), {get_week_rank, Node, Sid, RankList}),
    ok.

%%同步排名信息到中心服
rpc_syc_node_rank(FPointList) ->
    ?CAST(get_server_pid(), {sync_node_rank, FPointList}),
    ok.

%%创建roll
rpc_add_roll(Mkey, Mid, SceneId, Copy) ->
    ?CAST(get_server_pid(), {add_roll, Mkey, Mid, SceneId, Copy}),
    ok.

%%开始roll
rpc_start_roll(Mkey) ->
    ?CAST(get_server_pid(), {start_roll, Mkey}),
    ok.

init([]) ->
    process_flag(trap_exit,true),
    field_boss_init:init(),
    NextRefreshTime = field_boss:get_next_refresh_time(),
    Ref = erlang:send_after(NextRefreshTime*1000, self(), refresh_all),
    {ReadyTime, Time} =
        case NextRefreshTime > ?READY_TIME of
            true -> {(NextRefreshTime - ?READY_TIME), ?READY_TIME};
            false -> {1, NextRefreshTime}
        end,
    ReadyRef = erlang:send_after(ReadyTime*1000, self(), {ready_refresh, Time}),
    {ok, #st_field_boss{ref = Ref, ready_ref = ReadyRef}}.


handle_call(Request, From, State) ->
    case catch field_boss_handle:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("boss handle_call ~p~n", [Reason]),
            {reply, error, State}
    end.


handle_cast(Request, State) ->
    case catch field_boss_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("boss handle_cast ~p~n", [Reason]),
            {noreply, State}
    end.

handle_info(Request, State) ->
    case catch field_boss_handle:handle_info(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("boss handle_info ~p~n", [Reason]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ?DEBUG("field_boss_init logout", []),
    field_boss_init:log_out(),
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
