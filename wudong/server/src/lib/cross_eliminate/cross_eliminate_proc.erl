%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc 消消乐服务
%%%
%%% @end
%%% Created : 22. 六月 2016 10:32
%%%-------------------------------------------------------------------
-module(cross_eliminate_proc).
-author("hxming").


%% API
-behaviour(gen_server).

-include("cross_eliminate.hrl").
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
    , week_reward/0
    , cmd_refresh/0
]).

%%创建
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

week_reward() ->
    get_server_pid() ! week_reward.

cmd_refresh() ->
    get_server_pid() ! refresh_rank.

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
    LogList = cross_eliminate_load:init(),
    RankList = cross_eliminate_load:rank_list(LogList),
    RewardList = cross_eliminate_load:load_reward(),
    Ref = erlang:send_after(?CROSS_ELIMINATE_MATCH_TIMEOUT * 1000, self(), check_timeout),
    {ok, #st_eliminate{log_list = LogList, rank_list = RankList, reward_list = RewardList, ref = Ref}}.



handle_call(Request, From, State) ->
    case catch cross_eliminate_handle:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("cross eliminate handle_call ~p/~p~n", [Request, Reason]),
            {reply, error, State}
    end.


handle_cast(Request, State) ->
    case catch cross_eliminate_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross eliminate handle_cast ~p/ ~p~n", [Request, Reason]),
            {noreply, State}
    end.

handle_info(Request, State) ->
    case catch cross_eliminate_handle:handle_info(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross eliminate handle_info ~p/~p~n", [Request, Reason]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
