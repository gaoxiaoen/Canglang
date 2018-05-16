%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 二月 2017 下午8:08
%%%-------------------------------------------------------------------
-module(answer_proc).
-author("fengzhenlin").
-include("answer.hrl").
-include("common.hrl").

-behaviour(gen_server).

%% API
-export([start_link/0,
    get_server_pid/0,
    rpc_ready_open/1,  %%即将开启
    rpc_open_answer/1   %%开启答题
]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API
%%%===================================================================
get_server_pid() ->
    case get(answer_pid) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            case misc:whereis_name(local,?MODULE) of
                Pid when is_pid(Pid) ->
                    put(answer_pid,Pid),
                    Pid;
                _ ->
                    undefined
            end
    end.

rpc_ready_open(OpenTime) ->
    Pid = get_server_pid(),
    Pid ! {ready_open, OpenTime},
    ok.

rpc_open_answer(LongTime) ->
    Pid = get_server_pid(),
    Pid ! {open_answer, LongTime},
    ok.

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    {ok, #answer_st{}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @end
%%--------------------------------------------------------------------
handle_call(Request, From, State) ->
    case catch answer_handle:handle_call(Request, From, State) of
        {reply,Reply,NewState}->
            {reply,Reply,NewState};
        Reason ->
            ?ERR("answer_handle handle_call ~p~n",[Reason]),
            {reply,error,State}
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @end
%%--------------------------------------------------------------------
handle_cast(Request, State) ->
    case catch answer_handle:handle_cast(Request,State) of
        {noreply, NewState} ->
            {noreply,NewState};
        Reason ->
            ?ERR("answer_handle handle_cast ~p~n",[Reason]),
            {noreply,State}
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_info(Info, State) ->
    case catch answer_handle:handle_info(Info,State) of
        {noreply, NewState} ->
            {noreply,NewState};
        Reason ->
            ?ERR("answer_handle handle_info ~p~n",[Reason]),
            {noreply,State}
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
