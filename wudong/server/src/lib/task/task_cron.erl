%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 一月 2016 10:18
%%%-------------------------------------------------------------------
-module(task_cron).
-author("hxming").

-include("common.hrl").
-include("task.hrl").

-behaviour(gen_server).

%% API
-export([start_link/0, set_accept/3, set_finish/3]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {
    task_cron = dict:new()
}).

-define(TIMER, 300).
%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

set_accept(TaskId, Name, Type) ->
    case lists:member(Type, [?TASK_TYPE_MAIN, ?TASK_TYPE_BRANCH]) of
        false -> skip;
        true ->
            ?CAST(?MODULE, {set_accept, TaskId, Name, Type})
    end.

set_finish(TaskId, Name, Type) ->
    case lists:member(Type, [?TASK_TYPE_MAIN, ?TASK_TYPE_BRANCH]) of
        false -> skip;
        true ->
            ?CAST(?MODULE, {set_finish, TaskId, Name, Type})
    end.

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init([]) ->
    erlang:send_after(1000, self(), {load}),
    {ok, #state{}}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast({set_accept, TaskId, Name, Type}, State) ->
    Dict =
        case dict:is_key(TaskId, State#state.task_cron) of
            false ->
                Record = #task_cron{task_id = TaskId, name = Name, type = Type, acc_accept = 1, is_change = 1},
                dict:store(TaskId, Record, State#state.task_cron);
            true ->
                Record = dict:fetch(TaskId, State#state.task_cron),
                NewRecord = Record#task_cron{task_id = TaskId, name = Name, type = Type, acc_accept = Record#task_cron.acc_accept + 1, is_change = 1},
                dict:store(TaskId, NewRecord, State#state.task_cron)
        end,
    {noreply, State#state{task_cron = Dict}};

handle_cast({set_finish, TaskId, Name, Type}, State) ->
    Dict =
        case dict:is_key(TaskId, State#state.task_cron) of
            false ->
                Record = #task_cron{task_id = TaskId, name = Name, type = Type, acc_finish = 1, is_change = 1},
                dict:store(TaskId, Record, State#state.task_cron);
            true ->
                Record = dict:fetch(TaskId, State#state.task_cron),
                NewRecord = Record#task_cron{task_id = TaskId, name = Name, type = Type, acc_finish = Record#task_cron.acc_finish + 1, is_change = 1},
                dict:store(TaskId, NewRecord, State#state.task_cron)
        end,
    {noreply, State#state{task_cron = Dict}};


handle_cast(_Request, State) ->
    {noreply, State}.

handle_info({load}, State) ->
    TaskCronDict =
        case task_load:load_task_cron() of
            [] ->
                dict:new();
            Data ->

                F = fun([TaskId, Name, Type, AccAccept, AccFinish], Dict) ->
                    Record = #task_cron{task_id = TaskId, name = Name, type = Type, acc_accept = AccAccept, acc_finish = AccFinish},
                    dict:store(TaskId, Record, Dict)
                    end,
                lists:foldl(F, dict:new(), Data)

        end,
    erlang:send_after(?TIMER * 1000, self(), {update}),
    {noreply, State#state{task_cron = TaskCronDict}};


handle_info({update}, State) ->
    erlang:send_after(?TIMER * 1000, self(), {update}),
    TaskCronDict = update(State#state.task_cron),
    {noreply, State#state{task_cron = TaskCronDict}};


handle_info(_Info, State) ->
    {noreply, State}.


terminate(_Reason, _State) ->
    update(_State#state.task_cron),
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
update(TaskCronDict) ->
    F = fun({TaskId, TaskCron}, Dict) ->
        if TaskCron#task_cron.is_change /= 0 ->
            task_load:replace_task_cron(TaskCron),
            dict:store(TaskId, TaskCron#task_cron{is_change = 0}, Dict);
            true ->
                dict:store(TaskId, TaskCron, Dict)
        end
        end,
    lists:foldl(F, dict:new(), dict:to_list(TaskCronDict)).
