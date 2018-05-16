%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%            深渊魔宫
%%% @end
%%% Created : 20. 七月 2017 11:36
%%%-------------------------------------------------------------------
-module(cross_dark_bribe_proc).
-author("lzx").

%% API
-behaviour(gen_server).

-include("common.hrl").
-include("cross_dark_bribe.hrl").

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

-define(CROSS_DARK_BRIBE_PROC_SUP_PID, cross_dark_bribe_proc_sup_pid).
-define(CROSS_DARK_BRIBE_MIDNIGHT_REF, cross_dark_bribe_midnight_ref).


%% API
-export([
    start_link/0,
    get_server_pid/0
]).

%% 获取进程PID
get_server_pid() ->
    misc:get_server_pid(cross_area, ?CROSS_DARK_BRIBE_PROC_SUP_PID, ?MODULE).


start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).


init([]) ->
    process_flag(trap_exit, true),
    case config:is_center_node() of
        true ->
            Ref = erlang:send_after(30 * 1000, self(), timer_db),
            put(timer_db, Ref);
        false -> skip
    end,
    {ok, #cross_dark_bribe_state{open_state = 1}}.


handle_call(Request, From, State) ->
    case catch cross_dark_bribe_handle:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("cross dungeon handle_call ~p/~p~n", [Request, Reason]),
            {reply, error, State}
    end.


handle_cast(Request, State) ->
    case catch cross_dark_bribe_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross dungeon handle_cast ~p/ ~p~n", [Request, Reason]),
            {noreply, State}
    end.

handle_info(Request, State) ->
    case catch cross_dark_bribe_handle:handle_info(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross dungeon handle_info ~p/~p~n", [Request, Reason]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    F = fun(_Sn, ServerInfo) ->
        if ServerInfo#server_info.is_change == 1 ->
            cross_dark_bribe_init:db_update(ServerInfo),
            ServerInfo#server_info{is_change = 0};
            true -> ServerInfo
        end
        end,
    dict:map(F, _State#cross_dark_bribe_state.server_dict),
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================














