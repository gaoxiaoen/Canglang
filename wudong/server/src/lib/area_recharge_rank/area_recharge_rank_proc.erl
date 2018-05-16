%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2017 14:49
%%%-------------------------------------------------------------------
-module(area_recharge_rank_proc).
-author("Administrator").

%% API
-behaviour(gen_server).

-include("common.hrl").
-include("activity.hrl").
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
    , end_reward/1
    , cmd_refresh/0
    , cmd_refresh_nodb/0
    ,test/0
]).

%%创建
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

end_reward(Base) ->
    ?DEBUG("base ~p~n",[Base]),
    get_server_pid() ! {end_reward,Base}.

test() ->
    get_server_pid() ! test.

cmd_refresh() ->
    get_server_pid() ! refresh_rank.

cmd_refresh_nodb() ->
    get_server_pid() ! refresh_rank_nodb.

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
    %% 跨服充值初始化分区
%%     activity_area_group:init_area_group(data_area_recharge_rank,area_recharge_rank),
%%     erlang:send_after(1000, self(), refresh_rank),
    {ok, #st_area_recharge_rank{}}.

handle_call(Request, From, State) ->
    case catch area_recharge_rank_handle:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("area_recharge_rank_handle handle_call ~p/~p~n", [Request, Reason]),
            {reply, error, State}
    end.

handle_cast(Request, State) ->
    %%?DEBUG("hand_cast ~n"),
    case catch area_recharge_rank_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("area_recharge_rank_handle handle_cast ~p/ ~p~n", [Request, Reason]),
            {noreply, State}
    end.

handle_info(Request, State) ->
    case catch area_recharge_rank_handle:handle_info(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("area_recharge_rank_handle handle_info ~p/~p~n", [Request, Reason]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
%%%===================================================================
%%% Internal functions
%%%===================================================================
