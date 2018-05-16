%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 二月 2017 15:00
%%%-------------------------------------------------------------------
-module(designation_proc).
-author("hxming").

%% API
-behaviour(gen_server).

-include("designation.hrl").
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
    , add_des/2
]).

%%添加称号
add_des(DesId, PkeyList) ->
    get_server_pid() ! {add_des, DesId, PkeyList}.

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


init([]) ->
    %%初始化全局称号
    erlang:send_after(1000, self(), init),
    Ref = erlang:send_after(?DES_TIMER * 1000, self(), timer),
    put(timer, Ref),
    {ok, ?MODULE}.



handle_call(Request, From, State) ->
    case catch designation_handle:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("designation handle_call ~p/~p~n", [Request, Reason]),
            {reply, error, State}
    end.


handle_cast(Request, State) ->
    case catch designation_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("designation handle_cast ~p/ ~p~n", [Request, Reason]),
            {noreply, State}
    end.

handle_info(Request, State) ->
    case catch designation_handle:handle_info(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("designation handle_info ~p/~p~n", [Request, Reason]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
