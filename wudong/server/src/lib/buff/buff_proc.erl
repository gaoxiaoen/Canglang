%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 三月 2017 10:25
%%%-------------------------------------------------------------------
-module(buff_proc).

-author("hxming").
%% API
-behaviour(gen_server).

-include("task.hrl").
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

-record(state, {
    log_list = []
}).
-define(SERVER, ?MODULE).

%% API
-export([
    start_link/0,
    set_buff/4,
    set_buff/3,
    del_buff/3,
    del_buff/2,
    reset_buff/3,
    reset_buff/2,
    logout/1,
    get_server_pid/0
]).

-define(MAKE_KEY(Pid, BuffId), {Pid, BuffId}).

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

set_buff(Node, Pid, BuffId, Time) ->
    if Node == none orelse Node == node() ->
        set_buff(Pid, BuffId, Time);
        true ->
            center:apply(Node, buff_proc, set_buff, [Pid, BuffId, Time])
    end.

set_buff(Pid, BuffId, Time) ->
    get_server_pid() ! {set, Pid, BuffId, Time}.

del_buff(Node, Pid, BuffId) ->
    if Node == none orelse Node == node() ->
        del_buff(Pid, BuffId);
        true ->
            center:apply(Node, buff_proc, del_buff, [Pid, BuffId])
    end.
del_buff(Pid, BuffId) ->
    get_server_pid() ! {del, Pid, BuffId},
    ok.


reset_buff(Node, Pid, BuffId) ->
    if Node == none orelse Node == node() ->
        reset_buff(Pid, BuffId);
        true ->
            center:apply(Node, buff_proc, reset_buff, [Pid, BuffId])
    end.
reset_buff(Pid, BuffId) ->
    get_server_pid() ! {reset, Pid, BuffId},
    ok.


logout(Pid) ->
    get_server_pid() ! {logout, Pid}.


init([]) ->
    {ok, #state{}}.


handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info({set, Pid, BuffId, Time}, State) ->
    Ref = erlang:send_after(round(Time * 1000), self(), {reset, Pid, BuffId}),
    LogList =
        case lists:keytake(Pid, 1, State#state.log_list) of
            false ->
                [{Pid, [{BuffId, Ref}]} | State#state.log_list];
            {value, {_, BuffList}, T} ->
                case lists:keytake(BuffId, 1, BuffList) of
                    false ->
                        [{Pid, [{BuffId, Ref} | BuffList]} | T];
                    {value, {_BuffId, OldRef}, L} ->
                        util:cancel_ref([OldRef]),
                        [{Pid, [{BuffId, Ref} | L]} | T]
                end
        end,

%%     ?DEBUG("set log list ~p~n", [LogList]),
%%    misc:cancel_timer({Pid, BuffId}),
%%    Ref = erlang:send_after(round(Time * 1000), self(), {reset, Pid, BuffId}),
%%    put({Pid, BuffId}, Ref),
    {noreply, State#state{log_list = LogList}};

handle_info({reset, Pid, BuffId}, State) ->
    LogList =
        case lists:keytake(Pid, 1, State#state.log_list) of
            false ->
                State#state.log_list;
            {value, {_, BuffList}, T} ->
                case lists:keytake(BuffId, 1, BuffList) of
                    false ->
                        State#state.log_list;
                    {value, {_BuffId, Ref}, L} ->
                        util:cancel_ref([Ref]),
                        Pid ! {buff_timeout, BuffId},
                        case L of
                            [] -> T;
                            _ ->
                                [{Pid, L} | T]
                        end
                end
        end,

%%     ?DEBUG("reset log list ~p~n", [LogList]),
%%    misc:cancel_timer({Pid, BuffId}),
%%    case misc:is_process_alive(Pid) of
%%        false -> ok;
%%        true ->
%%            Pid ! {buff_timeout, BuffId}
%%    end,
%%    erlang:erase({Pid, BuffId}),
    {noreply, State#state{log_list = LogList}};

handle_info({del, Pid, BuffId}, State) ->
    LogList =
        case lists:keytake(Pid, 1, State#state.log_list) of
            false ->
                State#state.log_list;
            {value, {_, BuffList}, T} ->
                case lists:keytake(BuffId, 1, BuffList) of
                    false ->
                        State#state.log_list;
                    {value, {_BuffId, OldRef}, L} ->
                        util:cancel_ref([OldRef]),
                        case L of
                            [] -> T;
                            _ ->
                                [{Pid, L} | T]
                        end
                end
        end,
%%     ?DEBUG("del log list ~p~n", [LogList]),
%%    misc:cancel_timer({Pid, BuffId}),
%%    erlang:erase({Pid, BuffId}),
    {noreply, State#state{log_list = LogList}};



handle_info({logout, Pid}, State) ->
    LogList =
        case lists:keytake(Pid, 1, State#state.log_list) of
            false ->
                State#state.log_list;
            {value, {_, BuffList}, T} ->
                RefList = [Ref || {_, Ref} <- BuffList],
                util:cancel_ref(RefList),
                T
        end,
%%     ?DEBUG("logout log list ~p~n", [LogList]),
%%    misc:cancel_timer({Pid, BuffId}),
%%    erlang:erase({Pid, BuffId}),
    {noreply, State#state{log_list = LogList}};

handle_info(_Request, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
