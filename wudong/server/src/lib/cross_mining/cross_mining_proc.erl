%%%-------------------------------------------------------------------
%%% @author luobaqun
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 矿洞管理进程
%%% @end
%%% Created : 09. 四月 2018 上午10:24
%%%-------------------------------------------------------------------
-module(cross_mining_proc).
-author("luobaqun").
-include("cross_mining.hrl").
-include("server.hrl").
-include("common.hrl").


-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-export([
    get_server_pid/0
]).

-define(SERVER, ?MODULE).


%%%===================================================================
%%% API
%%%===================================================================

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
    case center:is_center_all() of
        true ->
            RankList0 = cross_mining_load:dbget_cross_mining_rank_list(),
            {RankList, PlayList} = cross_mining_util:init_rank_list(RankList0),
            MiningList = cross_mining_load:get_mining_list(),
            {MiningList1, MaxPage} = cross_mining_util:init_mining_list(MiningList),
            Nodes = ets:tab2list(?ETS_KF_NODES),
            AllActive = lists:sum([Node#ets_kf_nodes.cbp_len || Node <- Nodes, Node#ets_kf_nodes.type == ?CROSS_NODE_TYPE_NORMAL]),
            spawn(fun() -> ?CAST(cross_mining_proc:get_server_pid(), time_reset_mining) end);
        _ ->
            MiningList1 = [],
            RankList = [],
            PlayList = [],
            AllActive = 0,
            MaxPage = 0
    end,
    {ok, #st_cross_mining_manage{mining_list = MiningList1, active = AllActive, max_page = MaxPage, play_list = PlayList, rank_list = RankList}}.

handle_call(Request, From, State) ->
    case catch cross_mining_handle:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("cross_mining_handle handle_call ~p/~p~n", [Reason, Request]),
            {reply, error, State}
    end.


handle_cast(Request, State) ->
    case catch cross_mining_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross_mining_handle handle_cast ~p/~p~n", [Reason, Request]),
            {noreply, State}
    end.

handle_info(Request, State) ->
    case catch cross_mining_handle:handle_info(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross_mining_handle handle_info ~p/~p~n", [Reason, Request]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
