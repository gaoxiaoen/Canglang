%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%     登陆排队队列
%%% @end
%%% Created : 24. 十一月 2017 10:35
%%%-------------------------------------------------------------------
-module(login_queue).
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
    ref = none,
    queue_list = [] %%[{acc_name,time}]
}).

-record(queue, {acc_name, time, socket}).

-define(SERVER, ?MODULE).

%% API
-export([
    start_link/0,
    get_server_pid/0
]).
-export([logout/1]).

-define(TIMER, 5000).

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

logout(AccName) ->
    get_server_pid() ! {logout, AccName}.

init([]) ->
    Ref = erlang:send_after(?TIMER, self(), timer),
    {ok, #state{ref = Ref}}.


handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Request, State) ->
    {noreply, State}.



handle_info({queue, AccName, Socket}, State) ->
    Queue = #queue{acc_name = AccName, socket = Socket, time = util:unixtime()},
    QueueList = [Queue | lists:keydelete(AccName, #queue.acc_name, State#state.queue_list)],
    {noreply, State#state{queue_list = QueueList}};

handle_info({logout, AccName}, State) ->
    QueueList = lists:keydelete(AccName, #queue.acc_name, State#state.queue_list),
    {noreply, State#state{queue_list = QueueList}};


handle_info(timer, State) ->
    util:cancel_ref([State#state.ref]),
    Ref = erlang:send_after(?TIMER, self(), timer),
    {noreply, State#state{ref = Ref}};

handle_info(_Request, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
